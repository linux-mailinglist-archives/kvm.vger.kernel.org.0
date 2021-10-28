Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4107543E1D0
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhJ1NRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhJ1NQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 09:16:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED12661130;
        Thu, 28 Oct 2021 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635426872;
        bh=C1zcco3bTHMOEHdKG2K0ubtIXS9WB8cgc60pAqatfuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0wjY9u/vzPiiOcYBGLPCdlL8W/wye2808zGSSQAVBVvHo/k6qFihwjODj6AWxUpD
         4TnjpzUad9tFa0QeVAscGyxf79lr7ZUDOhs8nhxG/Wq0OjKAnOBuSUuH+wFnP2HJGz
         lXCelmjWvayCluyGPRNQO5W4RR5klCwzcqgUXrm6/Z6JqwyrJHa4kORFN/B7iKiOIH
         aZAfoTQLXefS5RE/GyokVWq4IJNcXln+AsQ9c1U936K4kHiTiCMUexLy/qF5oFxNt1
         rjbthJ4kZ+lyzX2khiduaBRJLZz1TBUgRtkthU2PGlO2zKrHyz+tE56i/WjAwPFWg8
         ye00MdxCfpgig==
Date:   Thu, 28 Oct 2021 14:14:27 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH v2 5/5] arm64/fpsimd: Document the use of
 TIF_FOREIGN_FPSTATE by KVM
Message-ID: <YXqiM08YPeyYley5@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="58r1ffgyFCvuxbm+"
Content-Disposition: inline
In-Reply-To: <20211028111640.3663631-6-maz@kernel.org>
X-Cookie: try again
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--58r1ffgyFCvuxbm+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 28, 2021 at 12:16:40PM +0100, Marc Zyngier wrote:
> The bit of documentation that talks about TIF_FOREIGN_FPSTATE
> does not mention the ungodly tricks that KVM plays with this flag.
>=20
> Try and document this for the posterity.

Reviwed-by: Mark Brown <broonie@kernel.org>

--58r1ffgyFCvuxbm+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmF6ojMACgkQJNaLcl1U
h9ADwwf+LD87gkZpKtme+gaULezsWo6+93ZLEdBBNTy13T2KQTAbi5wtv2tjrTh0
eCnrIjgyz35mSb3pF+vNn8+iyUBuELXFfK5+ZapkpduIBwY2tNLKCXQrpg28gVWV
AuZR6K7b3fktMxMM+vU2zMIacVr50uDT0Ba5BCUpcg0YwvRKORG4W+0UqetRjizz
ZfceGiGUd46iepoa5clJXJhZ1eJrUb9FLnekPOEcEUqs7Q1G5bF3Zoifc1JeDtdv
e38oMmLfKtwi8DSLfto5jPgb2/xYGBT1FATkdmDtGJaLhIggmkiNyzaugvwbY/BZ
MUYuoAUf80pcTiFpov2Kn7FWnw2R4g==
=+aPl
-----END PGP SIGNATURE-----

--58r1ffgyFCvuxbm+--
