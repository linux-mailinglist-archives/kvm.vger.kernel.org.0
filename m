Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB7F70EA20
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 02:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbjEXANq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 20:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbjEXANo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 20:13:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3377DE5
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:13:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8337a5861so1003132276.0
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684887220; x=1687479220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lx1WVgYfC1pRSc1qrXZSrJ51I+kVC4qLHdQWzCfeVrM=;
        b=w5mxfpys81PPE7EHmsV+8qihYmIqEO4aaswW55m1Nrtecm0kfG6CU1cFv59v/S4Do9
         GYwbxRHrRPnvVUkJNex8dJe96MDznBuapFU8PR9mMLWFdhyarxfsGIqoCNRU/rMGUcKY
         /hC9N19tNO6QgiDR8L0B29Fdl12vJ3HT51Gdh+fZNI8ZS1Md848IFMHEOKU03ImQsg5q
         NdlulIa3Ggv2Gq+8hY9eJzAtBVaLvWyXpyISO2FntoPFtoT87xmpsPBL7Pg3GB0JKCyU
         LD7euO4jB6JTh00MVTvYPAcRdAyvpDsIOQt+enjk2y6K6ACND7ey32YagoRekzSDO0fl
         0pRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684887220; x=1687479220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lx1WVgYfC1pRSc1qrXZSrJ51I+kVC4qLHdQWzCfeVrM=;
        b=KKRSQDDg/DPgWJyomyqqveKroovrFnMWT5xyHWeWQpF+tc1cX/jQ3qfzKzwvsKY7dW
         +/Ara5WET1/tvQGNmY/I/MBIAfw3rTdA95ZxcYE3c0yEH14pUY6dAlZWjx5SkcSBFIVy
         AYPiUrhQIeeFxQmlnO5KQT+luzeYbO8rXtBcJHsEDqo77ILlUiD8wSjcdxrF/XHXoaRn
         in3UQexVChJvP2llUIBFR13LQX+C3y97d4xgDGounuBhGapkNkhiSLOjPwchfecBvG3w
         OhH0jvgIPArD7RrEWulEDv1+wr0l3aKbKcj3S1e5GfZp2SzPKdjnPaINab40Ro90Khen
         Hg/Q==
X-Gm-Message-State: AC+VfDwAOe8wEQynn4BkXLtxRFJD2h74wPhA0TNZmjvTle+XWMfNRYwO
        QfQ1bNkvH1o2HAFZrE6C0XiMZeBqmso=
X-Google-Smtp-Source: ACHHUZ77yCmstdpyYOa+vw0A+oxpuZ8Uwc42kisQURohKkfrK//s++J4WLzwkMqJNN0YVty/P6gc+PKsluQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9284:0:b0:b8f:5474:2f33 with SMTP id
 y4-20020a259284000000b00b8f54742f33mr9056778ybl.5.1684887220472; Tue, 23 May
 2023 17:13:40 -0700 (PDT)
Date:   Tue, 23 May 2023 17:13:38 -0700
In-Reply-To: <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com> <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
Message-ID: <ZG1WsnYST4zLqTnv@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023, Yan Zhao wrote:
> On Sun, May 21, 2023 at 11:44:36AM +0800, Robert Hoo wrote:
> > On 5/9/2023 9:53 PM, Yan Zhao wrote:
> > > Keep a per-VM MTRR state and point it to the MTRR state of vCPU 0.
> > > 
> > > This is a preparation patch for KVM to reference a per-VM guest MTRR
> > > to decide memory type of EPT leaf entries when noncoherent DMA is present.
> > > 
> > > Though each vCPU has its own MTRR state, MTRR states should be
> > > consistent across each VM, which is demanded as in Intel's SDM
> > > "In a multiprocessor system using a processor in the P6 family or a more
> > > recent family, each processor MUST use the identical MTRR memory map so
> > > that software will have a consistent view of memory."
> > > 
> > > Therefore, when memory type of EPT leaf entry needs to honor guest MTRR,
> > > a per-VM version of guest MTRR can be referenced.
> > > 
> > > Each vCPU still has its own MTRR state field to keep guest rdmsr()
> > > returning the right value when there's lag of MTRR update for each vCPU.
> > > 
> > Can we get rid of per-vCPU MTRR state copies and just have this per-VM state
> > only? therefore can simplify implementation and avoid hazard of
> > inconsistency among per-VPU MTRR states.
> > 
> > I see in SDM, it notes:
> > "In multiple processor systems, the operating system must maintain MTRR
> > consistency between all the processors in the system (that is, all
> > processors must use the same MTRR values). The P6 and more recent processor
> > families provide no hardware support for maintaining this consistency."
> > 
> > leaving each vCPU's MTRR is just to fully mimic HW?
> >
> Yes, leaving each vCPU's MTRR to mimic HW.
> 
> As also suggested in SDM, the guest OS manipulates MTRRs in this way:
> 
> for each online CPUs {
> 	disable MTRR
> 	update fixed/var MTRR ranges
> 	enable MTRR
> }
> Guest OS needs to access memory only after this full pattern.

FWIW, that Linux doesn't use that approach.  Linux instead only puts the cache
into no-fill mode (CR0.CD=1) when modifying MTRRs.  OVMF does both (and apparently
doesn't optimize for self-snoop?).

> So, I think there should not have "hazard of inconsistency among per-VPU MTRR
> states".

Probably not, but despite the SDM's assertion that software "MUST" keep things
consistent, that's not actually reality.  E.g. a careful kernel that partitions
memory doesn't need to strictly keep MTRRs consistent.  Ditto for scenarios where
CPUs are offline (for a variety of definitions of "offline"), in which case only
online CPUs need to have consistent MTRRs, e.g. before APs are brought up, MTRRs
are obviously inconsistent.

> I want to have per-VM MTRR state is because I want to reduce unnessary EPT
> zap, which costs quite a lot cpu cycles even when the EPT is empty.
> 
> In this patch, per-VM MTRR pointer is used to point to vCPU 0's MTRR state,
> so that it can save some memory to keep the MTRR state.
> But I found out that it would only work when vCPU 0 (boot processor) is
> always online (which is not true for x86 under some configration).
> 
> I'll try to find out lowest online vCPU

Picking a single vCPU will always be subject to edge cases.  E.g. I can see something
like kexec() "offlining" KVM's chosen vCPU and then having problems because KVM
ignores MTRR updates from other vCPUs in the new kernel.

One idea would be to let all vCPUs write the per-VM state, and zap if and only if
the MTRRs are actually different.  But as above, I'm on the fence about diverging
from what hardware actually does with respect to MTRRs.

Argh, stupid quirks.  I was going to suggest we take advantage of the guest needing
to either disable MTRRs or put the cache into no-fill mode to avoid zapping SPTEs,
i.e. skip the zap if CR0.CD=1, but KVM's implementation of the quirk is all kinds
of messed up.  KVM ignores MTRRs and guest PAT when CR0.CD=1, but then doesn't zap
when CR0.CD is cleared:

	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);

which means that either KVM is relying on later MTRR changes to zap the bogus
WB SPTEs, or more likely things "work" because KVM doesn't install SPTEs for the
ranges that end up being DMA'd while CR0.CD is set.

*sigh*  What an absolutely asinine quirk.  KVM should never have taken it on to
workaround OVMF's stupidity.  Good gravy, that thing was even Cc'd stable@.  Yeesh.

Aha!  Idea.  There's should be no need to ignore guest PAT when CR0.CD=1 and the
quirk is enabled.  Even OVMF must be smart enough to map its code as WB in its page
tables.  And there is no need to zap SPTEs when CR0.CD is _set_, because SPTEs
created while CR0.CD=0 would have honored MTRRs.  Lastly, DMA when CR0.CD=1 and
the quirk is enabled simply can't work since KVM historically ignores everything
from the guest and maps all memory WB.

So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
non-WB MTRR ranges doesn't need to actually resolve the memtype, i.e. can be simple
and just
process MTRRs one by one.

Did that make sense?  Minus the code to identify non-WB MTRR ranges (and much
needed comments), the below is what I'm thinking.  If more intelligent zapping
provides the desired performance improvements, then I think/hope we avoid trying
to play games with MTRRs.

---
 arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |  8 ++------
 arch/x86/kvm/x86.c     |  6 ++----
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index a67c28a56417..e700c230268b 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -323,6 +323,9 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
 		return;
 
+	if (kvm_is_cr0_bit_set(vcpu, X86_CR0_CD))
+		return;
+
 	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
 		return;
 
@@ -375,6 +378,22 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	}
 }
 
+void kvm_mtrr_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	if (cr0 & X86_CR0_CD)
+		return;
+
+	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
+		return;
+
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
+		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+		return;
+	}
+
+	<zap non-WB memory>;
+}
+
 int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	int index;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d9d155691a7..962abc17afc0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7502,8 +7502,6 @@ static int vmx_vm_init(struct kvm *kvm)
 
 static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
-	u8 cache;
-
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
 	 * We have to be careful as to what are honored and when.
@@ -7530,11 +7528,9 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-			cache = MTRR_TYPE_WRBACK;
+			return MTRR_TYPE_WRBACK;
 		else
-			cache = MTRR_TYPE_UNCACHABLE;
-
-		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 	}
 
 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 977dceb7ba7e..3c085b6f9e3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -941,10 +941,8 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
 
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+	if ((cr0 ^ old_cr0) & X86_CR0_CD))
+		kvm_mtrr_post_set_cr0(vcpu, cr0);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 

base-commit: 7e998f35c57cb0a2c35f8545b54ab5f4f5a83841
-- 

