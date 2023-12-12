Return-Path: <kvm+bounces-4192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6893F80F10A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EB9D1F210EA
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B61D76DD1;
	Tue, 12 Dec 2023 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4/xKCDu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326975434;
	Tue, 12 Dec 2023 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BA5C433C7;
	Tue, 12 Dec 2023 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702394938;
	bh=LsaHooPiHp3ndDNeL8g52+UULWStSBHK+38Nz9ZVSvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P4/xKCDuc0UnUpX5qanZAo4sH/mPS4+0zf1vaulKbDZIW0Sv9PQ2cDn0d0uXo/edy
	 PwoW46GPHh9eFXbwsYIJrJe1kb4/NzaXnF9Rl+9cqQrH8Dp23LYudv8fgNxuVn69/R
	 6sVwb7fKYJpxDvFt9E7wK3jkWNG7bVMpxPsh3UsgxqPEw0vYip33Bck1OZBijJGbTM
	 C6gUWQ8xETxZHS0T3hZE20rdXpyd4RbKLu9kbvQ9UDyOn84RX+NOg+eGin8BFWRJHb
	 bK17BhYxPbRSuylhukcAUw1wUnrg37HZJWHNab0t8f0/DB+OSvlVHl+CpWO7KO5Md8
	 0qvn1DYufL4IA==
Date: Tue, 12 Dec 2023 15:28:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: selftests: Ensure sysreg-defs.h is generated at the
 expected path
Message-ID: <51c74e67-99f9-4a6a-b57f-867e7c9f2ee3@sirena.org.uk>
References: <20231212070431.145544-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yaDGDH+hjRObKyJL"
Content-Disposition: inline
In-Reply-To: <20231212070431.145544-2-oliver.upton@linux.dev>
X-Cookie: If rash develops, discontinue use.


--yaDGDH+hjRObKyJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 12, 2023 at 07:04:32AM +0000, Oliver Upton wrote:
> Building the KVM selftests from the main selftests Makefile (as opposed
> to the kvm subdirectory) doesn't work as OUTPUT is set, forcing the
> generated header to spill into the selftests directory. Additionally,
> relative paths do not work when building outside of the srctree, as the
> canonical selftests path is replaced with 'kselftest' in the output.

Tested-by: Mark Brown <broonie@kernel.org>

Hopefully we can get this to Linus' tree quickly!

--yaDGDH+hjRObKyJL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmV4fDQACgkQJNaLcl1U
h9BeiAf/et+vzxfbUp/hiT2qx7WbdTszCOWf2wmxQZUvJYXPtwcS1/x1DB4PJnRD
3VjnVblQIuDCpdmqTEHVQvpWS0a8DKv1Mc9d4C3JWteq1NmCkPXJCOHIM1YpiMLU
nSDk/Zz4ZqJ3lnY0JPmcxVWD2LjBgDBJg/G96yX3Lw95/q7wmqfaBtDLbujYFRXe
360nPOiaEi3XAayBTz59EzEuy/5p1n87aIIGhu49aw32m9F3na7HyZQsN4LFXq5T
tlCED9LsFHzF4tZQo805W2kzTcMuVrxgorgKmLYFTTniv8rXpZLb3MmT6547WLRo
m97K/ipoY0ot3XrxcsBohCsdwc8y/w==
=0GjW
-----END PGP SIGNATURE-----

--yaDGDH+hjRObKyJL--

