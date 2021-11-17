Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A714542F5
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 09:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhKQIwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 03:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbhKQIwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 03:52:31 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED32C061746
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 00:49:32 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i5so3144470wrb.2
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 00:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B7IPC7bC9AT8/D6fv37MaKPiWkigtWHGnCaDAdR23ks=;
        b=hr4Fk8sFDF5tNoJTaSITi0W06sn1vv3dLU2DPO5fkfTKyBCQmGQMCPwnEJLd447s4D
         /u2JAf8Wh5O2yyhZP75ZiMcjXIZN5AUnPGNYv12RZwVWLvdzsrBmoG8HFaTpHblvz3Cd
         GkxydX4K4zTJepGsnr721QACfbOk7bZv4XRSAq6Y/Agsz+B9YLIC/+hrhgGzhDleh44m
         SMJ9OrjL+buwd5wjKSYBaTs6+wR/fYsmq5AK5UkDCRdiCaKK++SiYZtl+Sp6NG8zruad
         UMhR+Ps9znscTWYK9qSV7l5DZuZWYxc8M+fcQJWDQwFbIKvYjTZzGVXGYHWqi3oSH0eb
         lTkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B7IPC7bC9AT8/D6fv37MaKPiWkigtWHGnCaDAdR23ks=;
        b=ieSZpTCmL2KstiCMw0OyBCVSxZVRdTV9450edEc12YcbOrtxdmzQ/PgHDBZDXkReaw
         xLRljeE42ozg4ANsMH3Tm5CLs0ueSbqrxGPplr40WZ6dnvf2HZ5R1XgTWMA6NvypTkEL
         oGMq6N72szmhq7QHfp2cAZjWVcLZ9KhrMl+E8Zs90wF40vrmkS7QCxWJVDF+DHpvjx1+
         w5d43THJnVQ5b/Xr/d6hHuFibJlXRI1UocvKAigVCej53OVMGjTCgcKrUFOlRae7v4At
         qgvV8apDGqpXkF5+/WrMbjfTVyNHG5jRfPzPiYRTILqcOIushKap7yX3+Fa2tChnEW7o
         KLBg==
X-Gm-Message-State: AOAM531RO0HaWsqTJpcrV+9vS3LJiq5MMYtYcQ43d4WGbrYoEuhapYAI
        HASA2pMF2iUsjRZEtDnG4lC/ruMqrpiojJisWjD7Ug==
X-Google-Smtp-Source: ABdhPJyULSq3RsjoXSpZlMHvAUGqp8FyT72f4rtpMXvyJSvuccvxb9bbZU1AiHFvqU7V9KJiog1NXIx2vH1S+mg6+HU=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr18297636wru.363.1637138971386;
 Wed, 17 Nov 2021 00:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20211117084705.687762-1-anup.patel@wdc.com>
In-Reply-To: <20211117084705.687762-1-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 17 Nov 2021 14:19:19 +0530
Message-ID: <CAAhSdy0z=QGDVnnfsg2hYANv-=8ooCWrnRtjut88exioAvcZYA@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palmer,

On Wed, Nov 17, 2021 at 2:17 PM Anup Patel <anup.patel@wdc.com> wrote:
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

Like you suggested, I have removed unwanted stuff from
defconfig PATCH.

Can you consider this patch for Linux-5.16-rcX ?

Regards,
Anup

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
