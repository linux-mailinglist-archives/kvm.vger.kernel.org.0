Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2CD1E611A
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 07:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfJ0GZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 02:25:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:39182 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfJ0GZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 02:25:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2019 23:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,235,1569308400"; 
   d="scan'208";a="373934135"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 26 Oct 2019 23:25:54 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iObzu-000J6M-7d; Sun, 27 Oct 2019 14:25:54 +0800
Date:   Sun, 27 Oct 2019 14:24:55 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: Re: [PATCH 2/6] vfio/mdev: Add "aggregation" attribute for supported
 mdev type
Message-ID: <201910271446.6kfLp0a2%lkp@intel.com>
References: <20191024050829.4517-3-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024050829.4517-3-zhenyuw@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhenyu,

I love your patch! Perhaps something to improve:

[auto build test WARNING on vfio/next]
[also build test WARNING on v5.4-rc4 next-20191025]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Zhenyu-Wang/VFIO-mdev-aggregated-resources-handling/20191027-111736
base:   https://github.com/awilliam/linux-vfio.git next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/vfio/mdev/mdev_sysfs.c:96:1: sparse: sparse: symbol 'mdev_type_attr_create' was not declared. Should it be static?
>> drivers/vfio/mdev/mdev_sysfs.c:108:1: sparse: sparse: symbol 'mdev_type_attr_aggregation' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
