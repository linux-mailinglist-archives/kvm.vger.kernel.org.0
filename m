Return-Path: <kvm+bounces-18007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D51DF8CCA05
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 02:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 769671F2270B
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5726FEEB7;
	Thu, 23 May 2024 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/iPEnmF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507D517FF;
	Thu, 23 May 2024 00:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716422463; cv=none; b=SksrW7BtlElgk26KdMcEMI+UVpSedV+4i7zNMJugvmo3GSpBFA0cn4JWU3lZSB+2yBiKvlPvA9PlJtCObRBrenn5CUqrbiKJGlqu+Q2IBchPzgy0kgZSzxRz1U2FwlclbGt+mJ34Dg9mxVRctX4iUuJfPTn5eK46nQPbl/7kQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716422463; c=relaxed/simple;
	bh=BZ+7rdCk+IntnuBSK4LDC88qXx4JwQPsKs5wSrREZhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2PFS8+09EPer50+Q5mSsLwq5oxtX8xHD3vb6ulm/JJzQTGmW8p5DK7tayUgUlJS8HOwR3wdouP0WfhY8XrAx64opiyvKGR/BnlaLBITO2hKfa5wUmDBpEzGoWSN80wCFdhcCxT5bGIs7OAqfU/bOElNicm/pw6qTBpxMyfXYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/iPEnmF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716422461; x=1747958461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BZ+7rdCk+IntnuBSK4LDC88qXx4JwQPsKs5wSrREZhM=;
  b=R/iPEnmFavdV6xeDF3WC3xqxSOm9mZqGV7918sIl0zHos0ClxtRY+XcU
   6L5xOEIM0XLtZNKOAb9vMzYI3Js5Tqz3U4nqMkBYTveWJxP5L+1jqnVDr
   QwyRLcVj3fo3Tt8hmx1aJNtUmLz/F6bORmT8UuFNbI40cBsIQvX4cC0sY
   FuZcrXeHJxH6hpAf0Ieu/TAPB8+TelO6pGg7s7q/Al+SvwCEYVeT+5b9s
   HpLi5dvhtUy5ZK4nsnxvpeh4SaO0ZmdWCtAKSZzWfQMVZEQqVrmtDAA/Q
   siv75hN1uLZ5CyBp6KxsTmZuHeH053JOjCrcnugAkmvA3Ojf0cmm5ANe7
   A==;
X-CSE-ConnectionGUID: g4yuMW90Qf21ryp5IKk36Q==
X-CSE-MsgGUID: Whfb7xkKR5KcVzAiI+YKgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="24119363"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="24119363"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 17:01:00 -0700
X-CSE-ConnectionGUID: SofhWmZ1QcKnKRKkbNhunA==
X-CSE-MsgGUID: 0s3Cl7JQQ9+C2kwjCpjErw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33363914"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 17:01:00 -0700
Date: Wed, 22 May 2024 17:01:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240523000100.GE212599@ls.amr.corp.intel.com>
References: <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
 <20240520233227.GA29916@ls.amr.corp.intel.com>
 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
 <20240521161520.GB212599@ls.amr.corp.intel.com>
 <20240522223413.GC212599@ls.amr.corp.intel.com>
 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
 <20240522234754.GD212599@ls.amr.corp.intel.com>
 <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>

On Wed, May 22, 2024 at 11:50:58PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-05-22 at 16:47 -0700, Isaku Yamahata wrote:
> > > How about we leave option 1 as a separate patch and note it is not
> > > functionally
> > > required? Then we can shed it if needed. At the least it can serve as a
> > > conversation piece in the meantime.
> > 
> > Ok. We understand the situation correctly. I think it's okay to do nothing for
> > now with some notes somewhere as record because it doesn't affect much for
> > usual
> > case.
> 
> I meant we include your proposed option 1 as a separate patch in the next
> series. I'm writing am currently writing a log for the iterator changes, and
> I'll note it as an issue. And then we include this later in the same series. No?

Ok, Let's include the patch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

