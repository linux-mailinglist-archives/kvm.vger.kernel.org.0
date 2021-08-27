Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270C63F92BA
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbhH0DNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBCCC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:49 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u8-20020a056a00098800b003eb2fbd34dcso135895pfg.12
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uZrve0kQ15HP3z2KuePyyhfbkhhcrwnoA/T8g2iERmI=;
        b=HAijQV9n2kvFCVpu4WKrSYqhGuXDgMZMqgz2QZwXiCHc9dE+QviJx8BH8gH6NI4abc
         Nv36FpRnJiw+gIEol8cRuO1iHglpFBba2m4qd27lHl1SkYdtfclRUpdYoVGp0y7ErhcB
         TTHn4HAbqYrv5DiGymKuC1OhLUTJHTPF7ERfzShVvlMoST2XXQNl5uKy95gBdZxcKqZf
         ypE4pLGWg6zlfL4UI4pzDepeCfmtq83R7NvR+Ak99c4VsmjFPUBzbNcNZN1DsxjtZU2/
         WVj0/WVvrXMmKJd4ShKAuchWXAzjDOLUgz6O2trC16wpLuB0tLZ2kaVaWPTRX6j0Yf3s
         lXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uZrve0kQ15HP3z2KuePyyhfbkhhcrwnoA/T8g2iERmI=;
        b=WF87Ibl0MSj/eeSsCL7V7iTK7GAOavO02vVlGNHVE7OOs6/xBFC2eF7GtT/lyTIndZ
         YLaM966Ma0EYIV/LNNszdJh8EjzMQ2B/m89P2cV7jjE4MChJbAr+GFTHJNlUljbhC5xB
         eZlDpDt+WnJx1OWrboD3y2ZZmysyeP0NDeqY/MNOa6G84P2yXK/LeX2pZjQOh0kfUK06
         P9aJJRG2JZpq2PQk0oagIF1jWNbm2mp8Dv4jds/WfuhpGKCR1ySlhMfslflALX2cJ5B2
         0ljVt+o1wH4fRyDU653AUu7iJvFgdAe/u5g46GY2vcudmyM06Ge3rTq5upVMYLs6+RJY
         3FjA==
X-Gm-Message-State: AOAM5311c/j4J7Lr4NwiaAG3v+kfkV3BUZCXneVVs2sXDy6v9xfBLOke
        nACfJgNWvGu3E+Ecmg3l2Kx7Reigolqipb6EoT+N4wTca0QQES+5I82VsOUPws+v4bshEW0l/Ou
        fKcJHsXl9BKnmkCce+h8SFgB30g5yZN44kvV8hCJvSqEWnXi/GRjmPrm1CrafHccgR5bH
X-Google-Smtp-Source: ABdhPJxA3M1kNuojXNgdNrDa0zdBYaF8mldalWWDCuupojzLvR5mBpw7aNY0Hq9DkB9AocAdzIeYXv8d8JzkESGp
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:aa7:8e4f:0:b0:3ee:27d5:28bc with SMTP
 id d15-20020aa78e4f000000b003ee27d528bcmr6869363pfr.24.1630033969198; Thu, 26
 Aug 2021 20:12:49 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:19 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-15-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 14/17] x86 AMD SEV-ES: Load GDT with UEFI segments
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

Before this commit, KVM-Unit-Tests set up process crashes when executing
'lgdt' instruction under SEV-ES. This is because lgdt triggers UEFI
procedures (e.g. UEFI #VC handler) that require UEFI's code and data
segments. But these segments are are not compatible with KVM-Unit-Tests
GDT:

UEFI uses 0x30 as code segment and 0x38 as data segment, but in
KVM-Unit-Tests' GDT, 0x30 is a data segment, and 0x38 is a code segment.
This discrepancy crashes the UEFI procedures and thus crashes the 'lgdt'
execution.

This commit fixes this issue by copying UEFI GDT's code and data
segments into KVM-Unit-Tests GDT, so that UEFI procedures (e.g. UEFI #VC
handler) can work.

In this commit, the guest VM passes setup_gdt_tss() but crashes in
load_idt(), which will be fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 41 +++++++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h |  1 +
 lib/x86/setup.c   |  4 ++++
 3 files changed, 46 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 8d4df8c..c9fabc4 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -91,6 +91,47 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
+static void copy_gdt_entry(gdt_entry_t *dst, gdt_entry_t *src, unsigned segment)
+{
+	unsigned index;
+
+	index = segment / sizeof(gdt_entry_t);
+	dst[index] = src[index];
+}
+
+/* Defined in x86/efi/efistart64.S */
+extern gdt_entry_t gdt64[];
+
+/*
+ * Copy UEFI's code and data segments to KVM-Unit-Tests GDT.
+ *
+ * This is because KVM-Unit-Tests reuses UEFI #VC handler that requires UEFI
+ * code and data segments to run. The UEFI #VC handler crashes the guest VM if
+ * these segments are not available. So we need to copy these two UEFI segments
+ * into KVM-Unit-Tests GDT.
+ *
+ * UEFI uses 0x30 as code segment and 0x38 as data segment. Fortunately, these
+ * segments can be safely overridden in KVM-Unit-Tests as they are used as
+ * protected mode and real mode segments (see x86/efi/efistart64.S for more
+ * details), which are not used in EFI set up process.
+ */
+void copy_uefi_segments(void)
+{
+	if (!amd_sev_es_enabled()) {
+		return;
+	}
+
+	/* GDT and GDTR in current UEFI */
+	gdt_entry_t *gdt_curr;
+	struct descriptor_table_ptr gdtr_curr;
+
+	/* Copy code and data segments from UEFI */
+	sgdt(&gdtr_curr);
+	gdt_curr = (gdt_entry_t *)gdtr_curr.base;
+	copy_gdt_entry(gdt64, gdt_curr, read_cs());
+	copy_gdt_entry(gdt64, gdt_curr, read_ds());
+}
+
 unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	if (amd_sev_enabled()) {
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index b73a872..0b4ff8c 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -40,6 +40,7 @@ bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
 bool amd_sev_es_enabled(void);
+void copy_uefi_segments(void);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index bdda337..c6eb3e9 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -324,6 +324,10 @@ static void setup_gdt_tss(void)
 	tss_hi->limit_low = (u16)((curr_tss_addr >> 32) & 0xffff);
 	tss_hi->base_low = (u16)((curr_tss_addr >> 48) & 0xffff);
 
+	if (amd_sev_es_enabled()) {
+		copy_uefi_segments();
+	}
+
 	load_gdt_tss(tss_offset);
 }
 
-- 
2.33.0.259.gc128427fd7-goog

