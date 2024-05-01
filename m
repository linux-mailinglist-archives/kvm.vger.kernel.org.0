Return-Path: <kvm+bounces-16327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7096A8B8826
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FD851F211C4
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8E05490E;
	Wed,  1 May 2024 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opacnROi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EACD535B7;
	Wed,  1 May 2024 09:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714555974; cv=none; b=cC6XmZ5ERPWkGR9Trem7Xge2MFixIXz43ENDH89U7aWNMaj8wHS/nZ7+VZN646PG/Bj9QR4u+MxvstRfI+fLeQMM4gIZAJJD/OQg+j4e0jKcTHjKvdwXTW353zzDP96oT3peUxmM6dwKEsKAKjOMCyyjwql08rRVerpCOELZnzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714555974; c=relaxed/simple;
	bh=5YH+MmCm3Gjj0HC8Tjm2tLqYxUcTFGdd/LlvFnv0Zmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCgPiRHECL+aG/bChvHLc7js8wgznUaB+aBBxWbMYO9Rwxls9p32OULeDPWEoz3s1fKMw+PNH1pI+TtIld6lidKsOoaCKNq9btXQyCj48+9IeuJ1/d790MXDkx2C5zx/cdQqcm9P/QepGafYWNyStEn3qp1eqbYyuLlaRjSkEVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opacnROi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB76C113CC;
	Wed,  1 May 2024 09:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714555973;
	bh=5YH+MmCm3Gjj0HC8Tjm2tLqYxUcTFGdd/LlvFnv0Zmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=opacnROi5vN+SdVTQqnNOx5Mdk6i7iuTBhYvkto9/M+VDpoBgYQdQ2+9ZFbtVguAo
	 rESrV46brivLuXaaHZgP3nfKDiBN2GX5OiqCOLXaCkv5YakDFU8tL0weJpGk0hc2dm
	 ToRqGD/wW+3aelUUq0M4tXadp0IcMbVJkCkwdmibdb1gEyiQ2dN8DswBcD4s+WXFQE
	 s+nugEj0NTlAPfI9IN5BKIL1+y0eZpXbm9rFp3KpyJ4b0L1VHnw98cT53kppGUuHgD
	 w7dwiwCRNW09IwFm612/wkaST8QXtVeUIv0vKlbTIy/eOzlcDWDDGPJ0jFjTBC7TEj
	 CbGeMKrLeOs4w==
Date: Wed, 1 May 2024 10:32:48 +0100
From: Conor Dooley <conor@kernel.org>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 03/11] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
Message-ID: <20240501-waltz-choosy-59e08e6a1099@spud>
References: <20240429150553.625165-1-cleger@rivosinc.com>
 <20240429150553.625165-4-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="342icLqh9B/uSr91"
Content-Disposition: inline
In-Reply-To: <20240429150553.625165-4-cleger@rivosinc.com>


--342icLqh9B/uSr91
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 05:04:56PM +0200, Cl=E9ment L=E9ger wrote:
> The Zc* standard extension for code reduction introduces new extensions.
> This patch adds support for Zca, Zcf, Zcd and Zcb. Zce, Zcmt and Zcmp
> are left out of this patch since they are targeting microcontrollers/
> embedded CPUs instead of application processors.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <cleger@rivosinc.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--342icLqh9B/uSr91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZjIMQAAKCRB4tDGHoIJi
0uwCAQC71T4oeRQGkk9Ig895iznNgUNZBhUBni4qknp8a7dg3QEAtnqR3qU/PwpZ
kLiHt0NXsVwN6O0JCML1X+/ptOrA1AM=
=lQyI
-----END PGP SIGNATURE-----

--342icLqh9B/uSr91--

