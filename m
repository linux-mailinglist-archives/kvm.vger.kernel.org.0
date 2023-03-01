Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DCF6A7214
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCARaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 12:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCARaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 12:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ED23B85F
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 09:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195FAB810B2
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 17:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12B3C4339B;
        Wed,  1 Mar 2023 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677691803;
        bh=AnretRIAHtjSZSeScp081+39dAq1WeF3Q30drGyIvNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cNlOs5oHEUeriuLQ0tPh5AZJIms2ZfTXq5EsS95+7CZwTZHgBa0UdRRysmQbfmIsL
         Azu8dl9O9JT8DfJP6NUmyIzlMgg67uoky1AgqY+St20CiFYmdsYUZqPoY8mqQB1a1x
         MQpRSpynT+Ho+o3oDPI2B+0+XwrreNPjKENeRlBi6+YHsbd/6WDDg5sMFrb5uC1qvA
         86MaHKo41acG/uaVnhJKqvlQt+afP8fF2/NHOTIKuJmuOQxFgeeAtKzZxyMlhwGuEt
         WfnSUn13oH9liVLV0jfUGpIPIlqINpCAaiRY2+Y+HNTO+XwyQZRRJj/iVZT8cNK3oM
         dN6KtoB3FRJCw==
Date:   Wed, 1 Mar 2023 17:29:56 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH -next v14 11/19] riscv: Add ptrace vector support
Message-ID: <Y/+LlNjJKA93FM7w@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-12-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GhW3vsjuT8BV+9si"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-12-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--GhW3vsjuT8BV+9si
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:10PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch adds ptrace support for riscv vector. The vector registers will
> be saved in datap pointer of __riscv_v_ext_state. This pointer will be set
> right after the __riscv_v_ext_state data structure then it will be put in
> ubuf for ptrace system call to get or set. It will check if the datap got
> from ubuf is set to the correct address or not when the ptrace system call
> is trying to set the vector registers.
>=20
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---

> +static int riscv_vr_get(struct task_struct *target,
> +			const struct user_regset *regset,
> +			struct membuf to)
> +{
> +	struct __riscv_v_ext_state *vstate =3D &target->thread.vstate;
> +
> +	if (!riscv_v_vstate_query(task_pt_regs(target)))
> +		return -EINVAL;
> +	/*

With the tiny nit of a missing newline after the return, both here and
in _get(),  this looks grand to me.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--GhW3vsjuT8BV+9si
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+LlAAKCRB4tDGHoIJi
0jjGAP92sCBHnExQMUSTyKYLd77FpiWjp8SKxLmkOQQwlbv8GgD+Ou8ZyiCtToLB
UeLZqVr9O+2U0WRJtferBBTYXdSbWwo=
=dJVN
-----END PGP SIGNATURE-----

--GhW3vsjuT8BV+9si--
