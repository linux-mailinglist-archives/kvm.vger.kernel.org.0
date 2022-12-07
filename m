Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D704645998
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 13:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLGMFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 07:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLGMFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 07:05:21 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F0B2496D;
        Wed,  7 Dec 2022 04:05:18 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f9so16192947pgf.7;
        Wed, 07 Dec 2022 04:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nL5tMNIP5CIUKG866yYq0jxqk6KvygHKPiHerSie/Pk=;
        b=G6EnekbGjZcrMT0lR2LZu1aVwcqsY2CgLDHoH3ih9zB2KUCFeCLb5XBMr8x7os8lah
         MDI0WPgsAYHiQRFu7nPlhMXc41Bo1GOmdv0FqaYs6T533Na9Nz0RrByHVK68qY5GdJxj
         tTX/KN3O6PSx8wAk7sX1VcqeLlWxkPpIyZ0pzBx5Fir5IvnumPYHXyKWq3QwxBfwW+0n
         ew2NfVpC/UXVWjBe863JqATEPAJz8ghgmlhBYqLbt2WayjGaoNtpNEvXKK7Z30IG/cbK
         ZqeNnaHdynuH2HB5ydLbZt7XpMsFh1dirUUjrUnHnkmx0Xb+HjsySIiKzrIR/x0dgtKh
         LxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nL5tMNIP5CIUKG866yYq0jxqk6KvygHKPiHerSie/Pk=;
        b=icEHeqewEmImqeuEfFbLMuHG2UGyO+lb0cG5MNIEhG8rtprBT0OGt9o6OFbz75iJf5
         9oEfSyZNHo2vkLzNqU1IfSbABH7wUVtatAMeNIwuzh+2diJ462cm3QQeOebFKwvlUZQ0
         Uc93+ZdjBy2ByJ+1TdIZNqGKQPCGTs9m89BH36n/mdxgjWVUUNqt49lHUaZzLLsAxMYa
         dAVj6x2BWsqgJxz/7S36G/4A9CO2MeqUE3EY0QqtsdIvjAnxuX3nJ3oGDYdiZ5orVQEr
         pMDZL6/bMTl6AC01udNkFJt0mNCUFV6kVsnXhpnwHZD8TIHzNUq2uLx5dtpRll0Ikj3w
         XsKg==
X-Gm-Message-State: ANoB5pnxF8VJotUEFVV2AyLPtXXiAiwWECKZNlLc1kQldi7a1y1u3QUq
        jbSUg8u0Lh/8UR1PaLb4j/v41bRfsHg=
X-Google-Smtp-Source: AA0mqf7t54V55tRuJgxMoLFjTmLUs+A3ELpyZd4YPAXbIGAqvZ0mjU+Wnf0hb1665gD/2GjaZLt2Wg==
X-Received: by 2002:a63:ed4f:0:b0:438:a751:f8fa with SMTP id m15-20020a63ed4f000000b00438a751f8famr82235298pgk.601.1670414718084;
        Wed, 07 Dec 2022 04:05:18 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id j4-20020a170903028400b00186e34524e3sm7562403plr.136.2022.12.07.04.05.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Dec 2022 04:05:17 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: Remove the unused macro KVM_MMU_READ_LOCK()
Date:   Wed,  7 Dec 2022 20:06:16 +0800
Message-Id: <20221207120617.9409-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

No code is using KVM_MMU_READ_LOCK().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 virt/kvm/kvm_mm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index a1ab15006af3..e98e294080bf 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -14,13 +14,11 @@
 #define KVM_MMU_LOCK_INIT(kvm)		rwlock_init(&(kvm)->mmu_lock)
 #define KVM_MMU_LOCK(kvm)		write_lock(&(kvm)->mmu_lock)
 #define KVM_MMU_UNLOCK(kvm)		write_unlock(&(kvm)->mmu_lock)
-#define KVM_MMU_READ_LOCK(kvm)		read_lock(&(kvm)->mmu_lock)
 #define KVM_MMU_READ_UNLOCK(kvm)	read_unlock(&(kvm)->mmu_lock)
 #else
 #define KVM_MMU_LOCK_INIT(kvm)		spin_lock_init(&(kvm)->mmu_lock)
 #define KVM_MMU_LOCK(kvm)		spin_lock(&(kvm)->mmu_lock)
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
-#define KVM_MMU_READ_LOCK(kvm)		spin_lock(&(kvm)->mmu_lock)
 #define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
-- 
2.19.1.6.gb485710b

