Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0578406880
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 10:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhIJIcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 04:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhIJIcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 04:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 804DE610C7;
        Fri, 10 Sep 2021 08:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631262650;
        bh=SPE/jxAWcGR+hp29mSZ8jiX1DlvUPpFpsR5GhteB0/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdJTsYlW1nmMWC/XtoK6daUP0VO8FY3FIh1eEbhc0bA4TLMp4fdNC/Ao4iwuJXK3D
         dGt5CnHrKC4JPe2ecUBMN+m+xd4jNM3dutWCGFPHphKFjhrflJ3sRsyv+Q2vGOIPKA
         noZtdu76LaegO4L2ET5NFaMoRI+VHTXjCGe431PTdzXiVqjs7ShWcIQT0bD82ZvPbP
         4TrEeSGJuduSBz7QKG0Qll8pN6a6vBsuxLt/lbdkJ8UpNRuAlAS9pGiPia/tDUjrxH
         Q/mQsefp9NxaMmU2pdVLcUXvGXw1DnI+jYAwaggg+KqSvXHe4M49w74RAo/4cxc5sW
         iW6ChlD5IMz3g==
Date:   Fri, 10 Sep 2021 09:30:11 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
Message-ID: <20210910083011.GA4474@sirena.org.uk>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <20210909171755.GF5176@sirena.org.uk>
 <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 09, 2021 at 01:06:31PM -0700, Raghavendra Rao Ananta wrote:
> On Thu, Sep 9, 2021 at 10:18 AM Mark Brown <broonie@kernel.org> wrote:

> > >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h

> > Can we arrange to copy this at build time rather than having a duplicate
> > copy we need to keep in sync?  We have some stuff to do this for uapi
> > headers already.

> That's a great idea actually (I wasn't aware of it). But, probably
> should've mentioned it earlier, I had a hard time compiling the header
> as is so I modified it a little bit and made the definitions of
> [write|read]_sysreg_s() similar to the ones in kvm-unit-tests.
> I'll try my best to get the original format working and try to
> implement your idea if it works.

One option would be to do something like split out the bits that can be
shared into a separate header which can be included from both places and
then have the header with the unsharable bits include that.  Something
like sysreg.h and sysreg_defs.h for example.

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmE7F5IACgkQJNaLcl1U
h9DaOwf+IKLvC2prK1SBAm+BeUSM4HW6iFJLUaEoQBFNBFbKI1JLEvcDGWwF4PQ/
zF8K1mWNAZNuqG3g3sx1pZ++IXy2reWVG6Dchp8SOs20ahX654NRhdALQ8xHmgtH
CHUDOB0Yh4TnmPiaKSbPvAGb0k3qgc+Et/45zJVhfejUqH7o6HYNMzzT296sGKak
0tST6itO7q+JqfrNOxp6FXJNB+ikd59ByaA06Xbv7jvP3xp8cYVRuOy42QhWi3Wo
XAIw3BInkhRgwi+/CdRtKhwq1sm1+beeBZ90DgsLCgb1Z1phbVRMiUcbFhzEQ9Tn
o4+sFQj+1FxkCY0Os7WkC2bBY/o1uQ==
=XPRc
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
