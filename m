Return-Path: <kvm+bounces-50021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3AC8AE127F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 06:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E7D4189F1F8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AEF1F37C5;
	Fri, 20 Jun 2025 04:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Keo9qEQ5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655421AD3E0;
	Fri, 20 Jun 2025 04:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750393759; cv=none; b=a5Jf1BGzPxnQdwjHXoYNqcRzVNu/a9A+9U9U6DSD94KF8ErCEHkT/a2q2fmplJyB5tRD91ougqvpFLrwzeLTZeFExNDySKiN2M+4pL1vCggppZAKxDFNDwpDJR+mTGltWTrC1RoyZ7GFTkkT6YvU9br/nI8syuhV8BFEt1WnaDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750393759; c=relaxed/simple;
	bh=It+X+LhsWdDOwjdBav4EX8XJ1EMBhJqb7BxwKfvsvlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXh9sp/ou7DD8mF+kZClT9dBSCTwACmu0e55/cH99OteSVwl+zz5l9XQweu4j6qYpB0R7VKXJBQnDIXeYltsET4nHNc1tgwbOuh3D4EfeIQcApZ7Mc2b8lV1hyPVSHpJpV+V60IG2HCfrV4gTI1oEeeIayLyOU7iJMw4Lv/KAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Keo9qEQ5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750393758; x=1781929758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=It+X+LhsWdDOwjdBav4EX8XJ1EMBhJqb7BxwKfvsvlY=;
  b=Keo9qEQ5Me4M6lnMHAooEkniX/BuacjOypwTVSfNkzPiFvCa1083Vqb0
   3dRO/zfUC/QjMx2Jq5Avt9YqUxwyBCPQ0iO9diLkgp9UQsBPaBJ2NUCJK
   PmUV5FnBaV/4yxgSu+Q5QLUBUohxn5bL8vkSDsb7fDvUfTS8xO5216cCV
   G6yRpcojuR36yJF/JmTj/lU+20fZ4h1We0ASXtYhapz8SvqxeDMvbsQfV
   +AKVFXGO+e712zu8kKOCf50wA7vxAa+QuvuxTcgLEzeRPG1kApnFM49po
   5PV/5kSuWZTs20SEMKvoRmZ6pGoQmxjPgBS+RNiMY0+FbVYQTa4yd0SRT
   g==;
X-CSE-ConnectionGUID: VrPHoj8XTiywjV5ZPPc0QQ==
X-CSE-MsgGUID: kjC7wdiLTnmWbK1EeA2rFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="40257705"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="40257705"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 21:29:17 -0700
X-CSE-ConnectionGUID: rWOJemhGSAKbmpWp/SKpxg==
X-CSE-MsgGUID: 6a20+jVmRau5+Pgdg0r32w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="154817573"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 19 Jun 2025 21:29:11 -0700
Date: Fri, 20 Jun 2025 12:21:49 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	dan.j.williams@intel.com, aik@amd.com, linux-coco@lists.linux.dev,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, linux-kernel@vger.kernel.org, lukas@wunner.de,
	yan.y.zhao@intel.com, daniel.vetter@ffwll.ch, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com, linux-pci@vger.kernel.org, zhiw@nvidia.com,
	simona.vetter@ffwll.ch, shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 00/30] Host side (KVM/VFIO/IOMMUFD) support for TDISP
 using TSM
Message-ID: <aFTh3YASDNtyAc+k@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250602133727.GD233377@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602133727.GD233377@nvidia.com>

On Mon, Jun 02, 2025 at 10:37:27AM -0300, Jason Gunthorpe wrote:
> On Thu, May 29, 2025 at 01:34:43PM +0800, Xu Yilun wrote:
> 
> > This series has 3 sections:
> 
> I really think this is too big to try to progress, even in RFC
> form.

Sorry, I missed this message...

Yeah, I just try to give a overview of what components we need, what the
expect flow would be like for the first time. Also vendors need as much
components as possible to enable their own HW and verify this flow works.

We could split into small topics then.

>  
> > Patch 1 - 11 deal with the private MMIO mapping in KVM MMU via DMABUF.
> > Leverage Jason & Vivek's latest VFIO dmabuf series [3], see Patch 2 - 4.
> > The concern for get_pfn() kAPI [4] is not addressed so are marked as
> > HACK, will investigate later.
> 
> I would probably split this out entirely into its own topic. It
> doesn't seem directly related to TSM as KVM can use DMABUF for good
> reasons independently .

Yes, since I'm not work on improving this for now, I'll not include this
part next time. Will start independent thread if there is update.

> 
> > Patch 12 - 22 is about TSM Bind/Unbind/Guest request management in VFIO
> > & IOMMUFD. Picks some of Shameer's patch in [5], see Patch 12 & 14.
> 
> This is some reasonable topic on its own after Dan's series

OK, I'll just focus on this for next version.

>  
> > Patch 23 - 30 is a solution to meet the TDX specific sequence
> > enforcement on various device Unbind cases, including converting device
> > back to shared, hot unplug, TD destroy. Start with a tdx_tsm driver
> > prototype and finally implement the Unbind enforcement inside the
> > driver. To be honest it is still awkward to me, but I need help.
> 
> Then you have a series or two to implement TDX using the infrastructure.

Yeah, this should happen after "IOMMUFD for trusted".

Thanks,
Yilun

> 
> Jason

