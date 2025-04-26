Return-Path: <kvm+bounces-44417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0045A9DA93
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 365A91BA7101
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325A1241662;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWE/bzN/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57823498E;
	Sat, 26 Apr 2025 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670532; cv=none; b=KQ4cfj3hSYIBMAxfLMr/In5bLcPxtdc2eaZTU5AaA8LMwMbYbffXOyIfQeo94VulEdvSiekR98m3VbmmOM2jcYWQfZpqFD9yOfqdZ7l2Qu/FPOf6u5+DxPKckCJnzmEjcSA5UgGvV+lnm3c9DqtyqjrHrs1JZPwTv7dRGRX6aI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670532; c=relaxed/simple;
	bh=8A74ZozC9sTAb9FFk+IBeU6GZPUV1uY2uFxjvew56hk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IS68iY/rK3STA8Rgqf69bYjfCx7j2/IkZEda+nfls0249yF0U6xBzVfPYZ0Ob91/f8pbl/icOfCNdtz2bk7c/6o1ESL5PuGfQWAVM+8ODs6VTS/78UQdJEAav1h2OCE0klH997KrSHa+c49aDWFzif7eV9dZLW50JNefALMjhGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWE/bzN/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09E6C4CEE2;
	Sat, 26 Apr 2025 12:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670532;
	bh=8A74ZozC9sTAb9FFk+IBeU6GZPUV1uY2uFxjvew56hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWE/bzN/N0ZmsgFxg7ba7AYijHbVrWhlZX3XFtDiZQz09jz3gglKTH9KXoud8aHe0
	 aM3K4JSMY3cyCnN7MdRYWh8ErZ7IzoJY49Gw8oliVLrtzfATTjh797o2+6smm0CfuL
	 g4wBK+2G9PgIwbnVb71f/RcmG+qXHDnKElPW8RU7pU7i5Ok2bwR6YVMBD4LiXsoTzr
	 3nFHYqiO8zRan2moHAjYEPV2NHHQDnacvm8WgihP45k/UK/2fMhIeX3b4wTq525OTu
	 G/+X1r4L+SlAOu06VmHP3zmXlSMzZpxGsAY6KQxUfIiVHNIU0Gr4rv7QIG+CqqavQe
	 c3ZHoo1omkKyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeI-0092VH-2z;
	Sat, 26 Apr 2025 13:28:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 07/42] arm64: sysreg: Update TRBIDR_EL1 description
Date: Sat, 26 Apr 2025 13:28:01 +0100
Message-Id: <20250426122836.3341523-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing MPAM field.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 668a6f397362c..6433a3ebcef49 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3688,7 +3688,12 @@ Field	31:0	TRG
 EndSysreg
 
 Sysreg	TRBIDR_EL1	3	0	9	11	7
-Res0	63:12
+Res0	63:16
+UnsignedEnum	15:12	MPAM
+	0b0000	NI
+	0b0001	DEFAULT
+	0b0010	IMP
+EndEnum
 Enum	11:8	EA
 	0b0000	NON_DESC
 	0b0001	IGNORE
-- 
2.39.2


