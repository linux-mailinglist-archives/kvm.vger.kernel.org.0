Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2296A7640
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCAVii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAVih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:38:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D6D2005C
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:38:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2C2614B3
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 21:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3870DC433EF;
        Wed,  1 Mar 2023 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677706715;
        bh=2TOjAcSIfOE8gIqH+j7oeqmP4jGbGHZKKqUSQ3APi8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H6uEf1e9EwW+/k9OClakly0QovLTPp7vS2ZNBOqKJeFrnKubue0VQlvhMnwLpa+dj
         3CjFusUSbS83ypZHhgMzlUoXmI02WDIQGF0eNhFx08lIkw+DnYeppOnKzepqhb6bxm
         OXRM+CCSn0LZOyIUcouaTuvGPuAZrnviqxqWpzLYX0z4JVu4lrFUM5RLPYmOhJH6wx
         RxyNsDflawWcJA8ffx1dwlTjXUt9A7goWuvWcRmZ7ZJCg9q9akj8weS8n1jv4DWnhC
         nqSQWvJfMW0M2uzbSi9aedRPBlC8LE5fgQOUP8rqC+q1shQxRXAL340/hjsQoSvXpR
         i05V6bT1EzOLw==
Date:   Wed, 1 Mar 2023 21:38:30 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v14 17/19] riscv: kvm: Add V extension to KVM ISA
Message-ID: <32f729dd-4a0c-45b1-adf7-141f50e31b0d@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-18-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/VzYTspzeD4jPzvS"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-18-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/VzYTspzeD4jPzvS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:16PM +0000, Andy Chiu wrote:
> From: Vincent Chen <vincent.chen@sifive.com>
>=20
> Add V extension to KVM isa extension list to enable supporting of V
> extension on VCPUs.
>=20
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 92af6f3f057c..3e3de7d486e1 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -105,6 +105,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_SVINVAL,
>  	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>  	KVM_RISCV_ISA_EXT_ZICBOM,
> +	KVM_RISCV_ISA_EXT_V,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
> =20
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7c08567097f0..b060d26ab783 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>  	[KVM_RISCV_ISA_EXT_H] =3D RISCV_ISA_EXT_h,
>  	[KVM_RISCV_ISA_EXT_I] =3D RISCV_ISA_EXT_i,
>  	[KVM_RISCV_ISA_EXT_M] =3D RISCV_ISA_EXT_m,
> +	[KVM_RISCV_ISA_EXT_V] =3D RISCV_ISA_EXT_v,
> =20
>  	KVM_ISA_EXT_ARR(SSTC),
>  	KVM_ISA_EXT_ARR(SVINVAL),
> --=20
> 2.17.1
>=20

--/VzYTspzeD4jPzvS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY//F1gAKCRB4tDGHoIJi
0gy/AP9kv312HhUI+B+AupH7zLPa+R564hqePJ4U1GXM+UPrdQD/Vvte7O+J8Fsx
YQDMnopT/tTs7c8my2Xv0ZQB3YJIKgY=
=FINC
-----END PGP SIGNATURE-----

--/VzYTspzeD4jPzvS--
