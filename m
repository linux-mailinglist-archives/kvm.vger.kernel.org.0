Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905EB647B48
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLIBWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 20:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLIBWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 20:22:12 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847BDAC6EF
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 17:22:10 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d7so3288652pll.9
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 17:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Bbsd2uHdvBvlG4eS2408Nj8qBKdDpkwt6U9dXP20Lw=;
        b=iImLLO18J+yC+3ZRaMcn68SJDq0f2hJA0xGrsSkvmOhsr4XWH5SRng1nllCYriKG5V
         l+JMnRTvmrOo7RVSmSq1HxrgeN2CZI3m3F0wtrfV86mTyKLhEHSQboXVZRV/HV/qwnxu
         3dBRFM3QEuopQJKEXTVdJl1bjVZLPaFiOz/Kis8z0rAS7gBIfkeX2vQ7IoN7RThvxzZi
         35j8g5Wd1oXzfxJCdwIUiQuN2+nBBV7oMLjiOi0BU3NJHLVreZTfrMHhErbLmGU3df6M
         hcpZ8b+I0hOcVL8tiEFhQNS7oRk0LnoyoN1JQijTAOpoMysKkfSKMmVO/fSxB6QIG2ft
         5ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Bbsd2uHdvBvlG4eS2408Nj8qBKdDpkwt6U9dXP20Lw=;
        b=h1Q9XmLuZDPs2nIIVbFptucgXfqgEhfqVSrrB5E8m4Pe2Kte6Vx/Syc6c04ep8261E
         Qxa1F1kqScCWSt1Cg4T8A+yGzWBwpM6X0uxElBvjI8Ei3Q4pwLJz/+AvR/gpsOFlBYjQ
         EYoyWvlV3PMpzs2LQQCotE2WC1qsBQFfULSOTBsAdnRXfuvM+5hJ1qRdsWKgp6ytC7py
         Pyq4CZBfcax9OEYLz3TASvzQGw6RkBhJVcSKNVZN2PUS37c+gyvio5KvF+/eEFnSGw07
         yEr5H6qixAPn8QZaWx9VdofKDFn9K/Joy1sT8qhNEdLY74A5jYzSvuPiM/CO935rWTKc
         w/ow==
X-Gm-Message-State: ANoB5pmZ9lwvdgq6erOs28Ga3Z+v8zRtkWrWNUqIqjCUcx0FyqZfYI+j
        PpKxQowJb6DCT9AEvl7EhpVqlw==
X-Google-Smtp-Source: AA0mqf788C5pqGhBeYbDPVJUntfULeFO3Ua/Vkwj4PpE9W9fzxWBBuL4UmcytM8HmijaOzAMZNA/2g==
X-Received: by 2002:a17:90a:af89:b0:218:7bf2:4ff2 with SMTP id w9-20020a17090aaf8900b002187bf24ff2mr1892669pjq.0.1670548929898;
        Thu, 08 Dec 2022 17:22:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i4-20020a170902e48400b001891b01addfsm49745ple.274.2022.12.08.17.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 17:22:09 -0800 (PST)
Date:   Fri, 9 Dec 2022 01:22:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: use unified srcu interface function
Message-ID: <Y5KNvgzakT1Vvxy4@google.com>
References: <CAPm50aJTh7optC=gBXfj+1HKVu+9U0165mYH0sjj3Jqgf8Aivg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50aJTh7optC=gBXfj+1HKVu+9U0165mYH0sjj3Jqgf8Aivg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> kvm->irq_routing is protected by kvm->irq_srcu.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  virt/kvm/irqchip.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..90f54f04e37c 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -216,7 +216,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
>         }
> 
>         mutex_lock(&kvm->irq_lock);
> -       old = rcu_dereference_protected(kvm->irq_routing, 1);
> +       old = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
> +                                       lockdep_is_held(&kvm->irq_lock));

Readers of irq_routing are protected via kvm->irq_srcu, but this writer is never
called with kvm->irq_srcu held.  I do like the of replacing '1' with
lockdep_is_held(&kvm->irq_lock) to document the protection, so what about just
doing that?  I.e.

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..77a18b4dc103 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -216,7 +216,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
        }
 
        mutex_lock(&kvm->irq_lock);
-       old = rcu_dereference_protected(kvm->irq_routing, 1);
+       old = rcu_dereference_protected(kvm->irq_routing,
+                                       lockdep_is_held(&kvm->irq_lock));
        rcu_assign_pointer(kvm->irq_routing, new);
        kvm_irq_routing_update(kvm);
        kvm_arch_irq_routing_update(kvm);


>         rcu_assign_pointer(kvm->irq_routing, new);
>         kvm_irq_routing_update(kvm);
>         kvm_arch_irq_routing_update(kvm);
> --
> 2.27.0
