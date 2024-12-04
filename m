Return-Path: <kvm+bounces-33056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 402DF9E45F5
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A499BE454F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14C920B80B;
	Wed,  4 Dec 2024 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="K8TGU9JN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MSNHHMb5"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F017207E0F;
	Wed,  4 Dec 2024 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733334719; cv=none; b=TMEkBO73LgcotxKSUZVyo00nhMLmN1K/w5jU9ys2rINrLbjapQG7+e3lDd31KtDwOBuoNNzOvoBWtAAV29ZBW9LzNvCRGOH/pTYEB46MnbjgTdVB4qxf4RZPvfwXpWwR3MU1QZbULtgH9neCys38UZ7mu6Jjz4rP0oXMp55sH2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733334719; c=relaxed/simple;
	bh=FGCl+JsSEeF80YE0YF+6nZDBFRr+bBmxhB89qH3mjzU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Sd+8HQm/1wKK9JA9gy0iW7HbpEmsSDzaMqwZoodbO2O3eUSXjCHHKm74CCnbabCHRVKFSTfoiwTcOattm1XJcLHoyRNhTqhfWRIoajjPzTzyYwInGWCYNAFMN7JbfqiTTSfwoGwiabrCltbsiePu80J1ciryEQALzeuS9dwKxa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=K8TGU9JN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MSNHHMb5; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 02FF7114010E;
	Wed,  4 Dec 2024 12:51:55 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 12:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733334715;
	 x=1733421115; bh=jJE2L9y+wEwp9MITaMA6HBhlkUzfR3+Jn5SAVrObSeE=; b=
	K8TGU9JNA/8Eu09oYaCYPJ1x38aLd+5O+m6ONqg8opGJDtCUw4krurwNMDVuM/bS
	pboxApeIJj0UYM25nVZO6jc/pjz5mxK0p9EthSOuJdLl1Uhb0UR+toFaH4m8DG/6
	W/elIdbhx/S00iG9P7dr15V4DODFipVo2v6QWXZTyo8Aq80mzPqPys0/6bHd2UJ+
	XuCB3Bb+VVIjuYNNcmMnYR9zMpMqTLO3aLpkbmfQdOERYkHvlwg5Zd2AzZQcwO0T
	x/m8zxyf6GZfgrxT5lvMBNyYnZXQ2Vt/ian5bILBmsgbK00KqvtVNMpHtOTtqR/I
	XovoBeeQyHZvl/nvJET8Qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733334715; x=
	1733421115; bh=jJE2L9y+wEwp9MITaMA6HBhlkUzfR3+Jn5SAVrObSeE=; b=M
	SNHHMb5oo8A+cXXlOyVSMFKIVOj7J9W4uUhqn38tBjghx7HUtOFmB0dA4Bot2KCr
	bsIj/eMZnypK+WU2JcvLA+i6I4zIsmtbtaActwHdkaM3B+u6mjZnLl7h+xQ16X58
	ySkMm4qVuVh5AGpEM1GPNEK95ZfueUre0dQ+KySSkN6kd8sDxGjFnJy4xS9eBNzo
	WobOnWI1DETEojrVO6Ypw923PBqnMGeQnnJX6tyDZE4KpW7ZfofgJ9AT2BCkG7F3
	pROqSiGJW5QMPfg4sfMSx3rJ+rH5ex1Yi2sos+5lQmz2tV2X+7ZeVcILnRBN810b
	1Nq/atoJFz3ohv4OtH2HA==
X-ME-Sender: <xms:upZQZ7SxdGZd1E4gTE9vgnsRIPL-HAhqgcDd1hmkESiEvXA5PB5OxA>
    <xme:upZQZ8x9PakEhW_RoG4KqmaONf4jQhAkzGLpC9pyY2GZZ5TPrFzFWTVt4TxWMTSS5
    T2HoUqwP318cky5rbs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddt
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefg
    gfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudej
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopegtihhmihhnrghghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgv
    rghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgrug
    gvrggurdhorhhgpdhrtghpthhtoheprghnugihsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgrthhhrghnsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:upZQZw0wpCWbUKnLUXLtGT8mmbRL9TsXw3nPu9bC4_En5MdNJ5RfGQ>
    <xmx:upZQZ7CP82B3yE7uInYvsCqXQcTBBHy9ntVV60QIO3XIR07DhIG_8w>
    <xmx:upZQZ0gSUG03GVXljjr0mb4aG_94ObaUSqDU49c-ZOfJ0bU_g5vo-A>
    <xmx:upZQZ_oUy0aSGB1Jgt9sGP5t1oxswFHJrniQdyqSiB8TlpLTHrO35g>
    <xmx:u5ZQZ7Sl6Btvw0Z2OCBePmmVUt5xTxYuxO2pOIknyVjTHsv3PkW_6aCY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C126B2220072; Wed,  4 Dec 2024 12:51:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 18:51:34 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Tor Vic" <torvic9@mailbox.org>, "Arnd Bergmann" <arnd@kernel.org>,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org,
 "Nathan Chancellor" <nathan@kernel.org>
Message-Id: <9dda7e79-3c0f-48b0-824c-40a230b5cc12@app.fastmail.com>
In-Reply-To: <6c037258-4263-426d-beb2-e6a0697be3ab@mailbox.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <6c037258-4263-426d-beb2-e6a0697be3ab@mailbox.org>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Dec 4, 2024, at 16:36, Tor Vic wrote:
> On 12/4/24 11:30, Arnd Bergmann wrote:
> Similar but not identical changes have been proposed in the past several 
> times like e.g. in 1, 2 and likely even more often.
>
> Your solution seems to be much cleaner, I like it.

Thanks. It looks like the other two did not actually
address the bug I'm fixing in my version.

> That said, on my Skylake platform, there is no difference between 
> -march=x86-64 and -march=x86-64-v3 in terms of kernel binary size or 
> performance.
> I think Boris also said that these settings make no real difference on 
> code generation.

As Nathan pointed out, I had a typo in my patch, so the
options didn't actually do anything at all. I fixed it now
and did a 'defconfig' test build with all three:

> Other settings might make a small difference (numbers are from 2023):
>    -generic:       85.089.784 bytes
>    -core2:         85.139.932 bytes
>    -march=skylake: 85.017.808 bytes


   text	   data	    bss	    dec	    hex	filename
26664466	10806622	1490948	38962036	2528374	obj-x86/vmlinux-v1
26664466	10806622	1490948	38962036	2528374	obj-x86/vmlinux-v2
26662504	10806654	1490948	38960106	2527bea	obj-x86/vmlinux-v3

which is a tiny 2KB saved between v2 and v3. I looked at
the object code and found that the v3 version takes advantage
of the BMI extension, which makes perfect sense. Not sure
if it has any real performance benefits.

Between v1 and v2, there is a chance to turn things like
system_has_cmpxchg128() into a constant on v2 and higher.

The v4 version is meaningless in practice since it only
adds AVX512 instructions that are only present in very
few CPUs and not that useful inside the kernel side from
specialized crypto and raid helpers.

      Arnd

