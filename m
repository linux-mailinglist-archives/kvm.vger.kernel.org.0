Return-Path: <kvm+bounces-33093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5933D9E4678
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 22:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D89D82844A4
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659571922E9;
	Wed,  4 Dec 2024 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="N546XD7u";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wJTARv45"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D2C18B499;
	Wed,  4 Dec 2024 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733347164; cv=none; b=FOk77+N8kdakYLHYFRTMpHdoaCm2FZfK/BO8V2eI0p5Rx8QGLgJ2M3R7YBp8uE1TTkGGOb7FmaK0JhfvnLWIo7v/+gm5Cc5bzj2HUBmrwD3dWQkCUSk4hPpVwruxYZ2j8Ye0nObVSl0KmY9ZSKSE4Rb/O0xHj4eJVQxbnPgoHpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733347164; c=relaxed/simple;
	bh=B9rF6FOEtdcHjCqXaF3lLBrBQRZ/1DKxyuLdj9gFU8U=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WQVMvd6wppF8v3pOQFvfFQyqD4/RWEhKVeC4YJYwAnOD4orRQFJn9loPd+1oAC28+/rHlEOC5MBUoyrEtiKHf494+XontD2pqb441JmOczaaQ3EvLL+3gAs6K9sFziG227KVn6/rpe5+KBAFWXhDHYSXefRSvmueqm5CeRTebmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=N546XD7u; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wJTARv45; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 83EEA11401F3;
	Wed,  4 Dec 2024 16:19:21 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 16:19:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733347161;
	 x=1733433561; bh=jHuW44WHE4NttJ2lU/dAb7RZUYUvNG29kEL8erso4UQ=; b=
	N546XD7ulWwS6rtihoFmb+2lqBlfynmHxY8kEQn/i4LXmJLRmewiSmNOywu+9BGK
	0rzJnXkKGQVN4+/v+sD8URrufzA712i889g/mqzQG2rDjeHMCxXo3Xd/WoRruPLL
	pg9pgzBCD5HLXJ8L082hRTFWbke/nGNoymaC0d7IJ5yesbaS6E0SLbQvCH7Pq21D
	EQvPJxz4o/rKgeZSb8hWo7suegNMkqWwjKVwGIh/a5dgUe+h9BpPPTTa7P+BVj9B
	SZuZwxihFY80abcJcnt6bmWKMTiBfdK8WHW1rfKGWBumBNXjn1MYR+228wyS6ulg
	NhuiTP5eltQgO9dSidAUkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733347161; x=
	1733433561; bh=jHuW44WHE4NttJ2lU/dAb7RZUYUvNG29kEL8erso4UQ=; b=w
	JTARv45O/ZLYiJqQ8aukll2KNCN+0jqs//PIyAogVNa/YWRRhta/zBQ/KjfHYx+Q
	K6fnHd2OL4ISjOt+PhQWqt42Uun3ckMLDqxc/mosETpcI3I3h6yt5uljRJgoKyu/
	xyHxUwBSstOUgUvoz+ELKqXTW4/Fvc8TYtoYlAlVWe9Nm59K6nKMhKeKmxfUhT7r
	H1esN3txX5r4KK858Vh79Kku21zivpXP6wbLAghBqI0M4OU1SCh4EDl5pvUeplpV
	GbQc+KB/9pR82mvm7SHgC5MwhZtfkhHeXjRhN51UDrRd6irLl236v9f3oe82ESua
	MxvqfX5fGBiSlgC1AjlMg==
X-ME-Sender: <xms:WcdQZ_4fhmR9vAK-YmdRNwhIhiul0e_y228X0-S3-HOe6A5czLWHXQ>
    <xme:WcdQZ07v91e4oWajIf2cQKEeul6I0ErXrCavxw2ZAm-6p3DpA1OxNXFGrUs3Q8fmJ
    UtWAJq7gbK6tpxE8FQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddugeefucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:WcdQZ2dQ2WxzFag0toogK5vMHgGPntAJszGjZiK5YX9mnj4GMDlCtA>
    <xmx:WcdQZwIym0w2vvEomwk0F8HtTGGxC9I2KLDGZvmw6h20U5bDPVMySg>
    <xmx:WcdQZzLbHR_o0S749OYD91CrsggHV3IOCPpwKKxcf3lrAqxDF3J1XA>
    <xmx:WcdQZ5zcowHs14-PrjYQ5D8O160BXctQpATkNPSnS4AG7F-gNR53jQ>
    <xmx:WcdQZ05MHqS9VNOOZqL0N4jZW6BpssjgO9GOhZ_a-LX0ar2s0sPeuOI9>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F07A72220073; Wed,  4 Dec 2024 16:19:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 22:18:58 +0100
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
Message-Id: <9dc6213a-99c4-4267-a5b1-62181a3ecfea@app.fastmail.com>
In-Reply-To: 
 <CAHp75VcYojM8uYURbaNjquod7n_EJe58Er-57Dw0iaZFc-+i8Q@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-5-arnd@kernel.org>
 <CAHp75VcYojM8uYURbaNjquod7n_EJe58Er-57Dw0iaZFc-+i8Q@mail.gmail.com>
Subject: Re: [PATCH 04/11] x86: split CPU selection into 32-bit and 64-bit
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024, at 19:31, Andy Shevchenko wrote:
> On Wed, Dec 4, 2024 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@kernel.org=
> wrote:
>>
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The x86 CPU selection menu is confusing for a number of reasons.
>> One of them is how it's possible to build a 32-bit kernel for
>> a small number of early 64-bit microarchitectures (K8, Core2)
>
> Core 2

Fixed

>> +choice
>> +       prompt "x86-64 Processor family"
>> +       depends on X86_64
>> +       default GENERIC_CPU
>> +       help
>> +         This is the processor type of your CPU. This information is
>> +         used for optimizing purposes. In order to compile a kernel
>> +         that can run on all supported x86 CPU types (albeit not
>> +         optimally fast), you can specify "Generic-x86-64" here.
>> +
>> +         Here are the settings recommended for greatest speed:
>> +         - "Opteron/Athlon64/Hammer/K8" for all K8 and newer AMD CPU=
s.
>> +         - "Intel P4" for the Pentium 4/Netburst microarchitecture.
>> +         - "Core 2/newer Xeon" for all core2 and newer Intel CPUs.
>
> Core 2

Fixed, though this is the preexisting help text that I just
moved around.

      Arnd

