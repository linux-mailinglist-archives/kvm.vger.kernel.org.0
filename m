Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFFB743C84
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbjF3NSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 09:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjF3NSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 09:18:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFB53A99;
        Fri, 30 Jun 2023 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688131096; x=1719667096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4BFFIC3cYHlXoBbTQgw8k4pdIJX8J94Q2/BVdcLpp+0=;
  b=f5ZmtkrVd3opDw4weGhfbkqMLu324130nGP2b7/I6nYxH2MP+0nhdDi4
   v/ZX/7OOkw6vGl4got10paFHcJ9sqr3IMGI6JSg3LRK/Ir7HWz3a0ZSp8
   Cc06xpHWLkFIZ7LczNrB/yCZutQ/yWUVEgACj+oNS3fPhjswfBep1qP42
   fe+bxBLU7/21XcN31LlEY2cCWY9tfCE01MMppnWJu5KW2VOe30qKgUdsZ
   eMBlM+OCmREcCMesvOSzi7p6S2jrhKq8HXj0xm/JBVKoimeMabMoCHWO8
   uxZpavxnL8kiz9L3MarZ3E2SOUyv3EdyqBZ9aROnZPOPlHvE4OPRxbcNm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362433153"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362433153"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 06:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="783077963"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="783077963"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2023 06:18:13 -0700
From:   Xin Zeng <xin.zeng@intel.com>
To:     linux-crypto@vger.kernel.org, kvm@vger.kernel.org
Cc:     giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Xin Zeng <xin.zeng@intel.com>
Subject: [RFC 3/5] units: Add HZ_PER_GHZ
Date:   Fri, 30 Jun 2023 21:13:02 +0800
Message-Id: <20230630131304.64243-4-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20230630131304.64243-1-xin.zeng@intel.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

There is going to be a new user of the HZ_PER_GHZ definition besides
possibly existing ones. Add that one to the header.

While at it, split Hz and kHz groups of the multipliers for better
maintenance and readability.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 include/linux/units.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/units.h b/include/linux/units.h
index 2793a41e73a2..8d1dd5609906 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -20,12 +20,16 @@
 #define PICO	1000000000000ULL
 #define FEMTO	1000000000000000ULL
 
+/* Hz based multipliers */
 #define NANOHZ_PER_HZ		1000000000UL
 #define MICROHZ_PER_HZ		1000000UL
 #define MILLIHZ_PER_HZ		1000UL
 #define HZ_PER_KHZ		1000UL
-#define KHZ_PER_MHZ		1000UL
 #define HZ_PER_MHZ		1000000UL
+#define HZ_PER_GHZ		1000000000UL
+
+/* kHz based multipliers */
+#define KHZ_PER_MHZ		1000UL
 
 #define MILLIWATT_PER_WATT	1000UL
 #define MICROWATT_PER_MILLIWATT	1000UL
-- 
2.18.2

