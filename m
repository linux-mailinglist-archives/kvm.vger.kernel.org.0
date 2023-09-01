Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3078F942
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbjIAHlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbjIAHlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:41:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00DA10E9
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693554074; x=1725090074;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PWpo+jZ/sznaloK4uuic1SIsYb9vsguyJtKvN0+WNME=;
  b=Rc6rESbsPWz9n5H4I5+Ue5zuDdi/5not/JndF02/sgCDJvKdoltY+kUU
   SzZ9Q4gGl0P5SnYwb09nsT+OakUjqrbBw6pbuwDjbKLlYHyAySQxvD6bR
   NTVxD0aEdr9OJNN+Lv2NpWcKiOItKvE6BXLM6ZD9h95Zqkw1xg1GSw1xD
   CcSdFOpqhxhHje/OW017yQiHZN2PBCDpkZu8ruoBMdJKm8ptXo8gs7xuB
   F27+LHL98zOj0g62WBOhwTipEw2fJEwpnIMdr8/XOIOxIDkqrySKbeEsA
   qCBddWEzHtJh1LJ9xpCQSHLqckDWsvldnPJUaSYJW3yF8OuWtIP4qtNoy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="378886126"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="378886126"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="733448032"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="733448032"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:11 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [kvm-unit-tests 0/6] vPMU v5 test case
Date:   Fri,  1 Sep 2023 15:40:46 +0800
Message-Id: <20230901074052.640296-1-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel vPMU version has been upgraded from 2 to 5 in [1], this patchset
adds test cases for each new feature.

Reference:
[1]:Upgrade vPMU version to 5
https://lore.kernel.org/kvm/20230901072809.640175-1-xiong.y.zhang@intel.com/T/#m3a7e8c3b98b8793a993f39c1851ef0b89efbd93d

Xiong Zhang (6):
  x86: pmu: remove duplicate code
  x86: pmu: Add Freeze_LBRS_On_PMI test case
  x86: pmu: PERF_GLOBAL_STATUS_SET MSR verification for vPMU v4
  x86: pmu: PERF_GLOBAL_INUSE MSR verification for vPMU v4
  x86: pmu: Limit vcpu's fixed counter into fixed_events[]
  x86: pmu: Support fixed counter enumeration in vPMU v5

 lib/x86/msr.h  |   8 ++++
 lib/x86/pmu.c  |  10 ++---
 lib/x86/pmu.h  |   6 +++
 x86/pmu.c      |  32 +++++++++++++--
 x86/pmu_lbr.c  | 109 ++++++++++++++++++++++++++++++++++++++++++++++++-
 x86/pmu_pebs.c |  12 ++++--
 6 files changed, 165 insertions(+), 12 deletions(-)


base-commit: e8f8554f810821e37f05112a46ae9775a029b5d1
-- 
2.34.1

