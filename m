Return-Path: <kvm+bounces-270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C0A7DDB10
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56ACBB21125
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 02:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5153BED5;
	Wed,  1 Nov 2023 02:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="RuqRHB3z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D695367
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:37:58 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D189C2;
	Tue, 31 Oct 2023 19:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1698806269;
	bh=w5Q+yOjS1lbBrWUF1wYoPOETYbMslm549x5jw+MUTHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RuqRHB3zd8iG/m4CwbzADMSPwk6K/Glp1LKXaIYLynePaUlH2Jk4pkcSDwgFBs4LL
	 +Aldn2Q4qE6KObBWK7dmkaIS6AnBRxSD9xpga4PPGcfbB64Ipwdlo36EWbS5FJI2tw
	 NJiG0C3l342Wg6JiJAC8gZqzpaT6fYt4GpUCJa9BPZLNpX7Z0LojT1v11JvfNMX0Ax
	 QgkYp/drI7lJMmKstXTO6hdsuTfOkL9poxqFOly8MjaGDVN6xQdd6+AVpG9e9yjtgb
	 ANrbqGhyB83wSaWsekJPZlsNXL5It/LTR09D0NSSu4lQwgEGPg+E+KGjuFuF4ZRJTx
	 WHujZYOL/BFmw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SKrlF4DvRz4wcg;
	Wed,  1 Nov 2023 13:37:45 +1100 (AEDT)
Date: Wed, 1 Nov 2023 13:37:43 +1100
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
Message-ID: <20231101133743.70454594@canb.auug.org.au>
In-Reply-To: <20231030125302.250fc7e8@canb.auug.org.au>
References: <20231030125302.250fc7e8@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4y4=U+6yjH0ay7I=XYwtotI";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/4y4=U+6yjH0ay7I=XYwtotI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 30 Oct 2023 12:53:02 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm-riscv tree got a conflict in:
>=20
>   arch/riscv/include/asm/csr.h
>=20
> between commit:
>=20
>   43c16d51a19b ("RISC-V: Enable cbo.zero in usermode")
>=20
> from the risc-v tree and commits:
>=20
>   db3c01c7a308 ("RISCV: KVM: Add senvcfg context save/restore")
>   81f0f314fec9 ("RISCV: KVM: Add sstateen0 context save/restore")
>=20
> from the kvm-riscv tree.
>=20
> I fixed it up (I just used the latter version of this file) and can
> carry the fix as necessary. This is now fixed as far as linux-next is
> concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.

This is now a conflict between the kvm tree and the risc-v tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/4y4=U+6yjH0ay7I=XYwtotI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmVBufcACgkQAVBC80lX
0GwhQgf/VhKxVFTnb9O4m7ZXuCCW66Xp3NHf1tADuOxPYlg5mUMKlwBHXlXVleNn
QiBg+Rujt/1FBmiXPJjiYwDGXaQcu9zkKoi3fe7vbX2zzLGfdDLm3SKdje8q10uS
lnsIKiUc4bz498tkzDPwJ345s1zsji4YHiEPWw+nG3PuPkmHSF5bnj5AjErLj5qy
Per14S5UBvUE6BGHOae81DNeaLJ8ve6Yep97icATgpxZ/V+Wh5/qYXTrfWHvWqX1
oyi/jebBRMzLMt8LNO2DCzOy+zHIT3S+Xr7vNen/qWB9VwZPCxtH2971xZOS+svI
OLukwv9Cv+hF74UTcpv2SUIEfLWi7Q==
=fGHd
-----END PGP SIGNATURE-----

--Sig_/4y4=U+6yjH0ay7I=XYwtotI--

