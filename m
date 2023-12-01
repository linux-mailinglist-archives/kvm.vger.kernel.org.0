Return-Path: <kvm+bounces-3176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D438380163C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 832AE1F210B4
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FD6619B0;
	Fri,  1 Dec 2023 22:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGKdWKyn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B786A12A
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 14:23:06 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-67a948922aaso7331576d6.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 14:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701469386; x=1702074186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1arD3VuS+5T2sJUVbac5aZMZf6BxOIcpbZbzyzfXpU=;
        b=bGKdWKynlNswHwA6DuVHo7iRiGEMsJYJGdzqRgTnpQ4GaiVt//GGdSIn462vkFBY5h
         9JzF2D2ubxEO4KrMi2i1FySlErLsqlqg/RqM3zYpMEb23i0haQ6EjcPIdUYUru5uRJ5N
         CLGTRvuKFEr5QjxEVkbXiANFVyxi3NYT7dwk7o+wE3UfxvjMXb8coTGcPm1iXHxl7uc4
         6dqJMH2CJZymOXvqt2CDcQ6pmyZOBj1BYPjMzfMRicd4O4PGX6+911ISw/3UDetYkD/S
         43J4XEpB1czURVwINx33IfHZeKyxHIhWPSseX8uDDqbewtpOgj8kiosY02y+ru6R0Ppu
         eNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701469386; x=1702074186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1arD3VuS+5T2sJUVbac5aZMZf6BxOIcpbZbzyzfXpU=;
        b=uzVdh3AjBUePKrrl4EN65FnnWymCdGOX0zyKn6QSACD+IlmCN5lG0w+VcWeMezm54T
         7EphBtyuawFSze1Js4zvVlXdHaJNcQt/pWq+18VdWunrdaaqYfGpmwqWWvSIIGnS3xw4
         dgjGZO2bipN083/G1wNebUCfV0lkMdyRSrkzCcFuRZIFL6oOoCE6leG07pSk8liDA2Pq
         guBT5lABwSFBk86LQkW7BZ7plMopaALj69ivjCnR+ZlBNL6hwxQqSRDkgNvYXKwY6WlC
         SmwnNQMTvdiTql7c8PDMOt02Auj4n41SmcUxKOFbganmWi8DPQxFxf//LVVHHAO/WsCk
         Gk/g==
X-Gm-Message-State: AOJu0Yxudc+qKJvRgyociGA9eQnoSTf6C5dc01aBpVeWsp2I+9spoc+g
	v3fGHfROhCblSnwGgSSnpDRXIt+y9RlZEGi2Tul1cw==
X-Google-Smtp-Source: AGHT+IGiQ0VKlSDri0k5jGVI71tA6NU1E77AVWcj1wlEsE3Y6N25anquP0fDpCv2mtc9IAicxcwIDZki/EPLS3GB4Hc=
X-Received: by 2002:a05:6214:4402:b0:67a:a4d8:ce49 with SMTP id
 oj2-20020a056214440200b0067aa4d8ce49mr282285qvb.21.1701469385692; Fri, 01 Dec
 2023 14:23:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
 <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com> <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
 <ZWpaoLpWNk_P_zum@google.com>
In-Reply-To: <ZWpaoLpWNk_P_zum@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 1 Dec 2023 14:22:29 -0800
Message-ID: <CAL715W+x5hv=qYogs0smVAjakeS=4dsuDpGrTE-ovze8QECtKg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Jacky Li <jackyli@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Liam Merwick <liam.merwick@oracle.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 2:13=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Dec 01, 2023, Mingwei Zhang wrote:
> > On Fri, Dec 1, 2023 at 1:30=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.=
com> wrote:
> > > For SNP + gmem, where the HVA ranges covered by the MMU notifiers are
> > > not acting on encrypted pages, we are ignoring MMU invalidation
> > > notifiers for SNP guests as part of the SNP host patches being posted
> > > upstream and instead relying on gmem own invalidation stuff to clean
> > > them up on a per-folio basis.
> > >
> > > Thanks,
> > > Ashish
> >
> > oh, I have no question about that. This series only applies to
> > SEV/SEV-ES type of VMs.
> >
> > For SNP + guest_memfd, I don't see the implementation details, but I
> > doubt you can ignore mmu_notifiers if the request does cover some
> > encrypted memory in error cases or corner cases. Does the SNP enforce
> > the usage of guest_memfd? How do we prevent exceptional cases? I am
> > sure you guys already figured out the answers, so I don't plan to dig
> > deeper until SNP host pages are accepted.
>
> KVM will not allow SNP guests to map VMA-based memory as encrypted/privat=
e, full
> stop.  Any invalidations initiated by mmu_notifiers will therefore apply =
only to
> shared memory.

Remind me. If I (as a SEV-SNP guest) flip the C-bit in my own x86 page
table and write to some of the pages, am I generating encrypted dirty
cache lines? I understand that the RMP table may say, hey it is
"shared" but that's ok since I just don't need to pvalidate them,
right?

>
> That approach doesn't work for SEV/SEV-ES because KVM can't prevent the g=
uest
> from accessing memory as encrypted, i.e. KVM needs the #NPF due to RMP vi=
olation
> to intercept attempts to convert a GFN from shared to private.

