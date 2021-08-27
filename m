Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9413F92BC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244163AbhH0DNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:41 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEE8C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u8-20020a056a00098800b003eb2fbd34dcso135953pfg.12
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XPH3ZQXX9I+I0587YaKD8R4psbwwAlYn98ccCyKakYk=;
        b=SwieuOaAQS5W5lkr66cL1H4NoSfyavklD4k+6HKtsPmQFxwPlsUr5YhsAq3KuD06ut
         54LIsODQxJJ/Y3Ucv8Qfv8/67jRGGkh49mtNU1c1Q1SfXZjdESzMQA51SiFt2zNSTBGw
         +amGXCwAycrVkRRHKLNo3XNDjmHzuRCWr+FthJ1pIOMHZi9WpSIPkd1e5AgCStbyErP9
         o0lg2seiQG42zZPL7CjGAODEjCySuTeKlRgUO5IOs4e/3bcYpKvPIz0cmWT2Oa7BVCMR
         gB5FUJmvTvMqRDqIXijiqsgX2nLrkWkU6BZo3G2epBLSejX9ZBFVtK5iKlnj1OcJMo4f
         SUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XPH3ZQXX9I+I0587YaKD8R4psbwwAlYn98ccCyKakYk=;
        b=FT6NsgaHI9mJ9uzZuoYOHeVk1RE1YfKSjgETUMniVd5Mm2H8/yD9VMAIHZKV0M7ZQk
         7hCp2B1ItBioe/tfY2h8whSHyl7A6Y/EfZJkm6J6XqJwq5UhpwTSQYaT6bWsYFxfQ5Ay
         6H2BkRgrZVCvkKFRBfPW4gYlmXcA8POl2Dx6lG014n1c4jOrjafVLXkPpw40zP2WwdDb
         qTbL66X1QhxnsDXRZIHLw2piEMPbpTvVcuu3Np7RnEshzAtjMbT1Fzx1NKAsw4pQ3euu
         nPyWuEx3/Eb+QNTG8PhnpVDLJevOM0uOnc1Xq5LQk0FXBQoR5suRiDGd7Yz0aKt9Ards
         bQqQ==
X-Gm-Message-State: AOAM53111y3GiMMt1FJt4PKdpRBWh4srpuE9l/eBRzOsAsK7lab+NpTp
        W2rtRaV1jTsp47UPBTcFaJwGrIIC2yyRKSSxgGdZAJH3eHyLqOylcvq3krwxYq9IRTw+Wp0Xd7w
        Hu02NmbeRegDLeAMb0yfTWfbLTGNZGnv+9W9y9yCA1W6pbU6lqV1eNU7H84m2xPJLkJ3o
X-Google-Smtp-Source: ABdhPJxPF7ce+g60jM6xNgBJNlfTQXqnu/Xa48pJ2blinykBlQVXHQwck9GOKD/Ci7mB9KlkJRvKLV/tMYM7AN1o
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a62:80d8:0:b0:3f2:72f5:bb31 with SMTP
 id j207-20020a6280d8000000b003f272f5bb31mr3803357pfd.0.1630033972517; Thu, 26
 Aug 2021 20:12:52 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:21 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-17-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 16/17] x86 AMD SEV-ES: Set up GHCB page
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV-ES introduces a GHCB page for guest/host communication. This
page should be unencrypted, i.e. its c-bit should be unset, otherwise
the guest VM may crash when #VC exception happens.

By default, KVM-Unit-Tests only sets up 2MiB pages, i.e. only Level 2
page table entries are provided. Unsetting GHCB Level 2 pte's c-bit
still crashes the guest VM. The solution is to unset only its Level 1
pte's c-bit.

This commit provides GHCB page set up code that:

   1. finds GHCB Level 1 pte
   2. if not found, installs corresponding Level 1 pages
   3. unsets GHCB Level 1 pte's c-bit

In this commit, KVM-Unit-Tests can run in an SEV-ES VM and boot into
test cases' main().

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 37 +++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h |  7 +++++++
 lib/x86/setup.c   |  4 ++++
 3 files changed, 48 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index d1e43ae..e004a7e 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -11,6 +11,7 @@
 
 #include "amd_sev.h"
 #include "x86/processor.h"
+#include "x86/vm.h"
 
 static unsigned long long amd_sev_c_bit_pos;
 
@@ -116,6 +117,42 @@ efi_status_t setup_amd_sev_es(void)
 	return EFI_SUCCESS;
 }
 
+void setup_ghcb_pte(pgd_t *page_table)
+{
+	/*
+	 * SEV-ES guest uses GHCB page to communicate with the host. This page
+	 * must be unencrypted, i.e. its c-bit should be unset. To do so, this
+	 * function searches GHCB's L1 pte, creates corresponding L1 ptes if not
+	 * found, and unsets the c-bit of GHCB's L1 pte.
+	 */
+	phys_addr_t ghcb_addr, ghcb_base_addr;
+	pteval_t *pte;
+
+	/* Read the current GHCB page addr */
+	ghcb_addr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+	/* Search Level 1 page table entry for GHCB page */
+	pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
+
+	/* Create Level 1 pte for GHCB page if not found */
+	if (pte == NULL) {
+		/* Find Level 2 page base address */
+		ghcb_base_addr = ghcb_addr & ~(LARGE_PAGE_SIZE - 1);
+		/* Install Level 1 ptes */
+		install_pages(page_table, ghcb_base_addr, LARGE_PAGE_SIZE, (void *)ghcb_base_addr);
+		/* Find Level 2 pte, set as 4KB pages */
+		pte = get_pte_level(page_table, (void *)ghcb_addr, 2);
+		assert(pte);
+		*pte &= ~(PT_PAGE_SIZE_MASK);
+		/* Find Level 1 GHCB pte */
+		pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
+		assert(pte);
+	}
+
+	/* Unset c-bit in Level 1 GHCB pte */
+	*pte &= ~(get_amd_sev_c_bit_mask());
+}
+
 static void copy_gdt_entry(gdt_entry_t *dst, gdt_entry_t *src, unsigned segment)
 {
 	unsigned index;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index aaa4806..81f5605 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -45,8 +45,15 @@ efi_status_t setup_amd_sev(void);
  */
 #define SEV_ES_VC_HANDLER_VECTOR 29
 
+/*
+ * AMD Programmer's Manual Volume 2
+ *   - Section "GHCB"
+ */
+#define SEV_ES_GHCB_MSR_INDEX 0xc0010130
+
 bool amd_sev_es_enabled(void);
 efi_status_t setup_amd_sev_es(void);
+void setup_ghcb_pte(pgd_t *page_table);
 void copy_uefi_segments(void);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 9075a22..0de3ec2 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -278,6 +278,10 @@ static void setup_page_table(void)
 		curr_pt[i] = ((phys_addr_t)(i << 21)) | flags;
 	}
 
+	if (amd_sev_es_enabled()) {
+		setup_ghcb_pte((pgd_t *)&ptl4);
+	}
+
 	/* Load 4-level page table */
 	write_cr3((ulong)&ptl4);
 }
-- 
2.33.0.259.gc128427fd7-goog

