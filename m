Return-Path: <kvm+bounces-33084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBEEC9E44F5
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9980A166FFD
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4AD1EF096;
	Wed,  4 Dec 2024 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="hwlDPSc0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="s0VFqvmF"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE618BBB4;
	Wed,  4 Dec 2024 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733341454; cv=none; b=j3CsKwo8dhCDUb9zW94Ft/Q0TsPdheGs8NTHpiKe9SixGdOk29hMWlFpGggmTDsf8/s/gTI0/DAXFn4gHMFtRF2ctX1Gp/MXpYgaEsEnMqNjZlxxb0bILDbGMOELA3MqN2igDunpkxPwmRKldosvquGc8L14ErZHTc30RJSelp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733341454; c=relaxed/simple;
	bh=9JZlTQUmVyWIc5Juw9KaWD5uEDIQ0ihP6yNvbkiRcrc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=NITQiv39jbBrfIBYGs4z2s4tKoVKg1JGeUVmMw3Wkq3Oc+RtmocOVL6oCrapMGeMg4oDFADUeBb7C2/Wce3wr6IC09mYsYKLbl+6SKOlztXPurgwDj1uEhEtv6nHa00nSaUA/w8ejdqVWEWdvkgIs7dAvdQPA5DriKWbjkjT4u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=hwlDPSc0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=s0VFqvmF; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D4C8A2540134;
	Wed,  4 Dec 2024 14:44:10 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 14:44:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733341450;
	 x=1733427850; bh=EEShQR326Q35qKfWScIGB4OH/vhPY1mnipsA5wuW348=; b=
	hwlDPSc0rvzNpZzrTYWC60TzGbdku3NKzOhXxi5qKbHrzNH1uGfnv56fgc21rdJL
	y5u2EM55QEPrZcWXqGh1/MCXKh5IWn7syUWl6F5wTxSq3p6DitP5YGI4GwZojONZ
	f//lPJu53VSpV+VkVA77aiGVXCoMXPcnLYqKcT1TiAnhSKGW2o9XTDVRIEv6iwjp
	i4SF6muIDU/xCsDLQKw89CO7jgTfgC+t1CoMmyFXUzCnUlTXt4sdwGNTHRHNz5gp
	wqqQcPbXKA6XkqQdMy9022jMpqkXUDEKzR0WwaWYyyN2sqvWjKmUdxN1pnTSKVS+
	bwHprqvsl3U4bqbx7sJuFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733341450; x=
	1733427850; bh=EEShQR326Q35qKfWScIGB4OH/vhPY1mnipsA5wuW348=; b=s
	0VFqvmFo9z0D1+k7pV4kWTIaDPIec9JqOlFhhRBMWx965EPN7yQTYcRjqvT7g0dB
	v4MBPz8qrAo15FndMI0Z5TBgzCZCoAXs2fHbqBcQtKZVkTHjKXlWQQ2jmxXDNg2q
	IufTOeXQQXFBcJ3HHMYUfn8nfTPI8n/7ICNDU8SneNybArJOmwkadZZfHOsN82qJ
	3rdDoxordPGLOn3emEtM2QkgGEDhcb8+sL5PpvblXy9OWGR1PYvQBErW9yA1QbkX
	hlORScw8AJkv2oDqC/kL9khp2aKfVKZW5k9OI/Jen+G5160YK/WVZQdZtrUUePBV
	yF4fKAKLlJWzjNseoCqtA==
X-ME-Sender: <xms:CbFQZ6S-STxiOch9IRji7jVLfiwi7yrDOQmtVC404LvFxkskODvWaQ>
    <xme:CbFQZ_yf0ytiW_PtxECETAskHeehuzX1nRquHfYHS36ZcTwfufy19KH3oIsKuZRFJ
    mDl5pXDhuutC-yX9h0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdeg
    jedvfeehtdeggeevheefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudeh
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopegtihhmihhnrghghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgv
    rghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgrug
    gvrggurdhorhhgpdhrtghpthhtoheprghnugihsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghp
    thhtohepthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:CbFQZ33eh8ZYfsPql2FP_KP8PxE7kchxDt2_9qO_eDw_HU7IbY8Rog>
    <xmx:CbFQZ2B13V_ZclRqtDBy2qHQWTH_QB7bI2Qd0BakBm9IE9ene8_3XQ>
    <xmx:CbFQZzj-gnk_gxccY5q9MQJ73y6CpI1qA56dPCHLr387FjvIXToMyA>
    <xmx:CbFQZyoqs9lDR5286bu_EP54yVcL4Wemx5rlWoGFT3d88xpE967IpA>
    <xmx:CrFQZz7UfHW9QtIHtpALIsC7FVq8sbLR9JgoDLIt799Fc5vCnPfFhyTq>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7F7912220072; Wed,  4 Dec 2024 14:44:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 20:43:35 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Andy Shevchenko" <andy@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
In-Reply-To: 
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024, at 19:10, Linus Torvalds wrote:
> "On second thought , let=E2=80=99s not go to x86-64 microarchitectural
> levels. =E2=80=98Tis a silly place"

Fair enough. I'll just make it use -march=3Dx86_64 to override
the compiler default then.

> On Wed, 4 Dec 2024 at 02:31, Arnd Bergmann <arnd@kernel.org> wrote:
>>
>> To allow reliably building a kernel for either the oldest x86-64
>> CPUs or a more recent level, add three separate options for
>> v1, v2 and v3 of the architecture as defined by gcc and clang
>> and make them all turn on CONFIG_GENERIC_CPU.
>
> The whole "v2", "v3", "v4" etc naming seems to be some crazy glibc
> artifact and is stupid and needs to die.
>
> It has no relevance to anything. Please do *not* introduce that
> mind-fart into the kernel sources.
>
> I have no idea who came up with the "microarchitecture levels"
> garbage, but as far as I can tell, it's entirely unofficial, and it's
> a completely broken model.

I agree that both the name and the concept are broken.
My idea was based on how distros (Red Hat Enterprise Linux
at least) already use the same levels for making userspace
require newer CPUs, so using the same flag for the kernel
makes some sense.

Making a point about the levels being stupid is a useful
goal as well.

> There is a very real model for microarchitectural features, and it's
> the CPUID bits. Trying to linearize those bits is technically wrong,
> since these things simply aren't some kind of linear progression.
>
> And worse, it's a "simplification" that literally adds complexity. Now
> instead of asking "does this CPU support the cmpxchgb16 instruction?",
> the question instead becomes one of "what the hell does 'v3' mean
> again?"

I guess the other side of it is that the current selection
between pentium4/core2/k8/bonnell/generic is not much better,
given that in practice nobody has any of the
pentium4/core2/k8/bonnell variants any more.

A more radical solution would be to just drop the entire
menu for 64-bit kernels and always default to "-march=3Dx86_64
-mtune=3Dgeneric" and 64 byte L1 cachelines.

      Arnd

