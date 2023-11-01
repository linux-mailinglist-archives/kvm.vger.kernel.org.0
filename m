Return-Path: <kvm+bounces-269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0617DDB09
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FAC71C20D2E
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 02:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14BF5ED7;
	Wed,  1 Nov 2023 02:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="nc14nOhl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74A367
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:36:12 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682A8BD;
	Tue, 31 Oct 2023 19:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1698806166;
	bh=TxYijZCRoh5ojMbiyuaBbdMRPr9YE0sS1cIswYJBrNw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nc14nOhlvjNPxk3F06m3sjqwkgaRGnmXpMxzTrN14V44ZH9c9yeBLsiFnD/+HB4F7
	 s+TFBz2t2QJGytVoOCag8Hveojw9M9y0SU/Hw8WaN7l4ObQC7bI6oSOCfD4i/wF/Ys
	 Q4eUFpF5/dpFJQ/u3tufZzTA0XNnazUKnywTGB/cIJ/FJF9GZ1p+8kr3xWqz3dQ4c+
	 80Cro+gRyF60tEpeApZf7cToBOibXON0eF4bRhtJ22hLfDVNESD8Kc5F2KGfVCc0GI
	 vtLfoTJs0i5zoWiN+47ffZXf7DquDReUg7REhdqBVrlTSsvWnf+jn5nQFlfkykBEfz
	 dGVxV2lBmYx8Q==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SKrjK69Sxz4wcg;
	Wed,  1 Nov 2023 13:36:05 +1100 (AEDT)
Date: Wed, 1 Nov 2023 13:36:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64
 tree
Message-ID: <20231101133604.4edad0b3@canb.auug.org.au>
In-Reply-To: <20231017123017.3907baac@canb.auug.org.au>
References: <20231017123017.3907baac@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+QxrnIxb6+.k+HEe3OnigdV";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/+QxrnIxb6+.k+HEe3OnigdV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 17 Oct 2023 12:30:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   arch/arm64/kvm/arm.c
>=20
> between commit:
>=20
>   d8569fba1385 ("arm64: kvm: Use cpus_have_final_cap() explicitly")
>=20
> from the arm64 tree and commit:
>=20
>   ef150908b6bd ("KVM: arm64: Add generic check for system-supported vCPU =
features")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (I just used the latter) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

This is now a conflict between the kvm tree and the arm64 tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/+QxrnIxb6+.k+HEe3OnigdV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmVBuZQACgkQAVBC80lX
0GwH5wf/RdBQBcblcMFtgM49SEUF4RHWBHhiep/hIg6tPWG7pKPVgKeyold61+3s
a0ifRXxLD0IuXgPuHoiX39UfTE4yH6TcYOaZ8mkZTX3DthWbFGUxINPDgc3TuWMz
tXNYH7xvCVFHPUI1jiSeVBT70BjJ4errJm7aG6OxisEEhbKsBENJJpijmuSaCM5J
lqmyxsyhGWHrEkoVN+Jim7Krr2c8v1glhbpmqK2rR1JY4ORCm1SPPZJ73cM1lKxn
SbBmaOJIqw18H644nM57jPMZcudLI5oXlDK6SzBbbUKShP/Oab6gSR0tgWz94dHP
fImX/y4UFkKfrlrziffVjsnrixEKjw==
=hLaM
-----END PGP SIGNATURE-----

--Sig_/+QxrnIxb6+.k+HEe3OnigdV--

