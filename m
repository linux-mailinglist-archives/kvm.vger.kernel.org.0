Return-Path: <kvm+bounces-59712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 143FABC917A
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 14:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 428551A60FD5
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 12:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1A42E2EFC;
	Thu,  9 Oct 2025 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="teLU8SNd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7E019E967;
	Thu,  9 Oct 2025 12:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760013773; cv=none; b=tV/UKTm/t+dDIqtc7lOJvtBsAtE9clwxwIj+ps2DRo+6/2hXBCW79yqfFIbpi6Tpl2FrtfZQapPL/t83m0ehnsLSzk3mrNI0YjE5MPISJG9eFmcD927wRbDNhwBrUVfoJbRQHwKd+IKvoFgTyh9xxIu1jIa4g80aXfOndY6ldj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760013773; c=relaxed/simple;
	bh=x7NTeLf98YsKIjLW5txYL5wOM6+bi+M1w4d21NY76zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fn7BWNPapYgMlzz8NOWaLpX6MBlq1RUMC6dqdpgESobDWocVUGV93KQqBSimRxfKz1jbKvVwfTsvvq4Q5kAqrLqjWdnA617pUy5/ZnJHX7NVH8GzWX9QF98An8Oe42/3Z7Pxeb1V9BQDs4cCeUJBMFtysy2VOpYDPK7R817Aky0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=teLU8SNd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0608BC4CEE7;
	Thu,  9 Oct 2025 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760013772;
	bh=x7NTeLf98YsKIjLW5txYL5wOM6+bi+M1w4d21NY76zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teLU8SNdu0sPz8WlsTxct4Ekg49SftyC6bjJKTyIgMjj1wdbMgzu45cicz8qWNo37
	 9rdHU8we029VbJnznae2+sa+t2VvTGOJZ+4BJNzhj0rCjKiZgqQV7jzSlkNKNGPRnl
	 vHGmDUR92YxbJMMXpXzECk7K2fB9WMRyx6wBFroJmYYtZ9JwldvAj7wEPuJ0YzzD5C
	 PsaJO1VXw7GlJKRWdHgko81Vexcr7AFSA7fYl+GEHchCWEp23fNqGAsJkL3EckxE3N
	 4xGcBLEcsozXuT4gza/6mdTQacngO6ef+jmNIr/Xoa2EPCSOwp9QsXJpAJ4sePn3MY
	 qhQ/mklUzopFQ==
Date: Thu, 9 Oct 2025 13:42:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH 1/3] arm64/sysreg: Support feature-specific fields with
 'Feat' descriptor
Message-ID: <5ac755f3-d7e4-421a-85bd-43d7aa7fbfde@sirena.org.uk>
References: <20251007153505.1606208-1-sascha.bischoff@arm.com>
 <20251007153505.1606208-2-sascha.bischoff@arm.com>
 <26d69b0d-3529-454f-9385-99a914bf1ebc@sirena.org.uk>
 <0a3a60082d13b27388a0893abce8be47b045c107.camel@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gG3MP3AzN4q55W5n"
Content-Disposition: inline
In-Reply-To: <0a3a60082d13b27388a0893abce8be47b045c107.camel@arm.com>
X-Cookie: Today is what happened to yesterday.


--gG3MP3AzN4q55W5n
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2025 at 09:48:36AM +0000, Sascha Bischoff wrote:
> On Tue, 2025-10-07 at 17:28 +0100, Mark Brown wrote:

> > logic for generating the conditionals in a manner that's not tied to
> > features with a layer on top that generates standard naming for
> > common
> > patterns like FEAT, but OTOH part of why that's not been done because
> > it's got a bunch of nasty issues so perhaps just doing the simpler
> > case
> > is fine.

> I agree that there are plenty of cases where sysreg fields change based
> on more than just architectural features. Whilst my intent for this
> change wasn't strictly to cover all of those cases, it could arguably
> be used for that. Effectively, all this change is doing is to add a
> prefix to the field definitions so it can be used however works best.

Yeah, I don't know that we need to cover all the cases in the user
visible syntax right now - my thought was more about the code.

> It does feel as if Feat was potentially the wrong name to choose.
> Something like Fieldset, Prefix, AltLayout, etc might be better. I'm
> rather open to suggestions here - naming is hard!

It is :)

> > > The Feat descriptor can be used in the following way (Feat acts as
> > > both an if and an else-if):

> > > =A0=A0=A0=A0=A0=A0=A0 Sysreg=A0 EXAMPLE 0=A0=A0=A0 1=A0=A0=A0 2=A0=A0=
=A0 3=A0=A0=A0 4
> > > =A0=A0=A0=A0=A0=A0=A0 Feat=A0=A0=A0 FEAT_A
> > > =A0=A0=A0=A0=A0=A0=A0 Field=A0=A0 63:0=A0=A0=A0 Foo
> > > =A0=A0=A0=A0=A0=A0=A0 Feat=A0=A0=A0 FEAT_B

> > This assumes that there will never be nesting of these conditions in
> > the architecture.

> My thinking was that for something like that one could do:

>         Feat    FEAT_A_B

> Or similar. Yes, it means that anything that is nested needs to be
> flattened, but it does allow one to describe that situation. In the
> end, all this effectively does is to add a prefix, and said prefix can
> be anything. Double so if we move away from calling it Feat, and use
> something more generic instead.

You could definitely do it that way, and for the limited implementation
you're proposing it probably works as well.  My thinking here is about
what happens with the syntax when someone comes along and implements
nesting of fatures - the existing syntax would be broken since you
couldn't distinguish between an implicit else and nested FEAT_.

> > Probably worth complaining if we end a sysreg with a feature/prefix
> > defined.

> This is already be caught as we hit the EndSysreg directive while still
> in the Feat block:

> Error at 4690: unhandled statement
> Error at 4690: Missing terminator for Feat block

> I can be more specific in catching that, if you like.

No, it's fine so long sa there's a warning.

> > This is only going to work if the whole register is in a FEAT_ block,
> > so
> > you coudn't have:

=2E..

> > but then supporting partial registers does have entertaining
> > consequences for handling Res0 and Res1.=A0 If we're OK with that
> > restriction then the program should complain if someone tries to=20
> > define a smaller FEAT block.

> It was my intent to only support whole registers here. Anything else
> gets insanely complex rather quickly, and much of the benefit gets lost
> IMO. By only operating on whole Sysregs (or SysregFields) we are able
> to re-use the existing logic to ensure that definitions are complete,
> and the generator's state tracking remains simple. And, as you say, it
> would break the ResX, Unkn side of things if we did anything else.

> When I add the missing check I mentioned above, then it will complain
> if fewer than 64 bits are in a defined block.

Yes, I think it's a reasonable simplification for the implementation and
so long as the syntax in the file can cope with someone doing the more
complicated cases it seems fine to leave them for later.  It's not like
it's a small bit of extra work it'd be easy to tack on, there's some
thorny issues there.

--gG3MP3AzN4q55W5n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjnrcYACgkQJNaLcl1U
h9ATfQf/casVQpgbpHM7Ag5qGzcf07FmU19LCgtzxPcUAuVl5aE9enSeRtWZbcF0
SBtbVWCd/N+OqWhF+DmQgxCjtQH4c6A9T4+N9zNh6BUf89ehECjit9XvvvRPzfcB
nP10Vd/qJ9wfnNYyyyYXvTncSi6YPRSRhpmcp0Gp79/XDjDEejsx0CvQUnQttJA9
iHiMCkxiuifOnHAlp+VuYhFaPlzfXM6hqZ+IdkGHKoAVmWlxJMzgBRZtRuJPfbq8
XLnB39TwPWVqoVRH+6D4r+EtAe8sM91nkOxGV0/nDDlKDTwqQlLm0/k7bl9LMoj9
I3DeIxVGcseaS2PyaUTvzswN+yYLmQ==
=ljFO
-----END PGP SIGNATURE-----

--gG3MP3AzN4q55W5n--

