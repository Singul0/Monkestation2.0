import { useBackend } from '../backend';
import { LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Machining = (props, context) => {
  return (
    <Window resizable>
      <Window.Content scrollable>
        <HealthStatus user="Jerry" />
      </Window.Content>
    </Window>
  );
};

const HealthStatus = (props, context) => {
  const { act, data } = useBackend(context);
  const { user } = props;
  const { health, color } = data;
  return (
    <Section title={'Health status of: ' + user}>
      <LabeledList>
        <LabeledList.Item label="Health">{health}</LabeledList.Item>
        <LabeledList.Item label="Color">{color}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
