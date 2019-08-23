Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF219AE33
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbfHWLge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:36:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfHWLgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:36:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1ED1253121;
        Fri, 23 Aug 2019 11:36:33 +0000 (UTC)
Received: from [10.36.117.2] (ovpn-117-2.ams2.redhat.com [10.36.117.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CDD060605;
        Fri, 23 Aug 2019 11:36:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add diag308 subcode 0 testing
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190821104736.1470-1-frankja@linux.ibm.com>
 <20190822111100.4444-1-frankja@linux.ibm.com>
 <34c8d077-fc5e-1d62-f946-17d067573c23@redhat.com>
 <72f07777-0f11-5cbe-da37-ace2ddfce78c@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <1f8a9de0-1ed7-205e-729e-cb543cdb90c5@redhat.com>
Date:   Fri, 23 Aug 2019 13:36:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <72f07777-0f11-5cbe-da37-ace2ddfce78c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 23 Aug 2019 11:36:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.08.19 13:33, Janosch Frank wrote:
> On 8/23/19 1:00 PM, David Hildenbrand wrote:
>> On 22.08.19 13:11, Janosch Frank wrote:
>>> By adding a load reset routine to cstart.S we can also test the clear
>>> reset done by subcode 0, as we now can restore our registers again.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>> I managed to extract this from another bigger test, so let's add it to the bunch.
>>> I'd be very happy about assembly review :-)
>>> ---
>>>  s390x/cstart64.S | 27 +++++++++++++++++++++++++++
>>>  s390x/diag308.c  | 31 ++++++++++---------------------
>>>  2 files changed, 37 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>> index dedfe80..47045e1 100644
>>> --- a/s390x/cstart64.S
>>> +++ b/s390x/cstart64.S
>>> @@ -145,6 +145,33 @@ memsetxc:
>>>  	.endm
>>>  
>>>  .section .text
>>> +/*
>>> + * load_reset calling convention:
>>> + * %r2 subcode (0 or 1)
>>> + */
>>> +.globl load_reset
>>> +load_reset:
>>> +	SAVE_REGS
>>> +	/* Save the first PSW word to the IPL PSW */
>>> +	epsw	%r0, %r1
>>> +	st	%r0, 0
>>> +	/* Store the address and the bit for 31 bit addressing */
>>> +	larl    %r0, 0f
>>> +	oilh    %r0, 0x8000
>>> +	st      %r0, 0x4
>>> +	/* Do the reset */
>>> +	diag    %r0,%r2,0x308
>>> +	/* Failure path */
>>> +	xgr	%r2, %r2
>>> +	br	%r14
>>> +	/* Success path */
>>> +	/* We lost cr0 due to the reset */
>>> +0:	larl	%r1, initial_cr0
>>> +	lctlg	%c0, %c0, 0(%r1)
>>> +	RESTORE_REGS
>>> +	lhi	%r2, 1
>>> +	br	%r14
>>> +
>>>  pgm_int:
>>>  	SAVE_REGS
>>>  	brasl	%r14, handle_pgm_int
>>> diff --git a/s390x/diag308.c b/s390x/diag308.c
>>> index f085b1a..baf9fd3 100644
>>> --- a/s390x/diag308.c
>>> +++ b/s390x/diag308.c
>>> @@ -21,32 +21,20 @@ static void test_priv(void)
>>>  	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>>>  }
>>>  
>>> +
>>>  /*
>>> - * Check that diag308 with subcode 1 loads the PSW at address 0, i.e.
>>> + * Check that diag308 with subcode 0 and 1 loads the PSW at address 0, i.e.
>>>   * that we can put a pointer into address 4 which then gets executed.
>>>   */
>>> +extern int load_reset(u64);
>>> +static void test_subcode0(void)
>>> +{
>>> +	report("load modified clear done", load_reset(0));
>>> +}
>>> +
>>>  static void test_subcode1(void)
>>>  {
>>> -	uint64_t saved_psw = *(uint64_t *)0;
>>> -	long subcode = 1;
>>> -	long ret, tmp;
>>> -
>>> -	asm volatile (
>>> -		"	epsw	%0,%1\n"
>>> -		"	st	%0,0\n"
>>> -		"	larl	%0,0f\n"
>>> -		"	oilh	%0,0x8000\n"
>>> -		"	st	%0,4\n"
>>> -		"	diag	0,%2,0x308\n"
>>> -		"	lghi	%0,0\n"
>>> -		"	j	1f\n"
>>> -		"0:	lghi	%0,1\n"
>>> -		"1:"
>>> -		: "=&d"(ret), "=&d"(tmp) : "d"(subcode) : "memory");
>>> -
>>> -	*(uint64_t *)0 = saved_psw;
>>> -
>>> -	report("load normal reset done", ret == 1);
>>> +	report("load normal reset done", load_reset(1));
>>>  }
>>>  
>>>  /* Expect a specification exception when using an uneven register */
>>> @@ -107,6 +95,7 @@ static struct {
>>>  	void (*func)(void);
>>>  } tests[] = {
>>>  	{ "privileged", test_priv },
>>> +	{ "subcode 0", test_subcode0 },
>>>  	{ "subcode 1", test_subcode1 },
>>>  	{ "subcode 5", test_subcode5 },
>>>  	{ "subcode 6", test_subcode6 },
>>>
>>
>> So, in general I am wondering if we should restore the original IPL_PSW
>> after we used it - is there any chance we might require the old value
>> again (I guess we're fine with cpu resets)?
> 
> I currently don't see a need, but we could cache it in the restart old
> psw address. Or we just store back the two word constant.
> 

If there's no need right no, I guess we can skip that. Was just wondering.


-- 

Thanks,

David / dhildenb
