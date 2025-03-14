Return-Path: <kvm+bounces-41125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9151EA62086
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB0878833B6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C87205AC2;
	Fri, 14 Mar 2025 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TKrzERJK"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9C1ACEA5
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991684; cv=none; b=kg5Z0BO8TYDHTIkMXupdH+NM3BKWfbR3knHmJFLNlIvgEw/XY8VNanK7rL7PcdvHd+El3kjFLLhkZqnWNt/osgMqwXG2PRTsZxdb6vTOhCf1nx1tccq4Z1SzI60X7TwIjdgIIEPfzDwux6yCRBLtc8znE5WyFPny0JI/HkH/tWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991684; c=relaxed/simple;
	bh=nr18M0ApcYyzJwa9HfncxSoeNNznBh8CgzSXR+/UJns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BFbJU8tR6wlHaaOevnS1OlaGjXdwCDbfHtw1Sg2D5ET9/vTydjShJVDwZNh7LK1Jf0sm47TT0NrTF5DR+lYn+Rt0c/X+lKXWFDFtnLz7jFDiU4r8HrCF7tCRRDgAEeyXrR5dsFvf4pjt8M3azHJOB5tX4eMlET64NpJuSl3AeNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TKrzERJK; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jS7GnXS57Xs/azpQBXOhcxeHSWhp2577+Gf5EPDZT7g=;
	b=TKrzERJKVosBm5GH1navXAiL5WZi5eVkteb0CikapFuMoAX7evPfentk60yQIrPFswKM3l
	NPUnhDtZxxhfjwjtfI6JCueKEznGAt8yBGAwfmaSGdq4kIBTUfbnM2aIFxWSWL0JluC0TX
	sdUW2hahNpFC51P2O2PSNw6qpc/BVug=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 8/9] arm64: Rename top-level directory
Date: Fri, 14 Mar 2025 15:25:15 -0700
Message-Id: <20250314222516.1302429-9-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
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


