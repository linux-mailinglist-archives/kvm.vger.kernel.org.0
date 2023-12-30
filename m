Return-Path: <kvm+bounces-5333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E158203F0
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 08:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 324071F21812
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 07:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F79023BB;
	Sat, 30 Dec 2023 07:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="YjTnz5vq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364291FCF
	for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 07:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bae735875bso253356939f.2
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 23:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1703922970; x=1704527770; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sMoecNT/vWFjebRTXppuzNrFLVfC8SMHVt9ayXTH6k=;
        b=YjTnz5vqYjXD9uWfhPY8YnkkRgzhDhN2y9d7vlQGRw7CHQMAf+O8Z+b7Kg/i69+yzH
         l4jZqBP3R+yUcrYNguRxR4IEq8E2T3rwvcqJqvbHW1hJgv86ltbemSEjuIuvIlnfO58V
         UGal3kIHvvScdZZ6LHsXy9nsSH/STUOFgwIIyeqgC7I0+OiWo5AhQv2CTVB4kYo/mZ5o
         tLZjKI6t3XR6kwP0yPajDo5Zsclu9Wt2TfaU00Xwd6OvaczPXWwLGex502t5Vi7RALIP
         bck+OJCQ5OfjlVoulo7gsTfMkCZfG8voNlMblPeFWlBNvyV7BCGB/V5oaEoh2QlOPUko
         3FTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703922970; x=1704527770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sMoecNT/vWFjebRTXppuzNrFLVfC8SMHVt9ayXTH6k=;
        b=gIQ4FZdRDkWgPTOf4anUyQ3B8G+c7SLFKPqG/N34uOJ0K2iXQ1MEy/qvDn4k5IhCSJ
         foSKva7jT3Zk6woxXR+absTLwEI67Zhs0tin9zilS8cbLZBwDroLxyiqzPXvsyWEOORb
         Yuzw6g6w5ttwD7rNpB6z6JqqJlbiPc91jXO7TB508UMDWnPNBXFcdnh5Xbs4C9h2OQTR
         xITWSXsPLuj9rZZoP+94b1GZCjEnX5AG02a7mnoL2KAlFYPBTCVMz5R8dIwoLQJu/vs0
         enQmEgoAZi6ShA7HIN2J10SycbuaVPWGS8W5+TDoK2YkXuol8BTYp+e2xBF8TapKzMQY
         5R4A==
X-Gm-Message-State: AOJu0Yx+R+m3KLk+0dwDIYoHAEcKk535wuEvrD8I/QAz34OHBBYY0vnR
	48xChcfbFP2mi2VMl3jDJ+FuHSCEBL4zxxeZ0Ue/Crlv73vFNw==
X-Google-Smtp-Source: AGHT+IGVmlE2QFQ0+dx8lrqZJ+DFVfKaIOwaq4FTrn+jPUMeUqrIhNxtpGBrKoQi6J3FUQbOs5JpKftu96beacssVUk=
X-Received: by 2002:a05:6e02:184b:b0:35f:f59d:f334 with SMTP id
 b11-20020a056e02184b00b0035ff59df334mr17011843ilv.35.1703922970107; Fri, 29
 Dec 2023 23:56:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229214950.4061381-1-atishp@rivosinc.com> <20231229214950.4061381-4-atishp@rivosinc.com>
In-Reply-To: <20231229214950.4061381-4-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Sat, 30 Dec 2023 13:25:59 +0530
Message-ID: <CAAhSdy3HgqPVCjnie-TtOC5uRWVXoZMRAKigvKK1+z0b7VHA2w@mail.gmail.com>
Subject: Re: [v2 03/10] drivers/perf: riscv: Read upper bits of a firmware counter
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 3:20=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> SBI v2.0 introduced a explicit function to read the upper 32 bits
> for any firmwar counter width that is longer than 32bits.
> This is only applicable for RV32 where firmware counter can be
> 64 bit.
>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 16acd4dcdb96..646604f8c0a5 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -35,6 +35,8 @@
>  PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:63");
>
> +static bool sbi_v2_available;
> +
>  static struct attribute *riscv_arch_formats_attr[] =3D {
>         &format_attr_event.attr,
>         &format_attr_firmware.attr,
> @@ -488,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *even=
t)
>         struct hw_perf_event *hwc =3D &event->hw;
>         int idx =3D hwc->idx;
>         struct sbiret ret;
> -       union sbi_pmu_ctr_info info;
>         u64 val =3D 0;
> +       union sbi_pmu_ctr_info info =3D pmu_ctr_list[idx];
>
>         if (pmu_sbi_is_fw_event(event)) {
>                 ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_REA=
D,
>                                 hwc->idx, 0, 0, 0, 0, 0);
> -               if (!ret.error)
> -                       val =3D ret.value;
> +               if (ret.error)
> +                       return val;
> +
> +               val =3D ret.value;
> +               if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.=
width >=3D 32) {
> +                       ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTE=
R_FW_READ_HI,
> +                                       hwc->idx, 0, 0, 0, 0, 0);
> +                       if (!ret.error)
> +                               val |=3D ((u64)ret.value << 32);
> +               }
>         } else {
> -               info =3D pmu_ctr_list[idx];
>                 val =3D riscv_pmu_ctr_read_csr(info.csr);
>                 if (IS_ENABLED(CONFIG_32BIT))
>                         val =3D ((u64)riscv_pmu_ctr_read_csr(info.csr + 0=
x80)) << 31 | val;
> @@ -1108,6 +1117,9 @@ static int __init pmu_sbi_devinit(void)
>                 return 0;
>         }
>
> +       if (sbi_spec_version >=3D sbi_mk_version(2, 0))
> +               sbi_v2_available =3D true;
> +
>         ret =3D cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
>                                       "perf/riscv/pmu:starting",
>                                       pmu_sbi_starting_cpu, pmu_sbi_dying=
_cpu);
> --
> 2.34.1
>

