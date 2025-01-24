Return-Path: <kvm+bounces-36497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F39A1B6ED
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0DDC188CC47
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85F9482EB;
	Fri, 24 Jan 2025 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LBdk6cKF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB8242AB0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725868; cv=none; b=df52ziaN0DWAbGO9erFNkdfeLJSaZHkRAhiX5rKH4A//EJ2QtYyTgyjUgVBbj8t0Zb/LjFtpnFEfofV3JE6p1PDQseBaFVDpO5g3+bn/C6JNoW3xjb4knbeb7AMQJN6AqaVugFCSiTJ7m0B/r30YwoAGITgHe2OHRXN4IQiRrOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725868; c=relaxed/simple;
	bh=fSsAL3WOwQ9gQ4rru12HLOwZ4HFCghaKIHkuJX/Kx5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qb21z8deDOb9H4XVuLKCBBCIooQrvbPlfM7Dl8uVyla5YvYaERnPlf6/WnTUZD/7owo4gUvIoL56ah/PIm/iyEVtuEKaF4VI96zAhOdyAIC03Z8yT7T6FZ4VcRPnSibWYyRcf9+2e0i3J+rB7/GGK5bl55yPRyyB6I/1oOT2eIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LBdk6cKF; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725867; x=1769261867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fSsAL3WOwQ9gQ4rru12HLOwZ4HFCghaKIHkuJX/Kx5E=;
  b=LBdk6cKFVYJcl1IaEYpwjyLpfjGD8NDJgL2dEJc0zI0udWK4PpO7Q5bN
   8W48SZSJ7uN4/laywd0eMeVSF6Rcn2zMdL2DsZaWb5cTLl8SG2PRhhs9w
   knp8o5gpZgZnKh+TI9idQhHKI1xp7zO4zp+OkTWsc9UOnt8OCyjMYFnVE
   Z7aX81RnHyH9olk0m6zruOhFf/7ZwI1F+MqAf16tZf/32jzMZhAN5yYzO
   Jvy6HEeaOxQ3uMiLBmPLLvZDHeabMJ77pCj0SWmoqgXiKjAe5wVk99rHj
   cTfdcBf1RBhyW4x3j0uZWQ4jsE/uCyD+ZTmJNmgMKOi9HGJlTARCjOqV0
   g==;
X-CSE-ConnectionGUID: miNaBs7ZRiGaqmpku+s00w==
X-CSE-MsgGUID: AuEKex8NTTaem+ovPs24qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246257"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246257"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:46 -0800
X-CSE-ConnectionGUID: Xg0IVMEySGOGeX/lgoAMtQ==
X-CSE-MsgGUID: ChSKISCtRFG5UODlsYUscg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804204"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:42 -0800
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
Subject: [PATCH v7 12/52] i386/tdx: Validate TD attributes
Date: Fri, 24 Jan 2025 08:20:08 -0500
Message-Id: <20250124132048.3229049-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Validate TD attributes with tdx_caps that only supported bits arer
allowed by KVM.

Besides, sanity check the attribute bits that have not been supported by
QEMU yet. e.g., debug bit, it will be allowed in the future when debug
TD support lands in QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v7:
- Define TDX_SUPPORTED_TD_ATTRS as QEMU supported mask, to validates
  user's request. (Rick)

Changes in v3:
- using error_setg() for error report; (Daniel)
---
 qapi/qom.json         |  16 +++++-
 target/i386/kvm/tdx.c | 118 +++++++++++++++++++++++++++++++++++++++++-
 target/i386/kvm/tdx.h |   3 ++
 3 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index 8740626c4ee6..a53000ca6fb4 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1060,11 +1060,25 @@
 #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
 #     be set, otherwise they refuse to boot.
 #
+# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
+#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
+#     Defaults to all zeros.
+#
+# @mrowner: ID for the guest TD’s owner (base64 encoded SHA384 digest).
+#     Defaults to all zeros.
+#
+# @mrownerconfig: ID for owner-defined configuration of the guest TD,
+#     e.g., specific to the workload rather than the run-time or OS
+#     (base64 encoded SHA384 digest).  Defaults to all zeros.
+#
 # Since: 10.0
 ##
 { 'struct': 'TdxGuestProperties',
   'data': { '*attributes': 'uint64',
-            '*sept-ve-disable': 'bool' } }
+            '*sept-ve-disable': 'bool',
+            '*mrconfigid': 'str',
+            '*mrowner': 'str',
+            '*mrownerconfig': 'str' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 653942d83bcb..ed843af1d0b6 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -11,17 +11,24 @@
 
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
+#include "qemu/base64.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "crypto/hash.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
+#define TDX_SUPPORTED_TD_ATTRS  (TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE |\
+                                 TDX_TD_ATTRIBUTES_PKS | \
+                                 TDX_TD_ATTRIBUTES_PERFMON)
+
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
@@ -153,13 +160,33 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
-static void setup_td_guest_attributes(X86CPU *x86cpu)
+static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
+{
+    if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
+        error_setg(errp, "Invalid attributes 0x%lx for TDX VM "
+                   "(KVM supported: 0x%llx)", tdx->attributes,
+                   tdx_caps->supported_attrs);
+        return -1;
+    }
+
+    if (tdx->attributes & ~TDX_SUPPORTED_TD_ATTRS) {
+        warn_report("Some QEMU unsupported TD attribute bits being requested:"
+                    "requested: 0x%lx QEMU supported: 0x%llx",
+                    tdx->attributes, TDX_SUPPORTED_TD_ATTRS);
+    }
+
+    return 0;
+}
+
+static int setup_td_guest_attributes(X86CPU *x86cpu, Error **errp)
 {
     CPUX86State *env = &x86cpu->env;
 
     tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
                              TDX_TD_ATTRIBUTES_PKS : 0;
     tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+
+    return tdx_validate_attributes(tdx_guest, errp);
 }
 
 static int setup_td_xfam(X86CPU *x86cpu, Error **errp)
@@ -214,6 +241,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     CPUX86State *env = &x86cpu->env;
     g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
     Error *local_err = NULL;
+    size_t data_len;
     int retry = 10000;
     int r = 0;
 
@@ -225,7 +253,40 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
-    setup_td_guest_attributes(x86cpu);
+    if (tdx_guest->mrconfigid) {
+        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
+                              strlen(tdx_guest->mrconfigid), &data_len, errp);
+        if (!data || data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
+            error_setg(errp, "TDX: failed to decode mrconfigid");
+            return -1;
+        }
+        memcpy(init_vm->mrconfigid, data, data_len);
+    }
+
+    if (tdx_guest->mrowner) {
+        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrowner,
+                              strlen(tdx_guest->mrowner), &data_len, errp);
+        if (!data || data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
+            error_setg(errp, "TDX: failed to decode mrowner");
+            return -1;
+        }
+        memcpy(init_vm->mrowner, data, data_len);
+    }
+
+    if (tdx_guest->mrownerconfig) {
+        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrownerconfig,
+                            strlen(tdx_guest->mrownerconfig), &data_len, errp);
+        if (!data || data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
+            error_setg(errp, "TDX: failed to decode mrownerconfig");
+            return -1;
+        }
+        memcpy(init_vm->mrownerconfig, data, data_len);
+    }
+
+    r = setup_td_guest_attributes(x86cpu, errp);
+    if (r) {
+        return r;
+    }
 
     r = setup_td_xfam(x86cpu, errp);
     if (r) {
@@ -283,6 +344,51 @@ static void tdx_guest_set_sept_ve_disable(Object *obj, bool value, Error **errp)
     }
 }
 
+static char *tdx_guest_get_mrconfigid(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return g_strdup(tdx->mrconfigid);
+}
+
+static void tdx_guest_set_mrconfigid(Object *obj, const char *value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    g_free(tdx->mrconfigid);
+    tdx->mrconfigid = g_strdup(value);
+}
+
+static char *tdx_guest_get_mrowner(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return g_strdup(tdx->mrowner);
+}
+
+static void tdx_guest_set_mrowner(Object *obj, const char *value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    g_free(tdx->mrowner);
+    tdx->mrowner = g_strdup(value);
+}
+
+static char *tdx_guest_get_mrownerconfig(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return g_strdup(tdx->mrownerconfig);
+}
+
+static void tdx_guest_set_mrownerconfig(Object *obj, const char *value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    g_free(tdx->mrownerconfig);
+    tdx->mrownerconfig = g_strdup(value);
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -306,6 +412,14 @@ static void tdx_guest_init(Object *obj)
     object_property_add_bool(obj, "sept-ve-disable",
                              tdx_guest_get_sept_ve_disable,
                              tdx_guest_set_sept_ve_disable);
+    object_property_add_str(obj, "mrconfigid",
+                            tdx_guest_get_mrconfigid,
+                            tdx_guest_set_mrconfigid);
+    object_property_add_str(obj, "mrowner",
+                            tdx_guest_get_mrowner, tdx_guest_set_mrowner);
+    object_property_add_str(obj, "mrownerconfig",
+                            tdx_guest_get_mrownerconfig,
+                            tdx_guest_set_mrownerconfig);
 }
 
 static void tdx_guest_finalize(Object *obj)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 4e2b5c61ff5b..e472b11fb0dd 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -24,6 +24,9 @@ typedef struct TdxGuest {
     bool initialized;
     uint64_t attributes;    /* TD attributes */
     uint64_t xfam;
+    char *mrconfigid;       /* base64 encoded sha348 digest */
+    char *mrowner;          /* base64 encoded sha348 digest */
+    char *mrownerconfig;    /* base64 encoded sha348 digest */
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.34.1


