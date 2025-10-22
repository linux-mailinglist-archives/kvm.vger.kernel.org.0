Return-Path: <kvm+bounces-60856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A4DBFE4F7
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 23:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E004F19A801D
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 21:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A747302CAC;
	Wed, 22 Oct 2025 21:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eAWO23LR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4B112B143;
	Wed, 22 Oct 2025 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761168448; cv=none; b=RiErbUgUJ2HW50d59742CvdJxajfWlk6cow43dbjBoG/Jv3RngFhVrnTMwLmZn8DkmsffqbuIacvXfxhw2OPzYT5KTnttnk/4pAWqHsBkesQZeoFsb7MLwSzpR058ulQS1GGCVyadHsrtuLmVLNh41S+ouJj9IfNM5Fvue/OQl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761168448; c=relaxed/simple;
	bh=WiMs1xpZodP+AahM3EmYiWvuRtlOth2p+dvocAU0+Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YktIdLJqtTZzjv6HiMTAfZZ5Emoo1rFcCSDTfK8HxgzlHdBkq1KlPCVq7030LqnFA5E/Eihlq2ptEsDOihyYZfbtEu7iMdCvHMy6Z6lvxYreg6NIhjWPbMeF2uVww0VOjWpwDBnhVuSyFKZD25y4aUEz55m8xWl8MiKbPjM0MmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eAWO23LR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761168446; x=1792704446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WiMs1xpZodP+AahM3EmYiWvuRtlOth2p+dvocAU0+Ps=;
  b=eAWO23LRSCZnKjJb4HLLnujfv2Qnv8M0qYYgx97bkq65nCrmTbLcWyaQ
   3BcjEjKr6xOHu0WVv41+uE602042vhR6qyWUlkC4dYAxnA2yL++UIyvqD
   Mo6AFkNgEgPOApY+1JDC23H3mv6KUkiYnY5StitYJH++iV+pPZu7K+bgs
   8yk+v0T7k4YMhEXgrfzMICUMo2OlOqfFpMlN6qILp6LbY9D1ncbNi4PWC
   s/imokez+LMKXoJUqKG4Cf2xuxjMZ8gTw2tROt4Wo7VmmzpztkXLhbf4d
   y23O78ZbwQxFeIidPlvI2xekVZWFisZbkMUQJ47hBqEOGDk+uKaklEayj
   Q==;
X-CSE-ConnectionGUID: CqneaFuDSZmJmPcyt5LcQQ==
X-CSE-MsgGUID: CBGuducgQve/k9OVhQKo6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63223498"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="63223498"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 14:27:26 -0700
X-CSE-ConnectionGUID: Hn3uYEjxSHWXFpHLNJbY2w==
X-CSE-MsgGUID: IlNYzEUUQVWqYLMCZCVVfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="189102196"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 22 Oct 2025 14:27:22 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBgMa-000Ck1-07;
	Wed, 22 Oct 2025 21:27:20 +0000
Date: Thu, 23 Oct 2025 05:27:01 +0800
From: kernel test robot <lkp@intel.com>
To: Hui Min Mina Chou <minachou@andestech.com>, anup@brainfault.org,
	atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, tim609@andestech.com,
	minachou@andestech.com, ben717@andestech.com, az70021@gmail.com
Subject: Re: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration
 to prevent stale entries
Message-ID: <202510230552.uCekjUFE-lkp@intel.com>
References: <20251021083105.4029305-1-minachou@andestech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021083105.4029305-1-minachou@andestech.com>

Hi Hui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next mst-vhost/linux-next linus/master v6.18-rc2 next-20251022]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Min-Mina-Chou/RISC-V-KVM-flush-VS-stage-TLB-after-VCPU-migration-to-prevent-stale-entries/20251021-163357
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251021083105.4029305-1-minachou%40andestech.com
patch subject: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration to prevent stale entries
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20251023/202510230552.uCekjUFE-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 754ebc6ebb9fb9fbee7aef33478c74ea74949853)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251023/202510230552.uCekjUFE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510230552.uCekjUFE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/riscv/kvm/vmid.c:126:6: warning: no previous prototype for function 'kvm_riscv_local_tlb_sanitize' [-Wmissing-prototypes]
     126 | void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
         |      ^
   arch/riscv/kvm/vmid.c:126:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     126 | void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
         | ^
         | static 
   1 warning generated.


vim +/kvm_riscv_local_tlb_sanitize +126 arch/riscv/kvm/vmid.c

   125	
 > 126	void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

