Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771154CAEEA
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241448AbiCBTnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241971AbiCBTnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:43:12 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A974A659E
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:42:27 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id k5-20020a926f05000000b002be190db91cso2014825ilc.11
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PCKbeMGnbMeKELdpOCOC6blFVgcWYPGEsQUKnbyj5go=;
        b=G0al7m5j2pHc4CKpHFPbAvY1Su3hfl9KYNhpUHasUGXkhZjiwnSE+L077x7HJGzxhc
         cXxJ4JwUSVkKnpf8t/HmJRhM/x7wMALqVExeShd5thY955fKWd0ZT1UDe9XqFSzvPOO8
         quu5C+hjVXWH6BPLfsrW7fsKuxo5LMd5VcUVYQ/a875oeBm6weKOwER47OXLQcfoom3E
         bvCqMHgoxfudytYMYZfl6faLp+vBLT32Hovs7p8zi5DP/ZWtvHNqV16WAWPYBIh3Z99M
         bsZpxeOWhQsHz0W9mZQX15ftuqL6gvEKdG4nUEodgpIE6yZgiKjw9azLE0aScrTir43i
         RNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PCKbeMGnbMeKELdpOCOC6blFVgcWYPGEsQUKnbyj5go=;
        b=DlouFct8yNvzXQkbI2/nJlIZjXmPRj+yuchJNx9l73eqOfITZ0E9OrbAsyQenvYvgX
         4dv2Qv5k+cg/tIL+7H3rEbdoDVBfW7n+1x0qFL8wijMnx5lz25GCtWXZEHopEKWRvE8o
         91iCdI0DVYKC7g5YwiXUaA5LEaW3Y+3mbC8bSyIux32frGh8vkHShH/Z8PGRTl15P9u+
         /lqGxQXVZqyUwBzoDicmGO5SbACTM7MV9IdNt9DYNErIepsrAdK9FcMjYU71fxnos5Gq
         OLUPqgKw4Kv3n2Ix5E0ycvo5xdD6qFKfh6j5BEhAdc4IRnEV+F+awi9EsyEdBtpk9EDf
         OUhA==
X-Gm-Message-State: AOAM533HA4APo6BnsjzfbafBfxDXOWUn6SxiWtyeZe+XzvVJeqOV9Iyj
        K0+DvR3O9Yw7FUIZf5Y63wRxT0bczqo=
X-Google-Smtp-Source: ABdhPJzREjaDgmMlO/8NJ9+/tMKnX5excwPLRFEHZ26PVrArvstUOygEWptrPRZ3dGEPxnpxWkN+HOgNpHE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a594:0:b0:314:365c:3a4f with SMTP id
 b20-20020a02a594000000b00314365c3a4fmr24710782jam.162.1646250147094; Wed, 02
 Mar 2022 11:42:27 -0800 (PST)
Date:   Wed,  2 Mar 2022 19:42:21 +0000
In-Reply-To: <20220302194221.1774513-1-oupton@google.com>
Message-Id: <20220302194221.1774513-3-oupton@google.com>
Mime-Version: 1.0
References: <20220302194221.1774513-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 2/2] Documentation: KVM: Move KVM/arm64 docs into aptly named directory
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM64 is the only supported ARM archiecture for KVM now. Move all the
documentation into a new directory, arm64, making the file structure
consistent with this change.

While we're at it, rename hyp-abi.rst to el2-abi.rst for the sake of
consistency with the architecture as well.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../virt/kvm/{arm/hyp-abi.rst => arm64/el2-abi.rst}       | 0
 Documentation/virt/kvm/{arm => arm64}/index.rst           | 8 ++++----
 Documentation/virt/kvm/{arm => arm64}/psci.rst            | 0
 Documentation/virt/kvm/{arm => arm64}/ptp_kvm.rst         | 0
 Documentation/virt/kvm/{arm => arm64}/pvtime.rst          | 0
 Documentation/virt/kvm/devices/vcpu.rst                   | 2 +-
 Documentation/virt/kvm/index.rst                          | 2 +-
 7 files changed, 6 insertions(+), 6 deletions(-)
 rename Documentation/virt/kvm/{arm/hyp-abi.rst => arm64/el2-abi.rst} (100%)
 rename Documentation/virt/kvm/{arm => arm64}/index.rst (76%)
 rename Documentation/virt/kvm/{arm => arm64}/psci.rst (100%)
 rename Documentation/virt/kvm/{arm => arm64}/ptp_kvm.rst (100%)
 rename Documentation/virt/kvm/{arm => arm64}/pvtime.rst (100%)

diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm64/el2-abi.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/hyp-abi.rst
rename to Documentation/virt/kvm/arm64/el2-abi.rst
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm64/index.rst
similarity index 76%
rename from Documentation/virt/kvm/arm/index.rst
rename to Documentation/virt/kvm/arm64/index.rst
index 78a9b670aafe..b0110fcf5eb1 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm64/index.rst
@@ -1,13 +1,13 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-===
-ARM
-===
+=====
+ARM64
+=====
 
 .. toctree::
    :maxdepth: 2
 
-   hyp-abi
+   el2-abi
    psci
    pvtime
    ptp_kvm
diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm64/psci.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm64/psci.rst
diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm64/ptp_kvm.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/ptp_kvm.rst
rename to Documentation/virt/kvm/arm64/ptp_kvm.rst
diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm64/pvtime.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/pvtime.rst
rename to Documentation/virt/kvm/arm64/pvtime.rst
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 92942440a9e7..ab9d81421488 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -159,7 +159,7 @@ Returns:
 
 Specifies the base address of the stolen time structure for this VCPU. The
 base address must be 64 byte aligned and exist within a valid guest memory
-region. See Documentation/virt/kvm/arm/pvtime.rst for more information
+region. See Documentation/virt/kvm/arm64/pvtime.rst for more information
 including the layout of the stolen time structure.
 
 4. GROUP: KVM_VCPU_TSC_CTRL
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index b6833c7bb474..4bf7e0eef6a1 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -25,7 +25,7 @@ KVM
 
    review-checklist
 
-   arm/index
+   arm64/index
 
    devices/index
 
-- 
2.35.1.574.g5d30c73bfb-goog

