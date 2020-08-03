Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4CD23A5B9
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 14:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgHCMl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 08:41:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23192 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727892AbgHCMl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 08:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596458485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kuJzN9R6wZEsQ5ZHMFVRxApLOxyAZvL/LhRqQsAj2sY=;
        b=a40lsd7ovvcIR8QwKwZK3mlj6Xf3ekrlbDaHlMtf21vU0uRjVRMunQRInwLKFnKLDvxiQS
        p7/OcjcgDS/F855AwaFOH81q7pCUePtH4Pjt/uD6/kW3XFPKW4Q3FRAR5FkGepDnychLb4
        Jmnj2aLKEIQ8P+F/p8nfVdJxa1H/U7Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-WTKnrNs7N9WIO8LLr0F1RQ-1; Mon, 03 Aug 2020 08:41:21 -0400
X-MC-Unique: WTKnrNs7N9WIO8LLr0F1RQ-1
Received: by mail-ed1-f71.google.com with SMTP id cz26so556097edb.7
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 05:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kuJzN9R6wZEsQ5ZHMFVRxApLOxyAZvL/LhRqQsAj2sY=;
        b=eXXQAQVPb3R8VCOfVD538Et0O+YtARcoxjJBrqS7eVcsQGXfnr65aVZ1D2Ld0c4OD2
         TO0Hu7XWTzu2EvaM3klCQij6Bnm9XtenyOkMzWGFmci0YdC/YgMW4Vwr+JKVUo7VcN2J
         T3WnyH44Wh/JiQce1lKztOglI5ZMAT1KEB4FkYyQzGBCi+adVCPnimzZsnqYm7WJuOPX
         /6FmUgC7OHVS3My7A3/qoCd3pBVw40uAfhK2Z+v5rUKN2D1/8gPCGbhviCCUQMNO6Brk
         4IQZ94HiyZcKxIUpCQUSgKYKRinZJsQDWp7lPTjRn+qCns89ap9z0jC4lza6b+mzuDZp
         NDLA==
X-Gm-Message-State: AOAM530cBngCTr173BlZgwTZnZZmF3LxhnZdFymWWY1uvL0f2K3Bzmk1
        CqxptOta7/NVBHSxx65tevvHI+uSKXJEYU7RDaMuSA94lqyUBxnm8OMmsdXll6zMzCC9Cp1XPKx
        VBv3osDHWSjwZ
X-Received: by 2002:a05:6402:1e2:: with SMTP id i2mr15099340edy.70.1596458480440;
        Mon, 03 Aug 2020 05:41:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUW/x/ociYNjBHtYwNZYjZYKHhFAFg9409aA9+QRUWZiWeqBlJuitJChPyzx9wS3FGb9mh3A==
X-Received: by 2002:a05:6402:1e2:: with SMTP id i2mr15099321edy.70.1596458480197;
        Mon, 03 Aug 2020 05:41:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h24sm16057707ejk.12.2020.08.03.05.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 05:41:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [kvm-unit-tests PATCH] x86: tscdeadline timer testing when apic is hw disabled
In-Reply-To: <1596441715-14959-1-git-send-email-wanpengli@tencent.com>
References: <1596441715-14959-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 03 Aug 2020 14:41:18 +0200
Message-ID: <87wo2fq4up.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> This patch adds tscdeadline timer testing when apic is hw disabled.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  x86/apic.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/x86/apic.c b/x86/apic.c
> index a7681fe..bcf56e2 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -30,15 +30,18 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
>      eoi();
>  }
>  
> -static void __test_tsc_deadline_timer(void)
> +static void __test_tsc_deadline_timer(bool apic_enabled)
>  {
>      handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
>      irq_enable();
>  
>      wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
>      asm volatile ("nop");
> -    report(tdt_count == 1, "tsc deadline timer");
> -    report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
> +    if (apic_enabled) {
> +        report(tdt_count == 1, "tsc deadline timer");
> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
> +    } else
> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer is not set");

I'd suggest we also check that the timer didn't fire, e.g.

report(tdt_count == 0, "tsc deadline timer didn't fire");

as a bonus, we'd get another reason to use braces for both branches of
the 'if' (which is a good thing regardless).

>  }
>  
>  static int enable_tsc_deadline_timer(void)
> @@ -54,10 +57,10 @@ static int enable_tsc_deadline_timer(void)
>      }
>  }
>  
> -static void test_tsc_deadline_timer(void)
> +static void test_tsc_deadline_timer(bool apic_enabled)
>  {
>      if(enable_tsc_deadline_timer()) {
> -        __test_tsc_deadline_timer();
> +        __test_tsc_deadline_timer(apic_enabled);
>      } else {
>          report_skip("tsc deadline timer not detected");
>      }
> @@ -132,6 +135,17 @@ static void verify_disabled_apic_mmio(void)
>      write_cr8(cr8);
>  }
>  
> +static void verify_disabled_apic_tsc_deadline_timer(void)
> +{
> +    reset_apic();
> +    if (enable_tsc_deadline_timer()) {
> +        disable_apic();
> +        __test_tsc_deadline_timer(false);
> +    } else {
> +        report_skip("tsc deadline timer not detected");
> +    }
> +}
> +
>  static void test_apic_disable(void)
>  {
>      volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
> @@ -148,6 +162,7 @@ static void test_apic_disable(void)
>      report(!this_cpu_has(X86_FEATURE_APIC),
>             "CPUID.1H:EDX.APIC[bit 9] is clear");
>      verify_disabled_apic_mmio();
> +    verify_disabled_apic_tsc_deadline_timer();
>  
>      reset_apic();
>      report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
> @@ -668,7 +683,7 @@ int main(void)
>  
>      test_apic_timer_one_shot();
>      test_apic_change_mode();
> -    test_tsc_deadline_timer();
> +    test_tsc_deadline_timer(true);
>  
>      return report_summary();
>  }

-- 
Vitaly

