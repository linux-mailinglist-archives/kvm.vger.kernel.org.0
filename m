Return-Path: <kvm+bounces-47670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82996AC32CE
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48DD217093D
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495111A76D4;
	Sun, 25 May 2025 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TXk+GaS7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C472DCBF7
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159404; cv=none; b=fn7LUg0qO1s+XqTmvX8oG2E3pUL6Zedi7kn1NpJZWnlStcntjkKScqlGpGORXYWpn8tF42PjmHG/E6uLKQvSRF/rkX8jvlKEiLVCYDK/i6mXj8jJmUS88NRLLtbTkmWLLS3VlAm5yG5Rp6gFR8v17Oi9MzJvbu72NDS/OS37mMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159404; c=relaxed/simple;
	bh=AQc3Ad1KTNoWAOJ9yKetJKURUKuAp2OJ1cfrinO+WVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNcgTIks6PmP6amAzgv6K7LlGaSzICAxeFSdDIekyTZ+Mn6TtZPWPgrVEh2Met1Yb2Un7toc6RF56REbqFp//2Z7HViHJBufOYT3EolJuSzivQEQXXxzyqqb7yEHv5xT6ByFnUIoELI1adbO3qXyaAhCEin19vu6jvJU/F9dMuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TXk+GaS7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E070CC4CEED;
	Sun, 25 May 2025 07:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159404;
	bh=AQc3Ad1KTNoWAOJ9yKetJKURUKuAp2OJ1cfrinO+WVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXk+GaS7L4iSDYYgE26q/YUowIgQy6qdm2bAtCfSbH2X9a+2rgfwZu/1xdu5vInLC
	 aVRXS+dMPRNFIu6fKbGuKONc6S75dxMZhtmEvk8B/T9f+xn/vVzjD+WCEw6fN7RbYz
	 9e9D5ZnRdR8q40ZrRFG4+R0kcecM12kfpS8XKtQH7Oc++BKFc3PQDlhkpHU+/hQ36y
	 A3rkMhOxw1AIv60VmWQTnamzOwFiv01YICDgFScJMmEotOKqn1hEZWXpdHfv1dHq2S
	 ljX9o2Bq5inw10KpF+gLBXLc/hjtXPHzQmxUxRun5r4qJzx5LBI8FklDJ/xXZCbWhf
	 I7QTg+/JRw4Cg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 10/10] util/update_headers: Add vfio related header files to update list
Date: Sun, 25 May 2025 13:19:16 +0530
Message-ID: <20250525074917.150332-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250525074917.150332-1-aneesh.kumar@kernel.org>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 util/update_headers.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 789e2a42b280..8dd0dd7a9de0 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -35,6 +35,13 @@ do
 	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
 done
 
+
+VFIO_LIST="vfio.h iommufd.h"
+for header in $VFIO_LIST
+do
+	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
+done
+
 unset KVMTOOL_PATH
 
 copy_optional_arch () {
-- 
2.43.0


