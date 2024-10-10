Return-Path: <kvm+bounces-28462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5993D998DDD
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C226B2B791
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF261CDFB6;
	Thu, 10 Oct 2024 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTcuAOF4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6516F185B6B;
	Thu, 10 Oct 2024 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577245; cv=none; b=nhdxUydbbtQ8OZYhy4iW0FyD/f7GyC8PxJynkHDitLJqjbDC3IPJ8+HIsBT2ovYisiK8YspwZvwb7kfBbtqsnya6aIguypIoAMyLk1IoX7erR8ovHFw6gUJiEODPa6BHJqO4ouOHXCbFEqPj2soYoBJ8dy0bU+hxqrfUFjTS9uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577245; c=relaxed/simple;
	bh=1TMPxMWmvd6Kf4NRLsvezV5L9HKWRBqdlpJ2USYyLEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BP9HPhiPjm9XaWnjN2SVyg4xder0jJDBXhb6KSG9bEdoJxnXeICnyWb7j1qrg/UB08hjMZTCCOtCGeey2h86sa5a03haEG1QHGT/2nHks9PBxnLKq2dKhT6BGKxSOQxI/rkKheNdpx5SFMUFXih2G5qLHrp0aW0aU9wZav8jTd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTcuAOF4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DD8C4CECC;
	Thu, 10 Oct 2024 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728577245;
	bh=1TMPxMWmvd6Kf4NRLsvezV5L9HKWRBqdlpJ2USYyLEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PTcuAOF455dLBeILPFIyJjVIb6QjIRJFHaig2+Cqq5A1u5/tpqyMwCO39yKuIqAlg
	 kOqlItq24BeMxcQqnU2mGWvWOmyVfLFyXirX3MX0mkv5Zr1q46MssxwwaQQ9kq7jLC
	 SqUyD9ymaj6YUtpJsNHByd07qff9KkBe4TI6ISCNVvVbbCPHGFC5Hcq/0dRGG74Orc
	 tlbAhUCsxdtRnZo3zQC6euqqwjAO06BR5ErFMYkBQui1xQJPsfSNma9fNIqvuLsZTP
	 x+3Cu2oB2L8zqjsYiqJLtt5td+aW8VvmakGg2bt2FUmN6Ld07hyuam+yEyN9irfmBJ
	 1nU5tDcVRSAyw==
Date: Thu, 10 Oct 2024 17:20:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 10/36] arm64: Define ID_AA64MMFR1_EL1.HAFDBS
 advertising FEAT_HAFT
Message-ID: <Zwf-2eW-ypRTZXfx@finisterre.sirena.org.uk>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q4WValHa0s1+hPNt"
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-11-maz@kernel.org>
X-Cookie: Editing is a rewording activity.


--q4WValHa0s1+hPNt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2024 at 07:59:53PM +0100, Marc Zyngier wrote:
> This definition is missing, and we are going to need it to sanitise
> TCR2_ELx.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 3c812fd28eca2..8db4431093b26 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1688,6 +1688,7 @@ UnsignedEnum	3:0	HAFDBS
>  	0b0000	NI
>  	0b0001	AF
>  	0b0010	DBM
> +	0b0011	HAFT
>  EndEnum

This is correct in so far as it goes, but we are also mising HDBSS
according to the 2024-09 XML, plus a couple of new revisions of ETS.
I'll send a patch doing the full update, it should just be a trivial
add/add conflict.

Reviewed-by: Mark Brown <broonie@kernel.org>

It tends to make life a bit easier to note which version of the spec is
being referenced with these updates.

--q4WValHa0s1+hPNt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcH/tgACgkQJNaLcl1U
h9BewAgAg/hv4R39tRrvxenHo8RtrEfIf/f2jS3aePgmsbrWspqBl0gt+J2BdsIb
FecMHHcUpPnUVLMbvJZCYFdCdo4NyMT5Rm5+7GIzFRxLVyzRMcbDsLMZKh+ufb20
2iOegrNkRPi3RuBYoU+R45wo5WtD7HCOlm5U0E2ai7gYgjxzKaTWQOPToRmfuYum
Q2Wt0cpWzI2xFAGLoqt/+8T9FPgV2FM2JjzuuRFbPjoW5T1E90A9F4h6sP3MdzZr
a3ZQp5fE1gAOlquDUFqPxMWi5sCHrnqT3TLSZ3XWQBLh1EIFL8zAx/nilLbWURnW
+39qiG2mtS+Vdx8rHxttdnEer5wyBA==
=Jh8J
-----END PGP SIGNATURE-----

--q4WValHa0s1+hPNt--

