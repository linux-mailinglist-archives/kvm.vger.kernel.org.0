Return-Path: <kvm+bounces-42006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EFAA70C3E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 357D0172742
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0096E26A0BD;
	Tue, 25 Mar 2025 21:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VWogPlft"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6626A0B7
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938814; cv=none; b=spyV+Z+gr+BrFC58FMBHA4lrtcx2L42nYddgTV/StJSqXN2Z/2720YKPm8Ftoeg0HvuXUiGZQzrXXCR+w3p86s2rAy9nqvbWdU3XdMt5KK1XKXJ/oYFF8K0k833DhSVSY+Po0QiOhVqSdIXENDNE76tHbyGjjXxOo4IfBl4qudg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938814; c=relaxed/simple;
	bh=YYMZdH1gYx0yTapM3sUVjxgord3OIn7DBOLaajxSZJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WBmUDWLov6zxktn3CviNONsOWd4iLc7VnKvE8LI1yASGz7lm7s8TLivMQwYzI24E5hTFMmeuV32aSSbhXsAQxbE8XNW+dqPTJj8LceHv9Nf3/z3qgktis0mnfgX0MpGyCGokv4TpCHCIfyVJXuFFzS1560rweX2X+8iaG8fkqmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VWogPlft; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4pBygg55ww7iZjXC5+eJpKjdiWLeyf3O34eZggKpIlw=;
	b=VWogPlft4JkJmxZEG5lQkEiGm8+ZF8FxOZk9edlWJGmuL7HG7eutHcnapQnSPAoSmaSGCu
	67LeYqCDnd3qWf/BspmGvICToRHbYT6PVrq080UYOloMzxcVBo34WliMYXH6e72MSflW9F
	Biun7kSC3ClhjrzxlQpRZItvfKt/FEk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 9/9] arm64: Get rid of the 'arm-common' include directory
Date: Tue, 25 Mar 2025 14:39:39 -0700
Message-Id: <20250325213939.2414498-10-oliver.upton@linux.dev>
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

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm64/arm-cpu.c                        | 4 ++--
 arm64/fdt.c                            | 4 ++--
 arm64/gic.c                            | 2 +-
 arm64/gicv2m.c                         | 2 +-
 arm64/include/{arm-common => }/gic.h   | 0
 arm64/include/kvm/kvm-arch.h           | 2 +-
 arm64/include/{arm-common => }/pci.h   | 0
 arm64/include/{arm-common => }/timer.h | 0
 arm64/kvm.c                            | 2 +-
 arm64/pci.c                            | 4 ++--
 arm64/pmu.c                            | 2 +-
 arm64/timer.c                          | 4 ++--
 12 files changed, 13 insertions(+), 13 deletions(-)
 rename arm64/include/{arm-common => }/gic.h (100%)
 rename arm64/include/{arm-common => }/pci.h (100%)
 rename arm64/include/{arm-common => }/timer.h (100%)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index f5c8e1e..b9ca814 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -3,8 +3,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
+#include "gic.h"
+#include "timer.h"
 
 #include "asm/pmu.h"
 
diff --git a/arm64/fdt.c b/arm64/fdt.c
index 286ccad..9d93551 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -4,8 +4,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/virtio-mmio.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/pci.h"
+#include "gic.h"
+#include "pci.h"
 
 #include <stdbool.h>
 
diff --git a/arm64/gic.c b/arm64/gic.c
index 0795e95..d0d8543 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -3,7 +3,7 @@
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
diff --git a/arm64/gicv2m.c b/arm64/gicv2m.c
index b47ada8..e4e7dc8 100644
--- a/arm64/gicv2m.c
+++ b/arm64/gicv2m.c
@@ -5,7 +5,7 @@
 #include "kvm/kvm.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #define GICV2M_MSI_TYPER	0x008
 #define GICV2M_MSI_SETSPI	0x040
diff --git a/arm64/include/arm-common/gic.h b/arm64/include/gic.h
similarity index 100%
rename from arm64/include/arm-common/gic.h
rename to arm64/include/gic.h
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index b097186..ef3a701 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -10,7 +10,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 /*
  * The memory map used for ARM guests (not to scale):
diff --git a/arm64/include/arm-common/pci.h b/arm64/include/pci.h
similarity index 100%
rename from arm64/include/arm-common/pci.h
rename to arm64/include/pci.h
diff --git a/arm64/include/arm-common/timer.h b/arm64/include/timer.h
similarity index 100%
rename from arm64/include/arm-common/timer.h
rename to arm64/include/timer.h
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 11c7a16..7d49cb4 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -5,7 +5,7 @@
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
diff --git a/arm64/pci.c b/arm64/pci.c
index 5bd82d4..99bf887 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -5,8 +5,8 @@
 #include "kvm/pci.h"
 #include "kvm/util.h"
 
-#include "arm-common/pci.h"
-#include "arm-common/gic.h"
+#include "pci.h"
+#include "gic.h"
 
 /*
  * An entry in the interrupt-map table looks like:
diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5ed4979..52f4256 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -9,7 +9,7 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #include "asm/pmu.h"
 
diff --git a/arm64/timer.c b/arm64/timer.c
index 6acc50e..b3164f8 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -3,8 +3,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
+#include "gic.h"
+#include "timer.h"
 
 void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
 {
-- 
2.39.5


