Return-Path: <kvm+bounces-46303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD83AB4DB4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F023416A7AE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 08:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB5A1F5827;
	Tue, 13 May 2025 08:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwbhUhAf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B34A93D
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 08:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123804; cv=none; b=PUWb7pnDJFT8PUYSj++Fpt3i/GmJGVg+MbAWmHU9H8SGhhtvXrbIWIB043cQpSef0sAFb/nY5TUjIVjsLluIbfhbE4Yb5GgWcMjYAwPzZg88bTT4M7ZF6pxEJ0ns7uuHxKqpv9xJjub1tTkluuFs4JZWlOL5+CagxNUNuPOxX70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123804; c=relaxed/simple;
	bh=ToqcWH2DwjjzvKTkbb1scAhC6W2tO35kLWOPSwlRmpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8mrxCqLTNaj8H+NUC2sWr98lfPXr+jCVfZfkws31YvZKeNPN3r7GVXaNk27WREoGPmAVtD9KLKu2g3OnSZ3BiscTlOTuiKVI2Sf+aQsUtnQR2H6N0Qy5X1gjePTy4ec2noqAlPlYNJ6QX9Zv1HemDBi1DxkD5DMLKLUFVDC8f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwbhUhAf; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747123803; x=1778659803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ToqcWH2DwjjzvKTkbb1scAhC6W2tO35kLWOPSwlRmpE=;
  b=CwbhUhAfLOo5uXNcPyKoC3L7o4ZFD6Km3+0dtCTasgbCckfaZzOuuggD
   tMXuoHAU2sNYUpI/gNqR7axGalGN8UxIOEXNrDM+IBIT7ORyWow26klj2
   PrwYSTbrd+mL1LGmqO6XpizJ2p/sCuXi+jYDqIH6HgbIohKdrq6EKuhO6
   ykLutZhXNDMxCWype5TyX+TyNiOfySXtBO4qA7ezl4Z2XrjqSY3nag3mX
   WXFJZYs83rz5btlqvlaIsnir72qRnzE+NN+xD2WlxMbQAn2Z975TNE4u2
   dfPbGGyyVgKJF8FBLdBRUFp5BTb8og6rqmnReaNmJqITIfgW+akQBKMqA
   g==;
X-CSE-ConnectionGUID: mZEGIJ/XTFu1zb6ugSn7Jg==
X-CSE-MsgGUID: V187OjwwQkiFv4ZUjFQMzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="49034923"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="49034923"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 01:10:03 -0700
X-CSE-ConnectionGUID: MUpUFQM5THe9jefW5Bax/A==
X-CSE-MsgGUID: VbGTNf04T8mj1oFR5jCDlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="160900961"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 13 May 2025 01:09:58 -0700
Date: Tue, 13 May 2025 16:31:02 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce
 RamBlockAttribute to manage RAMBLock with guest_memfd
Message-ID: <aCMDRoHcoV2PM34W@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
 <aCGsPh/A3sh0dDlI@intel.com>
 <3c4405f4-8d2a-48aa-b92a-f8fee223f1cb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c4405f4-8d2a-48aa-b92a-f8fee223f1cb@intel.com>

> >> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> >> index 0babd105c0..b8b5469db9 100644
> >> --- a/include/exec/ramblock.h
> >> +++ b/include/exec/ramblock.h
> >> @@ -23,6 +23,10 @@
> >>  #include "cpu-common.h"
> >>  #include "qemu/rcu.h"
> >>  #include "exec/ramlist.h"
> >> +#include "system/hostmem.h"
> >> +
> >> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
> >> +OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass, RAM_BLOCK_ATTRIBUTE)
> > 
> > Could we use "OBJECT_DECLARE_SIMPLE_TYPE" here? Since I find class
> > doesn't have any virtual method.
> 
> Yes, we can. Previously, I defined the state_change() method for the
> class (MemoryAttributeManagerClass) [1] instead of parent
> PrivateSharedManagerClass. And leave it unchanged in this version.
> 
> In next version, I will drop PrivateShareManager and revert to use
> RamDiscardManager. Then, maybe I should also use
> OBJECT_DECLARE_SIMPLE_TYPE and make state_change() an exported function
> instead of a virtual method since no derived class for RamBlockAttribute.

Thank you! I see. I don't have an opinion on whether to add virtual
method or not, if you feel it's appropriate then adding class is fine.
(My comment may be outdated, it's just for the fact that there is no
need to add class in this patch.) Looking forward to your next version.

> [1]
> https://lore.kernel.org/qemu-devel/20250310081837.13123-6-chenyi.qiang@intel.com/
> 
> > 
> >>  struct RAMBlock {
> >>      struct rcu_head rcu;
> >> @@ -90,5 +94,25 @@ struct RAMBlock {
> >>       */
> >>      ram_addr_t postcopy_length;
> >>  };
> >> +

[snip]

> >> +static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
> >> +{
> >> +    /*
> >> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
> >> +     * Use the host page size as the granularity to track the memory attribute.
> >> +     */
> >> +    g_assert(attr && attr->mr && attr->mr->ram_block);
> >> +    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
> >> +    return attr->mr->ram_block->page_size;
> > 
> > What about using qemu_ram_pagesize() instead of accessing
> > ram_block->page_size directly?
> 
> Make sense!
> 
> > 
> > Additionally, maybe we can add a simple helper to get page size from
> > RamBlockAttribute.
> 
> Do you mean introduce a new field page_size and related helper? That was
> my first version and but suggested with current implementation
> (https://lore.kernel.org/qemu-devel/b55047fd-7b73-4669-b6d2-31653064f27f@intel.com/)

Yes, that's exactly my point. It's up to you if it's really necessary :-).

> > 
> >> +}
> >> +
> > 
> > [snip]
> > 
> >> +static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
> >> +                                                      StateChangeListener *scl,
> >> +                                                      MemoryRegionSection *section)
> >> +{
> >> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> >> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> >> +    int ret;
> >> +
> >> +    g_assert(section->mr == attr->mr);
> >> +    scl->section = memory_region_section_new_copy(section);
> >> +
> >> +    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
> >> +
> >> +    ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
> >> +                                                      ram_block_attribute_notify_shared_cb);
> >> +    if (ret) {
> >> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
> >> +                     strerror(-ret));
> > 
> > There will be 2 error messages: one is the above, and another is from
> > ram_block_attribute_for_each_shared_section().
> > 
> > Could we just exit to handle this error?
> 
> Sure, will remove this message as well as the below one.

   if (ret) {
       error_report("%s: Failed to register RAM discard listener: %s", __func__,
                    strerror(-ret);
       exit(1);
   }

I mean adding a exit() here. When there's the error, if we expect it not to
break the QEMU, then perhaps warning is better. Otherwise, it's better to
handle this error. Direct exit() feels like an option.

Thanks,
Zhao

> > 
> >> +    }
> >> +}
> >> +

