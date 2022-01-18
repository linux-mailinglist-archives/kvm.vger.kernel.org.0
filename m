Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBED492B26
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiARQY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:24:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235878AbiARQY0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 11:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642523066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQ5m3lwuUpyPPTQyJUbOKHf/MlOy5Q/PxKD+Pyw7w5Y=;
        b=F8f21GD+QrP+QbmIbC5gDzdRFZfU3/a35wXSwtJOcNOUbFccy00epHhr9ztVxU0qx3i7YW
        QwWaCQnM4BoGUQRCumVPENbOURNQ4HESA7DOmdE/S4QB80Mb74eMROa7eR5vRNeLtXliS9
        kiHs5AsQGuma5fXjLBhtnjrk9tAIZlU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-91IQbX0ZOcaBbacWV8DJFA-1; Tue, 18 Jan 2022 11:24:24 -0500
X-MC-Unique: 91IQbX0ZOcaBbacWV8DJFA-1
Received: by mail-ed1-f72.google.com with SMTP id ej6-20020a056402368600b00402b6f12c3fso6070783edb.8
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TQ5m3lwuUpyPPTQyJUbOKHf/MlOy5Q/PxKD+Pyw7w5Y=;
        b=CxzuJjnfA/WVpNWpquPJoyrmmGjr3va5QGM1JlpyYVJdsFyhE/dt4aiUy5vnWBfK4e
         obx7DXgq7ts9TtOppu20unn7vxKQrjrG0p/Ii/mG5aH6pyHJ56kTwRin9Nm+ZAxGgSkp
         NNQfecCWkcWM0BlXwForWPnx8FOR6/sZPXSJ9aRJnLuL6teSzpU1QoAHkOhM/Yti+ep7
         +TtXVJDbi22opTVeK94X0hQtIT4a5b+BfWK8gZmaO2ZCCeicdZ8byYRjHIgrbu/LDn+B
         9M/CJ5hzUPay80h+JKQLV9GgVU2gAyRYaCpWmLDTMirJjmr1VTXvOx64eJxP3cueiOfb
         ItBw==
X-Gm-Message-State: AOAM5301cJJSZjLyyXBweljYgAxe5+jbaN03MMDvOchCSoBzSJH37YoK
        qHgXa3yIR0Pm5sYtDbeStNzgcRxQB5FRnYdwsom6w/2++17EVo0HPjI5VmBvaC9K89Z62zQyJEH
        j1OKTQMv7bg4S
X-Received: by 2002:a05:6402:354e:: with SMTP id f14mr9070734edd.186.1642523063610;
        Tue, 18 Jan 2022 08:24:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+QCkstf0l8JoA4uHIp3lSrrTkF/QwnqjPgVECOGeqihj33PQSevNwQopU7kCgGrflDuyA1A==
X-Received: by 2002:a05:6402:354e:: with SMTP id f14mr9070718edd.186.1642523063446;
        Tue, 18 Jan 2022 08:24:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z19sm82557edd.78.2022.01.18.08.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 08:24:22 -0800 (PST)
Message-ID: <e015778b-444c-d885-daec-11bfac394bb2@redhat.com>
Date:   Tue, 18 Jan 2022 17:24:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: VMX: switch wakeup_vcpus_on_cpu_lock to raw spinlock
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20220107175114.GA261406@fuller.cnet>
 <Yd1rw+XiUYFH1+OZ@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yd1rw+XiUYFH1+OZ@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/22 12:36, Sebastian Andrzej Siewior wrote:
> On 2022-01-07 14:51:14 [-0300], Marcelo Tosatti wrote:
>>
>> wakeup_vcpus_on_cpu_lock is taken from hard interrupt context
>> (pi_wakeup_handler), therefore it cannot sleep.
>>
>> Switch it to a raw spinlock.
>>
>> Fixes:
>>
>> [41297.066254] BUG: scheduling while atomic: CPU 0/KVM/635218/0x00010001
>> [41297.066323] Preemption disabled at:
>> [41297.066324] [<ffffffff902ee47f>] irq_enter_rcu+0xf/0x60
>> [41297.066339] Call Trace:
>> [41297.066342]  <IRQ>
>> [41297.066346]  dump_stack_lvl+0x34/0x44
>> [41297.066353]  ? irq_enter_rcu+0xf/0x60
>> [41297.066356]  __schedule_bug.cold+0x7d/0x8b
>> [41297.066361]  __schedule+0x439/0x5b0
>> [41297.066365]  ? task_blocks_on_rt_mutex.constprop.0.isra.0+0x1b0/0x440
>> [41297.066369]  schedule_rtlock+0x1e/0x40
>> [41297.066371]  rtlock_slowlock_locked+0xf1/0x260
>> [41297.066374]  rt_spin_lock+0x3b/0x60
>> [41297.066378]  pi_wakeup_handler+0x31/0x90 [kvm_intel]
>> [41297.066388]  sysvec_kvm_posted_intr_wakeup_ipi+0x9d/0xd0
>> [41297.066392]  </IRQ>
>> [41297.066392]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x12/0x20
>> ...
>>
>> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> so I have here v5.16 and no wakeup_vcpus_on_cpu_lock. It was also not
> removed so this patch is not intended for a previous kernel. Also
> checked next-20220111 and no wakeup_vcpus_on_cpu_lock.

Since this patch is good for stable@ too, I did the backport myself and 
queued Marcelo's version through a merge commit.  You can find it now in 
kvm.git's master (5.16 version) and next branches (5.17 version).

kvm/queue has been rebased on top as well.

Paolo

