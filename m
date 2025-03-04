Return-Path: <kvm+bounces-40010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CB7A4D922
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12310177ED6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30261FDA7C;
	Tue,  4 Mar 2025 09:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhRpietm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6836B1FCF5F;
	Tue,  4 Mar 2025 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741081570; cv=none; b=drQWUSVHcydvoxB5phNSVvIeMuwHY4CTE4z3vt22mAh1BQ/mqUlZHkOR2+YiOBaO0Z/d4MYY/aG9PH8JYrztPrzLqTQMNx45ZNvdRbT5NtCmYu6H+faILoWQl3Tz4CoIXUEUcql7CCg+MiFpV7oSJyOVIsV7SiOoUbHXMkTttnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741081570; c=relaxed/simple;
	bh=INrPSVavl8zMkrHNZpRUzth30ZLyDccF9J8o2rj2eFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+Kpl8vi35BA2Hs/oApTEnhYqwe2nO5OCP+NmtTHOO6me0vK0CD9gVdF5dXNKiaKSIdO4uvClSZQaetbUpWFghUJoqvO15TkrghDdjSUy+vxrfnPCZMhCxzW7sESj61anfmJEGCUhxZnrKbv4AlF86+OFjOsJC29IJKiLP/tQTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhRpietm; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741081569; x=1772617569;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=INrPSVavl8zMkrHNZpRUzth30ZLyDccF9J8o2rj2eFs=;
  b=lhRpietmD6SrYc8DAQXEpLK7Z2dWhTcId/JM/cxaeRRuyIZpN4Da7KwD
   d+iUtXv3jikUR7deHtJXvQgsUM6dQ1rP8lr4N8s7B4DlsQFBDjpQdcKEG
   yYTBFDFSAJIehjAP3nhocE7ue3ZmyIwcVZs8pCMQnVaq6HQ/1Re5mJ6zO
   2qdrPkCxbXlT0wjpA8t8M1dvKxRxI2kBp7tjS1wwinx+wVB5OsqWYP0Vs
   /XVJTwG/G4eSlaF/GJ39+A1I2I5qiBlUOf9143GUAdk1FmD+DbtsZbtgd
   em78s9Mmwll2FVY2g7DpBgAGNrahz2inf3fiZitgBEjBdkTM1sb0Fs9v3
   A==;
X-CSE-ConnectionGUID: g422eFSVSQ2n4BosbOKQ0A==
X-CSE-MsgGUID: rCiT7oxxRfKCsUbBaxdRwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52972824"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52972824"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:45:52 -0800
X-CSE-ConnectionGUID: Z8M3669jSW2Bst8ygeNLFA==
X-CSE-MsgGUID: snKJwRccREShHF9WnwaFmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118125869"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa006.fm.intel.com with ESMTP; 04 Mar 2025 01:45:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id B26B418F; Tue, 04 Mar 2025 11:45:47 +0200 (EET)
Date: Tue, 4 Mar 2025 11:45:47 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, 
	hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, 
	fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd()
 pages
Message-ID: <nfil6ngejfz2ehruzbguin35hnbsidr5rxywruhmpbarpiyvlp@7yepe2euriff>
References: <20250303171013.3548775-1-tabba@google.com>
 <20250303171013.3548775-4-tabba@google.com>
 <dedrbmbqyvmsjywilcjvu4lt5a3vess3l4p6ygum62gfpmnyce@cgtpjwf4krfw>
 <CA+EHjTygT1eqQgg59NzUK3uonikKrgi8qDhojPVnONH3qS33mQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTygT1eqQgg59NzUK3uonikKrgi8qDhojPVnONH3qS33mQ@mail.gmail.com>

On Tue, Mar 04, 2025 at 09:27:06AM +0000, Fuad Tabba wrote:
> Hi Kirill,
> 
> On Tue, 4 Mar 2025 at 08:58, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > On Mon, Mar 03, 2025 at 05:10:07PM +0000, Fuad Tabba wrote:
> > > Add support for mmap() and fault() for guest_memfd backed memory
> > > in the host for VMs that support in-place conversion between
> > > shared and private. To that end, this patch adds the ability to
> > > check whether the VM type supports in-place conversion, and only
> > > allows mapping its memory if that's the case.
> > >
> > > Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> > > indicates that the VM supports shared memory in guest_memfd, or
> > > that the host can create VMs that support shared memory.
> > > Supporting shared memory implies that memory can be mapped when
> > > shared with the host.
> > >
> > > This is controlled by the KVM_GMEM_SHARED_MEM configuration
> > > option.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  include/linux/kvm_host.h |  11 ++++
> > >  include/uapi/linux/kvm.h |   1 +
> > >  virt/kvm/guest_memfd.c   | 105 +++++++++++++++++++++++++++++++++++++++
> > >  virt/kvm/kvm_main.c      |   4 ++
> > >  4 files changed, 121 insertions(+)
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 7788e3625f6d..2d025b8ee20e 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> > >  }
> > >  #endif
> > >
> > > +/*
> > > + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> > > + * private memory is enabled and it supports in-place shared/private conversion.
> > > + */
> > > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> >
> > Hm. Do we expect any caller for !CONFIG_KVM_PRIVATE_MEM?

I think you missed this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

