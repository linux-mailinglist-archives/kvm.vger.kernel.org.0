Return-Path: <kvm+bounces-53872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 112CDB18F8C
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 19:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E93964E04CD
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 17:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC40124DD0C;
	Sat,  2 Aug 2025 17:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="k9iWwwzw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001E313A3ED;
	Sat,  2 Aug 2025 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754154984; cv=none; b=Gq7BNxg4t/aJzFFpYhAcvlhrQXSTdeDhPgNkLegBDHlkeSUb9OhlDu4XeTTEmP5Is0S1rNTZcmjv0XKOgN0HiC9Z0CqwkBoKogkRcTWka0iwpPrRKHllctsrM+QDLFWHkoQT4t9vh86YIGbAzFwFkHRBjD2XgKYLlX195JS+P6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754154984; c=relaxed/simple;
	bh=rS//BWp/z7vcRf5ZkmQC5+tk6Tm23LTbrBFqKXDBRXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdYdI42h21uTN2HAN027fSo7X/E199OgwVZ1rFeoUuBdA/UyjUGgfxX3usnmGW8/nRj45Vgn1bf4D0z9M0uT/fNPWJ2N1Y+9lsR+qqBxVfA4CRMynwcyAMFNlMaULL8vhKLcC+Qc+dL2pWdvFsqXtip231tygf9QMMWDcjwoGZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=k9iWwwzw; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 572HFIBt3676810
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sat, 2 Aug 2025 10:15:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 572HFIBt3676810
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754154925;
	bh=F4Dopa/ZsJk9VbLLBS0/s4sLec5wp54sQ9YX3OvcZko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9iWwwzwUyE/k5nSHRisA5bNF8PPnreIaRo0OiKlXOUu6JLKVCqSKyO4im5PUQQxk
	 S/O0YZeJFeGHIqxJq1+Ua4xfV/r6gZFy96xot1qgrui5VM6GWEfAEofpBKWceCteeP
	 U5Sm13Ima3W6q+uboO2U8XSwbmcgx/XPYiuXfufLRjJ839FmC0ia5tiAkNsRukaytV
	 +t3qtrL0l5tz6p75yhjq5R9JDO8QUCRpOh8CwkRY3s60vUmodJoHXKE4dpLsrnuN9f
	 7x58qy4k+kT/m7a6gDeIdZyCQ2Ayklm+9uS8LrB13/FHhRDfYV5VNmb/+KbNY0C5+r
	 tzxEF2VLEU7cA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5A 10/23] KVM: VMX: Add support for FRED context save/restore
Date: Sat,  2 Aug 2025 10:15:18 -0700
Message-ID: <20250802171518.3676800-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aIHGFpKfkyDisYaZ@intel.com>
References: <aIHGFpKfkyDisYaZ@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Handle FRED MSR access requests, allowing FRED context to be set/get
from both host and guest.

During VM save/restore and live migration, FRED context needs to be
saved/restored, which requires FRED MSRs to be accessed from userspace,
e.g., Qemu.

Note, handling of MSR_IA32_FRED_SSP0, i.e., MSR_IA32_PL0_SSP, is not
added yet, which is done in the KVM CET patch set.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5A:
* Return KVM_MSR_RET_UNSUPPORTED instead of 1 when FRED is not available
  (Chao Gao)

Change in v5:
* Use the newly added guest MSR read/write helpers (Sean).
* Check the size of fred_msr_vmcs_fields[] using static_assert() (Sean).
* Rewrite setting FRED MSRs to make it much easier to read (Sean).
* Add TB from Xuelian Guo.

Changes since v2:
* Add a helper to convert FRED MSR index to VMCS field encoding to
  make the code more compact (Chao Gao).
* Get rid of the "host_initiated" check because userspace has to set
  CPUID before MSRs (Chao Gao & Sean Christopherson).
* Address a few cleanup comments (Sean Christopherson).

Changes since v1:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
* Fail host requested FRED MSRs access if KVM cannot virtualize FRED
  (Chao Gao).
* Handle the case FRED MSRs are valid but KVM cannot virtualize FRED
  (Chao Gao).
* Add sanity checks when writing to FRED MSRs.
---
 arch/x86/kvm/vmx/vmx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     | 42 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 53dce136e24b..fd995787b6cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1388,6 +1388,18 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 	vmx_write_guest_host_msr(vmx, MSR_KERNEL_GS_BASE, data,
 				 &vmx->msr_guest_kernel_gs_base);
 }
+
+static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
+{
+	return vmx_read_guest_host_msr(vmx, MSR_IA32_FRED_RSP0,
+				       &vmx->msr_guest_fred_rsp0);
+}
+
+static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
+{
+	vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
+				 &vmx->msr_guest_fred_rsp0);
+}
 #endif
 
 static void grow_ple_window(struct kvm_vcpu *vcpu)
@@ -1989,6 +2001,27 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
 	}
 }
 
+#ifdef CONFIG_X86_64
+static const u32 fred_msr_vmcs_fields[] = {
+	GUEST_IA32_FRED_RSP1,
+	GUEST_IA32_FRED_RSP2,
+	GUEST_IA32_FRED_RSP3,
+	GUEST_IA32_FRED_STKLVLS,
+	GUEST_IA32_FRED_SSP1,
+	GUEST_IA32_FRED_SSP2,
+	GUEST_IA32_FRED_SSP3,
+	GUEST_IA32_FRED_CONFIG,
+};
+
+static_assert(MSR_IA32_FRED_CONFIG - MSR_IA32_FRED_RSP1 ==
+	      ARRAY_SIZE(fred_msr_vmcs_fields) - 1);
+
+static u32 fred_msr_to_vmcs(u32 msr)
+{
+	return fred_msr_vmcs_fields[msr - MSR_IA32_FRED_RSP1];
+}
+#endif
+
 /*
  * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
  * Returns 0 on success, non-0 otherwise.
@@ -2011,6 +2044,12 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KERNEL_GS_BASE:
 		msr_info->data = vmx_read_guest_kernel_gs_base(vmx);
 		break;
+	case MSR_IA32_FRED_RSP0:
+		msr_info->data = vmx_read_guest_fred_rsp0(vmx);
+		break;
+	case MSR_IA32_FRED_RSP1 ... MSR_IA32_FRED_CONFIG:
+		msr_info->data = vmcs_read64(fred_msr_to_vmcs(msr_info->index));
+		break;
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
@@ -2234,6 +2273,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx_update_exception_bitmap(vcpu);
 		}
 		break;
+	case MSR_IA32_FRED_RSP0:
+		vmx_write_guest_fred_rsp0(vmx, data);
+		break;
+	case MSR_IA32_FRED_RSP1 ... MSR_IA32_FRED_CONFIG:
+		vmcs_write64(fred_msr_to_vmcs(msr_index), data);
+		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		if (is_guest_mode(vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..8c87c154cf7d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -323,6 +323,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
+	MSR_IA32_FRED_RSP0, MSR_IA32_FRED_RSP1, MSR_IA32_FRED_RSP2,
+	MSR_IA32_FRED_RSP3, MSR_IA32_FRED_STKLVLS, MSR_IA32_FRED_SSP1,
+	MSR_IA32_FRED_SSP2, MSR_IA32_FRED_SSP3, MSR_IA32_FRED_CONFIG,
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
@@ -1870,6 +1873,37 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
 		data = (u32)data;
 		break;
+	case MSR_IA32_FRED_STKLVLS:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
+	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG:
+		u64 reserved_bits = 0;
+
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+
+		if (is_noncanonical_msr_address(data, vcpu))
+			return 1;
+
+		switch (index) {
+		case MSR_IA32_FRED_CONFIG:
+			reserved_bits = BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2);
+			break;
+		case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
+			reserved_bits = GENMASK_ULL(5, 0);
+			break;
+		case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_SSP3:
+			reserved_bits = GENMASK_ULL(2, 0);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return 1;
+		}
+		if (data & reserved_bits)
+			return 1;
+		break;
 	}
 
 	msr.data = data;
@@ -1914,6 +1948,10 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
 	}
 
 	msr.index = index;
@@ -7365,6 +7403,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
 			return;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.50.1


