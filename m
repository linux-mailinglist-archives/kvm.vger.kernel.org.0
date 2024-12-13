Return-Path: <kvm+bounces-33702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC009F05F4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2701883626
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931AA19E979;
	Fri, 13 Dec 2024 08:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="kwRlWruO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wf5Gfd1b"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF9F192D7B;
	Fri, 13 Dec 2024 08:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734077051; cv=none; b=QDbxB8mCeYSp/KLzxW5nWHShBXcRlxJo40msc0NwBuFaI6UCFvOD8VGK5pmz6wxbct4/wyGBdQ2ofzqDQ8V92eO3GSHM3krr8YIBUhnCbOHSdoOERKqco8bN9V9+LNtUtkqaqnYifDYCp0CewMHYpdM9AL+NnKhHarKpTRfKqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734077051; c=relaxed/simple;
	bh=SseRUNOOKUJAdxzVTz4HSQv3JlpkLlwSIWWX+XWKtgQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=bzuBsx8PH7eepgW1qCx9hHLMMJgpO4V0mDj5hkGUt7+c5pDn4IvvpOZEOitiD8SGETEU+pK1EJO06PYZ0BstuJpB3Q7Hz+LvMWhQvdfvYF0fwWId8NQ9XewNdh6uorH7NYIXptHgx72GvAmLbG1/roovg5jCZDGl8uPSOVp4hp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=kwRlWruO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wf5Gfd1b; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 54FCB25401E2;
	Fri, 13 Dec 2024 03:04:04 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Fri, 13 Dec 2024 03:04:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734077044;
	 x=1734163444; bh=xkdaBG8UMFyF010HWwrn18x+gfYMEYxilRcPMsaZiVs=; b=
	kwRlWruOQXnYuoGU4ct7wnbZzpq8GbzYC5uXTtj+ieZM03zuV+Tt9PLNpT0OkMP6
	K+i+RioQx0MTsgKt/M2b/PppfO3/x8ivdmXMgbKUtmfNssVe+GGwRCqCkPq5bfbN
	N8dyhtPQ4Y8dIw971ni0aAoroFXoZxvgetECTodVWa9EpbwIvPIt4iAHApW4roYn
	PLrV8oyDOOASxjzAJyxzXvs+w4ofKcTCDsZGygnEaPjBbVKKTcJ7ROn5U4zmudTy
	pHmGayBV63ZE/DwrQOOgYnfHnYBuEJEH5T2XxdxRUAamVnwYsphSP+hCQiLbMifs
	oeM1bdqzKH8E+n2zDWnHaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734077044; x=
	1734163444; bh=xkdaBG8UMFyF010HWwrn18x+gfYMEYxilRcPMsaZiVs=; b=w
	f5Gfd1bCGgDhcncBvskPNse389eQ0QEfGBCs/NoAeMsbZBsXO0YkbIDC96jSrJMp
	cNCa/5XjhA9LfhZLrr53T1E4loiHvDt1z6QQB8J1wFfiLQFQKw8FXuqapGsrT7H3
	3aygnrdo/gs3YOJRdiVQ//Rs2j4wszfdrvufgk8UlHWrhRdlWosh1d47qkqAAYmB
	khTX32HWGUwaBjac774RnINOTDWu5CQPe6Ug4YkIu7urQDpHwn157ajEAIblPN1d
	PXruLjz38Mj0+8MiAVWehfM8jxaCtTPZqVTvceHDBYe0vw7bdf7vvMez/f94RXZJ
	FGQnbO2l3OSOVvbmRJsgA==
X-ME-Sender: <xms:cepbZwHYOLdK2uLiclp-OM6t1Q7gEnVCC9TlLMzbw6ClQ1So0jUu5g>
    <xme:cepbZ5X6JlxRboE-OfGKmIOU19X6A6KLzaGL6IIsRwzSmlXK0mcMvG9MPVdsEZmsw
    ZN8TN8gQeTOoFz0KY8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeeigdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdeg
    jedvfeehtdeggeevheefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepfeeh
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopehtshgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghp
    thhtohepghhrrghfsegrmhgriihonhdrtghomhdprhgtphhtthhopegrthhishhhphesrg
    htihhshhhprghtrhgrrdhorhhgpdhrtghpthhtoheprghnuhhpsegsrhgrihhnfhgruhhl
    thdrohhrghdprhgtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhroh
    huphdrvghupdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghp
    thhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopehmph
    gvsegvlhhlvghrmhgrnhdrihgurdgruh
X-ME-Proxy: <xmx:cepbZ6LndnD8ZSZeGggeTF_B5V_DgMVWx-1ulNhV23ajSDoVV-Ti_w>
    <xmx:cepbZyGY9wBofw83hXJKg-3q6hMTZIhwUkue-0Cp7reEPrBTSbMuKQ>
    <xmx:cepbZ2UwyfQQq1czPmiqjUcFhf7znIqD5iwIE5qoLNE82ddwPCTk7Q>
    <xmx:cepbZ1P1Jq82_ZoB3xLrj4H6gt9wqcGRFechLH3v8hR7FqCjabg6Sw>
    <xmx:dOpbZw0XsZIrhDEJP9jq1aOwBLm0frAM5cG3_b5M1E0thNTIztJg5TAk>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6A3682220072; Fri, 13 Dec 2024 03:04:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Dec 2024 09:03:30 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>, "Arnd Bergmann" <arnd@kernel.org>
Cc: kvm@vger.kernel.org, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Jiaxun Yang" <jiaxun.yang@flygoat.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Naveen N Rao" <naveen@kernel.org>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Alexander Graf" <graf@amazon.com>, "Crystal Wood" <crwood@redhat.com>,
 "Anup Patel" <anup@brainfault.org>,
 "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Vitaly Kuznetsov" <vkuznets@redhat.com>,
 "David Woodhouse" <dwmw2@infradead.org>, "Paul Durrant" <paul@xen.org>,
 "Marc Zyngier" <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Message-Id: <6e971322-8b21-4d73-922c-a6032c6fe9bd@app.fastmail.com>
In-Reply-To: <35E5C2A3-94AC-446B-A0A1-84B043DBC890@Wilcox-Tech.com>
References: <20241212125516.467123-1-arnd@kernel.org>
 <35E5C2A3-94AC-446B-A0A1-84B043DBC890@Wilcox-Tech.com>
Subject: Re: [RFC 0/5] KVM: drop 32-bit host support on all architectures
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024, at 04:51, A. Wilcox wrote:
> On Dec 12, 2024, at 6:55=E2=80=AFAM, Arnd Bergmann <arnd@kernel.org> w=
rote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>=20
>> I submitted a patch to remove KVM support for x86-32 hosts earlier
>> this month, but there were still concerns that this might be useful f=
or
>> testing 32-bit host in general, as that remains supported on three ot=
her
>> architectures. I have gone through those three now and prepared simil=
ar
>> patches, as all of them seem to be equally obsolete.
>>=20
>> Support for 32-bit KVM host on Arm hardware was dropped back in 2020
>> because of lack of users, despite Cortex-A7/A15/A17 based SoCs being
>> much more widely deployed than the other virtualization capable 32-bit
>> CPUs (Intel Core Duo/Silverthorne, PowerPC e300/e500/e600, MIPS P5600)
>> combined.
>
>
> I do use 32-bit KVM on a Core Duo =E2=80=9CYonah=E2=80=9D and a Power =
Mac G4 (MDD), for
> purposes of bisecting kernel issues without having to reboot the host
> machine (when it can be duplicated in a KVM environment).
>
> I suppose it would still be possible to run the hosts on 6.12 LTS for
> some time with newer guests, but it would be unfortunate.

Would it be an option for you to just test those kernels on 64-bit
machines? I assume you prefer to do native builds on 32-bit hardware
because that fits your workflow, but once you get into debugging
in a virtual machine, the results should generally be the same when
building and running on a 64-bit host for both x86-32 and ppc32-classic,
right?

      Arnd

