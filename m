Return-Path: <kvm+bounces-10274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8289E86B2A1
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33DF528658A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F8A15D5AA;
	Wed, 28 Feb 2024 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hTzvms+j"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F8815B992
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132682; cv=none; b=sSFUOhzPX2X9XC89hExfNiILRV55Sod3vduw/aigOhgpf2VU7Nc+tOVDZ0/a2gDMd4tybwQyAHyLTGmvlAPFsmraCbaw4H/I1+DaRxAtxUlJ7SZ3VgBRMKcengarAXBR8eNHOU1Huja6KUpYrpzxlYETtwSv4nusgwwXZMVAUUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132682; c=relaxed/simple;
	bh=6h9QQdIRmg5Ehd2DrboX8nwLrsooMKBTIeFI6l7kGlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=VdfPmkp1eU7kHq8rgy/5TLWAIpysIOX/a2xn7gcfmSlW51aKcbW2vOtcbWY3Tp5rtLvhZ15xTKhuHFdhgWz4h0foTP2JKZyEGUwB2e6qE8saup9CM60/zFjOphq0bCotsIlpl41gJaPI4m8C4b4FR8bTdGJkHkiGOtN4k2BG8eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hTzvms+j; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgFFk+8mAGn4kPim3Rcl5TXPjdjXghcdwSe/TqO5sM4=;
	b=hTzvms+j5fVjopbvQt4oX8rhY3+3+vhHm/fWDEsf+hlmqDMAnQ5rvTeFYSn/WmoVG47xWT
	JLXMV0Io0udplPoXSAP4GVMMW6BWO01gJnTbOBhAmqDZu0yyJxMNAZ/5+1lGe8M7SfCewl
	rxJyGhDnwIoDKSsYkC+fhguihbNKBQ0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 05/13] riscv: Import gnu-efi files
Date: Wed, 28 Feb 2024 16:04:21 +0100
Message-ID: <20240228150416.248948-20-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/efi/crt0-efi-riscv64.S  | 187 ++++++++++++++++++++++++++++++++++
 riscv/efi/elf_riscv64_efi.lds | 142 ++++++++++++++++++++++++++
 riscv/efi/reloc_riscv64.c     |  90 ++++++++++++++++
 3 files changed, 419 insertions(+)
 create mode 100644 riscv/efi/crt0-efi-riscv64.S
 create mode 100644 riscv/efi/elf_riscv64_efi.lds
 create mode 100644 riscv/efi/reloc_riscv64.c

diff --git a/riscv/efi/crt0-efi-riscv64.S b/riscv/efi/crt0-efi-riscv64.S
new file mode 100644
index 000000000000..712ed03fc06e
--- /dev/null
+++ b/riscv/efi/crt0-efi-riscv64.S
@@ -0,0 +1,187 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR BSD-2-Clause */
+/*
+ * Copright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ * Copright (C) 2018 Alexander Graf <agraf@suse.de>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice and this list of conditions, without modification.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License as published by the Free Software Foundation;
+ * either version 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef EFI_SUBSYSTEM
+#define EFI_SUBSYSTEM 10
+#endif
+
+	.section	.text.head
+
+	/*
+	 * Magic "MZ" signature for PE/COFF
+	 */
+	.globl	ImageBase
+ImageBase:
+	.ascii	"MZ"
+	.skip	58				// 'MZ' + pad + offset == 64
+	.4byte	pe_header - ImageBase		// Offset to the PE header.
+pe_header:
+	.ascii	"PE"
+	.2byte 	0
+coff_header:
+	.2byte	0x5064				// riscv64
+	.2byte	4				// nr_sections
+	.4byte	0 				// TimeDateStamp
+	.4byte	0				// PointerToSymbolTable
+	.4byte	0				// NumberOfSymbols
+	.2byte	section_table - optional_header	// SizeOfOptionalHeader
+	.2byte	0x206				// Characteristics.
+						// IMAGE_FILE_DEBUG_STRIPPED |
+						// IMAGE_FILE_EXECUTABLE_IMAGE |
+						// IMAGE_FILE_LINE_NUMS_STRIPPED
+optional_header:
+	.2byte	0x20b				// PE32+ format
+	.byte	0x02				// MajorLinkerVersion
+	.byte	0x14				// MinorLinkerVersion
+	.4byte	_text_size - ImageBase		// SizeOfCode
+	.4byte	_alldata_size - ImageBase		// SizeOfInitializedData
+	.4byte	0				// SizeOfUninitializedData
+	.4byte	_start - ImageBase		// AddressOfEntryPoint
+	.4byte	_text - ImageBase		// BaseOfCode
+
+extra_header_fields:
+	.8byte	0				// ImageBase
+	.4byte	0x1000				// SectionAlignment
+	.4byte	0x1000				// FileAlignment
+	.2byte	0				// MajorOperatingSystemVersion
+	.2byte	0				// MinorOperatingSystemVersion
+	.2byte	0				// MajorImageVersion
+	.2byte	0				// MinorImageVersion
+	.2byte	0				// MajorSubsystemVersion
+	.2byte	0				// MinorSubsystemVersion
+	.4byte	0				// Win32VersionValue
+
+	.4byte	_image_end - ImageBase		// SizeOfImage
+
+	// Everything before the kernel image is considered part of the header
+	.4byte	_text - ImageBase		// SizeOfHeaders
+	.4byte	0				// CheckSum
+	.2byte	EFI_SUBSYSTEM			// Subsystem
+	.2byte	0				// DllCharacteristics
+	.8byte	0				// SizeOfStackReserve
+	.8byte	0				// SizeOfStackCommit
+	.8byte	0				// SizeOfHeapReserve
+	.8byte	0				// SizeOfHeapCommit
+	.4byte	0				// LoaderFlags
+	.4byte	0x10				// NumberOfRvaAndSizes
+
+	.8byte	0				// ExportTable
+	.8byte	0				// ImportTable
+	.8byte	0				// ResourceTable
+	.8byte	0				// ExceptionTable
+	.8byte	0				// CertificationTable
+	.4byte	_reloc - ImageBase				// BaseRelocationTable (VirtualAddress)
+	.4byte	_reloc_vsize - ImageBase				// BaseRelocationTable (Size)
+	.8byte	0				// Debug
+	.8byte	0				// Architecture
+	.8byte	0				// Global Ptr
+	.8byte	0				// TLS Table
+	.8byte	0				// Load Config Table
+	.8byte	0				// Bound Import
+	.8byte	0				// IAT
+	.8byte	0				// Delay Import Descriptor
+	.8byte	0				// CLR Runtime Header
+	.8byte	0				// Reserved, must be zero
+
+	// Section table
+section_table:
+
+	.ascii	".text\0\0\0"
+	.4byte	_text_vsize - ImageBase		// VirtualSize
+	.4byte	_text - ImageBase	// VirtualAddress
+	.4byte	_text_size - ImageBase		// SizeOfRawData
+	.4byte	_text - ImageBase	// PointerToRawData
+	.4byte	0		// PointerToRelocations (0 for executables)
+	.4byte	0		// PointerToLineNumbers (0 for executables)
+	.2byte	0		// NumberOfRelocations  (0 for executables)
+	.2byte	0		// NumberOfLineNumbers  (0 for executables)
+	.4byte	0x60000020	// Characteristics (section flags)
+
+	/*
+	 * The EFI application loader requires a relocation section
+	 * because EFI applications must be relocatable.  This is a
+	 * dummy section as far as we are concerned.
+	 */
+	.ascii	".reloc\0\0"
+	.4byte	_reloc_vsize - ImageBase			// VirtualSize
+	.4byte	_reloc - ImageBase			// VirtualAddress
+	.4byte	_reloc_size - ImageBase			// SizeOfRawData
+	.4byte	_reloc - ImageBase			// PointerToRawData
+	.4byte	0			// PointerToRelocations
+	.4byte	0			// PointerToLineNumbers
+	.2byte	0			// NumberOfRelocations
+	.2byte	0			// NumberOfLineNumbers
+	.4byte	0x42000040		// Characteristics (section flags)
+
+	.ascii	".data\0\0\0"
+	.4byte	_data_vsize - ImageBase			// VirtualSize
+	.4byte	_data - ImageBase			// VirtualAddress
+	.4byte	_data_size - ImageBase			// SizeOfRawData
+	.4byte	_data - ImageBase			// PointerToRawData
+	.4byte	0			// PointerToRelocations
+	.4byte	0			// PointerToLineNumbers
+	.2byte	0			// NumberOfRelocations
+	.2byte	0			// NumberOfLineNumbers
+	.4byte	0xC0000040		// Characteristics (section flags)
+
+	.ascii	".rodata\0"
+	.4byte	_rodata_vsize - ImageBase			// VirtualSize
+	.4byte	_rodata - ImageBase			// VirtualAddress
+	.4byte	_rodata_size - ImageBase			// SizeOfRawData
+	.4byte	_rodata - ImageBase			// PointerToRawData
+	.4byte	0			// PointerToRelocations
+	.4byte	0			// PointerToLineNumbers
+	.2byte	0			// NumberOfRelocations
+	.2byte	0			// NumberOfLineNumbers
+	.4byte	0x40000040		// Characteristics (section flags)
+
+	.text
+	.globl _start
+	.type _start,%function
+_start:
+	addi		sp, sp, -24
+	sd		a0, 0(sp)
+	sd		a1, 8(sp)
+	sd		ra, 16(sp)
+	lla		a0, ImageBase
+	lla		a1, _DYNAMIC
+	call		_relocate
+	bne		a0, zero, 0f
+	ld		a1, 8(sp)
+	ld		a0, 0(sp)
+	call		_entry
+	ld		ra, 16(sp)
+0:	addi		sp, sp, 24
+	ret
+
+// hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:
+ 
+ 	.data
+dummy:	.4byte	0
+
+#define IMAGE_REL_ABSOLUTE	0
+ 	.section .reloc, "a"
+label1:
+	.4byte	dummy-label1				// Page RVA
+	.4byte	12					// Block Size (2*4+2*2), must be aligned by 32 Bits
+	.2byte	(IMAGE_REL_ABSOLUTE<<12) +  0		// reloc for dummy
+	.2byte	(IMAGE_REL_ABSOLUTE<<12) +  0		// reloc for dummy
+
+#if defined(__ELF__) && defined(__linux__)
+	.section .note.GNU-stack,"",%progbits
+#endif
diff --git a/riscv/efi/elf_riscv64_efi.lds b/riscv/efi/elf_riscv64_efi.lds
new file mode 100644
index 000000000000..ac7055a5619b
--- /dev/null
+++ b/riscv/efi/elf_riscv64_efi.lds
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR BSD-2-Clause */
+
+OUTPUT_FORMAT("elf64-littleriscv", "elf64-littleriscv", "elf64-littleriscv")
+OUTPUT_ARCH(riscv)
+ENTRY(_start)
+SECTIONS
+{
+  .text 0 : {
+    *(.text.head)
+    . = ALIGN(4096);
+    _text = .;
+    *(.text)
+    *(.text.*)
+    *(.gnu.linkonce.t.*)
+    *(.plt)
+    . = ALIGN(16);
+    _evtext = .;
+    . = ALIGN(4096);
+    _etext = .;
+  } =0
+  _text_vsize = _evtext - _text;
+  _text_size = _etext - _text;
+  . = ALIGN(4096);
+  _reloc = .;
+  .reloc : {
+    *(.reloc)
+    _evreloc = .;
+    . = ALIGN(4096);
+    _ereloc = .;
+  } =0
+  _reloc_vsize = _evreloc - _reloc;
+  _reloc_size = _ereloc - _reloc;
+  . = ALIGN(4096);
+  _data = .;
+  .dynamic  : { *(.dynamic) }
+  . = ALIGN(4096);
+  .data :
+  {
+   *(.sdata)
+   *(.data)
+   *(.data1)
+   *(.data.*)
+   *(.got.plt)
+   *(.got)
+
+   /*
+    * Note that these aren't the using the GNU "CONSTRUCTOR" output section
+    * command, so they don't start with a size.  Because of p2align and the
+    * end/END definitions, and the fact that they're mergeable, they can also
+    * have NULLs which aren't guaranteed to be at the end.
+    */
+   . = ALIGN(16);
+   __init_array_start = .;
+   *(SORT(.init_array.*))
+   *(.init_array)
+   __init_array_end = .;
+  . = ALIGN(16);
+   __CTOR_LIST__ = .;
+   *(SORT(.ctors.*))
+   *(.ctors)
+   __CTOR_END__ = .;
+  . = ALIGN(16);
+   __DTOR_LIST__ = .;
+   *(SORT(.dtors.*))
+   *(.dtors)
+   __DTOR_END__ = .;
+   . = ALIGN(16);
+   __fini_array_start = .;
+   *(SORT(.fini_array.*))
+   *(.fini_array)
+   __fini_array_end = .;
+
+   /* the EFI loader doesn't seem to like a .bss section, so we stick
+      it all into .data: */
+   . = ALIGN(16);
+   _bss = .;
+   *(.sbss)
+   *(.scommon)
+   *(.dynbss)
+   *(.bss)
+   *(.bss.*)
+   *(COMMON)
+   . = ALIGN(16);
+   _bss_end = .;
+   _evdata = .;
+   . = ALIGN(4096);
+   _edata = .;
+  } =0
+  _data_vsize = _evdata - _data;
+  _data_size = _edata - _data;
+
+  . = ALIGN(4096);
+  _rodata = .;
+  .rela :
+  {
+    *(.rela.text*)
+    *(.rela.data*)
+    *(.rela.got)
+    *(.rela.dyn)
+    *(.rela.stab)
+    *(.rela.init_array*)
+    *(.rela.fini_array*)
+    *(.rela.ctors*)
+    *(.rela.dtors*)
+
+  }
+  . = ALIGN(4096);
+  .rela.plt : { *(.rela.plt) }
+  . = ALIGN(4096);
+  .rodata : {
+    *(.rodata*)
+    _evrodata = .;
+    . = ALIGN(4096);
+    _erodata = .;
+  } =0
+  _rodata_vsize = _evrodata - _rodata;
+  _rodata_size = _erodata - _rodata;
+  _image_end = .;
+  _alldata_size = _image_end - _reloc;
+
+  . = ALIGN(4096);
+  .dynsym   : { *(.dynsym) }
+  . = ALIGN(4096);
+  .dynstr   : { *(.dynstr) }
+  . = ALIGN(4096);
+  .note.gnu.build-id : { *(.note.gnu.build-id) }
+  . = ALIGN(4096);
+  .hash : { *(.hash) }
+  . = ALIGN(4096);
+  .gnu.hash : { *(.gnu.hash) }
+  . = ALIGN(4096);
+  .eh_frame : { *(.eh_frame) }
+  . = ALIGN(4096);
+  .gcc_except_table : { *(.gcc_except_table*) }
+  /DISCARD/ :
+  {
+    *(.rela.reloc)
+    *(.note.GNU-stack)
+  }
+  .comment 0 : { *(.comment) }
+}
+
diff --git a/riscv/efi/reloc_riscv64.c b/riscv/efi/reloc_riscv64.c
new file mode 100644
index 000000000000..e4296026e2a4
--- /dev/null
+++ b/riscv/efi/reloc_riscv64.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0+ OR BSD-3-Clause
+/* reloc_riscv.c - position independent ELF shared object relocator
+   Copyright (C) 2018 Alexander Graf <agraf@suse.de>
+   Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+   Copyright (C) 1999 Hewlett-Packard Co.
+	Contributed by David Mosberger <davidm@hpl.hp.com>.
+
+    All rights reserved.
+
+    Redistribution and use in source and binary forms, with or without
+    modification, are permitted provided that the following conditions
+    are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above
+      copyright notice, this list of conditions and the following
+      disclaimer in the documentation and/or other materials
+      provided with the distribution.
+    * Neither the name of Hewlett-Packard Co. nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+    CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+    BE LIABLE FOR ANYDIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
+    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
+    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+    SUCH DAMAGE.
+*/
+
+#include <efi.h>
+
+#include <elf.h>
+
+#define Elf_Dyn		Elf64_Dyn
+#define Elf_Rela	Elf64_Rela
+#define ELF_R_TYPE	ELF64_R_TYPE
+
+EFI_STATUS EFIAPI _relocate(long ldbase, Elf_Dyn *dyn)
+{
+	long relsz = 0, relent = 0;
+	Elf_Rela *rel = NULL;
+	unsigned long *addr;
+	int i;
+
+	for (i = 0; dyn[i].d_tag != DT_NULL; ++i) {
+		switch (dyn[i].d_tag) {
+		case DT_RELA:
+			rel = (Elf_Rela *)((unsigned long)dyn[i].d_un.d_ptr + ldbase);
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
+		switch (ELF_R_TYPE(rel->r_info)) {
+		case R_RISCV_RELATIVE:
+			addr = (unsigned long *)(ldbase + rel->r_offset);
+			*addr = ldbase + rel->r_addend;
+			break;
+		default:
+				break;
+		}
+		rel = (Elf_Rela *)((char *)rel + relent);
+		relsz -= relent;
+	}
+	return EFI_SUCCESS;
+}
-- 
2.43.0


