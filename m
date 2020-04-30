Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4144E1BF1B4
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 09:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgD3HmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 03:42:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57171 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgD3HmP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 03:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588232533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=6DxdnzTmG5k3sWTRolIg0DGv5gwp152RefZ2We+/FzM=;
        b=TdFSnf6C8Koi1bGF7APsY9MELPKfsU0aAr1IOVBJTvrkchRtyxwfLZZoSRKH7UTvJEGpvG
        CskNz7qtORUXiF7ER+1lev1aPHwuVQNEmFAYC8knK2Aqi5LjepBadBWDfTNQftXUik0EGY
        gZ1nxW7ae9FcaZ4CW4Jvi7+X1ejzlqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-HGtXQnMYOLi0xnVWHqn_uw-1; Thu, 30 Apr 2020 03:42:11 -0400
X-MC-Unique: HGtXQnMYOLi0xnVWHqn_uw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32D5F19200C0;
        Thu, 30 Apr 2020 07:42:10 +0000 (UTC)
Received: from [10.36.113.172] (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C98415D9F1;
        Thu, 30 Apr 2020 07:42:08 +0000 (UTC)
Subject: Re: [PATCH v3 08/10] s390x: smp: Wait for sigp completion
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com
References: <20200429143518.1360468-1-frankja@linux.ibm.com>
 <20200429143518.1360468-9-frankja@linux.ibm.com>
 <6fb43d45-952e-f66b-a0b2-19d8c3f44cd5@redhat.com>
 <68e16d1a-8990-0160-307d-93e870338879@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <ec5788be-d020-6490-2fe3-7297362fe683@redhat.com>
Date:   Thu, 30 Apr 2020 09:42:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <68e16d1a-8990-0160-307d-93e870338879@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.04.20 09:40, Janosch Frank wrote:
> On 4/29/20 5:15 PM, David Hildenbrand wrote:
>> On 29.04.20 16:35, Janosch Frank wrote:
>>> Sigp orders are not necessarily finished when the processor finished
>>> the sigp instruction. We need to poll if the order has been finished
>>> before we continue.
>>>
>>> For (re)start and stop we already use sigp sense running and sigp
>>> sense loops. But we still lack completion checks for stop and store
>>> status, as well as the cpu resets.
>>>
>>> Let's add them.
>>>
>>> KVM currently needs a workaround for the stop and store status test,
>>> since KVM's SIGP Sense implementation doesn't honor pending SIGPs at
>>> it should. Hopefully we can fix that in the future.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  lib/s390x/smp.c |  9 +++++++++
>>>  lib/s390x/smp.h |  1 +
>>>  s390x/smp.c     | 12 ++++++++++--
>>>  3 files changed, 20 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>>> index 6ef0335..8628a3d 100644
>>> --- a/lib/s390x/smp.c
>>> +++ b/lib/s390x/smp.c
>>> @@ -49,6 +49,14 @@ struct cpu *smp_cpu_from_addr(uint16_t addr)
>>>  	return NULL;
>>>  }
>>>  
>>> +void smp_cpu_wait_for_completion(uint16_t addr)
>>> +{
>>> +	uint32_t status;
>>> +
>>> +	/* Loops when cc == 2, i.e. when the cpu is busy with a sigp order */
>>> +	sigp_retry(1, SIGP_SENSE, 0, &status);
>>> +}
>>> +
>>>  bool smp_cpu_stopped(uint16_t addr)
>>>  {
>>>  	uint32_t status;
>>> @@ -100,6 +108,7 @@ int smp_cpu_stop_store_status(uint16_t addr)
>>>  
>>>  	spin_lock(&lock);
>>>  	rc = smp_cpu_stop_nolock(addr, true);
>>> +	smp_cpu_wait_for_completion(addr);
>>>  	spin_unlock(&lock);
>>>  	return rc;
>>>  }
>>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
>>> index ce63a89..a8b98c0 100644
>>> --- a/lib/s390x/smp.h
>>> +++ b/lib/s390x/smp.h
>>> @@ -45,6 +45,7 @@ int smp_cpu_restart(uint16_t addr);
>>>  int smp_cpu_start(uint16_t addr, struct psw psw);
>>>  int smp_cpu_stop(uint16_t addr);
>>>  int smp_cpu_stop_store_status(uint16_t addr);
>>> +void smp_cpu_wait_for_completion(uint16_t addr);
>>>  int smp_cpu_destroy(uint16_t addr);
>>>  int smp_cpu_setup(uint16_t addr, struct psw psw);
>>>  void smp_teardown(void);
>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>> index c7ff0ee..bad2131 100644
>>> --- a/s390x/smp.c
>>> +++ b/s390x/smp.c
>>> @@ -75,7 +75,12 @@ static void test_stop_store_status(void)
>>>  	lc->prefix_sa = 0;
>>>  	lc->grs_sa[15] = 0;
>>>  	smp_cpu_stop_store_status(1);
>>> -	mb();
>>> +	/*
>>> +	 * This loop is workaround for KVM not reporting cc 2 for SIGP
>>> +	 * sense if a stop and store status is pending.
>>> +	 */
>>> +	while (!lc->prefix_sa)
>>> +		mb();
>>>  	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
>>>  	report(lc->grs_sa[15], "stack");
>>>  	report(smp_cpu_stopped(1), "cpu stopped");
>>> @@ -85,7 +90,8 @@ static void test_stop_store_status(void)
>>>  	lc->prefix_sa = 0;
>>>  	lc->grs_sa[15] = 0;
>>>  	smp_cpu_stop_store_status(1);
>>> -	mb();
>>> +	while (!lc->prefix_sa)
>>> +		mb();
>>>  	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
>>>  	report(lc->grs_sa[15], "stack");
>>>  	report_prefix_pop();
>>> @@ -215,6 +221,7 @@ static void test_reset_initial(void)
>>>  	wait_for_flag();
>>>  
>>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>> +	smp_cpu_wait_for_completion(1);
>>
>> ^ is this really helpful? The next order already properly synchronizes, no?
> 
> Well, the next order isn't issued with sigp_retry, so we could actually
> get a cc 2 on the store. I need a cpu stopped loop here as well.

... should that one then simply have a retry?

> 
>>
>>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>>>  
>>>  	report_prefix_push("clear");
>>> @@ -265,6 +272,7 @@ static void test_reset(void)
>>>  	smp_cpu_start(1, psw);
>>>  
>>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>>> +	smp_cpu_wait_for_completion(1);
>>
>> Isn't this racy for KVM as well?
>>
>> I would have expected a loop until it is actually stopped.
> 
> I'd add a loop with a comment, but also keep the wait for completion.

I don't see how the wait for completion is really useful here. The wait
for stop will do the very same then.


-- 
Thanks,

David / dhildenb

