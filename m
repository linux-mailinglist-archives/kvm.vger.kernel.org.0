Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACA448D1AA
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 05:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbiAMEbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 23:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbiAMEay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 23:30:54 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A013C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 20:30:54 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id d3so4524255ilr.10
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 20:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0yH73VEziEUsOBvUvuDtXgMhHfRsF+1URQubdxH1oA=;
        b=pY7Mte0OzAcXW63BAUXaYTOdzsa1JGw3KPr011kvKGGHhoYVFXLOa8PxG97fl9D8d3
         Z/J9pyIkcULFcslXy4pGNDmUdORuDAEYewbw4AMPowfA1t/lkNho8sIcAnQ3KA1fwnwg
         ghwzsrNdWUcrcWCAA8tkM0fil0M5zrscmJKCBl74fWTg1g71dw5NAPYKna5ysfbKt2ag
         Q1IwAy+gCdN/AIz5uzWrEQT6IopSUszPG30RHgnruoXjUm9/HmCHIzj833BCs/0AYQRE
         BFrnEPW7cZRAFbzSeyZ8RalYnGR/irNgZxrJOphqRgFL0fMHSo7Ll9LGWxveJYuxlEvX
         u+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0yH73VEziEUsOBvUvuDtXgMhHfRsF+1URQubdxH1oA=;
        b=Mm0gI28IxDE0svlfPQ1Sr5UupwhfnJPAB3oNrfJdjoY/BCj78D/mSYZHfcF5dEYDH0
         bNDMuLa0qrMYj9UVMfOQgw8sfzsfBBeI5wMQ213JsvpqU8VQt6RnImwOplh0AbZhcAY1
         PcjmLHpBoipHuEBTar0lt0sJdHxO4KtLLomVxfc0AzraC5E7YEKvAVIL4MzDFDRTkAn7
         wzIX6S/KGi5MRj3GNNtQFoTDulip8yD1SVFeyocf9TkoBYsGZMvSWaorSdRzcXDKuggF
         WtNouSNDLoTQp/dOxeWS+pEotOn4Mn3hU2ddVlEv4GfgruGtmKDAKoSIQWQseC1ZifOm
         SUsA==
X-Gm-Message-State: AOAM531BEjr4RIAwrS7WxQSWFZmWnDxe27+FXt2vXS1meMhESs2ouYYo
        L+89/ae9d8ZuQzL5gMSti0yQNkJX75lOpmeHkGs=
X-Google-Smtp-Source: ABdhPJzRxeFEUP4HrT7eJCBNuyEqpJJ4QtpElQXV0jCU0k4GUcEF7zHHStQ4XECaA/lfs2IQ9LXpPbAYVIUjhhpgC6U=
X-Received: by 2002:a92:c912:: with SMTP id t18mr1449305ilp.74.1642048253554;
 Wed, 12 Jan 2022 20:30:53 -0800 (PST)
MIME-Version: 1.0
References: <20220112081329.1835-1-jiangyifei@huawei.com> <20220112081329.1835-14-jiangyifei@huawei.com>
In-Reply-To: <20220112081329.1835-14-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 13 Jan 2022 14:30:27 +1000
Message-ID: <CAKmqyKPsXeveeOH5-esui43xCpmn2WY0NhhhseL-BuLbzRBk-w@mail.gmail.com>
Subject: Re: [PATCH v5 13/13] target/riscv: enable riscv kvm accel
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 6:25 PM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Add riscv kvm support in meson.build file.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  meson.build | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/meson.build b/meson.build
> index c1b1db1e28..06a5476254 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -90,6 +90,8 @@ elif cpu in ['ppc', 'ppc64']
>    kvm_targets = ['ppc-softmmu', 'ppc64-softmmu']
>  elif cpu in ['mips', 'mips64']
>    kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
> +elif cpu in ['riscv']
> +  kvm_targets = ['riscv32-softmmu', 'riscv64-softmmu']
>  else
>    kvm_targets = []
>  endif
> --
> 2.19.1
>
>
