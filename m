Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B5D710E9B
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 16:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbjEYOxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 10:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbjEYOxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 10:53:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F06198
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 07:53:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2537706190eso960964a91.3
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 07:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685026423; x=1687618423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rSFdNT3OlfsY0bQmRspPX/bSZxshl7cPJhoCVM3oFpQ=;
        b=wOw+TnTwkXDLdYideFQ5UiH/q6HW7i+O1C92gYcB9jjKRXueOKjsfGN/buKtJH8toh
         whsdxiZnYmk9QfdgXiOXh5Y97z7/ynRKjDnRYiif/BvKI8eIv6g8uh6zyVllTHJ+tFVb
         YoXt0p2vXTjw5EeWBHNfsg1Gt2dAYfHSoWVX4Wag2VkJVyt7zsmARPi8hqH7dDCdTbRy
         6HnkoFmghq4jRHq7aRHMRCFxL0wvjy5CsXwvTo0Z23PhIFJ/wkH+1ijpreE4FvDswNtS
         6znoLXIUEq4T/ouGjdIx/U97/FA69pHHVvW1JmmpaW1Pe3E4ikVHaLeZ2bmxMVSUlYJW
         HV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026423; x=1687618423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rSFdNT3OlfsY0bQmRspPX/bSZxshl7cPJhoCVM3oFpQ=;
        b=JCJtg334/KEEAxZyjVVSFoSNf/EYCkpcCcGjLQu3ZCJuAI9dGQrLBSUr83BnJstcgA
         cZiYRqujboge4iVEiUstK2ishWK9VHoyuyBlDWKD5mUOnPxammeypBE3/toIzCF5sV2J
         +V15DAULBwjgxZT/wbpwwIPu28K0DmrJrVQetbIT6j8ub3CmKwo9fIG7iGcTNwR5cMak
         pocKwjtpYVhb7TGUV5tc4zxlgKQuA4R62kG4th8N9jkK0JxSvdDUDA7k/2sz0ovVoU9C
         +8lM7NJHD1NxO4xYxWERaUhldMLLIZpzaGnqBPcKLPK86j4T0I+VSuk+Z5Pq9L/Inn41
         YLYA==
X-Gm-Message-State: AC+VfDxaUEHe5fpWEKnN+K2wUdb5mX1sw6J7BtSpu/FVmCbpLBdFpAJb
        kyxWkLksnErf5gVkd9CRHKaXyz3DWBA=
X-Google-Smtp-Source: ACHHUZ6dIptxJWPzvMCC927bYMdE1YctBl54DZZJ+76LsGYekJ8cfQKKWN7z1skHpfMksq7q3Kc9DAFfTTA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ab97:b0:255:bd0e:4797 with SMTP id
 n23-20020a17090aab9700b00255bd0e4797mr438729pjq.4.1685026422851; Thu, 25 May
 2023 07:53:42 -0700 (PDT)
Date:   Thu, 25 May 2023 07:53:41 -0700
In-Reply-To: <ZG8z493pfPIOPAT2@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com> <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com> <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
 <ZG5VlRzJkcwo9Qju@google.com> <ZG8z493pfPIOPAT2@yzhao56-desk.sh.intel.com>
Message-ID: <ZG92dWFxu+ue31Sl@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023, Yan Zhao wrote:
> On Wed, May 24, 2023 at 11:21:09AM -0700, Sean Christopherson wrote:
> 
> ...
> 
> > > > Picking a single vCPU will always be subject to edge cases.  E.g. I can see something
> > > > like kexec() "offlining" KVM's chosen vCPU and then having problems because KVM
> > > > ignores MTRR updates from other vCPUs in the new kernel.
> > > >
> > > Not familiar with kexec().
> > > I wanted to trap APIC_SPIV and finding the lowest online vCPU id by checking
> > > apic->sw_enabled status. Then only MTRR state of vCPU whose id equals to
> > > the lowest online vCPU id can be written to per-VM MTRR state.
> > > Will that work for kexec()?
> > 
> > kexec() allows "booting" into a new kernel without transitioning through BIOS
> > and without doing a full reboot.  The scenario I'm worried about is if the new
> > kernel offlines KVM's chosen CPU for whatever reason and also modifies MTRRs.  I
> > think it's an extremely unlikely scenario, but my point is that selecting a single
> > vCPU to control the MTRRs works if and only if that vCPU stays online for the
> > entire lifetime of the VM, which KVM can't guarantee.
> > 
> > > > One idea would be to let all vCPUs write the per-VM state, and zap if and only if
> > > > the MTRRs are actually different.  But as above, I'm on the fence about diverging
> > > > from what hardware actually does with respect to MTRRs.
> > 
> > ...
> > 
> > > > So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> > > > then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> > > > and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> > > > if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> > > > zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
> Not only non-WB ranges are required to be zapped.
> Think about a scenario:
> (1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too.
> (2) after CR0.CD=1, without zap, its EPT entry memtype is still UC.
> (3) then guest performs MTRR disable, no zap too.
> (4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
> (5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.

KVM installs WB memtype when the quirk is enabled, thus no need to zap.  KVM
currently zaps everything when the quirk is disabled, and I'm not proposing that
be changed.

> Does it make sense?
> 
> > > > non-WB MTRR ranges doesn't need to actually resolve the memtype, i.e. can be simple
> > > > and just
> > > > process MTRRs one by one.
> > > > 
> > > > Did that make sense?  Minus the code to identify non-WB MTRR ranges (and much
> > > > needed comments), the below is what I'm thinking.  If more intelligent zapping
> > > > provides the desired performance improvements, then I think/hope we avoid trying
> > > > to play games with MTRRs.
> > > > 
> > > > ---
> > > >  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
> > > >  arch/x86/kvm/vmx/vmx.c |  8 ++------
> > > >  arch/x86/kvm/x86.c     |  6 ++----
> > > >  3 files changed, 23 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > > > index a67c28a56417..e700c230268b 100644
> > > > --- a/arch/x86/kvm/mtrr.c
> > > > +++ b/arch/x86/kvm/mtrr.c
> > > > @@ -323,6 +323,9 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> > > >  	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> > > >  		return;
> > > >  
> > > > +	if (kvm_is_cr0_bit_set(vcpu, X86_CR0_CD))
> > > > +		return;
> > > This will always make update_mtrr() return here for Linux and OVMF. 
> > 
> > Yes, that's the intent.  If the CR0.CD quirk is _disabled_, then all SPTEs are
> > UC, i.e. there's no need to zap.  If the quirk is enabled (the common case,
> > unfortunately), then KVM isn't honoring MTRRs, i.e. non-coherent DMA won't function
> > properly, and so zapping SPTEs is pointless.  And in both cases, KVM will zap
> > relevant SPTEs when CR0.CD is cleared.
> My worry is that if the quirk is enabled,
> (1) when CR0.CD=1, the EPT memtype is WB.
> (2) when MTRR is further disabled,
>     a. with EPT zap, the new EPT memtype is UC, effective memtype is UC
>     b. without EPT zap, some EPT memtype is still WB, effective memtype is guest PAT type
> However, in guest driver's point of view, the memtype is UC, because its MTRR is disabled.

The quirk throws all of that out the window.  As the quirk is implemented in KVM,
i.e. what guests have been running with for years, the MTRRs are completely
ignored when CR0.CD.

> So, if we don't zap EPT when guest disables MTRR, and if there's
> non-coherent DMA on-going which requires guest driver to flush caches to
> ensure cache coherency (though I don't think this scenario will happen in
> reality), guest driver may not do the right thing as it thinks the memory is
> UC which has no need to flush cache while the effective memtype is WB.
> 
> Previously, (i.e. in current upstream implementation),  
> (1) when CR0.CD=1, the EPT memtype is WB + ignore guest PAT.
> (2) when MTRR is further disabled,
>     EPT is zapped, new EPT memtype is UC, effective memtype is UC.

No, because after zapping, CR0.CD=1, and thus when KVM re-installs SPTEs the guest
will get WB memory for _everything_ once again.

> The guest device driver can flush cache well for non-coherent DMA.
>
> So, though the quirk will make current upstream code malfunction when
> CR0.CD is set alone, it still functions well if MTRR is also disabled.

Not unless I'm missing something.  I don't see any way for the guest to get UC
memory when CR0.CD=1 and the quirk is enabled.  The behavior is nonsensical IMO,
but that's been KVM's quirky behavior for years.

	if (is_mmio)
		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;

	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
			cache = MTRR_TYPE_WRBACK;  <===== Overrides MTRR settings
		else
			cache = MTRR_TYPE_UNCACHABLE;

		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
	}

	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;

> But I doubt if we need to care about this extreme condition of
> non-coherent DMA that happens when CR0.CD=1 and MTRR is disabled.

It doesn't actually require non-coherent DMA within the CR0.CD=1 window though.
A SPTE installed while CR0.CD=1 could overlap a *future* non-coherent DMA range,
i.e. not zapping when CR0.CD is cleared would leave a stale WB SPTE.  This is
especially likely with hugepages, e.g. if KVM can create 1GiB mappings.

> > > This zap looks will happen on each vCPU.
> > 
> > Yes, on CR0.CD 1=>0 transition.
> > 
> > > Then only half of zaps are saved compared to the original count of zaps in
> > > update_mtrr().
> > 
> > I don't think the current code is functionally correct though, even if we define
> > "correct" to only apply when CR0.CD=0 (because the CR0.CD=1 case when the quirk
> > can't possibly be correct).  Keeping stale WB+IGMT entries that were installed
> > while CR0.CD=1 is broken.  As mentioned in my previous mail, I suspect it works
> > only because KVM doesn't install SPTEs for DMA'd ranges.  FWIW, the WB memtype
> > is unlikely to be a problem, but setting IGMT definitely is.  Though of course
> > we can and should fix the IGMT thing separately.
> Current code may also not function well for non-coherent DMA when guest vCPU has
> no X86_FEATURE_MTRR, as it returns WB (without IPAT) as EPT memtype.
> Then the effective memtype is guest PAT, but from guest's point of view, it's all
> UC. (see pat_x_mtrr_type() in Linux's code).
> But I guess we don't need to mind this case?

Yes, we can ignore !X86_FEATURE_MTRR guests.  If someone wants to run such a
setup with non-coherent DMA, they're welcome to send patches and write a lengthy
explanation of why they want to run such insanity :-)

> > > And pieces of no-WB memory might produce more kvm_zap_gfn_range()?
> > 
> > Yes, but they'll be much, much more precise.  And the bajillion fixed MTRRs can
> Could we instead keep a per-VM copy of MTRR?
> Then, if a vCPU modifies an MTRR entry and we find it's different from that
> in the per-VM copy, we mark that entry dirty. When CD0=0, we just zap
> those dirty ranges. (or just zap all if there are dirty entries)
> In theory, only one vCPU will trigger this zap in each round of MTRR update.

I don't think tracking "dirty" MTRRs releative to a per-VM copy will work because
of the weird behavior of the quirk.  E.g. if the below happens, vCPU1's WB SPTE
won't be zapped because MTRRx wasn't "dirty".

     vCPU0         vCPU1
     ----------    ----------
1.   MTRRx = UC 
2.   CR0.CD = 1    CR0.CD=1
3.                 SPTE = WB
4.                 MTRRx = UC
5.                 CR0.CD=0

Another problem is that while only one vCPU will trigger the zap, KVM needs to
stall all vCPUs that dirtied MTRRs *relative to the original per-VM state*.  E.g.
if the per-VM state for MTRRx is WB and both vCPU1 and vCPU2 dirty an MTRR and
both clear CR0.CD, then KVM needs to stall vCPU1 and vCPU2 regardless of which
vCPU actually does the zapping.

And when handling the transition from dirty=>clean, KVM would need to prevent
writes to MTRRs while grabbing the snapshot of dirty MTRRs, i.e. to-be-zapped
ranges, in order to provide stable view of the clean per-VM copy.

In other words, the net effect will essentially be what I sketched out with the
precise zapping, but with the added downside of serializing writes to MTRRs while
transitioning the per-VM state from dirty=>clean.
