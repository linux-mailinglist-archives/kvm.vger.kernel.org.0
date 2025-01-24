Return-Path: <kvm+bounces-36506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DA9A1B702
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A8CF3AEA9B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBBB481D1;
	Fri, 24 Jan 2025 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NbqWhWuo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C443594E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725902; cv=none; b=BMTGUthXOFwB8aLrk3nGVpNkS2FfkCRJMjC0oRyUHU50YpiqHbhBTg8+HKNewnlUnKIANmeHIgr42C6D3jGVcn0+tgrPcsSpIc8UFi46/+PmMLIuw8MvbL62+jWPk4WhdzvrAlA+X7kWWcFZTKSZC47pKEnHlXNd2Xi4aAVP+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725902; c=relaxed/simple;
	bh=BWDfYdoXih8AY6i82nzgksQivupZnx5MXYglWsPoykQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TTOh+I9ipiNJREBEzQFNWEFSGk+gE3b7/CCIAtbVNYPxIjMvw6S1csED7gMb4bHz3ztl1G8E75AcMi5r1l54MAx1lKVu4JkO0uGnqLlGPhNWozdYqoQlXwo8ncl35b9Y+SJEYFzglWukafI0THEgiHWQyzxbNqB8jL78Jib8DUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NbqWhWuo; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725902; x=1769261902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BWDfYdoXih8AY6i82nzgksQivupZnx5MXYglWsPoykQ=;
  b=NbqWhWuotIfwEYM0lbfngA+q1aXGFJbImyHvMTd/mUr3u/bzKqNXjOEz
   0LnRVDz0fF2wJIo8ZFzBU5uABgKcMBBR8+PwveqJzQ5pVjd0WZKwzRsqY
   pCEithDueufDdS8ZvEzP2uIKtlUsHqq5nnQLUFQx4Qcx5KHBlvUWxRIvo
   Ffcx3P0SGygb66CyCzF1moa/QwhbkWIlGCYSl3xrdKQWkpaLoMB/j98bl
   9bFOMZh9HRkgzUcWLAKpPRdCZmwEbKqBg3/6bCw5vLZhBKHXbXO6qTBsg
   fridvIimYhnq91J+rEimPbjT7TLzc6KAjlNLt6qcLjFAZZ3Hr261inmIZ
   g==;
X-CSE-ConnectionGUID: zlHvx1wzQHecB762qcLFJg==
X-CSE-MsgGUID: R1xTK62JRiWycfe5WkizLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246382"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246382"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:21 -0800
X-CSE-ConnectionGUID: Ew2wTsMfQBiuCGDqGpzQsA==
X-CSE-MsgGUID: 8tkbM8KsSseO82JElQreaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804298"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:17 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 21/52] headers: Add definitions from UEFI spec for volumes, resources, etc...
Date: Fri, 24 Jan 2025 08:20:17 -0500
Message-Id: <20250124132048.3229049-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
will be used by TDX to build the UEFI Hand-Off Block (HOB) that is passed
to the Trusted Domain Virtual Firmware (TDVF).

All values come from the UEFI specification [1], PI spec [2] and TDVF
design guide[3].

[1] UEFI Specification v2.1.0 https://uefi.org/sites/default/files/resources/UEFI_Spec_2_10_Aug29.pdf
[2] UEFI PI spec v1.8 https://uefi.org/sites/default/files/resources/UEFI_PI_Spec_1_8_March3.pdf
[3] https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v7:
 - use SPDX tag;
---
 include/standard-headers/uefi/uefi.h | 187 +++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)
 create mode 100644 include/standard-headers/uefi/uefi.h

diff --git a/include/standard-headers/uefi/uefi.h b/include/standard-headers/uefi/uefi.h
new file mode 100644
index 000000000000..5256349ec0b6
--- /dev/null
+++ b/include/standard-headers/uefi/uefi.h
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
+ *                        <isaku.yamahata at intel.com>
+ *         Xiaoyao Li <xiaoyao.li@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef HW_I386_UEFI_H
+#define HW_I386_UEFI_H
+
+/***************************************************************************/
+/*
+ * basic EFI definitions
+ * supplemented with UEFI Specification Version 2.8 (Errata A)
+ * released February 2020
+ */
+/* UEFI integer is little endian */
+
+typedef struct {
+    uint32_t Data1;
+    uint16_t Data2;
+    uint16_t Data3;
+    uint8_t Data4[8];
+} EFI_GUID;
+
+typedef enum {
+    EfiReservedMemoryType,
+    EfiLoaderCode,
+    EfiLoaderData,
+    EfiBootServicesCode,
+    EfiBootServicesData,
+    EfiRuntimeServicesCode,
+    EfiRuntimeServicesData,
+    EfiConventionalMemory,
+    EfiUnusableMemory,
+    EfiACPIReclaimMemory,
+    EfiACPIMemoryNVS,
+    EfiMemoryMappedIO,
+    EfiMemoryMappedIOPortSpace,
+    EfiPalCode,
+    EfiPersistentMemory,
+    EfiUnacceptedMemoryType,
+    EfiMaxMemoryType
+} EFI_MEMORY_TYPE;
+
+#define EFI_HOB_HANDOFF_TABLE_VERSION 0x0009
+
+#define EFI_HOB_TYPE_HANDOFF              0x0001
+#define EFI_HOB_TYPE_MEMORY_ALLOCATION    0x0002
+#define EFI_HOB_TYPE_RESOURCE_DESCRIPTOR  0x0003
+#define EFI_HOB_TYPE_GUID_EXTENSION       0x0004
+#define EFI_HOB_TYPE_FV                   0x0005
+#define EFI_HOB_TYPE_CPU                  0x0006
+#define EFI_HOB_TYPE_MEMORY_POOL          0x0007
+#define EFI_HOB_TYPE_FV2                  0x0009
+#define EFI_HOB_TYPE_LOAD_PEIM_UNUSED     0x000A
+#define EFI_HOB_TYPE_UEFI_CAPSULE         0x000B
+#define EFI_HOB_TYPE_FV3                  0x000C
+#define EFI_HOB_TYPE_UNUSED               0xFFFE
+#define EFI_HOB_TYPE_END_OF_HOB_LIST      0xFFFF
+
+typedef struct {
+    uint16_t HobType;
+    uint16_t HobLength;
+    uint32_t Reserved;
+} EFI_HOB_GENERIC_HEADER;
+
+typedef uint64_t EFI_PHYSICAL_ADDRESS;
+typedef uint32_t EFI_BOOT_MODE;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    uint32_t Version;
+    EFI_BOOT_MODE BootMode;
+    EFI_PHYSICAL_ADDRESS EfiMemoryTop;
+    EFI_PHYSICAL_ADDRESS EfiMemoryBottom;
+    EFI_PHYSICAL_ADDRESS EfiFreeMemoryTop;
+    EFI_PHYSICAL_ADDRESS EfiFreeMemoryBottom;
+    EFI_PHYSICAL_ADDRESS EfiEndOfHobList;
+} EFI_HOB_HANDOFF_INFO_TABLE;
+
+#define EFI_RESOURCE_SYSTEM_MEMORY          0x00000000
+#define EFI_RESOURCE_MEMORY_MAPPED_IO       0x00000001
+#define EFI_RESOURCE_IO                     0x00000002
+#define EFI_RESOURCE_FIRMWARE_DEVICE        0x00000003
+#define EFI_RESOURCE_MEMORY_MAPPED_IO_PORT  0x00000004
+#define EFI_RESOURCE_MEMORY_RESERVED        0x00000005
+#define EFI_RESOURCE_IO_RESERVED            0x00000006
+#define EFI_RESOURCE_MEMORY_UNACCEPTED      0x00000007
+#define EFI_RESOURCE_MAX_MEMORY_TYPE        0x00000008
+
+#define EFI_RESOURCE_ATTRIBUTE_PRESENT                  0x00000001
+#define EFI_RESOURCE_ATTRIBUTE_INITIALIZED              0x00000002
+#define EFI_RESOURCE_ATTRIBUTE_TESTED                   0x00000004
+#define EFI_RESOURCE_ATTRIBUTE_SINGLE_BIT_ECC           0x00000008
+#define EFI_RESOURCE_ATTRIBUTE_MULTIPLE_BIT_ECC         0x00000010
+#define EFI_RESOURCE_ATTRIBUTE_ECC_RESERVED_1           0x00000020
+#define EFI_RESOURCE_ATTRIBUTE_ECC_RESERVED_2           0x00000040
+#define EFI_RESOURCE_ATTRIBUTE_READ_PROTECTED           0x00000080
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_PROTECTED          0x00000100
+#define EFI_RESOURCE_ATTRIBUTE_EXECUTION_PROTECTED      0x00000200
+#define EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE              0x00000400
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_COMBINEABLE        0x00000800
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_THROUGH_CACHEABLE  0x00001000
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE     0x00002000
+#define EFI_RESOURCE_ATTRIBUTE_16_BIT_IO                0x00004000
+#define EFI_RESOURCE_ATTRIBUTE_32_BIT_IO                0x00008000
+#define EFI_RESOURCE_ATTRIBUTE_64_BIT_IO                0x00010000
+#define EFI_RESOURCE_ATTRIBUTE_UNCACHED_EXPORTED        0x00020000
+#define EFI_RESOURCE_ATTRIBUTE_READ_ONLY_PROTECTED      0x00040000
+#define EFI_RESOURCE_ATTRIBUTE_READ_ONLY_PROTECTABLE    0x00080000
+#define EFI_RESOURCE_ATTRIBUTE_READ_PROTECTABLE         0x00100000
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_PROTECTABLE        0x00200000
+#define EFI_RESOURCE_ATTRIBUTE_EXECUTION_PROTECTABLE    0x00400000
+#define EFI_RESOURCE_ATTRIBUTE_PERSISTENT               0x00800000
+#define EFI_RESOURCE_ATTRIBUTE_PERSISTABLE              0x01000000
+#define EFI_RESOURCE_ATTRIBUTE_MORE_RELIABLE            0x02000000
+
+typedef uint32_t EFI_RESOURCE_TYPE;
+typedef uint32_t EFI_RESOURCE_ATTRIBUTE_TYPE;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_GUID Owner;
+    EFI_RESOURCE_TYPE ResourceType;
+    EFI_RESOURCE_ATTRIBUTE_TYPE ResourceAttribute;
+    EFI_PHYSICAL_ADDRESS PhysicalStart;
+    uint64_t ResourceLength;
+} EFI_HOB_RESOURCE_DESCRIPTOR;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_GUID Name;
+
+    /* guid specific data follows */
+} EFI_HOB_GUID_TYPE;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+} EFI_HOB_FIRMWARE_VOLUME;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+    EFI_GUID FvName;
+    EFI_GUID FileName;
+} EFI_HOB_FIRMWARE_VOLUME2;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+    uint32_t AuthenticationStatus;
+    bool ExtractedFv;
+    EFI_GUID FvName;
+    EFI_GUID FileName;
+} EFI_HOB_FIRMWARE_VOLUME3;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    uint8_t SizeOfMemorySpace;
+    uint8_t SizeOfIoSpace;
+    uint8_t Reserved[6];
+} EFI_HOB_CPU;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+} EFI_HOB_MEMORY_POOL;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+} EFI_HOB_UEFI_CAPSULE;
+
+#define EFI_HOB_OWNER_ZERO                                      \
+    ((EFI_GUID){ 0x00000000, 0x0000, 0x0000,                    \
+        { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 } })
+
+#endif
-- 
2.34.1


