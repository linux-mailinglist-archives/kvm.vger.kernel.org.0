Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2CF1091F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 16:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfEAOcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 10:32:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:52078 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfEAOcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 10:32:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 May 2019 07:32:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,418,1549958400"; 
   d="scan'208";a="147376659"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2019 07:32:13 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hLqHM-00012y-Lt; Wed, 01 May 2019 22:32:12 +0800
Date:   Wed, 1 May 2019 22:31:18 +0800
From:   kbuild test robot <lkp@intel.com>
To:     KarimAllah Ahmed <karahmed@amazon.de>
Cc:     kbuild-all@01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 62/65] arch/x86/kernel/e820.c:88:9-10: WARNING: return of
 0/1 in function '_e820__mapped_any' with return type bool
Message-ID: <201905012215.o7C9GJrG%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   e9c16c78503dd0482b876761d60a3d2f50ac4d86
commit: 0c55671f84fffe591e8435c93a8c83286fd6b8eb [62/65] kvm, x86: Properly check whether a pfn is an MMIO or not

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> arch/x86/kernel/e820.c:88:9-10: WARNING: return of 0/1 in function '_e820__mapped_any' with return type bool

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
