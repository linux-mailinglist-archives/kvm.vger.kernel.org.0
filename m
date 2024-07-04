Return-Path: <kvm+bounces-20927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A13926DBE
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A48E61C21656
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3269B17C73;
	Thu,  4 Jul 2024 03:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ms5xvoXU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2CB1B7E4
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062045; cv=none; b=bFQDfskFvxpZJj6jZR8EfHlKAZLtLNjuzFGfEOkh6VKK8ohji8MjIAdGDu2oL59ZYRI1d7TkHmoxFCC35/tTf79uRrTcBNMoXelQvlcAS+HZpwgm0HVvPMkD2ozVuPv9uhxxfhiSxEwiEmwql5k//FxoGeVHSDPjCEVyLYN4nzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062045; c=relaxed/simple;
	bh=4VH/b1FVdYaezQBLyS+kZwfI3T4jbK9VUPHg1kOSC0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ecz0fRppnOaigeFdCfR33M73sXlHdeAdqigGY6kIjCKvjnrbp3EyjVBpfONn9KAifQ3VukSHxCby8Jkp6S6cQ9NIn8Hiz6kpKZ9Xd9E4qOKkBGTbchSto5YeKvFNQiwOh7CS/QNtYWXOkD9muyrL7gFGNLqoyw57nBUir4V7JZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ms5xvoXU; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062043; x=1751598043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4VH/b1FVdYaezQBLyS+kZwfI3T4jbK9VUPHg1kOSC0s=;
  b=Ms5xvoXUBoVHMEPKG7Zg9pxxqUZe0vAs/HDhv3UBkpqYIitV+KjJ6gC4
   lVGTWqACNr64aJwyPV9lMvGhSEgGfmYVQeN2qxqdOsKMEjFfNYt1zmMnL
   auqulA8oXsc+U/WlH9BFFgyHPNYZgFWQYQsFb/2XIghehB4CemDSa0N5V
   8PYOn6hLpBCl/xK2TUtT4zK7XJD5kcJh/fnFd3ClsTwLMy0Fpp9gKoo6l
   oPqD8LNWZVqSs5HC/SDhfLkWGAdCMZ/6RE6wIM21xHD14/HvmCszobnxj
   0j5G16xAa6PwUIaEFCA9pY/on7U3fsMQNh0LMQMR7KL3MUUrTaAC8MK91
   w==;
X-CSE-ConnectionGUID: 7iJK8v+ATY2mb4fKeaFckg==
X-CSE-MsgGUID: SY0VjTbhQ+Kbh9FRX9QvMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838087"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838087"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:00:43 -0700
X-CSE-ConnectionGUID: MdfPppBnTPiNsHH28MY2fQ==
X-CSE-MsgGUID: 9PGc1LQSSqCR74sBHleRWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052151"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:00:38 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Date: Thu,  4 Jul 2024 11:15:57 +0800
Message-Id: <20240704031603.1744546-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce smp-cache object so that user could define cache properties.

In smp-cache object, define cache topology based on CPU topology level
with two reasons:

1. In practice, a cache will always be bound to the CPU container
   (either private in the CPU container or shared among multiple
   containers), and CPU container is often expressed in terms of CPU
   topology level.
2. The x86's cache-related CPUIDs encode cache topology based on APIC
   ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
   relies on also requires CPU containers to help indicate the private
   shared hierarchy of the cache. Therefore, for SMP systems, it is
   natural to use the CPU topology hierarchy directly in QEMU to define
   the cache topology.

Currently, separated L1 cache (L1 data cache and L1 instruction cache)
with unified higher-level cache (e.g., unified L2 and L3 caches), is the
most common cache architectures.

Therefore, enumerate the L1 D-cache, L1 I-cache, L2 cache and L3 cache
with smp-cache object to add the basic cache topology support.

Suggested-by: Daniel P. Berrange <berrange@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Suggested by credit:
 * Referred to Daniel's suggestion to introduce cache JSON list, though
   as a standalone object since -smp/-machine can't support JSON.
---
Changes since RFC v2:
 * New commit to implement cache list with JSON format instead of
   multiple sub-options in -smp.
---
 MAINTAINERS                 |   2 +
 hw/core/meson.build         |   1 +
 hw/core/smp-cache.c         | 103 ++++++++++++++++++++++++++++++++++++
 include/hw/core/smp-cache.h |  27 ++++++++++
 qapi/machine-common.json    |  50 +++++++++++++++++
 qapi/qapi-schema.json       |   4 +-
 qapi/qom.json               |   3 ++
 7 files changed, 188 insertions(+), 2 deletions(-)
 create mode 100644 hw/core/smp-cache.c
 create mode 100644 include/hw/core/smp-cache.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6725913c8b3a..b5391a7538de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1885,12 +1885,14 @@ F: hw/core/machine.c
 F: hw/core/machine-smp.c
 F: hw/core/null-machine.c
 F: hw/core/numa.c
+F: hw/core/smp-cache.c
 F: hw/cpu/cluster.c
 F: qapi/machine.json
 F: qapi/machine-common.json
 F: qapi/machine-target.json
 F: include/hw/boards.h
 F: include/hw/core/cpu.h
+F: include/hw/core/smp-cache.h
 F: include/hw/cpu/cluster.h
 F: include/sysemu/numa.h
 F: tests/unit/test-smp-parse.c
diff --git a/hw/core/meson.build b/hw/core/meson.build
index a3d9bab9f42a..6d3dae3af62e 100644
--- a/hw/core/meson.build
+++ b/hw/core/meson.build
@@ -14,6 +14,7 @@ hwcore_ss.add(files(
 
 common_ss.add(files('cpu-common.c'))
 common_ss.add(files('machine-smp.c'))
+common_ss.add(files('smp-cache.c'))
 system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
 system_ss.add(when: 'CONFIG_GENERIC_LOADER', if_true: files('generic-loader.c'))
 system_ss.add(when: 'CONFIG_GUEST_LOADER', if_true: files('guest-loader.c'))
diff --git a/hw/core/smp-cache.c b/hw/core/smp-cache.c
new file mode 100644
index 000000000000..c0157ce51c8f
--- /dev/null
+++ b/hw/core/smp-cache.c
@@ -0,0 +1,103 @@
+/*
+ * Cache Object for SMP machine
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+
+#include "hw/core/smp-cache.h"
+#include "qapi/error.h"
+#include "qapi/qapi-visit-machine-common.h"
+#include "qom/object_interfaces.h"
+
+static void
+smp_cache_get_cache_prop(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    SMPCache *cache = SMP_CACHE(obj);
+    SMPCachePropertyList *head = NULL;
+    SMPCachePropertyList **tail = &head;
+
+    for (int i = 0; i < SMP_CACHE__MAX; i++) {
+        SMPCacheProperty *node = g_new(SMPCacheProperty, 1);
+
+        node->name = cache->props[i].name;
+        node->topo = cache->props[i].topo;
+        QAPI_LIST_APPEND(tail, node);
+    }
+
+    if (!visit_type_SMPCachePropertyList(v, name, &head, errp)) {
+        return;
+    }
+    qapi_free_SMPCachePropertyList(head);
+}
+
+static void
+smp_cache_set_cache_prop(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    SMPCache *cache = SMP_CACHE(obj);
+    SMPCachePropertyList *list, *node;
+
+    if (!visit_type_SMPCachePropertyList(v, name, &list, errp)) {
+        return;
+    }
+
+    for (node = list; node; node = node->next) {
+        if (node->value->topo == CPU_TOPO_LEVEL_INVALID) {
+            error_setg(errp,
+                       "Invalid topology level: %s. "
+                       "The topology should match the valid CPU topology level",
+                       CpuTopologyLevel_str(node->value->topo));
+            goto out;
+        }
+        cache->props[node->value->name].topo = node->value->topo;
+    }
+
+out:
+    qapi_free_SMPCachePropertyList(list);
+}
+
+static void smp_cache_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add(oc, "caches", "SMPCacheProperties",
+                              smp_cache_get_cache_prop,
+                              smp_cache_set_cache_prop,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "caches",
+            "Cache property list for SMP machine");
+}
+
+static void smp_cache_instance_init(Object *obj)
+{
+    SMPCache *cache = SMP_CACHE(obj);
+    for (int i = 0; i < SMP_CACHE__MAX; i++) {
+        cache->props[i].name = (SMPCacheName)i;
+        cache->props[i].topo = CPU_TOPO_LEVEL_DEFAULT;
+    }
+}
+
+static const TypeInfo smp_cache_info = {
+    .parent = TYPE_OBJECT,
+    .name = TYPE_SMP_CACHE,
+    .class_init = smp_cache_class_init,
+    .instance_size = sizeof(SMPCache),
+    .instance_init = smp_cache_instance_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
+static void smp_cache_register_type(void)
+{
+    type_register_static(&smp_cache_info);
+}
+
+type_init(smp_cache_register_type);
diff --git a/include/hw/core/smp-cache.h b/include/hw/core/smp-cache.h
new file mode 100644
index 000000000000..c6b4d9efc290
--- /dev/null
+++ b/include/hw/core/smp-cache.h
@@ -0,0 +1,27 @@
+/*
+ * Cache Object for SMP machine
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef SMP_CACHE_H
+#define SMP_CACHE_H
+
+#include "qapi/qapi-types-machine-common.h"
+#include "qom/object.h"
+
+#define TYPE_SMP_CACHE "smp-cache"
+OBJECT_DECLARE_SIMPLE_TYPE(SMPCache, SMP_CACHE)
+
+struct SMPCache {
+    Object parent_obj;
+
+    SMPCacheProperty props[SMP_CACHE__MAX];
+};
+
+#endif /* SMP_CACHE_H */
diff --git a/qapi/machine-common.json b/qapi/machine-common.json
index 82413c668bdb..8b8c0e9eeb86 100644
--- a/qapi/machine-common.json
+++ b/qapi/machine-common.json
@@ -64,3 +64,53 @@
   'prefix': 'CPU_TOPO_LEVEL',
   'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
             'die', 'socket', 'book', 'drawer', 'default' ] }
+
+##
+# @SMPCacheName:
+#
+# An enumeration of cache for SMP systems.  The cache name here is
+# a combination of cache level and cache type.
+#
+# @l1d: L1 data cache.
+#
+# @l1i: L1 instruction cache.
+#
+# @l2: L2 (unified) cache.
+#
+# @l3: L3 (unified) cache
+#
+# Since: 9.1
+##
+{ 'enum': 'SMPCacheName',
+  'prefix': 'SMP_CACHE',
+  'data': [ 'l1d', 'l1i', 'l2', 'l3' ] }
+
+##
+# @SMPCacheProperty:
+#
+# Cache information for SMP systems.
+#
+# @name: Cache name.
+#
+# @topo: Cache topology level.  It accepts the CPU topology
+#     enumeration as the parameter, i.e., CPUs in the same
+#     topology container share the same cache.
+#
+# Since: 9.1
+##
+{ 'struct': 'SMPCacheProperty',
+  'data': {
+  'name': 'SMPCacheName',
+  'topo': 'CpuTopologyLevel' } }
+
+##
+# @SMPCacheProperties:
+#
+# List wrapper of SMPCacheProperty.
+#
+# @caches: the SMPCacheProperty list.
+#
+# Since 9.1
+##
+{ 'struct': 'SMPCacheProperties',
+  'data': { 'caches': ['SMPCacheProperty'] } }
diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
index b1581988e4eb..25394f2cda50 100644
--- a/qapi/qapi-schema.json
+++ b/qapi/qapi-schema.json
@@ -64,11 +64,11 @@
 { 'include': 'compat.json' }
 { 'include': 'control.json' }
 { 'include': 'introspect.json' }
-{ 'include': 'qom.json' }
-{ 'include': 'qdev.json' }
 { 'include': 'machine-common.json' }
 { 'include': 'machine.json' }
 { 'include': 'machine-target.json' }
+{ 'include': 'qom.json' }
+{ 'include': 'qdev.json' }
 { 'include': 'replay.json' }
 { 'include': 'yank.json' }
 { 'include': 'misc.json' }
diff --git a/qapi/qom.json b/qapi/qom.json
index 8bd299265e39..797dd58a61f5 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -8,6 +8,7 @@
 { 'include': 'block-core.json' }
 { 'include': 'common.json' }
 { 'include': 'crypto.json' }
+{ 'include': 'machine-common.json' }
 
 ##
 # = QEMU Object Model (QOM)
@@ -1064,6 +1065,7 @@
       'if': 'CONFIG_SECRET_KEYRING' },
     'sev-guest',
     'sev-snp-guest',
+    'smp-cache',
     'thread-context',
     's390-pv-guest',
     'throttle-group',
@@ -1135,6 +1137,7 @@
                                       'if': 'CONFIG_SECRET_KEYRING' },
       'sev-guest':                  'SevGuestProperties',
       'sev-snp-guest':              'SevSnpGuestProperties',
+      'smp-cache':                  'SMPCacheProperties',
       'thread-context':             'ThreadContextProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
-- 
2.34.1


