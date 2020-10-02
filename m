Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7CF28194B
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388291AbgJBRbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:31:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388248AbgJBRbD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 13:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601659861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TxOHOh0IIejZk+BuR1OyBgwvkUAEztBJORaBCqWyOAI=;
        b=gAlF4Fb9O5p+bwmkrO3IQWzUsbDWwBUIIKUgIbfPUEOA9oIyL+m9zqL9PwIqFWNG/DgtPO
        z7gKvzm1WyO9P1hY6sRNfnnBJKGYQOpJW0YKn3wZrXugURbV7VB0NOmuGGFEYSiDZ3Xwhi
        NL6nHfS6lkZyX7hIMF0xhxdUfdB8KH8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-l4is5hPdOzaxwHpmxuY0pQ-1; Fri, 02 Oct 2020 13:31:00 -0400
X-MC-Unique: l4is5hPdOzaxwHpmxuY0pQ-1
Received: by mail-wm1-f70.google.com with SMTP id y6so746931wmi.7
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 10:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TxOHOh0IIejZk+BuR1OyBgwvkUAEztBJORaBCqWyOAI=;
        b=UQLTFdIuYUQXx9TQfMb5b1rooWgs8BrGPCjypX67h+05EBx5lCslD+OSs4UsPGlsGx
         rBFwWowCr4ddluT23yF7LVG6NVZ0yd/h65YPpMu+ELs6u+FU2gRcqPMo0mY8Q2w2vQf5
         llHbqoZ+FnUbIW3fF2SqZ7jNRCvsSMcqII+ynoxwi8kxtCcy1cOja28+f5VJVlVLvOQd
         dD/2C7pGJNQXmUl1g+Pf25B9kBeXzUgHeNnqIr77yomST2lsBZbvTFWhvkoL+5aI7J/I
         0szPmzkOSS53SVzOXV3ZEjyZs2aDlBvuGrGKhyDI5whyMuJWH0eWPgtWJ1o/dGjNaCdQ
         VK0Q==
X-Gm-Message-State: AOAM531cJjWf068pBNSzY8AdQ3NlekJQfW+h7Z7/lpk4Dtl4upz9G1o4
        DoQy9MwWmxOaC4gsAzM2wiAUlz+A9TkI2hnDMEhNrN7B2dCq2UYfqrfk4H3vRWy8vUQR0yVoHss
        3VDdu/fWUCXbR
X-Received: by 2002:a7b:c0c1:: with SMTP id s1mr4244456wmh.73.1601659858186;
        Fri, 02 Oct 2020 10:30:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxM8WopKn+E/7ZEMfQTo4iJ+AulaHlScB3Vysd80PrpI/qioSdeZTkZO1byHJi2o6MFioQsA==
X-Received: by 2002:a7b:c0c1:: with SMTP id s1mr4244432wmh.73.1601659857933;
        Fri, 02 Oct 2020 10:30:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:47e0:e742:75ba:b84d? ([2001:b07:6468:f312:47e0:e742:75ba:b84d])
        by smtp.gmail.com with ESMTPSA id o194sm2808207wme.24.2020.10.02.10.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 10:30:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Qian Cai <cai@redhat.com>, Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkft-triage@lists.linaro.org
References: <20200903141122.72908-1-mgamal@redhat.com>
 <1f42d8f084083cdf6933977eafbb31741080f7eb.camel@redhat.com>
 <e1dee0fd2b4be9d8ea183d3cf6d601cf9566fde9.camel@redhat.com>
 <ebcd39a5-364f-c4ac-f8c7-41057a3d84be@redhat.com>
 <2063b592f82f680edf61dad575f7c092d11d8ba3.camel@redhat.com>
 <c385b225-77fb-cf2a-fba3-c70a9b6d541d@redhat.com>
 <CA+G9fYvm1Ux7XmmXgpPHmLJ4WbRoPowbEfbub1HC2G4E-1r-1g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68a67f54-af5c-8b33-6b87-a67ccbbfc155@redhat.com>
Date:   Fri, 2 Oct 2020 19:30:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYvm1Ux7XmmXgpPHmLJ4WbRoPowbEfbub1HC2G4E-1r-1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 19:28, Naresh Kamboju wrote:
>>
>> commit 608e2791d7353e7d777bf32038ca3e7d548155a4 (HEAD -> kvm-master)
>> Author: Paolo Bonzini <pbonzini@redhat.com>
>> Date:   Tue Sep 29 08:31:32 2020 -0400
>>
>>     KVM: VMX: update PFEC_MASK/PFEC_MATCH together with PF intercept
>>
>>     The PFEC_MASK and PFEC_MATCH fields in the VMCS reverse the meaning of
>>     the #PF intercept bit in the exception bitmap when they do not match.
>>     This means that, if PFEC_MASK and/or PFEC_MATCH are set, the
>>     hypervisor can get a vmexit for #PF exceptions even when the
>>     corresponding bit is clear in the exception bitmap.
>>
>>     This is unexpected and is promptly reported as a WARN_ON_ONCE.
>>     To fix it, reset PFEC_MASK and PFEC_MATCH when the #PF intercept
>>     is disabled (as is common with enable_ept && !allow_smaller_maxphyaddr).
> I have tested this patch on an x86_64 machine and the reported issue is gone.
> 

Thanks, the issue with my disk is gone too so it'll get to Linus in time
for rc8.

Paolo

