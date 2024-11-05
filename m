Return-Path: <kvm+bounces-30647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 394CC9BC584
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F23CF282B7F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBCE1FCC63;
	Tue,  5 Nov 2024 06:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9MB9OGO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282481F6667
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788638; cv=none; b=GvlG3zgeALYXlRwnKSD58/TnGO15IkRiBcZWwp1A+nZMk6Fn5ilpEILtKw7rVHPzZ1v3SghI4SngmgikIui7BoOK1o865l+7flSmtV5DS+9MJksikioliws56HzcnknbbDUbhvMXuXhTU31d9GxDhD98EOAHlGJo5E8OuLDhlgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788638; c=relaxed/simple;
	bh=/c6iKYuArYsGCvrbLnQoYffE/JqYul3IweXytxDmZNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=me1zQ6LbvBmXyRqpupa7KTujjHfLLV9n/1BU6b0LcylgN9xWjSniZ8ssmvTBv7GblOTF/OYcnACEMIGsOmKE9Ze4L9GlZzrBY8wEisPukU9IFUZNjTwnl/x7JRCJEy7Az9GgAY9hQttjrwj+39iyU964a/R+65KOUN98VnL60es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9MB9OGO; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788637; x=1762324637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/c6iKYuArYsGCvrbLnQoYffE/JqYul3IweXytxDmZNY=;
  b=I9MB9OGOJK+imERA6/Y6lPiu6y3nGwQ1JsCB9S1wLAZ8NID1Lzs7adul
   41vm7RCY9sr7TJlk68fITb9IvcEvUJYFrGztxa7dgPRMNy3UOs+s0oH02
   N5kecnY8xGkZ4fjwZM3F2s+H7tdntzw9I265Vix4aHTTtIN8vt4OW2BvX
   Bj/KsD+r4MiBxwwY/LxjfZmInvtbwekv9cg+VayizJvOEOlW7q2LxaiAA
   a7z6LMOmewm51z655KY82zQogCM6B3fZG6URClAueJEI+mpcZ0AbyMOHo
   acqN7ZU6N4mAZemowEVNSXwt/dpTTZtAxBCijmJKBLeuNZsLuDTP2rwQT
   Q==;
X-CSE-ConnectionGUID: insP5wpNTYyX3XHeIj2rMQ==
X-CSE-MsgGUID: EdpovNl0TpW1uKvd5yUrPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689425"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689425"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:17 -0800
X-CSE-ConnectionGUID: L6eSPwevRTCTpTItmtpCDQ==
X-CSE-MsgGUID: bP+aULKLSei0fDyQJ6ZDzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988794"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:13 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 13/60] i386/tdx: Validate TD attributes
Date: Tue,  5 Nov 2024 01:23:21 -0500
Message-Id: <20241105062408.3533704-14-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
fixed-1 bits must be set.

Besides, sanity check the attribute bits that have not been supported by
QEMU yet. e.g., debug bit, it will be allowed in the future when debug
TD support lands in QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>

---
Changes in v3:
- using error_setg() for error report; (Daniel)
---
 target/i386/kvm/tdx.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6cf81f788fe0..5a9ce2ada89d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,6 +20,7 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
@@ -141,13 +142,33 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
-static void setup_td_guest_attributes(X86CPU *x86cpu)
+static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
+{
+    if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
+            error_setg(errp, "Invalid attributes 0x%lx for TDX VM "
+                       "(supported: 0x%llx)",
+                       tdx->attributes, tdx_caps->supported_attrs);
+            return -1;
+    }
+
+    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
+        error_setg(errp, "Current QEMU doesn't support attributes.debug[bit 0] "
+                         "for TDX VM");
+        return -1;
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
@@ -211,7 +232,10 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
-    setup_td_guest_attributes(x86cpu);
+    r = setup_td_guest_attributes(x86cpu, errp);
+    if (r) {
+        return r;
+    }
 
     r = setup_td_xfam(x86cpu, errp);
     if (r) {
-- 
2.34.1


