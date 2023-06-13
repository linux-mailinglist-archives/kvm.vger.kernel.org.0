Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E174672E3EC
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242523AbjFMNT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 09:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242502AbjFMNTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 09:19:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8550E6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 06:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686662392; x=1718198392;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N0pEAGgj7hl33Q28PPttAftjSjowVftDqP6b6ibIa8U=;
  b=WGittnBqRT+EbcKpf7NjZxKXsiVsiDxEXRWhnLvUTsMpPdLynRC7jYYB
   GM1cK9Ra71KVeEs4SpuYvqdoQ4LcFkUtj1JY43jyY7OiHoCil+duzXpq2
   8DBDMWqNXuTKytpk9LEy1wGcqu5dVHof2tDZHp9cJpTiGvzXLq1COMCKC
   RzYEodDNDHbsMkJtsylDj2CJ2LQ5xYQVOc/4AAk7kXukT80JtPbtlGW/B
   /AjM687PqAbmLb2O5ovK+xAdVk7RxGjTN2ZtfaPXZswpMymq73x2aqe/t
   YarjSundbSJpFj66P/t7bBOOBjTjcUH2/s7vbASeStxNxhafrn/zDh3Wl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361696798"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="361696798"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:19:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744680300"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="744680300"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 06:19:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH v2 0/3] i386: Minor fixes of building CPUIDs
Date:   Tue, 13 Jun 2023 09:19:26 -0400
Message-Id: <20230613131929.720453-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This v2 adds patch 3 to fix the build of CPUID leaf 7.

The issue that fixed by Patch 1 looks fatal though it doesn't appear on
KVM because KVM always searches with assending order and hit with the
correct cpuid leaf 0.

Patch 2 removes the wrong constraint on CPUID leaf 1f.

Changes in v2:
- Add Patch 3;
- rebase to latest master branch
v1: https://lore.kernel.org/qemu-devel/20220712021249.3227256-1-xiaoyao.li@intel.com/

Xiaoyao Li (3):
  i386/cpuid: Decrease cpuid_i when skipping CPUID leaf 1F
  i386/cpuid: Remove subleaf constraint on CPUID leaf 1F
  i386/cpuid: Move leaf 7 to correct group

 target/i386/kvm/kvm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


base-commit: fdd0df5340a8ebc8de88078387ebc85c5af7b40f
-- 
2.34.1

