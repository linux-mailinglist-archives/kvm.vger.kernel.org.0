Return-Path: <kvm+bounces-47510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 592F3AC1989
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FED017CC5E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518DA221571;
	Fri, 23 May 2025 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCkDZCdz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9A20DD5C;
	Fri, 23 May 2025 01:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962447; cv=none; b=Jahi2Twkr0fDCJWk8WErOArN4gwZhY94MAlMDSKk64KMZEekGJowlQ4JpNFJW7Ni89Wgm/2Q5VH96ZMlHhNf3mghNOsgTvoVXK/rVYJOk/joxuYzqYdLX4/HhU3/172WO8Oupoav/J4txH/KwLfQKhYcw9M7mGHmbebU9dzVJEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962447; c=relaxed/simple;
	bh=w9DtJ/Ec6NdrV3VRufCS8WfeJ21qaZi19s5/soSvQJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnAomO0EgNxdWEVR+uZYHrlo1qQmIJ8ATlmRBZXmaBOMBVq/MF6z5QPbigLqejaDS0kWql9lvQ0LrVGl6BBhq0/GbA/dtGU4KD2wEqo9dNwpSaY0lcUFitt/4uAa6v6CFoRxhvg8NjO7x2CZb0wieyv5Z2Pcv9PEENepsLSOWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCkDZCdz; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747962446; x=1779498446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w9DtJ/Ec6NdrV3VRufCS8WfeJ21qaZi19s5/soSvQJo=;
  b=FCkDZCdzjUNt/EvTRkfZvKPIyL2jPcDjXsKoyKbUWZSLNsaCfyehyOnh
   r8PePVcoE7uzwXE4lzok3rFt46yRqEBjmbO1fnM+qrncWUGwT2Sn21j2V
   dPBWoHjoAD/KhGcOscO1V7h8Fla/XnEU8Gl1BBngRin9SLlzy9bNOTcnC
   nQZwGvuFWsPwCLZ+ImtAAauzic8rFTuGkfHZ37QpOP3q+fM+3UcDGXVlW
   y2hN/J/Dpzd+yyd2DFzfZQAn2rCvScUVWSCfNPgwROjvvzQlxR2W3ca3W
   /iHiGkS6oWHWcqTCiHOR1BGReQGSDi+kH1pfCEPH64sJ/+LeR++Fg0ogo
   w==;
X-CSE-ConnectionGUID: ZbT0D0JtTiG9C2/l5FVBsg==
X-CSE-MsgGUID: CiIgomToRWSi7ppES484Tw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50158448"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="50158448"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 18:07:25 -0700
X-CSE-ConnectionGUID: kc9Qse5SQIuRChyaR9R6hA==
X-CSE-MsgGUID: zSFq8ZiPTLWPgdCBJjrS/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="171831188"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 22 May 2025 18:03:46 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uIGp6-000Ppq-1D;
	Fri, 23 May 2025 01:03:44 +0000
Date: Fri, 23 May 2025 09:03:43 +0800
From: kernel test robot <lkp@intel.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, frankja@linux.ibm.com,
	borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
	nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
	agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
	schlameuss@linux.ibm.com
Subject: Re: [PATCH v3 3/4] KVM: s390: refactor and split some gmap helpers
Message-ID: <202505230839.LAF8wtzO-lkp@intel.com>
References: <20250522132259.167708-4-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522132259.167708-4-imbrenda@linux.ibm.com>

Hi Claudio,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvms390/next]
[also build test WARNING on s390/features kvm/queue kvm/next mst-vhost/linux-next linus/master v6.15-rc7 next-20250522]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Claudio-Imbrenda/s390-remove-unneeded-includes/20250522-212623
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git next
patch link:    https://lore.kernel.org/r/20250522132259.167708-4-imbrenda%40linux.ibm.com
patch subject: [PATCH v3 3/4] KVM: s390: refactor and split some gmap helpers
config: s390-randconfig-001-20250523 (https://download.01.org/0day-ci/archive/20250523/202505230839.LAF8wtzO-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250523/202505230839.LAF8wtzO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505230839.LAF8wtzO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/s390/mm/gmap_helpers.c: In function 'ptep_zap_swap_entry':
   arch/s390/mm/gmap_helpers.c:26:7: error: implicit declaration of function 'non_swap_entry'; did you mean 'init_wait_entry'? [-Werror=implicit-function-declaration]
     if (!non_swap_entry(entry))
          ^~~~~~~~~~~~~~
          init_wait_entry
   arch/s390/mm/gmap_helpers.c:28:11: error: implicit declaration of function 'is_migration_entry'; did you mean 'list_first_entry'? [-Werror=implicit-function-declaration]
     else if (is_migration_entry(entry))
              ^~~~~~~~~~~~~~~~~~
              list_first_entry
   arch/s390/mm/gmap_helpers.c:29:33: error: implicit declaration of function 'pfn_swap_entry_folio'; did you mean 'filemap_dirty_folio'? [-Werror=implicit-function-declaration]
      dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
                                    ^~~~~~~~~~~~~~~~~~~~
                                    filemap_dirty_folio
>> arch/s390/mm/gmap_helpers.c:29:33: warning: passing argument 1 of 'mm_counter' makes pointer from integer without a cast [-Wint-conversion]
      dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/s390/mm/gmap_helpers.c:9:
   include/linux/mm.h:2725:44: note: expected 'struct folio *' but argument is of type 'int'
    static inline int mm_counter(struct folio *folio)
                                 ~~~~~~~~~~~~~~^~~~~
   arch/s390/mm/gmap_helpers.c:30:2: error: implicit declaration of function 'free_swap_and_cache'; did you mean 'free_pgd_range'? [-Werror=implicit-function-declaration]
     free_swap_and_cache(entry);
     ^~~~~~~~~~~~~~~~~~~
     free_pgd_range
   arch/s390/mm/gmap_helpers.c: In function 'gmap_helper_zap_one_page':
   arch/s390/mm/gmap_helpers.c:60:27: error: implicit declaration of function 'pte_to_swp_entry'; did you mean 'ptep_zap_swap_entry'? [-Werror=implicit-function-declaration]
      ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
                              ^~~~~~~~~~~~~~~~
                              ptep_zap_swap_entry
   arch/s390/mm/gmap_helpers.c:60:27: error: incompatible type for argument 2 of 'ptep_zap_swap_entry'
      ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
                              ^~~~~~~~~~~~~~~~~~~~~~~
   arch/s390/mm/gmap_helpers.c:24:67: note: expected 'swp_entry_t' {aka 'struct <anonymous>'} but argument is of type 'int'
    static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
                                                          ~~~~~~~~~~~~^~~~~
   cc1: some warnings being treated as errors
--
>> arch/s390/mm/gmap.c:2251:33: warning: 'find_zeropage_ops' defined but not used [-Wunused-const-variable=]
    static const struct mm_walk_ops find_zeropage_ops = {
                                    ^~~~~~~~~~~~~~~~~


vim +/mm_counter +29 arch/s390/mm/gmap_helpers.c

    14	
    15	/**
    16	 * ptep_zap_swap_entry() - discard a swap entry.
    17	 * @mm: the mm
    18	 * @entry: the swap entry that needs to be zapped
    19	 *
    20	 * Discards the given swap entry. If the swap entry was an actual swap
    21	 * entry (and not a migration entry, for example), the actual swapped
    22	 * page is also discarded from swap.
    23	 */
    24	static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
    25	{
    26		if (!non_swap_entry(entry))
    27			dec_mm_counter(mm, MM_SWAPENTS);
    28		else if (is_migration_entry(entry))
  > 29			dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
    30		free_swap_and_cache(entry);
    31	}
    32	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

