Return-Path: <kvm+bounces-814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C677E2BD8
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 19:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 798762817A3
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 18:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24762D029;
	Mon,  6 Nov 2023 18:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p7dDrTfV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC172C874
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 18:25:46 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358B8D49
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:25:44 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-4083740f92dso35372745e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699295142; x=1699899942; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PZbnOM7riEudGU41WAWVHJxxAgVIo5bmLQWh/3qy2QU=;
        b=p7dDrTfVe/xI66uroMfqOBf0ufx3lAfLXVLaBFJwi3zkdZUh1OFIWZrvjcHX5lJUJo
         nzyciEjx/6RTaoicpxe5Ba/M6VDLfY1V2fC+yPgI3CeDzr9YUT6ilTHt9IevHX+HGdyM
         docZtmPZsGXviq2HgWmD+tOWVpMsw1qEtMATuLkXaXxMnt+iqzwDeTQI6hZ39rU9m4IF
         bFxFAuNx6ZFp1z6W1WtzN8iQzAUmQVaJ2BaLzjhzQ34qf0xAtRSz0OecYJzGTuNwwNCQ
         UiWbheaJJthmtdTQQaJqbn+Ghir/jJxhyZDskYtSzYZtK3eNXB1QDk8fjMtYj2ZLbsBO
         OsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699295142; x=1699899942;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PZbnOM7riEudGU41WAWVHJxxAgVIo5bmLQWh/3qy2QU=;
        b=Y4HdCI18H8utgI5qfJwxpkn9o5orDuMi7BaqQmIfSEMXUNPRAnOzp93a2WJNmYmmuu
         DbxiQRv81L8KlAI1HyWF36p8Yh4w6jLgpXOxlcK/LtdZTl+gSaGWNHsbG5O/EtziEoQC
         AWDB2hFHSvDDBXl8TTWIPbuboZmnE+wCSJT4A1vwenjfWu3A1hp6Y6ujLYXhBiAEGP38
         LvVvUIqJFaeSHXgWSwXOGeDN7/MrOByVtt3bEK+x4u4ywuA+T5wsdrZwJotiyIldZb1L
         fN06jbUNm3+38aYSZKsHwMkNNMTp0GdTvXKzNm1j5ytWFlS96eFejen4omRXGx2Wb/20
         Lytw==
X-Gm-Message-State: AOJu0YyiGqBrrB5osZ72mrgpluUtTcxfB5iwGNL7mwVwoKHjIbIpCYGN
	w8DteCDHR+3B9v4uDpwi9kF6zMyGUyeUDONeLFHZ4A==
X-Google-Smtp-Source: AGHT+IGmZRqvulBIYkvstrT5vZf9v7xG3mXvGD1G/qvRDEa0Wn50IaaWfnICFy/qZaiQ4+qeMBy9qNzAXncWFRQAfKc=
X-Received: by 2002:a05:6000:18a4:b0:32f:755c:c625 with SMTP id
 b4-20020a05600018a400b0032f755cc625mr24342465wri.11.1699295142426; Mon, 06
 Nov 2023 10:25:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: David Matlack <dmatlack@google.com>
Date: Mon, 6 Nov 2023 10:25:13 -0800
Message-ID: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
Subject: RFC: A KVM-specific alternative to UserfaultFD
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

I'd like your feedback on whether you would merge a KVM-specific
alternative to UserfaultFD.

Within Google we have a feature called "KVM Demand Paging" that we
have been using for post-copy live migration since 2014 and memory
poisoning emulation more recently. The high-level design is:

  (a) A bitmap that tracks which GFNs are present, along with a UAPI
to enable/disable the present bitmap.
  (b) UAPIs for marking GFNs present and non-present.
  (c) KVM_RUN support for returning to userspace on guest page faults
to non-present GFNs.
  (d) A notification mechanism and wait queue to coordinate KVM
accesses to non-present GFNs.
  (e) UAPI or KVM policy for collapsing SPTEs into huge pages as guest
memory becomes present.

The actual implementation within Google has a lot of warts that I
won't get into... but I think we could have a pretty clean upstream
solution.

In fact, a lot of the infrastructure needed to support this design is
already in-flight upstream. e.g. (a) and (b) could be built on top of
the new memory attributes (although I have concerns about the
performance of using xarray vs. bitmaps), (c) can be built on top of
the memory-fault exiting. The most complex piece of new code would be
the notification mechanism for (d). Within Google we've been using a
netlink socket, but I think we should use a custom file descriptor
instead.

If we do it right, almost no architecture-specific support is needed.
Just a small bit in the page fault path (for (c) and to account for
the present bitmap when determining what (huge)page size to map).

The most painful part of carrying KVM Demand Paging out-of-tree has
been maintaining the hooks for (d). But this has been mostly
self-inflicted. We started out by manually annotating all of the code
where KVM reads/writes guest memory. But there are more core routines
that all guest-memory accesses go through (e.g. __gfn_to_hva_many())
where we could put a single hook, and then KVM just has to make sure
to invalidate an gfn-to-hva/pfn caches and SPTEs when a page becomes
non-present (which is rare and typically only happens before a vCPU
starts running). And hooking KVM accesses to guest memory isn't
exactly new, KVM already manually tracks all writes to keep the dirty
log up to date.

So why merge a KVM-specific alternative to UserfaultFD?

Taking a step back, let's look at what UserfaultFD is actually
providing for KVM VMs:

  1. Coordination of userspace accesses to guest memory.
  2. Coordination of KVM+guest accesses to guest memory.

(1.) technically does not need kernel support. It's possible to solve
this problem in userspace, and likely can be more efficient to solve
it in userspace because you have more flexibility and can avoid
bouncing through the kernel page fault handler. And it's not
unreasonable to expect VMMs to support this. VMMs already need to
manually intercept userspace _writes_ to guest memory to implement
dirty tracking efficiently. It's a small step beyond that to intercept
both reads and writes for post-copy. And VMMs are increasingly
multi-process. UserfaultFD provides coordination within a process but
VMMs already need to deal with coordinating across processes already.
i.e. UserfaultFD is only solving part of the problem for (1.).

The KVM-specific approach is basically to provide kernel support for
(2) and let userspace solve (1) however it likes.

But if UserfaultFD solves (1) and (2), why introduce a KVM feature
that solves only (2)?

Well, UserfaultFD has some very real downsides:

  * Lack of sufficient HugeTLB Support: The most recent and glaring
    problem is upstream's NACK of HugeTLB High Granularity Mapping [1].
    Without HGM, UserfaultFD can only handle HugeTLB faults at huge
    page granularity. i.e. If a VM is backed with 1GiB HugeTLB, then
    UserfaultFD can only handle 1GiB faults. Demand-fetching 1GiB of
    memory from a remote host during the post-copy phase of live
    migration is untenable. Even 2MiB fetches are painful with most
    current NICs. In effect, there is no line-of-sight on an upstream
    solution for post-copy live migration for VMs backed with HugeTLB.

  * Memory Overhead: UserfaultFD requires an extra 8 bytes per page of
    guest memory for the userspace page table entries.

  * CPU Overhead: UserfaultFD has to manipulate userspace page tables to
    split mappings down to PAGE_SIZE, handle PAGE_SIZE'd faults, and,
    later, collapse mappings back into huge pages. These manipulations take
    locks like mmap_lock, page locks, and page table locks.

  * Complexity: UserfaultFD-based demand paging depends on functionality
    across multiple subsystems in the kernel including Core MM, KVM, as
    well as the each of the memory filesystems (tmpfs, HugeTLB, and
    eventually guest_memfd). Debugging problems requires
    knowledge across many domains that many engineers do not have. And
    solving problems requires getting buy-in from multiple subsystem
    maintainers that may not all be aligned (see: HGM).

All of these are addressed with a KVM-specific solution. A
KVM-specific solution can have:

  * Transparent support for any backing memory subsystem (tmpfs,
    HugeTLB, and even guest_memfd).
  * Only 1 bit of overhead per page of guest memory.
  * No need to modify host page tables.
  * All code contained within KVM.
  * Significantly fewer LOC than UserfaultFD.

Ok, that's the pitch. What are your thoughts?

[1] https://lore.kernel.org/linux-mm/20230218002819.1486479-1-jthoughton@google.com/

