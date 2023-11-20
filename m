Return-Path: <kvm+bounces-2068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8476A7F1348
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2B11C217AE
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CE71B283;
	Mon, 20 Nov 2023 12:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A5690IHY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AEEF1
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:39 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3b58d96a3bbso2516130b6e.1
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700483378; x=1701088178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVtcKgv20LGM4a/3eAwD6D8Boi3eiNlt7PGrZyJ4r68=;
        b=A5690IHY/0dXRDIOrN4z9z+n5iplif3FRGglQfms9D/hEpCnXFR0BM+OFK6LnEDRJi
         khzZ3shFXCV/HPmHMD7JbwE2v5i2bgCwQCwXYfZOv4cLl4GP1JqrFhlWDo3vVmWRMHaH
         Jd5yLl7uUUX40YuGnkyDqcDrC3SjwgUx/pJjPeu1BhIMJopDTpufrdUztzVHJMSpSx77
         VVOmcNGmMDG5XZs37ABCUrF5hsWuz5rIdzzlDbkjqJAYq/LIQeknBGLOfJ/QD72CKisk
         +kmehBjTOhbNn9r1rqMFf1Po3305rSlgL05LvKu1ZYl3Ma35ptgA6UE13n9h+b+jsZcx
         6J/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483378; x=1701088178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mVtcKgv20LGM4a/3eAwD6D8Boi3eiNlt7PGrZyJ4r68=;
        b=njkgfOOZ3Lef//JUUiCwi7y/ZOv7UVUbHvVlKpfEXluyEkCCP/SSuD6XeSkIz20fwg
         3nikH9MShswvb7YfhlI+nV+LC03tKbXR35WBCcJii9C0dwYmqPwf6w//z+YpEwFAl0qs
         zzOUboXW4/GFXhvN8UdYzn/S3dST1kLLSH9a548qCli98q0fLEy80/ZZkVN4kym0JXx/
         AXtTe+Pl9LKLS9U0038q54AALkGgfhudFB7P3uE5iPJcrs3gXoOLEAlXh18GqcIABfC7
         R8kfnltnUxJViJG8Ouq4wb59AcS7qEh5JO85TWc6f3VoffJ1mLIpQ2+hXgQlGL+/84Yt
         azFw==
X-Gm-Message-State: AOJu0YxCZZn57RcSlC0HrG7X0xL9g4HPbC55XhBzPPxNWt4zArWhzrcN
	NRbBwq6pH956+juwzwdnSzF80iKbWJI=
X-Google-Smtp-Source: AGHT+IE/xJkhRB7c8BPHyhXoOp1rWqTwX+0SeDW8tXYFFmDIZQ9QsSZFd+/r6JNj+SNKTKJDpNnEuw==
X-Received: by 2002:a05:6808:3082:b0:3a7:5d83:14d2 with SMTP id bl2-20020a056808308200b003a75d8314d2mr9627468oib.17.1700483377969;
        Mon, 20 Nov 2023 04:29:37 -0800 (PST)
Received: from wheely.local0.net (203-219-179-16.tpgi.com.au. [203.219.179.16])
        by smtp.gmail.com with ESMTPSA id d13-20020a056a00244d00b00690fe1c928csm6047477pfj.147.2023.11.20.04.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:29:37 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	Sean Christopherson <seanjc@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v4 2/4] KVM: selftests: Add aligned guest physical page allocator
Date: Mon, 20 Nov 2023 22:29:18 +1000
Message-ID: <20231120122920.293076-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231120122920.293076-1-npiggin@gmail.com>
References: <20231120122920.293076-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

powerpc will require this to allocate MMU tables in guest memory that
are larger than guest base page size.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 44 ++++++++++++-------
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e592a75ec052..46edefabac85 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -703,6 +703,8 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
+vm_paddr_t vm_phy_pages_alloc_align(struct kvm_vm *vm, size_t num, size_t align,
+			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..22cf6c0ca89f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1924,6 +1924,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * Input Args:
  *   vm - Virtual Machine
  *   num - number of pages
+ *   align - pages alignment
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
  *
@@ -1937,7 +1938,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+vm_paddr_t vm_phy_pages_alloc_align(struct kvm_vm *vm, size_t num, size_t align,
 			      vm_paddr_t paddr_min, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
@@ -1951,24 +1952,27 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		paddr_min, vm->page_size);
 
 	region = memslot2region(vm, memslot);
-	base = pg = paddr_min >> vm->page_shift;
-
-	do {
-		for (; pg < base + num; ++pg) {
-			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
+	base = paddr_min >> vm->page_shift;
+
+again:
+	base = (base + align - 1) & ~(align - 1);
+	for (pg = base; pg < base + num; ++pg) {
+		if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
+			base = sparsebit_next_set(region->unused_phy_pages, pg);
+			if (!base) {
+				fprintf(stderr, "No guest physical pages "
+					"available, paddr_min: 0x%lx "
+					"page_size: 0x%x memslot: %u "
+					"num_pages: %lu align: %lu\n",
+					paddr_min, vm->page_size, memslot,
+					num, align);
+				fputs("---- vm dump ----\n", stderr);
+				vm_dump(stderr, vm, 2);
+				TEST_ASSERT(false, "false");
+				abort();
 			}
+			goto again;
 		}
-	} while (pg && pg != base + num);
-
-	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
-			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
-		fputs("---- vm dump ----\n", stderr);
-		vm_dump(stderr, vm, 2);
-		abort();
 	}
 
 	for (pg = base; pg < base + num; ++pg)
@@ -1977,6 +1981,12 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return vm_phy_pages_alloc_align(vm, num, 1, paddr_min, memslot);
+}
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot)
 {
-- 
2.42.0


