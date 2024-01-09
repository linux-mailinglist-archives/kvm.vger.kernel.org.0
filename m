Return-Path: <kvm+bounces-5859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA95A827C91
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 02:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A8B2B2177E
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 01:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5586186C;
	Tue,  9 Jan 2024 01:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPrSjMSU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E32910E4
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 01:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704764158; x=1736300158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jxw+wXgVK+0zB4+6hhfX23WMdxNd1wR6ZS873ze7Cag=;
  b=LPrSjMSUc/lcO25t29ZRM7KbVgcNZS5P0D5eTOJ/EZCZo+cW4lADBcFH
   3PkYZqG2T3v00u5nStxwKYcDhMCFbiwZiOvoITw8TikSvjqsGDfd2HrEV
   /bD+NwWmIBlcxNyD4NP8IVNboScficXhUMmP9VgKW8ipdWD1+KFG2ELOJ
   K3EzHpYDpqtPMy+yRjTWx6KVkzuKKvUhuN2WLTolhYrJejVwVjHa1Mjqn
   b/Jkzibv+6TqKrBQci1bPoAzt8M9dkxR46FjnNFhWKz79SOfZoyPo6r+K
   7zEOjlhgyhd66E+xNg0onI3UNVPVt+GUZeNzhgUAShsqf8Sp0mxPtRTVN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="19554341"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="19554341"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 17:35:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="731303854"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="731303854"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga003.jf.intel.com with ESMTP; 08 Jan 2024 17:35:46 -0800
Date: Tue, 9 Jan 2024 09:48:41 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v7 00/16] Support smp.clusters for x86 in QEMU
Message-ID: <ZZyl+TEFki3Pmxqm@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <1766d543-8960-4f92-970e-d05975c53e90@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1766d543-8960-4f92-970e-d05975c53e90@amd.com>

Hi Babu,

On Mon, Jan 08, 2024 at 11:46:50AM -0600, Moger, Babu wrote:
> Date: Mon, 8 Jan 2024 11:46:50 -0600
> From: "Moger, Babu" <babu.moger@amd.com>
> Subject: Re: [PATCH v7 00/16] Support smp.clusters for x86 in QEMU
> 
> Hi  Zhao,
> 
> Ran few basic tests on AMD systems. Changes look good.
> 
> Thanks
> Babu
> 
> 
> Tested-by: Babu Moger <babu.moger@amd.com>
> 

Thanks much for your test!

Regards,
Zhao


