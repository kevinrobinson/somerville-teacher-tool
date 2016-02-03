module SerializeDataHelper

  def serialize_intervention(intervention)
    {
      id: intervention.id,
      name: intervention.name,
      comment: intervention.comment,
      goal: intervention.goal,
      start_date: intervention.start_date.strftime('%B %e, %Y'),
      end_date: intervention.end_date.try(:strftime, '%B %e, %Y'),
      educator_email: intervention.educator.try(:email),
      progress_notes: intervention.progress_notes.order(created_at: :asc).map do |progress_note|
        serialize_progress_note(progress_note)
      end
    }
  end

  def serialize_progress_note(progress_note)
    {
      id: progress_note.id,
      educator_email: progress_note.educator.email,
      content: progress_note.content,
      created_date: progress_note.created_at.strftime("%B %e, %Y %l:%M %p")
    }
  end

  def serialize_student_note(student_note)
    {
      id: student_note.id,
      content: student_note.content,
      educator_email: student_note.educator.email,
      created_at_timestamp: student_note.created_at,
      created_at: student_note.created_at.strftime('%B %e, %Y')
    }
  end

  # Used to send down all intervention types, for lookups from student records
  def intervention_types_index
    index = {}
    InterventionType.all.each do |intervention_type|
      index[intervention_type.id] = intervention_type;
    end
    index
  end
end
