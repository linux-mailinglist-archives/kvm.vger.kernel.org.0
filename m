Return-Path: <kvm+bounces-6198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 176CA82D453
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5A8C1F2168C
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3863C1D;
	Mon, 15 Jan 2024 06:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mZFFwTqv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941323C9
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 06:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705301856; x=1736837856;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HAuI63RtZNCW9bPDKoL24fAx009ASwCIuxW3e8g+f54=;
  b=mZFFwTqvqsiJnh6LwcI8MolihGd+IbLxMSHUhPIlDkFdXCpV6+QtlSRf
   mN7LHSxMr3nxZJ5FQEZ5KTig37z5iUImGNz7bnssr9vKnGmtxNBg8IR0i
   6Q4Vri+LzRb78fiibp30lNDaT1+j8W4oCoGjDbyLjB92TvoWIali/t5Xi
   TRu0IHVJTVp+ygD4WjBmTXWgj2oJIrBYPRbAyBgkVGala2ZZ/dv9touxq
   9sZb5GBrX8dc39lq90R+scyEsnamTwWHVCgjyGr4NYffBH42CVtFqWnH9
   0KMKxP8mzxh3RNklmUo7GrPXrcCgZEbc6o6TfsnLRT6xhr17e9ZMYXuwi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="465929464"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="465929464"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="817725685"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="817725685"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 14 Jan 2024 22:57:31 -0800
Date: Mon, 15 Jan 2024 14:57:30 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
Message-ID: <20240115065730.ezwpd3sjoycc57rm@yy-desk-7060>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060>
 <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
 <20240115052022.xbv6exhm4af7kai7@yy-desk-7060>
 <ZaTOpCFZRu6/py/J@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaTOpCFZRu6/py/J@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 15, 2024 at 02:20:20PM +0800, Zhao Liu wrote:
> On Mon, Jan 15, 2024 at 01:20:22PM +0800, Yuan Yao wrote:
> > Date: Mon, 15 Jan 2024 13:20:22 +0800
> > From: Yuan Yao <yuan.yao@linux.intel.com>
> > Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> >
> > Ah, so my understanding is incorrect on this.
> >
> > I tried on one raptor lake i5-i335U, which also hybrid soc but doesn't have
> > module level, in this case 0x1f and 0xb have same values in core/lp level.
>
> Some socs have modules/dies but they don't expose them in 0x1f.

Here they don't expose because from hardware level they can't or possible
software level configuration (i.e. disable some cores in bios) ?

>
> If the soc only expose thread/core levels in 0x1f, then its 0x1f is same
> as 0x0b. Otherwise, it will have more subleaves and different
> values.
>
> Thanks,
> Zhao
>

