Return-Path: <kvm+bounces-5141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD6B81CA83
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:10:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 747FAB23F4D
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1116B19443;
	Fri, 22 Dec 2023 13:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gU2VwFGp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A621863F;
	Fri, 22 Dec 2023 13:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF58C433C7;
	Fri, 22 Dec 2023 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703250594;
	bh=JPi9QFizO6dQFDu6f3b0ceAFOR5lY0Ihptjl/d/q+8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gU2VwFGp59ErPQDLIzr3fztJK2LcJHYhLvaC7zb0FlZ1Pe9u0rIIATiegZubtwiNA
	 AKOhNkqXBeVTgQ4ayExj0TTCOITf1IPjEyjUefQmrhnBSJSA1t+tioJ3CZSaqJp7zb
	 3ChuTmz6VAW1bHKnDK3bCDVYM+kRL3NyqE4B3c1I8bUWdpj1TaqpAdAQsDTdNmzRfW
	 TSlIi55AMGJXf+wxl8439BXsq1e7MYYwBMhFw6/ALV6NCTqEBq+Qt80WIr3bJBupL/
	 aNwon/RLwFaSyoqNdl4ywquKK4RLHDnOwUFuch2i1UiucFJvE3HWhEYRwXcLyXyvA5
	 mUA7gSJgLfHxg==
Date: Fri, 22 Dec 2023 13:09:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
Message-ID: <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
References: <ZYCaxOtefkuvBc3Z@thinky-boi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t5twuZwSLZu7sEe+"
Content-Disposition: inline
In-Reply-To: <ZYCaxOtefkuvBc3Z@thinky-boi>
X-Cookie: Familiarity breeds attempt.


--t5twuZwSLZu7sEe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2023 at 11:17:24AM -0800, Oliver Upton wrote:

> Here's the second batch of fixes for 6.7. Please note that this pull
> is based on -rc4 instead of my first fixes tag as the KVM selftests
> breakage was introduced by one of my changes that went through the
> perf tree.

Any news on this?  The KVM selftests are still broken in mainline,
pending-fixes and -next and the release is getting near.

Oliver, should your tree be in -next?

--t5twuZwSLZu7sEe+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmWFip0ACgkQJNaLcl1U
h9AyGQf+Jf2jjHDJkXIG6X0m8labz+op6RXGaBaSoP/zNl00m24GfUSoBp1NjZ8U
F8zMFpvFTNxOG2CaX2UFNUWWST2m4s9Dltm1vmCkvuxGwXRX3HzjKtxhbgghOxzh
L6AhcYlafcMAW9gc3KcsCUeHpVygySSODpJKPsnian7YzRAZbU3czBqtTclPMB9g
rclyw7dIztQPFblbKqJ+ttPwn8ww2eRImWXZ7SLbX/ay2eICT/kXOnV/TKzlkm5h
p6amLmr+2O2keDYNnhcpWRwvlYZcMIgaLS8B0XgDHzdBZHudLZavS4zDFwpNp9Sj
UXxr3et4ubELmkFvGS+CS39T2hGyLA==
=CikZ
-----END PGP SIGNATURE-----

--t5twuZwSLZu7sEe+--

