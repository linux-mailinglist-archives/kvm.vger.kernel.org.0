Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B79374C965
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 03:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjGJBCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jul 2023 21:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGJBCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jul 2023 21:02:08 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49649B1
        for <kvm@vger.kernel.org>; Sun,  9 Jul 2023 18:02:07 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id 71dfb90a1353d-47e35eba3e9so1103695e0c.2
        for <kvm@vger.kernel.org>; Sun, 09 Jul 2023 18:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688950925; x=1691542925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRYtNHqsD/i2GP+XXGxrr3lbGT6QdmCj8XgbZf/scYQ=;
        b=p7oYyAkAw3DH9IirgEZA+RJ25h5IQQqai0f1y89WRKA2zZ20BL2I6AFTuET5fiaBXj
         VqtGq/heeX0kk5fTWR1DTIpT7OeXKJVTJ89LBgXIZf0EM6aApKFpYgHFz9c58ILNatls
         dJYyuwQ5jchpeSVudQJo0FltUPfUOYpiT6VmWM3pj8h6Z7ciZzQLjf4v766HbUVc0FXk
         pBYC1pMIY4alzYD09QrX6NplOaW+PQkivDxGQyfB9QWV/r9ZkNEeOZHAlVRhiIFwTT13
         nHpXnmNcFXXTEGwfG7BXo3J0nFnJEa2lO2j0jGfpTo7SoN+l32oyD3qoDClpFobB6ZvW
         b4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688950925; x=1691542925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRYtNHqsD/i2GP+XXGxrr3lbGT6QdmCj8XgbZf/scYQ=;
        b=Cwjone4icn6hql1P+Cy4LU8IWNVFM+R3fl9Q0jDuEoEXbcaabhfDhRS46XgP4zE+JN
         A+Ebc/S1EPjGoZQvFnO7BwgcJ8eNndUj3MtUxeFWgfedpdIdm+YQ2bTLQhxjYQfRfJB4
         gx1e+U8xuIvAYf2FIMsf8VYXOMFxERmk/IySes0RI8+1EANNJ44SwaYZeKL7/bdfNWCG
         phElxcLba5lEwxmVl7zgvKX6assp0am1+A5Bfx/4DZ1dciaG5w8u2JQNZfzVQ+Ttl7kG
         s6LhfeYLI0MXJX78iMw57pM/zmw2im5VPZnBaEmMkGTES7weA4ekIWrD+Lm/rWJrAqQZ
         Jtzg==
X-Gm-Message-State: ABy/qLb8M3fGJQzavJ6jTV52Ow9Z2ZOnn9GG9mnR9wNuKnVrC6Q227aJ
        c/Xi8becd6TaQKeRsgFLl7NkPcVaQYhrHJ7l/m4=
X-Google-Smtp-Source: APBJJlHrD1aNO4ofNtJJmaoZOLUjR3G37DvvyKxapubQ1yjAWCDYGA2UIt3dzFRF9BV9KSeGbr/yN4WhhQJygrm+55o=
X-Received: by 2002:a1f:3d44:0:b0:476:4267:178d with SMTP id
 k65-20020a1f3d44000000b004764267178dmr5040935vka.12.1688950925530; Sun, 09
 Jul 2023 18:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230707032306.4606-1-gaoshanliukou@163.com>
In-Reply-To: <20230707032306.4606-1-gaoshanliukou@163.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Mon, 10 Jul 2023 11:01:39 +1000
Message-ID: <CAKmqyKMz=GXKaBAbFe6iBi3codHw-HVN-cpF42riMPUw6E_S6Q@mail.gmail.com>
Subject: Re: [PATCH] target/riscv KVM_RISCV_SET_TIMER macro is not configured correctly
To:     "yang.zhang" <gaoshanliukou@163.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        zhiwei_liu@linux.alibaba.com, dbarboza@ventanamicro.com,
        "yang.zhang" <yang.zhang@hexintek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 7, 2023 at 10:26=E2=80=AFPM yang.zhang <gaoshanliukou@163.com> =
wrote:
>
> From: "yang.zhang" <yang.zhang@hexintek.com>
>
> Should set/get riscv all reg timer,i.e, time/compare/frequency/state.
>
> Signed-off-by:Yang Zhang <yang.zhang@hexintek.com>
> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1688

Thanks!

Applied to riscv-to-apply.next

Alistair

> ---
>  target/riscv/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 30f21453d6..0c567f668c 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -99,7 +99,7 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, ui=
nt64_t type,
>
>  #define KVM_RISCV_SET_TIMER(cs, env, name, reg) \
>      do { \
> -        int ret =3D kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg=
); \
> +        int ret =3D kvm_set_one_reg(cs, RISCV_TIMER_REG(env, name), &reg=
); \
>          if (ret) { \
>              abort(); \
>          } \
> --
> 2.25.1
>
>
