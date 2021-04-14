Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EFF35FDE2
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 00:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhDNWes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 18:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbhDNWek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 18:34:40 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BCDC061574
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:34:17 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id d2so18487359ilm.10
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CI8Z/F5S582NuvrtPVvFNRH8BngEDJ7CgRUXykPNP6Y=;
        b=OAjusVNtJp44MuoIj11Gd4CxZDVcf4G6GZFOeCVgdmRydnublD7l3xV1rbIctwhxtq
         4+49mPnwcpSsCdoOBZ4fm2hUPFRXa4VwXhIxwEJTvf9p3+0R4pqoLxclwsghM/AwdlU/
         bYsoz0oe9Vg9YPqkytJMPavURoVTSlT1oECcfu4r5DtjpyHs/7U2zuK48fsQBHjUUD+n
         8tqnTFmxIiWJc/BB7tMgZNwM9ZNJkO1doNryxyIYvzyu89IUm03d7rBr6+d0pbFaeAWo
         UmcxusTzPet+8kDY/x6t+/uynw2as2V3+2LUicukVjENXxJECC/OdiSnNXiFJlgEN6pR
         h5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CI8Z/F5S582NuvrtPVvFNRH8BngEDJ7CgRUXykPNP6Y=;
        b=U6QjqrauKtWvh5bOPBPS9CCd3mfovjCmfljZp31PEY2mFH9AvgXgiOXgOvuQdS6WGk
         DJkkENLaB5/wAvCcN/JI3HemJLxEaOJoL1BxH3klARg4LH6gl0P8SBS/F6oN4h4HcvDe
         ULSH/vGCBAvbEuX+JbXlWsI/679ph6XKpvBAtgSmS26qneXgJRqXz1amM/kHUDfUoA6O
         5U00Mjy1V3iRGTOrVd/fONIvb/5XT3ICuj/wBD/tAk5l3yyR3frGTDrxQ4W44iGPVGpl
         gvJ+KSb+h+zmQ2uArrHMIKysNaCrla4eyBDwdBQ1vOx1qIfUm+DN5sbHpWwc6b4ThFOC
         wXKw==
X-Gm-Message-State: AOAM530j6U0ogldkp7RN+agjqn1rEskq3GP3Vv6/qRvsFIBAumC1ExXx
        SDV2Y4NRudu1v1nXRc+svYhO1qx1iPS9noZggRU=
X-Google-Smtp-Source: ABdhPJw7nVEWEpyQ3LlY/WJBHngQI5dgV+H5R7KpDVhY5wrYQ7aDnJU/AFTQru82dlQNnN0oQJZdZKvDxJQ8F6AtlvU=
X-Received: by 2002:a05:6e02:5a2:: with SMTP id k2mr409747ils.177.1618439656765;
 Wed, 14 Apr 2021 15:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065246.1853-1-jiangyifei@huawei.com> <20210412065246.1853-10-jiangyifei@huawei.com>
In-Reply-To: <20210412065246.1853-10-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 15 Apr 2021 08:33:50 +1000
Message-ID: <CAKmqyKPgfpEJYN0xTKRiD4Wk62-nu5pB=Ad1Z_NZasTrbXXrZg@mail.gmail.com>
Subject: Re: [PATCH RFC v5 09/12] target/riscv: Add host cpu type
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Bin Meng <bin.meng@windriver.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        fanliang@huawei.com, "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 4:54 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> 'host' type cpu is set isa to RVXLEN simply, more isa info
> will obtain from KVM in kvm_arch_init_vcpu()
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/cpu.c | 9 +++++++++
>  target/riscv/cpu.h | 1 +
>  2 files changed, 10 insertions(+)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index dd34ab4978..8132d35a92 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -216,6 +216,12 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
>  }
>  #endif
>
> +static void riscv_host_cpu_init(Object *obj)
> +{
> +    CPURISCVState *env = &RISCV_CPU(obj)->env;
> +    set_misa(env, RVXLEN);
> +}
> +
>  static ObjectClass *riscv_cpu_class_by_name(const char *cpu_model)
>  {
>      ObjectClass *oc;
> @@ -706,6 +712,9 @@ static const TypeInfo riscv_cpu_type_infos[] = {
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
> index a489d94187..3ca3dad341 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -43,6 +43,7 @@
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
