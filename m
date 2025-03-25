Return-Path: <kvm+bounces-42005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D99A70C47
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 583D1188D8B2
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37AD126A0B4;
	Tue, 25 Mar 2025 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k6+zC7QH"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EAA26A0A2
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938810; cv=none; b=WKPbBQLeXmLSndIJBqBBjgnpAhoxHGdJLrLIcyV0HkAdxhE51oExq5JRQGFDy6K+ltWrz1TljiT2siAEj9xyA5n1zbdL+1P75XCXpk8dWQ9tn3bZXI36NTwQFT4YkfIkqeWEojR8SbO1wp33nC3jlkxiKzID8tSyzbM3/UNMGqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938810; c=relaxed/simple;
	bh=vXrB6hJs3o1Fk4seq/2z4SQtzntmV/T6Sjg1l58u/VM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RAArn3Rx5z4QBLSyN11pDGrkrGIhhgTam77ltYg/cXQTQzQjK5t8qClZ0vRxBuuRNy8j7yc820HHsvnHVDIZP7yCLC17gcDCwctp0lTM9i2lin+BT3ZlfRqJpisbBxAX/eW+KgERM6S0zkVb67ojVmhcw4P1f1vSMRRyPVOI/Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k6+zC7QH; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPsM/NZfchQy4UiNZb92MrGPviC2hHtn5e4gCTHXvdY=;
	b=k6+zC7QHoRZKDEY3pEgGh1b61SftY5qq63QlB0dTX6ALCUi/3x62kzDIijVHcjLcr27JLK
	f68jCSQ9d54Gcvu5LOH78jJpf/KjcNnjsB9cCuty11OtcC0m6LsBZB52UrTaqmcFLc5D0+
	U1UxBspi7dAtkAZNysvs1EvS6aRKeZg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 8/9] arm64: Rename top-level directory
Date: Tue, 25 Mar 2025 14:39:38 -0700
Message-Id: <20250325213939.2414498-9-oliver.upton@linux.dev>
In-Reply-To: <20250325213939.2414498-1-oliver.upton@linux.dev>
References: <20250325213939.2414498-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As a finishing touch, align the top-level arch directory name with the
kernel's naming scheme.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                                     | 24 ++++++++++----------
 {arm => arm64}/arm-cpu.c                     |  0
 {arm => arm64}/fdt.c                         |  0
 {arm => arm64}/gic.c                         |  0
 {arm => arm64}/gicv2m.c                      |  0
 {arm => arm64}/include/arm-common/gic.h      |  0
 {arm => arm64}/include/arm-common/pci.h      |  0
 {arm => arm64}/include/arm-common/timer.h    |  0
 {arm => arm64}/include/asm/image.h           |  0
 {arm => arm64}/include/asm/kernel.h          |  0
 {arm => arm64}/include/asm/kvm.h             |  0
 {arm => arm64}/include/asm/pmu.h             |  0
 {arm => arm64}/include/asm/sve_context.h     |  0
 {arm => arm64}/include/kvm/barrier.h         |  0
 {arm => arm64}/include/kvm/fdt-arch.h        |  0
 {arm => arm64}/include/kvm/kvm-arch.h        |  0
 {arm => arm64}/include/kvm/kvm-config-arch.h |  0
 {arm => arm64}/include/kvm/kvm-cpu-arch.h    |  0
 {arm => arm64}/ioport.c                      |  0
 {arm => arm64}/kvm-cpu.c                     |  0
 {arm => arm64}/kvm.c                         |  0
 {arm => arm64}/pci.c                         |  0
 {arm => arm64}/pmu.c                         |  0
 {arm => arm64}/pvtime.c                      |  0
 {arm => arm64}/timer.c                       |  0
 25 files changed, 12 insertions(+), 12 deletions(-)
 rename {arm => arm64}/arm-cpu.c (100%)
 rename {arm => arm64}/fdt.c (100%)
 rename {arm => arm64}/gic.c (100%)
 rename {arm => arm64}/gicv2m.c (100%)
 rename {arm => arm64}/include/arm-common/gic.h (100%)
 rename {arm => arm64}/include/arm-common/pci.h (100%)
 rename {arm => arm64}/include/arm-common/timer.h (100%)
 rename {arm => arm64}/include/asm/image.h (100%)
 rename {arm => arm64}/include/asm/kernel.h (100%)
 rename {arm => arm64}/include/asm/kvm.h (100%)
 rename {arm => arm64}/include/asm/pmu.h (100%)
 rename {arm => arm64}/include/asm/sve_context.h (100%)
 rename {arm => arm64}/include/kvm/barrier.h (100%)
 rename {arm => arm64}/include/kvm/fdt-arch.h (100%)
 rename {arm => arm64}/include/kvm/kvm-arch.h (100%)
 rename {arm => arm64}/include/kvm/kvm-config-arch.h (100%)
 rename {arm => arm64}/include/kvm/kvm-cpu-arch.h (100%)
 rename {arm => arm64}/ioport.c (100%)
 rename {arm => arm64}/kvm-cpu.c (100%)
 rename {arm => arm64}/kvm.c (100%)
 rename {arm => arm64}/pci.c (100%)
 rename {arm => arm64}/pmu.c (100%)
 rename {arm => arm64}/pvtime.c (100%)
 rename {arm => arm64}/timer.c (100%)

diff --git a/Makefile b/Makefile
index 3085609..60e551f 100644
--- a/Makefile
+++ b/Makefile
@@ -169,19 +169,19 @@ endif
 # ARM64
 ifeq ($(ARCH), arm64)
 	DEFINES		+= -DCONFIG_ARM64
-	OBJS		+= arm/fdt.o
-	OBJS		+= arm/gic.o
-	OBJS		+= arm/gicv2m.o
-	OBJS		+= arm/ioport.o
-	OBJS		+= arm/kvm.o
-	OBJS		+= arm/kvm-cpu.o
-	OBJS		+= arm/pci.o
-	OBJS		+= arm/timer.o
+	OBJS		+= arm64/fdt.o
+	OBJS		+= arm64/gic.o
+	OBJS		+= arm64/gicv2m.o
+	OBJS		+= arm64/ioport.o
+	OBJS		+= arm64/kvm.o
+	OBJS		+= arm64/kvm-cpu.o
+	OBJS		+= arm64/pci.o
+	OBJS		+= arm64/timer.o
 	OBJS		+= hw/serial.o
-	OBJS		+= arm/arm-cpu.o
-	OBJS		+= arm/pvtime.o
-	OBJS		+= arm/pmu.o
-	ARCH_INCLUDE	:= arm/include
+	OBJS		+= arm64/arm-cpu.o
+	OBJS		+= arm64/pvtime.o
+	OBJS		+= arm64/pmu.o
+	ARCH_INCLUDE	:= arm64/include
 
 	ARCH_WANT_LIBFDT := y
 	ARCH_HAS_FLASH_MEM := y
diff --git a/arm/arm-cpu.c b/arm64/arm-cpu.c
similarity index 100%
rename from arm/arm-cpu.c
rename to arm64/arm-cpu.c
diff --git a/arm/fdt.c b/arm64/fdt.c
similarity index 100%
rename from arm/fdt.c
rename to arm64/fdt.c
diff --git a/arm/gic.c b/arm64/gic.c
similarity index 100%
rename from arm/gic.c
rename to arm64/gic.c
diff --git a/arm/gicv2m.c b/arm64/gicv2m.c
similarity index 100%
rename from arm/gicv2m.c
rename to arm64/gicv2m.c
diff --git a/arm/include/arm-common/gic.h b/arm64/include/arm-common/gic.h
similarity index 100%
rename from arm/include/arm-common/gic.h
rename to arm64/include/arm-common/gic.h
diff --git a/arm/include/arm-common/pci.h b/arm64/include/arm-common/pci.h
similarity index 100%
rename from arm/include/arm-common/pci.h
rename to arm64/include/arm-common/pci.h
diff --git a/arm/include/arm-common/timer.h b/arm64/include/arm-common/timer.h
similarity index 100%
rename from arm/include/arm-common/timer.h
rename to arm64/include/arm-common/timer.h
diff --git a/arm/include/asm/image.h b/arm64/include/asm/image.h
similarity index 100%
rename from arm/include/asm/image.h
rename to arm64/include/asm/image.h
diff --git a/arm/include/asm/kernel.h b/arm64/include/asm/kernel.h
similarity index 100%
rename from arm/include/asm/kernel.h
rename to arm64/include/asm/kernel.h
diff --git a/arm/include/asm/kvm.h b/arm64/include/asm/kvm.h
similarity index 100%
rename from arm/include/asm/kvm.h
rename to arm64/include/asm/kvm.h
diff --git a/arm/include/asm/pmu.h b/arm64/include/asm/pmu.h
similarity index 100%
rename from arm/include/asm/pmu.h
rename to arm64/include/asm/pmu.h
diff --git a/arm/include/asm/sve_context.h b/arm64/include/asm/sve_context.h
similarity index 100%
rename from arm/include/asm/sve_context.h
rename to arm64/include/asm/sve_context.h
diff --git a/arm/include/kvm/barrier.h b/arm64/include/kvm/barrier.h
similarity index 100%
rename from arm/include/kvm/barrier.h
rename to arm64/include/kvm/barrier.h
diff --git a/arm/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
similarity index 100%
rename from arm/include/kvm/fdt-arch.h
rename to arm64/include/kvm/fdt-arch.h
diff --git a/arm/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
similarity index 100%
rename from arm/include/kvm/kvm-arch.h
rename to arm64/include/kvm/kvm-arch.h
diff --git a/arm/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
similarity index 100%
rename from arm/include/kvm/kvm-config-arch.h
rename to arm64/include/kvm/kvm-config-arch.h
diff --git a/arm/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
similarity index 100%
rename from arm/include/kvm/kvm-cpu-arch.h
rename to arm64/include/kvm/kvm-cpu-arch.h
diff --git a/arm/ioport.c b/arm64/ioport.c
similarity index 100%
rename from arm/ioport.c
rename to arm64/ioport.c
diff --git a/arm/kvm-cpu.c b/arm64/kvm-cpu.c
similarity index 100%
rename from arm/kvm-cpu.c
rename to arm64/kvm-cpu.c
diff --git a/arm/kvm.c b/arm64/kvm.c
similarity index 100%
rename from arm/kvm.c
rename to arm64/kvm.c
diff --git a/arm/pci.c b/arm64/pci.c
similarity index 100%
rename from arm/pci.c
rename to arm64/pci.c
diff --git a/arm/pmu.c b/arm64/pmu.c
similarity index 100%
rename from arm/pmu.c
rename to arm64/pmu.c
diff --git a/arm/pvtime.c b/arm64/pvtime.c
similarity index 100%
rename from arm/pvtime.c
rename to arm64/pvtime.c
diff --git a/arm/timer.c b/arm64/timer.c
similarity index 100%
rename from arm/timer.c
rename to arm64/timer.c
-- 
2.39.5


