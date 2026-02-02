Return-Path: <kvm+bounces-69842-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPtSOzeegGl2/wIAu9opvQ
	(envelope-from <kvm+bounces-69842-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:53:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A022CC834
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 337223051281
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 12:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1411B4223;
	Mon,  2 Feb 2026 12:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0Wen35h"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E5915C158;
	Mon,  2 Feb 2026 12:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770036657; cv=none; b=rrBvKYuw0F9OwqYwVZ7abLcwjUQWx5AQBtzirdrx/2SdJd0m7q6z//9NQd8tlF/CEZJgIrPyhdg6H2eeHhqQhG9F4/YnWRZ9yrtB9QwzaLb+PGnyFsPpxHw0XolQzSFtSuH71k58FzB9WL7Wp8U81F/0gGbdCS1r9yDA2PqcpzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770036657; c=relaxed/simple;
	bh=SuKaTGgYRusTGMRpWzebQr0lVTgLiTHw3vc8hc0s3ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwnKH62rQo/jlq0BJ1JUV6/tK1KLLT4vpmCourJFWl5N6SBfLyRHmGwTKDUqgw5iYvehxizs3jZRAi/MPnlw+agd9TSq/dS80Q0Rw59bSojDNpKdYhNJJzsDuE2pMtGnVo1dLIDjBrzQjPxUPkDB5C2QxSk2UQs4Lfo4KZJSj58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B0Wen35h; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=49YW4SEmeqfmsCTg6PnrOrf26Ub+dtDy1bNpRRDJ8LI=; b=B0Wen35hmxwwSLZeLWd4c5nyBO
	QO6xYjhwA6gvmJLUCOQdqub19x/sF1d3H5kKuVI7PvmRhOtrJvNkudJ+jWUitdl/T3Ma9XjkKogBH
	+Tf+OnMbnKv3cWrvqGB7FHNiU3Waz5nzMzcL8o3c2MEn/9KNfgb0YsNybHfJUTGKaCRLZdFqNkhlw
	Zx3FQBG6Bt/i+znJEqwdmBH2Tej71AIZjPlvCY9DcJhxSu91JioT1qPIBPxDtH1KqyOfmC2ss7kyH
	x/7QfdE0ioHIQT4LP2rvaFfSlo9YPrVTUpYhcMq4mnkxf84mjFUS5pTz7T9bPjVs1ZzcjcFj3duBO
	nNPoaGsg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmtNv-0000000GVCQ-1VFp;
	Mon, 02 Feb 2026 12:50:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E633D3008E2; Mon, 02 Feb 2026 13:50:30 +0100 (CET)
Date: Mon, 2 Feb 2026 13:50:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com,
	bp@alien8.de, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@kernel.org, dev.jain@arm.com, hpa@zytor.com, hughd@google.com,
	ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
	kvm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
	npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
	ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
	tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
	x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Message-ID: <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260202110329.74397-1-lance.yang@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69842-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,kernel.org,arndb.de,linux.alibaba.com,alien8.de,intel.com,linux.intel.com,arm.com,zytor.com,google.com,gmail.com,suse.com,vger.kernel.org,kvack.org,redhat.com,surriel.com,linutronix.de,lists.linux.dev,nvidia.com];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: 8A022CC834
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 07:00:16PM +0800, Lance Yang wrote:
> 
> On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
> > On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
> > > When freeing or unsharing page tables we send an IPI to synchronize with
> > > concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
> > > that IPI to all CPUs, which is costly on large machines and hurts RT
> > > workloads[1].
> > > 
> > > This series makes those IPIs targeted. We track which CPUs are currently
> > > doing a lockless page table walk for a given mm (per-CPU
> > > active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
> > > GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
> > > tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
> > > the free/unshare paths.
> > 
> > I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
> > __tlb_remove_table_one() actually uses RCU.
> > 
> > So why are you making things more expensive for no reason?
> 
> You're right that when CONFIG_PT_RECLAIM is set, __tlb_remove_table_one()
> uses call_rcu() and we never call any sync there — this series doesn't
> touch that path.
> 
> In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
> that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
> we're not adding any new sync; we're replacing the existing broadcast IPI
> (tlb_remove_table_sync_one()) with targeted IPIs (tlb_remove_table_sync_mm()).

Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
unconditionally and not add overhead?

