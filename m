Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFCF3422A9
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCSQ6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230235AbhCSQ61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7927261953;
        Fri, 19 Mar 2021 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616173107;
        bh=oWRlc58V9GPpmhVKr28TgLiGNUEVGrMp7yMwubglgCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oP3rci4WbJRzdmIiKwS/z2XA5+6ILC5H/WgwOYc3fDAojChlIHPmnnhBzFyt1di/+
         1VrXpQImknmbD+9jP8HIUldavxYWsTFQTGKFZLNvl4xw0NlT4dWsUKfu0MvQjAw59u
         z+DzsNMqay0XAhB568J9x/MsmLEtfQCxkngjxxcq0ldf/OGCQCCJV9K/ZtRnNXKpxh
         y8ljQVbhpd8ih378xH/9A/NpRr6L0hamGq+fO9h3QBgyX+gRxwE7Kk1CEufthB4Lnf
         4iiVo+iesTvnonBZBL4zsqUTLIQAq71owzvEim+UBdJgrP0F/ZVbEG6AaMMZ2yaPzh
         y18u+bItojd5A==
Date:   Fri, 19 Mar 2021 16:58:22 +0000
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
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
Message-ID: <20210319165822.GI5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
 <20210319164236.GH5619@sirena.org.uk>
 <45a7868d83eaaef2e5d0f6e730c9c8f2@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Q59ABw34pTSIagmi"
Content-Disposition: inline
In-Reply-To: <45a7868d83eaaef2e5d0f6e730c9c8f2@kernel.org>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Q59ABw34pTSIagmi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 19, 2021 at 04:51:46PM +0000, Marc Zyngier wrote:
> On 2021-03-19 16:42, Mark Brown wrote:

> > Do compilers actually do much better with this than with a static
> > inline like the other functions in this header?  Seems like something
> > they should be figuring out.

> It's not about performance or anything of the sort: in most cases
> where we end-up using this, it is on the back of an exception.
> So performance is the least of our worries.

> However, the "reg" parameter to read/write_sysreg_s() cannot
> be a variable, because it is directly fed to the assembler.
> If you want to use functions, you need to specialise them per
> register. At this point, I'm pretty happy with a #define.

Ah, that makes sense - it was more of a "that's weird" than "that's
actually a problem", hence the Reviwed-by.

--Q59ABw34pTSIagmi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBU2C0ACgkQJNaLcl1U
h9Ajqwf9EMDQaypMDIWe3hvFmJpocQXYj8Z8pZV17DmNX8BsxorubMG4MZYXbAy3
Y6KQsdym6h98d123L43yudMJDZh1lUz5sxWtvbpTMkWShEaYWskz+Jt9u5FmVmRt
SKwrNpvVWtBUCKlmY2StbkfvvjAvHFrdP6dkSFUpNjXOORWvWFxEy3ON4Wh4/anX
1U+GXJN/udEiv1Gs2h1b+UWW7z2eDpfNImt1A/KekSoXH+6CiAc/DzV0PA3xelo/
YC4JLIPlLsdBT0wXPmY3pgAATgWM2j0cg/XLPZfylA88kgurHWHaZmq7H+rYO9xI
Jrx+XlOA0rjFsAI+OlH5tBWUdb72IQ==
=agRA
-----END PGP SIGNATURE-----

--Q59ABw34pTSIagmi--
