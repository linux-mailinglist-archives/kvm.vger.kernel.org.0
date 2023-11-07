Return-Path: <kvm+bounces-1089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AA77E4BB2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 23:29:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2011C20C92
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896A22A8CF;
	Tue,  7 Nov 2023 22:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h4/MLFNe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A02F870
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 22:29:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C94D11B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699396145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=14nYNv3+xpT4VSdBjbRS8HYKLwqiJKoVofBxrd00cPA=;
	b=h4/MLFNeeDIlCWeOE8fqpCfqrczNWi2/gmiuO2EMbhmcaO+RbvVGzZ9ILlXCGzqi70WWBp
	p2lSgXRuaZk0GUUTgVmfbHBpASc5OWhomD8dizKAb9EPnZ3odT7vR/J/ZrxvaCj70u3COJ
	h3XVkwSClbUdlQXqU3Kfao3Nlj2JjQs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-PdylK355MQe-x2p-dRJOmg-1; Tue, 07 Nov 2023 17:29:03 -0500
X-MC-Unique: PdylK355MQe-x2p-dRJOmg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-778a3e0b755so97869585a.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 14:29:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699396143; x=1700000943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14nYNv3+xpT4VSdBjbRS8HYKLwqiJKoVofBxrd00cPA=;
        b=CuisHEgVB2lYHgBjtpmS+ZtbwSxO+USktWGz6GkYEFhc8fWMr1aUguU56M38xy+HxY
         7DxgmRSszom2PngW1NajoJXmgjY8rkM02QN1aZkv4tnTQ2dnqwBhDlddse88YdZJe+AJ
         nv2f3uwQ5EFKaNhFMqRNrvUaVpHQYGWQzmCtrt97cx5OyFC8B3HnOUZtDeYQ/S2Or5qr
         a0qW88QFpl3skCRQfSnsDSLGR94z5OdYxnx6meJv60Lx87Dvu2vmoH2ic/B/maHvXYVk
         mTCtDgnKbU6805YTaIvJKNavVGu8ZQFwYvQgnKtmcNfWBGY9cUtzavsugbe1Rdxx/vlS
         sG6Q==
X-Gm-Message-State: AOJu0YwIPf9fLyvMvsiWDm7zOchSskEwRkZ7IxvlJjC1YRMeXudukaMQ
	RargkuD9G5MnhL0J6DmQu5KP4QRH6iUQF7uuXlaK2zS1o367hnmR5cni5CHCUJo/ChHn2pNWid7
	mInuIpnk1NjbU
X-Received: by 2002:a05:620a:1a98:b0:76d:95d3:800f with SMTP id bl24-20020a05620a1a9800b0076d95d3800fmr548461qkb.3.1699396143256;
        Tue, 07 Nov 2023 14:29:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGb2u25pNaIZvHnk6V0FK7STL+1PooXM5T2CLNLGM3wP6wOMwdu+mXbDrkzZ/DBEyIi9BNRw==
X-Received: by 2002:a05:620a:1a98:b0:76d:95d3:800f with SMTP id bl24-20020a05620a1a9800b0076d95d3800fmr548450qkb.3.1699396142894;
        Tue, 07 Nov 2023 14:29:02 -0800 (PST)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id bj28-20020a05620a191c00b007756f60bcacsm352809qkb.79.2023.11.07.14.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 14:29:02 -0800 (PST)
Date: Tue, 7 Nov 2023 17:29:00 -0500
From: Peter Xu <peterx@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, kvm list <kvm@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZUq6LJ+YppFlf43f@x1n>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>

Paolo,

On Tue, Nov 07, 2023 at 05:25:06PM +0100, Paolo Bonzini wrote:
> On 11/6/23 21:23, Peter Xu wrote:
> > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > > Hi Paolo,
> > > 
> > > I'd like your feedback on whether you would merge a KVM-specific
> > > alternative to UserfaultFD.
> 
> I'm reply to Peter's message because he already brought up some points that
> I'd have made...
> 
> > >    (b) UAPIs for marking GFNs present and non-present.
> > 
> > Similar, this is something bound to above bitmap design, and not needed for
> > uffd.  Extra interface?
> 
> We already use fallocate APIs to mark GFNs non-present in guest_memfd; and
> we also use them to mark GFNs present but it would not work to do that for
> atomic copy-and-allocate.  This UAPI could be pwrite() or a ioctl().

Agree.

> 
> > >    (c) KVM_RUN support for returning to userspace on guest page faults
> > > to non-present GFNs.
> > 
> > For (1), if the time to resolve a remote page fault is bottlenecked on the
> > network, concurrency may not matter a huge deal, IMHO.
> 
> That's likely, and it means we could simply extend KVM_EXIT_MEMORY_FAULT.
> However, we need to be careful not to have a maze of twisty APIs, all
> different.
> 
> > >    (d) A notification mechanism and wait queue to coordinate KVM
> > > accesses to non-present GFNs.
> > 
> > Probably uffd's wait queue to be reimplemented more or less.
> > Is this only used when there's no vcpu thread context?  I remember Anish's
> > other proposal on vcpu exit can already achieve similar without the queue.
> 
> I think this synchronization can be done mostly in userspace, at least on
> x86 (just like we got rid of the global VM-level dirty ring). But it remains
> a problem on Arm.

My memory was that ARM was also not the only outlier?  We probably need to
reach a consensus on whether we should consider ARM and no-vcpu context
from the start of the design.

> 
> > >    (e) UAPI or KVM policy for collapsing SPTEs into huge pages as guest
> > > memory becomes present.
> > 
> > This interface will also be needed if with userfaultfd, but if with uffd
> > it'll be a common interface so can be used outside VM context.
> 
> And it can be a generic API anyway (could be fadvise).

IMHO it should depend on whether multiple KVM instances will have the same
requirement when they are attached to the same gmemfd, when we want to
collapse small folios into a large for that gmemfd.

If my understanding is correct, that "N kvm <-> 1 gmemfd" idea was mostly
for kvm live upgrade on old<->new modules as the plan, then it seems all
KVMs do have the same goal over the large folio, then fadvise() seems
proper to me.

> 
> > > So why merge a KVM-specific alternative to UserfaultFD?
> > > 
> > > Taking a step back, let's look at what UserfaultFD is actually
> > > providing for KVM VMs:
> > > 
> > >    1. Coordination of userspace accesses to guest memory.
> > >    2. Coordination of KVM+guest accesses to guest memory.
> > > 
> > > VMMs already need to
> > > manually intercept userspace _writes_ to guest memory to implement
> > > dirty tracking efficiently. It's a small step beyond that to intercept
> > > both reads and writes for post-copy. And VMMs are increasingly
> > > multi-process. UserfaultFD provides coordination within a process but
> > > VMMs already need to deal with coordinating across processes already.
> > > i.e. UserfaultFD is only solving part of the problem for (1.).
> 
> This is partly true but it is missing non-vCPU kernel accesses, and it's
> what worries me the most if you propose this as a generic mechanism.  My gut
> feeling even without reading everything was (and it was confirmed after): I
> am open to merging some specific features that close holes in the
> userfaultfd API, but in general I like the unification between guest,
> userspace *and kernel* accesses that userfaultfd brings. The fact that it
> includes VGIC on Arm is a cherry on top. :)
> 
> For things other than guest_memfd, I want to ask Peter & co. if there could
> be a variant of userfaultfd that is better integrated with memfd, and solve
> the multi-process VMM issue.  For example, maybe a userfaultfd-like
> mechanism for memfd could handle missing faults from _any_ VMA for the
> memfd.

On "why uffd is per-vma": I never confirmed with Andrea on the current
design of uffd, but IMO it makes sense to make it per-process from security
pov, otherwise it's more a risk to the whole system: consider an attacker
open a fake logfile under shmem, waiting for another proc to open it and
control page fault of it.  The current uffd design requires each process to
be voluntary into userfaultfd involvements by either invoking syscall(uffd)
or open(/dev/userfaultfd).  People are obviously worried about uffd safety
already even with current conservative per-mm design, so as to introduce
unprileged_userfaultfd, /dev/userfaultfd, selinux rules, etc..

I think memfd can be a good candidate to start support file uffd if we want
to go that far, because memfd is by default anonymous, so at least added
much more complexity on hijacking.  Above example won't apply to memfd due
to anonymousness, requiring the target taking memfd and mmap() into its
address space, which is much harder.  IOW, the "voluntary" part moved from
uffd desc to the memfd desc.

What I don't know is whether it'd be worthwhile to go with such a design..
Currently even with per-mm uffd the complexity is mostly manageable to me:
each proc needs to allocate its own uffd, register, and deliver to the host
process (e.g. in QEMU's case, openvswitch delivers that to QEMU).

> 
> However, guest_memfd could be a good usecase for the mechanism that you
> suggest.  Currently guest_memfd cannot be mapped in userspace pages.  As
> such it cannot be used with userfaultfd.  Furthermore, because it is only
> mapped by hypervisor page tables, or written via hypervisor APIs,
> guest_memfd can easily track presence at 4KB granularity even if backed by
> huge pages.  That could be a point in favor of a KVM-specific solution.
> 
> Also, even if we envision mmap() support as one of the future extensions of
> guest_memfd, that does not mean you can use it together with userfaultfd.
> For example, if we had restrictedmem-backed guest_memfd, or
> non-struct-page-backed guest_memfd, mmap() would be creating a VM_PFNMAP
> area.

I think it's doable to support userfaultfd (or at least something like
userfaultfd) as long as we can trap at the fault time (e.g., the PFN should
be faulted dynamically in some form, rather than pfn mapped in mmap()).
AFAIK userfaultfd doesn't require page struct on its own.

> 
> Once you have the implementation done for guest_memfd, it is interesting to
> see how easily it extends to other, userspace-mappable kinds of memory.  But
> I still dislike the fact that you need some kind of extra protocol in
> userspace, for multi-process VMMs.  This is the kind of thing that the
> kernel is supposed to facilitate.  I'd like it to do _more_ of that (see
> above memfd pseudo-suggestion), not less.

Is that our future plan to extend gmemfd to normal memories?

I see that gmemfd manages folio on its own.  I think it'll make perfect
sense if it's for use in CoCo context, where the memory is so special to be
generic anyway.

However if to extend it to generic memories, I'm wondering how do we
support existing memory features of such memory which already exist with
KVM_SET_USER_MEMORY_REGION v1.  To name some:

  - numa awareness
  - swapping
  - cgroup
  - punch hole (in a huge page, aka, thp split)
  - cma allocations for huge pages / page migrations
  - ...

I also haven't thought all through on how other modules should consume
gmemfd yet, as I raised the other question previously on vhost.
E.g. AFAICT, vhost at least will also need ioctl(VHOST_SET_MEM_TABLE2).

Does it mean that most of these features will be reimplemented in kvm in
some form?  Or is there easy way?

> 
> > > All of these are addressed with a KVM-specific solution. A
> > > KVM-specific solution can have:
> > > 
> > >    * Transparent support for any backing memory subsystem (tmpfs,
> > >      HugeTLB, and even guest_memfd).
> > 
> > I'm curious how hard would it be to allow guest_memfd support userfaultfd.
> > David, do you know?
> 
> Did I answer above?  I suppose you'd have something along the lines of
> vma_is_shmem() added to vma_can_userfault; or possibly add something to
> vm_ops to bridge the differences.

Relying on "whether folio existed in gmemfd mapping" sounds very sane and
natural to identify data presence.  However not yet clear on the rest to me.

Currently kvm_gmem_allocate() does look like the place where gmemfd folios
will be allocated, so that can be an unified hook point where we'd want
something besides a zeroed page, huge or small.  But I'm not sure that's
the long term plan: it seems to me current fallocate(gmemfd) approach is
more for populating the mem object when VM starts.

A "can be relevant" question could be: what will happen if vhost would like
to DMA to a guest page that hasn't yet been transferred to the CoCo VM,
assuming we're during a postcopy process?  It seems to me there's some page
request interface still missing for gmemfd, but I'm also not sure.

> 
> > The rest are already supported by uffd so I assume not a major problem.
> 
> Userfaultfd is kinda unusable for 1GB pages so I'm not sure I'd include it
> in the "already works" side, but yeah.

Ah I never meant that 1G is working when leaving that comment. :) It's a
long known issue that userfaultfd / postcopy is not usable on 1G pages.

I think it's indeed fair to assume it's just broken and won't be able to be
fixed at least in the near future.

Thanks,

-- 
Peter Xu


