Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C83D9319
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhG1QYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 12:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhG1QYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 12:24:06 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A96C061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:24:05 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id x15-20020a05683000cfb02904d1f8b9db81so2633149oto.12
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HW0PiepK+nq3bFzT/Fn8u9V4p+iw8L1kdIC5/sf98H0=;
        b=AGMaGHlmbN19QdPdpDG44ZIiCbjxpXnCmRQn3diqJ86YSnjXg1cuHfeii+B5n2epJs
         tvwkqNB7dJRuMmaGtRs2dH47wFfYg3W59+P7+q8acOMgqskHDwzDAVet6IwMjhfQV8E+
         hnS6NbbYFVZ22m+E9xHmJkIeA4cXINjN22YLDg/vNVyjSW5O9GZ85CjEVd9bIi0uVXcj
         8r79DDZQu7xREJ6r3JjumruNypCa9uFmJJvgy3MauKguojfEXK4QPRH+akO2RGh8jxn5
         J3rhwHg7fVxCc0FbkA2z0G9LJ2Cxp0lURCZo20E/N4lOvb6hddyf5gCIxu0b+Yb2IZKp
         qVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HW0PiepK+nq3bFzT/Fn8u9V4p+iw8L1kdIC5/sf98H0=;
        b=H3E4MdBTCdAOPiv3i21upIrmqQAvlv18OvFBKsDyb0pz7Oy0UfXt5k6s0RNjr4ndY5
         zqCbRjOdxir/h7Go23WQdH5Tn7IvBo2VynzgK7DgmHkPZIt8+zTa5vCdvThsa1uxqM2n
         29eWEhs1pOccXcxz5rbkvhHPaDnmGQGRbd+WQaF8H8cP2M6FFnlVMtcsqv8uOThyAFtU
         5s1N5q1y4UMR2UkHgnQ8VsHlxfMPPgHy6we6oK/4KvvZd1BBx3tNlgCduvcnYbSdCCRs
         e8h//spHKbC1y/pJVzhv4PbMr+2u5A1hbJrAyRpUzBs5AECSq3TlNSflSHt8BUysQEb4
         4fPQ==
X-Gm-Message-State: AOAM531jGoahDVLvHHc9KkTrd5NCx0w8omAz1FcvLnLGZsND2eW8LLpZ
        BU22445iZgtOswt1ToM9C6CpdqLnLhZG8ZNv3GP78w==
X-Google-Smtp-Source: ABdhPJzC6Le0eRW2UYGbrpZfZmIXf6Y5X4+6zJ/SgfMtvclo1fyUpGD22NgF6lRFV0697Rm2NCkZYaiEdoKOUHI9LOM=
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr649860ots.72.1627489443969;
 Wed, 28 Jul 2021 09:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com> <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
In-Reply-To: <20210728072514.GA375@yzhao56-desk.sh.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 28 Jul 2021 09:23:53 -0700
Message-ID: <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
Subject: Re: A question of TDP unloading.
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 12:40 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
>
> On Wed, Jul 28, 2021 at 02:56:05PM +0800, Yu Zhang wrote:
> > Thanks a lot for your reply, Sean.
> >
> > On Tue, Jul 27, 2021 at 06:07:35PM +0000, Sean Christopherson wrote:
> > > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > > Hi all,
> > > >
> > > >   I'd like to ask a question about kvm_reset_context(): is there any
> > > >   reason that we must alway unload TDP root in kvm_mmu_reset_context()?

I just realized I sent my response to Yu yesterday without reply-all.
Sending it again here for posterity. I'll add comments on the
discussion inline below too.

Hi Yu,

I think the short answer here is no, there's no reason we can't keep
the root around for later.

When developing the TDP MMU, we were primarily concerned about
performance post-boot, especially during migration or when
re-populating memory for demand paging. In these scenarios the guest
role doesn't really change and so the TDP MMU's shadow page tables
aren't torn down. In my initial testing, I thought I only ever
observed two TDP MMU roots be allocated over the life of the VM, but I
could be wrong.

For the TDP MMU root to be torn down, there also has to be no vCPU
using it. This probably happens in transitions to SMM and guest root
level changes, but I suspected that there would usually be at least
one vCPU in some "normal" mode, post boot. That may have been an
incorrect assumption.

I think the easiest solution to this would be to just have the TDP MMU
roots track the life of the VM by adding an extra increment to their
reference count on allocation and an extra decrement when the VM is
torn down. However this introduces a problem because it increases the
amount of memory the TDP MMU is likely to be using for its page
tables. (It could use the memory either way but it would require some
surprising guest behavior.)

I have a few questions about these unnecessary tear-downs during boot:
1. How many teardowns did you observe, and how many different roles
did they represent? Just thrashing between two roles, or 12 different
roles?
2. When the TDP MMU's page tables got torn down, how much memory did
they map / how big were they?
3. If you hacked in the extra refcount increment I suggested above,
how much of a difference in boot time does it make?

For 2 and 3 I ask because if the guest hasn't accessed much of it's
memory early in boot, the paging structure won't be very large and
tearing it down / rebuilding it is pretty cheap.

We may find that we need some kind of page quota for the TDP MMU after
all, if we want to have a bunch of roots at the same time. If that's
the case, perhaps we should spawn another email thread to discuss how
that should work.

Thanks for raising this issue!
Ben

> > >
> > > The short answer is that mmu_role is changing, thus a new root shadow page is
> > > needed.
> >
> > I saw the mmu_role is recalculated, but I have not figured out how this
> > change would affect TDP. May I ask a favor to give an example? Thanks!

One really simple example is if the guest started using SMM. In that
case it's a totally different address space, so we need a new EPT.

> >
> > I realized that if we only recalculate the mmu role, but do not unload
> > the TDP root(e.g., when guest efer.nx flips), base role of the SPs will
> > be inconsistent with the mmu context. But I do not understand why this
> > shall affect TDP.

It might not always cause problems since TDP is less sensitive to this
kind of thing than shadow paging, but getting all the details right is
hard so we just took the conservative approach of handling all role
changes with a new root.

> >
> > >
> > > >   As you know, KVM MMU needs to track guest paging mode changes, to
> > > >   recalculate the mmu roles and reset callback routines(e.g., guest
> > > >   page table walker). These are done in kvm_mmu_reset_context(). Also,
> > > >   entering SMM, cpuid updates, and restoring L1 VMM's host state will
> > > >   trigger kvm_mmu_reset_context() too.
> > > >
> > > >   Meanwhile, another job done by kvm_mmu_reset_context() is to unload
> > > >   the KVM MMU:
> > > >
> > > >   - For shadow & legacy TDP, it means to unload the root shadow/TDP
> > > >     page and reconstruct another one in kvm_mmu_reload(), before
> > > >     entering guest. Old shadow/TDP pages will probably be reused later,
> > > >     after future guest paging mode switches.
> > > >
> > > >   - For TDP MMU, it is even more aggressive, all TDP pages will be
> > > >     zapped, meaning a whole new TDP page table will be recontrustred,
> > > >     with each paging mode change in the guest. I witnessed dozens of
> > > >     rebuildings of TDP when booting a Linux guest(besides the ones
> > > >     caused by memslots rearrangement).
> > > >
> > > >   However, I am wondering, why do we need the unloading, if GPA->HPA
> > > >   relationship is not changed? And if this is not a must, could we
> > > >   find a way to refactor kvm_mmu_reset_context(), so that unloading
> > > >   of TDP root is only performed when necessary(e.g, SMM switches and
> > > >   maybe after cpuid updates which may change the level of TDP)?
> > > >
> > > >   I tried to add a parameter in kvm_mmu_reset_context(), to make the
> > > >   unloading optional:
> > > >
> > > > +void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool force_tdp_unload)
> > > >  {
> > > > -       kvm_mmu_unload(vcpu);
> > > > +       if (!tdp_enabled || force_tdp_unload)
> > > > +               kvm_mmu_unload(vcpu);
> > > > +
> > > >         kvm_init_mmu(vcpu);
> > > >  }
> > > >
> > > >   But this change brings another problem - if we keep the TDP root, the
> > > >   role of existing SPs will be obsolete after guest paging mode changes.
> > > >   Altough I guess most role flags are irrelevant in TDP, I am not sure
> > > >   if this could cause any trouble.
> > > >
> > > >   Is there anyone looking at this issue? Or do you have any suggestion?
> > >
> > > What's the problem you're trying to solve?  kvm_mmu_reset_context() is most
> > > definitely a big hammer, e.g. kvm_post_set_cr0() and kvm_post_set_cr4() in
> > > particular could be reworked to do something like kvm_mmu_new_pgd() + kvm_init_mmu(),
> > > but modifying mmu_role bits in CR0/CR4 should be a rare event, i.e. there hasn't
> > > sufficient motivation to optimize CR0/CR4 changes.
> >
> > Well, I noticed this when I was trying to find the reason why a single GFN
> > can have multiple rmaps in TDP(not the SMM case, which uses different memslot).
> > And the fact that guest paging mode change will cause the unloading of TDP
> > looks counter-intuitive. I know I must have missed something important, and
> > I have a strong desire to figure out why. :)

Your best bet there might be to just log all the roles calculated over
the life of the VM and then reverse-engineer from there.
I would naively assume that that would give a pretty good picture of
what changes necessitated new TDP roots.

> >
> > Then I tried with TDP MMU, yet to find the unloading is performed even more
> > aggressively...
> >
> > >
> > > Note, most CR4 bits and CR0.PG are tracked in kvm_mmu_extended_role, not
> > > kvm_mmu_page_role, which adds a minor wrinkle to the logic.
> > >
> >
> > The extended role is another pain point for me when reading KVM MMU code.
> > I can understand it is useful in shadow, but does it also matters in TDP?
> >
>
> hi
> I noticed that shadow page's role is of type union kvm_mmu_page_role.
> so, can I understand that we actually only need to do kvm_mmu_unload() when
> base roles of new mmu role and the old context mmu role are different?
>
> Thanks
> Yan
>
>
