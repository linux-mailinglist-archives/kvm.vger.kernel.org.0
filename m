Return-Path: <kvm+bounces-26074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4BBF97065C
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 12:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 703AE2820F4
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 10:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D7E14C588;
	Sun,  8 Sep 2024 10:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="PbBrs4Be";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SSDL4jPd"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A541366;
	Sun,  8 Sep 2024 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725789672; cv=none; b=ZVdn2fBdfIhOXDcnv7Tv8W9y0EbjRLW/yYkwPrzBhOajKPYmI7cFIATuMKu4tG9M+QRvTg1zSsaKqk/Q8HMlV53ZFPsdYWPqHeaildKWsPq0fM7EHxgxQuvChTmm0p4mBwKkV1W8Q3xsxAcgKQJh5oDClC6m8qqHkP24YRn+Wng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725789672; c=relaxed/simple;
	bh=bHer9k9FqetYzp1LXRd154U8yglaVwUhfSbpANomuu4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=CkmhO83fsK0xCiEQTSsNOJuLTWF5f/YFpUQmK0OGoohJj2hzKFzzVwRd7dCwlQw00AKGOmQ11LqUm4dkpGrgfd1PbnHgAC+8GbVFR/r9xA3LYKfg72ReScdLBC6yaEUV5fBJNGbw2LHlaxKaRinJrfaRPe5CM7A+QjAjnkHqMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=PbBrs4Be; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SSDL4jPd; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 679A51140060;
	Sun,  8 Sep 2024 06:01:09 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-09.internal (MEProxy); Sun, 08 Sep 2024 06:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1725789669;
	 x=1725876069; bh=bHer9k9FqetYzp1LXRd154U8yglaVwUhfSbpANomuu4=; b=
	PbBrs4BebfNgbn+MHf+d2+EDi1PR2Lwtki95yZy32RqKvTzfuTsQUZrypWdFRDIS
	tmZEZXq8ThlIjapPJ6XYYWCYi91jBCsde4nepISD19hdo/Rzq3FTz2Eu4R5Pr/4u
	j7UfkTfjummDeLmvw440W7KCHasEZ3qswvtMsI4Y/+XqhIBsR5Tx2L43C4qEL6oH
	x+GLQvtQNN5fV35aMSI9rK8qfRuJnklTomCVabPndk5h/cDfOnRNUnX012/fp5hy
	vf7uakaGbe07GDam1HnX/MmaXFK8aRov2VDc1lRStKj3h6yN/umHkNtiAJp2rJQj
	ab+MRnRese+0qFnFxxwOrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725789669; x=
	1725876069; bh=bHer9k9FqetYzp1LXRd154U8yglaVwUhfSbpANomuu4=; b=S
	SDL4jPdRUbwPgv89PaU1gF6x/0SVrHab0dgHixWieP2qoPpyVsZORI/Djdfm5Bqh
	7ACz2Py9samQeG2I/B0t0nOHFZojDXLyhlGh3WVjxjw3QuIwmAh757FIsrL4uF18
	bOfXCjJ35JBtdAU6T2zhcfnEq+YcZaspGgwJjgYxCntU8QA3YmIU0L1rXjf2nqKD
	68T12HsOTfQcQ6gHoXQd8VMeHtD95Y/2Zw948dalm5oK/Z8YbH6PCffiQFZDuBlU
	IxbK75JK/fx9X7Z6LKlBp7VewZEHTbfvagBS9rCpKgqoUWg4SwIHtoXSYw1s49V4
	3kEQ43wwBK10PHCOVPweg==
X-ME-Sender: <xms:5HXdZpwlDS1mhMA8aJz8KbtxNhasqKCZ0G97rShSAESZgkxFeC11AA>
    <xme:5HXdZpRHKTo3kr9AGcpesKSwhZ2qoFNoWUsv2WIfY6gDfPmND3dvBJrhRCZKC637q
    P1Yc4NsZchuHFlUxV8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeihedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedflfhirgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfh
    hlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepjeehfeduvddtgffgvdffkeet
    hefhlefgvdevvdekuefffeekheehgeevhfevteejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgr
    thdrtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtshgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthht
    oheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrrghfrg
    gvlheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhirhgvshhhrdhkuhhmrghrsehl
    ihhnrghrohdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
    dprhgtphhtthhopehlohhonhhgrghrtghhsehlihhsthhsrdhlihhnuhigrdguvghvpdhr
    tghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhmihhpshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:5HXdZjXKsiVg0w6__LUADfJytMeo5A4WoNQvia67yR5kq9W8Jmoi0A>
    <xmx:5HXdZrgii1I_h-w-gR8wS3hexx2c9NS-vXSzX9kWSFdDgFOkwBGozQ>
    <xmx:5HXdZrDcUvQhwymXVqk5VPhjCz17hA7wRmgyDKLspEsJUf4QY_OiRA>
    <xmx:5HXdZkKztAxFwWu28RgDAE4gSSV_LYzj3kFiwO7qG8pSOTuVzODCvw>
    <xmx:5XXdZv766T5NvtEyKkiP7RLpIB-HYvrQDJZ-KN3MvjO9rf6m-9PJ-lIF>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 97D501C20066; Sun,  8 Sep 2024 06:01:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 08 Sep 2024 11:00:48 +0100
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Xuerui Wang" <kernel@xen0n.name>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 kvm@vger.kernel.org
Message-Id: <5d32c242-2854-4687-876a-312bf24e6aeb@app.fastmail.com>
In-Reply-To: 
 <CAAhV-H5xejfimHedCpLfh2CRheHJmAXpvcmWpLacyrg5m4EPJA@mail.gmail.com>
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
 <20240907-iocsr-v1-3-0c99b3334444@flygoat.com>
 <CAAhV-H5xejfimHedCpLfh2CRheHJmAXpvcmWpLacyrg5m4EPJA@mail.gmail.com>
Subject: Re: [PATCH 3/5] LoongArch: cpu-probe: Move IOCSR probing out of
 cpu_probe_common
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B49=E6=9C=888=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8A=E5=
=8D=883:47=EF=BC=8CHuacai Chen=E5=86=99=E9=81=93=EF=BC=9A
> Hi, Jiaxun,
>
> On Sat, Sep 7, 2024 at 6:17=E2=80=AFPM Jiaxun Yang <jiaxun.yang@flygoa=
t.com> wrote:
>>
>> IOCSR register definition appears to be a platform specific
>> spec instead of architecture spec, even for Loongson CPUs
>> there is no guarantee that IOCSR will always present.
>>
>> Thus it's dangerous to perform IOCSR probing without checking
>> CPU type and instruction availability.
> I don't think this is necessary. Loongson's Chip engineers confirm
> that IOCSR is always present in Loongson processors. If other
> LoongArch (not Loongson) processors have no IOCSR, they should
> implement their own cpu_probe_abc() instead of cpu_probe_loongson().

Hi Huacai,

IOCSR_FEATURE probing process is now in cpu_probe_common, which is shared
among all PRIDs, that's why it needs to be moved out.

It also prepares for different IOCSR definitions, as you said before IOC=
SR
definitions are not guaranteed to be compatible, so if an incompatible
implementation arise, you can just introduce a new CPU_TYPE for it and
create a new iocsr_probe function.

Thanks
- Jiaxun

>
> Huacai
>
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>


--=20
- Jiaxun

