Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A488C59A326
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354106AbiHSQrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 12:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353983AbiHSQqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 12:46:52 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CE112FAF
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:16 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3376851fe13so100225087b3.6
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=XijIKPSG6kvk8NxvmjtmY8phogA8Jwg+9VLOMKAfxBo=;
        b=KoQdAvLdqtvHerjKo8zZBjTL/cHkXCa4FZvixhiHnVBVmGjebrzzmMPcNii2PopeJ3
         jSRjeiydxGpUrOqqd7ApmQYIVlnt4yfIbWSCa6jbq2bOlXUppHIzLKc5X58O03S/GmBf
         4Y5oQycOJCylvDSGcTTYOwIP3IrmdyTzegkl8VYWTdOpbRSdMfqytx4M336a9/8L9DR/
         aXvpM9EL5VVLIuXP2Cwz9Wi0w7PPNMB09fppbAHD4GeqhOhQsJhaKGSTGt2bhIEPHK3T
         C5zBz/NHIPWjZdrf+xzBg/cz4L+Q8pzRn//FLLD38Iny+JGgkAP/WYob23oW/00WNtp4
         aCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=XijIKPSG6kvk8NxvmjtmY8phogA8Jwg+9VLOMKAfxBo=;
        b=NjiNQ9eMNasSgUDi2cn+AWHtP/8Tz8TLcZZXPOe4AwNO+U4DVuXkqfSWkTKtvTqPp8
         UnFEyrn1CxNDZUDpE9I0rofDptIH0FVEVG+qBA0FQLJJV/Bu3FxeiRv6sm7YBqlDpp9w
         b/jSYT/d6j/vnGHFbh8izJmVrTDPX7hjQTtkwDLCNLWr2QXMCWgyCLYcO5YympE4hDTT
         2V+lZcRfuySyMxFOwnTrnD8cj2+c0dEsFNE8MyqapUGBDtzTga/mpiQKs0kgYVvhM3He
         ZvSe1tRiVn/f5Tp4P1t0/tXPcqzuaJuTW5cqbjcJGk42KEhdtm92WjXDZqtFwSofue9y
         r6JA==
X-Gm-Message-State: ACgBeo3mXMhVqmuM2rB1WN0A0DAkUQEYY17ospuJH4FcGD4ifCIIZ0+T
        h4KP54VX7qpLINa30Vl2f7SxawUFkDc/PqRbOr1fRg==
X-Google-Smtp-Source: AA6agR7JuD2dimnGRGHFVLmW+yzm9h4JA2K68J6n4uTdZ2bc1pJuMlF2Ky547pqa9ml0uDdDALfemeQvwqzG18V8dJM=
X-Received: by 2002:a05:6902:70a:b0:695:6d71:ecd6 with SMTP id
 k10-20020a056902070a00b006956d71ecd6mr318886ybt.619.1660925518203; Fri, 19
 Aug 2022 09:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220814141237.493457-1-mail@conchuod.ie> <20220814141237.493457-2-mail@conchuod.ie>
In-Reply-To: <20220814141237.493457-2-mail@conchuod.ie>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 19 Aug 2022 21:41:46 +0530
Message-ID: <CAAhSdy1qEJR_d5ynbptsCVOA5fk+dPyZ0mzT7-y-RXtQjMni_Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] riscv: kvm: vcpu_timer: fix unused variable warnings
To:     Conor Dooley <mail@conchuod.ie>
Cc:     Atish Patra <atishp@atishpatra.org>,
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 14, 2022 at 7:42 PM Conor Dooley <mail@conchuod.ie> wrote:
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

I have queued this fix for 6.0-rc1

Thanks,
Anup

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
