Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0122D62970B
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiKOLQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKOLQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:21 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEABA5F8C
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:19 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id c5-20020a1c3505000000b003c56da8e894so10388503wma.0
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lM2yp/osnDi1TeBXG+cCa07bf+K2sNDUuqRai/Rm3iA=;
        b=QqGHZuFt9BpKZpnu1D4I30sZEaQLAMgs4U88rGIHONK9CZbID9l7eFDMzmr4R9tFH2
         5jP0ICK+/ug9aIsQAGfv+5ERmuNsytJ7OR6XO7Fw3NFTN8Gsx7hM7xoYd5FYpH/btxw4
         wcfMS8FSX3RJjFRrMIYIBCu8Zgs09OvxUjZaOMmCbFFs5D2ZI9YxHRZOfHgZtefek1QZ
         r4BV/vDh+RUc31ebxuH2+KLVqp8gW3deY9arRnC/bPvwLvJWb1XkP3VpI0JrOaIf779F
         wqSNtYub+fyFvIFk92aUdvRNgrWI1WWL7qwyGg64ha6Gljr6XZxhoqvnvFql743VGDxG
         upqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lM2yp/osnDi1TeBXG+cCa07bf+K2sNDUuqRai/Rm3iA=;
        b=t5ei9hLoQ463RczoAGmfRJWHtzPIb5/AxdT0zgzw1F2DqkJAq6XTA0zXlfpNs8iCnc
         1Vf7HUzLNI2/SvAqA1DVZWUV3qPJMjBM9akxoZ30bVUFTXN1H0dqTPCFx0dbZqaqH+R1
         9FYkuW3naMvuGh6iwht41dn9K4GDVqwPZeCKWoR3iqcVE/8PLWHcX5ijJ3c9XEcRy1Bl
         4gcKAhs9JrPag5cn/z99ZSMv6gAaQ/seVbSYwgY8YMpUGv05tU2NvVvdww8EqtwTtJxj
         9JytmZZj2iSgCb0iVy9leJ9zWBJzr0MA22+RpEVUG/OaQhijCQBqpktTan9NADoKSSKu
         g2TA==
X-Gm-Message-State: ANoB5pm2MpwUjwwUxr/xrVqKRsxVkrSVtmAhrGnzYScgr9pFLNWDy1b6
        +r5b9guzRdgnUKmY9AgsMAYfV9aen0LH1UsDZSFztufW+6Gaq4cnkjcPRfTOF2iaZlcihIGMp9X
        fHzkb4IUEMrxJw8UF2VZozigwRzgZMT3qPgb2OovHI2EYlM76VsoATBg=
X-Google-Smtp-Source: AA0mqf5yc2TO3aBf8mgzQGCaT6xkTcG4eeSytOnceUTf+c8ZtwUaAPxkK/Ck1/soa22THgPSTMi/oRksFg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3b19:b0:3cf:7514:a80d with SMTP id
 m25-20020a05600c3b1900b003cf7514a80dmr204260wms.0.1668510978137; Tue, 15 Nov
 2022 03:16:18 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:44 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-13-tabba@google.com>
Subject: [PATCH kvmtool v1 12/17] Use new function to align memory
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new mmap_anon_or_hugetlbfs_align() to allocate memory
aligned as needed instead of doing it at the caller while
allocating and mapping more than needed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/kvm.c   | 10 +++++-----
 riscv/kvm.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index c84983e..0e5bfad 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -37,17 +37,17 @@ void kvm__init_ram(struct kvm *kvm)
 	 * 2M trumps 64K, so let's go with that.
 	 */
 	kvm->ram_size = kvm->cfg.ram_size;
-	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
+	kvm->arch.ram_alloc_size = kvm->ram_size;
+	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs_align(kvm,
 						kvm->cfg.hugetlbfs_path,
-						kvm->arch.ram_alloc_size);
+						kvm->arch.ram_alloc_size,
+						SZ_2M);
 
 	if (kvm->arch.ram_alloc_start == MAP_FAILED)
 		die("Failed to map %lld bytes for guest memory (%d)",
 		    kvm->arch.ram_alloc_size, errno);
 
-	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
-					SZ_2M);
+	kvm->ram_start = kvm->arch.ram_alloc_start;
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_MERGEABLE);
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 4d6f5cb..e26b4f0 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -70,17 +70,17 @@ void kvm__arch_init(struct kvm *kvm)
 	 * 2M trumps 64K, so let's go with that.
 	 */
 	kvm->ram_size = min(kvm->cfg.ram_size, (u64)RISCV_MAX_MEMORY(kvm));
-	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
+	kvm->arch.ram_alloc_size = kvm->ram_size;
+	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs_align(kvm,
 						kvm->cfg.hugetlbfs_path,
-						kvm->arch.ram_alloc_size);
+						kvm->arch.ram_alloc_size,
+						SZ_2M);
 
 	if (kvm->arch.ram_alloc_start == MAP_FAILED)
 		die("Failed to map %lld bytes for guest memory (%d)",
 		    kvm->arch.ram_alloc_size, errno);
 
-	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
-					SZ_2M);
+	kvm->ram_start = kvm->arch.ram_alloc_start;
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_MERGEABLE);
-- 
2.38.1.431.g37b22c650d-goog

