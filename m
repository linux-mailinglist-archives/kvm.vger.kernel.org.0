Return-Path: <kvm+bounces-33666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3A39EFDEE
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 22:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C06E1167751
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71541C8776;
	Thu, 12 Dec 2024 21:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="sI9WQo0h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V2xBxaHc"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77DA189BAF;
	Thu, 12 Dec 2024 21:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037743; cv=none; b=WNR+VT8svyAaRTrxzdJVjYU/VkypG7tMU2+08Tz0Xqr8NjHZLLFzW24kEmd6PmrYGZlxxvfElGKS8OywBg4T8WlvZaaSq8l9C+qGd6RBsxViHwh+sOW/bIp5aBN9ucxPXUQZztnbIphvaLMxrAnodwfh5tZ/tN9XbseYa2OWf1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037743; c=relaxed/simple;
	bh=tq8SabrSNNl10xixFA1YpdWN/BgyhTYrgnAWPnPpstc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=icyYsr+Q7rRrvS45MVacd4yUptEoX6nqk0DGsZfaBrKuXFsEq4LL7qd1nMUQ/wZQM6PR/0E6PY+RMtCoQYP/A5JZvoEltRJUJsD1jwi1eLxAHzP60OQ/UGHmKut5k3ntliOA42VM0CNhyeIyGuukNFQNCKVHC0noMna522vSNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=sI9WQo0h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=V2xBxaHc; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 8EE3F1383EA7;
	Thu, 12 Dec 2024 16:09:00 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Thu, 12 Dec 2024 16:09:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734037740;
	 x=1734124140; bh=9IqZ6rAQRKbEW2J4TH6/7CA/VSmhrZDWQ3WoMQkxePk=; b=
	sI9WQo0hT8RZfeLkFWtOxYBaixCFsKGWtj1oeld5wv+OdD59xfdJ/DXtsqqA5hQt
	iqOuvNi/VCCSpWXoYZS39BY5IDFhiWrgN7uGOEI80sW1mD86lUNNrJYsuinhpIUd
	yIhPLs4TywRs8rOz9rzJVi1JgzrdiimkQ65PkMgb0vc72c6LR+JnVMGUs4NEk77r
	sTzT5VObzwIahbjTu14Sn072AKr3QmyqW4t6gUI+fj8oxqiYAtMZnJGpw6KFvWj9
	/oN1Ya0/vGY1kQzpziYR1O6rbYPBKcOKtWSh2D/iBJcvpmOMOKrODid3HPvM9yZy
	4mjyZbZRdPqpqpSkulf93g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734037740; x=
	1734124140; bh=9IqZ6rAQRKbEW2J4TH6/7CA/VSmhrZDWQ3WoMQkxePk=; b=V
	2xBxaHcyH7nhSIq8a4Shpv1fzPD4TS4/o7IMn+qgKdxGHqV8eH8bVojf4NDKmYId
	wQ5mTyohsX3YXFFFXfGAVLTVSHsgcVGB32ZuEuPEcsvKgPnNjr/ytl8Rol4AdGUH
	z4RYUE/LTQ4TSRFibOFJaAUAU9Y1y3XSO4DmEg/vuNB3umXTPRa+lqY4thL/yeSX
	+gWisPsU3ubkDeY87y6wmDYrll/Y7H8BuqaYXv7BQKRu+NAHz633wh9LSFMjsRCc
	Sl9zQV4xpWiKN9OVoZ2hImjbuMrL8rLGDuVpu5KmhMLyFaTOGnXlPY4RfqWnGL3Q
	tyRAAaDN7xrgHEaKtYX0A==
X-ME-Sender: <xms:6lBbZyw5SFn4lKEQCjXQULlKKQ3fuezYL-a0vCHYGD3K-FVjpKNC4A>
    <xme:6lBbZ-T7owsIHjUc1TlBe8pyoFKFV3A4XgfmG_C3lywr1GwU4Q9tIxa9IUfSJ4uZZ
    5abI64AlwCYCLWcu3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeehgddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdeg
    jedvfeehtdeggeevheefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopehtshgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghp
    thhtohepghhrrghfsegrmhgriihonhdrtghomhdprhgtphhtthhopegrthhishhhphesrg
    htihhshhhprghtrhgrrdhorhhgpdhrtghpthhtoheprghnuhhpsegsrhgrihhnfhgruhhl
    thdrohhrghdprhgtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhroh
    huphdrvghupdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghp
    thhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopehmph
    gvsegvlhhlvghrmhgrnhdrihgurdgruh
X-ME-Proxy: <xmx:6lBbZ0VwsS4U5Dh3P7otMqmSIAVEsOO6G7LJsCShu6InWS5ECnRScA>
    <xmx:6lBbZ4g36ua-0NY8XWqhtFeQFSxll2Gb7OcvFB5JwEkVcXBPt7efZw>
    <xmx:6lBbZ0CZQR2tq0T2mN9rDgYjaqBp7grBCA0XYnDCiY-g_gO8TIGx1w>
    <xmx:6lBbZ5JchKyroSqzawYqmB-bFcM24AfcbmVsrLAOC-nqaNsZvK-LMA>
    <xmx:7FBbZ-xtl9XJ4zczjb9ueyrbQc4qE0emOqr48sDEu3vHDq2m0T8uPYzW>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 134EC2220072; Thu, 12 Dec 2024 16:08:58 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 12 Dec 2024 22:08:37 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Arnd Bergmann" <arnd@kernel.org>, kvm@vger.kernel.org
Cc: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Jiaxun Yang" <jiaxun.yang@flygoat.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
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
Message-Id: <1633f30e-d885-4f31-a14d-11881e16deb9@app.fastmail.com>
In-Reply-To: <3589ad69-13df-40f1-88c2-55d39790bbac@csgroup.eu>
References: <20241212125516.467123-1-arnd@kernel.org>
 <20241212125516.467123-3-arnd@kernel.org>
 <3589ad69-13df-40f1-88c2-55d39790bbac@csgroup.eu>
Subject: Re: [RFC 2/5] powerpc: kvm: drop 32-bit booke
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2024, at 19:35, Christophe Leroy wrote:
> Le 12/12/2024 =C3=A0 13:55, Arnd Bergmann a =C3=A9crit=C2=A0:
>> From: Arnd Bergmann <arnd@arndb.de>

>>=20
>> Support for 64-bit hosts remains unchanged, for both 32-bit and
>> 64-bit guests.
>>=20

>>   arch/powerpc/include/asm/kvm_book3s_32.h    |  36 --
>>   arch/powerpc/include/asm/kvm_booke.h        |   4 -
>>   arch/powerpc/include/asm/kvm_booke_hv_asm.h |   2 -
>>   arch/powerpc/kvm/Kconfig                    |  22 +-
>>   arch/powerpc/kvm/Makefile                   |  15 -
>>   arch/powerpc/kvm/book3s_32_mmu_host.c       | 396 --------------
>>   arch/powerpc/kvm/booke.c                    | 268 ----------
>>   arch/powerpc/kvm/booke.h                    |   8 -
>>   arch/powerpc/kvm/booke_emulate.c            |  44 --
>>   arch/powerpc/kvm/booke_interrupts.S         | 535 -----------------=
--
>>   arch/powerpc/kvm/bookehv_interrupts.S       | 102 ----
>>   arch/powerpc/kvm/e500.c                     | 553 -----------------=
---
>>   arch/powerpc/kvm/e500.h                     |  40 --
>>   arch/powerpc/kvm/e500_emulate.c             | 100 ----
>>   arch/powerpc/kvm/e500_mmu_host.c            |  54 --
>>   arch/powerpc/kvm/e500mc.c                   |   5 +-
>>   arch/powerpc/kvm/trace_booke.h              |  14 -
>>   17 files changed, 4 insertions(+), 2194 deletions(-)
>>   delete mode 100644 arch/powerpc/include/asm/kvm_book3s_32.h
>>   delete mode 100644 arch/powerpc/kvm/book3s_32_mmu_host.c
>>   delete mode 100644 arch/powerpc/kvm/booke_interrupts.S
>>   delete mode 100644 arch/powerpc/kvm/e500.c
>
> Left over ?
>
> arch/powerpc/kernel/head_booke.h:#include <asm/kvm_asm.h>
> arch/powerpc/kernel/head_booke.h:#include <asm/kvm_booke_hv_asm.h>
> arch/powerpc/kernel/head_booke.h:       b=20
> kvmppc_handler_\intno\()_\srr1

As far as I can tell, these are still needed for e5500/e6500,
but you know more about the platform than I do.

       Arnd

