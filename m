Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911C11CF3F3
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 14:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgELMEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 08:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgELMEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 08:04:04 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498CCC061A0C;
        Tue, 12 May 2020 05:04:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so21431293wmk.5;
        Tue, 12 May 2020 05:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PMELSOtIJq8icXiOy447CmhBLkL+DrVMIqM3HCGDy/k=;
        b=Qi3kTenjls0txvjTAAazd2qIjCPPbcTcA79RiT/kPkZfWgOBE8t9gbpkFa2O2hIsKu
         +/e4WlOwqGoMWFSvpvXXEcMZA84WRRKKS9BoagzW1Rf94tpZCTZiVo3uQQic5XfzY2y8
         JRGu9xMIBgExABBoXfvitDo01Hp3JD/p0ZE7c+1ntnQ0elFJnaVD+CwQqjzGmcQkMZXB
         NVCkGy+ghGof54v/zZl2senq9tsUODYAeI3U2vEyy4YtKszdvI2dk8MdPhYNPR1skkJj
         Y5o8ssykTxET0ULsxrS8JEM7ti2EVGhtizpkBPix9GXTqGN6mU9l18dY7hH6U9Yks0OD
         yd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PMELSOtIJq8icXiOy447CmhBLkL+DrVMIqM3HCGDy/k=;
        b=a2OAks99vwLiP90mPD7mkriCBjbcELA5M6WVaOWiDpP23/Qju2zpdDiqoeja11Dvcg
         t8sserfXHp47PwvlgcqWyLXVbEoioUXMq3qYxrKtllVFAoIbHxhmNI7irrA6SQkAAzLq
         bruIELxAPO71HndMM5SyuPZrthA32PHDmCr+0ogCUkJkIqy7FhE8bWScF95Aer5AWu0g
         890UjePG+J0kpd/3DPwcZZNHDkHbgBy9NjVL5+P47dOaBA6akeeDvfgY6lxv4LTeYGhi
         ui3TdaMD9nT3bI4wM47atdmdkIlHFb4lF+iLf43En/gdNo8dxQagTubqQPcYnxObhzmT
         KVHQ==
X-Gm-Message-State: AGi0Pua5F+y10lPYHuKsBLPeGSTPk/YGx8T8mSnLvpxyGHYFreZO9s02
        wylqBafMz16zmXAuS5XEhMwo5Py877ENb2sSpDQ=
X-Google-Smtp-Source: APiQypKEI/kuLXubKVJiCE6c/tQMU9rEEoca5RDVXhReooIijTyTOoZ1Gvje1OMF4yW20na7jUGr6sbQBTTXk8OEJxQ=
X-Received: by 2002:a1c:2dc7:: with SMTP id t190mr35323379wmt.129.1589285042861;
 Tue, 12 May 2020 05:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com> <1589279480-27722-12-git-send-email-chenhc@lemote.com>
In-Reply-To: <1589279480-27722-12-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Tue, 12 May 2020 14:03:11 +0200
Message-ID: <CAHiYmc7i1bm=5Xmmv_e-k2sZakticcXBZqBB40ERATX1kL3MZg@mail.gmail.com>
Subject: Re: [PATCH V4 11/14] KVM: MIPS: Add CPUCFG emulation for Loongson-3
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D1=83=D1=82=D0=BE, 12. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:35 Huacai Chen <=
chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Loongson-3 overrides lwc2 instructions to implement CPUCFG and CSR
> read/write functions. These instructions all cause guest exit so CSR
> doesn't benifit KVM guest (and there are always legacy methods to
> provide the same functions as CSR). So, we only emulate CPUCFG and let
> it return a reduced feature list (which means the virtual CPU doesn't
> have any other advanced features, including CSR) in KVM.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>  arch/mips/include/asm/kvm_host.h  |  3 ++
>  arch/mips/include/uapi/asm/inst.h | 11 ++++++
>  arch/mips/kvm/mips.c              |  3 ++
>  arch/mips/kvm/vz.c                | 75 +++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 92 insertions(+)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm=
_host.h
> index f165902..3fd2f1c 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -173,6 +173,9 @@ struct kvm_vcpu_stat {
>         u64 vz_ghfc_exits;
>         u64 vz_gpa_exits;
>         u64 vz_resvd_exits;
> +#ifdef CONFIG_CPU_LOONGSON64
> +       u64 vz_cpucfg_exits;
> +#endif
>  #endif
>         u64 halt_successful_poll;
>         u64 halt_attempted_poll;
> diff --git a/arch/mips/include/uapi/asm/inst.h b/arch/mips/include/uapi/a=
sm/inst.h
> index 98f97c8..43d1faa 100644
> --- a/arch/mips/include/uapi/asm/inst.h
> +++ b/arch/mips/include/uapi/asm/inst.h
> @@ -1012,6 +1012,16 @@ struct loongson3_lsdc2_format {  /* Loongson-3 ove=
rridden ldc2/sdc2 Load/Store fo
>         ;))))))
>  };
>
> +struct loongson3_lscsr_format {        /* Loongson-3 CPUCFG&CSR read/wri=
te format */
> +       __BITFIELD_FIELD(unsigned int opcode : 6,
> +       __BITFIELD_FIELD(unsigned int rs : 5,
> +       __BITFIELD_FIELD(unsigned int fr : 5,
> +       __BITFIELD_FIELD(unsigned int rd : 5,
> +       __BITFIELD_FIELD(unsigned int fd : 5,
> +       __BITFIELD_FIELD(unsigned int func : 6,
> +       ;))))))
> +};
> +
>  /*
>   * MIPS16e instruction formats (16-bit length)
>   */
> @@ -1114,6 +1124,7 @@ union mips_instruction {
>         struct mm16_r5_format mm16_r5_format;
>         struct loongson3_lswc2_format loongson3_lswc2_format;
>         struct loongson3_lsdc2_format loongson3_lsdc2_format;
> +       struct loongson3_lscsr_format loongson3_lscsr_format;
>  };
>
>  union mips16e_instruction {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index ed989ef..9362769 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -68,6 +68,9 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
>         { "vz_ghfc",      VCPU_STAT(vz_ghfc_exits),      KVM_STAT_VCPU },
>         { "vz_gpa",       VCPU_STAT(vz_gpa_exits),       KVM_STAT_VCPU },
>         { "vz_resvd",     VCPU_STAT(vz_resvd_exits),     KVM_STAT_VCPU },
> +#ifdef CONFIG_CPU_LOONGSON64
> +       { "vz_cpucfg",    VCPU_STAT(vz_cpucfg_exits),    KVM_STAT_VCPU },
> +#endif
>  #endif
>         { "halt_successful_poll", VCPU_STAT(halt_successful_poll), KVM_ST=
AT_VCPU },
>         { "halt_attempted_poll", VCPU_STAT(halt_attempted_poll), KVM_STAT=
_VCPU },
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 63d5b35..e5c751b 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -29,6 +29,7 @@
>  #include <linux/kvm_host.h>
>
>  #include "interrupt.h"
> +#include "loongson_regs.h"
>
>  #include "trace.h"
>
> @@ -1092,6 +1093,75 @@ static enum emulation_result kvm_vz_gpsi_cache(uni=
on mips_instruction inst,
>         return EMULATE_FAIL;
>  }
>
> +#ifdef CONFIG_CPU_LOONGSON64
> +static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction ins=
t,
> +                                             u32 *opc, u32 cause,
> +                                             struct kvm_run *run,
> +                                             struct kvm_vcpu *vcpu)
> +{
> +       unsigned int rs, rd;
> +       unsigned int hostcfg;
> +       unsigned long curr_pc;
> +       enum emulation_result er =3D EMULATE_DONE;
> +
> +       /*
> +        * Update PC and hold onto current PC in case there is
> +        * an error and we want to rollback the PC
> +        */
> +       curr_pc =3D vcpu->arch.pc;
> +       er =3D update_pc(vcpu, cause);
> +       if (er =3D=3D EMULATE_FAIL)
> +               return er;
> +
> +       rs =3D inst.loongson3_lscsr_format.rs;
> +       rd =3D inst.loongson3_lscsr_format.rd;
> +       switch (inst.loongson3_lscsr_format.fr) {
> +       case 0x8:  /* Read CPUCFG */
> +               ++vcpu->stat.vz_cpucfg_exits;
> +               hostcfg =3D read_cpucfg(vcpu->arch.gprs[rs]);
> +
> +               switch (vcpu->arch.gprs[rs]) {
> +               case LOONGSON_CFG1:
> +                       hostcfg &=3D (LOONGSON_CFG1_FP | LOONGSON_CFG1_MM=
I |
> +                                   LOONGSON_CFG1_MSA1 | LOONGSON_CFG1_MS=
A2 |
> +                                   LOONGSON_CFG1_SFBP);
> +                       vcpu->arch.gprs[rd] =3D hostcfg;
> +                       break;
> +               case LOONGSON_CFG2:
> +                       hostcfg &=3D (LOONGSON_CFG2_LEXT1 | LOONGSON_CFG2=
_LEXT2 |
> +                                   LOONGSON_CFG2_LEXT3 | LOONGSON_CFG2_L=
SPW);
> +                       vcpu->arch.gprs[rd] =3D hostcfg;
> +                       break;
> +               case LOONGSON_CFG3:
> +                       hostcfg &=3D LOONGSON_CFG3_LCAMP;
> +                       vcpu->arch.gprs[rd] =3D hostcfg;
> +                       break;
> +               default:
> +                       /* Don't export any other advanced features to gu=
est */
> +                       vcpu->arch.gprs[rd] =3D 0;
> +                       break;
> +               }
> +               break;
> +
> +       default:
> +               kvm_err("lwc2 emulate not impl %d rs %lx @%lx\n",
> +                       inst.loongson3_lscsr_format.fr, vcpu->arch.gprs[r=
s], curr_pc);
> +               er =3D EMULATE_FAIL;
> +               break;
> +       }
> +
> +       /* Rollback PC only if emulation was unsuccessful */
> +       if (er =3D=3D EMULATE_FAIL) {
> +               kvm_err("[%#lx]%s: unsupported lwc2 instruction 0x%08x 0x=
%08x\n",
> +                       curr_pc, __func__, inst.word, inst.loongson3_lscs=
r_format.fr);
> +
> +               vcpu->arch.pc =3D curr_pc;
> +       }
> +
> +       return er;
> +}
> +#endif
> +
>  static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc=
,
>                                                      struct kvm_vcpu *vcp=
u)
>  {
> @@ -1121,6 +1191,11 @@ static enum emulation_result kvm_trap_vz_handle_gp=
si(u32 cause, u32 *opc,
>                 er =3D kvm_vz_gpsi_cache(inst, opc, cause, run, vcpu);
>                 break;
>  #endif
> +#ifdef CONFIG_CPU_LOONGSON64
> +       case lwc2_op:
> +               er =3D kvm_vz_gpsi_lwc2(inst, opc, cause, run, vcpu);
> +               break;
> +#endif
>         case spec3_op:
>                 switch (inst.spec3_format.func) {
>  #ifdef CONFIG_CPU_MIPSR6
> --
> 2.7.0
>
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index ac46840..dc753d0 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -1169,6 +1169,9 @@ static enum emulation_result kvm_vz_gpsi_lwc2(union=
 mips_instruction inst,
>                 hostcfg =3D read_cpucfg(vcpu->arch.gprs[rs]);
>
>                 switch (vcpu->arch.gprs[rs]) {
> +               case LOONGSON_CFG0:
> +                       vcpu->arch.gprs[rd] =3D 0x14c000;
> +                       break;
>                 case LOONGSON_CFG1:
>                         hostcfg &=3D (LOONGSON_CFG1_FP | LOONGSON_CFG1_MM=
I |
>                                     LOONGSON_CFG1_MSA1 | LOONGSON_CFG1_MS=
A2 |
> @@ -1181,7 +1184,6 @@ static enum emulation_result kvm_vz_gpsi_lwc2(union=
 mips_instruction inst,
>                         vcpu->arch.gprs[rd] =3D hostcfg;
>                         break;
>                 case LOONGSON_CFG3:
> -                       hostcfg &=3D LOONGSON_CFG3_LCAMP;
>                         vcpu->arch.gprs[rd] =3D hostcfg;
>                         break;
>                 default:
