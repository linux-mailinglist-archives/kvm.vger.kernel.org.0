Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6FE2EB6FC
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 01:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbhAFAnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 19:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbhAFAnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 19:43:23 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C88C061793;
        Tue,  5 Jan 2021 16:42:42 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id d8so1551502otq.6;
        Tue, 05 Jan 2021 16:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJIW+TkPHzwAadsvHwzFBYVv7eO9qsc4zllpELWrOHY=;
        b=vYgYsI83SZA8A5U0getZRGvfhjMCAL5Ne8nN37EtfYwvQppWY/NfjnZ4mGukHW93BH
         RCzpxpmlS1KT+8L0xC9/2/oRZTCg0mReYfVd/YcraTS1pH8pUfKbA91BcW6CoehdHY6X
         gmItY2fXMuXfrt2CFgAU79pFRn3xpnMvtz1ya/KbFC9sS5vsQSc07ACc+7efcxzDVp5I
         NsHyaKrEM2a4NSzqiNNF0lGBGfxWqfl/L4v091ViSEFrAP2Bqwcuu/mSDibQ/IzTAHRb
         74boqnDUhGfg27UkJBkjUOyRsniYh1L53cn+e3J5LqvHJJt6NXAHSiCVA+NM55jkWe0L
         CtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJIW+TkPHzwAadsvHwzFBYVv7eO9qsc4zllpELWrOHY=;
        b=hqL3rSrrPjG+bsZkJ4ByfQx1OLUbi3+M1iCw9ukes8UUKl4af3HqtV++p4J8sAu47q
         OgKnnmphUpOimA/DjWRbnITUKIyZOm1Nk3HlPSqJR0LZwGRQcktkTB8w0UFjitzEuhWc
         y62RUpxF8UPERoWNRM6yAaF4AxD2yXBDSPktSVBazdjnXuDWfYv4g3Uu1tAEU4Nd+GSU
         J2Umzb2WVSN7qhfMvomTPPrncATGHM+b4+iszTuRmWFc/p98IVY+FjiVCrH1b8rcM/fz
         0qmyJtaaD/mCdWah71o+HHapfQx/K1Vy0Q8JxKM5gHGglQFs0xR0VvG7viuBcNr4f7MN
         S9gg==
X-Gm-Message-State: AOAM530aORZnwUSP+yOJ4UI3ue/JqEo7+aC+pSLZUNnU+tCWrjz/K3u7
        VK+86Bc2wu2FKEvf9EmOu/ihyzLVPsjm1U5PyTR0o1Fn
X-Google-Smtp-Source: ABdhPJw7uTz6EV6kWmBFWPuO1J4Mue7BQ1TFNTgr7/WHNUxB12RqCFbcDGM8pUG8APcybpqefZ2MWaiaZYPq2LbecAg=
X-Received: by 2002:a05:6830:4f:: with SMTP id d15mr1541713otp.185.1609893762440;
 Tue, 05 Jan 2021 16:42:42 -0800 (PST)
MIME-Version: 1.0
References: <20210105192844.296277-1-nitesh@redhat.com>
In-Reply-To: <20210105192844.296277-1-nitesh@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 6 Jan 2021 08:42:31 +0800
Message-ID: <CANRm+CwW0NfqD3e+xEZtKrpV+igwZoCp_Tz_5sztj2-8WXGu0A@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest context"
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        seanjc@google.com, w90p710@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 at 06:30, Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.
>
> After the introduction of the patch:
>
>         87fa7f3e9: x86/kvm: Move context tracking where it belongs
>
> since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
> enabling of irqs to process pending interrupts should not be required
> within vcpu_enter_guest anymore.
>
> Conflicts:
>         arch/x86/kvm/svm.c
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  9 +++++++++
>  arch/x86/kvm/x86.c     | 11 -----------
>  2 files changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..c9b2fbb32484 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4187,6 +4187,15 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>
>  static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
> +       kvm_before_interrupt(vcpu);
> +       local_irq_enable();
> +       /*
> +        * We must have an instruction with interrupts enabled, so
> +        * the timer interrupt isn't delayed by the interrupt shadow.
> +        */
> +       asm("nop");
> +       local_irq_disable();
> +       kvm_after_interrupt(vcpu);
>  }

Why do we need to reintroduce this part?

    Wanpeng
