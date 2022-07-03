Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E261656497E
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 21:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiGCTQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 15:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbiGCTQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 15:16:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46954617A
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 12:16:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b13-20020a170902e94d00b001692fd82122so3855678pll.14
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 12:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PJho9CZvmlpqVROBIgjr58I6W6rS70wBDTVWcl2x88M=;
        b=dhfgXlXI+DKmrDGLYwp9oOHhs6iNnxgr/7LrX1Czf60haKVLts/OWxV1q1W0WtjlPx
         rpq0sZUrRepj8TAHoOI7TJMBUXRFaBpc+aLRh0G7c0FEF7L2/z54a0qiPvmczqkpsE22
         YzZYdQjx6LXrALy4kxfRBAWBlEBNjt7Se8qaLhmRirl5baAOiGUV8e5huGh/EVdcBt+7
         tMvK1NkhrXodKPyYa98L+5eA32FkWc1rEf9jha2iTKzcKzVM4Y6+U4zhT6yLSyDR1L3v
         NNZHDxDTd/ukUKB5ysOItJVfC/wR+axxVDbNWPsI253zvoj9eqgIu5Di1OX/NZqA023m
         rsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PJho9CZvmlpqVROBIgjr58I6W6rS70wBDTVWcl2x88M=;
        b=t1eJaoqDXvohK7laly45LCVrYCx2wAcqlMJ76YQcyfF3tx0eL4U4C/NQIBkrFKY+eO
         JywgV0a6//ARGksurMt7RMRcPqfGpq4FdieYJ+/Hjnhlgiu9MxMtNg0TscblQpVk8bZE
         63bsmvKuZuB1vsV87H0ISSJCAcNoGYeyFMNOY8G1DYDBgF6+H1LbOy9xxqHfaJlpEori
         LcMGCtOi03Oj7MdAzeH6m3u4WZq1+MW9ude0CKEHNkq86wvQeE0FZvTFA363c8wv/CX0
         pykx2/GOLYGpDpfWcJmVjxMQJvHDGLSrCuJ2BHofS8rhTxeQ1rZgh4ckhXTGw9Fv/prP
         p3Xw==
X-Gm-Message-State: AJIora+E0kZrQm9S4frHK/mQZ480kRt5BKg2tsohjAcmK4rhSV5waqx/
        TX66zIb05iLizCBzbIsdjJnyHDjEcqGTyVE5o3KwiJD8sR189tICuleDK+t/X6Og2Y7jLTdGMzS
        eLIV4icYywigfRa4AgsU5c5NAusNxzrQfKNGgp6AYaz6CRkokZSK/5sWTmRHjOOYbLxiW
X-Google-Smtp-Source: AGRyM1thoph7A8CcRJheWKWoPcMNifgQHb9oCTYqRTCuGYJZOOJJ3jyU1vu0tH4vyPCe08oUq2p/S5anDsXmZfxp
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:3027:b0:528:195f:11e2 with
 SMTP id ay39-20020a056a00302700b00528195f11e2mr18833258pfb.24.1656875807741;
 Sun, 03 Jul 2022 12:16:47 -0700 (PDT)
Date:   Sun,  3 Jul 2022 19:16:35 +0000
In-Reply-To: <20220703191636.2159067-1-aaronlewis@google.com>
Message-Id: <20220703191636.2159067-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220703191636.2159067-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 2/3] KVM: x86: update documentation for MSR filtering
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the documentation to ensure best practices are used by VMM
developers when using KVM_X86_SET_MSR_FILTER and
KVM_CAP_X86_USER_SPACE_MSR.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5c651a4e4e2c..bd7d081e960f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4178,7 +4178,14 @@ KVM does guarantee that vCPUs will see either the previous filter or the new
 filter, e.g. MSRs with identical settings in both the old and new filter will
 have deterministic behavior.
 
+When using filtering for the purpose of deflecting MSR accesses to userspace,
+exiting[1] **must** be enabled for the lifetime of filtering.  That is to say,
+exiting needs to be enabled before filtering is enabled, and exiting needs to
+remain enabled until after filtering has been disabled.  Doing so avoids the
+case where when an MSR access is filtered, instead of deflecting it to
+userspace as intended a #GP is injected in the guest.
 
+[1] KVM_CAP_X86_USER_SPACE_MSR set with exit reason KVM_MSR_EXIT_REASON_FILTER.
 
 4.98 KVM_CREATE_SPAPR_TCE_64
 ----------------------------
@@ -7191,6 +7198,16 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
 can then handle to implement model specific MSR handling and/or user notifications
 to inform a user that an MSR was not handled.
 
+When using filtering[1] for the purpose of deflecting MSR accesses to
+userspace, exiting[2] **must** be enabled for the lifetime of filtering.  That
+is to say, exiting needs to be enabled before filtering is enabled, and exiting
+needs to remain enabled until after filtering has been disabled.  Doing so
+avoids the case where when an MSR access is filtered, instead of deflecting it
+to userspace as intended a #GP is injected in the guest.
+
+[1] Using KVM_X86_SET_MSR_FILTER
+[2] KVM_CAP_X86_USER_SPACE_MSR set with exit reason KVM_MSR_EXIT_REASON_FILTER.
+
 7.22 KVM_CAP_X86_BUS_LOCK_EXIT
 -------------------------------
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

