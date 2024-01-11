Return-Path: <kvm+bounces-6115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0124282B80C
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 00:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B07A1F264C2
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 23:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F955A0E8;
	Thu, 11 Jan 2024 23:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxjappVJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38465A0E1
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 23:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-dae7cc31151so4694943276.3
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 15:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705015783; x=1705620583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=du1IavJIWBdDP20xh4ONlQiRPjaJ1D2XqOF3jy6wAQc=;
        b=PxjappVJG3nTn0E8uB9l+dJQdL21JAgqlRGH75DvquWDqr8DG/mYkHNjRTGO3lWB4m
         UUhs9cAzZ/sbh0VPnCObjj2rspevRwNal/947ykqUiPvem42LiA/ptiuOk6phcPKNb7K
         M7LOucuKVNJHv13ptfPOtzthSvsAzCbuYK2GE2E/4Mih2JaxUr4AH/p4hXHulBGgMKeh
         3S4oHhMrzl6KUIvfDu6cry0inyycz/ehml5I3YrmSD8zfyGrm15A2CjoACF6DtxNCz8G
         6UaFp5D7h8sGJ9LhePacGIv1B/xUNyHlNDctOvL2CWcy0m4Nlt9iBED/K4ODDEsflnxp
         D85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705015783; x=1705620583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=du1IavJIWBdDP20xh4ONlQiRPjaJ1D2XqOF3jy6wAQc=;
        b=gAFVZOh28OVNqXM12vpI0pQ4Zgzb3mnN5XFg0ewwN5G4I/8dAxJaxUzKUL/3sK1qf1
         IEuQigzU5eLtMxnidryOYXRhtL30S7Qc29MekWLYXFHpcFvOVpik52W0Fv1mUIusWtRu
         2rrPkaxaHvFvL0ivgMeHOcr4NVFfBnRjIKBI8beQ7Fl7PiPZqRXtzg9BwZfz6M2xA0Ja
         sMOTPLDixsGyQTBEfF1kjP74S8WcXRazvqqBhYse7nKkgd2IgxYygpXkzO9Fi1F0nx3I
         NmRBalbrs+BvLNV+aMVOXLGgNz+RsKiP48zr0wIppachaphyFuYg2fPVnRlHtxLqfAAl
         UZbw==
X-Gm-Message-State: AOJu0YzKv1vU3iVR6qZ1h3xdg2NnKVBRIXxeGC2VS1k0ULS2xMVFosoN
	DuyXiQ0LIZrQJH/Nr4rlAXYP5yg7iCM2dXQ9n/0=
X-Google-Smtp-Source: AGHT+IHBbOhzbyunGMknfXiMMQitbHDlBWritE8c6YY3dLnEUY/sdXf9eyO4l64E/4J5cTd0z270xybVnE8JxuI3mU4=
X-Received: by 2002:a25:dccf:0:b0:dbc:b48e:6426 with SMTP id
 y198-20020a25dccf000000b00dbcb48e6426mr2837ybe.110.1705015783478; Thu, 11 Jan
 2024 15:29:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103173349.398526-1-alex.bennee@linaro.org> <20240103173349.398526-26-alex.bennee@linaro.org>
In-Reply-To: <20240103173349.398526-26-alex.bennee@linaro.org>
From: Alistair Francis <alistair23@gmail.com>
Date: Fri, 12 Jan 2024 09:29:17 +1000
Message-ID: <CAKmqyKMLTLw37HzHhEdmQdd+WRYs603jm7w30k5HLNmZNYGacA@mail.gmail.com>
Subject: Re: [PATCH v2 25/43] target/riscv: Validate misa_mxl_max only once
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Song Gao <gaosong@loongson.cn>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Yanan Wang <wangyanan55@huawei.com>, 
	Bin Meng <bin.meng@windriver.com>, Laurent Vivier <lvivier@redhat.com>, 
	Michael Rolnik <mrolnik@gmail.com>, Alexandre Iooss <erdnaxe@crans.org>, 
	David Woodhouse <dwmw2@infradead.org>, Laurent Vivier <laurent@vivier.eu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Brian Cain <bcain@quicinc.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>, 
	Mahmoud Mandour <ma.mandourr@gmail.com>, Thomas Huth <thuth@redhat.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, Weiwei Li <liwei1518@gmail.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	John Snow <jsnow@redhat.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-riscv@nongnu.org, 
	Alistair Francis <alistair.francis@wdc.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 5:04=E2=80=AFAM Alex Benn=C3=A9e <alex.bennee@linaro=
.org> wrote:
>
> From: Akihiko Odaki <akihiko.odaki@daynix.com>
>
> misa_mxl_max is now a class member and initialized only once for each
> class. This also moves the initialization of gdb_core_xml_file which
> will be referenced before realization in the future.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Message-Id: <20231213-riscv-v7-4-a760156a337f@daynix.com>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

Acked-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/cpu.c         | 21 +++++++++++++++++++++
>  target/riscv/tcg/tcg-cpu.c | 23 -----------------------
>  2 files changed, 21 insertions(+), 23 deletions(-)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 2ab61df2217..b799f133604 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -1247,6 +1247,26 @@ static const MISAExtInfo misa_ext_info_arr[] =3D {
>      MISA_EXT_INFO(RVG, "g", "General purpose (IMAFD_Zicsr_Zifencei)"),
>  };
>
> +static void riscv_cpu_validate_misa_mxl(RISCVCPUClass *mcc)
> +{
> +    CPUClass *cc =3D CPU_CLASS(mcc);
> +
> +    /* Validate that MISA_MXL is set properly. */
> +    switch (mcc->misa_mxl_max) {
> +#ifdef TARGET_RISCV64
> +    case MXL_RV64:
> +    case MXL_RV128:
> +        cc->gdb_core_xml_file =3D "riscv-64bit-cpu.xml";
> +        break;
> +#endif
> +    case MXL_RV32:
> +        cc->gdb_core_xml_file =3D "riscv-32bit-cpu.xml";
> +        break;
> +    default:
> +        g_assert_not_reached();
> +    }
> +}
> +
>  static int riscv_validate_misa_info_idx(uint32_t bit)
>  {
>      int idx;
> @@ -1695,6 +1715,7 @@ static void riscv_cpu_class_init(ObjectClass *c, vo=
id *data)
>      RISCVCPUClass *mcc =3D RISCV_CPU_CLASS(c);
>
>      mcc->misa_mxl_max =3D (uint32_t)(uintptr_t)data;
> +    riscv_cpu_validate_misa_mxl(mcc);
>  }
>
>  static void riscv_isa_string_ext(RISCVCPU *cpu, char **isa_str,
> diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
> index 7f6712c81a4..eb243e011ca 100644
> --- a/target/riscv/tcg/tcg-cpu.c
> +++ b/target/riscv/tcg/tcg-cpu.c
> @@ -148,27 +148,6 @@ static void riscv_cpu_validate_misa_priv(CPURISCVSta=
te *env, Error **errp)
>      }
>  }
>
> -static void riscv_cpu_validate_misa_mxl(RISCVCPU *cpu)
> -{
> -    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cpu);
> -    CPUClass *cc =3D CPU_CLASS(mcc);
> -
> -    /* Validate that MISA_MXL is set properly. */
> -    switch (mcc->misa_mxl_max) {
> -#ifdef TARGET_RISCV64
> -    case MXL_RV64:
> -    case MXL_RV128:
> -        cc->gdb_core_xml_file =3D "riscv-64bit-cpu.xml";
> -        break;
> -#endif
> -    case MXL_RV32:
> -        cc->gdb_core_xml_file =3D "riscv-32bit-cpu.xml";
> -        break;
> -    default:
> -        g_assert_not_reached();
> -    }
> -}
> -
>  static void riscv_cpu_validate_priv_spec(RISCVCPU *cpu, Error **errp)
>  {
>      CPURISCVState *env =3D &cpu->env;
> @@ -676,8 +655,6 @@ static bool tcg_cpu_realize(CPUState *cs, Error **err=
p)
>          return false;
>      }
>
> -    riscv_cpu_validate_misa_mxl(cpu);
> -
>  #ifndef CONFIG_USER_ONLY
>      CPURISCVState *env =3D &cpu->env;
>      Error *local_err =3D NULL;
> --
> 2.39.2
>
>

