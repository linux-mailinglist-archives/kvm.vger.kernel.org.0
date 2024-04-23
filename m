Return-Path: <kvm+bounces-15685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4099D8AF421
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F048128ED2A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA7E13D51C;
	Tue, 23 Apr 2024 16:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJJ55Plq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E951484FD9;
	Tue, 23 Apr 2024 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889823; cv=none; b=UK2X00LVFHjrfKOB3CE/g37HGyfDfg6dYt64XKusb4hFVBBFAQN0pg94b74RIikkCYgoXjx01/+gEgksQHvvT0BCy19WtS/4b38QWTrfrcjYdyISL0+u1K9MSLBnGHA99d3KOE0vnS8Wrli3sB+A8ru/abnDBQqbDoWxN4+n8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889823; c=relaxed/simple;
	bh=MDpa0KTXNqlwoWKZPytLuLDc/9nA7cch3N1o2TonBUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYJd5jJm/frA7nd7h7RTjnxDa6A8gznDeWHphnlr8d6sdSvRfQO3QfEOwTJsjQ4KZzWH/I8Ekuey7QY3eNBpTHLGDCnl01CU7N6qsdc0fWacO1v2oqOf3W/HR91rZgV9dFQ9eI62dGCIpRTp0R3+W6mUEfbmQzH/tspl1Hdb9qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJJ55Plq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7297C116B1;
	Tue, 23 Apr 2024 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713889822;
	bh=MDpa0KTXNqlwoWKZPytLuLDc/9nA7cch3N1o2TonBUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJJ55Plq98sqsZ327NH89cZLGiWfOQXOGbgaeWDVy2xJvyGhWSePAc9eheVAtGBBv
	 I0ZNYJ6ma5UhVYt2RwFK/qBvcoHb9s5yeX024ajoG026WhmPfCTmEfqFA51jGq++b1
	 AUouMd+mghF88GCpyzxqm9zWvHsxIAj/Dop2oeW9RuNW2diC/p+3rEWQHWG4QAlgET
	 tQQ6cVvf5cLEulSbQlTqEjaztjIFM1iHfo37RcbWM9nNpTykUR/NbgWsnqF87+yEsp
	 uiRlCk3MnSiJplHkxJNq+gELJYeRVYXq3KVN80eYi5UO6L96qk/XbQeCKvpBMvF7V6
	 0cTRYY6vel0KA==
Date: Tue, 23 Apr 2024 17:30:17 +0100
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
Subject: Re: [RFC PATCH 2/7] dt-bindings: riscv: add Ssdbltrp ISA extension
 description
Message-ID: <20240423-poser-splashed-56ab5340af48@spud>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1mo6dkSKqd+bW1ie"
Content-Disposition: inline
In-Reply-To: <20240418142701.1493091-3-cleger@rivosinc.com>


--1mo6dkSKqd+bW1ie
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 04:26:41PM +0200, Cl=E9ment L=E9ger wrote:
> Add description for the Ssdbltrp ISA extension which is not yet
> ratified.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <cleger@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index 63d81dc895e5..ce7021dbb556 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -147,6 +147,12 @@ properties:
>              and mode-based filtering as ratified at commit 01d1df0 ("Add=
 ability
>              to manually trigger workflow. (#2)") of riscv-count-overflow.
> =20
> +        - const: ssdbltrp
> +          description: |
> +            The standard Ssdbltrp supervisor-level extension for double =
trap
> +            handling as currently defined by commit e85847b ("Merge pull=
 request
> +            #32 from ved-rivos/0415_1 ") of riscv-double-trap.

I see the proposed ratification for this is Sept 2024, and is marked as
"Freeze Approved". Do you know when it is going to be frozen? Until
this, I can't ack this patch. I had a look in the RVI JIRA
https://jira.riscv.org/browse/RVS-2291?src=3Dconfmacro
and it looks imminent, but it's unclear to me whether it actually has
been or not.

> +
>          - const: sstc
>            description: |
>              The standard Sstc supervisor-level extension for time compar=
e as
> --=20
> 2.43.0
>

--1mo6dkSKqd+bW1ie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZifiGQAKCRB4tDGHoIJi
0hV7AQCwM5lnZX7Tg+OYIQPsp0ouge2bHBKrLAWEl9at7FgtOQEA1eAWOXlr6fah
DurXskN1BrUnp0Wi8hkBvYt8NvTCmQQ=
=Tr/y
-----END PGP SIGNATURE-----

--1mo6dkSKqd+bW1ie--

