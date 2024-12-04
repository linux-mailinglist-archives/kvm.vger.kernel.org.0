Return-Path: <kvm+bounces-33090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 392F89E4786
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 23:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66A84B35449
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADD8191499;
	Wed,  4 Dec 2024 20:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="jtZbbN3h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EYkNwwM0"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F19017335C;
	Wed,  4 Dec 2024 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733345565; cv=none; b=CR8mdx5oJNj3ggAkWeSBM03nvAgjIG0ma8jsy0pCAyjDfOSKAaro9zFPB8GE39NywDPFXKzLzUZyiDzQwJHzYccwO0J0TWKKMKW8/vmZO+qUKYP5Jb3mDgsEVeAOiM448Ly1Z8I51cRLpahLxJweweWr4OuPCqAdpYHbcBwuKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733345565; c=relaxed/simple;
	bh=paSPirvo2hOk24PuqUZvfkWTNvDtkMqM8JhfKacPhS0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=X7Z0OHiWN2JBJNQDQWBx3Yb8RnCsdRNQ1p3vYZnlJVhoOhMf3W60/1CIg+HGO+Fsk8rvjXpuxMo3Et9yFx5c11sDrpmavq9tdYPYTKMbmqHgrLPl/Ntrlds6SkwhgcikRNj2vSFU+OC2iYtH3kDKi+HJ9gg1g3PP3Q4rxHsBcz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=jtZbbN3h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EYkNwwM0; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 775DB1140151;
	Wed,  4 Dec 2024 15:52:42 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 15:52:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733345562;
	 x=1733431962; bh=IARXqKJwMmq8+o594ye4w7KUMzZo7+xJIp2pYHwAhu0=; b=
	jtZbbN3hDZFJCu+ykQ+vucyGEqK+JgVQ+uW1DbBKuaMFaeaGVSUUDf+lZsfYC1lu
	nrdd1Zosp7xkokwqieU5F+zaqxA5pZf1eUoOsvy5Nw0tX0EC/tP9gW1nl3O8XAlK
	8J3BYpVt6DtuJ+yat+o/oVFggiz35xVpKALD+NCtfLODU2TQuL3psEwPb+IAPUmj
	7Zdapy2a6PF9+4L0CBIm/9msfujXrlY+zM1SeK10YKIWbrxjfkNZ1PM+3Nh/GZWr
	9euE3vA7FSkmp137VIVMVllA61swXcAwrVCwhwQEHAiCVO2B8qzwYQ1O0ikkac1P
	zDQfDYe4O1g8wYHvcChNbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733345562; x=
	1733431962; bh=IARXqKJwMmq8+o594ye4w7KUMzZo7+xJIp2pYHwAhu0=; b=E
	YkNwwM0E7CEak+uP4n0DAY4kDFY8c5x/DMb2vLQZFJ+75/yHwiVOluJYL7ZabENa
	SrMi8N/Dq8KvL7OwWqn4ftxFlLa0EWIj83KIDekBnpxdZ6bt2WPVji7/tUSfBC85
	TI3eaoMlCV0wSg0sWJmiuWyjFNKJ7Mku7PsrzQohnXgDjN/pJOd6lnOin8DYRSBO
	qJyDITmbGVCY6Z4gnLu1gcL6bvFtg0avlJJVsSaY6ORLQMsfh+nurXZYs4QaqD09
	jMkPpmPvYjtSez1K6xkHy3PoFywVv0qbUzRlqdNU+RolibgjeCygvS88nqmlZgOF
	/ArI9BfkPm09MhhAuF1vg==
X-ME-Sender: <xms:GcFQZw_b1_3yQmnXEQPOwpfKv3s-J4eEUvmRRBRRI9LNb-8LVaTAKA>
    <xme:GcFQZ4vbgT9wLxlcZD8dxOpAZDmqiYsLSgLYnu5ng1zSOdn9e2W3X1uQDuC7tRhgL
    kiX8Oq5Dmw7MoNiHW0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddufeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdeg
    jedvfeehtdeggeevheefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopegrnhguhidrshhhvghvtghhvghnkhhosehgmhgrihhlrdgtohhmpdhrtghp
    thhtoheptghimhhinhgrghhhihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggrnh
    hjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggr
    ugdrohhrghdprhgtphhtthhopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:GcFQZ2C0DZvNq-j9kmCne1c41Mc2ccRZlNduYb5BVxtXndeq3u7oZw>
    <xmx:GcFQZwd5RyKGmu8ZBzXo9YXL0zuQJVOFc_JA8hWvdgErKe-CTLSSXQ>
    <xmx:GcFQZ1OW4q_104X1mv2eeA_npl7Rz9uGi__KrJXxXJqwv50DHDNi6A>
    <xmx:GcFQZ6kv84UGoYbIvjxqK6jwuxUMTyvLzbZkc_zgd6mKeX-ktqxDTg>
    <xmx:GsFQZ2sU2KMiqepgfuT_SpYptr3hdceedKoMjBoPgkGVXmcmnIMCPt8y>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3FFCA2220072; Wed,  4 Dec 2024 15:52:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 21:52:01 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andy Shevchenko" <andy.shevchenko@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <d84fc2e4-ca81-42b1-ae44-292d0b32c7ed@app.fastmail.com>
In-Reply-To: 
 <CAHp75VcQcDD3gbfc6UzH3wYgge6EqSBEyWWOQ_dTkz8Eo+XgFw@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-7-arnd@kernel.org>
 <CAHp75VcQcDD3gbfc6UzH3wYgge6EqSBEyWWOQ_dTkz8Eo+XgFw@mail.gmail.com>
Subject: Re: [PATCH 06/11] x86: drop SWIOTLB and PHYS_ADDR_T_64BIT for PAE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024, at 19:41, Andy Shevchenko wrote:
> On Wed, Dec 4, 2024 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@kernel.org=
> wrote:
>>
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> Since kernels with and without CONFIG_X86_PAE are now limited
>> to the low 4GB of physical address space, there is no need to
>> use either swiotlb or 64-bit phys_addr_t any more, so stop
>> selecting these and fix up the build warnings from that.
>
> ...
>
>>         mtrr_type_lookup(addr, addr + PMD_SIZE, &uniform);
>>         if (!uniform) {
>>                 pr_warn_once("%s: Cannot satisfy [mem %#010llx-%#010l=
lx] with a huge-page mapping due to MTRR override.\n",
>> -                            __func__, addr, addr + PMD_SIZE);
>> +                            __func__, (u64)addr, (u64)addr + PMD_SIZ=
E);
>
> Instead of castings I would rather:
> 1) have addr and size (? does above have off-by-one error?) or end;
> 2) use struct resource / range with the respective %p[Rr][a] specifier
> or use %pa.

Changed as below now. I'm still not sure whether the mtrr_type_lookup
end argument is meant to be inclusive or exclusive, so I've left
that alone, but the printed range should be correct now.

Thanks,

     Arnd

@@ -740,11 +740,12 @@ int pud_set_huge(pud_t *pud, phys_addr_t addr, pgp=
rot_t prot)
 int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 {
        u8 uniform;
+       struct resource res =3D DEFINE_RES_MEM(addr, PMD_SIZE);
=20
        mtrr_type_lookup(addr, addr + PMD_SIZE, &uniform);
        if (!uniform) {
-               pr_warn_once("%s: Cannot satisfy [mem %#010llx-%#010llx]=
 with a huge-page mapping due to MTRR override.\n",
-                            __func__, (u64)addr, (u64)addr + PMD_SIZE);
+               pr_warn_once("%s: Cannot satisfy %pR with a huge-page ma=
pping due to MTRR override.\n",
+                            __func__, &res);
                return 0;
        }
=20


