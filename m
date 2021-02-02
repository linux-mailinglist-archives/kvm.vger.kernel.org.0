Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1F530B69E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 05:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhBBEld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 23:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhBBElb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 23:41:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6350F64EE1;
        Tue,  2 Feb 2021 04:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612240851;
        bh=Er+OHXyqWsWOV/4nsHP37J6xG+BftyW06TiJ8gisbV4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Il1RtFY1luYk2YDZSELCpxIvqu1sF9LKrwHYGlBcspk3ZpUh3L4OXJWt2mWt3OPIf
         nwSYJln4iMnr2M1KF/j9D8atuGFcHj6HD6/xxG52jC+vG76AYDPPnNVbIyJ693nhEv
         1n5rBPuTTZbkG6AxQ4dUKq7i9QXhOlePx+K6Qy/a1ygujpnIskwX5as7kX4/Zcoxsz
         Mn7m/WJ8rqaplg3qseL1120NzSvFkfoMXLPa15BDjXMf44ktMRnhfLMwX+1KKujA3I
         OiKLUuRpoXubNTJkEWvkiMwtVOdSgQV5CbCNfHZcmr5WITDKVVfHTIsGDASaeWt2jE
         b/3KFWqXwt3JQ==
Received: by mail-il1-f169.google.com with SMTP id z18so17630287ile.9;
        Mon, 01 Feb 2021 20:40:51 -0800 (PST)
X-Gm-Message-State: AOAM5304VJYd062GNiy5wRrkExGSX28YgNN2LK6ivIe9mMVZhOjLWZrX
        yUi8p/gURuzDC3pd4yVRD4EvHF6mA/iJyKbXoOA=
X-Google-Smtp-Source: ABdhPJxNqcOfKd+2zw8MJa1bQJc0zP65BYOEhjHjT5/AbrEVJT4BT/lW4iFbSw1YdLehcQ4nH1rYekWUvskMwGIjj8Q=
X-Received: by 2002:a92:7a0e:: with SMTP id v14mr16677653ilc.35.1612240850865;
 Mon, 01 Feb 2021 20:40:50 -0800 (PST)
MIME-Version: 1.0
References: <1612232135-26683-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1612232135-26683-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Tue, 2 Feb 2021 12:40:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H70jXH0KCKQw+5rEUv+jBLfksADKMJfpQOuz1PxcvxC_g@mail.gmail.com>
Message-ID: <CAAhV-H70jXH0KCKQw+5rEUv+jBLfksADKMJfpQOuz1PxcvxC_g@mail.gmail.com>
Subject: Re: [PATCH] KVM: MIPS: remove unneeded semicolon
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhuacai@kernel.org>

On Tue, Feb 2, 2021 at 10:15 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Eliminate the following coccicheck warning:
> ./arch/mips/kvm/mips.c:151:2-3: Unneeded semicolon
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  arch/mips/kvm/mips.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 3d6a7f5..58a8812 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -148,7 +148,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         default:
>                 /* Unsupported KVM type */
>                 return -EINVAL;
> -       };
> +       }
>
>         /* Allocate page table to map GPA -> RPA */
>         kvm->arch.gpa_mm.pgd = kvm_pgd_alloc();
> --
> 1.8.3.1
>
