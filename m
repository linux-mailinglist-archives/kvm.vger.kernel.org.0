Return-Path: <kvm+bounces-342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B067DE835
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10C76281684
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9AE15E85;
	Wed,  1 Nov 2023 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Otw23ont"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B4D101EF
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:42:37 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B74120
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:42:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc1397321fso2143525ad.3
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698878556; x=1699483356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umjDrFbVsgqJ4z1yzhq3O2IkRl0O4dYLZdb427Y8d2o=;
        b=Otw23ontKPlWJvVfV0u4909BzFaNQ+uzAcMSKu4YNKK3ryuz1iUiRW5u4UgxkiPpmh
         +T5qJrewqZeriReg9b3hnhrYoTN408nGYGuRAXnzVE0pIOtjStecQJkoWZCQHWWYLZjY
         ys84zSdW1Yyp4Rrlh9EIiGAcgShaOJyHMMY3NM2OUiZWH3n653EryKyANXa8C9BIFdUn
         iSdP4EOYkyTWmFh3deKhT1mADN9njOwaE7ZNiPiZ8qpz3UK7/lv6Kkh1hwjY3StrEriy
         8vpfU/zMxzv1BV8EQiy433nK/7JsW6yL+r/kN+iEtt373fkPDgdS9hE9q1YsebQhHuPM
         xUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698878556; x=1699483356;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=umjDrFbVsgqJ4z1yzhq3O2IkRl0O4dYLZdb427Y8d2o=;
        b=ECuNcvFm0tBq7SytmxH2Joo3GajbagFUe+WeEOcc8Unh6txnMvGqSWJ2Fe+mL7NgR2
         t+tEdP77srTD22jlBWeu2OUlXwz+khXQrWoKo6Y59fqUQg4G+lxqUGYWg/lAgpjKuF8T
         rD7YB155aD919hT633C9pGOn6cMiGHciJmBHuCk+vgqoa+Sra01ND2fMRpegNdgdOdr1
         TPArk2e70TWpnRa2xq9WAp+gMHyYmS8ThR47SFBsv4oqYYGnFd3xlFbr0CJDCXtNsCI9
         u/t4gsqvtQ9/+j0AySRcpzbHD4pljud+KLg+w6pe0ONCyll13z9tVkv8bElY+u6fmjZ+
         IA8Q==
X-Gm-Message-State: AOJu0Yw6r/MBJDcyTLH6DVYCop9O8uMvtHaxG93yYP2RV8riAQ1v7DRi
	cLXnjHzvO509fIY6tFCa7rN2OXv8Ugg=
X-Google-Smtp-Source: AGHT+IHZiZiBBwgOEtn7XwGvRKxTq1DihI9O371Fd4mUOTueTSxdTjs+pzFnYEuqiPedMO22M49VARVvyww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:44b:b0:1cc:4136:2b4b with SMTP id
 iw11-20020a170903044b00b001cc41362b4bmr184833plb.4.1698878556010; Wed, 01 Nov
 2023 15:42:36 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:42:34 -0700
In-Reply-To: <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <ZULLNdp6XKD6Twuc@google.com> <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
Message-ID: <ZULUWucAdR3oWR1y@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 01, 2023, Anish Moorthy wrote:
> On Wed, Nov 1, 2023 at 3:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Nov 01, 2023, Anish Moorthy wrote:
> > > On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >
> > > > Eh, the shortlog basically says "do work" with a lot of fancy words=
.  It really
> > > > just boils down to:
> > > >
> > > >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_O=
N_MISSING
> > >
> > > Proposed commit message for v6:
> > >
> > > > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in =
__gfn_to_pfn_memslot()
> > > >
> > > > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > > > faulting in pages for which mappings are absent. However, some call=
ers of
> > > > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt=
 out
> > > > of this behavior: allow doing so via the new can_exit_on_missing
> > > > parameter.
> > >
> > > Although separately, I don't think the parameter should be named
> > > can_exit_on_missing (or, as you suggested, can_do_userfault)-
> > > __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> > > setting up KVM exits, after all.
> >
> > Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, =
I don't
> > see how "I can't handle exits to userspace" is any different.
>=20
> Well the thing is that __gfn_to_pfn_memslot() is orthogonal to KVM
> exits. Its callers are just using it to try resolving a pfn, and what
> they do with the results is up to them.

But "how" the pfn is resolved is the business of the caller and of __gfn_to=
_pfn_memslot().
This already exits in the form of @async and @atomic, which respectively sa=
y
"don't wait on I/O" and "can't sleep, period".  The @async name is confusin=
g,
but David Steven's series is planning on replacing that with the much more =
literal
FOLL_NOWAIT (IIRC).

> Put more concretely, __gfn_to_pfn_memslot() has many callers of which
> only two (the stage-2 fault handlers) actually use it to set up a KVM
> exit- how does a parameter named "can_exit_on_missing" make sense to
> its callers in general?=20

It's a flag that says "I can't exit right now, please ignore exit_on_missin=
g".

> If it were __gfn_to_pfn_memslot() itself that was populating the run stru=
ct
> in response to absent mappings then I would agree that the name was
> appropriate- but that's not what's going on here.
>=20
> (side note, I'll assume that aside from the current naming discussion
> the commit message I proposed is fine)

