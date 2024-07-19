Return-Path: <kvm+bounces-21928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C60B993783A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 15:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02FB81C21154
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 13:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35C213DDCC;
	Fri, 19 Jul 2024 13:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BX2Ysd7H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFB229CE6;
	Fri, 19 Jul 2024 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721395037; cv=none; b=O9yHBhffb9UJw+dfot70TKGStpONdALFX/2m/eJHEoADEadxfozaJamYMuupq5gc/xdxVIxq1JwzkdD7AlfmEm374OY0D8StHMHn01EZmuYX/FXfvWRg6CAbVIwS7Eaqw5n0q7K7JR9A1plk5aiwXuUgyKDeV6KnA9ZtFoMLHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721395037; c=relaxed/simple;
	bh=qtLPFOhjqFSQYLpvCLe3qCCW4Py65LMqZdG1qvlJQ00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/MpN1RkVrxuOhm2UYW1vYo9//HFgfno9Mz4gDfOvDRxxAqR5AmzXfsLw/vKx1YNYGg2OgqiY7KRZJAeSJte/zIaaTAD4M4ieuldQsHEjmRO/snP7VIgOTHyJkMXuccUW1FlGO8TfEdl1ZR5sORhT0MYQA8t9adrROXm4+gRlqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BX2Ysd7H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA35AC32782;
	Fri, 19 Jul 2024 13:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721395037;
	bh=qtLPFOhjqFSQYLpvCLe3qCCW4Py65LMqZdG1qvlJQ00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BX2Ysd7HikpMDPOtr1h9L5jSD24rg6Ar4jIpudeOW75Ly61bPrVuFM8vH1CYKX6Li
	 2uJyxkwcqs9OnDeFrBkpahew6+Mie/ztcLEfSa4Dv3EXLvfUHnkEFajzNh5uKBqBni
	 iJFP0EkMY77o821Fwfkh2xlFsyatrgxuX+Qv/MRRMLJwOBcES5LFBoRG/gCNB6QJq8
	 WcIutfAiNxcpZU75Qf7cfS1j8EeyoLjrbPDUfxDsW+4vwPGMFldfln9TKqaFiX9Dye
	 OuLHSRI8uIWoEPoStzlx6ROavXVt9xom8g3hmKL8Ldp0XaXaaXNFlZBOivtfEMyR/s
	 4lJIYzCFCmJEw==
Date: Fri, 19 Jul 2024 14:17:12 +0100
From: Conor Dooley <conor@kernel.org>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: Samuel Holland <samuel.holland@sifive.com>, greentime.hu@sifive.com,
	vincent.chen@sifive.com, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240719-flatten-elixir-d4476977ab95@spud>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com>
 <727b966a-a8c4-4021-acf6-3c031ccd843a@sifive.com>
 <CAMWQL2g-peSYJQaxeJtyOzGdEmDQ6cnkRBdFQvLr2NQA1+mv2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FVYN+Rx9CKi55/SI"
Content-Disposition: inline
In-Reply-To: <CAMWQL2g-peSYJQaxeJtyOzGdEmDQ6cnkRBdFQvLr2NQA1+mv2g@mail.gmail.com>


--FVYN+Rx9CKi55/SI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 02:58:59PM +0800, Yong-Xuan Wang wrote:
> Hi Samuel,
>=20
> On Fri, Jul 19, 2024 at 7:38=E2=80=AFAM Samuel Holland
> <samuel.holland@sifive.com> wrote:
> >
> > On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> > > Add entries for the Svade and Svadu extensions to the riscv,isa-exten=
sions
> > > property.
> > >
> > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > ---
> > >  .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++=
++
> > >  1 file changed, 28 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml =
b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > index 468c646247aa..e91a6f4ede38 100644
> > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > @@ -153,6 +153,34 @@ properties:
> > >              ratified at commit 3f9ed34 ("Add ability to manually tri=
gger
> > >              workflow. (#2)") of riscv-time-compare.
> > >
> > > +        - const: svade
> > > +          description: |
> > > +            The standard Svade supervisor-level extension for SW-man=
aged PTE A/D
> > > +            bit updates as ratified in the 20240213 version of the p=
rivileged
> > > +            ISA specification.
> > > +
> > > +            Both Svade and Svadu extensions control the hardware beh=
avior when
> > > +            the PTE A/D bits need to be set. The default behavior fo=
r the four
> > > +            possible combinations of these extensions in the device =
tree are:
> > > +            1) Neither Svade nor Svadu present in DT =3D> It is tech=
nically
> > > +               unknown whether the platform uses Svade or Svadu. Sup=
ervisor
> > > +               software should be prepared to handle either hardware=
 updating
> > > +               of the PTE A/D bits or page faults when they need upd=
ated.
> > > +            2) Only Svade present in DT =3D> Supervisor must assume =
Svade to be
> > > +               always enabled.
> > > +            3) Only Svadu present in DT =3D> Supervisor must assume =
Svadu to be
> > > +               always enabled.
> > > +            4) Both Svade and Svadu present in DT =3D> Supervisor mu=
st assume
> > > +               Svadu turned-off at boot time. To use Svadu, supervis=
or must
> > > +               explicitly enable it using the SBI FWFT extension.
> > > +
> > > +        - const: svadu
> > > +          description: |
> > > +            The standard Svadu supervisor-level extension for hardwa=
re updating
> > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge pu=
ll request
> > > +            #25 from ved-rivos/ratified") of riscv-svadu. Please ref=
er to Svade
> >
> > Should we be referencing the archived riscv-svadu repository now that S=
vadu has
> > been merged to the main privileged ISA manual? Either way:
> >
> > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> >
>=20
> Yes, this commit is from the archived riscv-svadu repo. Or should I updat=
e it to
> "commit c1abccf ("Merge pull request  #25 from ved-rivos/ratified") of
> riscvarchive/riscv-svadu."?

I think Samuel was saying that we should use the commit where it was
merged into riscv-isa-manual instead.

--FVYN+Rx9CKi55/SI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZppnRwAKCRB4tDGHoIJi
0qmzAPwPCohsOIh0JMJTv+r89hx01GSGvJwwS4SEQyLjNq8GTwD/bTyQl6+PLCAD
n+bWqAgty3EMTJXCctxru5eDIOrN3wU=
=IM8G
-----END PGP SIGNATURE-----

--FVYN+Rx9CKi55/SI--

