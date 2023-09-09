Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0CE799315
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 02:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344888AbjIIAQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 20:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243171AbjIIAQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 20:16:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DBB2114
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 17:16:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5709b5ba7c9so3210235a12.1
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 17:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694218567; x=1694823367; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4kEZFjoXTNmrOhBP4hiqbQGbSpmEgyfVLJ8F6RdFm6I=;
        b=4zX1y6SoCiSi7/oTSXAy1hu6cwSkmS5h0xg5bqSP25HOKU8hVsXQfc7kCaRc3zRokp
         Rje3xYJdFOD70gZq4OLPrcclg6DE2QdnlZ62jsHBUJR+0VO1hy4ifglM4vlujsu/eos4
         V0M4qYQk1j0kz79heNNSe0uZqOc7INkYdG0mh4TzoHsiqek2/z6dAx4S4Hz2mgLQ8T5t
         /CykepSN8k16MCg4XLyk7n8x9AKCdmsDkxDmPQQ6Cs1tIj2PqYmoK0NxovbrTC11JtwH
         ehfC/Ogo8JjphWOLLtlvFnbfqwk15H06w7LuIuLtV4tJldRtgfcZciCcn1g47d15KNFN
         fAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694218567; x=1694823367;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kEZFjoXTNmrOhBP4hiqbQGbSpmEgyfVLJ8F6RdFm6I=;
        b=cZqNWjmkgHoc+nDKJaAL6x4jBpH5/f35yXvoDh6gjli0Df7bIzJcBMQ7m81FTu/6n7
         axHCqEJFbQC+QM2CQP/uLxmKXtMPGtquCNd6gvTrC+NfX0eQcizRCqjFq9hBD31zbDa+
         tx2MKWHHIjxpjvfklzPE6fdXnC5FCTryzke2GuwziJKEOAVh15m9fBu+1p0WBloItqAB
         IicBoHHWVH13583CJBNsNuq9XI+XoysP5IEWIy1yt8LHhCTqWIIdf28MNZQ0q2Uu4BSx
         chMxpslrUCiRxNETJYSKO7Gj2AV/+cWWl8vxHfk0vI9zStQHNM4mFqkiY05lvgPOB12n
         S2WA==
X-Gm-Message-State: AOJu0YyimtvLCw0mAs5u2C6/xnETHSPvPeeJpS7MMAIRxUOl3YYUS4qa
        VP3E9VAjsFXu/VuQVmP8WZqrk/pLjdNc2SBdc+vU2jTXsx/7b5WKac2swD8w2y34XAT+6MqIYqC
        9he/aHYKKRg5k8wcF57FwOmZHZRLOrdwinqguHfdkRcnN5y1xnHragFXPlg==
X-Google-Smtp-Source: AGHT+IFWyI2qzhnF1ZPDc0UNukpRKSol92t+cQFjKaMfcimuF+8ZLA5qbXuunHfJsCQG51NbjZ41snqTpGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:244e:b0:1b9:e9f3:b4ca with SMTP id
 l14-20020a170903244e00b001b9e9f3b4camr1370773pls.12.1694218566886; Fri, 08
 Sep 2023 17:16:06 -0700 (PDT)
Date:   Fri, 8 Sep 2023 17:16:05 -0700
In-Reply-To: <ZOjpIL0SFH+E3Dj4@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <ZOjpIL0SFH+E3Dj4@google.com>
Message-ID: <ZPu5RRlsZvzi2AP8@google.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023, Sean Christopherson wrote:
> On Tue, Jul 18, 2023, Sean Christopherson wrote:
> > This is the next iteration of implementing fd-based (instead of vma-based)
> > memory for KVM guests.  If you want the full background of why we are doing
> > this, please go read the v10 cover letter[1].
> > 
> > The biggest change from v10 is to implement the backing storage in KVM
> > itself, and expose it via a KVM ioctl() instead of a "generic" sycall.
> > See link[2] for details on why we pivoted to a KVM-specific approach.
> > 
> > Key word is "biggest".  Relative to v10, there are many big changes.
> > Highlights below (I can't remember everything that got changed at
> > this point).
> > 
> > Tagged RFC as there are a lot of empty changelogs, and a lot of missing
> > documentation.  And ideally, we'll have even more tests before merging.
> > There are also several gaps/opens (to be discussed in tomorrow's PUCK).
> > 
> > v11:
> >  - Test private<=>shared conversions *without* doing fallocate()
> >  - PUNCH_HOLE all memory between iterations of the conversion test so that
> >    KVM doesn't retain pages in the guest_memfd
> >  - Rename hugepage control to be a very generic ALLOW_HUGEPAGE, instead of
> >    giving it a THP or PMD specific name.
> >  - Fold in fixes from a lot of people (thank you!)
> >  - Zap SPTEs *before* updating attributes to ensure no weirdness, e.g. if
> >    KVM handles a page fault and looks at inconsistent attributes
> >  - Refactor MMU interaction with attributes updates to reuse much of KVM's
> >    framework for mmu_notifiers.
> > 
> > [1] https://lore.kernel.org/all/20221202061347.1070246-1-chao.p.peng@linux.intel.com
> > [2] https://lore.kernel.org/all/ZEM5Zq8oo+xnApW9@google.com
> 
> Trimmed the Cc substantially to discuss what needs to be done (within our control)
> to have a chance of landing this "soon".
> 
> We've chipped away at the todo list a bit, but there are still several non-trivial
> things that need to get addressed before we can merge guest_memfd().  If we move
> *really* fast, e.g. get everything address in less than 3 weeks, we have an outside
> chance at hitting 6.7.  But honestly, I think it 6.7 is extremely unlikely.
> 
> For 6.8, we'll be in good shape if we can get a non-RFC posted in the next ~6
> weeks, i.e. by end of September, though obviously the sooner the better.  If we slip
> much beyond that, 6.8 is going to be tough due to people disappearing for year-end
> stuff and holidays, i.e. we won't have enough time to address feedback _and_ get a
> another round of reviews.

Update, and adding one more TODO (thanks Asish!).

Rather than wait for all of the TODOs to be completed, I am going to send a
refreshed v12 early next week.  I will squash the fixups I have, maaaybe write a
few changelogs, and rebase onto v6.6-rc1.   And I'll capture the remaining todos
(for merging) in the cover letter.

Paolo, correct me if I misunderstood our conversation, but we still have a shot
at hitting v6.7.  The goal of sending out v12 even with the todos is to let
people test something that's close-ish to merge-ready asap.  And if all goes well,
get v13 posted in a few weeks and queued for v6.7.

Most of the remaining work is fairly straightforward, e.g. writing changelogs,
removing the dedicated file system, etc.  The notable exception is the memory
error handling, a.k.a. kvm_gmem_error_page().

So Isaku, you're "officially" on the critical path :-)  We don't need a proper
test of any kind, but the code does need to be point-tested to ensure it a memory
error doesn't panic/crash the host.   Anything goes, e.g. if hacking the kernel
to generate memory errors is easier than figuring out the fault injection stuff,
then go for it, we just need some level of confidence that kvm_gmem_error_page()
won't catch fire.  Please holler if you need help, or want to hand off the task
to someone else.


Precise shared vs. private mappings
-----------------------------------

Teach mmu_notifier events to zap only shared mappings.  This is a must-have for
SNP performance, and maybe even a hard requirement for TDX.  Not zapping private
mappings in response to mmu_notifier events means KVM will *never* free private
memory in response to mmu_notifier vents, which will in turn allow KVM skip the
cache flush (a nasty WBINVD everywhere) that's currently done when memory that
*might* be private is freed.

Sean will own, plan here: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com

> Speaking purely from a personal perspective, I really, really want to hit 6.8 so
> that this doesn't drag into 2024.
> 
> Loosely ordered by size and urgency (bigger, more urgent stuff first).  Please
> holler if I've missed something (taking notes is my Achilles heel).
> 
> 
> Filemap vs. xarray
> ------------------
> This is the main item that needs attention.  I don't want to merge guest_memfd()
> without doing this comparison, as not using filemap means we don't need AS_UNMOVABLE.
> Arguably we could merge a filemap implementation without AS_UNMOVABLE and just eat
> the suboptimal behavior, but not waiting a little while longer to do everything we
> can to get this right the first time seems ridiculous after we've been working on
> this for literally years.
> 
> Paolo was going to work on an axarray implementation, but AFAIK he hasn't done
> anything yet.  We (Google) don't have anyone available to work on an xarray
> implementation for several weeks (at best), so if anyone has the bandwidth and
> desire to take stab at an xarray implementation, please speak up.
> 
> 
> kvm_gmem_error_page()
> ---------------------
> As pointed out by Vishal[*], guest_memfd()'s error/poison handling is garbage.
> KVM needs to unmap, check for poison, and probably also restrict the allowed
> mapping size if a partial page is poisoned.
> 
> This item also needs actually testing, e.g. via error injection.  Writing a
> proper selftest may not be feasible, but at a bare minimum, someone needs to
> manually verify an error on a guest_memfd() can get routed all the way into the
> guest, e.g. as an #MC on x86.
> 
> This needs an owner.  I'm guessing 2-3 weeks?  Though I tend to be overly
> optimistic when sizing these things...
> 
> [*] https://lore.kernel.org/all/CAGtprH9a2jX-hdww9GPuMrO9noNeXkoqE8oejtVn2vD0AZa3zA@mail.gmail.com
> 
> 
> Documentation
> -------------
> Obviously a must have.  AFAIK, no one is "officially" signed up to work on this.
> I honestly haven't looked at the document in recent versions, so I have no idea
> how much effort is required.
> 
> 
> Fully anonymous inode vs. proper filesystem
> -------------------------------------------
> This is another one that needs to get sorted out before merging, but it should
> be a much smaller task (a day or two).  I will get to this in a few weeks unless
> someone beats me to the punch.
> 
> 
> KVM_CAP_GUEST_MEMFD
> -------------------
> New ioctl() needs a new cap.  Trivial, just capturing here so I don't forget.
> 
> 
> Changelogs
> ----------
> This one is on me, though I will probably procrastinate until all the other todo
> items are close to being finished.
> 
> 
> Tests
> -----
> I would really like to have a test that verifies KVM actually installs hugepages,
> but I'm ok merging without such a test, mainly because I suspect it will be
> annoyingly difficult to end up with a test that isn't flaky.
> 
> Beyond that, and the aforementioned memory poisoining, IMO, we have enough test
> coverage.  I am always open to more tests, but I don't think adding more coverage
> is a must have for merging.
> 
> 
> .release_folio and .invalidate_folio versus .evict_inode
> --------------------------------------------------------
> I think we're good on this one?  IIRC, without a need to "clean" physical memory
> (SNP and TDX), we don't need to do anything special.
> 
> Mike or Ackerley, am I forgetting anything?
> 
> 
> NUMA
> ----
> I am completely comfortable doing nothing as part of the initial merge.  We have
> line of sight to supporting NUMA policies in the form of fbind(), and I would be
> quite surprised if we get much pushback on implementing fbind().
> 
> 
> RSS stats
> ---------
> My preference is to not do anything in the initial implementation, and defer any
> changes until later.  IMO, while odd, not capturing guest_memfd() in RSS is
> acceptable as there are no virtual mappings to account.  I completely agree that
> we would ideally surface the memory usage to userspace in some way, but I don't
> think it's so critical that it needs to happen as part of the initial merge.
> 
> 
> Intrahost migration support
> ---------------------------
> Ackerley's RFC[*] is enough for me to have confidence that we can support
> intrahost migration without having to rework the ABI.  Please holler if you
> disagree.
> 
> [*] https://lkml.kernel.org/r/cover.1691446946.git.ackerleytng%40google.com
> 
