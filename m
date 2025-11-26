Return-Path: <kvm+bounces-64647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 539BCC8946B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E5B563585F1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA0631A069;
	Wed, 26 Nov 2025 10:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="bcJWPcdJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tBDACi4m"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95793090C6;
	Wed, 26 Nov 2025 10:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764152742; cv=none; b=mql1e3IFRj7StFkOrcxGD/m/vIejWsjMqyQwN/EAgVjpMORcWr8BqBdZiYW6PxnF7fpUKks6kCOkXh6PNNraOUejrPW8tMPRrBVkVeXf5edUfr1PhCPNxqlPH1nDoHq0bEv4d9DloibPs1aPf2SNWyGByBpg6oWHbjjSu3OfpLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764152742; c=relaxed/simple;
	bh=wRjn2oFshydwmp8v5ISLMhwn6Lx9wukokkbF3vuSGBk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OghetzLU0TyN8pNQMIvN2nxtepbbJ9//VOVUwUew+nlcATj3T+6I/CmGnkdcID4plft5oQgtgjwL9umHRsosKikYrZ0m/JmOUYPnFplnO1dR5pmd8N7lXyOBg6pRM3bzBXZ3G7LcirMP37NJa9h6+ZWbZJbc+Yvq3d103pdsT2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=bcJWPcdJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tBDACi4m; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A50DF7A01B0;
	Wed, 26 Nov 2025 05:25:38 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Wed, 26 Nov 2025 05:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764152738;
	 x=1764239138; bh=4n8XpKIntFouevCoTYjY7Dj+z9sDyT8dkxo4H6FtRSs=; b=
	bcJWPcdJy9XUMVMxzHRJ7mgJiP+gJKvAYMEZzJ4SwIAUpSqwbsV8zAfG8iOrq7jM
	zlcmu6LJxHz8mcOZmNZbLT3O9iXuP4eA6kCfwxTHFJjjw/gzejFFLMWYc5MwtbRY
	TqxwgiGjQ4LvaXarsMvEoZQmVclmbNiIDLjW69CkAN1ki9gmzBPfyLED1JLKF9n1
	RtoroRFgNLDV/yfBJVSDiC+RSqSvC+6si7u5FMnJwk5g6szSdQNv6CK8R03F8Gca
	0SI86kO2sv/wbEaMXPZ/0jR4pnqEVc4BMYtgRHicZ7fT6UpMbaq/3HYcqgmr2g4b
	8p3Gk7RhucTn2zw3+wMHtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764152738; x=
	1764239138; bh=4n8XpKIntFouevCoTYjY7Dj+z9sDyT8dkxo4H6FtRSs=; b=t
	BDACi4mgxthTaMQcoTilxJNS1MmZo/PuTErFfVFwRA8heCOrMeRhw10lTSyeWXYY
	nVwwk7DBUwKNlXh7JO2H1gfzeyLBUpTGcltXwcj6lHaWs9GRK7ZKRzZN0cJ0OI5M
	8W6PEOGhnjQHkbFRQ+l93VyIWfp01voDZKPJpNV2fOj0VKTYh8yz1GMfoDM3DFNJ
	cZOk0up9qOVOb2/Tr28enJzMHzMjNf8e25KvzlcUyutpPBn3+4f0HENO0E/RBkdt
	5dPSah3SACrcMwGxFE0AjKlRsem9B1TrOBB63vlVocKgXtkvRP/F8nr2QIMo4uDt
	ZPaVXUiJzHhuodFuaFiwg==
X-ME-Sender: <xms:odUmaSf39wj41CvRNp2Miqek7s_ldsswuePkHc0P5sFs3oMWlvEcPQ>
    <xme:odUmaXAZJB-ZnhmvXw96bHdwPGB0oKTeAZyo2BaxsV0DAO3Ooq1RWE6hoIMpj2f-s
    MBcwzVpMDLcpNJiNodwexPR41kigX_N81bZp_fKN8C2Ryd8oJH4Kbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeeguddtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:odUmaT_IRtIlzJdVQn44HB9PAdPvPZjLxwxYLrFtThG6QXT-vSeKYQ>
    <xmx:odUmabkrIzgtpu4N5ma7NguB5yy65rfZwabeOHWE8ow8k_IvQahlzA>
    <xmx:odUmaci64UXCXftbolXHlelT5NXaAABP3vw5y3J-GvteHgOV0GwPuQ>
    <xmx:odUmaTYhv4LeNBM7C6688gra0ssZ3jlWwrAaVluLiS-H2GjEi0VlaQ>
    <xmx:otUmaRUktK8pc6SeFNGE7LDKqpLNwgFKrf2gdTJeciV2SqKD1dcxsUFL>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 17AB2C40054; Wed, 26 Nov 2025 05:25:37 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AnJT6xfv7F9s
Date: Wed, 26 Nov 2025 11:25:16 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jason Wang" <jasowang@redhat.com>, "Jon Kohler" <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 Netdev <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Borislav Petkov" <bp@alien8.de>, "Sean Christopherson" <seanjc@google.com>,
 linux-arm-kernel@lists.infradead.org, "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Krzysztof Kozlowski" <krzk@kernel.org>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Drew Fustini" <fustini@kernel.org>
Message-Id: <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
In-Reply-To: 
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025, at 07:04, Jason Wang wrote:
> On Wed, Nov 26, 2025 at 3:45=E2=80=AFAM Jon Kohler <jon@nutanix.com> w=
rote:
>> > On Nov 19, 2025, at 8:57=E2=80=AFPM, Jason Wang <jasowang@redhat.co=
m> wrote:
>> > On Tue, Nov 18, 2025 at 1:35=E2=80=AFAM Jon Kohler <jon@nutanix.com=
> wrote:
>> Same deal goes for __put_user() vs put_user by way of commit
>> e3aa6243434f ("ARM: 8795/1: spectre-v1.1: use put_user() for __put_us=
er()=E2=80=9D)
>>
>> Looking at arch/arm/mm/Kconfig, there are a variety of scenarios
>> where CONFIG_CPU_SPECTRE will be enabled automagically. Looking at
>> commit 252309adc81f ("ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 i=
mplementations")
>> it says that "ARMv8 is a superset of ARMv7", so I=E2=80=99d guess tha=
t just
>> about everything ARM would include this by default?

I think the more relevant commit is for 64-bit Arm here, but this does
the same thing, see 84624087dd7e ("arm64: uaccess: Don't bother
eliding access_ok checks in __{get, put}_user").

Note that there is no KVM on 32-bit Arm any more, so we really don't
care about vhost performance there. The added access_ok() check in
arm32 __get_user() is probably avoidable, as embedded systems with
in-order cores could turn off the spectre workarounds, but as
Will explained in the arm64 commit, it's not that expensive either.

>> If so, that mean at least for a non-zero population of ARM=E2=80=99er=
s,
>> they wouldn=E2=80=99t notice anything from this patch, yea?
>
> Adding ARM maintainers for more thought.

I would think that if we change the __get_user() to get_user()
in this driver, the same should be done for the
__copy_{from,to}_user(), which similarly skips the access_ok()
check but not the PAN/SMAP handling.

In general, the access_ok()/__get_user()/__copy_from_user()
pattern isn't really helpful any more, as Linus already
explained. I can't tell from the vhost driver code whether
we can just drop the access_ok() here and use the plain
get_user()/copy_from_user(), or if it makes sense to move
to the newer user_access_begin()/unsafe_get_user()/
unsafe_copy_from_user()/user_access_end() and try optimize
out a few PAN/SMAP flips in the process.

     Arnd

