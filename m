Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B44F6A2B5F
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 19:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBYSrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 13:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYSrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 13:47:06 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EDC17148;
        Sat, 25 Feb 2023 10:47:05 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bg11so2144297oib.5;
        Sat, 25 Feb 2023 10:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mU8ouxaMVERSCUbXEf9OwfJ4PuquWDWLaI3fKf0e7O0=;
        b=i2gR2OWZzLr/IrXj7DUSMkK5l8xThJQ+UBmRFwSBdr0293XSFQKpoTBRObmlutJn3l
         akOz0p9AyqFE3HfBxbrrWvgHimJDoWdXkPCrMyhII+GrpgMM6ICsOH1mi8map0ukXw3M
         tYdfUw05uyL27NCkoo45uWOoqi52ojqYSONUh3dm/39O8BZmb0I/PpVIXwqrqcKCbQpU
         ms7WV52PrRkQfuwe/092kqnqCZzbfYzs23WcfIeKPTToClGRLgGMwgc5a3LWS3WTQ0FR
         Su3YAOz1sYkADVnxEDIN5Qq/EJZPa1zr12aGQkiwqzu19FgWfEyEckgo5XzGqOCDfgv1
         T7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mU8ouxaMVERSCUbXEf9OwfJ4PuquWDWLaI3fKf0e7O0=;
        b=XW6Z7D76ClqIAkT8kX5WdfKTFrh0vl0ha0m6fxtR7v05EfGkh7emVIH2Ys/Jb68WuE
         vJl50hRB90rpxUMhIEvrnlzwGscuOY+h7a4S2Cn3mG3MytlQfm2kJYYp11oixc93K+YF
         RqsZyjNULm5QVpr+uVFelzMxgvyTNdBtgxUv3x1ZMia1ia9bPeRWA7+m8igeNJkgYSlL
         FWWGmVIsUx0v+iAcqrBkc3pqT9klmUHQ5yOMKM5s6/c5N8fd8LaZsZqKs1wJjshF6eS0
         YOecuNoSof/xAYllUWeY67HipcBxj41OXIMzVPwCa7Pw/ZSAfeApjl7gkYtQuQEXHp9d
         /03Q==
X-Gm-Message-State: AO0yUKUTYZEiEVddQGCAgLDCDcfuULAkPzLG3dvXT92zN1RoqZs8sb2p
        rIIzbYYHWkxkpTGfqDJea/U=
X-Google-Smtp-Source: AK7set8VkV7Xov5x1fGY/9JN477Pgs4zaXeT7d9Ep3yomVCmotjwktaMsPjW73v7lwJwTsd9my6GUQ==
X-Received: by 2002:a05:6808:199:b0:37f:8682:9383 with SMTP id w25-20020a056808019900b0037f86829383mr7756010oic.9.1677350824676;
        Sat, 25 Feb 2023 10:47:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eb3-20020a056808634300b0037d8c2ff0acsm1162023oib.12.2023.02.25.10.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 10:47:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Feb 2023 10:47:02 -0800
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
Message-ID: <20230225184702.GA3587246@roeck-us.net>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428205116.861003-4-yury.norov@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> Test newly added bitmap_{from,to}_arr64() functions similarly to
> already existing bitmap_{from,to}_arr32() tests.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Ever since this test is in the tree, several of my boot tests show
lots of messages such as

test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
...
test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)

but then:

test_bitmap: all 6550 tests passed

The message suggests an error, given that it is displayed with pr_err,
but the summary suggests otherwise.

Is the message just noise, or is there a problem ?

Thanks,
Guenter

> ---
>  lib/test_bitmap.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
> index 0c82f07f74fc..d5923a640457 100644
> --- a/lib/test_bitmap.c
> +++ b/lib/test_bitmap.c
> @@ -585,6 +585,30 @@ static void __init test_bitmap_arr32(void)
>  	}
>  }
>  
> +static void __init test_bitmap_arr64(void)
> +{
> +	unsigned int nbits, next_bit;
> +	u64 arr[EXP1_IN_BITS / 64];
> +	DECLARE_BITMAP(bmap2, EXP1_IN_BITS);
> +
> +	memset(arr, 0xa5, sizeof(arr));
> +
> +	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
> +		memset(bmap2, 0xff, sizeof(arr));
> +		bitmap_to_arr64(arr, exp1, nbits);
> +		bitmap_from_arr64(bmap2, arr, nbits);
> +		expect_eq_bitmap(bmap2, exp1, nbits);
> +
> +		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
> +		if (next_bit < round_up(nbits, BITS_PER_LONG))
> +			pr_err("bitmap_copy_arr64(nbits == %d:"
> +				" tail is not safely cleared: %d\n", nbits, next_bit);
> +
> +		if (nbits < EXP1_IN_BITS - 64)
> +			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
> +	}
> +}
> +
>  static void noinline __init test_mem_optimisations(void)
>  {
>  	DECLARE_BITMAP(bmap1, 1024);
> @@ -852,6 +876,7 @@ static void __init selftest(void)
>  	test_copy();
>  	test_replace();
>  	test_bitmap_arr32();
> +	test_bitmap_arr64();
>  	test_bitmap_parse();
>  	test_bitmap_parselist();
>  	test_bitmap_printlist();
> -- 
> 2.32.0
> 
