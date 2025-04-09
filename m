Return-Path: <kvm+bounces-42981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E93A81B67
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 05:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744498877D8
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 03:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF22C1B0F1E;
	Wed,  9 Apr 2025 03:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Fhnx6Fml"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176C6208A7;
	Wed,  9 Apr 2025 03:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744168442; cv=none; b=hsK2223OF2QIkeLj7zvNvL8MDWPpNTMKU4KQQW036pF7k8T9WekqYc+/0SRAQvBjRABccWlOuJBy6k05RY/2u53cV5SomedAm22C1O7rZD4M29w2rFwvj6/7QtNMRk8yOZbOMgLxh0WqwsPo9PJF98wK1O5WYyULRnxn45cIonA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744168442; c=relaxed/simple;
	bh=XAPcpv9dTklZmsasy4zmEQvK3EyDsEJFLgD/1VBWPmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ABa1Jf9WtytnL5aH+31MOtmf51Dx9p1tlyND0XqsZyiCmsM3rlBWywjvF7I/TDU9felfRnQTjdF6phivkDicKzCu0975rbOV9EWmBiSgG3B2Ohl7EjWYZJW05unpamJkyhHmSHtLmrE/1gvXS714mpBnqU4Gw1iCKZ+K0dr6Vq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Fhnx6Fml; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1744168437;
	bh=WvgaY+S4ye8DGa4tdVR2rxD+TZR8otsnswSUDyvbRWc=;
	h=Date:From:To:Cc:Subject:From;
	b=Fhnx6FmlKPpqfQJnpfUXeXkp8VOI/sow/+7KxsFQGKppD616SxPsAkQMExHcIJA3C
	 bc/eLJWNDT39bpEapWZspYmw01ZrZUzorBhoE9snEluyzDhbXbd6VRSrcnSbJXk09R
	 wzPvu4aN9OYqQXOYt59FSORa4EqFRipKey+RaChac6FbaRm29H5O1zsRiScrWtcgQW
	 iGY/zB5/zoejRqaw3zEsS9mzuBjMplAoS0u7BxHv8SSShbTp1Cz9nKTWSG9q5TyvPG
	 8yIFM1bARYCRmo4lN2XeuAsJe/Hl4PiWfEDwMasql3Bx1DU8R/hAPR8vN9y9/Q8/IS
	 Cb406WgPl8pFQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4ZXShh54DFz4wbr;
	Wed,  9 Apr 2025 13:13:56 +1000 (AEST)
Date: Wed, 9 Apr 2025 13:13:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20250409131356.48683f58@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bAYEvJNf8ak7D_zauYbxM9o";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/bAYEvJNf8ak7D_zauYbxM9o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is not =
referenced. [ref.footnote]

Introduced by commit

  52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Extension=
s (TDX)")

--=20
Cheers,
Stephen Rothwell

--Sig_/bAYEvJNf8ak7D_zauYbxM9o
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmf15fQACgkQAVBC80lX
0Gw7xwf/XAnHjhuIdQpdOMS6BFaaqionXtYdMFMrOqD79BDY/6QQmZAoO7zf1N7v
3kXAgsGbXLi+FqIW68qRXIW+x/wjyxzui6a+xSIxiXoqUE5EAVpW9gUU1/rKKu9z
TXoOpxBrEi3n5iedLKIDTWHJO8qQz/fG61/IyrwWSCJhxQiBQQVAlxM1OcDwPsm6
8TsnZE1vSJxS5FXW6NKYJdTKsTtU7mVqbhEeqg1SIbCeMvCJ6yG/6tM8vyxxqrYB
u4XM/lW/S0JTowUctRXdZL3IbjIvc1N1FUP9KpZAofWK3ftymVE+MJu4UuPflueN
5kXyCfF002GIT6cbPGJbsOXlHod7BQ==
=NmTX
-----END PGP SIGNATURE-----

--Sig_/bAYEvJNf8ak7D_zauYbxM9o--

