Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614DA404310
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349848AbhIIBm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350461AbhIIBmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:42:22 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177BBC061151
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:39:08 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 1-20020a630e41000000b002528846c9f2so143904pgo.12
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lTqRO0idkBiaTW7ItUglmOAQqB88QiCZDRsI2c4OZ58=;
        b=dfmrkza0ggbmDEkjnJXOJPPETnwr63qICydj3Wpk8FVdGfgYnUe3tdRfwf43izmZlh
         JxSOd1JqW1MTS0/ZHkQAgMprhPbV4BSXeeIgbYbBKCA3AWlwrnCAMQOskkdJFtl3SpNS
         NYlk8NySDfFVwsWLNbt2aS2gMdiUIkjGqwUlX44XPD2fRg7V9U35AJtKn/mf6byslUqD
         NL5atvXUVIEsY54aZVVM2EKW1bkWeIMUnjVL5L817AjCF1JO7Y+b6N8XSmkYDpYuLgN4
         YHDXKEqFOETcnAtyGUP//89V6/7ir8IEwum8I50MTn0aWy8o2ROanviCskBO+Lby+UH4
         Dn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lTqRO0idkBiaTW7ItUglmOAQqB88QiCZDRsI2c4OZ58=;
        b=eAKxTFw1P/7kXViOfH2zB4/koKT/TJrqUIzTy799cm/xGqKr1ieyQhFQFxHqbUel7f
         8CX6F5Mc/kpU6UjltLbuYvAa8nCsrPOCMGYtWxBUIZcZIpooK8JmGkjGkWyJcsYRsx5Q
         MU7s1qtOSm4r0SEnhdapw2bQTUxxl1Fcz7Z/aYixis0nHeiWfJzwzW7ylZpwx15RoZvp
         YpPB0kk3MtaQijkJCvMld8oHPwumLDtml3y3nQW6Z/wanEGIMZq1p1l+ofHjjk+ucFRi
         2WBaCJRI0zl6Qj+Ixj2OwmNlYZSD+GwOJLC8zMYgQA7iKqMIYjB4VJj5881NpafJaW6Q
         Y75Q==
X-Gm-Message-State: AOAM533lSO5lqCyXdC7WAprrUiFsgxG+Mz4HH8qamuESyFb9T/52IjKk
        3m+uiPzcReT9X+95j+KfGdM/fpmGD0yB
X-Google-Smtp-Source: ABdhPJyc3BV8YSCcmMBcGFTF2wB4u0hyIS/oC54sk3TRAH4F3aSdUtllvTioIXtRosmVEfGWFTdqYH0KLtaf
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:38cc:: with SMTP id
 nn12mr608867pjb.139.1631151547473; Wed, 08 Sep 2021 18:39:07 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:18 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-19-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 18/18] KVM: selftests: vgic_init: Pull REDIST_REGION_ATTR_ADDR
 from vgic.h
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pull the definition of REDIST_REGION_ATTR_ADDR from vgic.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 623f31a14326..157fc24f39c5 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -13,11 +13,10 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "vgic.h"
 
 #define NR_VCPUS		4
 
-#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) (((uint64_t)(count) << 52) | \
-	((uint64_t)((base) >> 16) << 16) | ((uint64_t)(flags) << 12) | index)
 #define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
 
 #define GICR_TYPER 0x8
-- 
2.33.0.153.gba50c8fa24-goog

