Return-Path: <kvm+bounces-22062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6389392C0
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 18:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0432C1C215ED
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFBB16EC11;
	Mon, 22 Jul 2024 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RF13hYxO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EF6C2FD;
	Mon, 22 Jul 2024 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721667104; cv=none; b=GK+w7lTvnItFumB/Awu7dvR0BRNCKpE/DX5Yt5Y4DmoP6qfa6c9ZGv5fAw7pKCmdGR0hYNuBUvwgALaVstf7Aky3+7yczlq30xe2E1CNIhsLEOtphTWyd9uL0vYmZBWAySXqf3pcNkQux/X5nfiIqpqCYGqyq3umc+1jyl1NO/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721667104; c=relaxed/simple;
	bh=JWfbQMZVlMkgBoxkVUfOEex3UFL5SXV6npk5rwEQY5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmAOg+BjWAssoSFCLXM4/cWw34HJoyVccYl4uctLsMROp2BK5AZPoZ0HjVOWy893Vbh5x4Gk7PX/HmqjQTnHyKLgt9pBbxFj0qU+XGhKYyJJE3WdcG+QjAQOVOujK0IWg/ElMmj+EhsqM5k/QcCAT+D+ajFwyMHSMwAFaICVPyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RF13hYxO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30007C116B1;
	Mon, 22 Jul 2024 16:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721667103;
	bh=JWfbQMZVlMkgBoxkVUfOEex3UFL5SXV6npk5rwEQY5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RF13hYxOY22CChFt0RirGNMtTsHDyPBzPcVkUbHWS5dIuL3prCfcuYyUpPgu6TFms
	 s30N8GzM7XmEyvBHJ8Ex2q9+/NbsnFoK6AYyMKg9g0Tpxf/xenQxTDVoH2K4QMgvoj
	 c0nenUYZ9kC/4sgjjDQf8pucbJeq+XXw6ilM1vmdTSjd+hWt5iG4HTlRjKdlEdyisU
	 XikVZMN5YrSNnNC9U3AIoQgnc3B2PMBuqo/lRyEEqIUndsQ8j05OmH0/9eZED6q+xZ
	 G8s4kP9cNAXPTPCyXA2Is1C/Mkw7hxo9emWh3PLM6W7H4HRWqN3rB+3YH3j2DrirXD
	 7qXP6RceUZRAg==
Date: Mon, 22 Jul 2024 17:51:39 +0100
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
Message-ID: <20240722-seizing-mardi-5237466fcf83@spud>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com>
 <727b966a-a8c4-4021-acf6-3c031ccd843a@sifive.com>
 <CAMWQL2g-peSYJQaxeJtyOzGdEmDQ6cnkRBdFQvLr2NQA1+mv2g@mail.gmail.com>
 <20240719-flatten-elixir-d4476977ab95@spud>
 <CAMWQL2iWsxLJZZ3H59csJ376Hdtq+ZKjD92BtM9zhdXm+fh2=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="i7lBaJiME8pvvbi7"
Content-Disposition: inline
In-Reply-To: <CAMWQL2iWsxLJZZ3H59csJ376Hdtq+ZKjD92BtM9zhdXm+fh2=A@mail.gmail.com>


--i7lBaJiME8pvvbi7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2024 at 10:14:11AM +0800, Yong-Xuan Wang wrote:

> > > > > +        - const: svadu
> > > > > +          description: |
> > > > > +            The standard Svadu supervisor-level extension for ha=
rdware updating
> > > > > +            of PTE A/D bits as ratified at commit c1abccf ("Merg=
e pull request
> > > > > +            #25 from ved-rivos/ratified") of riscv-svadu. Please=
 refer to Svade
> > > >
> > > > Should we be referencing the archived riscv-svadu repository now th=
at Svadu has
> > > > been merged to the main privileged ISA manual? Either way:
> > > >
> > > > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> > > >
> > >
> > > Yes, this commit is from the archived riscv-svadu repo. Or should I u=
pdate it to
> > > "commit c1abccf ("Merge pull request  #25 from ved-rivos/ratified") of
> > > riscvarchive/riscv-svadu."?
> >
> > I think Samuel was saying that we should use the commit where it was
> > merged into riscv-isa-manual instead.
>=20
> Got it. I will update the description in the next version. Thank you!

There's no need (IMO) to send a new version for this alone - but if you
have to send another version for some other reason then do it.

Cheers,
Conor.

--i7lBaJiME8pvvbi7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZp6OGgAKCRB4tDGHoIJi
0md/AQCHwo+QPDHARtNDHNRq3twdF2e88mQDAlkAKW3vTkQzFQEAsTDuPgrPBZsr
zb5qyXjkbHHdxOvbc4DuItNy5t9OPA0=
=lVI/
-----END PGP SIGNATURE-----

--i7lBaJiME8pvvbi7--

