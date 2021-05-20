Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C076338B48F
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhETQst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 12:48:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232565AbhETQsr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 12:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621529245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YCtWwsQ9i5O4Xeu+A+59S2cyBi8nbEN/55Tl4bQDQVk=;
        b=T0hjDHehvehisbz/DynT3ViLvTd1xquMpf9ZGcYHT7P+PemtCB6Rozyqpoz5ZejsAhd/yS
        m1UxqsiIe80isYSyALcDl5VDH6/3IE/D8Mk4ZkEGlScgdaacgtnLBDelhHkA230oAsSDjm
        SP72Nt/ntVFhEC40hXv5LTHP85DQhZw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-67CrXwu0N4iz-94ypaysdw-1; Thu, 20 May 2021 12:47:24 -0400
X-MC-Unique: 67CrXwu0N4iz-94ypaysdw-1
Received: by mail-wr1-f72.google.com with SMTP id f19-20020adfb6130000b02901121afc9a31so2123107wre.10
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 09:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YCtWwsQ9i5O4Xeu+A+59S2cyBi8nbEN/55Tl4bQDQVk=;
        b=EdQLCMMFh1D1/bW8btiXxIQYXAHBqtUJzIPuv2aNqCfHcg7E4RYNqwkdAI96Br2har
         0hmxkJ1Sg/vaH3eeK9xopOxIt4TnrPm6ZQDL/CMMpbLlk+9vLmpDzU71WSRjPXol6OP/
         3NCfsB/MgIOoXcSYGM7uWBEGGg9tdUJ4VHZw127okO1RkSEtMX2kd+kXA9nzmbzIj7gx
         JV/i5V3wzU9Jy/oW0+g7IIpHpL1GWC4v7M1xs0P8Z7u5GGhlSvl3JdIbShssmLy3DFqo
         4mO9fuP67tUzPu+YKPrvs1/EaTMyaqmB4go1Co9MfBHTANekZi9SeP4dPRVDxzdqYLEK
         qR7w==
X-Gm-Message-State: AOAM530c5ZbnnJ/8YxaOl3uejv/FlCh9RzLEDgeszmSXLdmxOH4taxhQ
        6QEtcxgPg7MwXfZsXJE/E+JaYbUgcpzN6bD1r/AbEbyzKRowUJIQHQi35YwUAAQtWWpENrAwDvl
        BLET2oW77fd+T
X-Received: by 2002:a5d:648e:: with SMTP id o14mr5098882wri.27.1621529242563;
        Thu, 20 May 2021 09:47:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznkmjfT9NsXfTap8r15oc4f1lXnxEkukMC3LKwqhSw0P7mafL1T2zUAoiXfkNcPhKPnGfrAw==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr5098869wri.27.1621529242342;
        Thu, 20 May 2021 09:47:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y14sm9415696wmj.37.2021.05.20.09.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 09:47:21 -0700 (PDT)
Subject: Re: [PATCH stable v5.4+ 1/3] x86/kvm: Teardown PV features on boot
 CPU as well
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>
References: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2aff367f-74b5-ba03-229e-6d7b5b79815e@redhat.com>
Date:   Thu, 20 May 2021 18:47:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/21 14:56, Krzysztof Kozlowski wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 8b79feffeca28c5459458fe78676b081e87c93a4 upstream.
> 
> Various PV features (Async PF, PV EOI, steal time) work through memory
> shared with hypervisor and when we restore from hibernation we must
> properly teardown all these features to make sure hypervisor doesn't
> write to stale locations after we jump to the previously hibernated kernel
> (which can try to place anything there). For secondary CPUs the job is
> already done by kvm_cpu_down_prepare(), register syscore ops to do
> the same for boot CPU.
> 
> Krzysztof:
> This fixes memory corruption visible after second resume from
> hibernation:

Hi, you should include a cover letter detailing the differences between 
the original patches and the backport.

(I'll review it anyway, but it would have helped).

Paolo

>    BUG: Bad page state in process dbus-daemon  pfn:18b01
>    page:ffffea000062c040 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 compound_mapcount: -30591
>    flags: 0xfffffc0078141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
>    raw: 000fffffc0078141 dead0000000002d0 dead000000000100 0000000000000000
>    raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
>    page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag set
>    bad because of flags: 0x78141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210414123544.1060604-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> [krzysztof: Extend the commit message]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
> 
> Backport to v5.4 seems reasonable. Might have sense to earlier versions,
> but this was not tested/investigated.
> 
>   arch/x86/kernel/kvm.c | 32 ++++++++++++++++++++++++++++----
>   1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index e820568ed4d5..6b906a651fb1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -24,6 +24,7 @@
>   #include <linux/debugfs.h>
>   #include <linux/nmi.h>
>   #include <linux/swait.h>
> +#include <linux/syscore_ops.h>
>   #include <asm/timer.h>
>   #include <asm/cpu.h>
>   #include <asm/traps.h>
> @@ -558,17 +559,21 @@ static void kvm_guest_cpu_offline(void)
>   
>   static int kvm_cpu_online(unsigned int cpu)
>   {
> -	local_irq_disable();
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>   	kvm_guest_cpu_init();
> -	local_irq_enable();
> +	local_irq_restore(flags);
>   	return 0;
>   }
>   
>   static int kvm_cpu_down_prepare(unsigned int cpu)
>   {
> -	local_irq_disable();
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>   	kvm_guest_cpu_offline();
> -	local_irq_enable();
> +	local_irq_restore(flags);
>   	return 0;
>   }
>   #endif
> @@ -606,6 +611,23 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>   	native_flush_tlb_others(flushmask, info);
>   }
>   
> +static int kvm_suspend(void)
> +{
> +	kvm_guest_cpu_offline();
> +
> +	return 0;
> +}
> +
> +static void kvm_resume(void)
> +{
> +	kvm_cpu_online(raw_smp_processor_id());
> +}
> +
> +static struct syscore_ops kvm_syscore_ops = {
> +	.suspend	= kvm_suspend,
> +	.resume		= kvm_resume,
> +};
> +
>   static void __init kvm_guest_init(void)
>   {
>   	int i;
> @@ -649,6 +671,8 @@ static void __init kvm_guest_init(void)
>   	kvm_guest_cpu_init();
>   #endif
>   
> +	register_syscore_ops(&kvm_syscore_ops);
> +
>   	/*
>   	 * Hard lockup detection is enabled by default. Disable it, as guests
>   	 * can get false positives too easily, for example if the host is
> 

