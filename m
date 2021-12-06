Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB5C469152
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 09:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbhLFISe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 03:18:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239080AbhLFISd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 03:18:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638778504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fB0uNa7PodpnqT7F7hvVjyUv/QEUaHoehSHnEO9u53o=;
        b=fbgBfFYOOcnr5RFDLTETJCUHXERaq+xaLWMhytpwJ798pzNxJek4ea0f5UFB5iapATzfnN
        9fH6L/xKnB421bO22TAehFbSeT5vt3QBlzNpsKVpxYynZdCHnqkcWrPTU4GTOYCRHRxovG
        PaDvhY7bbIn7iGTh950sb/Vs+QZGT9Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-WQyPvQvlOeWFzdsR0Zr9zA-1; Mon, 06 Dec 2021 03:15:02 -0500
X-MC-Unique: WQyPvQvlOeWFzdsR0Zr9zA-1
Received: by mail-wr1-f70.google.com with SMTP id q17-20020adfcd91000000b0017bcb12ad4fso1756170wrj.12
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 00:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=fB0uNa7PodpnqT7F7hvVjyUv/QEUaHoehSHnEO9u53o=;
        b=L2Sr87l0XZBKyfh3/3yUl2+7bvPPv6IMfSMEzz+X4W9mkndvpAE2RJs2uIk4Rojgcc
         q2ruZjUEum2wNPB6GWOvbicNais5RdhbIIeEfP9hECjp++2QZISGr7HuFwnbkNZ/PSEm
         HBXKADYqWskt0qSZ7iTV3eFi6nYVfDC2RpQ/dMfZj9KoShNXlxS97fC7tgEAtqhn7C0U
         fhkz7USWmeZssXLXV+CueX9JXqpeB5XtxohGDVvmyrQLk4u/LzzN3vmoCX6sIb8d8XzP
         l3VSl/9GK6x2+3/Jzq5a9rjUhEcJtC4KMfADz+wZGS5PN6qYgTiiJ9UpMQA1Ladm+8PW
         KqPg==
X-Gm-Message-State: AOAM5333AQ0MKZ6WrTZxm0zIQTVxKRUBVVL0iZWRgmQbP2Z64zzPjolt
        Br39ZHXZunhDGjh9F4KWwOcTVQsUu6xkHv61g6aNwwNqmFLXHnATCL6jDEZUjMqkcjOtwGgeVDd
        ndHuPsR9xrTQG
X-Received: by 2002:a05:6000:381:: with SMTP id u1mr41471972wrf.302.1638778501479;
        Mon, 06 Dec 2021 00:15:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmUXhNhKnLPvIQt8a+QUVzIPPnSI1aNA4wwthV8Rb32aUbw1BzFLyOMK32juv6Gqb/sAgQyA==
X-Received: by 2002:a05:6000:381:: with SMTP id u1mr41471955wrf.302.1638778501260;
        Mon, 06 Dec 2021 00:15:01 -0800 (PST)
Received: from [192.168.3.132] (p5b0c62c6.dip0.t-ipconnect.de. [91.12.98.198])
        by smtp.gmail.com with ESMTPSA id y12sm10434324wrn.73.2021.12.06.00.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 00:15:00 -0800 (PST)
Message-ID: <959de529-503e-6dbf-b4ea-67e13252a86a@redhat.com>
Date:   Mon, 6 Dec 2021 09:15:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202123553.96412-1-david@redhat.com>
 <20211202123553.96412-3-david@redhat.com>
 <11f0ff2f-2bae-0f1b-753f-b0e9dc24b345@redhat.com>
 <20211203121819.145696b0@p-imbrenda>
 <fa95d6e6-27be-7abf-7b1e-bb6bb9d62214@redhat.com>
 <babd1100-844b-e00c-3e5b-30f7bca65636@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt
 test
In-Reply-To: <babd1100-844b-e00c-3e5b-30f7bca65636@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>>
>>>>
>>>>> +
>>>>> +	/*
>>>>> +	 * We want CPU #2 to be stopped. This should be the case at this
>>>>> +	 * point, however, we want to sense if it even exists as well.
>>>>> +	 */
>>>>> +	ret = smp_cpu_stop(2);
>>>>> +	if (ret) {
>>>>> +		report_skip("CPU #2 not found");
>>>>
>>>> Since you already queried for the availablity of at least 3 CPUs above, I
>>>> think you could turn this into a report_fail() instead?
>>>
>>> either that or an assert, but again, no strong opinions
>>>
>>
>> Just because there are >= 3 CPUs doesn't imply that CPU #2 is around.
> 
> Ok, fair point. But if #2 is not around, it means that the test has been run 
> in the wrong way by the user... I wonder what's better in that case - to 
> skip this test or to go out with a bang. Skipping the test has the advantage 
> of looking a little bit more "polite", but it has the disadvantage that it 
> might get lost in automation, e.g. if somebody enabled the test in their CI, 
> but did something wrong in the settings, they might not notice that the test 
> is not run at all...

I sticked to what we have in s390x/smp.c, where we fail if we only have
a single CPU.

But I don't particularly care (and have to move on doing other stuff),
so I'll do whatever maintainers want and resend :)

-- 
Thanks,

David / dhildenb

