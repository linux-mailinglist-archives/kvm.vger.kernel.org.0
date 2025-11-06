Return-Path: <kvm+bounces-62165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07108C3A348
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 11:23:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DFB81A47271
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 10:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124C7313269;
	Thu,  6 Nov 2025 10:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYLUK4eS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFFE2DC784;
	Thu,  6 Nov 2025 10:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762423773; cv=none; b=aDcT/p6/bGIAllr48HLh4CpJc8gd56DzDK82/aU4YDGneJJAI/3K1475uUCVD32YYr+3AMTrM72w2AHjU9Uk5+5Cy4H2LGgZ7IlQTVeCh3uVnmbDKXRRQFiLhJ+XJRGUiUJ4HH4FbTbJFmbC5dz751IecFrMUmG7+t/upU3RL08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762423773; c=relaxed/simple;
	bh=H2SNqHuTgmxJrrhJpWRRVpG1pyyTjyevFP2IE6kgncA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ryD986ev+lu0ENjD65b7M+SwTKh4FBJjIuWG3CkpM/yuFiIuIlAPAPmwkZh3nVCAkp8kpOtX8sWh5hgHzqpAsiIObzHTVyepmNRJEktv1ctHTkIHkIW5AxCd031c+TWdpXv5D7U65RnvE0ekqGE+gBH0Ecipiz2eMdcAIK3eo3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eYLUK4eS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762423772; x=1793959772;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H2SNqHuTgmxJrrhJpWRRVpG1pyyTjyevFP2IE6kgncA=;
  b=eYLUK4eSgHeVqWOkO5e5pHHScqzA0MN6dlqWEgbHZ3eahEbZy05aDEGJ
   ALZeAKyV1gecPpQgqWeY/Aaie1tEZdiB6EWyO9EMS+v2F0aSJQXozh6iT
   TMdP24kM58l7LpVr/XHZgEXcNOYk6z4VLOHeyACaaXTxvHkyGHbiQmrSH
   +JW9Zrp9o6/9mvRbBFvZt4Nm3cXS6Wda+nUHt+qtb12uCl+/3ICkQtYbk
   iD/7ly7yq8kVrONj7emAV1FG0fjNZ8yzD+HgdD+WupJLtoBJeJUVq/lab
   zABmnkh3uHLaitcGUtO9VYyyP5gyqd85u2BmZQbjaYfgEyF6XPPEAcpJZ
   A==;
X-CSE-ConnectionGUID: whegdeHnQvydarxGyN6dRA==
X-CSE-MsgGUID: wu69TjalTq26ycKNJ83qyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="82186406"
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="82186406"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 02:09:31 -0800
X-CSE-ConnectionGUID: M/kPqBTQQMG8Vgsma1BV+w==
X-CSE-MsgGUID: kR4W3VKWQuu4D6YPpvMx4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="187007555"
Received: from litbin-desktop.sh.intel.com ([10.239.159.60])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 02:09:29 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH] KVM: x86: Add a help to dedup loading guest/host XCR0 and XSS
Date: Thu,  6 Nov 2025 18:11:38 +0800
Message-ID: <20251106101138.2756175-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add and use a helper, kvm_load_xfeatures(), to dedup the code that loads
guest/host xfeatures by passing XCR0 and XSS values accordingly.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
The patch is based on the patch series
"KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling" [1], which is applied on 
top of kvm-x86 next branch(commit a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a).

[1] https://lore.kernel.org/all/20251030224246.3456492-1-seanjc@google.com
---
 arch/x86/kvm/x86.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8df02a083b2..35fc1333e198 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1203,33 +1203,18 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lmsw);
 
-static void kvm_load_guest_xfeatures(struct kvm_vcpu *vcpu)
+static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, u64 xcr0, u64 xss)
 {
 	if (vcpu->arch.guest_state_protected)
 		return;
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
 		if (vcpu->arch.xcr0 != kvm_host.xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
+			xsetbv(XCR_XFEATURE_ENABLED_MASK, xcr0);
 
 		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
 		    vcpu->arch.ia32_xss != kvm_host.xss)
-			wrmsrq(MSR_IA32_XSS, vcpu->arch.ia32_xss);
-	}
-}
-
-static void kvm_load_host_xfeatures(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.guest_state_protected)
-		return;
-
-	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-		if (vcpu->arch.xcr0 != kvm_host.xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
-
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
-		    vcpu->arch.ia32_xss != kvm_host.xss)
-			wrmsrq(MSR_IA32_XSS, kvm_host.xss);
+			wrmsrq(MSR_IA32_XSS, xss);
 	}
 }
 
@@ -11310,7 +11295,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrq(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	kvm_load_guest_xfeatures(vcpu);
+	kvm_load_xfeatures(vcpu, vcpu->arch.xcr0, vcpu->arch.ia32_xss);
 
 	if (unlikely(vcpu->arch.switch_db_regs &&
 		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
@@ -11406,7 +11391,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_load_host_xfeatures(vcpu);
+	kvm_load_xfeatures(vcpu, kvm_host.xcr0, kvm_host.xss);
 
 	/*
 	 * Sync xfd before calling handle_exit_irqoff() which may

base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
prerequisite-patch-id: 9aafd634f0ab2033d7b032e227d356777469e046
prerequisite-patch-id: 656ce1f5aa97c77a9cf6125713707a5007b2c7ba
prerequisite-patch-id: d6328b8c0fdb8593bb534ab7378821edcf9f639d
prerequisite-patch-id: c7f36d1cedc4ae6416223d2225460944629b3d4f
-- 
2.46.0


