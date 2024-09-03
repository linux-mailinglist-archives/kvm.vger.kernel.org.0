Return-Path: <kvm+bounces-25703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A56F4969339
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DEE21F21CE0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 05:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F56D1CE71A;
	Tue,  3 Sep 2024 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+GP7t8e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C194CA32;
	Tue,  3 Sep 2024 05:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725341680; cv=none; b=Y4ejy2MvtKE4RoiuuuwubJy2IyB+uahdMV7TGvU2BHYGCm5WGUWOkWHEQic3YWq/CM6VZyWDHI9jzM9a6jXQz/qGeOU0OgdUNCcdpZWMcqts8jboBlY/0ILM/9sBWWgSXrno7iwIuXWpbCBoYb2Ii5sEKlVxrWe9/IwZwoBF704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725341680; c=relaxed/simple;
	bh=c8KcBxPELnVU1lz0D5LCPWKXq/fZGhu7ld+hoWo1ZXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yn5S9oMyM/XIEHEPlYHb2u2uKQka2jnLyAxumBC0MHccmlsTsL/UnxwlRpTsEjhvMPELEmcMn5ZvqIj/dxb8Yvef1x82dddr0EWWmD5Xhz9DHeWhAMCA3yl3u4/Djp6tNzUcNFSKsUFhxo0sj29sC4Sa7ikVHD4oROPzEjBkLB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+GP7t8e; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725341679; x=1756877679;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=c8KcBxPELnVU1lz0D5LCPWKXq/fZGhu7ld+hoWo1ZXo=;
  b=b+GP7t8eBHUOSIXkZt3gwLTAki3zP3q2MsGw2wfBEh/64TdoODX/06FE
   iFcbNha76+oJscqu//x1EeCrK5hn2QBnhnA6RgOg5l8ifCu0/+PcKGuz5
   rxl1xbCrwyWVHVf0XlvmXyDPAxEXcLPVpcIeF2IPgPxL8Hz7PgGsgqj7U
   FqEX6aqezBTMOZ25W1QW1GYxvZ5NzGlwrcP6339+S7KqPFe1H4SX8gfGo
   oQOiYFfF2UdHK5iiJgE37yLldQeam/mrRISOjSL9bY8e54T+9oqW/oajp
   ZWPq/R0Aqgnv7FP9FiI9kUJ0p9j7XokxQ2YmfdJZkpBKjOJHGHS7k+VzR
   g==;
X-CSE-ConnectionGUID: JPPahUtFSpeyK3KHr2N8zg==
X-CSE-MsgGUID: lsfrBdK+SPqtnbFRT0EwcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="34487650"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="34487650"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:34:35 -0700
X-CSE-ConnectionGUID: apwivu79Tkq5kOy45tn23w==
X-CSE-MsgGUID: RErpYkIaTYWpzimcLkBq3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="69648032"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.115])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:34:31 -0700
Date: Tue, 3 Sep 2024 08:34:24 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <Ztaf4PbPNxeMIg7J@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <bb67e7315b443ad2f1cf0b0687c3412b9224122b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb67e7315b443ad2f1cf0b0687c3412b9224122b.camel@intel.com>

On Wed, Aug 28, 2024 at 02:34:21PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2024-08-12 at 15:48 -0700, Rick Edgecombe wrote:
> > +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> > +{
> > +       return tdx->td_vcpu_created;
> > +}
> 
> This and is_td_finalized() seem like unneeded helpers. The field name is clear
> enough.

I'll do a patch for this.

> >  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> >  {
> >         return kvm_tdx->tdr_pa;
> 
> Not this one though, the helper makes the caller code clearer.

Yes this makes things more readable.

Regards,

Tony

