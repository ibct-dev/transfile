#pragma once

#define MAKE_READ_SNAPSHOT(NAME) \
   struct NAME {\
       static fc::variant json() { return read_json_snapshot  ("/home/dev001/LEDGIS/build/unittests/snapshots/" #NAME ".json.gz"); } \
       static std::string bin()  { return read_binary_snapshot("/home/dev001/LEDGIS/build/unittests/snapshots/" #NAME ".bin.gz" ); } \
   };\

namespace eosio {
   namespace testing {
      struct snapshots {
         // v2
         MAKE_READ_SNAPSHOT(snap_v2)
         MAKE_READ_SNAPSHOT(snap_v2_prod_sched)
      };
   } /// eosio::testing
}  /// eosio
