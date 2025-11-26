Return-Path: <kvm+bounces-64746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 977C9C8BBE7
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4CE03B0081
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6686F341046;
	Wed, 26 Nov 2025 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="aXj9lRQC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YSDcHdp8"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F604314D0C;
	Wed, 26 Nov 2025 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764187152; cv=none; b=sLtoaScgBTz0gWsy3e+w8GwZ1QqsgyAOv/EHvaf5N7CKlpX38v0duofMFeRSJeUx72Tnywn/yJ1RxUyOiyN7wSEqag94NbQe4wS9JO9p5o54qVHaIdPP6Vp3rZ9wAaP1cgGhTsy4m9fARqUiuKJonfRJpydWY4MKWKiyUTG378Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764187152; c=relaxed/simple;
	bh=V6lnM32uR4+9C7saSDNGx1iZfcvQRwTcDI4uJP+3XTk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UdtP6YwVgG/bbaGEKU/adNBYTN8iJ6R8o9WZb9W/h3B6xFwclgmVyp5yfRCVwc32NQrH9I9hTZDd26+T/TbHf1zZVXVC3xL+LaIUZC2MYAgc6o+aByCtEizBklGmtC3mAGlh/la0cT9eybczyxuA6XwgKbKOb48PTG/r3711Wtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=aXj9lRQC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YSDcHdp8; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9C1DB1400218;
	Wed, 26 Nov 2025 14:59:09 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Wed, 26 Nov 2025 14:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764187149;
	 x=1764273549; bh=jmMZwZ3T/H2UJyGQvvWkg6V9yZfwMQ6Q8YhFI2Lxf0o=; b=
	aXj9lRQCNWAg9nsQ3DHf3eJO56Ou7rmq/jMqfUdkcvEl3Igc2cwgVR63q0j6sLKB
	LLI6BQ4kAh7qcrep92D8t8ghU8ingP8rHM50p6XkpIVhDJR9imjdHX9dgEhNwKgR
	Ioq0wnS+dgmqPluOodIkQ851x028SfGd7rZL/G1h7IfovUjhV28TOFmK6+/a0ypX
	iFrFnMBe/wHY/ElBvYN1PnMkah3XfKA5xPT+Fo0mKU9cJNaF+aIBuyAaWEnU7jTG
	d0kQl90ND8Ij5whgfSh79gEYZtl3BSLbAokAEmzpP/Y6uj9SOEcXdIWPyoduDj43
	UQ6364S9k1z254Jrae7j9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764187149; x=
	1764273549; bh=jmMZwZ3T/H2UJyGQvvWkg6V9yZfwMQ6Q8YhFI2Lxf0o=; b=Y
	SDcHdp8GQ7IzQIVS83yReQWGCFr+ftfC3+5X1e/72e0s+N+IXnKV7dm335FR6uJ3
	bZCmcpLGXmxMZjOUZ9+EYBJ2ih3+JJab7J8s1kRJAbmzOj90vTQ2ymdT9alPz9uJ
	FpID1ozUKzuP1LS+4szGBYkZHD2lVHY4Cws+pvqhFPRDV1TSNJRN5WKqjQ62Shys
	vnGgg3ypLBgZHywYZwmKw6es6bhKtvLqrUwhlDt7IlxhgXSCW1bZc65k3VMp1rqK
	/9D51S5ThKzdftuLacypWLUQjgaPb6Lauv7I0skdfgf9kVDnFLRtZ/W9//Q6CC12
	gC28Tr/zl4GgGkwgMf/9A==
X-ME-Sender: <xms:DFwnaZnXEDX8hixgp4KZxtf1qli86L99SPR_wC_aBNdFxNDNOQXS1g>
    <xme:DFwnafoVegS1uccN98WmrhAHQkc3jI0Mun_VBsaeYVCokUg21OmzDC20AxQVbDenU
    _PnxZRJl8yKMoaxlbvj79gHuEv1VW6wU_9dYqZrI-HmeVYDmdIYkAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeehvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdegjedvfeehtdeggeevheefleej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopegtrghtrghlih
    hnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtoheplhhinhhugiesrghrmhhl
    ihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegrlhgvgigrnhgurhgvrdgsvghllhhonh
    hisegsohhothhlihhnrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdr
    tghomhdprhgtphhtthhopehfuhhsthhinhhisehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehkrhiikheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlsehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhhsrdifrghllhgvihhjsehlihhnrghrohdroh
    hrgh
X-ME-Proxy: <xmx:DFwnabEsRwyQZAaT5vShCyjURj3S120JsvuLYehrvOnQYv7EzMhwvQ>
    <xmx:DFwnaUNcpLntQ5v6e89jBepgrtjQYQaQY2k1qKZaHxemlycXAxQ8TA>
    <xmx:DFwnaYpht-bc3cmc7a2nkvlr2wt5xEbcnlpU-vq8v79qG5pajXukgA>
    <xmx:DFwnadBtYehufbSh_R8RiQF57DlNd5NYmyStkx96fELHzRzDOOmkKA>
    <xmx:DVwnaXyJiCsUCvOA8Yv7sI0ij7ZOnBYDabjmrvbUqWOwf5tpq2wIrJVK>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 89CC5C4006B; Wed, 26 Nov 2025 14:59:08 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AnJT6xfv7F9s
Date: Wed, 26 Nov 2025 20:58:48 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jon Kohler" <jon@nutanix.com>
Cc: "Jason Wang" <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 Netdev <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Borislav Petkov" <bp@alien8.de>, "Sean Christopherson" <seanjc@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Krzysztof Kozlowski" <krzk@kernel.org>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Drew Fustini" <fustini@kernel.org>
Message-Id: <32530984-cbaa-49e8-9c1e-34f04271538d@app.fastmail.com>
In-Reply-To: <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
 <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025, at 20:47, Jon Kohler wrote:
>> On Nov 26, 2025, at 5:25=E2=80=AFAM, Arnd Bergmann <arnd@arndb.de> wr=
ote:
>> On Wed, Nov 26, 2025, at 07:04, Jason Wang wrote:
>>> On Wed, Nov 26, 2025 at 3:45=E2=80=AFAM Jon Kohler <jon@nutanix.com>=
 wrote:
>> I think the more relevant commit is for 64-bit Arm here, but this does
>> the same thing, see 84624087dd7e ("arm64: uaccess: Don't bother
>> eliding access_ok checks in __{get, put}_user").
>
> Ah! Right, this is definitely the important bit, as it makes it
> crystal clear that these are exactly the same thing. The current
> code is:
> #define get_user	__get_user
> #define put_user	__put_user
>
> So, this patch changing from __* to regular versions is a no-op
> on arm side of the house, yea?

Certainly on 64-bit, and almost always on 32-bit, yes.

>> I would think that if we change the __get_user() to get_user()
>> in this driver, the same should be done for the
>> __copy_{from,to}_user(), which similarly skips the access_ok()
>> check but not the PAN/SMAP handling.
>
> Perhaps, thats a good call out. I=E2=80=99d file that under one battle
> at a time. Let=E2=80=99s get get/put user dusted first, then go down
> that road?

It depends on what your bigger plan is. Are you working on
improving the vhost driver specifically, or are you trying
to kill off the __get_user/__put_user calls across the
entire kernel?

In the latter case, I would suggest you do one driver
at a time but address access_ok(), __{get,put}_user and
__copy_{from,to}_user() with a single patch per driver
as long as this is simple enough. For vhost specifically,
doing it piecemeal is probably fine since the interaction
is more complicated than most others.

>> In general, the access_ok()/__get_user()/__copy_from_user()
>> pattern isn't really helpful any more, as Linus already
>> explained. I can't tell from the vhost driver code whether
>> we can just drop the access_ok() here and use the plain
>> get_user()/copy_from_user(), or if it makes sense to move
>> to the newer user_access_begin()/unsafe_get_user()/
>> unsafe_copy_from_user()/user_access_end() and try optimize
>> out a few PAN/SMAP flips in the process.
>
> In general, I think there are a few spots where we might be
> able to optimize (vhost_get_vq_desc perhaps?) as that gets
> called quite a bit and IIRC there are at least two flips
> in there that perhaps we could elide to one? An investigation
> for another day I think.

Yes, sounds good.

      Arnd

