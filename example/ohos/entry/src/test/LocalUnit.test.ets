import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import FkUserAgentPlugin from 'fk_user_agent';

const FkUserAgentPlugin: FkUserAgentPlugin = new FkUserAgentPlugin()
export default function localUnitTest() {
  describe('localUnitTest', () => {
    it('getUniqueClassName', 0, () => {
      expect(fkUserAgentPlugin.getUniqueClassName()).not().assertNull();
    });
  });
}
