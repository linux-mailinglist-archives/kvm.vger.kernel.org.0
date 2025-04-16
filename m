Return-Path: <kvm+bounces-43399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF624A8B20B
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C2041904B18
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2A522B8B0;
	Wed, 16 Apr 2025 07:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="genllIwk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BJXvjtr8"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD678F66;
	Wed, 16 Apr 2025 07:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744788306; cv=none; b=faBYPHYufvzHPWhmb4KdZtWEuKeTtFEydEglyxWX8DOysW/OqV0w7WGr9yzipRCoaupv/HRDDgAMND6LeVz84SzileAVETAx/dictVU494KQV7B/jxPU0yntWEyZa2o5HlmZcJpO8RsGN1zO4KvJmBQn2fDf/cgTmXYDZpXJNiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744788306; c=relaxed/simple;
	bh=MedJfNtknxRj8ALaSCS2NveDWfGDaHDwTrcCOZeoXTo=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=g2ReHxfGeGJeE1KaL3eQ6rC2RNvRe9r4u++AjvVzYHThAjolu5yCKf010sk6lSBXW89lNnDbU1gKq6J0lkGWRFYu3//zbMWnCUP2or5zKPDOkagkWe55Y7uQcOMT3Q9agCc8/ohJKJMCDM9c80IbUGER8vCNh9wa4iGbpYP586g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=genllIwk; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BJXvjtr8; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Wed, 16 Apr 2025 07:24:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744788303;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VvfCcy3eif1YF5K8hb+jEM8YuXHXksLikwHcc5iatnM=;
	b=genllIwkpStwfivFcYJ3M2rRrWDfagme4AbnM+cHoiMWyLt3qM9HV7pne2vx5riAkD6Ts6
	D+D4fcM9KOfnmNccQlmiE1N7Om5FzcKO7KpeAXH8QE78B9RFd1yKrpfhK9gDQB8ImFN1+o
	Dt4R4HiUqVpRdRlTxF6LO5yusYD5I36FG4WQM1dctu4/xbCzUZKHt7DbLjL3ZRyU9SvR6E
	0YU2X20PAjettJYw0k3p/U1scgabWzPyR7wHwTrmfZeVl2fQiHc10Y8iE3KDbM8ocLO2pU
	cMqPLpeYom8rNtR/CJ/FpQFsBciAAcLD6fUm6PtW2Us1JCjhX7QjR6eJ2cER1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744788303;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VvfCcy3eif1YF5K8hb+jEM8YuXHXksLikwHcc5iatnM=;
	b=BJXvjtr8kqhqHSciL1a//5s+MqJyDs80sB0OyTL8XenHVw5DiwwwSVO/BT1VKPbWbTnps0
	2yLr84VfGzI1NcBg==
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
Message-ID: <174478829848.31282.16733995724256591570.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e71b6094c20f5dc9c43dc89af8a569ffa511d676
Gitweb:        https://git.kernel.org/tip/e71b6094c20f5dc9c43dc89af8a569ffa511d676
Author:        Mike Rapoport (Microsoft) <rppt@kernel.org>
AuthorDate:    Sun, 13 Apr 2025 11:08:58 +03:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 16 Apr 2025 09:16:02 +02:00

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
 arch/x86/kernel/e820.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9d8dd8d..de62388 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1299,6 +1299,13 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+	/*
+	 * Discard memory above 4GB because 32-bit systems are limited to 4GB
+	 * of memory even with HIGHMEM.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32))
+		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 

