Return-Path: <kvm+bounces-36239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C68BA190C0
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 12:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA1221887A7A
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 11:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37CF211A3C;
	Wed, 22 Jan 2025 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="ECELAQlC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kaj9xJl+"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D4920FA9A;
	Wed, 22 Jan 2025 11:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737545911; cv=none; b=VgDx3xMt8pHOHR8ymvqb19+rLXbfiTymyyRyKKLQDc2OQi2Iv+c1mM70i/gq4/f+SsKDysJM+KQxnw2cDvAG4hY77B+gHw+sg8GVcnqocCcgrZO0xfJVCszvvEhccUNf0zfkd3+meY3/58ChfCtXSkVsSwDqnhCtsYBX9ToBY54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737545911; c=relaxed/simple;
	bh=J6psTmPSOU3QKpSJiKJxeAXXel0SZEi6GTHPuAuKZM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btg6RDhR30ZPXTDUPzVCzsFNl1WGiRJnOZDr8HwOqj/9AMFDV2orqSTRPlvh6ahgr1AW1h5NScQQ6pKvynIGLG6rJ7Yd4SNkYkgioiOBwKRWL8iaWX2lBJIX5cpWj8gHYJox2xrK7OM+Q2kx8X8YppJFV1TRhoJUSVOufXigNiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=ECELAQlC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kaj9xJl+; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 1BE09114016C;
	Wed, 22 Jan 2025 06:38:28 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 22 Jan 2025 06:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1737545907; x=1737632307; bh=G8MsUq4Yg2
	w0NbfNEjbUAvvjkMooYocwMqwISkeqwRs=; b=ECELAQlCZh+3wWqHTR3gkm3IKl
	gxBsRMiF2EKFJQEatuh7cwdJiGhN5dozRoIhj/9iTNTqD6xaSB9mX55rdlEd42GV
	UVHHBifG9TtTo8HqNsY+PcXKTkATPd9m02ZSvTvxDnc1mtsuuq/HzWYIJmn+HMby
	TqBYTGO2BO8EPuB8NIMmCkJ2+j793ADkKSLrcuXoZ5UfHRBDTWeLZadRzReKXq8n
	C02DiMUB3KE/gl0ZdgSmiNKQR5hMsPdpDHdwPKerlz/Y87unmgGOCLd75A4TSRpS
	WUnPFKJBRfhV5/m/Ut50PFrzidQaBiv9jwgvgUeRkD7MXthhymoZWgoQbIhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1737545907; x=1737632307; bh=G8MsUq4Yg2w0NbfNEjbUAvvjkMooYocwMqw
	ISkeqwRs=; b=kaj9xJl+/kjO73YRAKA75oZUYvBLH+xw6B0HpYpwMzuYIU6idlj
	B0FH5PZfk8daVL468Q1UTGVGoF9NsbW0kVQ20PYmcMSd9WA5FJdNp4aVIgpV/W4D
	lrsjcXHQkHCoXfrd/BS2mUdxKFJzuHbbH9TvSD8ZZro8MlMkjPhAXlhGJSLzfFgj
	SFd2jFpwptJAkGx1sbuENHkU6QglKhV/I7S/e3QAZSR6wbtkkYFP+NjOIdkaPuH4
	VCXuWbh6KyXNwyhbHsaG98BX/szcuixl66qWZgFn2EmBo0ztxVWmVgRgTtC2LGxi
	Opx0uSudVPMWr873ehtjMvkJ9v6VRP//XBQ==
X-ME-Sender: <xms:s9iQZ1cr7X83bJNzUiAMJWGI4E-sedRZdDTOgyzvf-i5fxWnNlmpWA>
    <xme:s9iQZzO6FTtw5CpEhLEyIzDGX1JTt6mjOC340Q20_s7efpgeJkBHnxvyCIGGZrPXm
    3zQuVWk2jZHwUODvw>
X-ME-Received: <xmr:s9iQZ-hx7oU8dvgSyPaIdC8JkTPskVNfkcz2N60rjM2yvgZKPja8Jp6vpxrDvj4sw_B9Wytitn6gOovJZyQB6VIaDCY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgudehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehgtdfsredttddv
    necuhfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenuc
    ggtffrrghtthgvrhhnpedtjeeuteekheefueeluefgveeiffekhfetfeeivdefheeuhfej
    gedvieffiefhieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepuddtpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegslhhutggrseguvggsihgrnhdrohhrghdprhgtph
    htthhopehsvggrnhhjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepkhgsuhhstghh
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtjheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgt
    phhtthhopehmihgthhgrvghlrdgthhhrihhsthhivgesohhrrggtlhgvrdgtohhmpdhrtg
    hpthhtohepphgsohhniihinhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehkvhhm
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvg
    hlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:s9iQZ-9boLcqCIG8iGSsTn5LWMO3pFQu56TwLW494CMAYE0ix2qZOA>
    <xmx:s9iQZxujd4BTUKHTrnmBfqhlO2Gu0Ofbn2V7R9x_GKWeYug4LdbAuw>
    <xmx:s9iQZ9FQRXcYgGSSIwl0Iz1qr8guVbbDhQt9YSKCp3Q6QowKW-tFsQ>
    <xmx:s9iQZ4PAaEBzihQC8uNL-JA5Il5RhUiwSs7C40SipBSQycr1sur5Xg>
    <xmx:s9iQZykySSZF3JGjL29Vv404HXDFRyqk6lGXo4Zw3SnJQrv8FiyibfXc>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jan 2025 06:38:27 -0500 (EST)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 83C5DC223DF; Wed, 22 Jan 2025 12:38:25 +0100 (CET)
Date: Wed, 22 Jan 2025 12:38:25 +0100
From: Alyssa Ross <hi@alyssa.is>
To: Keith Busch <kbusch@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>, stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <twoqrb4bdyujvnf432lqvm3eqzvhqsbotag3q3snecgqwm7lzw@izuns3gun2a6>
References: <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp>
 <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
 <Z4cmLAu4kdb3cCKo@google.com>
 <Z4fnkL5-clssIKc-@kbusch-mbp>
 <CABgObfZWdwsmfT-Y5pzcOKwhjkAdy99KB9OUiMCKDe7UPybkUQ@mail.gmail.com>
 <Z4gGf5SAJwnGEFK0@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pbsm6sup57jukwpk"
Content-Disposition: inline
In-Reply-To: <Z4gGf5SAJwnGEFK0@kbusch-mbp>


--pbsm6sup57jukwpk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
MIME-Version: 1.0

On Wed, Jan 15, 2025 at 12:03:27PM -0700, Keith Busch wrote:
> On Wed, Jan 15, 2025 at 06:10:05PM +0100, Paolo Bonzini wrote:
> > You can implement something like pthread_once():
>
> ...
>
> > Where to put it I don't know.  It doesn't belong in
> > include/linux/once.h.  I'm okay with arch/x86/kvm/call_once.h and just
> > pull it with #include "call_once.h".
>
> Thanks for the suggestion, I can work with that. As to where to put it,
> I think the new 'struct once' needs to be a member of struct kvm_arch,
> so I've put it in arch/x86/include/asm/.
>
> Here's the result with that folded in. If this is okay, I'll send a v2,
> and can split out the call_once as a prep patch with your attribution if
> you like.

Has there been any progress here?  I'm also affected by the crosvm
regression, and it's been backported to the LTS stable kernel.

(CCing the stable and regressions lists to make sure the regression is
tracked.)

#regzbot introduced: d96c77bd4eeb

--pbsm6sup57jukwpk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRV/neXydHjZma5XLJbRZGEIw/wogUCZ5DYrwAKCRBbRZGEIw/w
omlXAQDBgeu+m7LZSkjFkp1AZv0g2BuJYTB3+jR3gfIKInXsygEA/RPqyDiFix9/
FzCbNsxxPIW+EnrJ8Hk/fHMvJDEG6Qo=
=oPrN
-----END PGP SIGNATURE-----

--pbsm6sup57jukwpk--

