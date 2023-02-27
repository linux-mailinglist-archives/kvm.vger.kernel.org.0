Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2DB6A4C2E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 21:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjB0UXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 15:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjB0UXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 15:23:43 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5583118169;
        Mon, 27 Feb 2023 12:23:40 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1723ab0375eso8711106fac.1;
        Mon, 27 Feb 2023 12:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQl9Er/LZyPguZdc7hsvFLd57KkAlUhYoP7LJ7OMkY8=;
        b=LX9G03P9f5wQYTd+LDJ277TTFDhfXvEYOktZKGdOgQqSRuKqtoWS6VX8IQHDEHiiKh
         2/VZcygOGUSfc3V5sg+D6aYG54vJ/5Kjdfv4Tjn8BWAinwtlDuSxpnFby/u5B2a0NPcm
         /RzwkuX/WNCbmLZhppkuFHBVd+LaGuWxQHbObkNloT8Fq0KfVcFXuVHx/PAv7cDWtQfa
         eeTLZd60cOLSVH7XETAW1480LCG88UubTbs3mRQL5iZSCV6CY1XoZa79damhFnxEzTz4
         Pklgzvib0IuwveHUymAm4o7FggQ8hK74mZ0bZEMz9ssW2goP+WZncfgmXEuAvs9p17Qg
         Z4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQl9Er/LZyPguZdc7hsvFLd57KkAlUhYoP7LJ7OMkY8=;
        b=pVh7r7gx8cq+SuE7DlPhoXxjTdv3owKhhTRxezawm2qpMMYqHdx30uV5m6DQhyBbvt
         kjjGDR+d7p6IWffAXPV70MQRpylQ/81B5TU5L16vnH/xUoAXNe6EBveXgIQQd6CcH5mJ
         YztrR17y1Rfiy2L9SDRoVeqRhHQ9Leh6xvhPznG1lxjh8TlGn9z1g8TDIOZkW6wIqpFu
         xebcM0jiwOudDF7uSA1BRcjq6Jc7j0Orn770Zj6X/TrYAhfgSm6sdqtQXC75vRXGPRNg
         GEwhstKWAVIfIbKvOvJ4w+9cWHCYOjPL2DKmfixzY96DttOGuewXyDLzfQmcTEpV2Fn0
         DIlg==
X-Gm-Message-State: AO0yUKUyr7VeHq8FqNScaII214DEYvUSXWj/CP/bSJv4BZjxd3hp5dLM
        uQ9BSWETfYEncNQBepqIygk=
X-Google-Smtp-Source: AK7set+mrWLU3Bm7ta3XbGGLzsTQu5bUFZs/+3Q0837U/3VDjtXJiRiiO/aLWPqjVe90FKGsfdB7hQ==
X-Received: by 2002:a05:6870:b6a7:b0:172:8998:9185 with SMTP id cy39-20020a056870b6a700b0017289989185mr5221796oab.18.1677529419420;
        Mon, 27 Feb 2023 12:23:39 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id b5-20020a05687061c500b001435fe636f2sm2576133oah.53.2023.02.27.12.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 12:23:38 -0800 (PST)
Date:   Mon, 27 Feb 2023 12:23:37 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
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
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Message-ID: <Y/0RSTYYnCsBRfXg@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20230225184702.GA3587246@roeck-us.net>
 <Y/qhL8kSzzhMm+tO@yury-laptop>
 <Y/qilU0cW6ebmrnM@yury-laptop>
 <95377047-6b26-b434-fc90-2289fccc2a0b@intel.com>
 <19587ea3-e54c-e3b0-5341-eb7ee486474b@roeck-us.net>
 <Y/0DcqXBDvp7tv0r@yury-laptop>
 <00ed5135-8cd2-dc40-44af-1cbf64a02591@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ed5135-8cd2-dc40-44af-1cbf64a02591@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 12:12:01PM -0800, Guenter Roeck wrote:
> On 2/27/23 11:24, Yury Norov wrote:
> > On Mon, Feb 27, 2023 at 06:59:12AM -0800, Guenter Roeck wrote:
> > > On 2/27/23 06:46, Alexander Lobakin wrote:
> > > > From: Yury Norov <yury.norov@gmail.com>
> > > > Date: Sat, 25 Feb 2023 16:06:45 -0800
> > > > 
> > > > > On Sat, Feb 25, 2023 at 04:05:02PM -0800, Yury Norov wrote:
> > > > > > On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> > > > > > > > Test newly added bitmap_{from,to}_arr64() functions similarly to
> > > > > > > > already existing bitmap_{from,to}_arr32() tests.
> > > > > > > > 
> > > > > > > > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > > > > > > 
> > > > > > > Ever since this test is in the tree, several of my boot tests show
> > > > > > > lots of messages such as
> > > > > > > 
> > > > > > > test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> > > > 
> > > > Hmmm, the whole 4 bytes weren't touched.
> > > > 
> > > > > > > test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
> > > > > > > test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
> > > > 
> > > > This is where it gets worse...
> > > > 
> > > > > > > ...
> > > > > > > test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
> > > > > > > test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)
> > > > 
> > > > I don't see the pattern how the actual result gets generated. But the
> > > > problem is in the bitmap code rather than in the subtest -- "must be"s
> > > > are fully correct.
> > > > 
> > > > Given that the 0xa5s are present in the upper 32 bits, it is Big Endian
> > > > I guess? Maybe even 32-bit Big Endian? Otherwise I'd start concerning
> > > > how comes it doesn't reproduce on x86_64s :D
> > > > 
> > > 
> > > It does reproduce on 32-bit x86 builds, and as far as I can see
> > > it is only seen with 32-bit little endian systems.
> > 
> > Hi Guenter, Alexander,
> > 
> > I think that the reason for the failures like this:
> > 
> > > test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> > 
> > is that bitmap_to_arr64 is overly optimized for 32-bit LE architectures.
> > 
> > Regarding this:
> > 
> > > test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
> > 
> > I am not sure what happens, but because this again happens on 32-bit
> > LE only, I hope the following fix would help too.
> > 
> > Can you please check if the patch works for you? I don't have a 32-bit LE
> > machine in hand, and all my 32-bit VMs (arm and i386) refuse to load the
> > latest kernels for some weird reason, so it's only build-tested.
> > 
> > I'll give it a full-run when restore my 32-bit setups.
> > 
> > Thanks,
> > Yury
> > 
> > > From 2881714db497aed103e310865da075e7b0ce7e1a Mon Sep 17 00:00:00 2001
> > From: Yury Norov <yury.norov@gmail.com>
> > Date: Mon, 27 Feb 2023 09:21:59 -0800
> > Subject: [PATCH] lib/bitmap: drop optimization of bitmap_{from,to}_arr64
> > 
> > bitmap_{from,to}_arr64() optimization is overly optimistic on 32-bit LE
> > architectures when it's wired to bitmap_copy_clear_tail().
> > 
> > bitmap_copy_clear_tail() takes care of unused bits in the bitmap up to
> > the next word boundary. But on 32-bit machines when copying bits from
> > bitmap to array of 64-bit words, it's expected that the unused part of
> > a recipient array must be cleared up to 64-bit boundary, so the last 4
> > bytes may stay untouched.
> > 
> > While the copying part of the optimization works correct, that clear-tail
> > trick makes corresponding tests reasonably fail when nbits % 64 <= 32:
> > 
> > test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> > 
> > Fix it by removing bitmap_{from,to}_arr64() optimization for 32-bit LE
> > arches.
> > 
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Fixes: 0a97953fd2210 ("lib: add bitmap_{from,to}_arr64")
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> 
> Tested with 32-bit i386 image. With this patch on top of
> v6.2-12765-g982818426a0f, the log messages are gone. Without this patch,
> they are still seen.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks!

Then, I'll submit it properly together with a fix for fail_counter.

Thanks,
Yury
