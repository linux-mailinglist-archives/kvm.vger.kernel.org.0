Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F33731442
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 11:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243792AbjFOJmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 05:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241720AbjFOJmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 05:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5381D1A3;
        Thu, 15 Jun 2023 02:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C874D62A6B;
        Thu, 15 Jun 2023 09:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE72C433D9;
        Thu, 15 Jun 2023 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686822140;
        bh=XQuGQJ3NoUrSQwNFP59JJLdxojYQ1TBivS0WT8/w20M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u8g8Ozh3mE2Snbs1cwUSb+RzROAQ6VDZetn74FhW+Lvt6kK7tuQnxhXI1q57lMD2r
         HjDbmJrSNVgR8BdXSaF25zqfgUXCj89a1Dw1oMD26FGuC1CAPYf2MCY0KD2ODAghM5
         Qc9++SJw+7dFtVAIW+Fhcya1X9t6JJsz0wPmfcmakfCryJs/u/0XMZKwmJj87l23o8
         rn4/Hj+TiJimGzHM+tbpdxFNWfYKlPcQmGEGhxzEQI1NbsYeeZCL8VF+0sWbQGiUwg
         DWy7oRzztq2Gy8xA2U9iTihhUfAniq596JyRQB19gnnlL/PJsKq0q0+H+R2oW8gHtu
         65gdoJ4b7D0bw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5151934a4e3so11278570a12.1;
        Thu, 15 Jun 2023 02:42:20 -0700 (PDT)
X-Gm-Message-State: AC+VfDzn2iSVkbtmzimQzbF7RTxc3UxPzbWTg0CCh98bdaGCP2WanLCu
        4ECP/v4WA5tBN27uzNy+iQzZv6ddbtPdKuZSInY=
X-Google-Smtp-Source: ACHHUZ5EqaWjq5vvJT3H+n50g/V85lvdiQoY7gum7sTvRKfWvo/vJxKBj7qau0xrHobkq3qsSyH3sg7fVkQhR5EYTmQ=
X-Received: by 2002:aa7:d358:0:b0:514:9423:65a5 with SMTP id
 m24-20020aa7d358000000b00514942365a5mr12355526edr.19.1686822138291; Thu, 15
 Jun 2023 02:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn> <20230609090832.2131037-30-zhaotianrui@loongson.cn>
In-Reply-To: <20230609090832.2131037-30-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 15 Jun 2023 17:42:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4rzRZQpfxFBANFJyUshsNHYqmZmLnZfHA+McPyQ3m4-w@mail.gmail.com>
Message-ID: <CAAhV-H4rzRZQpfxFBANFJyUshsNHYqmZmLnZfHA+McPyQ3m4-w@mail.gmail.com>
Subject: Re: [PATCH v13 29/30] LoongArch: KVM: Supplement kvm document about
 LoongArch-specific part
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Fri, Jun 9, 2023 at 5:09=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.c=
n> wrote:
>
> Supplement kvm document about LoongArch-specific part, such as add
> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
> etc.
>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  Documentation/virt/kvm/api.rst | 71 +++++++++++++++++++++++++++++-----
>  1 file changed, 62 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index add067793b90..ad8e13eab48d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -416,6 +416,12 @@ Reads the general purpose registers from the vcpu.
>         __u64 pc;
>    };
>
> +  /* LoongArch */
> +  struct kvm_regs {
Add a " /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */" line as others here?

> +        unsigned long gpr[32];
> +        unsigned long pc;
> +  };
> +
>
>  4.12 KVM_SET_REGS
>  -----------------
> @@ -506,7 +512,7 @@ translation mode.
>  ------------------
>
>  :Capability: basic
> -:Architectures: x86, ppc, mips, riscv
> +:Architectures: x86, ppc, mips, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_interrupt (in)
>  :Returns: 0 on success, negative on failure.
> @@ -592,6 +598,14 @@ b) KVM_INTERRUPT_UNSET
>
>  This is an asynchronous vcpu ioctl and can be invoked from any thread.
>
> +LOONGARCH:
> +^^^^^^^^^^
> +
> +Queues an external interrupt to be injected into the virtual CPU. A nega=
tive
> +interrupt number dequeues the interrupt.
> +
> +This is an asynchronous vcpu ioctl and can be invoked from any thread.
> +
>
>  4.17 KVM_DEBUG_GUEST
>  --------------------
> @@ -737,7 +751,7 @@ signal mask.
>  ----------------
>
>  :Capability: basic
> -:Architectures: x86
> +:Architectures: x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_fpu (out)
>  :Returns: 0 on success, -1 on error
> @@ -746,7 +760,7 @@ Reads the floating point state from the vcpu.
>
>  ::
>
> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>    struct kvm_fpu {
>         __u8  fpr[8][16];
>         __u16 fcw;
> @@ -761,12 +775,22 @@ Reads the floating point state from the vcpu.
>         __u32 pad2;
>    };
>
> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> +  struct kvm_fpu {
> +        __u32 fcsr;
> +        __u32 none;
Maybe use pad1 as x86 is better.

Huacai
> +        __u64 fcc;
> +        struct kvm_fpureg {
> +                __u64 val64[4];
> +        }fpr[32];
> +  };
> +
>
>  4.23 KVM_SET_FPU
>  ----------------
>
>  :Capability: basic
> -:Architectures: x86
> +:Architectures: x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_fpu (in)
>  :Returns: 0 on success, -1 on error
> @@ -775,7 +799,7 @@ Writes the floating point state to the vcpu.
>
>  ::
>
> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>    struct kvm_fpu {
>         __u8  fpr[8][16];
>         __u16 fcw;
> @@ -790,6 +814,16 @@ Writes the floating point state to the vcpu.
>         __u32 pad2;
>    };
>
> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> +  struct kvm_fpu {
> +        __u32 fcsr;
> +        __u32 none;
> +        __u64 fcc;
> +        struct kvm_fpureg {
> +                __u64 val64[4];
> +        }fpr[32];
> +  };
> +
>
>  4.24 KVM_CREATE_IRQCHIP
>  -----------------------
> @@ -1387,7 +1421,7 @@ documentation when it pops into existence).
>  -------------------
>
>  :Capability: KVM_CAP_ENABLE_CAP
> -:Architectures: mips, ppc, s390, x86
> +:Architectures: mips, ppc, s390, x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_enable_cap (in)
>  :Returns: 0 on success; -1 on error
> @@ -1442,7 +1476,7 @@ for vm-wide capabilities.
>  ---------------------
>
>  :Capability: KVM_CAP_MP_STATE
> -:Architectures: x86, s390, arm64, riscv
> +:Architectures: x86, s390, arm64, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_mp_state (out)
>  :Returns: 0 on success; -1 on error
> @@ -1460,7 +1494,7 @@ Possible values are:
>
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>     KVM_MP_STATE_RUNNABLE         the vcpu is currently running
> -                                 [x86,arm64,riscv]
> +                                 [x86,arm64,riscv,loongarch]
>     KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (A=
P)
>                                   which has not yet received an INIT sign=
al [x86]
>     KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, a=
nd is
> @@ -1516,11 +1550,14 @@ For riscv:
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
>
> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
> +whether the vcpu is runnable.
> +
>  4.39 KVM_SET_MP_STATE
>  ---------------------
>
>  :Capability: KVM_CAP_MP_STATE
> -:Architectures: x86, s390, arm64, riscv
> +:Architectures: x86, s390, arm64, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_mp_state (in)
>  :Returns: 0 on success; -1 on error
> @@ -1538,6 +1575,9 @@ For arm64/riscv:
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
>
> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
> +whether the vcpu is runnable.
> +
>  4.40 KVM_SET_IDENTITY_MAP_ADDR
>  ------------------------------
>
> @@ -2839,6 +2879,19 @@ Following are the RISC-V D-extension registers:
>    0x8020 0000 0600 0020 fcsr      Floating point control and status regi=
ster
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
> +LoongArch registers are mapped using the lower 32 bits. The upper 16 bit=
s of
> +that is the register group type.
> +
> +LoongArch csr registers are used to control guest cpu or get status of g=
uest
> +cpu, and they have the following id bit patterns::
> +
> +  0x9030 0000 0001 00 <reg:5> <sel:3>   (64-bit)
> +
> +LoongArch KVM control registers are used to implement some new defined f=
unctions
> +such as set vcpu counter or reset vcpu, and they have the following id b=
it patterns::
> +
> +  0x9030 0000 0002 <reg:16>
> +
>
>  4.69 KVM_GET_ONE_REG
>  --------------------
> --
> 2.39.1
>
>
