Return-Path: <kvm+bounces-36526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A66B1A1B71E
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF47B160865
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A6D14A617;
	Fri, 24 Jan 2025 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FFW7MMch"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA2214A605
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725974; cv=none; b=TqwuLar7Hesjw03TiUPKNf5dHqKSCwjX2CI9Or4WGO8+YB6BQpKRTMX3zG5HwRDt9RFzZb/tPNriLjQkdwMHiXoWr7dYFUUragZjA9YoTwVM/HjSDY+qyPP44Oud8QdGWnMjOPY+V6RSq8odhQ21tytVIg4CN6N8Os+/RdS0AME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725974; c=relaxed/simple;
	bh=XEwqmQoSvwYMfkPqc6TzR0UgP5NnIAttqomtt/9PTFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J4CDzmJ2jAM/JtTZZ4Ld9wTbDHt3BC8VGoYxsGOVNfaKxWDzoSN5Pl/gXN55vlO8X18SLlWni0kilOddsgj57f4sLv6JI2pZoyNLHdgtNQTtU/Q6dTd+H96mJfVHjMitTZrefg/D65WhTtCL/JQ/MMejVADw1dskJ/m3IyQxXV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FFW7MMch; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725974; x=1769261974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XEwqmQoSvwYMfkPqc6TzR0UgP5NnIAttqomtt/9PTFQ=;
  b=FFW7MMchctz+MDlUNosUDa0Cp80fafzNyZTkLpCrWlIMVUnWLP+R2PXr
   aqk4gt1WDaV+mIVf2Xv050MXyxS7JG00Z9lgNTTvWkRBrMF43NmOHHjEM
   c+pcD4ExrbQ0lIKA1s4p0sDko5flFk+3Q75wSXnUgD2ucvLLIRJlXDf2n
   rzBlRznqJockyRKbMF02FcvnvnnNlNXJEdzAGASWWsZftv+Pu8px740Hi
   Zrtokwnd+xxQJtkxvnH2zcwChBinxJHvpi3gkI9f1ESYtx/EQ63R3Fc5v
   oam3Gl1Y4YtiGXUP+czovJlugq8/+s4jtJApGfVnmb//z762KFHRITjou
   A==;
X-CSE-ConnectionGUID: uIXUN9AwSPupRG31XiZ5fw==
X-CSE-MsgGUID: pc5L8uqcSiKrgKcPFN+3GQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246551"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246551"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:33 -0800
X-CSE-ConnectionGUID: e6jGRyZ/TK+fefS8MicOpQ==
X-CSE-MsgGUID: gNS9RrQUStOtIANF8dwOFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804442"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:29 -0800
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
Subject: [PATCH v7 40/52] i386/cgs: Rename *mask_cpuid_features() to *adjust_cpuid_features()
Date: Fri, 24 Jan 2025 08:20:36 -0500
Message-Id: <20250124132048.3229049-41-xiaoyao.li@intel.com>
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

Because for TDX case, there are also fixed-1 bits that enfored by TDX
module.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/confidential-guest.h | 20 ++++++++++----------
 target/i386/kvm/kvm.c            |  2 +-
 target/i386/sev.c                |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index a86c42a47558..777d43cc9688 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -40,8 +40,8 @@ struct X86ConfidentialGuestClass {
     /* <public> */
     int (*kvm_type)(X86ConfidentialGuest *cg);
     void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
-    uint32_t (*mask_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
-                                    int reg, uint32_t value);
+    uint32_t (*adjust_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature,
+                                      uint32_t index, int reg, uint32_t value);
 };
 
 /**
@@ -71,21 +71,21 @@ static inline void x86_confidential_guest_cpu_instance_init(X86ConfidentialGuest
 }
 
 /**
- * x86_confidential_guest_mask_cpuid_features:
+ * x86_confidential_guest_adjust_cpuid_features:
  *
- * Removes unsupported features from a confidential guest's CPUID values, returns
- * the value with the bits removed.  The bits removed should be those that KVM
- * provides independent of host-supported CPUID features, but are not supported by
- * the confidential computing firmware.
+ * Adjust the supported features from a confidential guest's CPUID values,
+ * returns the adjusted value.  There are bits being removed that are not
+ * supported by the confidential computing firmware or bits being added that
+ * are forcibly exposed to guest by the confidential computing firmware.
  */
-static inline int x86_confidential_guest_mask_cpuid_features(X86ConfidentialGuest *cg,
+static inline int x86_confidential_guest_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                                              uint32_t feature, uint32_t index,
                                                              int reg, uint32_t value)
 {
     X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
 
-    if (klass->mask_cpuid_features) {
-        return klass->mask_cpuid_features(cg, feature, index, reg, value);
+    if (klass->adjust_cpuid_features) {
+        return klass->adjust_cpuid_features(cg, feature, index, reg, value);
     } else {
         return value;
     }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4078ba40473e..fa46edaeac8d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -573,7 +573,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
     }
 
     if (current_machine->cgs) {
-        ret = x86_confidential_guest_mask_cpuid_features(
+        ret = x86_confidential_guest_adjust_cpuid_features(
             X86_CONFIDENTIAL_GUEST(current_machine->cgs),
             function, index, reg, ret);
     }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0e1dbb6959ec..a6c0a697250b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -946,7 +946,7 @@ out:
 }
 
 static uint32_t
-sev_snp_mask_cpuid_features(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
+sev_snp_adjust_cpuid_features(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
                             int reg, uint32_t value)
 {
     switch (feature) {
@@ -2404,7 +2404,7 @@ sev_snp_guest_class_init(ObjectClass *oc, void *data)
     klass->launch_finish = sev_snp_launch_finish;
     klass->launch_update_data = sev_snp_launch_update_data;
     klass->kvm_init = sev_snp_kvm_init;
-    x86_klass->mask_cpuid_features = sev_snp_mask_cpuid_features;
+    x86_klass->adjust_cpuid_features = sev_snp_adjust_cpuid_features;
     x86_klass->kvm_type = sev_snp_kvm_type;
 
     object_class_property_add(oc, "policy", "uint64",
-- 
2.34.1


