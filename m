Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD08732584
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbjFPDAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbjFPDAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:00:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC57E2953;
        Thu, 15 Jun 2023 20:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 299D56185A;
        Fri, 16 Jun 2023 03:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CFBC433CC;
        Fri, 16 Jun 2023 03:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686884406;
        bh=lfknHlYVl7xYkxb20nhhhSp7zufa8esHt6mjikj4vqA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jAE+1Tp6FNYqMrl7Sxh8YTj9tilMjgVk8MyERRzcj3kzTrleZvA9WqHiNQ//0MFMk
         tS8hZEaMMH5TPzHB4kchfhuDhnqDn0TPYAQce+ik5fB79T3MJIvgR5f3WC8GcSBzhz
         qxfSIlKEVJjp0hiBtZlgPjFcbysOE0QxO3Qrm8SzPVr70H8VZPwKB9ENJp9bMkF131
         D9ISjsQO+hrU9KXk8tlG6QlGRcZEWXp5M9RiXlSUy+DoFN/PuCetbGR2StY9lesoj6
         GPWpRsopvg96bNzeViL+EMMJizczute1OgIHudHHwhbf/zZOwoRE+QhWHBbcGaoLru
         qDR+6ll+mt8XA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5149c76f4dbso268299a12.1;
        Thu, 15 Jun 2023 20:00:06 -0700 (PDT)
X-Gm-Message-State: AC+VfDxq1jlhWhNuyVj1YZJtV2OST3DrdzkT7yVLHTQiQCsHMpZKKqJD
        1rZ6KKXALVMNXRZyEQsqFPfg5nSR3s91r9GfZXs=
X-Google-Smtp-Source: ACHHUZ5YlVtj9U+gMDENeI3z8rcpk0Dp+squ/fpq8PSfXMLm1CWuIGmvmXfhmbRGTdSDlXdjOBxSJUgmbBRxNaOsnOk=
X-Received: by 2002:a17:906:8590:b0:974:1ef1:81fb with SMTP id
 v16-20020a170906859000b009741ef181fbmr514160ejx.22.1686884404345; Thu, 15 Jun
 2023 20:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
 <20230609090832.2131037-30-zhaotianrui@loongson.cn> <CAAhV-H4rzRZQpfxFBANFJyUshsNHYqmZmLnZfHA+McPyQ3m4-w@mail.gmail.com>
 <749abd01-c717-3a4c-238e-cda1bb74f25c@loongson.cn>
In-Reply-To: <749abd01-c717-3a4c-238e-cda1bb74f25c@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 16 Jun 2023 10:59:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6KtyaJ8rCt+ZkvOD0seN-PjULSVw+f+zSBw6=hkvyAGg@mail.gmail.com>
Message-ID: <CAAhV-H6KtyaJ8rCt+ZkvOD0seN-PjULSVw+f+zSBw6=hkvyAGg@mail.gmail.com>
Subject: Re: [PATCH v13 29/30] LoongArch: KVM: Supplement kvm document about
 LoongArch-specific part
To:     zhaotianrui <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 10:39=E2=80=AFAM zhaotianrui <zhaotianrui@loongson.=
cn> wrote:
>
>
> =E5=9C=A8 2023/6/15 =E4=B8=8B=E5=8D=885:42, Huacai Chen =E5=86=99=E9=81=
=93:
> > Hi, Tianrui,
> >
> > On Fri, Jun 9, 2023 at 5:09=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongs=
on.cn> wrote:
> >> Supplement kvm document about LoongArch-specific part, such as add
> >> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
> >> etc.
> >>
> >> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> >> ---
> >>   Documentation/virt/kvm/api.rst | 71 +++++++++++++++++++++++++++++---=
--
> >>   1 file changed, 62 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/a=
pi.rst
> >> index add067793b90..ad8e13eab48d 100644
> >> --- a/Documentation/virt/kvm/api.rst
> >> +++ b/Documentation/virt/kvm/api.rst
> >> @@ -416,6 +416,12 @@ Reads the general purpose registers from the vcpu=
.
> >>          __u64 pc;
> >>     };
> >>
> >> +  /* LoongArch */
> >> +  struct kvm_regs {
> > Add a " /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */" line as others he=
re?
>
> Thanks, I will add this comment here.
>
> Tianrui Zhao
>
> >> +        unsigned long gpr[32];
> >> +        unsigned long pc;
> >> +  };
> >> +
> >>
> >>   4.12 KVM_SET_REGS
> >>   -----------------
> >> @@ -506,7 +512,7 @@ translation mode.
> >>   ------------------
> >>
> >>   :Capability: basic
> >> -:Architectures: x86, ppc, mips, riscv
> >> +:Architectures: x86, ppc, mips, riscv, loongarch
> >>   :Type: vcpu ioctl
> >>   :Parameters: struct kvm_interrupt (in)
> >>   :Returns: 0 on success, negative on failure.
> >> @@ -592,6 +598,14 @@ b) KVM_INTERRUPT_UNSET
> >>
> >>   This is an asynchronous vcpu ioctl and can be invoked from any threa=
d.
> >>
> >> +LOONGARCH:
> >> +^^^^^^^^^^
> >> +
> >> +Queues an external interrupt to be injected into the virtual CPU. A n=
egative
> >> +interrupt number dequeues the interrupt.
> >> +
> >> +This is an asynchronous vcpu ioctl and can be invoked from any thread=
.
> >> +
> >>
> >>   4.17 KVM_DEBUG_GUEST
> >>   --------------------
> >> @@ -737,7 +751,7 @@ signal mask.
> >>   ----------------
> >>
> >>   :Capability: basic
> >> -:Architectures: x86
> >> +:Architectures: x86, loongarch
> >>   :Type: vcpu ioctl
> >>   :Parameters: struct kvm_fpu (out)
> >>   :Returns: 0 on success, -1 on error
> >> @@ -746,7 +760,7 @@ Reads the floating point state from the vcpu.
> >>
> >>   ::
> >>
> >> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> >> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
> >>     struct kvm_fpu {
> >>          __u8  fpr[8][16];
> >>          __u16 fcw;
> >> @@ -761,12 +775,22 @@ Reads the floating point state from the vcpu.
> >>          __u32 pad2;
> >>     };
> >>
> >> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> >> +  struct kvm_fpu {
> >> +        __u32 fcsr;
> >> +        __u32 none;
> > Maybe use pad1 as x86 is better.
> >
> > Huacai
>
> Thanks, this 'none' variable is meaningless, and I will remove it. As
> this have already been removed in the actually kvm_fpu structure.
Why remove? I think it is for alignment, just like pad1 for x86.

Huacai
>
> Tianrui Zhao
>
> >> +        __u64 fcc;
> >> +        struct kvm_fpureg {
> >> +                __u64 val64[4];
> >> +        }fpr[32];
> >> +  };
> >> +
> >>
> >>   4.23 KVM_SET_FPU
> >>   ----------------
> >>
> >>   :Capability: basic
> >> -:Architectures: x86
> >> +:Architectures: x86, loongarch
> >>   :Type: vcpu ioctl
> >>   :Parameters: struct kvm_fpu (in)
> >>   :Returns: 0 on success, -1 on error
> >> @@ -775,7 +799,7 @@ Writes the floating point state to the vcpu.
> >>
> >>   ::
> >>
> >> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> >> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
> >>     struct kvm_fpu {
> >>          __u8  fpr[8][16];
> >>          __u16 fcw;
> >> @@ -790,6 +814,16 @@ Writes the floating point state to the vcpu.
> >>          __u32 pad2;
> >>     };
> >>
> >> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> >> +  struct kvm_fpu {
> >> +        __u32 fcsr;
> >> +        __u32 none;
>
> I will also remove this 'none' variable.
>
> Tianrui Zhao
>
> >> +        __u64 fcc;
> >> +        struct kvm_fpureg {
> >> +                __u64 val64[4];
> >> +        }fpr[32];
> >> +  };
> >> +
> >>
> >>   4.24 KVM_CREATE_IRQCHIP
> >>   -----------------------
> >> @@ -1387,7 +1421,7 @@ documentation when it pops into existence).
> >>   -------------------
> >>
> >>   :Capability: KVM_CAP_ENABLE_CAP
> >> -:Architectures: mips, ppc, s390, x86
> >> +:Architectures: mips, ppc, s390, x86, loongarch
> >>   :Type: vcpu ioctl
> >>   :Parameters: struct kvm_enable_cap (in)
> >>   :Returns: 0 on success; -1 on error
> >> @@ -1442,7 +1476,7 @@ for vm-wide capabilities.
> >>   ---------------------
> >>
> >>   :Capability: KVM_CAP_MP_STATE
> >> -:Architectures: x86, s390, arm64, riscv
> >> +:Architectures: x86, s390, arm64, riscv, loongarch
> >>   :Type: vcpu ioctl
> >>   :Parameters: struct kvm_mp_state (out)
> >>   :Returns: 0 on success; -1 on error
> >> @@ -1460,7 +1494,7 @@ Possible values are:
> >>
> >>      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >>      KVM_MP_STATE_RUNNABLE         the vcpu is currently running
> >> -                                 [x86,arm64,riscv]
> >> +                                 [x86,arm64,riscv,loongarch]
> >>      KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processo=
r (AP)
> >>                                    which has not yet received an INIT =
signal [x86]
> >>      KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signa=
l, and is
> >> @@ -1516,11 +1550,14 @@ For riscv:
> >>   The only states that are valid are KVM_MP_STATE_STOPPED and
> >>   KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> >>
> >> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
> >> +whether the vcpu is runnable.
> >> +
> >>   4.39 KVM_SET_MP_STATE
> >>   ---------------------
> >>
> >>   :Capability: KVM_CAP_MP_STATE
> >> -:Architectures: x86, s390, arm64, riscv
> >> +:Architectures: x86, s390, arm64, riscv, loongarch
> >>   :Type: vcpu ioctl
> >>   :Parameters: struct kvm_mp_state (in)
> >>   :Returns: 0 on success; -1 on error
> >> @@ -1538,6 +1575,9 @@ For arm64/riscv:
> >>   The only states that are valid are KVM_MP_STATE_STOPPED and
> >>   KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or =
not.
> >>
> >> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
> >> +whether the vcpu is runnable.
> >> +
> >>   4.40 KVM_SET_IDENTITY_MAP_ADDR
> >>   ------------------------------
> >>
> >> @@ -2839,6 +2879,19 @@ Following are the RISC-V D-extension registers:
> >>     0x8020 0000 0600 0020 fcsr      Floating point control and status =
register
> >>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >>
> >> +LoongArch registers are mapped using the lower 32 bits. The upper 16 =
bits of
> >> +that is the register group type.
> >> +
> >> +LoongArch csr registers are used to control guest cpu or get status o=
f guest
> >> +cpu, and they have the following id bit patterns::
> >> +
> >> +  0x9030 0000 0001 00 <reg:5> <sel:3>   (64-bit)
> >> +
> >> +LoongArch KVM control registers are used to implement some new define=
d functions
> >> +such as set vcpu counter or reset vcpu, and they have the following i=
d bit patterns::
> >> +
> >> +  0x9030 0000 0002 <reg:16>
> >> +
> >>
> >>   4.69 KVM_GET_ONE_REG
> >>   --------------------
> >> --
> >> 2.39.1
> >>
> >>
>
