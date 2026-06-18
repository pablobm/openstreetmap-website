$(function () {
  const selectPageCheckbox = $("#select_page");
  const individualCheckboxes = $(".notification-mark-read");

  function updateCheckboxToSelectAll() {
    const checkedStatuses = individualCheckboxes.get().map(el => el.checked)
    const uniqueCheckedStatuses = [...new Set(checkedStatuses)];
    if (uniqueCheckedStatuses.length === 1) {
      selectPageCheckbox.prop("indeterminate", false);
      selectPageCheckbox.prop("checked", allChecked);
    } else {
      selectPageCheckbox.prop("indeterminate", true);
    }
  }

  selectPageCheckbox.on("click", function(evt) {
    individualCheckboxes.prop("checked", evt.target.checked);
  });

  individualCheckboxes.on("click", function () {
    updateCheckboxToSelectAll();
  });

  updateCheckboxToSelectAll();
});
