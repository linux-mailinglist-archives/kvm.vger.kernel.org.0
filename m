Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569576A2CD8
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 01:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBZAmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 19:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBZAmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 19:42:23 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7004158BF;
        Sat, 25 Feb 2023 16:42:19 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id y184so2567158oiy.8;
        Sat, 25 Feb 2023 16:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vqR8kMH8N8ZUldMBakO+fuxfrqtewrnxRblVc35UfD8=;
        b=D73s6uhirVM43CmtpxoNBPU0reDdA+KFDsxMwcsetcWH8+AmgkOwQSkaBVktCTEuZQ
         cWAPPmpELJN0ns7QhgKYYa8FtfxXGhDlAJGWdg8AYmvgIvdk8hn/AKabl5+mFPzzeMvj
         igQCmonfOG0k0ErG/FlHsrBz9VOR6h1m9n4EVptqKrAt6cUgrDk8AULk4TW0ouYoIbSP
         Pwpudim+4D2yEWAm/DXKPcBONhd59a9FwH2zF+MGDAyM+uc0bb9EsHWmLkAxOnu5Iu7L
         nHNYD006BaqkrXtJTRDSpnJr1vNpmh2Dz+PWhosyWQUE7diTDtVoNc/b5WJq0pewq3//
         k9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqR8kMH8N8ZUldMBakO+fuxfrqtewrnxRblVc35UfD8=;
        b=nZ8O8ooRD8hxJbtAUKRDYBmCI60M5yGS1+jLWS7fTG7Ovq3dsSgWtFTjr0TliFMalL
         u58+Jj/r7UOAUXh6p8R7E3rPrEjt3rvY7TMxhUuMX5lVMEyzWQAvMadMK5+jWKqoZUK6
         OfGbSbXYtaASEaJizvsdNvLf3c55d7eUfZHII/ajXxXMBBxm7YGqMl8BDUi4gfSEkT7L
         2DLKNeW8m9gytc6ynDBH6CXmi1VNLoRysR6MJyaTgwAS7eIbaQmUk1+JDbtldoRw4C8/
         f4pR246oprogeyr5ez2CPlSDriMgiWbrbVORcphFhkkcOzyNPYSBNXoPuY+OBcn0Mvf8
         NNKw==
X-Gm-Message-State: AO0yUKVPDl06FvmmVP7IRX2yLYGB45ZYlwoTeBg7CLP0yaQtnWBwYyKW
        wX0RZOUmKQfBz8Re7Ckm5zU=
X-Google-Smtp-Source: AK7set+e5+VTpITDEr4HeSf1IjPvczLluTV+P6OjRl87fjfm18XAEB2Qe4hHrmzbQ5RMdIbkpOEGBA==
X-Received: by 2002:a05:6808:2a09:b0:37f:a72c:257e with SMTP id ez9-20020a0568082a0900b0037fa72c257emr7118772oib.14.1677372138764;
        Sat, 25 Feb 2023 16:42:18 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i5-20020acaea05000000b00383b8084203sm1431047oih.26.2023.02.25.16.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 16:42:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <996a23fa-5ddf-4562-8675-5caeecc6368f@roeck-us.net>
Date:   Sat, 25 Feb 2023 16:42:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20230225184702.GA3587246@roeck-us.net> <Y/qhL8kSzzhMm+tO@yury-laptop>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
In-Reply-To: <Y/qhL8kSzzhMm+tO@yury-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/23 16:04, Yury Norov wrote:
> On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
>> Hi,
>>
>> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
>>> Test newly added bitmap_{from,to}_arr64() functions similarly to
>>> already existing bitmap_{from,to}_arr32() tests.
>>>
>>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
>>
>> Ever since this test is in the tree, several of my boot tests show
>> lots of messages such as
>>
>> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
>> test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
>> test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
>> ...
>> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
>> test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)
> 
> This may be a real problem. Can you share what's the system is? What's
> endianness and register length?
> 

https://kerneltests.org/builders/qemu-arm-v7-master/builds/532/steps/qemubuildcommand/logs/stdio
https://kerneltests.org/builders/qemu-arm-next/builds/2086/steps/qemubuildcommand/logs/stdio

are examples from different arm machines.

https://kerneltests.org/builders/qemu-xtensa-master/builds/2178/steps/qemubuildcommand/logs/stdio

is an example from xtensa.

https://kerneltests.org/builders/qemu-x86-master/builds/2248/steps/qemubuildcommand/logs/stdio

is an example from a 32-bit x86 test.

I am sure there are others; I only notice the messages if there is some other problem,
and came to believe that they must be noise because it happens across several
architectures and because it claimed at the end that all tests passed.

Just to confirm, I ran a test with big and little endian mips machines.
The problem is only seen with the little endian 32-bit machine. It is not
seen with the 32-bit big endian machine, and it is not seen with any of
the 64-bit machines (big and little endian).

Guenter

> + Alexander Lobakin, the author of the exact subtest.
>   
>> but then:
>>
>> test_bitmap: all 6550 tests passed
> 
> It's because corresponding error path doesn't increment failed_tests
> counter. I'll send a fix shortly.
> 
>>
>> The message suggests an error, given that it is displayed with pr_err,
>> but the summary suggests otherwise.
>>
>> Is the message just noise, or is there a problem ?
>>
>> Thanks,
>> Guenter
>>
>>> ---
>>>   lib/test_bitmap.c | 25 +++++++++++++++++++++++++
>>>   1 file changed, 25 insertions(+)
>>>
>>> diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
>>> index 0c82f07f74fc..d5923a640457 100644
>>> --- a/lib/test_bitmap.c
>>> +++ b/lib/test_bitmap.c
>>> @@ -585,6 +585,30 @@ static void __init test_bitmap_arr32(void)
>>>   	}
>>>   }
>>>   
>>> +static void __init test_bitmap_arr64(void)
>>> +{
>>> +	unsigned int nbits, next_bit;
>>> +	u64 arr[EXP1_IN_BITS / 64];
>>> +	DECLARE_BITMAP(bmap2, EXP1_IN_BITS);
>>> +
>>> +	memset(arr, 0xa5, sizeof(arr));
>>> +
>>> +	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
>>> +		memset(bmap2, 0xff, sizeof(arr));
>>> +		bitmap_to_arr64(arr, exp1, nbits);
>>> +		bitmap_from_arr64(bmap2, arr, nbits);
>>> +		expect_eq_bitmap(bmap2, exp1, nbits);
>>> +
>>> +		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
>>> +		if (next_bit < round_up(nbits, BITS_PER_LONG))
>>> +			pr_err("bitmap_copy_arr64(nbits == %d:"
>>> +				" tail is not safely cleared: %d\n", nbits, next_bit);
>>> +
>>> +		if (nbits < EXP1_IN_BITS - 64)
>>> +			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
>>> +	}
>>> +}
>>> +
>>>   static void noinline __init test_mem_optimisations(void)
>>>   {
>>>   	DECLARE_BITMAP(bmap1, 1024);
>>> @@ -852,6 +876,7 @@ static void __init selftest(void)
>>>   	test_copy();
>>>   	test_replace();
>>>   	test_bitmap_arr32();
>>> +	test_bitmap_arr64();
>>>   	test_bitmap_parse();
>>>   	test_bitmap_parselist();
>>>   	test_bitmap_printlist();
>>> -- 
>>> 2.32.0
>>>

