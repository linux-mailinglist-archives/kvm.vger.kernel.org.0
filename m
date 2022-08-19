Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C442159A6E4
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 22:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351693AbiHSUJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 16:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349927AbiHSUJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 16:09:14 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4B89D102
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 13:09:13 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-333a4a5d495so149493827b3.10
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 13:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YuF+xqYANb0UpSKdFXaPIjdGoUsETegDwAlHIfHh17s=;
        b=SmwVsSxLi/TN3be8ePf4Zt26MSe+mpgAQ9Yj1M7BSIb+2/45bT5dcu90JsXbPBl5vH
         caJzUu+A8tA+CqBs274jJpfoLUC/7GmPmhVg8b6otV8Dg+XUbZaq4LVnJUo5r2JnpOd1
         oZC+HNnX9iXvL2IpKtVVL/slYa6BOXTlJ7kWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YuF+xqYANb0UpSKdFXaPIjdGoUsETegDwAlHIfHh17s=;
        b=D0p9zJ+4ESSKizF+19+AaijtUpz3pQISsn2oCKVFHf8bzxlO1GxOxR39ois9i7+DWl
         V1zW/+ABWnpf0irS4IoK8atvTPIzfkMkDlm+314YqhRiYKcJCOlsYu9xSzDOKWqReTxK
         Wi1ZvmvFu9zNjB+OKQebF5apyI06gq/C9QMwaWoESfVHExs4TtIvOrlnZf9J0dxjIT3T
         hnuZI+SieywbnLdI8Bu+ZkikivY1VY2gADcEY/t44k+YmeN8Xu6Ae96TXwnLnLfEWKMa
         emsBuUWYldRlgdiLv2dLJ5tAc97cfm795VByZWq0i3BTsZOR69l059a7Fu1d/EiIdTiz
         12rw==
X-Gm-Message-State: ACgBeo3njni2fII8uMRgfg7N22z0VxVV35KxOay0ScN+PtheomDQ9pio
        M57JAoYMonybBlaIDJrZ8z9d1SDNjVyMh7//F2qC
X-Google-Smtp-Source: AA6agR7wQ8oKJPNlIuB55kWztWUPT4TZ4pt1foHS2qP00B5/o+HsUbPTDI0y9sCaodK5ZH30pxM3xwnr92xLtnZ6tlU=
X-Received: by 2002:a25:5105:0:b0:692:17f6:62b6 with SMTP id
 f5-20020a255105000000b0069217f662b6mr8381453ybb.361.1660939752536; Fri, 19
 Aug 2022 13:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220814141237.493457-1-mail@conchuod.ie> <20220814141237.493457-2-mail@conchuod.ie>
In-Reply-To: <20220814141237.493457-2-mail@conchuod.ie>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 19 Aug 2022 13:09:01 -0700
Message-ID: <CAOnJCU+gvVfqN6DHQRMtJ82xU4ZajHrANfeDjt21i9Om4r43eg@mail.gmail.com>
Subject: Re: [PATCH 1/4] riscv: kvm: vcpu_timer: fix unused variable warnings
To:     Conor Dooley <mail@conchuod.ie>
Cc:     Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 14, 2022 at 7:12 AM Conor Dooley <mail@conchuod.ie> wrote:
>
> From: Conor Dooley <conor.dooley@microchip.com>
>
> In two places, csr is set but never used:
>
> arch/riscv/kvm/vcpu_timer.c:302:23: warning: variable 'csr' set but not used [-Wunused-but-set-variable]
>         struct kvm_vcpu_csr *csr;
>                              ^
> arch/riscv/kvm/vcpu_timer.c:327:23: warning: variable 'csr' set but not used [-Wunused-but-set-variable]
>         struct kvm_vcpu_csr *csr;
>                              ^
>
> Remove the variable.
>
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  arch/riscv/kvm/vcpu_timer.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index 16f50c46ba39..185f2386a747 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -299,7 +299,6 @@ static void kvm_riscv_vcpu_update_timedelta(struct kvm_vcpu *vcpu)
>
>  void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_vcpu_csr *csr;
>         struct kvm_vcpu_timer *t = &vcpu->arch.timer;
>
>         kvm_riscv_vcpu_update_timedelta(vcpu);
> @@ -307,7 +306,6 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
>         if (!t->sstc_enabled)
>                 return;
>
> -       csr = &vcpu->arch.guest_csr;
>  #if defined(CONFIG_32BIT)
>         csr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
>         csr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
> @@ -324,13 +322,11 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
>
>  void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_vcpu_csr *csr;
>         struct kvm_vcpu_timer *t = &vcpu->arch.timer;
>
>         if (!t->sstc_enabled)
>                 return;
>
> -       csr = &vcpu->arch.guest_csr;
>         t = &vcpu->arch.timer;
>  #if defined(CONFIG_32BIT)
>         t->next_cycles = csr_read(CSR_VSTIMECMP);
> --
> 2.37.1
>

Thanks for fixing this. Sorry for missing those.


--
Regards,
Atish
