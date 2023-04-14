Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAEC6E2882
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDNQkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDNQku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:40:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FDB180
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC626491B
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 16:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6957BC433EF;
        Fri, 14 Apr 2023 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681490448;
        bh=+bsbFNcFaj5gJ3yfrtFwobAIBFwXygC8zktuMnqtTAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y34iTueB1ifRDeV6Isv0WDNMZGlBnhcZZ1uCNgJG3nLT5yhwSKyV0AyVts4gvbswA
         e+AdwztVpPwhw9z+yLol7HMiiKoNDDyszoueN/sc5mTz/RBzasG2f6TE1bv3o5Yzyz
         UTR9SxuAbNjdy7V2z5bh3fb+/5+y+19A5SvDemYIoUuYGmFIer5SCsmPrwPdh3/j4o
         SE6tA1aNfobSAlnHernR9scc2/UO4jkm/kW2hYj/K48OIdgRzwusT+BLdfWCre05GC
         /wbaiEBAf3r+wNDC2BnurySFNsV8egX6la7Q/tCvRQq9u1lfNOBRbNafx8wRQqCNIw
         ezJ/cY3n6ObfQ==
Date:   Fri, 14 Apr 2023 17:40:41 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>
Subject: Re: [PATCH -next v18 10/20] riscv: Allocate user's vector context in
 the first-use trap
Message-ID: <20230414-sprout-vengeful-f076776a08d7@spud>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
 <20230414155843.12963-11-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5xCGmRrbh4SbHigR"
Content-Disposition: inline
In-Reply-To: <20230414155843.12963-11-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5xCGmRrbh4SbHigR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 14, 2023 at 03:58:33PM +0000, Andy Chiu wrote:
> Vector unit is disabled by default for all user processes. Thus, a
> process will take a trap (illegal instruction) into kernel at the first
> time when it uses Vector. Only after then, the kernel allocates V
> context and starts take care of the context for that user process.
>=20
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@lina=
ro.org
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Acked-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>

I meant to reply to v17 saying that you could re-add my R-b, so:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--5xCGmRrbh4SbHigR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDmB9wAKCRB4tDGHoIJi
0jWmAQC10lY6uQVT+9WcXeQcH4DlqcXAy+iPmVp3ThJ14aNolAD/Zbm6ynzF2B7J
HiJEUH9/tcfJHMCB5H3LLiXMNtUazAs=
=7brj
-----END PGP SIGNATURE-----

--5xCGmRrbh4SbHigR--
