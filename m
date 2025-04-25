Return-Path: <kvm+bounces-44277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 939B0A9C27A
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B11197B5775
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E1B236437;
	Fri, 25 Apr 2025 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hcg4RdST"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573E231C9C;
	Fri, 25 Apr 2025 08:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571283; cv=none; b=tTP7t+navtDcnr9eWYqzkzzBoCSKmBIInoKPjuKG9sKCMAEFY1tclNEujkfT9uNyh97i+Ib/7pmrT+i6W01UavngZfuumV2E4xno3tCf1xEScLMk4+lhgwfsXNaV28Z1pCqp8ES4tZRBMWQEXOLNAqNhuXa64YOu0Qvmc2k/iGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571283; c=relaxed/simple;
	bh=4/Vbs76jppkzyZKMGwoWdOHkArQ62q4Z8iajisepyRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcNM8Fi9li9OKNkLpj+cykSLbGfWrhM21hYe8xXsk8x58CILNCURyfEuIGgwFBigKXYs6MahqZlTPOnVTNDoAorIthjHftXX0gzx1PC3D9E+xf18ZOTYJCdtGgkR2N58JqFwBvdKKWrfRwoGVeHVisxyNzSbWiG8QBlPCqKg+NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hcg4RdST; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745571282; x=1777107282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4/Vbs76jppkzyZKMGwoWdOHkArQ62q4Z8iajisepyRE=;
  b=Hcg4RdSTiKP+Oq8IZ+9pCCTKaYkS3XRPxlrw+TAOgUQBuGVv6gXOYk2P
   C6j5A/e5WuPyj0p2GNX8ug1qNlK/ceow1QB5EbPx2kDwG77Ow7lscQXdA
   cAHbER4JRyNgadWUiNH3vAhMvDS6hjJVfMIQS4sik+o2q/bZAjQgGLXDv
   AUGALj0ZZ+YwMQBNwmuy41cOhpb8IdouJAEfv6vzko5YNS1ZkW1Y8PFiC
   JktcbOFgB+skoEsAGoCSFbVN2X68dWLaUp3dB+sgVb8C/p/PpTQor50iI
   PJUIThNy+LMkdCAgny6mWXVynrZLlcrkeDvi7gcfrwCXrOGvO7H81Hvfr
   Q==;
X-CSE-ConnectionGUID: 9a1Do2NbQjuOm+hU2QvQLw==
X-CSE-MsgGUID: deUgYrZKRACnm6SpKeHD5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="47349945"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="47349945"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:58:19 -0700
X-CSE-ConnectionGUID: zj8aPa17QCypdjQC8gKSkQ==
X-CSE-MsgGUID: bxu6J7G/TAeJIRkGcGOWDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="133764273"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.113.29])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:58:13 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: mlevitsk@redhat.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V3 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Date: Fri, 25 Apr 2025 10:57:56 +0300
Message-ID: <20250425075756.14545-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250425075756.14545-1-adrian.hunter@intel.com>
References: <20250425075756.14545-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
which enables more efficient reclaim of private memory.

Private memory is removed from MMU/TDP when guest_memfds are closed. If
the HKID has not been released, the TDX VM is still in RUNNABLE state,
so pages must be removed using "Dynamic Page Removal" procedure (refer
TDX Module Base spec) which involves a number of steps:
	Block further address translation
	Exit each VCPU
	Clear Secure EPT entry
	Flush/write-back/invalidate relevant caches

However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
where all TDX VM pages are effectively unmapped, so pages can be reclaimed
directly.

Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
reclaim time.  For example:

	VCPUs	Size (GB)	Before (secs)	After (secs)
	 4	 18		  72		 24
	32	107		 517		134
	64	400		5539		467

Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
Link: https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V3:

	Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
	trigger on the error path from __tdx_td_init()

	Put cpus_read_lock() handling back into tdx_mmu_release_hkid()

	Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
	tdx_vm_ioctl() deal with kvm->lock


 Documentation/virt/kvm/x86/intel-tdx.rst | 16 +++++++++
 arch/x86/include/uapi/asm/kvm.h          |  1 +
 arch/x86/kvm/vmx/tdx.c                   | 41 +++++++++++++++---------
 3 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index de41d4c01e5c..e5d4d9cf4cf2 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
           KVM_TDX_INIT_MEM_REGION,
           KVM_TDX_FINALIZE_VM,
           KVM_TDX_GET_CPUID,
+          KVM_TDX_TERMINATE_VM,
 
           KVM_TDX_CMD_NR_MAX,
   };
@@ -214,6 +215,21 @@ struct kvm_cpuid2.
 	  __u32 padding[3];
   };
 
+KVM_TDX_TERMINATE_VM
+-------------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Release Host Key ID (HKID) to allow more efficient reclaim of private memory.
+After this, the TD is no longer in a runnable state.
+
+Using KVM_TDX_TERMINATE_VM is optional.
+
+- id: KVM_TDX_TERMINATE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
 KVM TDX creation flow
 =====================
 In addition to the standard KVM flow, new TDX ioctls need to be called.  The
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 225a12e0d5d6..a2f973e1d75d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -939,6 +939,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
+	KVM_TDX_TERMINATE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..5161f6f891d7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -500,14 +500,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 */
 	mutex_lock(&tdx_lock);
 
-	/*
-	 * Releasing HKID is in vm_destroy().
-	 * After the above flushing vps, there should be no more vCPU
-	 * associations, as all vCPU fds have been released at this stage.
-	 */
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
-	if (err == TDX_FLUSHVP_NOT_DONE)
-		goto out;
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
 		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
@@ -515,6 +508,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -539,7 +533,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
@@ -1789,13 +1783,13 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
+		WARN_ON_ONCE(!kvm->vm_dead);
+		ret = tdx_reclaim_page(page);
+		if (!ret)
+			tdx_unpin(kvm, page);
+		return ret;
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2790,6 +2784,20 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_terminate_vm(struct kvm *kvm)
+{
+	if (!kvm_trylock_all_vcpus(kvm))
+		return -EBUSY;
+
+	kvm_vm_dead(kvm);
+
+	kvm_unlock_all_vcpus(kvm);
+
+	tdx_mmu_release_hkid(kvm);
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2817,6 +2825,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_FINALIZE_VM:
 		r = tdx_td_finalize(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_TERMINATE_VM:
+		r = tdx_terminate_vm(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.43.0


