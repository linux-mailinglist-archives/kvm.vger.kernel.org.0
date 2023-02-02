Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE641687C73
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 12:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjBBLl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 06:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBBLl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 06:41:26 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B0A6BBC8;
        Thu,  2 Feb 2023 03:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675338085; x=1706874085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xAPwScE8MGvSRWPknoRnPVEE/EEIeDB2nFQYmmKKuhs=;
  b=suxFV1GpgBaRU5qvIaCvSl4gaccO4jvxdTqiORYtjDtAAkkSIIgsY4F/
   26g4vXZkxPlMcW+EbzeLdZjW00oXiCbckyknqhQAgzyjdMvAdyWhk7zSv
   HMlMpB+MVlzL0ELGGuYkXWhv90JMoqO7O+hM5o3Bu9DMx511L40Ijp9t2
   y584PEPVws45xc7am3r5UGsokTyl71VyrypAj7H2mMpxCWEwOmJMASkpe
   exfKFxC1ca1Wbka6OvNfNYcBZ475MHWaiKEWCvvs30KJ5JrwBz2/n+719
   Agt2lybMMXJLSJl9Xvu0yN8LQiZoCB805Rvs6OzVYhxrQb+F41BzCLo++
   A==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="asc'?scan'208";a="210309876"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 04:41:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 04:41:25 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 2 Feb 2023 04:41:22 -0700
Date:   Thu, 2 Feb 2023 11:40:58 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Atish Patra <atishp@rivosinc.com>
CC:     <linux-kernel@vger.kernel.org>, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 13/14] RISC-V: KVM: Support firmware events
Message-ID: <Y9uhSoOvodeQRO6G@wendy>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-14-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tlNBWfimPX/S/xVT"
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-14-atishp@rivosinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--tlNBWfimPX/S/xVT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Atish,

On Wed, Feb 01, 2023 at 03:12:49PM -0800, Atish Patra wrote:
> SBI PMU extension defines a set of firmware events which can provide
> useful information to guests about the number of SBI calls. As
> hypervisor implements the SBI PMU extension, these firmware events
> correspond to ecall invocations between VS->HS mode. All other firmware
> events will always report zero if monitored as KVM doesn't implement them.
>=20
> This patch adds all the infrastructure required to support firmware
> events.
>=20
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 473ad80..dd16e60 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -202,12 +202,15 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsi=
gned long cidx,
>  	struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
>  	u64 enabled, running;
> +	int fevent_code;
> =20
>  	pmc =3D &kvpmu->pmc[cidx];
> -	if (!pmc->perf_event)
> -		return -EINVAL;
> =20
> -	pmc->counter_val +=3D perf_event_read_value(pmc->perf_event, &enabled, =
&running);
> +	if (pmc->cinfo.type =3D=3D SBI_PMU_CTR_TYPE_FW) {
> +		fevent_code =3D get_event_code(pmc->event_idx);
> +		pmc->counter_val =3D kvpmu->fw_event[fevent_code].value;
> +	} else if (pmc->perf_event)
> +		pmc->counter_val +=3D perf_event_read_value(pmc->perf_event, &enabled,=
 &running);

Here, and elsewhere, all branches of an if/else must use {} if one
branch needs them.
Patches 4 & 12 have similar issues, which checkpatch in the patchwork
CI stuff also complained about.

Thanks,
Conor.


--tlNBWfimPX/S/xVT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9uhSQAKCRB4tDGHoIJi
0uqpAP9x4VGfcJGp96G2q7mYM1WaLkLQmijd3P41i9ItrDKGswD/ZmRRoH9XvuNl
IoucvfrlrOXTic9oOkpunlmQVDzl6Aw=
=V4EF
-----END PGP SIGNATURE-----

--tlNBWfimPX/S/xVT--
