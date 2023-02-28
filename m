Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FF66A61E1
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 22:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjB1V4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 16:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjB1V4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 16:56:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDDA12BEB
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 13:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E77C5B80ED1
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441CFC433D2;
        Tue, 28 Feb 2023 21:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677621403;
        bh=S8lArU8afl+FZofTeoyMgzmCP7SiMn5vwh2R/3DZBHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FTnOmkiSrrcvXLqb23p7iecO7gYO9DO7ij5XwxGxJ96BCipXunN2lqrUxV3oTZ7iR
         c+kyCANjoFiIFyb5QzYsid9wjh0PPjEqCG9xCFdawApISHIjwVsbbw+IHH+//vUAIH
         nVQPf7+x95TMdb7IpdlzVNWWwR5C5A9Jgb2kljR+jrWcvgcivJc2wlL6/p3efRwiO6
         LiQcAFh8BQKaScrm65OpfJH2jWe27XYZUrxjCybTnCIIcloQPAsw56V8M33FCKPVBp
         holjrGCZ3LXZL4fdz3TjoO4WNldoKJPFsjn49TRvHKnfRZUBm9MDsiTbUJnJkYEQU5
         zEAWNZnfGBIvQ==
Date:   Tue, 28 Feb 2023 21:56:37 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Nick Knight <nick.knight@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: Re: [PATCH -next v14 01/19] riscv: Rename __switch_to_aux -> fpu
Message-ID: <Y/54lWWZcx4sP5KE@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-2-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AmPj++hEXIEO1fE8"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-2-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--AmPj++hEXIEO1fE8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:00PM +0000, Andy Chiu wrote:
> From: Guo Ren <ren_guo@c-sky.com>
>=20
> The name of __switch_to_aux is not clear and rename it with the
> determine function: __switch_to_fpu. Next we could add other regs'
> switch.
>=20
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>

Suppose I shall tack myself onto the end of this list...
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--AmPj++hEXIEO1fE8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/54lQAKCRB4tDGHoIJi
0j5jAQCIrjBp1393Twe2BrHYeQyeiOv8wJ4vK9IIMw4cWM+k1QEAqiBDe+dgYFPH
hiidtfhhhbRNB3L9TloRKGC9iudVxgA=
=YHMe
-----END PGP SIGNATURE-----

--AmPj++hEXIEO1fE8--
