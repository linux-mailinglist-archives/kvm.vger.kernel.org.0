Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08EA595C86
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiHPM6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiHPM6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 08:58:15 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D5D2B62E;
        Tue, 16 Aug 2022 05:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660654690; x=1692190690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EVmXSV+NXLVHhZ0uXjBEy/9GC9MKD+VgS7o0uakK9K4=;
  b=f6fMuxNJFutfJyHZt4KhVxWcOnrWilHynOv8eSGwFR4CnOCUTsyMWDr/
   9zFlHKSvHh4qpPPOOPuNCHDirNta/ZEzKTRJWo5Tg8c8QA+bpv5cUX27n
   HZjA/Pc8y9vLAmUYUGlDB0wiTBG4Hmn7i004g77ut2ShNyKLs2GJhIZ8i
   am7fi/FTuaoIu/V66XwctzLBGi0UYvv71BaTRErvixly2kXYCAh0Sl4OK
   Nu3yPfrVPLDVEnJKuFn8BaYX2mko4fPn0LHVaM5BiHTekoZqDQqrsiBjl
   RK11hf3SDncSwFUKymSf31aujb9NbAbTp+6pqUmt+ARSkXP7KwsxZKk92
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279170176"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="279170176"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="667099391"
Received: from chaop.bj.intel.com ([10.240.193.75])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2022 05:58:06 -0700
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Preparation for fd-based guest private memory
Date:   Tue, 16 Aug 2022 20:53:20 +0800
Message-Id: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two are separated from fd-based guest private memory v7
(https://lkml.org/lkml/2022/7/6/253) and include pure renaming
preparation for that whole patchset.

Send it separately here with wish it can make review/merge easier.

There is no functional change for these two patches.

Chao Peng (2):
  KVM: Rename KVM_PRIVATE_MEM_SLOTS to KVM_INTERNAL_MEM_SLOTS
  KVM: Rename mmu_notifier_* to mmu_invalidate_*

 arch/arm64/kvm/mmu.c                     |  8 +--
 arch/mips/include/asm/kvm_host.h         |  2 +-
 arch/mips/kvm/mmu.c                      | 12 ++---
 arch/powerpc/include/asm/kvm_book3s_64.h |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c    |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c   |  6 +--
 arch/powerpc/kvm/book3s_hv_nested.c      |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  8 +--
 arch/powerpc/kvm/e500_mmu_host.c         |  4 +-
 arch/riscv/kvm/mmu.c                     |  4 +-
 arch/x86/include/asm/kvm_host.h          |  2 +-
 arch/x86/kvm/mmu/mmu.c                   | 14 ++---
 arch/x86/kvm/mmu/paging_tmpl.h           |  4 +-
 include/linux/kvm_host.h                 | 66 ++++++++++++------------
 virt/kvm/kvm_main.c                      | 52 ++++++++++---------
 virt/kvm/pfncache.c                      | 17 +++---
 17 files changed, 108 insertions(+), 103 deletions(-)

-- 
2.25.1

