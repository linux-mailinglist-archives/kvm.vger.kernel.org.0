Return-Path: <kvm+bounces-6190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0764D82D40A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AA69B20EA5
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151AE3D8C;
	Mon, 15 Jan 2024 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkqpN052"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143803C23
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 06:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705298402; x=1736834402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w64qKTKqo3JjtN7Wzl4g1zomYMWAQrjH+M5UN+xmLlU=;
  b=kkqpN052bhsV8qX1H6nZSESwDws+5dCtP8XHASiGMMJ2ItVGQtxvhyFk
   F80UfIQwB0ZrAcb5IaAFcRgP/o6GuhCKPwmkyYU1FR12WNKNKx4aDr+YF
   mZjwbJKr+vc4QVknvQlgxKDWzY5zTYDRbYK4Q2Yrh2vWPEOST4hIpBEQA
   FJ+BO64Nw3yY6n0bDdfmofSxf1Zwe/Y37SHHLgy47TlG/Lipust52mrmo
   nzIiwCvK3qUFaCU6rX74RzcwNHdL5GIJpafLy9j0c53w0jb6jOgczJCD7
   CfeB7+rb/A2FZAhhADAScGShVHrnhZjOZbGoGqFgGhaFslNMfH7Xy5Vtq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6634058"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="6634058"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:00:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="733210976"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="733210976"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga003.jf.intel.com with ESMTP; 14 Jan 2024 21:59:56 -0800
Date: Mon, 15 Jan 2024 14:12:54 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>,
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
Message-ID: <ZaTM5njcfIgfsjqt@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060>
 <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>

Hi Xiaoyao,

On Mon, Jan 15, 2024 at 12:34:12PM +0800, Xiaoyao Li wrote:
> Date: Mon, 15 Jan 2024 12:34:12 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> 
> > Yes, I think it's time to move to default 0x1f.
> 
> we don't need to do so until it's necessary.

Recent and future machines all support 0x1f, and at least SDM has
emphasized the preferred use of 0x1f.

Thanks,
Zhao


