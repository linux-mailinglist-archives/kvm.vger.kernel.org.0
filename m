Return-Path: <kvm+bounces-29568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 171FA9ACFBD
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95B87B23AE3
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E8E1CACE8;
	Wed, 23 Oct 2024 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmoPNK0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D974436E;
	Wed, 23 Oct 2024 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699769; cv=none; b=GvMhjsqskLcESKHJc56ovDJIXMg2T3l+rQackGv8mwE+XonxTT63EBreW5e1SFnLtF5m1zl8MThk7qh0zPtuMGWiQ4t7TgGEbNIlVWOHOTlKDd4HREfJftbQYsD2/J1eeCUVgk1yh8cclwiiESzBwXMyJ9r4tZBwx2BCM0yzIlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699769; c=relaxed/simple;
	bh=n9CFz8/vOnmhIP7XRNL8O0kq9oZVGYkCgzkVNRTU0os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGW9gjX1Ie/ZK6IXGjQf8JRKS9FYIZ8vCA6PdWoOKmo1UrwL3X7O0XDEhdfZbqKjEn7aO/38K4pLRHU1ZjCauEuatcxI7jdheXarsWrEPj9hbAB7Elhoq4XfhxewC0Fht+75XHFKh8iXTnnGxbRc0r9fe21UzG/g5PfVlQcZD18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmoPNK0N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8D5C4CEC6;
	Wed, 23 Oct 2024 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729699769;
	bh=n9CFz8/vOnmhIP7XRNL8O0kq9oZVGYkCgzkVNRTU0os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AmoPNK0Nsd0z81eyOINYWD1x7VjEuzVcwQy6+mG7obZ//QlkmYkxCieOgrlHEH9UV
	 lepgKko4MMKnh7m/YGqgnfaB3uWXJu4/ryUlZXJ8Bsb3RgTf6opZ8rZMI8apJmvbou
	 tXj5JBdl3NSwqwsNZrE2ivQzIzsrAlJ5bH9zXJjC041F/EB4YjDLTTJOqQ3nJgoN5h
	 FxV8FVfxZd2u6/0clzFBGtyxGPgEKuVEDhrkBWro2m59bqs/BVixmBBQ6RpqVuqK1/
	 QsmraCS8XxcF5/1cl+Uy3uLHBti4cs1s4FgvrSxxKmxqFPLJuTPqm74ctgElKKV+Jn
	 MtXkSW1FOxQVQ==
Date: Wed, 23 Oct 2024 17:09:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 10/37] arm64: Define ID_AA64MMFR1_EL1.HAFDBS
 advertising FEAT_HAFT
Message-ID: <4a30bfa6-f4d9-4aba-9cf9-3da3820d1c82@sirena.org.uk>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zTWiFabwS6Q+EPcc"
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-11-maz@kernel.org>
X-Cookie: A bachelor is an unaltared male.


--zTWiFabwS6Q+EPcc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 23, 2024 at 03:53:18PM +0100, Marc Zyngier wrote:

> This definition is missing, and we are going to need it to sanitise
> TCR2_ELx.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

I did give you a R-b on the prior version.  We also now have multiple
patches on the list doing a full update of this register, please pick up
one of those.

--zTWiFabwS6Q+EPcc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcZH7MACgkQJNaLcl1U
h9BCkwf/eGCXEznpZaAHD5ICBMoWRTJ9Qc2+3a3q4Q5wlIN0t15c8dgG62kaVvQJ
2/fwIHBln2QbFvzpgTYXkZr4fV0mFxlJv0yrK+W0oJS+PsFkKhGiJd1QmvokICUc
nMxD+VNkKFa4SXpmTGMxDumhGOEw2OR4RuB8MKsEmwZgo1wASGTf+QwQUEm+b16D
vOzcafUYFkXotHP99s0Mq5Thcj5V0yn6wlrTOpnQo+QmhdKuDRtXkwPKuoEEnSS1
WnwGR/EsZ3IELb43obAV+P3TGWuL2WnR4r0aIVYh22QCoobE5R34wc8A4tVa6ovp
1CSFbw3KqIf1dqcueiY3Pk+074TeOA==
=Iq2/
-----END PGP SIGNATURE-----

--zTWiFabwS6Q+EPcc--

