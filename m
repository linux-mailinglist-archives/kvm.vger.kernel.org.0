Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D40F53C74B
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 11:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbiFCJOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 05:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242962AbiFCJOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 05:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADBA3587C
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 02:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D50761993
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 09:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFA5C385A9;
        Fri,  3 Jun 2022 09:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654247653;
        bh=4iuDbJF2TwkFPPuM8NAW+pNui4kNwDghbT0ZtFlrIoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IadcjXgN2S8TgWWHwoYa0dtkT3cmgLdPmTvmlOMNv3gTXLIiT7Di5I9cBgsix7/1y
         R9JIIdE+VNCULWo8pkHEGJxPTwEpq0DLwnojTyWZqSsj3nupP377Y6rS/kp6gxxtse
         ts4APAk3ft5mjGlJqRPjcnsm2vpjhYkUTbFEgluln/vknywi+LMZzJJLrJfUjYSFqc
         /xs+iXMZKMlKMYPHkrhZ4E9xdtSqdcfaPLFkDAwIVqWqd/K68xevhAZt9ZgyZwzW53
         ieVQWZB6tJluCjXE3EHtZxb0N2j4SfEH4V0bcqxQc8CjbT5iMrNFUBY3XJT9srbWlY
         hij98GFpZCe6A==
Date:   Fri, 3 Jun 2022 11:14:11 +0200
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
Message-ID: <YpnQ43WaGH96MxyY@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cd3Wn50AMs8p39su"
Content-Disposition: inline
In-Reply-To: <20220528113829.1043361-5-maz@kernel.org>
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


--cd3Wn50AMs8p39su
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 28, 2022 at 12:38:14PM +0100, Marc Zyngier wrote:

> As it turns out, this isn't really a good match for flags, and
> we'd be better off if this was a simpler tristate, each state
> having a name that actually reflect the state:
>=20
> - FP_STATE_CLEAN
> - FP_STATE_HOST_DIRTY
> - FP_STATE_GUEST_DIRTY

I had to think a bit more than I liked about the _DIRTY in the
names of the host and guest flags, but that's really just
bikeshedding and not a meaningful issue.

Reviewed-by: Mark Brown <broonie@kernel.org>

--cd3Wn50AMs8p39su
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKZ0OIACgkQJNaLcl1U
h9Cdugf+Myti+VeYZN6D7RQ33L8t8tcj56eKqSK77fyOPsgjiMWKaCavzpRJWlBI
r2+yl/Wof+1erS6BJIVjItrz/37KiGdseN1W0cq48lubZkokkYR95NdJmtWcftTx
G4ZHPVkRT8PaLB/bnNXI0vFgUWuE/WpzJ+09QCu9DXIo79IP9num7T66O53/cMBZ
FUs0Iui5Z8qaV6QKDPgYYDFVFHSqdJxZlJpJroKbZxvJklf1HJ7jqRp3Gwex1+XT
lw01XQ+XNsarPtO0HUmaaVUfy/FSSNmrS0CI9+CMZ4DfkYQQvGEZ0XpHaSfhQ+7Z
ufNvIKzvmt5ZMl9jrr8BOkFMe40YUQ==
=c9Pn
-----END PGP SIGNATURE-----

--cd3Wn50AMs8p39su--
