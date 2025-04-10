Return-Path: <kvm+bounces-43064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1CFA83B1A
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEBCB189FEAC
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36F820766D;
	Thu, 10 Apr 2025 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3Yn+lBT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A843720B819;
	Thu, 10 Apr 2025 07:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269787; cv=none; b=CGBL4U+CKA9qWl0vATp9el1H9HTQ2iGAQs9uWTmJu8SbtaNZ9nhpTBuPl06bdbFN16OfNZcYulLBOU25J5uDgA1nXcs2fdevXd2UpBihzHYWSCucT+AHmmSDykZg8hrABs7CJRd815T19TNr4IptJWjJ2Ghh/Pp0KGcEsXQ1fdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269787; c=relaxed/simple;
	bh=bkjS1ShHcprcZLSzOo1xbnZ1tFJ/S/ey47LDxHM6MQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQQzWkTgu9vzwdPJF55G6DGm6rmSfBsOxTsXJPUC7m37BGJFhETTn2DD9eQIMMfWFE7WpX1ZJQu/YHw2Qs1bnX3ntNlob0FZkUqK8+G6SQF1uE8PB3IJ40XdDqvNm6l7R86gpRrEhh1CghiCb14AbW1dD31Lef1/+fstLbfhv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3Yn+lBT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269786; x=1775805786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bkjS1ShHcprcZLSzOo1xbnZ1tFJ/S/ey47LDxHM6MQ4=;
  b=T3Yn+lBT13X6o2VXNTzpMSVNQCIroXinMyddaWiF5sq9ZnkglbN7bjdU
   33L+SxEq9n3RIUqOvLiVqPajqBvu+rVidVmhh8aywgyzalIjAeB0iBmre
   7p9ojCkzxR0xq6JJJ0sfy18jRk7Mf6cBA6+Ih3r3oizSYwyqcvxF0Y+a3
   lF/phmEEfgQxlb29ETNblQ36PDLVzcI+/Vx20b2jzz3+am0Fh8cWvGc00
   aIs5mogoELqCV+UzBHbA+XNSajRkTtm8z3jh20QIx17UwOhgphhGT83UL
   uL0HP1fFMLEzBiXPA+U7PTYWe+SbsWXmvJNS489z6mpGyuLaNOpFdsbNL
   g==;
X-CSE-ConnectionGUID: BNahLccPQ8CaVoMvCaLLvA==
X-CSE-MsgGUID: MWRPLV+3SYuIgd5/uyFIhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439415"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439415"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:23:03 -0700
X-CSE-ConnectionGUID: fXgORDmPTamGsfX0wIiwSg==
X-CSE-MsgGUID: e9YRWaSQTeWdgMcSMygV8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778246"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:58 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v5 6/7] x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
Date: Thu, 10 Apr 2025 15:24:46 +0800
Message-ID: <20250410072605.2358393-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250410072605.2358393-1-chao.gao@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

In preparation for upcoming CET virtualization support, the CET supervisor
state will be added as a "guest-only" feature, since it is required only by
KVM (i.e., guest FPUs). Establish the infrastructure for "guest-only"
features.

Define a new XFEATURE_MASK_GUEST_SUPERVISOR mask to specify features that
are enabled by default in guest FPUs but not in host FPUs. Specifically,
for any bit in this set, permission is granted and XSAVE space is allocated
during vCPU creation. Non-guest FPUs cannot enable guest-only features,
even dynamically, and no XSAVE space will be allocated for them.

The mask is currently empty, but this will be changed by a subsequent
patch.

Note that there is no plan to add "guest-only" user xfeatures, so the user
default features remain unchanged.

Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
v5: Explain in detail the reasoning behind the mask name choice below the
"---" separator line.

In previous versions, the mask was named "XFEATURE_MASK_SUPERVISOR_DYNAMIC"
Dave suggested this name [1], but he also noted, "I don't feel strongly about
it and I've said my piece. I won't NAK it one way or the other."

The term "dynamic" was initially preferred because it reflects the impact
on XSAVE buffers—some buffers accommodate dynamic features while others do
not. This naming allows for the introduction of dynamic features that are
not strictly "guest-only", offering flexibility beyond KVM.

However, using "dynamic" has led to confusion [2]. Chang pointed out that
permission granting and buffer allocation are actually static at VCPU
allocation, diverging from the model for user dynamic features. He also
questioned the rationale for introducing a kernel dynamic feature mask
while using it as a guest-only feature mask [3]. Moreover, Thomas remarked
that "the dynamic naming is really bad" [4]. Although his specific concerns
are unclear, we should be cautious about reinstating the "kernel dynamic
feature" naming.

Therefore, in v4, I renamed the mask to "XFEATURE_MASK_SUPERVISOR_GUEST"
and further refined it to "XFEATURE_MASK_GUEST_SUPERVISOR" in this v5.

[1]: https://lore.kernel.org/all/893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com/#t
[2]: https://lore.kernel.org/kvm/e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com/
[3]: https://lore.kernel.org/kvm/7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com/
[4]: https://lore.kernel.org/all/87sg1owmth.ffs@nanos.tec.linutronix.de/
---
 arch/x86/include/asm/fpu/types.h  |  9 +++++----
 arch/x86/include/asm/fpu/xstate.h |  6 +++++-
 arch/x86/kernel/fpu/xstate.c      | 14 +++++++++++---
 arch/x86/kernel/fpu/xstate.h      |  5 +++++
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 769155a0401a..7494d732b296 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -600,8 +600,9 @@ struct fpu_state_config {
 	 * @default_size:
 	 *
 	 * The default size of the register state buffer. Includes all
-	 * supported features except independent managed features and
-	 * features which have to be requested by user space before usage.
+	 * supported features except independent managed features,
+	 * guest-only features and features which have to be requested by
+	 * user space before usage.
 	 */
 	unsigned int		default_size;
 
@@ -617,8 +618,8 @@ struct fpu_state_config {
 	 * @default_features:
 	 *
 	 * The default supported features bitmap. Does not include
-	 * independent managed features and features which have to
-	 * be requested by user space before usage.
+	 * independent managed features, guest-only features and features
+	 * which have to be requested by user space before usage.
 	 */
 	u64 default_features;
 	/*
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 7f39fe7980c5..62768d2131ec 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -45,9 +45,13 @@
 /* Features which are dynamically enabled for a process on request */
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
+/* Supervisor features which are enabled only in guest FPUs */
+#define XFEATURE_MASK_GUEST_SUPERVISOR	0
+
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
-					    XFEATURE_MASK_CET_USER)
+					    XFEATURE_MASK_CET_USER | \
+					    XFEATURE_MASK_GUEST_SUPERVISOR)
 
 /*
  * A supervisor state component may not always contain valuable information,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index cdd1e51fb93e..c7db9f1407f5 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -776,14 +776,22 @@ static void __init init_default_features(u64 kernel_max_features, u64 user_max_f
 	u64 kfeatures = kernel_max_features;
 	u64 ufeatures = user_max_features;
 
-	/* Default feature sets should not include dynamic xfeatures. */
-	kfeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
+	/*
+	 * Default feature sets should not include dynamic and guest-only
+	 * xfeatures at all.
+	 */
+	kfeatures &= ~(XFEATURE_MASK_USER_DYNAMIC | XFEATURE_MASK_GUEST_SUPERVISOR);
 	ufeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
 
 	fpu_kernel_cfg.default_features = kfeatures;
 	fpu_user_cfg.default_features   = ufeatures;
 
-	guest_default_cfg.features      = kfeatures;
+	/*
+	 * Ensure VCPU FPU container only reserves a space for guest-only
+	 * xfeatures. This distinction can save kernel memory by
+	 * maintaining a necessary amount of XSAVE buffer.
+	 */
+	guest_default_cfg.features      = kfeatures | xfeatures_mask_guest_supervisor();
 	guest_default_cfg.user_features = ufeatures;
 }
 
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 0fd34f53f025..8be3df4aa28b 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -61,6 +61,11 @@ static inline u64 xfeatures_mask_supervisor(void)
 	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
 }
 
+static inline u64 xfeatures_mask_guest_supervisor(void)
+{
+	return fpu_kernel_cfg.max_features & XFEATURE_MASK_GUEST_SUPERVISOR;
+}
+
 static inline u64 xfeatures_mask_independent(void)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR))
-- 
2.46.1


