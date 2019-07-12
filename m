Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F7967161
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfGLOcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41899 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfGLOcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:32:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23669A3B71;
        Fri, 12 Jul 2019 14:32:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14E9760920;
        Fri, 12 Jul 2019 14:32:14 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PULL 02/19] migration-test: rename parameter to parameter_int
Date:   Fri, 12 Jul 2019 16:31:50 +0200
Message-Id: <20190712143207.4214-3-quintela@redhat.com>
In-Reply-To: <20190712143207.4214-1-quintela@redhat.com>
References: <20190712143207.4214-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 12 Jul 2019 14:32:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We would need _str ones on the next patch.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 tests/migration-test.c | 55 +++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/tests/migration-test.c b/tests/migration-test.c
index b6434628e1..a4feb9545d 100644
--- a/tests/migration-test.c
+++ b/tests/migration-test.c
@@ -398,7 +398,8 @@ static char *migrate_get_socket_address(QTestState *who, const char *parameter)
     return result;
 }
 
-static long long migrate_get_parameter(QTestState *who, const char *parameter)
+static long long migrate_get_parameter_int(QTestState *who,
+                                           const char *parameter)
 {
     QDict *rsp;
     long long result;
@@ -409,17 +410,17 @@ static long long migrate_get_parameter(QTestState *who, const char *parameter)
     return result;
 }
 
-static void migrate_check_parameter(QTestState *who, const char *parameter,
-                                    long long value)
+static void migrate_check_parameter_int(QTestState *who, const char *parameter,
+                                        long long value)
 {
     long long result;
 
-    result = migrate_get_parameter(who, parameter);
+    result = migrate_get_parameter_int(who, parameter);
     g_assert_cmpint(result, ==, value);
 }
 
-static void migrate_set_parameter(QTestState *who, const char *parameter,
-                                  long long value)
+static void migrate_set_parameter_int(QTestState *who, const char *parameter,
+                                      long long value)
 {
     QDict *rsp;
 
@@ -429,7 +430,7 @@ static void migrate_set_parameter(QTestState *who, const char *parameter,
                     parameter, value);
     g_assert(qdict_haskey(rsp, "return"));
     qobject_unref(rsp);
-    migrate_check_parameter(who, parameter, value);
+    migrate_check_parameter_int(who, parameter, value);
 }
 
 static void migrate_pause(QTestState *who)
@@ -681,7 +682,7 @@ static void deprecated_set_downtime(QTestState *who, const double value)
                     " 'arguments': { 'value': %f } }", value);
     g_assert(qdict_haskey(rsp, "return"));
     qobject_unref(rsp);
-    migrate_check_parameter(who, "downtime-limit", value * 1000);
+    migrate_check_parameter_int(who, "downtime-limit", value * 1000);
 }
 
 static void deprecated_set_speed(QTestState *who, long long value)
@@ -692,7 +693,7 @@ static void deprecated_set_speed(QTestState *who, long long value)
                           "'arguments': { 'value': %lld } }", value);
     g_assert(qdict_haskey(rsp, "return"));
     qobject_unref(rsp);
-    migrate_check_parameter(who, "max-bandwidth", value);
+    migrate_check_parameter_int(who, "max-bandwidth", value);
 }
 
 static void deprecated_set_cache_size(QTestState *who, long long value)
@@ -703,7 +704,7 @@ static void deprecated_set_cache_size(QTestState *who, long long value)
                          "'arguments': { 'value': %lld } }", value);
     g_assert(qdict_haskey(rsp, "return"));
     qobject_unref(rsp);
-    migrate_check_parameter(who, "xbzrle-cache-size", value);
+    migrate_check_parameter_int(who, "xbzrle-cache-size", value);
 }
 
 static void test_deprecated(void)
@@ -738,8 +739,8 @@ static int migrate_postcopy_prepare(QTestState **from_ptr,
      * quickly, but that it doesn't complete precopy even on a slow
      * machine, so also set the downtime.
      */
-    migrate_set_parameter(from, "max-bandwidth", 100000000);
-    migrate_set_parameter(from, "downtime-limit", 1);
+    migrate_set_parameter_int(from, "max-bandwidth", 100000000);
+    migrate_set_parameter_int(from, "downtime-limit", 1);
 
     /* Wait for the first serial output from the source */
     wait_for_serial("src_serial");
@@ -790,7 +791,7 @@ static void test_postcopy_recovery(void)
     }
 
     /* Turn postcopy speed down, 4K/s is slow enough on any machines */
-    migrate_set_parameter(from, "max-postcopy-bandwidth", 4096);
+    migrate_set_parameter_int(from, "max-postcopy-bandwidth", 4096);
 
     /* Now we start the postcopy */
     migrate_postcopy_start(from, to);
@@ -831,7 +832,7 @@ static void test_postcopy_recovery(void)
     g_free(uri);
 
     /* Restore the postcopy bandwidth to unlimited */
-    migrate_set_parameter(from, "max-postcopy-bandwidth", 0);
+    migrate_set_parameter_int(from, "max-postcopy-bandwidth", 0);
 
     migrate_postcopy_complete(from, to);
 }
@@ -877,9 +878,9 @@ static void test_precopy_unix(void)
      * machine, so also set the downtime.
      */
     /* 1 ms should make it not converge*/
-    migrate_set_parameter(from, "downtime-limit", 1);
+    migrate_set_parameter_int(from, "downtime-limit", 1);
     /* 1GB/s */
-    migrate_set_parameter(from, "max-bandwidth", 1000000000);
+    migrate_set_parameter_int(from, "max-bandwidth", 1000000000);
 
     /* Wait for the first serial output from the source */
     wait_for_serial("src_serial");
@@ -889,7 +890,7 @@ static void test_precopy_unix(void)
     wait_for_migration_pass(from);
 
     /* 300 ms should converge */
-    migrate_set_parameter(from, "downtime-limit", 300);
+    migrate_set_parameter_int(from, "downtime-limit", 300);
 
     if (!got_stop) {
         qtest_qmp_eventwait(from, "STOP");
@@ -956,11 +957,11 @@ static void test_xbzrle(const char *uri)
      * machine, so also set the downtime.
      */
     /* 1 ms should make it not converge*/
-    migrate_set_parameter(from, "downtime-limit", 1);
+    migrate_set_parameter_int(from, "downtime-limit", 1);
     /* 1GB/s */
-    migrate_set_parameter(from, "max-bandwidth", 1000000000);
+    migrate_set_parameter_int(from, "max-bandwidth", 1000000000);
 
-    migrate_set_parameter(from, "xbzrle-cache-size", 33554432);
+    migrate_set_parameter_int(from, "xbzrle-cache-size", 33554432);
 
     migrate_set_capability(from, "xbzrle", "true");
     migrate_set_capability(to, "xbzrle", "true");
@@ -972,7 +973,7 @@ static void test_xbzrle(const char *uri)
     wait_for_migration_pass(from);
 
     /* 300ms should converge */
-    migrate_set_parameter(from, "downtime-limit", 300);
+    migrate_set_parameter_int(from, "downtime-limit", 300);
 
     if (!got_stop) {
         qtest_qmp_eventwait(from, "STOP");
@@ -1008,9 +1009,9 @@ static void test_precopy_tcp(void)
      * machine, so also set the downtime.
      */
     /* 1 ms should make it not converge*/
-    migrate_set_parameter(from, "downtime-limit", 1);
+    migrate_set_parameter_int(from, "downtime-limit", 1);
     /* 1GB/s */
-    migrate_set_parameter(from, "max-bandwidth", 1000000000);
+    migrate_set_parameter_int(from, "max-bandwidth", 1000000000);
 
     /* Wait for the first serial output from the source */
     wait_for_serial("src_serial");
@@ -1022,7 +1023,7 @@ static void test_precopy_tcp(void)
     wait_for_migration_pass(from);
 
     /* 300ms should converge */
-    migrate_set_parameter(from, "downtime-limit", 300);
+    migrate_set_parameter_int(from, "downtime-limit", 300);
 
     if (!got_stop) {
         qtest_qmp_eventwait(from, "STOP");
@@ -1054,9 +1055,9 @@ static void test_migrate_fd_proto(void)
      * machine, so also set the downtime.
      */
     /* 1 ms should make it not converge */
-    migrate_set_parameter(from, "downtime-limit", 1);
+    migrate_set_parameter_int(from, "downtime-limit", 1);
     /* 1GB/s */
-    migrate_set_parameter(from, "max-bandwidth", 1000000000);
+    migrate_set_parameter_int(from, "max-bandwidth", 1000000000);
 
     /* Wait for the first serial output from the source */
     wait_for_serial("src_serial");
@@ -1090,7 +1091,7 @@ static void test_migrate_fd_proto(void)
     wait_for_migration_pass(from);
 
     /* 300ms should converge */
-    migrate_set_parameter(from, "downtime-limit", 300);
+    migrate_set_parameter_int(from, "downtime-limit", 300);
 
     if (!got_stop) {
         qtest_qmp_eventwait(from, "STOP");
-- 
2.21.0

