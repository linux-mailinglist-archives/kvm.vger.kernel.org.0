Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF456A7168
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 17:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjCAQli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 11:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCAQlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 11:41:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A73C3C79F
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 08:41:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F147B80E95
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 16:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4CEC433D2;
        Wed,  1 Mar 2023 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688893;
        bh=ilPyVms7UIryzUrsM+Np2EOsRlnOLEbdK14JoDx6MHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aZB2LKzs0qUuWleTcmnuFpnEw+hlWFu9WoeeuL4gkBxjwroXZqmgQrPJNzPqmxmvO
         TbAOXuyW1zc88FVsU9fCZzF1hiAc3Wome0J20NP8ncOzQaU8avaY6r7p6PoqERvCLW
         7F8ihTWRaonHmO0F+3TU11JMwGj7elzjJ8pGcNjgI/nwkSko1t8hekP3DFDORmRnBJ
         U29y/Rkgf8ni9UYchTXuttVGAuqELf7/Y6XL6TXBI8bASrkQXm+YEr/tmH82h4j07f
         783v1PolzJahYVs8StciNeV0VViA8DjWSaUtyE37FxaI7OjikLwMaZeaROIWFRGXHx
         n2Z7clJ4qc+Jw==
Date:   Wed, 1 Mar 2023 16:41:27 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Nick Knight <nick.knight@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH -next v14 09/19] riscv: Add task switch support for vector
Message-ID: <Y/+AN0e5netDShxx@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-10-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6+DehdO2+y0/dUdA"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-10-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6+DehdO2+y0/dUdA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Fri, Feb 24, 2023 at 05:01:08PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch adds task switch support for vector. It also supports all
> lengths of vlen.
>=20
> [guoren@linux.alibaba.com: First available porting to support vector
> context switching]
> [nick.knight@sifive.com: Rewrite vector.S to support dynamic vlen, xlen a=
nd
> code refine]
> [vincent.chen@sifive.com: Fix the might_sleep issue in riscv_v_vstate_sav=
e,
> riscv_v_vstate_restore]
> [andrew@sifive.com: Optimize task switch codes of vector]
> [ruinland.tsai@sifive.com: Fix the arch_release_task_struct free wrong
> datap issue]
> [vineetg: Fixed lkp warning with W=3D1 build]
> [andy.chiu: Use inline asm for task switches]

Can we *please* get rid of these silly changelogs in the commit messages?
Either someone did something worthy of being a co-developer on the
patch, or this belongs under the --- line.
It's a bit ridiculous I think to have a 15 word commit message for the
patch, but have like 8 different bits of per-version changelogs...

> Suggested-by: Andrew Waterman <andrew@sifive.com>
> Co-developed-by: Nick Knight <nick.knight@sifive.com>
> Signed-off-by: Nick Knight <nick.knight@sifive.com>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/include/asm/processor.h   |  1 +
>  arch/riscv/include/asm/switch_to.h   |  3 ++
>  arch/riscv/include/asm/thread_info.h |  3 ++
>  arch/riscv/include/asm/vector.h      | 43 ++++++++++++++++++++++++++--
>  arch/riscv/kernel/process.c          | 18 ++++++++++++
>  5 files changed, 66 insertions(+), 2 deletions(-)

> @@ -118,6 +154,9 @@ static __always_inline bool has_vector(void) { return=
 false; }
>  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return f=
alse; }
>  #define riscv_v_vsize (0)
>  #define riscv_v_setup_vsize()	 do {} while (0)
> +#define riscv_v_vstate_save(task, regs)		do {} while (0)
> +#define riscv_v_vstate_restore(task, regs)	do {} while (0)
> +#define __switch_to_vector(__prev, __next)	do {} while (0)
>  #define riscv_v_vstate_off(regs)		do {} while (0)
>  #define riscv_v_vstate_on(regs)			do {} while (0)

While you're at it, you pay as well tab out all the do {} while (0) so
that they align. That's my OCD showing though.

Other than my complaint about the changelogs, this looks grand.

Thanks,
Conor.

--6+DehdO2+y0/dUdA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+ANAAKCRB4tDGHoIJi
0iomAQDpMp3VqnpVdvJ/tHxRv8rBb8uA3DTLsMTxyXoU5vx3PgEA8PfYfPho/7xr
PGvH3ug2iAYIbBSLhqlULA0e+uVRnwA=
=dxbL
-----END PGP SIGNATURE-----

--6+DehdO2+y0/dUdA--
