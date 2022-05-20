Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0752F065
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351511AbiETQSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 12:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiETQSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 12:18:44 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0236D86A;
        Fri, 20 May 2022 09:18:44 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v10so8115729pgl.11;
        Fri, 20 May 2022 09:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJkmL3cNNCMdY+tXxffweIx723JB3I+sakjvH9x5oPk=;
        b=pKqLfq/DCIUJC4+qM7NiWzWHEvd6SrtREbZVUXsyCE/WXQz6k3GgmSapoKl75dVARm
         DbiSfwlfIBtgrDKulb5CpFbtKpSkHN6f5nnd5qso6EHWyRCL/FqSYE1YV8/gLhAZBryA
         oY2gKX7F82zdYn4EfMvajmTTI5ItAx/NUx9Udla5wndZ47Ky33OlQ22/uFJA9kvkUnlR
         o0DVwt8vrrM2QUoPS2/u76YmC5xVNy3LV5hwY+r8Y/gyFVz0b87Q0y20zxyDZ6B6xVZL
         0Mo4RGXMptD21gYHBroNYsA7W2lBPaZ0V7c9Yh6nEJ/jP++Fd8IjP97FF7cfBPtm7rtU
         f3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJkmL3cNNCMdY+tXxffweIx723JB3I+sakjvH9x5oPk=;
        b=cEdJTmQ1GtDApbN3fZuMOu3lugLXsTNN9mYu+flGgRO15E9mBqTO35YYDSkBxGEW+5
         DEEmRHQgvV1jMKRZAWNj+znJziLJxLTPQvLtDYPm6oS6/aadU7yeRHyrJwMLw68ssrgk
         ZhgXvibcbvZtx3S59yy4aUCml6WGnMJaW0UdQE91Qzu6sQdaIFtnKoVb8QYuDRtH4pDH
         ITj4k1svPL9NcqlxBq0IOWHKZ2ONGwkabAhzgiaaJrXKMkMCfvKdt38YhKBSFCxCiJqa
         e//ZCuIADW3TNbkzhVyAOseXORWczNX1AmzZbmCGqSW55Od4emRfdVFSjpo5LnJYgc6Q
         erEg==
X-Gm-Message-State: AOAM530yAn6j6WDSucM+cXh6qd7zZnTQ5sca0RDf2RWbeyeiZVMdqfvO
        HruN2XWEMVNkFVRG5hqO9DmUyi9t+urGHFdyS5M=
X-Google-Smtp-Source: ABdhPJx+qcYi6F2bg4WVAwh754TW7golfOR49ep220qUtfFvRzJQads+gxDHdltL7DRwree4z7Rg9gCYETyar8r/p2w=
X-Received: by 2002:a65:694b:0:b0:3f5:f32a:3adc with SMTP id
 w11-20020a65694b000000b003f5f32a3adcmr9069654pgq.541.1653063523816; Fri, 20
 May 2022 09:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220428205116.861003-1-yury.norov@gmail.com> <20220428205116.861003-4-yury.norov@gmail.com>
 <20220519150929.GA3145933@roeck-us.net> <CAAH8bW8ju7XLkbYya1A1OtqGVGDUAk7dPyw01RsDzg+v7xihyQ@mail.gmail.com>
 <872607af-5647-a255-83f2-3bf75b7f0df4@roeck-us.net>
In-Reply-To: <872607af-5647-a255-83f2-3bf75b7f0df4@roeck-us.net>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Fri, 20 May 2022 09:18:33 -0700
Message-ID: <CAAH8bW9zdMCV_JJ7abC6jY=0W-oTK5g0refFgFHLYWCykVk5KA@mail.gmail.com>
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

On Thu, May 19, 2022 at 11:04 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 5/19/22 09:01, Yury Norov wrote:
> > On Thu, May 19, 2022 at 8:09 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> >>> Test newly added bitmap_{from,to}_arr64() functions similarly to
> >>> already existing bitmap_{from,to}_arr32() tests.
> >>>
> >>> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> >>
> >> With this patch in linux-next (including next-20220519), I see lots of
> >> bitmap test errors when booting 32-bit ppc images in qemu. Examples:
> >>
> >> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0", got "0,65"
> >> ...
> >> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128"
> >> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-129"
> >> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-130"
> >> ...
> >> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-209"
> >> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-210"
> >>
> >> and so on. It only  gets worse from there, and ends with:
> >>
> >> test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 4274
> >> test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
> >> ', Time: 127267
> >> test_bitmap: failed 337 out of 3801 tests
> >>
> >> Other architectures and 64-bit ppc builds seem to be fine.
> >
> > Hi Guenter,
> >
> > Thanks for letting me know. It's really weird because it has already
> > been for 2 weeks
> > in next with no issues. But I tested it on mips32, not powerpc. I'll
> > check what happens
> > there.
> >
> Oh, I have seen the problem for a while, it is just that -next is in
> such a bad shape that it is difficult to bisect individual problems.
>
> > Can you please share your config and qemu image if possible?
> >
>
> First, you have to revert commit b033767848c411
> ("powerpc/code-patching: Use jump_label for testing freed initmem")
> to avoid a crash. After that, a recent version of qemu should work
> with the following command line.
>
> qemu-system-ppc -kernel arch/powerpc/boot/uImage -M mpc8544ds \
>         -m 256 -no-reboot -initrd rootfs.cpio \
>         --append "rdinit=/sbin/init coherent_pool=512k mem=256M console=ttyS0" \
>         -monitor none -nographic
>
> Configuration is mpc85xx_defconfig with CONFIG_TEST_BITMAP enabled.
> I used the root file system (initrd) from
> https://github.com/groeck/linux-build-test/blob/master/rootfs/ppc/rootfs.cpio.gz

Yes, that helped a lot. Thanks, I was able to reproduce it. I'll take
a look shortly.

Thanks,
Yury
