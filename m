Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CC023B6F6
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 10:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgHDImj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 04:42:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726233AbgHDImi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 04:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596530557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQN2omUmbLugG62IVKIBTw16+eueSOPnGyTIHs/+g+w=;
        b=Z9sgA1nnTZiF0ijATh2p/d5Urh9gZ1QRlXCCS0wrX2/rmMgmwXcwj3M7honcQdInP5VoUc
        VtBUW32FEX2IxhlbtQDhmL3QMI++RqOnnxpdrtJF+kjDgK0mWacFRGd4UKZ+EAAM4LIIWi
        8UMmT5HuuJyzVBrgrU0CQhHGvHf5VlU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-kpPt_QETORmakgbmOrUpcw-1; Tue, 04 Aug 2020 04:42:35 -0400
X-MC-Unique: kpPt_QETORmakgbmOrUpcw-1
Received: by mail-ej1-f72.google.com with SMTP id z14so13705713eje.19
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 01:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SQN2omUmbLugG62IVKIBTw16+eueSOPnGyTIHs/+g+w=;
        b=XnSLJ3c3NVA/HbX5ZZKxIji67GJ770sD23usCTOMcV1d1UO9MvAxNpvSe8dsNBHoz+
         4VLl7VrfhqhIdXbcRhlgt9mjanKCUJCQN0MF876ocpej/CK0ibONAoRRHiYceO5+MIMx
         pLHIvyzAIv1I0klmxc1gyt4sqH/FIW6CcuyF5MiTsKJnNeDSrLNlmn2DreGXI/nV35Un
         c5ho/xYegVF25k0ySEOmMcqpOYdVe7gXIQV5FtUP6eAVBHEuMGv1rt7BV0AcyJpIkPVS
         1PD/KEOc2vc7tG2r3P6regY9uCTfUFIxKWVpFZDgPwTiSrDOW/MSAwp0zFB7hhPycNH8
         FPIw==
X-Gm-Message-State: AOAM531zs/YV4Jb5acvpz5smjANinPjZ8IMNltMANaI39Qfmr1bEyaVq
        bVbJebykNk0ZzrDR3k/jdcYxFk3Pq3IMB02WXDKk0KLCGfNi4mfAeaZ1CzbdwvK5ZN8Qt4XCo5V
        txarynphVRARn
X-Received: by 2002:a17:906:990c:: with SMTP id zl12mr19734618ejb.488.1596530554028;
        Tue, 04 Aug 2020 01:42:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQcHZCeBLaEBENnHGgMO4NWr2NRl0v5OaYAGkfPzEm1BO+7QDmTV00mLBkqYZLTbNRm+yz6Q==
X-Received: by 2002:a17:906:990c:: with SMTP id zl12mr19734607ejb.488.1596530553849;
        Tue, 04 Aug 2020 01:42:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id by3sm18093398ejb.9.2020.08.04.01.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 01:42:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [kvm-unit-tests PATCH RESEND v2] x86: tscdeadline timer testing when apic disabled
In-Reply-To: <1596501559-22385-1-git-send-email-wanpengli@tencent.com>
References: <1596501559-22385-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 04 Aug 2020 10:42:32 +0200
Message-ID: <87o8nqpzt3.fsf@vitty.brq.redhat.com>
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
> v1 -> v2:
>  * check tscdeadline timer didn't fire
>
>  x86/apic.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/x86/apic.c b/x86/apic.c
> index a7681fe..123ba26 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -30,15 +30,20 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
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
> +    } else {
> +        report(tdt_count == 0, "tsc deadline timer didn't fire");
> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer is not set");
> +    }
>  }
>  
>  static int enable_tsc_deadline_timer(void)
> @@ -54,10 +59,10 @@ static int enable_tsc_deadline_timer(void)
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
> @@ -132,6 +137,17 @@ static void verify_disabled_apic_mmio(void)
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
> @@ -148,6 +164,7 @@ static void test_apic_disable(void)
>      report(!this_cpu_has(X86_FEATURE_APIC),
>             "CPUID.1H:EDX.APIC[bit 9] is clear");
>      verify_disabled_apic_mmio();
> +    verify_disabled_apic_tsc_deadline_timer();
>  
>      reset_apic();
>      report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
> @@ -668,7 +685,7 @@ int main(void)
>  
>      test_apic_timer_one_shot();
>      test_apic_change_mode();
> -    test_tsc_deadline_timer();
> +    test_tsc_deadline_timer(true);
>  
>      return report_summary();
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

