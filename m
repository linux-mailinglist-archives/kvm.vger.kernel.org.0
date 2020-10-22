Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912482962D4
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 18:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897469AbgJVQhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 12:37:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2897376AbgJVQhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 12:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603384670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtYKlqqsfUh3onisRedfmUk1jbRBMiSeTyZIxTQjMc8=;
        b=c4xqdWtjqfIM8UtjCEkfJKSAvVhSlzeRxvFqirwDJLDtOyEZFO5Chi5vPzUptIg5Kx3ffB
        VfPCP2OAv3/xXlZKOR6jCrIysFa0vIAQdJlvHeo/+glACc8gFndzJS2dGjmglPR9i2rAi8
        ZkvXPPNDNgRBFKY2YEqxdPOWu1GLeJA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-RKLlPXBQMRSnc8qH8QwU3Q-1; Thu, 22 Oct 2020 12:37:48 -0400
X-MC-Unique: RKLlPXBQMRSnc8qH8QwU3Q-1
Received: by mail-wr1-f69.google.com with SMTP id m20so828568wrb.21
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 09:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QtYKlqqsfUh3onisRedfmUk1jbRBMiSeTyZIxTQjMc8=;
        b=dQLX6uA4VuUayoXvEoP7+mGfjO49CF1iCH21K4ej221erreJxIHTUKCkwfy6we92sq
         NtOtqlDBQOwvKb33M+MR8w/b+U1ZG+Sk1GheLoMKU0C/vknt2QEXMlxhhKbzo4plEeWO
         cwbtJ3vXDVy1hu/JrHxiEjxNkts2Y3UiWX0qbR+PubnzKBAorVqcS7E5GRO4MazQECoq
         tZVktEM4GI7km6qI6CXisi1tS9QohpwvzXfAIcDT9DiQsN3UjWWSiyc2yc01cg3KFPGB
         Lc3pUWoWUpj4ifMsQcSgQgBqbmgcBpKFF7Yck1QZ4nhdKKRDb8pHZBHGBZNzxTHVOAxv
         LZPQ==
X-Gm-Message-State: AOAM532iNIfg9ht3vdDk8UgS3/WTWDvesR9FWwpr8vsdlK+gvrfEgpzN
        4wI3qz61doa187K3hoblsKeJL44wKYnCvycYMfhTQjSWJWzEP2Rd//HmJhlNHJCRJkDJ1xvYz5y
        yOqptnxkRC8im
X-Received: by 2002:a05:600c:d3:: with SMTP id u19mr3422669wmm.150.1603384667427;
        Thu, 22 Oct 2020 09:37:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1dAAikdYTkIfDCyfgPB2/+jGjC1ziu0OYS9BzctMyy4WuCIHIg9aRgKHev2Ycgj9U+hDmog==
X-Received: by 2002:a05:600c:d3:: with SMTP id u19mr3422649wmm.150.1603384667195;
        Thu, 22 Oct 2020 09:37:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d129sm4073026wmf.19.2020.10.22.09.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 09:37:46 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in
 KVM_GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
 <CALMp9eR3Ng-WBrumXaJAecLWZECf-1NfzW+eTA0VxWuAcKAjAA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <281bca2d-d534-1032-eed3-7ee7705cb12c@redhat.com>
Date:   Thu, 22 Oct 2020 18:37:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eR3Ng-WBrumXaJAecLWZECf-1NfzW+eTA0VxWuAcKAjAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/20 18:35, Jim Mattson wrote:
> On Thu, Oct 22, 2020 at 6:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 22/10/20 03:34, Wanpeng Li wrote:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> Per KVM_GET_SUPPORTED_CPUID ioctl documentation:
>>>
>>> This ioctl returns x86 cpuid features which are supported by both the
>>> hardware and kvm in its default configuration.
>>>
>>> A well-behaved userspace should not set the bit if it is not supported.
>>>
>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>
>> It's common for userspace to copy all supported CPUID bits to
>> KVM_SET_CPUID2, I don't think this is the right behavior for
>> KVM_HINTS_REALTIME.
> 
> That is not how the API is defined, but I'm sure you know that. :-)

Yes, though in my defense :) KVM_HINTS_REALTIME is not a property of the
kernel, it's a property of the environment that the guest runs in.  This
was the original reason to separate it from other feature bits in the
same leaf.

Paolo

