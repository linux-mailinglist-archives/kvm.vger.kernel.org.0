Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C19464E46
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 13:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244740AbhLANAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349444AbhLANAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 08:00:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB99C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 04:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB312CE1DB3
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC8AC53FCC;
        Wed,  1 Dec 2021 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638363402;
        bh=cnf6mfxlAvT1EOVOQLzydeQXHEFrZLvejOYfDA/BBzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SimVJWW+qLh2pH2sPCh8qp7C4Lli3mx0D3w0p0GxOWg1GIAmJeGsCk/iF7IHk+0mq
         aqb+L0EpbrdzsL9y9BnjWt7rPEkaxIiaFKMLVfTWuge4JfxPJAZhwppYtddXYqlItd
         hcVRET9aiMMfOO3Y+DbpOHdjtXSTBSlKtXJkxtW7Z1yO2VKaRCfTTxfOdt80KepEtZ
         o6tFVxquQg3hUs6eQC7M2VU7x+SI7Ep08kGerYaOsDXvX0/GsCf1hwCZi63kmTzENM
         YSH8l0NN5vmOxQF/u5ypaiAw8K3CVn96fhRKR8DIgxQT6WExXyp+E60Rl102SPev/K
         rVbFWP8HfXXpg==
Date:   Wed, 1 Dec 2021 12:56:36 +0000
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
Subject: Re: [PATCH v3 3/6] KVM: arm64: Remove unused __sve_save_state
Message-ID: <YadxBLbaSxkBuqaF@sirena.org.uk>
References: <20211201120436.389756-1-maz@kernel.org>
 <20211201120436.389756-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SujizcpWR574KISM"
Content-Disposition: inline
In-Reply-To: <20211201120436.389756-4-maz@kernel.org>
X-Cookie: All true wisdom is found on T-shirts.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--SujizcpWR574KISM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 01, 2021 at 12:04:33PM +0000, Marc Zyngier wrote:
> Now that we don't have any users left for __sve_save_state, remove
> it altogether. Should we ever need to save the SVE state from the
> hypervisor again, we can always re-introduce it.

Reviwed-by: Mark Brown <broonie@kernel.org>

--SujizcpWR574KISM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGncQMACgkQJNaLcl1U
h9CaowgAgKZUZSBDBwrJAF4oArHVKzIxedIFVD0xv22xdR4NfTcy2Dmv3sbM08Va
41yJc4LOvrd51ybnaFI6zrhSBk/TKUR+/ayCmKnR/lgchfIdipAyDTYWsR+KXuF3
TUpo6HlxvvDkYf5VkoM1cBz1l8AX6ooLrT9e0Ndc2FUmBKkpVZS69FasbEw8Odzj
vzkjUe+ThdgHV1K4lwHZX1vzf78A6XTAE8eqTjM2oF+6XIBGBR0ZKvPGQ6SHij47
29oGnpXpg9M2v+1hHlffr3oT0XWdelA58Bh1TJifF3fdIOMX1Ys3IkhAVtIJcezT
HD7ctSuEw7HGwOKl/OYsku062y9QRA==
=0x81
-----END PGP SIGNATURE-----

--SujizcpWR574KISM--
