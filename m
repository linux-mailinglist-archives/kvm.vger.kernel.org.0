Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992FC48D1B8
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 05:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiAMEl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 23:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiAMElz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 23:41:55 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E2BC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 20:41:55 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id n19-20020a7bc5d3000000b003466ef16375so4695816wmk.1
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 20:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rRgjIPZAMfyNauGGHIKOX091JCYAgZevyPfFhtUJQts=;
        b=Rn4+emlflINHAHBiSJ3Gzd6GT/de+VWv1au7GWk8b6OrMoecsjCkN7c2+18t9vc79g
         7/bhYYKnUbclewXy8OEZ2KoO7zxZurf+4JJrLx9x4uaDDYYrUAM1m56vbxB/gB+PxRQE
         HZkeZyGPq+n/OKrDrWG/sUMFsEJzVyYJBdn7TY9KsBwwrfn4BuXazF9bR9Ktitc2dbij
         E0YYlNoJBPpEsqvZvlsHm4bYM3TFrgtrE2RT4OE0MDnUnRSinq+7ohA5qBgkYzX5ycVx
         9icDwH5VvCF/25c11L298V7PN4DF/vIQXmRLI29BDg8DTAXerFFqkrDzA86+HG/4eOMg
         Vd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rRgjIPZAMfyNauGGHIKOX091JCYAgZevyPfFhtUJQts=;
        b=RUwXNDjBBCT9Lp1jSh8SY/BqTCcza3L9dE0gtDWW4EXGa+wo6sNjB+J+ueVDBWzy7S
         AlioTcVy5GSLnvLDyRxdn8HFH+COo6XY1+JJMUh7gpHvXMOABViTklLrpYJ9uDPMHhY7
         fMZH6WWa5/qfjgKAH0YZTGMblO37liV5/WEaVT61hpKmn5oliglMG8PDJ3REH3OmK8+A
         Z6chSVdVhFPcgtB8H7Em+iTZUvwMC7rZih7YYcbeRAB63vtjfmGQKneqbd1eZZz4OzS9
         xcBhl8EDHuL0J8d3Ijm56XUdNAN5e7lNXkQCCK+Y7ShA88BSPpXTMiU2e/K6EzJh+7i5
         5ENg==
X-Gm-Message-State: AOAM531Ih35QrZHPSTvatdTFCMaNlzklpIngr19O74TrTrTsq2c50cq7
        Rx+MsfT6AEMR5MDFjzNpKNveOrxlq1AUig7yDd4Qwg==
X-Google-Smtp-Source: ABdhPJwq/inlKzSq75AY+T0EiU9ZxyChPaiKkzBbfN+RsyzMC//uRd8wWeOw7uPjcUk1dOIBM5ntx6MYREPqrrRjUC4=
X-Received: by 2002:a7b:c0c1:: with SMTP id s1mr9159071wmh.176.1642048913903;
 Wed, 12 Jan 2022 20:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20220112081329.1835-1-jiangyifei@huawei.com> <20220112081329.1835-14-jiangyifei@huawei.com>
In-Reply-To: <20220112081329.1835-14-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 13 Jan 2022 10:11:41 +0530
Message-ID: <CAAhSdy2oOiiJ=ogzP4+StyvJpqaa-zjPGqKA2hy2T3JcCO7jCA@mail.gmail.com>
Subject: Re: [PATCH v5 13/13] target/riscv: enable riscv kvm accel
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        libvir-list@redhat.com, Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 1:44 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add riscv kvm support in meson.build file.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

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
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
