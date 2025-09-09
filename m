Return-Path: <kvm+bounces-57077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CBF9B4A873
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DDB716E8D0
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8275A30B50C;
	Tue,  9 Sep 2025 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OMjtXKKZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E383081A4;
	Tue,  9 Sep 2025 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410806; cv=none; b=rlrJCWLgO9ZLHZHmFDfNkFV9zqiJPiNRhhb/tmeAxEGuGUOF/l47D9VQ86OtqKctT8587KtRrficphglySCq4tNcQa+hTpY3Z1M/Qy1S0eGvoGfdzX7IUwVjZ2VOvyck62FgssC8IUQRSDnBGTzS3l48L91/cyi5lrgQVLQVuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410806; c=relaxed/simple;
	bh=KOFFeBEs7QhCsltveRbSIhh4fed0gwK98txg6TSwRys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBAs4yRsuCxk2njxbqTVwNtYtNUNO4tJMo+z025rSklM/6o6iTTOPWgqkNVB6Ew97DpJ3iADklF5pxNeiH3VLD8bpgiWYCtZcSicCFnG28XErXadccKGOdMRSE9maHawJF0tcqTqSeU67ahWlxKs2+eX44Uw3fV8HpUoNfl+nMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OMjtXKKZ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410804; x=1788946804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KOFFeBEs7QhCsltveRbSIhh4fed0gwK98txg6TSwRys=;
  b=OMjtXKKZvZPG0szpYs8TtBkvGyqSEeCWyXwCKV5ooY3tQRHMDMdM1fP8
   gnNb8QsNke/1RyXpxU81ndYWgkoNiCcjXniQkPLrZWgwRR3S3UyC71Kew
   hwJkJSSvYv0rwmB2qMrVfExOM2eqpHRCRuJhVSsM4+0CL1by16iJCiJD0
   ou7gIg8slf8cOTIjPSIra2lbjuRmPvPdTOv79ESOsrU7bN/vXu2EyWzqe
   39EH9LR5tAT9nEUZ39oAEYucCjhx9h0rKsEF3VeeiNnnFpyX5wcbOs6qF
   sgzZXCjaw5hh6ytvxwCE3hEPiSmF0xSKQWlmKIfWTGxAyRcEYDnTwAIAM
   g==;
X-CSE-ConnectionGUID: ACKrvq/qRgOFuBkbBj+jqg==
X-CSE-MsgGUID: lNIUh4yBTwy/r4WzigLiPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307279"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307279"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
X-CSE-ConnectionGUID: IW6j0dD0S4SFl8Nv2dpDhw==
X-CSE-MsgGUID: 5ImhtPHrTbWfzrOuSBUYvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207424"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 13/22] KVM: VMX: Set up interception for CET MSRs
Date: Tue,  9 Sep 2025 02:39:44 -0700
Message-ID: <20250909093953.202028-14-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Enable/disable CET MSRs interception per associated feature configuration.

Pass through CET MSRs that are managed by XSAVE, as they cannot be
intercepted without also intercepting XSAVE. However, intercepting XSAVE
would likely cause unacceptable performance overhead.
MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.

Note, this MSR design introduced an architectural limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectural perspective since IBT relies on subset of SHSTK
relevant MSRs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 22bd71bebfad..70f5a9e05cec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4102,6 +4102,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	bool intercept;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
@@ -4147,6 +4149,23 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, intercept);
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+			    !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.47.3


