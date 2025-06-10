Return-Path: <kvm+bounces-48771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D9CAD2BE1
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8CB81892502
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 02:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD09824293C;
	Tue, 10 Jun 2025 02:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqrGUIBc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D8F24336D;
	Tue, 10 Jun 2025 02:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521629; cv=none; b=XeT8+WV+IkrnLdtg+yRwxA/sUR8JYfafJL5/msF/Aune4fr/pLQE+HHu7Y5WbqZN8hxTYVuWjmeRurBpCTof+rsXQzrOB+3Zr3D9Az1wdYJ952Wjqu0xfJ0MTPxLNTP+nqwrCgQEYfRUB17L3+POHHtoP9Sy51F8fzsxCA+GC2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521629; c=relaxed/simple;
	bh=FchX01MFxp5Y1PBJ6clFSa6v4H4hbzOl1iwsa5RQRm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSlnie7rwwCIE8jzoxdVtAbppfDB9J2u78q6tPGZMZe5yUn/2f477g60EWlN4OfIhGrv2LWk7tQVOPrIeNaH1rYNgXsBECn9ebs5A+tLHtjpgwsvxF5jWFrMn5gC2NmN1yEcwVVDKUe9qPOmQDA4pEMGni5Dxo2GkAWlkgAx558=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqrGUIBc; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749521627; x=1781057627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FchX01MFxp5Y1PBJ6clFSa6v4H4hbzOl1iwsa5RQRm4=;
  b=gqrGUIBcTH07CTOdt8SUM5iWtrphWa3ism96jUsv6ZF3+O/J+p6zp4nX
   RUSbzmvqe7DMx/AQ6CZa8VSUdKKuFOiK05NvTjSc5CN9IF/6Uwh73xfwC
   nFH25RNr1V2OKee4SDzQoZWY40uGsY8EOnWX76LOSlks45eEWtlTjToVq
   fo4baENtDrZAADv4lDHbVACh/K4HupOi2PCZm206gQob/RSR9A1bqLCLc
   PcemrnkdtCo4iwEsQ8WAqmRHHweiRugb9BGqCrBU9gIowFMvV3XlebdGd
   zfIrOVeyEqNQRST6fGO4pN+owsYpDloLUocsTQPMeadEYewnDRCyTUNTt
   w==;
X-CSE-ConnectionGUID: y99Ej/XDRsGWVyDCRv8GtQ==
X-CSE-MsgGUID: dJ4JecCXThO3AJuOWHRkig==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="50841203"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="50841203"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:45 -0700
X-CSE-ConnectionGUID: zdOaYM4UTKu3aD2g8wXQLQ==
X-CSE-MsgGUID: 0dsI/uksSh6+OV4Z3gmCDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147253818"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:42 -0700
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
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kirill.shutemov@intel.com,
	jiewen.yao@intel.com,
	binbin.wu@linux.intel.com
Subject: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE when TD finalize
Date: Tue, 10 Jun 2025 10:14:22 +0800
Message-ID: <20250610021422.1214715-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check userspace has enabled KVM exit on KVM_HC_MAP_GPA_RANGE during
KVM_TDX_FINALIZE_VM.

TDVMCALL_MAP_GPA is one of the GHCI base TDVMCALLs, so it must be
implemented by VMM to support TDX guests. KVM converts TDVMCALL_MAP_GPA
to KVM_HC_MAP_GPA_RANGE, which requires userspace to enable
KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE bit set. Check it when
userspace requests KVM_TDX_FINALIZE_VM, so that there is no need to check
it during TDX guests running.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst |  3 +++
 arch/x86/kvm/vmx/tdx.c                   | 20 +++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 69c64453e9ca..41e38c38b034 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -246,6 +246,9 @@ control flow is as follows:
    * Prepare content of initial guest memory.
    * KVM_TDX_INIT_MEM_REGION: Add initial guest memory.
    * KVM_TDX_FINALIZE_VM: Finalize the measurement of the TDX guest.
+     Note: To support TDVMCALL_MAP_GPA, userspace must opt-in
+     KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE before calling
+     KVM_TDX_FINALIZE_VM.
 
 #. Run VCPU
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a3cd68f44a9c..7fc6e6b9c131 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1209,17 +1209,6 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	u64 size = tdx->vp_enter_args.r13;
 	u64 ret;
 
-	/*
-	 * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
-	 * userspace to enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
-	 * bit set.  If not, the error code is not defined in GHCI for TDX, use
-	 * TDVMCALL_STATUS_INVALID_OPERAND for this case.
-	 */
-	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
-		ret = TDVMCALL_STATUS_INVALID_OPERAND;
-		goto error;
-	}
-
 	if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
 	    !kvm_vcpu_is_legal_gpa(vcpu, gpa + size - 1) ||
 	    (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
@@ -2821,6 +2810,15 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
+	/*
+	 * TDVMCALL_MAP_GPA is one of the GHCI base TDVMCALLs, so it must be
+	 * implemented by VMM to support TDX guests. KVM converts
+	 * TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE, which requires userspace to
+	 * enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE bit set.
+	 */
+	if (!user_exit_on_hypercall(kvm, KVM_HC_MAP_GPA_RANGE))
+		return -EINVAL;
+
 	guard(mutex)(&kvm->slots_lock);
 
 	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
-- 
2.46.0


