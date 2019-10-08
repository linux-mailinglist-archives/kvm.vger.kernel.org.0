Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1755CFE65
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 18:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfJHQB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 12:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62327 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfJHQB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 12:01:58 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CBDBD793D1
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 16:01:57 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id l12so3253044wrm.6
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 09:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TS0HYogtSTmLguUVn0v68yaiQUr6ZWK+hKn0fHd93Z0=;
        b=PGgD1W7AeDiIjtOsjnBB7hyqhtvXLImsCLzuZrYb8iGgDZNeO2P0MbUMXeQ63XJQRr
         NZ8U03sgm5qdosioHmKMaVNMBQSij7DY6+Jo7bY+UG4C2zZqe2EiGGH8Cq06SUKtRSp5
         5Dqw9TvOul7yVtpvq1qpQ2IPEHyW0FMds9wzfQWsUf45aZ9L9cqI0wVKn5TNASaynmLK
         odqD/65jANg6bNfwXAYXjNDdLTlfOXS2Wqp/RsTCXvblh+4B5NTK7iWo8zgWcdR0PLu8
         ztZ6c1ob1GBnn9FhDkdxpMqi2yOYvva6QSk9jw2H7C1tPD5dPl5HNPaDUGJsqg1L7jtr
         vjeg==
X-Gm-Message-State: APjAAAX+RmJ9W9+oYacPNzuXnzbFrXBkDpjARjH1wyDOGAE4SDTm+7Z8
        7IXoKwnViCEPBTjbW8Tq3TSoEO1cJ+7kO7+LC6e4K3FL15nsZqmoZPf9OC0IPv+RrjwbhEesXdr
        hBRpM9vzepAHw
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr4267827wmd.1.1570550516363;
        Tue, 08 Oct 2019 09:01:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6u86K3IwPNqtf0KGHP6//UeYcqXAvTS45mdwQM7K7JA1EnENcsXEYxI7EWqEYBxCtKFVewg==
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr4267760wmd.1.1570550515678;
        Tue, 08 Oct 2019 09:01:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id l11sm3660316wmh.34.2019.10.08.09.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:01:55 -0700 (PDT)
Subject: Re: KVM-unit-tests on AMD
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jack Wang <jack.wang.usish@gmail.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
 <875zkz1lbh.fsf@vitty.brq.redhat.com>
 <CA+res+QTrLv7Hr9RcGZDua6JAdaC3tfZXRM4e9+_kbsU72OfdA@mail.gmail.com>
 <87wodfz38m.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0868bf81-e4cf-0f9b-3ed1-9ca2e14b02dc@redhat.com>
Date:   Tue, 8 Oct 2019 18:01:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87wodfz38m.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 17:06, Vitaly Kuznetsov wrote:
> Jack Wang <jack.wang.usish@gmail.com> writes:
> 
>> Vitaly Kuznetsov <vkuznets@redhat.com> 于2019年10月8日周二 下午2:20写道：
>>>
>>> Nadav Amit <nadav.amit@gmail.com> writes:
>>>
>>>> Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>>>>
>>>
>>> It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
>>> but the whole SVM would appreciate some love ...
>>>
>>>> Clearly, I ask since they do not pass on AMD on bare-metal.
>>>
>>> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
>>> failures:
>>>
>>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>>
>>> (Why can't we just check
>>> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>>>
>>> FAIL svm (15 tests, 1 unexpected failures)
>>>
>>> There is a patch for that:
>>>
>>> https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.com/T/#t
>>>
>>
>>> Are you seeing different failures?
>>>
>>> --
>>> Vitaly
>> On my test machine AMD Opteron(tm) Processor 6386 SE, bare metal:
>> I got similar result:
>> vmware_backdoors (11 tests, 8 unexpected failures)
>> svm (13 tests, 1 unexpected failures), it failed on
>> FAIL: tsc_adjust
>>     Latency VMRUN : max: 181451 min: 13150 avg: 13288
>>     Latency VMEXIT: max: 270048 min: 13455 avg: 13623
> 
> Right you are,
> 
> the failing test is also 'tsc_adjust' for me, npt_rsvd_pfwalk (which
> Cathy fixed) is not being executed because we do '-cpu qemu64' for it.
> 
> With the following:
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index b4865ac..5ecb9bb 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -198,7 +198,7 @@ arch = x86_64
>  [svm]
>  file = svm.flat
>  smp = 2
> -extra_params = -cpu qemu64,+svm
> +extra_params = -cpu host,+svm
>  arch = x86_64
>  
>  [taskswitch]

Patch please? :D

Paolo

> everything passes, including tsc_adjust:
> 
> PASS: tsc_adjust
>     Latency VMRUN : max: 43240 min: 3720 avg: 3830
>     Latency VMEXIT: max: 36300 min: 3540 avg: 3648
> 

