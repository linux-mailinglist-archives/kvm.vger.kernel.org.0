Return-Path: <kvm+bounces-53277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8ABB0F969
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8908F188120B
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CAA239570;
	Wed, 23 Jul 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MLKsqjGz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sJGtJphd"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5B42367A6;
	Wed, 23 Jul 2025 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753292214; cv=none; b=G76RHWxZtM/YFGz2YMT7RfluLgFbDs1EmUXayRl//4wlTxr3mCr5bEykdvI74v+QWr51IAP8YSrGNvSNmZV09aXU8syP2fMNXIHdYTj7c3TKpeJW6VXRe207ySxACl/DNZUZo1HxCYLB8yty5Ar7KLxr4ezHQrtjn6MwfqVA620=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753292214; c=relaxed/simple;
	bh=SYRZmFM3Ioa0y0H9EeRaz2/V19DLQSJh6KQlg7ks8hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sES09tv1QGBhkkmmhI79j9TJ0YYLR9cjirHKuq8dDagKkD+dPKT+lv3lMPd6vP5giBW/9iG+e/w/L3jk83vpiSHBVKTiEhtO5A868F0u+gk1Vl7fFVIBWerLcVGtIlpvN6sZaPbUMOrW4Z7+B3wTVx6Qp58b+0QbUr8BNm7ZTcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MLKsqjGz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sJGtJphd; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753292210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Xp1mFPuuaOTq+ytYDakiRoJMAib8ShAL5vVh6jiIQ=;
	b=MLKsqjGz7dv4F3dGHFGcvMIpn4ph8VkSnRwmYGXvIL8bb0YZJiLtfARFFH/Yyn6BO/tZeq
	D8JwaU17tFvNs4VVhG5SOidsOCzIIG/NBJLtWtjrQwXHjMGC11aVEGBhnh2nmaCJ88P0vZ
	vS5YoR0yzHnoe6gGAq/ODhqNBYbtwSQwOsaABv7VuYXFoUBAVmf35dJbQLGvt0wyDzxFZC
	5xgJpdNndsE1kid6i76AxDefBWiJROWrtn3Gycf+uMZkI0hOaJdnNYx22tTtMb2CMyVj6t
	CzizYZd4OCtcy0tBDy14YpdyJF9XSU9KlAJXRkvxaw0hS4i1QusaNE0++6Kt7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753292210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Xp1mFPuuaOTq+ytYDakiRoJMAib8ShAL5vVh6jiIQ=;
	b=sJGtJphdJHSQ330EyRl6dwk+HIMhgOLRNNLP5nyEGAkUvzGQoJly+53bKOs5OZSpSnmEmg
	bijFHTo6AhFkV0CQ==
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
Subject: [PATCH v4 1/4] x86/cpuid: Remove transitional <asm/cpuid.h> header
Date: Wed, 23 Jul 2025 19:36:40 +0200
Message-ID: <20250723173644.33568-2-darwi@linutronix.de>
In-Reply-To: <20250723173644.33568-1-darwi@linutronix.de>
References: <20250723173644.33568-1-darwi@linutronix.de>
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


