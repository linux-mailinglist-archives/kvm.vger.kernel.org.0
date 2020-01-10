Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E50D1375E4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 19:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAJSLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 13:11:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:13850 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbgAJSLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 13:11:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 10:11:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="231653977"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jan 2020 10:11:35 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ipykw-0008vF-K4; Sat, 11 Jan 2020 02:11:34 +0800
Date:   Sat, 11 Jan 2020 02:10:50 +0800
From:   kbuild test robot <lkp@intel.com>
To:     weiqi <weiqi4@huawei.com>
Cc:     kbuild-all@lists.01.org, alexander.h.duyck@linux.intel.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        wei qi <weiqi4@huawei.com>
Subject: Re: [PATCH 1/2] vfio: add mmap/munmap API for page hinting
Message-ID: <202001110208.6GCxeDRv%lkp@intel.com>
References: <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi weiqi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on vfio/next vhost/linux-next v5.5-rc5 next-20200109]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/weiqi/page-hinting-add-passthrough-support/20200108-152941
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/vfio/vfio_iommu_type1.c:1275:5: sparse: sparse: symbol 'vfio_iommu_iova_to_phys' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
