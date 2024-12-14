Return-Path: <kvm+bounces-33826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B51019F2153
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 23:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4639B18871FB
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 22:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351A11B6CE0;
	Sat, 14 Dec 2024 22:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dizwexfw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763D87DA9C;
	Sat, 14 Dec 2024 22:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734216459; cv=none; b=Zpz4dFg9dFHg2VEM1ZFMi2E0SZghCjM0YYJO1Fty4rKCp7ZHhnzk02koAGgSHvEMJ2H47069eGTjFfoTsbmQPsVEngPfO2w9qelsLSu4SAcyzXad5qhEd9mhLbDrtaeYS1JJDcpwkWM5/aDAIcMrDkjr4G5zX6np929/Ju2gsEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734216459; c=relaxed/simple;
	bh=AKxRtbsHNV4cXXEwh68zgfEHkimry76rewwLYZhrLjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuTtudvcEQxgNlLfSV+ZpRrV8e8gkzL1KdC6TR/Ol/M/XayeMA2L7rxwab0+qDom4CKI6uqLg3tW8Jbk46KFmhpksu8Z7TBE9Hnm0rvmvAEUBA4g7EEGFSpnOlqPmPAJs8tEDtPiDLfOqifM7T+6CXvTAgBosgnkmMz69J6vmlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dizwexfw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734216457; x=1765752457;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AKxRtbsHNV4cXXEwh68zgfEHkimry76rewwLYZhrLjc=;
  b=dizwexfwZN8zALBhZUV8ET9Py6Vxoiz5we0qMKOVGj0vabriqSymMU6j
   KgX9AWKsKGEKdBl7jW8nNb6JgOCiS2QQIqA+9fpVK1FctkFiEtMpZ19LV
   rw2Y6caS8lvQnpekT54lcigBkP1qKq2B0g5YhO7XNB+A3WOCJWRY2qqJh
   VjTlx9wLx39bmugAPXJx2x6ijOXiIA+IkdNmszcvCujuxCH0ronT/odiW
   +u6kJypB/3Zu2pdxnN3X1bHVQqEMch9N3NqWH6g8IswvAqwAHwwtK0nMM
   Y51PhB4gcWPoJkzP5JN3KFoT0fiq1HgkfyC6r+/qBuRJUzEnb0i1kZRGh
   A==;
X-CSE-ConnectionGUID: 9PBOz4MkQmafGexfv94pIA==
X-CSE-MsgGUID: cG3xQD0tQ7O4ADP2q6I1Rg==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="45329652"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="45329652"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 14:47:36 -0800
X-CSE-ConnectionGUID: GKJobGtzR7membUQCuxeXw==
X-CSE-MsgGUID: IF8cd/2vSpiSpmThf6WLqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96705256"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Dec 2024 14:47:32 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tMav3-000DIU-13;
	Sat, 14 Dec 2024 22:47:29 +0000
Date: Sun, 15 Dec 2024 06:46:45 +0800
From: kernel test robot <lkp@intel.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, Wang@google.com,
	Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 10/13] KVM: selftests: Add KVM Userfault mode to
 demand_paging_test
Message-ID: <202412150600.wLk8rmZf-lkp@intel.com>
References: <20241204191349.1730936-11-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204191349.1730936-11-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build errors:

[auto build test ERROR on 4d911c7abee56771b0219a9fbf0120d06bdc9c14]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-Add-KVM_MEM_USERFAULT-memslot-flag-and-bitmap/20241205-032516
base:   4d911c7abee56771b0219a9fbf0120d06bdc9c14
patch link:    https://lore.kernel.org/r/20241204191349.1730936-11-jthoughton%40google.com
patch subject: [PATCH v1 10/13] KVM: selftests: Add KVM Userfault mode to demand_paging_test
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241215/202412150600.wLk8rmZf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412150600.wLk8rmZf-lkp@intel.com/

All errors (new ones prefixed by >>):

>> demand_paging_test.c:220:2: error: address argument to atomic operation must be a pointer to _Atomic type ('unsigned long *' invalid)
     220 |         atomic_fetch_and_explicit(bitmap_chunk,
         |         ^                         ~~~~~~~~~~~~
   /opt/cross/clang-ab51eccf88/lib/clang/19/include/stdatomic.h:169:35: note: expanded from macro 'atomic_fetch_and_explicit'
     169 | #define atomic_fetch_and_explicit __c11_atomic_fetch_and
         |                                   ^
   1 error generated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

