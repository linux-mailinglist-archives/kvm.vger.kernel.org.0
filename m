Return-Path: <kvm+bounces-1360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9047E70FB
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 18:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8919A2811D3
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDCB031A8B;
	Thu,  9 Nov 2023 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XdFU0ZP9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E5230340
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 17:58:51 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1613AA4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 09:58:51 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9caf486775so1371327276.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 09:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699552731; x=1700157531; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RFVfGsLBmL5i6JcHP880azf+XYiKofEmmYgiIz7F3i0=;
        b=XdFU0ZP9fW52a8fkOE9MEm4ZU2M3uRIn3eT/5XsKrJ3oHYfY4DUNuZP+cZ7QOOyWzo
         MHtcpAM+vQvxKIJaP32EPe0vT4hXKCD644EICaWB6prAq7OjP+zwfO/EioX93OQ31hvt
         ADLqsVlepwNSTPpmNgpymXAECvetleN6Hl7lUv/2bHtL/sH3nuwxdV9V+QC9xg/U2Eko
         GoQKHtHd0pyqlkeUQyvtsh9EVA4n8ShsmOZa2ESSURP55yOWiXPD8bZWp5bZWEsVdKj9
         JJzOP8af5ta7/QtE1urqkQ05yS24QLaMQAfPmivZeu8wKRoZctquImK9OwI08GkFx3Or
         9fLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699552731; x=1700157531;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RFVfGsLBmL5i6JcHP880azf+XYiKofEmmYgiIz7F3i0=;
        b=wpnVAkWT8oJ9yDeRXF0w5v7NIazYHD23VqqksGtt0QTNVfv2+qerqnurK8BpcrZysE
         AXDT+lp7sX7Z54RTZzqnSJpEnsUaeIs3/R7SekR8uOGIe8HCH50Ud2M1qbmMG/66Y6bA
         nzLEFTAjIPQZzaMskuljbFkqh7lfHHqy+XStzqDvG7RWTUUF6B7d9ESFfJSgilWCGeAS
         3cDTw2Vi7uTVuGfUHY07I5f2WM1dNiLfGv+7m8QeOD22I1ad/CEymGBAdemVWYci1i7L
         ophJyPxSeMESjq0PTzgDfVlTvcAc0q8xygTlkwRHbk5uwUWEunQyUzMYeRGhjtVpDEo8
         7EdA==
X-Gm-Message-State: AOJu0Yytdi4esNHsO38UZKO5Vqi74KRd6aVf2zXLnlBP+PdkrLWXcaHj
	pbWbqDG7atDIEckmCT161p7es8Bw9m0=
X-Google-Smtp-Source: AGHT+IHPrDSCvQr2sT08Pv40EnytCJNqx6afjozV4RKAshShvug9gavwMxGSel9NyADxoZZ9c0Ms78tabu4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:f12:0:b0:da1:513d:8a3c with SMTP id
 x18-20020a5b0f12000000b00da1513d8a3cmr133689ybr.11.1699552730763; Thu, 09 Nov
 2023 09:58:50 -0800 (PST)
Date: Thu, 9 Nov 2023 09:58:49 -0800
In-Reply-To: <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n> <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
Message-ID: <ZU0d2fq5zah5jxf1@google.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 09, 2023, David Matlack wrote:
> On Tue, Nov 7, 2023 at 2:29=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote=
:
> > On Tue, Nov 07, 2023 at 05:25:06PM +0100, Paolo Bonzini wrote:
> > > On 11/6/23 21:23, Peter Xu wrote:
> > > > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > > >
> > >
> > > Once you have the implementation done for guest_memfd, it is interest=
ing to
> > > see how easily it extends to other, userspace-mappable kinds of memor=
y.  But
> > > I still dislike the fact that you need some kind of extra protocol in
> > > userspace, for multi-process VMMs.  This is the kind of thing that th=
e
> > > kernel is supposed to facilitate.  I'd like it to do _more_ of that (=
see
> > > above memfd pseudo-suggestion), not less.
> >
> > Is that our future plan to extend gmemfd to normal memories?
> >
> > I see that gmemfd manages folio on its own.  I think it'll make perfect
> > sense if it's for use in CoCo context, where the memory is so special t=
o be
> > generic anyway.
> >
> > However if to extend it to generic memories, I'm wondering how do we
> > support existing memory features of such memory which already exist wit=
h
> > KVM_SET_USER_MEMORY_REGION v1.  To name some:
> >
> >   - numa awareness

The plan is to add fbind() to mirror mbind().

> >   - swapping
> >   - cgroup

Accounting is already supported.  Fine-grained reclaim will likely never be
supported (see below re: swap).

> >   - punch hole (in a huge page, aka, thp split)

Already works.  What doesn't work is reconstituing a hugepage, but like swa=
p,
I think that's something KVM should deliberately not support.

> >   - cma allocations for huge pages / page migrations

I suspect the direction guest_memfd will take will be to support a dedicate=
d pool
of memory, a la hugetlbfs reservations.

> >   - ...
>=20
> Sean has stated that he doesn't want guest_memfd to support swap. So I
> don't think guest_memfd will one day replace all guest memory
> use-cases. That also means that my idea to extend my proposal to
> guest_memfd VMAs has limited value. VMs that do not use guest_memfd
> would not be able to use it.

Yep.  This is a hill I'm extremely willing to die on.  I feel very, very st=
rongly
that we should put a stake in the ground regarding swap and other tradition=
al memory
management stuff.  The intent of guest_memfd is that it's a vehicle for sup=
porting
use cases that don't fit into generic memory subsytems, e.g. CoCo VMs, and/=
or where
making guest memory inaccessible by default adds a lot of value at minimal =
cost.

guest_memfd isn't intended to be a wholesale replacement of VMA-based memor=
y.
IMO, use cases that want to dynamically manage guest memory should be firml=
y
out-of-scope for guest_memfd.

> Paolo, it sounds like overall my proposal has limited value outside of
> GCE's use-case. And even if it landed upstream, it would bifrucate KVM
> VM post-copy support. So I think it's probably not worth pursuing
> further. Do you think that's a fair assessment? Getting a clear NACK
> on pushing this proposal upstream would be a nice outcome here since
> it helps inform our next steps.
>=20
> That being said, we still don't have an upstream solution for 1G
> post-copy, which James pointed out is really the core issue. But there
> are other avenues we can explore in that direction such as cleaning up
> HugeTLB (very nebulous) or adding 1G+mmap()+userfaultfd support to
> guest_memfd. The latter seems promising.

mmap()+userfaultfd is the answer for userspace and vhost, but it is most de=
fintiely
not the answer for guest_memfd within KVM.  The main selling point of guest=
_memfd
is that it doesn't require mapping the memory into userspace, i.e. userfaul=
tfd
can't be the answer for KVM accesses unless we bastardize the entire concep=
t of
guest_memfd.

And as I've proposed internally, the other thing related to live migration =
that I
think KVM should support is the ability to performantly and non-destructive=
ly freeze
guest memory, e.g. to allowing blocking KVM accesses to guest memory during=
 blackout
without requiring userspace to destroy memslots to harden against memory co=
rruption
due to KVM writing guest memory after userspace has taken the final snapsho=
t of the
dirty bitmap.

For both cases, KVM will need choke points on all accesses to guest memory.=
  Once
the choke points exist and we have signed up to maintain them, the extra bu=
rden of
gracefully handling "missing" memory versus frozen memory should be relativ=
ely
small, e.g. it'll mainly be the notify-and-wait uAPI.

Don't get me wrong, I think Google's demand paging implementation should di=
e a slow,
horrible death.   But I don't think userfaultfd is the answer for guest_mem=
fd.

