Return-Path: <kvm+bounces-28417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2AB998415
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7257FB20D26
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7A81BE245;
	Thu, 10 Oct 2024 10:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOKhVDT+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6EE1A00F0;
	Thu, 10 Oct 2024 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728557165; cv=none; b=WV8Na/f394kjcxsG/NcUjMCiXkTYuiuE0mQoGMMBdJV1LU/xdQf1Pz1DwbHfvebxPHtwIRKpmB/r79TW4x6zB9ovEWXwrMaifa4rHu9tiTPNLrCVUnxFrYDXgk9n7mUz5cw18PycsWN/Qttpmyebu6U/R9Kbz8t8EeqarGJLRNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728557165; c=relaxed/simple;
	bh=1hbqfV38Oeql7JAHRpKai5VwBkGsJMwFhotedx900xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbZc3aIQQXJK2jsYxKNT0gt3/yLjcYh9HMLI7OWdpGAC9OV6Dypp+1Vz4+Kizu90nBCCkjqaEXgUg2QYAcaeoGj6wrDpTwVQV0WfjpsdbZOc+zNX6iOXJajJhiOvxt77F1ZG/ULAYhJ/dRau9BPgctZH6oN2ukQmNPSrKikY200=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOKhVDT+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDA2C4CEC5;
	Thu, 10 Oct 2024 10:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728557164;
	bh=1hbqfV38Oeql7JAHRpKai5VwBkGsJMwFhotedx900xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOKhVDT+F9GjnOFt2owYmYPxrDcJvyejdmlcCOConVrByOg5U+U2eVpQ686f4p1/v
	 P2UJXPGakRhShhKc9nGM+BE+fD340MqPBB72GNYUCARjkYY/l3z53f+uG/jT37x5X/
	 MWUL8QsXMmsUdDoIAHRF16Ds//fH1bnCTbcq5CO4fENySKw66wh+OvFnDbAXT3lsa0
	 QaPwGkyKvpQp1wOcR9G/oIY1bynCxtbcAkrmJfYTrCdCYAyjG7CewGB/O16AjtweAw
	 HFsz8IJ2UccSk4MBeh4ZwyLZWeqc8D4SV/8B6QWzV5hsTm9pw4EASRv3LfCbmA9WO3
	 trQoa2IXStXUQ==
Date: Thu, 10 Oct 2024 11:46:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 03/36] arm64: Add encoding for PIRE0_EL2
Message-ID: <ZwewaZ0mFXri2u4A@finisterre.sirena.org.uk>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k+saYBuh2f127ZqX"
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-4-maz@kernel.org>
X-Cookie: Editing is a rewording activity.


--k+saYBuh2f127ZqX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2024 at 07:59:46PM +0100, Marc Zyngier wrote:
> PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
> regime, and it is sorely missing from the sysreg file.

Reviewed-by: Mark Brown <broonie@kernel.org>

--k+saYBuh2f127ZqX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcHsGgACgkQJNaLcl1U
h9CJ7gf+I1W4GqH5oXVeSjO0ctlfzQgciQuq4LUrTTTUEK9OBwlCshH2qGuENEMC
M7Glh1ZX//Pu4ImK5NgPRPc4qHog2XEMD7rc7nOgL2+QA31p1tfHBm73lvuNc0x3
JtsIAFSpUZO0iYBPouXSiClLjm/c2sbdrK4WjXOT3tbFe91RmdxYhVLaX29jpQEa
R3xUAPmHc1eIGZe3x2EdIpwwzNoHMv7uYQob1gpl2ugFabQDHrGDsuNlkVZZr40Y
qvnP+v2LILMwatW+b1BvgCciNyVpY7DfpGcb7AV4ItdAgGJici0PgbxN+JZ26BFK
IRZqCeNHB+N4oGBGMAu/KyKgCSoVPA==
=xGu6
-----END PGP SIGNATURE-----

--k+saYBuh2f127ZqX--

