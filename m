Return-Path: <kvm+bounces-59434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 823DFBB46E8
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 18:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2018919E0222
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 16:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7EB227599;
	Thu,  2 Oct 2025 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INDhLYg8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3408E19F127;
	Thu,  2 Oct 2025 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759420871; cv=none; b=HUYPV1FdGso+TIx+v1g9SZyl+vSSw4+Z2o+OY1NrnklHpBzghLchAmQ/2aD/z3BLAMoBqJc25JKLfDr5DXx6lknu5qQRMeGw3Wp6X1Bc3dSqLjiCrD4m6Xyd9r5VRw6182XAZZEb1ncOaoUBYlO2PCthN24SWbrEq9w9Zqb+vxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759420871; c=relaxed/simple;
	bh=AZPSBFYCIjS5xV6SLPct7R9cTCi/OTV+8qDbbOzqpIw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VrWgjNEn/nBCwK8DHtpjPGaR2xeIs2aXWebWG4q8qxWnOpMHvENbZ8S+J3FDq3VuL6wBOLLZoT07pmZNyvUKX6vXC3OKo6cSGln/9CYre4MhhjxXPjC80ZiVtJdCnAlzDZzl1dj3eDMNMJSWIY3H7qIIUH95oHscIue+pjat+CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INDhLYg8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AA4C4CEF4;
	Thu,  2 Oct 2025 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759420869;
	bh=AZPSBFYCIjS5xV6SLPct7R9cTCi/OTV+8qDbbOzqpIw=;
	h=Date:From:To:Cc:Subject:From;
	b=INDhLYg8Q0+sSmM5DC38E/vcwVrlswanWcgPKExgdQ+BQ1Bt8BvhsonbiQSADJojB
	 W6VQ3kY8VhlIn5WcoG8gzIY6i6AhkmKobm4ilP1TwCBmglI/cMDRzVGrlk7byYr0oR
	 sqbdTewbPlQ/gQ6BiUdiNxCiRpEvohNtCXHOraFbmFaiBJZJXjyw4xvqHuecMhjFlz
	 f0zy3IFQuCZ3BvjFB6OnzuI3QcGQdEG46y9LXjHD89mh4w20RFHqG/G/Jhrnsb0/hq
	 FIwqrMZSX/4EJWkB22EzuvmdOeiPhdOg1WkTgkM7eWaPtu7zKK0G/x3rJeuwmfb792
	 r2urE3nXf2yug==
Date: Thu, 2 Oct 2025 17:01:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Babu Moger <babu.moger@amd.com>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>, Xin Li <xin@zytor.com>
Subject: linux-next: manual merge of the kvm tree with the origin tree
Message-ID: <aN6hwNUa3Kh08yog@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dMCEnt+bT9Zc3PZR"
Content-Disposition: inline


--dMCEnt+bT9Zc3PZR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/include/asm/cpufeatures.h

between commit:

  e19c06219985f ("x86/cpufeatures: Add support for Assignable Bandwidth Mon=
itoring Counters (ABMC)")

=66rom the origin tree and commit:

  3c7cb84145336 ("x86/cpufeatures: Add a CPU feature bit for MSR immediate =
form instructions")

=66rom the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/x86/include/asm/cpufeatures.h
index b2a562217d3ff,f1a9f40622cdc..0000000000000
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@@ -496,7 -497,7 +497,8 @@@
  #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TS=
A-L1 */
  #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers usin=
g VERW before VMRUN */
  #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-u=
serspace, see VMSCAPE bug */
 -#define X86_FEATURE_MSR_IMM		(21*32+15) /* MSR immediate form instruction=
s */
 +#define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring C=
ounters */
++#define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instruction=
s */
 =20
  /*
   * BUG word(s)

--dMCEnt+bT9Zc3PZR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjeob8ACgkQJNaLcl1U
h9BB9wf+ORnhBeVabhjjATUrOjlox0RBiVs7xg381xsH/sMNw79c9YxMKyFVhzlI
4vz4+KahOaXqfKPKWHYyHcb6RTd1knf/V9uBSP8A/7sz4kBhL8Q6cRBFyWemRPqD
mRqfX8bTrmixW468VS08Mtx5/hGOKRxjdrnSba0JddD8ORWiv90uv+PoNkqUpDb1
VDCwv2UUjW5+9EZYWQE/fdEhJzYw+JaHxhvwOCZLZ+Td7dZQcg2eQhid6ujT4lGP
558YFCX9+ztvB5QHjV8csNfR8H5pIRds4Yp0HV2m5Ew/eoUnGTfvUWo1oG0Khn4n
Rg4VU6XLG7HfayNw96wnzUwBEZbhWw==
=tfMq
-----END PGP SIGNATURE-----

--dMCEnt+bT9Zc3PZR--

