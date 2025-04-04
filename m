Return-Path: <kvm+bounces-42677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E90BA7C1DA
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 232E33BD97C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC3F21A437;
	Fri,  4 Apr 2025 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FuVWpJaF"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ABC21859F
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785590; cv=none; b=M/O8sZMcAsZsBsYQXfLHLo8dP6T3GEJ7wBejuREwY2z1UBeUzypHGPm+SGzMneQx4ipKRPgKSFuBaqPrBngpMtjiDRbSmmbxZQePcEZNHxVrVJGsWAsTdzXt9i9cG/+E+3hLrCQoWjP/vylxdvReKeXSeQYaQc0aY1ixG/OtPFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785590; c=relaxed/simple;
	bh=mBawmEx9bsiy3MXdLUccP7gVeymt7ZSQh4E5/wfyO6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lJXx4J+HwUQHxTPtDDJEVZgkYNOHnvudM9Cy0MCt2I4fy1QN6VyuhsLtWNpaFvWETJNUPtsnUtZNEkQYCn3Xq4HhQcumHb5RMproF5c1TtzZY2CR6ZAEdmWfF09VdtLsCbvZxrdWARMAoXiU3/MusN++BZpzoTX4YmmNZenjWjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FuVWpJaF; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2CXcKvyf7HQxLCuPiaLx/fDQxFRm6TTVxjePqCxJrU=;
	b=FuVWpJaFBeT/4vNSVqDIIgzQEoW4j/1B74fleLlv7XG3lVWVEFH8uwo04ZKNhqFmqJsBww
	lYiKh1GCd71pdCwRq9oAzfm4uMQrpSvJIO5VDdIalGXMrIulaVAW665tf+1zYCkG+pF0Qq
	LzF/V/gCe67jwNJNVmZPWD+zN/8hD1U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 9/9] arm64: Get rid of the 'arm-common' include directory
Date: Fri,  4 Apr 2025 09:52:32 -0700
Message-Id: <20250404165233.3205127-10-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm64/arm-cpu.c                                    | 5 ++---
 arm64/fdt.c                                        | 5 ++---
 arm64/gic.c                                        | 3 +--
 arm64/gicv2m.c                                     | 3 +--
 arm64/include/{arm-common => kvm}/gic.h            | 0
 arm64/include/kvm/kvm-arch.h                       | 2 +-
 arm64/include/{arm-common/pci.h => kvm/pci-arch.h} | 0
 arm64/include/{arm-common => kvm}/timer.h          | 0
 arm64/kvm.c                                        | 3 +--
 arm64/pci.c                                        | 5 ++---
 arm64/pmu.c                                        | 3 +--
 arm64/timer.c                                      | 5 ++---
 12 files changed, 13 insertions(+), 21 deletions(-)
 rename arm64/include/{arm-common => kvm}/gic.h (100%)
 rename arm64/include/{arm-common/pci.h => kvm/pci-arch.h} (100%)
 rename arm64/include/{arm-common => kvm}/timer.h (100%)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index f5c8e1e..69bb2cb 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -1,11 +1,10 @@
 #include "kvm/fdt.h"
+#include "kvm/gic.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/timer.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
-
 #include "asm/pmu.h"
 
 #include <linux/byteorder.h>
diff --git a/arm64/fdt.c b/arm64/fdt.c
index 286ccad..df77758 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -1,12 +1,11 @@
 #include "kvm/devices.h"
 #include "kvm/fdt.h"
+#include "kvm/gic.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/pci-arch.h"
 #include "kvm/virtio-mmio.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/pci.h"
-
 #include <stdbool.h>
 
 #include <linux/byteorder.h>
diff --git a/arm64/gic.c b/arm64/gic.c
index 0795e95..b0d3a1a 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -1,10 +1,9 @@
 #include "kvm/fdt.h"
+#include "kvm/gic.h"
 #include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
 
-#include "arm-common/gic.h"
-
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/kvm.h>
diff --git a/arm64/gicv2m.c b/arm64/gicv2m.c
index b47ada8..b3c542a 100644
--- a/arm64/gicv2m.c
+++ b/arm64/gicv2m.c
@@ -2,11 +2,10 @@
 #include <stdlib.h>
 
 #include "kvm/irq.h"
+#include "kvm/gic.h"
 #include "kvm/kvm.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-
 #define GICV2M_MSI_TYPER	0x008
 #define GICV2M_MSI_SETSPI	0x040
 #define GICV2M_MSI_IIDR		0xfcc
diff --git a/arm64/include/arm-common/gic.h b/arm64/include/kvm/gic.h
similarity index 100%
rename from arm64/include/arm-common/gic.h
rename to arm64/include/kvm/gic.h
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index b097186..8f508ef 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -10,7 +10,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 
-#include "arm-common/gic.h"
+#include "kvm/gic.h"
 
 /*
  * The memory map used for ARM guests (not to scale):
diff --git a/arm64/include/arm-common/pci.h b/arm64/include/kvm/pci-arch.h
similarity index 100%
rename from arm64/include/arm-common/pci.h
rename to arm64/include/kvm/pci-arch.h
diff --git a/arm64/include/arm-common/timer.h b/arm64/include/kvm/timer.h
similarity index 100%
rename from arm64/include/arm-common/timer.h
rename to arm64/include/kvm/timer.h
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 11c7a16..23b4dab 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -4,8 +4,7 @@
 #include "kvm/8250-serial.h"
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
-
-#include "arm-common/gic.h"
+#include "kvm/gic.h"
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
diff --git a/arm64/pci.c b/arm64/pci.c
index 5bd82d4..0366783 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -1,13 +1,12 @@
 #include "kvm/devices.h"
 #include "kvm/fdt.h"
+#include "kvm/gic.h"
 #include "kvm/kvm.h"
 #include "kvm/of_pci.h"
 #include "kvm/pci.h"
+#include "kvm/pci-arch.h"
 #include "kvm/util.h"
 
-#include "arm-common/pci.h"
-#include "arm-common/gic.h"
-
 /*
  * An entry in the interrupt-map table looks like:
  * <pci unit address> <pci interrupt pin> <gic phandle> <gic interrupt>
diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5ed4979..5f31d6b 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -5,12 +5,11 @@
 #include "linux/err.h"
 
 #include "kvm/fdt.h"
+#include "kvm/gic.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-
 #include "asm/pmu.h"
 
 static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
diff --git a/arm64/timer.c b/arm64/timer.c
index 6acc50e..861f2d9 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -1,11 +1,10 @@
 #include "kvm/fdt.h"
+#include "kvm/gic.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/timer.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
-
 void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
 {
 	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
-- 
2.39.5


