Return-Path: <kvm+bounces-4477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AEE81302F
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7F4B28206B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43324AF84;
	Thu, 14 Dec 2023 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="rTUdyDnx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7B8118
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:32:31 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-5cd54e5fbb2so69377a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702557151; x=1703161951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHs0a9X4fElRxkh1m4Obf7cu50BAmw2Tug+rwqngNXM=;
        b=rTUdyDnx0uZyyMLdBq/39Sz/gjFVrGgpyKLlpYbesZsJXm5qekReLG1fkuAZqUCJxF
         GJcLI0hl2daTeRGAuY+hjKGgdaF6LaAOoo5WEQU2OXNCFLLam8F4IfFricyUnwirJ6JB
         uVJrQTwnrn5NDXkcvqnkU2QPAPwvRffrTEZdS2RDIvhSsVyq/8D0S1YEfZIKJprABZ/m
         zVqvH4wLBJ1Q6UlCt6SCTKN+QS2nrz9BzKEe2FAt3P4qHOrLAsvtW6Q9m9uteXrm2zvi
         EPF8Q/sNe/RT45dXjJyNhBoctCXiO8U3qSVG0jn5sXLTJxM4RqXAMJQXUdK5i98LnyU5
         WSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702557151; x=1703161951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHs0a9X4fElRxkh1m4Obf7cu50BAmw2Tug+rwqngNXM=;
        b=C2ZWHqjB/oeJwwQKhBdTvECvo58PhvawotzUDaHGPkguqYB1gf9MCGioUr/nWz6SlR
         56c/r7OrTUPH9q4vIp2EwYNzlaOmXgGs6hnOhkO9N50RJNVwuwQsK7JDok6bcNlGAAUD
         Rj9poNDLUINAVXTgfyqUEp0tccWAhyiAXK8hOO669d7bxDePPOW7YCmK0OMtR0UiHvVN
         nwtgXrdzMIH9u14k2U1boT/u2wABkLo8VozCwV87OWi1RlrFhKQhBJVqzwb01cD0/Hd6
         Ll0G3nUSEW12wIqp8KK3NhbBEDgpVAQJXIG2UoOxc/bvNxpplRrys+E8C0Ovj24RUB47
         OSiA==
X-Gm-Message-State: AOJu0YzhkmERF6J/9pIN/EA2M82nb2Ywmo30HIlcpsuPWI6V9ci1o1JG
	Vp0AyHPVONo9aJqBvXBpXV7JpDR5yXeQX1HPhj92HQ==
X-Google-Smtp-Source: AGHT+IHtJNIxrFwRTRE/bqbHJp34NVZj1ThA00NgG2O+fluhMv9I0JgSLSsCVqYFeOP3WU22OtYuCLxxss5Y01LGpik=
X-Received: by 2002:a17:90a:de94:b0:28b:1fbd:27de with SMTP id
 n20-20020a17090ade9400b0028b1fbd27demr4566pjv.29.1702557151290; Thu, 14 Dec
 2023 04:32:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-6-atishp@rivosinc.com>
In-Reply-To: <20231205024310.1593100-6-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 18:02:19 +0530
Message-ID: <CAAhSdy1L6smTUtjO1XJp2L=EfK-jYN9CS70h9nNa639ownKJBg@mail.gmail.com>
Subject: Re: [RFC 5/9] RISC-V: Add SBI PMU snapshot definitions
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> SBI PMU Snapshot function optimizes the number of traps to
> higher privilege mode by leveraging a shared memory between the S/VS-mode
> and the M/HS mode. Add the definitions for that extension
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/sbi.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index f3eeca79a02d..29821addb9b7 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -122,6 +122,7 @@ enum sbi_ext_pmu_fid {
>         SBI_EXT_PMU_COUNTER_STOP,
>         SBI_EXT_PMU_COUNTER_FW_READ,
>         SBI_EXT_PMU_COUNTER_FW_READ_HI,
> +       SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
>  };
>
>  union sbi_pmu_ctr_info {
> @@ -138,6 +139,13 @@ union sbi_pmu_ctr_info {
>         };
>  };
>
> +/* Data structure to contain the pmu snapshot data */
> +struct riscv_pmu_snapshot_data {
> +       uint64_t ctr_overflow_mask;
> +       uint64_t ctr_values[64];
> +       uint64_t reserved[447];
> +};
> +
>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
>
> @@ -234,9 +242,11 @@ enum sbi_pmu_ctr_type {
>
>  /* Flags defined for counter start function */
>  #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
> +#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT (1 << 1)
>
>  /* Flags defined for counter stop function */
>  #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
> +#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT (1 << 1)
>
>  enum sbi_ext_dbcn_fid {
>         SBI_EXT_DBCN_CONSOLE_WRITE =3D 0,
> --
> 2.34.1
>

