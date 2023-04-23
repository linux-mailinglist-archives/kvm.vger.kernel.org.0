Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023D16EBE70
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 12:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDWKLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 06:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDWKLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 06:11:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5ED19B0
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682244679; x=1713780679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G6qg4fvI7B3WrbISzi0JWpHcurYs084lVPk+UzzSSTE=;
  b=DHxB3OcPzp/X0RrZZVrxkWuNGkn9PAjJo4zwnQnFaERS7r8EMsTk8zSb
   YXF6dIFeoDxVlhDSEyZOY9sqn90vFusvBWaNw91ve/z9aBFqz9/78dPS6
   hzeI0fZlTz8xf1ZL7ZN08mQsDb9miswQD/6hYl8fmCDGa0CrT9wmlrCjc
   TKRVqCqP7HEKtv+jDs3XeL/GdkthZvKt21qSVrHyaM6tic6g4GuUHZBjM
   L0SJfRb5OtnNeLKdM73ED3d5Ham6HUimSvTRrR3J6aJtOfz8XMauo3gAE
   CpuUFSSpOQDmDDaHSGZXKHq0/uLFy4pzXCc3qU3Zg9+L2xmCuXY8Dg25i
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="348173930"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="348173930"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 03:11:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="938974050"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="938974050"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.214.112])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 03:11:16 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com
Subject: [PATCH 0/2] KVM: Fix some comments
Date:   Sun, 23 Apr 2023 18:11:10 +0800
Message-Id: <20230423101112.13803-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix comments for KVM_ENABLE_CAP.
Update msrs_to_save_all to msrs_to_save_base in comments.
Fix a typo in x86/mmu.rst

Binbin Wu (2):
  KVM: Fix comments for KVM_ENABLE_CAP
  KVM: x86: Fix some comments

 Documentation/virt/kvm/x86/mmu.rst | 2 +-
 arch/x86/kvm/x86.c                 | 4 ++--
 include/uapi/linux/kvm.h           | 2 +-
 tools/include/uapi/linux/kvm.h     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)


base-commit: cf9f4c0eb1699d306e348b1fd0225af7b2c282d3
-- 
2.25.1

