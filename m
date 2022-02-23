Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4308D4C05AE
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 01:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiBWABG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 19:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiBWABE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 19:01:04 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17B3B0A
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 16:00:38 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y6so44585280ybc.5
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 16:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSiA3S1xm7pTjQu/oWXgbDLtQEnGSkP+ktjeX6MfsjM=;
        b=Bu6a3ODl5Dt10lmJ5M8HJj4XhWyMZUaPvnc5LHBO10SuKJ0H6a1+Gft6VaKaQipiGt
         OIEB7d4uZNNxcC61l1LBWuQ1YYW6u6j5j7NORForrUCLX4n9gYHjjv4rse1jN401KuaQ
         OElEcQ7cvC+9l9AaJQVhISosQFpNVruxJxwJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSiA3S1xm7pTjQu/oWXgbDLtQEnGSkP+ktjeX6MfsjM=;
        b=XRQzb10d8suWANQVjin9zs8YbJReaHmqHHkSpVQeND1xMqvaq2jF+Jww/YkiyR14Ac
         Y9MAyUtGrs/NPReBWjVmlV+DmPjo71XOm08mkjEMUiguqkHN32Y6vOu1SCUDrbGC4mwh
         OJ23kRFnv7IL2b2LgC/uY9N7xBy2xNR9IoygxPngq/R1InRRiSN7EvX4bmoB+D0issUr
         i0NY2FgbpLV/u59rw67QcyZymwj8URX3meDVh7ImAkNfTbg3i1AmIbgoCFM8RkdIz46L
         NpdPDK835MD1grZDGCBoDaioXjGnnWGVj4SLbqv3ig9hfXXJIBtMPTsnvp7qtngl0fUD
         A2yQ==
X-Gm-Message-State: AOAM530sBcb09Y1COorUHK2p2qY4TesUpVshax8t8LhnxiplJ9faL59b
        /IpLfVMACMH57WFRvPt+QgA/7YVZdvIjCgZUQCOLX4Q4Rw0d
X-Google-Smtp-Source: ABdhPJw/3qzihNlONhEyWS53iUqO28cZ5mxXYNwCukNQR9UtK83rnxFwjJmDBuKON6Y+0IknNK19j5XplikMTJtDQ18=
X-Received: by 2002:a25:b205:0:b0:624:6faf:d090 with SMTP id
 i5-20020a25b205000000b006246fafd090mr15268936ybj.14.1645574437937; Tue, 22
 Feb 2022 16:00:37 -0800 (PST)
MIME-Version: 1.0
References: <20220201082227.361967-1-apatel@ventanamicro.com> <20220201082227.361967-5-apatel@ventanamicro.com>
In-Reply-To: <20220201082227.361967-5-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 22 Feb 2022 16:00:27 -0800
Message-ID: <CAOnJCU+Xfd5Y-ZLrY1JVoYFOtgw7eSahO=QwZVT57VV_UVjQVg@mail.gmail.com>
Subject: Re: [PATCH 4/6] RISC-V: Add SBI HSM suspend related defines
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
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

On Tue, Feb 1, 2022 at 12:23 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We add defines related to SBI HSM suspend call and also update HSM states
> naming as-per the latest SBI specification.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/sbi.h    | 27 ++++++++++++++++++++++-----
>  arch/riscv/kernel/cpu_ops_sbi.c |  2 +-
>  arch/riscv/kvm/vcpu_sbi_hsm.c   |  4 ++--
>  3 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index d1c37479d828..06133b4f8e20 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -71,15 +71,32 @@ enum sbi_ext_hsm_fid {
>         SBI_EXT_HSM_HART_START = 0,
>         SBI_EXT_HSM_HART_STOP,
>         SBI_EXT_HSM_HART_STATUS,
> +       SBI_EXT_HSM_HART_SUSPEND,
>  };
>
> -enum sbi_hsm_hart_status {
> -       SBI_HSM_HART_STATUS_STARTED = 0,
> -       SBI_HSM_HART_STATUS_STOPPED,
> -       SBI_HSM_HART_STATUS_START_PENDING,
> -       SBI_HSM_HART_STATUS_STOP_PENDING,
> +enum sbi_hsm_hart_state {
> +       SBI_HSM_STATE_STARTED = 0,
> +       SBI_HSM_STATE_STOPPED,
> +       SBI_HSM_STATE_START_PENDING,
> +       SBI_HSM_STATE_STOP_PENDING,
> +       SBI_HSM_STATE_SUSPENDED,
> +       SBI_HSM_STATE_SUSPEND_PENDING,
> +       SBI_HSM_STATE_RESUME_PENDING,
>  };
>
> +#define SBI_HSM_SUSP_BASE_MASK                 0x7fffffff
> +#define SBI_HSM_SUSP_NON_RET_BIT               0x80000000
> +#define SBI_HSM_SUSP_PLAT_BASE                 0x10000000
> +
> +#define SBI_HSM_SUSPEND_RET_DEFAULT            0x00000000
> +#define SBI_HSM_SUSPEND_RET_PLATFORM           SBI_HSM_SUSP_PLAT_BASE
> +#define SBI_HSM_SUSPEND_RET_LAST               SBI_HSM_SUSP_BASE_MASK
> +#define SBI_HSM_SUSPEND_NON_RET_DEFAULT                SBI_HSM_SUSP_NON_RET_BIT
> +#define SBI_HSM_SUSPEND_NON_RET_PLATFORM       (SBI_HSM_SUSP_NON_RET_BIT | \
> +                                                SBI_HSM_SUSP_PLAT_BASE)
> +#define SBI_HSM_SUSPEND_NON_RET_LAST           (SBI_HSM_SUSP_NON_RET_BIT | \
> +                                                SBI_HSM_SUSP_BASE_MASK)
> +
>  enum sbi_ext_srst_fid {
>         SBI_EXT_SRST_RESET = 0,
>  };
> diff --git a/arch/riscv/kernel/cpu_ops_sbi.c b/arch/riscv/kernel/cpu_ops_sbi.c
> index dae29cbfe550..2e16f6732cdf 100644
> --- a/arch/riscv/kernel/cpu_ops_sbi.c
> +++ b/arch/riscv/kernel/cpu_ops_sbi.c
> @@ -111,7 +111,7 @@ static int sbi_cpu_is_stopped(unsigned int cpuid)
>
>         rc = sbi_hsm_hart_get_status(hartid);
>
> -       if (rc == SBI_HSM_HART_STATUS_STOPPED)
> +       if (rc == SBI_HSM_STATE_STOPPED)
>                 return 0;
>         return rc;
>  }
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> index 2e383687fa48..1ac4b2e8e4ec 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -60,9 +60,9 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>         if (!target_vcpu)
>                 return -EINVAL;
>         if (!target_vcpu->arch.power_off)
> -               return SBI_HSM_HART_STATUS_STARTED;
> +               return SBI_HSM_STATE_STARTED;
>         else
> -               return SBI_HSM_HART_STATUS_STOPPED;
> +               return SBI_HSM_STATE_STOPPED;
>  }
>
>  static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> --
> 2.25.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
