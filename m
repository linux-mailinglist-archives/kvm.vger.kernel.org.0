Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C06A456E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjB0O7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjB0O7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:59:18 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE972203A;
        Mon, 27 Feb 2023 06:59:15 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id i202so2650268ioa.3;
        Mon, 27 Feb 2023 06:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3GCNwTUZB8kzZG/gYuYfLxJdLZvnUgoAzuOHI0jCdY=;
        b=S6iE4D8qfxp6Zf1z3MJFBlZvXshZkI5deCZvjwk+Ldb5nohj3XWFLrnHHGtLYjtpx5
         oU0r2v3M2QIFIGv/8jJeeU8W7jhYa+6ExZe2xNYpgzExSDhxbGewLxaIvwe/I+bMA1oq
         uO4toeIGCyx4xb4iP1v7uDywXR4F7fnjoh+z817RaSDJJXcPzQkzhPQoBfA3heXqWbGW
         6sRN+cosKJEzPmmSh1BcQqDGckK6oX2ee/3bIm/UXnoXBB4gHxEzC5oEi9eBlLD2MqZ9
         dAlTQYmOpMlb0KMqA93mffS2JIc1598FbG56zC2dOEMJELIpXTwmfGvljO3uv7kOFtHM
         Q8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3GCNwTUZB8kzZG/gYuYfLxJdLZvnUgoAzuOHI0jCdY=;
        b=bi0ff8U4b0/1G5ErkJhWN/K1exwvWtoDJjfPL3mEhUCPpKmHglRvIqEmUZF3eKVbmU
         oaeNJ4gJ2iYI+Xl13h02yb0aWs2/jN3udqqOKswn7hzaFzuSQFZ08tQsZWZqOKNB2a3S
         p2JUhhHWqWsFI63sG/S1ztR70bFUhzSMGuhgSlElQ27mhQqNIYQER+lBgysAHCC22dX5
         HLk55LNvNN0xCzh5oBQ5sclCm3cJLGtzsAhf2G2soPAybHmd8dF0r1P1wq3pQIcNP4Dq
         qxdiIWmHqznYfSudNT6HtQpQ++HhYWvCXB+hxnsEIHnwUj4sUY/gfio14t5slSYKZp1N
         pOgA==
X-Gm-Message-State: AO0yUKVfejR2uR8SaZdKbcT5ANq9AOyxAze6gadnT6oGAUNqyEm+f4Ru
        2NCD2vdGLWYJ3shuvMLjnz0=
X-Google-Smtp-Source: AK7set9dR0iQjzKlEIv6bGw6qiR9kUVSzphDuGcQaV2R+/Hhe/OK3u3U1m2vKlQLNv6dC/YksZGM7w==
X-Received: by 2002:a6b:7504:0:b0:6e9:d035:45df with SMTP id l4-20020a6b7504000000b006e9d03545dfmr15378337ioh.6.1677509954692;
        Mon, 27 Feb 2023 06:59:14 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m20-20020a92c534000000b00315813e404esm2015491ili.58.2023.02.27.06.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 06:59:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <19587ea3-e54c-e3b0-5341-eb7ee486474b@roeck-us.net>
Date:   Mon, 27 Feb 2023 06:59:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
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
 <Y/qilU0cW6ebmrnM@yury-laptop>
 <95377047-6b26-b434-fc90-2289fccc2a0b@intel.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <95377047-6b26-b434-fc90-2289fccc2a0b@intel.com>
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

On 2/27/23 06:46, Alexander Lobakin wrote:
> From: Yury Norov <yury.norov@gmail.com>
> Date: Sat, 25 Feb 2023 16:06:45 -0800
> 
>> On Sat, Feb 25, 2023 at 04:05:02PM -0800, Yury Norov wrote:
>>> On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
>>>> Hi,
>>>>
>>>> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
>>>>> Test newly added bitmap_{from,to}_arr64() functions similarly to
>>>>> already existing bitmap_{from,to}_arr32() tests.
>>>>>
>>>>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
>>>>
>>>> Ever since this test is in the tree, several of my boot tests show
>>>> lots of messages such as
>>>>
>>>> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> 
> Hmmm, the whole 4 bytes weren't touched.
> 
>>>> test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
>>>> test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
> 
> This is where it gets worse...
> 
>>>> ...
>>>> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
>>>> test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)
> 
> I don't see the pattern how the actual result gets generated. But the
> problem is in the bitmap code rather than in the subtest -- "must be"s
> are fully correct.
> 
> Given that the 0xa5s are present in the upper 32 bits, it is Big Endian
> I guess? Maybe even 32-bit Big Endian? Otherwise I'd start concerning
> how comes it doesn't reproduce on x86_64s :D
> 

It does reproduce on 32-bit x86 builds, and as far as I can see
it is only seen with 32-bit little endian systems.

Guenter

>>>
>>> This may be a real problem. Can you share what's the system is? What's
>>> endianness and register length?
>>>
>>> + Alexander Lobakin, the author of the exact subtest.
>>
>> Forgot to add
> 
> Oh, thanks for letting me know!
> 
>>    
>>>> but then:
>>>>
>>>> test_bitmap: all 6550 tests passed
>>>
>>> It's because corresponding error path doesn't increment failed_tests
>>> counter. I'll send a fix shortly.
> 
> [...]
> 
> Thanks,
> Olek

