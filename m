Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0D052DC4D
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 20:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243595AbiESSEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 14:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243584AbiESSEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 14:04:44 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB8A5FF13;
        Thu, 19 May 2022 11:04:43 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id m25so7405290oih.2;
        Thu, 19 May 2022 11:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=a1fLBAz97REz0jfdyucNaKEBoM0Z0pYoEHkMNeMyZmY=;
        b=Uts+jMb3MuoaLS6OeCoJ3tuosalXIzzvigYxaCpoSx3sFYls89Wumpe/Q58z2wrNmu
         uZDjciUuAI2Jcke0yVuUjvfAfyn+ViKpwGP+sdS0F3voNA6rwPhM5d82ZaywhLIAtEvt
         TIPcqmHb0UpUpygoeFdlTbGwkpBu+e6jqlSZm7Zd2OcLEZ9SW4OCW9ZyZ76Yob8kkBTQ
         nQgs6I7U7v/ESkep7gZkqYUFQGquqIhOifSReKBK68+3J3TPD80MJ9weARpS8CEQ20r/
         glGtntZ04BwGNeI/zwovNrOJeGeTmkO4c05pv+tSxIZh8Xi6BXea2sBrux1CXhdk8Wg7
         bR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=a1fLBAz97REz0jfdyucNaKEBoM0Z0pYoEHkMNeMyZmY=;
        b=4IMSjrUW3FMW+Lvr4dqGLElv0mcO9f7jvUTweCTm2LV3LBOABRGhGBY8W7h7g9cJK/
         bT18ct9gkT6J1SQkhsWNNstY44O1TPJvcaCIeP+m9y+keTX4FdaisftXhfPWtmpWxxep
         UIUm3Nn7M8SX4DIckvvyQUGG9q3Tw9bz7NG3JEHiBTgv10PPAAfLqSeFCbKeP2r70WIo
         79Oehaf9bc/VBfmGSm/2fUtY4JjRUGO7tnlsYSNA5UpqczG2U0TRRB47ojCh976aUKQV
         tFZzGpdqrpzp/W7X6YM1e4i6gr3nEpnCRtw0bNAFIqXgfnnKtntzQyhjbIABhL7O7ijD
         /8ng==
X-Gm-Message-State: AOAM532Mm1zqed1Pqm6YidNPpkXfGdFjSkxUGaDgcjHSWNb07bowoPY9
        0pEydtNlwG0DZGT1dqcGLQKRWqvP7g542Q==
X-Google-Smtp-Source: ABdhPJz3kOxPGC9IfIhJm0Kyu8j0LIFXBDddhJhj2FaXxItDd/dLBGPf5K1ZLyli35hlNUxOtMYwuw==
X-Received: by 2002:a05:6808:14cf:b0:328:ab6f:187b with SMTP id f15-20020a05680814cf00b00328ab6f187bmr3326747oiw.14.1652983482969;
        Thu, 19 May 2022 11:04:42 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e4-20020a056870a60400b000f169cbbb32sm114390oam.43.2022.05.19.11.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 11:04:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <872607af-5647-a255-83f2-3bf75b7f0df4@roeck-us.net>
Date:   Thu, 19 May 2022 11:04:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
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
 <20220519150929.GA3145933@roeck-us.net>
 <CAAH8bW8ju7XLkbYya1A1OtqGVGDUAk7dPyw01RsDzg+v7xihyQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
In-Reply-To: <CAAH8bW8ju7XLkbYya1A1OtqGVGDUAk7dPyw01RsDzg+v7xihyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 09:01, Yury Norov wrote:
> On Thu, May 19, 2022 at 8:09 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
>>> Test newly added bitmap_{from,to}_arr64() functions similarly to
>>> already existing bitmap_{from,to}_arr32() tests.
>>>
>>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
>>
>> With this patch in linux-next (including next-20220519), I see lots of
>> bitmap test errors when booting 32-bit ppc images in qemu. Examples:
>>
>> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0", got "0,65"
>> ...
>> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128"
>> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-129"
>> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-130"
>> ...
>> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-209"
>> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-210"
>>
>> and so on. It only  gets worse from there, and ends with:
>>
>> test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 4274
>> test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
>> ', Time: 127267
>> test_bitmap: failed 337 out of 3801 tests
>>
>> Other architectures and 64-bit ppc builds seem to be fine.
> 
> Hi Guenter,
> 
> Thanks for letting me know. It's really weird because it has already
> been for 2 weeks
> in next with no issues. But I tested it on mips32, not powerpc. I'll
> check what happens
> there.
> 
Oh, I have seen the problem for a while, it is just that -next is in
such a bad shape that it is difficult to bisect individual problems.

> Can you please share your config and qemu image if possible?
> 

First, you have to revert commit b033767848c411
("powerpc/code-patching: Use jump_label for testing freed initmem")
to avoid a crash. After that, a recent version of qemu should work
with the following command line.

qemu-system-ppc -kernel arch/powerpc/boot/uImage -M mpc8544ds \
	-m 256 -no-reboot -initrd rootfs.cpio \
	--append "rdinit=/sbin/init coherent_pool=512k mem=256M console=ttyS0" \
	-monitor none -nographic

Configuration is mpc85xx_defconfig with CONFIG_TEST_BITMAP enabled.
I used the root file system (initrd) from
https://github.com/groeck/linux-build-test/blob/master/rootfs/ppc/rootfs.cpio.gz

Hope this helps,
Guenter
