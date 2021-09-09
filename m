Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53169405BDD
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbhIIRTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237137AbhIIRTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31294610CE;
        Thu,  9 Sep 2021 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631207912;
        bh=Vzgjd07EtEWqLqFdwBwVXT6tQoiq5L9fl/NNb92VUM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nKvpjWDLmIbAiqGD25fjLhXyoOHGOY/R1rU7sbr7K5iSlc0NvQko/e83vdDFjGY3z
         QQ92yGJODGkgiQ9O0jQCl6i3wM774ALW3WLH7Z3ANlpWUA3pyDBzqScfnmsj1ZcSs0
         YPj5B3tTj7hvaICEUW+9tZsxestBaWh5yjts6EPsopIOe7yjxYbGCU2ZR8LMaWlaQM
         5SdhaWr6qX31BN3PPVJQHBV+JvH3bm0z5+oX8HUtJp8IZvMeak66N9FzwRHOd2gZ0N
         MRpQQEzCf8LYoSV5vKZgtnlfZB6ZazozaGmx8OhCoR/2S6hH8lrHPrE8sUOFZdvKeT
         bxxhE0qzdFjOg==
Date:   Thu, 9 Sep 2021 18:17:55 +0100
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
Message-ID: <20210909171755.GF5176@sirena.org.uk>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-3-rananta@google.com>
X-Cookie: I have become me without my consent.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 09, 2021 at 01:38:02AM +0000, Raghavendra Rao Ananta wrote:
> Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> into selftests to make use of all the standard
> register definitions in consistence with the kernel.

> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
>  1 file changed, 1278 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h

Can we arrange to copy this at build time rather than having a duplicate
copy we need to keep in sync?  We have some stuff to do this for uapi
headers already.

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmE6QcIACgkQJNaLcl1U
h9CAPAf+MQBjgDWR7i61DAYpl8mThqlPrRcYiztJRwtYDtMw4tnFmF/r7HCTXxTD
hznDPxnOmwaOTRqfL/fx7iIeBQGrVFlGdS+RPZcs2MGi9kasXOy0osmAAVC8xYi9
jawBd/Rb6MMxWin+UYNbKmqfUmXwWuOB8Jgo7Q03+Ef02u5H2YX4uhc2G7zpjzLS
TgXJBJVGsAzktFvAux/uM6ohHahk/pvvVKV9WmTmQS0Q/irfGevkwOCSExfKHVCS
LJN2eeZxmILmdc6FMEHqvi+p5YHyilJJdMFStqXBKSRSjMkx2S0AY46vHD6JNMaX
eqb+UAF2bjsjsvUxjZ2m7wHOdCTYUg==
=sR7c
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
