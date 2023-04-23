Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159076EBD16
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 06:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjDWEwp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 23 Apr 2023 00:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDWEwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 00:52:43 -0400
X-Greylist: delayed 1043 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Apr 2023 21:52:38 PDT
Received: from sendb.mailex.chinaunicom.cn (sendb.mailex.chinaunicom.cn [123.138.59.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0428910E4
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 21:52:37 -0700 (PDT)
Received: from M10-XA-MLCEN01.MailSrv.cnc.intra (unknown [10.236.3.197])
        by sendb.mailex.chinaunicom.cn (SkyGuard) with ESMTPS id 4Q3wTt3CgCz3FtkH
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 12:37:22 +0800 (CST)
Received: from smtpbg.qq.com (10.237.2.95) by M10-XA-MLCEN01.MailSrv.cnc.intra
 (10.236.3.197) with Microsoft SMTP Server id 15.0.1497.47; Sun, 23 Apr 2023
 12:35:02 +0800
X-QQ-mid: Ymail-xx24b003-t1682224500tau
Received: from localhost.localdomain (unknown [10.3.224.193])
        by smtp.qq.com (ESMTP) with 
        id ; Sun, 23 Apr 2023 12:34:59 +0800 (CST)
X-QQ-SSF: 0190000000000040I420050A0000000
X-QQ-GoodBg: 0
From:   =?gb18030?B?yM7D9MP0KMGqzai8r83FwarNqMr919a/xry809A=?=
         =?gb18030?B?z965q8u+sb6yvyk=?= <renmm6@chinaunicom.cn>
To:     =?gb18030?B?a3Zt?= <kvm@vger.kernel.org>
CC:     =?gb18030?B?cm1tMTk4NQ==?= <rmm1985@163.com>,
        =?gb18030?B?ZHJqb25lcw==?= <drjones@redhat.com>,
        =?gb18030?B?cGJvbnppbmk=?= <pbonzini@redhat.com>,
        =?gb18030?B?cmtyY21hcg==?= <rkrcmar@redhat.com>
Subject: [kvm-unit-tests PATCH] arch-run: Fix run_qemu return correct error code
Date:   Sun, 23 Apr 2023 12:34:36 +0800
Message-ID: <20230423043437.3018665-1-renmm6@chinaunicom.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-QQ-SENDSIZE: 520
Feedback-ID: Ymail-xx:chinaunicom.cn:mail-xx:mail-xx24b003-zhyw43w
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: rminmin <renmm6@chinaunicom.cn>

run_qemu should return 0 if logs doesn't
contain "warning" keyword.

Fixes: b2a2aa5d ("arch-run: reduce return code ambiguity")
Signed-off-by: rminmin <renmm6@chinaunicom.cn>
---
 scripts/arch-run.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 51e4b97..9878d32 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -61,7 +61,7 @@ run_qemu ()
                # Even when ret==1 (unittest success) if we also got stderr
                # logs, then we assume a QEMU failure. Otherwise we translate
                # status of 1 to 0 (SUCCESS)
-               if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
+               if [ -z "$(echo "$errors" | grep -i warning)" ]; then
                        ret=0
                fi
        fi
--
2.33.0

如果您错误接收了该邮件，请通过电子邮件立即通知我们。请回复邮件到 hqs-spmc@chinaunicom.cn，即可以退订此邮件。我们将立即将您的信息从我们的发送目录中删除。 If you have received this email in error please notify us immediately by e-mail. Please reply to hqs-spmc@chinaunicom.cn ,you can unsubscribe from this mail. We will immediately remove your information from send catalogue of our.
