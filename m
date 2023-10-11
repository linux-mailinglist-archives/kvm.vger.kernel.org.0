Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DCB7C59BA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 18:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjJKQ7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjJKQ7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 12:59:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62543A9
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:59:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA494C433C8;
        Wed, 11 Oct 2023 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697043576;
        bh=e5viJcqN3nJBdRAmO/Kr+eV13Dl29hvxxs7YFH8SvNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4ON66BQJRg/M1ESDoc9mENYCcURbt3nEEVsXPZ8yAiq3EiTNX6LeDIxQszm4uezF
         v9CdDjou5MnnYv49Sfvs4sOBD/dfv4zZvYnzh946KYXmKlovUlstTJvi0AFsnyAeRg
         KfN9CNUGaG93T0eApVMKhcfGM+OI9Gn74GYevT1tGb23STWh2T8RMANxfYNOFqqToE
         WM/9CJtrnh7uF5CTaMQC31y33nCpRv8K0W01oYsP+puOYA0soaIC8p+Mhp7CzrU9p1
         ESr0UBv2YRIYjYs3tZXmv1h7kU4H8mkPaHEuSthynzE9pAUS6jUx/rO/HOg9HX9zca
         oEeP4lb8OlirQ==
Date:   Wed, 11 Oct 2023 17:59:28 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
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
Message-ID: <cef524b7-ecbc-44c4-a582-e39f495c53db@sirena.org.uk>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-2-oliver.upton@linux.dev>
 <871qe1m79u.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5Wvu08zE1b6F12Gw"
Content-Disposition: inline
In-Reply-To: <871qe1m79u.wl-maz@kernel.org>
X-Cookie: What an artist dies with me!
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5Wvu08zE1b6F12Gw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2023 at 05:51:57PM +0100, Marc Zyngier wrote:
> Oliver Upton <oliver.upton@linux.dev> wrote:

> > The system register definitions are now generated with a script over in
> > the kernel sources. Pull a copy into tools in anticipation of updating
> > dependent header files and add a common makefile for generating the
> > header.

> Rather than a copy, which makes the maintenance pretty horrible, why
> don't you just symlink it? Git is perfectly capable of storing them,
> last time I checked.

Do we even need to symlink - as I suggested on the previous version can
we not just reference the script and data file directly in the main
kernel tree?  Like I said then there may be some use case for building
the tools directory outside the kernel source that I'm not aware of but
otherwise I'm not clear that the motivations for copying the actual
headers for use in tools/ apply to these files.

I think the current approach is *fine* (hence my reviewed by)=20
given the amount of other copying but it would save a bit of work to not
copy.

--5Wvu08zE1b6F12Gw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUm1G8ACgkQJNaLcl1U
h9CwFgf/Y112LQjPKLM+hj1TZJ6acrdWLfMbZei2Ous8Xsg06Oq7ikmyXDzjpOYo
VSlhNSXrwg25eV07F17+nW39F6BLPGdZpXvSavGkcHaJu3KQcjsredI2+rj4E1r9
/y+A14KZVfY46/pOp7cvHAusvW3+ZpA6xPawTIzmBKlqJQFRTtcCCconI3pAZK/a
cVlN9kdAplLGKyIRhSebLVCApWVq5boq3OA59HGpYPoqoTIUKbAQ4u631hVKFqLG
UPHrzGT+6mW6/5N9jYnWSNh/l4FZ7pjDa6cCeRZdxIWXolUJZXecqWVvOckL6hWN
t7dz6PtJ+q8Hrb55TY2gwFNJgXLKOQ==
=ZzxH
-----END PGP SIGNATURE-----

--5Wvu08zE1b6F12Gw--
