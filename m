Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7177C0309
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbjJJRxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbjJJRxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:53:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAD8A4
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:53:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F1C433C8;
        Tue, 10 Oct 2023 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696960396;
        bh=cx2JxC0iURoRrWYffKAIdyccngOQUSODrrfk6c46CX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nhVR5y3ImuE6z+RPfhVgYEQnhivVmAi97QFivStdWin4b8hzgp9FcFx0Qiv7k5Wm2
         tnkTOqWE/sQiYNH8Pxe678vlCddD4B44/Q9wvG2r53eJtg23BqWf7sCgqlwkfGBLhP
         E/gSvEFy/mgt7p7kLzsB2X/PNIF0Z+Bk0xsdkowb9FVeab53gA40sHtoTmWeMG8Z3A
         Otc6jznPjdLktcWeP5xM/lQm1lKlyUQDbcyu51BxO9OT3SwK8eCfaSHIbqIknbHgcF
         CtRDcEKjk1nCMCJP5IpMUuYlql+TSlLv5dKUDqj3zS6NM6q2HlrFltDNBOCLxaYFaA
         XUNAw21CgYUlw==
Date:   Tue, 10 Oct 2023 18:53:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v2 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Message-ID: <cc827136-c62f-4460-a49e-94d1b42c1f1b@sirena.org.uk>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-4-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zcteXYz5fZJBP43J"
Content-Disposition: inline
In-Reply-To: <20231010011023.2497088-4-oliver.upton@linux.dev>
X-Cookie: I feel partially hydrogenated!
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zcteXYz5fZJBP43J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2023 at 01:10:20AM +0000, Oliver Upton wrote:

> Start generating sysreg-defs.h for arm64 builds in anticipation of
> updating sysreg.h to a version that depends on it.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +ifeq ($(ARCH),arm64)
> +arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
> +GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
> +CFLAGS += -I$(GEN_HDRS)

We might want to hoist this up to the top level lib.mk at some point if
other kselftests want it too but let's not worry about it until it's a
practical issue.

--zcteXYz5fZJBP43J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUlj4QACgkQJNaLcl1U
h9CG2wf+LXRRosmuRsHr2KwWjh2URdt60VoRwaDmXhh7/pGe09afffuBz2c6/3So
So6ZdTfUue2ois6c+GACxKsjhcBOYxaNEkXubiv0KrqCNHsALoxTjB6uhD+3+Nuo
9Xz8ieecM9loqu7AYV+69udmy7bIKyt+aDm6bRtL0OoixTbAuH6qPzfOv1cV2AoK
ESB9tqrPI1MnK+I5O9peYaBvEevsB1CnI47LU4Mjb9679mN+1I0WeT4cMLmwHN8b
BWry5Nw7cQpiYosGLCvw3ZBbeBywPcYHc60h/O7DgJ8Ti53tTWsB/ndx1cxvlY/u
DSOo/pPUSSEO5bTag4/mlztczNALwA==
=0wtO
-----END PGP SIGNATURE-----

--zcteXYz5fZJBP43J--
