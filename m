Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23CA6D21DC
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjCaN5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCaN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:57:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B77BEF81
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:29 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ew6so89878074edb.7
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680271047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2ecs728xz8eViS6nyVKhqitH9aCAjKZcKOdrIrAaoo=;
        b=Z5+sJCH6Rdpn4imX4E2kh7GtAC06BaNjDvKp13hIOuvKgI4S4RFhRIWjIkVf0S/GaA
         lHPN4JDS4rtdyBqVQantSbktQoOtW4CSpESCdm9j5lafgt9M0/AqD+k5lp7/qRSF4yxD
         FL3L07t6DD6B8u6fQ1LjA0aL6Kh8v0vhQtx2u4GtBZU/yigUTotN2S6MjEj6mDdniij0
         PVEHqmeXuDuI9ekrmDO+YUvqozouvq+uohu9VQiRrgAQPbsaU8I4uSgsfCHLZqrc+MiK
         7jmOvGBf1+MIhSsI/wb/7kf0nQOOkJzROb1PZxDMx4tUmRiRXeZAa6M7j6Et0A/QUzN8
         qovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2ecs728xz8eViS6nyVKhqitH9aCAjKZcKOdrIrAaoo=;
        b=MHoNJL7x8Fpv1yl5VGg79p8khVTCceEv2WQtr24ZrOV7DhIrKgx5LXwUekzQSMOJ5+
         oVJL0AGoy3MNx4vuxd1pzKpsvRWVzzMDfgTTe57ZZ7fGYXDpXk4mI/9VWQ1c6uJ3dTMT
         Mout9wtVR9J5+PoxfECUsbiuvQ3A+cbAmdHZGZmoSf0NTH2mfVDw+Vk0fJN1eDrGvBa3
         j2QLbnRXQV3t6YvsQq1fz58wZwzs4QGqg6GiWCbKrWjQR/Oo3XZ4S3CCoSFc2HW4Eely
         3Wgl1JSWb2c8NKj9FHqb/ji2BaQ9fWe0rw5Rs503IJ7TSzT6iUFf37exvsFppkoBfgDQ
         K9rg==
X-Gm-Message-State: AAQBX9cXcNwxcdN791RrswlAq4aiMB5YmsJEsIwFur2FzjXgJxzSwzjU
        eu2PjZxM8z6/hH/M6k7ex4zVyON6q/E4wR6xvMlxSA==
X-Google-Smtp-Source: AKy350ZYlmhmYtoBoflC7KfeCuy34iMYnLOMdGiG+d/kCb3yilfoqrCbLl9wrxF96O9jVBLyPjsIfQ==
X-Received: by 2002:a50:ed8b:0:b0:502:3ea3:fc24 with SMTP id h11-20020a50ed8b000000b005023ea3fc24mr9918033edr.17.1680271047533;
        Fri, 31 Mar 2023 06:57:27 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af1a510052e55a748e5a73cd.dip0.t-ipconnect.de. [2003:f6:af1a:5100:52e5:5a74:8e5a:73cd])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00928de86245fsm996888ejb.135.2023.03.31.06.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:57:27 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 4/4] x86/access: Try emulation for CR0.WP test as well
Date:   Fri, 31 Mar 2023 15:57:09 +0200
Message-Id: <20230331135709.132713-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331135709.132713-1-minipli@grsecurity.net>
References: <20230331135709.132713-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enhance the CR.WP toggling test to do additional tests via the emulator
as these used to trigger bugs when CR0.WP is guest owned.

Link: https://lore.kernel.org/kvm/ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net/
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/access.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index ae5e7d8e8892..21967434bc18 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1107,27 +1107,43 @@ static int check_write_cr0wp(ac_pt_env_t *pt_env)
 	 * We load CR0.WP with the inverse value of what would be used during
 	 * the access test and toggle EFER.NX to flush and rebuild the current
 	 * MMU context based on that value.
+	 *
+	 * This used to trigger a bug in the emulator we try to test via FEP.
 	 */
+	for (;;) {
+		const char *fep = (at.flags & AC_FEP_MASK) ? "FEP " : "";
 
-	set_cr0_wp(1);
-	set_efer_nx(1);
-	set_efer_nx(0);
+		set_cr0_wp(1);
+		set_efer_nx(1);
+		set_efer_nx(0);
 
-	if (!ac_test_do_access(&at)) {
-		printf("%s: CR0.WP=0 r/o write fail\n", __FUNCTION__);
-		err++;
-	}
+		if (!ac_test_do_access(&at)) {
+			printf("%s: %sCR0.WP=0 r/o write fail\n", __FUNCTION__, fep);
+			err++;
+		}
 
-	at.flags |= AC_CPU_CR0_WP_MASK;
-	__ac_set_expected_status(&at, false);
+		at.flags |= AC_CPU_CR0_WP_MASK;
+		__ac_set_expected_status(&at, false);
 
-	set_cr0_wp(0);
-	set_efer_nx(1);
-	set_efer_nx(0);
+		set_cr0_wp(0);
+		set_efer_nx(1);
+		set_efer_nx(0);
 
-	if (!ac_test_do_access(&at)) {
-		printf("%s: CR0.WP=1 r/o write deny fail\n", __FUNCTION__);
-		err++;
+		if (!ac_test_do_access(&at)) {
+			printf("%s: %sCR0.WP=1 r/o write deny fail\n", __FUNCTION__, fep);
+			err++;
+		}
+
+		if (!fep_available)
+			break;
+
+		if (at.flags & AC_FEP_MASK)
+			break;
+
+		/* Re-test via the emulator */
+		at.flags |= AC_FEP_MASK;
+		at.flags ^= AC_CPU_CR0_WP_MASK;
+		__ac_set_expected_status(&at, false);
 	}
 
 	return err == 0;
-- 
2.39.2

