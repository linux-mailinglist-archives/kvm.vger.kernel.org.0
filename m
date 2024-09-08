Return-Path: <kvm+bounces-26088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6535F970A9A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 01:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00A6CB21312
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 23:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6607E17A922;
	Sun,  8 Sep 2024 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSL6FGc1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57983146D75;
	Sun,  8 Sep 2024 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725838211; cv=none; b=Nwki8Eivekoy+Ey9hGQ73IDgYav9DU+21Y7XKInmg1kieCHfmGxbUrO8mOnJo3dR7MkQgr28Sl/gp42gXgp8sBDCH4hWDWzyOBKEojmlOHmb6LBljL/4MiDXsgzRXLgiIHch23yO8pz+x9ksvszKwP9Ur9C3w/5DwkW2/TfqoSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725838211; c=relaxed/simple;
	bh=lUFLP2HRd2X2JjK7zXcxSdZ1fWTysYB1/qV2dk/l90g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3SKvhf80Gioh1UfpBN/YzzZ56BUKRQcU6dABtTt8tNup4mSSpa5HRYcE5/JrPkqGXaocbRKRI6qyC9Y0IjVE6ho5h/3epQVYHtArf4u3j7pENORDmP/Q7KP2OUIUgq2SgnCrnYj50CIcOLN/rC9QzZ68cohAbMOa6qlNPD4Gqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSL6FGc1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725838210; x=1757374210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lUFLP2HRd2X2JjK7zXcxSdZ1fWTysYB1/qV2dk/l90g=;
  b=lSL6FGc1LWpseWXNyU/FDJ7zo7svfTUIJLuM03/pQYZW7D9QPq5DGFBs
   /vFBvTrUrvoBhvOMsymarSLW3v5Y9QAk8Na9J+gOUJ1OXmuVitgEfXpvv
   kumKkeZoecVaURAOyEcQUbl96bVb5Cru6F5KTczTYbW8E3X+6OiDMustn
   ea/sMxlAYYME2d+ucYWmzrQOiKZ1IycPyuIA+aY4hOYqriKrzYPfPKig3
   HwoyX2wVD7jAuO7WBiVsrCt7XaZml+14qpSKHGYFDd3Cjk3oONouEHIBG
   fpgUJfl9x8j7tawI6IVGldpE8+RS1UYFtsK/t2s4mUdeuYThZGL+gcL1V
   w==;
X-CSE-ConnectionGUID: a5GPmlS+TRC111W2s8D7Sg==
X-CSE-MsgGUID: AArseYz7SWmS8PVO2CineA==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35865352"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="35865352"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 16:30:09 -0700
X-CSE-ConnectionGUID: 2X+0piqaSWWuIw4uykCLTg==
X-CSE-MsgGUID: sTse+OX3TmGFDwFevZbZXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66481156"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 08 Sep 2024 16:30:06 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1snRM4-000E4e-1A;
	Sun, 08 Sep 2024 23:30:04 +0000
Date: Mon, 9 Sep 2024 07:29:55 +0800
From: kernel test robot <lkp@intel.com>
To: Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
	pbonzini@redhat.com, dmatlack@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
Message-ID: <202409090949.xuOxMsJ2-lkp@intel.com>
References: <20240906204515.3276696-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906204515.3276696-3-vipinsh@google.com>

Hi Vipin,

kernel test robot noticed the following build errors:

[auto build test ERROR on 332d2c1d713e232e163386c35a3ba0c1b90df83f]

url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-x86-mmu-Track-TDP-MMU-NX-huge-pages-separately/20240907-044800
base:   332d2c1d713e232e163386c35a3ba0c1b90df83f
patch link:    https://lore.kernel.org/r/20240906204515.3276696-3-vipinsh%40google.com
patch subject: [PATCH v3 2/2] KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock
config: i386-randconfig-005-20240908 (https://download.01.org/0day-ci/archive/20240909/202409090949.xuOxMsJ2-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240909/202409090949.xuOxMsJ2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409090949.xuOxMsJ2-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: kvm_tdp_mmu_zap_possible_nx_huge_page
   >>> referenced by mmu.c:7415 (arch/x86/kvm/mmu/mmu.c:7415)
   >>>               arch/x86/kvm/mmu/mmu.o:(kvm_recover_nx_huge_pages) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

