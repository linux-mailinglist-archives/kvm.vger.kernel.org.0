Return-Path: <kvm+bounces-41183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B6AA647F3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87DE61893EF5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AF2228CBC;
	Mon, 17 Mar 2025 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZBCeFch"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797E229B17
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742204738; cv=none; b=W64IyvrT8HnZgcOzGzaAIGfLijCPIeKZwq84MH00ZLmTkuffS5Y75fTDiZ5iLHDZoAAoGyO9L/F8BK+XrJxd2iz0m0TDRSF1puss6OmvywpDaZYuJer6RnKgpQ624XiXIk+aDo8eX1jKrRyTN+B9+/l6MgbMN+bdmqOc4eevBIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742204738; c=relaxed/simple;
	bh=2L7KDp9FOHdilaL0CR+rsa4VNZkaVaclZPPZcERIo9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/QJVa7qkISRtlsdld6GnAfkv/I9TgeS9VURq5uqLlbiuGzTtTq+xVUlNVz2sHqE6990WPZ6WE3CEAr0gRbn5t3b2SzVcOwbm65h5wkXxjd6GX6vrnvYrCSpPrFa23i815HoUb3EqGbsm51CjHWZSOz1dFpvrznodzioRFw2wTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nZBCeFch; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742204736; x=1773740736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2L7KDp9FOHdilaL0CR+rsa4VNZkaVaclZPPZcERIo9M=;
  b=nZBCeFch9gLUHUrdIq3+2KJtwK7JjLcP7rQVPtARVX54W8mBTdHNWvrH
   g2c1O8CmzIzQUN/RSkVM8LTTAmiHlt3zu/+nGgJWX6TtHZg6GZ/SMKvJv
   r8nS60o4diBUecc+sXQ2ufDEjnq85JUrAuKw/yD7wpe6Pwsr8KGSf1ORz
   RcoL01/826jb2yuHupkXPB/sTyPEJw6HRVBFhl0M0xO4WuxEXjCNUcUTW
   8ZU60AVvP4mLoo1eOI8LEgtHYrvkfaFm74S+QulUmrQV0eaYDE5E68o+S
   JRkNdzGRVsZMnLFZ1mTHKb9rdSpSpdR4n+hMN+2GWYvKjx+21/CoFRym0
   Q==;
X-CSE-ConnectionGUID: ZRjn18yZS3CubvmwBUdsVA==
X-CSE-MsgGUID: 66DmPCRFSHaRB/z0g+X29Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="53917614"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="53917614"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 02:45:35 -0700
X-CSE-ConnectionGUID: KiI60iehTDqFb1rIF07FWA==
X-CSE-MsgGUID: KJK2d+JYRlCzVfXqZ1+Qpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="121882215"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.8])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 02:45:30 -0700
Date: Mon, 17 Mar 2025 11:45:25 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	"Maloor, Kishen" <kishen.maloor@intel.com>
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
Message-ID: <Z9fvNU4EvnI6ScWv@tlindgre-MOBL1>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <Z9e-0OcFoKpaG796@tlindgre-MOBL1>
 <b158a3ef-b115-4961-a9c3-6e90b49e3366@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b158a3ef-b115-4961-a9c3-6e90b49e3366@intel.com>

On Mon, Mar 17, 2025 at 03:32:16PM +0800, Chenyi Qiang wrote:
> 
> 
> On 3/17/2025 2:18 PM, Tony Lindgren wrote:
> > Hi,
> > 
> > On Mon, Mar 10, 2025 at 04:18:34PM +0800, Chenyi Qiang wrote:
> >> --- a/system/physmem.c
> >> +++ b/system/physmem.c
> >> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
> >>              qemu_mutex_unlock_ramlist();
> >>              goto out_free;
> >>          }
> >> +
> >> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
> >> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
> >> +            error_setg(errp, "Failed to realize memory attribute manager");
> >> +            object_unref(OBJECT(new_block->memory_attribute_manager));
> >> +            close(new_block->guest_memfd);
> >> +            ram_block_discard_require(false);
> >> +            qemu_mutex_unlock_ramlist();
> >> +            goto out_free;
> >> +        }
> >>      }
> >>  
> >>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> > 
> > Might as well put the above into a separate memory manager init function
> > to start with. It keeps the goto out_free error path unified, and makes
> > things more future proof if the rest of ram_block_add() ever develops a
> > need to check for errors.
> 
> Which part to be defined in a separate function? The init function of
> object_new() + realize(), or the error handling operation
> (object_unref() + close() + ram_block_discard_require(false))?

I was thinking the whole thing, including freeing :) But maybe there's
something more to consider to keep calls paired.

> If need to check for errors in the rest of ram_block_add() in future,
> how about adding a new label before out_free and move the error handling
> there?

Yeah that would work too.

Regards,

Tony

