Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BCD274F22
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 04:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgIWCn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 22:43:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727289AbgIWCn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 22:43:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600829036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5Iph86XmuhHCGapZ7ui2au4oqLldEp1TWYtO710rHU=;
        b=XSmpwGdClmNJLB/dR5QLRumWx+Lxb892EAYuc5oy7OSFCk69jNNDA9rA+2BxzHW/qhyQGf
        kAT9dvIv3a3GL8Fm18U9vFCbrf9Asc+8y9ALWbwAObXXSZtIpLivRJO+LC8ewaZGpYaOZ/
        RTOgmT0x+YA5kHEfbWKFFAPBNmLyco0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-cggYP2XoPC2CLVfp6eJ3wQ-1; Tue, 22 Sep 2020 22:43:53 -0400
X-MC-Unique: cggYP2XoPC2CLVfp6eJ3wQ-1
Received: by mail-wr1-f70.google.com with SMTP id l17so8163808wrw.11
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 19:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L5Iph86XmuhHCGapZ7ui2au4oqLldEp1TWYtO710rHU=;
        b=Scv04YObTMfAi2zefi1zClGN4AXm5b4JowM0BE/KODx0kXVLUEKrDQp2XnXsUZouUT
         qERprZErCgPWDc4ofT+ogeA/dCpiqFsxV6YWB7/IYFP6lPq/iz1kBWHw92gb0UBy1QY1
         grzg4gzRxTdsXwNZz0JResS94xGhPUeTWdPTePJBfhAYjPTAGFvQ0Rp2Ba9qLTcoiU3T
         tvT9ilJZ9j0kHXx3pvyjZGQwuamIF8fN5XuFQQXdo5UucuCbkzoDSA0EiJ15I9Y2oqqp
         f2VH8EEeuh412isOR32qAK5crtfwr4Dc3LYc/1wneuTYC2id+NeVWmfzEQH/eaNjno1K
         oEdw==
X-Gm-Message-State: AOAM530OfNNlA1ZFP58P2iZ1YbXFL16ls6Zick7V+baajJklLBIa5EiU
        KqLIBfVGvGFOZNrNNuUdGX6WTG9bNWD90gHu6Z60kYbWS0CYzp5h4PVBt8EunSn4hRpdCuz/LEZ
        JIw2HN4cVN32Q
X-Received: by 2002:adf:f986:: with SMTP id f6mr8040336wrr.270.1600829032478;
        Tue, 22 Sep 2020 19:43:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxujNV1OhkUe3ta9YvVqeawpCFmGsJIC6lIUnrWxeIHRF2Kv6kHIxIuUPBV+nuf//TFgzpi9A==
X-Received: by 2002:adf:f986:: with SMTP id f6mr8040312wrr.270.1600829032236;
        Tue, 22 Sep 2020 19:43:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2eaa:3549:74e8:ad2b? ([2001:b07:6468:f312:2eaa:3549:74e8:ad2b])
        by smtp.gmail.com with ESMTPSA id s11sm27588526wrt.43.2020.09.22.19.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 19:43:51 -0700 (PDT)
Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
To:     Babu Moger <babu.moger@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
 <1654dd89-2f15-62b6-d3a7-53f3ec422dd0@redhat.com>
 <20200914150627.GB6855@sjchrist-ice>
 <e74fd79c-c3d0-5f9d-c01d-5d6f2c660927@redhat.com>
 <408c7b65-11a5-29af-9b9f-ca8ccfcc0126@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4fea8c91-8991-2449-b8b7-180cdc8786ca@redhat.com>
Date:   Wed, 23 Sep 2020 04:43:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <408c7b65-11a5-29af-9b9f-ca8ccfcc0126@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 21:11, Babu Moger wrote:
> 
> 
>> -----Original Message-----
>> From: Paolo Bonzini <pbonzini@redhat.com>
>> Sent: Tuesday, September 22, 2020 8:39 AM
>> To: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Moger, Babu <Babu.Moger@amd.com>; vkuznets@redhat.com;
>> jmattson@google.com; wanpengli@tencent.com; kvm@vger.kernel.org;
>> joro@8bytes.org; x86@kernel.org; linux-kernel@vger.kernel.org;
>> mingo@redhat.com; bp@alien8.de; hpa@zytor.com; tglx@linutronix.de
>> Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to
>> generic intercepts
>>
>> On 14/09/20 17:06, Sean Christopherson wrote:
>>>> I think these should take a vector instead, and add 64 in the functions.
>>>
>>> And "s/int bit/u32 vector" + BUILD_BUG_ON(vector > 32)?
>>
>> Not sure if we can assume it to be constant, but WARN_ON_ONCE is good
>> enough as far as performance is concerned.  The same int->u32 +
>> WARN_ON_ONCE should be done in patch 1.
> 
> Paolo, Ok sure. Will change "int bit" to "u32 vector". I will send a new
> patch to address this. This needs to be addressed in all these functions,
> vmcb_set_intercept, vmcb_clr_intercept, vmcb_is_intercept,
> set_exception_intercept, clr_exception_intercept, svm_set_intercept,
> svm_clr_intercept, svm_is_intercept.
> 
> Also will add WARN_ON_ONCE(vector > 32); on set_exception_intercept,
> clr_exception_intercept.  Does that sound good?

I can do the fixes myself, no worries.  It should get to kvm/next this week.

Paolo

