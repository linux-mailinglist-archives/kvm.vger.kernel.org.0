Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16424A3CE0
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 05:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357573AbiAaERW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jan 2022 23:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiAaERV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jan 2022 23:17:21 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E6AC06173B
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 20:17:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso5410096wms.2
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 20:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8HnH9Zt6R9fMT+vzNU6lZCDo2VCXBihuUUKx7xESYC4=;
        b=0eomZB6oDi+B2PWHxL749knbLFreIeZoy97lij1LRfXB9GM1IDHoeX87wMHRFVMpRW
         mZQKccb+LLGrXoFeBn8JeYS4oL+nEovgL98ccI4ifqSpbQtieKS5bOYSbvhXqMvrObwm
         qXLU185eoDiLIw9+hfivqFudXrjxwwj4P3xcRWnQu53fgYhtG2uoZh8+QwmviA907yI6
         4F0qU/H/gzY7geH/J6lYqcrywqPwZqkqhRHk+8N5uAndk317jHDHWCYS3I7q19PjlwzK
         6ogFaV6lAC+znFXrPWYBe14i2LSYVkkODrvLmmRIfN9YU7xR6iGeskBiJSZFYnpWRn74
         Ds7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8HnH9Zt6R9fMT+vzNU6lZCDo2VCXBihuUUKx7xESYC4=;
        b=BT7qluo62OCUVQ4wmGeW4XpyOPPILOIHCxlzcp54QJVX32VFunwuczhs1MFc6FWIXq
         O8ypZh4TxO36No2xHF3qviT846iHGY0njHtZeRTWzq4QnfWVAXEQBienCCdR149n6763
         LfOpn5l7wrBA5z2jV82gLJc4V8lzTF9QHLzNxWLYpOTSKaHis2X6Q73HJaXpaBFQhq7e
         ZHCDl7QjmjzW8xtafgV+6uZnvul19ESy/OS3BSmMnA2iafwCWRZlKcYJn2v0gR9yCC/r
         azh4LAVYgj6EmcJIZn/so9NX7Kfe4p4F4ErFf2RXWyMuclVL8wJIfjd4eOh8rPeoNvwZ
         hYbw==
X-Gm-Message-State: AOAM530VKpCC7v9xMlWyDmKzjrVmGblpZm3yqdpdQXDACvQOnBhuuM+m
        NpYaxUWYEJNO+mweNvzA0H0HceQnmx2SOue4zM+Y4w==
X-Google-Smtp-Source: ABdhPJzVMzJp/elZCaxwqku1hZwYdiGLhgfcNoVLwLf27ozYDMCaPEGd8/rdnwQeKt1LHLsO+LAlMfv7evAMDGmJ/F0=
X-Received: by 2002:a1c:750f:: with SMTP id o15mr16545257wmc.137.1643602639403;
 Sun, 30 Jan 2022 20:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20220111010454.126241-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220111010454.126241-1-yang.lee@linux.alibaba.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 31 Jan 2022 09:47:05 +0530
Message-ID: <CAAhSdy1xnb=D70rHkewRka6_-bT0+7JAMTYc3fM1MRjs+s1uRQ@mail.gmail.com>
Subject: Re: [PATCH -next] RISC-V: KVM: remove unneeded semicolon
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 6:35 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Eliminate the following coccicheck warning:
> ./arch/riscv/kvm/vcpu_sbi_v01.c:117:2-3: Unneeded semicolon
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Thanks, I have queued this patch for 5.18

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_v01.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 4c7e13ec9ccc..9acc8fa21d1f 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -114,7 +114,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         default:
>                 ret = -EINVAL;
>                 break;
> -       };
> +       }
>
>         return ret;
>  }
> --
> 2.20.1.7.g153144c
>
