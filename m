Return-Path: <kvm+bounces-63783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A73C725DA
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:45:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1F3AD4E5413
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520472E62DA;
	Thu, 20 Nov 2025 06:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aDznXJEQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1FF21B9FD;
	Thu, 20 Nov 2025 06:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621045; cv=none; b=Y9a7X/Aq5HqsgZJISzuvAgUimLD252TEzrXiYUetDea9W23e7A+hNfOAp+89QlzuUYTw0CWk+hnvHafdai+gsdX2OMIiVMWIVmVPkQhLrX0RSOkhy87HwUp/ToEmisNkmHYCqigJq2saVsR6f3FT/0q88MDh4dOj/xafP1px9/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621045; c=relaxed/simple;
	bh=/k95Ch2WZrUhShfgashJIMCWCIu5BoQ14eRPgopSWeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5xPhidpJr9K3O7RfplR5jIo+vzPaDlezDlfriPs0y4zfk/5HUCrpkkCNmb7lGRmboUvjU8b3qt6M7fOTWg+CdTfZ4dO0rcK5nZd2kcnfjBb4z83SXwytv6TDsDXEir4P3JoEMVKGS2kULc7TFWe8l/AtTiDfL0G5aGNAB3SkbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aDznXJEQ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763621044; x=1795157044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/k95Ch2WZrUhShfgashJIMCWCIu5BoQ14eRPgopSWeQ=;
  b=aDznXJEQLxN93ebGRl/uwTOaLb7CLQUIXrXfmRbcK4hxQsoLIJEraUFb
   Q4snnHJVKG7TG0fIP/arBPPXJEFekZFS/PodI4k3IB6xRH1pV4utigSEG
   Y8sN/F10yqrei+cYIt/awm5ME2ilNc+j8jjBBQRXudXtt7fyKQnAKdLCT
   32ULSiHIR/O/ZdiSt03VT1dsB5VBeyM/zhozo9YSPFAFiLB81iDb993Y8
   4TLQAo5gML3+6uxIamX+7BiroxetXqRkRbrGBSC7wMCl8vmxbX137yX4i
   nHxMKhQUhkGbab6Rn5lwmYCyHE+A9vJB10zepbtUAL6rMtp/j9ejdGnzP
   Q==;
X-CSE-ConnectionGUID: nh6dkX04TaKE+p9Z++1c7Q==
X-CSE-MsgGUID: 8jkT0fZaSBa27IK1rmZggQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65715054"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65715054"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:43:53 -0800
X-CSE-ConnectionGUID: dUwpGbNjSvS0KlgjEVNfHQ==
X-CSE-MsgGUID: fXH9vQb4RHa0u5j4sjp4Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="195756499"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 19 Nov 2025 22:43:49 -0800
Date: Thu, 20 Nov 2025 14:28:58 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: dan.j.williams@intel.com
Cc: Dave Hansen <dave.hansen@intel.com>, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org, chao.gao@intel.com, dave.jiang@intel.com,
	baolu.lu@linux.intel.com, yilun.xu@intel.com,
	zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for
 new TDX Module objects
Message-ID: <aR61KpJ6c2azfwAn@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <70056924-1702-4020-b805-014efb87afdd@intel.com>
 <691dee3f569dc_1aaf41001e@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <691dee3f569dc_1aaf41001e@dwillia2-mobl4.notmuch>

On Wed, Nov 19, 2025 at 08:20:15AM -0800, dan.j.williams@intel.com wrote:
> Dave Hansen wrote:
> > On 11/16/25 18:22, Xu Yilun wrote:
> > ...> +	struct tdx_page_array *array __free(kfree) = kzalloc(sizeof(*array),
> > > +							     GFP_KERNEL);
> > > +	if (!array)
> > > +		return NULL;
> > 
> > I just reworked this to use normal goto's. It looks a billion times
> > better. Please remove all these __free()'s unless you have specific
> > evidence that they make the code better.
> > 
> > Maybe I'm old fashioned, but I don't see anything wrong with:
> > 
> > static struct tdx_pglist *tdx_pglist_alloc(unsigned int nr_pages)
> > {
> >         struct tdx_page_array *array = NULL;
> >         struct page **pages = NULL;
> >         struct page *root = NULL;
> >         int ret;
> > 
> >         if (!nr_pages)
> >                 return NULL;
> > 
> >         array = kzalloc(sizeof(*array), GFP_KERNEL);
> >         if (!array)
> >                 goto out_free;
> > 
> >         root = kzalloc(PAGE_SIZE, GFP_KERNEL);
> >         if (!root)
> >                 goto out_free;
> 
> I think this s/alloc_page/kcalloc/ is the bulk of the improvement, that
> is a good change I missed.

s/alloc_page/kzalloc, is it?

Yes, I agree. I almost missed the change here.

