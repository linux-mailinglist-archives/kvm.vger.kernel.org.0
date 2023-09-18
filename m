Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB797A45DC
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbjIRJ0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 05:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbjIRJ0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:26:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0F110D;
        Mon, 18 Sep 2023 02:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695029170; x=1726565170;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m3S2iJ6j3tD+50xgQRW0LmCvHsaXc0Bmt3ebkzB3hxc=;
  b=jFyqJg82kEzW4hOKu4XIr8gI7MTQ+ddLMbJ8Wn3LcPgKS1Vb6QD3vFLd
   TERxrpqkPhbN8ZDeBTd7FTJCE45nayKH2YcXPF6V/AMwX+IhEr9TyHe8E
   XpsK2Xjg3RR0Xyae/ecWQg5uUtp/BbgpI7iUxbykWpIgRWevrtMYW9YAL
   h3sC44DiML6ShKK2MCgust/LbcS/hKMXhvULFP/obpgwieGCJqJiSuwTP
   Zkp1TAMme91Hkcr4/4Kxoe1frTJoNKY2oTYPf4A6JpbaaCF35ahA2XhRU
   gfDUSCmBeO8N8GTcvdRmF6Wvt+Okp6IlnzxbOzHBy/xH1k/+YA4a95hjV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="383430574"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="383430574"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 02:26:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="811288402"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="811288402"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2023 02:26:06 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qiAW4-0005zN-0S;
        Mon, 18 Sep 2023 09:26:04 +0000
Date:   Mon, 18 Sep 2023 17:25:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Subject: Re: [PATCH 7/8] KVM: xen: prepare for using 'default' vcpu_info
Message-ID: <202309181725.cpTHcjo6-lkp@intel.com>
References: <20230914084946.200043-8-paul@xen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914084946.200043-8-paul@xen.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paul,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next linus/master v6.6-rc2 next-20230918]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Durrant/KVM-pfncache-add-a-map-helper-function/20230914-171017
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230914084946.200043-8-paul%40xen.org
patch subject: [PATCH 7/8] KVM: xen: prepare for using 'default' vcpu_info
config: i386-randconfig-063-20230918 (https://download.01.org/0day-ci/archive/20230918/202309181725.cpTHcjo6-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230918/202309181725.cpTHcjo6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309181725.cpTHcjo6-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/xen.c:492:25: sparse: sparse: symbol 'get_vcpu_info_cache' was not declared. Should it be static?
   arch/x86/kvm/xen.c:441:9: sparse: sparse: context imbalance in 'kvm_xen_update_runstate_guest' - unexpected unlock

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
