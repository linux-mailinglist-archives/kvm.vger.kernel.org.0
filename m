Return-Path: <kvm+bounces-51584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E559FAF8CE3
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E17171C46675
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0002868A9;
	Fri,  4 Jul 2025 08:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RXY3RNGu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D582F2C7A;
	Fri,  4 Jul 2025 08:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619051; cv=none; b=Mo5ZzoRGaUcQ7bUAUScxG7Hve1DSIWieEl+Y3Oyu+00Lu7kw1bku2tw3CPOnyfdVP9mgWliZ8O5K1rUGKZ0hwqewmGMuqPpYuuyBQbh8zxdYJVdKSHYDzhv+iBAV7RSLKErePxPM/z2m5jSgHe38cb/kyh2UJ+IG5KcztH6sSf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619051; c=relaxed/simple;
	bh=hZaCVTIfeV/I/bo9IvJw08qW8++f+STwV811Jj7U+J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEFct/NKNGBeMECYsWxmG7jP+otkvad5+/QrcRHrfkhPIWXu3Ue//91MSI5M7iTZwkNkG4Qzy/NnJomIrH8ZI12Nj8z5PkKngpZsUFmiAMXdYG33KWrPUq3Ct3BPxU0Mka8QURmsOd+Qyf9zBhuDdAM4tOwIosVT+oZOrCxja5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RXY3RNGu; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619049; x=1783155049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZaCVTIfeV/I/bo9IvJw08qW8++f+STwV811Jj7U+J4=;
  b=RXY3RNGuc+/iTxjAJADEr1WD6DaPXsUMAdlmih8Js/OnG814eWZ6lisT
   z9X7aWlA6IYcH0njMRqvE3MTTTEtw7e6tPHRC4geJU1wB5wkGPNPdCXcS
   enTIcb3lrdbwmu6ovFetek40uj7PH4K0LtzqVxaRlD9cuGrSQS3upg7c1
   /mKAG/uCwfY+rLp8cMkVogV+0sZMqXGt0oW+C2ddNIaYvux7OlQMu0IsV
   hB68HCgOkmIydLsYgltGx7q1xfTJVyjZi663Zm+cTsMKwGFPqsWoqzIad
   N8a5jgczyX/4ew+TsTKfSoR3d9m61dpLg0c5EFTzmMmM/rlVulhH4uGvC
   g==;
X-CSE-ConnectionGUID: hEht7CbwSp6B23q1uZCqxA==
X-CSE-MsgGUID: CjHzKgKzSialnnTcAIiN9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391718"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391718"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:42 -0700
X-CSE-ConnectionGUID: O5AklukPRu6q9Z1tXa1ueQ==
X-CSE-MsgGUID: /T3EeZzHREWiukrWL+BjjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154722001"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:42 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 16/23] KVM: VMX: Set up interception for CET MSRs
Date: Fri,  4 Jul 2025 01:49:47 -0700
Message-ID: <20250704085027.182163-17-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Enable/disable CET MSRs interception per associated feature configuration.

Shadow Stack feature requires all CET MSRs passed through to guest to make
it supported in user and supervisor mode while IBT feature only depends on
MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.

Note, this MSR design introduced an architectural limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectural perspective since IBT relies on subset of SHSTK
relevant MSRs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>

---
v11:
Rebase onto Sean's MSR cleanups.
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 136c77e91474..ba46c1dcdb9d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4084,6 +4084,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	bool set;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
@@ -4125,6 +4127,24 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, set);
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+		      !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, set);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.47.1


