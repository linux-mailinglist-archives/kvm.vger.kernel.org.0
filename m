Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E2CF6212
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2019 03:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfKJCAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 21:00:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:23928 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfKJCAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 21:00:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Nov 2019 18:00:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,286,1569308400"; 
   d="scan'208";a="197296366"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 09 Nov 2019 18:00:44 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iTcWy-000AP2-8Q; Sun, 10 Nov 2019 10:00:44 +0800
Date:   Sun, 10 Nov 2019 09:59:56 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
Message-ID: <201911100903.YIxR3HeI%lkp@intel.com>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Wanpeng,

I love your patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on v5.4-rc6 next-20191108]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Wanpeng-Li/KVM-X86-Single-target-IPI-fastpath/20191110-081303
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> arch/x86/kvm/vmx/vmx.c:6509:3-4: Unneeded semicolon
   arch/x86/kvm/vmx/vmx.c:6510:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
