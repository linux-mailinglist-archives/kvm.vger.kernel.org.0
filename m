Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB12F7D2B
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbhAONvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:51:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731264AbhAONvt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610718623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GClJQCWfDVIp8Abu+51pXYFvR3+SULW6nqe1Zw2Nhco=;
        b=F+C/Hx6rDj6qxuWxoXF4UDZORvoqvomimmfQoOsHcoZKMBYGVHBSLExAifxSGlvAaOJJBl
        9+lkUfyfYCNzsEn9TAbCqWGD+UhdB/3cSdgIoQMafk/NPnL9D8VPYFjPIgzaRRq34Bhjnb
        4p+LlPZHWepEE14XN/D+inHv6mlglS0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-iEYQ6LsKNcq697ZzCYafEA-1; Fri, 15 Jan 2021 08:50:21 -0500
X-MC-Unique: iEYQ6LsKNcq697ZzCYafEA-1
Received: by mail-ej1-f71.google.com with SMTP id p1so3601063ejo.4
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 05:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GClJQCWfDVIp8Abu+51pXYFvR3+SULW6nqe1Zw2Nhco=;
        b=Ro6dLC33RPrUrbLgXyKjSmazJbsW2yEJBt8V9hVEFQsa0GjB5F46O9PJiJBME/mSW/
         stpPZsBhgN0/d8meBcKd9a0PGd1+XZqyKi6za0hvOXo1bTYuQEcOBaze5aRzJUQIPugD
         qum6gp0L23c82+gfbrmgbf4ll7QlC8aO75CWq+k00k1Y8xTk22GxhlY1uiGysSpCm+/x
         Dw6Q0RtpIY20BxzslQLS0nN71+8Hr0atVjcELCyJXDz3I0wpM0EECE+Hao6xqq55XYXt
         4ltmWQAJtP54h6w5ergaKwaeeAkQ64u7AmwhezPjT/+O6Ovwl0WEl45JXiJRHvzOMUB+
         b1cQ==
X-Gm-Message-State: AOAM532ZIB0c1Rivr5mE2VVDxryYORcJuVKQEhrd1tjN+5epsOcuRtZe
        1q4qbAPtjk9now0h7G+CRL+stPCKoyiJ8oWATyFivuQv3oKwkLokevRgjeSfkT28MKoJ/9bNV4O
        DLAgxHL/9Ro1W
X-Received: by 2002:a17:907:3f13:: with SMTP id hq19mr9060269ejc.142.1610718620211;
        Fri, 15 Jan 2021 05:50:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKpmIkaYyI1N+J5ZOU1XodqPeFuoNmwqs4aW3Sw/NgHl/VK+y6PQ/FPUfmzNJDpLKJ7aNWYg==
X-Received: by 2002:a17:907:3f13:: with SMTP id hq19mr9060257ejc.142.1610718620074;
        Fri, 15 Jan 2021 05:50:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm3461214ejb.65.2021.01.15.05.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 05:50:19 -0800 (PST)
Subject: Re: [PATCH v2 2/3] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
To:     Peter Zijlstra <peterz@infradead.org>,
        Jason Baron <jbaron@akamai.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e5cc82ead7ab37b2dceb0837a514f3f8bea4f8d1.1610680941.git.jbaron@akamai.com>
 <YAFf2+nvhvWjGImy@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <84b2f5ba-1a16-cb01-646c-37e25d659650@redhat.com>
Date:   Fri, 15 Jan 2021 14:50:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YAFf2+nvhvWjGImy@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 10:26, Peter Zijlstra wrote:
>> +#define KVM_X86_OP(func)					     \
>> +	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
>> +				*(((struct kvm_x86_ops *)0)->func));
>> +#define KVM_X86_OP_NULL KVM_X86_OP
>> +#include <asm/kvm-x86-ops.h>
>> +EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>> +EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
>> +EXPORT_STATIC_CALL_GPL(kvm_x86_tlb_flush_current);
> Would something like:
> 
>    https://lkml.kernel.org/r/20201110103909.GD2594@hirez.programming.kicks-ass.net
> 
> Be useful? That way modules can call the static_call() but not change
> it.
> 

Maybe not in these cases, but in general there may be cases where we 
later want to change the static_call (for example replacing jump labels 
with static_calls).

Paolo

