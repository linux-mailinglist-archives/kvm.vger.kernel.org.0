Return-Path: <kvm+bounces-33034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC939E3B85
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EAEA165446
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F701E3DFA;
	Wed,  4 Dec 2024 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Y9VSWAbx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="5Fe+5ZP5"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56A71DFE15;
	Wed,  4 Dec 2024 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733319834; cv=none; b=oGB5uyY+cV3iAF4Fvb9/ekaWs71mCz2cYanwDgLBCk7sPDr1lSJzUGcCAHuxNJTFUqjE4OcH2WeMHpv/rL5Wo5XkIyEvKmNxS7p0sD+fjVja9FCootKk2jHBZ5b6DyJOWGN3J2mkZnTPNONFjrfDmXGdQD9vMHNuKNujUcI+8a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733319834; c=relaxed/simple;
	bh=IWY185UDxJQuTVgIgRa6TjkOFyZfoJ0/Ue//WdZuESE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TJKVoyaQJ6M70M4zDe/t1Vbgmx0wGBL3g+zC9rQeuFNqWrYTNGFvkWPeyeRNQ2lIBYRns+BD0iRZozn2icpxEIeUN592TjfVhK5lsPeUzm4TBqvdwNlyG3ASxJh0QK9iTGxmZbdTi6FJWMl6Lbpk/seowxkvR5rsxxgTRUSpbt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Y9VSWAbx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=5Fe+5ZP5; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 7018D11401A8;
	Wed,  4 Dec 2024 08:43:50 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 08:43:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733319830;
	 x=1733406230; bh=szqLPMx8pEbitHya79Wlpl8ZoRcwrEZDRJ1xqCJU1kk=; b=
	Y9VSWAbxTTbeAB2nPIdNLl3wa6McC0xNpmBHITMEqVmWmq3A8C3QmQ0m1Aerr2M1
	OsXsEYq0Z+3zu1XB9rM9phvVhVB0ZiiheHpZtLuX9Zg0Gkv/w2HHV0wnSDNQWqws
	Atid/Sjl5gjMm0vrhafV+ce8mkhm23uZ30fdRAZJtGo9yOFrQQTfvtTredQfyNP/
	mO9Md55X6PQfNTvqMjfSf1L0+RQdvS2uYFU51Icrq4IRavb7kQjzewNkIuQ8hPUY
	R5eNNym/AoKDMMDdsuUoxL6pip0R4ig/Mj0nWkpROLahrTYScrxBCXw5N2E48WrK
	fE8sQnKxhCM3X0Z5a7RKCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733319830; x=
	1733406230; bh=szqLPMx8pEbitHya79Wlpl8ZoRcwrEZDRJ1xqCJU1kk=; b=5
	Fe+5ZP5f9JxI4ZoOdSO2sG4nEHJ2O2fM56rEjdH29TXVcBGGeDkAbRihAkKfYYJa
	PuyY2gRPHQXwk+JeO7J/7U3maPCrhPVLkspPMby9lOuXWniQdRSlUjy89pFwWtWG
	xDnNO69B6l9lEwm1fzh6s/zxosJ6LBWwGFMfmi/nHf51Uad0WlVw+gkcKpG+A87R
	exTkHJtNPGSR4PKmea02h7FQ9/4zTwnwd3Ogwv4eMX7c2GHN2q3xuKxsieREYJsN
	PylRqteNZ7vwTEoS9TSwqjazcXNeOoj5o4e3KwHNLhrGxXKckApUadFUrvCZgNKZ
	KVmm2U64uJHkNVDwU9mlw==
X-ME-Sender: <xms:lVxQZ6up72_fCoflwn4HvGF9LdETVKpcXIE9ePmNbURsM4nRAyXsWA>
    <xme:lVxQZ_f7FPfX7KZ_tV-iWu0cZa1Xti8GlI6mLkTsLlIXY5WqneCh0NzeAZ0kUlpdY
    OQ4vIimX8w8n7VOo6M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeen
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpedvhfdvkeeuudevfffftefgvdevfedvleehvddvgeej
    vdefhedtgeegveehfeeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduiedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtohepsghrghgvrhhsthesghhmrghilhdrtghomhdprhgtphhtthhopegtihhmihhn
    rghghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvg
    drtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghp
    thhtoheprghnugihsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepthhglhigsehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:lVxQZ1yKY3_jv4r-jD8N9LFXrRF1VCORFW-7qy4FLlWeOQBU-0H6LA>
    <xmx:lVxQZ1P9Y0U_MoJvDv_F0FoiIC-tIHzdrVHf9UnLerzxoUb-eJzjTw>
    <xmx:lVxQZ68y8x9r2JfwD8lz-FV7yzmpm1lzqs7_4Isd9eaYND1abN3pEw>
    <xmx:lVxQZ9VqUBZiVBINP0H-Z8glVXPx8M_okDQKBtkBp2zy71jtjixOiA>
    <xmx:llxQZ1epkuu0tyfx9MzmyP-jVOAUeOgjX5Em7FIWy-3057BLz_htSvUg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1B4332220071; Wed,  4 Dec 2024 08:43:49 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 14:43:28 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Brian Gerst" <brgerst@gmail.com>, "Arnd Bergmann" <arnd@kernel.org>
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
Message-Id: <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com>
In-Reply-To: 
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024, at 14:29, Brian Gerst wrote:
> On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel.org>=
 wrote:
>>
>>  - In the early days of x86-64 hardware, there was sometimes the need
>>    to run a 32-bit kernel to work around bugs in the hardware drivers,
>>    or in the syscall emulation for 32-bit userspace. This likely still
>>    works but there should never be a need for this any more.
>>
>> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
>> PAE mode is still required to get access to the 'NX' bit on Atom
>> 'Pentium M' and 'Core Duo' CPUs.
>
> 8GB of memory is still useful for 32-bit guest VMs.

Can you give some more background on this?

It's clear that one can run a virtual machine this way and it
currently works, but are you able to construct a case where this
is a good idea, compared to running the same userspace with a
64-bit kernel?

From what I can tell, any practical workload that requires
8GB of total RAM will likely run into either the lowmem
limits or into virtual addressig limits, in addition to the
problems of 32-bit kernels being generally worse than 64-bit
ones in terms of performance, features and testing.

      Arnd

