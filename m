Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89BB426E33
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbhJHQAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJHQAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:35 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F090C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:40 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so1871419wrc.9
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
        b=J7ojB2L/g6easuNtOb22T/bQnMBxvkq3yUNrthr9utdVDUVUQvrpyTfNFPqwVu2eNS
         4fvbnv3QwvHgJJCEN1reAisHNn3uROCmL4+zKkTv1zf/x431NyReyFWKolpcKmG85ExA
         1DGKgEJQ3md+BSdcLbo8Bx5UHXABjwMwPbkgsY7SEGMRiI7YcbLHUg7GqzxbzoJ8BiW4
         dK0x+od77qfQ6LvIMcXTTaXtjqeDwOTPItHT+czA5cDDunOoXl6VicpvULiF55DuXn2h
         to/la/+v+M1gJThoSI6bKe3P2gBDxju2tQGS71CmPsvK+uhxXyofScxX0HQlMT13zeWy
         kACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
        b=z4+6B2+Ovi6I6tuP9Gs3/vV1px+6s0gZEVeRif1fojNVrqO69UvZKHgsslXYXM74OW
         7qFF1SjA88A7aq8D8QjUTF1tfayWR4WmDqE2DAWN1P+2zcdYqUrqGJIKmYl0jXTuVPUN
         z2NBoKXTYnmhqJUPzU6VXcHhIHZp255Y2uyfrCgr7L3pKKhIVLLU8JfXOJtumQxP1Bsp
         BuQ3NZJ8PffOHu3PGiNiAItQp90PFz0Kk0Q/63KnzRkwuEESYmO9M4VQReMtosvnxRtz
         YKZMfTONHIF7Oks8IPVqFkqCD534PdBFDq40hOTNZIyWxRNiMiIgB4Hfny9QqfDmmC5W
         y2EQ==
X-Gm-Message-State: AOAM530kHSAlu+PUn50a23EHARJVolhvtSL5L2l8MpqbhPyA97YaInIl
        xrz5dVfWUQa1tFoH3xoVkNhqxDhH9A==
X-Google-Smtp-Source: ABdhPJyu2z910e5hVmwkJoNrLtH1WXLkELfPaK2bV3KGfSoooZdoGdTRArUTVIRMq5kDX+ZAV2ffP5h4Dg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:e906:: with SMTP id q6mr4515684wmc.126.1633708718952;
 Fri, 08 Oct 2021 08:58:38 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:23 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-3-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 02/11] KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

hyp-main.c includes switch.h while it only requires adjust-pc.h.
Fix it to remove an unnecessary dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8ca1104f4774 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,7 +4,7 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
-#include <hyp/switch.h>
+#include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
-- 
2.33.0.882.g93a45727a2-goog

