import { useBackend, useLocalState } from '../backend';
import { Section, Stack, Tabs, Divider, Box, Button } from '../components';
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
      <Window.Content>
        <Stack fill>
          <Stack.Item width={'200px'}>
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
          <Stack.Item grow my={'16px'}>
            {/* Only MainRecipeScreen is scrollable */}
            <Box
              scrollable
              fill
              height={'100%'}
              pr={1}
              pt={1}
              mr={-1}
              style={{ 'overflow-y': 'auto' }}
            >
              <MainRecipeScreen tab={activeTab} />
            </Box>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MainRecipeScreen = (props, context) => {
  const { data } = useBackend(context);
  const { tab } = props;
  const { recipes, atom_data, busy } = data;

  if (!recipes || !recipes.length) {
    return <Section>No recipes available. yell at coders</Section>;
  }

  return (
    <>
      {recipes.map((recipe, index) => (
        <Section key={index} title={recipe.name}>
          <Stack>
            <Stack.Item>
              <Box
                width={'32px'}
                height={'32px'}
                style={{
                  transform: 'scale(2)',
                }}
                m={'16px'}
                className={`machining32x32 a${recipe.result}`}
              />
            </Stack.Item>
            <Stack.Item ml={'16px'} grow>
              {recipe.desc}
            </Stack.Item>
            <Button
              my={0.3}
              lineHeight={2.5}
              align="center"
              content="Make"
              disabled={busy}
              color="green"
              icon={busy ? 'circle-notch' : 'hammer'}
              iconSpin={busy ? 1 : 0}
              onClick={() => {}}
            />
          </Stack>
          <Dividers title={'Materials'} />
          <Stack vertical>
            {recipe.reqs &&
              Object.keys(recipe.reqs).map((atom_id) => {
                const atomIndex = Number(atom_id) - 1;
                const atomInfo = atom_data?.[atomIndex];
                return (
                  <Stack.Item key={atom_id}>
                    <Stack>
                      <Stack.Item>
                        <Box
                          width={'32px'}
                          height={'32px'}
                          className={`machining32x32 a${atom_id}`}
                          mr={1}
                        />
                      </Stack.Item>
                      <Stack.Item grow>
                        {atomInfo?.name
                          .split(' ')
                          .map((word) => word[0].toUpperCase() + word.slice(1))
                          .join(' ')}
                        {recipe.reqs[atom_id] > 1
                          ? ` x${recipe.reqs[atom_id]}`
                          : ''}
                      </Stack.Item>
                    </Stack>
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
