Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B968648CB2E
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 19:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356424AbiALSof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 13:44:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356400AbiALSoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 13:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642013063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0euwNUoIX4P3cIJqD7s9RsLkXGwDPppr7oLc7IwQAq0=;
        b=gpQpaxNZ01O5i11WgkIvJRqgVo0pXXqWqDebNKgcqgGuWkTzP2LMhkYl1LmKBsvEcHyfi1
        eNICcpT8sDEQfny5FziKC5glwiw9E28TDpMqVp/nK3gG2hHvb2QhXReFTuBg/i8sHHvW+P
        tqMdoOLMto/bgTdC1NoRDZGc2GXxr4A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-SGkHuvI1Paq52aaLfGJS6Q-1; Wed, 12 Jan 2022 13:44:22 -0500
X-MC-Unique: SGkHuvI1Paq52aaLfGJS6Q-1
Received: by mail-ed1-f72.google.com with SMTP id q15-20020a056402518f00b003f87abf9c37so3040809edd.15
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:44:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0euwNUoIX4P3cIJqD7s9RsLkXGwDPppr7oLc7IwQAq0=;
        b=7OyH8mkFyhCNeoMO+2cyh3Vq+9etU6cagEsop5te5Fpj/IB1qxnlEYhnXLBOBieQB1
         ddn99RFv6kK9z9iwS8Sq1+vW37ttdkxz5Y2nNCrHLcNqkAaJTB/hIDQ3zJ8sN5uubbOg
         P1pQzPouwyGn6TIl05iFt7DZqd5TFe+UZ0rnO1Y2avjSz6m1Zxt2mLsNuFWiMh0F10eW
         Z02Wh8tXYPY+dXo/hD/bGbgNEFa+vsPpgH9TONkiWmoBU1IJWdKhB1zQLcKU1DpeDn81
         th94YtHVQTBQeV2E5sDeMCn/ckO9xhuxGdsaqI8/gI3sv8xR8yi+9KUYu3Kg80/JRNgn
         mJSQ==
X-Gm-Message-State: AOAM530GYgzxIOGSW6rD/t+zAn/TR7plAReRj/X1TAQwg5VIbQD9bvSa
        tqAfc8bBX4hEKfQmRyY5JBRswv3KqOQBZY/EExJNCCLJL2tbZIzzM0dVI98GHmdyk1NrgRa14T/
        2a+gvajSj88EX
X-Received: by 2002:aa7:cb08:: with SMTP id s8mr886507edt.57.1642013060994;
        Wed, 12 Jan 2022 10:44:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5Vpb4+KFi6A1Jx23P0fHwpaRRKlXI7HWsja2GsrVmeIsLaq+qPo+x0/i+wVJu8ajLNvEFgw==
X-Received: by 2002:aa7:cb08:: with SMTP id s8mr886491edt.57.1642013060801;
        Wed, 12 Jan 2022 10:44:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v16sm251526edc.4.2022.01.12.10.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 10:44:20 -0800 (PST)
Message-ID: <7d96787e-d2e8-b4cd-c030-bcda3fe23e55@redhat.com>
Date:   Wed, 12 Jan 2022 19:44:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Li RongQing <lirongqing@baidu.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yd8QR2KHDfsekvNg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/22 18:30, Sean Christopherson wrote:
>> Uhhmm, why not? Who says the vcpu will run the moment it becomes
>> runnable again? Another task could be woken up meanwhile occupying the
>> real cpu.
> Hrm, but when emulating HLT, e.g. for an idling vCPU, KVM will voluntarily schedule
> out the vCPU and mark it as preempted from the guest's perspective.  The vast majority,
> probably all, usage of steal_time.preempted expects it to truly mean "preempted" as
> opposed to "not running".

I'm not sure about that.  In particular, PV TLB shootdown benefits from 
treating a halted vCPU as preempted, because it avoids wakeups of the 
halted vCPUs.

kvm_smp_send_call_func_ipi might not, though.

Paolo

