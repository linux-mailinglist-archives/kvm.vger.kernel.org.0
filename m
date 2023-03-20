Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C580B6C13AA
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCTNlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCTNlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:41:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D3A6A50
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679319662; x=1710855662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PPnzWermFoHYGXf1sxs5wBc7KDaOYQlXVtZo5m+F6X4=;
  b=NDNDiCmjRHtNBgQWwZABBZj9TYIrkxk8PS7UrAVvU2AsMdGz5r9mcYvY
   4clVdILErVelXLb9hX1sYQJyJD0SBwcj4Vs7+kP4y1zapOyp2pkgiqMR9
   y4sd6Y44hdYdlnZ+GoKNoVmVLo6xq+gK3EchCn/Yex03X5A2EgkBCuPKI
   BgTGxsCSLBP883/eTrSoim7LMDPVfNYKlVNeaAFNT1JkSzKstGrx1Wzio
   F7Lh4bI29/gU1Hj4v/y6iGWRRlG4DRC2Z3JVoKdgxwvFDlYoDPaKQFVpM
   TPuVCxoOj4EwJJDzM6bsI6OS45PHQL+phMRu2Mh8ddmJedf7bLgsUxKMS
   w==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="asc'?scan'208";a="206286060"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 06:41:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 06:41:00 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 06:40:58 -0700
Date:   Mon, 20 Mar 2023 13:40:28 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v15 15/19] riscv: signal: validate altstack to
 reflect Vector
Message-ID: <3d5f165c-d6d2-46b9-80c6-7f159d67019c@spud>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-16-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yxPk4TWfP8/Ronq"
Content-Disposition: inline
In-Reply-To: <20230317113538.10878-16-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--1yxPk4TWfP8/Ronq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 11:35:34AM +0000, Andy Chiu wrote:
> Some extensions, such as Vector, dynamically change footprint on a
> signal frame, so MINSIGSTKSZ is no longer accurate. For example, an
> RV64V implementation with vlen =3D 512 may occupy 2K + 40 + 12 Bytes of a
> signal frame with the upcoming support. And processes that do not
> execute any vector instructions do not need to reserve the extra
> sigframe. So we need a way to guard the allocation size of the sigframe
> at process runtime according to current status of V.
>=20
> Thus, provide the function sigaltstack_size_valid() to validate its size
> based on current allocation status of supported extensions.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/kernel/signal.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
> index d2d9232498ca..b8ad9a7fc0ad 100644
> --- a/arch/riscv/kernel/signal.c
> +++ b/arch/riscv/kernel/signal.c
> @@ -494,3 +494,11 @@ void __init init_rt_signal_env(void)
>  	 */
>  	signal_minsigstksz =3D get_rt_frame_size(true);
>  }
> +
> +#ifdef CONFIG_DYNAMIC_SIGFRAME
> +bool sigaltstack_size_valid(size_t ss_size)
> +{
> +	return ss_size > get_rt_frame_size(false);

btw, thanks for using a clearer function name w/ the s/cal/get/ change &
for the expansion on the commit message.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

> +}
> +#endif /* CONFIG_DYNAMIC_SIGFRAME */
> +
> --=20
> 2.17.1
>=20
>=20

--1yxPk4TWfP8/Ronq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBhiTAAKCRB4tDGHoIJi
0i/qAQCfSzdB6WuFomcawZNe+09WjIDBQ/KE/QkzDqCJA3c5dAD7B5CUylj8niQp
8qv18v+LkX8krcxGEFGlhlm8E76emwY=
=NT4n
-----END PGP SIGNATURE-----

--1yxPk4TWfP8/Ronq--
