Return-Path: <kvm+bounces-51570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF84AF8DA3
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59F3FB65847
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD1829AB1B;
	Fri,  4 Jul 2025 08:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EWxXi7b4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBBB286893;
	Fri,  4 Jul 2025 08:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619040; cv=none; b=bB2S3tC//nbAQ2549sspS5LJpUmCs3bHbaMXO8nPH95n4aFvSOnv05VvJFJTczafAQd21Ch7Y1cLNVXSe2rPWAPTRWxgyqBT9UUhW8RTt+FUks4Tk8y0hRaq8jIoO8mJ6YMXcDhUH8oWwZZh+pbcNSOvAIKKxWfdn0Yo/YDFGcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619040; c=relaxed/simple;
	bh=8jywZyXwSWHJQSDuzcjywjVNbHBLbTMBVffz5enZTwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2O/qvtOFowwOuKjdO9vGuyZPo28kIEwVHf4M7Z4M6k12gMMrN92Ju9ti2mrW26R0wUO/xCP1rl/jK/pR28J6u47iPIMnXqgjkqsHhUuXJRWXP6DBI0bN7om7yRo95Cjjyne+v/7iF7aeoOFXnqpkSBOPaQpyPxk78JPt2eULP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EWxXi7b4; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619039; x=1783155039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8jywZyXwSWHJQSDuzcjywjVNbHBLbTMBVffz5enZTwA=;
  b=EWxXi7b4+8Uf4FQzm8wTxkcoIl5EWsg0YEFF3dWM5BGoz87ApqT6MJBK
   nrl6WCr0vh7eRIiG00ORuy0A16shdcqoZ2OS5/xux8FU9V9TMyLx/nltA
   lZaVh3zGX+83L4rf1aX/CMecWmzsRWe0Zlun2w3PoNTd64DflxcqhdDyI
   jGglZCznMoVMqu79RZGg7xslgCsgzXTbMmD0X5xgal7V4AB9Fubs4YoNk
   OzkhPt9P3kkqGbeDioH7wgAZTbh34V0Wt0Qq0fydQnVJDkhHewrB7Xxbb
   5GeQDKowYyU94F2GfLtJ8ZdVgnbisFDB7ra2CmCWExeXsosoZi6M4NUg1
   g==;
X-CSE-ConnectionGUID: 3LW08TkCTrGMiCq623uDEQ==
X-CSE-MsgGUID: y5Rli4y2Rs+iHQdG4AN7qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391587"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391587"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:36 -0700
X-CSE-ConnectionGUID: po46PB+lQL2v4umbbn3Sqg==
X-CSE-MsgGUID: WhAhk9mhSu2lZPZDL3q9uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721952"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:36 -0700
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
Subject: [PATCH v11 03/23] KVM: x86: Manually clear MPX state only on INIT
Date: Fri,  4 Jul 2025 01:49:34 -0700
Message-ID: <20250704085027.182163-4-chao.gao@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Don't manually clear/zero MPX state on RESET, as the guest FPU state is
zero allocated and KVM only does RESET during vCPU creation, i.e. the
relevant state is guaranteed to be all zeroes.

Opportunistically move the relevant code into a helper in anticipation of
adding support for CET shadow stacks, which also has state that is zeroed
on INIT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51b37492142c..c956b36314fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12517,6 +12517,35 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvfree(vcpu->arch.cpuid_entries);
 }
 
+static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
+
+	/*
+	 * Guest FPU state is zero allocated and so doesn't need to be manually
+	 * cleared on RESET, i.e. during vCPU creation.
+	 */
+	if (!init_event || !fpstate)
+		return;
+
+	/*
+	 * On INIT, only select XSTATE components are zeroed, most components
+	 * are unchanged.  Currently, the only components that are zeroed and
+	 * supported by KVM are MPX related.
+	 */
+	if (!kvm_mpx_supported())
+		return;
+
+	/*
+	 * All paths that lead to INIT are required to load the guest's FPU
+	 * state (because most paths are buried in KVM_RUN).
+	 */
+	kvm_put_guest_fpu(vcpu);
+	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
+	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+	kvm_load_guest_fpu(vcpu);
+}
+
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_cpuid_entry2 *cpuid_0x1;
@@ -12574,22 +12603,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
-		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
-
-		/*
-		 * All paths that lead to INIT are required to load the guest's
-		 * FPU state (because most paths are buried in KVM_RUN).
-		 */
-		if (init_event)
-			kvm_put_guest_fpu(vcpu);
-
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
-
-		if (init_event)
-			kvm_load_guest_fpu(vcpu);
-	}
+	kvm_xstate_reset(vcpu, init_event);
 
 	if (!init_event) {
 		vcpu->arch.smbase = 0x30000;
-- 
2.47.1


