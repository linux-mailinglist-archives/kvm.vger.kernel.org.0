Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040774D5F85
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 11:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347893AbiCKKdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 05:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbiCKKdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 05:33:08 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E0A1B8C80;
        Fri, 11 Mar 2022 02:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646994725; x=1678530725;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1aief/3/s2+LNVFmqBrg7W4OFyMyskfUiP8fctxmftM=;
  b=fdGNMloYkYWLDpgcE8yh55F/GN0h05Sk9NMxBFd7W2ul0H2LsrgaNTSl
   s4AHwc2tcefJ8j/abfQ0lR6sJPLYibfEbreej0nZ0rpNCAnm+vUHhhvqV
   hooY/qc/vNnTZ3w0ku7bQMq32agfR1MUaO2Arn75eNV1lDK+GSbpj6M3H
   9sMJUU3LhYTEMKmyOdbkTVMkGxVnt6Tz36zcRQvpTIOz/Fs5ZkJFGOyTb
   OByN5tM2/U5I/NLrroW/tnZOXlAQEmSFc1LqoNXjqDqnlru7cHVFf80kb
   J3ma+AVo4fxf6DksYDobrUu6dxp/cCU1/DoEpOJ/8T0vZMVSd+gJc8Teg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="341976359"
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="341976359"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 02:32:04 -0800
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="538955693"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 02:32:02 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 0/2] minor cleanups on efer emulation
Date:   Fri, 11 Mar 2022 18:26:41 +0800
Message-Id: <20220311102643.807507-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two patches remove some redundant code related to mode switch
and EFER emulation.

Sanity tested with kernel in L0, L1 and L2 all patched.

v2: Split to two patches and use comments from Sean to explain why
it's secure to remove them, suggested by Sean.

Zhenzhong Duan (2):
  KVM: x86: Remove unnecessory assignment to uret->data
  KVM: x86: Remove redundant vm_entry_controls_clearbit() call

 arch/x86/kvm/vmx/vmx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

-- 
2.25.1

