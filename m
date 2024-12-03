Return-Path: <kvm+bounces-32884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E829E1212
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 04:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C73D282D31
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17A018A6A1;
	Tue,  3 Dec 2024 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gy9S3RL2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6DD18732E;
	Tue,  3 Dec 2024 03:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733198034; cv=none; b=qlw0pAE0+BqmkLs9RPESYCeuyFACtmM7ZLmcmN2Dp7JBFyq5M5B65HyWdeWbcDFf6AkYIpgdRe2a3LlqOuflUWxSI0Wm9f2Ge+akwEuwaCQ9SyRPGWE5rTvqtjlBPKuRR2ICIwUIkMKM8jIweZWmaMuY2PX+ts/ELT2LNMfcJf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733198034; c=relaxed/simple;
	bh=n1Bo+ocWIwX2RhTBAyNb+AZLF714cNwghYqi2l+mTVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy2dwrjgHSK5VX/AOukMkRDFJAo0aFCVtsNwgLZwAfIGsO4dJXCgM8XCdRxD3N7oNC36VXSbhr3kMwS4+ZdFmhn4FZdVOeetY+BZFGK8ybKyxdtHn/+DXULAB0i2KeNzgtN+BGvGhPDGiJrfl5oKA6B1XiNvakFGz7ryy75LX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gy9S3RL2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA509C4CEDA;
	Tue,  3 Dec 2024 03:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733198034;
	bh=n1Bo+ocWIwX2RhTBAyNb+AZLF714cNwghYqi2l+mTVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gy9S3RL2jbXs5lN0+59rRTYfG8GwAUFBJ3blkB3cnwOBw1NQeCIqlFqdCkGarUauX
	 l3uyE38YjJegWJ2L882c3RNZCiWXv+agbL6bBNc5FOyAXGM0PENTPaJTXWUTllFjE/
	 gw0LUACVN0AI1PxIHABMfCzTWMPTjzWq5HVnxm0gPUK1K4wBk0HivrieyGJaG+OXsW
	 wq6BYtGIraelkVsFG94vIFnDbK/FPsJQUMv/jFz0cCHSmdJnqZv1rw5hyXak0Mq3A+
	 Rv36KwiidNjwHg/UyZR19cja4fMTnXUT0X50Efas/iiG2WBykiaN+Rp5EnnFd/G0p6
	 F8SLQbG4Fo5CQ==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: [PATCH 03/11] tools headers: Sync uapi/linux/kvm.h with the kernel sources
Date: Mon,  2 Dec 2024 19:53:41 -0800
Message-ID: <20241203035349.1901262-4-namhyung@kernel.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241203035349.1901262-1-namhyung@kernel.org>
References: <20241203035349.1901262-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up the changes in this cset:

  e785dfacf7e7fe94 ("LoongArch: KVM: Add PCHPIC device support")
  2e8b9df82631e714 ("LoongArch: KVM: Add EIOINTC device support")
  c532de5a67a70f85 ("LoongArch: KVM: Add IPI device support")

This addresses these perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h

Please see tools/include/uapi/README for further details.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org
Cc: loongarch@lists.linux.dev
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/uapi/linux/kvm.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 637efc05514534ca..502ea63b5d2e7371 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1158,7 +1158,15 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_RISCV_AIA,
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
+	KVM_DEV_TYPE_LOONGARCH_IPI,
+#define KVM_DEV_TYPE_LOONGARCH_IPI	KVM_DEV_TYPE_LOONGARCH_IPI
+	KVM_DEV_TYPE_LOONGARCH_EIOINTC,
+#define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
+	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
+#define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+
 	KVM_DEV_TYPE_MAX,
+
 };
 
 struct kvm_vfio_spapr_tce {
-- 
2.47.0.338.g60cca15819-goog


