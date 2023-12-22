Return-Path: <kvm+bounces-5157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D43C81CB40
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 15:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D566EB228BE
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491881D52B;
	Fri, 22 Dec 2023 14:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/COoHr+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB00199A1;
	Fri, 22 Dec 2023 14:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A2AC433C8;
	Fri, 22 Dec 2023 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703254856;
	bh=rpP4r+Mn8Htxn9KN1/5jiebpI8ALkSar9OVBAUjvO5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c/COoHr+foveC4IdKnQE5MaeQ06EUZt6zW+JsmerAKOz+SjCm49IzyIF3b77Aog7C
	 5J5sz0XCDtdKI/mLEH1/SaRrHGcfwrHa41Cby3TyBVfSAhudqwTr1/cL6ew7HLy6j5
	 FKS/KxkZHpK5OSPeKyYoT1mIjAtwOn7J7DafiMtkjXlR2/JT32WaCqw/TjGzaukxiS
	 N5QN1LT2/RHpBCjKmS9DroXPhYoDIWZ/w646Wfmra1k1QwsfDZaTMOXgrr8n4gjIm6
	 Ak9tJWcM1YehKCEeClsYz832ZAgvFrAix7cccMcd9giekbKlUbz1wPpwoHnU6AKyMq
	 QB7XRpz4qQU3w==
Date: Fri, 22 Dec 2023 14:20:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
Message-ID: <cc920d55-39df-4255-b194-a2db1dec6bb7@sirena.org.uk>
References: <ZYCaxOtefkuvBc3Z@thinky-boi>
 <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
 <69259c81441a57ceebcffb0e16895db1@kernel.org>
 <ffbca4ce-7386-469b-952c-f33e2ba42a51@sirena.org.uk>
 <441ff2c753fbfd69a60e93031070b09e@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qUFkqCBRZLAnhi9H"
Content-Disposition: inline
In-Reply-To: <441ff2c753fbfd69a60e93031070b09e@kernel.org>
X-Cookie: Familiarity breeds attempt.


--qUFkqCBRZLAnhi9H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22, 2023 at 01:34:09PM +0000, Marc Zyngier wrote:
> On 2023-12-22 13:26, Mark Brown wrote:
> > On Fri, Dec 22, 2023 at 01:16:41PM +0000, Marc Zyngier wrote:

> > > > Oliver, should your tree be in -next?

> > > No, we don't have the KVM/arm64 fixes in -next.

> > I see it's not, I'm asking if it should be - given the latencies
> > involved it seems like it'd be helpful for keeping -next working.

> This is on purpose. We use -next for, well, the next release,
> and not as a band-aid for some other purpose. If you think things

Note that -next includes pending-fixes which is specifically for the
purpose of getting coverage for fixes intended to go to mainline (indeed
this issue was found and reported before the original problematic patch
was sent to mainline, it's not clear to me what went wrong there).  As
well as the fixes getting coverage through being in -next itself there's
a bunch of the CI that specifically looks at pending-fixes, trying to
both prioritise keeping mainline stable and catch things like unintended
dependencies on things only in -next.

There's also the fact that if mainline is broken and not somehow fixed
in -next then that does disrupt the use of -next for testing things
aimed at the next release.

> don't get merged quickly enough, please take it with the person
> processing the PRs (Paolo).

He is on CC here.  I'm not sure that it's specifically things not
getting merged (well, modulo this one fixing an issue in mainline) -
it's a totally reasonable approach to want to give things time to get
reviewed and tested before they get merged, but if we're doing that then
it seems sensible to take advantage of the coverage from having things
in the integration trees.  OTOH if things get merged very quickly then=20
it's less clear since there's less time for the integration trees to do
their thing.  It feels like things aren't lining up well here.

> > > And we have another two weeks to release, so ample amount of
> > > time until Paolo picks up the PR.

> > Sure, but we do also have the holidays and also the fact that it's a
> > build failure in a configuration used by some of the CIs means that
> > we've got a bunch of testing that simply hasn't been happening for a
> > couple of weeks now.

> Given that most of the KVM tests are usually more broken than
> the kernel itself, I'm not losing much sleep over it.

That's suprising to me, other than this release it doesn't match my
experiences too well - there is a bit of glitchiness in one of the
dirty_log tests on some platforms but otherwise the KVM selftests are
generally rather stable on the systems where I pay attention to the
results.  They're certainly not a testsuite I expect to have to
frequently worry about - we might wish for more coverage but that's
something different to brokenness.

The build issues during this release cycle have been a bit of an
exception.

--qUFkqCBRZLAnhi9H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmWFm0IACgkQJNaLcl1U
h9BAOQf+MuK1oAubpWCwy3b1APTrkRTu0rgC0+peM4sFBuogL7w3o88PZv3lxGsl
pZNEt55QbXQMwbJAxjqUCt5pz8M2Y0Uf4MzIW5/+il3A2GrJwa0pZeitu/ssDODp
ed9FPvJL5aO1HjBNINZRCgQXWKi3ZKx68catvht8//wQg1YavAe44lafddkoTSsF
7mHjMn+qNaEIm95TrVJiNa2CVJPd85XMzWB+G2Q7nxXKd83zLZ8Ggh22K2gHScTv
W6NQzDU2q3vd4/iZNMAtjACnTUCTebqq/SCR8cHA0jzJseq8pA42Buqw6XX/bt2y
U+Kk5wLlsjzHNPM1W51MnwlUcRLNGg==
=vXZQ
-----END PGP SIGNATURE-----

--qUFkqCBRZLAnhi9H--

