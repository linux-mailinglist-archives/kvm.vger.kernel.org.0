Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F833737A7
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhEEJjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:39:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:56202 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhEEJjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 05:39:14 -0400
IronPort-SDR: Ee4wyqgNQe3bqH3kLzSR+ElVq6q+637LSLREVrb9LcIwkd92+5Ya0YciWrVf0DTw3bh0vnamhE
 amfcIXJn6Z9Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="177724141"
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="177724141"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:17 -0700
IronPort-SDR: tV5+Re0ZerwtUBbloPtWPSD2k40DfDWmV8IsHVVjTQ9PqSirM4RCnfv0yNftH6z4f110YodKc6
 X3RWo06KdP3A==
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="433728443"
Received: from smorlan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.190.185])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:14 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 0/3] TDP MMU: several minor fixes or improvements
Date:   Wed,  5 May 2021 21:37:56 +1200
Message-Id: <cover.1620200410.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pathc 1 and 2 are basically v2 of below patch, after discussion with Ben:

https://lore.kernel.org/kvm/b6d23d9fd8e526e5c7c1a968e2018d13c5433547.camel@intel.com/T/#t

Patch 3 is a new one.

I didn't do lots of tests, especially I didn't do stress test, but only tested
by creating couple of VMs (16 vcpus, 4G memory) and killing them, and everything
seems fine.

Kai Huang (3):
  KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix TDP MMU page table level

 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.31.1

