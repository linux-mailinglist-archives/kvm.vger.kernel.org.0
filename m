Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9442D3629
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgLHWXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730393AbgLHWXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:23:02 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA1BC0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:22:21 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id c18so9592151iln.10
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZi46PwDTCiNBxYN28eeYZtMufiT2lSdKRPtnPp2uBA=;
        b=NgF2ekg1k+9cO6s6Cj4qgZNZwesh5RVJ+yitVQ53jq9S4JnMEY1fAvKafFG6f2OP63
         zken1A5kvTmK+Ez35UygQMQPvHbemFUpT0ogHeO6SrlEx0oveiKGAuYzY5ief4uI0DYr
         l0b729ZZqdOLrpC5gNI8L9fNUIg2kRM64RAn5lVuoKy8b7qQk0bQZncY/OBhrgY+vugd
         GWW7TGAeH7rOxn7AnXSO+3pJhxvgGpdykrXBCI/+1xRQ1o5DF+2mlN8N30S1lPxedGJ9
         JG2Ct20Jr7ZdERUodYOTo8239xhBa1+Qpi7Xe9dngL2NSXPkZp45OdAj/cdyP6dnA3gO
         BBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZi46PwDTCiNBxYN28eeYZtMufiT2lSdKRPtnPp2uBA=;
        b=QRUrSUVc4h3E2LXM9Ute8hDp+eADFBkDHYLivGzXc8twaSDS75OjDza7RlvOtOj9GE
         MhhSpzXzXc5aMwedRjzqJywabOnj+27uXRYm+DyfLOdPix9u4vJMYY0xPUNGqddmh5fE
         IP6hXsF8fMVU0bu3gHLHz/zOEePHrfdW4UGfqy9m04zDQE0X0kFlDwGF1Y2tetCq7mq+
         idSrmtwNDMR4ZhJLPAAuOAs7L2+DIV3YfcDECDj0x4bQKMCzqQiacabkKHQWIHL5dvTo
         j+BgghLS6FYPPFJE6JUIsUk+eNk4HRo5OPsprU61m/8dvbwMtwJe4JaesxPBwPtOI9Tc
         or+g==
X-Gm-Message-State: AOAM531/ZEA5Z2Zuc6xzarnP0ceYfQJ4mX7mTTMbC1y7zeV0WSzs/H3M
        YTU7ET6c8+CpxPxSth5VnyVxWPo1MzkVit4cRLU=
X-Google-Smtp-Source: ABdhPJzhK+ClKrZDoSlIkxZpVfST+Oc77Aa3SIyIhTTwL7rDp0p10RRz2lBvAiWVB5rWGydt52vrwgvJbbDyIX/y0cA=
X-Received: by 2002:a92:490d:: with SMTP id w13mr12021ila.227.1607466141348;
 Tue, 08 Dec 2020 14:22:21 -0800 (PST)
MIME-Version: 1.0
References: <20201203124703.168-1-jiangyifei@huawei.com> <20201203124703.168-10-jiangyifei@huawei.com>
In-Reply-To: <20201203124703.168-10-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 8 Dec 2020 14:21:55 -0800
Message-ID: <CAKmqyKMDWzBf29MgG7BsGTmweH7ZCRVqwCCqC620QoO776=cww@mail.gmail.com>
Subject: Re: [PATCH RFC v4 09/15] target/riscv: Add host cpu type
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 3, 2020 at 4:55 AM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Currently, host cpu is inherited simply.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  target/riscv/cpu.c | 6 ++++++
>  target/riscv/cpu.h | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index faee98a58c..439dc89ee7 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -186,6 +186,10 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
>
>  #endif
>
> +static void riscv_host_cpu_init(Object *obj)
> +{
> +}
> +
>  static ObjectClass *riscv_cpu_class_by_name(const char *cpu_model)
>  {
>      ObjectClass *oc;
> @@ -641,10 +645,12 @@ static const TypeInfo riscv_cpu_type_infos[] = {
>      DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E31,       rvxx_sifive_e_cpu_init),
>      DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E34,       rv32_imafcu_nommu_cpu_init),
>      DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U34,       rvxx_sifive_u_cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_HOST,             riscv_host_cpu_init),
>  #elif defined(TARGET_RISCV64)
>      DEFINE_CPU(TYPE_RISCV_CPU_BASE64,           riscv_base_cpu_init),
>      DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E51,       rvxx_sifive_e_cpu_init),
>      DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U54,       rvxx_sifive_u_cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_HOST,             riscv_host_cpu_init),

Shouldn't this only be included if KVM is configured? Also it should
be shared between RV32 and RV64.

Alistair

>  #endif
>  };
>
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index ad1c90f798..4288898019 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -43,6 +43,7 @@
>  #define TYPE_RISCV_CPU_SIFIVE_E51       RISCV_CPU_TYPE_NAME("sifive-e51")
>  #define TYPE_RISCV_CPU_SIFIVE_U34       RISCV_CPU_TYPE_NAME("sifive-u34")
>  #define TYPE_RISCV_CPU_SIFIVE_U54       RISCV_CPU_TYPE_NAME("sifive-u54")
> +#define TYPE_RISCV_CPU_HOST             RISCV_CPU_TYPE_NAME("host")
>
>  #define RV32 ((target_ulong)1 << (TARGET_LONG_BITS - 2))
>  #define RV64 ((target_ulong)2 << (TARGET_LONG_BITS - 2))
> --
> 2.19.1
>
>
