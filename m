Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6474746639C
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 13:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhLBM2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 07:28:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbhLBM2K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 07:28:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638447887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C83xi4fA5c9VsOduJ5B6diglBp8tOL6i14NDXgQQbrc=;
        b=jIkazDCnKzru/CMW8+Fq6mmKWE2NdgElrfrujoTn4SYbCShn6oiz0vh2Z3skl8gXVbNmao
        BaF5TiIESo4LeLd/zyiaFeAxVG0JJxQ2tHZKPwAL4BJlXVv1hBYYPB2SM2jIxl+0qntzaV
        S3Ljny86V2jvmGVOgnqwf9D/nNMlbcU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-wIoDVmsjOfKc6PGnvhVw7A-1; Thu, 02 Dec 2021 07:24:46 -0500
X-MC-Unique: wIoDVmsjOfKc6PGnvhVw7A-1
Received: by mail-wr1-f70.google.com with SMTP id q15-20020adfbb8f000000b00191d3d89d09so5002892wrg.3
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 04:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=C83xi4fA5c9VsOduJ5B6diglBp8tOL6i14NDXgQQbrc=;
        b=8QWlolvHbdffk4OkfTvh1U7GFSFs+CvEhWWnqXlwhl8ZgQNZnZLOMsIfyPuk+SXGrU
         ZMB/iGFQyahOUm7Ao125k2aHhsUlO4Xoz+qKxaBS4aFncTfBA5u6M2yTLtm6EbPT3xvM
         4Q1Y4W5xirZ08aid8MfZFGw+pc+RxIvk+G9xJY3NXnUB/qKQx+c5F4TxQ6qcJy9KtyJq
         HR012f1EAqW4Irc1tKiA40v4/Ib1QtzUQJg1VWG0r0f0vhovOxZ+7YgwgFQku0tLUJnz
         oc2Kyp7RfZXb5yqKmWdXyum3qxKCDa9KihDyQtVrGkw/vy0p7F3ftmCh26wFW+IMkZTS
         HHbg==
X-Gm-Message-State: AOAM5305oNzVj4XbfD2yLxKPwm+e0aYjjjekkCORUeUK7nM24NP4n//A
        S8522fst0TfQkti5YgkTjK1N+WGSjvMEolbFo8brUomkbVcB+qTLHtn18UwLYnC76KyKovY5Dhr
        q7uAgGxBXYDO5
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr14502087wri.355.1638447885532;
        Thu, 02 Dec 2021 04:24:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0ATnccPs1quG6qncUu/rpRiNBrxbpTwki4yRfNM7Ghe63iAYViItB1swDuehAYUx/iGg+XQ==
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr14502057wri.355.1638447885273;
        Thu, 02 Dec 2021 04:24:45 -0800 (PST)
Received: from ?IPV6:2003:d8:2f44:9200:3344:447e:353c:bf0b? (p200300d82f4492003344447e353cbf0b.dip0.t-ipconnect.de. [2003:d8:2f44:9200:3344:447e:353c:bf0b])
        by smtp.gmail.com with ESMTPSA id i7sm1267178wro.58.2021.12.02.04.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 04:24:44 -0800 (PST)
Message-ID: <0a708f46-d1fe-9a76-c1c7-76cd0ed74776@redhat.com>
Date:   Thu, 2 Dec 2021 13:24:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202095843.41162-1-david@redhat.com>
 <20211202095843.41162-3-david@redhat.com>
 <20211202120113.2dd279a8@p-imbrenda>
 <95160439-2aa9-765f-9f06-16952e42a495@redhat.com>
 <20211202130728.72570680@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: firq: floating interrupt
 test
In-Reply-To: <20211202130728.72570680@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.12.21 13:07, Claudio Imbrenda wrote:
> On Thu, 2 Dec 2021 12:13:08 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>>>> +static void wait_for_sclp_int(void)
>>>> +{
>>>> +	/* Enable SCLP interrupts on this CPU only. */
>>>> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
>>>> +
>>>> +	set_flag(1);  
>>>
>>> why not just WRITE_ONCE/READ_ONCE?  
>>
>> Because I shamelessly copied that from s390x/smp.c ;)
>>
>>>> +	set_flag(0);
>>>> +
>>>> +	/* Start CPU #1 and let it wait for the interrupt. */
>>>> +	psw.mask = extract_psw_mask();
>>>> +	psw.addr = (unsigned long)wait_for_sclp_int;
>>>> +	ret = smp_cpu_setup(1, psw);
>>>> +	if (ret) {
>>>> +		report_skip("cpu #1 not found");  
>>>
>>> ...which means that this will hang, and so will all the other report*
>>> functions. maybe you should manually unset the flag before calling the
>>> various report* functions.  
>>
>> Good point, thanks!
>>
>>>   
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	/* Wait until the CPU #1 at least enabled SCLP interrupts. */
>>>> +	wait_for_flag();
>>>> +
>>>> +	/*
>>>> +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
>>>> +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
>>>> +	 * wait state.
>>>> +	 *
>>>> +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
>>>> +	 * until not reported as running -- after all, our SCLP processing
>>>> +	 * will take some time as well and make races very rare.
>>>> +	 */
>>>> +	while(smp_sense_running_status(1));
> 
> if you wait here for CPU1 to be in wait state, then why did you need to
> wait until it has set the flag earlier? can't you just wait here and not
> use the whole wait_for_flag logic? smp_cpu_setup only returns after the
> new CPU has started running.

I use the flag right now as a mechanism to make the race window as short
as possible. But you're right, we might not need the flag logic as
knowing that we processed the setup part and will jump/jumped to the
target code might be good enough.

Thanks!

-- 
Thanks,

David / dhildenb

