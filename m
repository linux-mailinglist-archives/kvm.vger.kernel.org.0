Return-Path: <kvm+bounces-38940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73656A404E3
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B50440718
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AB61FF1BD;
	Sat, 22 Feb 2025 01:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gufCwx8V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BC41F8EEF;
	Sat, 22 Feb 2025 01:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188791; cv=none; b=T2vHErIc4A0y6RW0TMlM5AO2mNbjVbwYWsMDmJ8ASpYtf4pHrZranepI89gdcfjZVJxJguRDZCYxSuVeZ0rzJSCZ5YrbN2o6YQlV+Ic7ewRRWTtGt/SSBz7QvkNEzvAj8EZtziDeTc/YyYfdvUjSN5kHqBWZbssL3Yk8gwiqPiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188791; c=relaxed/simple;
	bh=uGv5kDAq2MG16uqMFDZWio6XTpqj0RRKijD5ikqAZIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mefhwelvvZf1gjVlaT5qeKOxOe7gf/6iQG6gCYL/ce08qnzSfVP99apfoZSWkB5CGtHPeARgMLx8ShCVgIWrAMFnfB57cQaVbncX28YbXiY3Eu8ziNt4qbWExmlR8dNS3gyS5ovHT2HQQnsUjYgdExujJwmKjHM0B0xHRnR5yyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gufCwx8V; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188790; x=1771724790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uGv5kDAq2MG16uqMFDZWio6XTpqj0RRKijD5ikqAZIU=;
  b=gufCwx8VCmrRrgoLu4P/LI/07J0VGBg8bcGC+r/mMWAGVqb8gHOGVTuf
   PiRDnmy26d+CDbUxl4AZwCWYdSX9PwG8yc2LtesMmnUxfKq/wPp4NRCCF
   EmhhzGDgfZsB8lO1S6eftyrik/TgMI98sQkUdkNbyCNsCjJh531q8yCQa
   U3SOl0hhz/077T6PQRJaploXNhwLcPS66qlNXPHS1zqq9uPh5MBwlH87n
   aezdWrW+nAqWrK+Ry7MmoNjI/xGyODfu/m9POAuOSmhjV1y5ruRRbqDM4
   wDnTTlzwgQFCp7yUgrdTv+Uuim7lPoC6KfwAU2M3vxo7JYaPJT8WNsL4G
   g==;
X-CSE-ConnectionGUID: 8ugEC8XpR1iUU2VdyDMdEA==
X-CSE-MsgGUID: zAwllo3QS5GWZ173aWfNKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449012"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449012"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:30 -0800
X-CSE-ConnectionGUID: 3VY3oIu2S3WAYs1FVMHGqA==
X-CSE-MsgGUID: LxQ5XoV1QtmRlMLH7uiXlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621610"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:27 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 02/16] KVM: TDX: Disable PI wakeup for IPIv
Date: Sat, 22 Feb 2025 09:47:43 +0800
Message-ID: <20250222014757.897978-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable PI wakeup for IPI virtualization (IPIv) case for TDX.

When a vCPU is being scheduled out, notification vector is switched and
pi_wakeup_handler() is enabled when the vCPU has interrupt enabled and
posted interrupt is used to wake up the vCPU.

For VMX, a blocked vCPU can be the target of posted interrupts when using
IPIv or VT-d PI.  TDX doesn't support IPIv, disable PI wakeup for IPIv.
Also, since the guest status of TD vCPU is protected, assume interrupt is
always enabled for TD. (PV HLT hypercall is not support yet, TDX guest
tells VMM whether HLT is called with interrupt disabled or not.)

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: split into new patch]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v3:
- No change.

TDX interrupts v2:
- "KVM: VMX: Remove use of struct vcpu_vmx from posted_intr.c" is dropped
  because the related fields have been moved to the common struct vcpu_vt
  already. Move the pi_wakeup_list init to this patch.

TDX interrupts v1:
- This is split out as a new patch from patch
  "KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c"
---
 arch/x86/kvm/vmx/posted_intr.c | 7 +++++--
 arch/x86/kvm/vmx/tdx.c         | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5696e0f9f924..25f8a19e2831 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -11,6 +11,7 @@
 #include "posted_intr.h"
 #include "trace.h"
 #include "vmx.h"
+#include "tdx.h"
 
 /*
  * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
@@ -190,7 +191,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
 	 * notification vector is switched to the one that calls
 	 * back to the pi_wakeup_handler() function.
 	 */
-	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
+	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
+		vmx_can_use_vtd_pi(vcpu->kvm);
 }
 
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
@@ -200,7 +202,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
+	if (kvm_vcpu_is_blocking(vcpu) &&
+	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
 		pi_enable_wakeup_handler(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fdc8732ba7a3..b52a8a6a7838 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -664,6 +664,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
+	INIT_LIST_HEAD(&tdx->vt.pi_wakeup_list);
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
-- 
2.46.0


