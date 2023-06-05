Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4072262E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjFEMop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjFEMoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:44:44 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F02A598;
        Mon,  5 Jun 2023 05:44:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Cx5vC42H1k0BYAAA--.229S3;
        Mon, 05 Jun 2023 20:44:40 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx+OS42H1kd3oAAA--.2298S3;
        Mon, 05 Jun 2023 20:44:40 +0800 (CST)
Message-ID: <4d4d7453-356d-9eec-c183-e8211a40e5e9@loongson.cn>
Date:   Mon, 5 Jun 2023 20:44:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 06/31] LoongArch: KVM: Implement vcpu create and
 destroy interface
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-7-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-7-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bx+OS42H1kd3oAAA--.2298S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxur1xZr4rZr4rJF18XFWDAwc_yoW5Zw4fpF
        W0kw13Wr48Jr17GwnxXwn0vFn0qrW8Gr17Wa47XrySyrnFqrnYyF4vkrWDAFWfJrZ3ZFyI
        qF1rGr4Uuw4qy3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
        Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8KNt3
        UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo, Mao <maobibo@loongson.cn>

在 2023/5/30 09:51, Tianrui Zhao 写道:
> Implement vcpu create and destroy interface, saving some info
> into vcpu arch structure such as vcpu exception entrance, vcpu
> enter guest pointer, etc. Init vcpu timer and set address
> translation mode when vcpu create.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 88 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
>  create mode 100644 arch/loongarch/kvm/vcpu.c
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> new file mode 100644
> index 000000000000..24b5b00266a1
> --- /dev/null
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/fpu.h>
> +#include <asm/loongarch.h>
> +#include <asm/setup.h>
> +#include <asm/time.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include "trace.h"
> +
> +int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long timer_hz;
> +	struct loongarch_csrs *csr;
> +
> +	vcpu->arch.vpid = 0;
> +
> +	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
> +	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
> +	vcpu->kvm->arch.online_vcpus = vcpu->vcpu_id + 1;
> +
> +	vcpu->arch.guest_eentry = (unsigned long)kvm_loongarch_ops->guest_eentry;
> +	vcpu->arch.handle_exit = _kvm_handle_exit;
> +	vcpu->arch.csr = kzalloc(sizeof(struct loongarch_csrs), GFP_KERNEL);
> +	if (!vcpu->arch.csr)
> +		return -ENOMEM;
> +
> +	/*
> +	 * kvm all exceptions share one exception entry, and host <-> guest switch
> +	 * also switch excfg.VS field, keep host excfg.VS info here
> +	 */
> +	vcpu->arch.host_ecfg = (read_csr_ecfg() & CSR_ECFG_VS);
> +
> +	/* Init */
> +	vcpu->arch.last_sched_cpu = -1;
> +	vcpu->arch.last_exec_cpu = -1;
> +
> +	/*
> +	 * Initialize guest register state to valid architectural reset state.
> +	 */
> +	timer_hz = calc_const_freq();
> +	kvm_init_timer(vcpu, timer_hz);
> +
> +	/* Set Initialize mode for GUEST */
> +	csr = vcpu->arch.csr;
> +	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CRMD, CSR_CRMD_DA);
> +
> +	/* Set cpuid */
> +	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TMID, vcpu->vcpu_id);
> +
> +	/* start with no pending virtual guest interrupts */
> +	csr->csrs[LOONGARCH_CSR_GINTC] = 0;
> +
> +	return 0;
> +}
> +
> +void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> +{
> +	int cpu;
> +	struct kvm_context *context;
> +
> +	hrtimer_cancel(&vcpu->arch.swtimer);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +	kfree(vcpu->arch.csr);
> +
> +	/*
> +	 * If the vCPU is freed and reused as another vCPU, we don't want the
> +	 * matching pointer wrongly hanging around in last_vcpu.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> +		if (context->last_vcpu == vcpu)
> +			context->last_vcpu = NULL;
> +	}
> +}

