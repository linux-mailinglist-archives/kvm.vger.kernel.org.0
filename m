Return-Path: <kvm+bounces-18004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8037E8CC9DD
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFA3E1C2124F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0CF14E2D2;
	Wed, 22 May 2024 23:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLf0WEeo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675DA14D432;
	Wed, 22 May 2024 23:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716421704; cv=none; b=dlHeQnKn64tkUmHWvGkveU/6nP+4pqNscHWN3+rUdDh43T/5R9Xg4S4dCcS7mhJH7WldrxpchJy/KOK5ZwvPxAvVA9rIClZ/C7CVcytbnvQ50FXwrT7ObF0Q1mkOTkQrYqeF37X5UjGgUasjMXD8bSc/qSZq8fpv/jDRwrQbx04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716421704; c=relaxed/simple;
	bh=VO7Jve0bQS85g1TWoblFqDzzncNS/p1+KZ7UIjz8km4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioe8+/y1VE386GsfbEQv/R1osXmghB5yR1xJ9lbrZpwKdee01nk22fFS4PkP0aIQvB6eGHeAQwTPsW2pyPNcdx6zcyhpYqnmQ5vGrs3JqkeUifMCy1Br1A0V6kQIC4M8mWeDn2ZVGiUA7daqphQL7bVPYygz/RrnnL9zFnD5nKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLf0WEeo; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716421704; x=1747957704;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VO7Jve0bQS85g1TWoblFqDzzncNS/p1+KZ7UIjz8km4=;
  b=YLf0WEeo7I1VQmDEnU3TsK8zUvXDZRsdMMAmcb9rvDU/lEDmJNARq/Ck
   BreyOCk4aZ76dg8enStidrRzwPuuKVSxfR+wNpYWNpEc+X9W27hcuQ0+3
   pgzWuFF6US5nziH65qY5B2cwL8DuhsZtMEbJq+MLZiFl/HHnrc9dIat4b
   skk6pLIUZj31WxBc5+MOJkCDfe96Ogzib8/IN4erdbY7+yIt1y+tZ6WQv
   OsPWFOJwdiuuJ2IACpNsEArSQjg9TXreuJig4V6CNu2Q4OMuB7hIhrAfx
   000exHmQmGiZLR2NHfiikLnVGxHKbpfHrDTsZAD4TIeoq+D3CeDdizMWO
   w==;
X-CSE-ConnectionGUID: LbHL2h33TGe0OIpLI6AUTg==
X-CSE-MsgGUID: DTGFihMZTfy3wwZwpDvdWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="38089111"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38089111"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:47:56 -0700
X-CSE-ConnectionGUID: s1E6ZHyYRUyhnG1OFjv9vQ==
X-CSE-MsgGUID: 8AhBhmKYSxCTNThY3GK9ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="70864568"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:47:55 -0700
Date: Wed, 22 May 2024 16:47:54 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240522234754.GD212599@ls.amr.corp.intel.com>
References: <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
 <20240520233227.GA29916@ls.amr.corp.intel.com>
 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
 <20240521161520.GB212599@ls.amr.corp.intel.com>
 <20240522223413.GC212599@ls.amr.corp.intel.com>
 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>

On Wed, May 22, 2024 at 11:09:54PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-05-22 at 15:34 -0700, Isaku Yamahata wrote:
> > option 1. Allow per-VM kvm_mmu_max_gfn()
> > Pro: Conceptually easy to understand and it's straightforward to disallow
> >      memslot creation > virtual maxphyaddr
> > Con: overkill for the corner case? The diff is attached.  This is only when
> > user
> >      space creates memlost > virtual maxphyaddr and the guest accesses GPA >
> >      virtual maxphyaddr)
> 
> It breaks the promise that gfn's don't have the share bit which is the pro for
> hiding the shared bit in the tdp mmu iterator.
> 
> > 
> > option 2. Keep kvm_mmu_max_gfn() and add ad hock address check.
> > Pro: Minimal change?
> >      Modify kvm_handel_noslot_fault() or kvm_faultin_pfn() to reject GPA >
> >      virtual maxphyaddr.
> > Con: Conceptually confusing with allowing operation on GFN > virtual
> > maxphyaddr.
> >      The change might be unnatural or ad-hoc because it allow to create
> > memslot
> >      with GPA > virtual maxphyaddr.
> 
> I can't find any actual functional problem to just ignoring it. Just some extra
> work to go over ranges that aren't covered by the root.
> 
> How about we leave option 1 as a separate patch and note it is not functionally
> required? Then we can shed it if needed. At the least it can serve as a
> conversation piece in the meantime.

Ok. We understand the situation correctly. I think it's okay to do nothing for
now with some notes somewhere as record because it doesn't affect much for usual
case.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

