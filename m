Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655A27BAF8E
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 02:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjJFAXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 20:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjJFAXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 20:23:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878F2DE
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 17:23:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498E3C433CB;
        Fri,  6 Oct 2023 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696551794;
        bh=7gn5bYSOqY42ZOI8T3wx/ZmlPKZuUmm/rNFyG9Dmp48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ey5YSoMbAf6DFj9fHf9xM1ZO7eLGYNh0YdgfWJbUs5KiMxPzT2Ox0w8Y0KXuWxMlI
         R7eOd2SPa2T6xmOOEQcJo727q05d7tdByQ9hoToezK9oYxzyANzGbI3MmA/igqRudy
         UZCeGtXDmcz6Sms6XdW/JZI7R9dZxc4OLvLUr0vVwEnpUfLFXZOz4fAIiUMA4UhJiI
         ru1IBprQR8m8D7dr0qfvilkePAsk8ynrU5smPSSu3wtcwA9EPdQ17pIXF/ogTwOCvx
         n3ktzFN5OY8AHBTrCprYa6zCVGs1ZclqLPRAeun2gHC5aYq2redRtdxBVM3dvQIjHl
         SX9PdYdp/4yVQ==
Date:   Fri, 6 Oct 2023 01:23:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 1/2] tools: arm64: Add a copy of sysreg-defs.h generated
 from the kernel
Message-ID: <66914631-c2fe-4a20-bfd6-561657cfe8e8@sirena.org.uk>
References: <20231005180325.525236-1-oliver.upton@linux.dev>
 <20231005180325.525236-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SrIN+QuGVdEIxhwg"
Content-Disposition: inline
In-Reply-To: <20231005180325.525236-2-oliver.upton@linux.dev>
X-Cookie: Avoid contact with eyes.
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--SrIN+QuGVdEIxhwg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023 at 06:03:23PM +0000, Oliver Upton wrote:

> Wiring up the build infrastructure necessary to generate the sysreg
> definitions for dependent targets (e.g. perf, KVM selftests) is a bit of
> an undertaking with near zero benefit. Just take what the kernel
> generated instead.
>=20
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/arch/arm64/include/asm/sysreg-defs.h | 6806 ++++++++++++++++++++
>  1 file changed, 6806 insertions(+)
>  create mode 100644 tools/arch/arm64/include/asm/sysreg-defs.h

If we're going to go with this approach we should probably script the
syncing of the generated file and ideally have something that detects if
there is a generated copy in the main kernel build with differences to
what's here.  There are regular syncs which I'm guessing are automated
somehow, and I see that perf has some tooling to notice differences in
the checked in files alraedy.

That said I'm not 100% clear why this isn't being added to "make
headers" and/or the perf build stuff?  Surely if perf is happy to peer
into the main kernel source it could just as well do the generation as
part of the build?  There's no great obstacle to having a target which
runs the generation script that I can see.

--SrIN+QuGVdEIxhwg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUfU2sACgkQJNaLcl1U
h9Bxsgf+LbAdnqiKg6lFDmvFBjomywCgjLhZ5afE5Zd5HO2ZKwps6lxEVAkPwzxC
SWj8mTKAO/m90Tsz0lQH8yAPDYEF+gvDaivvdkJ1bxu6wzMBM8SPi+gd//3AJtDG
3OnCFZNJ0bqPobisbMotV79qFNFT8SjjMVhWPB0AKCHKfJZhaxl9SQD9s9FVf9Oq
Lnqa7822/9zZ9g6V1qDtCGGdLW3nV1t1sV+wi8nPXzgNIpBr7P/1mKxcv+va0YSv
BxO/IFlQSjxnoMnqgWyeOUY2GyGCW7tjCI3jmUARx2gCDQ+GmwBlQHo+/6n3maA/
vkyCfogNpyO6qVrON5JOv7zxk2iRaw==
=arWO
-----END PGP SIGNATURE-----

--SrIN+QuGVdEIxhwg--
