Return-Path: <kvm+bounces-56393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E16AEB3D21B
	for <lists+kvm@lfdr.de>; Sun, 31 Aug 2025 12:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54CAD189EA04
	for <lists+kvm@lfdr.de>; Sun, 31 Aug 2025 10:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A82253F2B;
	Sun, 31 Aug 2025 10:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9AqPRA/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80321E3DD7;
	Sun, 31 Aug 2025 10:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756636068; cv=none; b=jk0/xgqC5IsOzbiZQgm84Hn1RrsL/l4aQ1NUCoiFO85i+rx3Gvr4nnqIoiFstXjGwqriAoNMDnE8+KeIhOyYcRFf8OBfQ71cauu4saRSQCpZ1GTd9M6BxzYQdYzdyASee8z+riDo+xp1tD/GF9TBQI1CR4auT5XmM06u5voVVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756636068; c=relaxed/simple;
	bh=G3VUUUy+Z0eEDLbmnC2uWZmW+NftXH+FJS/0FINvCZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ed7/nEImxAfIyjD7/UgwlZVjnI0ZBGkuAcf+6KLBLGF09GE8qdrLJfylYq4CUogRUpqlXejzWjqoP0fsvOAMHVEKMilT5ZeqLu2KgsSuU/qmdunjS8t+D2YYgARhgmDFqtBpuCucWT5ps+tXZ7BJNpdfkmtoCd2m1aE2eFXpVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9AqPRA/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756636067; x=1788172067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G3VUUUy+Z0eEDLbmnC2uWZmW+NftXH+FJS/0FINvCZo=;
  b=e9AqPRA/vkBV/lz7FLBaNLxmuJfgwemMMHQqAZODxxxAmiqvvd8Jmvd3
   DXN9VoUCEkRcAZ2084HEjdX7gxAvXeN3X+IitBq+Xk+z4glCRCeVbAMuY
   nxcxiEA3g+3e7FrjHMW7Q7QezxYVg9Wqb080mS8bnpZcf4oYmRZsV8HBL
   tx/QjS915KW5CJqh1fg55p0FsdkoVBFcol2RNdwoqzGnEjg0fAN8ag1hT
   7fLXw9S2Al2+U/a9uoX3ed3u751gXIF7ng7BvCiOU2Vha6/yL0uPs2t1D
   q+XF8D3NIMH7+scNZsLmyfsNg2/H7ojZLcus1oPllbOeJtfo6PYmJyzGa
   Q==;
X-CSE-ConnectionGUID: +5Pqvr0gQF+fcwoZ8BExqg==
X-CSE-MsgGUID: hc6abGsRSQ6gLHbN9CNqPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="46429009"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="46429009"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 03:27:46 -0700
X-CSE-ConnectionGUID: XAOUGNalRseEqI7XAhA2rA==
X-CSE-MsgGUID: t8fpDd0QR+6w+3bfnX9N/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="169989735"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 31 Aug 2025 03:27:42 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usfH3-000W4p-1J;
	Sun, 31 Aug 2025 10:27:07 +0000
Date: Sun, 31 Aug 2025 18:26:08 +0800
From: kernel test robot <lkp@intel.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>,
	"david@redhat.com" <david@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, "Roy, Patrick" <roypat@amazon.co.uk>,
	"tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <202508311805.yfcdeaFC-lkp@intel.com>
References: <20250828093902.2719-4-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828093902.2719-4-roypat@amazon.co.uk>

Hi Patrick,

kernel test robot noticed the following build warnings:

[auto build test WARNING on a6ad54137af92535cfe32e19e5f3bc1bb7dbd383]

url:    https://github.com/intel-lab-lkp/linux/commits/Roy-Patrick/filemap-Pass-address_space-mapping-to-free_folio/20250828-174202
base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
patch link:    https://lore.kernel.org/r/20250828093902.2719-4-roypat%40amazon.co.uk
patch subject: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
config: loongarch-randconfig-r133-20250831 (https://download.01.org/0day-ci/archive/20250831/202508311805.yfcdeaFC-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.3.0
reproduce: (https://download.01.org/0day-ci/archive/20250831/202508311805.yfcdeaFC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508311805.yfcdeaFC-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/secretmem.c:155:39: sparse: sparse: symbol 'secretmem_aops' was not declared. Should it be static?

vim +/secretmem_aops +155 mm/secretmem.c

1507f51255c9ff Mike Rapoport           2021-07-07  154  
1507f51255c9ff Mike Rapoport           2021-07-07 @155  const struct address_space_operations secretmem_aops = {
46de8b979492e1 Matthew Wilcox (Oracle  2022-02-09  156) 	.dirty_folio	= noop_dirty_folio,
6612ed24a24273 Matthew Wilcox (Oracle  2022-05-02  157) 	.free_folio	= secretmem_free_folio,
5409548df3876a Matthew Wilcox (Oracle  2022-06-06  158) 	.migrate_folio	= secretmem_migrate_folio,
1507f51255c9ff Mike Rapoport           2021-07-07  159  };
1507f51255c9ff Mike Rapoport           2021-07-07  160  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

