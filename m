Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8079073F7B0
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjF0IqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjF0IqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:46:00 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A3D4B8;
        Tue, 27 Jun 2023 01:45:56 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8CxI_DDoZpklvYCAA--.4517S3;
        Tue, 27 Jun 2023 16:45:55 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c7CoZpkSbALAA--.48080S3;
        Tue, 27 Jun 2023 16:45:54 +0800 (CST)
Message-ID: <7a36eb72-52dd-df51-db16-05c24241b82e@loongson.cn>
Date:   Tue, 27 Jun 2023 16:45:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v15 05/30] LoongArch: KVM: Add vcpu related header files
Content-Language: en-US
To:     WANG Xuerui <kernel@xen0n.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn,
        Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
 <20230626084752.1138621-6-zhaotianrui@loongson.cn>
 <18bc1f6b-5299-2628-82b7-55f3848e856a@xen0n.name>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <18bc1f6b-5299-2628-82b7-55f3848e856a@xen0n.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cx_c7CoZpkSbALAA--.48080S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Xw1fGw4fWFyftF4DKw1DCFX_yoW7KF4fp3
        WkArn8GrWUGrs7Jw45t3W5tryUJr18G34UWry7XFyUAr1UXry0qr1jgrs0gw1UXws5Jr1j
        qr1UXw15ur4UJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUU
        UU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/6/27 16:19, WANG Xuerui 写道:
> On 2023/6/26 16:47, Tianrui Zhao wrote:
>> Add LoongArch vcpu related header files, including vcpu csr
>> information, irq number defines, and some vcpu interfaces.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/insn-def.h  |  55 ++++++
>>   arch/loongarch/include/asm/kvm_csr.h   | 231 +++++++++++++++++++++++++
>>   arch/loongarch/include/asm/kvm_vcpu.h  |  97 +++++++++++
>>   arch/loongarch/include/asm/loongarch.h |  20 ++-
>>   arch/loongarch/kvm/trace.h             | 168 ++++++++++++++++++
>>   5 files changed, 566 insertions(+), 5 deletions(-)
>>   create mode 100644 arch/loongarch/include/asm/insn-def.h
>>   create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>>   create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>>   create mode 100644 arch/loongarch/kvm/trace.h
>>
>> diff --git a/arch/loongarch/include/asm/insn-def.h b/arch/loongarch/include/asm/insn-def.h
>> new file mode 100644
>> index 000000000000..e285ee108fb0
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/insn-def.h
>> @@ -0,0 +1,55 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +
>> +#ifndef __ASM_INSN_DEF_H
>> +#define __ASM_INSN_DEF_H
>> +
>> +#include <linux/stringify.h>
>> +#include <asm/gpr-num.h>
>> +#include <asm/asm.h>
>> +
>> +#define INSN_STR(x)        __stringify(x)
>> +#define CSR_RD_SHIFT        0
>> +#define CSR_RJ_SHIFT        5
>> +#define CSR_SIMM14_SHIFT    10
>> +#define CSR_OPCODE_SHIFT    24
>> +
>> +#define DEFINE_INSN_CSR                            \
>> +    __DEFINE_ASM_GPR_NUMS                        \
>> +"    .macro insn_csr, opcode, rj, rd, simm14\n"            \
>> +"    .4byte    ((\\opcode << " INSN_STR(CSR_OPCODE_SHIFT) ") |"    \
>> +"         (.L__gpr_num_\\rj << " INSN_STR(CSR_RJ_SHIFT) ") |"    \
>> +"         (.L__gpr_num_\\rd << " INSN_STR(CSR_RD_SHIFT) ") |"    \
>> +"         (\\simm14 << " INSN_STR(CSR_SIMM14_SHIFT) "))\n"    \
>> +"    .endm\n"
>> +
>> +#define UNDEFINE_INSN_CSR                        \
>> +"    .purgem insn_csr\n"
>> +
>> +#define __INSN_CSR(opcode, rj, rd, simm14)                \
>> +    DEFINE_INSN_CSR                            \
>> +    "insn_csr " opcode ", " rj ", " rd ", " simm14 "\n"        \
>> +    UNDEFINE_INSN_CSR
>> +
>> +
>> +#define INSN_CSR(opcode, rj, rd, simm14)                \
>> +    __INSN_CSR(LARCH_##opcode, LARCH_##rj, LARCH_##rd,        \
>> +           LARCH_##simm14)
>> +
>> +#define __ASM_STR(x)        #x
>> +#define LARCH_OPCODE(v)        __ASM_STR(v)
>> +#define LARCH_SIMM14(v)        __ASM_STR(v)
>> +#define __LARCH_REG(v)        __ASM_STR(v)
>> +#define LARCH___RD(v)        __LARCH_REG(v)
>> +#define LARCH___RJ(v)        __LARCH_REG(v)
>> +#define LARCH_OPCODE_GCSR    LARCH_OPCODE(5)
>> +
>> +#define GCSR_read(csr, rd)                        \
>> +    INSN_CSR(OPCODE_GCSR, __RJ(zero), __RD(rd), SIMM14(csr))
>> +
>> +#define GCSR_write(csr, rd)                        \
>> +    INSN_CSR(OPCODE_GCSR, __RJ($r1), __RD(rd), SIMM14(csr))
>> +
>> +#define GCSR_xchg(csr, rj, rd)                        \
>> +    INSN_CSR(OPCODE_GCSR, __RJ(rj), __RD(rd), SIMM14(csr))
>> +
>> +#endif /* __ASM_INSN_DEF_H */
> 
> I still find this unnecessarily complex. First of all this is reinventing infra that's already available as the "parse_r" helper (check out include/asm/tlb.h in v6.4), but the only usage of the helper has just been removed, so it's probably a signal saying this practice may not last for long -- people are no longer in a situation like back in the MIPS era when toolchain support are not guaranteed (or even allowed upstream).
> 
> Secondly, while support for older compilers is nice-to-have, but users of upstream kernels also already effectively depend on very recent toolchains (if not bleeding-edge). So we can just probe for support and just use proper mnemonics and automatically get support soon, because we can expect most of them to pick up upstream changes very quickly. That's to say, if we have something like:
> 
> # arch/loongarch/Kconfig
> config LOONGARCH
>     # ...
>     select HAVE_KVM if AS_HAS_LVZ_EXTENSION
No, I do not think so. It is a bad idea, by this way kvm module will be disabled until there is proper gcc version.
The popular gcc12/gcc13 does not support AS_HAS_LVZ_EXTENSION, kvm modules will be disabled with general gcc, may be useful for future gcc. what is detailed date for future gcc?

The existing patch can work on all gcc version. If the piece of code does not support generic gcc, why we post the patch now? It is just post a bunch of usefulness code with your method.

Regards
Bibo Mao
> 
> config AS_HAS_LVZ_EXTENSION
>     def_bool $(as-instr,gcsrrd \$t0$(comma)\$t1$(comma)123)
> 
> Then support is guaranteed for all KVM code and this cruft can go away, and then the feature will likely be available in a few months.
> 
> FYI, support for LSX and LASX instructions are already posted by your fellow toolchain folks [1], so it's 100% doable for them to add support despite the manuals not being available yet. Just coordinate with them a bit...
> 
> [1]: https://sourceware.org/pipermail/binutils/2023-June/127990.html
> 

