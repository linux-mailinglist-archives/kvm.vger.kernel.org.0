Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB71E8B323
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfHMI47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:56:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:31262 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfHMI47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:56:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 01:39:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="gz'50?scan'50,208,50";a="351472355"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 13 Aug 2019 01:39:01 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hxSKb-0001DL-BA; Tue, 13 Aug 2019 16:39:01 +0800
Date:   Tue, 13 Aug 2019 16:39:00 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kbuild-all@01.org, nitesh@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v5 4/6] mm: Introduce Reported pages
Message-ID: <201908131654.NqyZiEQm%lkp@intel.com>
References: <20190812213344.22097.86213.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2lwoaplyqgzmgqg6"
Content-Disposition: inline
In-Reply-To: <20190812213344.22097.86213.stgit@localhost.localdomain>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--2lwoaplyqgzmgqg6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexander,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[cannot apply to v5.3-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/mm-virtio-Provide-support-for-unused-page-reporting/20190813-150543
config: riscv-tinyconfig (attached as .config)
compiler: riscv64-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=riscv 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/mmzone.h:774:0,
                    from include/linux/gfp.h:6,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from include/linux/module.h:13,
                    from init/main.c:17:
>> include/linux/page_reporting.h:8:10: fatal error: asm/pgtable_types.h: No such file or directory
    #include <asm/pgtable_types.h>
             ^~~~~~~~~~~~~~~~~~~~~
   compilation terminated.

vim +8 include/linux/page_reporting.h

     4	
     5	#include <linux/mmzone.h>
     6	#include <linux/jump_label.h>
     7	#include <linux/pageblock-flags.h>
   > 8	#include <asm/pgtable_types.h>
     9	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--2lwoaplyqgzmgqg6
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--2lwoaplyqgzmgqg6--
