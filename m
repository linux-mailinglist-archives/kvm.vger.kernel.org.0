Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB836FC364
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbjEIKEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbjEIKEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:04:11 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF2DE4EFB;
        Tue,  9 May 2023 03:04:06 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8DxZPCVGlpkZO0GAA--.11560S3;
        Tue, 09 May 2023 18:04:05 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfTuTGlpkYWlSAA--.16963S3;
        Tue, 09 May 2023 18:04:03 +0800 (CST)
Subject: Re: [PATCH v9 30/30] LoongArch: KVM: Supplement kvm document about
 LoongArch-specific part
To:     Enze Li <lienze@kylinos.cn>
References: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
 <20230509075346.1023386-31-zhaotianrui@loongson.cn>
 <87bkitomt8.fsf@kylinos.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <1f06f49b-3b0a-efc4-97f2-3b64e6a82188@loongson.cn>
Date:   Tue, 9 May 2023 18:04:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <87bkitomt8.fsf@kylinos.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxfTuTGlpkYWlSAA--.16963S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3GryDAFy8uw15AF4kZF1xAFb_yoWxCrykpF
        ZakayfKr4vqry7t347t34jgryakrWxtF47C3Wrtr18C3Wjyr18Jr1qqrW8WFyDCryDAF18
        ZF18t3W3CFWUArJanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAaw2AF
        wI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
        Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
        14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
        AE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
        AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv
        6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年05月09日 17:50, Enze Li 写道:
> Hi Tianrui,
>
> Thank you for working on this.  Only one small nit, please see below.
>
> On Tue, May 09 2023 at 03:53:46 PM +0800, Tianrui Zhao wrote:
>
>> Supplement kvm document about LoongArch-specific part, such as add
>> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
>> etc.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   Documentation/virt/kvm/api.rst | 71 +++++++++++++++++++++++++++++-----
>>   1 file changed, 62 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index add067793b90..ae7d6a2cd54f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -416,6 +416,12 @@ Reads the general purpose registers from the vcpu.
>>   	__u64 pc;
>>     };
>>   
>> +  /* LoongArch */
>> +  struct kvm_regs {
>> +        unsigned long gpr[32];
>> +        unsigned long pc;
>> +  };
>> +
>>   
>>   4.12 KVM_SET_REGS
>>   -----------------
>> @@ -506,7 +512,7 @@ translation mode.
>>   ------------------
>>   
>>   :Capability: basic
>> -:Architectures: x86, ppc, mips, riscv
>> +:Architectures: x86, ppc, mips, riscv, loongarch
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_interrupt (in)
>>   :Returns: 0 on success, negative on failure.
>> @@ -592,6 +598,14 @@ b) KVM_INTERRUPT_UNSET
>>   
>>   This is an asynchronous vcpu ioctl and can be invoked from any thread.
>>   
>> +LOONGARCH:
>> +^^^^^^^^^^
>> +
>> +Queues an external interrupt to be injected into the virtual CPU. A negative
>> +interrupt number dequeues the interrupt.
>> +
>> +This is an asynchronous vcpu ioctl and can be invoked from any thread.
>> +
>>   
>>   4.17 KVM_DEBUG_GUEST
>>   --------------------
>> @@ -737,7 +751,7 @@ signal mask.
>>   ----------------
>>   
>>   :Capability: basic
>> -:Architectures: x86
>> +:Architectures: x86, loongarch
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_fpu (out)
>>   :Returns: 0 on success, -1 on error
>> @@ -746,7 +760,7 @@ Reads the floating point state from the vcpu.
>>   
>>   ::
>>   
>> -  /* for KVM_GET_FPU and KVM_SET_FPU */
>> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>>     struct kvm_fpu {
>>   	__u8  fpr[8][16];
>>   	__u16 fcw;
>> @@ -761,12 +775,22 @@ Reads the floating point state from the vcpu.
>>   	__u32 pad2;
>>     };
>>   
>> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
>> +  struct kvm_fpu {
>> +        __u32 fcsr;
>> +        __u32 none;
>> +        __u64 fcc;
>> +        struct kvm_fpureg {
>> +                __u64 val64[4];
>> +        }fpr[32];
>> +  };
>> +
>>   
>>   4.23 KVM_SET_FPU
>>   ----------------
>>   
>>   :Capability: basic
>> -:Architectures: x86
>> +:Architectures: x86, loongarch
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_fpu (in)
>>   :Returns: 0 on success, -1 on error
>> @@ -775,7 +799,7 @@ Writes the floating point state to the vcpu.
>>   
>>   ::
>>   
>> -  /* for KVM_GET_FPU and KVM_SET_FPU */
>> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>>     struct kvm_fpu {
>>   	__u8  fpr[8][16];
>>   	__u16 fcw;
>> @@ -790,6 +814,16 @@ Writes the floating point state to the vcpu.
>>   	__u32 pad2;
>>     };
>>   
>> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
>> +  struct kvm_fpu {
>> +        __u32 fcsr;
>> +        __u32 none;
>> +        __u64 fcc;
>> +        struct kvm_fpureg {
>> +                __u64 val64[4];
>> +        }fpr[32];
>> +  };
>> +
>>   
>>   4.24 KVM_CREATE_IRQCHIP
>>   -----------------------
>> @@ -1387,7 +1421,7 @@ documentation when it pops into existence).
>>   -------------------
>>   
>>   :Capability: KVM_CAP_ENABLE_CAP
>> -:Architectures: mips, ppc, s390, x86
>> +:Architectures: mips, ppc, s390, x86, loongarch
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_enable_cap (in)
>>   :Returns: 0 on success; -1 on error
>> @@ -1442,7 +1476,7 @@ for vm-wide capabilities.
>>   ---------------------
>>   
>>   :Capability: KVM_CAP_MP_STATE
>> -:Architectures: x86, s390, arm64, riscv
>> +:Architectures: x86, s390, arm64, riscv, loongarch
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_mp_state (out)
>>   :Returns: 0 on success; -1 on error
>> @@ -1460,7 +1494,7 @@ Possible values are:
>>   
>>      ==========================    ===============================================
>>      KVM_MP_STATE_RUNNABLE         the vcpu is currently running
>> -                                 [x86,arm64,riscv]
>> +                                 [x86,arm64,riscv,loongarch]
>>      KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
>>                                    which has not yet received an INIT signal [x86]
>>      KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
>> @@ -1516,11 +1550,14 @@ For riscv:
>>   The only states that are valid are KVM_MP_STATE_STOPPED and
>>   KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
>>
>> +On LoongArch, the KVM_MP_STATE_RUNNABLE state is only used which reflect the
>> +vcpu is runnable.
> There seems to be a grammatical error here.  The original sentence uses
> "which" to connect two clauses, but lacks a subject to introduce the
> second clause.  I think we should correct it like this,
>
> "On LoongArch, the KVM_MP_STATE_RUNNABLE state is only used to reflect
> whether the vcpu is runnable."
Thanks very much, I will fix the grammatical error in this sentence.

Thanks
Tianrui Zhao
>
>> +
>>   4.39 KVM_SET_MP_STATE
>>   ---------------------
>>   
>>   :Capability: KVM_CAP_MP_STATE
>> -:Architectures: x86, s390, arm64, riscv
>> +:Architectures: x86, s390, arm64, riscv, loongarch
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_mp_state (in)
>>   :Returns: 0 on success; -1 on error
>> @@ -1538,6 +1575,9 @@ For arm64/riscv:
>>   The only states that are valid are KVM_MP_STATE_STOPPED and
>>   KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
>>
>
>> +On LoongArch, the KVM_MP_STATE_RUNNABLE state is only used which reflect the
>> +vcpu is runnable.
> Likewise here.
>
> WDYT?
>
> Thanks,
> Enze
Thanks, I will fix it too.

Thanks
Tianrui Zhao
>
>> +
>>   4.40 KVM_SET_IDENTITY_MAP_ADDR
>>   ------------------------------
>>   
>> @@ -2839,6 +2879,19 @@ Following are the RISC-V D-extension registers:
>>     0x8020 0000 0600 0020 fcsr      Floating point control and status register
>>   ======================= ========= =============================================
>>   
>> +LoongArch registers are mapped using the lower 32 bits. The upper 16 bits of
>> +that is the register group type.
>> +
>> +LoongArch csr registers are used to control guest cpu or get status of guest
>> +cpu, and they have the following id bit patterns::
>> +
>> +  0x9030 0000 0001 00 <reg:5> <sel:3>   (64-bit)
>> +
>> +LoongArch KVM control registers are used to implement some new defined functions
>> +such as set vcpu counter or reset vcpu, and they have the following id bit patterns::
>> +
>> +  0x9030 0000 0002 <reg:16>
>> +
>>   
>>   4.69 KVM_GET_ONE_REG
>>   --------------------

