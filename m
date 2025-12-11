Return-Path: <kvm+bounces-65724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2F5CB4E79
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 320B73019BFD
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E78729BDA2;
	Thu, 11 Dec 2025 06:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iX08s+ys"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFED29D28A
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435532; cv=none; b=kzjIIGW8yYkmJCcLTJAzMJ8tDAhv6nDrlGvNg2x9K+sJQp+2jwYsrnsEEE9kI0YbkNZoa4jeu72rr1L8hYQrXgGJc2qX4BDy0tVpaRM81HaTY+rFB7dLMWmc6aATCj0nJA0xD0j3xihp6V6tDp2q751P9bQAwHEAbs0jKbQBA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435532; c=relaxed/simple;
	bh=d4fEjjgjaO1Mc5bLnP4bPrihTztTGRnCptHhP/Q5vnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q5jN15yseOTtLu3g9ZkFiPLwLyr7oRi8hKqh52z+K3m60b3IiNQx5jV0COAW0nOqHTnE2s7dTym6moilTV/q3FcQ9glOmlUS55jb09oPzqzAcO6IxAtZTaGzM0+27rRcdtKC0/lqK6/j5ogZAA2kMoWzl36QwqwvB7RL22J4vdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iX08s+ys; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435530; x=1796971530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d4fEjjgjaO1Mc5bLnP4bPrihTztTGRnCptHhP/Q5vnk=;
  b=iX08s+ysVRKNyoYi5oVFC098OHiGwsWqHpIElrDgC+00VIzhruuu3DN1
   zuur7TgirBKX/bNx/3gr7Pr5YlFcODWevgDLR6O+9Jy28zAkpP8a6091D
   ZpS/9UjjmvsPLNzIXh1HbPk9i8hTCahgFv7Ah61dwk/gOE/Dnwx9q/MLb
   txKoLsdDQJqVTUmRD4OdWqKvG6078BChKuT8nC/jugrDfN07zIMD51Fyi
   rdb6S1Nm0FLWhzxmi60M/AfKN1C7AVsQ2LU/kOVHJ85js+4WrLDq6Imye
   tAhHwC4mJXBC90nrW4AmKpzbUouyLgPkyKu65gmuQEKkbn+vkHmyNytt9
   Q==;
X-CSE-ConnectionGUID: tYmi4HzBTJGdWSPeeyzf9A==
X-CSE-MsgGUID: rEFXNgGuTFS1fsR+HtfbQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584468"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584468"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:29 -0800
X-CSE-ConnectionGUID: 52B2NNYHQ4GOo6aL5RfDfw==
X-CSE-MsgGUID: P3rtpxZpSCCAnIq8CXohyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196495009"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:25 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 6/9] i386/monitor: Support EGPRs in hmp_print
Date: Thu, 11 Dec 2025 15:09:39 +0800
Message-Id: <20251211070942.3612547-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070942.3612547-1-zhao1.liu@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add EGPRs in monitor_defs[] to allow HMP to access EGPRs.

For example,

(qemu) print $r16

Since monitor_defs[] is used for read-only case, no need to consider
xstate synchronization issues that might be caused by modifying EGPRs
(like what gdbstub did).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * New patch.
---
 target/i386/monitor.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index d2bb873d4947..99b32cb7b0f3 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -623,6 +623,22 @@ const MonitorDef monitor_defs[] = {
     { "r13", offsetof(CPUX86State, regs[13]) },
     { "r14", offsetof(CPUX86State, regs[14]) },
     { "r15", offsetof(CPUX86State, regs[15]) },
+    { "r16", offsetof(CPUX86State, regs[16]) },
+    { "r17", offsetof(CPUX86State, regs[17]) },
+    { "r18", offsetof(CPUX86State, regs[18]) },
+    { "r19", offsetof(CPUX86State, regs[19]) },
+    { "r20", offsetof(CPUX86State, regs[20]) },
+    { "r21", offsetof(CPUX86State, regs[21]) },
+    { "r22", offsetof(CPUX86State, regs[22]) },
+    { "r23", offsetof(CPUX86State, regs[23]) },
+    { "r24", offsetof(CPUX86State, regs[24]) },
+    { "r25", offsetof(CPUX86State, regs[25]) },
+    { "r26", offsetof(CPUX86State, regs[26]) },
+    { "r27", offsetof(CPUX86State, regs[27]) },
+    { "r28", offsetof(CPUX86State, regs[28]) },
+    { "r29", offsetof(CPUX86State, regs[29]) },
+    { "r30", offsetof(CPUX86State, regs[30]) },
+    { "r31", offsetof(CPUX86State, regs[31]) },
 #endif
     { "eflags", offsetof(CPUX86State, eflags) },
     { "eip", offsetof(CPUX86State, eip) },
-- 
2.34.1


