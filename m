Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC5459464
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbhKVSBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:01:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233367AbhKVSBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97BC60C4A;
        Mon, 22 Nov 2021 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637603885;
        bh=xaPvWRRZLplWuTj6zfL8WONxOMLolZjyxQW/VUcabzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TaGnGGcyBXQBLJ9W61wVeyz/MNc33lttcCzOEXoIzohiqYDXGAVQhE/bdAdCQXoBo
         Ji9T5Zp7wrEbdDIlf9DGI/ID7+/9eAuP+S/XvPWVFA06C0C1GR8bWQErfGKxKAKPs7
         BaIHVWzvDJo+7Lr4fSQAcdza1HzrY7X46t4hqxjL0W2a0jSq8m/ROoxl6lW7P2Y1To
         O8bUzzD65jVr0byC6hNreFKUVASfB3oUMhvcfA0i6vnpZECT08FV5sKjJBK0n+axbr
         lCSWQlBgmjz62gQHH5T6bmkD11Y4a0ZKB0GMMhq9rJs63xQaDPaOz4QvipZTMPSCIQ
         wHO6s9Sz4CcBg==
Date:   Mon, 22 Nov 2021 17:58:00 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Message-ID: <YZvaKOLPxwFE9vQz@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
 <5ab3836f-2b39-2ff5-3286-8258addd01e4@huawei.com>
 <871r38dvyr.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4ejJzEuy+GX8OnS7"
Content-Disposition: inline
In-Reply-To: <871r38dvyr.wl-maz@kernel.org>
X-Cookie: Lake Erie died for your sins.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4ejJzEuy+GX8OnS7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 22, 2021 at 03:57:32PM +0000, Marc Zyngier wrote:
> Zenghui Yu <yuzenghui@huawei.com> wrote:

> > Nit: This removes the only user of __sve_save_state() helper. Should we
> > still keep it in fpsimd.S?

> I was in two minds about that, as I'd like to eventually be able to
> use SVE for protected guests, where the hypervisor itself has to be in
> charge of the FP/SVE save-restore.

> But that's probably several months away, and I can always revert a
> deletion patch if I need to, so let's get rid of it now.

While we're on the subject of potential future work we might in future
want to not disable SVE on every syscall if (as seems likely) it turns
out that that's more performant for small vector lengths which would
mean some minor reshuffling here to do something like convert the saved
state to FPSIMD and drop TIF_SVE in _vcpu_load_fp().  As with using SVE
in protected guests that can just be done when needed though.

--4ejJzEuy+GX8OnS7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGb2icACgkQJNaLcl1U
h9BczQf+IBminM9LlYcrYBFvkLv1xG/VjhSrXo0RiCzpz5QehpsZDC2Xycu4+seo
7y5r3IXniQ0R4FAA68e9D2FT/ubuwBJ72cZ/eBdW5QWMFoX0dZMk3v+/YiDVxch0
hr/ZUAVDB6qsgjVXoUeuYJxfBuxlDnDUbB4zMw+PjP9mMcgg9aTzO4kgQ8VHd9q0
OkCT/fyP1zl0yaKtcFXeg2fsJWvJgOp+SnwQ+z5ht1jnCkb2t+iXO48wpg0YETtd
Uw5m/QMMsg/7Sy2WBjCB/gY2ThljfBpLY9CgbESPFNbyamfxDF/NWJZs6Bs/qHOB
y0I6Gy6DMi9nbVMYHcuZgcq+XzWlOg==
=9M+3
-----END PGP SIGNATURE-----

--4ejJzEuy+GX8OnS7--
