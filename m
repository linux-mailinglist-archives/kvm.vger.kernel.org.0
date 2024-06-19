Return-Path: <kvm+bounces-19988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7332790EF7E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4851C216BF
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FF314F9D9;
	Wed, 19 Jun 2024 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLDfWOkJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731221DFF7;
	Wed, 19 Jun 2024 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718805304; cv=none; b=g1pwxgDaj1uqeTBhYevSxn2/dPCOV16Huq5qx2H6HXX/I1pdCsFnq7Cd8QuEqgspQlMC2DCflzDa/LtyxhADu+gTTMHIO51lKx0hC0A2N9xm6Wn+FVxhmT4fsjp8NNJYUiiXmOC3Jn4+j5X9uk5h6uE8xme42w8MN6wkuoXPlJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718805304; c=relaxed/simple;
	bh=2L+1+gYamAC+cVSHQFSO0PZ1BNdypHQRZrJb2/vZugA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Jm+9YFo0yip9Pe/UZDRMoZlAckBeTZRqD9a75Lf6kUtto6MlbqggJ+jT1lCWMrQLAg+0xzGojJ4wIf12X8MGpKG3vpoa26y3y522rhWRB7rDa97xlLExFsabBoDVjXHFUkrMQcTSBL9t/q+nrRa+1SG99977iR0AmbkRxzxGuhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLDfWOkJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB5BC2BBFC;
	Wed, 19 Jun 2024 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718805304;
	bh=2L+1+gYamAC+cVSHQFSO0PZ1BNdypHQRZrJb2/vZugA=;
	h=Date:From:To:Cc:Subject:From;
	b=eLDfWOkJs16coIdHaDXkWEYi4Ygwc7SSM9NMfot3FR8z4eYvk5oGV0UWLHh2CRWYk
	 eO4+M4u6nMa4C0pWij/NKtp8q2GAKl1h29Rbv+2dQ74MNYrVJpPUBZ012KJZpxgWwY
	 jwV/SQQUEO3QSPTg22SLHPP3MiJ9ExIa26+nSf/j+1uAg6v9aqJ15MX9MIUXi70RUl
	 bNi0B8NLH+YgUn7xh2zs+Wk4wlMlUdcoAbJUztUxrxWHrM/kRVW4bVXRZfQ34R+1Qu
	 wZ4T/bcd+1beBKR2+b0e55vjHMJAlvD9E+D2bqk1+7fWz/J85xPLMuexQ3jphpKJ0X
	 g3Eu2NxKJveQw==
Date: Wed, 19 Jun 2024 14:54:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Borislav Petkov <bp@alien8.de>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <ZnLjMxzFE6UCPhqi@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nQUwDpK7LRDpRSib"
Content-Disposition: inline


--nQUwDpK7LRDpRSib
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/include/asm/sev-common.h

between commit:

  34ff659017359 ("x86/sev: Use kernel provided SVSM Calling Areas")

=66rom the tip tree and commit:

  d46b7b6a5f9ec ("KVM: SEV: Add support to handle MSR based Page State Chan=
ge VMGEXIT")

=66rom the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/x86/include/asm/sev-common.h
index e90d403f2068b,8647cc05e2f49..0000000000000
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@@ -98,19 -109,9 +109,22 @@@ enum psc_op=20
  	/* GHCBData[63:32] */				\
  	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
 =20
 +/* GHCB Run at VMPL Request/Response */
 +#define GHCB_MSR_VMPL_REQ		0x016
 +#define GHCB_MSR_VMPL_REQ_LEVEL(v)			\
 +	/* GHCBData[39:32] */				\
 +	(((u64)(v) & GENMASK_ULL(7, 0) << 32) |		\
 +	/* GHCBDdata[11:0] */				\
 +	GHCB_MSR_VMPL_REQ)
 +
 +#define GHCB_MSR_VMPL_RESP		0x017
 +#define GHCB_MSR_VMPL_RESP_VAL(v)			\
 +	/* GHCBData[63:32] */				\
 +	(((u64)(v) & GENMASK_ULL(63, 32)) >> 32)
 +
+ /* Set highest bit as a generic error response */
+ #define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
+=20
  /* GHCB Hypervisor Feature Request/Response */
  #define GHCB_MSR_HV_FT_REQ		0x080
  #define GHCB_MSR_HV_FT_RESP		0x081

--nQUwDpK7LRDpRSib
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZy4zIACgkQJNaLcl1U
h9Ac1ggAgkntQi6/mci/5sPhuewuaPr/pC/ZfJHq+36pfpdyL6J13Tq30j1ZVnr5
h9WfzGd8g4wyOUN0jfXJRunOtDbYDNi/B2r+rLikhtUW0VKPKsPl1xQX2pODRvYN
Zg9+Nj4WQ+Ir5zslNjNF97+4IExUaxSDkqeja8LlZ5PEzOPGpuLriYJEAH9D7svp
I9BFrGeOG87IKfRS+skYEwDFTiTTcsgDuZ4S8GeYA1M4tDJXSLiVT1aDWhTKbnhT
KS0/2KwhngcdcSDR6xlhs/xvzwkTtsTVza1IpGG10r8rOp53LRNRa39pG9kDKGn2
qmBgRuJFC8jL3/XDNnlNKzk2kuxdAQ==
=cDeN
-----END PGP SIGNATURE-----

--nQUwDpK7LRDpRSib--

