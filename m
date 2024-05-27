Return-Path: <kvm+bounces-18179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F2F8D05D7
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 17:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 218062887D3
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 15:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5061973463;
	Mon, 27 May 2024 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbtSOJS5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFDC1E868;
	Mon, 27 May 2024 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716822558; cv=none; b=c174cK6ovm4KQIhdXZKnQbldXRyUfMrBWrneLzgE3E7lgFgtSKiHWyp1GTUignG3WjAFlapxtKWCtFTTAUJWnhW48PILQ/OGB1ZHtP5t+1GlvCu+ECE/HhjBbzfgj0jARNdr5U905/S7ekUjvOSfnQvhQJJPi3moyR7KViyeDYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716822558; c=relaxed/simple;
	bh=YuKxD3bWQ8aYWzULrWddjuARczonPYhNEB+CaCLpbT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYu4V9TaJD1K4HTenRYP9bpXnac4BQlBRyL/TOtmDQjO2b3/7O7TxmpJFnpDCAULxYWYhgAJG/PKLl4bCwdIZY+pcR2Yk5oXcLpMOI4IGKFTDC0OvvDyo8XSX5O0kOLNRLL93B2G0wruxYKNr2psd0Fh5u88F03cGzSZHRN73U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbtSOJS5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D29C2BBFC;
	Mon, 27 May 2024 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716822558;
	bh=YuKxD3bWQ8aYWzULrWddjuARczonPYhNEB+CaCLpbT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RbtSOJS5A0pxbhhg/T2QRACi/3qELIIl8uDyGzpJ3dNKNbzcNWSr1VSk3Bq+S71KQ
	 //wLknjrjCT3MPDI9Z0TuqVRrwd/nAllBflc5Cfs+g1CtRc2di7xgxJ8reDR+HBrNT
	 h1z5IIKT5V919t72iKuNeAElyVwOr3G0ya5mWiRnl8GsZ49TLpZR8o7zHsMwVw2IRG
	 zmEtR3AG5NgtNbxL9EQU1kBUYNLUk2qaHg8a9dn6GRJ0KNBfcetBxHw2nIkqmDCJuE
	 04Ho9cLZezkdeoXMGmPJzXkX4ck/JWvbCk4UC4PIJg6NtfsdE9IWJm7EYiO68i5jLD
	 nMsUxBi+WcFSA==
Date: Mon, 27 May 2024 16:09:12 +0100
From: Conor Dooley <conor@kernel.org>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, greentime.hu@sifive.com,
	vincent.chen@sifive.com, cleger@rivosinc.com, alex@ghiti.fr,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/5] dt-bindings: riscv: Add Svadu Entry
Message-ID: <20240527-widely-goatskin-bb5575541aed@spud>
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-3-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="39tUOd5aicq+YFEC"
Content-Disposition: inline
In-Reply-To: <20240524103307.2684-3-yongxuan.wang@sifive.com>


--39tUOd5aicq+YFEC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 06:33:02PM +0800, Yong-Xuan Wang wrote:
> Add an entry for the Svadu extension to the riscv,isa-extensions property.
>=20
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

I'm going to un-ack this, not because you did something wrong per se,
but because there's some discussion on the OpenSBI list about what is
and what is not backwards compatible and how an OS should interpret
svade and svadu:
https://lists.infradead.org/pipermail/opensbi/2024-May/006949.html

Thanks,
Conor.

> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index 468c646247aa..598a5841920f 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -153,6 +153,12 @@ properties:
>              ratified at commit 3f9ed34 ("Add ability to manually trigger
>              workflow. (#2)") of riscv-time-compare.
> =20
> +        - const: svadu
> +          description: |
> +            The standard Svadu supervisor-level extension for hardware u=
pdating
> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull r=
equest
> +            #25 from ved-rivos/ratified") of riscv-svadu.
> +
>          - const: svinval
>            description:
>              The standard Svinval supervisor-level extension for fine-gra=
ined
> --=20
> 2.17.1
>=20

--39tUOd5aicq+YFEC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZlSiGAAKCRB4tDGHoIJi
0rsyAQDVctvH18CS7Wmm09E45EARmF5ZCi1dVq5wi3eKs6RM2gEA4XNa7WqLM3B8
qQI+GhZGvFqrbLnnav9sXWDnIHogkQU=
=AIHm
-----END PGP SIGNATURE-----

--39tUOd5aicq+YFEC--

