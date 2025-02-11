Return-Path: <kvm+bounces-37781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D5DBA301B9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A3B3A790E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E701D90C8;
	Tue, 11 Feb 2025 02:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZkbZLlsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40531D5ADB;
	Tue, 11 Feb 2025 02:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242398; cv=none; b=mexGWtvFHQ6tPHN64/vQuz77frfs5SLfEaMSvtu8ykX89tMZuvxe35wEPwjRccrHYwt/pAyEg9GtK4OOmmIpZGvjVyLFcpgmmctg0vszpnWkDaQ80O7Z0jSBS3G3A3u2WQZQL1+xlFCzEfc2fyjD0Or2IVmvV1kIyKoT5KZWVik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242398; c=relaxed/simple;
	bh=ZGE/gueTmxVzFHGbyM4Wo3MlwRXS6BvbhJZxWuqwHeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki73+xfKzTVTyBUICrWmcSdVKbUdow9HdrylDIybKIxwDd+K5vvDCJNtH1kdKaWi0i95Hz4niYWYgIqqvA06z8JLBVUdrT4Pdx3bmxtUNpOnqjhyqqVAWC7VP7TSdRT5Fq95cKxzCUUNRNVCeNW/BbsJKjU72PfZyrum5lYopbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZkbZLlsf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242398; x=1770778398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZGE/gueTmxVzFHGbyM4Wo3MlwRXS6BvbhJZxWuqwHeo=;
  b=ZkbZLlsftRi5JqJrdh5nZg4T8uFwHcayz4O3WCZqTHP0yHVbCI0kU7q5
   cWlneOsYqQTh7Bs7YYbAYJhetMo5mOLQkGGFM8qzh4xMiya+szl/X+fMP
   dYdsHQFT3YKVpX5LR4+4qSQGgHjIUWXcXStksq9D7NLbM72ULhJA75LU/
   g0CX8+wPCtAK9v5JpaPdO/Y/tIPtCvCJdBWHQ0ttTAfRIS1iqu1umwBZa
   eUqd9/lpfkaFSlaZa4MnN+bkVPiMwe4Yx0k2P1gH4zHGIz8sbRu+2+9RZ
   TbIP7YRN9ELv8Y1XrxopuWT6c/i7nzC9/7auTS5kHdycXPv2eH28UsDnZ
   Q==;
X-CSE-ConnectionGUID: 9xPKN3mYRGmPaed21WTiXg==
X-CSE-MsgGUID: 4SUbO0M7TSGBm9rGYeLYEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506606"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506606"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:17 -0800
X-CSE-ConnectionGUID: BHdYOP25RXWl46fxULl1Hg==
X-CSE-MsgGUID: eEENujGMQOWIDCecH9Fy5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236426"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:13 -0800
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
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 3/8] KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)
Date: Tue, 11 Feb 2025 10:54:37 +0800
Message-ID: <20250211025442.3071607-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a place holder and related helper functions for preparation of
TDG.VP.VMCALL handling.

The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
for the guest TD to call hypercall to VMM.  When the guest TD issues a
TDVMCALL, the guest TD exits to VMM with a new exit reason.  The arguments
from the guest TD and returned values from the VMM are passed in the guest
registers.  The guest RCX register indicates which registers are used.
Define helper functions to access those registers.

A new VMX exit reason TDCALL is added to indicate the exit is due to
TDVMCALL from the guest TD.  Define the TDCALL exit reason and add a place
holder to handle such exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
Hypercalls exit to userspace v2:
- Get/set tdvmcall inputs/outputs from/to vp_enter_args.
- Morph the guest requested exit reason (via TDVMCALL) to KVM's tracked
  exit reason when it could, i.e. when the TDVMCALL leaf number is less
  than 0x10000. (Sean)
- Drop helpers for read/write a0~a3.

Hypercalls exit to userspace v1:
- Update changelog.
- Drop the unused tdx->tdvmcall. (Chao)
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 arch/x86/include/uapi/asm/vmx.h |  4 ++-
 arch/x86/kvm/vmx/tdx.c          | 49 ++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index a5faf6d88f1b..6a9f268a2d2c 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -92,6 +92,7 @@
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
 #define EXIT_REASON_NOTIFY              75
+#define EXIT_REASON_TDCALL              77
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -155,7 +156,8 @@
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
-	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
+	{ EXIT_REASON_NOTIFY,                "NOTIFY" }, \
+	{ EXIT_REASON_TDCALL,                "TDCALL" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cb64675e6ad9..420ee492e919 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -235,6 +235,25 @@ static bool tdx_operand_busy(u64 err)
  */
 static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
 
+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
+{
+	return to_tdx(vcpu)->vp_enter_args.r10;
+}
+static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
+{
+	return to_tdx(vcpu)->vp_enter_args.r11;
+}
+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
+						     long val)
+{
+	to_tdx(vcpu)->vp_enter_args.r10 = val;
+}
+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
+						    unsigned long val)
+{
+	to_tdx(vcpu)->vp_enter_args.r11 = val;
+}
+
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
@@ -810,6 +829,7 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
 static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u32 exit_reason;
 
 	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
 	case TDX_SUCCESS:
@@ -822,7 +842,21 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 		return -1u;
 	}
 
-	return tdx->vp_enter_ret;
+	exit_reason = tdx->vp_enter_ret;
+
+	switch (exit_reason) {
+	case EXIT_REASON_TDCALL:
+		if (tdvmcall_exit_type(vcpu))
+			return EXIT_REASON_VMCALL;
+
+		if (tdvmcall_leaf(vcpu) < 0x10000)
+			return tdvmcall_leaf(vcpu);
+		break;
+	default:
+		break;
+	}
+
+	return exit_reason;
 }
 
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
@@ -930,6 +964,17 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
+static int handle_tdvmcall(struct kvm_vcpu *vcpu)
+{
+	switch (tdvmcall_leaf(vcpu)) {
+	default:
+		break;
+	}
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	return 1;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	u64 shared_bit = (pgd_level == 5) ? TDX_SHARED_BIT_PWL_5 :
@@ -1262,6 +1307,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
 		vcpu->mmio_needed = 0;
 		return 0;
+	case EXIT_REASON_TDCALL:
+		return handle_tdvmcall(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


