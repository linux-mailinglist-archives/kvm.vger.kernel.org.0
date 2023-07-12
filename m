Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF8175127D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 23:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjGLVRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 17:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjGLVRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 17:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554AB2D5F
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 14:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A262C61949
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 21:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C27C433C8;
        Wed, 12 Jul 2023 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689196534;
        bh=srSlB45+tKsynjd6lCyOzCxBjejSi0aDwrSiQqn1wyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OiE8UQug9Lz2a6vhipxEPBqS6prjPYc7yMA2qulV1NLKTEryjgF1cpaowmNBIKDJr
         5kyucBnEjLgZ31kwqimtZY+X6DISdfJQpUSpgMCNtO1JirIW1qnspmNgY92/PnKoHv
         CUgp0Z++IhVn0Vc6erne+uFpZMTt4tp7PxVSJn+bfL07EuMAuRQD2VjjUlSfc6xMx8
         uPasvsJ+z+b5mSJ80gTA+oZNLy3tIwc7BTdFapRQmYKf5tc6tVvEBWSQ79u3yyHECZ
         b8ucBuuUihR0maADZncjMFyT+QuYT4EaujYHYG/SqwAthN9opwUT2Ruro/Pnn9sMAs
         6/zOwFa76frSQ==
Date:   Wed, 12 Jul 2023 22:15:27 +0100
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
Subject: Re: [PATCH 14/27] KVM: arm64: Restructure FGT register switching
Message-ID: <2dbb5fd5-a275-432e-832b-7926060c9254@sirena.org.uk>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-15-maz@kernel.org>
 <b9ccca23-65d5-4ed1-976e-63d51e3457e3@sirena.org.uk>
 <87edlcao9b.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LgilXWRWGTBHM5Pp"
Content-Disposition: inline
In-Reply-To: <87edlcao9b.wl-maz@kernel.org>
X-Cookie: Dammit Jim, I'm an actor, not a doctor.
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LgilXWRWGTBHM5Pp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 09:06:08PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > > + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
> > > + * We're not using the generated masks as they are usually ahead of
> > > + * the published ARM ARM, which we use as a reference.

> > What's the issue here?  The generated definitions should be aligned with
> > what's published in DDI0601.  That AIUI exists in large part due to
> > concerns people were having with the amount of time it can take to fold
> > new features into the ARM, it's official.

> For multiple reasons:

> - What's published as DDI0601 is a list of registers, without any
>   context and no relation to the wider architecture (it is basically
>   the XML dumped as a PDF). That's not enough to implement the
>   architecture as it is missing all the content of the engineering
>   specs, which are not public documents.

Right, it's not the full spec - I was just thinking it was enough to
cover the use here with finding RES0 bits.  The actual XML is
downloadable as well, via=20

    https://developer.arm.com/downloads/-/exploration-tools

if that's more convenient (I am not sure why that's not available if you
go looking for DDI0601), not that that addresses the issue with not
having the non-XML part of things.  I know the people responsible for
producing the ARM are actively working on improving the production
process to address the lag so the ARM is available much more promptly.

> - I have no motivation in supporting the latest and greatest. NV is
>   hard enough without all the (still evolving) crop of 8.9/9.4
>   extensions.  As long as what I have is a legal implementation and
>   runs on the HW I have access to, that's good enough for me.

> - I want to look at a single document and support what's in there. Not
>   two. Because it is hard enough to follow when you're implementing
>   this crap, and even harder for someone trying to review it.

> So I firmly intend to totally ignore most of what's outside of the
> published ARM ARM unless it makes my life so much easier that I can't
> afford not to implement it.

That's definitely fair, my concern here is the risk that we might end up
with issues due to the manual definitions drifting from the generated
ones without people noticing as things go forwards.  Hopefully that's a
minor risk.

--LgilXWRWGTBHM5Pp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSvF+4ACgkQJNaLcl1U
h9Civwf/ZXWGE/hczTCulEMG2U6Wn7o9Ym9bVTemK3dSzhcUr869CF5uYsqOCd8D
5C8zdI44DKVAVKBP8dKZPuT/AI7WzIW+GY02+xGyqKVkZWl1zczQt4uYfUCKFPnU
TTBPMYXNxvh3yS7i1NXBhcdvbJebdE8GHRhQyHQNUXrOpv6HjzlqLpMXTGNWvv08
nEGnatET3TdJl+UkO5B1/sHDJ+hVWacgTeixZJEJ1KBSRg8OFlh+E6gLkRDCj5gU
IwLXM1KQGrghwT1TIaskC6XxiMhT3HIrIouF2QXOlSoPI3uBULWVMl7KiCPfDPe9
BYAiQnXnlLtCIzw0ychfACdnUjv50A==
=X6vv
-----END PGP SIGNATURE-----

--LgilXWRWGTBHM5Pp--
