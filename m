Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B5C640C68
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiLBRoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiLBRoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:44 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A90DEA6F
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:43 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id g14-20020adfa48e000000b00241f94bcd54so1256721wrb.23
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zPOx4m/3fYB8V48egMLSD29AXOysInYZsQD39byc48o=;
        b=FQIh4Qudy3vz3A+da2b6+80WNpXxA3iSS9zKi8944agRqf6/quOaELHt0b4hFvidUM
         5DkPj/6Z9N+JlLHv9priyjLmU4ZmYBr4keAHGsheukiO3SwDqoBJ0HLOwzFvlP+L/k6V
         XDdJQkawhk1FZ5ZE8M+Pe9BcAxNzkpTcqpKRMYTa67MuDf6Ztedm9sfeJFbvaz3TR/zH
         O2xTsWSVIxREWdHQAByQ6ST6P0+8i+PVX2BAUkZZKNrG6JAn0wymuHILCIYE5qDl9JdG
         gfflFlVm2wS+k9kLwaludYpPROhHMbmMSVppxFKHUp6MU+jGVKCZuh0ydfX1l2nSQRz0
         n/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPOx4m/3fYB8V48egMLSD29AXOysInYZsQD39byc48o=;
        b=telnzvefQ9oYE/SoCAJP+DC10Z85yjvIct3kiT1tFqZuJPIeopiACWKXPdw9TD9WXV
         aB4EIlVd7o5+nBGfd2WEGZSALaNefJ4lLmbLi59Z1jLJ4tiT9yRhx56Q4ZqLvx8Jlxrl
         yRpwqBsZCqUJU+fEckcdj2bKDSCDAZy2lFFwkbgObrarrkdEx+s2fE97Vi2ZIC6XT3/B
         NPqP0soeI5krRNbT7oPEv7rUb0p5zYmBSy0o8C/9j9iXxhCg1CEZHNcB7GVB8hnfplVN
         sc6ywtSyZ/9o4DtuZHiueCC7FhdmldKZEvT2X3e2IdFFylDmnSiSs5RD/bRr2Q41arDv
         ZWQA==
X-Gm-Message-State: ANoB5plo0o6HGxDJA+zTUDwU41UwTD9DIkGkKhykaL5AXuH0FN5UuTIO
        Y8TkIZHai9MIyiK7Ro4Qq4fECteUSwYQTsQmXQaBpLFpVwbPaQzufEqGKh4DQIP5d6h0L0oHLFI
        CegRGtHhJ5V0j4tK4uyjwIpFkre3Gc1ngnLp1SfB1ymWgfT9m1w/n8hE=
X-Google-Smtp-Source: AA0mqf7wuzE0gdsOQl9HBIaUjlnvXhJQNLa7uVCrgdG9rkOi7CkkSTdaAqUTvQTHHkoflTdMZwhWzdeW9w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c9f:b0:3b4:cd96:1748 with SMTP id
 k31-20020a05600c1c9f00b003b4cd961748mr204639wms.2.1670003081656; Fri, 02 Dec
 2022 09:44:41 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:55 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-11-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 10/32] Allocate pvtime memory with memfd
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that all guest memory is fd-based.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/aarch64/pvtime.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index 2933ac7..a7ba03e 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -8,25 +8,35 @@
 #define ARM_PVTIME_STRUCT_SIZE		(64)
 
 static void *usr_mem;
+int user_mem_fd = -1;
 
 static int pvtime__alloc_region(struct kvm *kvm)
 {
 	char *mem;
+	int mem_fd;
 	int ret = 0;
 
-	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW,
-		   MAP_ANON_NORESERVE, -1, 0);
-	if (mem == MAP_FAILED)
+	mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0);
+	if (mem_fd < 0)
 		return -errno;
 
+	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW, MAP_PRIVATE, mem_fd, 0);
+	if (mem == MAP_FAILED) {
+		ret = -errno;
+		close(mem_fd);
+		return ret;
+	}
+
 	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
 				ARM_PVTIME_SIZE, mem);
 	if (ret) {
 		munmap(mem, ARM_PVTIME_SIZE);
+		close(mem_fd);
 		return ret;
 	}
 
 	usr_mem = mem;
+	user_mem_fd = mem_fd;
 	return ret;
 }
 
@@ -38,7 +48,9 @@ static int pvtime__teardown_region(struct kvm *kvm)
 	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
 			 ARM_PVTIME_SIZE, usr_mem);
 	munmap(usr_mem, ARM_PVTIME_SIZE);
+	close(user_mem_fd);
 	usr_mem = NULL;
+	user_mem_fd = -1;
 	return 0;
 }
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

