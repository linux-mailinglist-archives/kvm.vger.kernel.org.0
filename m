Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EF9629706
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiKOLQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiKOLQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:14 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7836551
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:13 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id bg21-20020a05600c3c9500b003c2acbff422so779877wmb.0
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UA7RisSlDwyhxZSwr+fm8P5Gobfl19wI6DqwNPfj+j4=;
        b=ooKD/ZL78K9qjsu9X7pyTNtyTNkSR59YIhoRTWetM9sTWU4Surd/mYArxFcuYkPrX7
         AaiG67gEVRjOiTkUe5PjJazeINyFpdEGfrHJKZ+BAJEzvajFoicIlRMLZhXHR+kNFThy
         Q1wRKt8QOYXXNm4NnJ7G0XmZS/IwV5uxZQC9xgZaVRQHVShJRSCGGBHUPeG8T/ir5nAo
         ER2IAU1iUKkyo1X70r4DT0MxhdRo9Vx5P2w+6qZX3NKfzSWzjMm57MZKBhR+n8OtuWOc
         a8EpttedoZ3Oyk32h8UIj+tSeXiH7pk2YXwNxFukIO9NaPEikxF9evP5lnAG7gUAAG4k
         ZbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UA7RisSlDwyhxZSwr+fm8P5Gobfl19wI6DqwNPfj+j4=;
        b=JnIssVBlvMfyJGMo5+/yFgq92mG+7FODmudfhwqKefAbmk7F+Yr7Aipu+62IlTvVsJ
         SbDAme7AzWSah/GB49qRsL1GQeeCiqPrfcyAHmbTetTEKy9Eh32LrHEsm47nRe7UWG1h
         R5QAMd58btCvVe63bWGdIwqbSPEL0M8GEJN+v8Ehy6bhVAjQ0ku48GUarsFgU3hR6nGX
         w1sLQGCLBxUYy/2PQDfQ8k0HzoIEnwnwzt+5ENhMJyhPQwoUfhIzgL4rhz175g8D3oKc
         C58FGQVi2ZWNgVi6bwKZujjZ03EeM40HqAaghTVpq/vEVOJXruCjOkxToy5ycFYjqjvD
         /R8w==
X-Gm-Message-State: ANoB5pm6lsEOVf95yL7NX8koakkpZe5Pcmt0rv0b4cU9TDul+9FRDHOc
        nXAHwJbYaqEnFgjoLEu9mY93+o3yp+gwEB2ZDv+NOgO8EqYhB6EQ/xduZnVrmJ5RT5qcPuL2RwW
        087MY1YMN1yN9Fbf0YTgGlfzPg7p1Fwcmdt7FU+qgzo41n2xOLLoMThA=
X-Google-Smtp-Source: AA0mqf7SwmuRT9Rqd9LUhGdtwQMchOlIToVJyMO+nke6xLfKgpqdIxdmZJNq1EIVVlJLj5FOykFJdo5HfA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:19c8:b0:3cf:8df5:68dc with SMTP id
 u8-20020a05600c19c800b003cf8df568dcmr1044332wmq.15.1668510971466; Tue, 15 Nov
 2022 03:16:11 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:41 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-10-tabba@google.com>
Subject: [PATCH kvmtool v1 09/17] Allocate pvtime memory with memfd
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
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
2.38.1.431.g37b22c650d-goog

