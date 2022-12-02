Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9392F640C6B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiLBRo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiLBRoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:55 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F74EDEA6F
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:49 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id d4-20020adfa404000000b002421ca8cb07so1235719wra.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+6nwI+wYM9c9YZVdbndQ6TxTN9W/+nNFqEhLqsjkJc=;
        b=mi/f7ytkyjY0Am7KUqq6EOBz7u2kq0MYJvgHN5n/7RzdPsO9rRpOMmvvxYgDdb+xml
         5GcRwdnaTOLu3RiCjEQcUkdTMRVKb6pHSMbZg5KosIVzYSSrQM1zo89mx5M20okx6NPK
         vZHHr9q4Vj6Ui4hKHelMnjUr16KmQRxCgW9sc6PXk8CBSu5GlrtK2iyTdyB/j/m3ewRQ
         TVYsW/FoGSsPDHkqz4Z9OoAFAk3KGrofrjrC/eLYyFF/wTj63CBFVt8U+fsJy/reSlp5
         W53bM+dBq6acCq6haW7jzugTtwzvpcBNACbA0ttPkeJDkgOPK2kY6fmf+QIZ/nlo3f6n
         9Rfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+6nwI+wYM9c9YZVdbndQ6TxTN9W/+nNFqEhLqsjkJc=;
        b=vcs8WxHEpFBDYcDXpsuC/rxLaX4x1WLmQNpLEMXeqfs9xtc7AyGgbYNZ78bWlFbl1+
         M0OM/DvPMHwX7a7m2UsaDMkJBmL9jE78dtRspuWAmynfp8CGSImNQqmeNrSrSauK5iDC
         sT+fP+pEOAkT78TKpMC5uilC2KMHNa42dJWIegM4kDQtMdXn+RkMQGYc2z3BRoOFkLAh
         fPMaIkptMJlFwhOTB5xtKMqnGD6zKwiyhawtx80clXYWq4N8VTuw3sUB40hwaQ+/CZTP
         r+asPilIgFoTWlBGEHZxn3rcRL7dNh+mmcm44601LGZS7wyfATv57ZKAljmIEo0GQ2vk
         bcuA==
X-Gm-Message-State: ANoB5pmfULDzPUxYGBoiGDTNxO6S2zQqQuy1JDjIW1uIqnFiTzkNCpNF
        mWXEWprggObI+NqVkKyogv4WwTzoR45CGtDcuiXbKJUXmYSRyf8oW385kw8uxuRdWdO6Wz0hIcp
        t3q5raIuKqtaA8/ZdOxiUWPSWp9a8lxFCBjXA/wr/g1JldMXpSvfV3Kw=
X-Google-Smtp-Source: AA0mqf625dyZl+co1cKdjTkPOEIOLFPXesGpLXi0oNCmuwnM7mLiiuLNZWbXGoKwhYrw5BvWSQfn2j2ohw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f6ca:0:b0:241:dc52:5556 with SMTP id
 y10-20020adff6ca000000b00241dc525556mr35846345wrp.291.1670003088151; Fri, 02
 Dec 2022 09:44:48 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:58 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-14-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 13/32] Use new function to align memory
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
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
2.39.0.rc0.267.gcb52ba06e7-goog

