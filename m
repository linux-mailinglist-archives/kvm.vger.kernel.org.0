Return-Path: <kvm+bounces-45575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CADF0AABFA1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59CD04A7ED1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4292701A1;
	Tue,  6 May 2025 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQpN6S44"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02295266B65;
	Tue,  6 May 2025 09:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523991; cv=none; b=OVMyL7DbND7jIssaiDZ81MVS32Q3BC9sLwQnSfeJjNM5sCXXO46N0zkFr12EJI+M/xJPR/X9DZVucCfasXSf+e9yF7VFK7QByIOe4MNgF3FXCrRF9c/HbF+Pki4gR9ITN9HnyCTDgHKw8JaOoXnBSvN+VLtSp070lMudwNjBnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523991; c=relaxed/simple;
	bh=ismy3JZ/k0H77jw/gLjGJbAUD2NffbsRog7cYABsIlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O40xkVgSFP1M309oJTBuUB9YhfAIeUIHQbLnZk5v4ji3M5MeMaYkf1jnpo8Av6t0mTYh2tWkjUCLTPzvhDkgynELdWuy3pXaZJuG7ieNHMIdF21aj4SwwoeCFra0zNCGs9/vc9ygHIZhSukrqwPf+eX93EDKoa7XrUPzq2OWdiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQpN6S44; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746523990; x=1778059990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ismy3JZ/k0H77jw/gLjGJbAUD2NffbsRog7cYABsIlY=;
  b=cQpN6S445e8IrBLoCJUGVFd1IS5LISzNigAr/GxrCpRD1Fk6P2izzam4
   xK7LkIpEXwht8WI2IlYBQbb4YpGGbIISxn4Pt0FslT13PioQCnX2emc1d
   G2zooOvzUoj9DSTPWrmnTooUF5Pd+/poN8/oou+TD75pNPcliwR2ry/oa
   nqNzQU39fZkNCL+zpG0GxCk9F0JNu1sREYxQevYsjnYioAB2OPCtnT1G8
   mEthy27/uOTP6s87umZ3/lQZpR2UUtE8ZnfMgJY0yEYgXi9gCvYiOXuuf
   Q+J0+2mgDBc3ANIVlEWpfs2nY5nlKy7cueDB9Rbzd82OqsjQqkzhI2iMP
   Q==;
X-CSE-ConnectionGUID: d0LDf6aaRfqbHFdzdz96rQ==
X-CSE-MsgGUID: gHARiSLkQTOKPQU7M5O4qA==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="35800377"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="35800377"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:09 -0700
X-CSE-ConnectionGUID: RbO41vUKSVmP5HFNsRRcSw==
X-CSE-MsgGUID: evj4Zkp+TxGSdPC7GgI1zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135446879"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:03 -0700
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
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: [PATCH v6 3/7] x86/fpu/xstate: Differentiate default features for host and guest FPUs
Date: Tue,  6 May 2025 17:36:08 +0800
Message-ID: <20250506093740.2864458-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250506093740.2864458-1-chao.gao@intel.com>
References: <20250506093740.2864458-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, guest and host FPUs share the same default features. However,
the CET supervisor xstate is the first feature that needs to be enabled
exclusively for guest FPUs. Enabling it for host FPUs leads to a waste of
24 bytes in the XSAVE buffer.

To support "guest-only" features, add a new structure to hold the
default features and sizes for guest FPUs to clearly differentiate them
from those for host FPUs.

Note that,
1) for now, the default features for guest and host FPUs remain the
same. This will change in a follow-up patch once guest permissions, default
xfeatures, and fpstate size are all converted to use the guest defaults.

2) only supervisor features will diverge between guest FPUs and host
FPUs, while user features will remain the same [1][2]. So, the new
vcpu_fpu_config struct does not include default user features and size
for the UABI buffer.

An alternative approach is adding a guest_only_xfeatures member to
fpu_kernel_cfg and adding two helper functions to calculate the guest
default xfeatures and size. However, calculating these defaults at runtime
would introduce unnecessary overhead.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/kvm/aAwdQ759Y6V7SGhv@google.com/ [1]
Link: https://lore.kernel.org/kvm/9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com/ [2]
---
v6:
Drop vcpu_fpu_config.user_* (Rick)
Reset guest default size when XSAVE is unavaiable or disabled (Chang)

v5:
Add a new vcpu_fpu_config instead of adding new members to
fpu_state_config (Chang)
Extract a helper to set default values (Chang)
---
 arch/x86/include/asm/fpu/types.h | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c       |  1 +
 arch/x86/kernel/fpu/init.c       |  1 +
 arch/x86/kernel/fpu/xstate.c     | 27 +++++++++++++++++++++------
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 1c94121acd3d..abd193a1a52e 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -551,6 +551,31 @@ struct fpu_guest {
 	struct fpstate			*fpstate;
 };
 
+/*
+ * FPU state configuration data for fpu_guest.
+ * Initialized at boot time. Read only after init.
+ */
+struct vcpu_fpu_config {
+	/*
+	 * @size:
+	 *
+	 * The default size of the register state buffer in guest FPUs.
+	 * Includes all supported features except independent managed
+	 * features and features which have to be requested by user space
+	 * before usage.
+	 */
+	unsigned int size;
+
+	/*
+	 * @features:
+	 *
+	 * The default supported features bitmap in guest FPUs. Does not
+	 * include independent managed features and features which have to
+	 * be requested by user space before usage.
+	 */
+	u64 features;
+};
+
 /*
  * FPU state configuration data. Initialized at boot time. Read only after init.
  */
@@ -606,5 +631,6 @@ struct fpu_state_config {
 
 /* FPU state configuration information */
 extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct vcpu_fpu_config guest_default_cfg;
 
 #endif /* _ASM_X86_FPU_TYPES_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1cda5b78540b..2cd5e1910ff8 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -36,6 +36,7 @@ DEFINE_PER_CPU(u64, xfd_state);
 /* The FPU state configuration data for kernel and user space */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
+struct vcpu_fpu_config guest_default_cfg __ro_after_init;
 
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 6bb3e35c40e2..e19660cdc70c 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -202,6 +202,7 @@ static void __init fpu__init_system_xstate_size_legacy(void)
 	fpu_kernel_cfg.default_size = size;
 	fpu_user_cfg.max_size = size;
 	fpu_user_cfg.default_size = size;
+	guest_default_cfg.size = size;
 }
 
 /*
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1c8410b68108..f32047e12500 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -742,6 +742,9 @@ static int __init init_xstate_size(void)
 	fpu_user_cfg.default_size =
 		xstate_calculate_size(fpu_user_cfg.default_features, false);
 
+	guest_default_cfg.size =
+		xstate_calculate_size(guest_default_cfg.features, compacted);
+
 	return 0;
 }
 
@@ -762,6 +765,7 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	fpu_kernel_cfg.default_size = legacy_size;
 	fpu_user_cfg.max_size = legacy_size;
 	fpu_user_cfg.default_size = legacy_size;
+	guest_default_cfg.size = legacy_size;
 
 	/*
 	 * Prevent enabling the static branch which enables writes to the
@@ -772,6 +776,21 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	fpstate_reset(x86_task_fpu(current));
 }
 
+static void __init init_default_features(u64 kernel_max_features, u64 user_max_features)
+{
+	u64 kfeatures = kernel_max_features;
+	u64 ufeatures = user_max_features;
+
+	/* Default feature sets should not include dynamic xfeatures. */
+	kfeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
+	ufeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
+
+	fpu_kernel_cfg.default_features = kfeatures;
+	fpu_user_cfg.default_features   = ufeatures;
+
+	guest_default_cfg.features      = kfeatures;
+}
+
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
@@ -854,12 +873,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_user_cfg.max_features = fpu_kernel_cfg.max_features;
 	fpu_user_cfg.max_features &= XFEATURE_MASK_USER_SUPPORTED;
 
-	/* Clean out dynamic features from default */
-	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
-	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-
-	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
-	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	/* Now, given maximum feature set, determine default values */
+	init_default_features(fpu_kernel_cfg.max_features, fpu_user_cfg.max_features);
 
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
-- 
2.47.1


