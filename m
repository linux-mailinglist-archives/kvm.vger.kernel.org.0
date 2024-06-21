Return-Path: <kvm+bounces-20288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A41429128C2
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 17:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23336B294FA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DDA3F9EC;
	Fri, 21 Jun 2024 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBmZ5TVu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD52A38DF2;
	Fri, 21 Jun 2024 14:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718981903; cv=none; b=fguw09yFig5ELZ+p5WNl5RuMtIrJ/2lQH0/upmp2lKEoYFCemm1b8cP0QXESEawa2aaESJcRhQZVWWq2QmUs1GQftcfTXmAeg8mEwWQDzUOe8xy1di1BN7da9PP7qDsfUQkxSLpmQxuoxR02yFaiA9lN3pnfwSSKBFvh/LMpitQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718981903; c=relaxed/simple;
	bh=/N0zW1HmRgZHiAuUDZ099fGXSiJzEZf+VzrO/OmldTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UI7YZffcTLKlLkPBBgyxu4vq14Gb2VY24BMsw5dRtp9s0chJozrdHy9djBPlw2IEDzNVHX1ub9XEzjM2o1BeJOuXWCkMEN/yLGYBmbxe5TtXay3zH3NfSKB2HtKScPF4FH+FGkngOX8hv7LAkiIaDbhQn+EznrmIMpY7uDfR+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBmZ5TVu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3495CC2BBFC;
	Fri, 21 Jun 2024 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718981903;
	bh=/N0zW1HmRgZHiAuUDZ099fGXSiJzEZf+VzrO/OmldTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBmZ5TVueSExguMe00HI/IeWnKyG1SljHOkXRRoVKSsOdWOuj8tb0neCxlwDuyVLv
	 dJheJL/AA37THMdxMcMKAa0Cn0zSZRunsIcIvAuIuzfUNDAojnWJBznoabATc0Nde0
	 DS4zcDnK6RTxSDPdrrjnr8JW/Uskz2gwqdSLQGAdDQXAKIpE+Yw91n9F1E8tSfZF0a
	 9CS6EGVny5WzwWhbr9AhZypkGqMnXeWB28TF5s9ldQtCzkPaZaIB69jEMfd1pJFI3M
	 ofQvPbmNzlLx+Kuo134BHChi8Q8KrI7FG9tXkY4DX5cSiP0XAt6w/SUQs4wMMfvnun
	 gsKru6MwVcq6Q==
Date: Fri, 21 Jun 2024 15:58:18 +0100
From: Conor Dooley <conor@kernel.org>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	greentime.hu@sifive.com, vincent.chen@sifive.com,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240621-surging-flounder-58a653747e1d@spud>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
 <20240621-viewless-mural-f5992a247992@wendy>
 <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>
 <20240621-9bf9365533a2f8f97cbf1f5e@orel>
 <20240621-glutton-platonic-2ec41021b81b@spud>
 <20240621-a56e848050ebbf1f7394e51f@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8hAPi/SVNrIs/7zQ"
Content-Disposition: inline
In-Reply-To: <20240621-a56e848050ebbf1f7394e51f@orel>


--8hAPi/SVNrIs/7zQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 04:52:09PM +0200, Andrew Jones wrote:
> On Fri, Jun 21, 2024 at 03:04:47PM GMT, Conor Dooley wrote:
> > On Fri, Jun 21, 2024 at 03:15:10PM +0200, Andrew Jones wrote:
> > > On Fri, Jun 21, 2024 at 02:42:15PM GMT, Alexandre Ghiti wrote:

> > > I understand the concern; old SBI implementations will leave svadu in=
 the
> > > DT but not actually enable it. Then, since svade may not be in the DT=
 if
> > > the platform doesn't support it or it was left out on purpose, Linux =
will
> > > only see svadu and get unexpected exceptions. This is something we co=
uld
> > > force easily with QEMU and an SBI implementation which doesn't do any=
thing
> > > for svadu. I hope vendors of real platforms, which typically provide =
their
> > > own firmware and DTs, would get this right, though, especially since =
Linux
> > > should fail fast in their testing when they get it wrong.
> >=20
> > I'll admit, I wasn't really thinking here about something like QEMU that
> > puts extensions into the dtb before their exact meanings are decided
> > upon. I almost only ever think about "real" systems, and in those cases
> > I would expect that if you can update the representation of the hardware
> > provided to (or by the firmware to Linux) with new properties, then upd=
ating
> > the firmware itself should be possible.
> >=20
> > Does QEMU have the this exact problem at the moment? I know it puts
> > Svadu in the max cpu, but does it enable the behaviour by default, even
> > without the SBI implementation asking for it?
>=20
> Yes, because QEMU has done hardware A/D updating since it first started
> supporting riscv, which means it did svadu when neither svadu nor svade
> were in the DT. The "fix" for that was to ensure we have svadu and !svade
> by default, which means we've perfectly realized Alexandre's concern...
> We should be able to change the named cpu types that don't support svadu
> to only have svade in their DTs, since that would actually be fixing those
> cpu types, but we'll need to discuss how to proceed with the generic cpu
> types like 'max'.

Correct me please, since I think I am misunderstanding: At the moment
QEMU does A/D updating whether or not the SBI implantation asks for it,
with the max CPU. The SBI implementation doesn't understand Svadu and
won't strip it. The kernel will get a DT with Svadu in it, but Svadu will
be enabled, so it is not a problem.

--8hAPi/SVNrIs/7zQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnWVCQAKCRB4tDGHoIJi
0vOtAQDlXct24q3+5xwPuu3xdxQDI0UlyBOK0l80As/W7VUFAgD/dg4Zzqtg9N+j
ocw/Xv5W3AHDcfI4joWSya+p51csqww=
=er2I
-----END PGP SIGNATURE-----

--8hAPi/SVNrIs/7zQ--

