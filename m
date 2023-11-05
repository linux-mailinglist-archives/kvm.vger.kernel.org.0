Return-Path: <kvm+bounces-631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD59B7E1761
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 23:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B4741C2098A
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 22:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CF023B3;
	Sun,  5 Nov 2023 22:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="uNq/aKjS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFE33C3E
	for <kvm@vger.kernel.org>; Sun,  5 Nov 2023 22:32:04 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FA5DB;
	Sun,  5 Nov 2023 14:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1699223521;
	bh=tXo2JKdNmipVtk9xtlHrP8gzkKdlJTGNLcUVmH8G0EU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uNq/aKjSj2jmer3W1oTJYFp/oY+e8XnJWWgtkcB2r0GMZfR66GZwioTHDyPRBmuM7
	 omJ2ehqW/VciJyHnhSEVWVcHIDxfneaxa4HiblFM7UPJpeIrBIwXZ0Krl6sZQSqE4K
	 UWi71ybUMOW4JGqxkaZ9KE0tiiX/ahwniVYuwx4HQ2/CYc3WECXuLw2lu65bm9OFy8
	 lvAcB6SrBmqCup2RqX8ajpWdO7FQBxt1EWcKVSboIKs0eOFeuhwBse8S6XrW3qOg86
	 rXopybaaO6SNr7FP57IN2ss4I7r7thbe13AfZponnGPF4CvkM2SNPhcYsFIRKSxQpo
	 oEMuD4n/e72nw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SNq3K5nFXz4wxY;
	Mon,  6 Nov 2023 09:31:57 +1100 (AEDT)
Date: Mon, 6 Nov 2023 09:31:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul@pwsan.com>
Cc: Anup Patel <anup@brainfault.org>, Andrew Jones
 <ajones@ventanamicro.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Mayuresh Chitale <mchitale@ventanamicro.com>,
 Palmer Dabbelt <palmer@rivosinc.com>, Paolo Bonzini <pbonzini@redhat.com>,
 KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-riscv tree with the risc-v
 tree
Message-ID: <20231106093157.24f46f82@canb.auug.org.au>
In-Reply-To: <20231101133743.70454594@canb.auug.org.au>
References: <20231030125302.250fc7e8@canb.auug.org.au>
	<20231101133743.70454594@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//TXYKlFMg=EiXnsRQp=JYCH";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_//TXYKlFMg=EiXnsRQp=JYCH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 1 Nov 2023 13:37:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>=20
> On Mon, 30 Oct 2023 12:53:02 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Today's linux-next merge of the kvm-riscv tree got a conflict in:
> >=20
> >   arch/riscv/include/asm/csr.h
> >=20
> > between commit:
> >=20
> >   43c16d51a19b ("RISC-V: Enable cbo.zero in usermode")
> >=20
> > from the risc-v tree and commits:
> >=20
> >   db3c01c7a308 ("RISCV: KVM: Add senvcfg context save/restore")
> >   81f0f314fec9 ("RISCV: KVM: Add sstateen0 context save/restore")
> >=20
> > from the kvm-riscv tree.
> >=20
> > I fixed it up (I just used the latter version of this file) and can
> > carry the fix as necessary. This is now fixed as far as linux-next is
> > concerned, but any non trivial conflicts should be mentioned to your
> > upstream maintainer when your tree is submitted for merging.  You may
> > also want to consider cooperating with the maintainer of the conflicting
> > tree to minimise any particularly complex conflicts. =20
>=20
> This is now a conflict between the kvm tree and the risc-v tree.

This is now a conflict between the risc-v tree and Linus' tree.
--=20
Cheers,
Stephen Rothwell

--Sig_//TXYKlFMg=EiXnsRQp=JYCH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmVIF90ACgkQAVBC80lX
0GwIcAf/WTnE+DOhWu4iFbTOUUOLad3BTVjC12KaGL9sHEsZA8qV8gHKesWG7Pv/
4cXqq5AANe8tkRv7Sbg7dMZWE7jb+ttSI6N2yGcCkHGwyn82Q12ULD+NT2+WJx8+
m887BN1WJmdUbojC+xzMPwkVZRemc4jIZi9ZozcYjvrSW0kqu7CqUViDSmu878LB
ooVSExihnYHPULAfvUUowWz8YkAquSAkvVsgRIoMgYtiyEc2E2eIXraUrIZQImNJ
dOJ0Djs3eWF/oe12SrcvuwBu3XtZl9A4JJ9VHAjlVyt1oND+l3YJ3g9blL8JAypY
Am6Wy7Orn7IhLqcuIQxXjMLOIOaakg==
=GOX2
-----END PGP SIGNATURE-----

--Sig_//TXYKlFMg=EiXnsRQp=JYCH--

