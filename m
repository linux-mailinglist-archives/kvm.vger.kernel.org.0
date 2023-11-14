Return-Path: <kvm+bounces-1626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1516E7EA8FE
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 04:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86941F23C74
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 03:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DBC88C01;
	Tue, 14 Nov 2023 03:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="rLLBCTa2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01688488
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 03:13:30 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3277C91;
	Mon, 13 Nov 2023 19:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1699931608;
	bh=mEjM4aj+NkL7GUkm5VQRa7ZEFTmJWuTrMYLwB+YCYns=;
	h=Date:From:To:Cc:Subject:From;
	b=rLLBCTa2KsDb0Xhg+fv9eL6HJ7PlKLX/fQfTyabroEY5twa6b9bosOycxzSG0ES1m
	 fyuZttRj/+rrOZVSvVY/OzgIe+w7Qw6zuVLLpidFOdM8DErQycSUc+D1kvol81aLJ1
	 hTZ6nmAOGA3H6uTzT/4laSmHhmi8wazn+XXOH7S9M+GfychtRjKBBZSYY5ODT2QQVY
	 ut1D3n0Ycp6JPlTpUsHijl0DrQ4668Vg1HR4BkQaJno8YMSx2+BE8I810LT9zGTEaB
	 g7GsGW8/y6DxM3w04JSxCzrFvxyJ+jWOckk+mEVRvD4V1zGmrPnNZ2eBUTg7PXWD67
	 8smnWHGujr2KA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4STrwR5xVKz4wch;
	Tue, 14 Nov 2023 14:13:27 +1100 (AEDT)
Date: Tue, 14 Nov 2023 14:13:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20231114141326.38a3dcd4@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+DOfe=f.BDu0TPE2QI61Sg+";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/+DOfe=f.BDu0TPE2QI61Sg+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/filesystems/api-summary:74: fs/anon_inodes.c:167: ERROR: Unex=
pected indentation.
Documentation/filesystems/api-summary:74: fs/anon_inodes.c:168: WARNING: Bl=
ock quote ends without a blank line; unexpected unindent.

Introduced by commit

  e4c866e72563 ("fs: Rename anon_inode_getfile_secure() and anon_inode_getf=
d_secure()")

--=20
Cheers,
Stephen Rothwell

--Sig_/+DOfe=f.BDu0TPE2QI61Sg+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmVS5dYACgkQAVBC80lX
0GxaRAf/fSqatinvrWZzaI2/+c9YCjKfIzui+Dbry8Gh8GdZ2g5DlY0/LnxSkMyi
UrFZ1Q6BchZDUHhAcXqbQBC7Gj9/NJ70n3h7stAKfzbd8jIQbpd/Iw+3FWMIT1gk
2MiCrWDOd0wmmPw7KMPzuHGEMaIIjPl4H1LmLB8U17Za1jy+JZ83Sn/KiJmSpw+O
9OjKf2LNMEWkFpv6v0Hw2/nnBHDx2pJHpPADd2YSVPH7Y2VWSUerAs1X+IyJmOed
Ufy19ttVQyNn/TvvPG3xRODXE8aSmiVMn/X7ZUfzFCtbUAGS7Lt/pR5BVxOZfXou
SC2THURxPiB5dqcajinlvvOssEYXaQ==
=Tp1g
-----END PGP SIGNATURE-----

--Sig_/+DOfe=f.BDu0TPE2QI61Sg+--

