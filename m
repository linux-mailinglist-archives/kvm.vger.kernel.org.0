Return-Path: <kvm+bounces-69836-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yG3DCwCGgGnE8wIAu9opvQ
	(envelope-from <kvm+bounces-69836-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:09:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC857CB830
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B9453047013
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 11:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D85535EDB2;
	Mon,  2 Feb 2026 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VcHreQ2z"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FB635E53C
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770030267; cv=none; b=lWPlTsfO5CeDJQRkEDmifPcX2u79K5l2e6T8iFzumiu++ICNGfSfe9Kz4n6vjHS2KdxspGWJaztAf5T1tp8cAkyGgFGh1QHujWEuxe1BbpDRZcqH8/baVds0Kn0tijC4d/Z1/FKE/vwRJS/QTesAS/FVCtAJyZZsNboV/8c3k4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770030267; c=relaxed/simple;
	bh=nM8/mPmcpF2IB9y8k1rI6PzWyX/nU/v4hE+k12HL1pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AOji891NIX5o9pTd3NXFJA67ONLXsk+aC3jnsLPTUC+JKsOj1jCVAsP5YhrdTQDw45HY3j67l0moacn+6VKLPP+YrZShzVFa07udEs63E9D4iJ9QybyTU+fcGqbPpR4/YeFinADoguSfJyWrJRcfeDJYATby5wGNqSofQlFQ3io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VcHreQ2z; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770030262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZEap9olFo7mT2sNYk1w5rpD3JOe/VQuaiSKjgwHkTY=;
	b=VcHreQ2zTk7FVhSAZ6GgUVFwokNTeD4Qx5X8cU/BISIGZVGpdy7EuBWbXiewHlZJITBq1v
	h/0NPTey/RmvLR2J0f+PVlOVl0tKua0+75bhoCb7KXd8iwLBkGedJYaf/5skYt6MUHgfFl
	4MeXi+ZucQEe1Qgwzqawa5cry7k29lc=
From: Lance Yang <lance.yang@linux.dev>
To: peterz@infradead.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	arnd@arndb.de,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	boris.ostrovsky@oracle.com,
	bp@alien8.de,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	hpa@zytor.com,
	hughd@google.com,
	ioworker0@gmail.com,
	jannh@google.com,
	jgross@suse.com,
	kvm@vger.kernel.org,
	lance.yang@linux.dev,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	npache@redhat.com,
	npiggin@gmail.com,
	pbonzini@redhat.com,
	riel@surriel.com,
	ryan.roberts@arm.com,
	seanjc@google.com,
	shy828301@gmail.com,
	tglx@linutronix.de,
	virtualization@lists.linux.dev,
	will@kernel.org,
	x86@kernel.org,
	ypodemsk@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Date: Mon,  2 Feb 2026 19:00:16 +0800
Message-ID: <20260202110329.74397-1-lance.yang@linux.dev>
In-Reply-To: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,kernel.org,arndb.de,linux.alibaba.com,alien8.de,intel.com,linux.intel.com,arm.com,zytor.com,google.com,gmail.com,suse.com,vger.kernel.org,linux.dev,kvack.org,redhat.com,surriel.com,linutronix.de,lists.linux.dev,nvidia.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TAGGED_FROM(0.00)[bounces-69836-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[38]
X-Rspamd-Queue-Id: CC857CB830
X-Rspamd-Action: no action


On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
> > When freeing or unsharing page tables we send an IPI to synchronize with
> > concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
> > that IPI to all CPUs, which is costly on large machines and hurts RT
> > workloads[1].
> > 
> > This series makes those IPIs targeted. We track which CPUs are currently
> > doing a lockless page table walk for a given mm (per-CPU
> > active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
> > GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
> > tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
> > the free/unshare paths.
> 
> I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
> __tlb_remove_table_one() actually uses RCU.
> 
> So why are you making things more expensive for no reason?

You're right that when CONFIG_PT_RECLAIM is set, __tlb_remove_table_one()
uses call_rcu() and we never call any sync there — this series doesn't
touch that path.

In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
we're not adding any new sync; we're replacing the existing broadcast IPI
(tlb_remove_table_sync_one()) with targeted IPIs (tlb_remove_table_sync_mm()).

One thing I just realized: when CONFIG_MMU_GATHER_RCU_TABLE_FREE is not
set, the sync path isn't used at all (tlb_remove_table_sync_one() and
friends aren't even compiled), so we don't need the tracker in that config.

Thanks for raising this!
Lance

