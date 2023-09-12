Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C18579C9D5
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjILI0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 04:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjILI0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 04:26:11 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D7A1BF;
        Tue, 12 Sep 2023 01:26:07 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8BxyeqdIABlUm8lAA--.63548S3;
        Tue, 12 Sep 2023 16:26:05 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxvdybIABl63kAAA--.203S3;
        Tue, 12 Sep 2023 16:26:04 +0800 (CST)
Subject: Re: [PATCH v20 05/30] LoongArch: KVM: Add vcpu related header files
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
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-6-zhaotianrui@loongson.cn>
 <CAAhV-H6N9KVzHpJMXS5XbHF92qO_UDi_XHjNAt5BF6c3EaEj+A@mail.gmail.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <e8766483-76c1-a1b0-645a-863d086c3042@loongson.cn>
Date:   Tue, 12 Sep 2023 16:26:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6N9KVzHpJMXS5XbHF92qO_UDi_XHjNAt5BF6c3EaEj+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8CxvdybIABl63kAAA--.203S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWfuw47XrWrXFWruw45Gr4rZwc_yoW5JFW8Jo
        W3Ja1fGFn5Jw42yF4qga42qa4DZryFkFs8Zw45CryFv34UJas8Wr47J3yrXr43Xryqg343
        CFyIgas5ua4Fyws8l-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUO87kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
        6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFApnUUU
        UU=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/9/11 下午4:07, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Thu, Aug 31, 2023 at 4:30 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Add LoongArch vcpu related header files, including vcpu csr
>> information, irq number defines, and some vcpu interfaces.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_csr.h   | 222 +++++++++++++++++++++++++
>>   arch/loongarch/include/asm/kvm_vcpu.h  |  95 +++++++++++
>>   arch/loongarch/include/asm/loongarch.h |  19 ++-
>>   arch/loongarch/kvm/trace.h             | 168 +++++++++++++++++++
>>   4 files changed, 499 insertions(+), 5 deletions(-)
>>   create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>>   create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>>   create mode 100644 arch/loongarch/kvm/trace.h
>>
>> diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/include/asm/kvm_csr.h
>> new file mode 100644
>> index 0000000000..e27dcacd00
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_csr.h
>> @@ -0,0 +1,222 @@
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
>> +/* binutils support virtualization instructions */
>> +#define gcsr_read(csr)                                         \
>> +({                                                             \
>> +       register unsigned long __v;                             \
>> +       __asm__ __volatile__(                                   \
>> +               " gcsrrd %[val], %[reg]\n\t"                    \
>> +               : [val] "=r" (__v)                              \
>> +               : [reg] "i" (csr)                               \
>> +               : "memory");                                    \
>> +       __v;                                                    \
>> +})
>> +
>> +#define gcsr_write(v, csr)                                     \
>> +({                                                             \
>> +       register unsigned long __v = v;                         \
>> +       __asm__ __volatile__ (                                  \
>> +               " gcsrwr %[val], %[reg]\n\t"                    \
>> +               : [val] "+r" (__v)                              \
>> +               : [reg] "i" (csr)                               \
>> +               : "memory");                                    \
>> +})
>> +
>> +#define gcsr_xchg(v, m, csr)                                   \
>> +({                                                             \
>> +       register unsigned long __v = v;                         \
>> +       __asm__ __volatile__(                                   \
>> +               " gcsrxchg %[val], %[mask], %[reg]\n\t"         \
>> +               : [val] "+r" (__v)                              \
>> +               : [mask] "r" (m), [reg] "i" (csr)               \
>> +               : "memory");                                    \
>> +       __v;                                                    \
>> +})
>> +
>> +/* Guest CSRS read and write */
>> +#define read_gcsr_crmd()               gcsr_read(LOONGARCH_CSR_CRMD)
>> +#define write_gcsr_crmd(val)           gcsr_write(val, LOONGARCH_CSR_CRMD)
>> +#define read_gcsr_prmd()               gcsr_read(LOONGARCH_CSR_PRMD)
>> +#define write_gcsr_prmd(val)           gcsr_write(val, LOONGARCH_CSR_PRMD)
>> +#define read_gcsr_euen()               gcsr_read(LOONGARCH_CSR_EUEN)
>> +#define write_gcsr_euen(val)           gcsr_write(val, LOONGARCH_CSR_EUEN)
>> +#define read_gcsr_misc()               gcsr_read(LOONGARCH_CSR_MISC)
>> +#define write_gcsr_misc(val)           gcsr_write(val, LOONGARCH_CSR_MISC)
>> +#define read_gcsr_ecfg()               gcsr_read(LOONGARCH_CSR_ECFG)
>> +#define write_gcsr_ecfg(val)           gcsr_write(val, LOONGARCH_CSR_ECFG)
>> +#define read_gcsr_estat()              gcsr_read(LOONGARCH_CSR_ESTAT)
>> +#define write_gcsr_estat(val)          gcsr_write(val, LOONGARCH_CSR_ESTAT)
>> +#define read_gcsr_era()                        gcsr_read(LOONGARCH_CSR_ERA)
>> +#define write_gcsr_era(val)            gcsr_write(val, LOONGARCH_CSR_ERA)
>> +#define read_gcsr_badv()               gcsr_read(LOONGARCH_CSR_BADV)
>> +#define write_gcsr_badv(val)           gcsr_write(val, LOONGARCH_CSR_BADV)
>> +#define read_gcsr_badi()               gcsr_read(LOONGARCH_CSR_BADI)
>> +#define write_gcsr_badi(val)           gcsr_write(val, LOONGARCH_CSR_BADI)
>> +#define read_gcsr_eentry()             gcsr_read(LOONGARCH_CSR_EENTRY)
>> +#define write_gcsr_eentry(val)         gcsr_write(val, LOONGARCH_CSR_EENTRY)
>> +
>> +#define read_gcsr_tlbidx()             gcsr_read(LOONGARCH_CSR_TLBIDX)
>> +#define write_gcsr_tlbidx(val)         gcsr_write(val, LOONGARCH_CSR_TLBIDX)
>> +#define read_gcsr_tlbhi()              gcsr_read(LOONGARCH_CSR_TLBEHI)
>> +#define write_gcsr_tlbhi(val)          gcsr_write(val, LOONGARCH_CSR_TLBEHI)
>> +#define read_gcsr_tlblo0()             gcsr_read(LOONGARCH_CSR_TLBELO0)
>> +#define write_gcsr_tlblo0(val)         gcsr_write(val, LOONGARCH_CSR_TLBELO0)
>> +#define read_gcsr_tlblo1()             gcsr_read(LOONGARCH_CSR_TLBELO1)
>> +#define write_gcsr_tlblo1(val)         gcsr_write(val, LOONGARCH_CSR_TLBELO1)
>> +
>> +#define read_gcsr_asid()               gcsr_read(LOONGARCH_CSR_ASID)
>> +#define write_gcsr_asid(val)           gcsr_write(val, LOONGARCH_CSR_ASID)
>> +#define read_gcsr_pgdl()               gcsr_read(LOONGARCH_CSR_PGDL)
>> +#define write_gcsr_pgdl(val)           gcsr_write(val, LOONGARCH_CSR_PGDL)
>> +#define read_gcsr_pgdh()               gcsr_read(LOONGARCH_CSR_PGDH)
>> +#define write_gcsr_pgdh(val)           gcsr_write(val, LOONGARCH_CSR_PGDH)
>> +#define write_gcsr_pgd(val)            gcsr_write(val, LOONGARCH_CSR_PGD)
>> +#define read_gcsr_pgd()                        gcsr_read(LOONGARCH_CSR_PGD)
>> +#define read_gcsr_pwctl0()             gcsr_read(LOONGARCH_CSR_PWCTL0)
>> +#define write_gcsr_pwctl0(val)         gcsr_write(val, LOONGARCH_CSR_PWCTL0)
>> +#define read_gcsr_pwctl1()             gcsr_read(LOONGARCH_CSR_PWCTL1)
>> +#define write_gcsr_pwctl1(val)         gcsr_write(val, LOONGARCH_CSR_PWCTL1)
>> +#define read_gcsr_stlbpgsize()         gcsr_read(LOONGARCH_CSR_STLBPGSIZE)
>> +#define write_gcsr_stlbpgsize(val)     gcsr_write(val, LOONGARCH_CSR_STLBPGSIZE)
>> +#define read_gcsr_rvacfg()             gcsr_read(LOONGARCH_CSR_RVACFG)
>> +#define write_gcsr_rvacfg(val)         gcsr_write(val, LOONGARCH_CSR_RVACFG)
>> +
>> +#define read_gcsr_cpuid()              gcsr_read(LOONGARCH_CSR_CPUID)
>> +#define write_gcsr_cpuid(val)          gcsr_write(val, LOONGARCH_CSR_CPUID)
>> +#define read_gcsr_prcfg1()             gcsr_read(LOONGARCH_CSR_PRCFG1)
>> +#define write_gcsr_prcfg1(val)         gcsr_write(val, LOONGARCH_CSR_PRCFG1)
>> +#define read_gcsr_prcfg2()             gcsr_read(LOONGARCH_CSR_PRCFG2)
>> +#define write_gcsr_prcfg2(val)         gcsr_write(val, LOONGARCH_CSR_PRCFG2)
>> +#define read_gcsr_prcfg3()             gcsr_read(LOONGARCH_CSR_PRCFG3)
>> +#define write_gcsr_prcfg3(val)         gcsr_write(val, LOONGARCH_CSR_PRCFG3)
>> +
>> +#define read_gcsr_kscratch0()          gcsr_read(LOONGARCH_CSR_KS0)
>> +#define write_gcsr_kscratch0(val)      gcsr_write(val, LOONGARCH_CSR_KS0)
>> +#define read_gcsr_kscratch1()          gcsr_read(LOONGARCH_CSR_KS1)
>> +#define write_gcsr_kscratch1(val)      gcsr_write(val, LOONGARCH_CSR_KS1)
>> +#define read_gcsr_kscratch2()          gcsr_read(LOONGARCH_CSR_KS2)
>> +#define write_gcsr_kscratch2(val)      gcsr_write(val, LOONGARCH_CSR_KS2)
>> +#define read_gcsr_kscratch3()          gcsr_read(LOONGARCH_CSR_KS3)
>> +#define write_gcsr_kscratch3(val)      gcsr_write(val, LOONGARCH_CSR_KS3)
>> +#define read_gcsr_kscratch4()          gcsr_read(LOONGARCH_CSR_KS4)
>> +#define write_gcsr_kscratch4(val)      gcsr_write(val, LOONGARCH_CSR_KS4)
>> +#define read_gcsr_kscratch5()          gcsr_read(LOONGARCH_CSR_KS5)
>> +#define write_gcsr_kscratch5(val)      gcsr_write(val, LOONGARCH_CSR_KS5)
>> +#define read_gcsr_kscratch6()          gcsr_read(LOONGARCH_CSR_KS6)
>> +#define write_gcsr_kscratch6(val)      gcsr_write(val, LOONGARCH_CSR_KS6)
>> +#define read_gcsr_kscratch7()          gcsr_read(LOONGARCH_CSR_KS7)
>> +#define write_gcsr_kscratch7(val)      gcsr_write(val, LOONGARCH_CSR_KS7)
>> +
>> +#define read_gcsr_timerid()            gcsr_read(LOONGARCH_CSR_TMID)
>> +#define write_gcsr_timerid(val)                gcsr_write(val, LOONGARCH_CSR_TMID)
>> +#define read_gcsr_timercfg()           gcsr_read(LOONGARCH_CSR_TCFG)
>> +#define write_gcsr_timercfg(val)       gcsr_write(val, LOONGARCH_CSR_TCFG)
>> +#define read_gcsr_timertick()          gcsr_read(LOONGARCH_CSR_TVAL)
>> +#define write_gcsr_timertick(val)      gcsr_write(val, LOONGARCH_CSR_TVAL)
>> +#define read_gcsr_timeroffset()                gcsr_read(LOONGARCH_CSR_CNTC)
>> +#define write_gcsr_timeroffset(val)    gcsr_write(val, LOONGARCH_CSR_CNTC)
>> +
>> +#define read_gcsr_llbctl()             gcsr_read(LOONGARCH_CSR_LLBCTL)
>> +#define write_gcsr_llbctl(val)         gcsr_write(val, LOONGARCH_CSR_LLBCTL)
>> +
>> +#define read_gcsr_tlbrentry()          gcsr_read(LOONGARCH_CSR_TLBRENTRY)
>> +#define write_gcsr_tlbrentry(val)      gcsr_write(val, LOONGARCH_CSR_TLBRENTRY)
>> +#define read_gcsr_tlbrbadv()           gcsr_read(LOONGARCH_CSR_TLBRBADV)
>> +#define write_gcsr_tlbrbadv(val)       gcsr_write(val, LOONGARCH_CSR_TLBRBADV)
>> +#define read_gcsr_tlbrera()            gcsr_read(LOONGARCH_CSR_TLBRERA)
>> +#define write_gcsr_tlbrera(val)                gcsr_write(val, LOONGARCH_CSR_TLBRERA)
>> +#define read_gcsr_tlbrsave()           gcsr_read(LOONGARCH_CSR_TLBRSAVE)
>> +#define write_gcsr_tlbrsave(val)       gcsr_write(val, LOONGARCH_CSR_TLBRSAVE)
>> +#define read_gcsr_tlbrelo0()           gcsr_read(LOONGARCH_CSR_TLBRELO0)
>> +#define write_gcsr_tlbrelo0(val)       gcsr_write(val, LOONGARCH_CSR_TLBRELO0)
>> +#define read_gcsr_tlbrelo1()           gcsr_read(LOONGARCH_CSR_TLBRELO1)
>> +#define write_gcsr_tlbrelo1(val)       gcsr_write(val, LOONGARCH_CSR_TLBRELO1)
>> +#define read_gcsr_tlbrehi()            gcsr_read(LOONGARCH_CSR_TLBREHI)
>> +#define write_gcsr_tlbrehi(val)                gcsr_write(val, LOONGARCH_CSR_TLBREHI)
>> +#define read_gcsr_tlbrprmd()           gcsr_read(LOONGARCH_CSR_TLBRPRMD)
>> +#define write_gcsr_tlbrprmd(val)       gcsr_write(val, LOONGARCH_CSR_TLBRPRMD)
>> +
>> +#define read_gcsr_directwin0()         gcsr_read(LOONGARCH_CSR_DMWIN0)
>> +#define write_gcsr_directwin0(val)     gcsr_write(val, LOONGARCH_CSR_DMWIN0)
>> +#define read_gcsr_directwin1()         gcsr_read(LOONGARCH_CSR_DMWIN1)
>> +#define write_gcsr_directwin1(val)     gcsr_write(val, LOONGARCH_CSR_DMWIN1)
>> +#define read_gcsr_directwin2()         gcsr_read(LOONGARCH_CSR_DMWIN2)
>> +#define write_gcsr_directwin2(val)     gcsr_write(val, LOONGARCH_CSR_DMWIN2)
>> +#define read_gcsr_directwin3()         gcsr_read(LOONGARCH_CSR_DMWIN3)
>> +#define write_gcsr_directwin3(val)     gcsr_write(val, LOONGARCH_CSR_DMWIN3)
>> +
>> +/* Guest related CSRs */
>> +#define read_csr_gtlbc()               csr_read64(LOONGARCH_CSR_GTLBC)
>> +#define write_csr_gtlbc(val)           csr_write64(val, LOONGARCH_CSR_GTLBC)
>> +#define read_csr_trgp()                        csr_read64(LOONGARCH_CSR_TRGP)
>> +#define read_csr_gcfg()                        csr_read64(LOONGARCH_CSR_GCFG)
>> +#define write_csr_gcfg(val)            csr_write64(val, LOONGARCH_CSR_GCFG)
>> +#define read_csr_gstat()               csr_read64(LOONGARCH_CSR_GSTAT)
>> +#define write_csr_gstat(val)           csr_write64(val, LOONGARCH_CSR_GSTAT)
>> +#define read_csr_gintc()               csr_read64(LOONGARCH_CSR_GINTC)
>> +#define write_csr_gintc(val)           csr_write64(val, LOONGARCH_CSR_GINTC)
>> +#define read_csr_gcntc()               csr_read64(LOONGARCH_CSR_GCNTC)
>> +#define write_csr_gcntc(val)           csr_write64(val, LOONGARCH_CSR_GCNTC)
>> +
>> +#define __BUILD_GCSR_OP(name)          __BUILD_CSR_COMMON(gcsr_##name)
>> +
>> +__BUILD_GCSR_OP(llbctl)
>> +__BUILD_GCSR_OP(tlbidx)
>> +__BUILD_CSR_OP(gcfg)
>> +__BUILD_CSR_OP(gstat)
>> +__BUILD_CSR_OP(gtlbc)
>> +__BUILD_CSR_OP(gintc)
>> +
>> +#define set_gcsr_estat(val)    \
>> +       gcsr_xchg(val, val, LOONGARCH_CSR_ESTAT)
>> +#define clear_gcsr_estat(val)  \
>> +       gcsr_xchg(~(val), val, LOONGARCH_CSR_ESTAT)
>> +
>> +#define kvm_read_hw_gcsr(id)           gcsr_read(id)
>> +#define kvm_write_hw_gcsr(csr, id, val)        gcsr_write(val, id)
>> +
>> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v);
>> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 v);
>> +
>> +int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +
>> +#define kvm_save_hw_gcsr(csr, gid)     (csr->csrs[gid] = gcsr_read(gid))
>> +#define kvm_restore_hw_gcsr(csr, gid)  (gcsr_write(csr->csrs[gid], gid))
>> +
>> +static __always_inline unsigned long kvm_read_sw_gcsr(struct loongarch_csrs *csr, int gid)
>> +{
>> +       return csr->csrs[gid];
>> +}
>> +
>> +static __always_inline void kvm_write_sw_gcsr(struct loongarch_csrs *csr,
>> +                                             int gid, unsigned long val)
>> +{
>> +       csr->csrs[gid] = val;
>> +}
>> +
>> +static __always_inline void kvm_set_sw_gcsr(struct loongarch_csrs *csr,
>> +                                           int gid, unsigned long val)
>> +{
>> +       csr->csrs[gid] |= val;
>> +}
>> +
>> +static __always_inline void kvm_change_sw_gcsr(struct loongarch_csrs *csr,
>> +                                              int gid, unsigned long mask,
>> +                                              unsigned long val)
>> +{
>> +       unsigned long _mask = mask;
>> +
>> +       csr->csrs[gid] &= ~_mask;
>> +       csr->csrs[gid] |= val & _mask;
>> +}
>> +#endif /* __ASM_LOONGARCH_KVM_CSR_H__ */
>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>> new file mode 100644
>> index 0000000000..3d23a656fe
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
>> +#define CPU_SIP0                       (_ULCAST_(1))
>> +#define CPU_SIP1                       (_ULCAST_(1) << 1)
>> +#define CPU_PMU                                (_ULCAST_(1) << 10)
>> +#define CPU_TIMER                      (_ULCAST_(1) << 11)
>> +#define CPU_IPI                                (_ULCAST_(1) << 12)
>> +
>> +/* Controlled by 0x52 guest exception VIP
>> + * aligned to exst bit 5~12
>> + */
>> +#define CPU_IP0                                (_ULCAST_(1))
>> +#define CPU_IP1                                (_ULCAST_(1) << 1)
>> +#define CPU_IP2                                (_ULCAST_(1) << 2)
>> +#define CPU_IP3                                (_ULCAST_(1) << 3)
>> +#define CPU_IP4                                (_ULCAST_(1) << 4)
>> +#define CPU_IP5                                (_ULCAST_(1) << 5)
>> +#define CPU_IP6                                (_ULCAST_(1) << 6)
>> +#define CPU_IP7                                (_ULCAST_(1) << 7)
>> +
>> +#define MNSEC_PER_SEC                  (NSEC_PER_SEC >> 20)
>> +
>> +/* KVM_IRQ_LINE irq field index values */
>> +#define KVM_LOONGSON_IRQ_TYPE_SHIFT    24
>> +#define KVM_LOONGSON_IRQ_TYPE_MASK     0xff
>> +#define KVM_LOONGSON_IRQ_VCPU_SHIFT    16
>> +#define KVM_LOONGSON_IRQ_VCPU_MASK     0xff
>> +#define KVM_LOONGSON_IRQ_NUM_SHIFT     0
>> +#define KVM_LOONGSON_IRQ_NUM_MASK      0xffff
>> +
>> +/* Irq_type field */
>> +#define KVM_LOONGSON_IRQ_TYPE_CPU_IP   0
>> +#define KVM_LOONGSON_IRQ_TYPE_CPU_IO   1
>> +#define KVM_LOONGSON_IRQ_TYPE_HT       2
>> +#define KVM_LOONGSON_IRQ_TYPE_MSI      3
>> +#define KVM_LOONGSON_IRQ_TYPE_IOAPIC   4
>> +#define KVM_LOONGSON_IRQ_TYPE_ROUTE    5
>> +
>> +/* Out-of-kernel GIC cpu interrupt injection irq_number field */
>> +#define KVM_LOONGSON_IRQ_CPU_IRQ       0
>> +#define KVM_LOONGSON_IRQ_CPU_FIQ       1
>> +#define KVM_LOONGSON_CPU_IP_NUM                8
>> +
>> +typedef union loongarch_instruction  larch_inst;
>> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
>> +
>> +int  _kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst);
>> +int  _kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst);
>> +int  _kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int  _kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int  _kvm_emu_idle(struct kvm_vcpu *vcpu);
>> +int  _kvm_handle_pv_hcall(struct kvm_vcpu *vcpu);
>> +int  _kvm_pending_timer(struct kvm_vcpu *vcpu);
>> +int  _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault);
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
>> +       set_bit(irq, &vcpu->arch.irq_pending);
>> +       clear_bit(irq, &vcpu->arch.irq_clear);
>> +}
>> +
>> +static inline void _kvm_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int irq)
>> +{
>> +       clear_bit(irq, &vcpu->arch.irq_pending);
>> +       set_bit(irq, &vcpu->arch.irq_clear);
>> +}
>> +
>> +#endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>> index 10748a20a2..b9044c8dfa 100644
>> --- a/arch/loongarch/include/asm/loongarch.h
>> +++ b/arch/loongarch/include/asm/loongarch.h
>> @@ -269,6 +269,7 @@ __asm__(".macro     parse_r var r\n\t"
>>   #define LOONGARCH_CSR_ECFG             0x4     /* Exception config */
>>   #define  CSR_ECFG_VS_SHIFT             16
>>   #define  CSR_ECFG_VS_WIDTH             3
>> +#define  CSR_ECFG_VS_SHIFT_END         (CSR_ECFG_VS_SHIFT + CSR_ECFG_VS_WIDTH - 1)
>>   #define  CSR_ECFG_VS                   (_ULCAST_(0x7) << CSR_ECFG_VS_SHIFT)
>>   #define  CSR_ECFG_IM_SHIFT             0
>>   #define  CSR_ECFG_IM_WIDTH             14
>> @@ -357,13 +358,14 @@ __asm__(".macro   parse_r var r\n\t"
>>   #define  CSR_TLBLO1_V                  (_ULCAST_(0x1) << CSR_TLBLO1_V_SHIFT)
>>
>>   #define LOONGARCH_CSR_GTLBC            0x15    /* Guest TLB control */
>> -#define  CSR_GTLBC_RID_SHIFT           16
>> -#define  CSR_GTLBC_RID_WIDTH           8
>> -#define  CSR_GTLBC_RID                 (_ULCAST_(0xff) << CSR_GTLBC_RID_SHIFT)
>> +#define  CSR_GTLBC_TGID_SHIFT          16
>> +#define  CSR_GTLBC_TGID_WIDTH          8
>> +#define  CSR_GTLBC_TGID_SHIFT_END      (CSR_GTLBC_TGID_SHIFT + CSR_GTLBC_TGID_WIDTH - 1)
>> +#define  CSR_GTLBC_TGID                        (_ULCAST_(0xff) << CSR_GTLBC_TGID_SHIFT)
>>   #define  CSR_GTLBC_TOTI_SHIFT          13
>>   #define  CSR_GTLBC_TOTI                        (_ULCAST_(0x1) << CSR_GTLBC_TOTI_SHIFT)
>> -#define  CSR_GTLBC_USERID_SHIFT                12
>> -#define  CSR_GTLBC_USERID              (_ULCAST_(0x1) << CSR_GTLBC_USERID_SHIFT)
>> +#define  CSR_GTLBC_USETGID_SHIFT       12
>> +#define  CSR_GTLBC_USETGID             (_ULCAST_(0x1) << CSR_GTLBC_USETGID_SHIFT)
>>   #define  CSR_GTLBC_GMTLBSZ_SHIFT       0
>>   #define  CSR_GTLBC_GMTLBSZ_WIDTH       6
>>   #define  CSR_GTLBC_GMTLBSZ             (_ULCAST_(0x3f) << CSR_GTLBC_GMTLBSZ_SHIFT)
>> @@ -518,6 +520,7 @@ __asm__(".macro     parse_r var r\n\t"
>>   #define LOONGARCH_CSR_GSTAT            0x50    /* Guest status */
>>   #define  CSR_GSTAT_GID_SHIFT           16
>>   #define  CSR_GSTAT_GID_WIDTH           8
>> +#define  CSR_GSTAT_GID_SHIFT_END       (CSR_GSTAT_GID_SHIFT + CSR_GSTAT_GID_WIDTH - 1)
>>   #define  CSR_GSTAT_GID                 (_ULCAST_(0xff) << CSR_GSTAT_GID_SHIFT)
>>   #define  CSR_GSTAT_GIDBIT_SHIFT                4
>>   #define  CSR_GSTAT_GIDBIT_WIDTH                6
>> @@ -568,6 +571,12 @@ __asm__(".macro    parse_r var r\n\t"
>>   #define  CSR_GCFG_MATC_GUEST           (_ULCAST_(0x0) << CSR_GCFG_MATC_SHITF)
>>   #define  CSR_GCFG_MATC_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATC_SHITF)
>>   #define  CSR_GCFG_MATC_NEST            (_ULCAST_(0x2) << CSR_GCFG_MATC_SHITF)
>> +#define  CSR_GCFG_MATP_NEST_SHIFT      2
>> +#define  CSR_GCFG_MATP_NEST            (_ULCAST_(0x1) << CSR_GCFG_MATP_NEST_SHIFT)
>> +#define  CSR_GCFG_MATP_ROOT_SHIFT      1
>> +#define  CSR_GCFG_MATP_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATP_ROOT_SHIFT)
>> +#define  CSR_GCFG_MATP_GUEST_SHIFT     0
>> +#define  CSR_GCFG_MATP_GUEST           (_ULCAST_(0x1) << CSR_GCFG_MATP_GUEST_SHIFT)
>>
>>   #define LOONGARCH_CSR_GINTC            0x52    /* Guest interrupt control */
>>   #define  CSR_GINTC_HC_SHIFT            16
>> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
>> new file mode 100644
>> index 0000000000..17b28d94d5
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
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM   kvm
>> +
>> +/*
>> + * Tracepoints for VM enters
>> + */
>> +DECLARE_EVENT_CLASS(kvm_transition,
>> +       TP_PROTO(struct kvm_vcpu *vcpu),
>> +       TP_ARGS(vcpu),
>> +       TP_STRUCT__entry(
>> +               __field(unsigned long, pc)
>> +       ),
>> +
>> +       TP_fast_assign(
>> +               __entry->pc = vcpu->arch.pc;
>> +       ),
>> +
>> +       TP_printk("PC: 0x%08lx",
>> +                 __entry->pc)
>> +);
>> +
>> +DEFINE_EVENT(kvm_transition, kvm_enter,
>> +            TP_PROTO(struct kvm_vcpu *vcpu),
>> +            TP_ARGS(vcpu));
>> +
>> +DEFINE_EVENT(kvm_transition, kvm_reenter,
>> +            TP_PROTO(struct kvm_vcpu *vcpu),
>> +            TP_ARGS(vcpu));
>> +
>> +DEFINE_EVENT(kvm_transition, kvm_out,
>> +            TP_PROTO(struct kvm_vcpu *vcpu),
>> +            TP_ARGS(vcpu));
>> +
>> +/* Further exit reasons */
>> +#define KVM_TRACE_EXIT_IDLE            64
>> +#define KVM_TRACE_EXIT_CACHE           65
>> +#define KVM_TRACE_EXIT_SIGNAL          66
>> +
>> +/* Tracepoints for VM exits */
>> +#define kvm_trace_symbol_exit_types                    \
>> +       { KVM_TRACE_EXIT_IDLE,          "IDLE" },       \
>> +       { KVM_TRACE_EXIT_CACHE,         "CACHE" },      \
>> +       { KVM_TRACE_EXIT_SIGNAL,        "Signal" }
> Consider to use Idle, Cache which has the same style of Signal?
The trace point of signal is not used, and I will remove it.
>
> And why the types here are not the same as those in kvm_vcpu_stat?
As the idle_exits is the statistics of idle exiting, so it is different 
from idle trace point.
>
> struct kvm_vcpu_stat {
>   struct kvm_vcpu_stat_generic generic;
>   u64 idle_exits;
>   u64 signal_exits;
>   u64 int_exits;
>   u64 cpucfg_exits;
> };
>
>> +
>> +TRACE_EVENT(kvm_exit_gspr,
>> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int inst_word),
>> +           TP_ARGS(vcpu, inst_word),
>> +           TP_STRUCT__entry(
>> +                       __field(unsigned int, inst_word)
>> +           ),
>> +
>> +           TP_fast_assign(
>> +                       __entry->inst_word = inst_word;
>> +           ),
>> +
>> +           TP_printk("inst word: 0x%08x",
>> +                     __entry->inst_word)
>> +);
>> +
>> +
>> +DECLARE_EVENT_CLASS(kvm_exit,
>> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +           TP_ARGS(vcpu, reason),
>> +           TP_STRUCT__entry(
>> +                       __field(unsigned long, pc)
>> +                       __field(unsigned int, reason)
>> +           ),
>> +
>> +           TP_fast_assign(
>> +                       __entry->pc = vcpu->arch.pc;
>> +                       __entry->reason = reason;
>> +           ),
>> +
>> +           TP_printk("[%s]PC: 0x%08lx",
>> +                     __print_symbolic(__entry->reason,
>> +                                      kvm_trace_symbol_exit_types),
>> +                     __entry->pc)
>> +);
>> +
>> +DEFINE_EVENT(kvm_exit, kvm_exit_idle,
>> +            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +            TP_ARGS(vcpu, reason));
>> +
>> +DEFINE_EVENT(kvm_exit, kvm_exit_cache,
>> +            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +            TP_ARGS(vcpu, reason));
>> +
>> +DEFINE_EVENT(kvm_exit, kvm_exit,
> I'm not sure, but it may be DEFINE_EVENT(kvm_exit, kvm_exit_signal),
> which is corresponding to the types above?
The trace point of signal is not used, so there need not the 
kvm_exit_signal function.

Thanks
Tianrui Zhao
>
>
> Huacai
>
>> +            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>> +            TP_ARGS(vcpu, reason));
>> +
>> +#define KVM_TRACE_AUX_RESTORE          0
>> +#define KVM_TRACE_AUX_SAVE             1
>> +#define KVM_TRACE_AUX_ENABLE           2
>> +#define KVM_TRACE_AUX_DISABLE          3
>> +#define KVM_TRACE_AUX_DISCARD          4
>> +
>> +#define KVM_TRACE_AUX_FPU              1
>> +
>> +#define kvm_trace_symbol_aux_op                                \
>> +       { KVM_TRACE_AUX_RESTORE,        "restore" },    \
>> +       { KVM_TRACE_AUX_SAVE,           "save" },       \
>> +       { KVM_TRACE_AUX_ENABLE,         "enable" },     \
>> +       { KVM_TRACE_AUX_DISABLE,        "disable" },    \
>> +       { KVM_TRACE_AUX_DISCARD,        "discard" }
>> +
>> +#define kvm_trace_symbol_aux_state                     \
>> +       { KVM_TRACE_AUX_FPU,     "FPU" }
>> +
>> +TRACE_EVENT(kvm_aux,
>> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
>> +                    unsigned int state),
>> +           TP_ARGS(vcpu, op, state),
>> +           TP_STRUCT__entry(
>> +                       __field(unsigned long, pc)
>> +                       __field(u8, op)
>> +                       __field(u8, state)
>> +           ),
>> +
>> +           TP_fast_assign(
>> +                       __entry->pc = vcpu->arch.pc;
>> +                       __entry->op = op;
>> +                       __entry->state = state;
>> +           ),
>> +
>> +           TP_printk("%s %s PC: 0x%08lx",
>> +                     __print_symbolic(__entry->op,
>> +                                      kvm_trace_symbol_aux_op),
>> +                     __print_symbolic(__entry->state,
>> +                                      kvm_trace_symbol_aux_state),
>> +                     __entry->pc)
>> +);
>> +
>> +TRACE_EVENT(kvm_vpid_change,
>> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned long vpid),
>> +           TP_ARGS(vcpu, vpid),
>> +           TP_STRUCT__entry(
>> +                       __field(unsigned long, vpid)
>> +           ),
>> +
>> +           TP_fast_assign(
>> +                       __entry->vpid = vpid;
>> +           ),
>> +
>> +           TP_printk("vpid: 0x%08lx",
>> +                     __entry->vpid)
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
>> --
>> 2.27.0
>>

