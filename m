Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567635FC8D8
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJLQFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiJLQFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:05:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38E3753B0
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:05:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pq16so15672488pjb.2
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=enbmISb3NwCM4DbXn/DwQoZKZgOZCD6E3xV48iVN1Og=;
        b=m5F8qFJGBxFIeg20XFGxqcny2ByrS6fRZu4TwNdU/NpqHnhuSG6rR9ckpqyFbY01FQ
         CiobMnO49rWL9nZLkwQQk4y6ioS/OE2jYK2OglqxF8wygXJyggELIPOkrP2CDHNUwE6q
         6VdjvG49eCUjhd619FXeMaAlhpIoi8QYm1XowWaMLI+VRTlVldTw5AszRl3goC0Wowvz
         3lhHMgkc9SQxNG8NzY3cJ+AD5ylhnbj5pcAzUuHm4vTGjWyVpTpSIZDqG5+/Z5aHVAT1
         aAllPsIlVeGgf00Ecn88g90CvfvMM+3pVjpIE/f1Q3DN2nwwUtNu6xCPc76XRF8QQzda
         gELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enbmISb3NwCM4DbXn/DwQoZKZgOZCD6E3xV48iVN1Og=;
        b=aFsKNPZxa2iEgnEsKTOurpFo36+Ne3u8mBbYbBOZeQELhufhGnC9VFOf9k2Ine4FcN
         NlSRpFX6dlVOpztaF4p7YxDfeJ6tgw63qyDg59+6kLJxrObTTjKT1WMxjf5yl9cx4zYz
         n7F4ksRpOM/iGxo9MII2RG8mcLNCMERFf1r3xLkFzSAXYETW/HnVR8JB5y/S/HKkZpPJ
         6IlnoflLT9qFna8n5ixqgghIWRz+CkO/YFJX6+erEBdwIoYoKnqvvUnAGau1aOwLNGCO
         cJT5dsY4fPF0nSaKJMwtiX+5CYJJdBiVXUwy1eAwQ+a7nchzwBcwrly0jUb2LuYLu23C
         WTcg==
X-Gm-Message-State: ACrzQf11iEV1ORbhnmBvqOFWKpDxRGeprVMZ9KOIqj1k0eflIs5d8NaE
        3xeyKlgZeI6jRSyl1lHNkNLJCQ==
X-Google-Smtp-Source: AMsMyM4ujjInYGZ6D4HVYOvu5Sm4p6UoXALhGvZayBjp+zBuZQMMRjM16zywX2YpV7NyU6hy3heewA==
X-Received: by 2002:a17:902:6bc8:b0:178:81db:c6d9 with SMTP id m8-20020a1709026bc800b0017881dbc6d9mr30903720plt.56.1665590750137;
        Wed, 12 Oct 2022 09:05:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ea8200b0016d5b7fb02esm10782257plb.60.2022.10.12.09.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 09:05:49 -0700 (PDT)
Date:   Wed, 12 Oct 2022 16:05:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH][RFC] KVM: x86: Don't reset deadline to period when timer
 is in one shot mode
Message-ID: <Y0bl2WjoG12WcCPv@google.com>
References: <1665579268-7336-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1665579268-7336-1-git-send-email-lirongqing@baidu.com>
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

+Jim, Peter, and Wanpeng

On Wed, Oct 12, 2022, Li RongQing wrote:
> In one-shot mode, the APIC timer stops counting when the timer
> reaches zero, so don't reset deadline to period for one shot mode
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/lapic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9dda989..bf39027 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1840,8 +1840,12 @@ static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
>  		if (unlikely(count_reg != APIC_TMICT)) {
>  			deadline = tmict_to_ns(apic,
>  				     kvm_lapic_get_reg(apic, count_reg));
> -			if (unlikely(deadline <= 0))
> -				deadline = apic->lapic_timer.period;
> +			if (unlikely(deadline <= 0)) {
> +				if (apic_lvtt_period(apic))
> +					deadline = apic->lapic_timer.period;
> +				else
> +					deadline = 0;
> +			}

This is not the standard "count has reached zero" path, it's the "vCPU is migrated
and the timer needs to be resumed on the destination" path.  Zeroing the deadline
here will not squash the timer, IIUC it will cause the timer to immediately fire.

That said, I think the patch is actually correct even though the shortlog+changelog
are wrong.  If the timer expired while the vCPU was migrated, KVM _should_ fire
the timer ASAP.  AFAICT, nothing else in KVM will detect the expired timer, e.g.
if the timer expired on the source, apic_get_tmcct() on the source should have
returned zero.

The only wrinkle I can see is the bug called out in the commit that added this
code (the wonderfully (extreme sarcasm) titled commit 24647e0a39b6, "KVM: x86:
Return updated timer current count register from KVM_GET_LAPIC")

 : Note: When a one-shot timer expires, the code in arch/x86/kvm/lapic.c does
 : not zero the value of the LAPIC initial count register (emulating HW
 : behavior). If no other timer is run and pending prior to a subsequent
 : KVM_GET_LAPIC call, the returned register set will include the expired
 : one-shot initial count. On a subsequent KVM_SET_LAPIC call the code will
 : see a non-zero initial count and start a new one-shot timer using the
 : expired timer's count. This is a prior existing bug and will be addressed
 : in a separate patch. Thanks to jmattson@google.com for this find.

I don't see any evidence that that bug was ever fixed.  But again, that's an
orthogonal bug.

There is commit 2735886c9ef1 ("KVM: LAPIC: Keep stored TMCCT register value 0
after KVM_SET_LAPIC"), but I'm struggling to see how that's anything but a glorified
nop.

>  			else if (unlikely(deadline > apic->lapic_timer.period)) {
>  				pr_info_ratelimited(
>  				    "kvm: vcpu %i: requested lapic timer restore with "
> -- 
> 2.9.4
> 
