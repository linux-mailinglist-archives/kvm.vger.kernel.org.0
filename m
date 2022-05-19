Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399C852D708
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiESPJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 11:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbiESPJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 11:09:34 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BA85AA5A;
        Thu, 19 May 2022 08:09:33 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-f1d2ea701dso7111370fac.10;
        Thu, 19 May 2022 08:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fy+R5BiTiTm6GOFcSpgE3qMI2J0fcOYfQLVU7dwXaIg=;
        b=HmPQKl9E+YiKInodSkSVkqicKnZB9Hdj1bz3thm4NjBs9pFTSrigWtIZfFG0UsgpBP
         f6WcKRUzsO0THkHWk26gToxk1u4R0da1I4LMZEhc0tu6EQV6Ld24FgPstZSEixgqWCqX
         AYnOVKvpKr+2Z5vO3Vry0+PyL4tza8LthI5g8Abq2/Q4NdsPbkEJ2TeJXGozksbzpnZV
         s6/YYhIqtYDb42GTy9Ot1LT99/xhvd4dnvtVoWTAgO0TOzuX0zyc84P4I3Rc67SQEzGx
         6NJbw7dT8RQuO8G6virKdByFQrKZFuufpTE3ZbKw2mMxLyMXLq5GQWr3OJz7Bqmzgd8r
         aO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Fy+R5BiTiTm6GOFcSpgE3qMI2J0fcOYfQLVU7dwXaIg=;
        b=5QWQIfzIqDouKEDwvpBjMq76GmsPGC1YWEW+m6DhJEV9Jwh3aGFqn73TleOlD6sewB
         MZk6h9DA6oU7VNIs6eu00Fb4vUU0zs9D0VjE6bu9BeEIlaGPF3FQXZ0yHx87rqe/nguG
         WR+rM1H4+7oE1J2WCaS1+xqizQeLWmyCIb4uQiqiV18U2gFi5OV7VD7jfXM0+wclXIMA
         YVqg6d0wuTlqnnWTmYsoW9Sh3Y+w4levuniM2ppeeaR2ounbJDjJ9ALmWAFekekBYIyv
         s+smQIs61IGNTZHqv+iuhCJIP9twve2m16JZ2NuQtMzj5fyN4y1uJ/RZcYfEsv+z+/S3
         CNdQ==
X-Gm-Message-State: AOAM530QceVVBf3uJlXdU+ggC3E24KNZiO11Z8vklM3ef3fLT4ydV8k2
        RAQB1Eb9fNrj55qrURgFA/0=
X-Google-Smtp-Source: ABdhPJywKcaswxekmkUOgS2t4LBRvbD9KQ+c/wzh/8DTAMM9LIe2PhURk+N14BsyWxCe9/enXkBtsw==
X-Received: by 2002:a05:6870:c0d3:b0:f1:8e58:15ec with SMTP id e19-20020a056870c0d300b000f18e5815ecmr3400811oad.118.1652972973069;
        Thu, 19 May 2022 08:09:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bd15-20020a056870d78f00b000e686d1389esm2179717oab.56.2022.05.19.08.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:09:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 19 May 2022 08:09:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
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
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Message-ID: <20220519150929.GA3145933@roeck-us.net>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428205116.861003-4-yury.norov@gmail.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> Test newly added bitmap_{from,to}_arr64() functions similarly to
> already existing bitmap_{from,to}_arr32() tests.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

With this patch in linux-next (including next-20220519), I see lots of
bitmap test errors when booting 32-bit ppc images in qemu. Examples:

test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0", got "0,65"
...
test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128"
test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-129"
test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-130"
...
test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-209"
test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-210"

and so on. It only  gets worse from there, and ends with:

test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 4274
test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
', Time: 127267
test_bitmap: failed 337 out of 3801 tests

Other architectures and 64-bit ppc builds seem to be fine. 

Guenter
