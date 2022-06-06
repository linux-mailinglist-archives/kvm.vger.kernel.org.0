Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3353EBF8
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiFFKbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 06:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiFFKbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 06:31:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F315E980A8
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 03:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E8D160E88
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 10:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FABFC385A9;
        Mon,  6 Jun 2022 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654511471;
        bh=RzOj554rH8+MebtKLp8kUafMWsaG9Hef1Y0se144nuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M2jerxXte/nWPfN9/KLPlfIsFVhxt5fA7IR9FDTE2ociPH8vepgnv3VAfdROdbYj7
         QTxN2T3uUXtilsAJg3CscfyiCPQZ5OWbHuX28b5u0nlRFtcHAe01YbErEk/v01jNSf
         sdkO7ca5lxhgBI648V0bNh/s+ikQn0fgraephBuSfkVGgFI7d3qocR7o8HhhwSczOI
         sWKDCsO+9TUmVDDuVeajhUgQZt4XRgs7RkoDg1zusidQKjlNINIfU1H4nUlRZmB7hk
         0D+/rMolPsbj/o3wRUnSBlaZBbUnlUB3RPoJmOtEf1HhIeBqRxaQhhAES+SKdNkMmq
         SwMf1zd+AgAmw==
Date:   Mon, 6 Jun 2022 11:31:05 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: Re: [PATCH 04/18] KVM: arm64: Move FP state ownership from flag to a
 tristate
Message-ID: <Yp3XaeZFnlNOIE7t@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-5-maz@kernel.org>
 <YpnQ43WaGH96MxyY@sirena.org.uk>
 <874k0y5gkv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rQudSunjvuay9MSf"
Content-Disposition: inline
In-Reply-To: <874k0y5gkv.wl-maz@kernel.org>
X-Cookie: Bedfellows make strange politicians.
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--rQudSunjvuay9MSf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 06, 2022 at 09:41:52AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Sat, May 28, 2022 at 12:38:14PM +0100, Marc Zyngier wrote:

> > > - FP_STATE_CLEAN
> > > - FP_STATE_HOST_DIRTY
> > > - FP_STATE_GUEST_DIRTY

> > I had to think a bit more than I liked about the _DIRTY in the
> > names of the host and guest flags, but that's really just
> > bikeshedding and not a meaningful issue.

> Another option was:

> - FP_STATE_FREE
> - FP_STATE_HOST_OWNED
> - FP_STATE_GUEST_OWNED

> I don't mind wither way.

I think I do prefer that option, but like I say it's bikeshedding.

--rQudSunjvuay9MSf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKd12kACgkQJNaLcl1U
h9AVGgf/dlk9EDtEzQer5KaGtvG5vJiwknDihIt6gs7N2qOR6G8a4oZMsGZRbjke
2fRtcpAeFmhvRB70c7YTQ5YWy7tQLlCDvuC2wKYren2Z3bj3tnX6SQXiwPD37yAI
fS9sZrICl7Cy4H65S2fX/Lc0g1aec5uIMmFLhtTXoswUeMpNUqHBPp162VS10bGT
dhBD7IuuZqnYHzxLaMX87xG1NRR8IMmaDO+3Lgy2cHUoZ+z/2S+1lKLFA9BolVEA
cWzvrkbLq4kwH4/FRnc6sR/67DAD3yrrjELW5OL7vokRgdlYQ5XZ5gK92R15KTPD
Tx84jFJFDqsZYgJWsiDRldwbWFGwOQ==
=yN1j
-----END PGP SIGNATURE-----

--rQudSunjvuay9MSf--
