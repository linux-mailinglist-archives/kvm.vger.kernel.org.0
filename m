Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3041601849
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJQT6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJQT6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B914474E12
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f9-20020a25b089000000b006be298e2a8dso11495679ybj.20
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXN3DrxcNJ/Y/78wkRcairOywvsIdqiZwcK1G1DVGE4=;
        b=oeemi9W1/NxTBGN+bi9ENS2eCzjdUF2iUZSF50JhLehojM563m9xTeji358OLyx/Ko
         In2tJJsWxYNooHpB8nCKPIJh7QXAKL8V5cD2diGLIFs1QCtp1KQ35D7UyilwSMEiZvwq
         aNSWvgtXiTIjl8q3nI2kS0UksX3kAnBSUlHLW3GuCoKZnQc5ZI/4+44dlqLd3P9qaoic
         tvGT/l59bDNFqMnaa1KgE2JGsn97IbrxMWIQBPv+VAIuX1foYOuk9F3+uLgFQun37d2c
         vg6d3ZzTlzG+W6vBrw3/y7UQQA6fKOCM0Q3nnUOitNafMD8JWj0v4i4uEJyBt3u2wnGI
         BhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXN3DrxcNJ/Y/78wkRcairOywvsIdqiZwcK1G1DVGE4=;
        b=gu5Qd1mOxgGb7y7NtaeQX5Ww2d9H0bYoQuddFqQqcOihvBUBSP+EnKmM0+EkPAT/3/
         YqI4MkyLpBZHpsA6YxhWzGs5s0zlbnKiSYeTbIOowcAtTYecGKkyN64PDcY57gK+Py2H
         7nZhyZYQM1Q30HjfgsZqdoZcamcKv0xUXKm2m7rb2Tq2KeScuvxPOERwke7bcSUhRR0p
         yQkpj+2lwywn95zXYizqPSj5dgSh07iAlAschwl7s3HAfIQDrRWc1L3jxjabl0dw8ZIc
         ydINWjseG7eDLVFT9A2buQA3krkrrbEm68Ja2SNraQwwxx00YhvsPjZihewbv3nU9K+n
         L81Q==
X-Gm-Message-State: ACrzQf0RzGu/9iRc29MxMspieeFFqSPgEL+HGeJ8NX2M+hbd7fk8y0oQ
        LoVVx+KbzHcmgXKgwWPZMZF9ldElXQvXf26wLG5pjKAmTq2xrsQmxiC8kQk8SvfawdbbgdiMjAh
        QLAF41f87RdjRs+XETcfo+JX/o7jZdoAwEGUBJkSPs0/YJQkKBzFrhlySizcdmrc=
X-Google-Smtp-Source: AMsMyM6uVRlnbaLwPvA5cv3CBaCfTtzZp4rvmAYbniP0zzjm8hjFbla7cidTFWAF8yo4gU9zCY481meE5wgeTg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:ad5d:0:b0:357:1aeb:843d with SMTP id
 l29-20020a81ad5d000000b003571aeb843dmr10576032ywk.44.1666036720654; Mon, 17
 Oct 2022 12:58:40 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:22 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-3-ricarkol@google.com>
Subject: [PATCH v10 02/14] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Add a library function to get the PTE (a host virtual address) of a
given GVA.  This will be used in a future commit by a test to clear and
check the access flag of a particular page.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h       |  2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index a8124f9dd68a..df4bfac69551 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -109,6 +109,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
+
 static inline void cpu_relax(void)
 {
 	asm volatile("yield" ::: "memory");
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..63ef3c78e55e 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -138,7 +138,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 
@@ -169,11 +169,18 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
-	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
+	return ptep;
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-	exit(1);
+	exit(EXIT_FAILURE);
+}
+
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep = virt_get_pte_hva(vm, gva);
+
+	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
-- 
2.38.0.413.g74048e4d9e-goog

