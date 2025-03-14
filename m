Return-Path: <kvm+bounces-41124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 223C1A62083
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 604CD883342
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C314C20551F;
	Fri, 14 Mar 2025 22:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q95cy3sq"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FBA1F3B8B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991684; cv=none; b=c5JivX1tyECJCk4bVakStu+eTxrPUZxCwv6fveLVrSqrm3iLFta5lAduWO5mxBfQtuTSTTbujj9/zLHxOeSEqG2Le5ZzN74ylcrJzuyEzl3tV/hjog6wvv6BaCrnNqzjjDcxxUQ9GIQOqiIz6Ds7qZLZ9a+nb6KPg0pQrTmrH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991684; c=relaxed/simple;
	bh=2Pbd+iBgLt8A0/FD4aGok3fNr8aJQIAaDsC5FWNPazE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OyTleuMWwhxrGjBh/pMOs3kBLlZJJWvFeha0EDsXGZY3i0MBNbQLD6v5Kymnj6i2nCNqgnIv8so/b26KlffB/lnb1i5lA+a6QQ8bRJKiIsNnltg4338UGo074zw4P9JtKoKjr/FONnyFyNvISvMHeVzp6SE2U58lhB9QBTBwp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q95cy3sq; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJir3LtLO9hm6l4NNlQH2wFwoWgwEwtk7XE/avmP+jA=;
	b=q95cy3sqcfcwHOPC8GLaPSb8acBAZwnjx5xC0kzY3P8XagssBxXwKFuKjWS3miduBFWUwP
	V96Pb34R9sLeUb5IwiqXVRs9tZM2i2mm1zTmLInr8R1gmKqg9Nj6c4dFO64ECNJqpLzpfV
	Vuu4m0uUZBWyn6ZLaenwOiJmd4CGf7U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 7/9] arm64: Move asm headers
Date: Fri, 14 Mar 2025 15:25:14 -0700
Message-Id: <20250314222516.1302429-8-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                                    | 1 -
 arm/{aarch64 => }/include/asm/image.h       | 0
 arm/{aarch64 => }/include/asm/kernel.h      | 0
 arm/{aarch64 => }/include/asm/kvm.h         | 0
 arm/{aarch64 => }/include/asm/pmu.h         | 0
 arm/{aarch64 => }/include/asm/sve_context.h | 0
 6 files changed, 1 deletion(-)
 rename arm/{aarch64 => }/include/asm/image.h (100%)
 rename arm/{aarch64 => }/include/asm/kernel.h (100%)
 rename arm/{aarch64 => }/include/asm/kvm.h (100%)
 rename arm/{aarch64 => }/include/asm/pmu.h (100%)
 rename arm/{aarch64 => }/include/asm/sve_context.h (100%)

diff --git a/Makefile b/Makefile
index 25ee9b0..3085609 100644
--- a/Makefile
+++ b/Makefile
@@ -182,7 +182,6 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/pvtime.o
 	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= arm/include
-	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
 	ARCH_WANT_LIBFDT := y
 	ARCH_HAS_FLASH_MEM := y
diff --git a/arm/aarch64/include/asm/image.h b/arm/include/asm/image.h
similarity index 100%
rename from arm/aarch64/include/asm/image.h
rename to arm/include/asm/image.h
diff --git a/arm/aarch64/include/asm/kernel.h b/arm/include/asm/kernel.h
similarity index 100%
rename from arm/aarch64/include/asm/kernel.h
rename to arm/include/asm/kernel.h
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/include/asm/kvm.h
similarity index 100%
rename from arm/aarch64/include/asm/kvm.h
rename to arm/include/asm/kvm.h
diff --git a/arm/aarch64/include/asm/pmu.h b/arm/include/asm/pmu.h
similarity index 100%
rename from arm/aarch64/include/asm/pmu.h
rename to arm/include/asm/pmu.h
diff --git a/arm/aarch64/include/asm/sve_context.h b/arm/include/asm/sve_context.h
similarity index 100%
rename from arm/aarch64/include/asm/sve_context.h
rename to arm/include/asm/sve_context.h
-- 
2.39.5


