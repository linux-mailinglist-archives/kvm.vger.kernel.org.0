Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7183F0D6F
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhHRVe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhHRVey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:34:54 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0A0C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:34:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id n7so7756644ljq.0
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIJMBP+oNGnAAKwmFqWtXv81MB4wkUEraz55M0YB7rs=;
        b=foqb7b1M4tTMZr+19gT0KatyK3YWAxVGmDQTr25cXFLF0MNddFFoCuyzPU0hKkbF5a
         L529T14lULjeLlBYc/lRwonH7BG1vdlrvQ76+jec+Jmwslwl/bx33sJk1a80NEkgWDJS
         HM5nvMVR4Y0+7o7t6UkBRIJbb2oaEXr9QC0e9AJtm/n3qgnTfaeFWklKZ58KnlbhfU1S
         LdXrfUwhrrXFFMf9PAFN3C5/y92KRFtOqrgDf6Tx8HSnt7CRihSzYyrODXSIxppqerAv
         Yi/lSAFuOYtEDMuVLEtd4fGzXfFWKV4CywjxWbuMW62mfWceZEi4UwRF6WZoBAoGXnVr
         2qyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIJMBP+oNGnAAKwmFqWtXv81MB4wkUEraz55M0YB7rs=;
        b=W0+qgMz4Czd0cYuebh0EqbWtbgSIfT7IPPhwIyhdRvRr6NuwXFAuj0y0CjUwK3zMJU
         60VgqZo/tvpXS4wMIGr2W8hLeac+gpKr0DiKh6GG242BrHKpqbCcFmJFFv/oXKjhewPG
         upWLwBoTwFsVJ/fQjxmHrg2MwaB/hkEDzgiSjR4TgAQ2ZXGeNLYdJZOaZe2jlcWKXTvU
         Po8T2lxr3dcns5jNnldkaDWUHBWc/K7M9w4eB7FZqO6eQaP2yTUxrUBrfeU2YaDNg1Cg
         70REye2cpwTdguTkolCTVSYiDMUz2B64gqyUAzVSp/tZkg/nonDeodRh9Ho3ULjVX4HI
         ThLQ==
X-Gm-Message-State: AOAM532iOEq9irN2rs2GOroG7FBhLwJrxYqLelB1Ps5wGpts2D5VmO7q
        bgE2IzG8yr21OoZBeh3+a8R//Ecg1ktqMj8VFtuC+g==
X-Google-Smtp-Source: ABdhPJzdkFHv/DoVrFmnB5SXoPKGwHxKK4vShunyvprddeq1JJO2GNWpXj1AvWJsXXOV9c+ZzuVZMpwPaSIXCFPJT5Q=
X-Received: by 2002:a2e:a782:: with SMTP id c2mr9537367ljf.388.1629322454756;
 Wed, 18 Aug 2021 14:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210818213205.598471-1-ricarkol@google.com>
In-Reply-To: <20210818213205.598471-1-ricarkol@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 18 Aug 2021 14:34:03 -0700
Message-ID: <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com, drjones@redhat.com,
        catalin.marinas@arm.com, suzuki.poulose@arm.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> vgic_get_irq(intid) is used all over the vgic code in order to get a
> reference to a struct irq. It warns whenever intid is not a valid number
> (like when it's a reserved IRQ number). The issue is that this warning
> can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
>
> Drop the WARN call from vgic_get_irq.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 111bff47e471..81cec508d413 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>         if (intid >= VGIC_MIN_LPI)
>                 return vgic_get_lpi(kvm, intid);
>
> -       WARN(1, "Looking up struct vgic_irq for reserved INTID");

Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
or pr_warn_ratelimited()? I agree it is problematic that userspace can
cause this WARN to fire, but it'd be helpful for debugging too.

--
Thanks,
Oliver

>         return NULL;
>  }
>
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
