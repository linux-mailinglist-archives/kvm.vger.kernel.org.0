Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7937C1C114A
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 13:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgEALBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 07:01:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:65078 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbgEALBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 07:01:02 -0400
IronPort-SDR: a+jFt85Z/c096X9Kp3QNFwXYLCdgsF1KBx+4OpHtelITjplIo5lNjmiuRMSWwW+ckvJ+w5OUIP
 6khOjEu5cWMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 04:01:01 -0700
IronPort-SDR: wi6bVWscm90jt3UpQTeCkn/GMAZLCLnoaX3+5FU5/LGQ69PsVu4/ew0Juu5nYtHZjpB8Jjv2gx
 MeBffHVmTUsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,339,1583222400"; 
   d="scan'208";a="248526372"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 04:00:59 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jUTPe-0003Dr-FN; Fri, 01 May 2020 19:00:58 +0800
Date:   Fri, 1 May 2020 19:00:37 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     kbuild-all@lists.01.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86/paravirt: kvm_sev_migration_hcall() can be static
Message-ID: <20200501110036.GA54286@c61ca2aeffc5>
References: <d0e5e3227e24272ec5f277e6732c5e0a1276d4e1.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0e5e3227e24272ec5f277e6732c5e0a1276d4e1.1588234824.git.ashish.kalra@amd.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Signed-off-by: kbuild test robot <lkp@intel.com>
---
 kvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 928ddb8a8cfc7..884ba9203d3b4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -730,8 +730,8 @@ static void __init kvm_init_platform(void)
 }
 
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
-long kvm_sev_migration_hcall(unsigned long physaddr, unsigned long npages,
-			     bool enc)
+static long kvm_sev_migration_hcall(unsigned long physaddr, unsigned long npages,
+				    bool enc)
 {
 	return kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS, physaddr, npages,
 				  enc);
