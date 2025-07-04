Return-Path: <kvm+bounces-51576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B47F3AF8CD7
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40117188DC63
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0349E2EF662;
	Fri,  4 Jul 2025 08:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KDsUEzpW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4ED2EAB8E;
	Fri,  4 Jul 2025 08:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619046; cv=none; b=DOXKka3M/1B0bEdKEKKpIPV4dSJU1fogDv5QNVBw+ij0G1jwbjTUgak2i8rAksgSwc60FoPl8yPPAvQHuVoN4b7/AHRCqwJTdtR7VfieMRaqINQ2b0wem/46rD4HpMkx0LahCvL2ekhqoUlnlttn3Pe+6Ey7KHu4bVtCRTHo0i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619046; c=relaxed/simple;
	bh=98vuOCysWdJ2QYOUNSigU8h74tYMIrI+T4QAEb4AP6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+C6C3yTtQ0+B6ovUmwQxtAN9BLJCFUNXQgvaRC7fQ/Jee6Tj65+BkBZcbrftGS17GlOaWMULp3DEmcdOAmZbq1FVcI2CJ9DhFxoj3rEoEbGi76HvnnKk5P4trhorcxObe8OFQHW8HWOhJ1Yp9oQIhRppwyMz5JxEMsx+91BefE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KDsUEzpW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619044; x=1783155044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=98vuOCysWdJ2QYOUNSigU8h74tYMIrI+T4QAEb4AP6w=;
  b=KDsUEzpWLDGrJFNEFPR5vbHZTqaJUeEzDWan2aT4EYAlCXy1ywnPsin2
   4Hs82rPbiL0bgTHxqihk4GieGyF1CS16Q6zw4HHVwIEIqxkJf1nP3Rm8/
   IHAmalvqgE0t7tBFRAex69xK3Q9klDrfjM3SJ5YbSFvevylL+XFiqtDg6
   5jx5p1pvL0nj1e8eXsECljHE2fbdAfHg3XDggfDkeNRqCxysEPL8onwwL
   A4GLHPEE49WCWLUfy1I1NhaMPmLSjnw0jmKLTWu4vur1PMbH9Xq+Q7cs5
   eOHOlohpE3pDtn3EQARk7BFmyatZdKn6Dv5dDo4LB4YTIkYieFONBwdw8
   g==;
X-CSE-ConnectionGUID: AwAmnHVWQzm6o3erCnf6+g==
X-CSE-MsgGUID: o+E5n0wJR/u6KYwSj08//w==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391637"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391637"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:38 -0700
X-CSE-ConnectionGUID: QRUGIg2LQC6jPueEouF8hA==
X-CSE-MsgGUID: Uw+luuTeQb2cfgDlp3GKXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721970"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:38 -0700
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
Subject: [PATCH v11 08/23] KVM: x86: Initialize kvm_caps.supported_xss
Date: Fri,  4 Jul 2025 01:49:39 -0700
Message-ID: <20250704085027.182163-9-chao.gao@intel.com>
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

Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
XSAVES is supported. host_xss contains the host supported xstate feature
bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
enabled XSS feature bits, the resulting value represents the supervisor
xstates that are available to guest and are backed by host FPU framework
for swapping {guest,host} XSAVE-managed registers/MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd984c6acae5..fcbb4566b4c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -220,6 +220,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
@@ -9892,14 +9894,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
+		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
+	}
+
 	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
-
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-- 
2.47.1


