Return-Path: <kvm+bounces-27611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E30CF9882CB
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 12:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 535F6284A50
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 10:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC77718A6BB;
	Fri, 27 Sep 2024 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADckukHB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5DC45979;
	Fri, 27 Sep 2024 10:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727434211; cv=none; b=OE6oGeTwidwJdYqtzcRRu5yriztX6Wq0W4+yo9rB1KriaLhzjlmBbPVwjhTQxL46rVItZ7bhczXEv8eAWihsJZU/XIzYp4vMA2NIH4D1jAwEgyyrUZ6c9RbQF8vXhszre21/EsooImbg2b/hkv+3yO5wRIY2/qqaYyTeTWJvbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727434211; c=relaxed/simple;
	bh=oBJxi6FzSa9qFYt3elRzPL3B/oBQhNl/ym80FGsvztc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CxCa4/I6aFsXirqLhnBcBzmF/B3CqTqKd8e7Fn2gCA7s20VZEkk9VYcPhL7f8+nDnmzR/yAXeiJhKzIdkKqtb5SVaEaozfH3kqV7DPnqi/dHCBEewyszsrUsN4+7gMuyfi0MIDnvKC1QtV6pPhhjKjfQ1oVQHtg7tE+kycJZRvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADckukHB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497F8C4CECD;
	Fri, 27 Sep 2024 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727434211;
	bh=oBJxi6FzSa9qFYt3elRzPL3B/oBQhNl/ym80FGsvztc=;
	h=From:To:Cc:Subject:Date:From;
	b=ADckukHBF9CveM5VVL+7CgBuxI5tsXjqDW6l3VQkTNKkBWBpk+M4Zd7LkcpD8JD5P
	 78P8Ne6yG68GgIcfHML5MLq/NO+xZuTFxLroe6TeBTfq/ivQMRtP/Or7BdbTp24nLR
	 tqW6qkvolIIwvzpu0Z81Blg8EwqWckq7lImZL3ENdpCZf46gtduDPXllVsqHxYF1CE
	 vksG5VgOzbSlktnQl+qWbMgneqq84xvLqvlVc/mtAsExsX7kQrtaopZOx0WvgPe/oN
	 4pZAMoshu+qhKWXzVO7HlKGVQvTzhC7CvKdRb7228dwwr1xU7tv04RszAHdWIMotR3
	 r+erXo9AITerg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1su8Y4-00Fq2f-Uq;
	Fri, 27 Sep 2024 11:50:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] KVM: arm64: Another reviewer reshuffle
Date: Fri, 27 Sep 2024 11:49:56 +0100
Message-Id: <20240927104956.1223658-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It has been a while since James had any significant bandwidth to
review KVM/arm64 patches. But in the meantime, Joey has stepped up
and did a really good job reviewing some terrifying patch series.

Having talked with the interested parties, it appears that James
is unlikely to have time for KVM in the near future, and that Joey
is willing to take more responsibilities.

So let's appoint Joey as an official reviewer, and give James some
breathing space, as well as my personal thanks. I'm sure he will
be back one way or another!

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 878dcd23b3317..fe2028b5b250f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12270,7 +12270,7 @@ F:	virt/kvm/*
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 M:	Oliver Upton <oliver.upton@linux.dev>
-R:	James Morse <james.morse@arm.com>
+R:	Joey Gouly <joey.gouly@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.39.2


