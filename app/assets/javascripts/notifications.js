$(function () {
  const selectPageCheckbox = $("#select_page");
  const individualCheckboxes = $(".notification-mark-read");

  individualCheckboxes.on("click", function () {
    if (isPageSelected()) {
      toPageSelected();
    } else {
      toNoneOrSomeSelected();
    }
  });

  selectPageCheckbox.on("click", function () {
    if (isPageSelected()) {
      uncheckEachIndividualCheckbox();
      toNoneOrSomeSelected();
    } else {
      checkEachIndividualCheckbox();
      toPageSelected();
    }
  });

  function toNoneOrSomeSelected() {
    uncheckSelectPage();
  }

  function toPageSelected() {
    checkEachIndividualCheckbox();
    checkSelectPage();
  }

  function isPageSelected() {
    return individualCheckboxes.get().every(el => el.checked);
  }

  function checkEachIndividualCheckbox() {
    individualCheckboxes.prop("checked", true);
  }

  function uncheckEachIndividualCheckbox() {
    individualCheckboxes.prop("checked", false);
  }

  function checkSelectPage() {
    selectPageCheckbox.prop("checked", true);
  }

  function uncheckSelectPage() {
    selectPageCheckbox.prop("checked", false);
  }
});
