Return-Path: <kvm+bounces-34887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE9CA06F8A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1439167852
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF1021480D;
	Thu,  9 Jan 2025 07:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TkWUhwoG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C11204688
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736409333; cv=none; b=A1zSFKo7L/l83J4DANeOBAQGHIGWMW5Hu/d8eH8iXc4UxeiJgXeAfUscn6JqA7NkvNVlLoEl2bR1doQjs0dcyOFcPKLarEMAscwy07o2HF3GDaxuiSLYhdK8UMcmr2l2D+2RIGtDq98Lws8MKM6oo3HLgCd1WMwArO0zbHjwS9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736409333; c=relaxed/simple;
	bh=pyZmZFyKDBHekyYEQGRVyICCu9kWdK7pV256wvcoNRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OICXs4TPcXotFrs+oBmepPd654fe/loZIp1oi1xSbyQ74HLoUNORTHTc2iEWwJ7zwwj0xpW9V4plDraVYjxnWhqasd38I9UpaZXnrgTQCMRn/Y2o2CGgBUbGVo6WtkwFdtNJ8tzNWSPYl2/yvE5drmWAO3gFvAzoyz/0oBX7N0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TkWUhwoG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736409332; x=1767945332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pyZmZFyKDBHekyYEQGRVyICCu9kWdK7pV256wvcoNRI=;
  b=TkWUhwoGNPdJwuJVaNE3JCO5U4UZogKAypbfarP2bok8lBL4aDUV9jLF
   Yetjkpl49h+Hq6Oi52fZg3+XutVyDKCNkhnCaLxGD09imrTrVXQRNAOJf
   4e1tBqanJyBZnbLs9fxs+2qJ3E8pAz1fawia8OhXuPMbnowL0pP/2bInV
   plJHDUnB5qz7//3ZN0DbmBQHmYuRADoI+K2mkOJ6YvsOOGRJt/ahalude
   ptf3cPj+iHIwQ/7F0dFrdjQwtiQbRS52D5BEvDXRQ6hSlQWhgyi1TwHvz
   e9ceqpz37RagKd2ZlIhYSJT+kSx12/G7qssdNxftrXQtvp7UlE3U4rLNn
   Q==;
X-CSE-ConnectionGUID: ttU68dsgSt6+ttUCGVHNaw==
X-CSE-MsgGUID: KzBK5E6HQRGzpj3QeiEPzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36885073"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36885073"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 23:55:31 -0800
X-CSE-ConnectionGUID: In0HEq3YQQWKLhk9Q1wvMg==
X-CSE-MsgGUID: WI+43nBfQFaAxKWBm/njXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103872722"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 08 Jan 2025 23:55:28 -0800
Date: Thu, 9 Jan 2025 16:14:17 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
Message-ID: <Z3+FWW9v3QqL/gEw@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213070852.106092-6-chenyi.qiang@intel.com>

>  #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>              qemu_mutex_unlock_ramlist();
>              goto out_free;
>          }
> +
> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block->mr->size);

realize & unrealize are usually used for QDev. I think it's not good to use
*realize and *unrealize here.

Why about "guest_memfd_manager_attach_ram"?

In addition, it seems the third parameter is unnecessary and we can access
MemoryRegion.size directly in guest_memfd_manager_realize().

>      }
>  
>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> @@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
>  
>      if (block->guest_memfd >= 0) {
>          close(block->guest_memfd);
> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
> +        guest_memfd_manager_unrealize(gmm);

Similiarly, what about "guest_memfd_manager_unattach_ram"?

> +        object_unref(OBJECT(gmm));
>          ram_block_discard_require(false);
>      }
>  

Regards,
Zhao


