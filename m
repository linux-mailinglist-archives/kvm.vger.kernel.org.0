Return-Path: <kvm+bounces-35352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6F3A1018A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F17F41887AEF
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 07:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F161824633B;
	Tue, 14 Jan 2025 07:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dREu4k2l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461B51C3C1D;
	Tue, 14 Jan 2025 07:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736841042; cv=none; b=JKCc42WidL0K5Si4b/ASQem+pPnANKTK9CRuO9OkVR2B5hY6nvHs67e9wc4TO+pzc26BoBOC/XhoReqbqwDIi+Ur1Q3Jge8c5j6fAlwWG7lnrGIlwRxGWc2Ug7zDzoY24yEh9/x1HWgVrTcyMXSZhdSgDDwXBzgG9zdetkLhqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736841042; c=relaxed/simple;
	bh=1hohgCNV+pg4UmM7hYIl5tW4VQGcoSkgrBMVyWMtzPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkfJ9VkAek9FgOYdUMKZ50+4FgWCEli3S/1+wKGYixCa+x1FcNV3fF2MCid3nO/+DROizJjhFGHu+8F14dEsGywAIBd92jGZZurVOdcXsvCojbcO9ZVRKnZrUajvhm8rW+WDWxuYQalY0ZaWg9Y5SUAq8wZsRa9Cin5kbRVgbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dREu4k2l; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736841040; x=1768377040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1hohgCNV+pg4UmM7hYIl5tW4VQGcoSkgrBMVyWMtzPg=;
  b=dREu4k2luEm97t5bxz5K9RzJJy113z44Z1pD4vGf1LG29TQL9W5auuvO
   VX9LX3eV7ppLaWNuQqeJJJF91xyDEAEZMgLdnErR9c/RwNu/CbCt4bwXJ
   3Hrabf4+DjakGESsmulMkdCiSq+Fkg88q0bNQFShsvH3nNQ+9jVXZ4vqF
   n1XSczWT24q1iEG382kq3vIIt4DezJnDqQ5suczniDHV7kX9137CHmeCw
   9ZSn2P0WjwnFUKRWb41tpGJc6ayHdBxfAAgM3HQjTMREjYPAOlHd9JHPa
   +H55K+A0JEf782Yub2xesGL0g/v4VD19/ANCtY22UJtG7JBGkK40W2775
   w==;
X-CSE-ConnectionGUID: EVWdQWj9RUCbU1MOKQHf/A==
X-CSE-MsgGUID: ASQzUhyZSBed4hq+zWoGzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="54542227"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="54542227"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 23:50:39 -0800
X-CSE-ConnectionGUID: zByF74oJRIC0O1CQvfZN/g==
X-CSE-MsgGUID: 8cT5m3LeSZm1wZNi3phLBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="142005268"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa001.jf.intel.com with ESMTP; 13 Jan 2025 23:50:35 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 78FD439C; Tue, 14 Jan 2025 09:50:33 +0200 (EET)
Date: Tue, 14 Jan 2025 09:50:33 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, rientjes@google.com, 
	szy0127@sjtu.edu.cn
Subject: Re: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
Message-ID: <brebuxyjirsfc257fpq4qxlowveolrabzetg2i3cj3ee6yzci3@j7zlc676gf7n>
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250109225533.1841097-3-kevinloughlin@google.com>
 <szkkdk35keb6ibdy2d2p2q6qiykeo2aoj2iqpzx3h6k2wzs2ob@iuidkwpeoxua>
 <CAGdbjm+i52GNLRXVduzqe2h-bmNeJ_ES97p7LhJPJw+8FMuc-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGdbjm+i52GNLRXVduzqe2h-bmNeJ_ES97p7LhJPJw+8FMuc-A@mail.gmail.com>

On Mon, Jan 13, 2025 at 10:47:57AM -0800, Kevin Loughlin wrote:
> On Fri, Jan 10, 2025 at 12:23 AM Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > On Thu, Jan 09, 2025 at 10:55:33PM +0000, Kevin Loughlin wrote:
> > > @@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> > >       }
> > >  }
> > >
> > > +static void sev_wb_on_all_cpus(void)
> > > +{
> > > +     if (boot_cpu_has(X86_FEATURE_WBNOINVD))
> > > +             wbnoinvd_on_all_cpus();
> > > +     else
> > > +             wbinvd_on_all_cpus();
> >
> > I think the X86_FEATURE_WBNOINVD check should be inside wbnoinvd().
> > wbnoinvd() should fallback to WBINVD if the instruction is not supported
> > rather than trigger #UD.
> 
> I debated this as well and am open to doing it that way. One argument
> against silently falling back to WBINVD within wbnoinvd() (in general,
> not referring to this specific case) is that frequent WBINVD can cause
> soft lockups, whereas WBNOINVD is much less likely to do so. As such,
> there are potentially use cases where falling back to WBINVD would be
> undesirable (and would potentially be non-obvious behavior to the
> programmer calling wbnoinvd()), hence why I left the decision outside
> wbnoinvd().
> 
> That said, open to either way, especially since that "potential" use
> case doesn't apply here; just lemme know if you still have a strong
> preference for doing the check within wbnoinvd().

An alternative would be to fail wbnoinvd() with an error code and
possibly a WARN(). Crash on #UD is not helpful.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

