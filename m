Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D93CBDF14
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406601AbfIYNfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406589AbfIYNfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:35:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C92D30833A8;
        Wed, 25 Sep 2019 13:35:20 +0000 (UTC)
Received: from [10.36.117.14] (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98CB260BF1;
        Wed, 25 Sep 2019 13:35:19 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: SMP test
From:   David Hildenbrand <david@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-7-frankja@linux.ibm.com>
 <b8b574a0-aa5d-7a10-ccd3-d901bf2e0655@redhat.com>
 <df219ca6-b772-cfcb-2c9b-e53fe5b2c8b8@redhat.com>
 <4afbfdca-e028-4bb8-0ed0-41f907e9acf3@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <292dc9d3-c45c-8eb5-4f79-05572b84060d@redhat.com>
Date:   Wed, 25 Sep 2019 15:35:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4afbfdca-e028-4bb8-0ed0-41f907e9acf3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 25 Sep 2019 13:35:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.09.19 15:32, David Hildenbrand wrote:
> On 25.09.19 15:30, Thomas Huth wrote:
>> On 25/09/2019 15.27, David Hildenbrand wrote:
>>> On 20.09.19 10:03, Janosch Frank wrote:
>>>> Testing SIGP emulation for the following order codes:
>>>> * start
>>>> * stop
>>>> * restart
>>>> * set prefix
>>>> * store status
>>>> * stop and store status
>>>> * reset
>>>> * initial reset
>>>> * external call
>>>> * emegergency call
>>>>
>>>> restart and set prefix are part of the library and needed to start
>>>> other cpus.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  s390x/Makefile      |   1 +
>>>>  s390x/smp.c         | 242 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  s390x/unittests.cfg |   4 +
>>>>  3 files changed, 247 insertions(+)
>>>>  create mode 100644 s390x/smp.c
>>>>
>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>> index d83dd0b..3744372 100644
>>>> --- a/s390x/Makefile
>>>> +++ b/s390x/Makefile
>>>> @@ -15,6 +15,7 @@ tests += $(TEST_DIR)/cpumodel.elf
>>>>  tests += $(TEST_DIR)/diag288.elf
>>>>  tests += $(TEST_DIR)/stsi.elf
>>>>  tests += $(TEST_DIR)/skrf.elf
>>>> +tests += $(TEST_DIR)/smp.elf
>>>>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>>>  
>>>>  all: directories test_cases test_cases_binary
>>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>>> new file mode 100644
>>>> index 0000000..7032494
>>>> --- /dev/null
>>>> +++ b/s390x/smp.c
>>>> @@ -0,0 +1,242 @@
>>>> +/*
>>>> + * Tests sigp emulation
>>>> + *
>>>> + * Copyright 2019 IBM Corp.
>>>> + *
>>>> + * Authors:
>>>> + *    Janosch Frank <frankja@linux.ibm.com>
>>>> + *
>>>> + * This code is free software; you can redistribute it and/or modify it
>>>> + * under the terms of the GNU General Public License version 2.
>>>> + */
>>>> +#include <libcflat.h>
>>>> +#include <asm/asm-offsets.h>
>>>> +#include <asm/interrupt.h>
>>>> +#include <asm/page.h>
>>>> +#include <asm/facility.h>
>>>> +#include <asm-generic/barrier.h>
>>>> +#include <asm/sigp.h>
>>>> +
>>>> +#include <smp.h>
>>>> +#include <alloc_page.h>
>>>> +
>>>> +static int testflag = 0;
>>>> +
>>>> +static void cpu_loop(void)
>>>> +{
>>>> +	for (;;) {}
>>>
>>> Won't that be optimized out completely?
>>
>> Why? AFAIK this is the standard way to write and endless loop ... how
>> can a compiler optimize that away?
> 
> Was messing it up with "just" an empty loop body, I think you're right.
> 

However

https://stackoverflow.com/questions/2178115/are-compilers-allowed-to-eliminate-infinite-loops

"This is intended to allow compiler transformations such as removal of
empty loops even when termination cannot be proven."

I think this might get optimized out.

-- 

Thanks,

David / dhildenb
