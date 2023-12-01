Return-Path: <kvm+bounces-3175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 318E8801624
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6299D1C2104C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BF05ABB1;
	Fri,  1 Dec 2023 22:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n1T70R9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5DC10D
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 14:13:54 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d032ab478fso45386957b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 14:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701468834; x=1702073634; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skT9D2rGwh+yMNZUbJHv8h1YOHItOq/MHaYLCWWm+es=;
        b=n1T70R9xK3J0mcbskfdgNVCbHhHgehIjK23IVAEuJbkEuzeLfzLS+6bc8MKnxrCWzX
         r/BFqXhgQsLjPaO30y5gKiYnHBqrrIHCp49uX5fXuFhJ6AWSAHxBdUMzRDJR0cHvGaEk
         VuP2FIPsckohpicBoKv57pXVRQmM9uclyNd4kGKW9pDZ7kcKFTarfyfX7BTudyl7xGaj
         6QWO950H6O6NDR9U3KjzhrT2sc/M3egHaKuFA4ad2RvI59/87xyNFfhPF1CioTAOVG7A
         +CmvuOJjc+LmrfIMR3iV1eATOZNk6xuUC/oAaJYJsev5eUPSezxQDnC+oKupjKBFKMow
         RwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701468834; x=1702073634;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=skT9D2rGwh+yMNZUbJHv8h1YOHItOq/MHaYLCWWm+es=;
        b=QTbBND2pIhTJB4GuO2XDlIPpeNOKlrGptF9GH1WD2PKi+MuWVgbrxPtsBjUmm+u1Uq
         xXUSSxbukXJlsheWOftgj+C/zQiTnjuE2Hj3fKczH6H7SH78KixV7rLKhsdgWmzgRJaC
         fpYFaACRvdnt/vxLWF+aL0YM/YDMCi4c847YYZC5zK2nrPhSv3sTFFIV5G6EzRaNJw2p
         JbWsRNJUDF+m+1+abiagAtFg3XxXgjuPUKGpbG9Ty7CIgcHTcuO0+7sbISjB8DMOEfIE
         Q6dRUCZnF2Cq4CJLYVC8bc09CA6APoHVfdI716ck5gx+2wiV3Mdbq3bvdZZ5jEfMmyiV
         rS/A==
X-Gm-Message-State: AOJu0YxSdDvZEEQo94QSOAL6ArruIiQc0hcWplU4HxtqnJsb6yTOmBf9
	V0fqpro+wGWoA8wOEdDBIfSc8lW57aI=
X-Google-Smtp-Source: AGHT+IFDGGG6H8JayW9rTjJ6LB2f5sLV0bAeaBuvjmtWT0KE9q1XV2y0WG8YYCBz+FxZyxf+kWHUedYqs2Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3603:b0:5ca:e7e5:e8b9 with SMTP id
 ft3-20020a05690c360300b005cae7e5e8b9mr879460ywb.9.1701468834108; Fri, 01 Dec
 2023 14:13:54 -0800 (PST)
Date: Fri, 1 Dec 2023 14:13:52 -0800
In-Reply-To: <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
 <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com> <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
Message-ID: <ZWpaoLpWNk_P_zum@google.com>
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
> On Fri, Dec 1, 2023 at 1:30=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.co=
m> wrote:
> > For SNP + gmem, where the HVA ranges covered by the MMU notifiers are
> > not acting on encrypted pages, we are ignoring MMU invalidation
> > notifiers for SNP guests as part of the SNP host patches being posted
> > upstream and instead relying on gmem own invalidation stuff to clean
> > them up on a per-folio basis.
> >
> > Thanks,
> > Ashish
>=20
> oh, I have no question about that. This series only applies to
> SEV/SEV-ES type of VMs.
>=20
> For SNP + guest_memfd, I don't see the implementation details, but I
> doubt you can ignore mmu_notifiers if the request does cover some
> encrypted memory in error cases or corner cases. Does the SNP enforce
> the usage of guest_memfd? How do we prevent exceptional cases? I am
> sure you guys already figured out the answers, so I don't plan to dig
> deeper until SNP host pages are accepted.

KVM will not allow SNP guests to map VMA-based memory as encrypted/private,=
 full
stop.  Any invalidations initiated by mmu_notifiers will therefore apply on=
ly to
shared memory.

That approach doesn't work for SEV/SEV-ES because KVM can't prevent the gue=
st
from accessing memory as encrypted, i.e. KVM needs the #NPF due to RMP viol=
ation
to intercept attempts to convert a GFN from shared to private.

