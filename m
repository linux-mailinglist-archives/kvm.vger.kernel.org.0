Return-Path: <kvm+bounces-42674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D43A7C1D5
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56B593BD598
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EC8212FAB;
	Fri,  4 Apr 2025 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BFkqW3mX"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B63214A9C
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785584; cv=none; b=jX+KPjN+0mnfqNmZbJeaTXkhomfzkrQ4rmOis1Dkq+yP2m3cme8R6gzDHMNXgBVuGf1QGaCv6WaYLGg+vUxLQFapmjXFVzRz3lPhhA1yjVCRSNOEgYXOVSRzVhKK06Xh2IT/XNFQd44zjUYbGFIIq+KaxhSJN9jaKv+cGJ8O3Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785584; c=relaxed/simple;
	bh=qh5CKCuhZIJy2V4uu/2qTtRHv/azLp18VBWD84RD4Qw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Brrq1+i/Q2iLbBAnx540ABqseRHGL4C4Cc2U4Ldl2Ny1/Kmmvu2MWan4u6QvpfRWN/Z803RRbP6Xlyn9/LftCYowbJMgEXXmXcehMR0Eo7s82YrNPFUGeoY3B5pVcyAFMN34kT7MSbVKkFfK8m6Xv7O62a1Frpe+Tg/7ht6aP8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BFkqW3mX; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J++YesDbz+As4+xmAyp0B2XAif0IeIKXQAOq6lAgobQ=;
	b=BFkqW3mXFPjUVdaNTUDMqf7fb7AlcapSuSm63qMaG3Yo+qZaNgk06m+2whbxu6aaAv1UQl
	9DzKZhy+vv5S1AeFhyEGUlzRKQ+YF3dSgcxNfN1V80cwd/c0bLzuZTpXqqqUlGqlFSISoj
	UttS9M0SijKFHJldeNmVkBSikr3ZiMQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 6/9] arm64: Move remaining kvm/* headers
Date: Fri,  4 Apr 2025 09:52:29 -0700
Message-Id: <20250404165233.3205127-7-oliver.upton@linux.dev>
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

Move the remaining kvm/* headers into the top-level ARM include path.

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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


