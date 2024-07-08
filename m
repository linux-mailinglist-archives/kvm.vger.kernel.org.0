Return-Path: <kvm+bounces-21121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8C292A87F
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 19:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEE92B20E00
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A6614A0A5;
	Mon,  8 Jul 2024 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeMH0por"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A53314A08D;
	Mon,  8 Jul 2024 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720461224; cv=none; b=EnOG30PRZyVjjUnnm3y620xQD5+wZxNPC9bpeZvYNrG/drSo3yY2GYwjX8VMwIOPWu+BDsAw5lozqfVWLSRnjpd4d6CUrgaLLF3Jbz0/ZOXj/fcIcghmkvqUxy/fbY0m8i+GWWVCYpB28xDb5XEHigP02gLvs9EwvIbmz/L/qFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720461224; c=relaxed/simple;
	bh=C3GwnTURDmi547NFIqqGEDrXp5T993LZq/8bfiulStw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjJQrTu3R4VkHYqjS3v7FkFMVPv/NFHdWhqJEmzcKpPxp4UkTR7yLLXyf5KpXW4ApcP3JntCsm/vzLTnPZteluEI4GJrvEc0RyY0tMMpnIDq2lAE5tLuymEbk2DPuL3D9KcVIeQ7x3SEvUY4x13vVA3iZKEA5kPPTWea+lhbUds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeMH0por; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FFAC4AF0A;
	Mon,  8 Jul 2024 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720461224;
	bh=C3GwnTURDmi547NFIqqGEDrXp5T993LZq/8bfiulStw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XeMH0porEqwTosisdHpt+a6GgOqsNJbNdTV5WaP/bDuPnR3WolMrfTvbgWZ17LLmW
	 0yYp7EWKEQasUav6JRKRCC5lJZvovErHA23Oke3J8fXcI6xzime0l9rB6B5D2uw90P
	 E586WU+GI4iL587/d9aB4LhhyDMY8Ssosl70iPKEZNFxfFxPIdQdxDSTWyniPFhWiz
	 KsBD0W5XRQn5+feorxlKTu55uJBximr4VBr04fV7Kselsd9Sl7suOkeO5sNNecR9wV
	 5QiADd5uDza0H3N5ZWKhUdpUkiT/qvHH49SsPYWsq7G+pLXso7TABshk0aQA4Nev8I
	 d+zcmv41zSI4Q==
Date: Mon, 8 Jul 2024 18:53:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 0/7] KVM: arm64: Add support for FP8
Message-ID: <68d26d8a-f2fb-4652-ad89-d959e5fedcc8@sirena.org.uk>
References: <20240708154438.1218186-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ddky+SsFRvKacQta"
Content-Disposition: inline
In-Reply-To: <20240708154438.1218186-1-maz@kernel.org>
X-Cookie: Many are cold, but few are frozen.


--ddky+SsFRvKacQta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2024 at 04:44:31PM +0100, Marc Zyngier wrote:

> Although FP8 support was merged in 6.9, the KVM side was dropped, with
> no sign of it being picked up again. Given that its absence is getting
> in the way of NV upstreaming (HCRX_EL2 needs fleshing out), here's a
> small series addressing it.

Thanks, I've been prioritising SME since this was going to conflict with
it and some of your comments on the prior version sounded like you would
block things on a bigger refectoring of the interface with the host
kernel which definitely needs to wait for after SME (I do want to redo
the whole way the host stores FP data for threads which would be a good
time for such a refactoring).  Hopefully there'll be a version of the
SME patches suitable for ABI review this week.

Other than the issue with restoring FPMR for the guest these look good
to inspection.

--ddky+SsFRvKacQta
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaMJ6IACgkQJNaLcl1U
h9BXTgf/W38hTFwCYiS00hP4UdElxP4GotpS01nxhulGVSE8VDggFzcY+8XGNRNG
CcgWIkU8GyXZpMTq55Rr2yJ47IZByJQJqSsImqeiPKLwi5/+F9x4XcoxVj7XAE9V
BzG0k9JWH3M2FfIxcYvmyqV4d3AFid2AlF6xX4VAHWA2gbf92PjxO+q6bnAOtYpe
xoY1puZdXY+wLotVnQIZz3yI0/5ptqCp1fSJWErTr3nMC5igyIFbE5+MKWxaqT3L
s9POfUHR3wBK224G2gzf0fPTRaKZsrEtx8zgTHJ0ociPmO71imF9+TIwjIWCEH+c
MDONfXaEUFz4Hy/LoFsqi4nuwzF1Pg==
=38GM
-----END PGP SIGNATURE-----

--ddky+SsFRvKacQta--

