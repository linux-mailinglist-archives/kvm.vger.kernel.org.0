Return-Path: <kvm+bounces-28669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BA499B137
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 08:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17DE51F2313E
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 06:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6383612DD88;
	Sat, 12 Oct 2024 06:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tjmwf6fO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B6883CDB;
	Sat, 12 Oct 2024 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728713584; cv=none; b=R5xde2AiKsm190MnPRL4Kwp0UGR0iKicRZIrQTbrDoHh2bobuIlwEYsdH2CucR4HKPlMJSA9Z8PJVVCYI/uzX6x8Z+RdshEo8Hn4ai10GAzuRCN9Ja/IdEAt3ocONsa3obcEk8qJa+7NtXE6PR2DWDuZvdKfeduVjzjO25sLnH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728713584; c=relaxed/simple;
	bh=m42CQk4y980tF4qvboDX1NWtreWtA3r69nSD6YFedPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6Ee+seyCBwU1iIcXfw7LtNqaBi/0CK7ZWgFiv8R+rXhgMKxPHoIuQa48ZSq2jkn7x11vJk5altd0Z8tEaPmPAgDNdUO+czOVqQ1p8HiCGJkUzcIz1qATOTLOV5q6P0jlZsR/66e8U5W9el4MftNHo/o/UXpqir1UCT2CVWzntM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tjmwf6fO; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728713583; x=1760249583;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m42CQk4y980tF4qvboDX1NWtreWtA3r69nSD6YFedPk=;
  b=Tjmwf6fOn9NYHRDRKiC7OWieSgWUwjg+UtwmYm1egS1YYLZVsozW83Yo
   e8jwfJxhXRdVtaHtO1JHaCECjjkEVVrgEiHXXI8e1Xf3+98Tob7Oq1Qw0
   gjvKMv+vAoq/NOqyE0pSv6pM5o8AnBIHSilvylRTlnNnu6dcUcOJ7js8R
   Xf5g6mKKM5Zzf0KcPJT3wOIkWUvOme8WnMoOS1kme9qyGqCxamFFTHNwS
   ZLEnxDWTqSqU6y3OTDeNXpwGURzrUSxLaystbJXpPX32e42XP2bcUmxRF
   OyWjhTDNfcmw5WEr/1zCRt5S19BDMmTZXpYh+f12g7BUfE2e7EdDd9fAc
   g==;
X-CSE-ConnectionGUID: pXrpc4jSS1O6zTAKJOch+g==
X-CSE-MsgGUID: o/Rlx5auQemFUeNSY91DHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="38684798"
X-IronPort-AV: E=Sophos;i="6.11,197,1725346800"; 
   d="scan'208";a="38684798"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 23:13:02 -0700
X-CSE-ConnectionGUID: oyxCgg7mQ/qA1YxHM2sphQ==
X-CSE-MsgGUID: m1D1bpIJQ0mWI69VJg+KRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,197,1725346800"; 
   d="scan'208";a="77202878"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 11 Oct 2024 23:12:54 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1szVMy-000D6d-0H;
	Sat, 12 Oct 2024 06:12:52 +0000
Date: Sat, 12 Oct 2024 14:12:36 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com
Subject: Re: [PATCH v3 01/11] KVM: guest_memfd: Make guest mem use guest mem
 inodes instead of anonymous inodes
Message-ID: <202410121337.0ETimfvJ-lkp@intel.com>
References: <20241010085930.1546800-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010085930.1546800-2-tabba@google.com>

Hi Fuad,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b]

url:    https://github.com/intel-lab-lkp/linux/commits/Fuad-Tabba/KVM-guest_memfd-Make-guest-mem-use-guest-mem-inodes-instead-of-anonymous-inodes/20241010-170821
base:   8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
patch link:    https://lore.kernel.org/r/20241010085930.1546800-2-tabba%40google.com
patch subject: [PATCH v3 01/11] KVM: guest_memfd: Make guest mem use guest mem inodes instead of anonymous inodes
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20241012/202410121337.0ETimfvJ-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241012/202410121337.0ETimfvJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410121337.0ETimfvJ-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "security_inode_init_security_anon" [arch/x86/kvm/kvm.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

