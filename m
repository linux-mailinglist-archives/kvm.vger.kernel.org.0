Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595107BC204
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 00:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjJFWHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 18:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbjJFWHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 18:07:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EC2BF
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 15:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696630056; x=1728166056;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t1x24j0lHrp8WyR8NHLzBBuT0ffgppJLPGy2F6ORmiE=;
  b=f1FHg4voiBBXgds/0OZxDuBwRfjSBMVEaGrPEMiX6DI9PUz9qjTzmExr
   pBcR1ha4T+X18nGC3khVq7CnLhNQpdA4nfX5zmPCj72sz7wGHIz6RLhfL
   6eqtaYKKG+l7hPbjPwV98Xr5RCmR43E0qENX5Q9lqjvQbj7SO7D6LwYrH
   XrCWA1CB+Y7IemPRlzfNvkXIeD6BUqhNnYDdc3ABBWnjyKYZRgv4vO8l5
   8K+YjpHcclx6zNiVdWb/kO555+FKAJ2vDf0Qv/g4fVmPhPj1Urlj77z86
   +Lf9uxQmeBfXtRdJF/q0TM/iLIJG1rs1wFEu7RIC4t9cxm8AT9PAwva8b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="448037905"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="448037905"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 15:07:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="781789537"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="781789537"
Received: from lkp-server01.sh.intel.com (HELO 8a3a91ad4240) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 06 Oct 2023 15:07:34 -0700
Received: from kbuild by 8a3a91ad4240 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qosyp-0003gj-36;
        Fri, 06 Oct 2023 22:07:31 +0000
Date:   Sat, 7 Oct 2023 06:06:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/3] KVM: arm64: Rename helpers for VHE vCPU load/put
Message-ID: <202310070514.3iAWEi1d-lkp@intel.com>
References: <20231006093600.1250986-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006093600.1250986-3-oliver.upton@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6465e260f48790807eef06b583b38ca9789b6072]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-Don-t-zero-VTTBR-in-__tlb_switch_to_host/20231006-173738
base:   6465e260f48790807eef06b583b38ca9789b6072
patch link:    https://lore.kernel.org/r/20231006093600.1250986-3-oliver.upton%40linux.dev
patch subject: [PATCH 2/3] KVM: arm64: Rename helpers for VHE vCPU load/put
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20231007/202310070514.3iAWEi1d-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231007/202310070514.3iAWEi1d-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310070514.3iAWEi1d-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/arm64/kvm/hyp/vhe/sysreg-sr.c:109: warning: expecting prototype for __vcpu_put_switch_syregs(). Prototype was for __vcpu_put_switch_sysregs() instead


vim +109 arch/arm64/kvm/hyp/vhe/sysreg-sr.c

13aeb9b400c5d7 David Brazdil 2020-06-25   96  
13aeb9b400c5d7 David Brazdil 2020-06-25   97  /**
129fe154f5bca6 Oliver Upton  2023-10-06   98   * __vcpu_put_switch_syregs - Restore host system registers to the physical CPU
13aeb9b400c5d7 David Brazdil 2020-06-25   99   *
13aeb9b400c5d7 David Brazdil 2020-06-25  100   * @vcpu: The VCPU pointer
13aeb9b400c5d7 David Brazdil 2020-06-25  101   *
13aeb9b400c5d7 David Brazdil 2020-06-25  102   * Save guest system registers that do not affect the host's execution, for
13aeb9b400c5d7 David Brazdil 2020-06-25  103   * example EL1 system registers on a VHE system where the host kernel
13aeb9b400c5d7 David Brazdil 2020-06-25  104   * runs at EL2.  This function is called from KVM's vcpu_put() function
13aeb9b400c5d7 David Brazdil 2020-06-25  105   * and deferring saving system register state until we're no longer running the
13aeb9b400c5d7 David Brazdil 2020-06-25  106   * VCPU avoids having to save them on every exit from the VM.
13aeb9b400c5d7 David Brazdil 2020-06-25  107   */
129fe154f5bca6 Oliver Upton  2023-10-06  108  void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
13aeb9b400c5d7 David Brazdil 2020-06-25 @109  {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
