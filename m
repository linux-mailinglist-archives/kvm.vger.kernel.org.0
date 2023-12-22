Return-Path: <kvm+bounces-5144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C5381CAA4
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A88F21C22071
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDC01A5A2;
	Fri, 22 Dec 2023 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TglPM9bq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD41199B3;
	Fri, 22 Dec 2023 13:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C89C433C7;
	Fri, 22 Dec 2023 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703251572;
	bh=5mdushCAmtR12NQk3ifRoO1LyOIlnT7HdbcjSWRhkik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TglPM9bq3oy2vGbxTFrwxMkG5/gsLolZBBLfdu8rjVXyhsIzdXbfINR3c550WPKt9
	 FBruII+Ufv/qAd7MaBc6IkWHPafa0opnPsvhF3ROiGKKF23hzL5CXIwqZ5WKczvJZx
	 IsHrTG8+Vm4/jG542C5HjyzLFbC6hG8fZQAwcmmwIC4ucu1OIbgHrqu6OyEO/j8DNB
	 33uE3XUOallwtgZZWeRJ996rGgPxenYg/qchsZMI1GAzCfap5iwiIBNMSTYHq08UY2
	 v0qd+sCK7OLs784FKcoo8Q+rJHm1kkIOj252qMrQlo6cqBpzIqAvoYFiqNC62//jKu
	 CVRkr8oRSef3Q==
Date: Fri, 22 Dec 2023 13:26:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
Message-ID: <ffbca4ce-7386-469b-952c-f33e2ba42a51@sirena.org.uk>
References: <ZYCaxOtefkuvBc3Z@thinky-boi>
 <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
 <69259c81441a57ceebcffb0e16895db1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aCohuyrkSZdqp+0d"
Content-Disposition: inline
In-Reply-To: <69259c81441a57ceebcffb0e16895db1@kernel.org>
X-Cookie: Familiarity breeds attempt.


--aCohuyrkSZdqp+0d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 22, 2023 at 01:16:41PM +0000, Marc Zyngier wrote:

> > Oliver, should your tree be in -next?

> No, we don't have the KVM/arm64 fixes in -next.

I see it's not, I'm asking if it should be - given the latencies
involved it seems like it'd be helpful for keeping -next working.

> And we have another two weeks to release, so ample amount of
> time until Paolo picks up the PR.

Sure, but we do also have the holidays and also the fact that it's a
build failure in a configuration used by some of the CIs means that
we've got a bunch of testing that simply hasn't been happening for a
couple of weeks now.

--aCohuyrkSZdqp+0d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmWFjm4ACgkQJNaLcl1U
h9DmqAf/U2FfS7BUjQiwi9+P7v5s90HdXeVFdk1PYFrUAE/f1c7zp+pVXYMBNa50
Mw1zXUBzZ5/9dslhY41lHo3P/+gNdovj12H38g1E2Bn6wJHpTu9tBYC8bBhCfh6S
mZaaz7w5K1Njl+DxgWZqhQObIGbUNIanveOl/td9ng1fcK63E7jOxQi9nrqXPg7W
vh+pu/dXVhxv0qM1SWVmnHfOQA5rA03VsGqeWVucyT7CLSJRmDOe6giSd25mt1RF
h3anD71i2zRJONrmzYkYu2EEZZ/uLGEJwBztcm/ZnWdSO8VhvzG5OilY6JqOS//y
acUsXDpkn3EmAqZxy8JnrZ+LsvD18w==
=94u/
-----END PGP SIGNATURE-----

--aCohuyrkSZdqp+0d--

