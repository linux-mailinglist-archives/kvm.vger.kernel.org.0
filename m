Return-Path: <kvm+bounces-20014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1213690F5CB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 20:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ADCE1C214AC
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 18:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D875C157E84;
	Wed, 19 Jun 2024 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VubqIGNK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470B156F3C;
	Wed, 19 Jun 2024 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718820682; cv=none; b=amjelBlPV6kZfm6iKW2dkADcbQm10onBSxLEoAVaI4wllfqazgbYi1zBk4D05KXAsHxzLWvB7Es7pA2QaqyZTkO1ouEmitoAmJ0BZZTx6jS1uGGRghp5inwy9n71GLSJsBefRoC1Wv+NYajX71huDIvjkUTZw4H5Wr0bitSBf/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718820682; c=relaxed/simple;
	bh=eM8ZHNqn3zhJka/utQcQ6YZwZ1lRkZvcoh73c33nV2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uToAtv4NBZBc19k8fofwN9zUdvY8Rz5ycKplL6EaTUSsmFOHshZYRBESDFXnYHv9wLQcAy4u98V89rLktlzyiLtmNc5983XsKR5u+OT029mFEEhAq2X2MkCeDpDJyu6CGdaTUb/FADLUEM73fIQkkS8BilI2tzi71yfvnNQ7BrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VubqIGNK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF04C2BBFC;
	Wed, 19 Jun 2024 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718820681;
	bh=eM8ZHNqn3zhJka/utQcQ6YZwZ1lRkZvcoh73c33nV2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VubqIGNKPYexo5EaGDBeMUN4CkvxOkC+s04Qt73Usm5DYSq63iX1xyNuKpMpjDQ2L
	 hPSwvzqKYSi53jf/HZ6AxEuVA5ECX9DChgbV8B0EXCBGvENYuyptuDwlA3qKRMDAud
	 oIEG/qzT29LhIjfxmoEoiXHIlOQa/OJo2ma/576AMUAlO0Iij13wjqS7SGH6wZL9it
	 ooJQAspgbYNYHdYpE33I57PqYaC1UjV/EZmiyFjf3sWQ+epyqwL2NwZOaM6HnLho4c
	 5fDyBfkqEbpPL+Z1TcjKwFJLWDyZjAU9b4t6jO5pTW+jVrQJ1x63N4UyOLAvuTSlWg
	 Ge2emRBkit5sA==
Date: Wed, 19 Jun 2024 19:11:16 +0100
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
Message-ID: <20240619-shabby-smother-c482e771632a@spud>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAMWQL2gQpHPD=bPenjD+=NP47k8n26+6KP05zogxUtsD6zY6GQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5sQpHeJmYMJW0CIa"
Content-Disposition: inline
In-Reply-To: <CAMWQL2gQpHPD=bPenjD+=NP47k8n26+6KP05zogxUtsD6zY6GQ@mail.gmail.com>


--5sQpHeJmYMJW0CIa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Anup, Drew, Alex,

On Tue, Jun 18, 2024 at 06:38:13PM +0800, Yong-Xuan Wang wrote:
> On Thu, Jun 6, 2024 at 12:55=E2=80=AFAM Conor Dooley <conor@kernel.org> w=
rote:
> >
> > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > Add entries for the Svade and Svadu extensions to the riscv,isa-exten=
sions
> > > property.
> > >
> > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > ---
> > >  .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++=
++
> > >  1 file changed, 30 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml =
b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > index 468c646247aa..1e30988826b9 100644
> > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > @@ -153,6 +153,36 @@ properties:
> > >              ratified at commit 3f9ed34 ("Add ability to manually tri=
gger
> > >              workflow. (#2)") of riscv-time-compare.
> > >
> > > +        - const: svade
> > > +          description: |
> > > +            The standard Svade supervisor-level extension for raisin=
g page-fault
> > > +            exceptions when PTE A/D bits need be set as ratified in =
the 20240213
> > > +            version of the privileged ISA specification.
> > > +
> > > +            Both Svade and Svadu extensions control the hardware beh=
avior when
> > > +            the PTE A/D bits need to be set. The default behavior fo=
r the four
> > > +            possible combinations of these extensions in the device =
tree are:
> > > +            1. Neither svade nor svadu in DT: default to svade.
> >
> > I think this needs to be expanded on, as to why nothing means svade.
> >
> > > +            2. Only svade in DT: use svade.
> >
> > That's a statement of the obvious, right?
> >
> > > +            3. Only svadu in DT: use svadu.
> >
> > This is not relevant for Svade.
> >
> > > +            4. Both svade and svadu in DT: default to svade (Linux c=
an switch to
> > > +               svadu once the SBI FWFT extension is available).
> >
> > "The privilege level to which this devicetree has been provided can swi=
tch to
> > Svadu if the SBI FWFT extension is available".
> >
> > > +        - const: svadu
> > > +          description: |
> > > +            The standard Svadu supervisor-level extension for hardwa=
re updating
> > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge pu=
ll request
> > > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > > +
> > > +            Both Svade and Svadu extensions control the hardware beh=
avior when
> > > +            the PTE A/D bits need to be set. The default behavior fo=
r the four
> > > +            possible combinations of these extensions in the device =
tree are:
> >
> > @Anup/Drew/Alex, are we missing some wording in here about it only being
> > valid to have Svadu in isolation if the provider of the devicetree has
> > actually turned on Svadu? The binding says "the default behaviour", but
> > it is not the "default" behaviour, the behaviour is a must AFAICT. If
> > you set Svadu in isolation, you /must/ have turned it on. If you set
> > Svadu and Svade, you must have Svadu turned off?
> >
> > > +            1. Neither svade nor svadu in DT: default to svade.
> > > +            2. Only svade in DT: use svade.
> >
> > These two are not relevant to Svadu, I'd leave them out.
> >
> > > +            3. Only svadu in DT: use svadu.
> >
> > Again, statement of the obvious?
> >
> > > +            4. Both svade and svadu in DT: default to svade (Linux c=
an switch to
> > > +               svadu once the SBI FWFT extension is available).
> >
> > Same here as in the Svade entry.

> I will update the description. Thank you!

Before you do, I'd love if Anup, Drew or Alex could comment on my
question about default behaviours. They're the ones with Strong Opinions
here about how the SBI implementation should behave, and I want to make
sure it is correctly documented.

Thanks,
Conor.


--5sQpHeJmYMJW0CIa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnMfRAAKCRB4tDGHoIJi
0mxsAP9/HYbRT+IODW/JeWgB3oihF9tatXMsLPSv5zh01Chn2AD+MWUlW7+bWwkL
TcfQ9tn4kkqaW1w3XdBd3pZdG+9wBgQ=
=sFa3
-----END PGP SIGNATURE-----

--5sQpHeJmYMJW0CIa--

