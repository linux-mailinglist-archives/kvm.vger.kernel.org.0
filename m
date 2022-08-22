Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE2159B747
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 03:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiHVBh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 21:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiHVBh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 21:37:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB37320F44;
        Sun, 21 Aug 2022 18:37:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r69so8132554pgr.2;
        Sun, 21 Aug 2022 18:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=JYeDgo4BH0cqlWQE9A7b6GDBdTM8D8fxekVdXdAbBXo=;
        b=EgI2rsJEN8dXZrcfyF0z/7L6GsEorS3Y/X2XqgoYPFA4Dfc7MVK8Et6vUwSdr0RtY5
         UME69CrAeLPmbGkOHb4R6rzEwCX0dLqGtsp/HUXpgowaFdnsvj0182mby1dI3wntBEax
         jvQwcwr4omNIqNahfhXuAJbmRem/uSzzytG0XYL5RNrWWzpSlXzu8oHQ9Y7OIsw1v4Oe
         o+uimydwqmIfc1T+8f91MS1nIxPpQFgU5xoasR6Mo+y0Uk+wu7xEaZcfYD+42yl/HWBy
         EQE44kzBBIBlNDZ4Vu54kDs91A0Bdv01cOIFdEyYAWIMqzansrrH6wkKB4MrqchYczlc
         PysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=JYeDgo4BH0cqlWQE9A7b6GDBdTM8D8fxekVdXdAbBXo=;
        b=3xx0MOHCNDcT7Ts3qjOaBjO91TxHKUSyYMr2FLvVtsfv3Irwooa1HgDCoZtYLRfEdM
         3pfduBhr7ze1uZhK/8r5JhWPe+Bc72VGmIKQg1QDFCck1CiGL/OeimAenIP92ibaE/CH
         U5GmfmtIypaSAcVGA6Oj/EAxZ3c24GlwCoELdrtNkHv0IWYsvenVggwcUm1lLS/nxoqz
         HpStcZ0TjBwLsCaKYb50ixNSnsZNmzWTQTaMDUTniaAfv6Fa1zFsmprLrNpZhjH7bfWr
         PKAmkYLjsBlcgH6uVdybU7wspSw6OuO0Jcp95XHzSwfBUif/CMfCFTbHCayilfGSjg1H
         NQ7g==
X-Gm-Message-State: ACgBeo22Kgmap8cBvV4ZuPRRgMXDf2U2Z/9kY25Y10fDvVl0Y5kVBpIP
        dBdWKjduO7yJ19ga8Rym4Jlm/F6jeqY=
X-Google-Smtp-Source: AA6agR480J6nT8JPDWkIdj0GINl2OslL/GR05i5SE5Z+09zC9SyVLBrf89VzEYsRUdV+7hj1/cUCdQ==
X-Received: by 2002:a05:6a02:115:b0:41c:4d5f:876 with SMTP id bg21-20020a056a02011500b0041c4d5f0876mr15480717pgb.419.1661132246112;
        Sun, 21 Aug 2022 18:37:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902a38300b0016f154c8910sm7044406pla.204.2022.08.21.18.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 18:37:25 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
Subject: [PATCH linux-next v2] KVM: SVM: Remove the unneeded result variable
Date:   Mon, 22 Aug 2022 01:37:20 +0000
Message-Id: <20220822013720.199757-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Return the value from sev_guest_activate(&activate, error) and
sev_issue_cmd_external_user(f.file, id, data, error) directly
instead of storing it in another redundant variable.And also change
the position of handle and asid to simplify the code.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
v1 -> v2
Suggested-by: SeanChristopherson <seanjc@google.com>

Change the position of handle and asid.
Change the explain about this patch.
Dropping the comment about asid + handle.
 arch/x86/kvm/svm/sev.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 28064060413a..4448f2e512b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -276,31 +276,24 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
-	struct sev_data_activate activate;
-	int asid = sev_get_asid(kvm);
-	int ret;
-
-	/* activate ASID on the given handle */
-	activate.handle = handle;
-	activate.asid   = asid;
-	ret = sev_guest_activate(&activate, error);
+	struct sev_data_activate activate = {
+		.handle = handle,
+		.asid = sev_get_asid(kvm),
+	};
 
-	return ret;
+	return sev_guest_activate(&activate, error);
 }
 
 static int __sev_issue_cmd(int fd, int id, void *data, int *error)
 {
 	struct fd f;
-	int ret;
 
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
 
-	ret = sev_issue_cmd_external_user(f.file, id, data, error);
-
 	fdput(f);
-	return ret;
+	return sev_issue_cmd_external_user(f.file, id, data, error);
 }
 
 static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
-- 
2.25.1
