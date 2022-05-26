Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6ED5352CD
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348362AbiEZRkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348159AbiEZRkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:40:11 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83229994DA
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:39:54 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g3so2460461qtb.7
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=89joqpwa3bZgTiSZfeB/g8CsSOelrJL5EQhEZJ3d5Mw=;
        b=ZAn71j+rSMNQnZOvKVitpWHaZv1FUJu9WjCXDgEPMuLGMFkwgn+H73BlUx/RRBxAIe
         f5Lar2GLtlqekC+RSgMU3ihHyRr/jgJhQNKZCpQv5ScTLZ2wMW9n0O/Bi3Ba7rxTma3P
         YiOMyhJOc/Xyd/wdKhfg5l2vgwMqg4iMCUJ2mYt78RV25qFGSIPCozoRLvVTSm0c0JKY
         q9yrj2mWxdj0mg7IQ1cBCZiQFLT/6mSVjIFHbpF1X65z9CVMBv2tii2T1DW3kxwpYe9n
         hhhoFSA1IE4UgEjEASAvGBWf4TZv/t0uXKERG0HwwsQSHcAg0IIVqYcYMd/qNc/+xDVj
         lBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89joqpwa3bZgTiSZfeB/g8CsSOelrJL5EQhEZJ3d5Mw=;
        b=6xNh4gjQtFw2qO0oohfUj0PBqerfU7W8OWInJdoJQiroGmtIku/nBy97QVuwd3xiBx
         35pHrHzDchXq4FjsybRPoEI3kwNGHuyZxKoKdW6c/bgzd6LaN07oNbjM+TDz+zXo+6BQ
         xzJ/pBCtvHj044l6Mh+7J48TpFY3j00bfKiHBEA2q15bX6wj5EI7OaPJTRSVdfczhAHm
         2+DhoP8V0QulejRvbAHlAqm4STdbHvPrr269VdMRv5XmoZHH7TMAZC1c5j8VrETezfFR
         8PrEVUo30GGtAzpuM9gxKyO8XR1paghbWQ5ZK2Bml9yU2noqFxvn7wDr24LjdNExfu8W
         c9cA==
X-Gm-Message-State: AOAM530Dd4fcROexmnFizBqtLhV5kWzOb20tBBjkUnNksyrGS9RjwwTv
        byEMyvofLIB3JlW1VsHnAmY4RsW0srRK2V0+
X-Google-Smtp-Source: ABdhPJw09SneRmX7jjQSq8/G69wdROHT2X7llq+/u61ABFgDtI/u4AMzneTSRrltPjfRbhgQtfTxqw==
X-Received: by 2002:a05:6214:234c:b0:462:49aa:b788 with SMTP id hu12-20020a056214234c00b0046249aab788mr15614928qvb.103.1653586793375;
        Thu, 26 May 2022 10:39:53 -0700 (PDT)
Received: from doctor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id bq15-20020a05620a468f00b006a5a07bb868sm1592257qkb.119.2022.05.26.10.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:39:52 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Date:   Thu, 26 May 2022 17:39:49 +0000
Message-Id: <20220526173949.4851-3-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.31.2
In-Reply-To: <20220526173949.4851-1-cross@oxidecomputer.com>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Warn, don't fail, if the check for `getopt -T` fails in the `configure`
script.

Aside from this check, `configure` does not use `getopt`, so don't
fail to run if `getopt -T` doesn't indicate support for  the extended
Linux version.  Getopt is only used in `run_tests.sh`, which tests for
extended getopt anyway, but emit a warning here.

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 configure | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 23085da..5b7daac 100755
--- a/configure
+++ b/configure
@@ -318,11 +318,11 @@ EOF
   rm -f lib-test.{o,S}
 fi
 
-# require enhanced getopt
+# warn if enhanced getopt is unavailable
 getopt -T > /dev/null
 if [ $? -ne 4 ]; then
-    echo "Enhanced getopt is not available, add it to your PATH?"
-    exit 1
+    echo "Without enhanced getopt you won't be able to use run_tests.sh."
+    echo "Add it to your PATH?"
 fi
 
 # Are we in a separate build tree? If so, link the Makefile
-- 
2.31.2

