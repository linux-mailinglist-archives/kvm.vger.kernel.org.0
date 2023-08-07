Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3787B77179E
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 03:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjHGA6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 20:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjHGA6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 20:58:19 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC20C1707;
        Sun,  6 Aug 2023 17:58:13 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8BxyeqjQdBkqrsRAA--.30279S3;
        Mon, 07 Aug 2023 08:58:11 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxviOeQdBkBH1MAA--.22287S3;
        Mon, 07 Aug 2023 08:58:06 +0800 (CST)
Message-ID: <7984d6c7-4dd6-cc00-4c01-2fa1dfd468a6@loongson.cn>
Date:   Mon, 7 Aug 2023 08:58:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v18 05/30] LoongArch: KVM: Add vcpu related header files
To:     Chen Linxuan <chenlinxuan@uniontech.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>,
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
References: <20230803022138.2736430-1-zhaotianrui@loongson.cn>
 <20230803022138.2736430-6-zhaotianrui@loongson.cn>
 <367239C38ED9D19C+9ef16061-9057-482c-bd8c-0b9ede71cfa7@uniontech.com>
Content-Language: en-US
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <367239C38ED9D19C+9ef16061-9057-482c-bd8c-0b9ede71cfa7@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxviOeQdBkBH1MAA--.22287S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoWfXF4rKF18WrW7AF18Aw4UKFX_yoWrGFy8Ao
        WUGF13Jr15Jw1UKr4UGry7Xw15Jr15Gr4DJr15GryxJw1UJr1UX3yUJrWjq3y5Jry0gw1U
        Jr1UXFyDZFyUAw15l-sFpf9Il3svdjkaLaAFLSUrUUUU5b8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUO17kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUGVWUXwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4j6r4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
        WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1q6r43MI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8aFAJUUUU
        U==
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/8/6 14:46, Chen Linxuan 写道:
> I notice that v18 is released. So I resend my comment on v17 again.
> 
> On 2023/8/3 10:21, Tianrui Zhao wrote:
>> Add LoongArch vcpu related header files, including vcpu csr
>> information, irq number defines, and some vcpu interfaces.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/insn-def.h  |  55 ++++++
>>   arch/loongarch/include/asm/kvm_csr.h   | 252 +++++++++++++++++++++++++
>>   arch/loongarch/include/asm/kvm_vcpu.h  |  95 ++++++++++
>>   arch/loongarch/include/asm/loongarch.h |  20 +-
>>   arch/loongarch/kvm/trace.h             | 168 +++++++++++++++++
>>   5 files changed, 585 insertions(+), 5 deletions(-)
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
> 
> I want to continue the discussion in v16 here.
> 
> Just as what Huacai Chen and WANG Xuerui described before,
> I believe that whatever distros pick the kernel release contain this feature will be able to use the new toolchain baseline, just as what deepin is doing now.
> 
> That situation you describe before in which a distro support loongarch using such new kernel release somehow won't be able to use a new toolchain seems to be never going to happen in real world.

Hi Linxuan,

Thanks for caring about LoongArch kvm. Currently there is no popular OS distos
supporting LoongArch. I list some popular projects about kernel.
1. project kernelci, website locates at https://linux.kernelci.org/build/, gcc version
is 10, it does not support LoongArch kernel at all.

2. project LKP, its website located at https://download.01.org/0day-ci/cross-package/
the latest gcc version is gcc 12.3, it supports LoongArch kernel for CI builing test,
however it does not support LAS/LASX/LVZ since it depends on binutils version larger than 2.41

3. Fedora38 x86, there is cross-compliling packages for LoongArch with gcc 13.1 and
binutils 2.39. I always use it to compile UEFI bios and do simple ci test together with
qemu for different arches like arm64 and LoongArch.  The cross-compliling packages also
do not support  LAS/LASX/LVZ assemble language neither.

Since we all know that LoongArch ecosystem is poor, why do not we make use of existing
projects which supports LoongArch already?

Regards
Bibo Mao

> 
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
>> diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/include/asm/kvm_csr.h
>> new file mode 100644
>> index 000000000000..34483bbaec15
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_csr.h
>> @@ -0,0 +1,252 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#ifndef __ASM_LOONGARCH_KVM_CSR_H__
>> +#define __ASM_LOONGARCH_KVM_CSR_H__
>> +#include <asm/loongarch.h>
>> +#include <asm/kvm_vcpu.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#ifdef CONFIG_AS_HAS_LVZ_EXTENSION
>> +/* binutils support virtualization instructions */
>> +#define gcsr_read(csr)                        \
>> +({                                \
>> +    register unsigned long __v;                \
>> +    __asm__ __volatile__(                    \
>> +        " gcsrrd %[val], %[reg]\n\t"            \
>> +        : [val] "=r" (__v)                \
>> +        : [reg] "i" (csr)                \
>> +        : "memory");                    \
>> +    __v;                            \
>> +})
>> +
>> +#define gcsr_write(v, csr)                    \
>> +({                                \
>> +    register unsigned long __v = v;                \
>> +    __asm__ __volatile__ (                    \
>> +        " gcsrwr %[val], %[reg]\n\t"            \
>> +        : [val] "+r" (__v)                \
>> +        : [reg] "i" (csr)                \
>> +        : "memory");                    \
>> +})
>> +
>> +#define gcsr_xchg(v, m, csr)                    \
>> +({                                \
>> +    register unsigned long __v = v;                \
>> +    __asm__ __volatile__(                    \
>> +        " gcsrxchg %[val], %[mask], %[reg]\n\t"        \
>> +        : [val] "+r" (__v)                \
>> +        : [mask] "r" (m), [reg] "i" (csr)        \
>> +        : "memory");                    \
>> +    __v;                            \
>> +})
>> +#else
>> +/* binutils do not support virtualization instructions */
>> +#define gcsr_read(csr)                        \
>> +({                                \
>> +    register unsigned long __v;                \
>> +    __asm__ __volatile__ (GCSR_read(csr, %0)        \
>> +                : "=r" (__v) :            \
>> +                : "memory");            \
>> +    __v;                            \
>> +})
>> +
>> +#define gcsr_write(val, csr)                    \
>> +({                                \
>> +    register unsigned long __v = val;            \
>> +    __asm__ __volatile__ (GCSR_write(csr, %0)        \
>> +                : "+r" (__v) :            \
>> +                : "memory");            \
>> +})
>> +
>> +#define gcsr_xchg(val, mask, csr)                \
>> +({                                \
>> +    register unsigned long __v = val;            \
>> +    __asm__ __volatile__ (GCSR_xchg(csr, %1, %0)        \
>> +                : "+r" (__v)            \
>> +                : "r"  (mask)            \
>> +                : "memory");            \
>> +    __v;                            \
>> +})
>> +#endif
>> +
>> +/* Guest CSRS read and write */
>> +#define read_gcsr_crmd()        gcsr_read(LOONGARCH_CSR_CRMD)
>> +#define write_gcsr_crmd(val)        gcsr_write(val, LOONGARCH_CSR_CRMD)
>> +#define read_gcsr_prmd()        gcsr_read(LOONGARCH_CSR_PRMD)
>> +#define write_gcsr_prmd(val)        gcsr_write(val, LOONGARCH_CSR_PRMD)
>> +#define read_gcsr_euen()        gcsr_read(LOONGARCH_CSR_EUEN)
>> +#define write_gcsr_euen(val)        gcsr_write(val, LOONGARCH_CSR_EUEN)
>> +#define read_gcsr_misc()        gcsr_read(LOONGARCH_CSR_MISC)
>> +#define write_gcsr_misc(val)        gcsr_write(val, LOONGARCH_CSR_MISC)
>> +#define read_gcsr_ecfg()        gcsr_read(LOONGARCH_CSR_ECFG)
>> +#define write_gcsr_ecfg(val)        gcsr_write(val, LOONGARCH_CSR_ECFG)
>> +#define read_gcsr_estat()        gcsr_read(LOONGARCH_CSR_ESTAT)
>> +#define write_gcsr_estat(val)        gcsr_write(val, LOONGARCH_CSR_ESTAT)
>> +#define read_gcsr_era()            gcsr_read(LOONGARCH_CSR_ERA)
>> +#define write_gcsr_era(val)        gcsr_write(val, LOONGARCH_CSR_ERA)
>> +#define read_gcsr_badv()        gcsr_read(LOONGARCH_CSR_BADV)
>> +#define write_gcsr_badv(val)        gcsr_write(val, LOONGARCH_CSR_BADV)
>> +#define read_gcsr_badi()        gcsr_read(LOONGARCH_CSR_BADI)
>> +#define write_gcsr_badi(val)        gcsr_write(val, LOONGARCH_CSR_BADI)
>> +#define read_gcsr_eentry()        gcsr_read(LOONGARCH_CSR_EENTRY)
>> +#define write_gcsr_eentry(val)        gcsr_write(val, LOONGARCH_CSR_EENTRY)
>> +
>> +#define read_gcsr_tlbidx()        gcsr_read(LOONGARCH_CSR_TLBIDX)
>> +#define write_gcsr_tlbidx(val)        gcsr_write(val, LOONGARCH_CSR_TLBIDX)
>> +#define read_gcsr_tlbhi()        gcsr_read(LOONGARCH_CSR_TLBEHI)
>> +#define write_gcsr_tlbhi(val)        gcsr_write(val, LOONGARCH_CSR_TLBEHI)
>> +#define read_gcsr_tlblo0()        gcsr_read(LOONGARCH_CSR_TLBELO0)
>> +#define write_gcsr_tlblo0(val)        gcsr_write(val, LOONGARCH_CSR_TLBELO0)
>> +#define read_gcsr_tlblo1()        gcsr_read(LOONGARCH_CSR_TLBELO1)
>> +#define write_gcsr_tlblo1(val)        gcsr_write(val, LOONGARCH_CSR_TLBELO1)
>> +
>> +#define read_gcsr_asid()        gcsr_read(LOONGARCH_CSR_ASID)
>> +#define write_gcsr_asid(val)        gcsr_write(val, LOONGARCH_CSR_ASID)
>> +#define read_gcsr_pgdl()        gcsr_read(LOONGARCH_CSR_PGDL)
>> +#define write_gcsr_pgdl(val)        gcsr_write(val, LOONGARCH_CSR_PGDL)
>> +#define read_gcsr_pgdh()        gcsr_read(LOONGARCH_CSR_PGDH)
>> +#define write_gcsr_pgdh(val)        gcsr_write(val, LOONGARCH_CSR_PGDH)
>> +#define write_gcsr_pgd(val)        gcsr_write(val, LOONGARCH_CSR_PGD)
>> +#define read_gcsr_pgd()            gcsr_read(LOONGARCH_CSR_PGD)
>> +#define read_gcsr_pwctl0()        gcsr_read(LOONGARCH_CSR_PWCTL0)
>> +#define write_gcsr_pwctl0(val)        gcsr_write(val, LOONGARCH_CSR_PWCTL0)
>> +#define read_gcsr_pwctl1()        gcsr_read(LOONGARCH_CSR_PWCTL1)
>> +#define write_gcsr_pwctl1(val)        gcsr_write(val, LOONGARCH_CSR_PWCTL1)
>> +#define read_gcsr_stlbpgsize()        gcsr_read(LOONGARCH_CSR_STLBPGSIZE)
>> +#define write_gcsr_stlbpgsize(val)    gcsr_write(val, LOONGARCH_CSR_STLBPGSIZE)
>> +#define read_gcsr_rvacfg()        gcsr_read(LOONGARCH_CSR_RVACFG)
>> +#define write_gcsr_rvacfg(val)        gcsr_write(val, LOONGARCH_CSR_RVACFG)
>> +
>> +#define read_gcsr_cpuid()        gcsr_read(LOONGARCH_CSR_CPUID)
>> +#define write_gcsr_cpuid(val)        gcsr_write(val, LOONGARCH_CSR_CPUID)
>> +#define read_gcsr_prcfg1()        gcsr_read(LOONGARCH_CSR_PRCFG1)
>> +#define write_gcsr_prcfg1(val)        gcsr_write(val, LOONGARCH_CSR_PRCFG1)
>> +#define read_gcsr_prcfg2()        gcsr_read(LOONGARCH_CSR_PRCFG2)
>> +#define write_gcsr_prcfg2(val)        gcsr_write(val, LOONGARCH_CSR_PRCFG2)
>> +#define read_gcsr_prcfg3()        gcsr_read(LOONGARCH_CSR_PRCFG3)
>> +#define write_gcsr_prcfg3(val)        gcsr_write(val, LOONGARCH_CSR_PRCFG3)
>> +
>> +#define read_gcsr_kscratch0()        gcsr_read(LOONGARCH_CSR_KS0)
>> +#define write_gcsr_kscratch0(val)    gcsr_write(val, LOONGARCH_CSR_KS0)
>> +#define read_gcsr_kscratch1()        gcsr_read(LOONGARCH_CSR_KS1)
>> +#define write_gcsr_kscratch1(val)    gcsr_write(val, LOONGARCH_CSR_KS1)
>> +#define read_gcsr_kscratch2()        gcsr_read(LOONGARCH_CSR_KS2)
>> +#define write_gcsr_kscratch2(val)    gcsr_write(val, LOONGARCH_CSR_KS2)
>> +#define read_gcsr_kscratch3()        gcsr_read(LOONGARCH_CSR_KS3)
>> +#define write_gcsr_kscratch3(val)    gcsr_write(val, LOONGARCH_CSR_KS3)
>> +#define read_gcsr_kscratch4()        gcsr_read(LOONGARCH_CSR_KS4)
>> +#define write_gcsr_kscratch4(val)    gcsr_write(val, LOONGARCH_CSR_KS4)
>> +#define read_gcsr_kscratch5()        gcsr_read(LOONGARCH_CSR_KS5)
>> +#define write_gcsr_kscratch5(val)    gcsr_write(val, LOONGARCH_CSR_KS5)
>> +#define read_gcsr_kscratch6()        gcsr_read(LOONGARCH_CSR_KS6)
>> +#define write_gcsr_kscratch6(val)    gcsr_write(val, LOONGARCH_CSR_KS6)
>> +#define read_gcsr_kscratch7()        gcsr_read(LOONGARCH_CSR_KS7)
>> +#define write_gcsr_kscratch7(val)    gcsr_write(val, LOONGARCH_CSR_KS7)
>> +
>> +#define read_gcsr_timerid()        gcsr_read(LOONGARCH_CSR_TMID)
>> +#define write_gcsr_timerid(val)        gcsr_write(val, LOONGARCH_CSR_TMID)
>> +#define read_gcsr_timercfg()        gcsr_read(LOONGARCH_CSR_TCFG)
>> +#define write_gcsr_timercfg(val)    gcsr_write(val, LOONGARCH_CSR_TCFG)
>> +#define read_gcsr_timertick()        gcsr_read(LOONGARCH_CSR_TVAL)
>> +#define write_gcsr_timertick(val)    gcsr_write(val, LOONGARCH_CSR_TVAL)
>> +#define read_gcsr_timeroffset()        gcsr_read(LOONGARCH_CSR_CNTC)
>> +#define write_gcsr_timeroffset(val)    gcsr_write(val, LOONGARCH_CSR_CNTC)
>> +
>> +#define read_gcsr_llbctl()        gcsr_read(LOONGARCH_CSR_LLBCTL)
>> +#define write_gcsr_llbctl(val)        gcsr_write(val, LOONGARCH_CSR_LLBCTL)
>> +
>> +#define read_gcsr_tlbrentry()        gcsr_read(LOONGARCH_CSR_TLBRENTRY)
>> +#define write_gcsr_tlbrentry(val)    gcsr_write(val, LOONGARCH_CSR_TLBRENTRY)
>> +#define read_gcsr_tlbrbadv()        gcsr_read(LOONGARCH_CSR_TLBRBADV)
>> +#define write_gcsr_tlbrbadv(val)    gcsr_write(val, LOONGARCH_CSR_TLBRBADV)
>> +#define read_gcsr_tlbrera()        gcsr_read(LOONGARCH_CSR_TLBRERA)
>> +#define write_gcsr_tlbrera(val)        gcsr_write(val, LOONGARCH_CSR_TLBRERA)
>> +#define read_gcsr_tlbrsave()        gcsr_read(LOONGARCH_CSR_TLBRSAVE)
>> +#define write_gcsr_tlbrsave(val)    gcsr_write(val, LOONGARCH_CSR_TLBRSAVE)
>> +#define read_gcsr_tlbrelo0()        gcsr_read(LOONGARCH_CSR_TLBRELO0)
>> +#define write_gcsr_tlbrelo0(val)    gcsr_write(val, LOONGARCH_CSR_TLBRELO0)
>> +#define read_gcsr_tlbrelo1()        gcsr_read(LOONGARCH_CSR_TLBRELO1)
>> +#define write_gcsr_tlbrelo1(val)    gcsr_write(val, LOONGARCH_CSR_TLBRELO1)
>> +#define read_gcsr_tlbrehi()        gcsr_read(LOONGARCH_CSR_TLBREHI)
>> +#define write_gcsr_tlbrehi(val)        gcsr_write(val, LOONGARCH_CSR_TLBREHI)
>> +#define read_gcsr_tlbrprmd()        gcsr_read(LOONGARCH_CSR_TLBRPRMD)
>> +#define write_gcsr_tlbrprmd(val)    gcsr_write(val, LOONGARCH_CSR_TLBRPRMD)
>> +
>> +#define read_gcsr_directwin0()        gcsr_read(LOONGARCH_CSR_DMWIN0)
>> +#define write_gcsr_directwin0(val)    gcsr_write(val, LOONGARCH_CSR_DMWIN0)
>> +#define read_gcsr_directwin1()        gcsr_read(LOONGARCH_CSR_DMWIN1)
>> +#define write_gcsr_directwin1(val)    gcsr_write(val, LOONGARCH_CSR_DMWIN1)
>> +#define read_gcsr_directwin2()        gcsr_read(LOONGARCH_CSR_DMWIN2)
>> +#define write_gcsr_directwin2(val)    gcsr_write(val, LOONGARCH_CSR_DMWIN2)
>> +#define read_gcsr_directwin3()        gcsr_read(LOONGARCH_CSR_DMWIN3)
>> +#define write_gcsr_directwin3(val)    gcsr_write(val, LOONGARCH_CSR_DMWIN3)
>> +
>> +/* Guest related CSRs */
>> +#define read_csr_gtlbc()        csr_read64(LOONGARCH_CSR_GTLBC)
>> +#define write_csr_gtlbc(val)        csr_write64(val, LOONGARCH_CSR_GTLBC)
>> +#define read_csr_trgp()            csr_read64(LOONGARCH_CSR_TRGP)
>> +#define read_csr_gcfg()            csr_read64(LOONGARCH_CSR_GCFG)
>> +#define write_csr_gcfg(val)        csr_write64(val, LOONGARCH_CSR_GCFG)
>> +#define read_csr_gstat()        csr_read64(LOONGARCH_CSR_GSTAT)
>> +#define write_csr_gstat(val)        csr_write64(val, LOONGARCH_CSR_GSTAT)
>> +#define read_csr_gintc()        csr_read64(LOONGARCH_CSR_GINTC)
>> +#define write_csr_gintc(val)        csr_write64(val, LOONGARCH_CSR_GINTC)
>> +#define read_csr_gcntc()        csr_read64(LOONGARCH_CSR_GCNTC)
>> +#define write_csr_gcntc(val)        csr_write64(val, LOONGARCH_CSR_GCNTC)
>> +
>> +#define __BUILD_GCSR_OP(name)        __BUILD_CSR_COMMON(gcsr_##name)
>> +
>> +__BUILD_GCSR_OP(llbctl)
>> +__BUILD_GCSR_OP(tlbidx)
>> +__BUILD_CSR_OP(gcfg)
>> +__BUILD_CSR_OP(gstat)
>> +__BUILD_CSR_OP(gtlbc)
>> +__BUILD_CSR_OP(gintc)
>> +
>> +#define set_gcsr_estat(val)    \
>> +    gcsr_xchg(val, val, LOONGARCH_CSR_ESTAT)
>> +#define clear_gcsr_estat(val)    \
>> +    gcsr_xchg(~(val), val, LOONGARCH_CSR_ESTAT)
>> +
>> +#define kvm_read_hw_gcsr(id)        gcsr_read(id)
>> +#define kvm_write_hw_gcsr(csr, id, val)    gcsr_write(val, id)
>> +
>> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v);
>> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 v);
>> +
>> +int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +
>> +#define kvm_save_hw_gcsr(csr, gid)    (csr->csrs[gid] = gcsr_read(gid))
>> +#define kvm_restore_hw_gcsr(csr, gid)    (gcsr_write(csr->csrs[gid], gid))
>> +
>> +static __always_inline unsigned long kvm_read_sw_gcsr(struct loongarch_csrs *csr, int gid)
>> +{
>> +    return csr->csrs[gid];
>> +}
>> +
>> +static __always_inline void kvm_write_sw_gcsr(struct loongarch_csrs *csr,
>> +                          int gid, unsigned long val)
>> +{
>> +    csr->csrs[gid] = val;
>> +}
>> +
>> +static __always_inline void kvm_set_sw_gcsr(struct loongarch_csrs *csr,
>> +                        int gid, unsigned long val)
>> +{
>> +    csr->csrs[gid] |= val;
>> +}
>> +
>> +static __always_inline void kvm_change_sw_gcsr(struct loongarch_csrs *csr,
>> +                           int gid, unsigned long mask,
>> +                           unsigned long val)
>> +{
>> +    unsigned long _mask = mask;
>> +
>> +    csr->csrs[gid] &= ~_mask;
>> +    csr->csrs[gid] |= val & _mask;
>> +}
>> +#endif    /* __ASM_LOONGARCH_KVM_CSR_H__ */
>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>> new file mode 100644
>> index 000000000000..3d23a656fea3
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>> @@ -0,0 +1,95 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#ifndef __ASM_LOONGARCH_KVM_VCPU_H__
>> +#define __ASM_LOONGARCH_KVM_VCPU_H__
>> +
>> +#include <linux/kvm_host.h>
>> +#include <asm/loongarch.h>
>> +
>> +/* Controlled by 0x5 guest exst */
>> +#define CPU_SIP0            (_ULCAST_(1))
>> +#define CPU_SIP1            (_ULCAST_(1) << 1)
>> +#define CPU_PMU                (_ULCAST_(1) << 10)
>> +#define CPU_TIMER            (_ULCAST_(1) << 11)
>> +#define CPU_IPI                (_ULCAST_(1) << 12)
>> +
>> +/* Controlled by 0x52 guest exception VIP
>> + * aligned to exst bit 5~12
>> + */
>> +#define CPU_IP0                (_ULCAST_(1))
>> +#define CPU_IP1                (_ULCAST_(1) << 1)
>> +#define CPU_IP2                (_ULCAST_(1) << 2)
>> +#define CPU_IP3                (_ULCAST_(1) << 3)
>> +#define CPU_IP4                (_ULCAST_(1) << 4)
>> +#define CPU_IP5                (_ULCAST_(1) << 5)
>> +#define CPU_IP6                (_ULCAST_(1) << 6)
>> +#define CPU_IP7                (_ULCAST_(1) << 7)
>> +
>> +#define MNSEC_PER_SEC            (NSEC_PER_SEC >> 20)
>> +
>> +/* KVM_IRQ_LINE irq field index values */
>> +#define KVM_LOONGSON_IRQ_TYPE_SHIFT    24
>> +#define KVM_LOONGSON_IRQ_TYPE_MASK    0xff
>> +#define KVM_LOONGSON_IRQ_VCPU_SHIFT    16
>> +#define KVM_LOONGSON_IRQ_VCPU_MASK    0xff
>> +#define KVM_LOONGSON_IRQ_NUM_SHIFT    0
>> +#define KVM_LOONGSON_IRQ_NUM_MASK    0xffff
>> +
>> +/* Irq_type field */
>> +#define KVM_LOONGSON_IRQ_TYPE_CPU_IP    0
>> +#define KVM_LOONGSON_IRQ_TYPE_CPU_IO    1
>> +#define KVM_LOONGSON_IRQ_TYPE_HT    2
>> +#define KVM_LOONGSON_IRQ_TYPE_MSI    3
>> +#define KVM_LOONGSON_IRQ_TYPE_IOAPIC    4
>> +#define KVM_LOONGSON_IRQ_TYPE_ROUTE    5
>> +
>> +/* Out-of-kernel GIC cpu interrupt injection irq_number field */
>> +#define KVM_LOONGSON_IRQ_CPU_IRQ    0
>> +#define KVM_LOONGSON_IRQ_CPU_FIQ    1
>> +#define KVM_LOONGSON_CPU_IP_NUM        8
>> +
>> +typedef union loongarch_instruction  larch_inst;
>> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
>> +
>> +int  _kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst);
>> +int  _kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst);
>> +int  _kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int  _kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int  _kvm_emu_idle(struct kvm_vcpu *vcpu);
>> +int  _kvm_handle_pv_hcall(struct kvm_vcpu *vcpu);
>> +int  _kvm_pending_timer(struct kvm_vcpu *vcpu);
>> +int  _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault);
>> +void _kvm_deliver_intr(struct kvm_vcpu *vcpu);
>> +
>> +void kvm_own_fpu(struct kvm_vcpu *vcpu);
>> +void kvm_lose_fpu(struct kvm_vcpu *vcpu);
>> +void kvm_save_fpu(struct loongarch_fpu *fpu);
>> +void kvm_restore_fpu(struct loongarch_fpu *fpu);
>> +void kvm_restore_fcsr(struct loongarch_fpu *fpu);
>> +
>> +void kvm_acquire_timer(struct kvm_vcpu *vcpu);
>> +void kvm_reset_timer(struct kvm_vcpu *vcpu);
>> +void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>> +void kvm_restore_timer(struct kvm_vcpu *vcpu);
>> +void kvm_save_timer(struct kvm_vcpu *vcpu);
>> +
>> +int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq);
>> +/*
>> + * Loongarch KVM guest interrupt handling
>> + */
>> +static inline void _kvm_queue_irq(struct kvm_vcpu *vcpu, unsigned int irq)
>> +{
>> +    set_bit(irq, &vcpu->arch.irq_pending);
>> +    clear_bit(irq, &vcpu->arch.irq_clear);
>> +}
>> +
>> +static inline void _kvm_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int irq)
>> +{
>> +    clear_bit(irq, &vcpu->arch.irq_pending);
>> +    set_bit(irq, &vcpu->arch.irq_clear);
>> +}
>> +
>> +#endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>> index 10748a20a2ab..cce83a4cf1b3 100644
>> --- a/arch/loongarch/include/asm/loongarch.h
>> +++ b/arch/loongarch/include/asm/loongarch.h
>> @@ -11,6 +11,7 @@
>>     #ifndef __ASSEMBLY__
>>   #include <larchintrin.h>
>> +#include <asm/insn-def.h>
>>     /*
>>    * parse_r var, r - Helper assembler macro for parsing register names.
>> @@ -269,6 +270,7 @@ __asm__(".macro    parse_r var r\n\t"
>>   #define LOONGARCH_CSR_ECFG        0x4    /* Exception config */
>>   #define  CSR_ECFG_VS_SHIFT        16
>>   #define  CSR_ECFG_VS_WIDTH        3
>> +#define  CSR_ECFG_VS_SHIFT_END        (CSR_ECFG_VS_SHIFT + CSR_ECFG_VS_WIDTH - 1)
>>   #define  CSR_ECFG_VS            (_ULCAST_(0x7) << CSR_ECFG_VS_SHIFT)
>>   #define  CSR_ECFG_IM_SHIFT        0
>>   #define  CSR_ECFG_IM_WIDTH        14
>> @@ -357,13 +359,14 @@ __asm__(".macro    parse_r var r\n\t"
>>   #define  CSR_TLBLO1_V            (_ULCAST_(0x1) << CSR_TLBLO1_V_SHIFT)
>>     #define LOONGARCH_CSR_GTLBC        0x15    /* Guest TLB control */
>> -#define  CSR_GTLBC_RID_SHIFT        16
>> -#define  CSR_GTLBC_RID_WIDTH        8
>> -#define  CSR_GTLBC_RID            (_ULCAST_(0xff) << CSR_GTLBC_RID_SHIFT)
>> +#define  CSR_GTLBC_TGID_SHIFT        16
>> +#define  CSR_GTLBC_TGID_WIDTH        8
>> +#define  CSR_GTLBC_TGID_SHIFT_END    (CSR_GTLBC_TGID_SHIFT + CSR_GTLBC_TGID_WIDTH - 1)
>> +#define  CSR_GTLBC_TGID            (_ULCAST_(0xff) << CSR_GTLBC_TGID_SHIFT)
>>   #define  CSR_GTLBC_TOTI_SHIFT        13
>>   #define  CSR_GTLBC_TOTI            (_ULCAST_(0x1) << CSR_GTLBC_TOTI_SHIFT)
>> -#define  CSR_GTLBC_USERID_SHIFT        12
>> -#define  CSR_GTLBC_USERID        (_ULCAST_(0x1) << CSR_GTLBC_USERID_SHIFT)
>> +#define  CSR_GTLBC_USETGID_SHIFT    12
>> +#define  CSR_GTLBC_USETGID        (_ULCAST_(0x1) << CSR_GTLBC_USETGID_SHIFT)
>>   #define  CSR_GTLBC_GMTLBSZ_SHIFT    0
>>   #define  CSR_GTLBC_GMTLBSZ_WIDTH    6
>>   #define  CSR_GTLBC_GMTLBSZ        (_ULCAST_(0x3f) << CSR_GTLBC_GMTLBSZ_SHIFT)
>> @@ -518,6 +521,7 @@ __asm__(".macro    parse_r var r\n\t"
>>   #define LOONGARCH_CSR_GSTAT        0x50    /* Guest status */
>>   #define  CSR_GSTAT_GID_SHIFT        16
>>   #define  CSR_GSTAT_GID_WIDTH        8
>> +#define  CSR_GSTAT_GID_SHIFT_END    (CSR_GSTAT_GID_SHIFT + CSR_GSTAT_GID_WIDTH - 1)
>>   #define  CSR_GSTAT_GID            (_ULCAST_(0xff) << CSR_GSTAT_GID_SHIFT)
>>   #define  CSR_GSTAT_GIDBIT_SHIFT        4
>>   #define  CSR_GSTAT_GIDBIT_WIDTH        6
>> @@ -568,6 +572,12 @@ __asm__(".macro    parse_r var r\n\t"
>>   #define  CSR_GCFG_MATC_GUEST        (_ULCAST_(0x0) << CSR_GCFG_MATC_SHITF)
>>   #define  CSR_GCFG_MATC_ROOT        (_ULCAST_(0x1) << CSR_GCFG_MATC_SHITF)
>>   #define  CSR_GCFG_MATC_NEST        (_ULCAST_(0x2) << CSR_GCFG_MATC_SHITF)
>> +#define  CSR_GCFG_MATP_NEST_SHIFT    2
>> +#define  CSR_GCFG_MATP_NEST        (_ULCAST_(0x1) << CSR_GCFG_MATP_NEST_SHIFT)
>> +#define  CSR_GCFG_MATP_ROOT_SHIFT    1
>> +#define  CSR_GCFG_MATP_ROOT        (_ULCAST_(0x1) << CSR_GCFG_MATP_ROOT_SHIFT)
>> +#define  CSR_GCFG_MATP_GUEST_SHIFT    0
>> +#define  CSR_GCFG_MATP_GUEST        (_ULCAST_(0x1) << CSR_GCFG_MATP_GUEST_SHIFT)
>>     #define LOONGARCH_CSR_GINTC        0x52    /* Guest interrupt control */
>>   #define  CSR_GINTC_HC_SHIFT        16
>> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
>> new file mode 100644
>> index 000000000000..17b28d94d569
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/trace.h
>> @@ -0,0 +1,168 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_KVM_H
>> +
>> +#include <linux/tracepoint.h>
>> +#include <asm/kvm_csr.h>
>> +
>> +#undef    TRACE_SYSTEM
>> +#define TRACE_SYSTEM    kvm
>> +
>> +/*
>> + * Tracepoints for VM enters
>> + */
>> +DECLARE_EVENT_CLASS(kvm_transition,
>> +    TP_PROTO(struct kvm_vcpu *vcpu),
>> +    TP_ARGS(vcpu),
>> +    TP_STRUCT__entry(
>> +        __field(unsigned long, pc)
>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->pc = vcpu->arch.pc;
>> +    ),
>> +
>> +    TP_printk("PC: 0x%08lx",
>> +          __entry->pc)
>> +);
>> +
>> +DEFINE_EVENT(kvm_transition, kvm_enter,
>> +         TP_PROTO(struct kvm_vcpu *vcpu),
>> +         TP_ARGS(vcpu));
>> +
>> +DEFINE_EVENT(kvm_transition, kvm_reenter,
>> +         TP_PROTO(struct kvm_vcpu *vcpu),
>> +         TP_ARGS(vcpu));
>> +
>> +DEFINE_EVENT(kvm_transition, kvm_out,
>> +         TP_PROTO(struct kvm_vcpu *vcpu),
>> +         TP_ARGS(vcpu));
>> +
>> +/* Further exit reasons */
>> +#define KVM_TRACE_EXIT_IDLE        64
>> +#define KVM_TRACE_EXIT_CACHE        65
>> +#define KVM_TRACE_EXIT_SIGNAL        66
>> +
>> +/* Tracepoints for VM exits */
>> +#define kvm_trace_symbol_exit_types            \
>> +    { KVM_TRACE_EXIT_IDLE,        "IDLE" },    \
>> +    { KVM_TRACE_EXIT_CACHE,        "CACHE" },    \
>> +    { KVM_TRACE_EXIT_SIGNAL,    "Signal" }
>> +
>> +TRACE_EVENT(kvm_exit_gspr,
>> +        TP_PROTO(struct kvm_vcpu *vcpu, unsigned int inst_word),
>> +        TP_ARGS(vcpu, inst_word),
>> +        TP_STRUCT__entry(
>> +            __field(unsigned int, inst_word)
>> +        ),
>> +
>> +        TP_fast_assign(
>> +            __entry->inst_word = inst_word;
>> +        ),
>> +
>> +        TP_printk("inst word: 0x%08x",
>> +              __entry->inst_word)
>> +);
>> +
>> +
>> +DECLARE_EVENT_CLASS(kvm_exit,
>> +        TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +        TP_ARGS(vcpu, reason),
>> +        TP_STRUCT__entry(
>> +            __field(unsigned long, pc)
>> +            __field(unsigned int, reason)
>> +        ),
>> +
>> +        TP_fast_assign(
>> +            __entry->pc = vcpu->arch.pc;
>> +            __entry->reason = reason;
>> +        ),
>> +
>> +        TP_printk("[%s]PC: 0x%08lx",
>> +              __print_symbolic(__entry->reason,
>> +                       kvm_trace_symbol_exit_types),
>> +              __entry->pc)
>> +);
>> +
>> +DEFINE_EVENT(kvm_exit, kvm_exit_idle,
>> +         TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +         TP_ARGS(vcpu, reason));
>> +
>> +DEFINE_EVENT(kvm_exit, kvm_exit_cache,
>> +         TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +         TP_ARGS(vcpu, reason));
>> +
>> +DEFINE_EVENT(kvm_exit, kvm_exit,
>> +         TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +         TP_ARGS(vcpu, reason));
>> +
>> +#define KVM_TRACE_AUX_RESTORE        0
>> +#define KVM_TRACE_AUX_SAVE        1
>> +#define KVM_TRACE_AUX_ENABLE        2
>> +#define KVM_TRACE_AUX_DISABLE        3
>> +#define KVM_TRACE_AUX_DISCARD        4
>> +
>> +#define KVM_TRACE_AUX_FPU        1
>> +
>> +#define kvm_trace_symbol_aux_op                \
>> +    { KVM_TRACE_AUX_RESTORE,    "restore" },    \
>> +    { KVM_TRACE_AUX_SAVE,        "save" },    \
>> +    { KVM_TRACE_AUX_ENABLE,        "enable" },    \
>> +    { KVM_TRACE_AUX_DISABLE,    "disable" },    \
>> +    { KVM_TRACE_AUX_DISCARD,    "discard" }
>> +
>> +#define kvm_trace_symbol_aux_state            \
>> +    { KVM_TRACE_AUX_FPU,     "FPU" }
>> +
>> +TRACE_EVENT(kvm_aux,
>> +        TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
>> +             unsigned int state),
>> +        TP_ARGS(vcpu, op, state),
>> +        TP_STRUCT__entry(
>> +            __field(unsigned long, pc)
>> +            __field(u8, op)
>> +            __field(u8, state)
>> +        ),
>> +
>> +        TP_fast_assign(
>> +            __entry->pc = vcpu->arch.pc;
>> +            __entry->op = op;
>> +            __entry->state = state;
>> +        ),
>> +
>> +        TP_printk("%s %s PC: 0x%08lx",
>> +              __print_symbolic(__entry->op,
>> +                       kvm_trace_symbol_aux_op),
>> +              __print_symbolic(__entry->state,
>> +                       kvm_trace_symbol_aux_state),
>> +              __entry->pc)
>> +);
>> +
>> +TRACE_EVENT(kvm_vpid_change,
>> +        TP_PROTO(struct kvm_vcpu *vcpu, unsigned long vpid),
>> +        TP_ARGS(vcpu, vpid),
>> +        TP_STRUCT__entry(
>> +            __field(unsigned long, vpid)
>> +        ),
>> +
>> +        TP_fast_assign(
>> +            __entry->vpid = vpid;
>> +        ),
>> +
>> +        TP_printk("vpid: 0x%08lx",
>> +              __entry->vpid)
>> +);
>> +
>> +#endif /* _TRACE_LOONGARCH64_KVM_H */
>> +
>> +#undef TRACE_INCLUDE_PATH
>> +#define TRACE_INCLUDE_PATH ../../arch/loongarch/kvm
>> +#undef TRACE_INCLUDE_FILE
>> +#define TRACE_INCLUDE_FILE trace
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>

