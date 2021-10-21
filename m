Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93517436629
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhJUP1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232233AbhJUP0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C4161183;
        Thu, 21 Oct 2021 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634829869;
        bh=tUrSTzrgcnXRxuolPC5YiqjKQYQV19z+OKGtoBE//Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pEad02ay6+Bct21u4Vr3aCBZdjlooRsUJnBfQvsnjOD7ouqCLu2106vDuZdol0SI9
         CXD6az+sk29AOvUuVipq6vF9bGcBcU6mEv43pCJwPUx1uRGndrx14G7P7sKLiuczJV
         xFjHPuLwzKyr0YYKOvKy7lLEPLxjrPRnnbyA1p9z6wv6nUagqIzBaxw0n+8uY7aLyG
         5rgzto4O73JpcwCWJjRrecfjMxUR7idrJ2lPtI1OfeisTMkjmxi5fduCdKwFTbhFfw
         QLNo56f+Nakx3mmfJuDqZgudQ9cidMlkk9aD4+/opn2bt73Mk09p/91U9Y+bd8JJ++
         y3fs+t0nYtnYQ==
Date:   Thu, 21 Oct 2021 16:24:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 2/4] KVM: arm64: Introduce flag shadowing
 TIF_FOREIGN_FPSTATE
Message-ID: <YXGGKkQw27YiMBeP@sirena.org.uk>
References: <20211021151124.3098113-1-maz@kernel.org>
 <20211021151124.3098113-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L8Wd2CqiPfVWhZp9"
Content-Disposition: inline
In-Reply-To: <20211021151124.3098113-3-maz@kernel.org>
X-Cookie: I program, therefore I am.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--L8Wd2CqiPfVWhZp9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2021 at 04:11:22PM +0100, Marc Zyngier wrote:
> We currently have to maintain a mapping the thread_info structure
> at EL2 in order to be able to check the TIF_FOREIGN_FPSTATE flag.
>=20
> In order to eventually get rid of this, start with a vcpu flag that
> shadows the thread flag on each entry into the hypervisor.

Reviewed-by: Mark Brown <broonie@kernel.org>

--L8Wd2CqiPfVWhZp9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFxhikACgkQJNaLcl1U
h9BEwQf/esARvjGvexFVvEy7ZJkEtcEGWDwcI7fFBSYm35mVfsJxUU/14LDIPmci
EOzcELKvXBXccR+fJ+DdxtOkJJV/rB6vl1Iyg4ikNaNYbFENyYkkz0gyOtlXSkoH
nc9fUiPu4/i1+re6CB+n1Fam4qzuavZ71WK7fXwo5hNwB+vc0GAKRKwD8fCyMlcQ
7f/0JC25VkFkxpdY82tSo2RRRC/m5E6CXJtj0WnSM/q1yfKI/w75j4lDiO78w8+x
S3IRKg0aZSyiW/Kv05IfRFcO/xNXiOuLwRQ/+7+VuL34njdcA+UmASrJWmTBwV+T
wPCL4eMWVSK3O8SD6oohjJ/I3LOrRA==
=z7rI
-----END PGP SIGNATURE-----

--L8Wd2CqiPfVWhZp9--
