Return-Path: <kvm+bounces-20685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E37D491C3A3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 18:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A5EE28447D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230541C9EC5;
	Fri, 28 Jun 2024 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MX7Mj5hU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEF220DE8;
	Fri, 28 Jun 2024 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591591; cv=none; b=E1fEgGHQ6I8szd2AiqJ+kBiYjG+RwJVPeNRycko8EX6nUsjo8HClZ7k3N8L6TwxinP2D8k3mIpqt9csVccb1xdggSMRkcMMERgpwnRmlfYyy/eTBscF104rzflFiQdjifnZYYVRVZr6+1G5vVq3kfFU3lS6H+MMdPPb4Nwad2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591591; c=relaxed/simple;
	bh=LTxkkD/nY6lAd8Hm4iCQkiN/eHwDOA5Fki8VgmfgnRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3W/rVdYG0c5H+TgH9jp9qYxJU6QaSBjAWHJZdiBADOMR+2DDGRqfrMjecAU5CiHfJG18cFPDKSV7YBUfkWMTwkSTTKnQVMrFSN7XL7LgdW1TPoKjTn6Ggu4LfiSpyppoJdXzl9Jmxd49uZtD4zglE0yyMykbESumrkROha6UKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MX7Mj5hU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAF5C116B1;
	Fri, 28 Jun 2024 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719591590;
	bh=LTxkkD/nY6lAd8Hm4iCQkiN/eHwDOA5Fki8VgmfgnRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MX7Mj5hUhLiE91UIq2inljrT60PLH9e8l6QTgC6ZQNvAMBidqlAsUFcUWgh37xNtR
	 hYDylhmsqCO1JbsewHKDHXasQRX+xLjibcRc7V3aV9D/23ehealjzGCzLAVTdkVLs+
	 Qgmr2AIxylzGm8Vnz+W8zUvWobyOtbCGH3ImingcbS9miMBh7ILHe0QHegrE5SlZdD
	 K3KFM2wBj4ib6ehtDKUtfgNuCw2TQRbDywW1I+NIhYzzbYvRBf3Sy7sL8/WaYVsgAD
	 0V9b/A9JonF9gwm94KX6WWQwbU8dIQea/cXq/isAShfpX/FTIhMdkyb4uH/IWyJRZl
	 j1Piq1IPNhbwg==
Date: Fri, 28 Jun 2024 17:19:46 +0100
From: Conor Dooley <conor@kernel.org>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	greentime.hu@sifive.com, vincent.chen@sifive.com,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240628-clamp-vineyard-c7cdd40a6d50@spud>
References: <20240628093711.11716-1-yongxuan.wang@sifive.com>
 <20240628093711.11716-3-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zVY6bc51HzyyBUYM"
Content-Disposition: inline
In-Reply-To: <20240628093711.11716-3-yongxuan.wang@sifive.com>


--zVY6bc51HzyyBUYM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2024 at 05:37:06PM +0800, Yong-Xuan Wang wrote:
> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> property.
>=20
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
>  1 file changed, 28 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index 468c646247aa..c3d053ce7783 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -153,6 +153,34 @@ properties:
>              ratified at commit 3f9ed34 ("Add ability to manually trigger
>              workflow. (#2)") of riscv-time-compare.
> =20
> +        - const: svade
> +          description: |
> +            The standard Svade supervisor-level extension for SW-managed=
 PTE A/D
> +            bit updates as ratified in the 20240213 version of the privi=
leged
> +            ISA specification.
> +
> +            Both Svade and Svadu extensions control the hardware behavio=
r when
> +            the PTE A/D bits need to be set. The default behavior for th=
e four
> +            possible combinations of these extensions in the device tree=
 are:
> +            1) Neither Svade nor Svadu present in DT =3D>

>                 It is technically
> +               unknown whether the platform uses Svade or Svadu. Supervi=
sor may
> +               assume Svade to be present and enabled or it can discover=
 based
> +               on mvendorid, marchid, and mimpid.

I would just write "for backwards compatibility, if neither Svade nor
Svadu appear in the devicetree the supervisor may assume Svade to be
present and enabled". If there are systems that this behaviour causes
problems for, we can deal with them iff they appear. I don't think
looking at m*id would be sufficient here anyway, since the firmware can
have an impact. I'd just drop that part entirely.

> +            2) Only Svade present in DT =3D> Supervisor must assume Svad=
e to be
> +               always enabled. (Obvious)

nit: I'd drop the "(Obvious)" comments from here.

Cheers,
Conor.

> +            3) Only Svadu present in DT =3D> Supervisor must assume Svad=
u to be
> +               always enabled. (Obvious)
> +            4) Both Svade and Svadu present in DT =3D> Supervisor must a=
ssume
> +               Svadu turned-off at boot time. To use Svadu, supervisor m=
ust
> +               explicitly enable it using the SBI FWFT extension.
> +
> +        - const: svadu
> +          description: |
> +            The standard Svadu supervisor-level extension for hardware u=
pdating
> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull r=
equest
> +            #25 from ved-rivos/ratified") of riscv-svadu. Please refer t=
o Svade
> +            dt-binding description for more details.
> +
>          - const: svinval
>            description:
>              The standard Svinval supervisor-level extension for fine-gra=
ined
> --=20
> 2.17.1
>=20

--zVY6bc51HzyyBUYM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZn7ioQAKCRB4tDGHoIJi
0mVMAQCK/SejlGwyghvHwynQhnjL6X2rPW6tv4CtsmOgM3pYaAD+L/W8OKitFsGd
/L1I8rbFj1EVzu2iWs17GMSaDJIGZgU=
=ykY3
-----END PGP SIGNATURE-----

--zVY6bc51HzyyBUYM--

