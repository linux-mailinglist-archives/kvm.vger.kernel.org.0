Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7763E27B102
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgI1Phg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 11:37:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:3455 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgI1Phg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 11:37:36 -0400
IronPort-SDR: rllHz9qmaMor5eCYnzW9LDwGaT9i9dA3WOkSekOTGRk86IJ/f82fJ++f/xTQnGMCTtRNer+32Z
 yY+XWTbz1Okw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="161243340"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="161243340"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:37:35 -0700
IronPort-SDR: nw503zQt96GOU7yXMdfJ7+GJDrYRTySzeypEu0PgiXkkVvKgAWS1pN/Bq5L8Y8K/OyXTNnKhsv
 ADDikHVYygpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="350764144"
Received: from lkp-server01.sh.intel.com (HELO 0e0978ea3297) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 28 Sep 2020 08:37:33 -0700
Received: from kbuild by 0e0978ea3297 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kMvDY-0000L8-UP; Mon, 28 Sep 2020 15:37:32 +0000
Date:   Mon, 28 Sep 2020 23:37:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH kvm] KVM: VMX: vmx_uret_msrs_list[] can be static
Message-ID: <20200928153714.GA6285@a3a878002045>
References: <202009282300.GKb6ot6E%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009282300.GKb6ot6E%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: 14a61b642de9 ("KVM: VMX: Rename "vmx_msr_index" to "vmx_uret_msrs_list"")
Signed-off-by: kernel test robot <lkp@intel.com>
---
 vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 07781403db08a2..b20ef136894acc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -437,7 +437,7 @@ static unsigned long host_idt_base;
  * support this emulation, IA32_STAR must always be included in
  * vmx_uret_msrs_list[], even in i386 builds.
  */
-const u32 vmx_uret_msrs_list[] = {
+static const u32 vmx_uret_msrs_list[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
