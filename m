Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F26C750F1E
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjGLQ7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGLQ7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:59:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7FDCA
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DE386187A
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCABC433C7;
        Wed, 12 Jul 2023 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689181170;
        bh=6huaolnr1dQ7EB4VrqwL2Sztgp1Fwodb0xL9I6Z7DS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BBftf5yHc1t5UMqQCLO85WjAJ5g3XgNIncGX4HjRpPzr9+udtBt0BJUEfI06ulVaH
         YVlVB2/9/5xKQ2hGe32yihc5WJLSKd+MF74dpVAF+bmKjp9dNEsGg50J/ev6ddAgmg
         2ICTNB0Cr2ZQYLZFPsUeLF1GkIYIs/1/+To3gGY342LYKkWsF0tWUZbAbNJg7CrDpa
         ikcjUNuLnZZt2/Kph5r7NB2oYCHte7QTtd3HxJoVOSowA4WKrgN83mrxqNr/HQFky8
         8XUdSX5b2c4yhBYrIOm+4veGZ1q44kAQIXhPHFxz6HEQPMri4InuPJ78BcCGCAzBnL
         XMbf5l+h7lYkg==
Date:   Wed, 12 Jul 2023 17:59:23 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 09/27] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Message-ID: <d946feb3-b62b-4411-bee7-d84ef1ea0d4b@sirena.org.uk>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IxLDJnSmhBK9HsIm"
Content-Disposition: inline
In-Reply-To: <20230712145810.3864793-10-maz@kernel.org>
X-Cookie: Dammit Jim, I'm an actor, not a doctor.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--IxLDJnSmhBK9HsIm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 12, 2023 at 03:57:52PM +0100, Marc Zyngier wrote:

> As we're about to implement full support for FEAT_FGT, add the
> full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.

Checked against DDI0601 2023-06:

Reviewed-by: Mark Brown <broonie@kernel.org>

FWIW we now also have HDFGTxTR2_EL2, those can be added incrementally
of course (and generally the fewer registers in an individual patch the
better).

--IxLDJnSmhBK9HsIm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSu2+oACgkQJNaLcl1U
h9Dqzwf/ezv9DquO+Uil0dEhCrFV/8q5mctFhuaVvHOyXguxwI6///nJHDklteFL
GtJaMkQ1XPX+XRy1zwRl3KA/j+DWhF7+YlGTjFc1ZmKpu+0ENgFV1XLH0haUu/RY
bKc2TS0YbO7OhOJOFm9oPgbjNBVrM6FMaSv17gwzRGcVqyRWUJPj7IUkrtwphYWo
6DpKrkFm2EQgejJhC7tEuYvnMM8wSrilY8+dfEtEXOasZJF+0S1bVzdFaa4g1wQ9
QhvEW0M0Y6op3V5nKu1Aot9MYrGASK3ye0hFyNEPKh5go6milWIhi/8eQunQlLcT
l1qJf7MIvMBrHQL6kchTL2G0pdUu7g==
=Wih0
-----END PGP SIGNATURE-----

--IxLDJnSmhBK9HsIm--
