Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D190464ECD
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349461AbhLANd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 08:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbhLANd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 08:33:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400FFC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 05:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9689B81EE2
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55571C53FAD;
        Wed,  1 Dec 2021 13:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638365403;
        bh=03NvP3rtGXIB44jdTVoaqF1hAROkeujLt9oWcwTYciQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aqq8mbqJV9iJlkVO3sm+k+UuMWYsI4cOGf3gf8KnZkpo6n57F3tLHLS5v7+cWwnzZ
         FqTeHFD+vCzhmouOWJiQPeofYPRfvDpflQi1GavRjUbOHbl/k2O2rxL+VojQxs4may
         ZMr46q7oxa9s9ziuxEfJqtRP82txYHYGd7Ky+9AR5yb6fGfHW9sRgKzkBsk3zmmU4q
         +sCqU8n/hDiG+iYb6pMC2FdGdRslLLx0u7iAQ72c2d6Wx3l2sE1+RdERDvAtm8Utay
         tFftn2szDNcJHat9JLSdc3C/as5K+Xao6AuqqU1wrUes8FumBB9xE7CpCClKSkfjVo
         mqffFD16OXxeg==
Date:   Wed, 1 Dec 2021 13:29:58 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: Re: [PATCH v3 5/6] KVM: arm64: Stop mapping current thread_info at
 EL2
Message-ID: <Yad41lTBoUkt8lZi@sirena.org.uk>
References: <20211201120436.389756-1-maz@kernel.org>
 <20211201120436.389756-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cZE6w7K3Kpb3PE91"
Content-Disposition: inline
In-Reply-To: <20211201120436.389756-6-maz@kernel.org>
X-Cookie: All true wisdom is found on T-shirts.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--cZE6w7K3Kpb3PE91
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 01, 2021 at 12:04:35PM +0000, Marc Zyngier wrote:
> Now that we can track an equivalent of TIF_FOREIGN_FPSTATE, drop
> the mapping of current's thread_info at EL2.

Reviwed-by: Mark Brown <broonie@kernel.org>

--cZE6w7K3Kpb3PE91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGneNUACgkQJNaLcl1U
h9AhZwf/S6EbpxJbOPrC+y6KTi4WpcMaVfokcHdVC+OM2NfsJ4E/RNW21N+UrB6k
GOpmtrFQcy5+ww6odUoCv001V+ctHtEv40MOZB3W7t+EccEhKW5LgrD5xsDQ8jbB
RfInaPSvytz4Zu9JXiovO4doD59+RuK9+kwwP2odeUZ9/g7v6alsKqKFEQwpcOM9
Y0RjZ0Lf7fgmihm9goswCmfzSliaug0pK0KF7wizybjRkpuSRXEinkla2AT5gJQy
4+w9/eZrdwVCx3IS9iNqVSqA0esNVZCG3fbIxM3yv30voK34oDdhHhOWZoJKlq40
zNlJhIuqxJpUQaU7JZosijOMOnrC6Q==
=nlYP
-----END PGP SIGNATURE-----

--cZE6w7K3Kpb3PE91--
