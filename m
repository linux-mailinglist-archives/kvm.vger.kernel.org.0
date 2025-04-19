Return-Path: <kvm+bounces-43693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3342A94416
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 17:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E662C3B841C
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 15:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B951DC997;
	Sat, 19 Apr 2025 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Jbg1EhHe";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="qoO/JRDB"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281AA1E884;
	Sat, 19 Apr 2025 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745074882; cv=none; b=RKGkN5HHEdXPezbIEyv62sr0+2OI3keiHI2mNxB2v7zqtc6OZk/noj1YU9NjXiCpToHrF3sUEAO/TsaAQdwtr++qF4d8EbwX2326NDatWfGt8N4PmhSbpRSovDh90we5UTLORVYJaP7vEgl75pe+CdPdq9PD55UdgrDDwHsStpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745074882; c=relaxed/simple;
	bh=YgVYSHeKY/a1W/bRGfnFAmUq6gV1z1GAnooUQz1ZYic=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=pja+s3IGm994LAcbH40dTY26YNV/49XRDIUiavLz8R8BicafZkIIZ4mM1HvJqqkJzBsbxSZr+imatqB347y7EQSrND1QAQINn+J/Xz5EwzGmlJbDRb7jQ4CAVVxLD5zxajWEpUb9dV7NQ66W9xDr/2zX9eHVnj9XoyNDJzIgcrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Jbg1EhHe; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=qoO/JRDB; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Sat, 19 Apr 2025 15:00:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1745074868;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1M1aCK5ESLtJp6YPPmUCNmlhTn4cy5InXXOaZ8RKfo=;
	b=Jbg1EhHe0Mew6MM62uWjy8l3S/MSG6gxdeWU0cITOlS2rKBJgRj0FxtFvBJBhCW2kXwTYp
	9bfHvDmfNYCffB6CqGcoJogB6u8bK3M6TBveSTheFFprEDFOGfahevPy+mIDlrbrYKwFj1
	yjtXxdM1NcEn7j+JwdZmixleUwPTl+n4MpUvywOoLva2A032VFtwAfsR/vwXuSnt4BmS0Q
	ABbWJEDAbjRr/uWRSDjYf+Rt2Eh4OJ7H4T5KSxhsSBUJby0wm92SIIG0qwaLcOz0fus8ec
	bJQ9FOXSFtFQd0u2Bpryb/IxE2Tu1yx601sns5MPuYd0bv8FZjGSrS5MNATr/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1745074868;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1M1aCK5ESLtJp6YPPmUCNmlhTn4cy5InXXOaZ8RKfo=;
	b=qoO/JRDBqt/fRZuv3OiKh8fbSnNgnx80Yxlg83Dh8LWLLi3G5S5WMJOYhwRY3UIJgG+KdX
	6dv+zG2NDjCEU/DQ==
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
In-Reply-To:
 <20250413080858.743221-1-rppt@kernel.org # discussion and submission>
References:
 <20250413080858.743221-1-rppt@kernel.org # discussion and submission>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <174507483228.31282.2105701735501523134.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     83b2d345e1786fdab96fc2b52942eebde125e7cd
Gitweb:        https://git.kernel.org/tip/83b2d345e1786fdab96fc2b52942eebde125e7cd
Author:        Mike Rapoport (Microsoft) <rppt@kernel.org>
AuthorDate:    Sun, 13 Apr 2025 11:08:58 +03:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Sat, 19 Apr 2025 16:48:18 +02:00

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

Fixes: 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")
Reported-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Link: https://lore.kernel.org/r/20250413080858.743221-1-rppt@kernel.org # discussion and submission
---
 arch/x86/kernel/e820.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9d8dd8d..9920122 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1299,6 +1299,14 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+	/*
+	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
+	 * to even less without it.
+	 * Discard memory after max_pfn - the actual limit detected at runtime.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32))
+		memblock_remove(PFN_PHYS(max_pfn), -1);
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 

