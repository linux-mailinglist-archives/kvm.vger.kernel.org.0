Return-Path: <kvm+bounces-24117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2A29516A3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A23DB2589B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D7C1411F9;
	Wed, 14 Aug 2024 08:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1b2Vkoo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A5924B4A;
	Wed, 14 Aug 2024 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723624293; cv=none; b=p1cBJXu6px/k9YJP3AEMWwMDqQI1M0ys8waSULsvEudvfCbMswTmPpJ/0q16TpUAqNj/2P2UvtpW5gSYB97YeCH8aCEPJ1fWg73edw2ZdDgnJ42kA0WyASeVWsiM/Xa2CKEEJ+/IkwriaileUdsB8c9yJRe/70jxDgUjiorWbFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723624293; c=relaxed/simple;
	bh=nLPuAIh8rjbIDAj5WhCdf3+G9eV6BNGUL1w9hDjvP2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CLaOqYJ2o+Vci0yBYOiB05qc9Cl2iN8Zs53QrBNuKRBIza9Sd4nZfOjSav0Qj3gBjU1d7CxywbmReMocEzDkiskg0z84ukJhYOqRuuOtG5oE7fJtrU5f56/r26nipRY+Bh7DvMXccJ/K7BCHWt9ePG7z859zHg3dMUnsYsNec5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1b2Vkoo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258E2C32786;
	Wed, 14 Aug 2024 08:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723624292;
	bh=nLPuAIh8rjbIDAj5WhCdf3+G9eV6BNGUL1w9hDjvP2M=;
	h=From:To:Cc:Subject:Date:From;
	b=u1b2VkooLHPDO+iwlj4CphrkBKK2gREfiWlKyi15SWpn7HP3n0JaOScz1OrdS+sM5
	 cuJ/DAcGRtviaDsGwsPqDhankoMlCgdk355EXO0/13kgKBmVydffFBV4M/60xJp502
	 Y9bj9nLZDhjoRTqqYUTuAYXfbbrVi02EgRYLz3et16awiVZsm9IifQOX5+RvXb1a9k
	 LdzJweeIeFLhbOxzMjo9uWCijZljOU+ycaVR9Njmbjc6nWqUI2IYx/wwdJR/qUOcq2
	 aXjNBfBvgwra1ruNkPfa1M36PIxbBvY9G0BqOJINv2qqa5EYessPVF4O/WME/MtrlM
	 8kqGJxdc+JE2A==
From: Amit Shah <amit@kernel.org>
To: seanjc@google.com,
	pbonzini@redhat.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: amit.shah@amd.com,
	bp@alien8.de,
	ashish.kalra@amd.com,
	thomas.lendacky@amd.com,
	maz@kernel.org
Subject: [PATCH] KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG
Date: Wed, 14 Aug 2024 10:31:13 +0200
Message-ID: <20240814083113.21622-1-amit@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

"INVALID" is misspelt in "SEV_RET_INAVLID_CONFIG". Since this is part of
the UAPI, keep the current definition and add a new one with the fix.

Fix-suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 include/uapi/linux/psp-sev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 2289b7c76c59..832c15d9155b 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -51,6 +51,7 @@ typedef enum {
 	SEV_RET_INVALID_PLATFORM_STATE,
 	SEV_RET_INVALID_GUEST_STATE,
 	SEV_RET_INAVLID_CONFIG,
+	SEV_RET_INVALID_CONFIG = SEV_RET_INAVLID_CONFIG,
 	SEV_RET_INVALID_LEN,
 	SEV_RET_ALREADY_OWNED,
 	SEV_RET_INVALID_CERTIFICATE,
-- 
2.46.0


