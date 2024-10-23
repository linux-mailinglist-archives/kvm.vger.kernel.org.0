Return-Path: <kvm+bounces-29569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 826FB9ACFC6
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9294F1C20D52
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345BA1CACFE;
	Wed, 23 Oct 2024 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ynm67bTS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D734436E;
	Wed, 23 Oct 2024 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699880; cv=none; b=oFgpsB+FOhyU/n5qBr7vvGjTcfO9dTh286BH2iuwK+TFnCIHbP/u1ZrX+/mKzjgTIApn3auhwnZ72MlsnV60DtFAnrbce/m8bHSteyPR06X8C9OpKDPiyLWFx1u1HRhbAGzQTYHdnCEG8XZgqJi5JssRVzuKFNI5t+t52uNcO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699880; c=relaxed/simple;
	bh=ofJ96UZAAIntxC1YhWRS2QEXt54gNQotCCCiFxdd8KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZ5WJfOPIGbUkAdG5GVMDJ824WPgEGS6QBSsnvt8xfYbMtv76Kh/WtJjKeOBMxBJMWAp29KhbeHqkC3ABX/czwwe8afomT4yAOWJgmGPUXe8HkeVoEdkTtuJ9iyILJnza5w2Mt2l2FIhp6Mi4w9XKlBDFnr1vbTS0BBv3jNUvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ynm67bTS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81C8C4CEC6;
	Wed, 23 Oct 2024 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729699878;
	bh=ofJ96UZAAIntxC1YhWRS2QEXt54gNQotCCCiFxdd8KQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ynm67bTSjGgo4viJIYJcReIZm/PlEi7seZsZPmerhQRMpWnXUyfA1OHG5CQ2ex9O4
	 zzJD9j4dkHU8lLf+0KWbGRpEeUwr3oMsU4+xdPFH8HDGPPSyl5V5wp+EqGIosuBL2k
	 9tSQ6mvxiQHXvv2bMKHCsIO3rjvkQaZQHFAH0QAO5F/w1lps47Djel/iRIoZk9iY+p
	 pfciqBQ1Q2l8tYAIa1sUFApq5+N+jU4WVKr0OqHeWHuTUXbfGTdedz8eOHhBg8USf4
	 k+4eOJpc7UHm3DctOlpgVCVj0wRGO2lJnzifBG/OoJk5JdwOvNucvSWN0N8o8DwEr3
	 7NG28X7ShNcxQ==
Date: Wed, 23 Oct 2024 17:11:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 03/37] arm64: Add encoding for PIRE0_EL2
Message-ID: <d69ff36e-0767-47c9-a3f3-70105faef611@sirena.org.uk>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Yiz9uhNUAoNsiMKh"
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-4-maz@kernel.org>
X-Cookie: A bachelor is an unaltared male.


--Yiz9uhNUAoNsiMKh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 23, 2024 at 03:53:11PM +0100, Marc Zyngier wrote:
> PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
> regime, and it is sorely missing from the sysreg file.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Yiz9uhNUAoNsiMKh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcZICEACgkQJNaLcl1U
h9DvXAf/bw9sXwI8iYQc08VrIKiCzjsc/EOs/1zq2RYeCcHVkw5EeQyyHzEBPXhQ
PUteAGazVnZkZyA0O5eaWlKqHepxXFttNSQw+EWDX0qFuyFGgidhoWAUJ8vTCKEF
d91N2lZ9YVz5mufCkKrCQ/952AW8Mdr8w951kvGW3LzdCO52mfgVz0a7rHVmvsyA
C1BPkbMTzwdW06GCmIPOKiT9HEMXL63/XBUd9wBfCyk+MZmerY6ULVPyfY4fbKt9
KiPtdQIZbg+eofwEctUk9LhA/rtD7mIOo6HZSswKS3wUCfNd58Sdr+Wg3vjXadJE
GYb1J9ymylSlshUshmunGk7HlVDf6w==
=qW5L
-----END PGP SIGNATURE-----

--Yiz9uhNUAoNsiMKh--

