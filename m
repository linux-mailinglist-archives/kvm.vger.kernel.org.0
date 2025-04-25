Return-Path: <kvm+bounces-44258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 425FFA9C075
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6CEC16AB90
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E06233726;
	Fri, 25 Apr 2025 08:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kX+f/A0C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8F0232395
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 08:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745568492; cv=none; b=NoDTikxD2lkLcAeJOcyv2DQqCe32RzbDUY+XmWfH0VEu9wkW3YcV7iR0cq2ZVMtGfWveA+wTNJGKb7sM/O6z6D61x3g/L95LxAYO0cj4PlMb5bWqWlj5zy8BExqkysl2GCMCbePM7uHbNOh6nnDL5Z1fcCd9z/MLmSKrjAV6NQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745568492; c=relaxed/simple;
	bh=5KRtg0VP7RhePb2K1+43zCTF9YsbA4O/PrqeshZCb4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MV5s+stNzWRRG2+YlhbX83kVf+HHOmcUQRivVpzybZW/jEC8TCNqBcE2atHQn80pVa+QD69Ns0ntphJB3w+Ya8wiHleA4rGq1MR/t5oRwjzZi/P/Pxk1Cy1nGihmCnkJ69CC8Fm3diJidzAWNj343ejR3O4lOzo53dDK6OzAgq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kX+f/A0C; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745568491; x=1777104491;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5KRtg0VP7RhePb2K1+43zCTF9YsbA4O/PrqeshZCb4w=;
  b=kX+f/A0CrcU1Vn7lZv6RKpZeryfBrRl9vB2OlxEr81j4AFBOB+lFOqIk
   vkXHZ189+EpWWDNDE+sNVdMSod5BjwQkaYCjmMWFIyX/HxEjWdrayoZhF
   XVIVb/+Zx1nW5n07Lw8SeB/4oxZLAjjNSk2AueYP5K4BODI/9JzX6Bfcw
   4kIx8MOGm8J2rKtQQHO8LT0c2pvtL85/zi7JSGXX5mMv22XTrxk0z/e+D
   zrhu5lroZtCR4J8kmhlZqA2XXDZNN97mLL2boiGKjX8HoCP6b/wDRVbTx
   Hz35m2DUv7/Q90GOvmNWzaiJxaOrg6hEfe6TGHflTH6YBpm3n3z4eTzeg
   Q==;
X-CSE-ConnectionGUID: Hj5m8np+RgSVi7wvTJFBlQ==
X-CSE-MsgGUID: vYIj4lGxQkuENF7QdXezQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="47240131"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="47240131"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 01:08:09 -0700
X-CSE-ConnectionGUID: 2BKS4ujcSP2OGoMmWUBd1w==
X-CSE-MsgGUID: BElnjdbdSySYVUcokWJU+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="163808291"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 25 Apr 2025 01:07:59 -0700
Date: Fri, 25 Apr 2025 16:28:54 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
	kraxel@redhat.com, berrange@redhat.com
Subject: Re: [PATCH v4 01/11] [DO NOT MERGE] i386/cpu: Consolidate the helper
 to get Host's vendor
Message-ID: <aAtHxmpV7ka1lseC@intel.com>
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-2-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416215306.32426-2-dongli.zhang@oracle.com>

On Wed, Apr 16, 2025 at 02:52:26PM -0700, Dongli Zhang wrote:
> Date: Wed, 16 Apr 2025 14:52:26 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v4 01/11] [DO NOT MERGE] i386/cpu: Consolidate the helper
>  to get Host's vendor
> X-Mailer: git-send-email 2.43.5
> 
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Extend host_cpu_vendor_fms() to help more cases to get Host's vendor
> information.
> 
> Cc: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> This patch is already queued by Paolo.
> https://lore.kernel.org/all/20250410075619.145792-1-zhao1.liu@intel.com/
> I don't need to add my Signed-off-by.
> 
>  target/i386/host-cpu.c        | 10 ++++++----
>  target/i386/kvm/vmsr_energy.c |  3 +--
>  2 files changed, 7 insertions(+), 6 deletions(-)

Thanks. It has been merged as commit ae39acef49e2916 now.


