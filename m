Return-Path: <kvm+bounces-45853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 105A5AAFB20
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C7EE4C14EB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB1D22B5A5;
	Thu,  8 May 2025 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AXuN5SIN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DCF7F477;
	Thu,  8 May 2025 13:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710366; cv=none; b=dC9+P4CL1W9XF6cCdagnz2v/KxvpO8BslfxONUIOb90c7GzA5od/5wPDrT+ZKwr/HUGvIfgtKVbunCAkMmb4Z8nnLs6MP3eG/KV0s+Jz7xw1xefeQGYCT+x9Zq9P1aVRoQMaxboY4pUJNxbsrXUdLwjv23rnF4qbSZg2s/9ID50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710366; c=relaxed/simple;
	bh=mwlJfN+Lfy/+tFxLo5GorpTpyl8vbUUM9H3jpxrTN14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOiF7+feuMopEsOGODtKRmotD3GLOeGKCZmGcdDy8dTgS7aPR0Gg5XZ1m+nUjTbD5Tq4BPkwmDMOuuClhqo+QhpmNE/3uN+IBPHjgGGz9a/u1Ej5IHU7SmZRykdyE8xyLWP6CqkyKYXyWBn/twXJQqabo21UD8k2pm9+bruMgDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AXuN5SIN; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746710365; x=1778246365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=mwlJfN+Lfy/+tFxLo5GorpTpyl8vbUUM9H3jpxrTN14=;
  b=AXuN5SINS40pRlK6Dp5IKVHo5pLWNYCa9+SuiJLtGImp8sj2EeDLmWpZ
   NPsrasuOcNT4ZbXBGJHqBaHz7qCdBkcqaQWqkmKc1EbJaCScEAVfNnFT/
   PlT80vTo1fmPkjl91ROcFfjDOrh021D9Y9+BXdZAgj+6PYbQpVh18swrm
   C6jGXF54o8Y12PHtEFtek2xNYupRLaPFfITVXEtfaaD6hlZdVbrh3kq7F
   +B3r9PnS7EYQUJFrBH+vpfin91r1csCioZitsdEM+oONpHBgH9CKHZoJP
   rAHg+7ZP0vDoIorQq8SyxYvVUfbYDyYKSoI8KsMpJ+s0obug0kJkTSeWp
   w==;
X-CSE-ConnectionGUID: zDp9Tnl5TAqnwbzYZOKf3g==
X-CSE-MsgGUID: rLHayGXPRUevcArohXX9pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="51153317"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="51153317"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:19:24 -0700
X-CSE-ConnectionGUID: wQANjt/cTd2bmbymrY9p6g==
X-CSE-MsgGUID: Vqk59ioaSj2Qx1QsXXsqzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="167229229"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa002.jf.intel.com with ESMTP; 08 May 2025 06:19:21 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 22B551D7; Thu, 08 May 2025 16:19:19 +0300 (EEST)
Date: Thu, 8 May 2025 16:19:19 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <o74datlk3nmbc6ihxisggvxzf6r25ebnh4wt5ureud4befy7nl@l3m74n6qksqx>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
 <aBqxBmHtpSipnULS@yzhao56-desk.sh.intel.com>
 <CAGtprH9GvBd0QLksKGan0V-RPsbJVPrsZ9PE=PPgHx11x4z1aA@mail.gmail.com>
 <aBrIkdnpmKujtVxf@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBrIkdnpmKujtVxf@yzhao56-desk.sh.intel.com>

On Wed, May 07, 2025 at 10:42:25AM +0800, Yan Zhao wrote:
> On Tue, May 06, 2025 at 06:15:40PM -0700, Vishal Annapurve wrote:
> > On Tue, May 6, 2025 at 6:04 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > On Mon, May 05, 2025 at 08:44:26PM +0800, Huang, Kai wrote:
> > > > On Fri, 2025-05-02 at 16:08 +0300, Kirill A. Shutemov wrote:
> > > > > +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > > > > +                   struct list_head *pamt_pages)
> > > > > +{
> > > > > +   u64 err;
> > > > > +
> > > > > +   hpa = ALIGN_DOWN(hpa, SZ_2M);
> > > > > +
> > > > > +   spin_lock(&pamt_lock);
> > > >
> > > > Just curious, Can the lock be per-2M-range?
> > > Me too.
> > > Could we introduce smaller locks each covering a 2M range?
> > >
> > > And could we deposit 2 pamt pages per-2M hpa range no matter if it's finally
> > > mapped as a huge page or not?
> > >
> > 
> > Are you suggesting to keep 2 PAMT pages allocated for each private 2M
> > page even if it's mapped as a hugepage? It will lead to wastage of
> > memory of 4 MB per 1GB of guest memory range. For large VM sizes that
> > will amount to high values.
> Ok. I'm thinking of the possibility to aligning the time of PAMT page allocation
> to that of physical page allocation.

No. That's mostly wasted memory. We need to aim to allocate memory only as
needed. With huge pages wast majority of such allocations will never be
needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

