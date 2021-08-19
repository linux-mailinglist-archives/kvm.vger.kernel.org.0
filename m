Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8504A3F1844
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 13:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbhHSLfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbhHSLfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 07:35:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4862DC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:15 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k8so8621100wrn.3
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X0PCbfsKKi5Z5ypmtVXwwsJ90tFRD61CKAIuZBznxzQ=;
        b=mzvwOZaxCgFZJGyZvMfId3C3IezCI6GyI+GXQdTVCBCVlj7kcvUJMFYnK26acek0rl
         WmCUCVot3wpH91GQPmi0JDCcUb8JP2bpZw4VdBRjXT97TjARFJbrpDgkTO8Dh5ETGLUs
         4wom4pVJ4Jq+fxOjf6paiMhqfMaKjcKQmDRht1rrbcdAbV/GcKFTKz2/xPYBbl6W1z1b
         4lDdLMz9hTS7+SVl7Gw7UJMxEJ0NopJoHc3EDraRE+L+qs611THjRfspyYT0TB/z150E
         5vLfqtXePQw+TF3zoMKjUC1Jlsv5lHPl7Hy+mGvNkkSaTBkOlvmDpgFgdcqPdh9erbuH
         FYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X0PCbfsKKi5Z5ypmtVXwwsJ90tFRD61CKAIuZBznxzQ=;
        b=OL/mZRa0VF8yTIx/EwbzQ7uqE9eEt62nZPXrUWeiHTYFwqlsulOpOke43tn1FL6lQx
         71ET5sDEmei2nScYr4xhNJgybfj4wm4kDGiGqRe3ckOzWFkNzdMfpF1t24csle/LQ6Op
         p2uUVLSoq4k7A8BHS2n6DVSzTM8PMBIdR9yW3znqjWmzLyHL4ktNdCOQFMi2EvSo7NwP
         f3c5cK8BkKMqvgtAoMTfgNNvhsCsiwfCjrUA9lCZ/4O8+temZN9Zm9nyAK2e9loqfKE3
         w7ZcBWEKNMwsrWUzH4PhTSGOAy9auuYRD2MxIabov5eyUjNGfv8Xm6YSj+F6GHTnV/kR
         /RrQ==
X-Gm-Message-State: AOAM5325qu3bpcbdVuYnAx7TWoWfF5a7Rm8uEEgLaI4eBWEfWezpdwO4
        0FYBLmGYMmW2/6uyXAxKE9Y=
X-Google-Smtp-Source: ABdhPJwcoN9t04+Zqlr6/VR/FODLc0YPg4z4DCX5jXKkw1S7saURHlykzyFEsxwRuaB2BERyAWlM+w==
X-Received: by 2002:adf:90b1:: with SMTP id i46mr3335993wri.159.1629372913691;
        Thu, 19 Aug 2021 04:35:13 -0700 (PDT)
Received: from xps13.suse.de (ip5f5a5c19.dynamic.kabel-deutschland.de. [95.90.92.25])
        by smtp.gmail.com with ESMTPSA id w11sm2682859wrr.48.2021.08.19.04.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:35:13 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v2 3/6] x86: efi_main: Get EFI memory map and exit boot services
Date:   Thu, 19 Aug 2021 13:33:57 +0200
Message-Id: <20210819113400.26516-4-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819113400.26516-1-varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The largest EFI_CONVENTIONAL_MEMORY chunk is passed over to
alloc_phys for the testcase.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi_main.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/x86/efi_main.c b/x86/efi_main.c
index 00e7086..237d4e7 100644
--- a/x86/efi_main.c
+++ b/x86/efi_main.c
@@ -1,11 +1,103 @@
+#include <alloc_phys.h>
 #include <linux/uefi.h>
 
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_system_table_t *efi_system_table = NULL;
 
+static void efi_free_pool(void *ptr)
+{
+	efi_bs_call(free_pool, ptr);
+}
+
+static efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
+{
+	efi_memory_desc_t *m = NULL;
+	efi_status_t status;
+	unsigned long key = 0, map_size = 0, desc_size = 0;
+
+	status = efi_bs_call(get_memory_map, &map_size,
+			     NULL, &key, &desc_size, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
+		goto out;
+
+	/* Pad map_size with additional descriptors so we don't need to
+	 * retry. */
+	map_size += 4 * desc_size;
+	*map->buff_size = map_size;
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
+			     map_size, (void **)&m);
+	if (status != EFI_SUCCESS)
+		goto out;
+
+	/* Get the map. */
+	status = efi_bs_call(get_memory_map, &map_size,
+			     m, &key, &desc_size, NULL);
+	if (status != EFI_SUCCESS) {
+		efi_free_pool(m);
+		goto out;
+	}
+
+	*map->desc_size = desc_size;
+	*map->map_size = map_size;
+	*map->key_ptr = key;
+out:
+	*map->map = m;
+	return status;
+}
+
+static efi_status_t efi_exit_boot_services(void *handle,
+					   struct efi_boot_memmap *map)
+{
+	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
+}
+
+static efi_status_t exit_efi(void *handle)
+{
+	unsigned long map_size = 0, key = 0, desc_size = 0, buff_size;
+	efi_memory_desc_t *mem_map, *md, *conventional = NULL;
+	efi_status_t status;
+	unsigned num_ents, i;
+	unsigned long pages = 0;
+	struct efi_boot_memmap map;
+
+	map.map = &mem_map;
+	map.map_size = &map_size;
+	map.desc_size = &desc_size;
+	map.desc_ver = NULL;
+	map.key_ptr = &key;
+	map.buff_size = &buff_size;
+
+	status = efi_get_memory_map(&map);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_exit_boot_services(handle, &map);
+	if (status != EFI_SUCCESS) {
+		efi_free_pool(mem_map);
+		return status;
+	}
+
+	/* Use the largest EFI_CONVENTIONAL_MEMORY range for phys_alloc_init. */
+	num_ents = map_size / desc_size;
+	for (i = 0; i < num_ents; i++) {
+		md = (efi_memory_desc_t *) (((u8 *) mem_map) + i * (desc_size));
+
+		if (md->type == EFI_CONVENTIONAL_MEMORY && md->num_pages > pages) {
+			conventional = md;
+			pages = md->num_pages;
+		}
+	}
+	phys_alloc_init(conventional->phys_addr,
+			conventional->num_pages << EFI_PAGE_SHIFT);
+
+	return EFI_SUCCESS;
+}
+
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	efi_system_table = sys_tab;
 
+	exit_efi(handle);
+
 	return 0;
 }
-- 
2.30.2

