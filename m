Return-Path: <kvm+bounces-44042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5FAA99F56
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 142E47AF4CA
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9251B0439;
	Thu, 24 Apr 2025 03:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nbg5MOi9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0451AA1D8;
	Thu, 24 Apr 2025 03:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464149; cv=none; b=HLCGEuXFJ0h5bwUelNiYgRe2LSzqqhAcSh8snpJhWcBeJZO6Cj72Y2aFi8suaLwURYpl81e6jDvQUjsxLWLenlg1BKNK8A59rII9RcEDAeKSjfFcBjJsopAMxYArQpYH3jQHOFSwviOokwoJF+Y6BEYJJ5XsbfLE2g5IyZoUgXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464149; c=relaxed/simple;
	bh=KeWQF6JOZCE1U2cXc5jw2hofVfb7DCC9G33zg4hMCIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLeggjxm2pZCiOckdb0MLD31s1/Mxn+FfCR/a7/mJQjYSmoWiOgu1rLK/Rlj0DuT58U//z7Z3zVZngklAcZnjops3LVoQSS09kgTAf+kqyWJr/+f6FUEB0IXmhT/fiqG8h5Wp2nNyzDmsiGLXgoX6gol9jlPjhvGlBguMKJPyOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nbg5MOi9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464148; x=1777000148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KeWQF6JOZCE1U2cXc5jw2hofVfb7DCC9G33zg4hMCIg=;
  b=Nbg5MOi9+0pJ4Tjwts2B56Knee24idFtKsryIkrvWUNQB7lP5km7Z70m
   lie2HRAEXdMhfw1rJEFZ3iZ+lGU0m5t7MaNAYv6gGRW9HnvONq2dkChRD
   1aAdeK/6dAmujSDzUi5szIheADTcf0lbN513A7doBbpOkLfpkppBKDaWE
   zgX99dHB3JjNIn7xD2Y2vdfLFVoBPkskLu3ee3PS5iGHYrKatCc9k138Z
   39JxGN3UDd0/40T3GkE4yf0oG3kTOoR26hVrwaps6+Nn6n+CA8RYuSL97
   JUM3fr3VE/YBdMhDCQLqI1gjhgtPR9iXzz8alwlUA9D28t2jd//RK6MXl
   Q==;
X-CSE-ConnectionGUID: 2IjuW3rUQNWW+a3s4iXzTQ==
X-CSE-MsgGUID: q/jfgQdxS0CjLO74uQGiUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="57727367"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="57727367"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:06 -0700
X-CSE-ConnectionGUID: IV8EalImTd2EO6sMLYfQog==
X-CSE-MsgGUID: p42shN4AQMeg7I0S9md/xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137286490"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:00 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according to vCPU's ACCEPT level
Date: Thu, 24 Apr 2025 11:07:13 +0800
Message-ID: <20250424030713.403-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Determine the max mapping level of a private GFN according to the vCPU's
ACCEPT level specified in the TDCALL TDG.MEM.PAGE.ACCEPT.

When an EPT violation occurs due to a vCPU invoking TDG.MEM.PAGE.ACCEPT
before any actual memory access, the vCPU's ACCEPT level is available in
the extended exit qualification. Set the vCPU's ACCEPT level as the max
mapping level for the faulting GFN. This is necessary because if KVM
specifies a mapping level greater than the vCPU's ACCEPT level, and no
other vCPUs are accepting at KVM's mapping level, TDG.MEM.PAGE.ACCEPT will
produce another EPT violation on the vCPU after re-entering the TD, with
the vCPU's ACCEPT level indicated in the extended exit qualification.

Introduce "violation_gfn_start", "violation_gfn_end", and
"violation_request_level" in "struct vcpu_tdx" to pass the vCPU's ACCEPT
level to TDX's private_max_mapping_level hook for determining the max
mapping level.

Instead of taking some bits of the error_code passed to
kvm_mmu_page_fault() and requiring KVM MMU core to check the error_code for
a fault's max_level, having TDX's private_max_mapping_level hook check for
request level avoids changes to the KVM MMU core. This approach also
accommodates future scenarios where the requested mapping level is unknown
at the start of tdx_handle_ept_violation() (i.e., before invoking
kvm_mmu_page_fault()).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c      | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h      |  4 ++++
 arch/x86/kvm/vmx/tdx_arch.h |  3 +++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 86775af85cd8..dd63a634e633 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1859,10 +1859,34 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
 	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
 }
 
+static inline void tdx_get_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int level = -1;
+
+	u64 eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+
+	u32 eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
+			TDX_EXT_EXIT_QUAL_INFO_SHIFT;
+
+	if (eeq_type == TDX_EXT_EXIT_QUAL_TYPE_ACCEPT) {
+		level = (eeq_info & GENMASK(2, 0)) + 1;
+
+		tdx->violation_gfn_start = gfn_round_for_level(gpa_to_gfn(gpa), level);
+		tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
+		tdx->violation_request_level = level;
+	} else {
+		tdx->violation_gfn_start = -1;
+		tdx->violation_gfn_end = -1;
+		tdx->violation_request_level = -1;
+	}
+}
+
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
-	gpa_t gpa = to_tdx(vcpu)->exit_gpa;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	gpa_t gpa = tdx->exit_gpa;
 	bool local_retry = false;
 	int ret;
 
@@ -1884,6 +1908,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
 
+		tdx_get_accept_level(vcpu, gpa);
+
 		/* Only private GPA triggers zero-step mitigation */
 		local_retry = true;
 	} else {
@@ -2917,6 +2943,9 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
+	tdx->violation_gfn_start = -1;
+	tdx->violation_gfn_end = -1;
+	tdx->violation_request_level = -1;
 	return 0;
 
 free_tdcx:
@@ -3260,9 +3289,14 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 
 int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
 	if (unlikely(to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
 		return PG_LEVEL_4K;
 
+	if (gfn >= tdx->violation_gfn_start && gfn < tdx->violation_gfn_end)
+		return tdx->violation_request_level;
+
 	return PG_LEVEL_2M;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 51f98443e8a2..6e13895813c5 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -70,6 +70,10 @@ struct vcpu_tdx {
 
 	u64 map_gpa_next;
 	u64 map_gpa_end;
+
+	u64 violation_gfn_start;
+	u64 violation_gfn_end;
+	int violation_request_level;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index a30e880849e3..af006a73ee05 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -82,7 +82,10 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
 
 #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
+#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
 #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
+#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
+#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.43.2


