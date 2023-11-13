Return-Path: <kvm+bounces-1606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18BC77EA16F
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 17:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 301CF1C20935
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 16:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889B72232E;
	Mon, 13 Nov 2023 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0BmUW43z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C270B2134A
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 16:44:18 +0000 (UTC)
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F46D53
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:44:17 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id 71dfb90a1353d-4a18f724d47so1561952e0c.3
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699893856; x=1700498656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Oh1buoFW9Wx8GNHxVgKYsjzfXDy0o4J5rhs88onGqc=;
        b=0BmUW43zgPy7mzhJQArDNSHfhL3+Z0yRjxM0rTA8f/Lty5YW/OzDdLDul/jVPotzr9
         JdzPsMlefVRGsBJPQ5a35lrGl3HKrZh/z3tkSxQzHHQtQdyX6swI+F9g6rLAV5ocNjFt
         Tyt+nEkOeTDFr75TWeO/8ZhLZ39ibKXl4XYcvT92ZLJ3ASILc8nl722o/wQoCWOiEQYr
         3/AgfbrGeC0hHgaddtvn3LSS6UbtL+/W9+pKVT7FgqsZABDLq2D3P7vMvczo2PEhe4xU
         Gw829w2QbxB4yy/TxKKOVgmRqL+CpNPPnkzjjkEQ2yxCg9C57SIrHhMe5ySyQHdZSdJQ
         mvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699893856; x=1700498656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Oh1buoFW9Wx8GNHxVgKYsjzfXDy0o4J5rhs88onGqc=;
        b=e+pHi1air5wEDpTQTzTZzUBlQQePHZiaw7tsPzcUig4GzjKMbfQnhaycEBYfbKLLeq
         HwB1TzX6PRTsuFLNEBstW67Hw7GyRfI8SdBkUDzq2RNMJSbDO1HrwinUSsmfbzqWpNQs
         tJIs7ZrSuIXtmdHT/8a/kfdCZbRUiGh6epfhbHhJqxceu9hQnql/rZWTb5WzFBPSMCuQ
         5ZI6P2zmBwkJKF8EiyKHk8w/LP7pwPYY+GL0tUX2uIZ65hU1gjNmycWTUt9O/nHqHdP8
         KOwrsh0RymhWcQ1mVHnzRvRXxWYvcDQDypWVMLlWDyaed0gl7T8TWVFrWCVmS76e7BBn
         GVjg==
X-Gm-Message-State: AOJu0YyFiSLMgfT4AXx+8TViy9Bb/NDNVdw17FwuwZESvmZVKTaLOe7j
	kLFyc2FeDYOaFsmLr5YAYAqsjhuBC5oR/WerOz3S1OIs5hv6qu/ko+8VgQ==
X-Google-Smtp-Source: AGHT+IGcnlbt/lvvV7VgXWb4r1Og3sDlODCON9K4eJDMd/mSaenri++e7H/+SFlcNFeDPWGSbs13MpCmXOssIdqYIks=
X-Received: by 2002:a1f:f2c2:0:b0:49a:b737:4df7 with SMTP id
 q185-20020a1ff2c2000000b0049ab7374df7mr3191122vkh.5.1699893856018; Mon, 13
 Nov 2023 08:44:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n> <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com> <ZU0xCwvkKcpzBwc-@x1n> <CALzav=dyURZ=BOWzsYA8ruSWd3vgPQqxztHURWEUYPvOK=w4Yw@mail.gmail.com>
 <ZU+6RhTTWgSx7Juo@xz-m1.local>
In-Reply-To: <ZU+6RhTTWgSx7Juo@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Mon, 13 Nov 2023 08:43:48 -0800
Message-ID: <CALzav=dU_uU+aM+OvOgfieYoX7ot4bzJtY80Df2gNv=M-S606w@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 11, 2023 at 9:30=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Sat, Nov 11, 2023 at 08:23:57AM -0800, David Matlack wrote:
> >
> > But now that I think about it, isn't the KVM-based approach useful to
> > the broader community as well? For example, QEMU could use the
> > KVM-based demand paging for all KVM-generated accesses to guest
> > memory. This would provide 4K-granular demand paging for _most_ memory
> > accesses. Then for vhost and userspace accesses, QEMU can set up a
> > separate VMA mapping of guest memory and use UserfaultFD. The
> > userspace/vhost accesses would have to be done at the huge page size
> > granularity (if using HugeTLB). But most accesses should still come
> > from KVM, so this would be a real improvement over a pure UserfaultFD
> > approach.
>
> I fully understand why you propose that, but not the one I prefer.  That
> means KVM is leaving other modules behind. :( And that's not even the sam=
e
> as the case where KVM wants to resolve hugetlb over 1G, because at least =
we
> tried :) it's just that the proposal got rejected, unfortunately, so far.
>
> IMHO we should still consider virt the whole community, not KVM separatel=
y,
> even if KVM is indeed a separate module.

KVM is not just any module, though. It is the _only_ module that
mediates _guest_ access to host memory. KVM is also a constant: Any
Linux-based VM that cares about performance is using KVM. guest_memfd,
on the other hand, is not unique and not constant. It's just one way
to back guest memory.

The way I see it, we are going to have one of the 2 following outcomes:

1. VMMs use KVM-based demand paging to mediate guest accesses, and
UserfaultFD to mediate userspace and vhost accesses.
2. VMMs use guest_memfd-based demand paging for guest_memfd, and
UserfaultFD for everything else.

I think there are many advantages of (1) over (2). (1) means that VMMs
can have a common software architecture for post-copy across any
memory types. Any optimizations we implement will apply to _all_
memory types, not just guest_memfd.

Mediating guest accesses _in KVM_ also has practical benefits. It
gives us more flexibility to solve problems that are specific to
virtual machines that other parts of the kernel don't care about. For
example, there's value in being able to preemptively mark memory as
present so that guest accesses don't have to notify userspace. During
a Live Migration, at the beginning of post-copy, there might be a
large number of guest pages that are present and don't need to be
fetched. The set might also be sparse. With KVM mediating access to
guest memory, we can just add a bitmap-based UAPI to KVM to mark
memory as present.

Sure we could technically add a bitmap-based API to guest_memfd, but
that would only solve the problem _for guest_memfd_.

Then there's the bounce-buffering problem. With a guest_memfd-based
scheme, there's no way for userspace to bypass the kernel's notion of
what's present. That means all of guest memory has to be
bounce-buffered. (More on this below.)

And even if we generalize (2) to all memfds, that's still not covering
all ways of backing guest memory.

Having KVM-specific UAPIs is also not new. Consider how KVM implements
its own dirty tracking.

And all of that is independent of the short-term HugeTLB benefit for Google=
.

>
> So if we're going to propose the new solution to replace userfault, I'd
> rather we add support separately for everything at least still public, ev=
en
> if it'll take more work, comparing to make it kvm-only.

To be clear, it's not a replacement for UserfaultFD. It would work in
conjunction with UserfaultFD.

>
> >
> > And on the more practical side... If we integrate missing page support
> > directly into guest_memfd, I'm not sure how one part would even work.
> > Userspace would need a way to write to missing pages before marking
> > them present. So we'd need some sort of special flag to mmap() to
> > bypass the missing page interception? I'm sure it's solvable, but the
> > KVM-based does not have this problem.
>
> Userfaults rely on the temp buffer.  Take UFFDIO_COPY as an example,
> uffdio_copy.src|len describes that. Then the kernel does the atomicity
> work.

Any solution that requires bounce-buffering (memcpy) is unlikely to be
tenable. The performance implications and CPU overhead required to
bounce-buffer _every_ page of guest memory during post-copy is too
much. That's why Google maintains a second mapping when using
UserfaultFD.

>
> I'm not sure why KVM-based doesn't have that problem.  IIUC it'll be the
> same?  We can't make the folio present in the gmemfd mapping if it doesn'=
t
> yet contain full data copied over.  Having a special flag for the mapping
> is fine for each folio to allow different access permissions looks also
> fine, but that sounds like over complicated to me.

Both UserfaultFD and KVM-based demand paging don't have a
bounce-buffering problem because they mediate a specific _view_ of
guest memory, not the underlying memory. i.e. Neither mechanism
prevents userspace from creating a separate mapping where it can
access guest memory independent of the "present set", e.g. to RDMA
guest pages directly from the source.

