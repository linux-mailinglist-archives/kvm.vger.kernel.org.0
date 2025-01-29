Return-Path: <kvm+bounces-36828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0D0A21A95
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71A477A1094
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 09:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDF21B423B;
	Wed, 29 Jan 2025 09:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmXsVM7I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41741AE005;
	Wed, 29 Jan 2025 09:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144793; cv=none; b=XyY5n03K/RFoP+8KgR2bchnrpTVnlD9F2agb5QD1o1fMv7bKu5gFJJZUS7J2TA1/3CWmY0ymWQN613QOnp63RGAudDyJ348KJF0P1YJmG/iRRo9CqjFRPq+AICJEnLf+ygOW1iKmVf4TLggKTK5zW8r9dh+CMjF7VNkoift9Bho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144793; c=relaxed/simple;
	bh=n+Q6EGUmpUH8fNKUFT8UiTcL8EopaupqREmb3UuQXPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L211SR77Rm494HsptHG4IZzXyNuJXUXjvaULHeWtZj+xLRGlObhjjunt5RJQ8v/lUo4XCZFX+Au0FgHGqKfhYzyW9T4kvIzEpw1TMGEHBzhsBolAUeQi4kW4qKvsBqMFgbwShyWv1aadYLrpWULuAsdugjkj8saeVSPiBoEj5l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AmXsVM7I; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144792; x=1769680792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n+Q6EGUmpUH8fNKUFT8UiTcL8EopaupqREmb3UuQXPo=;
  b=AmXsVM7IUEPBVEuEvSMpVFomL5MgOJILoa9DFgSxyxjhUufZgep3Hm8Z
   Lijn6SyT+TOS/H+aYxvx5RE/h1u3hcL3qXXNiN1NPXEBrKXpjPROpsbBA
   pDYk0NPvholX65bAyIRX2IWjKSYD0/j9rZay42tYpJ3rtiPOuYQ/ir421
   aFEz1OiZzyXLHo1gKwL0ZYPS6id4/w/s0qtQ2VUEsrJZvtdkp7ZGQmwva
   bAI7aIkJOgIfmcCQI5Kfwr371tECY+W3iGXnpqop+G5V/uZU15QHCrUTG
   +lda1KnF6SW3O5XSQ+CnnDZm7rgP6LDzX+2d29PmDy6RVszpKO5OHCZZe
   A==;
X-CSE-ConnectionGUID: 7xeyoXgqTVWfkUzUIJWWLA==
X-CSE-MsgGUID: HOan9eIdSyOWtB0Ws6GqWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50035991"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50035991"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:29 -0800
X-CSE-ConnectionGUID: 94/HuDFFR3m9H4ywczsHqQ==
X-CSE-MsgGUID: m3EY/jQ0RLSAZ1+0RGMEYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262652"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:25 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 02/12] KVM: x86: Allow the use of kvm_load_host_xsave_state() with guest_state_protected
Date: Wed, 29 Jan 2025 11:58:51 +0200
Message-ID: <20250129095902.16391-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Allow the use of kvm_load_host_xsave_state() with
vcpu->arch.guest_state_protected == true. This will allow TDX to reuse
kvm_load_host_xsave_state() instead of creating its own version.

For consistency, amend kvm_load_guest_xsave_state() also.

Ensure that guest state that kvm_load_host_xsave_state() depends upon,
such as MSR_IA32_XSS, cannot be changed by user space, if
guest_state_protected.

[Adrian: wrote commit message]

Link: https://lore.kernel.org/r/Z2GiQS_RmYeHU09L@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
 - New patch
---
 arch/x86/kvm/svm/svm.c |  7 +++++--
 arch/x86/kvm/x86.c     | 18 +++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..b4bcfe15ad5e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4253,7 +4253,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		svm_set_dr6(svm, DR6_ACTIVE_LOW);
 
 	clgi();
-	kvm_load_guest_xsave_state(vcpu);
+
+	if (!vcpu->arch.guest_state_protected)
+		kvm_load_guest_xsave_state(vcpu);
 
 	kvm_wait_lapic_expire(vcpu);
 
@@ -4282,7 +4284,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
-	kvm_load_host_xsave_state(vcpu);
+	if (!vcpu->arch.guest_state_protected)
+		kvm_load_host_xsave_state(vcpu);
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbb6b7f40b3a..5cf9f023fd4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1169,11 +1169,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.guest_state_protected)
-		return;
+	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-
 		if (vcpu->arch.xcr0 != kvm_host.xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 
@@ -1192,13 +1190,11 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.guest_state_protected)
-		return;
-
 	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
-		vcpu->arch.pkru = rdpkru();
+		if (!vcpu->arch.guest_state_protected)
+			vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
 			wrpkru(vcpu->arch.host_pkru);
 	}
@@ -3916,6 +3912,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
+
+		if (vcpu->arch.guest_state_protected)
+			return 1;
+
 		/*
 		 * KVM supports exposing PT to the guest, but does not support
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
@@ -4375,6 +4375,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
+
+		if (vcpu->arch.guest_state_protected)
+			return 1;
+
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
 	case MSR_K7_CLK_CTL:
-- 
2.43.0


