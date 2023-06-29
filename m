Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE645742844
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjF2O0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjF2O0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 10:26:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD68119B6;
        Thu, 29 Jun 2023 07:26:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b7fdc66e30so4362715ad.2;
        Thu, 29 Jun 2023 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688048800; x=1690640800;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kUwJZctjYducV3lxWsItfiJda79yDZheiv4wcUu4YUI=;
        b=KHrpMeOCPr5UFhoIdVdBX4VnnIGV2yCBH5p9tZ6uzBMFZz0rgVyWKKa+gupXtOuDlc
         3MTOVfI0Vc87zjj8BuyjcK9l7H4PpYsdDVGeZAt+rMFJQsHjSjaeJs0NARd1cdqkhom3
         XLRUSm2aPKF8AtIVqrnTkyOo+tXd35rLLC5D1B6mfkgGzSbIuyBM2f4Xghn1ugB5xFep
         4MMwF/K7PQBiTufdTJhJYv8cimJnSPYeaB1edzawtSg2IwNdpGASY4EyxkF424VIY3Ao
         kvXU3zetUpUejeeI7QTEJUp/1MBmcF8RcOt4/HdTixdb1Rspqp8MjnO/S8PMU1hMWjPY
         RnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688048800; x=1690640800;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kUwJZctjYducV3lxWsItfiJda79yDZheiv4wcUu4YUI=;
        b=ZLPfRNxqXjjtwgzpRrv51qD6W62stWeDc7Ad/1eovxmHqAd92AXjEYaSQpgKrxUwh3
         gcS0DLkndGGOSGjsNfCzYOYliydUHAZrGr6DOAWrKjZwrauv4u0kQBDRt4PYUnJBcuF8
         YshOWrfa5ZZlOQq4n1gV2Cjm/F214Y7NwFS6sRZtlrVOYFasWvhO+C7E1HvzvLAR791t
         7ng4WHaKYoQ4fN24V5FIugKIdcQy1SA6DG8Gh5B/EDj1qQa20COs2KH0NrcMUWirpE8Y
         buuRN6aYGoOY6TuTjAWcPQzBPBXuDoamJmXanKK40OhjfedhBOKhiDgIuaNZXlnBMvub
         DaBw==
X-Gm-Message-State: ABy/qLaXwDP3ZPtCFgcaOAPI2hwBxvCjStaY4KtAuqKJXD0zqxhyYv6y
        5I3dDcE2YyJMUlkgiKo4Z2U=
X-Google-Smtp-Source: APBJJlHg81GI0EmNynu2USAoK4/5IR5rJdrqSgeTw+GVJdk9hXz8JCcUwh1vMi2geQsM0ITPg4efNQ==
X-Received: by 2002:a17:902:d485:b0:1b8:4f93:b206 with SMTP id c5-20020a170902d48500b001b84f93b206mr2690747plg.65.1688048799943;
        Thu, 29 Jun 2023 07:26:39 -0700 (PDT)
Received: from localhost.localdomain ([114.84.30.247])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b001b5656b0bf9sm9146526plh.286.2023.06.29.07.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 07:26:39 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Fix the meta info of test cases in the header comments
Date:   Thu, 29 Jun 2023 22:26:33 +0800
Message-Id: <20230629142633.86034-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

From: Like Xu <likexu@tencent.com>

Fix test case names (including descriptions) in comments for
tsc_scaling_sync and xen_shinfo_test. No functional changes intended.

Fixes: e467b0de82b2 ("KVM: x86: Test case for TSC scaling and offset sync")
Fixes: 8d4e7e80838f ("KVM: x86: declare Xen HVM shared info capability and add test case")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c | 4 ++--
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 5b669818e39a..cdb214660e0a 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * svm_vmcall_test
+ * tsc_scaling_sync
  *
  * Copyright © 2021 Amazon.com, Inc. or its affiliates.
  *
- * Xen shared_info / pvclock testing
+ * Test case for TSC scaling and offset sync
  */
 
 #include "test_util.h"
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 05898ad9f4d9..60daee9f3514 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * svm_vmcall_test
+ * xen_shinfo_test
  *
  * Copyright © 2021 Amazon.com, Inc. or its affiliates.
  *

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 
2.32.0

