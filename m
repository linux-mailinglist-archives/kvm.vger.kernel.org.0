Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4685444223
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 14:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhKCNIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:08:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhKCNHz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 09:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635944717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nVNT3IwW2nAj2r0Bm5fTe9lt5SSs+DxlLmhzm2o9qo0=;
        b=Ja9JHcpH7nO2oIQCWOSPlBuw3uiefuaZTVAf6TNpf9yrED35hhyU6CjnFi9x2GxrLIckr2
        fVfoywfxTNU73sv/bAk/NErJT8D2fEjcUtQwXWXGZSeQzCV1h1rYss3WElcY78V7uGKqIX
        repcDp3vD9ZJWRN2AwBD3/261gaxjuI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-CIyKwMi5MgiHvESXPL9e0w-1; Wed, 03 Nov 2021 09:05:16 -0400
X-MC-Unique: CIyKwMi5MgiHvESXPL9e0w-1
Received: by mail-ed1-f69.google.com with SMTP id w12-20020aa7da4c000000b003e28acbf765so2419208eds.6
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 06:05:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nVNT3IwW2nAj2r0Bm5fTe9lt5SSs+DxlLmhzm2o9qo0=;
        b=Qy9oupcyw1XxS0SIEspvYQLijPEnmdyqQUhh41GFtABzui/p/Q8RP1xPb3XwwZqc26
         afApU5QAavEavq1zXexLyomuySJSMwDcAVtdNcf3eBflAmtYYOa+68CTOmSBTjOsKDcZ
         7jtDRFce+mpGTQqQ1bzViNsf2aMdRuZUCvLX/JIaIf7ZUQwdlrVeesbEZqEp4ufsBXSN
         vnbZTqTMd9QGUM7s4uYr8QrrjpkcikHV1PjT9uT3uQZ1HY0iOOEHsIlWO+MldVCQWnBJ
         3yhfD3oUaiomJS0RcM8zHCE/dyIGwcjC1cTbUE6YQVYYn6sEtv+cGaYn3TE/x6p1USEo
         8O9Q==
X-Gm-Message-State: AOAM533NwMAdvILE8sbcEc+z4HoO6xSxJIguB6jnm9IyPw60+nR/ey1B
        +YTbgrTfqwEn2hYt3xK0gPsBPQIhMRpK9uGYOMbFlRWIUGlW0Z9xRCmpUfUZg/QpkJVbVyNfNP0
        VIr6PPVhTL88I
X-Received: by 2002:aa7:cb41:: with SMTP id w1mr61301927edt.327.1635944714081;
        Wed, 03 Nov 2021 06:05:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGozm7BKivZusG4/uaNCQv6O/dfjXPmlh8x182mCq5OrH9YAU//7U1FFLhZmqHNTbdUxIGEA==
X-Received: by 2002:aa7:cb41:: with SMTP id w1mr61301882edt.327.1635944713791;
        Wed, 03 Nov 2021 06:05:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t25sm1268156edv.31.2021.11.03.06.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 06:05:12 -0700 (PDT)
Message-ID: <69495972-c3b8-cad2-40d9-5044d2837043@redhat.com>
Date:   Wed, 3 Nov 2021 14:05:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
 <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
 <E4C6E3D6-E789-4F0A-99F7-554A0F852873@infradead.org>
 <e05809f3-46fa-8fdf-642d-66821465456e@redhat.com>
 <0FC7C414-418D-4EFC-93C3-BBB42176CB41@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0FC7C414-418D-4EFC-93C3-BBB42176CB41@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/21 13:56, David Woodhouse wrote:
>> No need to resubmit, thanks!  I'll review the code later and
>> decide whether to include this in 5.16 or go for the "good"
>> solution in 5.16 and submit this one for 5.15 only.
> I would call this the good solution for steal time. We really do
> always have a userspace HVA for that when it matters, and we should
> use it.
> 
> For Xen event channel delivery we have to do it from hardware
> interrupts under arbitrary current->mm and we need a kernel mapping,
> and we need the MMU notifiers and all that stuff. But for every
> mapping we do that way, we need extra checks in the MMU notifiers.
> 
> For steal time there's just no need.

Yes, but doing things by hand that it is slightly harder to get right, 
between the asm and the manual user_access_{begin,end}.

The good solution would be to handle the remapping of _all_ gfn-to-pfn 
caches from the MMU notifiers, so that you can still do map/unmap, keep 
the code simple, and get for free the KVM-specific details such as 
marking the gfn as dirty.

When I was working on it before, I got stuck with wanting to do it not 
just good but perfect, including the eVMCS page in it.  But that makes 
no sense because really all that needs to be fixed is the _current_ 
users of the gfn-to-pfn cache.

Paolo

