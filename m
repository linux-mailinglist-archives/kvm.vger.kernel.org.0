Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC63F92B3
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbhH0DN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbhH0DNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:25 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F6C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:37 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s2-20020a17090a948200b001927a323769so1306641pjo.9
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t39Mv0ccoM5NmVCSCdog5kXFGY+iF5gUOM0LhYajG54=;
        b=KBNz29sATJ6f5pkNlzcQbGiPG9ZqJPAFkiALxlwQQ4yw/aEx+l5OGnMc1iuBvlk3BT
         3hcz3sirD+OdbvDDf7imDbLUusnySs7TQzbbKy2R48FJ6jezH0bFjw1BzMRjyS3EsM2H
         LAAPxTYtyIQhCfQmZMY+6maGi/tTbkP4tf+Vs0cfLy4ZS5ZMCONZRlEKkQRSsH+smU14
         c1pra1OIhTR5tBbB2Icv2D8SDEdHocK9fwDZUwsoyVcO9DC2qlfG/r4PpJqvfK29f6u1
         bIEvXBm09dauFDRxEPOQ/7gVRmHNVd0mSY0kczRBCau/RBxgreIgOYrO7R9N1OQZlF/E
         t/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t39Mv0ccoM5NmVCSCdog5kXFGY+iF5gUOM0LhYajG54=;
        b=fKcnTRv6A/xbeoBgrajkeHqAqkqOsjeaf9OBRtU98uFWBWSIiZBG5XPC9I8QrLqxZm
         hdr44Yv0rG4Diy1VOf24JPT6FFR1vlh7T73jWv37GUAnHJW6L4/uY0Rt9XEC0BJQ878Y
         jFajdcLV1l3HK3PRwF9aOciifwO4Xi308UeYMCiseRAh2UYSEmA1t9MKAxkjc+yvQ1ae
         2KfmP0Ok0uGDK2NpLz0Iad2Or7kPKAGPjxDBBtFq8MK7lTFYShYSvK4lJkXC5FGa516i
         HRj52S857upyz9Q/d4wNYj2Daq8yl/Sibs1JhWmjP7BrWx+m3lybnqhh3DjhlVMWPVvZ
         etNw==
X-Gm-Message-State: AOAM532TJK7GY08ZKhoBERuXzxyFgPkfEkaPoGy2UZN12J+vi+sWUtub
        wrR5TbP4b8Sf2xSU9Pc64XO+0N6pFDYxggrLu20lkqGwcY7bK3ExXiCXqe5rIHT1JyKDOeaH/y/
        JDi7WzpABzrqkpv9aKjEEn9wuUF0aIKhMYrnStvOwv8Z0kTS5JO9Zu9sOaUQTUJjUCQcR
X-Google-Smtp-Source: ABdhPJyINF5JntVdt+ioKhUjqjN/bBOPzrVTD2w1oUoEhnbTpmGTaS/hR+cGgUQSwljD58v2o8zcxVyfggfhcq0F
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a62:7d84:0:b029:3b8:49bb:4c3f with SMTP
 id y126-20020a627d840000b02903b849bb4c3fmr6953419pfc.49.1630033957129; Thu,
 26 Aug 2021 20:12:37 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:12 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-8-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 07/17] x86 UEFI: Set up memory allocator
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

KVM-Unit-Tests library implements a memory allocator which requires
two arguments to set up (See `lib/alloc_phys.c:phys_alloc_init()` for
more details):
   1. A base (start) physical address
   2. Size of available memory for allocation

To get this memory info, we scan all the memory regions returned by
`LibMemoryMap()`, find out the largest free memory region and use it for
memory allocation.

After retrieving this memory info, we call `ExitBootServices` so that
KVM-Unit-Tests has full control of the machine, and UEFI will not touch
the memory after this point.

Starting from this commit, `x86/hypercall.c` test case can run in UEFI
and generates the same output as in Seabios.

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/efi.c           | 28 +++++++++++++---
 lib/efi.h           |  2 +-
 lib/x86/asm/setup.h | 16 +++++++++-
 lib/x86/setup.c     | 78 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 99307db..b7a69d3 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -31,9 +31,10 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
 	unsigned long key = 0, map_size = 0, desc_size = 0;
+	u32 desc_ver;
 
 	status = efi_bs_call(get_memory_map, &map_size,
-			     NULL, &key, &desc_size, NULL);
+			     NULL, &key, &desc_size, &desc_ver);
 	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
 		goto out;
 
@@ -48,12 +49,13 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
 
 	/* Get the map. */
 	status = efi_bs_call(get_memory_map, &map_size,
-			     m, &key, &desc_size, NULL);
+			     m, &key, &desc_size, &desc_ver);
 	if (status != EFI_SUCCESS) {
 		efi_free_pool(m);
 		goto out;
 	}
 
+	*map->desc_ver = desc_ver;
 	*map->desc_size = desc_size;
 	*map->map_size = map_size;
 	*map->key_ptr = key;
@@ -62,18 +64,34 @@ out:
 	return status;
 }
 
-efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map)
+efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
 {
-	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
+	return efi_bs_call(exit_boot_services, handle, mapkey);
 }
 
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
+	unsigned long mapkey = 0;
+	efi_status_t status;
+	efi_bootinfo_t efi_bootinfo;
 
 	efi_system_table = sys_tab;
 
-	setup_efi();
+	setup_efi_bootinfo(&efi_bootinfo);
+	status = setup_efi_pre_boot(&mapkey, &efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to set up before ExitBootServices, exiting.\n");
+		return status;
+	}
+
+	status = efi_exit_boot_services(handle, mapkey);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to exit boot services\n");
+		return status;
+	}
+
+	setup_efi(&efi_bootinfo);
 	ret = main(__argc, __argv, __environ);
 
 	/* Shutdown the guest VM */
diff --git a/lib/efi.h b/lib/efi.h
index 60cdb6f..2d3772c 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -11,7 +11,7 @@
 
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
-efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map);
+efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 
 #endif /* _EFI_H_ */
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index eb1cf73..8ff31ef 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -4,8 +4,22 @@
 #ifdef TARGET_EFI
 #include "x86/apic.h"
 #include "x86/smp.h"
+#include "efi.h"
 
-void setup_efi(void);
+/*
+ * efi_bootinfo_t: stores EFI-related machine info retrieved by
+ * setup_efi_pre_boot(), and is then used by setup_efi(). setup_efi() cannot
+ * retrieve this info as it is called after ExitBootServices and thus some EFI
+ * resources are not available.
+ */
+typedef struct {
+	phys_addr_t free_mem_start;
+	phys_addr_t free_mem_size;
+} efi_bootinfo_t;
+
+void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
+void setup_efi(efi_bootinfo_t *efi_bootinfo);
+efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo);
 #endif /* TARGET_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 0a065fe..a49e0d4 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -131,6 +131,81 @@ extern phys_addr_t ring0stacktop;
 extern gdt_entry_t gdt64[];
 extern size_t ring0stacksize;
 
+void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
+{
+	efi_bootinfo->free_mem_size = 0;
+	efi_bootinfo->free_mem_start = 0;
+}
+
+static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
+{
+	int i;
+	unsigned long free_mem_total_pages;
+	efi_status_t status;
+	struct efi_boot_memmap map;
+	efi_memory_desc_t *buffer, *d;
+	unsigned long map_size, desc_size, buff_size;
+	u32 desc_ver;
+
+	map.map = &buffer;
+	map.map_size = &map_size;
+	map.desc_size = &desc_size;
+	map.desc_ver = &desc_ver;
+	map.buff_size = &buff_size;
+	map.key_ptr = mapkey;
+
+	status = efi_get_memory_map(&map);
+	if (status != EFI_SUCCESS) {
+		return status;
+	}
+
+	/*
+	 * The 'buffer' contains multiple descriptors that describe memory
+	 * regions maintained by UEFI. This code records the largest free
+	 * EFI_CONVENTIONAL_MEMORY region which will be used to set up the
+	 * memory allocator, so that the memory allocator can work in the
+	 * largest free continuous memory region.
+	 */
+	free_mem_total_pages = 0;
+	for (i = 0; i < map_size; i += desc_size) {
+		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
+		if (d->type == EFI_CONVENTIONAL_MEMORY) {
+			if (free_mem_total_pages < d->num_pages) {
+				free_mem_total_pages = d->num_pages;
+				efi_bootinfo->free_mem_size = free_mem_total_pages << EFI_PAGE_SHIFT;
+				efi_bootinfo->free_mem_start = d->phys_addr;
+			}
+		}
+	}
+
+	if (efi_bootinfo->free_mem_size == 0) {
+		return EFI_OUT_OF_RESOURCES;
+	}
+
+	return EFI_SUCCESS;
+}
+
+efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
+{
+	efi_status_t status;
+
+	status = setup_pre_boot_memory(mapkey, efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("setup_pre_boot_memory() failed: ");
+		switch (status) {
+		case EFI_OUT_OF_RESOURCES:
+			printf("No free memory region\n");
+			break;
+		default:
+			printf("Unknown error\n");
+			break;
+		}
+		return status;
+	}
+
+	return EFI_SUCCESS;
+}
+
 static void setup_gdt_tss(void)
 {
 	gdt_entry_t *tss_lo, *tss_hi;
@@ -169,7 +244,7 @@ static void setup_gdt_tss(void)
 	load_gdt_tss(tss_offset);
 }
 
-void setup_efi(void)
+void setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	reset_apic();
 	setup_gdt_tss();
@@ -179,6 +254,7 @@ void setup_efi(void)
 	enable_apic();
 	enable_x2apic();
 	smp_init();
+	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0.259.gc128427fd7-goog

