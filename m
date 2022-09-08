Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9675B2552
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiIHSH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIHSHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:07:55 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2AEE5803
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:07:54 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v128so3713357ioe.12
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 11:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Sgue2it8oIQyCZ0dgiK+lfIOhc4Ojo+VX9+hlyU/fAM=;
        b=WpwXWk7ovo/Px0C6HQi+mrMV6vmY457JOa7D9wb3PNQyrhxq1IFQqzD+S3QhbrxmT8
         j27jbd+ucoBB/AaHGPNA9VGGf0Cp4hmrB4wuyO4h9FfHI1GQtKKVKmKnmKs03IO1+A8K
         JtyMeCHPQcqZqagARULCy3nQ5zGRxOT/McRQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Sgue2it8oIQyCZ0dgiK+lfIOhc4Ojo+VX9+hlyU/fAM=;
        b=XM11EBvALpjthtWKlMAav3m+mFbKgzPKAGk50WdQwN3optLj774GcZyw2rIpwnXu3j
         MjsDFDD0SKdYq0GEDeLj6+btCZRtdNNQN3tk3bwi2S3fQx4uapizJc5zAEAF3H+zvEcC
         /VIUn6eaDbM9AU0os61hZ8T4dUmY2re091BoDtaV7ZZSkL2p3MrGpb2KgGD0uMVVT7I3
         VwEmWuQXxpuy/ku7IRwx6DigNfgjAqmq03YwrgCb31xKroIF4S95TsrHBRbyrpi44zKh
         7UODcbLLgV+ENALgaA+YOgjJR9QxCgCF4Y3BnjKiPFd9rX0JfH8zKYCxTlKST6nDXt1P
         tl5A==
X-Gm-Message-State: ACgBeo1FcQ//2qJoig0blkxq3GqCueYSFL1omcVB4jjMOn9fiRuxA+q/
        k3wHLrOFOJK/v+vwkGDpRlEkgImTi7phIyU1APibMRr4Vyap
X-Google-Smtp-Source: AA6agR5om7Zij8/Q2Sk3qE4xiianEiekmBgoO0hsMaV3qvOLptDT+b0crxMt2BaHlXCtF/DfIuUbrYNeeSjgOYWsy6o=
X-Received: by 2002:a6b:cf09:0:b0:68b:8602:e487 with SMTP id
 o9-20020a6bcf09000000b0068b8602e487mr4482792ioa.127.1662660473381; Thu, 08
 Sep 2022 11:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220908110404.186725-1-apatel@ventanamicro.com>
In-Reply-To: <20220908110404.186725-1-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 8 Sep 2022 11:07:42 -0700
Message-ID: <CAOnJCUKHCjmaJ2TCxUVnuYetWovwJQnEWJEi3geqf1hOGSM_Nw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Change the SBI specification version to v1.0
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
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

On Thu, Sep 8, 2022 at 4:04 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The SBI v1.0 specificaiton is functionally same as SBI v0.3
> specification except that SBI v1.0 specification went through
> the full RISC-V International ratification process.
>
> Let us change the SBI specification version to v1.0.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 26a446a34057..d4e3e600beef 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -11,8 +11,8 @@
>
>  #define KVM_SBI_IMPID 3
>
> -#define KVM_SBI_VERSION_MAJOR 0
> -#define KVM_SBI_VERSION_MINOR 3
> +#define KVM_SBI_VERSION_MAJOR 1
> +#define KVM_SBI_VERSION_MINOR 0
>
>  struct kvm_vcpu_sbi_extension {
>         unsigned long extid_start;
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
