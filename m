Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC8553C742
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbiFCJJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 05:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242953AbiFCJJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 05:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6BBE082
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 02:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D76618A6
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 09:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D524C34114;
        Fri,  3 Jun 2022 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654247394;
        bh=ThbjYz1VPOOCZfSoMHKCJNv4joGtIlV2WQb/q8/byg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wap4azFylQ7sCs9bHodMhU5wB5uu7VhLym04W5LB2XPgE73S4hLf0udyQbXdbqlEF
         FilarPxtS83HopuDpZjr+LRLtPdFsx3Czz+heE8chmikDy0xsoqVR9DsmvljYAgCBs
         l6y6keqAMCLG6oI3LAVD7c+QxFHbwjL3DUef/iQbjo8w2ILNG8qFxo8GZyJzi53Tm5
         EvSBl3JGsvX5/zuWWOW7dBl6nTtuhy2MzJZ4w+Cqpk7axIPjIny4ce59dFFx7W0ypq
         fyDNQEV21kiGLwL5OeFy9Zipojo6q/mkzWOKOi0lZEo6PlHtOO5vmYHrok3xVNiAdG
         C2fb6v2oPKQlQ==
Date:   Fri, 3 Jun 2022 11:09:51 +0200
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
Subject: Re: [PATCH 03/18] KVM: arm64: Drop FP_FOREIGN_STATE from the
 hypervisor code
Message-ID: <YpnP35rl40rDakgb@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MU9Z6LR9WcUWlxk3"
Content-Disposition: inline
In-Reply-To: <20220528113829.1043361-4-maz@kernel.org>
X-Cookie: May your camel be as swift as the wind.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--MU9Z6LR9WcUWlxk3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 28, 2022 at 12:38:13PM +0100, Marc Zyngier wrote:
> The vcpu KVM_ARM64_FP_FOREIGN_FPSTATE flag tracks the thread's own
> TIF_FOREIGN_FPSTATE so that we can evaluate just before running
> the vcpu whether it the FP regs contain something that is owned
> by the vcpu or not by updating the rest of the FP flags.

Reviewed-by: Mark Brown <broonie@kernel.org>

--MU9Z6LR9WcUWlxk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKZz98ACgkQJNaLcl1U
h9DAAwgAgtdvhf759AQPe2iS/1hVc6SW/WgwQC00F9zMxyXtlXa85GYzI4HO0P+w
ndPvA6eGVF3vnN53rzjUdHWhej2h6JOEHFigz5/hLCQrm64n8JpCRH82ijtP9MN+
Xl6uKP7M17DRCzicD5Gr/lbVPQDIpuyLuiaoWfulT3e5piXWdNoNB3z8FHLMUhMW
+1PAc1xPv7+kZl7W8k6InJCfQT46niP1JJ6YBI3FSJifFZUSV5CuxlyvWsfOsB54
zqK1wUgbjzV8cbZvlkOIe0d5pIWG2e3YOic4Zumyqak06cwgaayUP9lPep5C35vY
Kyheo2OW0eqx+5mIlY8y61BFeimR+Q==
=amiN
-----END PGP SIGNATURE-----

--MU9Z6LR9WcUWlxk3--
