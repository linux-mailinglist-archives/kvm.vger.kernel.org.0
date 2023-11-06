Return-Path: <kvm+bounces-823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCC27E2FCD
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 23:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F26311C208D4
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 22:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CA82F506;
	Mon,  6 Nov 2023 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BD2pHC0o"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B3D2E648
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:24:55 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263B71BC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:24:53 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-991c786369cso743303066b.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 14:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699309491; x=1699914291; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBc/ggck5kEwoz7Pzq1oyoBVca0d6LjbmSU8LqVeIqY=;
        b=BD2pHC0oQpqvYOBjwECaztnOBTK98cl2drOuYlSho8cx74h5BgPQA7Ej+2xMvWCSdq
         fs3DWKiaS4innT5AE7HRNN3DRuXg0ZZA38IQul+waKUttqsD5qra9IMkpK+c4prkExHd
         Gy6PSsBYXXlMD2mCVOwGnYWpUhQf1pcx0icz/u8PHM5Ob6Wx7/e0id9VGD15QOTiHW51
         LVv8+PmE6cgbdLkndnk8DchTtQjDo0f+QehCY1Qk1HhMFjdn0TS9oPAZHJDAGepbwVrG
         UJUSCoeYEVhR+/g56nbo56ydnj5ZMdZVMjmRb5ebmhJ9cilzKtG1Uf0zu/A9kgX7TOaM
         2B1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699309491; x=1699914291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBc/ggck5kEwoz7Pzq1oyoBVca0d6LjbmSU8LqVeIqY=;
        b=rKMN31Tji6NCWkthuNCppdx/ZexqJuLfyFwUtD9TCN/XU74WP4kFDEZ/oP0QwO3mDp
         ZFcBKZ0kBPpJ/Za2DgxHIsL//SnR/mqtVapqYxVanGkFG5+GVRScPC904l1oy8rPJr1z
         smMukFJnmkhBMMsswmmvjLyaYEwnIGhBkZLKtYKEH5EVfymDXkoObfc6smt2azcBrZWN
         XxmyoDo4kjOrELPFqYlZMWfwOM14GaU4zPEGwjr5gTSRWU4sJU7OcqbNy+GvVPTzcj4I
         fJmqWTp2a8A+NjaQdIuPK+1YhzOOIllmmz6EyZqu21wia/IYY6jJtLFlPz+wDln+yaGg
         GBFg==
X-Gm-Message-State: AOJu0YzISFpjxtLlVT4KbIZNK3M4mWu5Rh72EMSwVUrXPNc8DizHZ6sb
	GkD+PPr0kAJ4SZxEAG/d0BNiutzLUDsQGCtSANETFg==
X-Google-Smtp-Source: AGHT+IHwz3xE0akhNgPv/m/6xjfXKJWeHCOK6th98fqnftiwEoDvEM3bsTp3VUR1QcjmFftQzaUNnObBDZNyca/mqcc=
X-Received: by 2002:a17:907:3205:b0:9de:3bc4:8cfa with SMTP id
 xg5-20020a170907320500b009de3bc48cfamr7105331ejb.3.1699309491406; Mon, 06 Nov
 2023 14:24:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
In-Reply-To: <ZUlLLGLi1IyMyhm4@x1n>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Mon, 6 Nov 2023 14:24:13 -0800
Message-ID: <CAJHvVciC3URbJJMwhU0ahhzq6bomr7juuWqPdpczV6Qgb8OUuQ@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 12:23=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, David,
>
> Before Paolo shares his opinion, I can provide some quick comments.
>
> On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > Hi Paolo,
> >
> > I'd like your feedback on whether you would merge a KVM-specific
> > alternative to UserfaultFD.
> >
> > Within Google we have a feature called "KVM Demand Paging" that we
> > have been using for post-copy live migration since 2014 and memory
> > poisoning emulation more recently. The high-level design is:
>
> I have no immediate comment on the proposal yet, but I can list how uffd
> handles below as comparisons, inline below.
>
> >
> >   (a) A bitmap that tracks which GFNs are present, along with a UAPI
> > to enable/disable the present bitmap.
>
> Uffd uses the pgtable (anon) or page cache (shmem/hugetlb) directly.
> Slight win, IMHO, because bitmap will be extra structure to maintain the
> same information, IIUC.
>
> >   (b) UAPIs for marking GFNs present and non-present.
>
> Similar, this is something bound to above bitmap design, and not needed f=
or
> uffd.  Extra interface?
>
> >   (c) KVM_RUN support for returning to userspace on guest page faults
> > to non-present GFNs.
>
> Uffd has the wait queues, so this will be extra kvm interface to maintain=
,
> but not easy to judge because it may bring benefits indeed, like better
> concurrency.  Personally I'm just not sure (1) how important concurrency =
is
> in this use case, and (2) whether we can improve uffd general code on
> scalability.
>
> For (1), if the time to resolve a remote page fault is bottlenecked on th=
e
> network, concurrency may not matter a huge deal, IMHO.  But I didn't real=
ly
> do enough test over this area.
>
> For (2), something like:
>
> https://lore.kernel.org/r/20230905214235.320571-1-peterx@redhat.com
>
> I didn't continue that thread because QEMU doesn't use uffd as heavy, so =
no
> rush to push that further from QEMU's perspective.  However IMHO it'll
> always be valuable to profile userfault to see whether the issues can be
> resolved in more general ways.  One thing that can happen is that we
> explored uffd enough so we may find out the bottleneck that we cannot avo=
id
> due to uffd's design, but IIUC that work hasn't yet been done by anyone,
> IOW there's still chance to me to provide a generic solution.
>
> >   (d) A notification mechanism and wait queue to coordinate KVM
> > accesses to non-present GFNs.
>
> Probably uffd's wait queue to be reimplemented more or less.
>
> Is this only used when there's no vcpu thread context?  I remember Anish'=
s
> other proposal on vcpu exit can already achieve similar without the queue=
.
>
> >   (e) UAPI or KVM policy for collapsing SPTEs into huge pages as guest
> > memory becomes present.
>
> This interface will also be needed if with userfaultfd, but if with uffd
> it'll be a common interface so can be used outside VM context.
>
> >
> > The actual implementation within Google has a lot of warts that I
> > won't get into... but I think we could have a pretty clean upstream
> > solution.
> >
> > In fact, a lot of the infrastructure needed to support this design is
> > already in-flight upstream. e.g. (a) and (b) could be built on top of
> > the new memory attributes (although I have concerns about the
> > performance of using xarray vs. bitmaps), (c) can be built on top of
> > the memory-fault exiting. The most complex piece of new code would be
> > the notification mechanism for (d). Within Google we've been using a
> > netlink socket, but I think we should use a custom file descriptor
> > instead.
> >
> > If we do it right, almost no architecture-specific support is needed.
> > Just a small bit in the page fault path (for (c) and to account for
> > the present bitmap when determining what (huge)page size to map).
> >
> > The most painful part of carrying KVM Demand Paging out-of-tree has
> > been maintaining the hooks for (d). But this has been mostly
> > self-inflicted. We started out by manually annotating all of the code
> > where KVM reads/writes guest memory. But there are more core routines
> > that all guest-memory accesses go through (e.g. __gfn_to_hva_many())
> > where we could put a single hook, and then KVM just has to make sure
>
> It's great to know (d) is actually not a real problem, however..
>
> > to invalidate an gfn-to-hva/pfn caches and SPTEs when a page becomes
> > non-present (which is rare and typically only happens before a vCPU
> > starts running). And hooking KVM accesses to guest memory isn't
> > exactly new, KVM already manually tracks all writes to keep the dirty
> > log up to date.
>
> .. what about all the other kernel modules that can directly access the
> guest memory without KVM APIs, like, vhost?  Does all of them need to
> implement similar things?
>
> >
> > So why merge a KVM-specific alternative to UserfaultFD?
> >
> > Taking a step back, let's look at what UserfaultFD is actually
> > providing for KVM VMs:
> >
> >   1. Coordination of userspace accesses to guest memory.
> >   2. Coordination of KVM+guest accesses to guest memory.
> >
> > (1.) technically does not need kernel support. It's possible to solve
> > this problem in userspace, and likely can be more efficient to solve
> > it in userspace because you have more flexibility and can avoid
> > bouncing through the kernel page fault handler. And it's not
> > unreasonable to expect VMMs to support this. VMMs already need to
> > manually intercept userspace _writes_ to guest memory to implement
> > dirty tracking efficiently. It's a small step beyond that to intercept
> > both reads and writes for post-copy. And VMMs are increasingly
> > multi-process. UserfaultFD provides coordination within a process but
> > VMMs already need to deal with coordinating across processes already.
> > i.e. UserfaultFD is only solving part of the problem for (1.).
> >
> > The KVM-specific approach is basically to provide kernel support for
> > (2) and let userspace solve (1) however it likes.
>
> It's slightly unfortunate to QEMU and other userspace hypervisors in this
> case, because it means even if the new interface will be merged, each
> community will need to add support for it for the same postcopy feature,
> and I'm not 100% sure on the complexity at least for QEMU.
>
> I think this is not a major concern if purely judging from KVM perspectiv=
e,
> indeed, as long as the solution supercedes the current one, so I think it=
's
> still okay to do so.  Meanwhile there is also the other option to let
> whatever userspace (QEMU, etc.) keeps using userfaultfd, so KVM will have
> two solutions for VM postcopy, which is also not fully unacceptable,
> either.  In all cases, before deciding to go this way, IMHO it'll be a ni=
ce
> gesture to consider the side effects to other communities, like QEMU, tha=
t
> heavily consumes KVM.
>
> >
> > But if UserfaultFD solves (1) and (2), why introduce a KVM feature
> > that solves only (2)?
> >
> > Well, UserfaultFD has some very real downsides:
> >
> >   * Lack of sufficient HugeTLB Support: The most recent and glaring
> >     problem is upstream's NACK of HugeTLB High Granularity Mapping [1].
> >     Without HGM, UserfaultFD can only handle HugeTLB faults at huge
> >     page granularity. i.e. If a VM is backed with 1GiB HugeTLB, then
> >     UserfaultFD can only handle 1GiB faults. Demand-fetching 1GiB of
> >     memory from a remote host during the post-copy phase of live
> >     migration is untenable. Even 2MiB fetches are painful with most
> >     current NICs. In effect, there is no line-of-sight on an upstream
> >     solution for post-copy live migration for VMs backed with HugeTLB.
>
> Indeed I didn't see any patch from James anymore for that support.  Does =
it
> mean that the project will be discontinued?
>
> Personally I still think this is the right way to go, that it'll be good =
if
> hugetlb pages can be split in any context even outside hypervisors.
>
> I don't think the community is NACKing the solution to allow hugetlb to
> split, it's not merged sololy because the specialty of hugetlbfs, and HGM
> just happened at that stage of time.
>
> I had a feeling that it'll be resolved sooner or later, even without a
> hugetlb v2, maybe?  That "v2" suggestion seems to be the final conclusion
> per the last lsfmm 2023 conference; however I don't know whether the
> discussion continued anywhere else, and I think that not all the ways are
> explored, and maybe we can work it out with current hugetlb code base in
> some form so that the community will be happy to allow hugetlb add new
> features again.

I can at least add my perspective here. Note it may be quite different
from James', I'm only speaking for myself here.

I agree HGM wasn't explicitly NACKed, but at the same time I don't
feel we ever got to consensus around a path for it to be merged. There
were some good suggestions from you Peter and others around
improvements to move in that direction, but it remains unclear to me
at least a) at what point will things be "unified enough" that new
features can be merged? and b) what path towards unification should we
take - incremental improvements? build a hugetlbfs v2? something else?

In other words, I think getting HGM merged upstream involves a
potentially large / unbounded amount of work, and the outcome is
uncertain (e.g. one can imagine a scenario where some incremental
improvements are made, but HGM still seems largely unpalatable to the
community despite this).

So, I think the HGM state of affairs made alternatives like what David
is talking about in this thread much more attractive than they were
when we started working on HGM. :/

>
> >
> >   * Memory Overhead: UserfaultFD requires an extra 8 bytes per page of
> >     guest memory for the userspace page table entries.
>
> What is this one?

In the way we use userfaultfd, there are two shared userspace mappings
- one non-UFFD registered one which is used to resolve demand paging
faults, and another UFFD-registered one which is handed to KVM et al
for the guest to use. I think David is talking about the "second"
mapping as overhead here, since with the KVM-based approach he's
describing we don't need that mapping.

>
> >
> >   * CPU Overhead: UserfaultFD has to manipulate userspace page tables t=
o
> >     split mappings down to PAGE_SIZE, handle PAGE_SIZE'd faults, and,
> >     later, collapse mappings back into huge pages. These manipulations =
take
> >     locks like mmap_lock, page locks, and page table locks.
>
> Indeed this can be a problem, however this is also the best part of
> userfaultfd on the cleaness of the whole design, that it unifies everythi=
ng
> into the core mm, and it's already there.  That's also why it can work wi=
th
> kvm/vhost/userapp/whatever as long as the page is accessed in whatever
> form.
>
> >
> >   * Complexity: UserfaultFD-based demand paging depends on functionalit=
y
> >     across multiple subsystems in the kernel including Core MM, KVM, as
> >     well as the each of the memory filesystems (tmpfs, HugeTLB, and
> >     eventually guest_memfd). Debugging problems requires
> >     knowledge across many domains that many engineers do not have. And
> >     solving problems requires getting buy-in from multiple subsystem
> >     maintainers that may not all be aligned (see: HGM).
>
> I'll put HGM related discussion in above bullet.  OTOH, I'd consider
> "debugging problem requires knowledge across many domains" not as valid a=
s
> reasoning.  At least this is not a pure technical point, and I think we
> should still stick with technical comparisons on the solutions.
>
> >
> > All of these are addressed with a KVM-specific solution. A
> > KVM-specific solution can have:
> >
> >   * Transparent support for any backing memory subsystem (tmpfs,
> >     HugeTLB, and even guest_memfd).
>
> I'm curious how hard would it be to allow guest_memfd support userfaultfd=
.
> David, do you know?
>
> The rest are already supported by uffd so I assume not a major problem.
>
> >   * Only 1 bit of overhead per page of guest memory.
> >   * No need to modify host page tables.
> >   * All code contained within KVM.
> >   * Significantly fewer LOC than UserfaultFD.
>
> We're not planning to remove uffd from mm even if this is merged.. right?
> Could you elaborate?

Also, if we did make improvements for UFFD for this use case, other
(non-VM) use cases may also benefit from those same improvements,
since UFFD is so general.

>
> >
> > Ok, that's the pitch. What are your thoughts?
> >
> > [1] https://lore.kernel.org/linux-mm/20230218002819.1486479-1-jthoughto=
n@google.com/
>
> How about hwpoison in no-KVM contexts?  I remember Mike Kravetz mentioned
> about that in the database usages, and IIRC Google also mentioned the
> interest in that area at least before.
>
> Copy Mike for that; copy Andrea for everything.
>
> Thanks,
>
> --
> Peter Xu
>

