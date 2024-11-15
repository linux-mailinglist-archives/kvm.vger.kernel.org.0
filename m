Return-Path: <kvm+bounces-31923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 778E59CDBE2
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4CBDB2481D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1C8199EA2;
	Fri, 15 Nov 2024 09:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pn46ug84"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD5192B94;
	Fri, 15 Nov 2024 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731664378; cv=none; b=hzIaYKgbOYCQqO3XK2h7TGkAtZM2UVZWNRQyvx6GPCw9DJVjYMYCkb4/p2PBAwkUTKzWg36xTWqAdx55FpocxqjXICFXs3eTx1PAKjm3wKaEOv/AlPCpstpOquv56uunSgIY4ei9NgPq33S3gGPTTNsNe0F3N7DWIXzQykz1KGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731664378; c=relaxed/simple;
	bh=PSJADArL2xWR+olfNc+CrrgxOkgymj6N08p3mFqLcaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/RsNHSL2PADk+n5rX5ubKEU8DGPLknx5cvH14n3HX+mgmd1ODjezT5Escc+ZczNTXO2FP9B8qHRA1kkEITMqrculYMrwWE+PUN3PmmV4e7eyIkWiVkYqCwvK4l7YSbjr379tKE3cy2b/yoQo+yaVLs6UKv2fGCfyN40SgApf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pn46ug84; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731664376; x=1763200376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PSJADArL2xWR+olfNc+CrrgxOkgymj6N08p3mFqLcaY=;
  b=Pn46ug84Ey3s1fa+1pQzf2oBq2kxUJbfie0MJT8RVi0P0XLfEsNGsQhe
   w5vCWHfJXJl3CZcrb08kbzlWQWi4i7sSoavQRc0XifQj6sMgWh8UH69sG
   av6nE1wpXgaxZhqYvNxFKL8YXUlYm/t+UAv8OuVw3C7KUFcLXKdKpa816
   o5162/20ujapXvz2PClAaWQdA5Xy+BK3lwEvs3ggfwBlHwaV1CrsClo58
   NfUT+sAg+AORB6ZKf2wpHHv4xsjIVVrMo2TdKIIXqLaC5K8nPu6OqCS4c
   nbuIcaxyYkOkZiL3vTAQUCjREYbGxiK986eqv1TA2aX414u55xDiAHx9k
   Q==;
X-CSE-ConnectionGUID: dzCKf06eRtCVbXHq0xPEcg==
X-CSE-MsgGUID: cvmv+i4vT/aMDi0IC3eueg==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31584836"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="31584836"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:56 -0800
X-CSE-ConnectionGUID: d75CrdAvQ96AUBNvfR2M6g==
X-CSE-MsgGUID: NLG4yQxqTDuDslm7hWGa0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="93584315"
Received: from kinlongk-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.135])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:53 -0800
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: VMX: Refactor VMX module init/exit functions
Date: Fri, 15 Nov 2024 22:52:39 +1300
Message-ID: <3f23f24098bdcf42e213798893ffff7cdc7103be.1731664295.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731664295.git.kai.huang@intel.com>
References: <cover.1731664295.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add vt_init() and vt_exit() as the new module init/exit functions and
refactor existing vmx_init()/vmx_exit() as helper to make room for TDX
specific initialization and teardown.

To support TDX, KVM will need to enable TDX during KVM module loading
time.  Enabling TDX requires enabling hardware virtualization first so
that all online CPUs (and the new CPU going online) are in post-VMXON
state.

Currently, the vmx_init() flow is:

 1) hv_init_evmcs(),
 2) kvm_x86_vendor_init(),
 3) Other VMX specific initialization,
 4) kvm_init()

The kvm_x86_vendor_init() invokes kvm_x86_init_ops::hardware_setup() to
do VMX specific hardware setup and calls kvm_update_ops() to initialize
kvm_x86_ops to VMX's version.

TDX will have its own version for most of kvm_x86_ops callbacks.  It
would be nice if kvm_x86_init_ops::hardware_setup() could also be used
for TDX, but in practice it cannot.  The reason is, as mentioned above,
TDX initialization requires hardware virtualization having been enabled,
which must happen after kvm_update_ops(), but hardware_setup() is done
before that.

Also, TDX is based on VMX, and it makes sense to only initialize TDX
after VMX has been initialized.  If VMX fails to initialize, TDX is
likely broken anyway.

So the new flow of KVM module init function will be:

 1) Current VMX initialization code in vmx_init() before kvm_init(),
 2) TDX initialization,
 3) kvm_init()

Split vmx_init() into two parts based on above 1) and 3) so that TDX
initialization can fit in between.  Make part 1) as the new helper
vmx_init().  Introduce vt_init() as the new module init function which
calls vmx_init() and kvm_init().  TDX initialization will be added
later.

Do the same thing for vmx_exit()/vt_exit().

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/main.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c  | 23 ++---------------------
 arch/x86/kvm/vmx/vmx.h  |  3 +++
 3 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 92d35cc6cd15..6772e560ac7b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -167,3 +167,35 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static void vt_exit(void)
+{
+	kvm_exit();
+	vmx_exit();
+}
+module_exit(vt_exit);
+
+static int __init vt_init(void)
+{
+	int r;
+
+	r = vmx_init();
+	if (r)
+		return r;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
+		     THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	vmx_exit();
+	return r;
+}
+module_init(vt_init);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0f008f5ef6f0..90d8d86ba355 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8602,23 +8602,16 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
 	vmx_cleanup_l1d_flush();
-}
 
-static void vmx_exit(void)
-{
-	kvm_exit();
-	__vmx_exit();
 	kvm_x86_vendor_exit();
-
 }
-module_exit(vmx_exit);
 
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
@@ -8662,21 +8655,9 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
-	/*
-	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
-	 * exposed to userspace!
-	 */
-	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
-		     THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	return 0;
 
-err_kvm_init:
-	__vmx_exit();
 err_l1d_flush:
 	kvm_x86_vendor_exit();
 	return r;
 }
-module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 43f573f6ca46..1813caac1cea 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -756,4 +756,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
+int vmx_init(void);
+void vmx_exit(void);
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.46.2


