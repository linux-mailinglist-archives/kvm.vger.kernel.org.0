Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DCD74C958
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 02:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjGJAzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jul 2023 20:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjGJAzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jul 2023 20:55:36 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B8E102
        for <kvm@vger.kernel.org>; Sun,  9 Jul 2023 17:55:35 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-44350ef5831so1344290137.2
        for <kvm@vger.kernel.org>; Sun, 09 Jul 2023 17:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688950535; x=1691542535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o4Qr+CMcRvK7od0Tu4aV60dgvSnHiMgCwfgZMkOn8Ik=;
        b=HEz/W/WxWMhRUbHbBn4jXo7TWQFBUyQeU3XT8Z8bawnzRrx93gQ5GqlrmU2mky0yuh
         4aGNzbYDaPytyRZyxiYTXXybVUDmWYLWwUXs4xq4SuoHfFUlytNlSxFNqlo4yPZg///q
         eHokUPCrvm1KugKMUk/Rg0AuZg18iAM8nu+9/590co2jKFQdO05mXrpdeCYbfnrlm92H
         e2uO+NdH5+1bLZpk+ft9gNl/I5S7aI+i2c99DMbqzOIDpsvKlRet8U03jSVr/4+8I0Ze
         5noHbDzcjOccDjDxyjgj9rF6ctnJkmf6GBhHAY3F1LGU6BXJ23t6t8+CP1XSB4FgXj2b
         AlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688950535; x=1691542535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o4Qr+CMcRvK7od0Tu4aV60dgvSnHiMgCwfgZMkOn8Ik=;
        b=lVvJot6jyz6EdpfLd+bkGEfc2tsnd9Hz2draBp4jTT/ICg1ebiMOuNmEjDEM+BTlfi
         x2FvThqjyQ3jLqNfkt5XY6MBAWgv72yrF9duWccBXiqJpAkrSnZtDCaLuvkpUtTwZMH4
         iy8AcVbiVuXRDYKy+3PAbGb/oRrVYVGUWm2ddX7AeDhH/feuXy/Bzo/dqIzSsr+Vec3b
         Apd7+ubZaIPz1CwROckHHohasKiGH2euxyQzci19/gQV3zOx6cYCr38skgSIXRsZVMy5
         ir1O/QLJNcXjFzJHH9pwyTNkWe85Hq0I2G64WakjAYNreKc65WV5jrgknAld6bTHFKLP
         X4mg==
X-Gm-Message-State: ABy/qLa53i3/m/90ecZZ2JtWGq1wAeDhOOdWnCaDF2fU0kMTYZ8yeMto
        TkeVnC/SOevzPGb0rkb8YlsoEq9F7/PhO1gnIsg=
X-Google-Smtp-Source: APBJJlEgxK2QI3lIURM2zYzSkWNt2S7ck3rXLLhVEpJAf6xAIW7dFzk+ewpxpk5GinLPuspaPpISDnHhtOvtYQdEKv8=
X-Received: by 2002:a67:be06:0:b0:443:5af5:8128 with SMTP id
 x6-20020a67be06000000b004435af58128mr5664519vsq.0.1688950534720; Sun, 09 Jul
 2023 17:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230707032306.4606-1-gaoshanliukou@163.com>
In-Reply-To: <20230707032306.4606-1-gaoshanliukou@163.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Mon, 10 Jul 2023 10:55:08 +1000
Message-ID: <CAKmqyKNFx=t4x25fLQWdtWhzhOrN-+xU0FmifquT8pcfNALbng@mail.gmail.com>
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

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

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
