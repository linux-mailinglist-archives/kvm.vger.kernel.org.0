Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E2466E19
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 01:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377707AbhLCAEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 19:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349732AbhLCAEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 19:04:01 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C8AC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 16:00:37 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id v15so2923417ljc.0
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 16:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rnwNnAFE/VR1Og3qTHK6mcZTTWNiJW8ONXwUoX8CXHw=;
        b=B54qvsAFSR5/uMQK+Gf46ugPYa//76QhIS6zhCRHZ5uDAE0cNsHXCZWN71Z1/Qlfhb
         1hXCU9MAywRa581slJaTWvd+cen6nx0VVMHvYjTPYY1YpmPi5Nwc+lCpa22vXfn3C+Wt
         nMScD1DpsVnIC2MWGzrxGB6k3utdNMaH7ziWjdBZLqNLtHOyxhwvn2nzwFVx3E3ajwOb
         b96gpdRtJ6tGiRozOOZp/de30SQawrWG0/wRhcIo4ChZWs/XBph1H/HHX3jS0qI8mR7k
         hE4RBLgsaRDYOMx+B5Nsmfo6FNnGCVmCe8GnspSMIU47fPLKR5X4yURkZg1TJkbr0axh
         7z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rnwNnAFE/VR1Og3qTHK6mcZTTWNiJW8ONXwUoX8CXHw=;
        b=X6xSLqsxwjnusJiOvT9RUfgj0KKT/QupOIIURI9v1zkyDcmkwaXiog0U+FuXkVnTHC
         Lw5V198ZvT+udMa7yAqaiqD6sE4NP0LsuMFUsyP2d1D0WtIe4B/t+o1PdYPRcJJqK76v
         pf+WM9u2n+0Bf1eiG9ePTylKQnFZm5RaMOtkk/TRnOvmLy87mYadbvW6heZAkGt0mgiw
         NRJWRi5uR/RWmequp7zmLDVac28rJ0iM+AVM//LRJjYnS3S4XmNmNkNuHSjC4o0S8GLL
         qhZaX7KYIliFnLLxSAryNr3NY2AVnBBfwiB1Rl6F/OSlsfJMRJsDOxr8KvWyYcj6LRc8
         k69g==
X-Gm-Message-State: AOAM533GNMPoZ08QMlmY+QLUlxiVnysUxTFFiOIvUlBB5nP0LolnMuLg
        DJ885CLMA+H/7Mz3wjVoMUmtW6hEW2kvD5lkvdemqg==
X-Google-Smtp-Source: ABdhPJxPDYqiN21f87qq1zHbb7NQj0YPaHsqX1flsJiSO4NzCZxdtjgmqRYF+7Jay4k2a+iZYV3aJzpitffJHbFnxoE=
X-Received: by 2002:a2e:8156:: with SMTP id t22mr15094892ljg.223.1638489635661;
 Thu, 02 Dec 2021 16:00:35 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local> <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com> <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local> <Yae+8Oshu9sVrrvd@google.com>
 <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
 <YagHRESjukJoS7NQ@google.com> <CALzav=dDEhU3uN9CofYQqCukT3QJUm+pjRz2WTr-Ss9TNVBgLg@mail.gmail.com>
 <YakTrkA6xzD5dzyN@google.com>
In-Reply-To: <YakTrkA6xzD5dzyN@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 2 Dec 2021 16:00:09 -0800
Message-ID: <CALzav=et40yLPOWsbx7iGjW3c8CR-88xRQ46rGU=1XDVEjVwWA@mail.gmail.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 2, 2021 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 02, 2021, David Matlack wrote:
> > On Wed, Dec 1, 2021 at 3:37 PM Sean Christopherson <seanjc@google.com> wrote:
> > > It's not just the extra objects, it's the overall complexity that bothers me.
> > > Complexity isn't really the correct word, it's more that as written, the logic
> > > is spread over several files and is disingenuous from the perspective that the
> > > split_cache is in kvm->arch, which implies persistence, but the cache are
> > > completely torn down after evey memslot split.
> > >kmem_cache_alloc
> > > I suspect part of the problem is that the code is trying to plan for a future
> > > where nested MMUs also support splitting large pages.  Usually I'm all for that
> > > sort of thing, but in this case it creates a lot of APIs that should not exist,
> > > either because the function is not needed at all, or because it's a helper buried
> > > in tdp_mmu.c.  E.g. assert_split_caches_invariants() is overkill.
> > >
> > > That's solvable by refactoring and shuffling code, but using kvm_mmu_memory_cache
> > > still feels wrong.  The caches don't fully solve the might_sleep() problem since
> > > the loop still has to drop mmu_lock purely because it needs to allocate memory,
> >
> > I thought dropping the lock to allocate memory was a good thing. It
> > reduces the length of time we hold the RCU read lock and mmu_lock in
> > read mode. Plus it avoids the retry-with-reclaim and lets us reuse the
> > existing sp allocation code.
>
> It's not a simple reuse though, e.g. it needs new logic to detect when the caches
> are empty, requires a variant of tdp_mmu_iter_cond_resched(), needs its own instance
> of caches and thus initialization/destruction of the caches, etc...
>
> > Eager page splitting itself does not need to be that performant since
> > it's not on the critical path of vCPU execution. But holding the MMU
> > lock can negatively affect vCPU performance.
> >
> > But your preference is to allocate without dropping the lock when possible. Why?
>
> Because they're two different things.  Lock contention is already handled by
> tdp_mmu_iter_cond_resched().  If mmu_lock is not contended, holding it for a long
> duration is a complete non-issue.

So I think you are positing that disabling reclaim will make the
allocations fast enough that the time between
tdp_mmu_iter_cond_resched checks will be acceptable. Is there really
no risk of long tail latency in kmem_cache_alloc() or
__get_free_page()? Even if it's rare, they will be common at scale.

This is why I'm being so hesitant, and prefer to avoid the problem
entirely by doing all allocations outside the lock. But I'm honestly
more than happy to be convinced otherwise and go with your approach.

>
> Dropping mmu_lock means restarting the walk at the root because a different task
> may have zapped/changed upper level entries.  If every allocation is dropping
> mmu_lock, that adds up to a lot of extra memory accesses, especially when using
> 5-level paging.
>
> Batching allocations via mmu_caches mostly works around that problem, but IMO
> it's more complex overall than the retry-on-failure approach because it bleeds
> core details into several locations, e.g. the split logic needs to know intimate
> details of kvm_mmu_memory_cache, and we end up with two (or one complex) versions
> of tdp_mmu_iter_cond_resched().
>
> In general, I also dislike relying on magic numbers (the capacity of the cache)
> for performance.  At best, we have to justify the magic number, now and in the
> future.  At worst, someone will have a use case that doesn't play nice with KVM's
> chosen magic number and then we have to do more tuning, e.g. see the PTE prefetch
> stuff where the magic number of '8' (well, 7) ran out of gas for modern usage.
> I don't actually think tuning will be problematic for this case, but I'd rather
> avoid the discussion entirely if possible.
>
> I'm not completely opposed to using kvm_mmu_memory_cache to batch allocations,
> but I think we should do so if and only if batching has measurably better
> performance for things we care about.  E.g. if eager splitting takes n% longer
> under heavy memory pressure, but vCPUs aren't impacted, do we care?
