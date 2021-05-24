Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BC38E764
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhEXN1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:27:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232456AbhEXN1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 09:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621862732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M0kainRH42RdsY8Y3urUJhWHPRUuUeVjYP8+Uj0Uo0c=;
        b=L4FuAZ94WsFl6m7BrUX54LOX23MvkxYetsKwvAPEYnU2/4Yxmuryaysf0k+3sDoACvF05m
        4Hjq4ryBXSPYwfSnJ/9QCe+SAiN6gm6tKQbVdsnNv8StVuB8Yrzq1xqrvFy5Pj+FcQ8r15
        OWJX/bEzR0HB7oYAqL2IB79wa4RwW8U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-4SwI2kn4PBSch2n3GoCYUQ-1; Mon, 24 May 2021 09:25:28 -0400
X-MC-Unique: 4SwI2kn4PBSch2n3GoCYUQ-1
Received: by mail-ej1-f70.google.com with SMTP id gf21-20020a170906e215b02903dfa2e85ff7so716536ejb.15
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0kainRH42RdsY8Y3urUJhWHPRUuUeVjYP8+Uj0Uo0c=;
        b=BT4xJFmyJ2vhbX5L28pwmMDOMQnE7QmkCtngDZDzsWE/hYo7/uDpKHvew9zcbgbaC5
         /yi1m7DweJxuc/r9pg2kSQ5g73Kf6Uh8AFPOYWZ6wGW26YOVRMVFbl5QLF2gfHoI9CUY
         kVwhLOFtlWQOtiONSkxN0ImpxVTCAipdZQWEyAmbGgm7XIaUEsJv6B77r8zgCAliTZpk
         uHFXFssQd5buxMRFgcZxVBN9oROFjBF2bDvmz35GIiaB/kcRrj8sq9LOL+c4Avpm8BUN
         HTbtlbiIKoNDKuHp4SMlC0yABeJKGQe/fkwToUcooFe0pxDsZQRugSCsLsYh65WFkxkV
         Jmmw==
X-Gm-Message-State: AOAM532ZDgq3Nl0pjhLjw49vjvRVF5TP8s/3EzyEVHjSqlR8WKRwXrAI
        rwoyvdskUndRm/DoOYSvwYXLMeo/33EjCb5XJH0FVyl/3E9KdbvFkqmFTGcnlPdBfpF46ar68bL
        mI0YgMktNwBrp
X-Received: by 2002:a17:906:eb0d:: with SMTP id mb13mr23097555ejb.261.1621862727709;
        Mon, 24 May 2021 06:25:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9QnvMOCLEMOMhpBAki5iXpY5iZp70ilUI2Tl1uFieprXzXpBLESyZxxJnCJHzmTQqktCk2A==
X-Received: by 2002:a17:906:eb0d:: with SMTP id mb13mr23097529ejb.261.1621862727542;
        Mon, 24 May 2021 06:25:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r17sm9231641edt.33.2021.05.24.06.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 06:25:26 -0700 (PDT)
Subject: Re: [PATCH v2 02/10] KVM: selftests: simplify setup_demand_paging
 error handling
To:     Axel Rasmussen <axelrasmussen@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20210519200339.829146-1-axelrasmussen@google.com>
 <20210519200339.829146-3-axelrasmussen@google.com>
 <CANgfPd-dF+vWafBC5DsNhf5C0M12+LxRQLhsBM=CzOKTsep+og@mail.gmail.com>
 <CAJHvVcizVoAs+-wOXeO7bc=8c2G3oEC4KSVyPm5E9Z6YMCsvaw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <824fe2de-a087-d2b4-406a-e8c6c040b37a@redhat.com>
Date:   Mon, 24 May 2021 15:25:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAJHvVcizVoAs+-wOXeO7bc=8c2G3oEC4KSVyPm5E9Z6YMCsvaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/21 00:14, Axel Rasmussen wrote:
> On Wed, May 19, 2021 at 2:45 PM Ben Gardon <bgardon@google.com> wrote:
>>
>> On Wed, May 19, 2021 at 1:03 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
>>>
>>> A small cleanup. Our caller writes:
>>>
>>>    r = setup_demand_paging(...);
>>>    if (r < 0) exit(-r);
>>>
>>> Since we're just going to exit anyway, instead of returning an error we
>>> can just re-use TEST_ASSERT. This makes the caller simpler, as well as
>>> the function itself - no need to write our branches, etc.
>>>
>>> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
>>> ---
>>>   .../selftests/kvm/demand_paging_test.c        | 51 +++++++------------
>>>   1 file changed, 19 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
>>> index 9398ba6ef023..601a1df24dd2 100644
>>> --- a/tools/testing/selftests/kvm/demand_paging_test.c
>>> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
>>> @@ -9,6 +9,8 @@
>>>
>>>   #define _GNU_SOURCE /* for pipe2 */
>>>
>>> +#include <inttypes.h>
>>> +#include <stdint.h>
>>
>> Why do the includes need to change in this commit? Is it for the PRIu64 below?
> 
> Right, I didn't actually try compiling without these, but inttypes.h
> defines PRIu64 and stdint.h defines uint64_t. In general I tend to
> prefer including things like this because we're using their
> definitions directly, even if we might be picking them up transiently
> some other way.

inttypes.h is defined to include stdint.h (stdint.h is mostly useful in 
freestanding environments and is usually provided by the C compiler, 
while inttypes.h is provided by libc).

Paolo

