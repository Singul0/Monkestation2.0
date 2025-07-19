import { useBackend, useLocalState } from '../backend';
import { LabeledList, Section, Stack, Tabs, NoticeBox } from '../components';
import { Window } from '../layouts';

const TAB_LIST = [
  { key: 'cargo', label: 'Cargo' },
  { key: 'health', label: 'Health' },
  { key: 'settings', label: 'Settings' },
  { key: 'dummy', label: 'Dummy' },
];

export const Machining = (props, context) => {
  const [activeTab, setActiveTab] = useLocalState(
    'machiningTab',
    TAB_LIST[0].key,
  );

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Stack fill>
          <Stack.Item>
            <Section fill>
              <Tabs vertical>
                {TAB_LIST.map((tab) => (
                  <Tabs.Tab
                    key={tab.key}
                    selected={activeTab === tab.key}
                    onClick={() => setActiveTab(tab.key)}
                  >
                    {tab.label}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            {activeTab === 'cargo' && (
              <Section title="Cargo">Here you can order supply crates.</Section>
            )}
            {activeTab === 'health' && <HealthStatus user="Jerry" />}
            {activeTab === 'settings' && (
              <Section title="Settings">
                <NoticeBox info>Settings screen goes here.</NoticeBox>
              </Section>
            )}
            {activeTab === 'dummy' && (
              <Section title="Dummy">
                <NoticeBox info>Dummy Interface</NoticeBox>
              </Section>
            )}
          </Stack.Item>
        </Stack>
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
