Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F5876E75E
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjHCLvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 07:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbjHCLvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 07:51:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F397C273B
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 04:51:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-99357737980so122892466b.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 04:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1691063476; x=1691668276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzPKbAFOISRw/5YbvjKOSvX0ETCU4L0S6O4dsEu3NT4=;
        b=NmceIrgAHf6DAIvboMUEJ7JzGv/tctRVCkJT5rFCwP1gjAqtTTP8QBBHcUFFDfMGBs
         BYoMiwGFBUcc4qkO1aP5M+f3VANXSoUG79+qViju1B4qLjEdKSuii/Ejplx775yyq/KY
         kwPpM3SoyKTKiJrPp30PV+xmIGSRPVg2kTQqiX6zrE6KZqRDssx2DXyfePCNsheKnpps
         y7P9xhkULIkmVQ5263v7d+3SilFSbIJvnWQH+1DJzyzAhpl8c6SbxLArCbvMWuvUAQYW
         7i0oTbFZTMHZaNnBJlX8EVHXYOQcZMJygUJ2RX7N99gREQtmg4jdm/X5OEBAAGcseg+n
         mjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691063476; x=1691668276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzPKbAFOISRw/5YbvjKOSvX0ETCU4L0S6O4dsEu3NT4=;
        b=AN/Vw3+NxaxXRSiLP7ac34vptCG0ZKGDEQYmvfFxx2DqvVUaMwHdEiSxxH4Yk8qYbp
         kGH+YGth/n30oHTS6YwZT+275Ti1O3VGRuz+iPyews9FIchSPi0K/6f6WlbgmWahZ05i
         jVXij4x34YnypbPLHEqxnJ+ToEalFuyvY8Q/M32jshKXGYPMHSWS+tXigtGNIQRtFz0O
         S/c7YD2Fh64nDUiKDylhwVSZm4Ljgf9ACVkYyATfRDS+0FE7KoG+Gcm+gfvESyjUeROl
         vFdRmA625WPWbQtFlKZ7s6LChJHuyA8bzZCtDO1ntIicc/TH59MfpgRpceuLeiKo7Yel
         tgWw==
X-Gm-Message-State: ABy/qLZp4lusc4UzBdIJrac2pxwOhE9rhAlgWTc8cXQrfGh32uUJ+Nw+
        byRSr/I3HIKqWcDhlav+j4Mu7LPTKSi6IZSoAhBNhw==
X-Google-Smtp-Source: APBJJlHaBGbLysLT4OovkxC+A8IVLYfeu33xeC0pulr4EZBtAA8oMQYOh/PvStYR1i80XF9LdMskfV0M9j4jh4uFMsg=
X-Received: by 2002:a17:906:5352:b0:99b:f676:52da with SMTP id
 j18-20020a170906535200b0099bf67652damr7364642ejo.65.1691063476270; Thu, 03
 Aug 2023 04:51:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230728210122.175229-1-dbarboza@ventanamicro.com> <20230728210122.175229-2-dbarboza@ventanamicro.com>
In-Reply-To: <20230728210122.175229-2-dbarboza@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 3 Aug 2023 17:21:04 +0530
Message-ID: <CAAhSdy28VzHT5NMcPokEm0i3Jdzg=+YQRhLR++YrUt1BykBsFA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] RISC-V: KVM: provide UAPI for host SATP mode
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, atishp@atishpatra.org, ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 29, 2023 at 2:31=E2=80=AFAM Daniel Henrique Barboza
<dbarboza@ventanamicro.com> wrote:
>
> KVM userspaces need to be aware of the host SATP to allow them to
> advertise it back to the guest OS.
>
> Since this information is used to build the guest FDT we can't wait for
> the SATP reg to be readable. We just need to read the SATP mode, thus
> we can use the existing 'satp_mode' global that represents the SATP reg
> with MODE set and both ASID and PPN cleared. E.g. for a 32 bit host
> running with sv32 satp_mode is 0x80000000, for a 64 bit host running
> sv57 satp_mode is 0xa000000000000000, and so on.
>
> Add a new userspace virtual config register 'satp_mode' to allow
> userspace to read the current SATP mode the host is using with
> GET_ONE_REG API before spinning the vcpu.
>
> 'satp_mode' can't be changed via KVM, so SET_ONE_REG is allowed as long
> as userspace writes the existing 'satp_mode'.
>
> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Queued this patch for Linux-6.6

Thanks,
Anup

> ---
>  arch/riscv/include/asm/csr.h      | 2 ++
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 7 +++++++
>  3 files changed, 10 insertions(+)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 7bac43a3176e..777cb8299551 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -54,6 +54,7 @@
>  #ifndef CONFIG_64BIT
>  #define SATP_PPN       _AC(0x003FFFFF, UL)
>  #define SATP_MODE_32   _AC(0x80000000, UL)
> +#define SATP_MODE_SHIFT        31
>  #define SATP_ASID_BITS 9
>  #define SATP_ASID_SHIFT        22
>  #define SATP_ASID_MASK _AC(0x1FF, UL)
> @@ -62,6 +63,7 @@
>  #define SATP_MODE_39   _AC(0x8000000000000000, UL)
>  #define SATP_MODE_48   _AC(0x9000000000000000, UL)
>  #define SATP_MODE_57   _AC(0xa000000000000000, UL)
> +#define SATP_MODE_SHIFT        60
>  #define SATP_ASID_BITS 16
>  #define SATP_ASID_SHIFT        44
>  #define SATP_ASID_MASK _AC(0xFFFF, UL)
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 9c35e1427f73..992c5e407104 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -55,6 +55,7 @@ struct kvm_riscv_config {
>         unsigned long marchid;
>         unsigned long mimpid;
>         unsigned long zicboz_block_size;
> +       unsigned long satp_mode;
>  };
>
>  /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 0dc2c2cecb45..85773e858120 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -152,6 +152,9 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_v=
cpu *vcpu,
>         case KVM_REG_RISCV_CONFIG_REG(mimpid):
>                 reg_val =3D vcpu->arch.mimpid;
>                 break;
> +       case KVM_REG_RISCV_CONFIG_REG(satp_mode):
> +               reg_val =3D satp_mode >> SATP_MODE_SHIFT;
> +               break;
>         default:
>                 return -EINVAL;
>         }
> @@ -234,6 +237,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_=
vcpu *vcpu,
>                 else
>                         return -EBUSY;
>                 break;
> +       case KVM_REG_RISCV_CONFIG_REG(satp_mode):
> +               if (reg_val !=3D (satp_mode >> SATP_MODE_SHIFT))
> +                       return -EINVAL;
> +               break;
>         default:
>                 return -EINVAL;
>         }
> --
> 2.41.0
>
