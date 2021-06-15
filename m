Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1854C3A7320
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 02:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFOA70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 20:59:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:18757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhFOA70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 20:59:26 -0400
IronPort-SDR: bdXehK/sFVgbBLd5itthsVRfpswI7Ot/VqAeZiEa8h8pLetje3e52Ity6vrvVwhB1E0IKjlBTZ
 DI48OmE+eyRw==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="193212080"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="193212080"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 17:57:22 -0700
IronPort-SDR: OR24zLFJEuvFHWtbXKAD2t9vBzHRxL0kq8guZK4Xns6jLf+68axmWlMxPpMtPk+x9aIcLC7Zv7
 Nb5aQTJPFSUw==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="442391831"
Received: from tmonfort-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.223.245])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 17:57:20 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 0/3] TDP MMU: several minor fixes or improvements
Date:   Tue, 15 Jun 2021 12:57:08 +1200
Message-Id: <cover.1623717884.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:

 - Rebased to latest kvm/queue.
 - Added Sean's reviewed-by for patch 2.

v1 -> v2:
 - Update patch 2, using Sean's suggestion.
 - Update patch 3, based on Ben's review.

https://lore.kernel.org/kvm/cover.1620343751.git.kai.huang@intel.com/

v1:

https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mcc2e6ea6d9e3caec2bcc9e5f99cbbe2a8dd24145


Kai Huang (3):
  KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix TDP MMU page table level

 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.31.1

