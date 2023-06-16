Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F12733113
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 14:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344442AbjFPMWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 08:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbjFPMWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 08:22:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B2110EC;
        Fri, 16 Jun 2023 05:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686918164; x=1718454164;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ex0yt1i7Cbl/SX0kQYlhzclSAQPI9Tm8drVNJbKVxxQ=;
  b=w4Mxx5ZnW/SdSSjQ/K+3q7iPckaR6LvluugbtMqcoBc2FiQLnXTDD69q
   MtQyKNrgLE8NUdohqe3IJNaT8siEuYTfCC0knR/OJADweFNf/VddeRPcI
   b5K6GoihaorfN1s28P8dTuZIb+7Qn6TkQoOI4hJ+VKRGsWKRxBFigkjYJ
   lZFaVbBT1njdmYPszsKpqfhd6ZZHwWjFDvXy6tLKD+exSahW5dO2I0Ydd
   6IDv+xfNwtnQT10Xm0922nnpx+hOTgWMyLDJKYZgsXjzS3TQIhLez9bYd
   6gvEziF7fLahOXuBA8rg8srLYDU5QFeATWRBHpeHAHPGoxiZgI21jEQKU
   A==;
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="asc'?scan'208";a="157265778"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jun 2023 05:22:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 16 Jun 2023 05:22:37 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 16 Jun 2023 05:22:36 -0700
Date:   Fri, 16 Jun 2023 13:22:10 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
CC:     <linux-riscv@lists.infradead.org>, <kvm-riscv@lists.infradead.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <palmer@dabbelt.com>, <anup@brainfault.org>, <atishp@atishpatra.or>
Subject: Re: [PATCH] riscv: kvm: define vcpu_sbi_ext_pmu in header
Message-ID: <20230616-founder-speech-6f57f22e1412@wendy>
References: <20230616115410.166244-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q6rxVgS4vXEezT6x"
Content-Disposition: inline
In-Reply-To: <20230616115410.166244-1-ben.dooks@codethink.co.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Q6rxVgS4vXEezT6x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Ben,

On Fri, Jun 16, 2023 at 12:54:10PM +0100, Ben Dooks wrote:
> Sparse is giving a warning about vcpu_sbi_ext_pmu not being
> defined, so add a definition to the relevant header to fix
> the following:
>=20
> arch/riscv/kvm/vcpu_sbi_pmu.c:81:37: warning: symbol 'vcpu_sbi_ext_pmu' w=
as not declared. Should it be static?
>=20
> Fixes: 3e5e56c60a1477 ("riscv: kvm: move extern sbi_ext declarations to a=
 header")

You sure this is the right fixes tag? This code didn't exist when I
wrote that commit, should the fixes tag not be
	Fixes: cbddc4c4cb9e ("RISC-V: KVM: Add SBI PMU extension support")
instead?

Cheers,
Conor.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 3 +++
>  arch/riscv/kvm/vcpu_sbi.c             | 4 +---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index 4278125a38a5..b94c7e958da7 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -66,4 +66,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext=
_hsm;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
> =20
> +#ifdef CONFIG_RISCV_PMU_SBI
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> +#endif
>  #endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index e52fde504433..c973d92a0ba5 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -20,9 +20,7 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext=
_v01 =3D {
>  };
>  #endif
> =20
> -#ifdef CONFIG_RISCV_PMU_SBI
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> -#else
> +#ifndef CONFIG_RISCV_PMU_SBI
>  static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu =3D {
>  	.extid_start =3D -1UL,
>  	.extid_end =3D -1UL,
> --=20
> 2.39.2
>=20

--Q6rxVgS4vXEezT6x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIxT8gAKCRB4tDGHoIJi
0vXrAPoDbIl7+BtIQL9RSKnHHl+qR6AC1t2fNpqK2vRdGsayQwEAktGck+kuaWVm
Th3ycnNrUQaUtOO9UX0f+TD5F+ilKA4=
=BTVw
-----END PGP SIGNATURE-----

--Q6rxVgS4vXEezT6x--
