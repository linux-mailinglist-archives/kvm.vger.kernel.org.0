Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C247707C87
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjERJN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjERJNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:13:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CDF1FE5
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 02:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684401224; x=1715937224;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=opQCEcQaboUKMPopDxsMLuvqYQtVkW5T1IFEGqovO/o=;
  b=aEOhdJXXtJgwDcwkrR/BInylOmVmaBdUEw00Odnm62ebhoh0SBJOhLgI
   CYiLnJu06NN4Q/D4Be6CdFbK06OkqYPwYTtQNKCAOlM2EO+LyFPCPHBXH
   kb5wPiWSniI+5IgbJVLrIotR2rzetJASPEysciQKp2xt62cPzbRHmxiHg
   lvPXztB/179dI1FOgJZGyhG9ItTrY+McbcdVz4aVXpw4+9+BuCPc3m6La
   KwTYOtSaPhTqlvKx5UiThI7WH4gTmlUEClvQf/uBGjucjB2O0SpBkb3cw
   +BH2WEBRtaDY+PjiMwuoONel363tqN9DqGT9cxh+rPBcQOC22r37tp2cs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="332382996"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="332382996"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="735006628"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="735006628"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.101])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:42 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com
Subject: [PATCH v2 0/3] KVM: Fix some comments
Date:   Thu, 18 May 2023 17:13:36 +0800
Message-Id: <20230518091339.1102-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix comments for KVM_ENABLE_CAP.
Update msrs_to_save_all to msrs_to_save_base in comments.
Fix a typo in x86/mmu.rst

---
Changelog:
v1 --> v2: 
Add changelog in patch 1 to explain the modification, and drop the tools/ change.
Split the change of x86/mmu.rst to a separate patch.

Binbin Wu (3):
  KVM: Fix comment for KVM_ENABLE_CAP
  KVM: x86: Fix comments that refer to the out-dated msrs_to_save_all
  KVM: Documentation: Fix a typo in Documentation/virt/kvm/x86/mmu.rst

 Documentation/virt/kvm/x86/mmu.rst | 2 +-
 arch/x86/kvm/x86.c                 | 4 ++--
 include/uapi/linux/kvm.h           | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)


base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
-- 
2.25.1

