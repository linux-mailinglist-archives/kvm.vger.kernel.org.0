Return-Path: <kvm+bounces-22452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 782B893DEEE
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 12:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3AF91F224CD
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 10:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB315D8F0;
	Sat, 27 Jul 2024 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="eeyBtK9h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nNHR1XOO"
X-Original-To: kvm@vger.kernel.org
Received: from fout3-smtp.messagingengine.com (fout3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A746A332
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 10:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722077924; cv=none; b=NifXih+6qRVDmPDItw8QEtTvbyVJmppNtkFXn26mc+e64AGfjKxeBhVkb4JQ9c0YRQv/fu6WMJZm5l6vMpP/GhVNxzWwrHMFpa64ozkO8WxMEDFqZ3Z43DvbyoMrOp1dPOvsQO7ARREyvA+LiZOs/FdU7wYFq8iWzc4tbn4HPRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722077924; c=relaxed/simple;
	bh=MC2CBBFhPOvcU0O404kRgYCL1n7thZAgncTMr8keoK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7YyWmbM0Y10L4S36FCYdNnwpxfVVKD4yeDQ6e0tngVZXur78MHw0lzP8geDyX8amQjghEEnAFZeKqRzrefEKprcjN46QQoCcqRdxJ6dt0/Ib0HQhMU72D1ksiz6rIkzdELqQBjYEOkICRWgu3Ts5VSRmO9ZRdvHG5L0ljy6Lj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=eeyBtK9h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nNHR1XOO; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id F2AC01380600;
	Sat, 27 Jul 2024 06:58:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 27 Jul 2024 06:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1722077919; x=1722164319; bh=IKD5f6Z61a
	e7MtEVXqCKj3u0ucVoIOZTWjoItrgGU2g=; b=eeyBtK9hrrPRVOHiqxfbk6smeL
	jyFTiP508iQqd2C8tbA5Q0CtloryYt8qD6mgnFqQfZUM5eV8Ha0TjD6gpMxS0fBL
	Q2HKHHW65HgSIpNDki0ufNFcNvHNflmPE3ZkCJDpxkeFhhMPqQcXBckCwcJ4gi7Y
	wyfadKpfmRvVxtBaLny4KX6qROuDBOwbKfH4dQLKWLthyV7IiwAHKERYsE2LMNXe
	deklOtzaoPDMBW7J8soB0UjPS2CxOFEwg4ln0MUvcyMnAYUIJBjAKbcEmqo+jNqv
	VUJUSfzU6qxegWcy3uB/jTshS8ZAQBOWAz8QYbrKno1dPwBgnAU1wWSuhUBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1722077919; x=1722164319; bh=IKD5f6Z61ae7MtEVXqCKj3u0ucVo
	IOZTWjoItrgGU2g=; b=nNHR1XOOgIvW4P5D8W1MC7vQ2eBiZckZ4ItcPGrOKilg
	mNpq/K0RA3RDfLOncSpK+FpGI+T9rrq3KaYAYfmUOzXhTU6Aqw2SGmm+2NQ6llCF
	D2yjKzBbtrPq+0vLPW7NxI5ku8xhYdFa0uhft3BqSjlU2/R1Gbf+0W89mU9xP1fx
	NyCvqutl8QR3DZ00kNVN4G7nYUHGhB5Hv0sG+KldWPzRBJSgrO1elxr4JTbzjxOs
	pEtLbHguS5vkV4x8+Vkigi0QsrbC+GH0O1+3oq/w4um+60oT2wTeG9u3eVHcSuuU
	ENptQ3mwgVjPqXhndF6A4Fg0UVXqWhWW/UEE6XIU5Q==
X-ME-Sender: <xms:39KkZk6kKJ-SiOk43uNwHGfDuqrvQWOi2I8xVI8FzanioDaT7j4pUA>
    <xme:39KkZl4lyqvpCY52mqz4OTtjd_c2Vi2iM9yF9xMohIfr_mSN16ssPGr4xMiTHtF6a
    NcEDTa19S1G2dt6lQ>
X-ME-Received: <xmr:39KkZje1rLAcqHZrmlCjEawjM9OmUyiKcNL7hXObaA4Vw1Xr0ElaEDZnkQgIC6IUUZjtOY8h5VRjd0CSeddjCp_gMQaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrieejgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesghdtsf
    ertddtjeenucfhrhhomheptehlhihsshgrucftohhsshcuoehhihesrghlhihsshgrrdhi
    sheqnecuggftrfgrthhtvghrnhepjeduueevteegledvieegleetvdejfeefkeefudetle
    ffiefhkeetvdeiuddugfeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhephhhisegrlhihshhsrgdrihhspdhnsggprhgtphhtthhopedt
X-ME-Proxy: <xmx:39KkZpL-72nUrrmJfNLZ2yKmhNUAhOA3Go7D0VYU_QXT0wTwXkYF-Q>
    <xmx:39KkZoJUwkCxZtudMafUajwsjdE9ytSobDXkXW5dircZu-1p68kN3Q>
    <xmx:39KkZqxjaU-K0snzerHHMSuBdhE4vvPC8iDT3cKiogpMtFXIgAxe0w>
    <xmx:39KkZsKJmfwdaxMN3d1y7ubCMY_3_uDfeSDkkbEngs5FVBvvyahbNA>
    <xmx:39KkZvWvHr0QNT90uIP6KHRNjp_faqZR4UJlBAvHnR-DQxnHHOEdbORx>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Jul 2024 06:58:39 -0400 (EDT)
Received: by mbp.qyliss.net (Postfix, from userid 1000)
	id 774813519; Sat, 27 Jul 2024 12:58:37 +0200 (CEST)
Date: Sat, 27 Jul 2024 12:58:37 +0200
From: Alyssa Ross <hi@alyssa.is>
To: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 1/2] Get basename() from <libgen.h> for musl
 compat
Message-ID: <b43mil7j4t5zc2l33vtrixc2puyxm5546fdnsefci7z2sditwa@z7h7jo3jgols>
References: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
 <20240727-musl-v1-1-35013d2f97a0@gmx.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="czvrfnwpeos54aj5"
Content-Disposition: inline
In-Reply-To: <20240727-musl-v1-1-35013d2f97a0@gmx.net>


--czvrfnwpeos54aj5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 10:11:14AM GMT, J. Neusch=C3=A4fer wrote:
> According to the manpage, basename is defined in <libgen.h>.
> Not including it results in a compilation failure on musl-libc:

That's not quite what the man page says =E2=80=94 there are two versions of
basename, the POSIX version and the GNU version, with differing
behaviour.

> vfio/core.c:538:22: error: implicit declaration of function 'basename' [-=
Werror=3Dimplicit-function-declaration]
>   538 |         group_name =3D basename(group_path);
>       |                      ^~~~~~~~

In this case, it should be safe to switch to the POSIX version, because
group_path is writeable and not used after this, so

Reviewed-by: Alyssa Ross <hi@alyssa.is>

but it would be nicer if the commit message was clearer, because it
currently reads like it's just including a missing header, rather than
changing the behaviour of the function.

> Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> ---
>  vfio/core.c | 1 +
>  1 file changed, 1 insertion(+)


--czvrfnwpeos54aj5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmak0tYACgkQ+dvtSFmy
ccApfQ//VOM05DDJ/DUQNdvCDLXVrQ+xHFgEz+sBTAOWFMRnadw+zW1shsk0MhOo
3QgcUHGA38p+waC5cg7EmhIEyNJKBuoRYbvoEVqUutT2s0wwT+L+HclPKLd1ANx6
yp1z8xPJGFWpLsyQEzQ8/wuCY0ck71zhvlAZwGw4FeiE/X9h6L1ETj94hviHVMAU
WqwVL4lQKKpcJeuJHaAKPigQgIMWVM2KrxdUb217p/AAFSQ/XI2E+tveUhfyy6bW
NQnfiYy2SZozRJE0n/UT6ztsi3DWIj2YrcRJjfUU79k+853I1OtSMdaVxYqKD08F
fdQ/Fu5gYmzJ3ithAg2cnsQ+Nx/gtlhutvf+dYR6MftcGN2UFAIvQbeN7MeSB10B
x8zUHsAFN3EIel9xphHpjaQy9XBK0vantTWuGSW8SrYGFBGXMVfx4/UrzUsnvdR1
7YN58SSX0cWwenN0IR6FcwabiQn0Scjccgi5/TziK1Gley3DPNzwakK78D/s/s42
ATlIEDtHlyCWajeLAKtDZodn2oAUolgyaJ2rhgCu7Fk432IbK9ZcbDje95jUadjj
7+ytaBbGMpfzpwzJHrcfJOWCMQR8eu39mzF/TwOa6rdCpFsahOyl844DiG7p2Mp7
khyVG+fH2/pY1KLDW54faupSI/Fajgt9iPypuDbnjCWAvaqc2II=
=teT1
-----END PGP SIGNATURE-----

--czvrfnwpeos54aj5--

