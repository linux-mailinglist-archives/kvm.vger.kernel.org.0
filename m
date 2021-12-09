Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2946F257
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhLIRp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 12:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbhLIRpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 12:45:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14A4C061746;
        Thu,  9 Dec 2021 09:41:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y13so21624238edd.13;
        Thu, 09 Dec 2021 09:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Ha1arazSwC976tURMSNLlrwWYigXu8viEfvQRgLEuA=;
        b=aWWzGCIcUjq74l9UMqSnNm2LbG8v+B3Mkpsmm7IIXSE1o0TGkaBcHb3yS3A3ojyAh9
         w/6zCUNsK+wJ6wUabSY0xBMabuhio6S3ZlqIcDge4CyvZ3MaDLLFblo8uiKwQKJo//A/
         eIFkM72eq07aXRn+kuOEZn32Srud9mH2YJzjyJiT7bpyT3HA8hELJCYi9MgFyvGV+ySN
         dt64jLOc5G068KsomXJDsjoR5khGjmAgJ7PYtSY2Q2gAnrU506YLCiGN5RM90SfkXNPj
         MFG8LbeBCxxlxwUvx4qxPb2zenf/3oHQ1wb8vUl2lopWScoj4EqHmqkiu1GSN9zu/I1O
         aIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Ha1arazSwC976tURMSNLlrwWYigXu8viEfvQRgLEuA=;
        b=Ugm3o9fPFEQ0pOo12myvQvNTdVkpa20S8fsFP1CW2l89FErh8QetQhO4MSSwo6PCZx
         AxEjeVMubFKe2p5x77284ScoYLNQyJr/VEh5c6HqmOEz3vvrq3f0b4O6zb3XFoDH8zYq
         P635kZsBHLvMRVDk678rlXYp+h1Ql4Vda4VWZ10rslswpWTftsA3fLAN5ZXO36vZBSsh
         0hlwOxHwCzWoUOrhaGN2DAhPV1r48Mdu1ve8yM1hjswi9dkFlG0h6LYLpjHW+02CHYBD
         JxzSfImCeExLDzr4XgNj4BK1bJO//B/qw+6Dp1zw1HYywbPG5RP+oyxskP8iVmWuVlx5
         GRFQ==
X-Gm-Message-State: AOAM5301hxS+n8FIrleuUdGFWV0cFc0NfiKTcWDdbbRu1PCb9A3hexIG
        +1VXJpCa/A6Ie2d9hkJq7pY=
X-Google-Smtp-Source: ABdhPJzCL6PUYuCP0GRE2dc1g2cqm+RtZVndoItyY8lDOtkx9cTeOE501KZRx6KEhhTgGKgnNN3FsA==
X-Received: by 2002:a05:6402:289e:: with SMTP id eg30mr30904687edb.253.1639071556590;
        Thu, 09 Dec 2021 09:39:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r3sm251195ejr.79.2021.12.09.09.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:39:16 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7a4c9a55-91d8-84d7-89d2-e4f423fb248b@redhat.com>
Date:   Thu, 9 Dec 2021 18:39:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/11] x86/kvm: Silence per-cpu pr_info noise about KVM
 clocks and steal time
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-12-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209150938.3518-12-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 16:09, David Woodhouse wrote:
> From: David Woodhouse<dwmw@amazon.co.uk>
> 
> I made the actual CPU bringup go nice and fast... and then Linux spends
> half a minute printing stupid nonsense about clocks and steal time for
> each of 256 vCPUs. Don't do that. Nobody cares.

Queued this one, it makes sense even without the rest of the series.

Paolo

> Signed-off-by: David Woodhouse<dwmw@amazon.co.uk>
> ---
>   arch/x86/kernel/kvm.c      | 6 +++---
>   arch/x86/kernel/kvmclock.c | 2 +-
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbdad7729..a438217cbfac 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -313,7 +313,7 @@ static void kvm_register_steal_time(void)
>   		return;
>   
>   	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
> -	pr_info("stealtime: cpu %d, msr %llx\n", cpu,
> +	pr_debug("stealtime: cpu %d, msr %llx\n", cpu,
>   		(unsigned long long) slow_virt_to_phys(st));
>   }
>   
> @@ -350,7 +350,7 @@ static void kvm_guest_cpu_init(void)
>   
>   		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>   		__this_cpu_write(apf_reason.enabled, 1);
> -		pr_info("setup async PF for cpu %d\n", smp_processor_id());
> +		pr_debug("setup async PF for cpu %d\n", smp_processor_id());
>   	}
>   
>   	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> @@ -376,7 +376,7 @@ static void kvm_pv_disable_apf(void)
>   	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
>   	__this_cpu_write(apf_reason.enabled, 0);
>   
> -	pr_info("disable async PF for cpu %d\n", smp_processor_id());
> +	pr_debug("disable async PF for cpu %d\n", smp_processor_id());
>   }
>   
>   static void kvm_disable_steal_time(void)
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 462dd8e9b03d..a35cbf9107af 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -174,7 +174,7 @@ static void kvm_register_clock(char *txt)
>   
>   	pa = slow_virt_to_phys(&src->pvti) | 0x01ULL;
>   	wrmsrl(msr_kvm_system_time, pa);
> -	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
> +	pr_debug("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
>   }
>   
>   static void kvm_save_sched_clock_state(void)
> -- 2.31.1
> 

