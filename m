Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCFD7A2F39
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbjIPKRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Sep 2023 06:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbjIPKQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 06:16:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68456CD6;
        Sat, 16 Sep 2023 03:16:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86387C433C9;
        Sat, 16 Sep 2023 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694859410;
        bh=CPqa5XMGwBLOA4jHS5fpv9sb1hhCtF6K+XwWWf1F+Yc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QgJVPtr+PjIx9K2tx06ar78QHPSOzUCD2FdlKIQRhizGgdzA14wQfFdc6kQoijofe
         Mn3AEMO5JkTvPlakYeWTUyYbK/sVCnPzm+DnRkINTIYfF/GYT+jlx8o/hD0F3giPCG
         3KP0pxUWmw1QE1RHnDdVDz8VABRq8OLxlAtN3KZBA/LMUOMwKBbuMAyk1Zw6bJJTRC
         8hi5qwzn/fO/4PuP0MnbA55mxkIDWAFuge0mpF3GDD8CAKAJCx9tRXFJNWFPavYTA2
         4jtRSueYHLCF0anbaE42oABYdRKvi2XyR9JqURaHg8TB7fgqYadqBzOTIwxJ3bPxWF
         ADzGvSr2PTZyA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2bfc5218dd8so46621281fa.2;
        Sat, 16 Sep 2023 03:16:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YyJ3vI9EoR3/g56Pzp/KArhDRnGHPhoS+AZ2ot4+J0Cokho2YXI
        yllKwz0D0pWx+rUKD5O7ZYqo+xNvRxTwn5nHD1w=
X-Google-Smtp-Source: AGHT+IHreEbi5PiEYEhb3k0ICOeqcPhGSLRdpPIrDwiFi6S0VhpOI4+tD1zL2y4djZqjqCqp/W6gsrOdVi7KJS3qZCY=
X-Received: by 2002:ac2:58f8:0:b0:500:bb99:69a9 with SMTP id
 v24-20020ac258f8000000b00500bb9969a9mr3022443lfo.64.1694859408621; Sat, 16
 Sep 2023 03:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn> <20230915014949.1222777-6-zhaotianrui@loongson.cn>
In-Reply-To: <20230915014949.1222777-6-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 16 Sep 2023 18:16:35 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6B9o9mD9tt9vtAOBYxBrB6wnZkuk+EV5MmyYE=LyvtgA@mail.gmail.com>
Message-ID: <CAAhV-H6B9o9mD9tt9vtAOBYxBrB6wnZkuk+EV5MmyYE=LyvtgA@mail.gmail.com>
Subject: Re: [PATCH v21 05/29] LoongArch: KVM: Add vcpu related header files
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Fri, Sep 15, 2023 at 9:50=E2=80=AFAM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Add LoongArch vcpu related header files, including vcpu csr
> information, irq number defines, and some vcpu interfaces.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_csr.h   | 221 +++++++++++++++++++++++++
>  arch/loongarch/include/asm/kvm_vcpu.h  | 107 ++++++++++++
>  arch/loongarch/include/asm/loongarch.h |  19 ++-
>  arch/loongarch/kvm/trace.h             | 166 +++++++++++++++++++
>  4 files changed, 508 insertions(+), 5 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>  create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>  create mode 100644 arch/loongarch/kvm/trace.h
>
> diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/includ=
e/asm/kvm_csr.h
> new file mode 100644
> index 0000000000..bcdff6724a
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_csr.h
> @@ -0,0 +1,221 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_LOONGARCH_KVM_CSR_H__
> +#define __ASM_LOONGARCH_KVM_CSR_H__
> +#include <asm/loongarch.h>
> +#include <asm/kvm_vcpu.h>
> +#include <linux/uaccess.h>
> +#include <linux/kvm_host.h>
> +
> +/* binutils support virtualization instructions */
> +#define gcsr_read(csr)                                         \
> +({                                                             \
> +       register unsigned long __v;                             \
> +       __asm__ __volatile__(                                   \
> +               " gcsrrd %[val], %[reg]\n\t"                    \
> +               : [val] "=3Dr" (__v)                              \
> +               : [reg] "i" (csr)                               \
> +               : "memory");                                    \
> +       __v;                                                    \
> +})
> +
> +#define gcsr_write(v, csr)                                     \
> +({                                                             \
> +       register unsigned long __v =3D v;                         \
> +       __asm__ __volatile__ (                                  \
> +               " gcsrwr %[val], %[reg]\n\t"                    \
> +               : [val] "+r" (__v)                              \
> +               : [reg] "i" (csr)                               \
> +               : "memory");                                    \
> +})
> +
> +#define gcsr_xchg(v, m, csr)                                   \
> +({                                                             \
> +       register unsigned long __v =3D v;                         \
> +       __asm__ __volatile__(                                   \
> +               " gcsrxchg %[val], %[mask], %[reg]\n\t"         \
> +               : [val] "+r" (__v)                              \
> +               : [mask] "r" (m), [reg] "i" (csr)               \
> +               : "memory");                                    \
> +       __v;                                                    \
> +})
> +
> +/* Guest CSRS read and write */
> +#define read_gcsr_crmd()               gcsr_read(LOONGARCH_CSR_CRMD)
> +#define write_gcsr_crmd(val)           gcsr_write(val, LOONGARCH_CSR_CRM=
D)
> +#define read_gcsr_prmd()               gcsr_read(LOONGARCH_CSR_PRMD)
> +#define write_gcsr_prmd(val)           gcsr_write(val, LOONGARCH_CSR_PRM=
D)
> +#define read_gcsr_euen()               gcsr_read(LOONGARCH_CSR_EUEN)
> +#define write_gcsr_euen(val)           gcsr_write(val, LOONGARCH_CSR_EUE=
N)
> +#define read_gcsr_misc()               gcsr_read(LOONGARCH_CSR_MISC)
> +#define write_gcsr_misc(val)           gcsr_write(val, LOONGARCH_CSR_MIS=
C)
> +#define read_gcsr_ecfg()               gcsr_read(LOONGARCH_CSR_ECFG)
> +#define write_gcsr_ecfg(val)           gcsr_write(val, LOONGARCH_CSR_ECF=
G)
> +#define read_gcsr_estat()              gcsr_read(LOONGARCH_CSR_ESTAT)
> +#define write_gcsr_estat(val)          gcsr_write(val, LOONGARCH_CSR_EST=
AT)
> +#define read_gcsr_era()                        gcsr_read(LOONGARCH_CSR_E=
RA)
> +#define write_gcsr_era(val)            gcsr_write(val, LOONGARCH_CSR_ERA=
)
> +#define read_gcsr_badv()               gcsr_read(LOONGARCH_CSR_BADV)
> +#define write_gcsr_badv(val)           gcsr_write(val, LOONGARCH_CSR_BAD=
V)
> +#define read_gcsr_badi()               gcsr_read(LOONGARCH_CSR_BADI)
> +#define write_gcsr_badi(val)           gcsr_write(val, LOONGARCH_CSR_BAD=
I)
> +#define read_gcsr_eentry()             gcsr_read(LOONGARCH_CSR_EENTRY)
> +#define write_gcsr_eentry(val)         gcsr_write(val, LOONGARCH_CSR_EEN=
TRY)
> +
> +#define read_gcsr_tlbidx()             gcsr_read(LOONGARCH_CSR_TLBIDX)
> +#define write_gcsr_tlbidx(val)         gcsr_write(val, LOONGARCH_CSR_TLB=
IDX)
> +#define read_gcsr_tlbhi()              gcsr_read(LOONGARCH_CSR_TLBEHI)
> +#define write_gcsr_tlbhi(val)          gcsr_write(val, LOONGARCH_CSR_TLB=
EHI)
> +#define read_gcsr_tlblo0()             gcsr_read(LOONGARCH_CSR_TLBELO0)
> +#define write_gcsr_tlblo0(val)         gcsr_write(val, LOONGARCH_CSR_TLB=
ELO0)
> +#define read_gcsr_tlblo1()             gcsr_read(LOONGARCH_CSR_TLBELO1)
> +#define write_gcsr_tlblo1(val)         gcsr_write(val, LOONGARCH_CSR_TLB=
ELO1)
> +
> +#define read_gcsr_asid()               gcsr_read(LOONGARCH_CSR_ASID)
> +#define write_gcsr_asid(val)           gcsr_write(val, LOONGARCH_CSR_ASI=
D)
> +#define read_gcsr_pgdl()               gcsr_read(LOONGARCH_CSR_PGDL)
> +#define write_gcsr_pgdl(val)           gcsr_write(val, LOONGARCH_CSR_PGD=
L)
> +#define read_gcsr_pgdh()               gcsr_read(LOONGARCH_CSR_PGDH)
> +#define write_gcsr_pgdh(val)           gcsr_write(val, LOONGARCH_CSR_PGD=
H)
> +#define write_gcsr_pgd(val)            gcsr_write(val, LOONGARCH_CSR_PGD=
)
> +#define read_gcsr_pgd()                        gcsr_read(LOONGARCH_CSR_P=
GD)
> +#define read_gcsr_pwctl0()             gcsr_read(LOONGARCH_CSR_PWCTL0)
> +#define write_gcsr_pwctl0(val)         gcsr_write(val, LOONGARCH_CSR_PWC=
TL0)
> +#define read_gcsr_pwctl1()             gcsr_read(LOONGARCH_CSR_PWCTL1)
> +#define write_gcsr_pwctl1(val)         gcsr_write(val, LOONGARCH_CSR_PWC=
TL1)
> +#define read_gcsr_stlbpgsize()         gcsr_read(LOONGARCH_CSR_STLBPGSIZ=
E)
> +#define write_gcsr_stlbpgsize(val)     gcsr_write(val, LOONGARCH_CSR_STL=
BPGSIZE)
> +#define read_gcsr_rvacfg()             gcsr_read(LOONGARCH_CSR_RVACFG)
> +#define write_gcsr_rvacfg(val)         gcsr_write(val, LOONGARCH_CSR_RVA=
CFG)
> +
> +#define read_gcsr_cpuid()              gcsr_read(LOONGARCH_CSR_CPUID)
> +#define write_gcsr_cpuid(val)          gcsr_write(val, LOONGARCH_CSR_CPU=
ID)
> +#define read_gcsr_prcfg1()             gcsr_read(LOONGARCH_CSR_PRCFG1)
> +#define write_gcsr_prcfg1(val)         gcsr_write(val, LOONGARCH_CSR_PRC=
FG1)
> +#define read_gcsr_prcfg2()             gcsr_read(LOONGARCH_CSR_PRCFG2)
> +#define write_gcsr_prcfg2(val)         gcsr_write(val, LOONGARCH_CSR_PRC=
FG2)
> +#define read_gcsr_prcfg3()             gcsr_read(LOONGARCH_CSR_PRCFG3)
> +#define write_gcsr_prcfg3(val)         gcsr_write(val, LOONGARCH_CSR_PRC=
FG3)
> +
> +#define read_gcsr_kscratch0()          gcsr_read(LOONGARCH_CSR_KS0)
> +#define write_gcsr_kscratch0(val)      gcsr_write(val, LOONGARCH_CSR_KS0=
)
> +#define read_gcsr_kscratch1()          gcsr_read(LOONGARCH_CSR_KS1)
> +#define write_gcsr_kscratch1(val)      gcsr_write(val, LOONGARCH_CSR_KS1=
)
> +#define read_gcsr_kscratch2()          gcsr_read(LOONGARCH_CSR_KS2)
> +#define write_gcsr_kscratch2(val)      gcsr_write(val, LOONGARCH_CSR_KS2=
)
> +#define read_gcsr_kscratch3()          gcsr_read(LOONGARCH_CSR_KS3)
> +#define write_gcsr_kscratch3(val)      gcsr_write(val, LOONGARCH_CSR_KS3=
)
> +#define read_gcsr_kscratch4()          gcsr_read(LOONGARCH_CSR_KS4)
> +#define write_gcsr_kscratch4(val)      gcsr_write(val, LOONGARCH_CSR_KS4=
)
> +#define read_gcsr_kscratch5()          gcsr_read(LOONGARCH_CSR_KS5)
> +#define write_gcsr_kscratch5(val)      gcsr_write(val, LOONGARCH_CSR_KS5=
)
> +#define read_gcsr_kscratch6()          gcsr_read(LOONGARCH_CSR_KS6)
> +#define write_gcsr_kscratch6(val)      gcsr_write(val, LOONGARCH_CSR_KS6=
)
> +#define read_gcsr_kscratch7()          gcsr_read(LOONGARCH_CSR_KS7)
> +#define write_gcsr_kscratch7(val)      gcsr_write(val, LOONGARCH_CSR_KS7=
)
> +
> +#define read_gcsr_timerid()            gcsr_read(LOONGARCH_CSR_TMID)
> +#define write_gcsr_timerid(val)                gcsr_write(val, LOONGARCH=
_CSR_TMID)
> +#define read_gcsr_timercfg()           gcsr_read(LOONGARCH_CSR_TCFG)
> +#define write_gcsr_timercfg(val)       gcsr_write(val, LOONGARCH_CSR_TCF=
G)
> +#define read_gcsr_timertick()          gcsr_read(LOONGARCH_CSR_TVAL)
> +#define write_gcsr_timertick(val)      gcsr_write(val, LOONGARCH_CSR_TVA=
L)
> +#define read_gcsr_timeroffset()                gcsr_read(LOONGARCH_CSR_C=
NTC)
> +#define write_gcsr_timeroffset(val)    gcsr_write(val, LOONGARCH_CSR_CNT=
C)
> +
> +#define read_gcsr_llbctl()             gcsr_read(LOONGARCH_CSR_LLBCTL)
> +#define write_gcsr_llbctl(val)         gcsr_write(val, LOONGARCH_CSR_LLB=
CTL)
> +
> +#define read_gcsr_tlbrentry()          gcsr_read(LOONGARCH_CSR_TLBRENTRY=
)
> +#define write_gcsr_tlbrentry(val)      gcsr_write(val, LOONGARCH_CSR_TLB=
RENTRY)
> +#define read_gcsr_tlbrbadv()           gcsr_read(LOONGARCH_CSR_TLBRBADV)
> +#define write_gcsr_tlbrbadv(val)       gcsr_write(val, LOONGARCH_CSR_TLB=
RBADV)
> +#define read_gcsr_tlbrera()            gcsr_read(LOONGARCH_CSR_TLBRERA)
> +#define write_gcsr_tlbrera(val)                gcsr_write(val, LOONGARCH=
_CSR_TLBRERA)
> +#define read_gcsr_tlbrsave()           gcsr_read(LOONGARCH_CSR_TLBRSAVE)
> +#define write_gcsr_tlbrsave(val)       gcsr_write(val, LOONGARCH_CSR_TLB=
RSAVE)
> +#define read_gcsr_tlbrelo0()           gcsr_read(LOONGARCH_CSR_TLBRELO0)
> +#define write_gcsr_tlbrelo0(val)       gcsr_write(val, LOONGARCH_CSR_TLB=
RELO0)
> +#define read_gcsr_tlbrelo1()           gcsr_read(LOONGARCH_CSR_TLBRELO1)
> +#define write_gcsr_tlbrelo1(val)       gcsr_write(val, LOONGARCH_CSR_TLB=
RELO1)
> +#define read_gcsr_tlbrehi()            gcsr_read(LOONGARCH_CSR_TLBREHI)
> +#define write_gcsr_tlbrehi(val)                gcsr_write(val, LOONGARCH=
_CSR_TLBREHI)
> +#define read_gcsr_tlbrprmd()           gcsr_read(LOONGARCH_CSR_TLBRPRMD)
> +#define write_gcsr_tlbrprmd(val)       gcsr_write(val, LOONGARCH_CSR_TLB=
RPRMD)
> +
> +#define read_gcsr_directwin0()         gcsr_read(LOONGARCH_CSR_DMWIN0)
> +#define write_gcsr_directwin0(val)     gcsr_write(val, LOONGARCH_CSR_DMW=
IN0)
> +#define read_gcsr_directwin1()         gcsr_read(LOONGARCH_CSR_DMWIN1)
> +#define write_gcsr_directwin1(val)     gcsr_write(val, LOONGARCH_CSR_DMW=
IN1)
> +#define read_gcsr_directwin2()         gcsr_read(LOONGARCH_CSR_DMWIN2)
> +#define write_gcsr_directwin2(val)     gcsr_write(val, LOONGARCH_CSR_DMW=
IN2)
> +#define read_gcsr_directwin3()         gcsr_read(LOONGARCH_CSR_DMWIN3)
> +#define write_gcsr_directwin3(val)     gcsr_write(val, LOONGARCH_CSR_DMW=
IN3)
> +
> +/* Guest related CSRs */
> +#define read_csr_gtlbc()               csr_read64(LOONGARCH_CSR_GTLBC)
> +#define write_csr_gtlbc(val)           csr_write64(val, LOONGARCH_CSR_GT=
LBC)
> +#define read_csr_trgp()                        csr_read64(LOONGARCH_CSR_=
TRGP)
> +#define read_csr_gcfg()                        csr_read64(LOONGARCH_CSR_=
GCFG)
> +#define write_csr_gcfg(val)            csr_write64(val, LOONGARCH_CSR_GC=
FG)
> +#define read_csr_gstat()               csr_read64(LOONGARCH_CSR_GSTAT)
> +#define write_csr_gstat(val)           csr_write64(val, LOONGARCH_CSR_GS=
TAT)
> +#define read_csr_gintc()               csr_read64(LOONGARCH_CSR_GINTC)
> +#define write_csr_gintc(val)           csr_write64(val, LOONGARCH_CSR_GI=
NTC)
> +#define read_csr_gcntc()               csr_read64(LOONGARCH_CSR_GCNTC)
> +#define write_csr_gcntc(val)           csr_write64(val, LOONGARCH_CSR_GC=
NTC)
> +
> +#define __BUILD_GCSR_OP(name)          __BUILD_CSR_COMMON(gcsr_##name)
> +
> +__BUILD_GCSR_OP(llbctl)
> +__BUILD_GCSR_OP(tlbidx)
> +__BUILD_CSR_OP(gcfg)
> +__BUILD_CSR_OP(gstat)
> +__BUILD_CSR_OP(gtlbc)
> +__BUILD_CSR_OP(gintc)
> +
> +#define set_gcsr_estat(val)    \
> +       gcsr_xchg(val, val, LOONGARCH_CSR_ESTAT)
> +#define clear_gcsr_estat(val)  \
> +       gcsr_xchg(~(val), val, LOONGARCH_CSR_ESTAT)
> +
> +#define kvm_read_hw_gcsr(id)           gcsr_read(id)
> +#define kvm_write_hw_gcsr(id, val)     gcsr_write(val, id)
> +
> +int kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v);
> +int kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 v);
> +int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu =
*vcpu);
> +
> +#define kvm_save_hw_gcsr(csr, gid)     (csr->csrs[gid] =3D gcsr_read(gid=
))
> +#define kvm_restore_hw_gcsr(csr, gid)  (gcsr_write(csr->csrs[gid], gid))
> +
> +static __always_inline unsigned long kvm_read_sw_gcsr(struct loongarch_c=
srs *csr, int gid)
> +{
> +       return csr->csrs[gid];
> +}
> +
> +static __always_inline void kvm_write_sw_gcsr(struct loongarch_csrs *csr=
,
> +                                             int gid, unsigned long val)
> +{
> +       csr->csrs[gid] =3D val;
> +}
> +
> +static __always_inline void kvm_set_sw_gcsr(struct loongarch_csrs *csr,
> +                                           int gid, unsigned long val)
> +{
> +       csr->csrs[gid] |=3D val;
> +}
> +
> +static __always_inline void kvm_change_sw_gcsr(struct loongarch_csrs *cs=
r,
> +                                              int gid, unsigned long mas=
k,
> +                                              unsigned long val)
> +{
> +       unsigned long _mask =3D mask;
> +
> +       csr->csrs[gid] &=3D ~_mask;
> +       csr->csrs[gid] |=3D val & _mask;
> +}
> +#endif /* __ASM_LOONGARCH_KVM_CSR_H__ */
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> new file mode 100644
> index 0000000000..7756f27183
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -0,0 +1,107 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_LOONGARCH_KVM_VCPU_H__
> +#define __ASM_LOONGARCH_KVM_VCPU_H__
> +
> +#include <linux/kvm_host.h>
> +#include <asm/loongarch.h>
> +
> +/* Controlled by 0x5 guest exst */
> +#define CPU_SIP0                       (_ULCAST_(1))
> +#define CPU_SIP1                       (_ULCAST_(1) << 1)
> +#define CPU_PMU                                (_ULCAST_(1) << 10)
> +#define CPU_TIMER                      (_ULCAST_(1) << 11)
> +#define CPU_IPI                                (_ULCAST_(1) << 12)
> +
> +/* Controlled by 0x52 guest exception VIP
> + * aligned to exst bit 5~12
> + */
> +#define CPU_IP0                                (_ULCAST_(1))
> +#define CPU_IP1                                (_ULCAST_(1) << 1)
> +#define CPU_IP2                                (_ULCAST_(1) << 2)
> +#define CPU_IP3                                (_ULCAST_(1) << 3)
> +#define CPU_IP4                                (_ULCAST_(1) << 4)
> +#define CPU_IP5                                (_ULCAST_(1) << 5)
> +#define CPU_IP6                                (_ULCAST_(1) << 6)
> +#define CPU_IP7                                (_ULCAST_(1) << 7)
> +
> +#define MNSEC_PER_SEC                  (NSEC_PER_SEC >> 20)
> +
> +/* KVM_IRQ_LINE irq field index values */
> +#define KVM_LOONGSON_IRQ_TYPE_SHIFT    24
> +#define KVM_LOONGSON_IRQ_TYPE_MASK     0xff
> +#define KVM_LOONGSON_IRQ_VCPU_SHIFT    16
> +#define KVM_LOONGSON_IRQ_VCPU_MASK     0xff
> +#define KVM_LOONGSON_IRQ_NUM_SHIFT     0
> +#define KVM_LOONGSON_IRQ_NUM_MASK      0xffff
> +
> +/* Irq_type field */
> +#define KVM_LOONGSON_IRQ_TYPE_CPU_IP   0
> +#define KVM_LOONGSON_IRQ_TYPE_CPU_IO   1
> +#define KVM_LOONGSON_IRQ_TYPE_HT       2
> +#define KVM_LOONGSON_IRQ_TYPE_MSI      3
> +#define KVM_LOONGSON_IRQ_TYPE_IOAPIC   4
> +#define KVM_LOONGSON_IRQ_TYPE_ROUTE    5
I think the types should be refined, so please give me a better definition.

> +
> +/* Out-of-kernel GIC cpu interrupt injection irq_number field */
> +#define KVM_LOONGSON_IRQ_CPU_IRQ       0
> +#define KVM_LOONGSON_IRQ_CPU_FIQ       1
> +#define KVM_LOONGSON_CPU_IP_NUM                8
And these lines should be removed, right?

Huacai

> +
> +typedef union loongarch_instruction  larch_inst;
> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> +
> +int  kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst);
> +int  kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst);
> +int  kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int  kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
> +int  kvm_emu_idle(struct kvm_vcpu *vcpu);
> +int  kvm_handle_pv_hcall(struct kvm_vcpu *vcpu);
> +int  kvm_pending_timer(struct kvm_vcpu *vcpu);
> +int  kvm_handle_fault(struct kvm_vcpu *vcpu, int fault);
> +void kvm_deliver_intr(struct kvm_vcpu *vcpu);
> +void kvm_deliver_exception(struct kvm_vcpu *vcpu);
> +
> +void kvm_own_fpu(struct kvm_vcpu *vcpu);
> +void kvm_lose_fpu(struct kvm_vcpu *vcpu);
> +void kvm_save_fpu(struct loongarch_fpu *fpu);
> +void kvm_restore_fpu(struct loongarch_fpu *fpu);
> +void kvm_restore_fcsr(struct loongarch_fpu *fpu);
> +
> +void kvm_acquire_timer(struct kvm_vcpu *vcpu);
> +void kvm_reset_timer(struct kvm_vcpu *vcpu);
> +void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
> +void kvm_restore_timer(struct kvm_vcpu *vcpu);
> +void kvm_save_timer(struct kvm_vcpu *vcpu);
> +
> +int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt=
 *irq);
> +/*
> + * Loongarch KVM guest interrupt handling
> + */
> +static inline void kvm_queue_irq(struct kvm_vcpu *vcpu, unsigned int irq=
)
> +{
> +       set_bit(irq, &vcpu->arch.irq_pending);
> +       clear_bit(irq, &vcpu->arch.irq_clear);
> +}
> +
> +static inline void kvm_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int i=
rq)
> +{
> +       clear_bit(irq, &vcpu->arch.irq_pending);
> +       set_bit(irq, &vcpu->arch.irq_clear);
> +}
> +
> +static inline int kvm_queue_exception(struct kvm_vcpu *vcpu,
> +                       unsigned int code, unsigned int subcode)
> +{
> +       /* only one exception can be injected */
> +       if (!vcpu->arch.exception_pending) {
> +               set_bit(code, &vcpu->arch.exception_pending);
> +               vcpu->arch.subcode =3D subcode;
> +               return 0;
> +       } else
> +               return -1;
> +}
> +#endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index 33531d432b..9b4957cefa 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -226,6 +226,7 @@
>  #define LOONGARCH_CSR_ECFG             0x4     /* Exception config */
>  #define  CSR_ECFG_VS_SHIFT             16
>  #define  CSR_ECFG_VS_WIDTH             3
> +#define  CSR_ECFG_VS_SHIFT_END         (CSR_ECFG_VS_SHIFT + CSR_ECFG_VS_=
WIDTH - 1)
>  #define  CSR_ECFG_VS                   (_ULCAST_(0x7) << CSR_ECFG_VS_SHI=
FT)
>  #define  CSR_ECFG_IM_SHIFT             0
>  #define  CSR_ECFG_IM_WIDTH             14
> @@ -314,13 +315,14 @@
>  #define  CSR_TLBLO1_V                  (_ULCAST_(0x1) << CSR_TLBLO1_V_SH=
IFT)
>
>  #define LOONGARCH_CSR_GTLBC            0x15    /* Guest TLB control */
> -#define  CSR_GTLBC_RID_SHIFT           16
> -#define  CSR_GTLBC_RID_WIDTH           8
> -#define  CSR_GTLBC_RID                 (_ULCAST_(0xff) << CSR_GTLBC_RID_=
SHIFT)
> +#define  CSR_GTLBC_TGID_SHIFT          16
> +#define  CSR_GTLBC_TGID_WIDTH          8
> +#define  CSR_GTLBC_TGID_SHIFT_END      (CSR_GTLBC_TGID_SHIFT + CSR_GTLBC=
_TGID_WIDTH - 1)
> +#define  CSR_GTLBC_TGID                        (_ULCAST_(0xff) << CSR_GT=
LBC_TGID_SHIFT)
>  #define  CSR_GTLBC_TOTI_SHIFT          13
>  #define  CSR_GTLBC_TOTI                        (_ULCAST_(0x1) << CSR_GTL=
BC_TOTI_SHIFT)
> -#define  CSR_GTLBC_USERID_SHIFT                12
> -#define  CSR_GTLBC_USERID              (_ULCAST_(0x1) << CSR_GTLBC_USERI=
D_SHIFT)
> +#define  CSR_GTLBC_USETGID_SHIFT       12
> +#define  CSR_GTLBC_USETGID             (_ULCAST_(0x1) << CSR_GTLBC_USETG=
ID_SHIFT)
>  #define  CSR_GTLBC_GMTLBSZ_SHIFT       0
>  #define  CSR_GTLBC_GMTLBSZ_WIDTH       6
>  #define  CSR_GTLBC_GMTLBSZ             (_ULCAST_(0x3f) << CSR_GTLBC_GMTL=
BSZ_SHIFT)
> @@ -475,6 +477,7 @@
>  #define LOONGARCH_CSR_GSTAT            0x50    /* Guest status */
>  #define  CSR_GSTAT_GID_SHIFT           16
>  #define  CSR_GSTAT_GID_WIDTH           8
> +#define  CSR_GSTAT_GID_SHIFT_END       (CSR_GSTAT_GID_SHIFT + CSR_GSTAT_=
GID_WIDTH - 1)
>  #define  CSR_GSTAT_GID                 (_ULCAST_(0xff) << CSR_GSTAT_GID_=
SHIFT)
>  #define  CSR_GSTAT_GIDBIT_SHIFT                4
>  #define  CSR_GSTAT_GIDBIT_WIDTH                6
> @@ -525,6 +528,12 @@
>  #define  CSR_GCFG_MATC_GUEST           (_ULCAST_(0x0) << CSR_GCFG_MATC_S=
HITF)
>  #define  CSR_GCFG_MATC_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATC_S=
HITF)
>  #define  CSR_GCFG_MATC_NEST            (_ULCAST_(0x2) << CSR_GCFG_MATC_S=
HITF)
> +#define  CSR_GCFG_MATP_NEST_SHIFT      2
> +#define  CSR_GCFG_MATP_NEST            (_ULCAST_(0x1) << CSR_GCFG_MATP_N=
EST_SHIFT)
> +#define  CSR_GCFG_MATP_ROOT_SHIFT      1
> +#define  CSR_GCFG_MATP_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATP_R=
OOT_SHIFT)
> +#define  CSR_GCFG_MATP_GUEST_SHIFT     0
> +#define  CSR_GCFG_MATP_GUEST           (_ULCAST_(0x1) << CSR_GCFG_MATP_G=
UEST_SHIFT)
>
>  #define LOONGARCH_CSR_GINTC            0x52    /* Guest interrupt contro=
l */
>  #define  CSR_GINTC_HC_SHIFT            16
> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> new file mode 100644
> index 0000000000..134b5968f6
> --- /dev/null
> +++ b/arch/loongarch/kvm/trace.h
> @@ -0,0 +1,166 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_KVM_H
> +
> +#include <linux/tracepoint.h>
> +#include <asm/kvm_csr.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM   kvm
> +
> +/*
> + * Tracepoints for VM enters
> + */
> +DECLARE_EVENT_CLASS(kvm_transition,
> +       TP_PROTO(struct kvm_vcpu *vcpu),
> +       TP_ARGS(vcpu),
> +       TP_STRUCT__entry(
> +               __field(unsigned long, pc)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->pc =3D vcpu->arch.pc;
> +       ),
> +
> +       TP_printk("PC: 0x%08lx",
> +                 __entry->pc)
> +);
> +
> +DEFINE_EVENT(kvm_transition, kvm_enter,
> +            TP_PROTO(struct kvm_vcpu *vcpu),
> +            TP_ARGS(vcpu));
> +
> +DEFINE_EVENT(kvm_transition, kvm_reenter,
> +            TP_PROTO(struct kvm_vcpu *vcpu),
> +            TP_ARGS(vcpu));
> +
> +DEFINE_EVENT(kvm_transition, kvm_out,
> +            TP_PROTO(struct kvm_vcpu *vcpu),
> +            TP_ARGS(vcpu));
> +
> +/* Further exit reasons */
> +#define KVM_TRACE_EXIT_IDLE            64
> +#define KVM_TRACE_EXIT_CACHE           65
> +
> +/* Tracepoints for VM exits */
> +#define kvm_trace_symbol_exit_types                    \
> +       { KVM_TRACE_EXIT_IDLE,          "IDLE" },       \
> +       { KVM_TRACE_EXIT_CACHE,         "CACHE" }
> +
> +TRACE_EVENT(kvm_exit_gspr,
> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int inst_word),
> +           TP_ARGS(vcpu, inst_word),
> +           TP_STRUCT__entry(
> +                       __field(unsigned int, inst_word)
> +           ),
> +
> +           TP_fast_assign(
> +                       __entry->inst_word =3D inst_word;
> +           ),
> +
> +           TP_printk("inst word: 0x%08x",
> +                     __entry->inst_word)
> +);
> +
> +
> +DECLARE_EVENT_CLASS(kvm_exit,
> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> +           TP_ARGS(vcpu, reason),
> +           TP_STRUCT__entry(
> +                       __field(unsigned long, pc)
> +                       __field(unsigned int, reason)
> +           ),
> +
> +           TP_fast_assign(
> +                       __entry->pc =3D vcpu->arch.pc;
> +                       __entry->reason =3D reason;
> +           ),
> +
> +           TP_printk("[%s]PC: 0x%08lx",
> +                     __print_symbolic(__entry->reason,
> +                                      kvm_trace_symbol_exit_types),
> +                     __entry->pc)
> +);
> +
> +DEFINE_EVENT(kvm_exit, kvm_exit_idle,
> +            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> +            TP_ARGS(vcpu, reason));
> +
> +DEFINE_EVENT(kvm_exit, kvm_exit_cache,
> +            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> +            TP_ARGS(vcpu, reason));
> +
> +DEFINE_EVENT(kvm_exit, kvm_exit,
> +            TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> +            TP_ARGS(vcpu, reason));
> +
> +#define KVM_TRACE_AUX_RESTORE          0
> +#define KVM_TRACE_AUX_SAVE             1
> +#define KVM_TRACE_AUX_ENABLE           2
> +#define KVM_TRACE_AUX_DISABLE          3
> +#define KVM_TRACE_AUX_DISCARD          4
> +
> +#define KVM_TRACE_AUX_FPU              1
> +
> +#define kvm_trace_symbol_aux_op                                \
> +       { KVM_TRACE_AUX_RESTORE,        "restore" },    \
> +       { KVM_TRACE_AUX_SAVE,           "save" },       \
> +       { KVM_TRACE_AUX_ENABLE,         "enable" },     \
> +       { KVM_TRACE_AUX_DISABLE,        "disable" },    \
> +       { KVM_TRACE_AUX_DISCARD,        "discard" }
> +
> +#define kvm_trace_symbol_aux_state                     \
> +       { KVM_TRACE_AUX_FPU,     "FPU" }
> +
> +TRACE_EVENT(kvm_aux,
> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
> +                    unsigned int state),
> +           TP_ARGS(vcpu, op, state),
> +           TP_STRUCT__entry(
> +                       __field(unsigned long, pc)
> +                       __field(u8, op)
> +                       __field(u8, state)
> +           ),
> +
> +           TP_fast_assign(
> +                       __entry->pc =3D vcpu->arch.pc;
> +                       __entry->op =3D op;
> +                       __entry->state =3D state;
> +           ),
> +
> +           TP_printk("%s %s PC: 0x%08lx",
> +                     __print_symbolic(__entry->op,
> +                                      kvm_trace_symbol_aux_op),
> +                     __print_symbolic(__entry->state,
> +                                      kvm_trace_symbol_aux_state),
> +                     __entry->pc)
> +);
> +
> +TRACE_EVENT(kvm_vpid_change,
> +           TP_PROTO(struct kvm_vcpu *vcpu, unsigned long vpid),
> +           TP_ARGS(vcpu, vpid),
> +           TP_STRUCT__entry(
> +                       __field(unsigned long, vpid)
> +           ),
> +
> +           TP_fast_assign(
> +                       __entry->vpid =3D vpid;
> +           ),
> +
> +           TP_printk("vpid: 0x%08lx",
> +                     __entry->vpid)
> +);
> +
> +#endif /* _TRACE_LOONGARCH64_KVM_H */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../arch/loongarch/kvm
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE trace
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --
> 2.39.1
>
>
