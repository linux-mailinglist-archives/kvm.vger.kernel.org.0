Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02377BC0C2
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 22:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjJFUwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 16:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbjJFUwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 16:52:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D430BD
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 13:52:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0520EC433C8;
        Fri,  6 Oct 2023 20:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696625568;
        bh=6gw26i5UhuMp+O8gF4WbUk+QbWnjoZs1jIoNHPWeyuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PloiUE+//+LxK7DVbsW95KlChVfo/QmHu4+vku+HKoImR94uIqaXp+7q55BWbpphm
         ZFxkyJBRozeMt4tJKu9Or9GGVPfdQiRW47qzHaZFOO8jpu4VmpBkWURcKg+AOBxNEZ
         l2a566VrJrwhfEHpWZyKGhYaza5G39tt01r9pdrRXmdP87cKRDKpf0JCBmM606vKFm
         O4wVoi0ssBrnb2lyeqtBaNoXlXtS+ws22syB9tstKNkP7JdhYcOlMiafxWblFG90w1
         SiZnaCOcii7J5AJSe5J/2+SvevekU9NLpy5z7KoDuUHGy9jil8ZT8iI+fcB64k7wr4
         1D8sQza//fnvQ==
Date:   Fri, 6 Oct 2023 21:52:43 +0100
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
Message-ID: <ca6bf3c6-230c-4645-bfc0-2ebe2e680032@sirena.org.uk>
References: <20231005180325.525236-1-oliver.upton@linux.dev>
 <20231005180325.525236-2-oliver.upton@linux.dev>
 <66914631-c2fe-4a20-bfd6-561657cfe8e8@sirena.org.uk>
 <ZR_SLyTfkhmdZoXI@linux.dev>
 <ec96d303-f0c4-470c-b23c-e59054c52008@sirena.org.uk>
 <ZSBjAWlPUBjiU7Vj@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2Ho6O1gZ03A33tqs"
Content-Disposition: inline
In-Reply-To: <ZSBjAWlPUBjiU7Vj@linux.dev>
X-Cookie: Rome wasn't burnt in a day.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--2Ho6O1gZ03A33tqs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2023 at 07:41:53PM +0000, Oliver Upton wrote:
> On Fri, Oct 06, 2023 at 12:33:48PM +0100, Mark Brown wrote:
> > On Fri, Oct 06, 2023 at 09:23:59AM +0000, Oliver Upton wrote:
> > > On Fri, Oct 06, 2023 at 01:23:08AM +0100, Mark Brown wrote:

> > > incidental user of this via cputype.h, KVM selftests is what's taking
> > > the direct dependency.

> > If perf doesn't care perhaps just restructure things so it doesn't pull
> > it in and do whatever you were doing originally then?

> The only option would be to use yet another set of headers that are
> specific to KVM selftests, which I feel would only complicate things
> further.

I don't see that it needs to be a different copy?  It'd just be perf
skipping the generation part of things which AIUI it doesn't actually
need.

> > | In file included from util/../../arch/arm64/include/asm/cputype.h:201,
> > |                  from util/arm-spe.c:37:
> > | tools/arch/arm64/include/asm/sysreg.h:132:10: fatal error: asm/sysreg-defs.h: No such file or directory

> > so that's already happening - see perf's arm-spe.c.  You could also fix
> > perf by avoiding spelunking in the main kernel source like it's
> > currently doing.

> My interpretation of that relative path is tools/arch/arm64/include/asm/cputype.h

Ugh, right - that directory of fun :(  It's not exactly copies of the
kernel internal headers, it's separate thing that happens to look at lot
like them but isn't always the same - most of the files are straight
copies but there's also some independent implementations in there.

> perf + KVM selftests aren't directly using kernel headers, and I'd rather
> not revisit that just for handling the sysreg definitions. So then if we
> must periodically copy things out of the kernel tree anyway, what value
> do we derive from copying the script as opposed to just lifting the
> generated output?

The original code was generating things during the build so I'm really
confused as to why that's now completely off the table?  It does seem
like the obvious approach, it feels like I'm missing some of the
analysis here.  Doing generation makes keeping things in sync marginally
easier (you don't have to do do an arch specific build) and the source
smaller, and makes it clear that this is actually duplication.

> We must do _something_ about this, as updates to sysreg.h are blocked
> until the handling of generated headers gets worked out.

So then the original code seems like the obvious thing surely, it just
put the Makefile fragment doing the generation in the wrong place (or
perhaps should have duplicated it in the perf Makefile given that
there's no obviously sensible shared place already, it's just a couple
of lines)?  Or like I said previously tweaked things so that perf isn't
pulling in the generated file in the first place and doesn't need to
worry about it.

TBH when doing generation I'm not sure I see the value in doing a copy
in the first place, I'm not sure people ever actually pull the tools
directory out of the kernel source and build it independently so we can
just skip the effort of keeping a copy in sync entirely.  With copying
the headers we gain control of exactly which headers tools are looking
at, plus there's the cases where the headers diverge.  If we need
explicit rules to generate and don't expect to ever diverge then we get
both properties as part of the generation process with just the
duplication of the rules.  There might be use cases where tools/ needs
to be actually free standing though.

In any case I don't think we should just check a raw copy of the
generated file in with nothing to automate the drift detection and sync
parts of things which is what the current patch does.

--2Ho6O1gZ03A33tqs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUgc5oACgkQJNaLcl1U
h9Cz0Af/XdtHoZ9OcgWhEjzkT/D/sQPYsTBsiLszyetAgTjM4yOft1FXRgb9vgqm
s/UTcDoZY4I3KjrHMhYxP/D/arj6Nh9/5Q2J9Ihbit14Q2vigpFqBH7o8Hws0ZFM
w121TzyhG8dsKmqkmn8AAfqQUQWF5mNL8+STvzQrdtwSu1MrW/9QirGLE+pSH/kz
2GbmBA6gPIc2Xp7crqzYJwVKgfPGFbr8ijVa+0wsd49moFx+rpxZW/VY/wN+WSgG
kKehjejPlTuq3BTh5q6726In6gnm5pW8dVh0Pw51J01Ia5FtnjWUuYPh4ooe3D+3
vl+ekCyGBp1ObS35s2uhy0FfjwHbuw==
=KvNx
-----END PGP SIGNATURE-----

--2Ho6O1gZ03A33tqs--
