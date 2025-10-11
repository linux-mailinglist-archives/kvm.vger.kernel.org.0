Return-Path: <kvm+bounces-59835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8634ABCFD39
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 00:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C9A984E2943
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 22:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8DB244679;
	Sat, 11 Oct 2025 22:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iEH1qPYD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066DB1F9F47;
	Sat, 11 Oct 2025 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760221788; cv=none; b=NpO9Tvj5PQmOM5a+d++DidCAEm6+TG73zFnd7P7/ERao7iLPU3WDgk7HF5VmMchebXQAEhizTnBlLLN9Sa1RF1/HISs/LA0NyC1sIvnV1kcBeugt0RNZSk5+jKJ88Fq1uP5WPeJLb4EZ6DXrNlGfkEoHTfBnw3/Cy4N/y/msmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760221788; c=relaxed/simple;
	bh=9ftHdqHrokZcQXhNcrNBSsyfRb38s2MdEhcqUsS5UxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzp9VWNp8K87o8rUB4OCAe9ObPFUzNQPe12sHuxp4tVHjGuyOn5NkHPiEakmYBSO/2LeRDznUNQhdvZ2joXW9zmxrPR9UwJ1FMa9+XbuSG5Z/zjGA8u5TI6MaQSascaVnyrCSX0AeqnUhRuSKHM9oaRA6T2Lg8byesVwVjwfYo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iEH1qPYD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760221786; x=1791757786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9ftHdqHrokZcQXhNcrNBSsyfRb38s2MdEhcqUsS5UxA=;
  b=iEH1qPYDh+bttozWoB9budNuMO0KxcnYiyunQLEeFZeFyekztSmHT8xi
   s77AKp9Ksu31UT15gaGTmSU6u8xFJ6fhXC35lW8l9OPsIMv7AFslgMZYy
   wZl6SNOLPCkIDvkFw7HOOByPlKh9dXQFXeZpIRn1ohMTWlFsShv43bYMo
   PIdcvvWmuF2icDwoFnZ6iUucqTkb4Jq8u095V4rhINp6cqVvV+Iw98ezm
   38TGqsYBwF8oU5F9bqdfozKjQgmza7Sr3zjzvocCEFBqPFC/ZR0MJcgXh
   GMAMsHZxUeKr8WmYgLCpcTcuh5PyI1V7ENITU47+QQC7rnWo8qgJZk8DX
   A==;
X-CSE-ConnectionGUID: i8MXDAvzTW6aB9U7D8AEPA==
X-CSE-MsgGUID: 83FeOSn9S0u9mV1hKqhQ6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11579"; a="72660435"
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="72660435"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 15:29:45 -0700
X-CSE-ConnectionGUID: 6aRIkqUKSgqrljdR0Y68Gg==
X-CSE-MsgGUID: VJALYLfTRNSHXLaG4Pa2/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="181682031"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 11 Oct 2025 15:29:40 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7i5p-00041T-2l;
	Sat, 11 Oct 2025 22:29:37 +0000
Date: Sun, 12 Oct 2025 06:28:42 +0800
From: kernel test robot <lkp@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Subject: Re: [PATCH 07/26] drm/xe/pf: Add support for encap/decap of
 bitstream to/from packet
Message-ID: <202510120631.vW6dpp07-lkp@intel.com>
References: <20251011193847.1836454-8-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011193847.1836454-8-michal.winiarski@intel.com>

Hi Michał,

kernel test robot noticed the following build warnings:

[auto build test WARNING on drm-xe/drm-xe-next]
[also build test WARNING on next-20251010]
[cannot apply to awilliam-vfio/next drm-i915/for-linux-next drm-i915/for-linux-next-fixes linus/master awilliam-vfio/for-linus v6.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Micha-Winiarski/drm-xe-pf-Remove-GuC-version-check-for-migration-support/20251012-034301
base:   https://gitlab.freedesktop.org/drm/xe/kernel.git drm-xe-next
patch link:    https://lore.kernel.org/r/20251011193847.1836454-8-michal.winiarski%40intel.com
patch subject: [PATCH 07/26] drm/xe/pf: Add support for encap/decap of bitstream to/from packet
config: riscv-randconfig-002-20251012 (https://download.01.org/0day-ci/archive/20251012/202510120631.vW6dpp07-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 39f292ffa13d7ca0d1edff27ac8fd55024bb4d19)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251012/202510120631.vW6dpp07-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510120631.vW6dpp07-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:272 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_read'
>> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:382 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_write'
>> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:467 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_save_init'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

