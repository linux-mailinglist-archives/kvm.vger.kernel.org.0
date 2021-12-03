Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C6467402
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 10:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351403AbhLCJaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 04:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbhLCJaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 04:30:05 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14754C06173E
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 01:26:42 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d9so4390602wrw.4
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 01:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k6aucabibQqs2VrbmkeB/1vOT7V/HEk3VUT4PvkHOkw=;
        b=FPuSCHw/zT6DJ0lhv7IoQXSVjI5n+H98+64+3h0S0ETjcsLeTbBlxrKrVTXZcHtIKU
         +4cCG0RZhG1yDMw4enjgsXixDYVQPcome7basTqRLhzwXUOzKC5ZcRuqQIduHvcQYxP8
         lMfeT4/zGRxb886vviKIa5Io6oXe/zbPUAs2/zqDowc5btiuJcKO4vpe6dfDlv46N71E
         FfoIcCo04Gqoyeb7wENRNbgujGZlOS4zF8m9Ry8qkKFu+h5e1nvy/h2rJfYMhQA+ZY3a
         bNefbqHXybE8y4qdmi1ygAYDcAtfJfZeDjQyjSHP3Y5jwm7gzss/5lmzdV49TOSkfLwE
         Bz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k6aucabibQqs2VrbmkeB/1vOT7V/HEk3VUT4PvkHOkw=;
        b=QHNLP+MOXLWzYMgxd9uV91bH67mwunyza5R+zRmxAGasS9xwWr6anWieROyn/ic4Py
         LdH1xI3DS8/o/xLrekTj5unuvjJ0Z0sRBxLMjUEvhIFU/PFoDaLKXAcJRAubkAE0hkBV
         CRvHiLqw0zpLPof/p/MsvF+ykTOgwdcn6qX3FiCPCxC76u5a5sqRrDCHcaJlBEl3Btnb
         10/kfh9VlbOqkC/8xAA/CTzEgfUwyvltA+SA0SSDUuDA38WyreFTicmSvnjjAk5EiIR/
         4qB+aiiU5FBE3CGQIPXnl1MeWjAAJ/YJsHyCHRDYYss0HgeSp4D002GfobPa7uYicLHK
         ugvg==
X-Gm-Message-State: AOAM531ph2JvbeKY/BOpaZn2FTgkzsR2bQKZjrY5JebHIAgSuo/zCstw
        yBpqPfSHgVRBaV2vOci0h/O5y3PSeDygyX7IPjpWdA==
X-Google-Smtp-Source: ABdhPJwUeNYaQU0w36sYC1UvpvhS+E+TnHxnjMCeQd2b4IcpfLtfyx8p2foRJeQJ/SPFuKvw8bGXIC1MssFG+bhn0E0=
X-Received: by 2002:a5d:650f:: with SMTP id x15mr20299919wru.201.1638523600380;
 Fri, 03 Dec 2021 01:26:40 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-10-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-10-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 14:56:28 +0530
Message-ID: <CAAhSdy2iy6caF3DLqvo=xpYst=QV4bSjTQjU0ZktV88Ez-QqPA@mail.gmail.com>
Subject: Re: [PATCH v1 09/12] target/riscv: Add host cpu type
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        libvir-list@redhat.com, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> 'host' type cpu is set isa to RV32 or RV64 simply, more isa info
> will obtain from KVM in kvm_arch_init_vcpu()
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/cpu.c | 15 +++++++++++++++
>  target/riscv/cpu.h |  1 +
>  2 files changed, 16 insertions(+)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index a464845c99..6512182c62 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -247,6 +247,18 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
>  }
>  #endif
>
> +#if defined(CONFIG_KVM)
> +static void riscv_host_cpu_init(Object *obj)
> +{
> +    CPURISCVState *env = &RISCV_CPU(obj)->env;
> +#if defined(TARGET_RISCV32)
> +    set_misa(env, MXL_RV32, 0);
> +#elif defined(TARGET_RISCV64)
> +    set_misa(env, MXL_RV64, 0);
> +#endif
> +}
> +#endif
> +
>  static ObjectClass *riscv_cpu_class_by_name(const char *cpu_model)
>  {
>      ObjectClass *oc;
> @@ -844,6 +856,9 @@ static const TypeInfo riscv_cpu_type_infos[] = {
>          .class_init = riscv_cpu_class_init,
>      },
>      DEFINE_CPU(TYPE_RISCV_CPU_ANY,              riscv_any_cpu_init),
> +#if defined(CONFIG_KVM)
> +    DEFINE_CPU(TYPE_RISCV_CPU_HOST,             riscv_host_cpu_init),
> +#endif
>  #if defined(TARGET_RISCV32)
>      DEFINE_CPU(TYPE_RISCV_CPU_BASE32,           rv32_base_cpu_init),
>      DEFINE_CPU(TYPE_RISCV_CPU_IBEX,             rv32_ibex_cpu_init),
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 2807eb1bcb..e7dba35acb 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -45,6 +45,7 @@
>  #define TYPE_RISCV_CPU_SIFIVE_E51       RISCV_CPU_TYPE_NAME("sifive-e51")
>  #define TYPE_RISCV_CPU_SIFIVE_U34       RISCV_CPU_TYPE_NAME("sifive-u34")
>  #define TYPE_RISCV_CPU_SIFIVE_U54       RISCV_CPU_TYPE_NAME("sifive-u54")
> +#define TYPE_RISCV_CPU_HOST             RISCV_CPU_TYPE_NAME("host")
>
>  #if defined(TARGET_RISCV32)
>  # define TYPE_RISCV_CPU_BASE            TYPE_RISCV_CPU_BASE32
> --
> 2.19.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
