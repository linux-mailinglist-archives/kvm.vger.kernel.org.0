Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CD819710
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfEJD0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:26:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39944 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEJD0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:26:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id d31so2269170pgl.7
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q7h5Qs9EG/wncRXZ7Hbvuyl3Ay6PMSDz6cuLAx/xGP0=;
        b=gQsOEZ+tPYhV+OgzrB1nvGIL/Uy32KUMnCGLs4xZATGSP3kGjgrjSq6YVeRPBFgDsz
         QBybmG6nAvPaFhV4Ka1leg1suyeiOYGr66xnJLCF80BBnkGvW7s7LlaH7yZkzK6EAa+b
         zbNeSyUr0F4g+F7a7AZbi3GZtZ98/6xWTccujIDA4TlviwnXGLtLg3O0c3gbykfrJZnt
         I/PK+VVoyfzxGH/4wPh2gnICg8aQuE8nkuLgloc7Pt0mGJGbwzd7Hfj7Ot+zmAt95M0Y
         Iud9OmdWqHBLwZFzuB9CXp2yPrtjqQStI5L4NHUO0ryKTcImzoU7HBTy6RaawO1/ZndW
         2isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q7h5Qs9EG/wncRXZ7Hbvuyl3Ay6PMSDz6cuLAx/xGP0=;
        b=n/7YrXQKl1FNXP/zOn2cO95sWoX0wCjQ7wcZzLThqQYY2PtVFccYlh1ccb8/p6WYgf
         tu2+2Wb0aSbJXK61Xr/NI68ZVLFiKJGA9BWNjW/2NpT3CmyKFHi8v8QpcRNccyVLl4HU
         YzRc0MIFz0TTqzH5Dnd6m0ElDgjGdn7qM826FHpbh9dcvtCwPFtMWRpHGXwq6anOIG3D
         IbN3OHj3KlrpofSuFnQxGxyIqmTcxud2wFHhxTtFDcefoyNV9Tg88tuwTi6CBIHZWhbU
         LePo6QQMWWAK2NJpoAZ6potOwdReMklkLbN/ZN1skOOw6hhe34A/OaKJzniUVoOKiPJt
         dvKA==
X-Gm-Message-State: APjAAAXCDMeeRjVdx99oqyPDRpYggG4yB5B65buIxs6XNN2wVYDEJ6Hf
        MHx24krBUWIeHSuBHj2KLf68XCiXbfE=
X-Google-Smtp-Source: APXvYqxqdZZKbbq6A/dVk0NLTdhtIkbQk5X6Skp6BQw3AQF2zNLp7eGrbQIED+lgSiSD7ZST0i2ETA==
X-Received: by 2002:a63:f806:: with SMTP id n6mr10702834pgh.242.1557458772705;
        Thu, 09 May 2019 20:26:12 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id z66sm5225592pfz.83.2019.05.09.20.26.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:26:11 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v3 4/4] arm: Remove redundant page zeroing
Date:   Thu,  9 May 2019 13:05:58 -0700
Message-Id: <20190509200558.12347-5-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190509200558.12347-1-nadav.amit@gmail.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that alloc_page() zeros the page, remove the redundant page zeroing.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/arm/asm/pgtable.h   | 2 --
 lib/arm/mmu.c           | 1 -
 lib/arm64/asm/pgtable.h | 1 -
 3 files changed, 4 deletions(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index b614bce..241dff6 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -53,7 +53,6 @@ static inline pmd_t *pmd_alloc_one(void)
 {
 	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
 	pmd_t *pmd = alloc_page();
-	memset(pmd, 0, PTRS_PER_PMD * sizeof(pmd_t));
 	return pmd;
 }
 static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
@@ -80,7 +79,6 @@ static inline pte_t *pte_alloc_one(void)
 {
 	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
 	pte_t *pte = alloc_page();
-	memset(pte, 0, PTRS_PER_PTE * sizeof(pte_t));
 	return pte;
 }
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 03f6622..3d38c83 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -166,7 +166,6 @@ void *setup_mmu(phys_addr_t phys_end)
 #endif
 
 	mmu_idmap = alloc_page();
-	memset(mmu_idmap, 0, PAGE_SIZE);
 
 	/*
 	 * mach-virt I/O regions:
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 5860abe..ee0a2c8 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -61,7 +61,6 @@ static inline pte_t *pte_alloc_one(void)
 {
 	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
 	pte_t *pte = alloc_page();
-	memset(pte, 0, PTRS_PER_PTE * sizeof(pte_t));
 	return pte;
 }
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
-- 
2.17.1

