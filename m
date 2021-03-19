Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74C73423C2
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 18:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCSRyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 13:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229926AbhCSRxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 13:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D6BF61941;
        Fri, 19 Mar 2021 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616176433;
        bh=zrcL9MRIFXU8BSdXA3iKVsYRz6r0TE1XU84YXfluHhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JleX4Ku9BTUuHpkzuztNMHZyK1I2gm5G53d+jG4H7cBYdMIjEiP67A5Tsti0YJwcE
         +2vFKmppEYuF8Ys8Iedf6E1rDo2tJfOjSGi5f7ZCrbfOLiFmXyU6Rv8lfh100O9cGj
         Y2SU9l+MGa64aSPP03m7Izg/2nj+qrNf9WxtqVA8Rio8bVfL0x2K12RTlSqXFZWYRF
         HgA0Rn+IkXa8HCboaJP1wDgpSdjXAyhh98yyGNOkC7s49JGayvEwdXuUruBs2xxTIi
         w+5zqc9aAFJFDVkhek2UGBZuw7yRknjLO1W7bnmzHcy9ZmjKfeHhBa6mdedqVpSNjw
         mXPZikZXDBn+Q==
Date:   Fri, 19 Mar 2021 17:53:49 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>, ascull@google.com,
        qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH v2 00/11] KVM: arm64: Enable SVE support on nVHE systems
Message-ID: <20210319175349.GK5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aqWxf8ydqYKP8htK"
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-1-maz@kernel.org>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--aqWxf8ydqYKP8htK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 18, 2021 at 12:25:21PM +0000, Marc Zyngier wrote:

> Most of this series only repaints things so that VHE and nVHE look as
> similar as possible, the ZCR_EL2 management being the most visible
> exception. This results in a bunch of preparatory patches that aim at
> making the code slightly more readable.

That readability stuff is definitely helping from my PoV.

Reviewed-by: Mark Brown <broonie@kernel.org>

(FWIW, from the SVE side)

> This has been tested on a FVP model with both VHE/nVHE configurations
> using the string tests included with the "optimized-routines"
> library[2].

There's also some tests Dave wrote which got upstreamed in kselftest
now, some normal kselftests and also a stress test that sits and
writes/reads bit patterns into the registers and is pretty good at
picking up any context switch issues.

--aqWxf8ydqYKP8htK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBU5SwACgkQJNaLcl1U
h9AN5wf+P7ae7UEos5cVKTOeBLoAWzSixqcgUVEwBW/KICbwvz0XROUxMt7whp9r
3Tw/PL3WZ4lUkWYFvvB3tVnjQk1JvolP4ZD07/28uKOuokUk1lCitqDpEwpi3y58
TTfo6q89G0Z8n6bMMeRPe1WrajTzkfkGHsScPrOaH2OWWjPwv4YfgtfsLCtXTiWH
XI+Jd6NOtPjSMMSYTnje4qFyPmn9Y7OzkbEXj/3wKP4qBYw4lhQ4pZ4jF38ngSve
SvXbki6zREpP5U4BpqQcMzu1D1/DN/Xz0YeBi2MKNQrIrEVY+z8kQZ1BMSXZ5xi/
sQ3P3aJ6VfsbW0AQmgZoAknknjcdaw==
=Q9m5
-----END PGP SIGNATURE-----

--aqWxf8ydqYKP8htK--
