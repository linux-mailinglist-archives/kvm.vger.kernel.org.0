Return-Path: <kvm+bounces-37789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB864A301D2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:57:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 065557A2F03
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C42F1D5CFE;
	Tue, 11 Feb 2025 02:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ak3jo+/G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37891D5178;
	Tue, 11 Feb 2025 02:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242633; cv=none; b=OSQVAUPMI63SjtBBTWSw5rwO625QBMWqXP1OIZ6QpOToN21BlodmdeiKYMqMS4DK4ba1krM+Brg0r8aHfNQOVCt3BAspESosKUSgAKsdS3cBfb7s6ZNBxJlGpz2LKhdss3EFR38s1VZd9QyrqRGQJfQVSEBpJ5d5GqP3jD29eCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242633; c=relaxed/simple;
	bh=V1iJLe8wImdK0toiut9YkwUhhYvNwcKXcvVcNaiUBj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfmucY8RuLnksn/EFeglq69IBSk95ptUwji4AWVeuTMqu0gN2yoeyq0nYwboAGWPjHMHnZOIcMcGIR1H00+md9lDL2uUQYmPSTWZxAaUxdmGovUgsbDLJ3pKk6yX72dCnFTpW1h58g93h5HM+iNhYsilQd+K61FIigbNnNVEvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ak3jo+/G; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242632; x=1770778632;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V1iJLe8wImdK0toiut9YkwUhhYvNwcKXcvVcNaiUBj4=;
  b=ak3jo+/GTveyTEa5aYt2HyJ2QvdKhexlgJ1mXLRgCJiri06ML5f9Iga8
   QPqnwISWy/c2dJMuBQqMoc2pXyqV4EIBOjdJTPdcAXIF2LoauSVi/7pVl
   Wgll7nusTKsSqEGbsFQdIOvV3mSG2aDsDYkyZSSPGTVZXVVKXiXmrwwub
   bCnEQzeUY2mZmu04lzX1IFOUfTBUlLjWmRpHxIbh5PX6ibTRqPFF/9CVY
   mYJ/wDyrihlxKfQEgA/3b/EP0hv5qK+y5j7OK0ygroSTkWgyQ2WtAvseC
   q2kp9x4+4tGqkmEaXFtn9k4Wua47cHzSOtEbsrgdYio+Kb8ZuGRhsH/Na
   A==;
X-CSE-ConnectionGUID: 3raS49ZpTfar3hJHhf0FDw==
X-CSE-MsgGUID: piKoXijxQWCYiTXq8nhg/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612438"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612438"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:10 -0800
X-CSE-ConnectionGUID: /3bZZr7rTxKCcy4G1ffWHg==
X-CSE-MsgGUID: xhFhitj5Tr+46eqeGxNF2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355254"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:56:54 -0800
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
Subject: [PATCH v2 02/17] KVM: TDX: Disable PI wakeup for IPIv
Date: Tue, 11 Feb 2025 10:58:13 +0800
Message-ID: <20250211025828.3072076-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
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
index 6940ce812730..825f13371134 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -669,6 +669,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
+	INIT_LIST_HEAD(&tdx->vt.pi_wakeup_list);
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
-- 
2.46.0


