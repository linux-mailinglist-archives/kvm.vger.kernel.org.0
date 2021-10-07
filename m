Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E851F4258B8
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243041AbhJGRCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 13:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242937AbhJGRCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 13:02:01 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C49C061760
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 09:59:34 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id l13so6843732qtv.3
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yStGYIpZvygpVOizwmrRBKxJSbCuOoEwX5b/Zb25tt0=;
        b=mppNOVAEN+ki/T08o63WMJV4P8udEmtmkGOlQa6mcKWowODcCyB3XLnyzMlrqUi1Xt
         wI5mcrEfQgBS+oGPU0FZqxVZwv1pUgMA+7RUVAVU2d+8TzfnfzZQIZtxJh39WKdtcldj
         Knt//D+OuRT2vJoa9q9ajNmswldyLCfxFDP+dd+PID4/BFfOvM70p/DLM9Ue3wAs/k+b
         D8BcOwYQoTXdBHESPulEEW54QXng020cd88Q70TiLf4EESkmarwkLX4bds7s5k9kpbYd
         LOerYpEUJPxMKvXsHykqqKe/fw58OaS1iRAfvMpAHR4rwb/lfsX9NzgcnLw6uPeJCqkB
         crOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yStGYIpZvygpVOizwmrRBKxJSbCuOoEwX5b/Zb25tt0=;
        b=G/WBo4lMTJoDQMpQjopBrcVU3F0VUugRg/LwmDPHkk8SNFpqIWWhS4RR0C7zHf8NQi
         8sDMpD6AVCdSC5ckC4r3oGtWA7ab9UgQd75k5UtIDDXKFcxEUSNX8ewMEiES4SRRis7O
         WZ2+Ma/Oita47fL+OfvFwjKAQyvfaf7kIe8WV/JGbbrL7UIXdhsixOXfXjPjJpInYd/g
         5QsLOYG+xwNtdB/pD6o66bJW1InJsQnBvowqRP7sja9dDmGz0Fu9Lh7Sq5tqL+TqZd8C
         ZT6GoezMwPitQ0ykcDYhgAnt/PEQcwZr2e6oGEWngpkwfI7lK+jLxH4u7dITED4aKJQQ
         AauA==
X-Gm-Message-State: AOAM530Qtt5Hi/2+cLbaJGQYB13/z+UKINdKBc4R8lN7zI+r/BjMRNcm
        kT7olkSlGz+F9WsNwsDd+c+b82D8bSGjqFgRjucdfw==
X-Google-Smtp-Source: ABdhPJxTAXIl5n2x/wQHnws8o08Z9GMfP8GXDvCZvrxTPvhcRyUVX7c5KZ+qz0KRjOEopqc7sNJRocOee/a0NptbvdQ=
X-Received: by 2002:a05:622a:4d4:: with SMTP id q20mr6376969qtx.57.1633625973690;
 Thu, 07 Oct 2021 09:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211001170553.3062988-1-maz@kernel.org>
In-Reply-To: <20211001170553.3062988-1-maz@kernel.org>
From:   Andrew Scull <ascull@google.com>
Date:   Thu, 7 Oct 2021 17:59:22 +0100
Message-ID: <CADcWuH0S2-WVN073VkZ1tTf76xemKsbZyjNyC1hBjY+n09dZWQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Allow KVM to be disabled from the command line
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, David Brazdil <dbrazdil@google.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Andrew Scull <ascull@google.com>


On Fri, 1 Oct 2021 at 18:06, Marc Zyngier <maz@kernel.org> wrote:
>
> Although KVM can be compiled out of the kernel, it cannot be disabled
> at runtime. Allow this possibility by introducing a new mode that
> will prevent KVM from initialising.
>
> This is useful in the (limited) circumstances where you don't want
> KVM to be available (what is wrong with you?), or when you want
> to install another hypervisor instead (good luck with that).
>
> Reviewed-by: David Brazdil <dbrazdil@google.com>
> Acked-by: Will Deacon <will@kernel.org>
> Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>
> Notes:
>     v2: Dropped the id_aa64mmfr1_vh=0 setting so that KVM can be disabled
>         and yet stay in VHE mode on platforms that require it.
>         I kept the AB/RB's, but please shout if you disagree!
>
>  Documentation/admin-guide/kernel-parameters.txt |  2 ++
>  arch/arm64/include/asm/kvm_host.h               |  1 +
>  arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
>  3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 91ba391f9b32..f268731a3d4d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2365,6 +2365,8 @@
>         kvm-arm.mode=
>                         [KVM,ARM] Select one of KVM/arm64's modes of operation.
>
> +                       none: Forcefully disable KVM.
> +
>                         nvhe: Standard nVHE-based mode, without support for
>                               protected guests.
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..019490c67976 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -58,6 +58,7 @@
>  enum kvm_mode {
>         KVM_MODE_DEFAULT,
>         KVM_MODE_PROTECTED,
> +       KVM_MODE_NONE,
>  };
>  enum kvm_mode kvm_get_mode(void);
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..658171231af9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
>                 return -ENODEV;
>         }
>
> +       if (kvm_get_mode() == KVM_MODE_NONE) {
> +               kvm_info("KVM disabled from command line\n");
> +               return -ENODEV;
> +       }
> +
>         in_hyp_mode = is_kernel_in_hyp_mode();
>
>         if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>                 return 0;
>         }
>
> -       if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
> +       if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
> +               kvm_mode = KVM_MODE_DEFAULT;
>                 return 0;
> +       }
> +
> +       if (strcmp(arg, "none") == 0) {
> +               kvm_mode = KVM_MODE_NONE;
> +               return 0;
> +       }
>
>         return -EINVAL;
>  }
> --
> 2.30.2
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
