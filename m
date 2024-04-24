Return-Path: <kvm+bounces-15759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CCD8B0350
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 09:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 879861F21A88
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 07:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08B11581F5;
	Wed, 24 Apr 2024 07:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C01cGJHa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF9723CB;
	Wed, 24 Apr 2024 07:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713944414; cv=none; b=MO2P0Mt0zoJmw0B59rqFRQ0Roj3HcpQpC9XfMwUIPD0UBY44AVNFguQlsH+MBh/KBQDz8zeVdOR8P0Zxp4vy/q9QmPHlRlR/pk/Xbhqy2Gn/M4pgmDqpHmk0WD48n/NP4gEGT0QcO5xCdwoS+8tKqH1TIkwrhunerAwV4nlkIwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713944414; c=relaxed/simple;
	bh=3HsOuSJtJ1IhE61NoIAbOBMWZ2YnkKaqYDMmNhQXJwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IioKsgszjWSowr3INlGS4iT10HISIiy5VzqDa3Q8q/Ip3alNLcPwC+hY4UW5zZnnjKz0o7wevmzo9lyITAir3suK0LPxCa/cJcAvyxtBZkZNVe7KyJ4tgyOCvWdoje3jFauuTwIS2W6PvyMo26TBIY5NK84oJ+gp3x1CmsF7ezs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C01cGJHa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC58FC113CE;
	Wed, 24 Apr 2024 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713944413;
	bh=3HsOuSJtJ1IhE61NoIAbOBMWZ2YnkKaqYDMmNhQXJwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C01cGJHaEbj4jAXPEmGr9XRdc9//r7NyYG9h0HHh0P2Gls9cq5hhbzvB6h9B8DvjO
	 ZibdC8Jcg/THVBIjizJaXZc4UZiUqi9Lk3zil83977KEmEnW74mvGHqYdnssAacJC3
	 4ByD9P+tI8VdtLHvmil0oTineLS9/01Tgj3lfCP6bgffEzLpLoRDk9GtqYJ44UXIzP
	 /Yi/stzmzEJNPQIcoAT1yzE1U+POy1eSfYfxpMABGRKGg/lY8gMqk5RV5f+O22Y0/o
	 hUq60Vg8VgsekAm5vJN+cnOm/ODkThHbfCm4zggIxZoUjzY7ahGGo6+NKoaBJPN3Qk
	 ucpDjJ0lH0O/Q==
Date: Wed, 24 Apr 2024 08:40:08 +0100
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
Message-ID: <20240424-rehydrate-sloppy-62132c72fe18@spud>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-3-cleger@rivosinc.com>
 <20240423-poser-splashed-56ab5340af48@spud>
 <e39f2fea-868a-4a79-b7a5-bef8f15de688@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SiSSfUusYQSVZJqq"
Content-Disposition: inline
In-Reply-To: <e39f2fea-868a-4a79-b7a5-bef8f15de688@rivosinc.com>


--SiSSfUusYQSVZJqq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024 at 09:20:35AM +0200, Cl=E9ment L=E9ger wrote:
>=20
>=20
> On 23/04/2024 18:30, Conor Dooley wrote:
> > On Thu, Apr 18, 2024 at 04:26:41PM +0200, Cl=E9ment L=E9ger wrote:
> >> Add description for the Ssdbltrp ISA extension which is not yet
> >> ratified.
> >>
> >> Signed-off-by: Cl=E9ment L=E9ger <cleger@rivosinc.com>
> >> ---
> >>  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b=
/Documentation/devicetree/bindings/riscv/extensions.yaml
> >> index 63d81dc895e5..ce7021dbb556 100644
> >> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> >> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> >> @@ -147,6 +147,12 @@ properties:
> >>              and mode-based filtering as ratified at commit 01d1df0 ("=
Add ability
> >>              to manually trigger workflow. (#2)") of riscv-count-overf=
low.
> >> =20
> >> +        - const: ssdbltrp
> >> +          description: |
> >> +            The standard Ssdbltrp supervisor-level extension for doub=
le trap
> >> +            handling as currently defined by commit e85847b ("Merge p=
ull request
> >> +            #32 from ved-rivos/0415_1 ") of riscv-double-trap.
> >=20
> > I see the proposed ratification for this is Sept 2024, and is marked as
> > "Freeze Approved". Do you know when it is going to be frozen? Until
> > this, I can't ack this patch. I had a look in the RVI JIRA
> > https://jira.riscv.org/browse/RVS-2291?src=3Dconfmacro
> > and it looks imminent, but it's unclear to me whether it actually has
> > been or not.
>=20
> Hi Conor,
>=20
> Yeah, this series is a RFC since the spec is not yet ratified nor frozen
> and its purpose is actually to get to a frozen state. As to when this
> will be ratified, I guess Ved can probably answer that.

Usually I'd just not ack the RFC patches, but I do at least check how
far they might be from frozen before I move on, The jira for this one
says "Actual ARC Freeze Approval:	18/Apr/24", which made me think
a freeze was gonna happen soon.

--SiSSfUusYQSVZJqq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZii3WAAKCRB4tDGHoIJi
0sIAAQDIxpw/HuOo9/JqvyU+02o1E9Ih6d0pVx2mM9tf0Irq2gD/W+zFzb+/rTjf
GqZYpJl93UvUWXVzUj0PqNxDnSWcEQo=
=7cO9
-----END PGP SIGNATURE-----

--SiSSfUusYQSVZJqq--

