Return-Path: <kvm+bounces-5909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B831828EE2
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 22:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0234288642
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 21:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5830D3DB96;
	Tue,  9 Jan 2024 21:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="DmOTk+zs"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3B03A1AF;
	Tue,  9 Jan 2024 21:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1704835868;
	bh=/9TbmG1mkTviEJzln1X2ZoBNOgGeQX/25p7+0ORbndM=;
	h=Date:From:To:Cc:Subject:From;
	b=DmOTk+zs/oHGjh1AUqBg5mrYP4jAgorqMZKBY4PeRBUI+6N8Euq/ozWVqGt/7dklQ
	 MJ2OochfJcTfCo2aZr/+/prqoF2YStRGtaKllBdlioq68GxUhz/3wEmuSyb78t3waz
	 3BRGz/CezW1AselOT8chbD8MCIJhtmwTAHCqiqFsyJONBrWwOLB070B6Zg8Q23BwUJ
	 +Nx0sGQe2EZrg+h88jrCJVLvyB5qQW+tYoOHp9jDLDr4A/dQVw7ia+IEQ5wBtbfBXf
	 jftYicEt65sT/5owAIlpaikGozSdyeyglmtTZ7fhzUSPFvfplStu3A9Qat6cPp97Bu
	 4Sgw7l86TRnNw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4T8kd83SnJz4wcc;
	Wed, 10 Jan 2024 08:31:08 +1100 (AEDT)
Date: Wed, 10 Jan 2024 08:31:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20240110083106.72679ebb@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KKBi4oucxbLPHYvMR.Ur=8d";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/KKBi4oucxbLPHYvMR.Ur=8d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  caadf876bb74 ("KVM: introduce CONFIG_KVM_COMMON")

Fixes tag

  Fixes: 8132d887a702 ("KVM: remove CONFIG_HAVE_KVM_EVENTFD", 2023-12-08)

has these problem(s):

  - Subject has leading but no trailing quotes
  - Subject does not match target commit subject
    Just use
        git log -1 --format=3D'Fixes: %h ("%s")'

The date string adds nothing.

--=20
Cheers,
Stephen Rothwell

--Sig_/KKBi4oucxbLPHYvMR.Ur=8d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmWduxoACgkQAVBC80lX
0GxPnQf/d+G8l0m6AWEydBIPKO6A1jqklfdecqctL4v8oEu9fOurMnpwKhNhGxgu
HERbwbXYcqRqA9FHWqN+FkmGPiBJpzknO/SybyjBPEcDz5blYvPUS4WnxYUHtrpd
HnR0geLgfQoy1w40ulzq4SzcFSHfeG0pUzhYnznU6f646W9cFBH7YwIifs8gPr96
+B0gVlk2Cclq3eFhxblNpVvGYoobiTktRm6aR1aTmbCXOP7d6eB0Ytr0Ez5kVBNL
1phyZSj8tAqS20Oy+yo8a2DkPt0eFXq4ijofIn2OWTnKWTRMyZ+QL7IPVifGydGe
W3wELH7OFYCu5Cyi7cbF8uPqUyaWDA==
=mDSd
-----END PGP SIGNATURE-----

--Sig_/KKBi4oucxbLPHYvMR.Ur=8d--

