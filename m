Return-Path: <kvm+bounces-36523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5B9A1B717
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CAA21883AD1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5018F78F51;
	Fri, 24 Jan 2025 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oC0Yj0D5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7607080B
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725963; cv=none; b=N7wgoWN2oSPwNYm61sVMj69WxquMD/YWtH7gDXAOBRv/6GhQmo7aGHOxXvUg6WxxGYmTicQF9Y5XMVp7RzOa6+Ea2O57Kg9fyB5RqhNxL9X6gpg2irKI1N2goT11qvQr8DL1cdC0vVeDVWObHMLiUrpqoJjn61EGxF1R6MfCIvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725963; c=relaxed/simple;
	bh=1ZBokcORlkGr+ynt1gqXnRjHyyHWXe5wnMVgE1+YOYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TJTI39TWYKF3UfF4w58z3X0wZv07W48ztefGQ6OtXHdyG8LFDbvdgDDJNFfmzG7QB1GITsjSGbjTYiFsp3wQeTCVDK7hlnkyjeRalT5eGzFeF6DeYwk/r/tCyoxJmA4+OKDRzoSqVodGJoJPXt1wslhYE3il86TuCSO+1vZKTH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oC0Yj0D5; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725962; x=1769261962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ZBokcORlkGr+ynt1gqXnRjHyyHWXe5wnMVgE1+YOYs=;
  b=oC0Yj0D5yHl8AXSTE7SUNlPcrX1FhPgRQBtt+VgCqcpt1Jn/dmeNjr+g
   Y0WhUzm1Cqz7qq6mT9krdzQf/x8PY03jvdO54q5e09JtqLKne/xCgFF0L
   huoMdGJw4u59SXD3fI9oKRVPfShK20D/nyL5CHZLUdGccp0RlEr0DAMqB
   T/Yl1prt/+j8Fd/5R/EINbj8UUmHRNYltlsSnI9uVvoTHrj2KJ+DtKDj4
   smpZPPCu55jEwhkEX+V+u96PcIn5Z3/hUW/syar1+UK2qUOprzhG5jBuA
   v1txNjOX6xOUu9NfbXmEK9sFu22r7yWAh88baxG3aZSWQNm1cR3ciRd50
   g==;
X-CSE-ConnectionGUID: l73uePjxSWup7s/3jNmTkA==
X-CSE-MsgGUID: cEPYSzQISgeDWTjRCJR/5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246522"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246522"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:22 -0800
X-CSE-ConnectionGUID: L2y8dTvzTU2ddyE9ud9+fA==
X-CSE-MsgGUID: 5GNqz6pFR1uKwKz6iRg36Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804419"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:18 -0800
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
Subject: [PATCH v7 37/52] i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
Date: Fri, 24 Jan 2025 08:20:33 -0500
Message-Id: <20250124132048.3229049-38-xiaoyao.li@intel.com>
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

For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
by VMM, while the features enumerated/controlled by other MSRs except
MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.

Only configure MSR_IA32_UCODE_REV for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 44 ++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ead1d0263385..4078ba40473e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3863,32 +3863,34 @@ static void kvm_init_msrs(X86CPU *cpu)
     CPUX86State *env = &cpu->env;
 
     kvm_msr_buf_reset(cpu);
-    if (has_msr_arch_capabs) {
-        kvm_msr_entry_add(cpu, MSR_IA32_ARCH_CAPABILITIES,
-                          env->features[FEAT_ARCH_CAPABILITIES]);
-    }
-
-    if (has_msr_core_capabs) {
-        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
-                          env->features[FEAT_CORE_CAPABILITY]);
-    }
-
-    if (has_msr_perf_capabs && cpu->enable_pmu) {
-        kvm_msr_entry_add_perf(cpu, env->features);
+
+    if (!is_tdx_vm()) {
+        if (has_msr_arch_capabs) {
+            kvm_msr_entry_add(cpu, MSR_IA32_ARCH_CAPABILITIES,
+                                env->features[FEAT_ARCH_CAPABILITIES]);
+        }
+
+        if (has_msr_core_capabs) {
+            kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
+                                env->features[FEAT_CORE_CAPABILITY]);
+        }
+
+        if (has_msr_perf_capabs && cpu->enable_pmu) {
+            kvm_msr_entry_add_perf(cpu, env->features);
+        }
+
+        /*
+         * Older kernels do not include VMX MSRs in KVM_GET_MSR_INDEX_LIST, but
+         * all kernels with MSR features should have them.
+         */
+        if (kvm_feature_msrs && cpu_has_vmx(env)) {
+            kvm_msr_entry_add_vmx(cpu, env->features);
+        }
     }
 
     if (has_msr_ucode_rev) {
         kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
     }
-
-    /*
-     * Older kernels do not include VMX MSRs in KVM_GET_MSR_INDEX_LIST, but
-     * all kernels with MSR features should have them.
-     */
-    if (kvm_feature_msrs && cpu_has_vmx(env)) {
-        kvm_msr_entry_add_vmx(cpu, env->features);
-    }
-
     assert(kvm_buf_set_msrs(cpu) == 0);
 }
 
-- 
2.34.1


