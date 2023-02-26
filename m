Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3176A2CB0
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 01:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjBZAFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 19:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBZAFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 19:05:04 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C820C1024B;
        Sat, 25 Feb 2023 16:05:02 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id e18-20020a0568301e5200b00690e6abbf3fso1678703otj.13;
        Sat, 25 Feb 2023 16:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yVCbU2imVIcW8tPi1Mg3K5vbKs5hIvJLd7KMCksABfg=;
        b=WKmYp31tCnNCUDEcgbLJbWizDQR+9lWDkaxYjGPeSWmC/9r6CHdJmnwMwBXNORQIpW
         rIys8rl0LmuWU4dwnb3oZkaj5Tr/T7fGS2YbJ4iOyjN3S15cykky1YDVHnvnTEVRday9
         JIhx5IIkuc6qU48keLM1Xh5i/Ck0HH1m50HFO//zfEXjie6AYqhXibadjDv7VVSdBovd
         6BxPGnTfC8dC+Maba+2HAsnz6HRNqletDL7lKe8dvyjtXG+5Z9nw6b/it21yuaflqvbq
         xr/LiJp6BaOETEbx80vfZdvFj+cqZi25wU1WRN6+6Zhm6pnf0jPMndvrsVdL9qg3qeVw
         Hruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yVCbU2imVIcW8tPi1Mg3K5vbKs5hIvJLd7KMCksABfg=;
        b=j1xRdAji+f1HNFqikX5qIP2kdRnjehPT2lZ5ZdCi97YjfcX2Cbl1Lc/3wPyYjIpbgV
         7mZ/O7M4ipRD6E62EvEDVQ/6LQfEvXQwnPYKM4Fg/Q7M5e35lApW+aZmGmB5Z9G16UGh
         P/UZBODMjm59+5PYckE5ipTo/UWWPxr+StIvSkmG/OgP7UsyT7OAyWub1HUrMfsWqdF2
         YVLpxgzAZdQP57ZabKXDocQ8rutH7ZiZujC3bHYFt3RR5sslZHdgB5PuLsdTss8ZleVA
         s1zGtMSFLTMCJYrSkw0P8otKHWhlqwIzeSp8wqUwLS0riVIkjWJl2NSc8AfMgh6ivVkr
         WtbQ==
X-Gm-Message-State: AO0yUKVMSCG3ThRMVo6dH70mtrdO/GDhvw7Nq43W6C+R1OOJ5STQql8p
        SfQaubIGqhUe7FFRh54Ul/w=
X-Google-Smtp-Source: AK7set9+sdwFCKrvJTz9NuJPDiuB/MBL7XzfB3R8oneaIjYfPnaEMm8Hk9b+7iUUEtmk1KiDWykHKA==
X-Received: by 2002:a9d:7194:0:b0:68b:d266:e6cc with SMTP id o20-20020a9d7194000000b0068bd266e6ccmr10854384otj.19.1677369902012;
        Sat, 25 Feb 2023 16:05:02 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id d13-20020a056830138d00b00690e6d56670sm1095628otq.25.2023.02.25.16.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 16:05:01 -0800 (PST)
Date:   Sat, 25 Feb 2023 16:04:59 -0800
From:   Yury Norov <yury.norov@gmail.com>
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
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Message-ID: <Y/qhL8kSzzhMm+tO@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20230225184702.GA3587246@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230225184702.GA3587246@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
> Hi,
> 
> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> > Test newly added bitmap_{from,to}_arr64() functions similarly to
> > already existing bitmap_{from,to}_arr32() tests.
> > 
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> 
> Ever since this test is in the tree, several of my boot tests show
> lots of messages such as
> 
> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
> test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
> ...
> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
> test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)

This may be a real problem. Can you share what's the system is? What's
endianness and register length?

+ Alexander Lobakin, the author of the exact subtest.
 
> but then:
> 
> test_bitmap: all 6550 tests passed

It's because corresponding error path doesn't increment failed_tests
counter. I'll send a fix shortly.

> 
> The message suggests an error, given that it is displayed with pr_err,
> but the summary suggests otherwise.
> 
> Is the message just noise, or is there a problem ?
> 
> Thanks,
> Guenter
> 
> > ---
> >  lib/test_bitmap.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
> > index 0c82f07f74fc..d5923a640457 100644
> > --- a/lib/test_bitmap.c
> > +++ b/lib/test_bitmap.c
> > @@ -585,6 +585,30 @@ static void __init test_bitmap_arr32(void)
> >  	}
> >  }
> >  
> > +static void __init test_bitmap_arr64(void)
> > +{
> > +	unsigned int nbits, next_bit;
> > +	u64 arr[EXP1_IN_BITS / 64];
> > +	DECLARE_BITMAP(bmap2, EXP1_IN_BITS);
> > +
> > +	memset(arr, 0xa5, sizeof(arr));
> > +
> > +	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
> > +		memset(bmap2, 0xff, sizeof(arr));
> > +		bitmap_to_arr64(arr, exp1, nbits);
> > +		bitmap_from_arr64(bmap2, arr, nbits);
> > +		expect_eq_bitmap(bmap2, exp1, nbits);
> > +
> > +		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
> > +		if (next_bit < round_up(nbits, BITS_PER_LONG))
> > +			pr_err("bitmap_copy_arr64(nbits == %d:"
> > +				" tail is not safely cleared: %d\n", nbits, next_bit);
> > +
> > +		if (nbits < EXP1_IN_BITS - 64)
> > +			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
> > +	}
> > +}
> > +
> >  static void noinline __init test_mem_optimisations(void)
> >  {
> >  	DECLARE_BITMAP(bmap1, 1024);
> > @@ -852,6 +876,7 @@ static void __init selftest(void)
> >  	test_copy();
> >  	test_replace();
> >  	test_bitmap_arr32();
> > +	test_bitmap_arr64();
> >  	test_bitmap_parse();
> >  	test_bitmap_parselist();
> >  	test_bitmap_printlist();
> > -- 
> > 2.32.0
> > 
