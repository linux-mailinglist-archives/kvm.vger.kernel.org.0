Return-Path: <kvm+bounces-11092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C44872C86
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4609B1F21596
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CED7D29E;
	Wed,  6 Mar 2024 02:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="n4i39rgQ"
X-Original-To: kvm@vger.kernel.org
Received: from butterfly.pear.relay.mailchannels.net (butterfly.pear.relay.mailchannels.net [23.83.216.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633717FE
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 02:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.216.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709690783; cv=pass; b=G55hwT8WnALtzcvGpc/7uV6Vij85COssPIQVHiBWNa0yxMdC4DNhNr0Qvg4LYdEbmh5R3/lmWgDucdpnyIbFbyaJMGLZmhaQISTDlxvHWRzy6dVd3/AL382IK51sA+ZSpo3z31sSQpVSpNyvB5yu2lTzDX8xcv4qW2KEVFHB0gY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709690783; c=relaxed/simple;
	bh=on8gZm2QdDyARPaE+/P1kLM0jMpWnGyLwBsuWanXgp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdzsGKpngG/hgMrUmGkxgdv5vM4FDHGWmvWIaPqCQ3TvBu+VOvnT6TGezTLeOTPPR12pxNEfyp7MBS1j0i8rxNWXwehx+wCo/33QpDfN/VLZuMNMuOBp88jiJKFjWg2xbVXIXpk207EA5AvQInDhCUlDRdjHgPAWAtGq+tzVik8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=n4i39rgQ; arc=pass smtp.client-ip=23.83.216.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8EF681028F7
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:49:58 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2B94F101673
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:49:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1709686198; a=rsa-sha256;
	cv=none;
	b=c4VQxfN/N6u7wF2ZNRQwn3x0duHV7XzWypGRxaz0p9iIi1BO17IOMmmyjOBL1ABnBssp9f
	C8gevBImnJQpKWnAAK35j+o4EYTncZxDeFZcHjVtbfl1q/Ed2DsJyg+kB77UZT6xjIl048
	mDWz5A1z0azusWGF4plFutlfjxY+CK7aDJCSgM72EMqa1z8OJPjqHZQXZY6+aU+oESzk6w
	u1GWp8Vb5WT0JBcOIdoWVoW60N1pqbr56yOxGLvid/eTawfhE1XPLyi07m0fxRT3eBJv/J
	TA0pdlCBqzyEDjnrhviBb0s9O4qhl6WHuEFU82dEli10UMGQ1bZ1KRmVYbTE+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1709686198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zB/e4S9PL1mKLbb+4/xBriylBo1s1uvVH44wHxVwVlM=;
	b=dg8YqbBrMPFV6gmG2BRrlOdi9bBVcpnHPgkI/+GqufDvIrtPynELhvDQtAd1WeTE2MMr4N
	vnds7xUUuiOFxlCAPMnX7kwmAkh7ouhPj/o+ehsrqBvnrB5vopqJNigCIBScn8G6pede/T
	4yNrQnobBDUhY4LiqLH5+4zInnI92acgiiriNCIY5mrVsmchVck7Csmowoj3JyXgto1Ru7
	wzxLuJ4feeeJH8fOBLulO+NpjX6f8Za5aA1n3mpRUlhfGj7qU9a2YbA3lHelwe4nm4LFiS
	JrtJb0vf7xXXz8XHlnHkdITc5x5sFr0dt9C+yzUXN67Tqn1Ox9AVmXWwl+41GA==
ARC-Authentication-Results: i=1;
	rspamd-55b4bfd7cb-t6svs;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Good
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Squirrel-Relation: 223914876b412ded_1709686198445_3617887133
X-MC-Loop-Signature: 1709686198445:3134370656
X-MC-Ingress-Time: 1709686198445
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.112.142.242 (trex/6.9.2);
	Wed, 06 Mar 2024 00:49:58 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4TqDNj6mZfzJZ
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1709686198;
	bh=zB/e4S9PL1mKLbb+4/xBriylBo1s1uvVH44wHxVwVlM=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=n4i39rgQl6sE76YQvdLbztq5cVNDLVBxTfzkSGVKCWkzBZQ3dmCWEHr3sg9We8XA/
	 2dvc0swIb+8kY77cZYNORlhnPkxpJPDMVOAaUh700eqpRUmN93iNF69CZzqlocfETw
	 BAIWJw8Zrrw3Cc/3qlFoo/tLeKro73C7jGIHCNXxpLHLvxIK2XabV2dW4RMAn2+53P
	 Um0X1mlTPXGk7woNw4izFVkiEQnGjMnga62jwi4GTzKtgbrrqjH9Pza9c74nM91QQE
	 rou121DSeJWp8C3nm2FtRiqQwFy/6zMLZRrnWDd2Nu09u2ce3BgDbgCbdnvU1csJiU
	 s6yXiHC0VWEqg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0082
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Tue, 05 Mar 2024 16:49:49 -0800
Date: Tue, 5 Mar 2024 16:49:49 -0800
From: Krister Johansen <kjlx@templeofstupid.com>
To: stable@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: [PATCH 5.15.y v2 2/2] KVM: arm64: Limit stage2_apply_range() batch
 size to largest block
Message-ID: <373363c947131626f70c6337c5c0f197046db4fe.1709685364.git.kjlx@templeofstupid.com>
References: <cover.1709665227.git.kjlx@templeofstupid.com>
 <cover.1709685364.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1709685364.git.kjlx@templeofstupid.com>

From: Oliver Upton <oliver.upton@linux.dev>

commit 5994bc9e05c2f8811f233aa434e391cd2783f0f5 upstream.

Presently stage2_apply_range() works on a batch of memory addressed by a
stage 2 root table entry for the VM. Depending on the IPA limit of the
VM and PAGE_SIZE of the host, this could address a massive range of
memory. Some examples:

  4 level, 4K paging -> 512 GB batch size

  3 level, 64K paging -> 4TB batch size

Unsurprisingly, working on such a large range of memory can lead to soft
lockups. When running dirty_log_perf_test:

  ./dirty_log_perf_test -m -2 -s anonymous_thp -b 4G -v 48

  watchdog: BUG: soft lockup - CPU#0 stuck for 45s! [dirty_log_perf_:16703]
  Modules linked in: vfat fat cdc_ether usbnet mii xhci_pci xhci_hcd sha3_generic gq(O)
  CPU: 0 PID: 16703 Comm: dirty_log_perf_ Tainted: G           O       6.0.0-smp-DEV #1
  pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : dcache_clean_inval_poc+0x24/0x38
  lr : clean_dcache_guest_page+0x28/0x4c
  sp : ffff800021763990
  pmr_save: 000000e0
  x29: ffff800021763990 x28: 0000000000000005 x27: 0000000000000de0
  x26: 0000000000000001 x25: 00400830b13bc77f x24: ffffad4f91ead9c0
  x23: 0000000000000000 x22: ffff8000082ad9c8 x21: 0000fffafa7bc000
  x20: ffffad4f9066ce50 x19: 0000000000000003 x18: ffffad4f92402000
  x17: 000000000000011b x16: 000000000000011b x15: 0000000000000124
  x14: ffff07ff8301d280 x13: 0000000000000000 x12: 00000000ffffffff
  x11: 0000000000010001 x10: fffffc0000000000 x9 : ffffad4f9069e580
  x8 : 000000000000000c x7 : 0000000000000000 x6 : 000000000000003f
  x5 : ffff07ffa2076980 x4 : 0000000000000001 x3 : 000000000000003f
  x2 : 0000000000000040 x1 : ffff0830313bd000 x0 : ffff0830313bcc40
  Call trace:
   dcache_clean_inval_poc+0x24/0x38
   stage2_unmap_walker+0x138/0x1ec
   __kvm_pgtable_walk+0x130/0x1d4
   __kvm_pgtable_walk+0x170/0x1d4
   __kvm_pgtable_walk+0x170/0x1d4
   __kvm_pgtable_walk+0x170/0x1d4
   kvm_pgtable_stage2_unmap+0xc4/0xf8
   kvm_arch_flush_shadow_memslot+0xa4/0x10c
   kvm_set_memslot+0xb8/0x454
   __kvm_set_memory_region+0x194/0x244
   kvm_vm_ioctl_set_memory_region+0x58/0x7c
   kvm_vm_ioctl+0x49c/0x560
   __arm64_sys_ioctl+0x9c/0xd4
   invoke_syscall+0x4c/0x124
   el0_svc_common+0xc8/0x194
   do_el0_svc+0x38/0xc0
   el0_svc+0x2c/0xa4
   el0t_64_sync_handler+0x84/0xf0
   el0t_64_sync+0x1a0/0x1a4

Use the largest supported block mapping for the configured page size as
the batch granularity. In so doing the walker is guaranteed to visit a
leaf only once.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221007234151.461779-3-oliver.upton@linux.dev
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 arch/arm64/include/asm/stage2_pgtable.h | 20 --------------------
 arch/arm64/kvm/mmu.c                    |  9 ++++++++-
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index fe341a6578c3..c8dca8ae359c 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -10,13 +10,6 @@
 
 #include <linux/pgtable.h>
 
-/*
- * PGDIR_SHIFT determines the size a top-level page table entry can map
- * and depends on the number of levels in the page table. Compute the
- * PGDIR_SHIFT for a given number of levels.
- */
-#define pt_levels_pgdir_shift(lvls)	ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - (lvls))
-
 /*
  * The hardware supports concatenation of up to 16 tables at stage2 entry
  * level and we use the feature whenever possible, which means we resolve 4
@@ -30,11 +23,6 @@
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
 #define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
 
-/* stage2_pgdir_shift() is the size mapped by top-level stage2 entry for the VM */
-#define stage2_pgdir_shift(kvm)		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
-#define stage2_pgdir_size(kvm)		(1ULL << stage2_pgdir_shift(kvm))
-#define stage2_pgdir_mask(kvm)		~(stage2_pgdir_size(kvm) - 1)
-
 /*
  * kvm_mmmu_cache_min_pages() is the number of pages required to install
  * a stage-2 translation. We pre-allocate the entry level page table at
@@ -42,12 +30,4 @@
  */
 #define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
 
-static inline phys_addr_t
-stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
-{
-	phys_addr_t boundary = (addr + stage2_pgdir_size(kvm)) & stage2_pgdir_mask(kvm);
-
-	return (boundary - 1 < end - 1) ? boundary : end;
-}
-
 #endif	/* __ARM64_S2_PGTABLE_H_ */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 38a8095744a0..db667b4ad103 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,6 +31,13 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
+static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
+	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
+
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
 
 /*
  * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
@@ -52,7 +59,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 		if (!pgt)
 			return -EINVAL;
 
-		next = stage2_pgd_addr_end(kvm, addr, end);
+		next = stage2_range_addr_end(addr, end);
 		ret = fn(pgt, addr, next - addr);
 		if (ret)
 			break;
-- 
2.25.1


