Return-Path: <kvm+bounces-6196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A9D82D429
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C06431C2109F
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FDAD3C0B;
	Mon, 15 Jan 2024 06:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgaT9AWs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441D2566
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 06:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705299758; x=1736835758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GQIsLNn6hJVJTPHXRkaEq4wnPTcPIuPsr+uAqE0okVs=;
  b=VgaT9AWsfj/wFgYw6e4q95MVlQtmShgvIuYES4zSkOzcWJLbbdyd6wSM
   KLoenbrM8yuQxNLk9uPa991ShW+kc5h9iAWma+hS8B2n7Pw3GrFjpyKYU
   RT0M3sXkrm2LImBKlY9aAPUEzBp3QvPvmDdHoxOrYNddeONaBGIakIB7j
   UxH+TaaYOoMiabVSMv7H/fgBGHIjw99do85qASSHuDHeCaAkaAZKdUjLr
   tg++I5a6UutcsCv5Hftn776kti1sJTJkigDrwRs8EjOzCozJ51Rj441UJ
   vttXsqFDksT00b86kiqRWesgnLalC8Kl7DXP8cJExSTOBbIbDy3wPHBy6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="399220952"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="399220952"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:22:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="733215325"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="733215325"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga003.jf.intel.com with ESMTP; 14 Jan 2024 22:22:33 -0800
Date: Mon, 15 Jan 2024 14:35:31 +0800
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
Message-ID: <ZaTSM8IAzQ1onX05@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060>
 <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
 <ZaTM5njcfIgfsjqt@intel.com>
 <78168ef8-2354-483a-aa3b-9e184de65a72@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78168ef8-2354-483a-aa3b-9e184de65a72@intel.com>

On Mon, Jan 15, 2024 at 02:11:17PM +0800, Xiaoyao Li wrote:
> Date: Mon, 15 Jan 2024 14:11:17 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> 
> On 1/15/2024 2:12 PM, Zhao Liu wrote:
> > Hi Xiaoyao,
> > 
> > On Mon, Jan 15, 2024 at 12:34:12PM +0800, Xiaoyao Li wrote:
> > > Date: Mon, 15 Jan 2024 12:34:12 +0800
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> > > 
> > > > Yes, I think it's time to move to default 0x1f.
> > > 
> > > we don't need to do so until it's necessary.
> > 
> > Recent and future machines all support 0x1f, and at least SDM has
> > emphasized the preferred use of 0x1f.
> 
> The preference is the guideline for software e.g., OS. QEMU doesn't need to
> emulate cpuid leaf 0x1f to guest if there is only smt and core level.

Please, QEMU is emulating hardware not writing software. Is there any
reason why we shouldn't emulate new and generic hardware behaviors and
stick with the old ones?

> because in this case, they are exactly the same in leaf 0xb and 0x1f. we don't
> need to bother advertising the duplicate data.

You can't "define" the same 0x0b and 0x1f as duplicates. SDM doesn't
have such the definition.

Regards,
Zhao


