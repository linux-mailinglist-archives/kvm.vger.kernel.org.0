Return-Path: <kvm+bounces-54561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD36B23D5A
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 02:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F5A9620A97
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 00:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCA712FF69;
	Wed, 13 Aug 2025 00:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eKnyjKzo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D641EF50F;
	Wed, 13 Aug 2025 00:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755046351; cv=none; b=QXPUpcL4HwH05YdE8z8EA8NNZmYwYg6oR2Csxosl5S1yXjvS53WP1G+WcUrm0FPIdPfNJJ1+7jOME7UY8fHHlgY1CSZ5MK1zNi/0w5mwB5u8PwAoRNM/J/mCXR5yGuLc1AmF97Bb3kJquqvyL/zQp4LwcV0tHB9bAE33zjQE1WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755046351; c=relaxed/simple;
	bh=W59sWljTo31n0OteBWneyzCr/mv5go6jVJu0eiSWH4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pNYSh0M8s1zHoZURVc0syqTwpVHWlwQfHUosGx+9JMnVvPXUhEHQsVOIyWWKtH1E4WcmHXZfRkKnfUWy1Tt5w5/c0X0rYQYGwgYhOg3fxLyVrC8D+Q+WaY0o1nbr7ry2x1Y0snSWRXjVbiN2aOpyMFc/GzMhcoxOIy6ez7V51pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eKnyjKzo; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755046350; x=1786582350;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=W59sWljTo31n0OteBWneyzCr/mv5go6jVJu0eiSWH4k=;
  b=eKnyjKzoIZofWw9Ls4K6dYIPVrDunEET54bmMNmZGDNspf9/ESEaddLQ
   ToS+g7L15/YNkfBNxCV3U1brCelLhjP0Tq4JakEpnV291lO9cxdaYwg+K
   D4p3Xsu7D725jU+/8go7XEfrYEv7ha0yvacL1v3esTYNHjgsVu327yxiA
   vLkdRN60xVaIAhm/3gDZJwiJW4iSJBe2njePwOfp0CT1ng2+DRGMYyRXi
   Ixy/9wh2TfiMimCTmm+/y6e4e5/emo0rYFTCYr2U73J32L4aTkOVCJxB2
   zEmhLPH4qKW5lIJLXa2re2pPmelBOa1T5Med2t4hOqxvdTKqlb8sYrWI3
   A==;
X-CSE-ConnectionGUID: g2i19cr6TUOWNqMzvBnPhA==
X-CSE-MsgGUID: EN6brwLRQLmItw+E6n/XuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57394535"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57394535"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 17:52:29 -0700
X-CSE-ConnectionGUID: jXTc6OxET9muuvbGrymxJQ==
X-CSE-MsgGUID: bd6JqGcxSweRxJy7OjRLHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="190032042"
Received: from linux-pnp-server-11.sh.intel.com ([10.239.176.178])
  by fmviesa002.fm.intel.com with ESMTP; 12 Aug 2025 17:52:25 -0700
From: Wangyang Guo <wangyang.guo@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: wangyang.guo@intel.com,
	Tianyou Li <tianyou.li@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to virt_spin_lock
Date: Wed, 13 Aug 2025 08:50:43 +0800
Message-ID: <20250813005043.1528541-1-wangyang.guo@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When multiple threads waiting for lock at the same time, once lock owner
releases the lock, waiters will see lock available and all try to lock,
which may cause an expensive CAS storm.

Binary exponential backoff is introduced. As try-lock attempt increases,
there is more likely that a larger number threads compete for the same
lock, so increase wait time in exponential.

The optimization can improves SpecCPU2017 502.gcc_r benchmark by ~4% for
288 cores VM on Intel Xeon 6 E-cores platform.

For micro benchmark, the patch can have significant performance gain
in high contention case. Slight regression is found in some of mid-
conetented cases because the last waiter might take longer to check
unlocked. No changes to low contented scenario as expected.

Micro Bench: https://github.com/guowangy/kernel-lock-bench
Test Platform: Xeon 8380L
First Row: critical section length
First Col: CPU core number
Values: backoff vs linux-6.15, throughput based, higher is better

non-critical-length: 1
       0     1     2     4     8    16    32    64   128
1   1.01  1.00  1.00  1.00  1.01  1.01  1.01  1.01  1.00
2   1.02  1.01  1.02  0.97  1.02  1.05  1.01  1.00  1.01
4   1.15  1.20  1.14  1.11  1.34  1.26  0.99  0.93  0.98
8   1.59  1.71  1.18  1.80  1.95  1.45  1.05  0.99  1.17
16  1.04  1.37  1.08  1.31  1.85  1.50  1.24  0.99  1.24
32  1.24  1.36  1.23  1.40  1.50  1.86  1.45  1.18  1.48
64  1.12  1.24  1.11  1.31  1.34  1.37  2.01  1.60  1.43

non-critical-length: 32
       0     1     2     4     8    16    32    64   128
1   1.00  1.00  1.00  1.00  1.00  0.99  1.00  1.00  1.01
2   1.00  1.00  1.00  1.00  1.00  1.00  1.00  0.99  1.00
4   1.12  1.25  1.09  1.07  1.12  1.16  1.13  1.16  1.09
8   1.02  1.16  1.03  1.02  1.04  1.07  1.04  0.99  0.98
16  0.97  0.95  0.84  0.96  0.99  0.98  0.98  1.01  1.03
32  1.05  1.03  0.87  1.05  1.25  1.16  1.25  1.30  1.27
64  1.83  1.10  1.07  1.02  1.19  1.18  1.21  1.14  1.13

non-critical-length: 128
       0     1     2     4     8    16    32    64   128
1   1.00  1.00  1.00  1.00  1.00  1.00  1.00  1.00  1.00
2   0.99  1.02  1.00  1.00  1.00  1.00  1.00  1.00  1.00
4   0.98  0.99  1.00  1.00  0.99  1.04  0.99  0.99  1.02
8   1.08  1.08  1.08  1.07  1.15  1.12  1.03  0.94  1.00
16  1.00  1.00  1.00  1.01  1.01  1.01  1.36  1.06  1.02
32  1.07  1.08  1.07  1.07  1.09  1.10  1.22  1.36  1.25
64  1.03  1.04  1.04  1.06  1.13  1.18  0.82  1.02  1.14

Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Wangyang Guo <wangyang.guo@intel.com>
---
 arch/x86/include/asm/qspinlock.h | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 68da67df304d..ac6e1bbd9ba4 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -87,7 +87,7 @@ DECLARE_STATIC_KEY_FALSE(virt_spin_lock_key);
 #define virt_spin_lock virt_spin_lock
 static inline bool virt_spin_lock(struct qspinlock *lock)
 {
-	int val;
+	int val, locked;
 
 	if (!static_branch_likely(&virt_spin_lock_key))
 		return false;
@@ -98,11 +98,33 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
 	 * horrible lock 'holder' preemption issues.
 	 */
 
+#define MAX_BACKOFF 64
+	int backoff = 1;
+
  __retry:
 	val = atomic_read(&lock->val);
+	locked = val;
+
+	if (locked || !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL)) {
+		int spin_count = backoff;
+
+		while (spin_count--)
+			cpu_relax();
+
+		/*
+		 * Here not locked means lock tried, but fails.
+		 *
+		 * When multiple threads waiting for lock at the same time,
+		 * once lock owner releases the lock, waiters will see lock available
+		 * and all try to lock, which may cause an expensive CAS storm.
+		 *
+		 * Binary exponential backoff is introduced. As try-lock attempt
+		 * increases, there is more likely that a larger number threads
+		 * compete for the same lock, so increase wait time in exponential.
+		 */
+		if (!locked)
+			backoff = (backoff < MAX_BACKOFF) ? backoff << 1 : backoff;
 
-	if (val || !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL)) {
-		cpu_relax();
 		goto __retry;
 	}
 
-- 
2.43.5


