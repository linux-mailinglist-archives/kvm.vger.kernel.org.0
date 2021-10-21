Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D599C436026
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhJUL1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhJUL07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 07:26:59 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F3DC06161C
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 04:24:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v17so490635wrv.9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 04:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=823GhYmXbttbJwIVURhuPlV/kHfvN4T6Ehf+eMAd4qg=;
        b=nfEfrSbCk1e42MxpttkQclQWIW+uGKdG0+QuvEJZcTOkz8qazuzf5znHkZAPhC2hU8
         fsZmSzj21VYm0rLGPCAQsri62ycKeT1JWBOvqxD0LDbgmXKOJr9z3EdntJiRNDUdYrqH
         4NFYkpq6ejFL8fDyiwRe932cdHINEFAe4B2BpWxcEFPZIb1T+VmZFn+vtnX1+h1PfFtC
         Wt7h/3irpBfE4hMC6yezfWvv6EHZms1tONuiAwHoC7vpOXD4zyJ1ht7+5GXJ+Hcgco9S
         cSOMGqXn6Sfr0iCGs+0KqHThxqQAjfZoix70tBXFaULNLMNWlETPB+BY7s6BBmDMFCjP
         F8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=823GhYmXbttbJwIVURhuPlV/kHfvN4T6Ehf+eMAd4qg=;
        b=IT9kWju8VdCEseYxEw5Er1Aup9RJjYNkpuhGKvzeAeTo5v9UXR3AEFd9PXdm15NzIG
         4YbH+QalmrPszQ5nNg2rCXUtoIPgQtxW94zJMI142ZCgT9ygwtptfdfJ4s0kIKQi4Zid
         4uQSxT4Yj9WwSKuNguEKxOmiB2qRJA14+Hm+tPB6D6BEzwFfQVtSHDyfDSzjk4+igw3T
         a0zrN3HQZGQBPmbihl7u4wow6YEGZciqfYilqzWJ5Cg31awlluTVyF2cpNrKjgY3tNve
         zTa3+PL92SjBKT5q/OTCXhLC3JfpklVxZUWixj7nAH5C51/E2HQaKMSSDNM5MNXZsqv1
         NHdQ==
X-Gm-Message-State: AOAM533MkvesZdaSr/CH2qq8SHurij92EuvOsWG6i4B6QR7oDMv8uRKg
        PuzlbQqLkKHwYlaikZpx42uXAVpVYBPvxm7I/AjHaQ==
X-Google-Smtp-Source: ABdhPJw4/zb4/niggRe0zyZ/ENXV882FAHY78FWAaLNgfY/JPNI0A5fpTNtqBvIEMMQ4TnCeIIlENOKE9MKEK0amVZ4=
X-Received: by 2002:adf:e60a:: with SMTP id p10mr6498325wrm.306.1634815482401;
 Thu, 21 Oct 2021 04:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211021104536.1060107-1-ran.jianping@zte.com.cn>
In-Reply-To: <20211021104536.1060107-1-ran.jianping@zte.com.cn>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 21 Oct 2021 16:54:29 +0530
Message-ID: <CAAhSdy3DWOux6HiDU6fPazZUq=FOor8_ZEoqh6FBZru07NyxLQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V:KVM: remove unneeded semicolon Elimate the
 following coccinelle check warning: ./arch/riscv/kvm/vcpu_sbi.c:169:2-3:
 Unneeded semicolon ./arch/riscv/kvm/vcpu_exit.c:397:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu_exit.c:687:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_exit.c:645:2-3:
 Unneeded semicolon ./arch/riscv/kvm/vcpu.c:247:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu.c:284:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_timer.c:123:2-3:
 Unneeded semicolon ./arch/riscv/kvm/vcpu_timer.c:170:2-3: Unneeded semicolon
To:     cgel.zte@gmail.com
Cc:     Anup Patel <anup.patel@wdc.com>, Atish Patra <atish.patra@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 4:15 PM <cgel.zte@gmail.com> wrote:
>
> From: ran jianping <ran.jianping@zte.com.cn>

Reduce the length of patch subject (preferable around 70 characters)
and move the rest of patch subject as patch description.

Regards,
Anup

>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
> ---
>  arch/riscv/kvm/vcpu.c       | 4 ++--
>  arch/riscv/kvm/vcpu_exit.c  | 6 +++---
>  arch/riscv/kvm/vcpu_sbi.c   | 2 +-
>  arch/riscv/kvm/vcpu_timer.c | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index c44cabce7dd8..912928586df9 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -244,7 +244,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>                 break;
>         default:
>                 return -EINVAL;
> -       };
> +       }
>
>         if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
> @@ -281,7 +281,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>                 break;
>         default:
>                 return -EINVAL;
> -       };
> +       }
>
>         return 0;
>  }
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 13bbc3f73713..7f2d742ae4c6 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -394,7 +394,7 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 break;
>         default:
>                 return -EOPNOTSUPP;
> -       };
> +       }
>
>         /* Update MMIO details in kvm_run struct */
>         run->mmio.is_write = true;
> @@ -642,7 +642,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                 break;
>         default:
>                 return -EOPNOTSUPP;
> -       };
> +       }
>
>  done:
>         /* Move to next instruction */
> @@ -684,7 +684,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 break;
>         default:
>                 break;
> -       };
> +       }
>
>         /* Print details in-case of error */
>         if (ret < 0) {
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index ebdcdbade9c6..eb3c045edf11 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -166,7 +166,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                 /* Return error for unsupported SBI calls */
>                 cp->a0 = SBI_ERR_NOT_SUPPORTED;
>                 break;
> -       };
> +       }
>
>         if (next_sepc)
>                 cp->sepc += 4;
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ddd0ce727b83..5c4c37ff2d48 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -120,7 +120,7 @@ int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
>                 break;
>         default:
>                 return -EINVAL;
> -       };
> +       }
>
>         if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
> @@ -167,7 +167,7 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
>         default:
>                 ret = -EINVAL;
>                 break;
> -       };
> +       }
>
>         return ret;
>  }
> --
> 2.25.1
>
