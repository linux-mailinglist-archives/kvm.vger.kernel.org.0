Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594DC6A4D81
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjB0Vpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjB0Vpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:45:36 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C200C1ADF6;
        Mon, 27 Feb 2023 13:45:29 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id a14-20020a056830100e00b00690ed91749aso4410258otp.7;
        Mon, 27 Feb 2023 13:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tuhD4iL/HxIBp2Kwqi0Bl1yPTrRqIcGB+aRhHOA8ccY=;
        b=Fv9OugYojrJOxXMYa0Lr81s8i48T6D9GNxhltqStALa5qMcMYOyxVG6p6XZsmiLOmf
         OATZ2Em1d6av37qlpd85Pd90kM8gxhz4S6Xa2b2DfcIOFCcfMO/v0n0W9hYsb+TmfV9Z
         Pk1FUCGpEYOOeNzbACrylaaxgW/it5ahoBk5M7HUoDvAyqMa3xopuwKFe5opf6QJjI/G
         eqM3rJEiG0pMwrZRvv5VvvQHp/S0u5mbCHLs53IgOhUXzk8lhzgEWwXz3JYCnRa7tW/U
         TL5Vety2g0NFMM4U2QW/eFLI0GAZzcsScxVRvhRVutiJSZcrMD9HFN2Yl7r3ohO6xEkV
         JHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tuhD4iL/HxIBp2Kwqi0Bl1yPTrRqIcGB+aRhHOA8ccY=;
        b=xmUDx3KqlrNrwpRcj/p7WF1BnOs36yBqwjKUnfXbpB3QHYq7bJek7o7DPOkzWVH9Ci
         wCnUVUXmX1kjgzj6T79JTmQr1MLNz+EQMON1HKkE85ii/AU6Q41b2bmOVWRaCCdhiTGI
         1molQM/AOmPYsW3rYyKpzjjGISh0v22iWWfsBDKYKBKtDtLCfdTLJXqGdf9LNh6Wr+o9
         5U/xaQDlIPVUA4PfiuemxkF0A7eocbqkBji4oIZCFPie+TD5gKTmp4SeUELMUQHl9iJB
         d1N42pAJlkxo5VS0g6q4RwsUajsEKvbVa88vwpNpGQwFAotzhJfXJuFY39tdE/N4pwtd
         us3w==
X-Gm-Message-State: AO0yUKVvGMM5R0AdTiVElI4tCJXmPh9wP5e8RVscfBoPh2CRZu4R4x2Z
        snLRYJjsdlVYd7gISfYw5q+cHoxmnpg=
X-Google-Smtp-Source: AK7set8RUUrbKGQSb+u4+Hl8zi+rULsdULMXS1ABVD1QOuGgtfNBOgoqQ0wlgWeX+mX8+sd7wsZrkQ==
X-Received: by 2002:a05:6830:6518:b0:693:be07:356a with SMTP id cm24-20020a056830651800b00693be07356amr404769otb.2.1677534328472;
        Mon, 27 Feb 2023 13:45:28 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id h8-20020a056830164800b0068bb73bd95esm3011168otr.58.2023.02.27.13.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:45:27 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/2] lib/test_bitmap: increment failure counter properly
Date:   Mon, 27 Feb 2023 13:45:23 -0800
Message-Id: <20230227214524.914050-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tests that don't use expect_eq() macro to determine that a test is
failured must increment failed_tests explicitly.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/lkml/20230225184702.GA3587246@roeck-us.net/
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 8954610ec683..c4b90d145398 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -471,6 +471,7 @@ static void __init test_bitmap_parselist(void)
 		if (err != ptest.errno) {
 			pr_err("parselist: %d: input is %s, errno is %d, expected %d\n",
 					i, ptest.in, err, ptest.errno);
+			failed_tests++;
 			continue;
 		}
 
@@ -479,6 +480,7 @@ static void __init test_bitmap_parselist(void)
 			pr_err("parselist: %d: input is %s, result is 0x%lx, expected 0x%lx\n",
 					i, ptest.in, bmap[0],
 					*ptest.expected);
+			failed_tests++;
 			continue;
 		}
 
@@ -512,11 +514,13 @@ static void __init test_bitmap_printlist(void)
 
 	if (ret != slen + 1) {
 		pr_err("bitmap_print_to_pagebuf: result is %d, expected %d\n", ret, slen);
+		failed_tests++;
 		goto out;
 	}
 
 	if (strncmp(buf, expected, slen)) {
 		pr_err("bitmap_print_to_pagebuf: result is %s, expected %s\n", buf, expected);
+		failed_tests++;
 		goto out;
 	}
 
@@ -584,6 +588,7 @@ static void __init test_bitmap_parse(void)
 		if (err != test.errno) {
 			pr_err("parse: %d: input is %s, errno is %d, expected %d\n",
 					i, test.in, err, test.errno);
+			failed_tests++;
 			continue;
 		}
 
@@ -592,6 +597,7 @@ static void __init test_bitmap_parse(void)
 			pr_err("parse: %d: input is %s, result is 0x%lx, expected 0x%lx\n",
 					i, test.in, bmap[0],
 					*test.expected);
+			failed_tests++;
 			continue;
 		}
 
@@ -616,10 +622,12 @@ static void __init test_bitmap_arr32(void)
 
 		next_bit = find_next_bit(bmap2,
 				round_up(nbits, BITS_PER_LONG), nbits);
-		if (next_bit < round_up(nbits, BITS_PER_LONG))
+		if (next_bit < round_up(nbits, BITS_PER_LONG)) {
 			pr_err("bitmap_copy_arr32(nbits == %d:"
 				" tail is not safely cleared: %d\n",
 				nbits, next_bit);
+			failed_tests++;
+		}
 
 		if (nbits < EXP1_IN_BITS - 32)
 			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 32)],
@@ -642,15 +650,19 @@ static void __init test_bitmap_arr64(void)
 		expect_eq_bitmap(bmap2, exp1, nbits);
 
 		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
-		if (next_bit < round_up(nbits, BITS_PER_LONG))
+		if (next_bit < round_up(nbits, BITS_PER_LONG)) {
 			pr_err("bitmap_copy_arr64(nbits == %d:"
 				" tail is not safely cleared: %d\n", nbits, next_bit);
+			failed_tests++;
+		}
 
 		if ((nbits % 64) &&
-		    (arr[(nbits - 1) / 64] & ~GENMASK_ULL((nbits - 1) % 64, 0)))
+		    (arr[(nbits - 1) / 64] & ~GENMASK_ULL((nbits - 1) % 64, 0))) {
 			pr_err("bitmap_to_arr64(nbits == %d): tail is not safely cleared: 0x%016llx (must be 0x%016llx)\n",
 			       nbits, arr[(nbits - 1) / 64],
 			       GENMASK_ULL((nbits - 1) % 64, 0));
+			failed_tests++;
+		}
 
 		if (nbits < EXP1_IN_BITS - 64)
 			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
-- 
2.34.1

