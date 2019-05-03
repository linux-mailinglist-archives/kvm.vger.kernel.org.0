Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB0313368
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfECRym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:54:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37209 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbfECRyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:54:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so3066661pgc.4
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 10:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EjWUD7AEqMZh2AEG40y523x+dTHNGBkinNX6q5avIyQ=;
        b=KzybIdD9Nledj8gbnchJ/42ZCvnTN3Gft7IFaN0iMfzEf8E1qEH8B6j3cy8GPmy55P
         97U85tr3XCpgeF/khjKBg0p9E30hGJ+YglWgfGvtauU2CO9oC/kiuUP3tus3AL+JRQkb
         numi057UzU7DMkhRe0wYUpLHfqmkcDTA2mpellLKopQsvyjYavttwogzSvP+XwuGMhW6
         k943n4kQVFEou3n1YRE2MpT5HlMcqFcB2qaCI5Wr2qYHPs1WPQvaGWckRyG6LwS/YBfZ
         BogQi4VMCq/VuZkXWLGQkdwAJO4yh7cAOrJaAHtAM+XLd6DukDho1BLEUvCktbCHZ5XI
         LNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EjWUD7AEqMZh2AEG40y523x+dTHNGBkinNX6q5avIyQ=;
        b=eZsXdlRnVOsMbWJR28GE/rPgCdWo/O3vrqD4LlgBXn+aI03rrMIUd6jbj6BVCOFhKE
         nW7CEHhIh/2TIJ8EnR4EGaDDZvd5wIQn9sbQuJFpr+4PWCC30nb5ohKq485GXaHYPk6m
         cmfxEH8HfmJHAzHnFNBCtyjAwE5JbSvFWz4ut3Ani2RnbioawzsaJccS2b6MEnP4GzJk
         oE8WFTvCRPcTgU+CnJZaehjG0P8ejvzF4lFonpdEhFcMK4LLTCYG0ml+ONIqzs35EFHV
         WzZyloLvSxld9qOk+BYt2IeBTq7K1G0cr3N0U2ldqCOuf3r5DUheGiTC17uOXgEYqvgP
         ++oA==
X-Gm-Message-State: APjAAAVqTJTwyXgKxRZAzMuFGcF3fnazYwxD0fsEf5zrgleUFMTui7Z9
        4GICQmxSVY8cZv6N0Enuy4E=
X-Google-Smtp-Source: APXvYqxGsRxJY1KpSS7F9Hh8g0V0pbqLwlMCtSuDVWrjZsVxnnFodlXl2wW3TFHePgLWExdA7R1kMQ==
X-Received: by 2002:aa7:92d1:: with SMTP id k17mr12819132pfa.91.1556906080695;
        Fri, 03 May 2019 10:54:40 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p20sm3717311pgj.86.2019.05.03.10.54.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:54:39 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: Remove redeundant page zeroing
Date:   Fri,  3 May 2019 03:32:07 -0700
Message-Id: <20190503103207.9021-5-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503103207.9021-1-nadav.amit@gmail.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

Now that alloc_page() zeros the page, remove the redundant page zeroing.

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

