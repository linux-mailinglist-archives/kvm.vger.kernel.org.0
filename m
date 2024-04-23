Return-Path: <kvm+bounces-15678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D2C8AF3EA
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75C491F24976
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8D713D61F;
	Tue, 23 Apr 2024 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVLh/+KL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E0313D508;
	Tue, 23 Apr 2024 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889446; cv=none; b=sfFXTVfaCVSYnM1ODrVpt1DzZy6W/GN3nysKXzYojDLLFFjZv0pMBkWKoq+MKkpVpmTXavgz3VHs+JJSOoIdsqer2mTUx7QnYWeDYfUI7IKdyW3+ZIc5+NRUuVQJhAWb114Yc+doBRb577YUialOdFinozb7LYuTG2WwIBdxuV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889446; c=relaxed/simple;
	bh=vwDBeno2e/iwFzcx2Jptp5EtMai4XbyUfnQr/YhkQrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrzALommXWJ+PKzQgmiJmhAFbTmXjruovGj1ibVkbqlec1+faXfSwfLT1C/6Q1Hg7vE8UDRlfm4xbSL8E0lqf1+5QB06URHWPQUgldyIzmlnLa8hlH1OhGFyc+ygwP7IvXmL5aWMTuO4kV1FAz68A+BwxtryZATJpsvhfMXub8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVLh/+KL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04ACC2BD11;
	Tue, 23 Apr 2024 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713889446;
	bh=vwDBeno2e/iwFzcx2Jptp5EtMai4XbyUfnQr/YhkQrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVLh/+KL+A2ou4nm3BK8fIxsTnG3oFQSbd5XmcVW6hiwzh/1+NniqvRGIQM5yx3JW
	 kBx33egZjJTAqa6A4L6pK99raX84GYy60a/TP5jm4BhCbC4lAi97mA0UpgRw571BoH
	 DVvX8iFUUNCnJOkbLiuKtBsKzXvRLgl+IpfuW6fFktxuTiE4gZ2sFcl4+qvlpLdb72
	 EekG76DBEJFWlrQxkzqNUaVgJctSF/4Fovb8e5LEIxdUv7iJ1pm3H0GkViOGPaHMmQ
	 FgKmTJJgd4ZB5JuFhPcuDrtS8airnRfI9ySbu7v2FOTS5QhAElYWszg1qbhIsBp894
	 4HjwlFWe0RvvQ==
Date: Tue, 23 Apr 2024 17:24:01 +0100
From: Conor Dooley <conor@kernel.org>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [RFC PATCH 0/7] riscv: Add support for Ssdbltrp extension
Message-ID: <20240423-fresh-constrict-c28f949665e8@spud>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZyfNa3C9GxmtsB0D"
Content-Disposition: inline
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>


--ZyfNa3C9GxmtsB0D
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 04:26:39PM +0200, Cl=E9ment L=E9ger wrote:

>  drivers/firmware/Kconfig                      |   7 +
>  drivers/firmware/Makefile                     |   1 +
>  drivers/firmware/riscv_dbltrp.c               |  95 ++++++++++

=46rom what we discussed with Arnd back when we started routing the dts
and soc driver stuff via the soc tree, riscv stuff in drivers/firmware
supposedly also falls under my remit, and gets merged via the soc tree,
although I would expect that this and the initial SSE support series
would go via the riscv tree since they touch a lot more than just
drivers/firmware.

Could you create a drivers/firmware/riscv directory for this dbltrp file
and whichever of this or the SSE patch that lands first add a maintainers
entry for drivers/firmware/riscv that links to my git tree?
It probably also makes sense to create per-driver entries for each of
the dbltrp and sse drivers that ensures you get CCed on any patches
for them.


--ZyfNa3C9GxmtsB0D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZifgoQAKCRB4tDGHoIJi
0gtxAP97veR232X2TcwIa1suQQaYkJFQCQQVnjXfjQbNWVcPOgEA9snlyFRloP4v
YPfhoD5GS61aDZ1CUlxZJeAcLoQN/QA=
=j5Fq
-----END PGP SIGNATURE-----

--ZyfNa3C9GxmtsB0D--

