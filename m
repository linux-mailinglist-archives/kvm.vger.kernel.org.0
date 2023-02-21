Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5469D912
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 03:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjBUC5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 21:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjBUC5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 21:57:18 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C8D824129;
        Mon, 20 Feb 2023 18:56:47 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8AxlF3cMvRj0gUDAA--.657S3;
        Tue, 21 Feb 2023 10:56:28 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxG77ZMvRj3343AA--.35199S3;
        Tue, 21 Feb 2023 10:56:25 +0800 (CST)
Subject: Re: [PATCH v2 01/29] LoongArch: KVM: Add kvm related header files
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-2-zhaotianrui@loongson.cn>
 <2b047b75-7397-0cce-e7af-ebba67ae2561@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <c9dada46-829c-d3cd-c3b6-68a570552e84@loongson.cn>
Date:   Tue, 21 Feb 2023 10:56:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <2b047b75-7397-0cce-e7af-ebba67ae2561@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxG77ZMvRj3343AA--.35199S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxGF13Gw1xZF1DJw1kKryUJrb_yoW5ZFWkpa
        48Cw4xKr4UXryUKr1xXrn5XasIqrZrtr1ayFsxt3W3Ja4q93W8Cr4kGa4UuF4xJrykXa17
        Aa4UKrnxuFs8ta7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月21日 02:22, Paolo Bonzini 写道:
> On 2/20/23 07:57, Tianrui Zhao wrote:
>> +
>> +/* Resume Flags */
>> +#define RESUME_FLAG_DR        (1<<0)    /* Reload guest nonvolatile 
>> state? */
>> +#define RESUME_FLAG_HOST    (1<<1)    /* Resume host? */
>> +
>> +#define RESUME_GUEST        0
>> +#define RESUME_GUEST_DR        RESUME_FLAG_DR
>> +#define RESUME_HOST        RESUME_FLAG_HOST
>> +
>
> Most of this code is dead, I'll give more instructions in a reply to 
> patch 8.
>
>> +    unsigned long guest_eentry;
>> +    unsigned long host_eentry;
>> +    int (*vcpu_run)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +    int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +
>> +    /* Host registers preserved across guest mode execution */
>> +    unsigned long host_stack;
>> +    unsigned long host_gp;
>> +    unsigned long host_pgd;
>> +    unsigned long host_pgdhi;
>> +    unsigned long host_entryhi;
>> +
>> +    /* Host CSR registers used when handling exits from guest */
>> +    unsigned long badv;
>> +    unsigned long host_estat;
>> +    unsigned long badi;
>> +    unsigned long host_ecfg;
>> +    unsigned long host_percpu;
>> +
>> +    /* GPRS */
>> +    unsigned long gprs[32];
>> +    unsigned long pc;
>> +
>> +    /* FPU State */
>> +    struct loongarch_fpu fpu FPU_ALIGN;
>> +    /* Which auxiliary state is loaded (KVM_LOONGARCH_AUX_*) */
>> +    unsigned int aux_inuse;
>> +
>> +    /* CSR State */
>> +    struct loongarch_csrs *csr;
>> +
>> +    /* GPR used as IO source/target */
>> +    u32 io_gpr;
>> +
>> +    struct hrtimer swtimer;
>> +    /* Count timer control KVM register */
>> +    u32 count_ctl;
>> +
>> +    /* Bitmask of exceptions that are pending */
>> +    unsigned long irq_pending;
>> +    /* Bitmask of pending exceptions to be cleared */
>> +    unsigned long irq_clear;
>> +
>> +    /* Cache some mmu pages needed inside spinlock regions */
>> +    struct kvm_mmu_memory_cache mmu_page_cache;
>> +
>> +    /* vcpu's vpid is different on each host cpu in an smp system */
>> +    u64 vpid[NR_CPUS];
>
> In _kvm_check_vmid(), you already have
>
> +    if (migrated || (ver != old)) {
> +        _kvm_update_vpid(vcpu, cpu);
> +        trace_kvm_vpid_change(vcpu, vcpu->arch.vpid[cpu]);
> +    }
>
> so a vpid will never be recycled if a vCPU migrates from physical CPU 
> A to B and back to A.
>
> So please keep the current VPID in the per-cpu struct vmcs, and you 
> can just copy it from there in _kvm_check_vmid().

Thanks,  that is to say we should remove the vpid[NR_CPUS] array and it 
is enough to use only one vpid variable?

Thanks
Tianrui Zhao

>
>> +    /* Period of stable timer tick in ns */
>> +    u64 timer_period;
>> +    /* Frequency of stable timer in Hz */
>> +    u64 timer_mhz;
>> +    /* Stable bias from the raw time */
>> +    u64 timer_bias;
>> +    /* Dynamic nanosecond bias (multiple of timer_period) to avoid 
>> overflow */
>> +    s64 timer_dyn_bias;
>> +    /* Save ktime */
>> +    ktime_t stable_ktime_saved;
>> +
>> +    u64 core_ext_ioisr[4];
>> +
>> +    /* Last CPU the VCPU state was loaded on */
>> +    int last_sched_cpu;
>> +    /* Last CPU the VCPU actually executed guest code on */
>> +    int last_exec_cpu;
>> +
>> +    u8 fpu_enabled;
>
> This field is always true, please remove it.

Thanks, i will remove this variable.

Thanks
Tianrui Zhao

>
>> +    struct kvm_guest_debug_arch guest_debug;
>
> This struct is empty, please remove it.

Ok, I will remove it.

Thanks
Tianrui Zhao

>
> Paolo

