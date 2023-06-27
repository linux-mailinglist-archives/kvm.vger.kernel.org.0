Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B046E73F783
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjF0Iho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjF0IhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:37:22 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A7903584;
        Tue, 27 Jun 2023 01:36:10 -0700 (PDT)
Received: from loongson.cn (unknown [111.9.175.10])
        by gateway (Coremail) with SMTP id _____8AxBsV2n5pkwPUCAA--.4579S3;
        Tue, 27 Jun 2023 16:36:06 +0800 (CST)
Received: from [10.136.12.26] (unknown [111.9.175.10])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx3yNzn5pkSqwLAA--.7341S3;
        Tue, 27 Jun 2023 16:36:05 +0800 (CST)
Subject: Re: [PATCH v15 02/30] LoongArch: KVM: Implement kvm module related
 interface
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
 <20230626084752.1138621-3-zhaotianrui@loongson.cn>
From:   Jinyang He <hejinyang@loongson.cn>
Message-ID: <8a8efbfd-1ddf-8e25-01c8-111c691ee1c7@loongson.cn>
Date:   Tue, 27 Jun 2023 16:36:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20230626084752.1138621-3-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Bx3yNzn5pkSqwLAA--.7341S3
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Cw1rArWkZF17KrWxZw48Xwc_yoWkZFykpr
        W8CrWUAry3KFnrWa4rXw1Y9r4rJrWI9a9YvF15trWktwnrtrWrWa4Ikr17Ga45Jr1IvF40
        k3Z5Crsa9Fs2qacCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jFApnUUU
        UU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-06-26 16:47, Tianrui Zhao wrote:

> Implement LoongArch kvm module init, module exit interface,
> using kvm context to save the vpid info and vcpu world switch
> interface pointer.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/kvm/main.c | 283 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 283 insertions(+)
>   create mode 100644 arch/loongarch/kvm/main.c
>
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> new file mode 100644
> index 000000000000..f98c1619725f
> --- /dev/null
> +++ b/arch/loongarch/kvm/main.c
> @@ -0,0 +1,283 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/kvm_host.h>
> +#include <asm/cacheflush.h>
> +#include <asm/kvm_csr.h>
> +
> +static struct kvm_context __percpu *vmcs;
> +struct kvm_world_switch *kvm_loongarch_ops;
> +unsigned long vpid_mask;
> +static int gcsr_flag[CSR_MAX_NUMS];
> +
> +int get_gcsr_flag(int csr)
> +{
> +	if (csr < CSR_MAX_NUMS)
> +		return gcsr_flag[csr];
> +
> +	return INVALID_GCSR;
> +}
> +
> +static inline void set_gcsr_sw_flag(int csr)
> +{
> +	if (csr < CSR_MAX_NUMS)
> +		gcsr_flag[csr] |= SW_GCSR;
> +}
> +
> +static inline void set_gcsr_hw_flag(int csr)
> +{
> +	if (csr < CSR_MAX_NUMS)
> +		gcsr_flag[csr] |= HW_GCSR;
> +}
> +
> +/*
> + * The default value of gcsr_flag[CSR] is 0, and we use this
> + * function to set the flag to 1(SW_GCSR) or 2(HW_GCSR) if the
> + * gcsr is software or hardware. It will be used by get/set_gcsr,
> + * if gcsr_flag is HW we should use gcsrrd/gcsrwr to access it,
> + * else use sw csr to emulate it.
> + */
> +static void _kvm_init_gcsr_flag(void)
> +{
> +	set_gcsr_hw_flag(LOONGARCH_CSR_CRMD);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PRMD);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_EUEN);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_MISC);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_ECFG);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_ESTAT);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_ERA);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_BADV);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_BADI);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_EENTRY);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBIDX);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBEHI);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO0);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO1);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_ASID);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PGDL);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PGDH);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL0);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL1);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_STLBPGSIZE);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_RVACFG);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_CPUID);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG1);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG2);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG3);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS0);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS1);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS2);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS3);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS4);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS5);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS6);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_KS7);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TMID);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TCFG);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TVAL);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_CNTC);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_LLBCTL);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRENTRY);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRBADV);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRERA);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRSAVE);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO0);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO1);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBREHI);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRPRMD);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN0);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN1);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN2);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN3);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_MWPS);
> +	set_gcsr_hw_flag(LOONGARCH_CSR_FWPS);
> +
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL1);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL2);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MERRCTL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO1);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO2);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MERRENTRY);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MERRERA);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MERRSAVE);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_CTAG);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DEBUG);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DERA);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DESAVE);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG1);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG2);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG3);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PGD);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_TINTCLR);
> +
> +	set_gcsr_sw_flag(LOONGARCH_CSR_FWPS);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_FWPC);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MWPS);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_MWPC);
> +
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB0ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB0MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB0CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB0ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB1ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB1MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB1CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB1ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB2ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB2MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB2CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB2ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB3ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB3MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB3CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB3ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB4ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB4MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB4CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB4ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB5ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB5MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB5CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB5ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB6ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB6MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB6CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB6ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB7ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB7MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB7CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_DB7ASID);
> +
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB0ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB0MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB0CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB0ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB1ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB1MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB1CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB1ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB2ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB2MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB2CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB2ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB3ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB3MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB3CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB3ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB4ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB4MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB4CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB4ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB5ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB5MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB5CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB5ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB6ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB6MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB6CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB6ASID);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB7ADDR);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB7MASK);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB7CTRL);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_IB7ASID);
> +
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL0);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR0);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL1);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR1);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL2);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR2);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL3);
> +	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
> +}
> +
> +static int kvm_loongarch_env_init(void)
> +{
> +	struct kvm_context *context;
> +	int cpu, order;
> +	void *addr;
> +
> +	vmcs = alloc_percpu(struct kvm_context);
> +	if (!vmcs) {
> +		pr_err("kvm: failed to allocate percpu kvm_context\n");
> +		return -ENOMEM;
> +	}
> +
> +	kvm_loongarch_ops = kzalloc(sizeof(*kvm_loongarch_ops), GFP_KERNEL);
> +	if (!kvm_loongarch_ops)
free vmcs ?
> +		return -ENOMEM;
> +
> +	/*
> +	 * There will be problem in world switch code if there
> +	 * is page fault reenter, since pgd register is shared
> +	 * between root kernel and kvm hypervisor. World switch
> +	 * entry need be unmapped area, cannot be tlb mapped area.
> +	 * In future if hw pagetable walking is supported, or there
> +	 * is separate pgd registers between root kernel and kvm
> +	 * hypervisor, copying about world switch code will not be used.
> +	 */
> +
> +	order = get_order(kvm_vector_size + kvm_enter_guest_size);
> +	addr = (void *)__get_free_pages(GFP_KERNEL, order);
> +	if (!addr) {
> +		free_percpu(vmcs);
free kvm_loongarch_ops ?
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(addr, kvm_vector_entry, kvm_vector_size);
> +	memcpy(addr + kvm_vector_size, kvm_enter_guest, kvm_enter_guest_size);
> +	flush_icache_range((unsigned long)addr, (unsigned long)addr +
> +				kvm_vector_size + kvm_enter_guest_size);
> +	kvm_loongarch_ops->guest_eentry = addr;
> +	kvm_loongarch_ops->enter_guest = addr + kvm_vector_size;
> +	kvm_loongarch_ops->page_order = order;
> +
> +	vpid_mask = read_csr_gstat();
> +	vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
> +	if (vpid_mask)
> +		vpid_mask = GENMASK(vpid_mask - 1, 0);
> +
> +	for_each_possible_cpu(cpu) {
> +		context = per_cpu_ptr(vmcs, cpu);
> +		context->vpid_cache = vpid_mask + 1;
> +		context->last_vcpu = NULL;
> +	}
> +
> +	_kvm_init_fault();
> +	_kvm_init_gcsr_flag();
> +
> +	return 0;
> +}
> +
> +static void kvm_loongarch_env_exit(void)
> +{
> +	free_pages((unsigned long)kvm_loongarch_ops->guest_eentry, kvm_loongarch_ops->page_order);
free kvm_loongarch_ops ?
> +	free_percpu(vmcs);
> +}
> +
> +static int kvm_loongarch_init(void)
> +{
> +	int r;
> +
> +	if (!cpu_has_lvz)
> +		return 0;

I think we should do some print and return with errno.


Jinyang

> +
> +	r = kvm_loongarch_env_init();
> +	if (r)
> +		return r;
> +
> +	return kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> +}
> +
> +static void kvm_loongarch_exit(void)
> +{
> +	kvm_exit();
> +	kvm_loongarch_env_exit();
> +}
> +
> +module_init(kvm_loongarch_init);
> +module_exit(kvm_loongarch_exit);

