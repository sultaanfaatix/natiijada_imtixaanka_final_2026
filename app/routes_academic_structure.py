from flask import Blueprint, flash, redirect, render_template, request, url_for
from flask_login import login_required

from . import db
from .audit import audit
from .models import AcademicLevel, AcademicClass, AcademicSection
from .permissions import can
from sqlalchemy import func

academic_bp = Blueprint("academic_structure", __name__)


@academic_bp.before_request
@login_required
def require_login():
    if not can("manage_academic_structure"):
        flash("You don't have permission to manage system setup.", "danger")
        return redirect(url_for("admin.dashboard"))


@academic_bp.route("/academic-structure")
def index():
    """Main academic structure management page"""
    levels = AcademicLevel.query.order_by(AcademicLevel.sort_order).all()
    return render_template("academic_structure/index.html", levels=levels)


# Academic Level Management
@academic_bp.route("/academic-levels")
def academic_levels():
    """List all academic levels"""
    levels = AcademicLevel.query.order_by(AcademicLevel.sort_order).all()
    return render_template("academic_structure/levels.html", levels=levels)


@academic_bp.route("/academic-levels/new", methods=["GET", "POST"])
@academic_bp.route("/academic-levels/<int:level_id>/edit", methods=["GET", "POST"])
def academic_level_form(level_id=None):
    """Create or edit academic level"""
    level = db.session.get(AcademicLevel, level_id) if level_id else AcademicLevel()
    
    if request.method == "POST":
        level.name = request.form["name"].strip()
        level.sort_order = int(request.form.get("sort_order", 0))
        level.is_active = bool(request.form.get("is_active"))
        
        db.session.add(level)
        audit("System Setup", f"Saved academic level: {level.name}")
        db.session.commit()
        flash("Academic level saved successfully.", "success")
        return redirect(url_for("academic_structure.academic_levels"))
    
    return render_template("academic_structure/level_form.html", level=level)


@academic_bp.route("/academic-levels/<int:level_id>/delete", methods=["POST"])
def delete_academic_level(level_id):
    """Delete academic level"""
    level = db.session.get(AcademicLevel, level_id)
    if not level:
        flash("Academic level not found.", "danger")
        return redirect(url_for("academic_structure.academic_levels"))
    
    # Check if level has classes
    if level.classes.count() > 0:
        flash("Cannot delete academic level with existing classes.", "danger")
        return redirect(url_for("academic_structure.academic_levels"))
    
    db.session.delete(level)
    audit("System Setup", f"Deleted academic level: {level.name}")
    db.session.commit()
    flash("Academic level deleted.", "success")
    return redirect(url_for("academic_structure.academic_levels"))


# Academic Class Management
@academic_bp.route("/academic-classes")
def academic_classes():
    """List all academic classes"""
    classes = AcademicClass.query.join(AcademicLevel).order_by(
        AcademicLevel.sort_order, AcademicClass.sort_order
    ).all()
    return render_template("academic_structure/classes.html", classes=classes)


@academic_bp.route("/academic-classes/new", methods=["GET", "POST"])
@academic_bp.route("/academic-classes/<int:class_id>/edit", methods=["GET", "POST"])
def academic_class_form(class_id=None):
    """Create or edit academic class"""
    cls = db.session.get(AcademicClass, class_id) if class_id else AcademicClass()
    
    if request.method == "POST":
        cls.academic_level_id = int(request.form["academic_level_id"])
        cls.name = request.form["name"].strip()
        cls.sort_order = int(request.form.get("sort_order", 0))
        cls.is_active = bool(request.form.get("is_active"))
        
        db.session.add(cls)
        audit("System Setup", f"Saved academic class: {cls.name}")
        db.session.commit()
        flash("Academic class saved successfully.", "success")
        return redirect(url_for("academic_structure.academic_classes"))
    
    levels = AcademicLevel.query.filter_by(is_active=True).order_by(AcademicLevel.sort_order).all()
    return render_template("academic_structure/class_form.html", cls=cls, levels=levels)


@academic_bp.route("/academic-classes/<int:class_id>/delete", methods=["POST"])
def delete_academic_class(class_id):
    """Delete academic class"""
    cls = db.session.get(AcademicClass, class_id)
    if not cls:
        flash("Academic class not found.", "danger")
        return redirect(url_for("admin_advanced_results.new_setup"))
    
    # Check if class has sections
    if cls.sections.count() > 0:
        flash("Cannot delete academic class with existing sections.", "danger")
        return redirect(url_for("admin_advanced_results.new_setup"))
    
    db.session.delete(cls)
    audit("System Setup", f"Deleted academic class: {cls.name}")
    db.session.commit()
    flash("Academic class deleted.", "success")
    return redirect(url_for("admin_advanced_results.new_setup"))


@academic_bp.route("/academic-classes/add", methods=["POST"])
def add_class():
    """Quick add class from Setup page"""
    academic_level_id = int(request.form.get("academic_level_id"))
    name = request.form.get("name", "").strip()
    
    if not name:
        flash("Class name is required.", "danger")
        return redirect(url_for("admin_advanced_results.new_setup"))
    
    level = db.session.get(AcademicLevel, academic_level_id)
    if not level:
        flash("Academic level not found.", "danger")
        return redirect(url_for("admin_advanced_results.new_setup"))
    
    # Get max sort_order for this level
    max_order = db.session.query(db.func.max(AcademicClass.sort_order)).filter_by(
        academic_level_id=academic_level_id
    ).scalar() or 0
    
    cls = AcademicClass(
        academic_level_id=academic_level_id,
        name=name,
        sort_order=max_order + 1,
        is_active=True
    )
    
    db.session.add(cls)
    audit("System Setup", f"Added academic class: {cls.name}")
    db.session.commit()
    flash("Class added successfully.", "success")
    return redirect(url_for("admin_advanced_results.new_setup"))


# Academic Section Management
@academic_bp.route("/academic-sections")
def academic_sections():
    """List all academic sections"""
    sections = AcademicSection.query.join(AcademicClass).join(AcademicLevel).order_by(
        AcademicLevel.sort_order, AcademicClass.sort_order, AcademicSection.sort_order
    ).all()
    return render_template("academic_structure/sections.html", sections=sections)


@academic_bp.route("/academic-sections/new", methods=["GET", "POST"])
@academic_bp.route("/academic-sections/<int:section_id>/edit", methods=["GET", "POST"])
def academic_section_form(section_id=None):
    """Create or edit academic section"""
    section = db.session.get(AcademicSection, section_id) if section_id else AcademicSection()
    
    if request.method == "POST":
        section.academic_class_id = int(request.form["academic_class_id"])
        section.name = request.form["name"].strip()
        section.sort_order = int(request.form.get("sort_order", 0))
        section.is_active = bool(request.form.get("is_active"))
        
        db.session.add(section)
        audit("System Setup", f"Saved academic section: {section.name}")
        db.session.commit()
        flash("Academic section saved successfully.", "success")
        return redirect(url_for("academic_structure.academic_sections"))
    
    classes = AcademicClass.query.filter_by(is_active=True).join(AcademicLevel).filter(
        AcademicLevel.is_active == True
    ).order_by(AcademicLevel.sort_order, AcademicClass.sort_order).all()
    return render_template("academic_structure/section_form.html", section=section, classes=classes)


@academic_bp.route("/academic-sections/<int:section_id>/delete", methods=["POST"])
def delete_academic_section(section_id):
    """Delete academic section"""
    section = db.session.get(AcademicSection, section_id)
    if not section:
        flash("Academic section not found.", "danger")
        return redirect(url_for("academic_structure.academic_sections"))
    
    # Check if section has students
    from .models import Student
    if Student.query.filter_by(academic_section_id=section_id).count() > 0:
        flash("Cannot delete academic section with existing students.", "danger")
        return redirect(url_for("academic_structure.academic_sections"))
    
    db.session.delete(section)
    audit("System Setup", f"Deleted academic section: {section.name}")
    db.session.commit()
    flash("Academic section deleted.", "success")
    return redirect(url_for("academic_structure.academic_sections"))
