Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA266A4C0B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 21:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjB0UMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 15:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjB0UMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 15:12:07 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76AE1B2D7;
        Mon, 27 Feb 2023 12:12:05 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id b12so4697081ils.8;
        Mon, 27 Feb 2023 12:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=orqc7aIResxBe03vCpBeboci/UnZToSoRQ+wlArEs+E=;
        b=TqFpKZkcHp4kG/PR3AMItIwNSgzMQ+pl0Mwb+uobHec2diBUP+hanuh06HoTlHgqoK
         jyUVeUhYJcQ8rmywJs8DsPkvJ2be8Ra3j8GaG67Q6P99B0Q3qJGg9J5ce4SSBaJbxzOK
         1w1CvTovX9BYDcI0zKoZHowj8DPGDyJI+LQmjBSkWweagfzmvhzoGfV5aZ48WRoAI0rd
         R7+i1XGhnPp+8/RiRTwtZ5kuQAxSvphoRC1gpfu4Nv41uXRGLFNZo9ZjzbaQkEQ1ISFO
         tf7dpjW22kUnJ96rhYQYSQPd17oDhTgC4Cv8DNXkCVZVLIpFElCU0a/hGig2CaU0cDci
         arrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orqc7aIResxBe03vCpBeboci/UnZToSoRQ+wlArEs+E=;
        b=1qmkunqnEWPWlo1kQgw4vxKtGg3CfyPEvkzNUe46pUXN6RjPbGyukUA9EyWcpNIroN
         2DbyfNWHF2wzzhSENovs5jeNtyHfPbRHY0jT8kmH+oCcH2E07hc9irNJ+1YZTtUO86ue
         5P6p2kOiNpqfiPk5bAOMWt/2ekJgc3FeBmbk6R1S/xmMRMOo2YGlIxdfjvbOVpiWAY0o
         a4LZIIM89B6YuCOMs/yNgKoud4BvYU7iou5jwMvniy17M9JlbRwJMUnW1841ImYkWUJL
         4ZbJJ5BWD8JaoKyeeWolY/iD64GxYDbIsXJy7cUB5GOJplQzPWvwoSp5Q1nZKDdzODAh
         65bA==
X-Gm-Message-State: AO0yUKUjAL50ZAwK5Lttkdz8t+WE/A275DnbVGjDxHPFu14ed2p4VIUN
        gMipFrhcBj3oFso9zkNxudY=
X-Google-Smtp-Source: AK7set+iPWO7TGG3YF7lggcPi/Hh6C9m5pOhKUA7kP7FrDx9146NCCz0CDx6pfYbktp6EeRi2Zv0Ag==
X-Received: by 2002:a05:6e02:2167:b0:315:6840:f727 with SMTP id s7-20020a056e02216700b003156840f727mr7195722ilv.8.1677528725184;
        Mon, 27 Feb 2023 12:12:05 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s26-20020a02cf3a000000b003b443977af0sm2354146jar.7.2023.02.27.12.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 12:12:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <00ed5135-8cd2-dc40-44af-1cbf64a02591@roeck-us.net>
Date:   Mon, 27 Feb 2023 12:12:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        linux-kernel@vger.kernel.org,
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
 <19587ea3-e54c-e3b0-5341-eb7ee486474b@roeck-us.net>
 <Y/0DcqXBDvp7tv0r@yury-laptop>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Y/0DcqXBDvp7tv0r@yury-laptop>
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

On 2/27/23 11:24, Yury Norov wrote:
> On Mon, Feb 27, 2023 at 06:59:12AM -0800, Guenter Roeck wrote:
>> On 2/27/23 06:46, Alexander Lobakin wrote:
>>> From: Yury Norov <yury.norov@gmail.com>
>>> Date: Sat, 25 Feb 2023 16:06:45 -0800
>>>
>>>> On Sat, Feb 25, 2023 at 04:05:02PM -0800, Yury Norov wrote:
>>>>> On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
>>>>>>> Test newly added bitmap_{from,to}_arr64() functions similarly to
>>>>>>> already existing bitmap_{from,to}_arr32() tests.
>>>>>>>
>>>>>>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
>>>>>>
>>>>>> Ever since this test is in the tree, several of my boot tests show
>>>>>> lots of messages such as
>>>>>>
>>>>>> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
>>>
>>> Hmmm, the whole 4 bytes weren't touched.
>>>
>>>>>> test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
>>>>>> test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
>>>
>>> This is where it gets worse...
>>>
>>>>>> ...
>>>>>> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
>>>>>> test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)
>>>
>>> I don't see the pattern how the actual result gets generated. But the
>>> problem is in the bitmap code rather than in the subtest -- "must be"s
>>> are fully correct.
>>>
>>> Given that the 0xa5s are present in the upper 32 bits, it is Big Endian
>>> I guess? Maybe even 32-bit Big Endian? Otherwise I'd start concerning
>>> how comes it doesn't reproduce on x86_64s :D
>>>
>>
>> It does reproduce on 32-bit x86 builds, and as far as I can see
>> it is only seen with 32-bit little endian systems.
> 
> Hi Guenter, Alexander,
> 
> I think that the reason for the failures like this:
> 
>> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> 
> is that bitmap_to_arr64 is overly optimized for 32-bit LE architectures.
> 
> Regarding this:
> 
>> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
> 
> I am not sure what happens, but because this again happens on 32-bit
> LE only, I hope the following fix would help too.
> 
> Can you please check if the patch works for you? I don't have a 32-bit LE
> machine in hand, and all my 32-bit VMs (arm and i386) refuse to load the
> latest kernels for some weird reason, so it's only build-tested.
> 
> I'll give it a full-run when restore my 32-bit setups.
> 
> Thanks,
> Yury
> 
>>From 2881714db497aed103e310865da075e7b0ce7e1a Mon Sep 17 00:00:00 2001
> From: Yury Norov <yury.norov@gmail.com>
> Date: Mon, 27 Feb 2023 09:21:59 -0800
> Subject: [PATCH] lib/bitmap: drop optimization of bitmap_{from,to}_arr64
> 
> bitmap_{from,to}_arr64() optimization is overly optimistic on 32-bit LE
> architectures when it's wired to bitmap_copy_clear_tail().
> 
> bitmap_copy_clear_tail() takes care of unused bits in the bitmap up to
> the next word boundary. But on 32-bit machines when copying bits from
> bitmap to array of 64-bit words, it's expected that the unused part of
> a recipient array must be cleared up to 64-bit boundary, so the last 4
> bytes may stay untouched.
> 
> While the copying part of the optimization works correct, that clear-tail
> trick makes corresponding tests reasonably fail when nbits % 64 <= 32:
> 
> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> 
> Fix it by removing bitmap_{from,to}_arr64() optimization for 32-bit LE
> arches.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: 0a97953fd2210 ("lib: add bitmap_{from,to}_arr64")
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Tested with 32-bit i386 image. With this patch on top of
v6.2-12765-g982818426a0f, the log messages are gone. Without this patch,
they are still seen.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

> ---
>   include/linux/bitmap.h | 8 +++-----
>   lib/bitmap.c           | 2 +-
>   2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 40e53a2ecc0d..5abc993903fb 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -302,12 +302,10 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
>   #endif
>   
>   /*
> - * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
> - * machines the order of hi and lo parts of numbers match the bitmap structure.
> - * In both cases conversion is not needed when copying data from/to arrays of
> - * u64.
> + * On 64-bit systems bitmaps are represented as u64 arrays internally. So,
> + * conversion is not needed when copying data from/to arrays of u64.
>    */
> -#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> +#if BITS_PER_LONG == 32
>   void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
>   void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
>   #else
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 1c81413c51f8..ddb31015e38a 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1495,7 +1495,7 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
>   EXPORT_SYMBOL(bitmap_to_arr32);
>   #endif
>   
> -#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> +#if BITS_PER_LONG == 32
>   /**
>    * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
>    *	@bitmap: array of unsigned longs, the destination bitmap

