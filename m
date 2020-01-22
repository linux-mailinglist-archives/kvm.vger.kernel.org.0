Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FDC1452A8
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 11:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgAVKcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 05:32:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20928 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729016AbgAVKct (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 05:32:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579689167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=DlobJlAnnhvvMzd91At4Q8/jXgzUWTwGBR6/4ravnCc=;
        b=ARrYxoLpYlGpnztk5jfZkQwt7ypoWqTqi9KXxY530dHyzv9pmuQtGq2vIdJB69OSwEHJCA
        qEsyCOZI5+ZAQiX1DsJ+hz7GlYq47NhUAkLxSWF1xLLHPC8sWkKaDw1TKSmxXSTCnGgV22
        Lbm3EsgDpdM6nMSu6dspddrwdi5C7dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-5iXDaEHYMXyLEG3BLEk8gQ-1; Wed, 22 Jan 2020 05:32:45 -0500
X-MC-Unique: 5iXDaEHYMXyLEG3BLEk8gQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8515C1005502;
        Wed, 22 Jan 2020 10:32:44 +0000 (UTC)
Received: from [10.36.117.205] (ovpn-117-205.ams2.redhat.com [10.36.117.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 006CB60C85;
        Wed, 22 Jan 2020 10:32:42 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 6/6] s390x: SCLP unit test
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
 <20200120184256.188698-7-imbrenda@linux.ibm.com>
 <35e59971-c09e-2808-1be6-f2ccd555c4f6@redhat.com>
 <42c5b040-733d-4e5b-0276-5b94315336bb@redhat.com>
 <e406268e-7881-f5c3-7b28-70e355765539@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAlgEEwEIAEICGwMFCQlmAYAGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl3pImkCGQEACgkQTd4Q
 9wD/g1o+VA//SFvIHUAvul05u6wKv/pIR6aICPdpF9EIgEU448g+7FfDgQwcEny1pbEzAmiw
 zAXIQ9H0NZh96lcq+yDLtONnXk/bEYWHHUA014A1wqcYNRY8RvY1+eVHb0uu0KYQoXkzvu+s
 Dncuguk470XPnscL27hs8PgOP6QjG4jt75K2LfZ0eAqTOUCZTJxA8A7E9+XTYuU0hs7QVrWJ
 jQdFxQbRMrYz7uP8KmTK9/Cnvqehgl4EzyRaZppshruKMeyheBgvgJd5On1wWq4ZUV5PFM4x
 II3QbD3EJfWbaJMR55jI9dMFa+vK7MFz3rhWOkEx/QR959lfdRSTXdxs8V3zDvChcmRVGN8U
 Vo93d1YNtWnA9w6oCW1dnDZ4kgQZZSBIjp6iHcA08apzh7DPi08jL7M9UQByeYGr8KuR4i6e
 RZI6xhlZerUScVzn35ONwOC91VdYiQgjemiVLq1WDDZ3B7DIzUZ4RQTOaIWdtXBWb8zWakt/
 ztGhsx0e39Gvt3391O1PgcA7ilhvqrBPemJrlb9xSPPRbaNAW39P8ws/UJnzSJqnHMVxbRZC
 Am4add/SM+OCP0w3xYss1jy9T+XdZa0lhUvJfLy7tNcjVG/sxkBXOaSC24MFPuwnoC9WvCVQ
 ZBxouph3kqc4Dt5X1EeXVLeba+466P1fe1rC8MbcwDkoUo65Ag0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAGJAiUEGAECAA8FAlXLn5ECGwwFCQlmAYAACgkQTd4Q
 9wD/g1qA6w/+M+ggFv+JdVsz5+ZIc6MSyGUozASX+bmIuPeIecc9UsFRatc91LuJCKMkD9Uv
 GOcWSeFpLrSGRQ1Z7EMzFVU//qVs6uzhsNk0RYMyS0B6oloW3FpyQ+zOVylFWQCzoyyf227y
 GW8HnXunJSC+4PtlL2AY4yZjAVAPLK2l6mhgClVXTQ/S7cBoTQKP+jvVJOoYkpnFxWE9pn4t
 H5QIFk7Ip8TKr5k3fXVWk4lnUi9MTF/5L/mWqdyIO1s7cjharQCstfWCzWrVeVctpVoDfJWp
 4LwTuQ5yEM2KcPeElLg5fR7WB2zH97oI6/Ko2DlovmfQqXh9xWozQt0iGy5tWzh6I0JrlcxJ
 ileZWLccC4XKD1037Hy2FLAjzfoWgwBLA6ULu0exOOdIa58H4PsXtkFPrUF980EEibUp0zFz
 GotRVekFAceUaRvAj7dh76cToeZkfsjAvBVb4COXuhgX6N4pofgNkW2AtgYu1nUsPAo+NftU
 CxrhjHtLn4QEBpkbErnXQyMjHpIatlYGutVMS91XTQXYydCh5crMPs7hYVsvnmGHIaB9ZMfB
 njnuI31KBiLUks+paRkHQlFcgS2N3gkRBzH7xSZ+t7Re3jvXdXEzKBbQ+dC3lpJB0wPnyMcX
 FOTT3aZT7IgePkt5iC/BKBk3hqKteTnJFeVIT7EC+a6YUFg=
Organization: Red Hat GmbH
Message-ID: <997a62b7-7ab7-6119-4948-e8779e639101@redhat.com>
Date:   Wed, 22 Jan 2020 11:32:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <e406268e-7881-f5c3-7b28-70e355765539@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.01.20 11:31, Thomas Huth wrote:
> On 22/01/2020 11.22, David Hildenbrand wrote:
>> On 22.01.20 11:10, David Hildenbrand wrote:
>>> On 20.01.20 19:42, Claudio Imbrenda wrote:
>>>> SCLP unit test. Testing the following:
>>>>
>>>> * Correctly ignoring instruction bits that should be ignored
>>>> * Privileged instruction check
>>>> * Check for addressing exceptions
>>>> * Specification exceptions:
>>>>   - SCCB size less than 8
>>>>   - SCCB unaligned
>>>>   - SCCB overlaps prefix or lowcore
>>>>   - SCCB address higher than 2GB
>>>> * Return codes for
>>>>   - Invalid command
>>>>   - SCCB too short (but at least 8)
>>>>   - SCCB page boundary violation
>>>>
>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  s390x/Makefile      |   1 +
>>>>  s390x/sclp.c        | 474 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  s390x/unittests.cfg |   8 +
>>>>  3 files changed, 483 insertions(+)
>>>>  create mode 100644 s390x/sclp.c
>>>>
>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>> index 3744372..ddb4b48 100644
>>>> --- a/s390x/Makefile
>>>> +++ b/s390x/Makefile
>>>> @@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
>>>>  tests += $(TEST_DIR)/stsi.elf
>>>>  tests += $(TEST_DIR)/skrf.elf
>>>>  tests += $(TEST_DIR)/smp.elf
>>>> +tests += $(TEST_DIR)/sclp.elf
>>>>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>>>  
>>>>  all: directories test_cases test_cases_binary
>>>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>>>> new file mode 100644
>>>> index 0000000..215347e
>>>> --- /dev/null
>>>> +++ b/s390x/sclp.c
>>>> @@ -0,0 +1,474 @@
>>>> +/*
>>>> + * Service Call tests
>>>> + *
>>>> + * Copyright (c) 2019 IBM Corp
>>>> + *
>>>> + * Authors:
>>>> + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>> + *
>>>> + * This code is free software; you can redistribute it and/or modify it
>>>> + * under the terms of the GNU General Public License version 2.
>>>> + */
>>>> +
>>>> +#include <libcflat.h>
>>>> +#include <asm/page.h>
>>>> +#include <asm/asm-offsets.h>
>>>> +#include <asm/interrupt.h>
>>>> +#include <sclp.h>
>>>> +
>>>> +#define PGM_NONE	1
>>>> +#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
>>>> +#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
>>>> +#define PGM_BIT_PRIV	(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
>>>> +#define MKPTR(x) ((void *)(uint64_t)(x))
>>>> +
>>>> +#define LC_SIZE (2 * PAGE_SIZE)
>>>> +
>>>> +static uint8_t pagebuf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/* scratch pages used for some tests */
>>>> +static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/* temporary lowcore for test_sccb_prefix */
>>>> +static uint8_t sccb_template[PAGE_SIZE];				/* SCCB template to be used */
>>>> +static uint32_t valid_code;						/* valid command code for READ SCP INFO */
>>>> +static struct lowcore *lc;
>>>> +
>>>> +/**
>>>> + * Perform one service call, handling exceptions and interrupts.
>>>> + */
>>>> +static int sclp_service_call_test(unsigned int command, void *sccb)
>>>> +{
>>>> +	int cc;
>>>> +
>>>> +	sclp_mark_busy();
>>>> +	sclp_setup_int();
>>>> +	cc = servc(command, __pa(sccb));
>>>> +	if (lc->pgm_int_code) {
>>>> +		sclp_handle_ext();
>>>> +		return 0;
>>>> +	}
>>>> +	if (!cc)
>>>> +		sclp_wait_busy();
>>>> +	return cc;
>>>> +}
>>>> +
>>>> +/**
>>>> + * Perform one test at the given address, optionally using the SCCB template,
>>>> + * checking for the expected program interrupts and return codes.
>>>> + *
>>>> + * The parameter buf_len indicates the number of bytes of the template that
>>>> + * should be copied to the test address, and should be 0 when the test
>>>> + * address is invalid, in which case nothing is copied.
>>>> + *
>>>> + * The template is used to simplify tests where the same buffer content is
>>>> + * used many times in a row, at different addresses.
>>>> + *
>>>> + * Returns true in case of success or false in case of failure
>>>> + */
>>>> +static bool test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>>> +{
>>>> +	SCCBHeader *h = (SCCBHeader *)addr;
>>>> +	int res, pgm;
>>>> +
>>>> +	/* Copy the template to the test address if needed */
>>>> +	if (buf_len)
>>>> +		memcpy(addr, sccb_template, buf_len);
>>>> +	if (exp_pgm != PGM_NONE)
>>>> +		expect_pgm_int();
>>>> +	/* perform the actual call */
>>>> +	res = sclp_service_call_test(cmd, h);
>>>> +	if (res) {
>>>> +		report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd, addr, res);
>>>> +		return false;
>>>> +	}
>>>> +	pgm = clear_pgm_int();
>>>> +	/* Check if the program exception was one of the expected ones */
>>>> +	if (!((1ULL << pgm) & exp_pgm)) {
>>>> +		report_info("First failure at addr %p, buf_len %d, cmd %#x, pgm code %d",
>>>> +				addr, buf_len, cmd, pgm);
>>>> +		return false;
>>>> +	}
>>>> +	/* Check if the response code is the one expected */
>>>> +	if (exp_rc && exp_rc != h->response_code) {
>>>> +		report_info("First failure at addr %p, buf_len %d, cmd %#x, resp code %#x",
>>>> +				addr, buf_len, cmd, h->response_code);
>>>> +		return false;
>>>> +	}
>>>> +	return true;
>>>> +}
>>>> +
>>>> +/**
>>>> + * Wrapper for test_one_sccb to be used when the template should not be
>>>> + * copied and the memory address should not be touched.
>>>> + */
>>>> +static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pgm, uint16_t exp_rc)
>>>> +{
>>>> +	return test_one_sccb(cmd, addr, 0, exp_pgm, exp_rc);
>>>> +}
>>>> +
>>>> +/**
>>>> + * Wrapper for test_one_sccb to set up a simple SCCB template.
>>>> + *
>>>> + * The parameter sccb_len indicates the value that will be saved in the SCCB
>>>> + * length field of the SCCB, buf_len indicates the number of bytes of
>>>> + * template that need to be copied to the actual test address. In many cases
>>>> + * it's enough to clear/copy the first 8 bytes of the buffer, while the SCCB
>>>> + * itself can be larger.
>>>> + *
>>>> + * Returns true in case of success or false in case of failure
>>>> + */
>>>> +static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
>>>> +			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>>> +{
>>>> +	memset(sccb_template, 0, sizeof(sccb_template));
>>>> +	((SCCBHeader *)sccb_template)->length = sccb_len;
>>>> +	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
>>>
>>> Doing a fresh ./configure + make on RHEL7 gives me
>>>
>>> [linux1@rhkvm01 kvm-unit-tests]$ make
>>> gcc  -std=gnu99 -ffreestanding -I /home/linux1/git/kvm-unit-tests/lib -I /home/linux1/git/kvm-unit-tests/lib/s390x -I lib -O2 -march=zEC12 -fno-delete-null-pointer-checks -g -MMD -MF s390x/.sclp.d -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror  -fomit-frame-pointer    -Wno-frame-address   -fno-pic    -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o s390x/sclp.o s390x/sclp.c
>>> s390x/sclp.c: In function 'test_one_simple':
>>> s390x/sclp.c:121:2: error: dereferencing type-punned pointer will break strict-aliasing rules [-Werror=strict-aliasing]
>>>   ((SCCBHeader *)sccb_template)->length = sccb_len;
>>>   ^
>>> s390x/sclp.c: At top level:
>>> cc1: error: unrecognized command line option "-Wno-frame-address" [-Werror]
>>> cc1: all warnings being treated as errors
>>> make: *** [s390x/sclp.o] Error 1
>>
>> The following makes it work:
>>
>>
>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>> index c13fa60..0b8117a 100644
>> --- a/s390x/sclp.c
>> +++ b/s390x/sclp.c
>> @@ -117,8 +117,10 @@ static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pgm, uint16_t
>>  static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
>>                         uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>  {
>> +       SCCBHeader *header = (void *)sccb_template;
>> +
>>         memset(sccb_template, 0, sizeof(sccb_template));
>> -       ((SCCBHeader *)sccb_template)->length = sccb_len;
>> +       header->length = sccb_len;
> 
> While that might silence the compiler warning, we still might get
> aliasing problems here, I think.
> The right way to solve this problem is to turn sccb_template into a
> union of the various structs/arrays that you want to use and then access
> the fields through the union instead ("type-punning through union").

We do have the exact same thing in lib/s390x/sclp.c already, no?

Especially, new compilers don't seem to care?

-- 
Thanks,

David / dhildenb

