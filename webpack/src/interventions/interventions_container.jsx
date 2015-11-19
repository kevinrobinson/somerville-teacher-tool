import React from 'react';
var jQueryUIWrapper = require('./jquery-ui-wrapper.jsx');

export default class InterventionsContainer extends React.Component {
  constructor() {
    super()
    this.state = {
      editingIntervention: null,
      interventions: null
    };
  }

  // TODO(kr)
  // onInterventionSelected
  // onAddIntervention
  // onCancelNewIntervention
  // onAddProgressNote

  // TODO(kr) css bug here
  render() {
    return <div>
      {this.renderLeftPanel()}
      {this.renderRightPanel()}
    </div>;
  }

  renderLeftPanel() {
    return <div className="left-panel">
      <div id="open-intervention-form">
        <h1>
          <span id="add-intervention-plus-sign">
            +
          </span>
          <span id="add-intervention-text">
            Add intervention
          </span>
        </h1>
      </div>
      <div id="intervention-cell-list">
        TODO(kr)
      </div>
    </div>;
  }

  renderInterventionTypeSelector() {
    return 'INTERVENTION TYPE SELECTOR';
    // <select id={intervention_type_id,
    //             options_from_collection_for_select(InterventionType.all, :id, :name),
    //             { include_blank: " -- Intervention type -- " },
    //             { required: true }) %>
  }

  renderRightPanel() {
    return <div className="right-panel">
      <div id="intervention-detail-list">
        {!this.state.interventions || this.state.interventions.length === 0
          ? <div>No interventions</div>
          : this.state.interventions.map(this.renderInterventionDetails)}
        <form>
          <h1>Add Intervention</h1>
          <p className="alert field errors"></p>
          <label>Select Intervention</label>
          {this.renderInterventionTypeSelector}
          <label>Comment</label>
          <textarea id="comment" placeholder="Add comment" cols="40" rows="5" />
          <label>Goal</label>
          <textarea id="goal" placeholder="Add goal" cols="40" rows="5" />
          <label>End date</label>
          <jQueryUIWrapper.DatePicker />
          <br/><br/>
          
          <button id="close-intervention-form" className="btn cancel-btn" type="button">Cancel</button>
        </form>
      </div>
    </div>
  }


          // <input type="text" <%= i.text_field :end_date class: "datepicker" placeholder: "yyyy-mm-dd",
          //     pattern: "(19|20)[0-9]{2}(\/|-|.)((0[1-9])|(1[0-2])|([0-9]))(\/|-|.)(([0-2][0-9])|(3[0-1])|([0-9]))"
          //     # Accepts any of the following formats: 2014-02-02 2014/02/02 2014/2/2 2014.2.2 ...
          // %>

          // <%= i.hidden_field :educator_id value: current_educator.id %>
          // <%= i.hidden_field :student_id value: @student.id %>
          // <%= i.submit "Save" class: "btn save-btn" %>

  renderInterventionDetails() {
    return 'INTERVENTION DETAILS';
        //       <% if @interventions.present? %>
        //     <% @interventions.all.each do |i| %>

        //       <!-- INTERVENTION DETAILS -->

        //       <div className="intervention-detail" data-id="<%= i.id %>">
        //         <h2><%= i.intervention_type.name %></h2>
        //         <strong>Description</strong>
        //         <p><%= i.comment %></p>
        //         <strong>Goal</strong>
        //         <p><%= i.goal %></p>
        //         <strong>Start Date</strong>
        //         <p><%= i.start_date.strftime("%B %e %Y") %></p>
        //         <% if i.end_date.present? %>
        //           <strong>End Date</strong>
        //           <p><%= i.end_date.strftime("%B %e, %Y") %></p>
        //         <% end %>
        //         <% if i.progress_notes.present? %>
        //           <h2>Progress notes</h2>
        //           <div className="progress-note-list">
        //             <% i.progress_notes.each do |p| %>
        //               <div className="progress-note">
        //                 <strong>
        //                   <%= p.educator.email %>
        //                 </strong>
        //                 <p>
        //                   <%= p.content %>
        //                   <br/>
        //                   <span className="smalltype">
        //                     <%= p.created_at.strftime("%B %e, %Y %l:%M %p") %>
        //                   </span>
        //                 </p>
        //               </div>
        //             <% end %>
        //           </div>
        //         <% else %>
        //           <div className="progress-note-list"></div>
        //         <% end %>

        //         <!-- PROGRESS NOTES ON INTERVENTION -->

        //         <button className="btn add-progress-note" type="button">
        //           Add progress note
        //         </button>

        //         <div className="add-progress-note-area">
        //           <h2>Add progress note</h2>
        //           <p className="alert field errors"></p>
        //           <%= form_for @progress_note, remote: true do |p| %>
        //             <label>Progress note</label>
        //             <%= p.text_area :content, cols: "40", rows: "5", required: true %>
        //             <%= p.select(:educator_id,
        //                   options_from_collection_for_select(Educator.all, :id, :email),
        //                   { include_blank: " -- Select educator -- " },
        //                   { required: true }) %>
        //             <br/>
        //             <%= p.hidden_field :intervention_id, value: i.id %>
        //             <%= p.submit "Save", class: "btn save-btn" %>
        //             <div className="btn cancel-progress-note" type="button">Cancel</div>
        //           <% end %>
        //         </div>
        //       </div>
        //     <% end %>
        //   </div>
        // <% end %>
  }
}

// getInitialState
// onInterventionSelected
// onAddIntervention
// onCancelNewIntervention
// onAddProgressNote
