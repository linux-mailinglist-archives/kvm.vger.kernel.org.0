Return-Path: <kvm+bounces-48770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EC5AD2BDD
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB1751711D8
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 02:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0C0242935;
	Tue, 10 Jun 2025 02:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bh9gMIWC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F86242909;
	Tue, 10 Jun 2025 02:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521627; cv=none; b=Cub3sn6tds54pBsM7qusL6pLFQ5/Urm86JKk4nHb9o+Oq3go+9jQqzkB0GLBY3m3XMErHkwZwvtIqFEhxHcjYARzL7T7kHI72K73bDSwupAwlwG99BHYyRfBebTMLg8oglPOynTg4EUMTtFV3TFS9bbqKD/XHsSSktkqj9I3KdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521627; c=relaxed/simple;
	bh=qyS3Hw2HNbn8etjY4K2OSgsAtv5O5q2J4SVd6WFY+mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9U21MYqF77ZFl0B8mB/Ltbfz2mgQyawiT8J2ySa2KVLBXOb9Hgk0uSXcxu1imn8UKIF6XF3rGOAobhNgtjMdNOnzw8fCojvM87QFCbJ5kV5ZxuFxcpH3FM+OJRPYO5nZFMsYnL6Yrj9JpkoJAprRtoGFdCoDoxnYinHkNFEHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bh9gMIWC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749521625; x=1781057625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qyS3Hw2HNbn8etjY4K2OSgsAtv5O5q2J4SVd6WFY+mE=;
  b=bh9gMIWCHeVjUwJ4ObFuw5qVCgE7JnYld3fqyRhhfW+Inzfp3cNLx+Fh
   blUTB24TQkp2or6mOPVs5rXz+TQV1M/wppDHTIsKa24TaFt3XkxqtrYHe
   XkpDvbKankYDkErmC3pZfOathwE6xSrunwi/iAo3qSVC7o6xn8NJHzKj4
   OuHPmxCAnrqqriaKxbPt26VQ6WczVjPLxWBqxhLhLeB41sL1LXaG8jBHN
   ZuEr5Rvpil8+QNYzimQQBzBkZN5XoivRl9exgAXxlNy9aeCxikKusdZvy
   y3AXOdLzJnjeOPhfRlIlvowzQCbVMLExkPlSInJOr3rLhDzZxkRh3HU2I
   w==;
X-CSE-ConnectionGUID: txyOR1i6TPyAi6UZozeIiw==
X-CSE-MsgGUID: zVv6fdP9TLitAO13mBQAEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="50841194"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="50841194"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:42 -0700
X-CSE-ConnectionGUID: PEaS6U6hQp203jiLLgnoQw==
X-CSE-MsgGUID: IbSenGuBQbSLNYL7saY6ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147253784"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:38 -0700
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
Subject: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Date: Tue, 10 Jun 2025 10:14:21 +0800
Message-ID: <20250610021422.1214715-4-binbin.wu@linux.intel.com>
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

Exit to userspace for TDG.VP.VMCALL<GetTdVmCallInfo> via a new KVM exit
reason to allow userspace to provide information about the support of
TDVMCALLs when r12 is 1 for the TDVMCALLs beyond the GHCI base API.

GHCI spec defines the GHCI base TDVMCALLs: <GetTdVmCallInfo>, <MapGPA>,
<ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
<Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
<Instruction.WRMSR>. They must be supported by VMM to support TDX guests.

For GetTdVmCallInfo
- When leaf (r12) to enumerate TDVMCALL functionality is set to 0,
  successful execution indicates all GHCI base TDVMCALLs listed above are
  supported.

  Update the KVM TDX document with the set of the GHCI base APIs.

- When leaf (r12) to enumerate TDVMCALL functionality is set to 1, it
  indicates the TDX guest is querying the supported TDVMCALLs beyond
  the GHCI base TDVMCALLs.
  Exit to userspace to let userspace set the TDVMCALL sub-function bit(s)
  accordingly to the leaf outputs.  KVM could set the TDVMCALL bit(s)
  supported by itself when the TDVMCALLs don't need support from userspace
  after returning from userspace and before entering guest. Currently, no
  such TDVMCALLs implemented, KVM just sets the values returned from
  userspace.

  A new KVM exit reason KVM_EXIT_TDX_GET_TDVMCALL_INFO and its structure
  are added. Userspace is required to handle the exit reason as the initial
  support for TDX.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 Documentation/virt/kvm/api.rst           | 17 +++++++++++
 Documentation/virt/kvm/x86/intel-tdx.rst |  9 ++++++
 arch/x86/kvm/vmx/tdx.c                   | 36 +++++++++++++++++++++---
 include/uapi/linux/kvm.h                 |  7 +++++
 4 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7c5bb6b5c2c2..4a729841e000 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7201,6 +7201,23 @@ generated Quote is returned via the same buffer. Userspace is required to handle
 the KVM exit reason as the initial support for TDX, however, userspace is
 allowed to set 'ret' filed to TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED.
 
+::
+
+		/* KVM_EXIT_TDX_GET_TDVMCALL_INFO */
+		struct tdx_get_tdvmcall_info {
+			__u64 ret;
+			__u64 leaf;
+			__u64 leaf_output[4];
+		};
+
+If the exit reason is KVM_EXIT_TDX_GET_TDVMCALL_INFO, then it indicates that a
+TDX guest has requested to get the supporting status of TDVMCALLs. Currently,
+KVM only exits to userspace when the leaf value is 1, i.e, the TDX guest is
+querying the supporting status of TDVMCALLs beyond the GHCI base TDVMCALLs.
+Userspace is expected to set leaf outputs according to the layout defined in
+the GHCI spec if they are supported by userspace. Userspace is required to
+handle the exit reason as the initial support for TDX.
+
 ::
 
 		/* Fix the size of the union. */
diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 76bdd95334d6..69c64453e9ca 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -249,6 +249,15 @@ control flow is as follows:
 
 #. Run VCPU
 
+The GHCI base TDVMCALLs
+=======================
+The GHCI base TDVMCALLs are: <GetTdVmCallInfo>, <MapGPA>, <ReportFatalError>,
+<Instruction.CPUID>, <#VE.RequestMMIO>, <Instruction.HLT>, <Instruction.IO>,
+<Instruction.RDMSR> and <Instruction.WRMSR>. These base TDVMCALLs are mandatory
+for VMMs to support TDX guests.
+For the TDVMCALLs beyond the GHCI base TDVMCALLs, TDX guests can query the
+support status via GetTdVmCallInfo with leaf set to 1.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 35428c6b5a67..a3cd68f44a9c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1449,18 +1449,46 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_get_tdcall_info(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_tdvmcall_info.ret);
+
+	/*
+	 * For now, there is no TDVMCALL beyond GHCI base API supported by KVM
+	 * directly without the support from userspace, just set the value
+	 * returned from userspace.
+	 */
+	tdx->vp_enter_args.r11 = vcpu->run->tdx_get_tdvmcall_info.leaf_output[0];
+	tdx->vp_enter_args.r12 = vcpu->run->tdx_get_tdvmcall_info.leaf_output[1];
+	tdx->vp_enter_args.r13 = vcpu->run->tdx_get_tdvmcall_info.leaf_output[2];
+	tdx->vp_enter_args.r14 = vcpu->run->tdx_get_tdvmcall_info.leaf_output[3];
+
+	return 1;
+}
+
 static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-	if (tdx->vp_enter_args.r12)
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
-	else {
+	switch (tdx->vp_enter_args.r12) {
+	case 0:
 		tdx->vp_enter_args.r11 = 0;
 		tdx->vp_enter_args.r13 = 0;
 		tdx->vp_enter_args.r14 = 0;
+		return 1;
+	case 1:
+		vcpu->run->tdx_get_tdvmcall_info.leaf = 1;
+		vcpu->run->exit_reason = KVM_EXIT_TDX_GET_TDVMCALL_INFO;
+		vcpu->arch.complete_userspace_io = tdx_complete_get_tdcall_info;
+		memset(vcpu->run->tdx_get_tdvmcall_info.leaf_output, 0,
+		       sizeof(vcpu->run->tdx_get_tdvmcall_info.leaf_output));
+		return 0;
+	default:
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
 	}
-	return 1;
 }
 
 static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e63e4df468b5..0729b37ac911 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX_GET_QUOTE    40
+#define KVM_EXIT_TDX_GET_TDVMCALL_INFO  41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -454,6 +455,12 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} tdx_get_quote;
+		/* KVM_EXIT_TDX_GET_TDVMCALL_INFO */
+		struct {
+			__u64 ret;
+			__u64 leaf;
+			__u64 leaf_output[4];
+		} tdx_get_tdvmcall_info;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.46.0


