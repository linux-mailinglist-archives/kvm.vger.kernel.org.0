Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EE26DAC5F
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 13:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjDGLxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 07:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjDGLw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 07:52:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB847ED8
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 04:52:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-4fa3ca41384so1708157a12.2
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 04:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680868373; x=1683460373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdsSI2dugb8QtnqVf27M40SpFkEimDgZgBLKngWDXtA=;
        b=eHsgTAiypcrDoToWF8gXeNKhzM4YibV2hdoLrWbc40xstbkqSMD2hqNE1gsmMjN3p4
         //6oW8ONGMISP8svpNGmoZx5P1ZtcrmQ3hG8y10TMyWYm8MlUNN2KXBNnRzDADBFNO7W
         a2GXJ8oaGTYSVlkRyi0UjC1Qg8gOn+ckfYsilet/eHZSkS7NKeeIt+2Xvgmw0N5xDedB
         Gr2y4Mqzsuc4KnvTWuo00UUGSxbzLNqsqVf2jmQhfsajOKYQqAEoOZ3OZmAat1kYXlBP
         bl7DwQ+RcnkCoO4WXQmtqho/DofhzTjuFQ3Mj9ggvkXsKoBJyNkhk9I0iXEi/RyiS9Cs
         MiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680868373; x=1683460373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdsSI2dugb8QtnqVf27M40SpFkEimDgZgBLKngWDXtA=;
        b=ywWW9Dv4fNqrmSEuKFGKlE0SgJCw9bbHZNCBOhqjt4787S9/RgHZeH+cZuPLvyGCUR
         7t/9eiLdV1nR336YCthGRCe8LxKbV9flTFgPurqy5ceZnUXtv/uZ1Zufa1wJiLUmYWkQ
         kjCKHFEQI3daTtD0NNZddfTNFRAlSwBYvWE4eyUdWSDaJHi2XqhA4whmoidjriu2pcRp
         inquT5tPKpV+oFI2pj7dRZgWt9udjFM1uxaVxXnSLDNAqCm09rrw56LaBA/+M3BiknI2
         VNLe9zZ3AJQpt2NCTQ/I+ZazCCEwRBAKXP/W61bCfPlMs0KVm19cMzXhKXDuBwqBnFHa
         yVrA==
X-Gm-Message-State: AAQBX9feQWFt/sTHO2EO8KxbJIjcYNl/7jXi9mFQW3mgldcGGoKWBtBi
        6adr2ZoO77hXCE2n2/92MDLCJN42+nLt/PgDrUEIi0uJiVFOKlRbG9Dp3A==
X-Google-Smtp-Source: AKy350bQHM5pLOO7YoLDGP8RS5GEUwvXo1V1aEdjTyr1nsOixOPcDpdxiLE0Wsb/9xEUqMtWYrfxFCjyAdAWx5Xhz8A=
X-Received: by 2002:a50:9f43:0:b0:4c0:71e6:9dc5 with SMTP id
 b61-20020a509f43000000b004c071e69dc5mr766168edf.1.1680868373537; Fri, 07 Apr
 2023 04:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230401112730.2105240-1-apatel@ventanamicro.com>
In-Reply-To: <20230401112730.2105240-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 7 Apr 2023 17:22:42 +0530
Message-ID: <CAAhSdy1rFdCDOajCo+_07=S1n1LC-4ZdK1u1Bz4Zi5KxrcuHeQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Allow Zbb extension for Guest/VM
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 1, 2023 at 4:57=E2=80=AFPM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zbb extension for Guest/VM.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Queued this patch for Linux-6.4

Thanks,
Anup

> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index d8ead5952ed9..47a7c3958229 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -106,6 +106,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_SVINVAL,
>         KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>         KVM_RISCV_ISA_EXT_ZICBOM,
> +       KVM_RISCV_ISA_EXT_ZBB,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3112697cb12d..02b49cb94561 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -61,6 +61,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVPBMT),
> +       KVM_ISA_EXT_ARR(ZBB),
>         KVM_ISA_EXT_ARR(ZIHINTPAUSE),
>         KVM_ISA_EXT_ARR(ZICBOM),
>  };
> @@ -99,6 +100,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigne=
d long ext)
>         case KVM_RISCV_ISA_EXT_SSTC:
>         case KVM_RISCV_ISA_EXT_SVINVAL:
>         case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
> +       case KVM_RISCV_ISA_EXT_ZBB:
>                 return false;
>         default:
>                 break;
> --
> 2.34.1
>
