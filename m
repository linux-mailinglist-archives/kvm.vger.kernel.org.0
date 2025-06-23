Return-Path: <kvm+bounces-50273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA70AE3598
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CA203A825A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 06:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078801E2847;
	Mon, 23 Jun 2025 06:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="OivJcPAt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA2570838;
	Mon, 23 Jun 2025 06:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750659680; cv=none; b=awL7X4e46g6sqix7aeuevGb99509gVFfiHGWHjNiAMyHKdqUinYFTZcCPmNJyMdwTlaVYZNFSm1nbKOBKIsh8g3zoetW/1/+w4r8ySEPivW+pJvfrq/j9T0CgEs58vkXEsuABMbMVEfOTtVDN08RvxuDi99/ntqP72caEvoTgQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750659680; c=relaxed/simple;
	bh=w9ArxVT1FN7vw+Kp8reQCAfu6ps4EtTrnIiq+KM96CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=iUV+g5Ru8kesSW58nJA9yohw6Epk0kJTO00//8PWyO+y6Fa6uCIn324lN7t6Pst5YO4c6AZzwYTifpBg6Q+dzsphIAz49mWf2bZakXI7EGBSKPlAyvVk4QhKCcJChrxduI+wt5HMBaSip69+msBEnw7p37XALbZ2Ls1gWFPZV98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=OivJcPAt; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1750659671;
	bh=+qiHFWW8Vx9ZKoLKXtcKg9JU1VCbWzliDXLeKcRlTbc=;
	h=Date:From:To:Cc:Subject:From;
	b=OivJcPAt2k8bM9+gOWewQPEIuYLveD9O59J73HlW5gyRQ1CgYLXbEkQqChaP6M7K/
	 0oBRQi46rK/G3uj0LV9E5waP803/1mcIlacHXpN6ZXAYzY82TLw/imB91RkTU3FidL
	 /r52wA5TWYFJ8zeQkQ1ewV9bx/X6jtTNmKFHfkw5HuhQezi0139CqGz7BdO8aAHYJ3
	 0Y70uT5x9ay7FQGpwfQyd/hRY6ODeklhX+XRDystAu8rad4yFaV0GcqXX1vhnWbahw
	 xZReIGSZHdRYO1GPnLcu13OZjEGFLeU+754kNrqLeCkLFN5MCI2gitQ460DQckyy3M
	 nVjNy0+v5aTmA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4bQdJ729rNz4wj2;
	Mon, 23 Jun 2025 16:21:11 +1000 (AEST)
Date: Mon, 23 Jun 2025 16:21:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the kvm-fixes tree
Message-ID: <20250623162110.6e2f4241@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FF_4nBuLBv5t3N8_YCJTZUf";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/FF_4nBuLBv5t3N8_YCJTZUf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm-fixes tree, today's linux-next build (htmldocs)
produced these warnings:

Documentation/virt/kvm/api.rst:7218: WARNING: Bullet list ends without a bl=
ank line; unexpected unindent. [docutils]
Documentation/virt/kvm/api.rst:7229: WARNING: Bullet list ends without a bl=
ank line; unexpected unindent. [docutils]
Documentation/virt/kvm/api.rst:7234: WARNING: Bullet list ends without a bl=
ank line; unexpected unindent. [docutils]

Introduced by commits

  cf207eac06f6 ("KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>")
  25e8b1dd4883 ("KVM: TDX: Exit to userspace for GetTdVmCallInfo")
  4580dbef5ce0 ("KVM: TDX: Exit to userspace for SetupEventNotifyInterrupt")

--=20
Cheers,
Stephen Rothwell

--Sig_/FF_4nBuLBv5t3N8_YCJTZUf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmhY8lYACgkQAVBC80lX
0GwXYAgAg0nPwHLdVYItZ9mq3SYqz4JfuXPvUJfbr20jutOtVvcPYizvnISgOrNv
AW8y6qBZl2NVqTG4wjsymwzfABbtrWxTQ+byZAUv/hpl5oWakNvtA/DUEymP5zkS
cVbx5n2IHnnTg9yC4fvtH1j8uKVcsIpxDV8/sAOPeVymYDxFzK051AAzyL8CL6QF
8VTZ9FXhd1BAkkEbxtyrYXRY3sTMYBAkN40+W/SfFviQAUH9Ve60cR8I2pGRzIOu
sFK2uctvRNg8THriztzDjoj/GguYUri129sFZO8gr8FbzyzWMSrtflKBBc4jrLDF
GhjDUb5Sd66XUDG6M2avQa57IAGQ8w==
=wNcg
-----END PGP SIGNATURE-----

--Sig_/FF_4nBuLBv5t3N8_YCJTZUf--

