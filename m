Return-Path: <kvm+bounces-5683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BAEC8249EC
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:00:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E55A01F2324E
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 21:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93722CCD1;
	Thu,  4 Jan 2024 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GkCcbRHd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D37B2C69A
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 21:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704402004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0cKn7qdYds079CLOrGNBapSvJeS5p31NAQ7WgjQqmE=;
	b=GkCcbRHdmE0f5C+oMd410DrjFFftMQAhkxURM90bsnnuTmZ1P7yN1fVGp5zZV34ES9yAjk
	2fBnAksMGlMANcepkB1+xSMb4e90KjTLPAMEHe0F6OJCP8hb+hPgN16+OUTana8R3U/Q3g
	0hXwqSgUplYdaJVP52DK1jqxOpDNx/s=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-GE2DdKgbMG6iYTBR-hY7JA-1; Thu,
 04 Jan 2024 16:00:01 -0500
X-MC-Unique: GE2DdKgbMG6iYTBR-hY7JA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4B4D1C18CC3;
	Thu,  4 Jan 2024 21:00:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7F1B1121313;
	Thu,  4 Jan 2024 21:00:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: ajones@ventanamicro.com
Subject: [PATCH 4/4] treewide: remove CONFIG_HAVE_KVM
Date: Thu,  4 Jan 2024 15:59:59 -0500
Message-Id: <20240104205959.4128825-5-pbonzini@redhat.com>
In-Reply-To: <20240104205959.4128825-1-pbonzini@redhat.com>
References: <20240104205959.4128825-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

It has no users anymore.  While at it also remove a dependency on X86
that is redundant within arch/x86.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/Kconfig         | 1 -
 arch/arm64/kvm/Kconfig     | 1 -
 arch/loongarch/Kconfig     | 1 -
 arch/loongarch/kvm/Kconfig | 1 -
 arch/mips/Kconfig          | 9 ---------
 arch/s390/Kconfig          | 1 -
 arch/s390/kvm/Kconfig      | 1 -
 arch/x86/Kconfig           | 1 -
 arch/x86/kvm/Kconfig       | 2 --
 virt/kvm/Kconfig           | 3 ---
 10 files changed, 21 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7b071a00425d..dbf08f8b66dd 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -214,7 +214,6 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_KVM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PERF_EVENTS
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ad5ce0454f17..d8e40d7f89f6 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	select KVM_COMMON
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index ee123820a476..78330e0ca2f2 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -129,7 +129,6 @@ config LOONGARCH
 	select HAVE_KPROBES
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_KRETPROBES
-	select HAVE_KVM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PCI
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 3b284b7e63ad..62c05d6e175c 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on AS_HAS_LVZ_EXTENSION
-	depends on HAVE_KVM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_COMMON
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3eb3239013d9..cf5bb1c756e6 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1262,7 +1262,6 @@ config CPU_LOONGSON64
 	select MIPS_FP_SUPPORT
 	select GPIOLIB
 	select SWIOTLB
-	select HAVE_KVM
 	help
 	  The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of processor
 	  cores implements the MIPS64R2 instruction set with many extensions,
@@ -1375,7 +1374,6 @@ config CPU_MIPS32_R2
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
-	select HAVE_KVM
 	help
 	  Choose this option to build a kernel for release 2 or later of the
 	  MIPS32 architecture.  Most modern embedded systems with a 32-bit
@@ -1391,7 +1389,6 @@ config CPU_MIPS32_R5
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
 	select CPU_SUPPORTS_VZ
-	select HAVE_KVM
 	select MIPS_O32_FP64_SUPPORT
 	help
 	  Choose this option to build a kernel for release 5 or later of the
@@ -1408,7 +1405,6 @@ config CPU_MIPS32_R6
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
 	select CPU_SUPPORTS_VZ
-	select HAVE_KVM
 	select MIPS_O32_FP64_SUPPORT
 	help
 	  Choose this option to build a kernel for release 6 or later of the
@@ -1444,7 +1440,6 @@ config CPU_MIPS64_R2
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_HUGEPAGES
 	select CPU_SUPPORTS_MSA
-	select HAVE_KVM
 	help
 	  Choose this option to build a kernel for release 2 or later of the
 	  MIPS64 architecture.  Many modern embedded systems with a 64-bit
@@ -1463,7 +1458,6 @@ config CPU_MIPS64_R5
 	select CPU_SUPPORTS_MSA
 	select MIPS_O32_FP64_SUPPORT if 32BIT || MIPS32_O32
 	select CPU_SUPPORTS_VZ
-	select HAVE_KVM
 	help
 	  Choose this option to build a kernel for release 5 or later of the
 	  MIPS64 architecture.  This is a intermediate MIPS architecture
@@ -1482,7 +1476,6 @@ config CPU_MIPS64_R6
 	select CPU_SUPPORTS_MSA
 	select MIPS_O32_FP64_SUPPORT if 32BIT || MIPS32_O32
 	select CPU_SUPPORTS_VZ
-	select HAVE_KVM
 	help
 	  Choose this option to build a kernel for release 6 or later of the
 	  MIPS64 architecture.  New MIPS processors, starting with the Warrior
@@ -1500,7 +1493,6 @@ config CPU_P5600
 	select CPU_SUPPORTS_VZ
 	select CPU_MIPSR2_IRQ_VI
 	select CPU_MIPSR2_IRQ_EI
-	select HAVE_KVM
 	select MIPS_O32_FP64_SUPPORT
 	help
 	  Choose this option to build a kernel for MIPS Warrior P5600 CPU.
@@ -1621,7 +1613,6 @@ config CPU_CAVIUM_OCTEON
 	select USB_OHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
 	select MIPS_L1_CACHE_SHIFT_7
 	select CPU_SUPPORTS_VZ
-	select HAVE_KVM
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
 	  many ethernet hardware widgets for networking tasks. The processor
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3bec98d20283..b369ee2648c2 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -194,7 +194,6 @@ config S390
 	select HAVE_KPROBES
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_KRETPROBES
-	select HAVE_KVM
 	select HAVE_LIVEPATCH
 	select HAVE_MEMBLOCK_PHYS_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index f89bedbe63bd..7f17c5185dc3 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3762f41bb092..a3935a737c14 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -240,7 +240,6 @@ config X86
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
 	select HAVE_RETHOOK
-	select HAVE_KVM
 	select HAVE_LIVEPATCH			if X86_64
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c8e62a371d24..419a72ed307a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -7,7 +7,6 @@ source "virt/kvm/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
-	depends on HAVE_KVM || X86
 	default y
 	help
 	  Say Y here to get to see options for using your Linux host to run other
@@ -20,7 +19,6 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	depends on HIGH_RES_TIMERS
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index cce5c03ecc92..4ecb6daf3f91 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # KVM common configuration items and defaults
 
-config HAVE_KVM
-       bool
-
 config KVM_COMMON
        bool
        select EVENTFD
-- 
2.39.1


