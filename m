Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3569264E240
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiLOUSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLOUSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:18:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB1F31EC1;
        Thu, 15 Dec 2022 12:18:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F326ECE1D03;
        Thu, 15 Dec 2022 20:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3BBC433F2;
        Thu, 15 Dec 2022 20:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671135484;
        bh=oel0ZlOiiQOwqlbEX/I6OlGQeXzpFhRh/Jy7Mv8nTSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EdgEqLCxeDXAXzybpNlP+ffQ5ItI5gPQ7CTUCYBo8RvvtRESOQPBALRL+vW1IhqGq
         BcZmyxEvj93MuMP9mlwbZPusjeAe/v/zLGehtYlDTIuxVTX01PGeaGOZY2+z1I85LG
         m2h18sYLJRI/iaazBkEwL1ZsU8wM9jjwylN1zJTv9GeSurm08lFsQQroHPuzw2HUqB
         1W+cUcwr8AwgyC4B0SmqQlB29+nAVpLTWym2WiveICJE5zAe4KNghI8cyHytPT6neX
         9UztJTVoSwuB07T3lj+gERoqWbkO6IicFX0Ri1klvT1FE8TEbZRf/zukRFtKaaErM7
         lZNGn8IQTaqcg==
Date:   Thu, 15 Dec 2022 20:17:52 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 05/11] RISC-V: KVM: Improve privilege mode filtering
 for perf
Message-ID: <Y5uA8CEoTKzIGoSy@dizzy>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-6-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Kh96vCh7mb1vJCOA"
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-6-atishp@rivosinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Kh96vCh7mb1vJCOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Atish,

On Thu, Dec 15, 2022 at 09:00:40AM -0800, Atish Patra wrote:
> RISC-V: KVM: Improve privilege mode filtering for perf

I almost marked this as "not applicable" in patchwork as I was mislead
by the $subject. I know our perf driver is a real mixed bag, but should
it not be something more like:
"perf: RISC-V: Improve privilege mode filtering for KVM"?
It was only when I noticed that the rest of the series had been marked
as "Handled Elsewhere" that I realised that this must not be a KVM patch
;)

Thanks,
Conor

> Currently, the host driver doesn't have any method to identify if the
> requested perf event is from kvm or bare metal. As KVM runs in HS
> mode, there are no separate hypervisor privilege mode to distinguish
> between the attributes for guest/host.
>=20
> Improve the privilege mode filtering by using the event specific
> config1 field.
>=20
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c   | 27 ++++++++++++++++++++++-----
>  include/linux/perf/riscv_pmu.h |  2 ++
>  2 files changed, 24 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 65d4aa4..df795b7 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -298,6 +298,27 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *n=
um_hw_ctr)
>  }
>  EXPORT_SYMBOL(riscv_pmu_get_hpm_info);
> =20
> +static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
> +{
> +	unsigned long cflags =3D 0;
> +	bool guest_events =3D false;
> +
> +	if (event->attr.config1 & RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS)
> +		guest_events =3D true;
> +	if (event->attr.exclude_kernel)
> +		cflags |=3D guest_events ? SBI_PMU_CFG_FLAG_SET_VSINH : SBI_PMU_CFG_FL=
AG_SET_SINH;
> +	if (event->attr.exclude_user)
> +		cflags |=3D guest_events ? SBI_PMU_CFG_FLAG_SET_VUINH : SBI_PMU_CFG_FL=
AG_SET_UINH;
> +	if (guest_events && event->attr.exclude_hv)
> +		cflags |=3D SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_host)
> +		cflags |=3D SBI_PMU_CFG_FLAG_SET_UINH | SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_guest)
> +		cflags |=3D SBI_PMU_CFG_FLAG_SET_VSINH | SBI_PMU_CFG_FLAG_SET_VUINH;
> +
> +	return cflags;
> +}
> +
>  static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc =3D &event->hw;
> @@ -308,11 +329,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *ev=
ent)
>  	uint64_t cbase =3D 0;
>  	unsigned long cflags =3D 0;
> =20
> -	if (event->attr.exclude_kernel)
> -		cflags |=3D SBI_PMU_CFG_FLAG_SET_SINH;
> -	if (event->attr.exclude_user)
> -		cflags |=3D SBI_PMU_CFG_FLAG_SET_UINH;
> -
> +	cflags =3D pmu_sbi_get_filter_flags(event);
>  	/* retrieve the available counter index */
>  #if defined(CONFIG_32BIT)
>  	ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pm=
u.h
> index a1c3f77..1c42146 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -26,6 +26,8 @@
> =20
>  #define RISCV_PMU_STOP_FLAG_RESET 1
> =20
> +#define RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS 0x1
> +
>  struct cpu_hw_events {
>  	/* currently enabled events */
>  	int			n_events;
> --=20
> 2.25.1
>=20
>=20

--Kh96vCh7mb1vJCOA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY5uA5wAKCRB4tDGHoIJi
0pnAAP9279BG2bKNaby4m7HVZ0iqkvu0RtJ6SIQ0JPGpdv+p1QEAtd4qbzkPg3u6
Mw7SPMVU7YEk3w/xjU2fqUVQ1eTkxQU=
=A5xN
-----END PGP SIGNATURE-----

--Kh96vCh7mb1vJCOA--
