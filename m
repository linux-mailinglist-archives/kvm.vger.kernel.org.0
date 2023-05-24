Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789FB70FDC1
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 20:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbjEXSVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 14:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbjEXSVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 14:21:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A4E1B8
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 11:21:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8bab3b392so252096276.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684952471; x=1687544471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qPsi238rs8TxWyOeKtKvTzn4rwQLMVznAU//DI9C/Fc=;
        b=SumpIGVcdp1FlCuK8wvas4tCL9gYHm+b/9ecCoPMly6UmaHRRyaqZai1hWo8VL52eE
         rO+GvgMtSYjcBxMGZbq/dZA86sbJK5+oE7ekmWRkdmUHma5Xl6+eAz1ZWzXlb/ZvFP/2
         rqZLMqweS60eJQ7w2SKgnJhOyZ3bQk+AiQeFG5Qw+/Df4TXSzIcLnSV7Mgcj+bkeUjci
         Gxecsfp5VhT1uSIuPM30UyVQ2+mwzZxTt8v1R5r6pbqiGwNfAYOK1zVFxSOFZEKzQq8m
         fcB0/Dt51GfurrVgw+4h3U5a9FQR2h6O513ATmNWA/GAZIi9bUbAzGHD3ejRtiHYMwIZ
         RpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684952471; x=1687544471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qPsi238rs8TxWyOeKtKvTzn4rwQLMVznAU//DI9C/Fc=;
        b=Nq15/BsQNEYE+zBupMQ89XU/087AwwVn36r1yFB7N9eQnJPRchrOy/24OXGzUgawns
         lxLBdbZdW6HRzgqbiJ1OCJJPbvzSNIf22I1IkTiMNe69o/Wi02eL1WWPIj4D6EO0GJT3
         lOQGxdWlXeqquykcl+1CWYNs8fWmDI0qpKSowuU4dQXNTPU3odGYH2CNajx3SFfg+J2i
         Qi2ZOJLVtOOLK8sZyrdJh2guMs+7XY4MigMhOIkMw2uFUXDaaulK+tSIMP1+XJFG288l
         xJIErPH01ZzMUZQf1NQApICCKG8J/bDNymq1KC6U9vQ35XMK9C9YAjthEXdA9QwUct0f
         ISNg==
X-Gm-Message-State: AC+VfDy7HbB5sE1DX9zsZ8M6R/AHR1vrx8+wzxZg9TZmQbF1b3WvHMU/
        qIMin5pBuOxcxPOzmGAySCUS34foj08=
X-Google-Smtp-Source: ACHHUZ7Mrw8IB3CapOcyNB8qee3TbVkirdrXYndgINHZkLlBJnAh/DbOKNQWc8zO92vRy2Bi/YuirGSlDG4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:b15:b0:ba8:1e5f:8514 with SMTP id
 ch21-20020a0569020b1500b00ba81e5f8514mr160580ybb.5.1684952471190; Wed, 24 May
 2023 11:21:11 -0700 (PDT)
Date:   Wed, 24 May 2023 11:21:09 -0700
In-Reply-To: <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com> <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com> <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
Message-ID: <ZG5VlRzJkcwo9Qju@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, Yan Zhao wrote:
> On Tue, May 23, 2023 at 05:13:38PM -0700, Sean Christopherson wrote:
> > On Tue, May 23, 2023, Yan Zhao wrote:
> > > As also suggested in SDM, the guest OS manipulates MTRRs in this way:
> > > 
> > > for each online CPUs {
> > > 	disable MTRR
> > > 	update fixed/var MTRR ranges
> > > 	enable MTRR
> > > }
> > > Guest OS needs to access memory only after this full pattern.
> > 
> > FWIW, that Linux doesn't use that approach.  Linux instead only puts the cache
> > into no-fill mode (CR0.CD=1) when modifying MTRRs.  OVMF does both (and apparently
> > doesn't optimize for self-snoop?).
> I think Linux also follows this patten.
> This is the call trace I found out in my environment.
> cache_cpu_init
>     cache_disable
>         write_cr0 to CD=1, NW=0
>         mtrr_disable

Huh, I somehow missed this call to mtrr_disable().  I distinctly remember looking
at this helper, no idea how I missed that.

>     mtrr_generic_set_state
>         mtrr_wrmsr to fixed/var ranges
>     cache_enable
>         mtrr_enable
>         write_cr0(read_cr0() & ~X86_CR0_CD);
> 

...

> > Picking a single vCPU will always be subject to edge cases.  E.g. I can see something
> > like kexec() "offlining" KVM's chosen vCPU and then having problems because KVM
> > ignores MTRR updates from other vCPUs in the new kernel.
> >
> Not familiar with kexec().
> I wanted to trap APIC_SPIV and finding the lowest online vCPU id by checking
> apic->sw_enabled status. Then only MTRR state of vCPU whose id equals to
> the lowest online vCPU id can be written to per-VM MTRR state.
> Will that work for kexec()?

kexec() allows "booting" into a new kernel without transitioning through BIOS
and without doing a full reboot.  The scenario I'm worried about is if the new
kernel offlines KVM's chosen CPU for whatever reason and also modifies MTRRs.  I
think it's an extremely unlikely scenario, but my point is that selecting a single
vCPU to control the MTRRs works if and only if that vCPU stays online for the
entire lifetime of the VM, which KVM can't guarantee.

> > One idea would be to let all vCPUs write the per-VM state, and zap if and only if
> > the MTRRs are actually different.  But as above, I'm on the fence about diverging
> > from what hardware actually does with respect to MTRRs.

...

> > So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> > then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> > and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> > if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> > zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
> > non-WB MTRR ranges doesn't need to actually resolve the memtype, i.e. can be simple
> > and just
> > process MTRRs one by one.
> > 
> > Did that make sense?  Minus the code to identify non-WB MTRR ranges (and much
> > needed comments), the below is what I'm thinking.  If more intelligent zapping
> > provides the desired performance improvements, then I think/hope we avoid trying
> > to play games with MTRRs.
> > 
> > ---
> >  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c |  8 ++------
> >  arch/x86/kvm/x86.c     |  6 ++----
> >  3 files changed, 23 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > index a67c28a56417..e700c230268b 100644
> > --- a/arch/x86/kvm/mtrr.c
> > +++ b/arch/x86/kvm/mtrr.c
> > @@ -323,6 +323,9 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> >  	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> >  		return;
> >  
> > +	if (kvm_is_cr0_bit_set(vcpu, X86_CR0_CD))
> > +		return;
> This will always make update_mtrr() return here for Linux and OVMF. 

Yes, that's the intent.  If the CR0.CD quirk is _disabled_, then all SPTEs are
UC, i.e. there's no need to zap.  If the quirk is enabled (the common case,
unfortunately), then KVM isn't honoring MTRRs, i.e. non-coherent DMA won't function
properly, and so zapping SPTEs is pointless.  And in both cases, KVM will zap
relevant SPTEs when CR0.CD is cleared.

And this is actually already the behavior for all MTRRs execpt for MSR_MTRRdefType
due to the !mtrr_is_enabled() clause below.

> >  	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
> >  		return;
> >  
> > @@ -375,6 +378,22 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> >  	}
> >  }
> >  
> > +void kvm_mtrr_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> > +{
> > +	if (cr0 & X86_CR0_CD)
> > +		return;
> > +
> > +	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> > +		return;
> > +
> > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
> > +		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> > +		return;
> > +	}
> > +
> > +	<zap non-WB memory>;
> This zap looks will happen on each vCPU.

Yes, on CR0.CD 1=>0 transition.

> Then only half of zaps are saved compared to the original count of zaps in
> update_mtrr().

I don't think the current code is functionally correct though, even if we define
"correct" to only apply when CR0.CD=0 (because the CR0.CD=1 case when the quirk
can't possibly be correct).  Keeping stale WB+IGMT entries that were installed
while CR0.CD=1 is broken.  As mentioned in my previous mail, I suspect it works
only because KVM doesn't install SPTEs for DMA'd ranges.  FWIW, the WB memtype
is unlikely to be a problem, but setting IGMT definitely is.  Though of course
we can and should fix the IGMT thing separately.

> And pieces of no-WB memory might produce more kvm_zap_gfn_range()?

Yes, but they'll be much, much more precise.  And the bajillion fixed MTRRs can
be batched into a single zap by sacrificing a tiny amount of precision, i.e. zap
from the lowest non-WB fixed MTRR to the highest.  Crucially, assuming BIOS and
the kernel aren't doing something bizarre, that should preserve the SPTEs for the
code the guest is executing from (0 - VGA hole should be WB).

And if we want to squeeze more performance out of this path, there are other
optimizations we can make.  E.g. I'm guessing one of the problems, perhaps even
_the_ problem, is that there's contention on mmu_lock in kvm_zap_gfn_range() when
bringing up APs, which is likely why you observe slow downs even when there are
no SPTEs to zap.  A thought for handling that would be to do something akin to
kvm_recalculate_apic_map().  E.g. instead of having every vCPU zap, track (a)
if a zap is in-progress and (b) the ranges being zapped.  There will still be
lock contention to add ranges, but it should be fairly short in duration compared
to zapping all possible SPTEs (current behavior).

Something like

	struct tbd *range = NULL;
	bool do_zap = false;

	<gather non-wb ranges>

	for_each_non_wb_range(...) {
		if (!range)
			range = kmalloc(...);

		spin_lock(&kvm->arch.mtrr_zap_lock);
		if (<range not in list>) {
			list_add_tail(&range->list, &kvm->arch.mtrr_zap_list);
			range = NULL;

			if (!kvm->arch.mtrr_zapping) {
				do_zap = true;
				kvm->arch.mtrr_zapping = true;
			}
		}
		spin_unlock(&kvm->arch.mtrr_zap_lock);
	}

	kfree(zap_entry);

	if (do_zap) {
		spin_lock(&kvm->arch.mtrr_zap_lock);

		while (!list_empty(&kvm->arch.mtrr_zap_list)) {
			struct tbd *range;

			range = list_first_entry(&kvm->arch.mtrr_zap_list);
			list_del(range->list);

			spin_unlock(&kvm->arch.mtrr_zap_lock);

			kvm_zap_gfn_range(..., range->start, range->end);
			kfree(range);
		
			spin_lock(&kvm->arch.mtrr_zap_lock);
		}

		/* Clear under lock to ensure new entries are processed. */
		kvm->arch.mtrr_zapping = false;

		spin_unlock(&kvm->arch.mtrr_zap_lock);
	}

	/* Wait for the zap to complete. */
	while (READ_ONCE(kvm->arch.mtrr_zapping))
		cpu_relax();

and I'm sure someone that's better at lockless programming could optimize that
even further if necessary, e.g. by checking for "range in list" outside of the
spinlock.

E.g. in my OVMF based VM, the precise zap would target only two ranges, the VGA
hole and the 32-bit PCI:

  kvm: vCPU0 default type = 6
  kvm: vCPU0 fixed MTRR range 0 - 15 == 6
  kvm: vCPU0 fixed MTRR range 16 - 87 == 0
  kvm: vCPU0 variable MTRR range 80000000 - 100000000  = 0

That bumps up to three ranges for the kernel, which adds what I suspect is the
64-bit PCI hole:

  kvm: vCPU0 default type = 6                                                   
  kvm: vCPU0 fixed MTRR range 0 - 15 == 6                                       
  kvm: vCPU0 fixed MTRR range 16 - 87 == 0
  kvm: vCPU0 variable MTRR range 800000000 - 1000000000  = 0
  kvm: vCPU0 variable MTRR range 80000000 - 100000000  = 0

The above is distilled information from this hack-a-print:

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 9fac1ec03463..6259c7a4bcd3 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -304,12 +304,42 @@ static void var_mtrr_range(struct kvm_mtrr_range *range, u64 *start, u64 *end)
        *end = (*start | ~mask) + 1;
 }
 
+
+static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
+{
+       return (range->mask & (1 << 11)) != 0;
+}
+
 static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 {
        struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
        gfn_t start, end;
        int index;
 
+       if (mtrr_is_enabled(mtrr_state) && msr == MSR_MTRRdefType) {
+               struct kvm_mtrr_range *range;
+               int i;
+
+               pr_warn("vCPU%u default type = %u\n", vcpu->vcpu_idx, (u8)(mtrr_state->deftype & 0xff));
+
+               if (!fixed_mtrr_is_enabled(mtrr_state)) {
+                       pr_warn("vCPU%u fixed MTRRs disabled\n", vcpu->vcpu_idx);
+               } else {
+                       for (i = 0; i < ARRAY_SIZE(mtrr_state->fixed_ranges); i++)
+                               pr_warn("vCPU%u fixed MTRR range %u == %u\n",
+                                       vcpu->vcpu_idx, i, mtrr_state->fixed_ranges[i]);
+               }
+
+               list_for_each_entry(range, &mtrr_state->head, node) {
+                       if (!var_mtrr_range_is_valid(range))
+                               continue;
+
+                       var_mtrr_range(range, &start, &end);
+                       pr_warn("vCPU%d variable MTRR range %llx - %llx  = %u\n",
+                               vcpu->vcpu_idx, start, end, (u8)(range->base & 0xff));
+               }
+       }
+
        if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
              !kvm_arch_has_noncoherent_dma(vcpu->kvm))
                return;
@@ -333,11 +363,6 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
        kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
 }
 
-static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
-{
-       return (range->mask & (1 << 11)) != 0;
-}
-
 static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
        struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;

