Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5AB513CE4
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 22:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352014AbiD1Uyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 16:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351959AbiD1Uyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 16:54:43 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA0FC0E5A;
        Thu, 28 Apr 2022 13:51:27 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id s4so4585941qkh.0;
        Thu, 28 Apr 2022 13:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/BaooLzAKHS9Su+qBeGx1AzKlxdTJqpbBgALV7a+lkY=;
        b=MSB06OYuM4vzrWqwQq2U1WVVBwEbaiCPelC6EXPkuZMcw/sC0MEEGljhHmrGZ1z798
         536aKbryjcWX6KGezO6vag8k8Pp+hWnwm+aoTLJ6Pk47FYEcEuXsi0GfQwJdebEcxyvR
         wAwgOyje2Tws5RQxcMNCaok+AI/fR0DOm+fCP1irGLWgwioHqNVXwaFgpzKhqBWSvF0e
         6p0Np4HcorErIoOGYB183hT+pb4R+YbELFpj0PCKjCkpAgEVdeTT+YKNX90unvXGr1j/
         rqTq+XJfwxpIvZeQFh37Z2U7BXv32Q2PWiXhzqIG3MssbY22vWlPidfP5c46y03srtEV
         vZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BaooLzAKHS9Su+qBeGx1AzKlxdTJqpbBgALV7a+lkY=;
        b=OFFty82rNeGBDZFSy6Chg3c87Yp718JegYkg3270oTKIr/qX0AznrOsbRDQ3Oj6msu
         4ifavFoNY0Jub4Q9OJnvVHmkGBc2ZsBPUDqM++ha5UwujzwIJZwZWsWyh6vm8vD8bajP
         LPNKNta3ZOufVU54ieeV6jMR+7tyVb/WQKh1/sQQGNkrgfK16dG3GUBb/Uy4x5MKqS1Z
         JA7DH0qTHkOFXtZbVQd0oGFf9EVyT85hdu8jBVTDboXC052YXgVpk560a953hWl8MOFO
         QgSqaHJI0MAvYbmVwhdGMqzjse7kb9ouyE9OiUny9OjG7Via4nbgikrvXFTMvx09EB47
         W9Iw==
X-Gm-Message-State: AOAM53096Rqkq8dif0I+tM/Nb5I4/kPY/GeZfH4tCavkWSEjuXHaHVyR
        /C4qzoe2SB1PFsl6D7JQZR3H0amygmk=
X-Google-Smtp-Source: ABdhPJwgTBNoaiyndhh2z4VT3EESH1Q5rsnilRmKWwzQG5A8cFDGXw3yE0CM9mJL0lvThT5ehcIv1A==
X-Received: by 2002:a37:a3d2:0:b0:69f:74af:2aef with SMTP id m201-20020a37a3d2000000b0069f74af2aefmr10045059qke.388.1651179086102;
        Thu, 28 Apr 2022 13:51:26 -0700 (PDT)
Received: from localhost ([2601:c4:c432:4da:fa85:340e:2244:1d8c])
        by smtp.gmail.com with ESMTPSA id d65-20020a37b444000000b0069e9f79795fsm494549qkf.67.2022.04.28.13.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 13:51:25 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 5/5] drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate
Date:   Thu, 28 Apr 2022 13:51:16 -0700
Message-Id: <20220428205116.861003-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428205116.861003-1-yury.norov@gmail.com>
References: <20220428205116.861003-1-yury.norov@gmail.com>
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

The smu_v1X_0_set_allowed_mask() uses bitmap_copy() to convert
bitmap to 32-bit array. This may be wrong due to endiannes issues.
Fix it by switching to bitmap_{from,to}_arr32.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index b87f550af26b..5f8809f6990d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -781,7 +781,7 @@ int smu_v11_0_set_allowed_mask(struct smu_context *smu)
 		goto failed;
 	}
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					  feature_mask[1], NULL);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index cf09e30bdfe0..747430ce6394 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -730,7 +730,7 @@ int smu_v13_0_set_allowed_mask(struct smu_context *smu)
 	    feature->feature_num < 64)
 		return -EINVAL;
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					      feature_mask[1], NULL);
-- 
2.32.0

