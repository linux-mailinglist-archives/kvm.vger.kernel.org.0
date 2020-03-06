Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE5717BBBD
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCFLcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:32:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:60709 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgCFLck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 06:32:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 03:32:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,521,1574150400"; 
   d="gz'50?scan'50,208,50";a="241146608"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 06 Mar 2020 03:32:31 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jABDT-000H7h-3y; Fri, 06 Mar 2020 19:32:31 +0800
Date:   Fri, 6 Mar 2020 19:32:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v5 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <202003061911.MfG74mgX%lkp@intel.com>
References: <20200304174947.69595-6-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20200304174947.69595-6-peterx@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tip/auto-latest]
[also build test ERROR on linus/master v5.6-rc4]
[cannot apply to kvm/linux-next linux/master vhost/linux-next next-20200305]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200305-053531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 6f2bc932d8ff72b1a0a5c66f3dad04ccba576a8b
config: s390-alldefconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/../../virt/kvm/kvm_main.o: In function `kvm_reset_dirty_gfn':
>> kvm_main.c:(.text+0x6a60): undefined reference to `kvm_arch_mmu_enable_log_dirty_pt_masked'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--oyUTqETQ0mS9luUI
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--oyUTqETQ0mS9luUI--
