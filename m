Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF6C45561E
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 08:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244110AbhKRH5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 02:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244102AbhKRH5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 02:57:11 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732EFC061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 23:54:11 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so15566108ybe.3
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 23:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tUx9UjZoKSPnqR6g70X7U+S/RFB8dii6mOvb2a9mdkw=;
        b=QdZaVueVf1RI9KAn4GY3zFdazR/X2OmjOrNG3c+p4FkxC1hxvkGmqLSDC5JnkUzGoR
         bJIjgd1N331cufVv26TCQHZiyG8JwYR9tD/2vG9Fp3EtD9lnL7PBKozHyQn83bYGZRnF
         urnmL7ipfX/FGNoOKIm2xoNfRfCgyS6fcKrQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tUx9UjZoKSPnqR6g70X7U+S/RFB8dii6mOvb2a9mdkw=;
        b=55zJN+9BuRojTuF7ador0N3c+HZ1pZvELb1/EZJB1WXzixOEEGoxTQ+nDDBur4OyIj
         kdoygyMVXc6YuRGYD8sexiyyLSMEpypYSEyLsaSGHOJ5nhmBSVqS5e5re7ZUYVhzZwja
         L8R8ya7+p5vJdAWIuGcVbowsZg6drPb8LFxYl9lNKS+C5LG2yvQP2ROeMqVXUX7tEpVL
         tQYZLTdMYrD6BUp5iSULcrwcJgmuYKUHxQxi94+aaQH5siHsTMS5gGGz8m8zyCUn+j10
         /7QfmClxBCfSYy57+KtHleW6mtyztEHgQmm/6fKxkcLd8TX2hIfpc1VOz/aigAycVt0j
         daVw==
X-Gm-Message-State: AOAM531UBMDzvnMgVmCJZLvcCyeHFocuuirkOkeEZoM8vJVp13XUUnj/
        JmBqhnN5Pb2IFPwyekVdpe07LZPESdfnu0eCFc0N
X-Google-Smtp-Source: ABdhPJztIGeM2yO42tHG/OmNK597LLtMYpZrWrT/uiP9eI1nHBWCBrDBBYc830E4jWNuw8OZfj6oG/jQLdidDgSgfko=
X-Received: by 2002:a25:b005:: with SMTP id q5mr24987464ybf.35.1637222050369;
 Wed, 17 Nov 2021 23:54:10 -0800 (PST)
MIME-Version: 1.0
References: <20211117084705.687762-1-anup.patel@wdc.com>
In-Reply-To: <20211117084705.687762-1-anup.patel@wdc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 17 Nov 2021 23:53:59 -0800
Message-ID: <CAOnJCULQJj0ZyyF+Q1cogXsC9GDQKLTms8vHvNNpj4aHntmx6w@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 12:47 AM Anup Patel <anup.patel@wdc.com> wrote:
>
> Let's enable KVM RISC-V in RV64 and RV32 defconfigs as module
> so that it always built along with the default kernel image.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
> Changes since v1:
>  - Rebased on Linux-5.16-rc1
>  - Removed unwanted stuff from defconfig PATCH1
>  - Dropped PATCH2 and PATCH3 since these are already merged via KVM tree
> ---
>  arch/riscv/configs/defconfig      | 2 ++
>  arch/riscv/configs/rv32_defconfig | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
> index c252fd5706d2..ef473e2f503b 100644
> --- a/arch/riscv/configs/defconfig
> +++ b/arch/riscv/configs/defconfig
> @@ -19,6 +19,8 @@ CONFIG_SOC_VIRT=y
>  CONFIG_SOC_MICROCHIP_POLARFIRE=y
>  CONFIG_SMP=y
>  CONFIG_HOTPLUG_CPU=y
> +CONFIG_VIRTUALIZATION=y
> +CONFIG_KVM=m
>  CONFIG_JUMP_LABEL=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
> diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
> index 434ef5b64599..6e9f12ff968a 100644
> --- a/arch/riscv/configs/rv32_defconfig
> +++ b/arch/riscv/configs/rv32_defconfig
> @@ -19,6 +19,8 @@ CONFIG_SOC_VIRT=y
>  CONFIG_ARCH_RV32I=y
>  CONFIG_SMP=y
>  CONFIG_HOTPLUG_CPU=y
> +CONFIG_VIRTUALIZATION=y
> +CONFIG_KVM=m
>  CONFIG_JUMP_LABEL=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
> --
> 2.25.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>


-- 
Regards,
Atish
