Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8666C2F7C54
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbhAONRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:17:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732170AbhAONRY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dV0VIxtOow3nIBadYeaRETElBYXibOZ77ggrv4koxxw=;
        b=QxPfPes1vvKZ4AyY8XuFfa/qaLe/i4X7x6bVAIKfuxRp6FZjuFpwsTwOBJAHmQXuUSnoRS
        yjUV57bDIGpIebsU8RjlDuxkENVZeLucamdRWn9Mr/3JkTS7TfV+lTVVhD5d46SwH2f9KY
        aLoYkuMA05H879Nb/BtS/weRnxDwB0U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-_Q3W-ZLOOtSC4zytMtqFAQ-1; Fri, 15 Jan 2021 08:15:56 -0500
X-MC-Unique: _Q3W-ZLOOtSC4zytMtqFAQ-1
Received: by mail-ed1-f69.google.com with SMTP id g14so3843735edt.12
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 05:15:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dV0VIxtOow3nIBadYeaRETElBYXibOZ77ggrv4koxxw=;
        b=BXhWD2WaH+9pRroJGDRYMPPfNUzxyQanx2yCj8OT+6ukYBFshB81QDLSaYSKSsm4RJ
         348Myp6TP2Lc9vT617cjsbEMX2o6m7m3Apyl/bm5qCiiTgAT3Ki1PQapj+WVl4l+8m36
         O5A1bH5aSf2D6xMmYHXFPHY6vT/ofyOMGrOwv5Di4x7t6Eh4SA77/IgxZOwHhMuu/iG6
         dA3Ql7yPG7Mo6siFpTpev5D0Smf29KRlOkd/wcbWGCM6bLItd0LXxhzggd208rgw9zdw
         GLUnqm8bl+i06w5E67cJFs9Rrb5F48pQJKrn3zle/LdeR3wQzfO+gqYmtQnC9Uap3WKe
         /4tA==
X-Gm-Message-State: AOAM532pOuO3mE4limLywojWYKQBUC7pTCKEVgJBHGkGfL5+ljv1SedC
        0m4CJvi/0+uZDLXFmqb3rJviXUEom3FQ52G9rpmyOgvcLp6dIHX8kCxj0RP3QGi1n5sEX5s7DSO
        TDh6U9z6iq2x1
X-Received: by 2002:a17:906:2681:: with SMTP id t1mr8759742ejc.29.1610716555550;
        Fri, 15 Jan 2021 05:15:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXZkTwApypH8mMny5nyZy9cV4F/Z1aIUwN/opNrl8epxNKrjnRnEg4UAdOUMgmPBBv05Cmqw==
X-Received: by 2002:a17:906:2681:: with SMTP id t1mr8759729ejc.29.1610716555367;
        Fri, 15 Jan 2021 05:15:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm3117462edb.16.2021.01.15.05.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 05:15:54 -0800 (PST)
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
 <YACl4jtDc1IGcxiQ@google.com>
 <d2e5f090-b699-1f94-eb33-b7bb74f14364@redhat.com>
 <YADB72Bu9PGh+bFk@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9e9781b-60df-e477-fb62-f41aa694348a@redhat.com>
Date:   Fri, 15 Jan 2021 14:15:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YADB72Bu9PGh+bFk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/21 23:13, Sean Christopherson wrote:
> On Thu, Jan 14, 2021, Paolo Bonzini wrote:
>> On 14/01/21 21:13, Sean Christopherson wrote:
>>> On Wed, Jan 13, 2021, Paolo Bonzini wrote:
>>>> On 12/01/21 23:28, Sean Christopherson wrote:
>>>>> What's the biggest hurdle for doing this completely within the unit test
>>>>> framework?  Is teaching the framework to migrate a unit test the biggest pain?
>>>>
>>>> Yes, pretty much.  The shell script framework would show its limits.
>>>>
>>>> That said, I've always treated run_tests.sh as a utility more than an
>>>> integral part of kvm-unit-tests.  There's nothing that prevents a more
>>>> capable framework from parsing unittests.cfg.
>>>
>>> Heh, got anyone you can "volunteer" to create a new framework?  One-button
>>> migration testing would be very nice to have.  I suspect I'm not the only
>>> contributor that doesn't do migration testing as part of their standard workflow.
>>
>> avocado-vt is the one I use for installation tests.  It can do a lot more,
>> including migration, but it is a bit hard to set up.
> 
> Is avocado-vt the test stuff you were talking about at the KVM Forum BoF?

Yes, it is.

Paolo

