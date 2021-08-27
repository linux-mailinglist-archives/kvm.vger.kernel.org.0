Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1D13F92AF
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbhH0DNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244082AbhH0DNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8158C0613CF
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f17-20020a170902ab91b029012c3bac8d81so619532plr.23
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TV3XBKvgeVZ3rwCRmDSJpEdlUJZvgFVJ0BSDevfpb6Q=;
        b=HfshYIuZYAIUjDw0eK+CBhq0gXsFxZ+zx+WurVoTsURhuDQPVj+FAfp5gDzHyggXmk
         clyO4CmxMmmQl8WTR30u8ZicWI8TR55uCpP6jS/i4yOPinOJ416zCxNJ8rKagszlOFF9
         2Nq47A2XZ3s7/dGa9Kjlu2RHkniEWL1aUTeCENJbfpPg/m747e4puQgHzyi9RfAbGhsE
         7ezwMUy45b33JD5QThcTOhrMSJfw1+c5yr3p2EpHpDFJsiqC6lM+xV3423LL53ySvrpD
         V8Cs+l8Ldg2VrkqovWpF3BX13CopdOO/duUXvcQyObClN2AZwPwk4iHi/i6Yj3+NPKUH
         1p8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TV3XBKvgeVZ3rwCRmDSJpEdlUJZvgFVJ0BSDevfpb6Q=;
        b=e1FqA/y0RVpvTWy4XSky6XvrnMoSslYh2jwpDICphoKiYOwXTcr4WvLvbvCJAImosg
         I1W3w7Pwvj6SBrtoFXH7LwQEExAJtzWi3GLI8FZD/pscY7p3YEEVfhWtBG4p89XAkloS
         ikhQE9Vy6kQ4Y85k8MXWNm4ruyFGTp9sK+iQ2M5AX3c2NG+t7kvWlvlx5RVm4XHND948
         TE6+lJcCEkn1KazW19iZY0kE87NOk+/At6HlN+jEe6exjRNBusT9C7DVhTP4bYi9Varu
         UqR5HcEODpF5wGF0vjCjw1X3G0kgxr+lscb+RJAtfcDsvu9Dqq2rDHuPqgU6pj4MJmPQ
         1Wbg==
X-Gm-Message-State: AOAM533U/GWNggyYfu9ROfiwaMATncZzkTL0X1eZYBKTUygWmhZ76U15
        kQPddBWaMyFCxkFdi7yycFJVYs2LRvkvt7uQI/34RvXqar+5Ov2duR41APfGb684YIXdow2E0a9
        d8fn13BC5jHTPxrI75XanEEDSv+dqRGLaYa9Qf+mBtpHusbqx8nMHVX5mPGCRoBZBJw6g
X-Google-Smtp-Source: ABdhPJyHsYrPyzUKegLg9DRMzuDfhDJgQ2CV9dLSDePVFZOQm5T3GHpdkVxbLx7pQKj9vvL+lWmIMN5VuvqVVuQR
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:aa7:8d46:0:b029:3cd:c2fd:fea5 with SMTP
 id s6-20020aa78d460000b02903cdc2fdfea5mr6836271pfe.31.1630033948101; Thu, 26
 Aug 2021 20:12:28 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:07 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-3-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 02/17] x86 UEFI: Implement UEFI function calls
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

From: Varad Gautam <varad.gautam@suse.com>

This commit implements helper functions that call UEFI services and
assist the boot up process.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/efi.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 lib/efi.c

diff --git a/lib/efi.c b/lib/efi.c
new file mode 100644
index 0000000..9711354
--- /dev/null
+++ b/lib/efi.c
@@ -0,0 +1,58 @@
+#include <linux/uefi.h>
+
+unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
+efi_system_table_t *efi_system_table = NULL;
+
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
+unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
+{
+	efi_system_table = sys_tab;
+
+	return 0;
+}
-- 
2.33.0.259.gc128427fd7-goog

