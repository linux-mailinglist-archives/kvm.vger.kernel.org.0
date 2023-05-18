Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33277086F0
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 19:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjERRcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 13:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjERRb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 13:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E6210E2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B523760C82
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45FBC433D2;
        Thu, 18 May 2023 17:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684431102;
        bh=zzp+uovCM+0ktu/LRwnGZCR4E9oZn2Eu76OqQF3q8zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCa0sI9TiYtzmwygrOxmqsEphXml8GCDPI+Uyvgl2lmFO300C2SL9+xr2oZDQgnmd
         JC1Iwm99HHpZ48WwVvC1Vp3JCWhzzlIQa5n11P8oSgprFcBeVP01ZD5NPuZVF9icu+
         5WXSVatdqL7Ps4Tlt2ZLQTLkUgohAwnv5cHYSdo/WL8+tEyQyozAIwOQTJ+NLNMcSD
         wycNptRle6HS5XtjWK5XwyywCCV7D67kB2X1bEVtKRgdsawRVNyFBk9riCPQjYKNxi
         9aZBSFD8B0ttgCzluYRXW01ojb1BGacomQMkTvWdttxj5MjWh+vEmljOjluj+3zxa5
         KKPkTCA/FunMg==
Date:   Thu, 18 May 2023 18:31:37 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v20 23/26] riscv: Enable Vector code to be built
Message-ID: <20230518-rented-jogging-b84c705f7d76@spud>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
 <20230518161949.11203-24-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bQceGelgZ6gGgrWd"
Content-Disposition: inline
In-Reply-To: <20230518161949.11203-24-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bQceGelgZ6gGgrWd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 18, 2023 at 04:19:46PM +0000, Andy Chiu wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
>=20
> This patch adds configs for building Vector code. First it detects the
> reqired toolchain support for building the code. Then it provides an
> option setting whether Vector is implicitly enabled to userspace.
>=20
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>

> Suggested-by: Conor Dooley <conor.dooley@microchip.com>>

You can drop this tag if you respin, I just provided review comments ;)
Also, it has an extra > at the end.

Otherwise, I am still not sold on the "default y", but we can always
flip it if there is in fact a regression.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks.

--bQceGelgZ6gGgrWd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGZg+QAKCRB4tDGHoIJi
0lffAP923xnPAi25QhBpQiF/OpAi1FG7JJJt2w3dfV0mC2a3FQEAlJOfSGkio5j1
qO0ZWN5aIO5AXcPZ1Tl1jmBjwSdNVAE=
=Hlwa
-----END PGP SIGNATURE-----

--bQceGelgZ6gGgrWd--
