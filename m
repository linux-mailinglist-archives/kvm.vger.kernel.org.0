Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E28723517
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjFFCNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjFFCNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:13:33 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 226F010A;
        Mon,  5 Jun 2023 19:13:31 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.86])
        by gateway (Coremail) with SMTP id _____8AxxvBKln5kyVUAAA--.982S3;
        Tue, 06 Jun 2023 10:13:30 +0800 (CST)
Received: from [10.20.42.86] (unknown [10.20.42.86])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxReRIln5kBZ8BAA--.7390S3;
        Tue, 06 Jun 2023 10:13:29 +0800 (CST)
Subject: Re: [PATCH v12 08/31] LoongArch: KVM: Implement vcpu handle exit
 interface
To:     "bibo, mao" <maobibo@loongson.cn>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-9-zhaotianrui@loongson.cn>
 <d28f48e3-95d2-111f-e938-348d68402a57@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <3fe89bb1-a39c-1da2-b527-4175dfb68752@loongson.cn>
Date:   Tue, 6 Jun 2023 10:13:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <d28f48e3-95d2-111f-e938-348d68402a57@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxReRIln5kBZ8BAA--.7390S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Aw4UtFWxCFW8Zw15tF15ZFc_yoW5JF43pr
        WkCFn8Ww4rJry7Gw13tws0qrnIqr97Kr1I9ry3Way2yrsFy34rtry8KrZxCFy5ur1FqF1x
        ZF1rGrn8uFs0yagCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
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
        Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8_gA5
        UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年06月05日 21:03, bibo, mao 写道:
>
> 在 2023/5/30 09:52, Tianrui Zhao 写道:
>> Implement vcpu handle exit interface, getting the exit code by ESTAT
>> register and using kvm exception vector to handle it.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/vcpu.c | 46 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index eca8b96a3e6e..ddea480fa5b0 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -55,6 +55,52 @@ static void kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
>>   }
>>   
>> +/*
>> + * Return 1 for resume guest and "<= 0" for resume host.
>> + */
>> +static int _kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long exst = vcpu->arch.host_estat;
>> +	u32 intr = exst & 0x1fff; /* ignore NMI */
>> +	u32 exccode = (exst & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
>> +	int ret = RESUME_GUEST;
>> +
>> +	vcpu->mode = OUTSIDE_GUEST_MODE;
>> +
>> +	/* Set a default exit reason */
>> +	run->exit_reason = KVM_EXIT_UNKNOWN;
>> +	run->ready_for_interrupt_injection = 1;
> Is ready_for_interrupt_injection used in qemu or kvm for LoongArch?
We do not handle ready_for_interrupt_injection when vcpu exit in 
qemu/kvm, and I will remove it.

Thanks
Tianrui Zhao
>
>> +
>> +	local_irq_enable();
>> +	guest_state_exit_irqoff();
>> +
>> +	trace_kvm_exit(vcpu, exccode);
>> +	if (exccode) {
>> +		ret = _kvm_handle_fault(vcpu, exccode);
>> +	} else {
>> +		WARN(!intr, "suspicious vm exiting");
> how about comments like this?
>    WARN(!intr, "vm exiting with suspicious irq \n")
>
> Regards
> Bibo, Mao
Thanks, this comment should contain more information, I will fix it.

Thanks
Tianrui Zhao
>> +		++vcpu->stat.int_exits;
>> +	}
>> +
>> +	cond_resched();
>> +	local_irq_disable();
>> +
>> +	if (ret == RESUME_HOST)
>> +		return ret;
>> +
>> +	/* Only check for signals if not already exiting to userspace */
>> +	if (signal_pending(current)) {
>> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
>> +		++vcpu->stat.signal_exits;
>> +		return -EINTR;
>> +	}
>> +
>> +	kvm_pre_enter_guest(vcpu);
>> +	trace_kvm_reenter(vcpu);
>> +	guest_state_enter_irqoff();
>> +	return RESUME_GUEST;
>> +}
>> +
>>   int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned long timer_hz;

