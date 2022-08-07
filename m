Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C358BA0C
	for <lists+kvm@lfdr.de>; Sun,  7 Aug 2022 09:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiHGHcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 03:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiHGHcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 03:32:47 -0400
Received: from bg5.exmail.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B67DFE7;
        Sun,  7 Aug 2022 00:32:41 -0700 (PDT)
X-QQ-mid: bizesmtp62t1659857557tww2qqbe
Received: from localhost.localdomain ( [182.148.15.41])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 07 Aug 2022 15:32:11 +0800 (CST)
X-QQ-SSF: 0100000000200040B000B00A0000000
X-QQ-FEAT: pmoWCtn9ynD9qOI3q7r8NczIC7L58hwOdJ7EJmsWqOlZqkNDcGnOP4tCaRLFa
        FdnJgoGxOqO+ItrNwqpxv+s4K4I7p5qn2lRbC9DIF/A1EPsL0uJzGMFaApr0PDnJnVVcMxC
        qYd2W0tJY5dwSumuW0sbBr+IJ13lR9vbgVfLBKcVVkFaa1i6DKXCwT1f2Z701RnIsJhVYCb
        7ZBsOkU4rJGcWvQC6KOC8PcXIhn2IS7AuqZPwdEd1MsmmDBup4B12I1tVvCQYTWawU4tnjb
        7ErQRYadSDIDpgGJvmsi1zviy7Esx8hW5XuT29J/rKMxH+CZbN/YIzmauznGsQt80AsE37B
        6+hDlP/nY8ebeEmQbaMf6j+lWijzQ==
X-QQ-GoodBg: 0
From:   shaomin Deng <dengshaomin@cdjrlc.com>
To:     shuah@kernel.org
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>
Subject: [PATCH] tools/perf: Fix typo in comments
Date:   Sun,  7 Aug 2022 03:32:09 -0400
Message-Id: <20220807073209.3187-1-dengshaomin@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaomin Deng <dengshaomin@cdjrlc.com>

Delete repeated word "into" in comments.

Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 659eb4e4b34b..e0fe03cac5ba 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -131,7 +131,7 @@ static void handler_call_die(const char *handler_name)
 }
 
 /*
- * Insert val into into the dictionary and decrement the reference counter.
+ * Insert val into the dictionary and decrement the reference counter.
  * This is necessary for dictionaries since PyDict_SetItemString() does not
  * steal a reference, as opposed to PyTuple_SetItem().
  */
-- 
2.25.1

