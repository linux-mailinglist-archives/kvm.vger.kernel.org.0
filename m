Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE551274A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 07:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfECFtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 01:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfECFtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 01:49:32 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3DB5307DAAA;
        Fri,  3 May 2019 05:49:31 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-70.ams2.redhat.com [10.36.116.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62986423D;
        Fri,  3 May 2019 05:49:30 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] powerpc: Allow for a custom decr value to
 be specified to load on decr excp
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, dgibson@redhat.com
References: <20190501070039.2903-1-sjitindarsingh@gmail.com>
 <ec8d1a58-e066-f61a-ad28-92b82fccdbff@redhat.com>
 <1556837714.1887.3.camel@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; keydata=
 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
Organization: Red Hat
Message-ID: <02ba90f9-df08-c696-1913-1ebb80f00bad@redhat.com>
Date:   Fri, 3 May 2019 07:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556837714.1887.3.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 03 May 2019 05:49:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 00.55, Suraj Jitindar Singh wrote:
> On Thu, 2019-05-02 at 10:01 +0200, Laurent Vivier wrote:
>> On 01/05/2019 09:00, Suraj Jitindar Singh wrote:
>>> Currently the handler for a decrementer exception will simply
>>> reload the
>>> maximum value (0x7FFFFFFF), which will take ~4 seconds to expire
>>> again.
>>> This means that if a vcpu cedes, it will be ~4 seconds between
>>> wakeups.
>>>
>>> The h_cede_tm test is testing a known breakage when a guest cedes
>>> while
>>> suspended. To be sure we cede 500 times to check for the bug.
>>> However
>>> since it takes ~4 seconds to be woken up once we've ceded, we only
>>> get
>>> through ~20 iterations before we reach the 90 seconds timeout and
>>> the
>>> test appears to fail.
>>>
>>> Add an option when registering the decrementer handler to specify
>>> the
>>> value which should be reloaded by the handler, allowing the timeout
>>> to be
>>> chosen.
>>>
>>> Modify the spr test to use the max timeout to preserve existing
>>> behaviour.
>>> Modify the h_cede_tm test to use a 10ms timeout to ensure we can
>>> perform
>>> 500 iterations before hitting the 90 second time limit for a test.
>>>
>>> This means the h_cede_tm test now succeeds rather than timing out.
>>>
>>> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
>>> ---
>>>   lib/powerpc/handlers.c | 7 ++++---
>>>   powerpc/sprs.c         | 3 ++-
>>>   powerpc/tm.c           | 3 ++-
>>>   3 files changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
>>> index be8226a..c8721e0 100644
>>> --- a/lib/powerpc/handlers.c
>>> +++ b/lib/powerpc/handlers.c
>>> @@ -12,11 +12,12 @@
>>>   
>>>   /*
>>>    * Generic handler for decrementer exceptions (0x900)
>>> - * Just reset the decrementer back to its maximum value
>>> (0x7FFFFFFF)
>>> + * Just reset the decrementer back to the value specified when
>>> registering the
>>> + * handler
>>>    */
>>> -void dec_except_handler(struct pt_regs *regs __unused, void *data
>>> __unused)
>>> +void dec_except_handler(struct pt_regs *regs __unused, void *data)
>>>   {
>>> -	uint32_t dec = 0x7FFFFFFF;
>>> +	uint64_t dec = *((uint64_t *) data);
>>>   
>>>   	asm volatile ("mtdec %0" : : "r" (dec));
>>>   }
>>> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
>>> index 6744bd8..3bd6ac7 100644
>>> --- a/powerpc/sprs.c
>>> +++ b/powerpc/sprs.c
>>> @@ -253,6 +253,7 @@ int main(int argc, char **argv)
>>>   		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
>>>   		-1ULL,
>>>   	};
>>> +	uint64_t decr = 0x7FFFFFFF;

Declare the variable as "static", please, otherwise the pointer to it
might get invalid at the end of the function.

>>>   	for (i = 1; i < argc; i++) {
>>>   		if (!strcmp(argv[i], "-w")) {
>>> @@ -288,7 +289,7 @@ int main(int argc, char **argv)
>>>   		(void) getchar();
>>>   	} else {
>>>   		puts("Sleeping...\n");
>>> -		handle_exception(0x900, &dec_except_handler,
>>> NULL);
>>> +		handle_exception(0x900, &dec_except_handler,
>>> &decr);
>>>   		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
>>>   		hcall(H_CEDE);
>>>   	}
>>> diff --git a/powerpc/tm.c b/powerpc/tm.c
>>> index bd56baa..0f3f543 100644
>>> --- a/powerpc/tm.c
>>> +++ b/powerpc/tm.c
>>> @@ -95,11 +95,12 @@ static bool enable_tm(void)
>>>   static void test_h_cede_tm(int argc, char **argv)
>>>   {
>>>   	int i;
>>> +	uint64_t decr = 0x3FFFFF;

"static" please.

>>>   	if (argc > 2)
>>>   		report_abort("Unsupported argument: '%s'",
>>> argv[2]);
>>>   
>>> -	handle_exception(0x900, &dec_except_handler, NULL);
>>> +	handle_exception(0x900, &dec_except_handler, &decr);
>>
>> Maybe you should also need here:
>>
>>      asm volatile ("mtdec %0" : : "r" (decr));
>>
>> To set the first one to the same values as the following ones?
> 
> I guess we could get a case where the decrementer is really large (if
> large decrementer is enabled for example) and otherwise we just don't
> wake up...
> 
> In practise I'm not sure. But I'll add it if you like

I think I agree with Laurent - it's likely better to add the mtdec here.

Also, while you're at it, could/should we maybe remove the "nodefault"
in unittests.cfg again (or rather the whole "groups" line)? I'm really
afraid that this test does not get enough test coverage due to this...

 Thomas
