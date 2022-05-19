Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB83052D9B1
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiESQBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241611AbiESQBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:01:18 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B93220F3;
        Thu, 19 May 2022 09:01:17 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n8so5212613plh.1;
        Thu, 19 May 2022 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Izt2XQIS+k/iuXA05DKzoWcR89KdN5/M9JpMeEiR3dk=;
        b=l+Z5DmtzF2PgSdkzReMXkCr0cikUBHlWtJhOoNkfVGm38LC7zuwnjIKP8w+S8zYU0l
         O4KR91U+cpCxuuu8g/ETUF4jAo+xXwGpo9ryb50c+J5XpKR09Q2O/bbEf5xlk3+M3pGj
         NQuZ2LoiJRuECGmMkbVOPLY8bq3ECkxQkzJ8bbVEM+SkQoVSGXZWFb/fbZq06ipYJmZ+
         tnjZ9RJ1+72C+V8v8qoDrHh+3fTfDx+nvvykt+VzOwUefQYg7/JwMzNhWkMXSkYbuiGu
         8oDyZsL61cYx3FGPVXl02kA1U1YcDh6V1U5D60XchTn+d1nNi+6e8OYl1IH4MF+lDyk1
         mYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Izt2XQIS+k/iuXA05DKzoWcR89KdN5/M9JpMeEiR3dk=;
        b=IZqZdBnZoFdIssS+eWZP7/I0c1VCP/cRiy6G5vMOCQi8wnSC8gR0qApKPNBLdOX67g
         q0C7B7H7h5buDgVWwY6VJUu0T2Ehel3lcOBLwykMmLFqsx0H//rr8H2wzJgzxzqU8GSR
         RR71QI2E/t3u/ocyrX3wytMt4CMwB/8zHX2CpVJI8IT/WvLvQb+KX8JEygcsUkwIupO1
         J1S8DRAb5EjFdaUVo5fER2Oj7fu3JmAKThIA+S6Byjt0weuVvYTgIOYgZwj0Uvq1sXZl
         3RR/I5Rz+CwRdt8JE3pT70u1p0A6HLriD3qYmlzIcByFoiS3RiJ277DkZI1ioH35Pm7X
         RGfQ==
X-Gm-Message-State: AOAM532K9T2t5NRlPEEr8gB08R7h/NCVNE9sRx6mfEj66Mm/iLeM4dyi
        FBHuXFMyELoJkzxv+TGrgt6a1+ezAHF/A8SJxOc=
X-Google-Smtp-Source: ABdhPJxuAHz6fXhLGH98VdN5BYkURgBOorxd4Mtvxw41lKe+Kr0/EjkshxnhJApKfZa/HsAUzAKQ9vip789BEWDnuAk=
X-Received: by 2002:a17:903:24f:b0:15c:e3b8:a640 with SMTP id
 j15-20020a170903024f00b0015ce3b8a640mr5309537plh.5.1652976076357; Thu, 19 May
 2022 09:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220428205116.861003-1-yury.norov@gmail.com> <20220428205116.861003-4-yury.norov@gmail.com>
 <20220519150929.GA3145933@roeck-us.net>
In-Reply-To: <20220519150929.GA3145933@roeck-us.net>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Thu, 19 May 2022 09:01:00 -0700
Message-ID: <CAAH8bW8ju7XLkbYya1A1OtqGVGDUAk7dPyw01RsDzg+v7xihyQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
To:     Guenter Roeck <linux@roeck-us.net>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 8:09 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> > Test newly added bitmap_{from,to}_arr64() functions similarly to
> > already existing bitmap_{from,to}_arr32() tests.
> >
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
>
> With this patch in linux-next (including next-20220519), I see lots of
> bitmap test errors when booting 32-bit ppc images in qemu. Examples:
>
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0", got "0,65"
> ...
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128"
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-129"
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-130"
> ...
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-209"
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-210"
>
> and so on. It only  gets worse from there, and ends with:
>
> test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 4274
> test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
> ', Time: 127267
> test_bitmap: failed 337 out of 3801 tests
>
> Other architectures and 64-bit ppc builds seem to be fine.

Hi Guenter,

Thanks for letting me know. It's really weird because it has already
been for 2 weeks
in next with no issues. But I tested it on mips32, not powerpc. I'll
check what happens
there.

Can you please share your config and qemu image if possible?

Thanks,
Yury
