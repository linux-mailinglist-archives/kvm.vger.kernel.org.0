Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4997237B9
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjFFGaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 02:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjFFGay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 02:30:54 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8568392;
        Mon,  5 Jun 2023 23:30:51 -0700 (PDT)
Received: from loongson.cn (unknown [192.168.100.1])
        by gateway (Coremail) with SMTP id _____8DxPPCW0n5kWgQAAA--.144S3;
        Tue, 06 Jun 2023 14:30:46 +0800 (CST)
Received: from [0.0.0.0] (unknown [192.168.100.1])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxJeST0n5ko+EBAA--.8268S3;
        Tue, 06 Jun 2023 14:30:44 +0800 (CST)
Subject: Re: [PATCH v12 01/31] LoongArch: KVM: Add kvm related header files
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-2-zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Youling Tang <tangyouling@loongson.cn>
Message-ID: <7bbc1383-9248-438b-cc09-1639185b7b45@loongson.cn>
Date:   Tue, 6 Jun 2023 14:30:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20230530015223.147755-2-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf8AxJeST0n5ko+EBAA--.8268S3
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7ur17CF18GFWxCryUCF18Xrc_yoW8Kryxpa
        yvkw1xKr47X340grn7tw1qvF9rJr4Ut3W2vanrJrWrA3Z7Ka4fCFs8G34DZF4fA3ykXanF
        ya4rGwsxursrJacCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
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

Hi, Tianrui

On 05/30/2023 09:51 AM, Tianrui Zhao wrote:
/* snip */
> +struct kvm_vcpu_arch {
> +	/*
> +	 * Switch pointer-to-function type to unsigned long
> +	 * for loading the value into register directly.
> +	 */
> +	unsigned long guest_eentry;
> +	unsigned long host_eentry;
> +
> +	/* Pointers stored here for easy accessing from assembly code */
> +	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +
> +	/* Host registers preserved across guest mode execution */
> +	unsigned long host_stack;
> +	unsigned long host_gp;

In arch/loongarch/kvm/switch.S,

ld.d tp, a2, KVM_ARCH_HGP
ld.d sp, a2, KVM_ARCH_HSTACK

Should we need to change host_gp to host_tp (and also change host_stack
to host_sp for consistency).

And modify KVM_ARCH_HSTACK and KVM_ARCH_HGP synchronously.

Thanks,
Youling
> +	unsigned long host_pgd;
> +
> +	/* Host CSRs are used when handling exits from guest */
> +	unsigned long badi;
> +	unsigned long badv;
> +	unsigned long host_ecfg;
> +	unsigned long host_estat;
> +	unsigned long host_percpu;
> +
> +	/* GPRs */
> +	unsigned long gprs[32];
> +	unsigned long pc;
> +
> +	/* FPU state */
> +	struct loongarch_fpu fpu FPU_ALIGN;
> +	/* Which auxiliary state is loaded (KVM_LOONGARCH_AUX_*) */
> +	unsigned int aux_inuse;
> +
> +	/* CSR state */
> +	struct loongarch_csrs *csr;
> +
> +	/* GPR used as IO source/target */
> +	u32 io_gpr;
> +
> +	struct hrtimer swtimer;
> +	/* KVM register to control count timer */
> +	u32 count_ctl;
> +
> +	/* Bitmask of exceptions that are pending */
> +	unsigned long irq_pending;
> +	/* Bitmask of pending exceptions to be cleared */
> +	unsigned long irq_clear;
> +
> +	/* Cache for pages needed inside spinlock regions */
> +	struct kvm_mmu_memory_cache mmu_page_cache;
> +
> +	/* vcpu's vpid */
> +	u64 vpid;
> +
> +	/* Period of stable timer tick in ns */
> +	u64 timer_period_ns;
> +	/* Frequency of stable timer in Hz */
> +	u64 timer_mhz;
> +	/* Stable bias from the raw time */
> +	u64 timer_bias;
> +	/* Dynamic nanosecond bias (multiple of timer_period_ns) to avoid overflow */
> +	s64 timer_dyn_bias;
> +
> +	ktime_t stable_ktime_saved;
> +
> +	u64 core_ext_ioisr[4];
> +
> +	/* Last CPU the vCPU state was loaded on */
> +	int last_sched_cpu;
> +	/* Last CPU the vCPU actually executed guest code on */
> +	int last_exec_cpu;
> +	/* mp state */
> +	struct kvm_mp_state mp_state;
> +};

