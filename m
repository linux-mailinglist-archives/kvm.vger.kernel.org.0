Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CE04BD261
	for <lists+kvm@lfdr.de>; Sun, 20 Feb 2022 23:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbiBTWnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 17:43:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243751AbiBTWnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 17:43:00 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC9810FE1
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:38 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 75so12707481pgb.4
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oPA5R1WSU1kKD6bVBGCw5++hf0Sn3ln+ch1niI7ZUvM=;
        b=YnUQVMFbuzAc9BqsUk9FxnbfS8UvmX/lDPHJ/XW+RZMRncv8gnJbrbSvhfZRyPCxWN
         FVdESDLLamaZZyd4tN5TvZGH128f5DlOTW9zISVmiopwbJa8NLmca5+fdlS47U3IYjz/
         /rMeP/Uyfom/qaeO9o5aYvnjNMp4OKAXtVx/1/o8H+TrxPtPWQmyrn3ezvTB1hV60LqZ
         OM0kO58XSH+Nl9Cg9AVahTTIZxibF/gj8yDco+9AxAHHHVRjWPP39AcsoI5fQrr/f2Eq
         4hzl0WyiIcc2VISqx/igqFLX41UTdEt+TXz/9N1nIQpgW6yiB6hlyXHwspNoZpgb9X3X
         iT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPA5R1WSU1kKD6bVBGCw5++hf0Sn3ln+ch1niI7ZUvM=;
        b=en4BeBVN1huimWLP/RAVQ7DlWWxfmRrKb7LaI8H//LVvbhOPWIllz5q1wi4SNcWbLJ
         WIQDl/F1W2LbQvCYDuEn9zngm9a2G2qLsTC7ROpgladHsnGh9/5v6oh1xlHEV/s2BG4g
         ozM/H6WOwHaAhHQIunWk0ir39Qyx0/E1LDFJVGYYN5J5eXNAi5TLuloRN9/Ix3NYw5p8
         d/4XSomz/7XVY7GbYgRaplQUy4gEPAsbvyac2QlqHYniVA8YR3VNRJU0+wAkMl833EgO
         R8opMMD1v8AnF2N7TSvLAgpZm4X4byW+rdPR88twjg54tsJE1ojw3mFVb4j+PviusbJi
         urrA==
X-Gm-Message-State: AOAM531MSvVD4Zbkbn97YGi4BixMwcdEI1e48HipjDCCNplDWOZ5UnHt
        KfDcxwMUjFBZ/DEoDoC53/2yBKFcm3Q=
X-Google-Smtp-Source: ABdhPJxSV28JK7J7cuPXysHCJM1puMXC77hYskvfqX6VDacNfziD32928xM1LT1fEp9EMQDY5zigUw==
X-Received: by 2002:a05:6a00:198e:b0:4e1:52be:877d with SMTP id d14-20020a056a00198e00b004e152be877dmr17607577pfl.78.1645396958064;
        Sun, 20 Feb 2022 14:42:38 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id gk17sm605629pjb.15.2022.02.20.14.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 14:42:37 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 1/3] x86 UEFI: pull UEFI definitions for file operations
Date:   Sun, 20 Feb 2022 14:42:32 -0800
Message-Id: <20220220224234.422499-2-zxwang42@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220224234.422499-1-zxwang42@gmail.com>
References: <20220220224234.422499-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

Pull kernel's UEFI definitions for file operations. These definitions
will enable kvm-unit-tests to read files from the disk image, through
UEFI services.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/linux/efi.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 455625a..a811bbd 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -1,5 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Relevant definitions from linux/efi.h. */
+/*
+ * Relevant definitions from
+ *   - linux/efi.h
+ *   - drivers/firmware/efi/libstub/efistub.h
+ */
 
 #ifndef __LINUX_UEFI_H
 #define __LINUX_UEFI_H
@@ -58,7 +62,10 @@ typedef guid_t efi_guid_t;
 	(b) & 0xff, ((b) >> 8) & 0xff,						\
 	(c) & 0xff, ((c) >> 8) & 0xff, d } }
 
-#define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+#define ACPI_TABLE_GUID			EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+#define LOADED_IMAGE_PROTOCOL_GUID	EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2, 0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
+#define EFI_FILE_SYSTEM_GUID		EFI_GUID(0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
+#define EFI_FILE_INFO_ID		EFI_GUID(0x09576e92, 0x6d3f, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
 
 typedef struct {
 	efi_guid_t guid;
@@ -416,6 +423,77 @@ struct efi_boot_memmap {
 	unsigned long           *buff_size;
 };
 
+#define __aligned_u64 u64 __attribute__((aligned(8)))
+typedef struct {
+	u32			revision;
+	efi_handle_t		parent_handle;
+	efi_system_table_t	*system_table;
+	efi_handle_t		device_handle;
+	void			*file_path;
+	void			*reserved;
+	u32			load_options_size;
+	void			*load_options;
+	void			*image_base;
+	__aligned_u64		image_size;
+	unsigned int		image_code_type;
+	unsigned int		image_data_type;
+	efi_status_t		(__efiapi *unload)(efi_handle_t image_handle);
+} efi_loaded_image_t;
+
+typedef struct {
+	u64			size;
+	u64			file_size;
+	u64			phys_size;
+	efi_time_t		create_time;
+	efi_time_t		last_access_time;
+	efi_time_t		modification_time;
+	__aligned_u64		attribute;
+	efi_char16_t		filename[];
+} efi_file_info_t;
+
+typedef struct efi_file_protocol efi_file_protocol_t;
+
+struct efi_file_protocol {
+	u64		revision;
+	efi_status_t	(__efiapi *open)	(efi_file_protocol_t *,
+						 efi_file_protocol_t **,
+						 efi_char16_t *, u64, u64);
+	efi_status_t	(__efiapi *close)	(efi_file_protocol_t *);
+	efi_status_t	(__efiapi *delete)	(efi_file_protocol_t *);
+	efi_status_t	(__efiapi *read)	(efi_file_protocol_t *,
+						 unsigned long *, void *);
+	efi_status_t	(__efiapi *write)	(efi_file_protocol_t *,
+						 unsigned long, void *);
+	efi_status_t	(__efiapi *get_position)(efi_file_protocol_t *, u64 *);
+	efi_status_t	(__efiapi *set_position)(efi_file_protocol_t *, u64);
+	efi_status_t	(__efiapi *get_info)	(efi_file_protocol_t *,
+						 efi_guid_t *, unsigned long *,
+						 void *);
+	efi_status_t	(__efiapi *set_info)	(efi_file_protocol_t *,
+						 efi_guid_t *, unsigned long,
+						 void *);
+	efi_status_t	(__efiapi *flush)	(efi_file_protocol_t *);
+};
+
+typedef struct efi_simple_file_system_protocol efi_simple_file_system_protocol_t;
+
+struct efi_simple_file_system_protocol {
+	u64	revision;
+	int	(__efiapi *open_volume)(efi_simple_file_system_protocol_t *,
+					efi_file_protocol_t **);
+};
+
+#define EFI_FILE_MODE_READ	0x0000000000000001
+#define EFI_FILE_MODE_WRITE	0x0000000000000002
+#define EFI_FILE_MODE_CREATE	0x8000000000000000
+
+#define MAX_FILENAME_SIZE	256
+
+struct finfo {
+	efi_file_info_t info;
+	efi_char16_t	filename[MAX_FILENAME_SIZE];
+};
+
 #define efi_bs_call(func, ...) efi_system_table->boottime->func(__VA_ARGS__)
 #define efi_rs_call(func, ...) efi_system_table->runtime->func(__VA_ARGS__)
 
-- 
2.35.1

