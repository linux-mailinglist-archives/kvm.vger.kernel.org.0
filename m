Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E21C74537F
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 03:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjGCBWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 21:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGCBWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 21:22:54 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642E812D
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 18:22:52 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5702415be17so41098257b3.2
        for <kvm@vger.kernel.org>; Sun, 02 Jul 2023 18:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688347371; x=1690939371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRF740pvkTjPn4YyUomuPjqPm+NWFaBR5Nuuxw9suaE=;
        b=sZzttCQ2aFMeuk7Qzxvb8/ctk3BL0j6coXsUhhhCjG4NhHIREn+/97VJ+hl7OSxG3F
         Aa1MUdSfU1WWWKn8kYjOU8fVooQopsh0+VRCQjlG1orSFCZxUuesUzPYZyulQUjCJqZr
         l92XA22clFVvGECLdQG8Ie9qfgl1I3UX0Y9T1uVc5RxR6vbVW5HRUmpRhwt6K6IoMnJR
         Gm3bzOnS2FfrFoeH/5ygtHkXEqKRAm+paQCB9TofUjsOQYza9/ncXTIct/+m691bChfE
         g55Zv9q5NXBF+C21VdaqT+PLTawrGvR//8whU1yY4KI1VHhFCBpRJyda8y0wmcEcu8EC
         myLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688347371; x=1690939371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRF740pvkTjPn4YyUomuPjqPm+NWFaBR5Nuuxw9suaE=;
        b=hk/lBWsCmHFAyWM+UGl/S07QMGYO5luUEyxFGDjzJxVp3yuHlXWXUU8TkRK/2p57Se
         TWjIQNAWCs9vvg1oIV/ZXSXB1lhb8gwQoyabo6SrzPAnnk7qVhSTvrHnIYNb6Enz3Rpl
         9FZs0UVG2enc1dM0WqEUgyQwSaWsU4Uyqgc+ehfv05EKBIdBQpZNuIJPVgfC1KlpSVnA
         9UCEkin9FvCAyxX7qNEre1J+GLyzxiS832sSFgd1XdAF872uqUk61dTJ7WY6nkI/Y/BC
         377EY441PjHp8yJ8syY4YfQcRonPO0hHFzMmUjyHJlI8UzJkAI5a9y+K6gJj3ditRjt9
         EhkA==
X-Gm-Message-State: ABy/qLbwUeX8vGIluKRgaBFv4Ns3sSwRcGUMhN7uRhIjLS9zgbLxoIze
        ApoXM13r8cLiIB6WSkL/FkXFHDn3PK5Xp1tkxoo=
X-Google-Smtp-Source: APBJJlEYfvoyq7nlwsb2Qd+EnEtO+x8RmnoUJdsf3KLdVU8hbVL3wJDxvBrE6UtcPOKcqPjcE1hYTT0Q8ZhcfgSdgdo=
X-Received: by 2002:a25:4d07:0:b0:be5:fa6b:1fcd with SMTP id
 a7-20020a254d07000000b00be5fa6b1fcdmr6540014ybb.30.1688347371509; Sun, 02 Jul
 2023 18:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230620081611.88158-1-philmd@linaro.org>
In-Reply-To: <20230620081611.88158-1-philmd@linaro.org>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Mon, 3 Jul 2023 11:22:25 +1000
Message-ID: <CAKmqyKNXLxE=AN-nOt6eMYFMdY1hFQqg3wFh364-pQ26xTeTaA@mail.gmail.com>
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

Do you mind rebasing this on
https://github.com/alistair23/qemu/tree/riscv-to-apply.next?

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
