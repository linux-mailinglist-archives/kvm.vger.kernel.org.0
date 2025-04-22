Return-Path: <kvm+bounces-43767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDDEA96161
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F959175DA7
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5088825E469;
	Tue, 22 Apr 2025 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="PDVPu9XQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5DB248864;
	Tue, 22 Apr 2025 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310232; cv=none; b=QPILZOR3ZJ3YFjd7C9/2tSdwmFUJ+y+20TQkV+e4mlnrRoXQlW8BCPPUTfsgXE7+CZBnrNBcYJ/187RRc7EszHFWEiYptaYus3tzzOF/KGzztrfeyp9BfSnEuSDzB2BLhi+mzt3D95CUNFjfLCIujhT6wli8keUoXJFrOo1mW4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310232; c=relaxed/simple;
	bh=WKHBXzCIM8dhgpIt8w/1Ozp+xY8OjqWfA3OriCcjuiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ungmZS7O/iUHq6MMEp5cchikf+oW7pBMqMLaX8twwFTATfVRmHZHiZLrJyYlw+kcCeHpl7XEAek29M3CmCaY0kOqBNTzlq9iGgjEUzle/Es+VclUWviu12E7wByJotCX58IlXd3OG5x62NloxGdkvK5vujF8hZCPF0kONfOqYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=PDVPu9XQ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9d1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9d1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310193;
	bh=surLjFBivIIEufZnV9GysArl3hqE7z9bLE2rz9eXLVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDVPu9XQHbsy+9zMB77AuUPJAFzP6+3MovevbJMBmQVh/3iVUCYwI5Ng1h0xT30vm
	 X8HfQftwL0hag/dd4pb7oRSGGFlpdc5yUKF1aLAtQjdTnu6WUfuwsxheUgx5rH1l3I
	 VFJ+eXJ5UUCW8fv8acq5ydfQce4mXeEXCPGFye3tcXqJaX2GSNUs4pIGDEhbMrQ960
	 oBgHwyc9FaWWsdewM2UB4aEXKOAPOSMghbAOOdGe/uEpV21elRfjtANUuRWv5NbX/h
	 S8xE7Lxl3sNA9/kFkD2QVJVloW74MhhCeuDf/dOEyAHbDkTIynJQA/jRK7RFP66Jf1
	 hLdcobD2D4VHQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 25/34] x86/msr: Rename native_wrmsrq() to native_wrmsrq_no_trace()
Date: Tue, 22 Apr 2025 01:22:06 -0700
Message-ID: <20250422082216.1954310-26-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

native_wrmsrq() doesn't do trace thus can be used in noinstr context,
rename it to native_wrmsrq_no_trace() to make it explicit.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/events/amd/brs.c                 | 2 +-
 arch/x86/hyperv/ivm.c                     | 2 +-
 arch/x86/include/asm/apic.h               | 2 +-
 arch/x86/include/asm/fred.h               | 2 +-
 arch/x86/include/asm/microcode.h          | 2 +-
 arch/x86/include/asm/msr.h                | 8 ++++----
 arch/x86/include/asm/sev-internal.h       | 2 +-
 arch/x86/include/asm/spec-ctrl.h          | 2 +-
 arch/x86/kernel/cpu/mce/core.c            | 2 +-
 arch/x86/kernel/cpu/microcode/amd.c       | 2 +-
 arch/x86/kernel/cpu/microcode/intel.c     | 2 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 2 +-
 arch/x86/kvm/vmx/vmx.c                    | 8 ++++----
 13 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index 06f35a6b58a5..0153616a97cd 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -44,7 +44,7 @@ static inline unsigned int brs_to(int idx)
 static __always_inline void set_debug_extn_cfg(u64 val)
 {
 	/* bits[4:3] must always be set to 11b */
-	native_wrmsrq(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);
+	native_wrmsrq_no_trace(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);
 }
 
 static __always_inline u64 get_debug_extn_cfg(void)
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 09a165a3c41e..821609af5bd2 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -116,7 +116,7 @@ static inline u64 rd_ghcb_msr(void)
 
 static inline void wr_ghcb_msr(u64 val)
 {
-	native_wrmsrq(MSR_AMD64_SEV_ES_GHCB, val);
+	native_wrmsrq_no_trace(MSR_AMD64_SEV_ES_GHCB, val);
 }
 
 static enum es_result hv_ghcb_hv_call(struct ghcb *ghcb, u64 exit_code,
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 68e10e30fe9b..442127c3e1f5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -214,7 +214,7 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 
 static inline void native_apic_msr_eoi(void)
 {
-	native_wrmsrq(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK);
+	native_wrmsrq_no_trace(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK);
 }
 
 static inline u32 native_apic_msr_read(u32 reg)
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 8ae4429e5401..3a58545415d9 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -101,7 +101,7 @@ static __always_inline void fred_update_rsp0(void)
 	unsigned long rsp0 = (unsigned long) task_stack_page(current) + THREAD_SIZE;
 
 	if (cpu_feature_enabled(X86_FEATURE_FRED) && (__this_cpu_read(fred_rsp0) != rsp0)) {
-		native_wrmsrq(MSR_IA32_FRED_RSP0, rsp0);
+		native_wrmsrq_no_trace(MSR_IA32_FRED_RSP0, rsp0);
 		__this_cpu_write(fred_rsp0, rsp0);
 	}
 }
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 107a1aaa211b..da482f430d80 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -63,7 +63,7 @@ static inline u32 intel_get_microcode_revision(void)
 {
 	u32 rev, dummy;
 
-	native_wrmsrq(MSR_IA32_UCODE_REV, 0);
+	native_wrmsrq_no_trace(MSR_IA32_UCODE_REV, 0);
 
 	/* As documented in the SDM: Do a CPUID 1 here */
 	native_cpuid_eax(1);
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 5271cb002b23..d130bdeed3ce 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -366,7 +366,7 @@ static __always_inline int rdmsrq_safe(u32 msr, u64 *val)
  *                         __native_wrmsrq()   -----------------------
  *                            /     \                                |
  *                           /       \                               |
- *               native_wrmsrq()    native_write_msr_safe()          |
+ *        native_wrmsrq_no_trace()    native_write_msr_safe()        |
  *                   /    \                                          |
  *                  /      \                                         |
  *      native_wrmsr()    native_write_msr()                         |
@@ -462,19 +462,19 @@ static __always_inline bool __native_wrmsrq(u32 msr, u64 val, int type)
 	return __native_wrmsrq_variable(msr, val, type);
 }
 
-static __always_inline void native_wrmsrq(u32 msr, u64 val)
+static __always_inline void native_wrmsrq_no_trace(u32 msr, u64 val)
 {
 	__native_wrmsrq(msr, val, EX_TYPE_WRMSR);
 }
 
 static __always_inline void native_wrmsr(u32 msr, u32 low, u32 high)
 {
-	native_wrmsrq(msr, (u64)high << 32 | low);
+	native_wrmsrq_no_trace(msr, (u64)high << 32 | low);
 }
 
 static inline void notrace native_write_msr(u32 msr, u64 val)
 {
-	native_wrmsrq(msr, val);
+	native_wrmsrq_no_trace(msr, val);
 
 	if (tracepoint_enabled(write_msr))
 		do_trace_write_msr(msr, val, 0);
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index d259bcec220a..7eb030702435 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -101,7 +101,7 @@ static inline u64 sev_es_rd_ghcb_msr(void)
 
 static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 {
-	native_wrmsrq(MSR_AMD64_SEV_ES_GHCB, val);
+	native_wrmsrq_no_trace(MSR_AMD64_SEV_ES_GHCB, val);
 }
 
 enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index 00b7e0398210..8cf69849bbbe 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -84,7 +84,7 @@ static inline u64 ssbd_tif_to_amd_ls_cfg(u64 tifn)
 static __always_inline void __update_spec_ctrl(u64 val)
 {
 	__this_cpu_write(x86_spec_ctrl_current, val);
-	native_wrmsrq(MSR_IA32_SPEC_CTRL, val);
+	native_wrmsrq_no_trace(MSR_IA32_SPEC_CTRL, val);
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index b854a60238de..bd3cb984ccb9 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1321,7 +1321,7 @@ static noinstr bool mce_check_crashing_cpu(void)
 		}
 
 		if (mcgstatus & MCG_STATUS_RIPV) {
-			native_wrmsrq(MSR_IA32_MCG_STATUS, 0);
+			native_wrmsrq_no_trace(MSR_IA32_MCG_STATUS, 0);
 			return true;
 		}
 	}
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 1798a6c027f8..41c553396500 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -607,7 +607,7 @@ static bool __apply_microcode_amd(struct microcode_amd *mc, u32 *cur_rev,
 	if (!verify_sha256_digest(mc->hdr.patch_id, *cur_rev, (const u8 *)p_addr, psize))
 		return false;
 
-	native_wrmsrq(MSR_AMD64_PATCH_LOADER, p_addr);
+	native_wrmsrq_no_trace(MSR_AMD64_PATCH_LOADER, p_addr);
 
 	if (x86_family(bsp_cpuid_1_eax) == 0x17) {
 		unsigned long p_addr_end = p_addr + psize - 1;
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 86e1047f738f..26e13dc4cedd 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -320,7 +320,7 @@ static enum ucode_state __apply_microcode(struct ucode_cpu_info *uci,
 	}
 
 	/* write microcode via MSR 0x79 */
-	native_wrmsrq(MSR_IA32_UCODE_WRITE, (unsigned long)mc->bits);
+	native_wrmsrq_no_trace(MSR_IA32_UCODE_WRITE, (unsigned long)mc->bits);
 
 	rev = intel_get_microcode_revision();
 	if (rev != mc->hdr.rev)
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index cc534a83f19d..e970a0de894f 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -483,7 +483,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * cache.
 	 */
 	saved_msr = native_rdmsrq(MSR_MISC_FEATURE_CONTROL);
-	native_wrmsrq(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
+	native_wrmsrq_no_trace(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 	closid_p = this_cpu_read(pqr_state.cur_closid);
 	rmid_p = this_cpu_read(pqr_state.cur_rmid);
 	mem_r = plr->kmem;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e73c1d5ba6c4..b53575dee64a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -382,7 +382,7 @@ static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 
 	msr = native_rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 	msr |= FB_CLEAR_DIS;
-	native_wrmsrq(MSR_IA32_MCU_OPT_CTRL, msr);
+	native_wrmsrq_no_trace(MSR_IA32_MCU_OPT_CTRL, msr);
 	/* Cache the MSR value to avoid reading it later */
 	vmx->msr_ia32_mcu_opt_ctrl = msr;
 }
@@ -393,7 +393,7 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
 		return;
 
 	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
-	native_wrmsrq(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+	native_wrmsrq_no_trace(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
 }
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
@@ -6745,7 +6745,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	vcpu->stat.l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		native_wrmsrq_no_trace(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
 		return;
 	}
 
@@ -7318,7 +7318,7 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
 	    vmx->spec_ctrl != hostval)
-		native_wrmsrq(MSR_IA32_SPEC_CTRL, hostval);
+		native_wrmsrq_no_trace(MSR_IA32_SPEC_CTRL, hostval);
 
 	barrier_nospec();
 }
-- 
2.49.0


