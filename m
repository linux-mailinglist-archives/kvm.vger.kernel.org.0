Return-Path: <kvm+bounces-53399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEFEB111CE
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04A85462E4
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDE52EE5FF;
	Thu, 24 Jul 2025 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Mrh5O04f";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1NzEzFLO"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B7D2EE27C;
	Thu, 24 Jul 2025 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753385836; cv=none; b=ABWzjYbE1libtTBjoLgl/flFjk53wsVzcowr/jm23xgPAQAbWth6w8PgcLPeL+TcW9BGRqgf9z6cNXuvCUYpBhvhRlJqLoYl+k84h188JCG4BrrtfAjsz6tqXMRNFlUp5E6F5ryXVNnhq7Utw+/mBlVKdg9kJ9MX7f7f9s0Q1cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753385836; c=relaxed/simple;
	bh=SYRZmFM3Ioa0y0H9EeRaz2/V19DLQSJh6KQlg7ks8hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJSt6RtEXTJL78l3Xm2Gmuhob3W23AoBNtSr7uRUQ3iKACPFQc0W/f+AzupEue7z0SbX3CPRf3k/TA8i9z1CQI19scTlH+g8jztlVWBdwG09U0/PrbdJ18f7VI7KecGs4BhXz5Mfe1huU1RnDXDmzKrgaP82kOsIMQJsRBC1MXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Mrh5O04f; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1NzEzFLO; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753385833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Xp1mFPuuaOTq+ytYDakiRoJMAib8ShAL5vVh6jiIQ=;
	b=Mrh5O04fdrJojbS6a5+KI0UYwEDw0aKCClaOxLP6ncoAntRTT8JLB97iIpcHaOyf304HlF
	t/7SSiHm3LFgrte61IqSy2FC7JfWR10wypsCMrxYp2HVzpL7M/wSG0TJGiOfDLxAQD5G3o
	+6IeLWujv7hknrUwrXbq+qLPxf61OKw8psv8iGw+DjjO2emAnW2DFrvz4cMdgCK1wReFbX
	v/jEDA/VnfEvewDR2Yy1Ek6HXKAGHc1cgiZpPkDY8R0Zd7df675i0kukzW6sNpWu6YDLE0
	RAdkA0S8x0ghwwemX4XfSzb6wsEZJkNQwSWCQfQoDIHSrxzyXclEat40GA2rgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753385833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Xp1mFPuuaOTq+ytYDakiRoJMAib8ShAL5vVh6jiIQ=;
	b=1NzEzFLOT5f3Hs14tWbBaRXmf9yVLEejoJJXYuk9itDRRk6OPujSMvyfBPH5+JUZqtaKpu
	KKCpz2Sj3P4gbDAw==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v5 1/4] x86/cpuid: Remove transitional <asm/cpuid.h> header
Date: Thu, 24 Jul 2025 21:37:02 +0200
Message-ID: <20250724193706.35896-2-darwi@linutronix.de>
In-Reply-To: <20250724193706.35896-1-darwi@linutronix.de>
References: <20250724193706.35896-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All CPUID call sites were updated at commit:

    968e30006807 ("x86/cpuid: Set <asm/cpuid/api.h> as the main CPUID header")

to include <asm/cpuid/api.h> instead of <asm/cpuid.h>.

The <asm/cpuid.h> header was still retained as a wrapper, just in case
some new code in -next started using it.  Now that everything is merged
to Linus' tree, remove the header.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/include/asm/cpuid.h | 8 --------
 1 file changed, 8 deletions(-)
 delete mode 100644 arch/x86/include/asm/cpuid.h

diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
deleted file mode 100644
index d5749b25fa10..000000000000
--- a/arch/x86/include/asm/cpuid.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#ifndef _ASM_X86_CPUID_H
-#define _ASM_X86_CPUID_H
-
-#include <asm/cpuid/api.h>
-
-#endif /* _ASM_X86_CPUID_H */
-- 
2.50.1


