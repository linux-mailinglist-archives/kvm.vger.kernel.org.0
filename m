Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50CD7A5770
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 04:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjISCiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 22:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjISCip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 22:38:45 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A460FFF;
        Mon, 18 Sep 2023 19:38:36 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8DxVuirCQllSswpAA--.44960S3;
        Tue, 19 Sep 2023 10:38:35 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd6nCQllhyALAA--.24517S3;
        Tue, 19 Sep 2023 10:38:33 +0800 (CST)
Subject: Re: [PATCH v21 02/29] LoongArch: KVM: Implement kvm module related
 interface
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
 <20230915014949.1222777-3-zhaotianrui@loongson.cn>
 <CAAhV-H5MEEACwp-NAPMWDhv31YT9cqJE6o8Z_O3UtHepyKF81g@mail.gmail.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <a6a8ce42-54ad-659a-95c9-c5f47f74aecd@loongson.cn>
Date:   Tue, 19 Sep 2023 10:38:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5MEEACwp-NAPMWDhv31YT9cqJE6o8Z_O3UtHepyKF81g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Cxjd6nCQllhyALAA--.24517S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWfJrWfXF1kJry7Cw48ZryktFc_yoW8Xr48Wo
        WrKF4rGF1UAr12yrZxW34qqaykWr1rCa9ava17Zw1ftw1qy3WFgrZ8Ca1UArsxXF1UCa4U
        GanFgF1j9FWxKr13l-sFpf9Il3svdjkaLaAFLSUrUUUUeb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUO07kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1q6r43MI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUU
        UUU
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/9/17 下午12:21, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Fri, Sep 15, 2023 at 9:50 AM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Implement LoongArch kvm module init, module exit interface,
>> using kvm context to save the vpid info and vcpu world switch
>> interface pointer.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/main.c | 367 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 367 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/main.c
>>
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> new file mode 100644
>> index 0000000000..0deb9273d8
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -0,0 +1,367 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/module.h>
>> +#include <linux/kvm_host.h>
>> +#include <asm/cacheflush.h>
>> +#include <asm/cpufeature.h>
>> +#include <asm/kvm_csr.h>
>> +#include "trace.h"
>> +
>> +static struct kvm_context __percpu *vmcs;
>> +struct kvm_world_switch *kvm_loongarch_ops;
>> +unsigned long vpid_mask;
>> +static int gcsr_flag[CSR_MAX_NUMS];
>> +
>> +int get_gcsr_flag(int csr)
>> +{
>> +       if (csr < CSR_MAX_NUMS)
>> +               return gcsr_flag[csr];
>> +
>> +       return INVALID_GCSR;
>> +}
>> +
>> +static inline void set_gcsr_sw_flag(int csr)
>> +{
>> +       if (csr < CSR_MAX_NUMS)
>> +               gcsr_flag[csr] |= SW_GCSR;
>> +}
>> +
>> +static inline void set_gcsr_hw_flag(int csr)
>> +{
>> +       if (csr < CSR_MAX_NUMS)
>> +               gcsr_flag[csr] |= HW_GCSR;
>> +}
>> +
>> +/*
>> + * The default value of gcsr_flag[CSR] is 0, and we use this
>> + * function to set the flag to 1(SW_GCSR) or 2(HW_GCSR) if the
>> + * gcsr is software or hardware. It will be used by get/set_gcsr,
>> + * if gcsr_flag is HW we should use gcsrrd/gcsrwr to access it,
>> + * else use sw csr to emulate it.
>> + */
>> +static void kvm_init_gcsr_flag(void)
>> +{
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_CRMD);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRMD);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_EUEN);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_MISC);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ECFG);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ESTAT);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ERA);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_BADV);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_BADI);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_EENTRY);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBIDX);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBEHI);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO0);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO1);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_ASID);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PGDL);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PGDH);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL0);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL1);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_STLBPGSIZE);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_RVACFG);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_CPUID);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG1);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG2);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG3);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS0);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS1);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS2);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS3);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS4);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS5);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS6);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_KS7);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TMID);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TCFG);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TVAL);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_CNTC);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_LLBCTL);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRENTRY);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRBADV);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRERA);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRSAVE);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO0);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO1);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBREHI);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_TLBRPRMD);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN0);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN1);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN2);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN3);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_MWPS);
>> +       set_gcsr_hw_flag(LOONGARCH_CSR_FWPS);
>> +
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL1);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL2);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRCTL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO1);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO2);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRENTRY);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRERA);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MERRSAVE);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_CTAG);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DEBUG);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DERA);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DESAVE);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG1);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG2);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG3);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PGD);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_TINTCLR);
>> +
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_FWPS);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_FWPC);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MWPS);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_MWPC);
>> +
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB0ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB1ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB2ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB3ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB4ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB5ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB6ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_DB7ASID);
>> +
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB0ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB1ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB2ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB3ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB4ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB5ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB6ASID);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7ADDR);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7MASK);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7CTRL);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_IB7ASID);
>> +
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL0);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR0);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL1);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR1);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL2);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR2);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL3);
>> +       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
>> +}
>> +
>> +static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +       struct kvm_context *context;
>> +       unsigned long vpid;
>> +
>> +       context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
>> +       vpid = context->vpid_cache + 1;
>> +       if (!(vpid & vpid_mask)) {
>> +               /* finish round of 64 bit loop */
>> +               if (unlikely(!vpid))
>> +                       vpid = vpid_mask + 1;
>> +
>> +               /* vpid 0 reserved for root */
>> +               ++vpid;
>> +
>> +               /* start new vpid cycle */
>> +               kvm_flush_tlb_all();
>> +       }
>> +
>> +       context->vpid_cache = vpid;
>> +       vcpu->arch.vpid = vpid;
>> +}
>> +
>> +void kvm_check_vpid(struct kvm_vcpu *vcpu)
>> +{
>> +       struct kvm_context *context;
>> +       bool migrated;
>> +       unsigned long ver, old, vpid;
>> +       int cpu;
>> +
>> +       cpu = smp_processor_id();
>> +       /*
>> +        * Are we entering guest context on a different CPU to last time?
>> +        * If so, the vCPU's guest TLB state on this CPU may be stale.
>> +        */
>> +       context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
>> +       migrated = (vcpu->cpu != cpu);
>> +
>> +       /*
>> +        * Check if our vpid is of an older version
>> +        *
>> +        * We also discard the stored vpid if we've executed on
>> +        * another CPU, as the guest mappings may have changed without
>> +        * hypervisor knowledge.
>> +        */
>> +       ver = vcpu->arch.vpid & ~vpid_mask;
>> +       old = context->vpid_cache  & ~vpid_mask;
>> +       if (migrated || (ver != old)) {
>> +               kvm_update_vpid(vcpu, cpu);
>> +               trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
>> +               vcpu->cpu = cpu;
>> +       }
>> +
>> +       /* Restore GSTAT(0x50).vpid */
>> +       vpid = (vcpu->arch.vpid & vpid_mask) << CSR_GSTAT_GID_SHIFT;
>> +       change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
>> +}
>> +
>> +static int kvm_loongarch_env_init(void)
>> +{
>> +       struct kvm_context *context;
>> +       int cpu, order;
>> +       void *addr;
>> +
>> +       vmcs = alloc_percpu(struct kvm_context);
>> +       if (!vmcs) {
>> +               pr_err("kvm: failed to allocate percpu kvm_context\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       kvm_loongarch_ops = kzalloc(sizeof(*kvm_loongarch_ops), GFP_KERNEL);
>> +       if (!kvm_loongarch_ops) {
>> +               free_percpu(vmcs);
>> +               vmcs = NULL;
>> +               return -ENOMEM;
>> +       }
>> +       /*
>> +        * There will be problem in world switch code if there
>> +        * is page fault reenter, since pgd register is shared
>> +        * between root kernel and kvm hypervisor. World switch
>> +        * entry need be unmapped area, cannot be tlb mapped area.
>> +        * In future if hw pagetable walking is supported, or there
>> +        * is separate pgd registers between root kernel and kvm
>> +        * hypervisor, copying about world switch code will not be used.
>> +        */
>> +
>> +       order = get_order(kvm_vector_size + kvm_enter_guest_size);
>> +       addr = (void *)__get_free_pages(GFP_KERNEL, order);
>> +       if (!addr) {
>> +               free_percpu(vmcs);
>> +               vmcs = NULL;
>> +               kfree(kvm_loongarch_ops);
>> +               kvm_loongarch_ops = NULL;
>> +               return -ENOMEM;
>> +       }
>> +
>> +       memcpy(addr, kvm_vector_entry, kvm_vector_size);
>> +       memcpy(addr + kvm_vector_size, kvm_enter_guest, kvm_enter_guest_size);
> Why memcpy? In our internal repo, we use kvm_vector_entry and
> kvm_enter_guest directly. The long comments above make me nervous
> because Loongson-3A6000 already supports hardware pagetable walker.
>
> Huacai
As mentioned in the comments, it need not this memcpy if hardware page 
walk is supported in 3A6000.

Thanks
Tianrui Zhao
>
>> +       flush_icache_range((unsigned long)addr, (unsigned long)addr +
>> +                               kvm_vector_size + kvm_enter_guest_size);
>> +       kvm_loongarch_ops->guest_eentry = addr;
>> +       kvm_loongarch_ops->enter_guest = addr + kvm_vector_size;
>> +       kvm_loongarch_ops->page_order = order;
>> +
>> +       vpid_mask = read_csr_gstat();
>> +       vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
>> +       if (vpid_mask)
>> +               vpid_mask = GENMASK(vpid_mask - 1, 0);
>> +
>> +       for_each_possible_cpu(cpu) {
>> +               context = per_cpu_ptr(vmcs, cpu);
>> +               context->vpid_cache = vpid_mask + 1;
>> +               context->last_vcpu = NULL;
>> +       }
>> +
>> +       kvm_init_fault();
>> +       kvm_init_gcsr_flag();
>> +
>> +       return 0;
>> +}
>> +
>> +static void kvm_loongarch_env_exit(void)
>> +{
>> +       unsigned long addr;
>> +
>> +       if (vmcs)
>> +               free_percpu(vmcs);
>> +
>> +       if (kvm_loongarch_ops) {
>> +               if (kvm_loongarch_ops->guest_eentry) {
>> +                       addr = (unsigned long)kvm_loongarch_ops->guest_eentry;
>> +                       free_pages(addr, kvm_loongarch_ops->page_order);
>> +               }
>> +               kfree(kvm_loongarch_ops);
>> +       }
>> +}
>> +
>> +static int kvm_loongarch_init(void)
>> +{
>> +       int r;
>> +
>> +       if (!cpu_has_lvz) {
>> +               kvm_info("hardware virtualization not available\n");
>> +               return -ENODEV;
>> +       }
>> +       r = kvm_loongarch_env_init();
>> +       if (r)
>> +               return r;
>> +
>> +       return kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
>> +}
>> +
>> +static void kvm_loongarch_exit(void)
>> +{
>> +       kvm_exit();
>> +       kvm_loongarch_env_exit();
>> +}
>> +
>> +module_init(kvm_loongarch_init);
>> +module_exit(kvm_loongarch_exit);
>> +
>> +#ifdef MODULE
>> +static const struct cpu_feature loongarch_kvm_feature[] = {
>> +       { .feature = cpu_feature(LOONGARCH_LVZ) },
>> +       {},
>> +};
>> +MODULE_DEVICE_TABLE(cpu, loongarch_kvm_feature);
>> +#endif
>> --
>> 2.39.1
>>

