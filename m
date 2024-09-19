Return-Path: <kvm+bounces-27111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77AF097C28C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B0301F21D6E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF0018E11;
	Thu, 19 Sep 2024 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="flfbCvxm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2793B1DFF0
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710046; cv=none; b=oIym8a6K636bnxK6V5nzaSeIWzsQT2dPwN+4EfexYp1OcJhe1K/v74JL/AWKQg+rAER5LntqIjdycThVPAqR3LLIqdoeeCpwDjzN0tNoanQNhTl8QhN5hicQitU69AuWSXTpcMwuylCBJjHVg9QbtRA8LJMMpz6mNNOgYGX/qss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710046; c=relaxed/simple;
	bh=4Lv6y5pVsU6DtDjzxhv1VCs53XCauucInvDj9vyaeKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I/AUyEKFyRg9T2wBA8fkU8gKtMI7a0dwtBf9RCPv41ygcYTeldo1+Vh9JX/p+dinO6VTJOqFNyN6Jq+e0QLCgktcv8rrnyCtSpwtgo1Miw6Zp8OzUA9fSrNs4zLrDDu9rdzT5EOZiL6n4uSBstHC+MuJdNfQA7h1jA6CXcDKpY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=flfbCvxm; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710045; x=1758246045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Lv6y5pVsU6DtDjzxhv1VCs53XCauucInvDj9vyaeKw=;
  b=flfbCvxmoDA1WbA5lhtJA2duvjUtH8bQajRXW9no0Cmv3Mm1M3PgsSBh
   kHplKt3z1QSuUQRzNLGIJU7ulkcj6R+7pnlgbKjrSPcafjFClBIEgHBvV
   gqUeFfhniKcVzX7PJhRsWLLjjkuJQPg8iJitOftUp9pHlaxqIUJJ+mpgp
   rIRAfXaDsZEV71C6n2b0p8tCx9mdlyegkWIR5XjyPlFrb1TtNT4nhrt7q
   ZQ8U/TqZsfQcllmG9bKBY1fltfTP1FtweZGNfDXv8QSATCRXzhpc2I5P4
   J+NtaMMLVdkVCUurDiQuNXeXTDQopF9EKz7rh+9AftKf4emKtcxGeHnQB
   A==;
X-CSE-ConnectionGUID: vrWEOGJnRXqBnL12cr0dYA==
X-CSE-MsgGUID: KT3RS1TPRuCMgXu9NzNwyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797984"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797984"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:45 -0700
X-CSE-ConnectionGUID: oRBjSbnIQmSIHRcM58FHEg==
X-CSE-MsgGUID: BCnW7jNJTSGl38Hi7C4luQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058880"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:39 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 09/15] hw/cpu: Abstract module/die/socket levels as topology devices
Date: Thu, 19 Sep 2024 09:55:27 +0800
Message-Id: <20240919015533.766754-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Abstract module/die/socket levels as the cpu-module/cpu-die/cpu-socket
topology devices then they can be inserted into topology tree.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS             |  6 ++++++
 hw/cpu/die.c            | 34 ++++++++++++++++++++++++++++++++++
 hw/cpu/meson.build      |  3 +++
 hw/cpu/module.c         | 34 ++++++++++++++++++++++++++++++++++
 hw/cpu/socket.c         | 34 ++++++++++++++++++++++++++++++++++
 include/hw/cpu/die.h    | 29 +++++++++++++++++++++++++++++
 include/hw/cpu/module.h | 29 +++++++++++++++++++++++++++++
 include/hw/cpu/socket.h | 29 +++++++++++++++++++++++++++++
 8 files changed, 198 insertions(+)
 create mode 100644 hw/cpu/die.c
 create mode 100644 hw/cpu/module.c
 create mode 100644 hw/cpu/socket.c
 create mode 100644 include/hw/cpu/die.h
 create mode 100644 include/hw/cpu/module.h
 create mode 100644 include/hw/cpu/socket.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e5b2cd91dca..03c1a13de074 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1886,6 +1886,9 @@ F: hw/core/numa.c
 F: hw/cpu/cluster.c
 F: hw/cpu/cpu-slot.c
 F: hw/cpu/cpu-topology.c
+F: hw/cpu/die.c
+F: hw/cpu/module.c
+F: hw/cpu/socket.c
 F: qapi/machine.json
 F: qapi/machine-common.json
 F: qapi/machine-target.json
@@ -1894,6 +1897,9 @@ F: include/hw/core/cpu.h
 F: include/hw/cpu/cluster.h
 F: include/hw/cpu/cpu-slot.h
 F: include/hw/cpu/cpu-topology.h
+F: include/hw/cpu/die.h
+F: include/hw/cpu/module.h
+F: include/hw/cpu/socket.h
 F: include/sysemu/numa.h
 F: tests/functional/test_cpu_queries.py
 F: tests/functional/test_empty_cpu_model.py
diff --git a/hw/cpu/die.c b/hw/cpu/die.c
new file mode 100644
index 000000000000..f00907ffd78b
--- /dev/null
+++ b/hw/cpu/die.c
@@ -0,0 +1,34 @@
+/*
+ * CPU die abstract device
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
+#include "hw/cpu/die.h"
+
+static void cpu_die_class_init(ObjectClass *oc, void *data)
+{
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    tc->level = CPU_TOPOLOGY_LEVEL_DIE;
+}
+
+static const TypeInfo cpu_die_type_info = {
+    .name = TYPE_CPU_DIE,
+    .parent = TYPE_CPU_TOPO,
+    .class_init = cpu_die_class_init,
+    .instance_size = sizeof(CPUDie),
+};
+
+static void cpu_die_register_types(void)
+{
+    type_register_static(&cpu_die_type_info);
+}
+
+type_init(cpu_die_register_types)
diff --git a/hw/cpu/meson.build b/hw/cpu/meson.build
index 358e2b3960fa..c64eec4460d8 100644
--- a/hw/cpu/meson.build
+++ b/hw/cpu/meson.build
@@ -3,6 +3,9 @@ common_ss.add(files('cpu-topology.c'))
 system_ss.add(files('core.c'))
 system_ss.add(files('cpu-slot.c'))
 system_ss.add(when: 'CONFIG_CPU_CLUSTER', if_true: files('cluster.c'))
+system_ss.add(files('die.c'))
+system_ss.add(files('module.c'))
+system_ss.add(files('socket.c'))
 
 system_ss.add(when: 'CONFIG_ARM11MPCORE', if_true: files('arm11mpcore.c'))
 system_ss.add(when: 'CONFIG_REALVIEW', if_true: files('realview_mpcore.c'))
diff --git a/hw/cpu/module.c b/hw/cpu/module.c
new file mode 100644
index 000000000000..b6f50a2ba588
--- /dev/null
+++ b/hw/cpu/module.c
@@ -0,0 +1,34 @@
+/*
+ * CPU module abstract device
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
+#include "hw/cpu/module.h"
+
+static void cpu_module_class_init(ObjectClass *oc, void *data)
+{
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    tc->level = CPU_TOPOLOGY_LEVEL_MODULE;
+}
+
+static const TypeInfo cpu_module_type_info = {
+    .name = TYPE_CPU_MODULE,
+    .parent = TYPE_CPU_TOPO,
+    .class_init = cpu_module_class_init,
+    .instance_size = sizeof(CPUModule),
+};
+
+static void cpu_module_register_types(void)
+{
+    type_register_static(&cpu_module_type_info);
+}
+
+type_init(cpu_module_register_types)
diff --git a/hw/cpu/socket.c b/hw/cpu/socket.c
new file mode 100644
index 000000000000..516e93389e11
--- /dev/null
+++ b/hw/cpu/socket.c
@@ -0,0 +1,34 @@
+/*
+ * CPU socket abstract device
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
+#include "hw/cpu/socket.h"
+
+static void cpu_socket_class_init(ObjectClass *oc, void *data)
+{
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    tc->level = CPU_TOPOLOGY_LEVEL_SOCKET;
+}
+
+static const TypeInfo cpu_socket_type_info = {
+    .name = TYPE_CPU_SOCKET,
+    .parent = TYPE_CPU_TOPO,
+    .class_init = cpu_socket_class_init,
+    .instance_size = sizeof(CPUSocket),
+};
+
+static void cpu_socket_register_types(void)
+{
+    type_register_static(&cpu_socket_type_info);
+}
+
+type_init(cpu_socket_register_types)
diff --git a/include/hw/cpu/die.h b/include/hw/cpu/die.h
new file mode 100644
index 000000000000..682e226ac569
--- /dev/null
+++ b/include/hw/cpu/die.h
@@ -0,0 +1,29 @@
+/*
+ * CPU die abstract device
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef HW_CPU_DIE_H
+#define HW_CPU_DIE_H
+
+#include "hw/cpu/cpu-topology.h"
+#include "hw/qdev-core.h"
+
+#define TYPE_CPU_DIE "cpu-die"
+
+OBJECT_DECLARE_SIMPLE_TYPE(CPUDie, CPU_DIE)
+
+struct CPUDie {
+    /*< private >*/
+    CPUTopoState obj;
+
+    /*< public >*/
+};
+
+#endif /* HW_CPU_DIE_H */
diff --git a/include/hw/cpu/module.h b/include/hw/cpu/module.h
new file mode 100644
index 000000000000..242cd623a3b3
--- /dev/null
+++ b/include/hw/cpu/module.h
@@ -0,0 +1,29 @@
+/*
+ * CPU module abstract device
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef HW_CPU_MODULE_H
+#define HW_CPU_MODULE_H
+
+#include "hw/cpu/cpu-topology.h"
+#include "hw/qdev-core.h"
+
+#define TYPE_CPU_MODULE "cpu-module"
+
+OBJECT_DECLARE_SIMPLE_TYPE(CPUModule, CPU_MODULE)
+
+struct CPUModule {
+    /*< private >*/
+    CPUTopoState obj;
+
+    /*< public >*/
+};
+
+#endif /* HW_CPU_MODULE_H */
diff --git a/include/hw/cpu/socket.h b/include/hw/cpu/socket.h
new file mode 100644
index 000000000000..a25bf8727a22
--- /dev/null
+++ b/include/hw/cpu/socket.h
@@ -0,0 +1,29 @@
+/*
+ * CPU socket abstract device
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef HW_CPU_SOCKET_H
+#define HW_CPU_SOCKET_H
+
+#include "hw/cpu/cpu-topology.h"
+#include "hw/qdev-core.h"
+
+#define TYPE_CPU_SOCKET "cpu-socket"
+
+OBJECT_DECLARE_SIMPLE_TYPE(CPUSocket, CPU_SOCKET)
+
+struct CPUSocket {
+    /*< private >*/
+    CPUTopoState parent_obj;
+
+    /*< public >*/
+};
+
+#endif /* HW_CPU_SOCKET_H */
-- 
2.34.1


