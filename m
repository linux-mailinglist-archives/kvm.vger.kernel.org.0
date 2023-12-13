Return-Path: <kvm+bounces-4410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 453B8812399
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 00:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B59D61F21A2D
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11D079E28;
	Wed, 13 Dec 2023 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/6iq4hd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC54CC9
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 15:56:31 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5e2fc8fe1a8so590957b3.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 15:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702511791; x=1703116591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UxO4lwP1Y614pYP6ZHT+U53NlXgl8rz0sajx/aIIUBo=;
        b=n/6iq4hdeY0NUcjf+rU2vxu/hbxPQEwPdMuv5fe1m2M/1AIqqTyOJb8jIZ2isBMKhH
         Zxn1J7+IgX/rx0FUVBfu92Rq59km+IIVm+tlw1sKYJ8uqF18t8RUxIb+XQ6lNFeBqFEu
         5T7AC13pb1a9Hkqc6MuuKsunBAWcdhLoC6eEcZ7QMkSr4huW5y4Vvu7lOrA3fBYbFwrD
         bYElGiuFVWvZSxZ+1y8Pm+cUVZW9zmCQ1Xk9nhkTNlr5+Qh+eWwFfPjK66utuJUy7C3E
         pscjJ2hH4aawF6azeH6eBKbcM+y3zl/GCnbntJOv6RvpBd88QWii3BCR3Z3yta68S4c/
         QBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702511791; x=1703116591;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UxO4lwP1Y614pYP6ZHT+U53NlXgl8rz0sajx/aIIUBo=;
        b=V9sucptMRMLcyQ9g3EJXhlqqy4jGELpE4AUO1z07dA3QPS7lWvAH4sasoP7Vz8L26Z
         7u5S7a5o/1E4mvQrY+fdCkIrmC3p6DajJCcaIq38nAYxT8z3S1xKFVJUOCzzy1gQJnmZ
         lAj/fIgPlyWs+05IRg6CS1CxIjMJj5MynI9p4GF2pDsOYOAUwOGm9ebE1qwPonreOT5j
         MESWFlpMjmh8xBbmh/wHdjknEwPz8dnReNeUy+/fwsXZkAshRE2lni7HRbRdCH8ZSwmb
         zutM4wqt+tV657G31mZFpRjgrp6pQWAl+BpM79sE1FRWDXFrgZryEUHQqsrEkzeUDDwf
         k7IA==
X-Gm-Message-State: AOJu0YxfPDUlaA8fltWVIZhrWzSD+M+643EhDNPaik9cIi4ovAX+cYxT
	0lWxv1pRs/Z9pefFz9P+aUpvo//h6Q8=
X-Google-Smtp-Source: AGHT+IEdEJxURty77JppqMbnEcTtdqehWo1GpHD5Zc7eekAL54I1TN5IQJjkH6fjT6U+/8piBXb3dgq1kJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:14d:b0:db5:3aaf:5207 with SMTP id
 p13-20020a056902014d00b00db53aaf5207mr151250ybh.3.1702511791190; Wed, 13 Dec
 2023 15:56:31 -0800 (PST)
Date: Wed, 13 Dec 2023 15:56:29 -0800
In-Reply-To: <06076290-4efb-5d71-74eb-396d325447e0@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
 <20231130111804.2227570-2-zhaotianrui@loongson.cn> <e40d3884-bf39-8286-627f-e0ce7dacfcbe@loongson.cn>
 <ZXiV1rMrXY0hNgvZ@google.com> <023b6f8f-301b-a6d0-448b-09a602ba1141@loongson.cn>
 <06076290-4efb-5d71-74eb-396d325447e0@loongson.cn>
Message-ID: <ZXpErTHBn6HeQUOp@google.com>
Subject: Re: [PATCH v5 1/4] KVM: selftests: Add KVM selftests header files for LoongArch
From: Sean Christopherson <seanjc@google.com>
To: maobibo <maobibo@loongson.cn>
Cc: zhaotianrui <zhaotianrui@loongson.cn>, Shuah Khan <shuah@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, Peter Xu <peterx@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, huangpei@loongson.cn
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023, maobibo wrote:
>=20
> On 2023/12/13 =E4=B8=8B=E5=8D=883:15, zhaotianrui wrote:
> >=20
> > =E5=9C=A8 2023/12/13 =E4=B8=8A=E5=8D=881:18, Sean Christopherson =E5=86=
=99=E9=81=93:
> > > On Tue, Dec 12, 2023, zhaotianrui wrote:
> > > > Hi, Sean:
> > > >=20
> > > > I want to change the definition of=C2=A0 DEFAULT_GUEST_TEST_MEM in =
the common
> > > > file "memstress.h", like this:
> > > >=20
> > > > =C2=A0 /* Default guest test virtual memory offset */
> > > > +#ifndef DEFAULT_GUEST_TEST_MEM
> > > > =C2=A0 #define DEFAULT_GUEST_TEST_MEM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0xc0000000
> > > > +#endif
> > > >=20
> > > > As this address should be re-defined in LoongArch headers.
> > >=20
> > > Why?=C2=A0 E.g. is 0xc0000000 unconditionally reserved, not guarantee=
d to
> > > be valid,
> > > something else?
> > >=20
> > > > So, do you have any suggesstion?
> > >=20
> > > Hmm, I think ideally kvm_util_base.h would define a range of memory t=
hat
> > > can be used by tests for arbitrary data.=C2=A0 Multiple tests use 0xc=
0000000,
> > > which is not entirely arbitrary, i.e. it doesn't _need_ to be 0xc0000=
000,
> > > but 0xc0000000 is convenient because it's 32-bit addressable and does=
n't
> > > overlap reserved areas in other architectures.
> In general text entry address of user application on x86/arm64 Linux
> is 0x200000, however on LoongArch system text entry address is strange, i=
ts
> value 0x120000000.
>=20
> When DEFAULT_GUEST_TEST_MEM is defined as 0xc0000000, there is limitation
> for guest memory size, it cannot exceed 0x120000000 - 0xc000000 =3D 1.5G
> bytes, else there will be conflict. However there is no such issue on
> x86/arm64, since 0xc0000000 is above text entry address 0x200000.

Ugh, I spent a good 30 minutes trying to figure out how any of this works o=
n x86
before I realized DEFAULT_GUEST_TEST_MEM is used for the guest _virtual_ ad=
dress
space.

I was thinking we were talking about guest _physical_ address, hence my com=
ments
about it being 32-bit addressable and not overlappin reserved areas.  E.g. =
on x86,
anything remotely resembling a real system has regular memory, a.k.a. DRAM,=
 split
between low memory (below the 32-bit boundary, i.e. below 4GiB) and high me=
mory
(from 4GiB to the max legal physical address).  Addresses above "top of low=
er
usable DRAM" (TOLUD) are reserved (again, in a "real" system) for things li=
ke
PCI, local APIC, I/O APIC, and the _architecturally_ defined RESET vector.

I couldn't figure out how x86 worked, because KVM creates an KVM-internal m=
emslot
at address 0xfee00000.  And then I realized the test creates memslots at co=
mpletely
different GPAs, and DEFAULT_GUEST_TEST_MEM is used only as super arbitrary
guest virtual address.

*sigh*

Anyways...

> The LoongArch link scripts actually is strange, it brings out some
> compatible issues such dpdk/kvm selftest when user applications
> want fixed virtual address space.

Can you elaborate on compatiblity issues?  I don't see the connection betwe=
en
DPDK and KVM selftests.

> So here DEFAULT_GUEST_TEST_MEM is defined as 0x130000000 separately, mayb=
e
> 0x140000000 is better since it is 1G super-page aligned for 4K page size.

I would strongly prefer we carve out a virtual address range that *all* tes=
ts
can safely use for test-specific code and data.  E.g. if/when we add usersp=
ace
support to selftests, I like the idea of having dedicated address spaces fo=
r
kernel vs. user[*].

Maybe we can march in that generally direction and define test's virtual ad=
dress
range to be in kernel space, i.e. the high half.  I assume/hope that would =
play
nice with all architectures' entry points?

[*] https://lore.kernel.org/all/20231102155111.28821-1-guang.zeng@intel.com

