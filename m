Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7FD6EA46F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjDUHQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjDUHQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:16:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4BEB8
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682061410; x=1713597410;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mVOyobHqS70/bnDemHJljxCFKnPUn+13x7a8gc3MjyM=;
  b=W9sgls1odPPFVYSzyYPS5/DMmXbV9ua3PJnIO0moak+ql+bx/0TdeOhb
   I9NBa8LTNWWrOdDZEqd9Pnj5Cc7A3uMEYZe0XHaulSk2VR1WLByF1v68x
   8F8mmWCAP8K5w+ufraOpZVu1QKbWUumFxRJ2LSQyPbE5aKBeB7N/kfOtB
   O9mz1qWy5xQIzTX9NjchBtSTgja3o/S50A0f4ryfJnei6HC6W+9/9CuDs
   LaZPDG3keCZBJihRUfoAFgRTK//c4t/hCJ0x9Zm5kexGRvjMz9rm/KRWW
   Rj1Z+FX/iT9cYgRKnw5nPvXGVlxqsQdraTxtIcTtVFxtpgQdtzycUP18w
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326260527"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326260527"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938385322"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938385322"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:39 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH 0/4] Enable VMM userspace support for CET virtualization
Date:   Fri, 21 Apr 2023 00:12:23 -0400
Message-Id: <20230421041227.90915-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are VMM userspace enabling patches for CET virtualization.
Currently CET user mode SHSTK/IBT and kernel mode IBT are supported.
supervisor SHSTK are not supported now, so related MSRs support
are not included in this series.

Yang Weijiang (4):
  target/i386: Enable XSAVES support for user mode CET states
  target/i386: Add CET MSRs access interfaces
  target/i386: Enable CET states migration
  target/i386: Advertise CET flags in feature words

 target/i386/cpu.c     | 47 ++++++++++++++++++-------
 target/i386/cpu.h     | 23 ++++++++++++
 target/i386/kvm/kvm.c | 44 +++++++++++++++++++++++
 target/i386/machine.c | 81 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 183 insertions(+), 12 deletions(-)

base-commit: c283ff89d11ff123efc9af49128ef58511f73012
-- 
2.27.0

