Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534AA6436AE
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 22:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiLEVUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 16:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiLEVUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 16:20:12 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4A922B1E
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 13:20:11 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h7so14766961wrs.6
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 13:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tvspzYuiNlqsolHQI9cb6UyP9lHHvgHoYr6XTMSAWqM=;
        b=dsRKl0ZRF1eSzedOz30CZ2dJwfwV7y4nwtkPD4smqjVfgP9d7dmpoOw6yIogiGj/nZ
         zU4YOI4+hZ+TE1Gds3vtpKbi8wJai7dTjae9wMfrwM0Qh+NCnHxbgZR4Wjwq+C+wrCxW
         xUJQCbItYCDNOAV3wRMWxcwcqz3/b1fuV9e1GtzUnooJ/KjQMEgfd/gpOoAMxOQKgcy+
         zsBJfIzp4ArHQtzPpflCnoX6qgpuTkueVJS2TmxRACY/1Tx1SnuJjup/isAofnnK5gdr
         13xZMNb/k3wNV0ojVPKXY7OBxHzx/bQCA7biHHZZSWmyU6CsalX1sBY49NGJ4YTKI8LV
         M6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tvspzYuiNlqsolHQI9cb6UyP9lHHvgHoYr6XTMSAWqM=;
        b=QWyWeR/CSWCqsouaV4SZ3BxMDAcBISf5Y/IfSVF3G/1qymIcXvs2eBZ2Twye2gP6xY
         ICD4YRAUdFuZg++Zhd+wTecPyXvEPXMQWZfkqyj91rN/uYX9L2yyIZn0KpiLqqad+dsl
         FgLWnzXfmhyndQeRlIShC2LUwzHAozjJKqSu7JzDgyRRxZcreA9IBQpPS4tRuTUC8eVp
         wU6bqoqiWXYvBevzSNf/jUUpOH0qDhg10f0QQBBk/leSo+13iGPU0t8c1F50LgNVyghJ
         E1fszB0Q+H3Ae2xkyUX39x/uSwNT2d9M0OS9/udKDYCTSUpKpd0zIUrSjxk1d3vy7ssC
         f+WA==
X-Gm-Message-State: ANoB5pnXqY2T6OgPU5Izu2sBEYAfHkRIj9pchAb1aivYVohghfbPLCgR
        jN6mCIoICUbvdrb17VHW9VfWN2Mis3q/P/TnYxxv3w==
X-Google-Smtp-Source: AA0mqf6a0X/TGRnbbsp7Qd6SvXvGiMvX6c07IfefpbXvQ6O+QW2rALKmjJ0Ku5ZwK7wmbWmPn0UZRm58qA5zBSGOaH4=
X-Received: by 2002:a05:6000:124d:b0:242:10a:6667 with SMTP id
 j13-20020a056000124d00b00242010a6667mr34250640wrx.39.1670275209777; Mon, 05
 Dec 2022 13:20:09 -0800 (PST)
MIME-Version: 1.0
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com> <Y44NylxprhPn6AoN@x1n> <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com>
In-Reply-To: <Y442dPwu2L6g8zAo@google.com>
From:   James Houghton <jthoughton@google.com>
Date:   Mon, 5 Dec 2022 16:19:56 -0500
Message-ID: <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 5, 2022 at 1:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 05, 2022, David Matlack wrote:
> > On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > == Getting the faulting GPA to userspace ==
> > > > > KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
> > > > > and it provides the main functionality we need. We can extend it
> > > > > easily to support our use case here, and I think we have at least two
> > > > > options:
> > > > > - Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
> > > > > KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
> > > > > otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
> > > > > -EFAULT).
> > > > > - We're already introducing a new CAP, so just tie the above behavior
> > > > > to whether or not one of the CAPs (below) is being used.
> > > >
> > > > We might even be able to get away with a third option: unconditionally return
> > > > KVM_EXIT_MEMORY_FAULT instead of -EFAULT when the error occurs when accessing
> > > > guest memory.

Wouldn't we need a new CAP for this?

> > > >
> > > > > == Problems ==
> > > > > The major problem here is that this only solves the scalability
> > > > > problem for the KVM demand paging case. Other userfaultfd users, if
> > > > > they have scalability problems, will need to find another approach.
> > > >
> > > > It may not fully solve KVM's problem either.  E.g. if the VM is running nested
> > > > VMs, many (most?) of the user faults could be triggered by FNAME(walk_addr_generic)
> > > > via __get_user() when walking L1's EPT tables.
> >
> > We could always modify FNAME(walk_addr_generic) to return out to user
> > space in the same way if that is indeed another bottleneck.
>
> Yes, but given that there's a decent chance that solving this problem will add
> new ABI, I want to make sure that we are confident that we won't end up with gaps
> in the ABI.  I.e. I don't want to punt the nested case to the future.
>
> > > > Disclaimer: I know _very_ little about UFFD.
> > > >
> > > > Rather than add yet another flag to gup(), what about flag to say the task doesn't
> > > > want to wait for UFFD faults?  If desired/necessary, KVM could even toggle the flag
> > > > in KVM_RUN so that faults that occur outside of KVM ultimately don't send an actual
> > > > SIGBUGS.

I really like this idea! Having KVM_RUN toggle it in
handle_ept_violation/etc. seems like it would work the best. If we
toggled it in userspace before KVM_RUN, we would still open ourselves
up to KVM_RUN exiting without post-copy information (like, if GUP
failed during instruction emulation), IIUC.

> >
> > There are some copy_to/from_user() calls in KVM that cannot easily
> > exit out to KVM_RUN (for example, in the guts of the emulator IIRC).
> > But we could use your approach just to wrap the specific call sites
> > that can return from KVM_RUN.
>
> Yeah, it would definitely need to be opt-in.
>
> > > > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > > > index 07c81ab3fd4d..7f66b56dd6e7 100644
> > > > --- a/fs/userfaultfd.c
> > > > +++ b/fs/userfaultfd.c
> > > > @@ -394,7 +394,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> > > >          * shmem_vm_ops->fault method is invoked even during
> > > >          * coredumping without mmap_lock and it ends up here.
> > > >          */
> > > > -       if (current->flags & (PF_EXITING|PF_DUMPCORE))
> > > > +       if (current->flags & (PF_EXITING|PF_DUMPCORE|PF_NO_UFFD_WAIT))
> > > >                 goto out;
> > >
> > > I'll have a closer read on the nested part, but note that this path already
> > > has the mmap lock then it invalidates the goal if we want to avoid taking
> > > it from the first place, or maybe we don't care?

Not taking the mmap lock would be helpful, but we still have to take
it in UFFDIO_CONTINUE, so it's ok if we have to still take it here.

The main goal is to avoid the locks in the userfaultfd wait_queues. If
we could completely avoid taking the mmap lock for reading in the
common post-copy case, we would avoid potential latency spikes if
someone (e.g. khugepaged) came around and grabbed the mmap lock for
writing.

It seems pretty difficult to make UFFDIO_CONTINUE *not* take the mmap
lock for reading, but I suppose it could be done with something like
the per-VMA lock work [2]. If we could avoid taking the lock in
UFFDIO_CONTINUE, then it seems plausible that we could avoid taking it
in slow GUP too. So really whether or not we are taking the mmap lock
(for reading) in the mem fault path isn't a huge deal by itself.

> > >
> > > If we want to avoid taking the mmap lock at all (hence the fast-gup
> > > approach), I'd also suggest we don't make it related to uffd at all but
> > > instead an interface to say "let's check whether the page tables are there
> > > (walk pgtable by fast-gup only), if not return to userspace".
>
> Ooh, good point.  If KVM provided a way for userspace to toggle a "fast-only" flag,
> then hva_to_pfn() could bail if hva_to_pfn_fast() failed, and I think KVM could
> just do pagefault_disable/enable() around compatible KVM uaccesses?
>
> > > Because IIUC fast-gup has nothing to do with uffd, so it can also be a more
> > > generic interface.  It's just that if the userspace knows what it's doing
> > > (postcopy-ing), it knows then the faults can potentially be resolved by
> > > userfaultfd at this stage.
> >
> > Are there any cases where fast-gup can fail while uffd is enabled but
> > it's not due to uffd? e.g. if a page is swapped out?
>
> Undoubtedly.  COW, NUMA balancing, KSM?, etc.  Nit, I don't think "due to uffd"
> is the right terminology, I think the right phrasing is something like "but can't
> be resolved by userspace", or maybe "but weren't induced by userspace".  UFFD
> itself never causes faults.
>
> > I don't know what userspace would do in those situations to make forward progress.
>
> Access the page from userspace?  E.g. a "LOCK AND -1" would resolve read and write
> faults without modifying guest memory.
>
> That won't work for guests backed by "restricted mem", a.k.a. UPM guests, but
> restricted mem really should be able to prevent those types of faults in the first
> place.  SEV guests are the one case I can think of where that approach won't work,
> since writes will corrupt the guest.  SEV guests can likely be special cased though.

As I mentioned in the original email, I think MADV_POPULATE_WRITE
would work here (Peter suggested this to me last week, thanks Peter!).
It would basically call slow GUP for us. So instead of hva_to_pfn_fast
(fails) -> hva_to_pfn_slow -> slow GUP, we do hva_to_pfn_fast (fails)
-> exit to userspace -> MADV_POPULATE_WRITE (-> slow GUP) -> KVM_RUN
-> hva_to_pfn_fast (succeeds).

[2]: https://lwn.net/Articles/906852/

- James
