Return-Path: <kvm+bounces-59801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDBBBCF4D1
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 13:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3ABBB4E96EF
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 11:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A38426D4F1;
	Sat, 11 Oct 2025 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7OK2Gog"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FB026B74A;
	Sat, 11 Oct 2025 11:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760183878; cv=none; b=YK9e+wn2LJxBexWP3NcP4WYlS+MiUMSGuNtxO53eBmuXEZevVpPWbsDS8/XxjA98UMpoRZSg12LqvrjPgY7YXoUw+8zjy51w3PROl8S5Tr5ZmxxVGvz0JPGvNBTColrKEx3+Rj9EMBJQXXzPIwuuqCTJHyQQy9aqF1EHyE21s4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760183878; c=relaxed/simple;
	bh=apJt3RY2rGIw2sSuDVIW9g28uVuWxjX8XuKvILDChHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFKjBuaEkf2f6XK+EP55O1lyqBkZQ+/YwzIfDcIvpei91HAOAYJxJdY5ojzTj/oTf1+tccH4N5OgWM3S9sD0HUEkdg3kx78i21SO2Ttq05oHwDezg/4T4fawQDPwLDv71ZB3JBvcHa5RqJFoh8RJ0btNE9sVcrvA9zlaeUGOr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7OK2Gog; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760183871; x=1791719871;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=apJt3RY2rGIw2sSuDVIW9g28uVuWxjX8XuKvILDChHM=;
  b=T7OK2GogHBR0kk+JDLxOjxrLvMylpnjREdbfgRjhy5iTmjujXm7veKNS
   PTVGd9co5hYgkJyncWiDrv1QkfXBfM9oDL+T9WEVLl8Faat38dYW11b6B
   y1oB9p/qMIhTvnXlBFhnvU/siCk5T25cER+yZs3pTK+mFt+m/Yc3aMO4z
   4Nvv3JGF5uyXZ4HM/x9tpEO6mOk+kPFAvrXvIoRyVWCQMTWugsvq/ZDqi
   nXQIz6D1fzI1ORmui2UnptKRbGFkSiHtvo3lk2/sqHztfXh5gRFKAL7RY
   nUXwgKxTxDhKQUyIxEpOtE3js2ZElq9UdVif69RxTSw7sU2iEOeII/ckG
   g==;
X-CSE-ConnectionGUID: kdoArvJnRUSl4PpYSpkQxQ==
X-CSE-MsgGUID: q7Uj38mCTwOdOlaW+adRKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62305702"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62305702"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 04:57:51 -0700
X-CSE-ConnectionGUID: I+r30GgoQwCI86EDS47p9g==
X-CSE-MsgGUID: k9tYwXXhQgy2YtKkrvIYwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="186294987"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 11 Oct 2025 04:57:49 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7YEM-0003kB-23;
	Sat, 11 Oct 2025 11:57:46 +0000
Date: Sat, 11 Oct 2025 19:57:07 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alex Mastro <amastro@fb.com>
Subject: Re: [PATCH v3 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Message-ID: <202510111953.naYvy8XB-lkp@intel.com>
References: <20251010-fix-unmap-v3-3-306c724d6998@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010-fix-unmap-v3-3-306c724d6998@fb.com>

Hi Alex,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 407aa63018d15c35a34938633868e61174d2ef6e]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Mastro/vfio-type1-sanitize-for-overflow-using-check_-_overflow/20251010-154148
base:   407aa63018d15c35a34938633868e61174d2ef6e
patch link:    https://lore.kernel.org/r/20251010-fix-unmap-v3-3-306c724d6998%40fb.com
patch subject: [PATCH v3 3/3] vfio/type1: handle DMA map/unmap up to the addressable limit
config: i386-buildonly-randconfig-001-20251011 (https://download.01.org/0day-ci/archive/20251011/202510111953.naYvy8XB-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510111953.naYvy8XB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510111953.naYvy8XB-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/overflow.h:6,
                    from include/linux/bits.h:32,
                    from include/linux/bitops.h:6,
                    from include/linux/log2.h:12,
                    from arch/x86/include/asm/div64.h:8,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/compat.h:10,
                    from drivers/vfio/vfio_iommu_type1.c:24:
   drivers/vfio/vfio_iommu_type1.c: In function 'vfio_dma_do_unmap':
>> include/linux/limits.h:25:25: warning: conversion from 'long long unsigned int' to 'dma_addr_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Woverflow]
      25 | #define U64_MAX         ((u64)~0ULL)
         |                         ^
   drivers/vfio/vfio_iommu_type1.c:1361:28: note: in expansion of macro 'U64_MAX'
    1361 |                 iova_end = U64_MAX;
         |                            ^~~~~~~
--
   In file included from include/linux/overflow.h:6,
                    from include/linux/bits.h:32,
                    from include/linux/bitops.h:6,
                    from include/linux/log2.h:12,
                    from arch/x86/include/asm/div64.h:8,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/compat.h:10,
                    from vfio_iommu_type1.c:24:
   vfio_iommu_type1.c: In function 'vfio_dma_do_unmap':
>> include/linux/limits.h:25:25: warning: conversion from 'long long unsigned int' to 'dma_addr_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Woverflow]
      25 | #define U64_MAX         ((u64)~0ULL)
         |                         ^
   vfio_iommu_type1.c:1361:28: note: in expansion of macro 'U64_MAX'
    1361 |                 iova_end = U64_MAX;
         |                            ^~~~~~~


vim +25 include/linux/limits.h

3c9d017cc283df Andy Shevchenko 2023-08-04  14  
54d50897d544c8 Masahiro Yamada 2019-03-07  15  #define U8_MAX		((u8)~0U)
54d50897d544c8 Masahiro Yamada 2019-03-07  16  #define S8_MAX		((s8)(U8_MAX >> 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  17  #define S8_MIN		((s8)(-S8_MAX - 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  18  #define U16_MAX		((u16)~0U)
54d50897d544c8 Masahiro Yamada 2019-03-07  19  #define S16_MAX		((s16)(U16_MAX >> 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  20  #define S16_MIN		((s16)(-S16_MAX - 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  21  #define U32_MAX		((u32)~0U)
3f50f132d8400e John Fastabend  2020-03-30  22  #define U32_MIN		((u32)0)
54d50897d544c8 Masahiro Yamada 2019-03-07  23  #define S32_MAX		((s32)(U32_MAX >> 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  24  #define S32_MIN		((s32)(-S32_MAX - 1))
54d50897d544c8 Masahiro Yamada 2019-03-07 @25  #define U64_MAX		((u64)~0ULL)
54d50897d544c8 Masahiro Yamada 2019-03-07  26  #define S64_MAX		((s64)(U64_MAX >> 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  27  #define S64_MIN		((s64)(-S64_MAX - 1))
54d50897d544c8 Masahiro Yamada 2019-03-07  28  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

