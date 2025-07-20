import { useLocalState } from '../backend';
import { Section, Stack, Tabs } from '../components';
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
            <MainRecipeScreen tab={activeTab} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MainRecipeScreen = ({ tab }) => {
  // You can customize content based on tab argument
  let title = '';
  let description = '';
  switch (tab) {
    case 'cargo':
      title = 'Cargo';
      description = 'Here you can order supply crates.';
      break;
    case 'health':
      title = 'Health';
      description = 'Health status and diagnostics.';
      break;
    case 'settings':
      title = 'Settings';
      description = 'Settings screen goes here.';
      break;
    case 'dummy':
      title = 'Dummy';
      description = 'Dummy Interface';
      break;
    default:
      title = 'Unknown';
      description = 'No content available.';
  }
  return <Section title={title}>{description}</Section>;
};
