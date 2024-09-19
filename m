Return-Path: <kvm+bounces-27165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D231E97C401
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 664001F21E52
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D10D77110;
	Thu, 19 Sep 2024 05:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHX/NHPz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507917BAF
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725387; cv=none; b=gG7h3MlJyMCysKM+0sgqxlUAkqbaH1BhD8eNFNgsXlvVcII/Wnnz5EVVbYOXTvu5Eyf5sRy4nSDoTb7GYmQUGhy/fhNsrLYX1UnDedWE9WY81pKeetJtDuLuhI04ODFD62Em/NfFznn3XEqvWls27zs+K3mY9I8V8doZZ6QkGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725387; c=relaxed/simple;
	bh=qJ6NOfIv6xlTy3/VIJhTGfDVU1kuzHahvjHb/mzi/Yo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FysT17i1hg5CPHwGVmYCKE+kpQrk+Ue8jXDoBqYCRZ3AfryvrHvzxySacwAPj3X9iEoRjINjmJw+ukaZqFlaX67PoMLaEKpdyZ2Mw5LAQsdnbYOObwqNcIs1dOwpHcxKUSp0+Frk+u2VuL0+ZbwBAKQqUT0euCjC6lbbl2ei6k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHX/NHPz; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725386; x=1758261386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qJ6NOfIv6xlTy3/VIJhTGfDVU1kuzHahvjHb/mzi/Yo=;
  b=NHX/NHPz0Api673UD1QiYuqOzLz4x0APm5jV8uMzH1/w7vaHPcxv+CSO
   KcvrQk0mCAUVbbhqVrFHy/m8sFiJXjilQfn5bZvS0rvnhTBgMANlyNwZ9
   wZ5ZflTE9hK7ZCPaH/uM7CQQadtKmg4LTEkFwE1mvUU1ESGQiz+fwXmK0
   rkCaoKNsm6dhQyyO+7wEPOFQ27wOpKwQXrHHUulz7t0Wv3NDYk3kWCfQ9
   k47Ki1HXTaFAC6o9aQtVBpnPt9Fvmw85OwJJsMCoEcEpG/uL3PcwWe+rY
   bSNk3VhE4nYKaq1n+AApoPEQyKXxEsO8gEva/19aj0EpfCCnjrcAsPxzU
   Q==;
X-CSE-ConnectionGUID: OydfB57hQeONz42wpUVJEA==
X-CSE-MsgGUID: 9CzUZ0SNRC2maJNlfVqSmQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813695"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813695"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:26 -0700
X-CSE-ConnectionGUID: RNragx4JQm++GP/Zqhw+Sw==
X-CSE-MsgGUID: ix81mjh5Tfy9LecwpDpOIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418793"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:56:20 -0700
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
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 09/12] i386: Introduce x86 CPU core abstractions
Date: Thu, 19 Sep 2024 14:11:25 +0800
Message-Id: <20240919061128.769139-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Abstract 3 core types for i386: common core, Intel Core (P-core) and
Intel atom (E-core). This is in preparation for creating the hybrid
topology from the CLI.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/core.c      | 56 +++++++++++++++++++++++++++++++++++++++++
 target/i386/core.h      | 53 ++++++++++++++++++++++++++++++++++++++
 target/i386/meson.build |  1 +
 3 files changed, 110 insertions(+)
 create mode 100644 target/i386/core.c
 create mode 100644 target/i386/core.h

diff --git a/target/i386/core.c b/target/i386/core.c
new file mode 100644
index 000000000000..d76186a6a070
--- /dev/null
+++ b/target/i386/core.c
@@ -0,0 +1,56 @@
+/*
+ * x86 CPU core
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
+#include "core.h"
+
+static void x86_common_core_class_init(ObjectClass *oc, void *data)
+{
+    X86CPUCoreClass *cc = X86_CPU_CORE_CLASS(oc);
+
+    cc->core_type = COMMON_CORE;
+}
+
+static void x86_intel_atom_class_init(ObjectClass *oc, void *data)
+{
+    X86CPUCoreClass *cc = X86_CPU_CORE_CLASS(oc);
+
+    cc->core_type = INTEL_ATOM;
+}
+
+static void x86_intel_core_class_init(ObjectClass *oc, void *data)
+{
+    X86CPUCoreClass *cc = X86_CPU_CORE_CLASS(oc);
+
+    cc->core_type = INTEL_CORE;
+}
+
+static const TypeInfo x86_cpu_core_infos[] = {
+    {
+        .name = TYPE_X86_CPU_CORE,
+        .parent = TYPE_CPU_CORE,
+        .class_size = sizeof(X86CPUCoreClass),
+        .class_init = x86_common_core_class_init,
+        .instance_size = sizeof(X86CPUCore),
+    },
+    {
+        .parent = TYPE_X86_CPU_CORE,
+        .name = X86_CPU_CORE_TYPE_NAME("intel-atom"),
+        .class_init = x86_intel_atom_class_init,
+    },
+    {
+        .parent = TYPE_X86_CPU_CORE,
+        .name = X86_CPU_CORE_TYPE_NAME("intel-core"),
+        .class_init = x86_intel_core_class_init,
+    },
+};
+
+DEFINE_TYPES(x86_cpu_core_infos)
diff --git a/target/i386/core.h b/target/i386/core.h
new file mode 100644
index 000000000000..b942153b2c0d
--- /dev/null
+++ b/target/i386/core.h
@@ -0,0 +1,53 @@
+/*
+ * x86 CPU core header
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#include "hw/cpu/core.h"
+#include "hw/cpu/cpu-topology.h"
+#include "qom/object.h"
+
+#ifndef I386_CORE_H
+#define I386_CORE_H
+
+#ifdef TARGET_X86_64
+#define TYPE_X86_PREFIX "x86-"
+#else
+#define TYPE_X86_PREFIX "i386-"
+#endif
+
+#define TYPE_X86_CPU_CORE TYPE_X86_PREFIX "core"
+
+OBJECT_DECLARE_TYPE(X86CPUCore, X86CPUCoreClass, X86_CPU_CORE)
+
+typedef enum {
+    COMMON_CORE = 0,
+    INTEL_ATOM,
+    INTEL_CORE,
+} X86CoreType;
+
+struct X86CPUCoreClass {
+    /*< private >*/
+    CPUTopoClass parent_class;
+
+    /*< public >*/
+    DeviceRealize parent_realize;
+    X86CoreType core_type;
+};
+
+struct X86CPUCore {
+    /*< private >*/
+    CPUCore parent_obj;
+
+    /*< public >*/
+};
+
+#define X86_CPU_CORE_TYPE_NAME(core_type_str) (TYPE_X86_PREFIX core_type_str)
+
+#endif /* I386_CORE_H */
diff --git a/target/i386/meson.build b/target/i386/meson.build
index 075117989b9d..80a32526d98b 100644
--- a/target/i386/meson.build
+++ b/target/i386/meson.build
@@ -18,6 +18,7 @@ i386_system_ss.add(files(
   'arch_memory_mapping.c',
   'machine.c',
   'monitor.c',
+  'core.c',
   'cpu-apic.c',
   'cpu-sysemu.c',
 ))
-- 
2.34.1


