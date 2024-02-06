Return-Path: <kvm+bounces-8146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E79384BECA
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FCB01F270B0
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635941BDED;
	Tue,  6 Feb 2024 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="GYJsypjZ"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001131B978;
	Tue,  6 Feb 2024 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707251792; cv=none; b=cYjeQKdQ0/TmEMDoxkXtjy3w3n5DmgDwu4CNP3NrOEao+BxnJeaiXI9F0Sf4+9opc798lZ+SDMUEJ/ylnxCSIponXS5BMQbBO3UJAp5IpQFrArj491ssi2BtkbihSDM20DPbAUjboTUZJOjzbp+I+eGlRfd+Jwp1PYK+jv6e8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707251792; c=relaxed/simple;
	bh=HTFyY7X/5KdcOjrn3vIvfV9mbmOJVJclMVmTWXWpzOE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=b/c3Ap9UkDl7/g9/K0JAdLYK4Yy5RYhOwVUxOpLvtd3W26kcSc90Wg1TqXMpNdICkkmkOUawV9zVL4oYuiyIaYasK28BK+0ehyHXJYrQOAJo0ArDUbva2GXM2naHh2qrfGaakufgBED4H67jAVPdi0bgojFKa7FNMDdK/r4yhkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=GYJsypjZ; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1707251786;
	bh=D338XPKReBnSA/jax4himT5TtkURWctMrbTaqiNJ3ys=;
	h=Date:From:To:Cc:Subject:From;
	b=GYJsypjZ8IcaN3tA1DZH1cLWDyWZGAjqivPxmU8wF6ohWKtkBKzLB4dy51VITvCcG
	 os3T7iTe7qynVIf4oLXvIm/KM46XSZ+8er43j0x6P4OY5wiwxmHr7MDEmvyxyZGsIy
	 IJsTVO+mxjYH9QF1XpkV2R9x1/GjsLXT/k4ci8oZa/hpNqW+gLQHsdJ5xsB5h5LiZJ
	 4ib0ZCvxQx13hJVCCr5q5fSId7H/ZeJnzJhWXvncHNhP8oeUrDJ4IwwvaherJ61mz8
	 QFwtc0zeFfOydGtoo1i6caXQw2u8UtuIb07VU6msc5Pm00IyB30YdiyfT7w7JYepgN
	 XY+f0pMAaNwuA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TTw561zJdz4wcJ;
	Wed,  7 Feb 2024 07:36:26 +1100 (AEDT)
Date: Wed, 7 Feb 2024 07:36:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>, KVM <kvm@vger.kernel.org>, Linux
 Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20240207073624.657a7f16@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/W1O2RwmZNo00UU1XbbIucec";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/W1O2RwmZNo00UU1XbbIucec
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  e45964771007 ("x86/coco: Define cc_vendor without CONFIG_ARCH_HAS_CC_PLAT=
FORM")

Fixes tag

  Fixes: a9ef277488cf ("x86/kvm: Fix SEV check in sev_map_percpu_data()", 2=
024-01-31)

has these problem(s):

  - Subject has leading but no trailing quotes
  - Subject does not match target commit subject
    Just use
        git log -1 --format=3D'Fixes: %h ("%s")'

The date adds nothing to the Fixes tags.

--=20
Cheers,
Stephen Rothwell

--Sig_/W1O2RwmZNo00UU1XbbIucec
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmXCmEgACgkQAVBC80lX
0GwQNAf/Z8YBANwnFl+bx5c0ll5YmPNdq3pz5vYLBK1U2nPtkwn4JO2i2H6O356Z
Ws+RSg6QQm6CpTzCAY7IVa2VRDYsYu1bGuAcsokO9oBOD9O9W7ejDJx6UUyniQ6o
SicuWitjK/03TFWTT0o5FDemcnSEXEADZAAcRqpRKQjeYlI72E9bSP1YQ4vxtC53
OaedmroUVrO95kb9USbfKsPVa78W6EqynutnNdMp6K3qrj+YmgOiz1a9jz1kQGsI
DwpAIoUTFuxnFyhgCzNEup8P6PpEQBiFuMm38HmeNPLQuW+raKuUQ6O8cE+4kDGn
nvqm0ptOiLB12KrF2KU4Rkvy5b3hLg==
=k1yZ
-----END PGP SIGNATURE-----

--Sig_/W1O2RwmZNo00UU1XbbIucec--

