Return-Path: <kvm+bounces-59961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3B7BD6EA7
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17319420058
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8542580DE;
	Tue, 14 Oct 2025 01:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dgzTIyq+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10519F48D;
	Tue, 14 Oct 2025 01:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404238; cv=none; b=lpef5hzIjqxyWhaj+UNAIZrYthcP29pIQ8y7wbAciIO/t3hIjAo+HJlS/+1QO8XTvmU3UG6iPDNXK/rxyTliPvqjG38ANrEXvH7TOuAaMx/SVr/r7ResisnJkiuZF9a03PTsbgVqgw3yc3LedvblgPRiZZC4bw/fuzfvh96OGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404238; c=relaxed/simple;
	bh=uIJN3VdN1mUAT5jTOI6pi2Bgh1By/v/hWWmxwuQXcPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJhkRQF9AchJvbP0YdnUIXonoyds+IQYqTnNZRDMp4VmPEPR4NBjaaNs2HH1XpLZUFnG6MWy7vKEj0yZYzcrvj+88RdRaREEPpCL+ndBWz+/LZbFaxvu0H5q54o05wii1Ex0K/oasSV7SO/DyY9wzFJI2sVxfTvKx1ZqRlphAvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dgzTIyq+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1W1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1W1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404204;
	bh=/UBGMbczMLj4pPauT6AJ4EIz1iBt7oMw+LqWmfBkdAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgzTIyq+dgLLvWm2YMuNip3clEirOJ5syVCchsLnqOnGBCa1G6xp+cWo3dB/uy5d6
	 c1JYg1ijmIvMmCos375oXEL1Ik9T/ABn274nSfDw5NO0c0V4MsZGgLon39IwUfiB56
	 VJPXWG+1sN11qnhQfNKayA4HN1DaK3CVHW0bny59BLeod2O+dVPJ5dIMOdfDnDzN0c
	 SO9eltUmMTPjpykTmoEUTLbD5X75I75zZsx5nB9xh81KF4k0XuMHe7VCswrMPh6nDn
	 Y2c0CN0o0dTdFeyEi4Nwbx4GxF8qzo0kew27mXauZlRpawqXCuiBS3hAkefli8OqQM
	 Fki8JW6Mo7gZA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 09/21] KVM: VMX: Add support for saving and restoring FRED MSRs
Date: Mon, 13 Oct 2025 18:09:38 -0700
Message-ID: <20251014010950.1568389-10-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Introduce support for handling FRED MSR access requests, enabling both
host and guest to read and write FRED MSRs, which is essential for VM
save/restore and live migration, and allows userspace tools such as QEMU
to access the relevant MSRs.

Specially, intercept accesses to the FRED SSP0 MSR (IA32_PL0_SSP), which
remains accessible when FRED is enumerated even if CET is not.  This
ensures the guest value is fully virtual and does not alter the hardware
FRED SSP0 MSR.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v7:
* Intercept accesses to FRED SSP0, i.e., IA32_PL0_SSP, which remains
  accessible when FRED but !CET (Sean).

Change in v6:
* Return KVM_MSR_RET_UNSUPPORTED instead of 1 when FRED is not available
  (Chao Gao)
* Handle MSR_IA32_PL0_SSP when FRED is enumerated but CET not.

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
 arch/x86/include/asm/kvm_host.h |  5 ++
 arch/x86/kvm/vmx/vmx.c          | 45 +++++++++++++++++
 arch/x86/kvm/x86.c              | 85 +++++++++++++++++++++++++++++++--
 3 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..43a18e265289 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1092,6 +1092,11 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+	/*
+	 * Stores the FRED SSP0 MSR when CET is not supported, prompting KVM
+	 * to intercept its accesses.
+	 */
+	u64 fred_ssp0_fallback;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ea660c0481c..f797e6b12721 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1386,6 +1386,18 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
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
@@ -1987,6 +1999,27 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
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
@@ -2009,6 +2042,12 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2241,6 +2280,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 42ecd093bb4c..80c490e71853 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -331,6 +331,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
+	MSR_IA32_FRED_RSP0, MSR_IA32_FRED_RSP1, MSR_IA32_FRED_RSP2,
+	MSR_IA32_FRED_RSP3, MSR_IA32_FRED_STKLVLS, MSR_IA32_FRED_SSP1,
+	MSR_IA32_FRED_SSP2, MSR_IA32_FRED_SSP3, MSR_IA32_FRED_CONFIG,
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
@@ -1919,7 +1922,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * architecture. Intercepting XRSTORS/XSAVES for this
 		 * special case isn't deemed worthwhile.
 		 */
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_INT_SSP_TAB:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
 			return KVM_MSR_RET_UNSUPPORTED;
 		/*
@@ -1934,6 +1937,52 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
 			return 1;
 		break;
+	case MSR_IA32_FRED_STKLVLS:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
+	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG: {
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
+
+		if (data & reserved_bits)
+			return 1;
+
+		break;
+	}
+	case MSR_IA32_PL0_SSP: /* I.e., MSR_IA32_FRED_SSP0 */
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+
+		if (is_noncanonical_msr_address(data, vcpu))
+			return 1;
+
+		if (!IS_ALIGNED(data, 4))
+			return 1;
+
+		break;
 	}
 
 	msr.data = data;
@@ -1988,10 +2037,19 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		if (!host_initiated)
 			return 1;
 		fallthrough;
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_INT_SSP_TAB:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
 			return KVM_MSR_RET_UNSUPPORTED;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_IA32_PL0_SSP: /* I.e., MSR_IA32_FRED_SSP0 */
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
 	}
 
 	msr.index = index;
@@ -4316,6 +4374,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+			WARN_ON_ONCE(msr != MSR_IA32_FRED_SSP0);
+			vcpu->arch.fred_ssp0_fallback = data;
+			break;
+		}
+
 		kvm_set_xstate_msr(vcpu, msr_info);
 		break;
 	default:
@@ -4669,6 +4733,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+			WARN_ON_ONCE(msr_info->index != MSR_IA32_FRED_SSP0);
+			msr_info->data = vcpu->arch.fred_ssp0_fallback;
+			break;
+		}
+
 		kvm_get_xstate_msr(vcpu, msr_info);
 		break;
 	default:
@@ -7712,10 +7782,19 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
 			return;
 		fallthrough;
-	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 			return;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
+			return;
+		break;
+	case MSR_IA32_PL0_SSP: /* I.e., MSR_IA32_FRED_SSP0 */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_FRED))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.51.0


