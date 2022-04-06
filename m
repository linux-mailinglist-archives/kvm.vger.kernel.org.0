Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398EF4F5B2C
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiDFKIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352098AbiDFKHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:07:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E2B8A;
        Tue,  5 Apr 2022 23:37:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 125so1389391pgc.11;
        Tue, 05 Apr 2022 23:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UCjltPZbiAVZx3cBLhNLkq6ISdWaFOqpYWbyIpmYIY8=;
        b=aYmJMX4+yVCOhVjcnIMSqHKgW59WQ62MfrixNQoxDox5zX3fv+nOnR75SgTwSmdOgZ
         Cfw4fVFaL1K6oiUkTykDw68Se9nh8a5vbady465TGooBc6RowGIKFWOrTYhO0lF1GO8/
         7BH2O8G2XW0t5/U8h7WkF+vziF8PZqgJApB0MD3w87/Vqq90N3+JeTdEKZ/LEAQnqa03
         6J0vjZJ36tA46ZnODRk3q1ArRRuWu3dkEyt949DjARplPDz4cHb0OOHoQngZQ6szDcES
         P6KjjfEWZHXFAENwxz3AETvKOaV3P1NFVWcsb8K53PWlE2TA7kpsPmIibs6ZrxlhDJcK
         GKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UCjltPZbiAVZx3cBLhNLkq6ISdWaFOqpYWbyIpmYIY8=;
        b=GY7lOgB1kvDWoAXKw0GUMZXS+K9uLMOqT36LbA+9D/wOxe0sBeNNGzLMOWsungLpUf
         JxC8cJ8NSQPQotnJ4HJdLYiKKzAPtTv4YeG2SrB3gKgUcugObFf4CFRLwbCjaRToLUzv
         c0v+8Px4sQBTUojqujVLHAKMvOeRywMzcXS2XtLS694Z6u31vPlP4a3eCmEifQhSvrOj
         7jdhyLKBWUShQv9ryly8+SCXfnj7ceJQL4GF8aQLgO23Oyy7NiELpQXeYmEO2KH+9NGy
         I5koAA6YbVB/Fjm7ocg9yreohlxZOn3KNJoeHdwRnQ65F47YlWyNxXLjz8r+TLhTEyKt
         3VDg==
X-Gm-Message-State: AOAM530Pcpj29QNn6HYcFyNrgaSUABTx0576GmeNarZBzbpFwoFV9k06
        xCfB/OcqYmWvfJr9iGLnaJc=
X-Google-Smtp-Source: ABdhPJxZqB+AkbQtszf+J1qKq+zgWjVnz9Fawp6JWeB9Hnqiv6G4pUYgjaMq8kSbsS8uFuvFCkhM+g==
X-Received: by 2002:a63:6d4c:0:b0:398:7c40:c160 with SMTP id i73-20020a636d4c000000b003987c40c160mr5913318pgc.109.1649227045337;
        Tue, 05 Apr 2022 23:37:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm17286650pfb.95.2022.04.05.23.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:37:25 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] selftests: kvm: add tsc_scaling_sync to .gitignore
Date:   Wed,  6 Apr 2022 14:37:13 +0800
Message-Id: <20220406063715.55625-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406063715.55625-1-likexu@tencent.com>
References: <20220406063715.55625-1-likexu@tencent.com>
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

The tsc_scaling_sync's binary should be present in the .gitignore
file for the git to ignore it.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Note: hyperv_svm_test has been added in the upstream commit 946ad0499d98.

 tools/testing/selftests/kvm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1f1b6c978bf7..84d5bcf93f8b 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -33,6 +33,7 @@
 /x86_64/state_test
 /x86_64/svm_vmcall_test
 /x86_64/svm_int_ctl_test
+/x86_64/tsc_scaling_sync
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
 /x86_64/userspace_io_test
-- 
2.35.1

