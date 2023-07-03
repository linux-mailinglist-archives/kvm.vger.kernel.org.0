Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756B574536F
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 03:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjGCBDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 21:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGCBDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 21:03:46 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA3120
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 18:03:45 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-440afc96271so1344731137.3
        for <kvm@vger.kernel.org>; Sun, 02 Jul 2023 18:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688346225; x=1690938225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kr/csRpj7yRPd+a7XEQy9luDGdTRfuaDwcgbO882Uj8=;
        b=kOhKlHs+rIVwGNY5dryVgpjloNzsE74uqLEH50SI1+QjWy0EzNZs/z6Szie+6igmog
         OaWB5piKPLNyMtmpSVGY77Zf4cT5S8rssJAO2ivGBWZEmvkp//5aMZp6TzXYsNN3m3Za
         iTedvqhwrm0xaf6V6ERCqoGESvdmTcJIiSrdzVL33uYJhHgLKRjzN6WxGVRxUXy2KijT
         jOI5xDUOIhsiW72ztAr0f/vqtinUztpsGSrK6iFL6dibO6Vq9RRDR+UBz27o5d5Vs0p+
         hNe7ebF4NCxiRCHpgpzkZtRMX++j37B5sd5D3vN/2mA9JoUctktxc/cIA/hfGT7HL239
         ETUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688346225; x=1690938225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kr/csRpj7yRPd+a7XEQy9luDGdTRfuaDwcgbO882Uj8=;
        b=Rd0lCLC37Xn+KpuZ44HunV74tb9tmTRgbsLfMaZjsQmYAxbwRE4ieZ9l7DPxSZjccY
         Pve0zKXfVcBNyIkMRqfdmDAP9PLVP+IqatfhxfoEIjRbmpOIEZ/QLTSUH7XevbDK9RaS
         4S2J1Q08+W56XTY0X4I/xDHs4tn3npeef5+MfkbYLuZlj0uaXNab657pzvjvArXJTs0r
         f+43gzqsT+V+QaG8YSqJNgm686LAXSnVQAEqqKF+DEfB/AlXVPD9Ql5qS2/+jG3deDMM
         Ib4utP83Mo1F97alNRKf+vNPiB2NzMiv1YzkE2TGQXNM0ZjToC4HAAVvGP3Inay/50kA
         KEBA==
X-Gm-Message-State: ABy/qLbJ1uqwj4pAmG7UYPeHKxwsv1/GtTUGUqhogaqIJ0OM+c4lJQqG
        NVzE1+vnCGjLHDmzkmiKbwERh0RX4d4kw7jL2gI=
X-Google-Smtp-Source: APBJJlEiA/DJ04JzAYoPetRZd51MbkR1pL12E+h/WqOyzTBsiq/7TvFwrnAP3Qm1BvA19qUXYTGTSNpZoG5Upuv9KcQ=
X-Received: by 2002:a67:f981:0:b0:443:672c:2d8 with SMTP id
 b1-20020a67f981000000b00443672c02d8mr4324597vsq.22.1688346224763; Sun, 02 Jul
 2023 18:03:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230620081611.88158-1-philmd@linaro.org>
In-Reply-To: <20230620081611.88158-1-philmd@linaro.org>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Mon, 3 Jul 2023 11:03:18 +1000
Message-ID: <CAKmqyKObAOYmgT54azCgrYt-aHD8V37c1h6KoNBjshASEdvVwA@mail.gmail.com>
Subject: Re: [PATCH] target/riscv: Remove unuseful KVM stubs
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bin Meng <bin.meng@windriver.com>, qemu-riscv@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, kvm@vger.kernel.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Alistair Francis <alistair.francis@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 6:17=E2=80=AFPM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> Since we always check whether KVM is enabled before calling
> kvm_riscv_reset_vcpu() and kvm_riscv_set_irq(), their call
> is elided by the compiler when KVM is not available.
> Therefore the stubs are not even linked. Remove them.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/kvm-stub.c  | 30 ------------------------------
>  target/riscv/kvm.c       |  4 +---
>  target/riscv/meson.build |  2 +-
>  3 files changed, 2 insertions(+), 34 deletions(-)
>  delete mode 100644 target/riscv/kvm-stub.c
>
> diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
> deleted file mode 100644
> index 4e8fc31a21..0000000000
> --- a/target/riscv/kvm-stub.c
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -/*
> - * QEMU KVM RISC-V specific function stubs
> - *
> - * Copyright (c) 2020 Huawei Technologies Co., Ltd
> - *
> - * This program is free software; you can redistribute it and/or modify =
it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2 or later, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOU=
T
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License alo=
ng with
> - * this program.  If not, see <http://www.gnu.org/licenses/>.
> - */
> -#include "qemu/osdep.h"
> -#include "cpu.h"
> -#include "kvm_riscv.h"
> -
> -void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
> -{
> -    abort();
> -}
> -
> -void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
> -{
> -    abort();
> -}
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0f932a5b96..52884bbe15 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -503,9 +503,7 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
>  {
>      CPURISCVState *env =3D &cpu->env;
>
> -    if (!kvm_enabled()) {
> -        return;
> -    }
> +    assert(kvm_enabled());
>      env->pc =3D cpu->env.kernel_addr;
>      env->gpr[10] =3D kvm_arch_vcpu_id(CPU(cpu)); /* a0 */
>      env->gpr[11] =3D cpu->env.fdt_addr;          /* a1 */
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index e1ff6d9b95..37fc2cf487 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -22,7 +22,7 @@ riscv_ss.add(files(
>    'crypto_helper.c',
>    'zce_helper.c'
>  ))
> -riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: file=
s('kvm-stub.c'))
> +riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
>
>  riscv_softmmu_ss =3D ss.source_set()
>  riscv_softmmu_ss.add(files(
> --
> 2.38.1
>
>
