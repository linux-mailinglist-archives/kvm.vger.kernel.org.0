Return-Path: <kvm+bounces-42002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1F7A70C51
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:44:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9F4484231D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFBB26A095;
	Tue, 25 Mar 2025 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TOz65J7e"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125DE26A088
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 21:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938807; cv=none; b=roxLzSookNz47FGEPJDzy1B1Gau4yFG/gj3lEcGiiyaeLqVCkwmq4z0gGi66LlofLufRWSuTtjhxW6sSg695pidvyFeb7uzAmY96EaKHZ/p3W2zAekMi76R9sT0KPOp1mSyyuW7gb33ghBK4KoBr4V1/UGa1EHdoZVgsIHG4Uv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938807; c=relaxed/simple;
	bh=iQgGYAz+QPP5HbflwSDAvegeWKIlJ4QeMpJW4l9lAGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qdHhqQQWhoOgMRa0WjCZNIoH+pAyLx5+VbSY89yzW5MwiOVgAnCl9HVGk0qkAY4fQSy7PCX64ZVymKe/772akRsfDHwJrxq30bn6ujzoL7wpWDAfNKRChEde0Xyd2be00dYWLAbL/owrgQM3zCMeWiFxhj/pI+sLzjgOaV3c5Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TOz65J7e; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WnVnLC+BrbTLwQ/rBq8l+CNs17j9rpKS2l4jwwS5bH4=;
	b=TOz65J7eMMK/K34No8HlsBClhdnf0vJTlCQ9+5UATrr9TSnmptGuFQNHjhJYGuZdWUZ3I3
	TGkAQ27J0yuVNjMCcVhkwreMfWAnCHf6TnDaAR7cieoWaj681JKnFTHToQTZGY7ElvsS/1
	0UqSgIrOV6I49dRniEsjh0S2IEGfgkg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 6/9] arm64: Move remaining kvm/* headers
Date: Tue, 25 Mar 2025 14:39:36 -0700
Message-Id: <20250325213939.2414498-7-oliver.upton@linux.dev>
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

Move the remaining kvm/* headers into the top-level ARM include path.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/fdt-arch.h         | 6 ------
 arm/{aarch64 => }/include/kvm/barrier.h    | 0
 arm/include/{arm-common => kvm}/fdt-arch.h | 0
 3 files changed, 6 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 rename arm/{aarch64 => }/include/kvm/barrier.h (100%)
 rename arm/include/{arm-common => kvm}/fdt-arch.h (100%)

diff --git a/arm/aarch64/include/kvm/fdt-arch.h b/arm/aarch64/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
--- a/arm/aarch64/include/kvm/fdt-arch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef KVM__KVM_FDT_H
-#define KVM__KVM_FDT_H
-
-#include "arm-common/fdt-arch.h"
-
-#endif /* KVM__KVM_FDT_H */
diff --git a/arm/aarch64/include/kvm/barrier.h b/arm/include/kvm/barrier.h
similarity index 100%
rename from arm/aarch64/include/kvm/barrier.h
rename to arm/include/kvm/barrier.h
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/kvm/fdt-arch.h
similarity index 100%
rename from arm/include/arm-common/fdt-arch.h
rename to arm/include/kvm/fdt-arch.h
-- 
2.39.5


