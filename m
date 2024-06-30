Return-Path: <kvm+bounces-20733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2081D91D1F6
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 16:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0ED3281CDA
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 14:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5DE14E2E8;
	Sun, 30 Jun 2024 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hIpyXJeD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282897E572;
	Sun, 30 Jun 2024 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719756579; cv=none; b=r2wYkIEbqxJsB8iWwaJP6jQHFC48/coFD2HDLwPHD9DC2q5Oq+0atxVuJZ7L1yWGDfsyhjeK7G/MnZu9zs+Ood6BexsvtBlFDFivRA9MpjUiD8p/Dvhqvgr8m+UdLs39jI0OWegCsKDCC/2zlBiBe50ppBlus1WpgNK0ewc6BDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719756579; c=relaxed/simple;
	bh=/xCCulK2LDvM6T4DDK3IaPZekIJJ7Gq+2ykmVNaX2YM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMPAxB2gcmQYmSFun+UbT/Kwa7uZt9pYFPcEQIn2FZB2RFPgnowxTxP3WTHFgBp+6vlRtmkcIW8eV45m+wccWU3TUiEFeki38X5Kn6QqG5gJGDphJsnb5fE2u7T8qIo4lgAwX8pZag4uRSXPx8KYCcTsj6+KUxYJ5OtUW/Ze6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hIpyXJeD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1F4C2BD10;
	Sun, 30 Jun 2024 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719756578;
	bh=/xCCulK2LDvM6T4DDK3IaPZekIJJ7Gq+2ykmVNaX2YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hIpyXJeDjyxKeeaNxtVJX644yi5CswNk4QOjMTn10ZTy8z1URm5QSFhuiPgNw2BhM
	 3rkcWZCDMNXDAjRewXOwPJmp/XooFrSToztonDGy77Mh6n25fc2TmQ65BCxE8Miet/
	 OcWwcQgbQMo263ZlWTOwuxWs5mIwksFrbnFxNiHzV88do6qwZzHOknD66IVKY3GNQe
	 ragVgaD33bELePr9TIUPh/g7LMsGZ/8oEGcwGWCc1M5Mlep1ngwSknu6qtSFHxrJso
	 p5JP0fHbVDZtLXOf5KI2fggU9uw8qIpOu1AmEgHLyvNZ2wnse79/850GDego4u9XZz
	 tk/wLpivtFLTg==
Date: Sun, 30 Jun 2024 15:09:33 +0100
From: Conor Dooley <conor@kernel.org>
To: Jessica Clarke <jrtc27@jrtc27.com>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-riscv <linux-riscv@lists.infradead.org>,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	Greentime Hu <greentime.hu@sifive.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240630-caboose-diameter-7e73bf86da49@spud>
References: <20240628093711.11716-1-yongxuan.wang@sifive.com>
 <20240628093711.11716-3-yongxuan.wang@sifive.com>
 <20240628-clamp-vineyard-c7cdd40a6d50@spud>
 <402C3422-0248-4C0F-991E-C0C4BBB0FA72@jrtc27.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VstelAVsSG0eBIgw"
Content-Disposition: inline
In-Reply-To: <402C3422-0248-4C0F-991E-C0C4BBB0FA72@jrtc27.com>


--VstelAVsSG0eBIgw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 29, 2024 at 02:09:34PM +0100, Jessica Clarke wrote:
> On 28 Jun 2024, at 17:19, Conor Dooley <conor@kernel.org> wrote:
> >=20
> > On Fri, Jun 28, 2024 at 05:37:06PM +0800, Yong-Xuan Wang wrote:
> >> Add entries for the Svade and Svadu extensions to the riscv,isa-extens=
ions
> >> property.
> >>=20
> >> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> >> ---
> >> .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
> >> 1 file changed, 28 insertions(+)
> >>=20
> >> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b=
/Documentation/devicetree/bindings/riscv/extensions.yaml
> >> index 468c646247aa..c3d053ce7783 100644
> >> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> >> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> >> @@ -153,6 +153,34 @@ properties:
> >>             ratified at commit 3f9ed34 ("Add ability to manually trigg=
er
> >>             workflow. (#2)") of riscv-time-compare.
> >>=20
> >> +        - const: svade
> >> +          description: |
> >> +            The standard Svade supervisor-level extension for SW-mana=
ged PTE A/D
> >> +            bit updates as ratified in the 20240213 version of the pr=
ivileged
> >> +            ISA specification.
> >> +
> >> +            Both Svade and Svadu extensions control the hardware beha=
vior when
> >> +            the PTE A/D bits need to be set. The default behavior for=
 the four
> >> +            possible combinations of these extensions in the device t=
ree are:
> >> +            1) Neither Svade nor Svadu present in DT =3D>
> >=20
> >>                It is technically
> >> +               unknown whether the platform uses Svade or Svadu. Supe=
rvisor may
> >> +               assume Svade to be present and enabled or it can disco=
ver based
> >> +               on mvendorid, marchid, and mimpid.
> >=20
> > I would just write "for backwards compatibility, if neither Svade nor
> > Svadu appear in the devicetree the supervisor may assume Svade to be
> > present and enabled". If there are systems that this behaviour causes
> > problems for, we can deal with them iff they appear. I don't think
> > looking at m*id would be sufficient here anyway, since the firmware can
> > have an impact. I'd just drop that part entirely.
>=20
> Older QEMU falls into that category, as do Bluespec=E2=80=99s soft-cores =
(which
> ours are derived from at Cambridge). I feel that, in reality, one
> should be prepared to handle both trapping and atomic updates if
> writing an OS that aims to support case 1.

I guess that is actually what we should put in then, to use an
approximation of your wording, something like
	Neither Svade nor Svadu present in DT =3D> Supervisor software should be
	prepared to handle either hardware updating of the PTE A/D bits or page
	faults when they need updated
?

--VstelAVsSG0eBIgw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZoFnHQAKCRB4tDGHoIJi
0ndoAP93+tDDtA9REzbCkIEltVoxfZckvSQWizwwYg211bfpVwEAr32+ixQYgkK/
rHueZ5hB231ndT82y+Y9rNscAzTMUwA=
=tz48
-----END PGP SIGNATURE-----

--VstelAVsSG0eBIgw--

