Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673302C8A5A
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 18:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgK3RCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 12:02:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728174AbgK3RCy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 12:02:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606755687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgFd89DHnuHQ3v4vDDMB2aGeZJsjGIrSQaYmVa9y5pY=;
        b=VEp9D8pBF4sMTGq8N3MVIOPnAgvLA8NREGcTrV0Tew8f1dZ+vamoAwm2l6YhCgUa70VJKd
        MC8mVEpUc6v19fzcqKX+siLYFhX+AylL7on3CWxvCbRraFNtFNr1ePT/shRYBSh9rvLekJ
        frDhUrMTqhuusYoYSxWNeEEEw22O7dY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-_F7-u8_PNSyZLkVkTzYThw-1; Mon, 30 Nov 2020 12:01:19 -0500
X-MC-Unique: _F7-u8_PNSyZLkVkTzYThw-1
Received: by mail-ed1-f70.google.com with SMTP id y11so7067207edv.6
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 09:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VgFd89DHnuHQ3v4vDDMB2aGeZJsjGIrSQaYmVa9y5pY=;
        b=FJNLNfYhREaDAHWGVq84Jf3GZlZ98XhWQu9Iq27vQbU3fQiPjNrIC0nqkieHyeXXLO
         y2BTn2GqDNrSBstp8+3jWTQiz/l32d0noAWg91TEQBhFfC+Eex0UYAmnwRELAcOIHlN/
         1voZYotmJZnxqp4sBWLm8u5GAxF+h6KYWBEZIKYw0W/+WJ68I0xhm7WJ4ZUgUNakZEaE
         xOHUIbmp7cHeWJdZH/GC3DASZgj3AZbm46k4Te2TNX1tzyB0PPpOPnrf28Ag1MwmTMO5
         Y03OBeH+uDfFco71HH8nW2xUMWR/kgom5os67QoN5cgR5fQo07Hci7wDcTJmxrVjhvZi
         eMFA==
X-Gm-Message-State: AOAM530RcY2DrNdTKBCupToxKSlhVOl52x4zVd7A+Pj1T5vk2b0bIFwb
        K5Q2fJGMbsYIVk8qmz7hBCEIjm8plEyFu4HUWEDzY5wL+svFxhk3ubIiSfKBCdYvG7FeAQXauwB
        B0dURFI1eehor
X-Received: by 2002:a50:9991:: with SMTP id m17mr8474530edb.48.1606755678222;
        Mon, 30 Nov 2020 09:01:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuh5JY/rp8mBQt2cCoqr5FsmGZwPNmCeuL6bdGW9SV9BsoqQFM1sgKQnAFQijgEJHRpPd3MQ==
X-Received: by 2002:a50:9991:: with SMTP id m17mr8474488edb.48.1606755678013;
        Mon, 30 Nov 2020 09:01:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e3sm9022319ejq.96.2020.11.30.09.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:01:17 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: implement
 KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
 <20201130133559.233242-2-mlevitsk@redhat.com>
 <38602ef4-7ecf-a5fd-6db9-db86e8e974e4@redhat.com>
 <ee06976738dff35e387077ba73e6ab375963abbf.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <005aaf41-9376-d535-211f-9ff08e53bcc4@redhat.com>
Date:   Mon, 30 Nov 2020 18:01:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <ee06976738dff35e387077ba73e6ab375963abbf.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 16:58, Maxim Levitsky wrote:
>> This is mostly useful for userspace that doesn't disable the quirk, right?
> Isn't this the opposite? If I understand the original proposal correctly,
> the reason that we include the TSC_ADJUST in the new ioctl, is that
> we would like to disable the special kvm behavior (that is disable the quirk),
> which would mean that tsc will jump on regular host initiated TSC_ADJUST write.
> 
> To avoid this, userspace would set TSC_ADJUST through this new interface.

Yeah, that makes sense.  It removes the need to think "I have to set TSC 
adjust before TSC".

> Do you think that this is an issue? If so I can make the code work with
> signed numbers.

Not sure if it's an issue, but I prefer to make the API "less 
surprising" for userspace.  Who knows how it will be used.

> About nsec == 0, this is to allow to use this API for VM initialization.
> (That is to call KVM_SET_TSC_PRECISE prior to doing KVM_GET_TSC_PRECISE)

I prefer using flags for that purpose.

Paolo

