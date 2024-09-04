Return-Path: <kvm+bounces-25818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6427096AF09
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E1DB1F25A12
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE8F12C530;
	Wed,  4 Sep 2024 03:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JktX4HVq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E328F824AC;
	Wed,  4 Sep 2024 03:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419679; cv=none; b=RahzvW0GYneEVg4rh10Aohqrc8ndmcsc9PK+ZDkhEGZx/GwzaBi0/uYCr3MRiAulxGKzIqggOHeGzEVldJhvyCALAHM1t9u5u44OQqTEQCqeZrgPxDAQyPpmN6hz/H8mqomtqdvXqnNBqXG872hZgz1OyxWrQ++L83dBmONDEh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419679; c=relaxed/simple;
	bh=U/Ua4SaeSzKMaUdpZlIQ2ga4XtLDXbBrIYvv9HJOes8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XW3wy98ugYbXoejJYN6w8hQ1MvAjk/XTCPcLxVr67nF4rxiXKFj3Smv61KH0/WHeZ5C2zt7ncFgIAzGCv8XrtiQD2mZK+Tb9rKvhoXzMNXZX9tQd0+66A4xpnhlLecj0Y5MpykcHPdeBg5XsC+5DQtazjo0wKB+NwUdEP5aZdRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JktX4HVq; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419678; x=1756955678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U/Ua4SaeSzKMaUdpZlIQ2ga4XtLDXbBrIYvv9HJOes8=;
  b=JktX4HVqK7VVQmtX3O7q852lYe6bzYRM5ln9WZLlphQxisjCejaP/JRN
   hrRB3fZl4xHF9TfeA47dJAChPghOtvmF9AS9w0sVyJkEqzqHuvR1BHZUl
   98X+64mRHwoh0TXHbUM1i+7zZYvEw2xxy3z1ZUo97xVG5KWRyIvpD/Nlt
   0jq6AhUdFWrZ05WUIIkXyZppD/1CNkNrL/Wc4zKuzbefnyi3pHYROC0an
   VSv9806E/KUs7LfkTWaFGybQvE/RQmMa5ffDUjoLsdc3jplgz8Sov+390
   WalzVrdelnwWlk8Ox01xgGUwTOIhbskShhRCv/aiHCLCX7ZiwM7TMY4H0
   A==;
X-CSE-ConnectionGUID: S998bzq2Rxun0l1mqjilkQ==
X-CSE-MsgGUID: DVnHPCrWR4egWQcRkE3E/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564682"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564682"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
X-CSE-ConnectionGUID: UwcCFA/ETMORdYJJXWN0wQ==
X-CSE-MsgGUID: w1ZEbwiQRva0aTclHnNZdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106295"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:06 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/21] KVM: TDX: Require TDP MMU and mmio caching for TDX
Date: Tue,  3 Sep 2024 20:07:40 -0700
Message-Id: <20240904030751.117579-11-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable TDX support when TDP MMU or mmio caching aren't supported.

As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
support for TDX isn't implemented.

TDX requires KVM mmio caching. Without mmio caching, KVM will go to MMIO
emulation without installing SPTEs for MMIOs. However, TDX guest is
protected and KVM would meet errors when trying to emulate MMIOs for TDX
guest during instruction decoding. So, TDX guest relies on SPTEs being
installed for MMIOs, which are with no RWX bits and with VE suppress bit
unset, to inject VE to TDX guest. The TDX guest would then issue TDVMCALL
in the VE handler to perform instruction decoding and have host do MMIO
emulation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Addressed Binbin's comment by massaging Isaku's updated comments and
   adding more explanations about instroducing mmio caching.
 - Addressed Sean's comments of v19 according to Isaku's update but
   kept the warning for MOVDIR64B.
 - Move code change in tdx_hardware_setup() to __tdx_bringup() since the
   former has been removed.
---
 arch/x86/kvm/mmu/mmu.c  | 1 +
 arch/x86/kvm/vmx/main.c | 1 +
 arch/x86/kvm/vmx/tdx.c  | 8 +++-----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 01808cdf8627..d26b235d8f84 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -110,6 +110,7 @@ static bool __ro_after_init tdp_mmu_allowed;
 #ifdef CONFIG_X86_64
 bool __read_mostly tdp_mmu_enabled = true;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+EXPORT_SYMBOL_GPL(tdp_mmu_enabled);
 #endif
 
 static int max_huge_page_level __read_mostly;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c9dfa3aa866c..2cc29d0fc279 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,6 +3,7 @@
 
 #include "x86_ops.h"
 #include "vmx.h"
+#include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 25c24901061b..0c08062ef99f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1474,16 +1474,14 @@ static int __init __tdx_bringup(void)
 	const struct tdx_sys_info_td_conf *td_conf;
 	int r;
 
+	if (!tdp_mmu_enabled || !enable_mmio_caching)
+		return -EOPNOTSUPP;
+
 	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_warn("MOVDIR64B is reqiured for TDX\n");
 		return -EOPNOTSUPP;
 	}
 
-	if (!enable_ept) {
-		pr_err("Cannot enable TDX with EPT disabled.\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
 	 * as making SEAMCALLs requires CPU being in post-VMXON state.
-- 
2.34.1


