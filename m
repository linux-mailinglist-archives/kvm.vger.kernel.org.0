Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BCF375D79
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhEFXfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:35:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:63204 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhEFXfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:35:16 -0400
IronPort-SDR: CGP1N3NHN6ifnRxolXpiZf/B+gWU5LhNWAa4NLs0bWaftRfCgIwGTtUS3rRrVwtYo77aVYiEKH
 eVjUQ7pqxr/g==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="186066157"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="186066157"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:17 -0700
IronPort-SDR: h7mVV/1APKXHukmpaL29psE7+UuhUk5QrL4zI9mjebFvDB3lSMqAev/AAiWDMm2SNCInt3poWK
 ISHgqCXAi5bQ==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="608004599"
Received: from jasonbai-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.141.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:15 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 0/3] TDP MMU: several minor fixes or improvements
Date:   Fri,  7 May 2021 11:33:59 +1200
Message-Id: <cover.1620343751.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1:

https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mcc2e6ea6d9e3caec2bcc9e5f99cbbe2a8dd24145

v1 -> v2:
 - Update patch 2, using Sean's suggestion.
 - Update patch 3, based on Ben's review.

Kai Huang (3):
  KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix TDP MMU page table level

 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.31.1

