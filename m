Return-Path: <kvm+bounces-2134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBEB7F1C73
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 19:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0C21C2184B
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 18:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F57B321AA;
	Mon, 20 Nov 2023 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ClaRwpk0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE766C9
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 10:32:51 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-421ae866bc2so29991cf.0
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 10:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700505171; x=1701109971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8SQ5+iePSzyz7d8X0NCYQHRcVGWk9rqi7uNg7LIa+o=;
        b=ClaRwpk0EqRIKvJlxQSWMEXRJac9xzL6hFkrGtjovJeJ/r17TGmu1JHoq9PWKuX5OG
         0iObM/IJeccwhxXhgOo9E5DVmqC9sAe4FlJHGOktoPeTKKvWHAjNGtecXQFQoVDYp3WY
         dZS1bi1oyu6e5etX9F/OZzWo9+zIYlQZnBFA5ynr3Po/1vzbArAsIFzojncyABIcjVd4
         b2fLzQ1WJV2kQ4Kd15K2pP4fZTbwUMr43Kiqu3zGnQT6Iu9ji7qR/FWh21lZS5kg/0AE
         yQ5tN+iNYoIANwEENz49wliNgIVOEGMFEnO1FYCmwAPVNsrotTznQLGzzz0rgTuRRTBO
         rRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700505171; x=1701109971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F8SQ5+iePSzyz7d8X0NCYQHRcVGWk9rqi7uNg7LIa+o=;
        b=Rvq/bjyjR+qptdr7ixuXO+X3GMiQ4xFYtcFPLFsibOnwdlA5Hi91cRQ6+x6IwTestU
         4K61h5wInrJo118ZJvA7QNQpo5jXMzZJlvFvwRUt7uNpVCo0dLnLnbmefbuGpWJ9Cmka
         i/zoj95jzJoGE0W5g3noDJtJujG3v0lJkf4xkbDoZjvcPNH/phkR1Z/O7wctIIWDOEbD
         VtlhVApLGeaRvZB9+aVtG3dYfcl/MNQ7QuE+Big6HgWY++EM6PbWKjUGA92OW2jWOdCK
         /nLInJHtmtYBPmUIKyvtNCRBCyk1Ul60cis2jgIX78qwSCvNqvylp6tIXnO5L90pk/Vb
         ALtg==
X-Gm-Message-State: AOJu0YyahSIa/4AhEOjk0kz4OIJPb15P00j85hxN53mjQxShJsgjs35g
	XO69XqmNAyONP0spotmKlG5MoSUOtnu5dBxVOn4vqA==
X-Google-Smtp-Source: AGHT+IFtg7Tv5PbkkqL5v/zocaLdoDQQlERLBodXOOYTFhFgid7cutvomW57MBbCwmfHQNqMES5UQdIFNdP83G7e57Y=
X-Received: by 2002:a05:622a:1444:b0:420:e68c:5b with SMTP id
 v4-20020a05622a144400b00420e68c005bmr489115qtx.13.1700505170545; Mon, 20 Nov
 2023 10:32:50 -0800 (PST)
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
 <ZU+6RhTTWgSx7Juo@xz-m1.local> <CALzav=dU_uU+aM+OvOgfieYoX7ot4bzJtY80Df2gNv=M-S606w@mail.gmail.com>
In-Reply-To: <CALzav=dU_uU+aM+OvOgfieYoX7ot4bzJtY80Df2gNv=M-S606w@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 20 Nov 2023 13:32:12 -0500
Message-ID: <CADrL8HVwBjLpWDM9i9Co1puFWmJshZOKVu727fMPJUAbD+XX5g@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: David Matlack <dmatlack@google.com>
Cc: Peter Xu <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2023 at 8:44=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Sat, Nov 11, 2023 at 9:30=E2=80=AFAM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Sat, Nov 11, 2023 at 08:23:57AM -0800, David Matlack wrote:
> > >
> > > But now that I think about it, isn't the KVM-based approach useful to
> > > the broader community as well? For example, QEMU could use the
> > > KVM-based demand paging for all KVM-generated accesses to guest
> > > memory. This would provide 4K-granular demand paging for _most_ memor=
y
> > > accesses. Then for vhost and userspace accesses, QEMU can set up a
> > > separate VMA mapping of guest memory and use UserfaultFD. The
> > > userspace/vhost accesses would have to be done at the huge page size
> > > granularity (if using HugeTLB). But most accesses should still come
> > > from KVM, so this would be a real improvement over a pure UserfaultFD
> > > approach.
> >
> > I fully understand why you propose that, but not the one I prefer.  Tha=
t
> > means KVM is leaving other modules behind. :( And that's not even the s=
ame
> > as the case where KVM wants to resolve hugetlb over 1G, because at leas=
t we
> > tried :) it's just that the proposal got rejected, unfortunately, so fa=
r.
> >
> > IMHO we should still consider virt the whole community, not KVM separat=
ely,
> > even if KVM is indeed a separate module.
>
> KVM is not just any module, though. It is the _only_ module that
> mediates _guest_ access to host memory. KVM is also a constant: Any
> Linux-based VM that cares about performance is using KVM. guest_memfd,
> on the other hand, is not unique and not constant. It's just one way
> to back guest memory.
>
> The way I see it, we are going to have one of the 2 following outcomes:
>
> 1. VMMs use KVM-based demand paging to mediate guest accesses, and
> UserfaultFD to mediate userspace and vhost accesses.
> 2. VMMs use guest_memfd-based demand paging for guest_memfd, and
> UserfaultFD for everything else.
>
> I think there are many advantages of (1) over (2). (1) means that VMMs
> can have a common software architecture for post-copy across any
> memory types. Any optimizations we implement will apply to _all_
> memory types, not just guest_memfd.
>
> Mediating guest accesses _in KVM_ also has practical benefits. It
> gives us more flexibility to solve problems that are specific to
> virtual machines that other parts of the kernel don't care about. For
> example, there's value in being able to preemptively mark memory as
> present so that guest accesses don't have to notify userspace. During
> a Live Migration, at the beginning of post-copy, there might be a
> large number of guest pages that are present and don't need to be
> fetched. The set might also be sparse. With KVM mediating access to
> guest memory, we can just add a bitmap-based UAPI to KVM to mark
> memory as present.

I'm not sure if this has been mentioned yet, but making guest_memfd
work at all for non-private memory would require changing all the
places where we do uaccess to go through guest_memfd logic instead
(provided the goal is to have no dependency on the userspace page
tables, i.e., we don't need to mmap the guest_memfd). Those uaccess
places are most of the places where KVM demand paging hooks would need
to be added (plus GUP, and maybe a few more, like if KVM uses kmap to
access memory). This isn't considering making post-copy work with
guest_memfd, just making guest_memfd work at all for non-private
memory.

So the way I see it, making guest_memfd work more completely would be
a decent chunk (most?) of the work for KVM demand paging. I think a
more generic solution akin to userfaultfd would be better if it can
cleanly solve our problem.

> Sure we could technically add a bitmap-based API to guest_memfd, but
> that would only solve the problem _for guest_memfd_.

I think this could be done in a more generic way. If we had some kind
of file-based userfaultfd, we could use that to mediate KVM's use of
the guest_memfd, instead of building the API into guest_memfd itself.
Guest_memfd would be the only useful application of this for KVM (as
using tmpfs/etc. memfds directly would still require uaccess =3D>
regular userfaultfd). Maybe there could be other applications for
file-based userfaultfd someday; I haven't thought of any yet.

It also doesn't have to be some kind of bitmap-based API either
(though that might be the right approach). Certainly UFFDIO_INSERT
(the analogue of UFFDIO_COPY, IIUC) wouldn't be enough either; we
would need an analogue for UFFDIO_CONTINUE (see [1] for the original
motivation).

What about something like this:

When an mm tries to grab a page from the file (via vm_ops->fault or
the appropriate equivalent operation, like for guest_memfd,
kvm_gmem_get_folio), notify userspace via userfaultfd that this is
about to happen, and userspace can delay it for as long as necessary,
then issuing a UFFDIO_WAKE_FILE (or something).

This approach doesn't solve the problem of telling KVM if a 2M or 1G
mapping is ok, though. :( I'm also not sure how to translate "when an
mm tries to grab a page from the file" into something that makes sense
to userspace, so maybe that's another reason this idea doesn't work,
and a bitmap would be better.

If we go with a file-based userfaultfd system, I think we're basically
stuck with using guest_memfd if we want to avoid the memory + CPU
overhead that comes from normal userfaultfd for post-copy (due to
managing the userspace page tables; not needed with KVM demand
paging). So we'd need to build everything we need into guest_memfd,
like 1G page support, and maybe even things like a
hugetlb-vmemmap-optimization equivalent for guest_memfd.

Given that guest_memfd doesn't support swapping, we wouldn't be able
to reap the benefits of file-based userfaultfd over regular
userfaultfd for tmpfs-backed VMs that rely on swapping. :( So that's
another point in favor of KVM demand paging.

>
> Then there's the bounce-buffering problem. With a guest_memfd-based
> scheme, there's no way for userspace to bypass the kernel's notion of
> what's present. That means all of guest memory has to be
> bounce-buffered. (More on this below.)

I think this is definitely solvable; its solution probably depends on
the mechanics of a file-based userfaultfd, though.

> And even if we generalize (2) to all memfds, that's still not covering
> all ways of backing guest memory.

I think this is a fair point; we can't use file-based userfaultfd for
anon-backed memslots. I don't think it matters that much though:

KVM demand paging + userfaultfd for anon-backed memslots is a little
cumbersome; we're basically stuck with the single mapping. If the VMM
needs to use userfaultfd, there's no reason to switch to KVM demand
paging, because we'll still need to UFFDIO_COPY (or UFFDIO_UNREGISTER)
no matter what.

So KVM demand paging is only helpful for VMMs that use anon-backed
memslots if they've already annotated everywhere where something
non-KVM may access guest memory (and therefore don't need userfaultfd
except to catch KVM's accesses). So userfaultfd will be the easiest
post-copy system to use for a VMM that has used anonymous memory for
the memslots even in a world where KVM demand paging exists.

This is all just my two cents. I'm not sure what the best solution is
yet, but the fact that KVM demand paging has many fewer unknowns than
file-based userfaultfd makes me want to prefer it. And it's
unfortunate that a file-based userfaultfd solution wouldn't help us at
all for VMs that can have their memory swapped out.

- James

[1]: https://lore.kernel.org/linux-mm/20210225002658.2021807-1-axelrasmusse=
n@google.com/

