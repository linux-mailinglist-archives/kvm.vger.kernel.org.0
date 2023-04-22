Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6999D6EB6AB
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 03:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjDVBdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 21:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbjDVBdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 21:33:35 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B61526AD
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 18:33:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-63d30b08700so14494740b3a.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 18:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682127207; x=1684719207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TK7tDPNhjjI/c8f1UksqVhncl1j69HVMyE1qQbrDgCc=;
        b=yj4krTi7mm2M4rq38MR9yLl1zfgz10Y5K0QvkDzRrG1mpsceW4yy4Wr/ARgyHk97XL
         0DOlg9GeR0rTsGgTftv1w0pmmQ05KFfSBDPoKfKQo2s4LnhJP5gsNRSDpnqaBV8M7r6o
         257vsz0FKKLNAuXbtLpIph0oe4V3lIp/2wDub9XaKJ47Bl1FKP5E+vmy9ts2PD8mR97q
         9MEChyNeCa+/ZP8G/34EjR2phHFraWU5DFrl2F+mswxu4xl4PTrA1RvswLzlclnxaQoo
         rV65VpExq3KDp+59xTnbY72d8I69cTMebsXAfcbJa4Lr1iBbKCGUt/45xJFCwg19VBSo
         8y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682127207; x=1684719207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TK7tDPNhjjI/c8f1UksqVhncl1j69HVMyE1qQbrDgCc=;
        b=lPDk0G6K5F9z/o+NtPVfcpLOVRZBSwcrxU8NdL3/h1vkk/S5HWC5NqYfx/nHf4qLIF
         Km/vn3QBsqc8aNUXn9hRPez8Z4bQRc4NjGfv9bGzA9umuzhPcvEujygs6S8pdmcBn6Bz
         W2PUtv/USOYfxWATTeAryEkI4fqVdMt+gElMLS4g4WCdX10stt0kJLMRoD8MUUBuf92f
         E0Olh/KOdvtGYL4NI0zFkvWZX7i9VA2XqVYyFoiX933UeCjv7PmqPCdhfueZt6uH590Y
         yAuHW9swS+DTRv5K/mbA1wawXFXyGivXfhWy/hA2ymqVkNjiNhJq1w9ACSm8eEZHeE1W
         OBDA==
X-Gm-Message-State: AAQBX9dDL5Ksn8B/L+Y7yVz+dhtDMgXDjH13Ue0E9QL64ojdMykA7uLA
        TgHkYLw93zhYEydYNKhtTYEb5XooTwU=
X-Google-Smtp-Source: AKy350ag6d4bSfCDOptBpieRzniWJpVFwCPiX/4xg9Bael6bw/da2WDo5R4ZqVRDbhAJ9bNUVgQNe3MlshE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:813:b0:63d:38db:60e9 with SMTP id
 m19-20020a056a00081300b0063d38db60e9mr3145211pfk.2.1682127207666; Fri, 21 Apr
 2023 18:33:27 -0700 (PDT)
Date:   Fri, 21 Apr 2023 18:33:26 -0700
In-Reply-To: <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
Mime-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
Message-ID: <ZEM5Zq8oo+xnApW9@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
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

+Christian and Hugh

On Wed, Apr 19, 2023, David Hildenbrand wrote:
> On 19.04.23 02:47, Sean Christopherson wrote:
> > An alternative that we haven't considered since the very early days is making the
> > uAPI a KVM ioctl() instead of a memfd() flag or dedicated syscall.  Looking at the
> > code for "pure shim" implementation[3], that's actually not that crazy of an idea.
> 
> Yes.
> 
> > 
> > I don't know that I love the idea of burying this in KVM, but there are benefits
> > to coupling restrictedmem to KVM (aside from getting out from behind this bikeshed
> > that I created).
> 
> Yes, it's all better than jumping through hoops to come up with a bad name
> like "restrictedmem".
> 
> > 
> > The big benefit is that the layer of indirection goes away.  That simplifies things
> > like enhancing restrictedmem to allow host userspace access for debug purposes,
> > batching TLB flushes if a PUNCH_HOLE spans multiple memslots, enforcing exclusive
> > access, likely the whole "share with a device" story if/when we get there, etc.
> > 
> > The obvious downsides are that (a) maintenance falls under the KVM umbrella, but
> > that's likely to be true in practice regardless of where the code lands, and
> 
> Yes.
> 
> > (b) if another use case comes along, e.g. the Gunyah hypervisor[4][5], we risk
> > someone reinventing a similar solution.
> 
> I agree. But if it's as simple as providing an ioctl for that hypervisor
> that simply wires up the existing implementation, it's not too bad.
> 
> > 
> > If we can get Gunyah on board and they don't need substantial changes to the
> > restrictedmem implementation, then I'm all for continuing on the path we're on.
> > But if Gunyah wants to do their own thing, and the lightweight shim approach is
> > viable, then it's awfully tempting to put this all behind a KVM ioctl().
> 
> Right. Or we still succeed in finding a name that's not as bad as what we
> had so far.

Okie dokie.  So as not to bury the lede:

I think we should provide a KVM ioctl() and have KVM provide its own low-level
implementation, i.e. not wrap shmem.  As much as I don't want to have KVM serving
up memory to userspace, by trying to keep KVM out of the memory management business,
we're actually making things *more* complex and harder to maintain (and merge).

Hugh said something to this effect quite early on[1], it just unfortunately took
me a long time to understand the benefits.

 : QEMU gets fd from opening /dev/kvm_something, uses ioctls (or perhaps
 : the fallocate syscall interface itself) to allocate and free the memory,
 : ioctl for initializing some of it too.  KVM in control of whether that
 : fd can be read or written or mmap'ed or whatever, no need to prevent it
 : in shmem.c, no need for flags, seals, notifications to and fro because
 : KVM is already in control and knows the history.  If shmem actually has
 : value, call into it underneath - somewhat like SysV SHM, and /dev/zero
 : mmap, and i915/gem make use of it underneath.  If shmem has nothing to
 : add, just allocate and free kernel memory directly, recorded in your
 : own xarray.

Christian also suggested that we stop trying to be lazy and create a proper API[2].

 : I find this hard to navigate tbh and it feels like taking a shortcut to
 : avoid building a proper api. If you only care about a specific set of
 : operations specific to memfd restricte that needs to be available to
 : in-kernel consumers, I wonder if you shouldn't just go one step further
 : then your proposal below and build a dedicated minimal ops api. Idk,
 : sketching like a madman on a drawning board here with no claim to
 : feasibility from a mm perspective whatsoever

The key point from Hugh is that, except for a few minor things that are trivially
easy to replicate, the things that make shmem "shmem" don't provide any value for
the KVM use case:

  - We have no plans to support swap, and migration support is dubious at best.
    Swap in particular brings in a lot of complexity for no benefit (to us).  That
    complexity doesn't mean depending on shmem is inherently bad, but it does mean
    rolling our own implementation is highly unlikely to result in reinventing
    shmem's wheel.

  - Sharing a backing file between arbitrary process is _unwanted_ for the initial
    use cases.  There may come a time when mutually trusted VMs can share "private"
    data, but (a) that's a distant future problem and (b) it'll likely require even
    more KVM control over the memory.

  - All of the interfaces for read/write/mmap/etc. are dead weight from our
    perspective.  Even worse, we have to actively avoid those interfaces.  That
    can kinda sorta be done without polluting shmem code by using a shim, but
    that has problems of its own (see below).

And Christian pointed out several flaws with wrapping shmem:

  - Implementing a partial overlay filesystem leads to inconsistencies because
    only some of the ops are changed, e.g. poking at the inode_operations or
    super_operations will show shmem stuff, whereas address_space_operations and
    file_operations will show restrictedmem stuff.


  - Usurping just f_ops and a_ops without creating a full blown filesystem
    avoids the partial overlay issues, but partially overriding ops isn't really
    supported (because it's weird and brittle), e.g. blindly forwarding a
    fallocate() after restrictedmem does it's thing "works", but only because
    we very carefully and deliberately designed restrictedmem on top of shmem.

On top of the points raised by Hugh and Christian, wrapping shmem isn't really
any simpler, just different.  E.g. there's a very subtle bug in the shim variant:
by passing SGP_WRITE, shmem skips zeroing the page because restrictemem is telling
shmem that it (restrictedmem) will immediately write the page.  For TDX and SNP,
that's a "feature" because in those cases trusted firmware will zero (or init)
memory when it's assigned to the guest, but it's a nasty flaw for other use cases.

I'm not saying that we'll magically avoid such bugs by avoiding shmem, just pointing
out that using shmem requires understanding exactly how shmem works, i.e. using
shmem isn't necessarily any easier than building directly on filemap and/or folio
APIs.  And I gotta imagine it will be a similar story if/when we want to add
hugetlbfs support.  Building on filemap/folio will definitely have its own challenges,
but after prototyping an implementation I can confidently say that none of the
problems will be insurmountable.  KVM has _way_ more complex code in its memslot
and MMU implementations.

And another benefit of building on filemap and/or folio APIs is that, because we
would be reinventing the wheel to some extent, when we do inevitablly run into
problems, it will be easier to get help solving those problems because (a) we won't
be doing weird things no one wants to deal with and (b) because the problems will
likely be things others have already dealt with.

The other angle I've been looking at is whether or not having KVM provide its
own implementation will lead to maintenance problems in the future, specifically
if we get to the point where we want to support "fancy" things like swap and
migration.  For migration, I'm quite confident that a dedicated KVM ioctl() versus
wrapping shmem would be at worst a wash, and more than likely simpler if KVM owns
everything.  E.g. migrating pages under TDX and SNP requires invoking magic
instructions, and so we'd be overriding ->migrate_folio() no matter what.

As for swap, I think we should put a stake in the ground and say that KVM will
never support swap for KVM's ioctl().  Sooo much of the infrastructure around
swap/reclaim is tied to userspace mappings, e.g. knowing which pages are LRU and/or
cold.  I poked around a bit to see how we could avoid reinventing all of that
infrastructure for fd-only memory, and the best idea I could come up with is
basically a rehash of Kirill's very original "KVM protected memory" RFC[3], i.e.
allow "mapping" fd-only memory, but ensure that memory is never actually present
from hardware's perspective.

But on top of the various problems with that approach, the only use cases I can
think of for using fd-only to back non-confidential VMs is to guard against spurious
writes/reads to guest memory and/or avoid memory overhead for mapping guest
memory into the user page tables.  Avoiding memory overhead is completely defeated
if the page tables are populated PROT_NONE, which just leaves the "harden against
guest data corruption use case".  And for that specific use case, _if_ swap is
desirable, it would be far, far easier to teach the kernel to allow KVM to follow
PROT_NONE (as Kirill's series did), as opposed to trying to teach the kernel and/or
KVM how to swap fd-only memory.

In other words, fd-only memory is purely for slice-of-hardware VMs.  If someone
wants to overcommit VMs, then they use KVM's traditional API for mapping memory
into the guest.

Regarding putting this in KVM, as mentioned (way) above in the quote, the worst
case scenario of making this a KVM ioctl() seems to be that KVM will end up with
an ioctl() that redirects to common kernel code.  On the flip side, implementing
this in KVM gives us a much clearer path to getting all of this merged.  There will
be a few small non-KVM patches, but they will either be trivial, e.g. exporting
APIs (that aren't contentious) or not strictly required, e.g. adding a flag to
mark an address space as completely unmigratable (for improved performance).  I.e.
the non-KVM patches will be small and be very actionable for their maintainers,
and other than that we control our own destiny.

And on the topic of control, making this a KVM ioctl() and implementation gives
KVM a _lot_ of control.  E.g. we can make the file size immutable to simplify the
implementation, bind the fd to a single VM at creation time, add KVM-defined flags
for controlling hugepage behavior, etc.

Last but not least, I think forcing us KVM folks to get our hands at least a little
dirty with MM and FS stuff would be a *good* thing.  KVM has had more than a few
bugs that we missed in no small part because most of the people that work on KVM
have almost zero knowledge of MM and FS, and especially at the boundaries between
those two.

Note, I implemented the POC on top of the filemap APIs because that was much faster
and less error prone than re-implementing xarray management myself.  We may or may
not want to actually make the kernel at large aware of these allocations, i.e. it
may be better to follow Hugh's suggestion and use the folio APIs directly instead
of piggybacking filemap+folios.  E.g. I _think_ migration becomes a complete non-issue
if the pages are "raw" allocations and never get marked as LRU-friendly.  What I'm
not so sure about is if there is anything substantial that we'd lose out on by not
reusing the filemap stuff.

The POC also doesn't play nice with Ackerley's patches to allocate files on a
user-defined mount.  AIUI, that's largely a non-issue as something like fbind()
would provide a superset of that functionality and more than one maintainer has
expressed (handwavy) support for a generic fbind().

Code is available here if folks want to take a look before any kind of formal
posting:

	https://github.com/sean-jc/linux.git x86/kvm_gmem_solo

[1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@google.com
[2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@brauner
[3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutemov@linux.intel.com
