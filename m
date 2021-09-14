Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2940ABD7
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 12:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhINKk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 06:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhINKk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 06:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A826112D;
        Tue, 14 Sep 2021 10:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631615980;
        bh=X/xWVryAoLR7F4gV0F2zY4/xYU1ChD2peTUfv0rUZc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VMQ3Uy3nchC/bZwF0x8e+1q47nyPm+/I0t6LMEt3rojKp8ZMlO6cDZd58Ez/nsLGy
         2W283wCjSURRX5KHRrB57FdM1zweXDeu2ZpTXBKn2mjfUoeRqILe2drBy9HfF473Qu
         p4EGedimD4SrGl9ve13ObSIQD3uuVNldUU7VOcoLrwsvpgjNlDIM3YmTjvTSz35lII
         XondBEOe0/Vkvj6I3xQ/jcc+zdMCOQUAW2s1lj/KfASpqZ6j0mRspEuwkV8lkBzgOn
         VaF9l7MHrDaCGQK0NL3HK8j54cKDwork356wqYoMsfjNSh8QDQTmMITvMfQH30C9kB
         wbSqDa5qRu2kA==
Date:   Tue, 14 Sep 2021 11:39:00 +0100
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
Message-ID: <20210914103900.GC4434@sirena.org.uk>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <20210909171755.GF5176@sirena.org.uk>
 <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
 <20210910083011.GA4474@sirena.org.uk>
 <CAJHc60z0kLzrA3FfQeD0RFZE-PscnDsxxqkVwzcNFcCkf_FRPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline
In-Reply-To: <CAJHc60z0kLzrA3FfQeD0RFZE-PscnDsxxqkVwzcNFcCkf_FRPw@mail.gmail.com>
X-Cookie: This space intentionally left blank.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 13, 2021 at 04:38:29PM -0700, Raghavendra Rao Ananta wrote:

> I was looking into this though and could only find some utilities such
> as tools/iio/, tools/spi/, and so on, which seem to create a symbolic
> link to the header present in the kernel (rather than copying). Is
> this what you were referring to?

TBH I'm not exactly aware of how it works, just that it does work - the
main case I was thinking of was the uapi headers, mainly when used in
kselftest.  Those look like they're actual copies rather than symlinks
so I guess it's a different mechanism to what's used by the other tools
you found.

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFAe8MACgkQJNaLcl1U
h9B44Af/SfJ+AN5Ix/ZXr/siuBNgcCpe3/mrChxg41mKS/t+k7AWSAqfnOD/iUcf
oZC0i22AAWeRNATEsToyHoax/Bqdr/HWpOSzajwbgP9Dn9rhvpJscPAxy4kq1Y78
hwa+3eHPhRfPx98ZiT5HFFVPtx2eg1wDiO4YkHGyDfEO8ChLMpylYJPI4IwIzU36
ZpT0Ked+cJvArWiX5JslxeGzHn+jJazjkO//PdltUMw6JnhNfHV3uXYfvMsmBOsd
yRAtlgPEah/p33l4ZmkTH7y0quM4XaWFmNOOH4yuMDn2dAr2+9cg2TRbL0jQzAVL
pqf78AH3B6XfTRQDQRSvHCkerk8o8w==
=R/0t
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
