Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38A443AD1B
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 09:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhJZHXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 03:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbhJZHXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 03:23:16 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CEBC061767
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 00:20:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j205so12410487wmj.3
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 00:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uK4FEnHzYo2iEEhaGJnf6I9ZRkM8/MsJyen6l90ZGKI=;
        b=L40b46cvNdnoFhEJgc4ozV6AU+8HP3JD9axeHoM1+le7lYvCvQzY34TfMZqx/L2q/0
         ug63G0r7I68BS/CtcWqpLnCMbmJlNSbkxElIbYZioptOg0yw/s7ST4dpS/4FZzX5UwvD
         WGhWgKCcYfbjp9NgyazdiWncis/Brnk5cRx+PCDZD9oD0dsh5vwG7KEcNgkjg4LmuQik
         oEhOQS1B6biVGXQ32ihYHZDvnABGdCt0kIFIRZsrkFR72BUCbu6vU4nFu5p8/TIxsHtl
         NKbMydmy1tBt8K6jZQ/zBUrGyDVx2hdxcc+nb97ZKG+6QhNZ4pmUhurmX7kRgjjUO+0o
         WFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uK4FEnHzYo2iEEhaGJnf6I9ZRkM8/MsJyen6l90ZGKI=;
        b=JQS7GUFsHsfIVi6xoK1bbuprXRP7xne6dW9gGGYvehuJu/0FWPkbh2ItudRdU1rIfw
         NfQOjAhfxWn/5+YCwgDVZhSoghoP92JAFm1HFLBXm90ymn0wreJnaIe3iokZiFIoaGuJ
         vMvnD7b5lu7+o6373k7loBogWnebr+fl4SHkK2+0IfoP6VpjOuHgDc2TaEylkk61EuMC
         po2x2tqtyVRrMpbZcbsECeBIdMZk6T5OVegFcMk8b+tUnqRvMqQS/ftgSAt4QdMjf99o
         /ELKRG5GEMLZrMHDOQ25mUxevj6eW+G2FRqxlK7UVKFNc+jcIPfy3Jm4cm8zrqUVioj6
         FIcw==
X-Gm-Message-State: AOAM530vwX/uYI1hB9g4an904eOcOqJL9Q58Xlb6OfBnbcebT6V7CDoc
        mUKspJsVb1E+bosiRIb1ZeK29tgcA58trJeImeiwTA==
X-Google-Smtp-Source: ABdhPJxaZPO1AnPCFdVJO9RU5s/rQ6FpcabewmEN+KQwwXwpufrKWHvczAximO9dbWgB2kgUPqL0aH5nekYca6HIiQg=
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr26131590wmq.59.1635232851263;
 Tue, 26 Oct 2021 00:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy3DWOux6HiDU6fPazZUq=FOor8_ZEoqh6FBZru07NyxLQ@mail.gmail.com>
 <20211021115706.1060778-1-ran.jianping@zte.com.cn>
In-Reply-To: <20211021115706.1060778-1-ran.jianping@zte.com.cn>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 26 Oct 2021 12:50:40 +0530
Message-ID: <CAAhSdy3mu-eKUYjEQmQoDODeKnzXEErkmLrgtztsFN7-+o3rHg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V:KVM: remove unneeded semicolon
To:     cgel.zte@gmail.com
Cc:     Anup Patel <anup.patel@wdc.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atish.patra@wdc.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 5:27 PM <cgel.zte@gmail.com> wrote:
>
> From: ran jianping <ran.jianping@zte.com.cn>
>
>  Elimate the following coccinelle check warning:
>  ./arch/riscv/kvm/vcpu_sbi.c:169:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu_exit.c:397:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu_exit.c:687:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu_exit.c:645:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu.c:247:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu.c:284:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu_timer.c:123:2-3: Unneeded semicolon
>  ./arch/riscv/kvm/vcpu_timer.c:170:2-3: Unneeded semicolon
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ran jianping <ran.jianping@zte.com.cn>

Applied to riscv_kvm_next, Thanks!

Regards,
Anup

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
