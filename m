Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15006E4AAB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 14:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503976AbfJYMCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 08:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbfJYMCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 08:02:23 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1648D4E8AC
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 12:02:23 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id a81so1019207wma.4
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 05:02:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhnGjNYl34BBej/G9IX/zdJYT44shCWthBnaow9hDa0=;
        b=oLWKwRW1Mbzt4UcIp8Oq5lNDag9MlKvXWweTY3QGOu0L8sC39i1Lo92PCdRiZSJOUV
         lc0xX1GnsT4FFNNeTOJwfjOdK7O5xp5W8vxtWw7c+zYzHP38CzxsZ49oHZFdVOuQAa1f
         Ns8sNCi1glSTv+vuthZKUMOpV+ftoXmdiMczBzd1FKiSJlhPxsv8b8VVCwxH0NitefL2
         c1ghQMeWdeNsVTTD+QIrfeIQYXpDL4ALf9HfkqM6ZNDFhJrXq3rVI2reQEruNIVFjuAk
         AHEyaI0UbVxphKwruJ6kmQ3MllUlXV9gNWmeRHcbkvtGYrnPal162L1nSQBZsYFepWcR
         2a8Q==
X-Gm-Message-State: APjAAAX5EXCe5bhw2v6ev1BD7GVHKi/rlDJOD8/IBn8IkryrwL40V3Ni
        rWk18Kj9nIENPKuF68MWYTRxCpTonvsMrAetB7kaOXR4TH8pUNjjK7uKu7GBSuuhd47oIA9Npa1
        2YiiL6cyUmKoE
X-Received: by 2002:a1c:9847:: with SMTP id a68mr3155401wme.18.1572004941656;
        Fri, 25 Oct 2019 05:02:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxwsMVOR60a0YiZNHpidmA8uSmWVIC5eakJiKfRUewwkkwxWAf6JFvuj/ZwuF4qfke5tp78TQ==
X-Received: by 2002:a1c:9847:: with SMTP id a68mr3155367wme.18.1572004941369;
        Fri, 25 Oct 2019 05:02:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c7b:17ec:2a40:d29? ([2001:b07:6468:f312:9c7b:17ec:2a40:d29])
        by smtp.gmail.com with ESMTPSA id 79sm2637628wmb.7.2019.10.25.05.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 05:02:20 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: Fix -Wmissing-prototypes warnings
To:     wang.yi59@zte.com.cn, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <201910250958273740534@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <07bbeb02-e8fe-36d5-a761-402a48fe076f@redhat.com>
Date:   Fri, 25 Oct 2019 14:02:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201910250958273740534@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  It may not appear on git.kernel.org until after KVM
Forum though.

Paolo

On 25/10/19 03:58, wang.yi59@zte.com.cn wrote:
> Gentle Ping :)
> 
>> We get two warning when build kernel with W=1:
>> arch/x86/kernel/kvm.c:872:6: warning: no previous prototype for ‘arch_haltpoll_enable’ [-Wmissing-prototypes]
>> arch/x86/kernel/kvm.c:885:6: warning: no previous prototype for ‘arch_haltpoll_disable’ [-Wmissing-prototypes]
>>
>> Including the missing head file can fix this.
>>
>> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
>> ---
>>  arch/x86/kernel/kvm.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index e820568..32ef1ee 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -33,6 +33,7 @@
>>  #include <asm/apicdef.h>
>>  #include <asm/hypervisor.h>
>>  #include <asm/tlb.h>
>> +#include <asm/cpuidle_haltpoll.h>
>>
>>  static int kvmapf = 1;
> 
> 
> ---
> Best wishes
> Yi Wang
> 

