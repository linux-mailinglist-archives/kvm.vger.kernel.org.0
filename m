Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2160651962B
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344443AbiEDD4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiEDD4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:56:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2D617E1A
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651636380; x=1683172380;
  h=from:to:cc:subject:date:message-id;
  bh=wd44rRVb/i4J5AyXfR4P9VxC1F2rC12gMIvhn3rbB2k=;
  b=injGyAfa+bsBviiao2v8lq3nU6g7INOzbyXLY58MW/zfMUTHV2DX/FIm
   RItr6QF9WZjKkILxQb+Pbeu35uxZsgskuKi8bzQMiJ4oUHMELUzDX3Hzm
   /cXNSDqUs4H0DmNfVwfRpp/T9aZwfRa+KAeuzOT/MKnJE7zQXRZFcpT2b
   6q/OujPeaBKysrNxzX5Dqc+MowJz+HWTlwjZeDgVG1NZvdUpaTqEjORiv
   mxCDePoUHHEUgT5Xdb0ng3Cd67b/cKyswVxOrZ5CKNCT1FwwLGohQ/D0k
   694/5X2YJeC0rYpeKyEuFPJi3e2POEC6X4q6jHAWNJ4f1kj+DDOSdiCFG
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267534994"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267534994"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 20:52:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="562533847"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 20:52:57 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Chen Farrah <farrah.chen@intel.com>,
        Wei Danmei <danmei.wei@intel.com>
Subject: [PATCH] KVM: VMX: Fix build error on claim of vmx_get_pid_table_order()
Date:   Wed,  4 May 2022 11:21:02 +0800
Message-Id: <20220504032102.15062-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change function claim to static.
Report warning: no previous prototype for 'vmx_get_pid_table_order'
[-Wmissing-prototypes].

Fixes: 101c99f6506d ("KVM: VMX: enable IPI virtualization")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
Paolo, could you please merge this fix into commit 101c99f6506d ("KVM:
VMX: enable IPI virtualization") in kvm/queue? Sorry for such mistake.

 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bb09fc9a7e55..2065babb2c9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4402,7 +4402,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
-int vmx_get_pid_table_order(struct kvm *kvm)
+static int vmx_get_pid_table_order(struct kvm *kvm)
 {
 	return get_order(kvm->arch.max_vcpu_ids * sizeof(*to_kvm_vmx(kvm)->pid_table));
 }
-- 
2.27.0

