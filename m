Return-Path: <kvm+bounces-33123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 518739E52E2
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9012A1882EA0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 10:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3791B1D8A10;
	Thu,  5 Dec 2024 10:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="NwuaBbIY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="H5S+Gi3E"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEBC1946B3;
	Thu,  5 Dec 2024 10:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733395671; cv=none; b=nGu6mGbTQaUj26UoDGkUY1sbrK2WhySCYB+MUa69W6apaJJTF9xIpTsKCQQq7x8O+pvyf/cloBVQvqM91bbc2P4Xu8YmsjVF606dGRQ5cihBQBydRUe5FM4V45LKOAur95sCCQNHipt9tt64sjspZhmZKIhiXQ0Hab2AqVfFOB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733395671; c=relaxed/simple;
	bh=KSxSLHiz1w1m4nCRxL7NwszuYMNMlNd5r27go3PiCm4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OUeHKOqBvJoIjFYztlQkG0tlahkOtubud5l6Nr9msLtNxZ2Bi+2gczCArG9/x98i2U0DS4JI+V2jmhZP4L0n6yZpus48v4Z6tW/Bdaw135ZmzyMhobQVqNM/3j1nZc+GNQYpBfuS+J6ylhOcBOL+eudXl9iBFl01AmqZhBjjg+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=NwuaBbIY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=H5S+Gi3E; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id F30D01140237;
	Thu,  5 Dec 2024 05:47:46 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Thu, 05 Dec 2024 05:47:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733395666;
	 x=1733482066; bh=WBdD6BvwhD2VIoSBC+YXbRjVhPqEhoboIcVpkiVONtA=; b=
	NwuaBbIY3dfOhwgG6jwWyujPvV/9IcBq9L79K4yBXCUkTqHSBniWs/ggmI6EZmzm
	hRfzouriz8NtZbkPa/AwT6YBdMid+BXR0o8DC7nnPOD6axThRSEvfbI3lahmR/P/
	TztUM37Y8lzQHXDO8WO8GFUPADq1TfU/cCT/uJuPAxWNM3dNKtrKJ7QmjyVOLm7d
	Rh6eKDwdTLHWpYCl1UKBHdPwCJ3VqUi88HWEbR9omh7W+IO9BaRJiBopJUcO9WvU
	LjQCHasLUgtvCGXHBGKSMrRHQ4H90dEsVZ7D7idmGVEelSCk4DZ1ykQANf0AQASf
	kHIltHB/t/rBcoXKe4biFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733395666; x=
	1733482066; bh=WBdD6BvwhD2VIoSBC+YXbRjVhPqEhoboIcVpkiVONtA=; b=H
	5S+Gi3EYYsQJvQIige/r7AfoPY1VuDcbIhdzqsCy43GQzQZ+qb+bciXWYhtErlLR
	4wOX0ILRSulnvGxUvgVJCRfnv95dpjQvLFyBY6di7hrhAYG+MUSDrFscXQ0Svtb0
	ztohbxva3AmGRSQ+4Doz7c2KnfdNqEI4WJyFvu9DaC930EfYeROFfg7k6W5SXDZJ
	B5fVPLDAw5E7Ipa4m/dmJNaWDpK3LP2NqdHNOYzQwJ/V167tuHL1IYAxqPxoAtRS
	X73rmtWG4fKl6pWZSR+3PaxQdOxElQWfr549Aynr1Ozv796PHRsX+vAHlmLsb063
	N2/bX8wZLrWDjvQBNegzg==
X-ME-Sender: <xms:0YRRZ0Mp-NADHmzMgLzBaWmrrQ7MTJVDPJHwB-jfxOGTcoj3OYLpAA>
    <xme:0YRRZ6_fdVocquEAzHh2thMLaYDl6oDBOBxNVswaD3YZJ9jvFeGeW-IfFgPvZBnXO
    c_YMwi2yvxs9LeDdFc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieejgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtoheptghimhhinhgrghhhihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggr
    nhhjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:0YRRZ7TP21mebaLeF0MtrSn1ZYAiRip-GWIWVFFcqV_ncnSraKx2nQ>
    <xmx:0YRRZ8uTBpaQQSEWf7W261yrePnYINH02UOtuVcVg347dhqEMndxNg>
    <xmx:0YRRZ8cT_U6LqHoVKelDkjedR7AaN8_5MRHeUCOsgTMZmJr_mKSGLQ>
    <xmx:0YRRZw3S4E9Bq8653qfz3IypRJqJjFNHflz2bkzE3dXZ3BzgOqXUgw>
    <xmx:0oRRZ30xlw4LWhm7979mwqa_7pDAp4_31hZJUy5KjHFBTJ5IsD0YpaRL>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 779082220073; Thu,  5 Dec 2024 05:47:45 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 05 Dec 2024 11:47:24 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andy Shevchenko" <andy@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Arnd Bergmann" <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <6465b995-a1d2-422b-b1f2-5e1a0b3163bb@app.fastmail.com>
In-Reply-To: <Z1F6AIjZdjv7igVp@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
 <66fefc5a-8cd9-4e6f-971d-0efc9810851b@app.fastmail.com>
 <Z1F6AIjZdjv7igVp@smile.fi.intel.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Dec 5, 2024, at 11:01, Andy Shevchenko wrote:
> On Thu, Dec 05, 2024 at 10:46:25AM +0100, Arnd Bergmann wrote:
>> On Thu, Dec 5, 2024, at 00:33, Linus Torvalds wrote:
>> > On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:
>
> ...
>
>> I did come across a remaining odd problem with this, as Crusoe and
>> GeodeLX both identify as Family 5 but have CMOV.  Trying to use
>> a CONFIG_M686+CONFIG_X86_GENERIC on these runs fails with a boot
>> error "This kernel requires a 686 CPU but only detected a 586 CPU".
>
> It might be also that Intel Quark is affected same way.

No, as far as I can tell, Quark correctly identifies as Family 5
and is lacking CMOV. It does seem though that it's currently
impossible to configure a kernel for Quark that uses PAE/NX,
because there is no CONFIG_MQUARK and it relies on building
with CONFIG_M586TSC. If anyone still cared enough about it,
they could probably add an MQUARK option that has lets
you build the kernel with -march=i586 -mtune=i486 and
optional PAE.

The only other one that perhaps gets misidentified is the IDT
Winchip that is claimed to support cmpxchg64b but only
identifies as Family 4. It's even less likely that anyone
cares about this one than the Quark.

     Arnd

