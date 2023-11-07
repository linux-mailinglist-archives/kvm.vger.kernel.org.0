Return-Path: <kvm+bounces-1066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 786147E4988
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19FA5B20FD5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC57236B15;
	Tue,  7 Nov 2023 20:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0EP8BSjR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1755436AED
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:04:52 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C336E7
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:04:52 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4083ac51d8aso46294435e9.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699387490; x=1699992290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RW9IhHaBIvQOgwf4W1AtJa+oIMrtwReenj+NnKK52Cw=;
        b=0EP8BSjRVG0ikfjTRCqMSUmiXy8yE489kZ8+G0HwFhcSDo6QRxV5zqH9ZfIW6KZWwn
         EXdv9WAE0NK0kBzsQtaN6G473UnUFgPhil+ln4GVMFbxvzQ4HRXpZqUQa8+i1xC62kU2
         p2HQh/adX/iCJCNGPU9ab+XW1byeO/npKBrwrQCfm4IgIOe4Vs3hTHEImtbgBE5hGumk
         XsaS0E/CW7YRUCHYRT2OoqudgdNPPi5dGcitXezR5iBOXB9L1XiiVw+hifnbIhqzPvLt
         FATvZdNdx2wMsZJvokujBpLni7KuKrn0ZG/fqdexox/+KHaaKyj5SeUj2MnMpFFr9WSS
         B5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699387490; x=1699992290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RW9IhHaBIvQOgwf4W1AtJa+oIMrtwReenj+NnKK52Cw=;
        b=d23RiYAnO5fAr8V84eEUz0UECcH33+HqBwWiXk0DtzZjOlygn/yBbOZZ4dp+dyCD7K
         tmxe8jxaIj0PCsXitc7KRjNLveFAONAP9wq/YagvJz++DeBNYGOe+M6SK5CDG2z8muUn
         Jyc3oxs7Ig6KrOFiaPWPRozk5+OC4pP97SieZ4laUyL682ffRfgb73PrIQWK7OgL9Loq
         OFSWR7z49UwUqM3ESgglfY8UjezCMiFDm74RU7BslilwUyD7EBEWVG/F390HrpvGQM2f
         wv7Ru8yZc6XRfWlL5NkJralCYKXc5MUiZx+GbtcvltxRxy81CI9FpFVExMIEDmyQcNvJ
         uu0A==
X-Gm-Message-State: AOJu0Yx86CLFsHpyd2X5hybRjMJpp1Q/aaib5B1Cl8dSjKpcXbzBmtlK
	DABSTNxz2FDnJk+ni2HYa113ANRGN5s3mICnBTW2Qg==
X-Google-Smtp-Source: AGHT+IEIGVbTRObx1tr0gG+0IuLYj3+1JOu+AU0k0JmLnlgUHqVUDDUFk2EYebyRDI74KsY58WnYRJXVxEJu+xzwFZQ=
X-Received: by 2002:a05:6000:1c9:b0:32d:8185:9526 with SMTP id
 t9-20020a05600001c900b0032d81859526mr24013690wrx.55.1699387490353; Tue, 07
 Nov 2023 12:04:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
In-Reply-To: <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 7 Nov 2023 12:04:21 -0800
Message-ID: <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, kvm list <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 8:25=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
> On 11/6/23 21:23, Peter Xu wrote:
> > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> >>
> >> So why merge a KVM-specific alternative to UserfaultFD?
> >>
> >> Taking a step back, let's look at what UserfaultFD is actually
> >> providing for KVM VMs:
> >>
> >>    1. Coordination of userspace accesses to guest memory.
> >>    2. Coordination of KVM+guest accesses to guest memory.
> >>
> >> VMMs already need to
> >> manually intercept userspace _writes_ to guest memory to implement
> >> dirty tracking efficiently. It's a small step beyond that to intercept
> >> both reads and writes for post-copy. And VMMs are increasingly
> >> multi-process. UserfaultFD provides coordination within a process but
> >> VMMs already need to deal with coordinating across processes already.
> >> i.e. UserfaultFD is only solving part of the problem for (1.).
>
> This is partly true but it is missing non-vCPU kernel accesses, and it's
> what worries me the most if you propose this as a generic mechanism.

Non-vCPU accesses in KVM could still be handled with my proposal. But
I agree that non-KVM kernel accesses are a gap.

>  My
> gut feeling even without reading everything was (and it was confirmed
> after): I am open to merging some specific features that close holes in
> the userfaultfd API, but in general I like the unification between
> guest, userspace *and kernel* accesses that userfaultfd brings. The fact
> that it includes VGIC on Arm is a cherry on top. :)

Can you explain how VGIC interacts with UFFD? I'd like to understand
if/how that could work with a KVM-specific solution.

>
> For things other than guest_memfd, I want to ask Peter & co. if there
> could be a variant of userfaultfd that is better integrated with memfd,
> and solve the multi-process VMM issue.  For example, maybe a
> userfaultfd-like mechanism for memfd could handle missing faults from
> _any_ VMA for the memfd.
>
> However, guest_memfd could be a good usecase for the mechanism that you
> suggest.  Currently guest_memfd cannot be mapped in userspace pages.  As
> such it cannot be used with userfaultfd.  Furthermore, because it is
> only mapped by hypervisor page tables, or written via hypervisor APIs,
> guest_memfd can easily track presence at 4KB granularity even if backed
> by huge pages.  That could be a point in favor of a KVM-specific solution=
.
>
> Also, even if we envision mmap() support as one of the future extensions
> of guest_memfd, that does not mean you can use it together with
> userfaultfd.  For example, if we had restrictedmem-backed guest_memfd,
> or non-struct-page-backed guest_memfd, mmap() would be creating a
> VM_PFNMAP area.
>
> Once you have the implementation done for guest_memfd, it is interesting
> to see how easily it extends to other, userspace-mappable kinds of
> memory.  But I still dislike the fact that you need some kind of extra
> protocol in userspace, for multi-process VMMs.  This is the kind of
> thing that the kernel is supposed to facilitate.  I'd like it to do
> _more_ of that (see above memfd pseudo-suggestion), not less.

I was also thinking guest_memfd could be an avenue to solve the
multi-process issue. But a little different than the way you described
(because I still want to find an upstream solution for HugeTLB-backed
VMs, if possible).

What I was thinking was that my proposal could be extended to
guest_memfd VMAs. The way my proposal works is that all KVM and guest
accesses would be guaranteed to go through the VM's present bitmaps,
but accesses through VMAs are not. But with guest_memfd, once we add
mmap() support, we have access to the struct kvm at the time that
mmap() is called and when handling page faults on the guest_memfd VMA.
So it'd be possible for guest_memfd to consult the present bitmap,
notify userspace on non-present pages, and wait for pages to become
present when handling faults. This means we could funnel all accesses
through VMAs (multi-process and non-KVM kernel accesses) through a
single notification mechanism. i.e. It solves the multi-process issue
and unifies guest, kernel, and userspace accesses. BUT, only for
guest_memfd.

So in the short term we could provide a partial solution for
HugeTLB-backed VMs (at least unblocking Google's use-case) and in the
long-term there's line of sight of a unified solution.

