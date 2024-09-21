Return-Path: <kvm+bounces-27243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2692697DF53
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 00:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D42D3281F27
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 22:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E741515445D;
	Sat, 21 Sep 2024 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaFW6f6H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46EEBE;
	Sat, 21 Sep 2024 22:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726956359; cv=none; b=IZjK5CAVTC0sHzNzOq/OnHJGQUZFpiIxvZ1o1HRaZ0xLpJAXaeqYFb2Oc/C7fSZ+qYyB/CbpY29IcSQpG9ZMqwrFinDUiJxt5tftWRnv6Y9OkNnUv9HbvbOoR6rapmNTO/6CNfC8607oJDxSn/cqF4aYt22633nUQRPd5PKWXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726956359; c=relaxed/simple;
	bh=/X57ncqkKV685Tc73lC69jepq5DQEY1k/4jxl0qDY1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrDLyybuCXBeWyzzQVi/FO+kb+UdIQ9R2IC+faS9xBFkyL+OROw063Sd72hvnVAbZHtZgg3m7S1CIP07thkIsG0lsxXoDTx2+q2aoCoZjwXSgX9XQmqUcDWYEi+oRIs3wx7Pt8s/w2ztIHnGmNY5m3fjpCbA/kaRdrF9Nx5p6ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaFW6f6H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEE8C4CEC2;
	Sat, 21 Sep 2024 22:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726956358;
	bh=/X57ncqkKV685Tc73lC69jepq5DQEY1k/4jxl0qDY1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eaFW6f6H4UbmenZx+RBfLxcjVcGtlv6PLhDt7CBFjY7+rsSkXYal+pGf8Y9K0/ApG
	 aP+3br8KzKBaSNGIWK73F1GLmQa06AlB3jQ2yTUJNQJW50Z3KwCB8gjCNU8AbuzxhL
	 n+d+6QS5euVbHibGXG80FHn2iGlM9DIPLErFhBioSqAUxwRCfSHRkDa1fmiAWRnONE
	 euQiKvpVXbdfRRv0QRhsr1t+iq02bSsK/xnZB5lNBTlIb4cvMz4gT4OynYkSATAXhT
	 7R6wthhKyj7+sgApV1KTWMw3oHPPLX/LyKH3mFbPfvDLTplyCVzs88G3VKW2IjGgwC
	 iENCPkcAOpbdg==
Date: Sat, 21 Sep 2024 23:05:53 +0100
From: Conor Dooley <conor@kernel.org>
To: Max Hsu <max.hsu@sifive.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH RFC 1/3] dt-bindings: riscv: Add Svukte entry
Message-ID: <20240921-shock-purge-d91482d191a1@spud>
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
 <20240920-dev-maxh-svukte-rebase-v1-1-7864a88a62bd@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="e1yUmKuhmIxAjSpf"
Content-Disposition: inline
In-Reply-To: <20240920-dev-maxh-svukte-rebase-v1-1-7864a88a62bd@sifive.com>


--e1yUmKuhmIxAjSpf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024 at 03:39:03PM +0800, Max Hsu wrote:
> Add an entry for the Svukte extension to the riscv,isa-extensions
> property.
>=20
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> Signed-off-by: Max Hsu <max.hsu@sifive.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index a06dbc6b4928958704855c8993291b036e3d1a63..df96aea5e53a70b0cb8905332=
464a42a264e56e6 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -171,6 +171,13 @@ properties:
>              memory types as ratified in the 20191213 version of the priv=
ileged
>              ISA specification.
> =20
> +        - const: svukte
> +          description:
> +            The standard Svukte supervisor-level extensions for making u=
ser-mode
> +            accesses to supervisor memory raise page faults in constant =
time,
> +            mitigating attacks that attempt to discover the supervisor
> +            software's address-space layout, as PR#1564 of riscv-isa-man=
ual.

I'm surprised this doesn't fail dt_binding_check, with the # in it. I'd
like to see a commit hash here though, in the same format as the other
extensions using them.

> +
>          - const: zacas
>            description: |
>              The Zacas extension for Atomic Compare-and-Swap (CAS) instru=
ctions
>=20
> --=20
> 2.43.2
>=20

--e1yUmKuhmIxAjSpf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZu9DQQAKCRB4tDGHoIJi
0vpuAP92NYEC9FM8e8Y7BhVJDJvf069DI4tcoz+kx+BoYjEtzQD9Fp1Wj8hFfHNh
s70/gx+0/zuAYgjxNfQ7GnUDfjIW7A8=
=lQCo
-----END PGP SIGNATURE-----

--e1yUmKuhmIxAjSpf--

