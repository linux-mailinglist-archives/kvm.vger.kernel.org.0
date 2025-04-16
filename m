Return-Path: <kvm+bounces-43403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68953A8B324
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84F3B3BD211
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 08:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2336A22CBC9;
	Wed, 16 Apr 2025 08:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="v6bfIxnb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fsGZGUhy"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD1612CD96;
	Wed, 16 Apr 2025 08:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744791426; cv=none; b=OdkKNIz5IAjHKsQI90bxVHlo9kMaI0Dd4FVd8uu3oHO5d3Cd77AhhR65h3pzMH9D6meketwXsJMIHuV2UhcE2cb2TuTZIxfpIbSuqHjbRVKSnVPwc5/WWjGsw7p/+TGxecUe8CuhCorpNP9A1KHCOZtIRr4jcgyKpBt3UBUiY8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744791426; c=relaxed/simple;
	bh=u4CrPtjM2/s1r9RucEkw3Wm4tDwvpmG49jCjfS2ABJU=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=MH8p4ESN8SIhnSMYYGsy0lF1sq2vdLxRDd+ZCmtvNwXslhjJ2IB+9G+aE3RZjDinvuN4eYSHGyZ1h0qn7noOL7EarvIimjYmj1SVcyzL2XKhM1g3jNlUSFSHNDNCn786kC6ffaBkQIlnNvGO8PLcDoIw+dqBlbPcHKebdHgpKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=v6bfIxnb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fsGZGUhy; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Wed, 16 Apr 2025 08:16:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744791422;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dV4c1nIHek6fWfDNR/sFsg7UIs5ti7koym3h3PZsGbw=;
	b=v6bfIxnbAk7i8S5SMwW7Og0gKrF5n3pyXD1KzLTb7+EumBi8cZAa7arvpDlFlcCVA623cg
	Mvw66sX/2YVwMNnaEICsa4PqvswKPNjMtJ41b+dzy47gq6GZGjqVsmlRneSF9W+DlMokdg
	k6ihkoqXViBEXU+Lhvcqn8/TwlIXWjtCMTPrVKpDy197vsQd2X57mzI+WlmgqzL5b6Pyyi
	aW+I6Xol6WHfMu34N/7og9ebl7xOUpXBOPtd61N/cDIBON42m3BjVW2M+Lg4EiQSdTM6nK
	IMdJv+hwAAomScG14yWubZQNEmWT7XGuNdgv7fHmMp6AysUwt3O2nxSwAz+p8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744791422;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dV4c1nIHek6fWfDNR/sFsg7UIs5ti7koym3h3PZsGbw=;
	b=fsGZGUhyiSHYQEFk7thnNeW+JNl6ZqS1MtdUvvxJBhC27V27BN/xJw4c4nsrK+yLjOMFaq
	3Mfrf+oUUEEAh4Dw==
From: "tip-bot2 for Mike Rapoport (Microsoft)" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/e820: Discard high memory that can't be
 addressed by 32-bit systems
Cc: Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Andy Shevchenko <andy@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Davide Ciminaghi <ciminaghi@gnudd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <20250413080858.743221-1-rppt@kernel.org>
References: <20250413080858.743221-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <174479141543.31282.1765445425938242082.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     1e07b9fad022e0e02215150ca1e20912e78e8ec1
Gitweb:        https://git.kernel.org/tip/1e07b9fad022e0e02215150ca1e20912e78e8ec1
Author:        Mike Rapoport (Microsoft) <rppt@kernel.org>
AuthorDate:    Sun, 13 Apr 2025 11:08:58 +03:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 16 Apr 2025 09:51:02 +02:00

x86/e820: Discard high memory that can't be addressed by 32-bit systems

Dave Hansen reports the following crash on a 32-bit system with
CONFIG_HIGHMEM=y and CONFIG_X86_PAE=y:

  > 0xf75fe000 is the mem_map[] entry for the first page >4GB. It
  > obviously wasn't allocated, thus the oops.

  BUG: unable to handle page fault for address: f75fe000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000
  Oops: Oops: 0002 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  EIP: __free_pages_core+0x3c/0x74
  ...
  Call Trace:
   memblock_free_pages+0x11/0x2c
   memblock_free_all+0x2ce/0x3a0
   mm_core_init+0xf5/0x320
   start_kernel+0x296/0x79c
   i386_start_kernel+0xad/0xb0
   startup_32_smp+0x151/0x154

The mem_map[] is allocated up to the end of ZONE_HIGHMEM which is defined
by max_pfn.

The bug was introduced by this recent commit:

  6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")

Previously, freeing of high memory was also clamped to the end of
ZONE_HIGHMEM but after this change, memblock_free_all() tries to
free memory above the of ZONE_HIGHMEM as well and that causes
access to mem_map[] entries beyond the end of the memory map.

To fix this, discard the memory after max_pfn from memblock on
32-bit systems so that core MM would be aware only of actually
usable memory.

[ mingo: Fixed build failure. ]

Fixes: 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")
Reported-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Arnd Bergmann <arnd@kernel.org>
Tested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Link: https://lore.kernel.org/r/20250413080858.743221-1-rppt@kernel.org
---
 arch/x86/kernel/e820.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9d8dd8d..2f38175 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1299,6 +1299,14 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+#ifdef CONFIG_X86_32
+	/*
+	 * Discard memory above 4GB because 32-bit systems are limited to 4GB
+	 * of memory even with HIGHMEM.
+	 */
+	memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
+#endif
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 

