Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2133653852A
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiE3PnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 11:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238764AbiE3PnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 11:43:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BED62CD5
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 07:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0ECB60FB7
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 14:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE87DC3411E;
        Mon, 30 May 2022 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653922288;
        bh=zIS303ND/ipmUxzUl0cjT6WILUpauYfW4NIWc/vz/oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d96MfobovSzVRjGjNOhCLFB3kwhwzT9duEtP6BfpsqNOx6Dlsw7TL9p8OynqPl1xx
         tZKJt5XBiPYT7FhnT15yJHRl+crOFznGvfjbA5bV168fGTK6O9R0fR0oV9o84wOZFK
         RL7W/9N7rGmrgYPw1m8mM0DiBLrHw045eorTvRl2uKfaa6+pe5aoDFVZwGkhMvCU6U
         rtG+RwDDUd8fjuUHP3oP3mnXmYwYM1Pc2C4ROTu4rxRrPMS+pQBqcJtynGnkBSMxo+
         L1InQ8FcyYzr3egtS/KL6QGm7PZMpG8mb9UEbo6Vb2IQxP8sBke6IVpuoSsDc638WT
         NW+1mUzJwx7dQ==
Date:   Mon, 30 May 2022 16:51:25 +0200
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
Subject: Re: [PATCH 02/18] KVM: arm64: Always start with clearing SME flag on
 load
Message-ID: <YpTZ7btyYNOidHmO@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="09dlo0gX1RQg6igT"
Content-Disposition: inline
In-Reply-To: <20220528113829.1043361-3-maz@kernel.org>
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


--09dlo0gX1RQg6igT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 28, 2022 at 12:38:12PM +0100, Marc Zyngier wrote:
> On each vcpu load, we set the KVM_ARM64_HOST_SME_ENABLED
> flag if SVE is enabled for EL0 on the host. This is used to
> restore the correct state on vpcu put.

s/SVE/SME/

but otherwise

Reviwed-by: Mark Brown <broonie@kernel.org>

--09dlo0gX1RQg6igT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKU2ewACgkQJNaLcl1U
h9CsOAf/ch7hbdVBEYHqj9l2Bu7hPD45KvDptN/N2xZb8fzBVzmvvY+hO36KHUUJ
Wpdw3LosZwyeVxuDAKFeJRPZm/KeiNTS8eD51W6ZjeL4gDXLY1i0WFpDIr4Ue74b
mrElUFTjjrxgBQDSL2nwY9+dgwYxrKAM7697ortKfcU1aUUg9NfoOTagFwzFy0pn
P4ylovcmwFO9OWVhk9gXJwcaAi/4NttFQHrgMUkXyn9CTPLP3XzMeRxn6v+KBHCK
sbdXlECu/fK7NEkHylhE5IPKfZRqAgn4TydtOM5LseTeiLbasOPqWWF0sRRnfOjC
+o+/WxGkZCXXwQR8mhH/TR9JEOdfDA==
=SNHP
-----END PGP SIGNATURE-----

--09dlo0gX1RQg6igT--
