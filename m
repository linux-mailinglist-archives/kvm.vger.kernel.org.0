Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FAA35FDCF
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 00:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhDNWdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 18:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhDNWdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 18:33:00 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC82C061574
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:32:36 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a9so11401066ioc.8
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DnWpmyuBcVLMh+o254nNZjs/ViGAgPIT2BWu82a9qds=;
        b=VBQkmczcFZIy8vNoASuNLjaR7Mqq4uAMvQbmVI31prjpKqnoQ8DYYWS/Vr64FewoaJ
         t+5Z8Vez2c/GrpehDiF/LLnGO3ELLsNVQDb8JmfBoO5DZ38ECyWeAFHhkde39wCh1dAV
         8KFjbXmGMdDMMWu8b6fIseMYcUJyTpPnzuXdfZI8bBiEJUp5EnsCaSzRonsSp34GSTFt
         cGOjTskLLPCkEeZ91Vqyq0es38h+7I2VVq6+ZICZXMXFtp2+ZfJt55x1yl6tlqS2BiRw
         COmM3IEw/1lV4CpM9RR+oeBMxF+so8nr2YMSAg5tmBdAwYVKUDDvIY7eXfHoYLeOYAFt
         M2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DnWpmyuBcVLMh+o254nNZjs/ViGAgPIT2BWu82a9qds=;
        b=OVz+wsIbajbjT8Smh3A7fH3z33z2F26reCyI3qgmJScOaUuTUQp8Q6+A4JjCXSIqUS
         CiNc0BnRb+FGtmawg1PKjx/Y2+CsL3P2q4nXDbraxs69MRF6+q3jnSI/4YouZ8MZZdbw
         Ow8/FFkaT/OuE1dNxdDOHtba7fp59AhDk6UvnQH6Ke4g1uDavISgiPW9XjnPg1PtST2R
         630m4qVQAJaW4Dsz4l3KYx5txO6jqwXoI5R7yG7F6CBdaUCHJb5zykds44M+XAl/qdrX
         3eOAU8nZUmBQDUudVIIDvitBxlURjH1TJt5BCrUoE/1n6VTFqJ5z9SicDagtnQdk7zCm
         KViw==
X-Gm-Message-State: AOAM531+f6rg4Kfw0KCiHdckCgwuuvPkBxIAsZewpLQrqi4OY/Bs/V9l
        UvMXchipUVnWy00NZOJ1vKGjF9jZxavA3D5H0H0=
X-Google-Smtp-Source: ABdhPJzlHwyWvinrhm2Yv5H+jUvhG4+4quL/QYdBBVc8w8nMH9ycirhBlndVFnE//9LtCOb91HnQ1eLdgxpG+hRYNFc=
X-Received: by 2002:a05:6638:1211:: with SMTP id n17mr198838jas.26.1618439556144;
 Wed, 14 Apr 2021 15:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065246.1853-1-jiangyifei@huawei.com> <20210412065246.1853-4-jiangyifei@huawei.com>
In-Reply-To: <20210412065246.1853-4-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 15 Apr 2021 08:32:09 +1000
Message-ID: <CAKmqyKN-eiDw3Ufo1QyLg5ELP-JY+aq3Bi1cPJVf8gQtsu+qkw@mail.gmail.com>
Subject: Re: [PATCH RFC v5 03/12] target/riscv: Implement function kvm_arch_init_vcpu
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

On Mon, Apr 12, 2021 at 4:53 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
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
> index 687dd4b621..0d924be33f 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -38,6 +38,18 @@
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>
> +static __u64 kvm_riscv_reg_id(CPURISCVState *env, __u64 type, __u64 idx)
> +{
> +    __u64 id = KVM_REG_RISCV | type | idx;

Can you use uint64_t instead of __u64?

Once that is fixed:

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> +
> +    if (riscv_cpu_is_32bit(env)) {
> +        id |= KVM_REG_SIZE_U32;
> +    } else {
> +        id |= KVM_REG_SIZE_U64;
> +    }
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
> +    id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
> +    ret = kvm_get_one_reg(cs, id, &isa);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->misa = isa | RVXLEN;
> +
> +    return ret;
>  }
>
>  int kvm_arch_msi_data_to_gsi(uint32_t data)
> --
> 2.19.1
>
>
