Return-Path: <kvm+bounces-37688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACBDA2E942
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 11:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E7EC7A1F05
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4FBF1E3DED;
	Mon, 10 Feb 2025 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WExtlNhH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DE81E377F;
	Mon, 10 Feb 2025 10:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739182919; cv=none; b=Svdgv0rDOu60rhmh1QOqjaMnICm3bsw2MBGpZViTOgPZRJePuXum6J46JEJx29YTsjNCeUQka1L13CRKHPNZVEblnOR0snZLbG0knNvETnO+/bIQMNNKqsIyOe1sm+PIznaoTP9N8JvWMRap9FQyAyf1Rbh+1KfW8ng1bl2G+3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739182919; c=relaxed/simple;
	bh=ifzqjmVo6+1GZ02Esx+8xwzoWK38llbl0Pz1DASKo6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A36ftD246a1S/3BF3wyIiSGqdaPQUuU7Ch/PoHKJBsbi8z1Wstzd06b8ixBeyCqmPvH3Hh5QNdqdOuGg1H4CmpW+hYodmycj8RI484RXS1v98fRKsHZH9FYBajXhSL3fF2HoKSxKZpw6xIU3HFkXMnoBrEx0IU09Jh2PUlK39X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WExtlNhH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFAAC4CED1;
	Mon, 10 Feb 2025 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739182919;
	bh=ifzqjmVo6+1GZ02Esx+8xwzoWK38llbl0Pz1DASKo6g=;
	h=From:To:Cc:Subject:Date:From;
	b=WExtlNhHFt/BMC6J7NrMsiwq6mHoZXMHAzRYArWt9cJdJ6sbvdhgP4IuNnGJ8AKw6
	 xRjT41zmYZ90C7cVmLJ7N3KmViPk5/+y6B0tgiA1/z7zjk4NQTbR/RFXFdoV2iGCNt
	 fUoCipSDe4LHEjnqV0BnaG2iYWib1Wc64+IxT65qaCD1JjIgOV9XYRodTrtYy8Rw+3
	 wTaZzELTUNc5cJYPIO2+Y7+dxy7QFHpE4Yb+dSg5IALFnojRkCpOPiqzjl5hVwarm+
	 CWF+ULjeWlGjfIBGIroUg2rVwxRjhVtChRNTcMqVsNyoZm2S11qScAfHIv3rOq0q/l
	 Y2wR6rAUy49iQ==
From: Masahiro Yamada <masahiroy@kernel.org>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Masahiro Yamada <masahiroy@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH] LoongArch: KVM: remove unnecessary header include path
Date: Mon, 10 Feb 2025 19:21:41 +0900
Message-ID: <20250210102148.1516651-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arch/loongarch/kvm/ includes local headers with the double-quote form
(#include "..."). Also, TRACE_INCLUDE_PATH in arch/loongarch/kvm/trace.h
is relative to include/trace/.

Hence, the local header search path is unneeded.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/loongarch/kvm/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index 3a01292f71cc..f4c8e35c216a 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -3,8 +3,6 @@
 # Makefile for LoongArch KVM support
 #
 
-ccflags-y += -I $(src)
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
-- 
2.43.0


