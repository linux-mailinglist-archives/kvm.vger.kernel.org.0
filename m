Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9A6A2CB5
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 01:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBZAGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 19:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBZAGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 19:06:49 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C311423D;
        Sat, 25 Feb 2023 16:06:48 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v1-20020a9d6041000000b0068d4a8a8d2dso1682432otj.12;
        Sat, 25 Feb 2023 16:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VUE0MJp/2mak3ou+EMKvdWy8qdO6Ey+Lb0K8RI8IcOQ=;
        b=kpRKeKjY7oZS+R+kc3fb1IFgSOfenQlYMfaIr3gtyL8VDH4KqK47r2YGWE/Zd3VkRu
         2BB4Z5+jSEY6BXaazoIWGKbR7y10fZ+DfF7IUYqY87LNBTrLD9L9fWjqIQkSAZxJCisc
         IPtcQPUYUcXRSfGEXRCrWBssNkekJ9T5VriMlPCQiLoJ/2yxEZFt8ZRhv9wQm9G3QANy
         e3/khexhrIs6lrKgCWCuIbi84K/usiywT8+wvlp7chxtDNrmzbyIEElslvDNqBYyowL1
         JawAfy1fZjLPvaJnZ/+78qowl9tlzfcNG0W+AH0Bi2iQAfMwofNHjvyow562d1cS9ejB
         Dy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUE0MJp/2mak3ou+EMKvdWy8qdO6Ey+Lb0K8RI8IcOQ=;
        b=OquLB2MxeJTnj6q7r3EgK4PLZ9h9jeU7ygJwDIIdLjWJ+Itj0aBbPX4fIKGFiGYnnH
         Oyw0OIdDcKuKzaHVD31cLT05F+r3TtpTUeIi7shDxSWkFCtGGS/y07gPhNUjdsG2CL0J
         Nzkej13OUzSXEzX4HCMMypvpZSc5Oyqus6moInr60uctDg5QNahkGkLsMqfEKxwAb/hy
         3uWEuUMkur8nsCtq1dsjliX1ORR1Q0Q04swI2q5UaU+3mN5y/foQbuUqYp700/qT38nT
         34FiWxMnTwWy3ZFdMAF4BfdOWtuQC/Q9KfXeLhYG+jUBRSzxehp4iXSNmg4RUQ6/FJmS
         99Qw==
X-Gm-Message-State: AO0yUKVXZ9obklivKVZg0UesHZocRyos1nvuYFuciziIcseobRpKreWP
        DmENX7przlHwICB/pJ4xxUE=
X-Google-Smtp-Source: AK7set8GAzBrbqyzE3HtDWBweZIPgaoUmiJoPdGkpDm3Mzd+IUdKiQH8EEGc5lM+HpU+Mwoyp/YoLQ==
X-Received: by 2002:a9d:37c5:0:b0:68c:136b:59ff with SMTP id x63-20020a9d37c5000000b0068c136b59ffmr6253946otb.6.1677370007548;
        Sat, 25 Feb 2023 16:06:47 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id e8-20020a9d7308000000b0068bce6239a3sm1078487otk.38.2023.02.25.16.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 16:06:47 -0800 (PST)
Date:   Sat, 25 Feb 2023 16:06:45 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
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
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Message-ID: <Y/qilU0cW6ebmrnM@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20230225184702.GA3587246@roeck-us.net>
 <Y/qhL8kSzzhMm+tO@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/qhL8kSzzhMm+tO@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 04:05:02PM -0800, Yury Norov wrote:
> On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
> > Hi,
> > 
> > On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> > > Test newly added bitmap_{from,to}_arr64() functions similarly to
> > > already existing bitmap_{from,to}_arr32() tests.
> > > 
> > > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > 
> > Ever since this test is in the tree, several of my boot tests show
> > lots of messages such as
> > 
> > test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> > test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
> > test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
> > ...
> > test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
> > test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)
> 
> This may be a real problem. Can you share what's the system is? What's
> endianness and register length?
> 
> + Alexander Lobakin, the author of the exact subtest.

Forgot to add
  
> > but then:
> > 
> > test_bitmap: all 6550 tests passed
> 
> It's because corresponding error path doesn't increment failed_tests
> counter. I'll send a fix shortly.
> 
> > 
> > The message suggests an error, given that it is displayed with pr_err,
> > but the summary suggests otherwise.
> > 
> > Is the message just noise, or is there a problem ?
> > 
> > Thanks,
> > Guenter
> > 
> > > ---
> > >  lib/test_bitmap.c | 25 +++++++++++++++++++++++++
> > >  1 file changed, 25 insertions(+)
> > > 
> > > diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
> > > index 0c82f07f74fc..d5923a640457 100644
> > > --- a/lib/test_bitmap.c
> > > +++ b/lib/test_bitmap.c
> > > @@ -585,6 +585,30 @@ static void __init test_bitmap_arr32(void)
> > >  	}
> > >  }
> > >  
> > > +static void __init test_bitmap_arr64(void)
> > > +{
> > > +	unsigned int nbits, next_bit;
> > > +	u64 arr[EXP1_IN_BITS / 64];
> > > +	DECLARE_BITMAP(bmap2, EXP1_IN_BITS);
> > > +
> > > +	memset(arr, 0xa5, sizeof(arr));
> > > +
> > > +	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
> > > +		memset(bmap2, 0xff, sizeof(arr));
> > > +		bitmap_to_arr64(arr, exp1, nbits);
> > > +		bitmap_from_arr64(bmap2, arr, nbits);
> > > +		expect_eq_bitmap(bmap2, exp1, nbits);
> > > +
> > > +		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
> > > +		if (next_bit < round_up(nbits, BITS_PER_LONG))
> > > +			pr_err("bitmap_copy_arr64(nbits == %d:"
> > > +				" tail is not safely cleared: %d\n", nbits, next_bit);
> > > +
> > > +		if (nbits < EXP1_IN_BITS - 64)
> > > +			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
> > > +	}
> > > +}
> > > +
> > >  static void noinline __init test_mem_optimisations(void)
> > >  {
> > >  	DECLARE_BITMAP(bmap1, 1024);
> > > @@ -852,6 +876,7 @@ static void __init selftest(void)
> > >  	test_copy();
> > >  	test_replace();
> > >  	test_bitmap_arr32();
> > > +	test_bitmap_arr64();
> > >  	test_bitmap_parse();
> > >  	test_bitmap_parselist();
> > >  	test_bitmap_printlist();
> > > -- 
> > > 2.32.0
> > > 
