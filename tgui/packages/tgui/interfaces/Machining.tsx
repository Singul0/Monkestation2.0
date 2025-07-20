import { useBackend, useLocalState } from '../backend';
import { Section, Stack, Tabs, Divider } from '../components';
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

const MainRecipeScreen = (props, context) => {
  const { data } = useBackend(context);
  const { tab } = props;
  const { recipes, atom_data } = data;

  if (!recipes || !recipes.length) {
    return <Section>No recipes available. yell at coders</Section>;
  }

  return (
    <>
      {recipes.map((recipe, index) => (
        <Section key={index} title={recipe.name}>
          {recipe.desc}
          <Dividers title={'Materials'} />
          {/* Display each material's name vertically */}
          <Stack vertical>
            {recipe.reqs &&
              Object.keys(recipe.reqs).map((atom_id) => {
                const atomIndex = Number(atom_id) - 1;
                const atomInfo = atom_data?.[atomIndex];
                return (
                  <Stack.Item key={atom_id}>
                    {atomInfo?.name || `Material ${atom_id}`}
                    {recipe.reqs[atom_id] > 1
                      ? ` x${recipe.reqs[atom_id]}`
                      : ''}
                  </Stack.Item>
                );
              })}
          </Stack>
        </Section>
      ))}
    </>
  );
};

const Dividers = ({ title }) => {
  return (
    <Stack my={1}>
      <Stack.Item grow>
        <Divider />
      </Stack.Item>
      <Stack.Item color={'gray'}>{title}</Stack.Item>
      <Stack.Item grow>
        <Divider />
      </Stack.Item>
    </Stack>
  ) as any;
};
