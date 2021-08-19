Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D077B3F1845
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 13:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhHSLfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238749AbhHSLfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 07:35:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CF4C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k29so8598272wrd.7
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eC9zp1q36Ee/jP4TtRNuvYFMVVhl5Tzhsv3C+E9+clA=;
        b=LJZf/WYhzqWl0RAfYmmDt5TufJvd03obtVO8/gTVcFVlmXAEAlkW+GAqOt2ieAMeaC
         LhQqse5t9BoLo2hOnVXTuJKzb5pPNwFela0R32qMBcWhLPt3qFtPlwppUvbJRI8pGEmT
         CCU8+e36tt+MlGC6d+WgudecFRacLdJEqaEOqwuG4ggdzk9SD91H6ezzYcSfyzJh1Ods
         ZcXUNtkYCyynMIec8V7dNXhRX9oLCyhgv3G8p8vgfGArcAKbjpwi0BRbt83XrS56pq/9
         RM6/0KBCmW8wUniowS2SXA5PBY7bqUeRfRssb2tpUejOvZjCIkXKfCTpFaGFxnjQaDp0
         nlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eC9zp1q36Ee/jP4TtRNuvYFMVVhl5Tzhsv3C+E9+clA=;
        b=o2yMS/HjmqTCqFrHUumAYEEuTJAmKi5Ab4geUdglzkQkIhlhw3tYMRSgvoaynMlTZc
         rC0VhVN8wE2+AZ/TkweLsk2cztTZRtrkzPKPCKEeUAsJMT4BugDii8tw66MKa1z23YyY
         cwOofeNZaqIKPKsNV4dhA4wU/g9Z5jREMgSB1WSabxhuAWI0CieR3Pr5p5IVbYWtK4bn
         zt+w3jg1VO71vqAQrQ/uOiGX+STRXVMm/PT+jrfiEkmzk2VKekYyj6AaJExdb27YfuwE
         PEje0tOml0o/SioEb5ya8aezHvgsVw+vz/zi2PZtoz8Lk1hNwYrd9SZZ1ehXg9/AwjIJ
         2lEg==
X-Gm-Message-State: AOAM531jkr29H7KWX9BclG0n9JeEcAvQjahBTDfQnIQQl/5rKq9R9kiW
        3wafzICbOsLeEjCvfk0lJnU=
X-Google-Smtp-Source: ABdhPJz4Y9alIqUQrC1EJg6AywOllPOB1o2+33bJpldYtzx/8W5FlFar+l6BOMRspJEmtv8LOjVKag==
X-Received: by 2002:adf:f943:: with SMTP id q3mr3301475wrr.118.1629372914735;
        Thu, 19 Aug 2021 04:35:14 -0700 (PDT)
Received: from xps13.suse.de (ip5f5a5c19.dynamic.kabel-deutschland.de. [95.90.92.25])
        by smtp.gmail.com with ESMTPSA id w11sm2682859wrr.48.2021.08.19.04.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:35:14 -0700 (PDT)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v2 4/6] x86: efi_main: Self-relocate ELF .dynamic addresses
Date:   Thu, 19 Aug 2021 13:33:58 +0200
Message-Id: <20210819113400.26516-5-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819113400.26516-1-varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFI expects a relocatable PE, and the loader will patch in the
relocations from the COFF.

Since we are wrapping an ELF into a PE here, the EFI loader will
not handle ELF relocations, and we need to patch the ELF .dynamic
section manually on early boot.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi_main.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/x86/efi_main.c b/x86/efi_main.c
index 237d4e7..be3f9ab 100644
--- a/x86/efi_main.c
+++ b/x86/efi_main.c
@@ -1,9 +1,13 @@
 #include <alloc_phys.h>
 #include <linux/uefi.h>
+#include <elf.h>
 
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_system_table_t *efi_system_table = NULL;
 
+extern char ImageBase;
+extern char _DYNAMIC;
+
 static void efi_free_pool(void *ptr)
 {
 	efi_bs_call(free_pool, ptr);
@@ -93,11 +97,70 @@ static efi_status_t exit_efi(void *handle)
 	return EFI_SUCCESS;
 }
 
+static efi_status_t elf_reloc(unsigned long image_base, unsigned long dynamic)
+{
+	long relsz = 0, relent = 0;
+	Elf64_Rel *rel = 0;
+	Elf64_Dyn *dyn = (Elf64_Dyn *) dynamic;
+	unsigned long *addr;
+	int i;
+
+	for (i = 0; dyn[i].d_tag != DT_NULL; i++) {
+		switch (dyn[i].d_tag) {
+		case DT_RELA:
+			rel = (Elf64_Rel *)
+				((unsigned long) dyn[i].d_un.d_ptr + image_base);
+			break;
+		case DT_RELASZ:
+			relsz = dyn[i].d_un.d_val;
+			break;
+		case DT_RELAENT:
+			relent = dyn[i].d_un.d_val;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!rel && relent == 0)
+		return EFI_SUCCESS;
+
+	if (!rel || relent == 0)
+		return EFI_LOAD_ERROR;
+
+	while (relsz > 0) {
+		/* apply the relocs */
+		switch (ELF64_R_TYPE (rel->r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_RELATIVE:
+			addr = (unsigned long *) (image_base + rel->r_offset);
+			*addr += image_base;
+			break;
+		default:
+			break;
+		}
+		rel = (Elf64_Rel *) ((char *) rel + relent);
+		relsz -= relent;
+	}
+	return EFI_SUCCESS;
+}
+
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
+	unsigned long image_base, dyn;
 	efi_system_table = sys_tab;
 
 	exit_efi(handle);
 
+	image_base = (unsigned long) &ImageBase;
+	dyn = image_base + (unsigned long) &_DYNAMIC;
+
+	/* The EFI loader does not handle ELF relocations, so fixup
+	 * .dynamic addresses before proceeding any further. */
+	elf_reloc(image_base, dyn);
+
+	start64();
+
 	return 0;
 }
-- 
2.30.2

