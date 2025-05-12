Return-Path: <kvm+bounces-46129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0516AAB2DB1
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 05:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 888631780EA
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 03:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5717224E4A9;
	Mon, 12 May 2025 03:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HzZLHyn+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CEA13B293
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 03:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747019025; cv=none; b=ac+Vl5rwo0clxa9HFaBLUQqhiu0w0Dbb/y5aGzULHVEyzw7yXTrtKYUCGL8u9g8MQgyeRO4RSb03ah4Ia9Axm3r+sxMTleBm61k+DHSomQafvBP6DZ+EugDoqtQD2XGv5FfwqDK82wEc+Lo/ECvVTyr/Jp8R9szzv+PEpm0Ca8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747019025; c=relaxed/simple;
	bh=Bj/tH68dQzsGdHRJBEGcFc/YadVXSQUdHnDga7hlP4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usaCa7uSPIJMuv4by6olXaaJ7F4mM7vWL0JazncdwuGNCHzxFMTaaio75C82yehMjtp5Zys3lq4Ekrf2aUtr+6h5QlCHgoJdzwzHzPXeRnI3/PSEeGGtGMti9C6PK9UZa9r5VU14dTlvFV6Mkwb1prmT1rlv0fuuqd2p04yO1nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HzZLHyn+; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747019023; x=1778555023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bj/tH68dQzsGdHRJBEGcFc/YadVXSQUdHnDga7hlP4w=;
  b=HzZLHyn+pAyX3Rse0mkQjhIK3/F854Hl8kndCp8rDkwpyIdfmEGBP4eZ
   qB96SxcYzgrzXZELXxKauRfOwL8WCtuCoAQvAnV6HbQFWAUfY20m8wl+V
   Z5Q2vWHW5fgUSoxpXwMy8jpUfjJQTLAWFKBpxIXT3OPsU7XMbspEU9dMn
   j3Sdd6BlwgpZ+u2cW/BK8j4YQa7Mp8HlDVBteC4m+9yyMwHoTtzWnAxQT
   ElNvwSFrdx3yyrPqzag3nSB4dx9J8/+ONG7jzekZl0EdJ6RXja1sIqnF/
   C+uH3ATmi3/cuOxaBWnvodOzfNYcW52wz4GMAlOGfnJ9/UjvYAHyy/3lq
   Q==;
X-CSE-ConnectionGUID: 7Pj6AAYLReeGJqC7Sd5kBg==
X-CSE-MsgGUID: 267bJzNhSXui2PheEv8CAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48046376"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="48046376"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 20:03:42 -0700
X-CSE-ConnectionGUID: aPnosXKGSIyf29dDBkqrjA==
X-CSE-MsgGUID: 5W4UljGCQ/amyVe+XVUeIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="137717132"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 11 May 2025 20:03:39 -0700
Date: Mon, 12 May 2025 11:24:42 +0800
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
Subject: Re: [PATCH v4 01/13] memory: Export a helper to get intersection of
 a MemoryRegionSection with a given range
Message-ID: <aCFp+oLcypJEh71X@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-2-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407074939.18657-2-chenyi.qiang@intel.com>

On Mon, Apr 07, 2025 at 03:49:21PM +0800, Chenyi Qiang wrote:
> Date: Mon,  7 Apr 2025 15:49:21 +0800
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> Subject: [PATCH v4 01/13] memory: Export a helper to get intersection of a
>  MemoryRegionSection with a given range
> X-Mailer: git-send-email 2.43.5
> 
> Rename the helper to memory_region_section_intersect_range() to make it
> more generic. Meanwhile, define the @end as Int128 and replace the
> related operations with Int128_* format since the helper is exported as
> a wider API.
> 
> Suggested-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>     - No change.
> 
> Changes in v3:
>     - No change
> 
> Changes in v2:
>     - Make memory_region_section_intersect_range() an inline function.
>     - Add Reviewed-by from David
>     - Define the @end as Int128 and use the related Int128_* ops as a wilder
>       API (Alexey)
> ---
>  hw/virtio/virtio-mem.c | 32 +++++---------------------------
>  include/exec/memory.h  | 27 +++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 27 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


