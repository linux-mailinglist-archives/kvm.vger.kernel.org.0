Return-Path: <kvm+bounces-36487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 478EEA1B6E2
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95B0E7A4E52
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE524D599;
	Fri, 24 Jan 2025 13:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RfwUMHPm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B99C288CC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725831; cv=none; b=mMc+kKaaq3LgQ8DkC/JAMqoz+OpQmjG7ZiT0RgVDQeMG19HmE2dAGej5LaT320c5V09hBm1dv2Qu7SNftOcLZpr0Xck0DGPCqeO1Gzs4MjLgffuxelm2MqTuuNPKYfcLQD+YmeVeYpLC8g8ZIfnoxu/lUJul2VUtFbY0+OKKaYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725831; c=relaxed/simple;
	bh=xzih++adOsaHe0umhusAizXMSAWafcak7ZcTqRe6TaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GbJ0Y8dHBehw4+dtS6CGSAzs+ncbwm/e9NBNg1+4byqImLKZ5MAYpmRXFmCVEb9nYF4AsrLu7DNUfWIfUVi0J9YeaWJlc8KP3jk2PICBClCyrIoXqpdN916eVCpSknbmZ7Ge6AOAeBUTsZ/eRzgIiYFWCvgPhZ1cKoaC9fFujbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RfwUMHPm; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725830; x=1769261830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xzih++adOsaHe0umhusAizXMSAWafcak7ZcTqRe6TaA=;
  b=RfwUMHPmw/NZpNnev0zS8wQSJ0DEK2q2Vq1CvQuJXf8wayCu3X13C4Uy
   qiP/vNFomZyXVpAH2TWX7I/J4tJlwqlKbOKyjMcOMbzb39Ab8wbZKD1TZ
   j1kTDeFwrWecJubYKparqm0PUYRIMUK0RVv3QdHRn/cV/kjn6fNu37R96
   Sroq57COR/oBOHl8t0OUIgKa3Tl478SOVRJHYQr3ZLHIsy6dMAAKy2Iv1
   nlz3JphYaCXH7VZitX24jE+CG+oaZl5EJMa5FvyI4ACVITsfyLr/fh2Wf
   cUrhywuQJkByFkIszuiVQh+lY2jWtdYXuQqQGEaFlT4HDEJRKiG8YDgxe
   g==;
X-CSE-ConnectionGUID: xVbN5sEGTIyOBGX8seWQZA==
X-CSE-MsgGUID: v6tY9OzCTCaJABOuOl95zA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246188"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246188"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:10 -0800
X-CSE-ConnectionGUID: Nm7eKvjHREmqOmskLGOi6A==
X-CSE-MsgGUID: 6n9CO0z/TQiDEkPFpj3iSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804106"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:05 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 02/52] i386: Introduce tdx-guest object
Date: Fri, 24 Jan 2025 08:19:58 -0500
Message-Id: <20250124132048.3229049-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce tdx-guest object which inherits X86_CONFIDENTIAL_GUEST,
and will be used to create TDX VMs (TDs) by

  qemu -machine ...,confidential-guest-support=tdx0	\
       -object tdx-guest,id=tdx0

It has one QAPI member 'attributes' defined, which allows user to set
TD's attributes directly.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes in v7:
 - update QAPI version to 10.0;
 - update to use SPDX tags for license info;
 - update copyright to 2025;

Chanegs in v6:
 - Make tdx-guest inherits X86_CONFIDENTIAL_GUEST;
 - set cgs->require_guest_memfd;
 - allow attributes settable via QAPI;
 - update QAPI version to since 9.2;

Changes in v4:
 - update the new qapi `since` filed from 8.2 to 9.0

Changes in v1
 - make @attributes not user-settable
---
 configs/devices/i386-softmmu/default.mak |  1 +
 hw/i386/Kconfig                          |  5 +++
 qapi/qom.json                            | 15 +++++++++
 target/i386/kvm/meson.build              |  2 ++
 target/i386/kvm/tdx.c                    | 43 ++++++++++++++++++++++++
 target/i386/kvm/tdx.h                    | 21 ++++++++++++
 6 files changed, 87 insertions(+)
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

diff --git a/configs/devices/i386-softmmu/default.mak b/configs/devices/i386-softmmu/default.mak
index 4faf2f0315e2..bc0479a7e0a3 100644
--- a/configs/devices/i386-softmmu/default.mak
+++ b/configs/devices/i386-softmmu/default.mak
@@ -18,6 +18,7 @@
 #CONFIG_QXL=n
 #CONFIG_SEV=n
 #CONFIG_SGA=n
+#CONFIG_TDX=n
 #CONFIG_TEST_DEVICES=n
 #CONFIG_TPM_CRB=n
 #CONFIG_TPM_TIS_ISA=n
diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index d34ce07b215d..cce9521ba934 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -10,6 +10,10 @@ config SGX
     bool
     depends on KVM
 
+config TDX
+    bool
+    depends on KVM
+
 config PC
     bool
     imply APPLESMC
@@ -26,6 +30,7 @@ config PC
     imply QXL
     imply SEV
     imply SGX
+    imply TDX
     imply TEST_DEVICES
     imply TPM_CRB
     imply TPM_TIS_ISA
diff --git a/qapi/qom.json b/qapi/qom.json
index 28ce24cd8d08..e3a5e9330b54 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1047,6 +1047,19 @@
             '*host-data': 'str',
             '*vcek-disabled': 'bool' } }
 
+##
+# @TdxGuestProperties:
+#
+# Properties for tdx-guest objects.
+#
+# @attributes: The 'attributes' of a TD guest that is passed to
+#     KVM_TDX_INIT_VM
+#
+# Since: 10.0
+##
+{ 'struct': 'TdxGuestProperties',
+  'data': { '*attributes': 'uint64' } }
+
 ##
 # @ThreadContextProperties:
 #
@@ -1132,6 +1145,7 @@
     'sev-snp-guest',
     'thread-context',
     's390-pv-guest',
+    'tdx-guest',
     'throttle-group',
     'tls-creds-anon',
     'tls-creds-psk',
@@ -1204,6 +1218,7 @@
                                       'if': 'CONFIG_SECRET_KEYRING' },
       'sev-guest':                  'SevGuestProperties',
       'sev-snp-guest':              'SevSnpGuestProperties',
+      'tdx-guest':                  'TdxGuestProperties',
       'thread-context':             'ThreadContextProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 3996cafaf29f..466bccb9cb17 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -8,6 +8,8 @@ i386_kvm_ss.add(files(
 
 i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
 
+i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
+
 i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
 i386_system_ss.add_all(when: 'CONFIG_KVM', if_true: i386_kvm_ss)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
new file mode 100644
index 000000000000..ec84ae2947bb
--- /dev/null
+++ b/target/i386/kvm/tdx.c
@@ -0,0 +1,43 @@
+/*
+ * QEMU TDX support
+ *
+ * Copyright (c) 2025 Intel Corporation
+ *
+ * Author:
+ *      Xiaoyao Li <xiaoyao.li@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qom/object_interfaces.h"
+
+#include "tdx.h"
+
+/* tdx guest */
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
+                                   tdx_guest,
+                                   TDX_GUEST,
+                                   X86_CONFIDENTIAL_GUEST,
+                                   { TYPE_USER_CREATABLE },
+                                   { NULL })
+
+static void tdx_guest_init(Object *obj)
+{
+    ConfidentialGuestSupport *cgs = CONFIDENTIAL_GUEST_SUPPORT(obj);
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    cgs->require_guest_memfd = true;
+    tdx->attributes = 0;
+
+    object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
+                                   OBJ_PROP_FLAG_READWRITE);
+}
+
+static void tdx_guest_finalize(Object *obj)
+{
+}
+
+static void tdx_guest_class_init(ObjectClass *oc, void *data)
+{
+}
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
new file mode 100644
index 000000000000..f3b725336161
--- /dev/null
+++ b/target/i386/kvm/tdx.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef QEMU_I386_TDX_H
+#define QEMU_I386_TDX_H
+
+#include "confidential-guest.h"
+
+#define TYPE_TDX_GUEST "tdx-guest"
+#define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
+
+typedef struct TdxGuestClass {
+    X86ConfidentialGuestClass parent_class;
+} TdxGuestClass;
+
+typedef struct TdxGuest {
+    X86ConfidentialGuest parent_obj;
+
+    uint64_t attributes;    /* TD attributes */
+} TdxGuest;
+
+#endif /* QEMU_I386_TDX_H */
-- 
2.34.1


