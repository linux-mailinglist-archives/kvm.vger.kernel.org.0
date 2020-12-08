Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BACD2D3612
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgLHWPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbgLHWPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:15:03 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1685C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:14:22 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id z5so63250iob.11
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDhpagymtzefWB/r5VG7ra2ZItwjDxoOaj88vM8lSpI=;
        b=adGqN+ZpghBajeFeRhtFx0ax7BS/LkHFIdwKeAM/RHXsWoXGNnUz8ZGllSSV+vCDgl
         6/9giI894+si87qHAT4cCqwIOhk5+8FduLyNNVwvZ0OJh1iIXMF+w6CPil5i0wm33U1z
         wz1oGKfNzC60mb6ynMq12+Px24H146uiAgNetslNE3nJ5YZLgacM5Epdr7zMqN2dnnY0
         J0Zc4nnrnJyl9XukXY7KEYbpdT90UhiO36Y36TLdBJZpQyfu6mOEhRRf3+f3vg1PQziY
         ERKib6Zjvg189Z/Kp50um5pxo7Nm2Pg7EVT5cBxkwVjlw8SSf4yTD6HglUdXc5g6KFGd
         x0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDhpagymtzefWB/r5VG7ra2ZItwjDxoOaj88vM8lSpI=;
        b=SkGeaB+ypebnnu7wp6mKZKZMXmhjnuHd8ieEw/i/rChIVVGP3FaHXtp+aTzn8C/iRQ
         q7QVA7gzxNn0nsEa5pk65WxLTDymAuLPFeS7RXBylChwpHRhgtNFblTwsSxsnF3+SDR6
         l1NA3yFwJAQJ07Cf3fKlO7OT7B5PryQIucmF2CqI3zfKrv0VD6csSeJKLE1vG+yZjrVJ
         yvm341C7iavb+msOfbv5WW1baoh8tVhsq0bw8CwlX43esfBGXopM2uOurCVUOwPyJDvo
         oiyt5176Ug4vncoX/f3I+Oh7x/S+ClHAZeBEBYQr4BGOuDosJZx3vUGMq2jwlcM4D8bd
         fe5w==
X-Gm-Message-State: AOAM53101cZrYMWLc4YpFejKlB5OxSLQaUNnfupPq1soX3t7beJ30i3F
        EpDZ/F8hfWDzrTo09dLNnFDCZlQNV4CxS/RVCJw=
X-Google-Smtp-Source: ABdhPJxaoNHS+3cxjoivZFinPoi/B19lNAFgA0xdURtMwzg4Zm45evCCCE49Hz9dImEMzTZCna0lA1oW/PQKBc9OqpI=
X-Received: by 2002:a02:5148:: with SMTP id s69mr29004326jaa.8.1607465662194;
 Tue, 08 Dec 2020 14:14:22 -0800 (PST)
MIME-Version: 1.0
References: <20201203124703.168-1-jiangyifei@huawei.com> <20201203124703.168-4-jiangyifei@huawei.com>
In-Reply-To: <20201203124703.168-4-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 8 Dec 2020 14:13:56 -0800
Message-ID: <CAKmqyKNE1JU3KJscNfg78dGW9Avs2nvTVt-qr417g5noTbCAYQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 03/15] target/riscv: Implement function kvm_arch_init_vcpu
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
> Get isa info from kvm while kvm init.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  target/riscv/kvm.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 8c386d9acf..86660ba81b 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -38,6 +38,18 @@
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>
> +static __u64 kvm_riscv_reg_id(__u64 type, __u64 idx)
> +{
> +    __u64 id = KVM_REG_RISCV | type | idx;
> +
> +#if defined(TARGET_RISCV32)
> +    id |= KVM_REG_SIZE_U32;
> +#elif defined(TARGET_RISCV64)
> +    id |= KVM_REG_SIZE_U64;
> +#endif

There is a series on list (I'll send a v2 out later today) that starts
to remove these #ifdef for the RISC-V XLEN. Next time you rebase it
would be great if you can use that and hopefully remove this.

Alistair

> +    return id;
> +}
> +
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
>  };
> @@ -79,7 +91,20 @@ void kvm_arch_init_irq_routing(KVMState *s)
>
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
> -    return 0;
> +    int ret = 0;
> +    target_ulong isa;
> +    RISCVCPU *cpu = RISCV_CPU(cs);
> +    CPURISCVState *env = &cpu->env;
> +    __u64 id;
> +
> +    id = kvm_riscv_reg_id(KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
> +    ret = kvm_get_one_reg(cs, id, &isa);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->misa = isa;
> +
> +    return ret;
>  }
>
>  int kvm_arch_msi_data_to_gsi(uint32_t data)
> --
> 2.19.1
>
>
