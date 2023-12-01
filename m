Return-Path: <kvm+bounces-3178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0603D801651
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 367D01C20A7C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD5D619BC;
	Fri,  1 Dec 2023 22:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xov5jiO4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C3BD6C
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 14:30:14 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-db5416d0fccso1337178276.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 14:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701469813; x=1702074613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=osEZycnHPVtCx8e32yWkNMf3F/SDPrgjJcL17uIzMRw=;
        b=xov5jiO4ekkAR7MRCTd22ukSr4g1FY8wsVW8eaa8AaHyKzyEWnDmB0DCcE6iCdpmHr
         zxztBOjWZ1UZpwMOSa9wKn6uAVK8HJ0zqeUiW7LADNYtyGpqSf8cMro8bB7CbpsmRu62
         F0sQGrpi1UIUW0Z4Z6mbn8QWSIsg1SqDeNCBAgzf85oTJDXbT1ZiKIg2TLFRnxxVs4iT
         asoYHIe25zqghLvevr0UTRnuWOgymWvIDG0kLF1AWPWpfZtnkftwOPe0pddxoUNoOuKd
         GsunJ+mhI6S5UOUSzLB+olxKgaZ3qcSyzTEBn2nqsU54WO5i2M5Ej3G1NGULXp6LA0PA
         vi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701469813; x=1702074613;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=osEZycnHPVtCx8e32yWkNMf3F/SDPrgjJcL17uIzMRw=;
        b=qq8q4PjFN7aW4g9DF9NabLHfov4p3Xz+71eC+bxzEfF3XePBRtLQf3sB67LCnHIl2x
         T2ZQJ1WdNXAsbVNfBq6beaZ5EuRlMJRkqwOUPWY/V51t/UnXrc022B5cvFzCFqAg4ouQ
         9cajpOKEWll20HEYt9VigKDCBKMlSdcqhPTqYZ8hZ6EFFUUkB1ex+ZJ00soTfG9Sq4Y9
         mp7H9fEpkUMT9TE90IfmZhBLeTT2TDpqOyaRpul7vP7kOBMJOss3zDZ1BBYmAzrN7XzC
         2iE+gGUhKVYZjC6pHUHcJ6qXiucPBElNcph0E9yeSG2yIAbkZpIuu/NNaLqkpj2b51nw
         UHuw==
X-Gm-Message-State: AOJu0YyDedJQOxvt7M+6YpDVT9Lj1vpA3M7ixwCARa8nkbRI6yszbqto
	BYV7I3c9V7tHlMrB28hSQddMdDzpyTw=
X-Google-Smtp-Source: AGHT+IEmZSWdpuJCKbFC/QJX/qKsJimwRUhx5+z2xe0ejVHoJ15qwqQ/hD78+jmdc3kkPxmnxKCahmf11CE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7141:0:b0:da0:c9a5:b529 with SMTP id
 m62-20020a257141000000b00da0c9a5b529mr737209ybc.12.1701469813483; Fri, 01 Dec
 2023 14:30:13 -0800 (PST)
Date: Fri, 1 Dec 2023 14:30:11 -0800
In-Reply-To: <CAL715W+x5hv=qYogs0smVAjakeS=4dsuDpGrTE-ovze8QECtKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
 <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com> <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
 <ZWpaoLpWNk_P_zum@google.com> <CAL715W+x5hv=qYogs0smVAjakeS=4dsuDpGrTE-ovze8QECtKg@mail.gmail.com>
Message-ID: <ZWpec_P17GL01yL0@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Jacky Li <jackyli@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Liam Merwick <liam.merwick@oracle.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 01, 2023, Mingwei Zhang wrote:
> On Fri, Dec 1, 2023 at 2:13=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Fri, Dec 01, 2023, Mingwei Zhang wrote:
> > > On Fri, Dec 1, 2023 at 1:30=E2=80=AFPM Kalra, Ashish <ashish.kalra@am=
d.com> wrote:
> > > > For SNP + gmem, where the HVA ranges covered by the MMU notifiers a=
re
> > > > not acting on encrypted pages, we are ignoring MMU invalidation
> > > > notifiers for SNP guests as part of the SNP host patches being post=
ed
> > > > upstream and instead relying on gmem own invalidation stuff to clea=
n
> > > > them up on a per-folio basis.
> > > >
> > > > Thanks,
> > > > Ashish
> > >
> > > oh, I have no question about that. This series only applies to
> > > SEV/SEV-ES type of VMs.
> > >
> > > For SNP + guest_memfd, I don't see the implementation details, but I
> > > doubt you can ignore mmu_notifiers if the request does cover some
> > > encrypted memory in error cases or corner cases. Does the SNP enforce
> > > the usage of guest_memfd? How do we prevent exceptional cases? I am
> > > sure you guys already figured out the answers, so I don't plan to dig
> > > deeper until SNP host pages are accepted.
> >
> > KVM will not allow SNP guests to map VMA-based memory as encrypted/priv=
ate, full
> > stop.  Any invalidations initiated by mmu_notifiers will therefore appl=
y only to
> > shared memory.
>=20
> Remind me. If I (as a SEV-SNP guest) flip the C-bit in my own x86 page
> table and write to some of the pages, am I generating encrypted dirty
> cache lines?

No.  See Table 15-39. "RMP Memory Access Checks" in the APM (my attempts to=
 copy
it to plain test failed miserably). =20

For accesses with effective C-bit =3D=3D 0, the page must be Hypervisor-Own=
ed.  For
effective C-bit =3D=3D 1, the page must be fully assigned to the guest.  Vi=
olation
of those rules generates #VMEXIT.

A missing Validated attribute causes a #VC, but that case has lower priorit=
y than
the about checks.

