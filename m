Return-Path: <kvm+bounces-8511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986458505B1
	for <lists+kvm@lfdr.de>; Sat, 10 Feb 2024 18:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EDE12818D8
	for <lists+kvm@lfdr.de>; Sat, 10 Feb 2024 17:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C415D478;
	Sat, 10 Feb 2024 17:22:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6743C5CDCC
	for <kvm@vger.kernel.org>; Sat, 10 Feb 2024 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707585734; cv=none; b=A3O3a0zhn2kuwQs35/S4L0i9zO7/G+3C05uxtvRVs5bnTBgwFaqcdE0IkLVAA4RGTe/gNamDwrwpBJQu38sa/xzbEe7HUFElrT6BLcGiuK80ekqEhYuw7qEx9ZXEd614/A5PSvW8oEiCH4qhuQWP3ZUaCWfYat3csh/XaZqKTLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707585734; c=relaxed/simple;
	bh=rbqMNhAMKFifaFYV+ZaFMyKtvq2I6Yd+9RUVEQM8R/E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=fQL1uMnXTnZbKaNsI9YJrIDS9cPwKVqz3DyujTN8qf4nqFUtoyoVMbGTkf0T3s5gb+dHgtgptifewLU6UrJzUmBbVVn2uS+VOycNrQlBhIc4E8tR05yJVca+7GSQcjn91BOfNDBNYZTdqiJC8J/5+qEWJztLaqIQrZkx5t9avoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-232-dhyRpcqeMt6KzxuBy0ecIw-1; Sat, 10 Feb 2024 17:22:06 +0000
X-MC-Unique: dhyRpcqeMt6KzxuBy0ecIw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 10 Feb
 2024 17:21:45 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 10 Feb 2024 17:21:45 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Sean Christopherson' <seanjc@google.com>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Nick Desaulniers <ndesaulniers@google.com>, Uros Bizjak
	<ubizjak@gmail.com>, Jakub Jelinek <jakub@redhat.com>, "Andrew Pinski (QUIC)"
	<quic_apinski@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
	"Peter Zijlstra" <peterz@infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: RE: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
Thread-Topic: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on
 gcc-11 (and earlier)
Thread-Index: AQHaW6GAqckjYnd4VEGhBeXgBOKGT7ED0v0Q
Date: Sat, 10 Feb 2024 17:21:45 +0000
Message-ID: <9ba89b70e48143a69f76f6e0f276f149@AcuMS.aculab.com>
References: <20240208220604.140859-1-seanjc@google.com>
 <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com>
 <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <ZcadTKwaSvvywNA9@google.com>
In-Reply-To: <ZcadTKwaSvvywNA9@google.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Sean Christopherson
> Sent: 09 February 2024 21:47
>=20
> On Fri, Feb 09, 2024, Linus Torvalds wrote:
> > Sean? Does this work for the case you noticed?
>=20
> Yep.  You can quite literally see the effect of the asm("").  A "good" se=
quence
> directly propagates the result from the VMREAD's destination register to =
its
> final destination
>=20
>   <+1756>:  mov    $0x280e,%r13d
>   <+1762>:  vmread %r13,%r13
>   <+1766>:  jbe    0x209fa <sync_vmcs02_to_vmcs12+1834>
>   <+1768>:  mov    %r13,0xe8(%rbx)
>=20
> whereas the "bad" sequence bounces through a different register.
>=20
>   <+1780>:  mov    $0x2810,%eax
>   <+1785>:  vmread %rax,%rax
>   <+1788>:  jbe    0x209e4 <sync_vmcs02_to_vmcs12+1812>
>   <+1790>:  mov    %rax,%r12
>   <+1793>:  mov    %r12,0xf0(%rbx)
...

Annoying, but I doubt it is measurable in this case.
Firstly it could easily be a 'free' register rename.
Secondly isn't vmread horribly slow anyway, so an extra
clock or two won't matter?

The double register move that OPTIMER_HIDE_VAR() often
generates is another matter entirely :-)
In the old days the peephole optimiser would (should?)
have removed most of these.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


