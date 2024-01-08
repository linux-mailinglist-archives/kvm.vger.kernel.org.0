Return-Path: <kvm+bounces-5806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D891826EF7
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C82D6282EBC
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96064655B;
	Mon,  8 Jan 2024 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyUunxJ+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6445C02
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NUQb3ZgfVWywTpmXggFoXewrDYTsKJJ8WCGj59D+i+A=;
	b=RyUunxJ+8IMmNIiGXNfma2jK4HCTG0q1MQ9wZwo+Xr89MDCf76y6fNwUu3R9OeGNJ6OmaU
	bpt2DdE/U3h2UgSwechb9+7XfI5akczuBz0t06NxtOjIM0XdpfZ9Ou93lY9apuDSosdX4G
	COOcsFYxW7B+0cE/UhUEYtBdBGg44wA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-fL18LyPvOe6IP1Z1ILKQfg-1; Mon, 08 Jan 2024 07:47:42 -0500
X-MC-Unique: fL18LyPvOe6IP1Z1ILKQfg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4686A185A781;
	Mon,  8 Jan 2024 12:47:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A61E38DF;
	Mon,  8 Jan 2024 12:47:42 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: ajones@ventanamicro.com
Subject: [PATCH v2 5/5] treewide: remove CONFIG_HAVE_KVM
Date: Mon,  8 Jan 2024 07:47:40 -0500
Message-Id: <20240108124740.114453-6-pbonzini@redhat.com>
In-Reply-To: <20240108124740.114453-1-pbonzini@redhat.com>
References: <20240108124740.114453-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

It has no users anymore.

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
index 6c3c8ca73e7f..5678238324e2 100644
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
index 61f7e33b1f95..ac4de790dc31 100644
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
index 72e9b7dcdf7d..cae908d64550 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_ASYNC_PF
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
index cce3dea27920..2851cfbbe5d2 100644
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
 	select KVM_COMMON
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 184dab4ee871..71ec20e7c39b 100644
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


