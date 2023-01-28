Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D67067F8CE
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 15:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjA1OsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 09:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjA1OsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 09:48:15 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E46028852
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 06:48:14 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cw4so2017926edb.13
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 06:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1lxUpJSfxW1ZZV9lMQmOX9ndF9VezYLbwHaqKcuesvo=;
        b=RtURjaujbaSgYg8dv56Qf+hC1TetbqbHqyIIY6s7dI+APqUXmnRn7NgNPZa+7Ndl5+
         6v7jYHiN8g//VSipATTE3qw/OcyFjSGO0uo0G2XXJOFzZiI97HJhidBHoXSf6Dm3+3d2
         /avcyh3HCkoNWpWxZ6iH7a2OwRQZy2+Fpwf9FXkCvn13xuHzVJ7RMPQHyPFDW3aKPMEK
         wkZuZ3d+k+TLl/d1Kgx+WY5uOM4tbQbH7pgBE/K8rCNmdnhMosXeyzFk1ge/mDutdbVN
         TBgu8Cg90KGe+fOACR0ryUCUIx70yjq5+7aMvln9XLzbbvQTOGk5iHbl6IrZA+QDwFLB
         S76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1lxUpJSfxW1ZZV9lMQmOX9ndF9VezYLbwHaqKcuesvo=;
        b=yBELPvaz7DVhrfxfcTvhEhwLRlyyhbCKcxcVIxkv12w5GrJfK5W9p/s2bHMowpGczM
         ZrWZV/GtB6aZkJvwfh5PX0vWvXbQ1n6QwqNL+a8ZCscw/+SJQ6ASp+JQ8dwlffZ1UUf8
         L2WuqiNIxNuJ5a5Afyn8ufPTwBLYxS3nG4spHMQ+rdb6+AvaHT/I/Y4C1SyNlBnoSg1t
         u/XJ13j9kFYgI338RW0jL8ZWwW+kUSZA0Z+CH5YlGJA2O9gZL+1eI1gvmgL3BULndxXW
         jkp2iOXAApbcbsjMf3tskJaVcIwTvb/D3A4XIj8rIX02qq4WSzIoiWPWjy/8UdOMdVN8
         KsPg==
X-Gm-Message-State: AFqh2kr+s95kZYfKUJ501JJl1fiGjMXbNMzLFWCVSeV3pIMtUWUhzJkm
        0n2fsYK7rwa644uUCWr1TjOL2aaVL0rPy8TsKiS8nsNMjicPy/LS
X-Google-Smtp-Source: AMrXdXs9+iKP9MWJQn3NINp9DainLk/ZniHxMwWvgN5wV3i7BI6ahOb7PK5VZdkvWkxkVNQKOjTSQ/LsSWIwwxDUJwc=
X-Received: by 2002:a05:6402:4494:b0:49e:89e:c7b4 with SMTP id
 er20-20020a056402449400b0049e089ec7b4mr6940024edb.1.1674917291865; Sat, 28
 Jan 2023 06:48:11 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-3-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-3-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 28 Jan 2023 20:17:59 +0530
Message-ID: <CAAhSdy3pCcbscpYa82Daji4bXT0EdosmH3Xn7MjeJPk-zTA_Yg@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] perf: RISC-V: Improve privilege mode filtering
 for perf
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> Currently, the host driver doesn't have any method to identify if the
> requested perf event is from kvm or bare metal. As KVM runs in HS
> mode, there are no separate hypervisor privilege mode to distinguish
> between the attributes for guest/host.
>
> Improve the privilege mode filtering by using the event specific
> config1 field.
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c   | 27 ++++++++++++++++++++++-----
>  include/linux/perf/riscv_pmu.h |  2 ++
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 6b53adc..e862b13 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -301,6 +301,27 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
>  }
>  EXPORT_SYMBOL_GPL(riscv_pmu_get_hpm_info);
>
> +static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
> +{
> +       unsigned long cflags = 0;
> +       bool guest_events = false;
> +
> +       if (event->attr.config1 & RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS)
> +               guest_events = true;
> +       if (event->attr.exclude_kernel)
> +               cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VSINH : SBI_PMU_CFG_FLAG_SET_SINH;
> +       if (event->attr.exclude_user)
> +               cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VUINH : SBI_PMU_CFG_FLAG_SET_UINH;
> +       if (guest_events && event->attr.exclude_hv)
> +               cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
> +       if (event->attr.exclude_host)
> +               cflags |= SBI_PMU_CFG_FLAG_SET_UINH | SBI_PMU_CFG_FLAG_SET_SINH;
> +       if (event->attr.exclude_guest)
> +               cflags |= SBI_PMU_CFG_FLAG_SET_VSINH | SBI_PMU_CFG_FLAG_SET_VUINH;
> +
> +       return cflags;
> +}
> +
>  static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>  {
>         struct hw_perf_event *hwc = &event->hw;
> @@ -311,11 +332,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>         uint64_t cbase = 0;
>         unsigned long cflags = 0;
>
> -       if (event->attr.exclude_kernel)
> -               cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
> -       if (event->attr.exclude_user)
> -               cflags |= SBI_PMU_CFG_FLAG_SET_UINH;
> -
> +       cflags = pmu_sbi_get_filter_flags(event);
>         /* retrieve the available counter index */
>  #if defined(CONFIG_32BIT)
>         ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
> index a1c3f77..1c42146 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -26,6 +26,8 @@
>
>  #define RISCV_PMU_STOP_FLAG_RESET 1
>
> +#define RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS 0x1

For consistency other defines in this header:
s/RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS/RISCV_PMU_CONFIG1_GUEST_EVENTS/

> +
>  struct cpu_hw_events {
>         /* currently enabled events */
>         int                     n_events;
> --
> 2.25.1
>

Otherwise, it looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup
