Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A856849B118
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbiAYKCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiAYJ72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:28 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C105BC06173D;
        Tue, 25 Jan 2022 01:59:27 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 133so17875929pgb.0;
        Tue, 25 Jan 2022 01:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zKa7O9jly0TmC+XlGqqr6BfbIZ5VWJb9uLLAbrIft7I=;
        b=N0bWDnPVNDhPyw9vRxjj9dkZtaXUb2VFb7HUs8semTHvhI/1Hd7Hpg9GNm+ML1uuwr
         /FzSQSLrx8UnlpyDh9fGJnm+T/jKcqPZ1TlPV6NPXlcNlOE9Ifq8SpaPajGGZJ0vK3Lg
         2EkE3at11G5IuzfQxA+PrPspn/zspzLS4od1dsKl9icgvhPUbxk9E5LitonWzPMO6r6w
         zbDEaKJx0+g7AyHm0WEN20Na4//L6325eQK50QbABBAgupk9CPC8MQpbiKtlUp7BtSSy
         PgQmaJzaTlnDbd9LZGUBwuoKMUpZi13MmsbwOnn5HMipT9iwSh+kmYUFd8QRB9QINgB+
         E5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zKa7O9jly0TmC+XlGqqr6BfbIZ5VWJb9uLLAbrIft7I=;
        b=HIlUmhcsfVrpAusqrGzqDwFLYBjg7xOG/fovGz4Nj5as6/8ik04NE09gDzAs7As5ry
         r6Y2WGK1MJHmQ2DQJzmnx5jPh3NylQhaxJbPSZ1a7RlkGDIuv7xA4vXodaGLSnzpf9NU
         RWGaVsR/Dz+B5Mc7HP3YHl/Ld/XxJZ68Cdx8MuGQkIEDOGS6PE/UuOcesMDe+yE4Mqbq
         jl4jLA2YTnFhs9a20Nz3P0eszbW/m/UU7Mh12Xiv9ECm6ycoB76mxPBBUgOdzwaQP1FN
         Tw7C1PhHuYgf4MOsI7S2+SFahiunuIVkJzX/eMafDDdmCiGnqCWJbA1n5QR4JbhpU+Qa
         m+mw==
X-Gm-Message-State: AOAM532a62sHQ6MJo0iiteiIDwgtmkw4FOs+G3BoPn1cxS4lg9t7leFV
        jEXNc9KhbE/81cEhU/0hlAk=
X-Google-Smtp-Source: ABdhPJy1jcF+7YUEA9nKFYorWmaFH66iBFZi30z3MGYnvjZXwMqhEynxgPjjUUDaHaNR6SnlbPmDRg==
X-Received: by 2002:a63:f452:: with SMTP id p18mr14741473pgk.545.1643104767312;
        Tue, 25 Jan 2022 01:59:27 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:27 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] KVM: x86/tdp_mmu: Remove unused "kvm" of kvm_tdp_mmu_get_root()
Date:   Tue, 25 Jan 2022 17:58:54 +0800
Message-Id: <20220125095909.38122-5-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm *kvm" parameter of kvm_tdp_mmu_get_root() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc9e3553fba2..d0c85d114574 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -121,7 +121,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 						   typeof(*next_root), link);
 
-	while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
+	while (next_root && !kvm_tdp_mmu_get_root(next_root))
 		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 				&next_root->link, typeof(*next_root), link);
 
@@ -203,7 +203,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
-		    kvm_tdp_mmu_get_root(kvm, root))
+		    kvm_tdp_mmu_get_root(root))
 			goto out;
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3899004a5d91..599714de67c3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,8 +7,7 @@
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
-__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
-						     struct kvm_mmu_page *root)
+__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
 	if (root->role.invalid)
 		return false;
-- 
2.33.1

