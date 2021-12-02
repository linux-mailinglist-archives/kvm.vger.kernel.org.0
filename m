Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BBE46621F
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357220AbhLBLQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:16:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233144AbhLBLQe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638443592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zDx7pyskBIHWNmIa7jFxsgFUTyyGtRftiQzsPbzbtNA=;
        b=P/4vKxMlXMmk3XGcqk8TdEqSDZJXh7nXy2d0ipf/hon+lDzUmhqOWVZ2u/HgzHvudX0i2l
        KjuztmnRHrm0OQmTSS1aNsJspBXKUqd9XTSDL1Y8dyXR+eNjpMTmNwbKrQotafV/MTL5Ep
        JaFhBtJeNoqQAw3HUh5zBCpp5hr3lI4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-So8ULs3TPF-7N1j3Ihn92g-1; Thu, 02 Dec 2021 06:13:11 -0500
X-MC-Unique: So8ULs3TPF-7N1j3Ihn92g-1
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso1516154wms.4
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:13:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=zDx7pyskBIHWNmIa7jFxsgFUTyyGtRftiQzsPbzbtNA=;
        b=dD6RZBVN1sNElNbK3YI9odm49LcmkPfIOW6YzHkZt3Pvy2OVShOaacYWc9Om07qrtn
         XfYRodn1Dj4TKbIlNfN4cm+j2y5fAetJ7TBEFOCdKGuXZjRw5h/0QgViihMWwZXAoKH5
         vdYEWaVeZV76IA5nfSlKNAvUjOuKqpsLRqYZVxcV4briZO3VfF5KW2NT8XCeCXnmDkqv
         j1C2OwmiBj8YEXpsEKDlUPklEjHqPmSldKvhIhDOH/928a+0JhQmS9JQPPPjQbaC97jJ
         c4Xqkc+9uSe87IIV9YZEno6Hs5bnGMhWRIieGbCWIwA2s61ydv7E2uVGYtAiRSh8Tehp
         Qd/Q==
X-Gm-Message-State: AOAM531Us2tzbTm75X9Zpwmcg14BmimVRyj0MqC+SIF3Z9LOlENlUlTZ
        cMcBJDTq776n6iJR6bjLlLOwgXyE+7HlukeXzYFLQqBOaQXRJZ7N28wnU3ELz8ugcEhonaWxYBw
        njW+qgMRoKjq4
X-Received: by 2002:adf:aa08:: with SMTP id p8mr13699009wrd.572.1638443590171;
        Thu, 02 Dec 2021 03:13:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzObIE/bfAsh/wgaVECiwfDHjoqoOJjiYXV4XCikcLWWPCsFub6kr0pn3SA7/j8ZQURAjT1w==
X-Received: by 2002:adf:aa08:: with SMTP id p8mr13698979wrd.572.1638443589924;
        Thu, 02 Dec 2021 03:13:09 -0800 (PST)
Received: from ?IPV6:2003:d8:2f44:9200:3344:447e:353c:bf0b? (p200300d82f4492003344447e353cbf0b.dip0.t-ipconnect.de. [2003:d8:2f44:9200:3344:447e:353c:bf0b])
        by smtp.gmail.com with ESMTPSA id r17sm1940286wmq.5.2021.12.02.03.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 03:13:09 -0800 (PST)
Message-ID: <95160439-2aa9-765f-9f06-16952e42a495@redhat.com>
Date:   Thu, 2 Dec 2021 12:13:08 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: firq: floating interrupt
 test
In-Reply-To: <20211202120113.2dd279a8@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> +static void wait_for_sclp_int(void)
>> +{
>> +	/* Enable SCLP interrupts on this CPU only. */
>> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
>> +
>> +	set_flag(1);
> 
> why not just WRITE_ONCE/READ_ONCE?

Because I shamelessly copied that from s390x/smp.c ;)

>> +	set_flag(0);
>> +
>> +	/* Start CPU #1 and let it wait for the interrupt. */
>> +	psw.mask = extract_psw_mask();
>> +	psw.addr = (unsigned long)wait_for_sclp_int;
>> +	ret = smp_cpu_setup(1, psw);
>> +	if (ret) {
>> +		report_skip("cpu #1 not found");
> 
> ...which means that this will hang, and so will all the other report*
> functions. maybe you should manually unset the flag before calling the
> various report* functions.

Good point, thanks!

> 
>> +		goto out;
>> +	}
>> +
>> +	/* Wait until the CPU #1 at least enabled SCLP interrupts. */
>> +	wait_for_flag();
>> +
>> +	/*
>> +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
>> +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
>> +	 * wait state.
>> +	 *
>> +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
>> +	 * until not reported as running -- after all, our SCLP processing
>> +	 * will take some time as well and make races very rare.
>> +	 */
>> +	while(smp_sense_running_status(1));
>> +
>> +	h = alloc_page();
> 
> do you really need to dynamically allocate one page?
> is there a reason for not using a simple static buffer? (which you can
> have aligned and statically initialized)

I don't really have a strong opinion. I do prefer dynamic alloctions,
though, if there isn't a good reason not to use them. No need to mess
with page alignments manually.

> 
>> +	memset(h, 0, sizeof(*h));
> 
> otherwise, if you really want to allocate the memory, get rid of the
> memset; the allocator always returns zeroed memory (unless you
> explicitly ask not to by using flags)

Right. "special" FLAG_DONTZERO in that semantics in that allocator.

> 
>> +	h->length = 4096;
>> +	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
>> +	if (ret) {
>> +		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
>> +		goto out_destroy;
>> +	}
>> +
>> +	/*
>> +	 * Wait until the interrupt gets delivered on CPU #1, marking the
> 
> why do you expect the interrupt to be delivered on CPU1? could it not
> be delivered on CPU0?

We don't enable SCLP interrupts + external interrupts on CPU #0 because
we'll only call sclp_setup_int() on CPU #1.

> 
>> +	 * SCLP requests as done.
>> +	 */
>> +	sclp_wait_busy();
> 
> this is logically not wrong (and should stay, because it makes clear
> what you are trying to do), but strictly speaking it's not needed since
> the report below will hang as long as the SCLP busy flag is set. 

Right. But it's really clearer to just have this in the code.


-- 
Thanks,

David / dhildenb

