Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFBB3F92BB
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244160AbhH0DNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B91C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 32-20020a6315600000b029023caa2bfec4so502184pgv.20
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6Or8JGri7gHTTsWTaZhjhFlqCYKlq3JhtE5Agq3KsCM=;
        b=X0G7T0UCY0YXpFZSMAtPi9Y7lq/g0O23xteuI5QCtrYneqmXlViLiI3Ri1mEaiOT9P
         g9hotFquJHMX/1BIGaO6L+V9znINaD/Ie6f+yY34ngICdzz1xNcpU/MXZy1tgEmABIRt
         MAIQSdoqImOnOcLQvwO0V8Q4o5+VKRtYXz1Lsm86mO8ZHDh6XcuQ8ITuz3ZiNsJRt3U7
         6A5eUMWN37I+MrzsRz4vNetpZxRl9715IlkjLqQQiYaunRE6CIrECy5Nu2d/QAQmGNte
         KEY8nZc8Zy+DZ4Awkt//I/LLV3jXuNpE+o2BZSCq/KHf+LcGUII1AfqF6ArNbYf0U1qK
         8mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6Or8JGri7gHTTsWTaZhjhFlqCYKlq3JhtE5Agq3KsCM=;
        b=snUVCrRH46SR+sOnytBK7QF1iO4wV9I+1kwxHOnUn54eVVYLUe1/sbetqbVtXUv7ig
         KWytUoovAfHWRLixlR313em6QSvZ8qhdjX+Fn8+ikxgKggq2rsZCydpzeks9EyKp8I+C
         Dy/Lv2aTCKKHsNrC678yGdW8YzP5MnjlCFTocQXKkgLXLB/tCRwe5E8nbmlrLyVIUZeY
         ZEHKTC/bDJEdAy9EvLmT5uByWd5RE+bisZmyvLpJH7OVPLe89iXV/h+PD11BTo8S3cmq
         +UTnMNzApjCBkQmOYiHEVauPUArFPXg4Q9okCDiy9RhBh2RNQjui80+IUYmQBQOPn6rN
         Xesg==
X-Gm-Message-State: AOAM530roLe2g1Wqej1NuJZuoGsvFSKP1QJqKdxoWpDqe+gP6BKqQ0JF
        NdOktrIqoDfe+XW6AFu8Yjc59dycvCYqQnpyt7MOlDH8ZVFlGThD9sIiEFzK0JxyY/Hf0JSBfLR
        nkBOaesGNOFXIpDb2vhtjsCMfRrt2FL8R2LstXRwuGF/K5Kc86KcE4cEVa4C+sWH0kWdC
X-Google-Smtp-Source: ABdhPJyoNq+oMHVqi8CU15SvoSW9msaiv9bTqJaPwie9CkHUzRQISPUBPLpbhylU1fMfcByQkIK/bpI0EwEB0lMN
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6a00:23ca:b0:3e1:2d8:33f3 with SMTP
 id g10-20020a056a0023ca00b003e102d833f3mr6966844pfc.42.1630033970648; Thu, 26
 Aug 2021 20:12:50 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:20 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-16-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 15/17] x86 AMD SEV-ES: Copy UEFI #VC IDT entry
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

AMD SEV-ES introduces a new #VC exception that handles the communication
between guest and host.  UEFI already implements a #VC handler so there
is no need to re-implement it in KVM-Unit-Tests. To reuse this #VC
handler, this commit reads UEFI's IDT, copy the #VC IDT entry into
KVM-Unit-Tests' IDT.

Reusing UEFI #VC handler is a temporary workaround, and the long-term
solution is to implement a #VC handler in KVM-Unit-Tests so it does not
depend on specific UEFI's #VC handler. However, we still believe that
the current approach is good as an intermediate solution, because it
unlocks a lot of testing and we do not expect that testing to be
inherently tied to the UEFI's #VC handler.

In this commit, load_idt() can work and now guest crashes in
setup_page_table(), which will be fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 25 +++++++++++++++++++++++++
 lib/x86/amd_sev.h |  7 +++++++
 lib/x86/setup.c   | 12 ++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index c9fabc4..d1e43ae 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -91,6 +91,31 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
+efi_status_t setup_amd_sev_es(void)
+{
+	struct descriptor_table_ptr idtr;
+	idt_entry_t *idt;
+
+	if (!amd_sev_es_enabled()) {
+		return EFI_UNSUPPORTED;
+	}
+
+	/*
+	 * Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does
+	 * not have to re-implement a #VC handler.
+	 *
+	 * TODO: Reusing UEFI #VC handler is a temporary workaround to simplify
+	 * the boot up process, the long-term solution is to implement a #VC
+	 * handler in KVM-Unit-Tests and load it, so that KVM-Unit-Tests does
+	 * not depend on specific UEFI #VC handler implementation.
+	 */
+	sidt(&idtr);
+	idt = (idt_entry_t *)idtr.base;
+	boot_idt[SEV_ES_VC_HANDLER_VECTOR] = idt[SEV_ES_VC_HANDLER_VECTOR];
+
+	return EFI_SUCCESS;
+}
+
 static void copy_gdt_entry(gdt_entry_t *dst, gdt_entry_t *src, unsigned segment)
 {
 	unsigned index;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 0b4ff8c..aaa4806 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -39,7 +39,14 @@
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
+/*
+ * AMD Programmer's Manual Volume 2
+ *   - Section "#VC Exception"
+ */
+#define SEV_ES_VC_HANDLER_VECTOR 29
+
 bool amd_sev_es_enabled(void);
+efi_status_t setup_amd_sev_es(void);
 void copy_uefi_segments(void);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index c6eb3e9..9075a22 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -227,6 +227,18 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
 		}
 	}
 
+	status = setup_amd_sev_es();
+	if (status != EFI_SUCCESS) {
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			/* Continue if AMD SEV-ES is not supported */
+			break;
+		default:
+			printf("Set up AMD SEV-ES failed\n");
+			return status;
+		}
+	}
+
 	return EFI_SUCCESS;
 }
 
-- 
2.33.0.259.gc128427fd7-goog

