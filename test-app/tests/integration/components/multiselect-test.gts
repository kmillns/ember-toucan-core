import {
  click,
  fillIn,
  render,
  setupOnerror,
  triggerKeyEvent,
} from '@ember/test-helpers';
import { module, test } from 'qunit';

import Multiselect from '@crowdstrike/ember-toucan-core/components/form/controls/multiselect';
import { setupRenderingTest } from 'test-app/tests/helpers';

let testColors = ['blue', 'red'];

module('Integration | Component | Multiselect', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect]').hasTagName('input');
    assert
      .dom('[data-multiselect-container]')
      .hasClass('text-titles-and-attributes');
    assert
      .dom('[data-multiselect-container]')
      .hasClass('shadow-focusable-outline');
    assert
      .dom('[data-multiselect-container]')
      .doesNotHaveClass('text-disabled');
    assert
      .dom('[data-multiselect-container]')
      .doesNotHaveClass('shadow-error-outline');
    assert
      .dom('[data-multiselect-container]')
      .doesNotHaveClass('focus-within:shadow-error-focus-outline');

    assert.dom('[data-multiselect]').hasAttribute('aria-autocomplete', 'list');
    assert.dom('[data-multiselect]').hasAttribute('aria-haspopup', 'listbox');
    assert.dom('[data-multiselect]').hasAttribute('autocapitalize', 'none');
    assert.dom('[data-multiselect]').hasAttribute('autocomplete', 'off');
    assert.dom('[data-multiselect]').hasAttribute('autocorrect', 'off');
    assert.dom('[data-multiselect]').hasAttribute('role', 'combobox');
    assert.dom('[data-multiselect]').hasAttribute('spellcheck', 'false');
    assert.dom('[data-multiselect]').hasAttribute('type', 'text');
  });

  test('it disables the component using `@isDisabled`', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        @isDisabled={{true}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect]').isDisabled();
    assert.dom('[data-multiselect]').hasClass('text-disabled');
    assert
      .dom('[data-multiselect]')
      .doesNotHaveClass('text-titles-and-attributes');
  });

  test('it sets readonly on the input using `@isReadOnly`', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        @isReadOnly={{true}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect]').hasAttribute('readonly');

    assert
      .dom('[data-multiselect-container]')
      .hasClass('shadow-read-only-outline');
    assert.dom('[data-multiselect-container]').hasClass('bg-surface-xl');
    assert.dom('[data-multiselect]').hasNoClass('bg-overlay-1');
    assert.dom('[data-multiselect]').hasNoClass('text-disabled');
    assert.dom('[data-multiselect]').hasNoClass('shadow-error-outline');
    assert.dom('[data-multiselect]').hasNoClass('shadow-focusable-outline');
  });

  test('it spreads attributes to the underlying input', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        placeholder="Placeholder text"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert
      .dom('[data-multiselect]')
      .hasAttribute('placeholder', 'Placeholder text');
  });

  test('it applies the error shadow when `@hasError={{true}}`', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        @hasError={{true}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect-container]').hasClass('shadow-error-outline');
    assert
      .dom('[data-multiselect-container]')
      .hasClass('focus-within:shadow-error-focus-outline');
    assert
      .dom('[data-multiselect-container]')
      .doesNotHaveClass('shadow-focusable-outline');
  });

  test('it opens the popover on click', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[role="listbox"]').doesNotExist();

    await click('[data-multiselect]');

    assert.dom('[role="listbox"]').exists();
  });

  test('it opens the popover when the input receives input', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[role="listbox"]').doesNotExist();

    await fillIn('[data-multiselect]', 'b');

    assert.dom('[role="listbox"]').exists();
  });

  // NOTE: This ensures that when a user clicks the border or the chevron
  //       that the input gets focused
  test('it focuses the input when the container element is clicked', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[role="listbox"]').doesNotExist();

    await click('[data-multiselect-container]');

    assert.dom('[data-multiselect]').isFocused();

    assert.dom('[role="listbox"]').exists();
  });

  test('it yields the `option`, `index`, `Chip`, and `Remove` to the `:chip` block and sets the `@label` on the Remove component', async function (assert) {
    let selected = ['blue'];

    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{selected}}
        @selected={{selected}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip data-test-index="{{chip.index}}">
            {{chip.option}}
            <chip.Remove data-remove="{{chip.option}}" @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option data-option>
            {{multiselect.option}}
          </multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Verify the `chip.Remove` `@label` argument gets set to the aria-label properly
    // for screenreaders.  Without an aria-label attribute, screenreader users
    // will have 0 context on what the button does.
    assert
      .dom('[data-multiselect-remove-option]')
      .hasAttribute('aria-label', 'Remove');

    // Verify the `chip.option` gets yielded back properly via the `chip` block.
    assert.dom('[data-remove="blue"]').exists();

    // Verify the chip index gets yielded back
    assert.dom('[data-test-index="0"]').exists();
  });

  test('it sets `aria-expanded` based on the popover state', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[role="listbox"]').doesNotExist();

    assert.dom('[data-multiselect]').hasNoAttribute('aria-expanded');

    await click('[data-multiselect]');

    assert.dom('[data-multiselect]').hasAttribute('aria-expanded');
  });

  test('it sets `aria-controls`', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect]').hasAttribute('aria-controls');
  });

  test('it applies the provided `@contentClass` to the popover content list', async function (assert) {
    await render(<template>
      <Multiselect
        @options={{testColors}}
        @contentClass="test-class"
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    assert.dom('[role="listbox"]').exists();
    assert.dom('[role="listbox"]').hasClass('test-class');
  });

  test('it renders the provided options in the popover list', async function (assert) {
    await render(<template>
      <Multiselect
        @options={{testColors}}
        @contentClass="test-class"
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option
            data-option
          >{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    // We want to verify our options have `role="option"` for accessibility reasons
    assert.dom('[role="option"]').exists({ count: 2 });
    // We can also verify our data attributes are spread to each option
    assert.dom('[data-option]').exists({ count: 2 });
  });

  test('it renders a selected chip for each item provided via `@selected`', async function (assert) {
    let selected = ['blue', 'red'];

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect-selected-option]').exists({ count: 2 });

    let [firstChip, secondChip] = document.querySelectorAll(
      '[data-multiselect-selected-option]'
    );

    assert.dom(firstChip).hasText('blue');
    assert.dom(secondChip).hasText('red');
  });

  test('it sets the label of each selected chip', async function (assert) {
    let options = ['a'];

    let selected = [...options];

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect-selected-option]').exists({ count: 1 });
    assert.dom('[data-multiselect-selected-option]').hasText('a');
  });

  test('it sets `aria-selected` properly on the list item that is currently selected', async function (assert) {
    let selected = ['blue'];

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    // Since `@selected=["blue"]`, we expect it to be selected
    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('aria-selected', 'true');

    // ...but not the "red" one!
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('aria-selected', 'false');
  });

  test("it checks each option's checkbox based on `@selected`", async function (assert) {
    let selected = ['blue'];

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    // Since `@selected=['blue']`, we expect it to be checked
    assert.dom('[data-multiselect-option-checkbox]:first-child').isChecked();

    // ...but not the "red" one!
    assert.dom('[data-multiselect-option-checkbox]:last-child').isNotChecked();
  });

  test('it provides default filtering', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await fillIn('[data-multiselect]', 'blue');

    // Filtering works as we expect
    assert.dom('[role="option"]').exists({ count: 1 });
    assert.dom('[role="option"]').hasText('blue');

    // Resetting the filter by clearing the input should
    // display all available options
    await fillIn('[data-multiselect]', '');
    assert.dom('[role="option"]').exists({ count: 2 });

    // Verify we can filter again after clearing
    await fillIn('[data-multiselect]', 'red');
    assert.dom('[role="option"]').exists({ count: 1 });
    assert.dom('[role="option"]').hasText('red');
  });

  test('it renders `@noResultsText`', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No items"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await fillIn('[data-multiselect]', 'something-not-in-the-list');

    // We should not have any list items
    assert.dom('[role="option"]').exists({ count: 0 });

    // ...but we should have our no results item!
    assert.dom('[role="status"]').exists();
    assert.dom('[role="status"]').hasTagName('li');
    assert.dom('[role="status"]').hasText('No items');
    assert
      .dom('[role="status"]')
      .hasAttribute(
        'aria-live',
        'assertive',
        'Expected assertive so it is announced to screenreaders'
      );
  });

  test('it calls `@onChange` when an option is selected via mouse click and keeps the popover oepn', async function (assert) {
    assert.expect(6);

    let handleChange = (value: string[]) => {
      assert.deepEqual(value, ['blue'], 'Expected input to match');
      assert.step('handleChange');
    };

    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        @onChange={{handleChange}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.verifySteps([]);

    await fillIn('[data-multiselect]', 'blue');

    assert.dom('[role="option"]').exists({ count: 1 });

    await click('[role="option"]');

    assert.verifySteps(['handleChange']);

    // Verify the popover remains open
    assert.dom('[role="listbox"]').exists();
  });

  test('it calls `@onChange` when an option is selected via the keyboard with ENTER and keeps the popover open', async function (assert) {
    assert.expect(6);

    let handleChange = (value: string[]) => {
      assert.deepEqual(value, ['blue'], 'Expected input to match');
      assert.step('handleChange');
    };

    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        @onChange={{handleChange}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.verifySteps([]);

    await fillIn('[data-multiselect]', 'blue');

    assert.dom('[role="option"]').exists({ count: 1 });

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Enter');

    assert.verifySteps(['handleChange']);

    // Verify the popover remains open
    assert.dom('[role="listbox"]').exists();
  });

  test('it calls `@onChange` with newly added values', async function (assert) {
    assert.expect(3);

    let selected = ['a', 'b', 'c'];
    let options = ['a', 'b', 'c', 'd', 'e', 'f'];

    let handleChange = (value: string[]) => {
      assert.deepEqual(
        value,
        ['a', 'b', 'c', 'd'],
        'Expected "d" to be added on change'
      );
      assert.step('handleChange');
    };

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @onChange={{handleChange}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Select another option, "d"
    await fillIn('[data-multiselect]', 'd');
    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Enter');

    assert.verifySteps(['handleChange']);
  });

  test('it calls `@onChange` when a chip is removed by click the "X"/remove button', async function (assert) {
    assert.expect(6);

    let selected = ['a', 'b', 'c'];
    let options = ['a', 'b', 'c'];

    let handleChange = (value: string[]) => {
      assert.deepEqual(
        value,
        ['a', 'c'],
        'Expected "b" to be removed on change'
      );
      assert.step('handleChange');
    };

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @onChange={{handleChange}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect-remove-option]').exists({ count: 3 });

    let removeButtons = document.querySelectorAll(
      '[data-multiselect-remove-option]'
    );

    assert.ok(removeButtons, 'Expected queryable remove buttons');
    assert.ok(
      removeButtons[1],
      'Expected the middle remove button to be available'
    );

    // Remove the middle item
    await click(removeButtons[1] as Element);

    assert.verifySteps(['handleChange']);
  });

  test('it removes the last selected item and calls `@onChange` when the backspace key is pressed with an empty input', async function (assert) {
    assert.expect(3);

    let options = ['a', 'b', 'c'];
    let selected = [...options];

    let handleChange = (value: string[]) => {
      assert.deepEqual(
        value,
        ['a', 'b'],
        'Expected "b" to be removed on change'
      );
      assert.step('handleChange');
    };

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @onChange={{handleChange}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');
    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Backspace');

    assert.verifySteps(['handleChange']);
  });

  test('it removes an item when it is re-selected after already being selected and calls `@onChange`', async function (assert) {
    assert.expect(3);

    let options = ['a', 'b', 'c'];
    let selected = [...options];

    let handleChange = (value: string[]) => {
      assert.deepEqual(
        value,
        ['b', 'c'],
        'Expected "a" to be removed on change as it was re-selected'
      );
      assert.step('handleChange');
    };

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @onChange={{handleChange}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await fillIn('[data-multiselect]', 'a');
    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Enter');

    assert.verifySteps(['handleChange']);
  });

  /**
   * This handles the case where a user is actively filtering and presses the
   * backspace key.  For this case, we do NOT want to remove a selected chip,
   * as the user is interacting with filtering rather than attempting to delete
   * an item.
   */
  test('it does **NOT** call `@onChange` if the input has a value and the backspace key is pressed', async function (assert) {
    assert.expect(1);

    let selected = ['a', 'b', 'c'];
    let options = ['a', 'b', 'c'];

    let handleChange = () => {
      assert.step('do-not-expect-this-to-be-called!');
    };

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @onChange={{handleChange}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await fillIn('[data-multiselect]', 'testing');
    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Backspace');

    assert.verifySteps([]);
  });

  test('it does not render the "X"/remove button on selected chips when `@isDisabled={{true}}`', async function (assert) {
    let options = ['a', 'b', 'c'];
    let selected = [...options];

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @isDisabled={{true}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect-remove-option]').doesNotExist();
  });

  test('it does not render the "X"/remove button on selected chips when `@isReadOnly={{true}}`', async function (assert) {
    let options = ['a', 'b', 'c'];
    let selected = [...options];

    // NOTE: starting with selected options already!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @isReadOnly={{true}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    assert.dom('[data-multiselect-remove-option]').doesNotExist();
  });

  test('it uses the results from `@onFilter` to populate the filtered options', async function (assert) {
    assert.expect(5);

    let selected = ['blue'];

    let handleFilter = (value: unknown) => {
      assert.strictEqual(
        value,
        'y',
        'Expected the input to match what was entered via fillIn'
      );
      assert.step('onFilter');

      return ['yellow'];
    };

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @onFilter={{handleFilter}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await fillIn('[data-multiselect]', 'y');

    assert.verifySteps(['onFilter']);

    assert.dom('[role="option"]').exists({ count: 1 });
    assert.dom('[role="option"]').hasText('yellow');
  });

  test('it sets the "active" item to the first one in the list when the input gains focus', async function (assert) {
    let selected = ['blue'];

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    assert.dom('[role="option"]').exists({ count: 2 });

    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'true');
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'false');
  });

  test('it sets the "active" item to the next item in the list when using the DOWN arrow', async function (assert) {
    let selected = ['blue'];

    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    assert.dom('[role="option"]').exists({ count: 2 });

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'ArrowDown');

    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'false');
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'true');
  });

  test('it sets the "active" item to the previous item in the list when using the UP arrow', async function (assert) {
    let selected = ['red'];

    // NOTE: Setting the selected option to "red" here so that
    // the last item in the list will be active so that we can
    // move up!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    assert.dom('[role="option"]').exists({ count: 2 });

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'ArrowUp');

    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'true');
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'false');
  });

  test('it closes an open popover when the ESCAPE key is pressed', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    await click('[data-multiselect]');

    assert.dom('[role="listbox"]').exists();

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Escape');

    assert.dom('[role="listbox"]').doesNotExist();
  });

  test('it closes an open popover when the component is blurred', async function (assert) {
    // NOTE: We add an input tag so we have something to blur to (by focusing another element)
    await render(<template>
      {{! template-lint-disable require-input-label }}
      <input placeholder="test" data-input />

      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover
    await click('[data-multiselect]');

    assert.dom('[role="listbox"]').exists();

    // Now blur the element by focusing the other input element in our test
    await click('[data-input]');

    assert.dom('[role="listbox"]').doesNotExist();
  });

  test('it reopens the popover when any key is pressed if the popover is closed', async function (assert) {
    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover by clicking it
    await click('[data-multiselect]');

    // Now close it
    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Escape');
    // Now reopen it
    await triggerKeyEvent('[data-multiselect]', 'keydown', 'ArrowDown');

    assert.dom('[role="listbox"]').exists();
  });

  test('it makes the first option "active" when the metakey and UP arrow is pressed', async function (assert) {
    let selected = ['f'];
    let options = ['a', 'b', 'c', 'd', 'e', 'f'];

    // NOTE: Our selected option is currently at the bottom of the list!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover by clicking it
    await click('[data-multiselect]');

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'ArrowUp', {
      metaKey: true,
    });

    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'true');
    // Verify our last item is no longer "active"
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'false');
  });

  test('it makes the last option "active" when the metakey and DOWN arrow is pressed', async function (assert) {
    let selected = ['a'];
    let options = ['a', 'b', 'c', 'd', 'e', 'f'];

    // NOTE: Our selected option is currently at the top of the list!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover by clicking it
    await click('[data-multiselect]');

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'ArrowDown', {
      metaKey: true,
    });

    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'true');

    // Verify our first item is no longer "active"
    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'false');
  });

  test('it makes the last option "active" when the PAGEDOWN key is pressed', async function (assert) {
    let selected = ['a'];
    let options = ['a', 'b', 'c', 'd', 'e', 'f'];

    // NOTE: Our selected option is currently at the top of the list!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover by clicking it
    await click('[data-multiselect]');

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'PageDown');

    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'true');

    // Verify our first item is no longer "active"
    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'false');
  });

  test('it makes the first option "active" when the PAGEUP key is pressed', async function (assert) {
    let selected = ['f'];
    let options = ['a', 'b', 'c', 'd', 'e', 'f'];

    // NOTE: Our selected option is currently at the bottom of the list!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover by clicking it
    await click('[data-multiselect]');

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'PageUp');

    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'true');
    // Verify our last item is no longer "active"
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'false');
  });

  test('it makes the first option "active" when the HOME key is pressed', async function (assert) {
    let selected = ['f'];
    let options = ['a', 'b', 'c', 'd', 'e', 'f'];

    // NOTE: Our selected option is currently at the bottom of the list!
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{options}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);

    // Open the popover by clicking it
    await click('[data-multiselect]');

    await triggerKeyEvent('[data-multiselect]', 'keydown', 'Home');

    assert
      .dom('[role="option"]:first-child')
      .hasAttribute('data-active', 'true');
    // Verify our last item is no longer "active"
    assert
      .dom('[role="option"]:last-child')
      .hasAttribute('data-active', 'false');
  });

  // This tests our `resetValue` action
  test('it clears the input value when a user enters invalid text into the input without selecting anything and then blurs the input', async function (assert) {
    assert.expect(3);

    let selected = ['blue'];

    let handleChange = () => {
      assert.step('do-not-expect-this-to-be-called!');
    };

    // NOTE: We have a selected option
    // NOTE: We add an input tag so we have something to blur to (by focusing another element)
    await render(<template>
      <Multiselect
        @selected={{selected}}
        @options={{testColors}}
        @onChange={{handleChange}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove @label="Remove" />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>

      {{! template-lint-disable require-input-label }}
      <input placeholder="test" data-input />
    </template>);

    await click('[data-multiselect]');

    // Enter garbage into the input
    await fillIn('[data-multiselect]', 'some-garbage');

    // Now blur the element
    await click('[data-input]');

    // Verify the input is reset to our `@selected` option
    assert.dom('[data-multiselect]').hasValue('');

    // NOTE: We do not expect the `@onChange`  to be called in this
    // case as we are only visually resetting to the previously
    // selected value
    assert.verifySteps([]);

    // We want to verify the original options are re-displayed
    // rather than the input being filtered to garbage
    await click('[data-multiselect]');

    assert.dom('[role="option"]').exists({ count: 2 });
  });

  test('it throws an assertion error if no `:chip` block is provided', async function (assert) {
    assert.expect(1);

    setupOnerror((e: Error) => {
      assert.ok(
        e.message.includes('The `:chip` block is required'),
        'Expected assertion error message'
      );
    });

    await render(<template>
      <Multiselect
        @noResultsText="No results"
        @options={{testColors}}
        data-multiselect
      >
        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);
  });

  test('it throws an assertion error if no `@label` argument is provided to the Remove component', async function (assert) {
    assert.expect(1);

    setupOnerror((e: Error) => {
      assert.ok(
        e.message.includes(
          'The Remove component "@label" argument is required'
        ),
        'Expected assertion error message'
      );
    });

    await render(<template>
      <Multiselect
        @options={{testColors}}
        @selected={{testColors}}
        @noResultsText="No results"
        data-multiselect
      >
        <:chip as |chip|>
          <chip.Chip>
            {{chip.option}}
            <chip.Remove />
          </chip.Chip>
        </:chip>

        <:default as |multiselect|>
          <multiselect.Option>{{multiselect.option}}</multiselect.Option>
        </:default>
      </Multiselect>
    </template>);
  });
});
