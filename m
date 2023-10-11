Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769EF7C5AFD
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 20:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjJKSNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 14:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjJKSNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 14:13:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8292A4
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 11:13:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42408C433C8;
        Wed, 11 Oct 2023 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697048026;
        bh=Qa05tAAgyS/5aYss7IJ8FsoIgIP2XDxv74PGahPH+tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PA8d85+bkccWjvLJWiYmqBQJ54HcpwLZQEXbP2IcEDTLrDdjydm30uZB4M3tHChLf
         od890PMRvjpgnzFUE4CCbdS7KaWmpNaNIV0XGW6QU5mnc4kKh6iJBKslTeIKcauxwj
         VNUi5tOKu2B+JyyuvgV6jkpYT5zsRS2YAQtUNdwA5qCXiK7abyeJN4TSlTQT8gTT8R
         WA8I+XqFjult1on0oulrh/7LtZ7+keHJTsEvkNx8kbO9FOOghtWWskQBVDJ2T/oR5f
         N3sErsvtN1n2VyFmUv9oC2CsvrRiCf6yusFGBt2dixcAZ13VD79pNq0bS2jKNGKPpa
         qn/ZE7e+UmV+Q==
Date:   Wed, 11 Oct 2023 19:13:39 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/5] tools headers arm64: Copy sysreg-defs generation
 from kernel source
Message-ID: <a704d2dd-9e42-4b21-bf29-35dd3bb4eefe@sirena.org.uk>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-2-oliver.upton@linux.dev>
 <871qe1m79u.wl-maz@kernel.org>
 <cef524b7-ecbc-44c4-a582-e39f495c53db@sirena.org.uk>
 <ZSbj16o2FYOTn9DL@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3UfZlHTqfunNo1jj"
Content-Disposition: inline
In-Reply-To: <ZSbj16o2FYOTn9DL@linux.dev>
X-Cookie: What an artist dies with me!
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3UfZlHTqfunNo1jj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 11, 2023 at 06:05:11PM +0000, Oliver Upton wrote:
> On Wed, Oct 11, 2023 at 05:59:28PM +0100, Mark Brown wrote:
> > On Wed, Oct 11, 2023 at 05:51:57PM +0100, Marc Zyngier wrote:

> > > Rather than a copy, which makes the maintenance pretty horrible, why
> > > don't you just symlink it? Git is perfectly capable of storing them,
> > > last time I checked.

> > Do we even need to symlink - as I suggested on the previous version can
> > we not just reference the script and data file directly in the main
> > kernel tree?  Like I said then there may be some use case for building

> So long as we aren't going to do any further renames I don't have an
> issue with this approach.

It doesn't seem likely, and it feels like it's reasonable to ask anyone
who wants to do them to ensure they take care of the tools/ directory as
part of it.

--3UfZlHTqfunNo1jj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUm5dIACgkQJNaLcl1U
h9B66Qf+PNE9gjqhpKZhLEkzpPJbVvASlUTrnB3gm/SZwawLW2RwIUQGE8GvNPsi
LtAPYLp5pkBwCeymMSDJjPN996+mozYIxC4TSMY9NzIeYxdkUUKgmGgaPtoMSKCX
btj09yEAB1Zw8yDhUJlC+jrc4tXtit7xQaJoKE9yhYphsRmkFkHuaeN9Q/FTQfOp
IsYywyx/Q0vQ9gU2jFmqdxp45MayCWg38WV0FkLzMY8l90E7fKYIqtmAv8tEOe/D
wRTJiwOHifz5Lsl/o80HfUKKWGao0cWz1n4lqStkOhQFLjUUqviesExV2tNMXPxB
yl4aoSX7UmVNTVSKQd9PSxk92zPpfQ==
=23sl
-----END PGP SIGNATURE-----

--3UfZlHTqfunNo1jj--
