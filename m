Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7499C67D988
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 00:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjAZXTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 18:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjAZXTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 18:19:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48C16A5F
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 15:19:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75484B81F2C
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 23:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2587C433D2;
        Thu, 26 Jan 2023 23:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674775169;
        bh=/xxnORces+7PQtmvaI57BF4HOd03bYSj1knJxgUH8bE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T+lZMixk8EP4tji07xe82tx6YmEqXcbjBAGrS69B7gZS9MR+7W1xvss+Q9sZDMYUi
         NM036B4UMI4uoTZvk/1ETeOYaqRLX1EALJzUjmtmL3vlg5cxrqumJ7Yy8Y/DkJzKfi
         J0XWmhxNeMjkG2IZ0yZobNo301H+LGHmyi3qx76U2hL5JCeVjlcyMFlDDwhQEq1Wse
         Crs6WSVDZS1XeFxaOZB9mJIsIJ3E+n2YzMx3bKjY+ChGXGZplUFYquOApIkXxE/7uF
         bMdv4tqlw7zcdc4437q28H2XJ6SSNEMYX8LxCEuzRLGKpnRYGCMPfuC+6QXX6w/PYj
         wnd1coVWplnFQ==
Date:   Thu, 26 Jan 2023 23:19:22 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Zong Li <zong.li@sifive.com>,
        Nick Knight <nick.knight@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v13 14/19] riscv: signal: Report signal frame size
 to userspace via auxv
Message-ID: <Y9MKeqtT+PEe7KTY@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-15-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j/GNO2EbtRS4mZpS"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-15-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--j/GNO2EbtRS4mZpS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:51PM +0000, Andy Chiu wrote:
> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/=
processor.h
> index 44d2eb381ca6..4f36c553605e 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
> @@ -7,6 +7,7 @@
>  #define _ASM_RISCV_PROCESSOR_H
> =20
>  #include <linux/const.h>
> +#include <linux/cache.h>

What have I missed that is the reason for adding this header?

>  #include <vdso/processor.h>
> =20
> @@ -203,8 +205,10 @@ static size_t cal_rt_frame_size(void)
> =20
>  	frame_size =3D sizeof(*frame);
> =20
> -	if (has_vector() && vstate_query(task_pt_regs(current)))
> -		total_context_size +=3D rvv_sc_size;

Usual naming comment here about rvv.

Thanks,
Conor.


--j/GNO2EbtRS4mZpS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9MKegAKCRB4tDGHoIJi
0mmDAQCjFEpuNXkD97JMxkxeRTvw1yqmWXkab5dzjD9uKZ9rcQEAuWAEOzLFUUdw
IHP/W6yZ16E6gVFkR9IRKYwwmzhdNAQ=
=uuYD
-----END PGP SIGNATURE-----

--j/GNO2EbtRS4mZpS--
