Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF77B564AAF
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 02:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiGDAJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 20:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDAJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 20:09:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B85F76
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 17:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656893383; x=1688429383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ej954QNIH0u8FquOmcQh7a2TY9lMp6G5ASe5JF4PW64=;
  b=St5UcrDMS0zHdq+6Ui1rh3xWXXhHBRPkkNvq9wxvHrmMAhxls1ZtBuyY
   Z66kTKkxlqDJlx/gI9J51gnfrTuvxseZpM2jxhg9tm8CK4oJvwkHKtgst
   aO3XQdob/LrU7OmWylAuq+7aMtvxwZg3q20NnkV7c0ky3PrYxt8hkZERg
   o+IX3AOH5vhJeJtbanOCY9Rcu6385hIoTb92w39ib+J2KDRmOo1eZrCuw
   HgeymwayN8uJwEy0CYE4KnjiHPQdzxPBZc4FCTQOmzEck/zkDKt9mMFnh
   o5rDeRPAcuZ8kK5VjrJw9Z9ssUtlIVSu6TXgJC/zzK48EG0L7HmdgUFpv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="281756605"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="281756605"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 17:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="919121977"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jul 2022 17:09:41 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o89em-000HBd-DU;
        Mon, 04 Jul 2022 00:09:40 +0000
Date:   Mon, 4 Jul 2022 08:09:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Don't deflect MSRs to userspace that can't
 be filtered
Message-ID: <202207040818.udTt0mLB-lkp@intel.com>
References: <20220703191636.2159067-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703191636.2159067-4-aaronlewis@google.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Aaron,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on next-20220701]
[cannot apply to mst-vhost/linux-next linus/master v5.19-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Aaron-Lewis/MSR-Filtering-updates/20220704-031727
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220704/202207040818.udTt0mLB-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5d787689b14574fe58ba9798563f4a6df6059fbf)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0c12a0d47fb511592df45bf2030cc200b5bab5ef
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Aaron-Lewis/MSR-Filtering-updates/20220704-031727
        git checkout 0c12a0d47fb511592df45bf2030cc200b5bab5ef
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:1715:6: error: no previous prototype for function 'kvm_msr_filtering_disallowed' [-Werror,-Wmissing-prototypes]
   bool kvm_msr_filtering_disallowed(u32 index)
        ^
   arch/x86/kvm/x86.c:1715:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool kvm_msr_filtering_disallowed(u32 index)
   ^
   static 
   1 error generated.


vim +/kvm_msr_filtering_disallowed +1715 arch/x86/kvm/x86.c

  1714	
> 1715	bool kvm_msr_filtering_disallowed(u32 index)
  1716	{
  1717		/* x2APIC MSRs do not support filtering. */
  1718		if (index >= 0x800 && index <= 0x8ff)
  1719			return true;
  1720	
  1721		return false;
  1722	}
  1723	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
