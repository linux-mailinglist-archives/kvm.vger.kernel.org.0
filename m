Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC5C237F2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfETNWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:22:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54452 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfETNWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 09:22:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id i3so13304999wml.4
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 06:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZD8+3LdOXmSgvF5Ce+oDOsqn87xV+jcKh3r9XJQGteg=;
        b=HigtUw9GBp7TFj37dSUu+WXVpj6qLjT1I6q3Q6GEFzdSmri4HvEs6XMMxh0G+/VfBf
         l76n+AMqCSKjv+Qy+32sEv3x6YfJoK2DU3mu/wLgPb1UGsV4WVflA4YS7iiHH2jvBemH
         OYlD0nlsiukhBfYMZUk9tyecicp2uJtsZbq4wWhbgzf0ssx+xC2MFxcIbtVDisoHN2vI
         IXcc7qTdkZT1eKDErRWmBcoMhFMARz6eATnk47UChr7QwD3JswUxJfhT6jGWRPTDDzr2
         ZGobKVQXftPO/iqoen2q7QCb7Jp4L7GvdK5yy/PI7LFDFIcEebn2adn18pySftIy9g9i
         NsTw==
X-Gm-Message-State: APjAAAVQIBFUiF1BsQulptfBrCACLPdJnAsBB4GU8o2lTvnzmAkY6Ts1
        bVwjUEi97Dw44p3wt9qaY1r5og==
X-Google-Smtp-Source: APXvYqzhRmaUSwsc0lb4PFcSwQi2hB+xeqAgjVF9HtZLg86RRWTLcorNoC902Py5KEISKMw7fsrRnQ==
X-Received: by 2002:a7b:c189:: with SMTP id y9mr12420826wmi.116.1558358570569;
        Mon, 20 May 2019 06:22:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id b18sm15335963wrx.75.2019.05.20.06.22.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:22:49 -0700 (PDT)
Subject: Re: [kvm-unit-test nVMX]: Test "load IA32_PAT" VM-entry control on
 vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190418213941.20977-1-krish.sadhukhan@oracle.com>
 <d9145c8b-ce7a-6d74-c6c4-3390b1406e0a@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <03b136e4-20fb-0f39-3c9e-696e925fb3a2@redhat.com>
Date:   Mon, 20 May 2019 15:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d9145c8b-ce7a-6d74-c6c4-3390b1406e0a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/19 19:43, Krish Sadhukhan wrote:
> Ping...

There have been some changes inthe meanwhile so the patches needed some
work to rebase.  I hope I haven't butchered them too much, please take a
look at the master branch. :)

Thanks,

Paolo

> On 4/18/19 2:39 PM, Krish Sadhukhan wrote:
>> This is the unit test for the "load IA32_PAT" VM-entry control. Patch# 2
>> builds on top of my previous patch,
>>
>>     [PATCH 6/6 v5][kvm-unit-test nVMX]: Check "load IA32_PAT" on
>> vmentry of L2 guests
>>
>>
>> [PATCH 1/2][kvm-unit-test nVMX]: Move the functionality of
>> enter_guest() to
>> [PATCH 2/2][kvm-unit-test nVMX]: Check "load IA32_PAT" VM-entry
>> control on vmentry
>>
>>   x86/vmx.c       |  27 +++++++----
>>   x86/vmx.h       |   4 ++
>>   x86/vmx_tests.c | 140
>> ++++++++++++++++++++++++++++++++++++++++++++++--------
>>   3 files changed, 143 insertions(+), 28 deletions(-)
>>
>> Krish Sadhukhan (2):
>>        nVMX: Move the functionality of enter_guest() to
>> __enter_guest() and make the former a wrapper of the latter
>>        nVMX: Check "load IA32_PAT" VM-entry control on vmentry of
>> nested guests
>>

