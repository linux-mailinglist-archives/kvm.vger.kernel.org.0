Return-Path: <kvm+bounces-20698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 870C591C908
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3557B1F225EF
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3FD811FE;
	Fri, 28 Jun 2024 22:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iz3DG4S8"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6596277F10
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719613324; cv=none; b=DV9PwNHlbMdVZswM4ZZECKLzjCe8aibws5oRz87gh7uSWsYDUVjN1SmohtdytsPIBluKFUkFqZ4EQ0trio5IW+vou29VAXcNc79MsyRix0gHqQZIArJL6Nq4NKeYK9HFuWa1SceH4lWcMGeaQh+ioKmbv1sQHrT4zuQh8NOr36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719613324; c=relaxed/simple;
	bh=8BgVqLuGIJtALnVWUOdgeF3NA6D/bD9RMe0EMj7PrUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GcALDcBG2L6HwEPvfWsSp+eDL0NCVW1J+ly8pwx3WQPcqnbezRL2KpuyQJcGCSjfpHitTZjIl8X4MItC/fCeq0gyhSjQvCMDtLgaHI5wicnvE5aQorIGfkwtdD6xn0La0zJHA2zQLs++d83+k+50SsKm+tAbpCeUhsGQXJtKU8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iz3DG4S8; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719613320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RDLjJ/QL1pzRW/LPtpuWNILzc0CwDsylZyQWWeEqcyw=;
	b=iz3DG4S8He/WrLynQ8XZYsqzGmYL4y3b4bn0zE3jmXDEhVlj5a3/5SwzKOllbcqroMcvM3
	wBuQf74AmoS3WJdXu1KoZb4GVooFV21n3mQ3oB8Mto5Bn5JkG8VuZyKpqJYG1V/xDN3ubm
	rNt5jBvvGU+5cwJ5Xc3XGHSkMgnS+DA=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] MAINTAINERS: Include documentation in KVM/arm64 entry
Date: Fri, 28 Jun 2024 22:21:47 +0000
Message-ID: <20240628222147.3153682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ensure updates to the KVM/arm64 documentation get sent to the right
place.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aacccb376c28..05d71b852857 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12078,6 +12078,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
+F:	Documentation/virt/kvm/arm/
 F:	arch/arm64/include/asm/kvm*
 F:	arch/arm64/include/uapi/asm/kvm*
 F:	arch/arm64/kvm/
-- 
2.45.2.803.g4e1b14247a-goog


