Return-Path: <kvm+bounces-48769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1C8AD2BDC
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81B7D1711DE
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 02:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA04242923;
	Tue, 10 Jun 2025 02:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S706fC8d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ED72417C3;
	Tue, 10 Jun 2025 02:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521625; cv=none; b=qX0H5Im4qT/aUt+Jl+nXHX40ccsndV47ZRDl93KkidYOhcZ1ddeVTMeoPWn/bXlJkVcmh73YjWrtofgK/a5jTwprY021t22j8awS7G4/7BGcpy/kZ823UVF8JgNtzq4NKMmy8QC84X+II0dF3inzyAHDDYyLFPfbSQZzDh8GgPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521625; c=relaxed/simple;
	bh=zN74o/ir6eSl0BT6r5GIO5+qKaPJoK1kJ2MoO/zI7vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD7EaNu4ZLGnUSB2lisSzHyrGcE9DHiGeOWoPHmo+vj+sc79NcrPf+AdD1SAukHAtgFZTNJpgzqMf6qAUpugKKTRDJzOWOmT1vBOeC//Upm6aPZeX+wg76Xt6fpkA/FeeaQmxMQAGDDescyZiBUyp3m16btiEbNxTwKfebSpedE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S706fC8d; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749521624; x=1781057624;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zN74o/ir6eSl0BT6r5GIO5+qKaPJoK1kJ2MoO/zI7vo=;
  b=S706fC8dYnNS+hUHoesNkEc6zMNAh9g0bC2O7dDrecdk5R3V5YIYM4sI
   6ky50H7yk7G9LIbNiSeIWvo600Gmn5vS03hccwiMuxcljkuHNwDx/UhTb
   hLHbi/9R0oQO/bvHqIbxwLu4X7rlWnExMumBPIfnw/GvfqXkoxg4q49V2
   r1yEVSeolIZPcB24/Keandu2YFQCjQ73TQD8R/QQOl+jTE8Jdnff9bNzG
   Cpk1Gf/cXz3ZJ20iTIQK1WAPUO6SZgAY2GrMcOmRlwIsBo7VNDjQOzn5Y
   11Y648gjdZCMSI1QCmv1XLZGya8ypYUXTdY5oSPNNpQMGfcanYOw1EY7L
   A==;
X-CSE-ConnectionGUID: nSHNXmrHTNOPUEhpPHddLg==
X-CSE-MsgGUID: 3fwOP9+pTq6gFldJKVOXMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="50841185"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="50841185"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:38 -0700
X-CSE-ConnectionGUID: Pai/b6P6Sry4oY7aBUh9pQ==
X-CSE-MsgGUID: vS94t4dRQQ+/wN8bW4fE4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147253753"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:34 -0700
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
Subject: [RFC PATCH 2/4] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Date: Tue, 10 Jun 2025 10:14:20 +0800
Message-ID: <20250610021422.1214715-3-binbin.wu@linux.intel.com>
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

Handle TDVMCALL for GetQuote to generate a TD-Quote.

GetQuote is a doorbell-like interface used by TDX guests to request VMM
to generate a TD-Quote signed by a service hosting TD-Quoting Enclave
operating on the host.  A TDX guest passes a TD Report (TDREPORT_STRUCT) in
a shared-memory area as parameter.  Host VMM can access it and queue the
operation for a service hosting TD-Quoting enclave.  When completed, the
Quote is returned via the same shared-memory area.

KVM only checks the GPA from the TDX guest has the shared-bit set and drops
the shared-bit before exiting to userspace to avoid bleeding the shared-bit
into KVM's exit ABI.  KVM forwards the request to userspace VMM (e.g. QEMU)
and userspace VMM queues the operation asynchronously.  KVM sets the return
code according to the 'ret' field set by userspace to notify the TDX guest
whether the request has been queued successfully or not.  When the request
has been queued successfully, the TDX guest can poll the status field in
the shared-memory area to check whether the Quote generation is completed
or not.  When completed, the generated Quote is returned via the same
buffer.

Add KVM_EXIT_TDX_GET_QUOTE as a new exit reason to userspace. Userspace is
required to handle the KVM exit reason as the initial support for TDX,
however, userspace is allowed to set 'ret' filed to
TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Mikko Ylinen <mikko.ylinen@linux.intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
---
v2:
- Skip sanity checks except for the check of the shared-bit. (Rick, Sean)
- Drop the shared-bit of the GPA before exiting to userspace. (Sean)
- Improve the description of 'ret' field in the document. (Kai)
- Use number 40 for KVM_EXIT_TDX_GET_QUOTE. (Xiaoyao, Rick)
- Update the changelog and the description of KVM_EXIT_TDX_GET_QUOTE in the
  document according to the code changes.

RFC v1:
- Add "Acked-by" from Kai.
- State that KVM_EXIT_TDX_GET_QUOTE should be handled by userspace as the
  initial support for TDX.
- Remove a blank line.
---
 Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c         | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  7 +++++++
 3 files changed, 63 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424..7c5bb6b5c2c2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7174,6 +7174,33 @@ The valid value for 'flags' is:
   - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
     in VMCS. It would run into unknown result if resume the target VM.
 
+::
+
+		/* KVM_EXIT_TDX_GET_QUOTE */
+		struct tdx_get_quote {
+			__u64 ret;
+			__u64 gpa;
+			__u64 size;
+		};
+
+If the exit reason is KVM_EXIT_TDX_GET_QUOTE, then it indicates that a TDX
+guest has requested to generate a TD-Quote signed by a service hosting
+TD-Quoting Enclave operating on the host. The 'gpa' field and 'size' specify
+the guest physical address and size of a shared-memory buffer, in which the
+TDX guest passes a TD Report. KVM checks the GPA from the TDX guest has the
+shared-bit set and drops the shared-bit in 'gpa' field before exiting to
+userspace. KVM doesn't do other sanity checks. The 'ret' field represents the
+return value of the GetQuote request. KVM only bridges the request to the
+userspace VMM, and the userspace VMM is responsible for setting up the return
+value since only userspace knows whether the request has been queued
+successfully or not. KVM sets the return code according to the 'ret' field
+before returning back to the TDX guest. When the request has been queued
+successfully, the TDX guest can poll the status field in the shared-memory area
+to check whether the Quote generation is completed or not. When completed, the
+generated Quote is returned via the same buffer. Userspace is required to handle
+the KVM exit reason as the initial support for TDX, however, userspace is
+allowed to set 'ret' filed to TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED.
+
 ::
 
 		/* Fix the size of the union. */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8134d5805b03..35428c6b5a67 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1463,6 +1463,33 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_quote.ret);
+	return 1;
+}
+
+static int tdx_get_quote(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 gpa = tdx->vp_enter_args.r12;
+	u64 size = tdx->vp_enter_args.r13;
+
+	/* The gpa of buffer must have shared bit set. */
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX_GET_QUOTE;
+	vcpu->run->tdx_get_quote.gpa = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
+	vcpu->run->tdx_get_quote.size = size;
+
+	vcpu->arch.complete_userspace_io = tdx_complete_get_quote;
+
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1472,6 +1499,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_report_fatal_error(vcpu);
 	case TDVMCALL_GET_TD_VM_CALL_INFO:
 		return tdx_get_td_vm_call_info(vcpu);
+	case TDVMCALL_GET_QUOTE:
+		return tdx_get_quote(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d00b85cb168c..e63e4df468b5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX_GET_QUOTE    40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -447,6 +448,12 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX_GET_QUOTE */
+		struct {
+			__u64 ret;
+			__u64 gpa;
+			__u64 size;
+		} tdx_get_quote;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.46.0


