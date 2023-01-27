Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A167E4F1
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbjA0MS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjA0MSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:18:40 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50F340BC3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:15:13 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id h19so3302414vsv.13
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=voPlRXxpBMdM10/rkXj6aBG2pUgoFvgwiJZKHRVQeYQ=;
        b=Sff+hvOU2iCljIh8CEpYcZUcRd0FRki4/VqfCxncuM4Uf00IxJXzS+8RF5NorDYDrw
         +DuYI5nqbF7lPekG29BAMsQY6xP/EZ7qMK/dvSsoY9vANM5W00IkRBVsCet7tZLJRopH
         X/PdE4aqSJoE1Wkbp8Xi4NK8DkerjDWMYCnz6pooap+TrpVTnBPjLGVVEmfrrbCW8SFs
         B/TNOUX7JTd20zRHEWCxogSPcOhbBqFCC6b2Nd8OIUqTrgFYZ3gZMMjEJ0BkN4W2SAJb
         qVSL90VSO1/zClkUvjrvtGkDigSpFsQ6P/UcW/fv4k5K54g1OdGS9tPAv82Eqjqf1Vx3
         9gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=voPlRXxpBMdM10/rkXj6aBG2pUgoFvgwiJZKHRVQeYQ=;
        b=0dtp/NILJUbBrVRCdwR8pX+94SkP44UavYqWemYZexVfYAIcAS77VTPmDE8If55rwa
         Oc8t0o7NHA1kNfZ73r1SChWGoo0My5VZPhiEjW4GOhTXn2nBk1H41RaJi93QekFMUqoa
         t5EzNBLLdMJXTlyDmH51/ZmaT05NpfRWS/tpX9ao8zAVRxoZWuqdRsL0LRWbtJUWMfdf
         WybfFklx1sCfLp/GKejV+uiMYM9tVJ+jQO3rI6UYHhX5m725cw/MZ0mG5iyJ0BisQweg
         XjOVZE/wucKi7DINyTrFW4V5ZtG8kJ79ooO1ap95y1zEU2qX7Pa3bf0N18avlwr6pDUC
         PYAw==
X-Gm-Message-State: AFqh2kr6rgPPoYADsHR5kFx9WajXvDTbX+aSgErAmJQczmILdz2+ztMT
        9e1dVGkLZo2GtI50xqq7diqYpfV6BWjG0mygN9MheQ==
X-Google-Smtp-Source: AMrXdXtq0XX0/BXZTy4vtKTn/J0d3fbU8rAMqVfyLhoN29ydFe2ekri5sPJZKqdpzOA8471Maw+InB+gRIX3839s1Vg=
X-Received: by 2002:a05:6102:c16:b0:3d3:e027:877a with SMTP id
 x22-20020a0561020c1600b003d3e027877amr5440401vss.0.1674821706879; Fri, 27 Jan
 2023 04:15:06 -0800 (PST)
MIME-Version: 1.0
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
 <20230112140304.1830648-2-apatel@ventanamicro.com> <20230126154753.txhgaqgudnksymrm@orel>
In-Reply-To: <20230126154753.txhgaqgudnksymrm@orel>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 27 Jan 2023 17:44:54 +0530
Message-ID: <CAK9=C2UEF=ta08wwm=nnHgL9yqFCa_03L6UX-SuNLffHhXc45Q@mail.gmail.com>
Subject: Re: [PATCH 1/7] RISC-V: Add AIA related CSR defines
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 9:17 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Jan 12, 2023 at 07:32:58PM +0530, Anup Patel wrote:
> > The RISC-V AIA specification improves handling per-HART local interrupts
> > in a backward compatible manner. This patch adds defines for new RISC-V
> > AIA CSRs.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/csr.h | 93 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 93 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> > index 0e571f6483d9..d608dac4b19f 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -73,7 +73,10 @@
> >  #define IRQ_S_EXT            9
> >  #define IRQ_VS_EXT           10
> >  #define IRQ_M_EXT            11
> > +#define IRQ_S_GEXT           12
> >  #define IRQ_PMU_OVF          13
> > +#define IRQ_LOCAL_MAX                (IRQ_PMU_OVF + 1)
> > +#define IRQ_LOCAL_MASK               ((_AC(1, UL) << IRQ_LOCAL_MAX) - 1)
>
> How about instead of the above two defines we do
>
>   #define IRQ_LOCAL_MASK GENMASK(13, 0)
>
> And in general it might be nice to put GENMASK to work for all the
> new masks below.
>
> >
> >  /* Exception causes */
> >  #define EXC_INST_MISALIGNED  0
> > @@ -156,6 +159,27 @@
> >                                (_AC(1, UL) << IRQ_S_TIMER) | \
> >                                (_AC(1, UL) << IRQ_S_EXT))
> >
> > +/* AIA CSR bits */
> > +#define TOPI_IID_SHIFT               16
> > +#define TOPI_IID_MASK                _AC(0xfff, UL)
> > +#define TOPI_IPRIO_MASK              _AC(0xff, UL)
> > +#define TOPI_IPRIO_BITS              8
> > +
> > +#define TOPEI_ID_SHIFT               16
> > +#define TOPEI_ID_MASK                _AC(0x7ff, UL)
> > +#define TOPEI_PRIO_MASK              _AC(0x7ff, UL)
> > +
> > +#define ISELECT_IPRIO0               0x30
> > +#define ISELECT_IPRIO15              0x3f
> > +#define ISELECT_MASK         _AC(0x1ff, UL)
> > +
> > +#define HVICTL_VTI           _AC(0x40000000, UL)
>
> I'd rather read this as '1 << 30' to match the spec and other
> bit masks in this file. Actually, it'd be nice if BIT() was
> used throughout this file, e.g. #define HVICTL_VTI BIT(30)
>
> > +#define HVICTL_IID           _AC(0x0fff0000, UL)
> > +#define HVICTL_IID_SHIFT     16
> > +#define HVICTL_DPR           _AC(0x00000200, UL)
> > +#define HVICTL_IPRIOM                _AC(0x00000100, UL)
> > +#define HVICTL_IPRIO         _AC(0x000000ff, UL)
> > +
> >  /* xENVCFG flags */
> >  #define ENVCFG_STCE                  (_AC(1, ULL) << 63)
> >  #define ENVCFG_PBMTE                 (_AC(1, ULL) << 62)
> > @@ -250,6 +274,18 @@
> >  #define CSR_STIMECMP         0x14D
> >  #define CSR_STIMECMPH                0x15D
> >
> > +/* Supervisor-Level Window to Indirectly Accessed Registers (AIA) */
> > +#define CSR_SISELECT         0x150
> > +#define CSR_SIREG            0x151
> > +
> > +/* Supervisor-Level Interrupts (AIA) */
> > +#define CSR_STOPEI           0x15c
> > +#define CSR_STOPI            0xdb0
> > +
> > +/* Supervisor-Level High-Half CSRs (AIA) */
> > +#define CSR_SIEH             0x114
> > +#define CSR_SIPH             0x154
> > +
> >  #define CSR_VSSTATUS         0x200
> >  #define CSR_VSIE             0x204
> >  #define CSR_VSTVEC           0x205
> > @@ -279,8 +315,32 @@
> >  #define CSR_HGATP            0x680
> >  #define CSR_HGEIP            0xe12
> >
> > +/* Virtual Interrupts and Interrupt Priorities (H-extension with AIA) */
> > +#define CSR_HVIEN            0x608
> > +#define CSR_HVICTL           0x609
> > +#define CSR_HVIPRIO1         0x646
> > +#define CSR_HVIPRIO2         0x647
> > +
> > +/* VS-Level Window to Indirectly Accessed Registers (H-extension with AIA) */
> > +#define CSR_VSISELECT                0x250
> > +#define CSR_VSIREG           0x251
> > +
> > +/* VS-Level Interrupts (H-extension with AIA) */
> > +#define CSR_VSTOPEI          0x25c
> > +#define CSR_VSTOPI           0xeb0
> > +
> > +/* Hypervisor and VS-Level High-Half CSRs (H-extension with AIA) */
> > +#define CSR_HIDELEGH         0x613
> > +#define CSR_HVIENH           0x618
> > +#define CSR_HVIPH            0x655
> > +#define CSR_HVIPRIO1H                0x656
> > +#define CSR_HVIPRIO2H                0x657
> > +#define CSR_VSIEH            0x214
> > +#define CSR_VSIPH            0x254
> > +
> >  #define CSR_MSTATUS          0x300
> >  #define CSR_MISA             0x301
> > +#define CSR_MIDELEG          0x303
> >  #define CSR_MIE                      0x304
> >  #define CSR_MTVEC            0x305
> >  #define CSR_MENVCFG          0x30a
> > @@ -297,6 +357,25 @@
> >  #define CSR_MIMPID           0xf13
> >  #define CSR_MHARTID          0xf14
> >
> > +/* Machine-Level Window to Indirectly Accessed Registers (AIA) */
> > +#define CSR_MISELECT         0x350
> > +#define CSR_MIREG            0x351
> > +
> > +/* Machine-Level Interrupts (AIA) */
> > +#define CSR_MTOPEI           0x35c
> > +#define CSR_MTOPI            0xfb0
> > +
> > +/* Virtual Interrupts for Supervisor Level (AIA) */
> > +#define CSR_MVIEN            0x308
> > +#define CSR_MVIP             0x309
> > +
> > +/* Machine-Level High-Half CSRs (AIA) */
> > +#define CSR_MIDELEGH         0x313
> > +#define CSR_MIEH             0x314
> > +#define CSR_MVIENH           0x318
> > +#define CSR_MVIPH            0x319
> > +#define CSR_MIPH             0x354
> > +
> >  #ifdef CONFIG_RISCV_M_MODE
> >  # define CSR_STATUS  CSR_MSTATUS
> >  # define CSR_IE              CSR_MIE
> > @@ -307,6 +386,13 @@
> >  # define CSR_TVAL    CSR_MTVAL
> >  # define CSR_IP              CSR_MIP
> >
> > +# define CSR_IEH             CSR_MIEH
> > +# define CSR_ISELECT CSR_MISELECT
> > +# define CSR_IREG    CSR_MIREG
> > +# define CSR_IPH             CSR_MIPH
> > +# define CSR_TOPEI   CSR_MTOPEI
> > +# define CSR_TOPI    CSR_MTOPI
> > +
> >  # define SR_IE               SR_MIE
> >  # define SR_PIE              SR_MPIE
> >  # define SR_PP               SR_MPP
> > @@ -324,6 +410,13 @@
> >  # define CSR_TVAL    CSR_STVAL
> >  # define CSR_IP              CSR_SIP
> >
> > +# define CSR_IEH             CSR_SIEH
> > +# define CSR_ISELECT CSR_SISELECT
> > +# define CSR_IREG    CSR_SIREG
> > +# define CSR_IPH             CSR_SIPH
> > +# define CSR_TOPEI   CSR_STOPEI
> > +# define CSR_TOPI    CSR_STOPI
> > +
> >  # define SR_IE               SR_SIE
> >  # define SR_PIE              SR_SPIE
> >  # define SR_PP               SR_SPP
> > --
> > 2.34.1
> >
>
> Besides my preference for GENMASK and BIT, this looks good to me.
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks, I will address all your comments in v2.

Regards,
Anup
