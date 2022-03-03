Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0D44CC5B5
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiCCTMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiCCTMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:12:34 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D4B12624;
        Thu,  3 Mar 2022 11:11:47 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id b5so9348803wrr.2;
        Thu, 03 Mar 2022 11:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edxzlT0ua6q/WXD1RlHEu98j/w9wI0fapmJTiBUe15k=;
        b=GQXrOrivW1MnjCYBa5LVMnvnaOVAw209ImFARkARXMI3U9X8Kc3+9+eUvssQCdUD9N
         rpSkWDp6atspq7VRacpcfJT7nCvGtyaFvCmbk4ljd3XjHezeDsd8TvadKPRk+Yk5C5p2
         6vXiC/OjRQOjdeLmJky0H+7Xdx6aU1S4cFZBz0CLe2edjLSz0uFifnbLbkdsbAr/fyz8
         5wHxh8o9wGzLgFnqKoermHZG/NwTGge6LEkyOTyC42B1obldTZsoS7KCDHQ3hzQBEkmO
         q/GJ2rU/oJe90f4R0pgVmjv1B4GApmxgqaeoo9BVJEBJh6lgSWKdbhZ/1Ihnz3Zw4qgW
         7NCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edxzlT0ua6q/WXD1RlHEu98j/w9wI0fapmJTiBUe15k=;
        b=rDbcb3IEL4GM5IO9MwlXj6S02WRe31N9OQxlN8RiVA1A2SNG4YuJyTBmJMgG5ToV+Y
         15s5XlUC2IDrWo0RePIGN0t6skOw18+0ymevzCFY2skqBxPDr7BWQgBSONvBhKmAFUwd
         /3ETAvADXKbO36GqU4eGCLE/fY8gM9qQIIY0wNEVOG7OX2eSVS6thpCdL3hP5VaUEJQs
         9UMNYtdOg3oSm5iSjafd8ARUu56fY1Ug5Q8EDGb6eqgk40OhFi2SAEAQafND9eh6oqEw
         xab2UFWYo+lHEhkRWqCe+XzfzG44h53PeXUMVaTP5up5Ww+lfDoWT8l8JAD2kWTN9bcv
         IXVA==
X-Gm-Message-State: AOAM5302b3zvf0PUtwAzgk/bjXkvJ8BV+c8ga1Zllf3j0q87SNJC7kxm
        NlB0H7/2oIjxJYZlRFgWKEo=
X-Google-Smtp-Source: ABdhPJyxh5uuODFt55cQHPPblOjHfDLTnMQ2MQy32zg30St9DxGfGo6u9V5RNhRN6X+uV7/v1lam5A==
X-Received: by 2002:a5d:4578:0:b0:1ed:bf30:40f3 with SMTP id a24-20020a5d4578000000b001edbf3040f3mr28245345wrc.669.1646334705876;
        Thu, 03 Mar 2022 11:11:45 -0800 (PST)
Received: from localhost.localdomain ([102.122.167.77])
        by smtp.gmail.com with ESMTPSA id f13-20020adff8cd000000b001f03439743fsm2811600wrq.75.2022.03.03.11.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 11:11:45 -0800 (PST)
From:   hatimmohammed369@gmail.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hatim Muhammed <hatimmohammed369@gmail.com>
Subject: [PATCH] Fixed function pointers coding style issues
Date:   Thu,  3 Mar 2022 21:11:20 +0200
Message-Id: <20220303191120.7503-1-hatimmohammed369@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hatim Muhammed <hatimmohammed369@gmail.com>

Signed-off-by: Hatim Muhammed <hatimmohammed369@gmail.com>

Some functions pointers did not provide names for their parameters,
     Fixed that

---
 virt/kvm/vfio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50221c2..37887b158aae 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -35,7 +35,7 @@ struct kvm_vfio {
 static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
 {
 	struct vfio_group *vfio_group;
-	struct vfio_group *(*fn)(struct file *);
+	struct vfio_group *(*fn)(struct file *_file);
 
 	fn = symbol_get(vfio_group_get_external_user);
 	if (!fn)
@@ -66,7 +66,7 @@ static bool kvm_vfio_external_group_match_file(struct vfio_group *group,
 
 static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 {
-	void (*fn)(struct vfio_group *);
+	void (*fn)(struct vfio_group *_vfio_group);
 
 	fn = symbol_get(vfio_group_put_external_user);
 	if (!fn)
@@ -79,7 +79,7 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 
 static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 {
-	void (*fn)(struct vfio_group *, struct kvm *);
+	void (*fn)(struct vfio_group *_vfio_group, struct kvm *_kvm);
 
 	fn = symbol_get(vfio_group_set_kvm);
 	if (!fn)
@@ -92,7 +92,7 @@ static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 
 static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 {
-	long (*fn)(struct vfio_group *, unsigned long);
+	long (*fn)(struct vfio_group *_vfio_group, unsigned long _n);
 	long ret;
 
 	fn = symbol_get(vfio_external_check_extension);
@@ -109,7 +109,7 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
 {
-	int (*fn)(struct vfio_group *);
+	int (*fn)(struct vfio_group *_vfio_group);
 	int ret = -EINVAL;
 
 	fn = symbol_get(vfio_external_user_iommu_id);
-- 
2.35.1

