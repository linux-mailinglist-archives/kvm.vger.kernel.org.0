Return-Path: <kvm+bounces-4006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 415E580BD79
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 23:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1B3D280C15
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 22:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7F21D53C;
	Sun, 10 Dec 2023 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="YWzrUP3L"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333ABCF;
	Sun, 10 Dec 2023 14:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1702245597;
	bh=AUNfz/WUo0mpeLmt0K3ZA76hXqurTm3No7As+VGKfwk=;
	h=Date:From:To:Cc:Subject:From;
	b=YWzrUP3LGSjne2bEXdXp3tizEc+xLNQEVN2NDGmudA/+YyGX89M9lpdN+2x2Byo8v
	 G1lj+sfp+XyV2GOFZyCEUPNsGzJFUnBJk40rNq1riPGuFjUpOLtCC9R6CmbKl6Pp8j
	 lG6J/ZGDRWbRRoPVgfPpycq2JIfPi+RuKzckRG0Ii3Plw+/NNuMOmTWzQiyYL6fAU1
	 yacequgirX0M3mxjKYJuYMDMQDVk7wy6P8/torYWidP3+o6sL/TZnSRFUk+nECMLvH
	 1skbaIEKwNjrMo8m//fdZ1FpU9omtrgrMNs0eUmb7wHvp2QnQHp2+wlY1fIslKNw4U
	 09aDFn7bLRxgQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SpJhF3JZLz4wd4;
	Mon, 11 Dec 2023 08:59:57 +1100 (AEDT)
Date: Mon, 11 Dec 2023 08:59:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the kvm tree
Message-ID: <20231211085956.25bedfe4@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/d.2RVOQPXloefmNqMqrVkhd";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/d.2RVOQPXloefmNqMqrVkhd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in Linus Torvalds' tree as different
commits (but the same patches):

  3b99d46a1170 ("KVM: selftests: Actually print out magic token in NX hugep=
ages skip message")
  fc6543bb55d4 ("KVM: selftests: add -MP to CFLAGS")

These are commits

  4a073e813477 ("KVM: selftests: Actually print out magic token in NX hugep=
ages skip message")
  96f124015f82 ("KVM: selftests: add -MP to CFLAGS")

in Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/d.2RVOQPXloefmNqMqrVkhd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmV2NNwACgkQAVBC80lX
0Gx8qwf/bSEAD8b+ubhA+JFxP5GiDCPawNR13jLf7YtPvXqYsS2Dw2fl+sl1a8Sl
d6WwYoyOhIElm6oNfxX0LoymDXTHx9W6HURip1qCD3vAVMNgAX9QInr/gtGmqSuS
vDbKXGQH0sAAPsQ+nmiN51buWYOKJ+yut7yaLnO6IpGHTrVCTxAjiqwD9dKapLmV
qMkAHjeRl1N5tjOkzm/vNMhOcPJ2EEc+UYRpk9zIFw4TzcvMBOmZVJFf7SBuazbz
fz+hhO0/35YPz0sH1pdpsvF/1SJ9iqQjGWfVi4mVfdBSNmqOzcaBdUqVq6ajHHsk
VhvpkROCC8twJHWtVtH65xCc7um/0g==
=qKtq
-----END PGP SIGNATURE-----

--Sig_/d.2RVOQPXloefmNqMqrVkhd--

