Return-Path: <kvm+bounces-18942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3248FD332
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53489B22EBE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5AF18FDD3;
	Wed,  5 Jun 2024 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5XCRj96"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4DA188CDF;
	Wed,  5 Jun 2024 16:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717606504; cv=none; b=D+B+Mydfx9M82x4iPNVWZf/7frXQiG/3g1/f477iGG87zrsblpwWd8E24xKDnVtwIN828x/Hp5kMm2EDcwR888qdt/VBAUM9UGYbn4V9155KNQRnAEkkWpsDzISEvUoIqOtDuh+/K9/vBHMKPBPTfuhqCtQeumJuyzZtEPLvY9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717606504; c=relaxed/simple;
	bh=BSnD9wLTtKbSKikywrrQT5l9mkvhTFfOEYd7ndU0zhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQ15AAeM6oN2klyC0vFlO1qBf1EJQnT5GutE9Lc7tYB9hJy+A6Sl0N46Ew6mI7alnetITM8Xh9czw/eiXLUZuz4wANj97E1BEhE+0UMGItlFlApceC3QBbCtJ5bKE/AMVhxpY2LrmQ9ELejh++PmDEmAHYM4oqWRQN/n9B5eMd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5XCRj96; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDE3C3277B;
	Wed,  5 Jun 2024 16:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717606503;
	bh=BSnD9wLTtKbSKikywrrQT5l9mkvhTFfOEYd7ndU0zhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e5XCRj96A0ShjEuilfFCPUt4VolsLcZBGYj5R/qcp0O9NFkBlt7kYC/ztC/cGPfpD
	 iGJFKR26NPrn5yfFhuWHMgyr9kg+rhDoxOX4Vdhx6kfTxWbqItMTK+6YiOnBXBglVC
	 HWWR9KaQxWJJreCrwXjsAxFwE8TN+gC0TLb4INkB82SnBIhlAsDGifzXeaeB7M7E6h
	 WYAbBMfA4GdYLqlVDemcs65Yny7KeRuSvlouZvDIZPP8CH5Q3FFNoDLqikyM4q9aFT
	 3ywJLHXhmbWc63yE8SD5XmV+sSwDwAfj4mx+b5SM5Yi6lqKQnhd2Wfq6oW5/OTJUec
	 Wf037EwFDJ3Ew==
Date: Wed, 5 Jun 2024 17:54:58 +0100
From: Conor Dooley <conor@kernel.org>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	apatel@ventanamicro.com, alex@ghiti.fr, ajones@ventanamicro.com,
	greentime.hu@sifive.com, vincent.chen@sifive.com,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240605-atrium-neuron-c2512b34d3da@spud>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MuN5kP8SHGJqYdTt"
Content-Disposition: inline
In-Reply-To: <20240605121512.32083-3-yongxuan.wang@sifive.com>


--MuN5kP8SHGJqYdTt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> property.
>=20
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index 468c646247aa..1e30988826b9 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -153,6 +153,36 @@ properties:
>              ratified at commit 3f9ed34 ("Add ability to manually trigger
>              workflow. (#2)") of riscv-time-compare.
> =20
> +        - const: svade
> +          description: |
> +            The standard Svade supervisor-level extension for raising pa=
ge-fault
> +            exceptions when PTE A/D bits need be set as ratified in the =
20240213
> +            version of the privileged ISA specification.
> +
> +            Both Svade and Svadu extensions control the hardware behavio=
r when
> +            the PTE A/D bits need to be set. The default behavior for th=
e four
> +            possible combinations of these extensions in the device tree=
 are:
> +            1. Neither svade nor svadu in DT: default to svade.

I think this needs to be expanded on, as to why nothing means svade.

> +            2. Only svade in DT: use svade.

That's a statement of the obvious, right?

> +            3. Only svadu in DT: use svadu.

This is not relevant for Svade.

> +            4. Both svade and svadu in DT: default to svade (Linux can s=
witch to
> +               svadu once the SBI FWFT extension is available).

"The privilege level to which this devicetree has been provided can switch =
to
Svadu if the SBI FWFT extension is available".

> +        - const: svadu
> +          description: |
> +            The standard Svadu supervisor-level extension for hardware u=
pdating
> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull r=
equest
> +            #25 from ved-rivos/ratified") of riscv-svadu.
> +
> +            Both Svade and Svadu extensions control the hardware behavio=
r when
> +            the PTE A/D bits need to be set. The default behavior for th=
e four
> +            possible combinations of these extensions in the device tree=
 are:

@Anup/Drew/Alex, are we missing some wording in here about it only being
valid to have Svadu in isolation if the provider of the devicetree has
actually turned on Svadu? The binding says "the default behaviour", but
it is not the "default" behaviour, the behaviour is a must AFAICT. If
you set Svadu in isolation, you /must/ have turned it on. If you set
Svadu and Svade, you must have Svadu turned off?

> +            1. Neither svade nor svadu in DT: default to svade.
> +            2. Only svade in DT: use svade.

These two are not relevant to Svadu, I'd leave them out.

> +            3. Only svadu in DT: use svadu.

Again, statement of the obvious?

> +            4. Both svade and svadu in DT: default to svade (Linux can s=
witch to
> +               svadu once the SBI FWFT extension is available).

Same here as in the Svade entry.

Thanks,
Conor.


--MuN5kP8SHGJqYdTt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZmCYYgAKCRB4tDGHoIJi
0tLVAQDaJxypeK+klc9eSIXgb1/wgPLmEylTnc8/4ceKF/GFnwEAq4ysX3JMpe/B
tD+9p+XFfXCPa2GD2rvlTIT6YJMYuwI=
=Q4pd
-----END PGP SIGNATURE-----

--MuN5kP8SHGJqYdTt--

