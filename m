Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C9B7A3F9D
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 05:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbjIRDNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Sep 2023 23:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjIRDM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Sep 2023 23:12:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F6ADB;
        Sun, 17 Sep 2023 20:12:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4F5C433C8;
        Mon, 18 Sep 2023 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695006772;
        bh=lnOY0xyLXsdniuxIMbYGVdEslrwjw3uTjaBMiC3urDE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ep0SSpU+08z6i6K8t/64NWx0fOk4/GU2sBZubJA5X0uGYYwy3157BLPWefXkGg3zv
         CB0FsGqcLWkHuw+xSvy6Gvq7qYttdObV1qvDcgLKRlltKX92Yv5KL2HKA8RZoHcf9j
         Sfca8IEQDOF9FzqNawIPy6NJ64Fkd+b/7aGr/g46SR9LzUqwVsLXXqPgNfP79nfLvZ
         33GjR6tqP+7ksWoh7na78PxW4ACX+QtFuI+m8cu8peoQvKyGtn319prDMEmW2wjA25
         j/yCP/Y8T+xZA9BZuyhj3yEqVJq7lA6p1XB5xPPg/033xdlWR41/dhKgWmgmhIk0vH
         q7F3OWXjagBMg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50305abe5f0so2005998e87.2;
        Sun, 17 Sep 2023 20:12:52 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz6xVK+fM/l6myo/7FQeuvBj0DZHnpyYq4CIgYLKDN0Oha3D092
        1Fmd+h8Bmpk8P/2q2c0ybc+N5tjmFcSii1z+S6U=
X-Google-Smtp-Source: AGHT+IHOcRm8rwrglhNEcPfms0b/BsfriVEq7rzfApxRA+qQtGdkNzKFKFdjOmqOkmtMGik/RCm0pe98epfS+5g+x0U=
X-Received: by 2002:a05:6512:36c5:b0:500:7fc7:8521 with SMTP id
 e5-20020a05651236c500b005007fc78521mr6111840lfs.64.1695006770972; Sun, 17 Sep
 2023 20:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
 <20230915014949.1222777-3-zhaotianrui@loongson.cn> <CAAhV-H5ti7L+QXJ=boK8aKNwt74Pvn1-vm71B9Bymi+2zXXzHw@mail.gmail.com>
 <525aa9e2-1ebc-6c49-55ef-9f3c7d18d3e0@loongson.cn> <CAAhV-H7wB_N0nFm1JMhKJR=8NAuDR3XNC6NfeZis0VhDECAUjg@mail.gmail.com>
 <b11389ee-7740-7911-2e57-75edadade703@loongson.cn>
In-Reply-To: <b11389ee-7740-7911-2e57-75edadade703@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 18 Sep 2023 11:12:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5bmk5jF8Rbso7uUc2-pUvduwdJOoD2Gj_krJZoZ+y1ag@mail.gmail.com>
Message-ID: <CAAhV-H5bmk5jF8Rbso7uUc2-pUvduwdJOoD2Gj_krJZoZ+y1ag@mail.gmail.com>
Subject: Re: [PATCH v21 02/29] LoongArch: KVM: Implement kvm module related interface
To:     zhaotianrui <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 11:08=E2=80=AFAM zhaotianrui <zhaotianrui@loongson.=
cn> wrote:
>
>
> =E5=9C=A8 2023/9/18 =E4=B8=8A=E5=8D=889:45, Huacai Chen =E5=86=99=E9=81=
=93:
> > On Mon, Sep 18, 2023 at 9:21=E2=80=AFAM zhaotianrui <zhaotianrui@loongs=
on.cn> wrote:
> >>
> >> =E5=9C=A8 2023/9/16 =E4=B8=8B=E5=8D=884:51, Huacai Chen =E5=86=99=E9=
=81=93:
> >>> Hi, Tianrui,
> >>>
> >>> On Fri, Sep 15, 2023 at 9:50=E2=80=AFAM Tianrui Zhao <zhaotianrui@loo=
ngson.cn> wrote:
> >>>> Implement LoongArch kvm module init, module exit interface,
> >>>> using kvm context to save the vpid info and vcpu world switch
> >>>> interface pointer.
> >>>>
> >>>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> >>>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/kvm/main.c | 367 +++++++++++++++++++++++++++++++++=
+++++
> >>>>    1 file changed, 367 insertions(+)
> >>>>    create mode 100644 arch/loongarch/kvm/main.c
> >>>>
> >>>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> >>>> new file mode 100644
> >>>> index 0000000000..0deb9273d8
> >>>> --- /dev/null
> >>>> +++ b/arch/loongarch/kvm/main.c
> >>>> @@ -0,0 +1,367 @@
> >>>> +// SPDX-License-Identifier: GPL-2.0
> >>>> +/*
> >>>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> >>>> + */
> >>>> +
> >>>> +#include <linux/err.h>
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/kvm_host.h>
> >>>> +#include <asm/cacheflush.h>
> >>>> +#include <asm/cpufeature.h>
> >>>> +#include <asm/kvm_csr.h>
> >>>> +#include "trace.h"
> >>>> +
> >>>> +static struct kvm_context __percpu *vmcs;
> >>>> +struct kvm_world_switch *kvm_loongarch_ops;
> >>>> +unsigned long vpid_mask;
> >>>> +static int gcsr_flag[CSR_MAX_NUMS];
> >>>> +
> >>>> +int get_gcsr_flag(int csr)
> >>>> +{
> >>>> +       if (csr < CSR_MAX_NUMS)
> >>>> +               return gcsr_flag[csr];
> >>>> +
> >>>> +       return INVALID_GCSR;
> >>>> +}
> >>>> +
> >>>> +static inline void set_gcsr_sw_flag(int csr)
> >>>> +{
> >>>> +       if (csr < CSR_MAX_NUMS)
> >>>> +               gcsr_flag[csr] |=3D SW_GCSR;
> >>>> +}
> >>>> +
> >>>> +static inline void set_gcsr_hw_flag(int csr)
> >>>> +{
> >>>> +       if (csr < CSR_MAX_NUMS)
> >>>> +               gcsr_flag[csr] |=3D HW_GCSR;
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * The default value of gcsr_flag[CSR] is 0, and we use this
> >>>> + * function to set the flag to 1(SW_GCSR) or 2(HW_GCSR) if the
> >>>> + * gcsr is software or hardware. It will be used by get/set_gcsr,
> >>>> + * if gcsr_flag is HW we should use gcsrrd/gcsrwr to access it,
> >>>> + * else use sw csr to emulate it.
> >>>> + */
> >>>> +static void kvm_init_gcsr_flag(void)
> >>>> +{
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_CRMD);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRMD);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_EUEN);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_MISC);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ECFG);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ESTAT);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ERA);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_BADV);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_BADI);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_EENTRY);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBIDX);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBEHI);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO0);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO1);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ASID);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PGDL);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PGDH);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL0);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL1);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_STLBPGSIZE);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_RVACFG);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_CPUID);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG1);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG2);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG3);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS0);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS1);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS2);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS3);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS4);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS5);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS6);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS7);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TMID);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TCFG);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TVAL);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_CNTC);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_LLBCTL);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRENTRY);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRBADV);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRERA);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRSAVE);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO0);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO1);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBREHI);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRPRMD);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN0);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN1);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN2);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN3);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_MWPS);
> >>>> +       set_gcsr_hw_flag(LOONGARCH_CSR_FWPS);
> >>>> +
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL1);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL2);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRCTL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO1);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO2);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRENTRY);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRERA);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRSAVE);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_CTAG);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DEBUG);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DERA);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DESAVE);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG1);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG2);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG3);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PGD);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_TINTCLR);
> >>>> +
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_FWPS);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_FWPC);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MWPS);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MWPC);
> >>> FWPS and MWPS are both HW CSR and SW CSR?
> >>>
> >>> Huacai
> >> The FWPC and MWPC should be SW GCSR, FWPS and MWPS should be HW GCSR, =
it
> >> is my mistake.
> > But in user manual vol 3, section 1.5, FWPC/FWPS/MWPC/MWPS are all HW
> > GCSR, while DBxxxx and IBxxxx are SW GCSR.
> Ok, It is my misunderstanding, as the FWPC and MWPC can control guest
> debug register numbers, but I know they are all HW GCSR when I look up
> the manual again.
So these lines can be removed?

        set_gcsr_sw_flag(LOONGARCH_CSR_FWPS);
        set_gcsr_sw_flag(LOONGARCH_CSR_FWPC);
        set_gcsr_sw_flag(LOONGARCH_CSR_MWPS);
        set_gcsr_sw_flag(LOONGARCH_CSR_MWPC);

And add FWPC/MWPC to hw list?

Huacai

>
> Thanks
> Tianrui Zhao
> >
> > Huacai
> >
> >> Thanks
> >> Tianrui Zhao
> >>>> +
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7ASID);
> >>>> +
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6ASID);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7ADDR);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7MASK);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7CTRL);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7ASID);
> >>>> +
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL0);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR0);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL1);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR1);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL2);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR2);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL3);
> >>>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
> >>>> +}
> >>>> +
> >>>> +static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
> >>>> +{
> >>>> +       struct kvm_context *context;
> >>>> +       unsigned long vpid;
> >>>> +
> >>>> +       context =3D per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> >>>> +       vpid =3D context->vpid_cache + 1;
> >>>> +       if (!(vpid & vpid_mask)) {
> >>>> +               /* finish round of 64 bit loop */
> >>>> +               if (unlikely(!vpid))
> >>>> +                       vpid =3D vpid_mask + 1;
> >>>> +
> >>>> +               /* vpid 0 reserved for root */
> >>>> +               ++vpid;
> >>>> +
> >>>> +               /* start new vpid cycle */
> >>>> +               kvm_flush_tlb_all();
> >>>> +       }
> >>>> +
> >>>> +       context->vpid_cache =3D vpid;
> >>>> +       vcpu->arch.vpid =3D vpid;
> >>>> +}
> >>>> +
> >>>> +void kvm_check_vpid(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +       struct kvm_context *context;
> >>>> +       bool migrated;
> >>>> +       unsigned long ver, old, vpid;
> >>>> +       int cpu;
> >>>> +
> >>>> +       cpu =3D smp_processor_id();
> >>>> +       /*
> >>>> +        * Are we entering guest context on a different CPU to last =
time?
> >>>> +        * If so, the vCPU's guest TLB state on this CPU may be stal=
e.
> >>>> +        */
> >>>> +       context =3D per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> >>>> +       migrated =3D (vcpu->cpu !=3D cpu);
> >>>> +
> >>>> +       /*
> >>>> +        * Check if our vpid is of an older version
> >>>> +        *
> >>>> +        * We also discard the stored vpid if we've executed on
> >>>> +        * another CPU, as the guest mappings may have changed witho=
ut
> >>>> +        * hypervisor knowledge.
> >>>> +        */
> >>>> +       ver =3D vcpu->arch.vpid & ~vpid_mask;
> >>>> +       old =3D context->vpid_cache  & ~vpid_mask;
> >>>> +       if (migrated || (ver !=3D old)) {
> >>>> +               kvm_update_vpid(vcpu, cpu);
> >>>> +               trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
> >>>> +               vcpu->cpu =3D cpu;
> >>>> +       }
> >>>> +
> >>>> +       /* Restore GSTAT(0x50).vpid */
> >>>> +       vpid =3D (vcpu->arch.vpid & vpid_mask) << CSR_GSTAT_GID_SHIF=
T;
> >>>> +       change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
> >>>> +}
> >>>> +
> >>>> +static int kvm_loongarch_env_init(void)
> >>>> +{
> >>>> +       struct kvm_context *context;
> >>>> +       int cpu, order;
> >>>> +       void *addr;
> >>>> +
> >>>> +       vmcs =3D alloc_percpu(struct kvm_context);
> >>>> +       if (!vmcs) {
> >>>> +               pr_err("kvm: failed to allocate percpu kvm_context\n=
");
> >>>> +               return -ENOMEM;
> >>>> +       }
> >>>> +
> >>>> +       kvm_loongarch_ops =3D kzalloc(sizeof(*kvm_loongarch_ops), GF=
P_KERNEL);
> >>>> +       if (!kvm_loongarch_ops) {
> >>>> +               free_percpu(vmcs);
> >>>> +               vmcs =3D NULL;
> >>>> +               return -ENOMEM;
> >>>> +       }
> >>>> +       /*
> >>>> +        * There will be problem in world switch code if there
> >>>> +        * is page fault reenter, since pgd register is shared
> >>>> +        * between root kernel and kvm hypervisor. World switch
> >>>> +        * entry need be unmapped area, cannot be tlb mapped area.
> >>>> +        * In future if hw pagetable walking is supported, or there
> >>>> +        * is separate pgd registers between root kernel and kvm
> >>>> +        * hypervisor, copying about world switch code will not be u=
sed.
> >>>> +        */
> >>>> +
> >>>> +       order =3D get_order(kvm_vector_size + kvm_enter_guest_size);
> >>>> +       addr =3D (void *)__get_free_pages(GFP_KERNEL, order);
> >>>> +       if (!addr) {
> >>>> +               free_percpu(vmcs);
> >>>> +               vmcs =3D NULL;
> >>>> +               kfree(kvm_loongarch_ops);
> >>>> +               kvm_loongarch_ops =3D NULL;
> >>>> +               return -ENOMEM;
> >>>> +       }
> >>>> +
> >>>> +       memcpy(addr, kvm_vector_entry, kvm_vector_size);
> >>>> +       memcpy(addr + kvm_vector_size, kvm_enter_guest, kvm_enter_gu=
est_size);
> >>>> +       flush_icache_range((unsigned long)addr, (unsigned long)addr =
+
> >>>> +                               kvm_vector_size + kvm_enter_guest_si=
ze);
> >>>> +       kvm_loongarch_ops->guest_eentry =3D addr;
> >>>> +       kvm_loongarch_ops->enter_guest =3D addr + kvm_vector_size;
> >>>> +       kvm_loongarch_ops->page_order =3D order;
> >>>> +
> >>>> +       vpid_mask =3D read_csr_gstat();
> >>>> +       vpid_mask =3D (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GI=
DBIT_SHIFT;
> >>>> +       if (vpid_mask)
> >>>> +               vpid_mask =3D GENMASK(vpid_mask - 1, 0);
> >>>> +
> >>>> +       for_each_possible_cpu(cpu) {
> >>>> +               context =3D per_cpu_ptr(vmcs, cpu);
> >>>> +               context->vpid_cache =3D vpid_mask + 1;
> >>>> +               context->last_vcpu =3D NULL;
> >>>> +       }
> >>>> +
> >>>> +       kvm_init_fault();
> >>>> +       kvm_init_gcsr_flag();
> >>>> +
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +static void kvm_loongarch_env_exit(void)
> >>>> +{
> >>>> +       unsigned long addr;
> >>>> +
> >>>> +       if (vmcs)
> >>>> +               free_percpu(vmcs);
> >>>> +
> >>>> +       if (kvm_loongarch_ops) {
> >>>> +               if (kvm_loongarch_ops->guest_eentry) {
> >>>> +                       addr =3D (unsigned long)kvm_loongarch_ops->g=
uest_eentry;
> >>>> +                       free_pages(addr, kvm_loongarch_ops->page_ord=
er);
> >>>> +               }
> >>>> +               kfree(kvm_loongarch_ops);
> >>>> +       }
> >>>> +}
> >>>> +
> >>>> +static int kvm_loongarch_init(void)
> >>>> +{
> >>>> +       int r;
> >>>> +
> >>>> +       if (!cpu_has_lvz) {
> >>>> +               kvm_info("hardware virtualization not available\n");
> >>>> +               return -ENODEV;
> >>>> +       }
> >>>> +       r =3D kvm_loongarch_env_init();
> >>>> +       if (r)
> >>>> +               return r;
> >>>> +
> >>>> +       return kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> >>>> +}
> >>>> +
> >>>> +static void kvm_loongarch_exit(void)
> >>>> +{
> >>>> +       kvm_exit();
> >>>> +       kvm_loongarch_env_exit();
> >>>> +}
> >>>> +
> >>>> +module_init(kvm_loongarch_init);
> >>>> +module_exit(kvm_loongarch_exit);
> >>>> +
> >>>> +#ifdef MODULE
> >>>> +static const struct cpu_feature loongarch_kvm_feature[] =3D {
> >>>> +       { .feature =3D cpu_feature(LOONGARCH_LVZ) },
> >>>> +       {},
> >>>> +};
> >>>> +MODULE_DEVICE_TABLE(cpu, loongarch_kvm_feature);
> >>>> +#endif
> >>>> --
> >>>> 2.39.1
> >>>>
> >>
>
