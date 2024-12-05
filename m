Return-Path: <kvm+bounces-33129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB9FD9E54C0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7670B28373C
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2B3214A78;
	Thu,  5 Dec 2024 11:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="NHAx49Nf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UHv46XpB"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470AA214A73;
	Thu,  5 Dec 2024 11:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733399928; cv=none; b=YHdSHUsA4vcL1gVTc5QiCg+PSfVTvFNr4rSB7VMprNxfTVlVzJPHeLWzqiUZEyRs1GHIdwCzs0U5GRjJglYJ1kJmgLJkUX93fy+gqRH2QXVXjorflm78ty6y9qRYAVwA1NiXNK2WIx7Xx3QYIvT8UGxHoXkiTKZ0d5VJmFp4+/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733399928; c=relaxed/simple;
	bh=TXxBsh/0Dupz3rwhGOucWdNFXxWHczDayCS9WG0joQg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=a3i5GG/Muu4K5jXPHj8eJjhqTuZY1kY8v5Mo+zjY/BSAnON1Pp4A6KmXFEBWb1Lw0QVOBjwGW9AVmZvlNWo2eVLT+wANXklROLRNxWL+gK70/yyV/2FRgCr7K0246iR2hcVCBH/x97sLRCb6nAirkOFJIdVMsTAx/8fXcFuEib4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=NHAx49Nf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UHv46XpB; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id EE1C8114018E;
	Thu,  5 Dec 2024 06:58:43 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Thu, 05 Dec 2024 06:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733399923;
	 x=1733486323; bh=Tv0o38Q1VlIsg6s/dOh0hDJHiMNuiauv4VLlU8CJQXU=; b=
	NHAx49NfQKyVGqR1p5crjX1541OJUpvn82ZEseI6Wfol4P11h1KBWtMMPDpZzHib
	Fp9+p6dQR44e8glWPtTKmvMA9bGe5nxT11mIGPTqtKXSFBBaNg07uP0jp73+J4VS
	FkfeZG8DD+Lj9tG3cYsePVzkKMl2MvTAyMTLZPhixTTu5/KbMPbA563XIVI/WazT
	LD1UL3a2ZOhkX5hgvkK6RWgk1mm4IBRs3r/eTpFaImjN56ZtWpIYVWQT0wkNxvLL
	o0xl+B0H/1y42ce/CT4BLO5SlihY605coj7wMf5aZU4Uc6dfQDoJGIKN+Yz85RDF
	ZGlibZz5hsYoH5tpsUBnoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733399923; x=
	1733486323; bh=Tv0o38Q1VlIsg6s/dOh0hDJHiMNuiauv4VLlU8CJQXU=; b=U
	Hv46XpBy8/xur5bmR5+r4YLDhvoiHshD2VpjMb5Cu2AQoYEY0f+PoUgf/v24WRrv
	f1PPKSWog4fBm7w6Gm6jwmucfy6//5FKBhF7LqdVKaSuZ+e5Qd/aGGFD1yYbWKRE
	5j2CNCl62VqfL6Y/R1EgrduOaWsKqx1QOYf+dx+0vS8EO1v0XEwmYY0ghO0GoVzD
	WJoRuwv/rt3pCh+vP6jVBFb843MdZJePVTbmrluFazwNbGZh7LDDUovB1tsVPldJ
	9qwdBeebiZgRsGEXYYodJLEWKqft4wjaEi4ulhs8GOTkIcr05qAmKECqfqDkAT3i
	MBSgK02NwtvAOT292zCAw==
X-ME-Sender: <xms:cpVRZ_j_dSzeZKvaB_uTDpKWCPD5XHjZcHkrphGGPvML3yF37P8Pdg>
    <xme:cpVRZ8DozELlcLQwZB5b9ESr5Bth2jWyek7anHGiXkj9F2hlb7Btq-rOL0Knuj1eI
    IKQ8rgZu3o4YMpk4Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieejgdeffecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:c5VRZ_Hxu5ITd0WSyCdCK_6I14emoPTdPtnN9ILobW4KTeXBk6BJ3A>
    <xmx:c5VRZ8T1c6L6I2MgXDSqlNUmCnSWUgCGeDqz0tJQB4qlfRPMtMNDKA>
    <xmx:c5VRZ8yAIR_NWPeKZBrBMrsWTl8auXd9sAJQZpCAj4sfkBeEVKKmEA>
    <xmx:c5VRZy678X_zr9vLzV7zZK9ZI4McTE8WvyF5dcoltaixYAD68Dr_0w>
    <xmx:c5VRZxIJDoMhrQU6-YL3vNMyuewhamXkKyrWFXCVDAI1V5ClMgEA6YJp>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DD43B2220072; Thu,  5 Dec 2024 06:58:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 05 Dec 2024 12:58:22 +0100
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
Message-Id: <1f2ad273-f3a5-4d16-95a4-b8d960410917@app.fastmail.com>
In-Reply-To: <Z1GLrISQEaXelzqu@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
 <Z1FgxAWHKgyjOZIU@smile.fi.intel.com>
 <74e8e9c6-8205-413a-97a4-aae32042c019@app.fastmail.com>
 <Z1GLrISQEaXelzqu@smile.fi.intel.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Dec 5, 2024, at 12:17, Andy Shevchenko wrote:
> On Thu, Dec 05, 2024 at 11:09:41AM +0100, Arnd Bergmann wrote:
>> On Thu, Dec 5, 2024, at 09:13, Andy Shevchenko wrote:
>> > On Wed, Dec 04, 2024 at 03:33:19PM -0800, Linus Torvalds wrote:
>> >> On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> >> Will that work when you cross-compile? No. Do we care? Also no. It's
>> >> basically a simple "you want to optimize for your own local machine"
>> >> switch.
>> >
>> > Maybe it's okay for 64-bit machines, but for cross-compiling for 32-bit on
>> > 64-bit. I dunno what '-march=native -m32' (or equivalent) will give in such
>> > cases.
>> 
>> From the compiler's perspective this is nothing special, it just
>> builds a 32-bit binary that can use any instruction supported in
>> 32-bit mode of that 64-bit CPU,
>
> But does this affect building, e.g., for Quark on my Skylake desktop?

Not at the moment:

- the bug I'm fixing in the patch at hand is currently only present
  when building 64-bit kernels

- For a 64-bit target such as a Pineview Atom, it's only a problem
  if the toolchain default is -arch=native and you build with
  CONFIG_GENERIC_CPU

- If we add support for configuring -march=native and you build
  using that option on a Skylake host, that would be equally
  broken for 32-bit Quark or 64-bit Pineview targets that are
  lacking some of the instructions present in Skylake.

As I said earlier, I don't think we should offer the 'native'
option for 32-bit targets at all. For 64-bit, we either decide
it's a user error to enable -march=native, or change it to
-mtune=native to avoid the problem.

     Arnd

