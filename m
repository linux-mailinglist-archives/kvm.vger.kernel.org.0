Return-Path: <kvm+bounces-72895-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MLaHUXCqWkhEQEAu9opvQ
	(envelope-from <kvm+bounces-72895-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:49:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F23C2167ED
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:49:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA5F131B8F0E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83643ECBFF;
	Thu,  5 Mar 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EENc5Y/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF8B3D3CFD;
	Thu,  5 Mar 2026 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732678; cv=none; b=Eo3pcRKyXrcqFZyzoTyuH3fV18cGa1ADuqCE2LGpFKYgyBXNtSHnTSuya5U5eE0B2udTkRlsYluJzS/GO8DZIMA73NHKcDKMNVX46QuK8AITFmN3EAFANS5VITawN9i8MEb+xCiv+42/pHH+iVdGGD56EY11jSeGo39qurU95j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732678; c=relaxed/simple;
	bh=AYSF4woZnUUExmVQAgqaWWHMhnv4Eg3Hbzpmjm5Vdos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGeKySGgaDC0Gi1iV848udYOZxj35dLkwlzSz6Spq0OWYi/5YNyeHZQD+HFC0FC0vFtAObO+eZ1dpYHELAD0m6FOTlIdWqYY4gifSnGW5flojVbVc1w4ASL4ykNgqhAje46QyQXknffpBpEHrehmGQpta4m+johtAL15jUyj3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EENc5Y/M; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732676; x=1804268676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AYSF4woZnUUExmVQAgqaWWHMhnv4Eg3Hbzpmjm5Vdos=;
  b=EENc5Y/MzEKz46FFQnqurenIIqZtjr4ofv/PCoQc9uOySyRhmpOnsdjC
   7hn1RtjjFsd2rOOcCpFlBMTSYElY33AnBn/S0vl98PolQE80tEzYAN3yn
   QotgOhq416WpqJ3EkVYBBnZAskA0Ao2uHRPeUcUypMNezIOgVpm/uUrds
   N9Z6VWxN7O1/0CaZvg85ydIT00+xjwo6WJibIHcvlyLCAmPjeO1o6VkJ5
   x460nDGCr47uz2gWHqmjSn92GZibYfFOf00yfD40e6u66DIU8BAvqf8s4
   7hfbgjDGWmy/aSpWaj6zBAmhk4fcaZtWGJSo6jSjybFP+zO23ysEDeAKz
   Q==;
X-CSE-ConnectionGUID: 7G5lMH5mSlyi0+nDew32mw==
X-CSE-MsgGUID: Rs1or19/QeidGXTo7Kl96w==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73798219"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73798219"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:36 -0800
X-CSE-ConnectionGUID: XKhphNWuQviog9D1H35mAg==
X-CSE-MsgGUID: A6/I9Lt9QhKh1lVlf4mb4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="215527258"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:35 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/36] KVM: nVMX: Pass struct msr_data to VMX MSRs emulation
Date: Thu,  5 Mar 2026 09:43:49 -0800
Message-ID: <7c23de0a19fbd6c452e3a8a50322972f421b734c.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F23C2167ED
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72895-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Pass struct msr_data, which has host_initiated member in addition to
msr_index and data to vmx_set/get_vmx_msr().

Processor-based tertiary control access depends on which initiated the
operation, the host or the guest. For host-initiated access (KVM_GET_MSRS,
KVM_SET_MSRS), if the host supports processor-based tertiary controls,
allow access.  If guest-initiated access (emulation for guest rdmsr/wrmsr),
allow/disallow based on guest tertiary controls is advertised to the guest
(guest processor-based control high &
CPU_BASED_ACTIVATE_TERTIARY_CONTROLS).  Prepare to add the check.

No functional change intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  9 +++++++--
 arch/x86/kvm/vmx/nested.h |  4 ++--
 arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++----
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c475b8c94807..5f0ac8acd768 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1475,9 +1475,11 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
  *
  * Returns 0 on success, non-0 otherwise.
  */
-int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
+int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 msr_index = msr_info->index;
+	u64 data = msr_info->data;
 
 	/*
 	 * Don't allow changes to the VMX capability MSRs while the vCPU
@@ -1540,8 +1542,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 }
 
 /* Returns 0 on success, non-0 otherwise. */
-int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
+int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, struct msr_data *msr_info)
 {
+	u32 msr_index = msr_info->index;
+	u64 *pdata = &msr_info->data;
+
 	switch (msr_index) {
 	case MSR_IA32_VMX_BASIC:
 		*pdata = msrs->basic;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b844c5d59025..d0257447b7cb 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -47,8 +47,8 @@ static inline void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 }
 
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
-int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
-int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
+int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, struct msr_data *msr);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9d5a493b6fe5..9177b693df1b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2070,11 +2070,22 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 
 int vmx_get_feature_msr(u32 msr, u64 *data)
 {
+	struct msr_data msr_info;
+	int r;
+
 	switch (msr) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!nested)
 			return 1;
-		return vmx_get_vmx_msr(&vmcs_config.nested, msr, data);
+
+		msr_info = (struct msr_data) {
+			.index = msr,
+			.host_initiated = true,
+		};
+		r = vmx_get_vmx_msr(&vmcs_config.nested, &msr_info);
+		if (!r)
+			*data = msr_info.data;
+		return r;
 	default:
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
@@ -2159,8 +2170,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return 1;
-		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
-				    &msr_info->data))
+		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info))
 			return 1;
 #ifdef CONFIG_KVM_HYPERV
 		/*
@@ -2487,7 +2497,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1; /* they are read-only */
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return 1;
-		return vmx_set_vmx_msr(vcpu, msr_index, data);
+		return vmx_set_vmx_msr(vcpu, msr_info);
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest() ||
 			vmx_rtit_ctl_check(vcpu, data) ||
-- 
2.45.2


