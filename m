Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032BF732555
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 04:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbjFPCjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 22:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241149AbjFPCjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:39:19 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C3F02D4F;
        Thu, 15 Jun 2023 19:39:17 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8Cx_epUy4tkOM0FAA--.12512S3;
        Fri, 16 Jun 2023 10:39:16 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxJeRRy4tkS8YcAA--.16434S3;
        Fri, 16 Jun 2023 10:39:13 +0800 (CST)
Subject: Re: [PATCH v13 29/30] LoongArch: KVM: Supplement kvm document about
 LoongArch-specific part
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
 <20230609090832.2131037-30-zhaotianrui@loongson.cn>
 <CAAhV-H4rzRZQpfxFBANFJyUshsNHYqmZmLnZfHA+McPyQ3m4-w@mail.gmail.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <749abd01-c717-3a4c-238e-cda1bb74f25c@loongson.cn>
Date:   Fri, 16 Jun 2023 10:39:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4rzRZQpfxFBANFJyUshsNHYqmZmLnZfHA+McPyQ3m4-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8AxJeRRy4tkS8YcAA--.16434S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3GryDAFy8tr4kJrWrKw45urX_yoWxAryDpF
        ZayaySgr4vqryxt347t34jgryak397tF47G3Wrtr18C3Wjyr18Jr1qqrW8GFWDCrykAF18
        AF18t3ZxCFW5ArXCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
        6r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUU
        U==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/6/15 下午5:42, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Fri, Jun 9, 2023 at 5:09 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
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
>> index add067793b90..ad8e13eab48d 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -416,6 +416,12 @@ Reads the general purpose registers from the vcpu.
>>          __u64 pc;
>>     };
>>
>> +  /* LoongArch */
>> +  struct kvm_regs {
> Add a " /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */" line as others here?

Thanks, I will add this comment here.

Tianrui Zhao

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
>>          __u8  fpr[8][16];
>>          __u16 fcw;
>> @@ -761,12 +775,22 @@ Reads the floating point state from the vcpu.
>>          __u32 pad2;
>>     };
>>
>> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
>> +  struct kvm_fpu {
>> +        __u32 fcsr;
>> +        __u32 none;
> Maybe use pad1 as x86 is better.
>
> Huacai

Thanks, this 'none' variable is meaningless, and I will remove it. As 
this have already been removed in the actually kvm_fpu structure.

Tianrui Zhao

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
>>          __u8  fpr[8][16];
>>          __u16 fcw;
>> @@ -790,6 +814,16 @@ Writes the floating point state to the vcpu.
>>          __u32 pad2;
>>     };
>>
>> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
>> +  struct kvm_fpu {
>> +        __u32 fcsr;
>> +        __u32 none;

I will also remove this 'none' variable.

Tianrui Zhao

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
>> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
>> +whether the vcpu is runnable.
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
>> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
>> +whether the vcpu is runnable.
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
>> --
>> 2.39.1
>>
>>

