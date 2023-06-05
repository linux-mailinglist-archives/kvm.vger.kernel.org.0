Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715B5722C20
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjFEQES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjFEQER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E13D94
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E99361F6E
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 16:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0387C433EF;
        Mon,  5 Jun 2023 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685981055;
        bh=6qbih/vEQ3IgOXhLpHjEbAQXTz8MxqlIdSAHtD/Pfbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gW5cwihYbSD8isEE0cE+yobhRtfF9vEw94r7PkeRaaStg2e1/fROWxZfDtpRjH3x+
         Mv8hOIU2+WvsoJ8QvGkYR0wYXAyX5NplAznMKUMl42ZsEqENKnyKKwzBPzlsPIgrBs
         YbRd5iiTdDNYitNa2z52AV26E+WEFjB/Qtc60I5rR8DUATW4Dv7T63q/TdCotXq/FA
         DhLhwSDXvPw+uZYzTMTcCtmWULNI6Mt1hFhqN6/ACCVKF2FlvLeJKPrKPckoEDKwG6
         XSAYovwPnTzK4rGq3hKVT5NNJx1VyclG9A8m3otlVqOg390dOeX3+8oHzgHNjfFD3e
         RO1Ak36QgG2Tw==
Date:   Mon, 5 Jun 2023 17:04:08 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Liao Chang <liaochang1@huawei.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>
Subject: Re: [PATCH -next v21 11/27] riscv: Allocate user's vector context in
 the first-use trap
Message-ID: <20230605-creme-smugly-e7592c870dda@spud>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-12-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JDKQEQvRrSOz4/Yu"
Content-Disposition: inline
In-Reply-To: <20230605110724.21391-12-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JDKQEQvRrSOz4/Yu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05, 2023 at 11:07:08AM +0000, Andy Chiu wrote:
> Vector unit is disabled by default for all user processes. Thus, a
> process will take a trap (illegal instruction) into kernel at the first
> time when it uses Vector. Only after then, the kernel allocates V
> context and starts take care of the context for that user process.
>=20
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@lina=
ro.org
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
> Changelog v21:
>  - Remove has_vector() and use ELF_HWCAP instead. The V bit in the hwcap,
>    if preesents, implies has_vector() returning true. So we can drop
>    has_vector() test here safely, because we also don't handle !V but
>    has_vector() cases.

I think you could probably have carried my R-b from v20, but I realise I
did not reply to you - sorry about that.
The removal of the has_vector() check seems to tally with the
conversation we had on v20, so
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--JDKQEQvRrSOz4/Yu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZH4HeAAKCRB4tDGHoIJi
0gMUAP90+rSr7Qh/b85tSAyFl+ycEwu104o3A+izAsQe5k6aXAD8CHaPrNUw32YG
9aVdc4VtljGYKMwlbMMXQrgfGv0FOQ4=
=4Lvs
-----END PGP SIGNATURE-----

--JDKQEQvRrSOz4/Yu--
