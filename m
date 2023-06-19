Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7D7351FA
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 12:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjFSK0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 06:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjFSK03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 06:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FD013D;
        Mon, 19 Jun 2023 03:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEC4C60B3E;
        Mon, 19 Jun 2023 10:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D02FC43391;
        Mon, 19 Jun 2023 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687170387;
        bh=YzS+7JT5JGD5OnwOktHBbPjec4tNOdx49qt9Nw4Nckk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=M7TO71ssQ+Oh0HjrZKHBlEeR+7P40JKK7smU2a4nEr+pKfBh3TyjpnBV8/Vpkm40z
         rokfithS+EAPdyBUrXBlZYpIj9yLpRfJPR/bE87xF+JTS6MSttJlJulKqYRBVO0XKW
         JsZgqU31LXJiQRb1nW0ZzyE9Af6Zy5K4+5uRZdObebkHAqN6a0lRQv2jemgSKCeXA2
         cgSsGbxK1vqZYJgWG0sr5pG9Hj/VG83ZqcLKLmJfxvdt8XP2z1kw2KS3dfyE0ibqyn
         L9exxlfM1Vx/jUF+feGrAGqDkIujNSdpQIF2YGGgyqlA+5qGas3E9ioYOvgfsrMxKi
         5Goj7/UhMyNpA==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-51a2fa4a45eso4237944a12.0;
        Mon, 19 Jun 2023 03:26:27 -0700 (PDT)
X-Gm-Message-State: AC+VfDxzVLqEiMTCMvOWULP7K+OegssXs2M3XBEdw7bLBeFXb/BIl1Os
        XpChg1ht41D9S9VSQWk2hK7OBVFt8m5KA0CWfIE=
X-Google-Smtp-Source: ACHHUZ5grqV8r2pbRciZ5jWXt3a05iFks8zLv5+jKLp+GEwhQibeFmPq7T5qiXRxJBTtIrZCl4AklZAigNUL7JqLLyc=
X-Received: by 2002:aa7:cf19:0:b0:518:922a:bc38 with SMTP id
 a25-20020aa7cf19000000b00518922abc38mr6816336edy.2.1687170385462; Mon, 19 Jun
 2023 03:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230619083255.3841777-1-zhaotianrui@loongson.cn> <20230619083255.3841777-30-zhaotianrui@loongson.cn>
In-Reply-To: <20230619083255.3841777-30-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 19 Jun 2023 18:26:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4nSAW3So6=PTetRiMSgDXtekR9j6RDu7CFbx_d6ekjXQ@mail.gmail.com>
Message-ID: <CAAhV-H4nSAW3So6=PTetRiMSgDXtekR9j6RDu7CFbx_d6ekjXQ@mail.gmail.com>
Subject: Re: [PATCH v14 29/30] LoongArch: KVM: Supplement kvm document about
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

Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>

On Mon, Jun 19, 2023 at 4:34=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Supplement kvm document about LoongArch-specific part, such as add
> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
> etc.
>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  Documentation/virt/kvm/api.rst | 70 +++++++++++++++++++++++++++++-----
>  1 file changed, 61 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index add067793b90..0bae97c63156 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -416,6 +416,13 @@ Reads the general purpose registers from the vcpu.
>         __u64 pc;
>    };
>
> +  /* LoongArch */
> +  struct kvm_regs {
> +       /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
> +        unsigned long gpr[32];
> +        unsigned long pc;
> +  };
> +
>
>  4.12 KVM_SET_REGS
>  -----------------
> @@ -506,7 +513,7 @@ translation mode.
>  ------------------
>
>  :Capability: basic
> -:Architectures: x86, ppc, mips, riscv
> +:Architectures: x86, ppc, mips, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_interrupt (in)
>  :Returns: 0 on success, negative on failure.
> @@ -592,6 +599,14 @@ b) KVM_INTERRUPT_UNSET
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
> @@ -737,7 +752,7 @@ signal mask.
>  ----------------
>
>  :Capability: basic
> -:Architectures: x86
> +:Architectures: x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_fpu (out)
>  :Returns: 0 on success, -1 on error
> @@ -746,7 +761,7 @@ Reads the floating point state from the vcpu.
>
>  ::
>
> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>    struct kvm_fpu {
>         __u8  fpr[8][16];
>         __u16 fcw;
> @@ -761,12 +776,21 @@ Reads the floating point state from the vcpu.
>         __u32 pad2;
>    };
>
> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> +  struct kvm_fpu {
> +        __u32 fcsr;
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
> @@ -790,6 +814,15 @@ Writes the floating point state to the vcpu.
>         __u32 pad2;
>    };
>
> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> +  struct kvm_fpu {
> +        __u32 fcsr;
> +        __u64 fcc;
> +        struct kvm_fpureg {
> +                __u64 val64[4];
> +        }fpr[32];
> +  };
> +
>
>  4.24 KVM_CREATE_IRQCHIP
>  -----------------------
> @@ -1387,7 +1420,7 @@ documentation when it pops into existence).
>  -------------------
>
>  :Capability: KVM_CAP_ENABLE_CAP
> -:Architectures: mips, ppc, s390, x86
> +:Architectures: mips, ppc, s390, x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_enable_cap (in)
>  :Returns: 0 on success; -1 on error
> @@ -1442,7 +1475,7 @@ for vm-wide capabilities.
>  ---------------------
>
>  :Capability: KVM_CAP_MP_STATE
> -:Architectures: x86, s390, arm64, riscv
> +:Architectures: x86, s390, arm64, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_mp_state (out)
>  :Returns: 0 on success; -1 on error
> @@ -1460,7 +1493,7 @@ Possible values are:
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
> @@ -1516,11 +1549,14 @@ For riscv:
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
> @@ -1538,6 +1574,9 @@ For arm64/riscv:
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
>
> +On LoongArch, only the KVM_MP_STATE_RUNNABLE state is used to reflect
> +whether the vcpu is runnable.
> +
>  4.40 KVM_SET_IDENTITY_MAP_ADDR
>  ------------------------------
>
> @@ -2839,6 +2878,19 @@ Following are the RISC-V D-extension registers:
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
