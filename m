Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B262163E0
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 04:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgGGCVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 22:21:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:19817 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgGGCVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 22:21:44 -0400
IronPort-SDR: 1bRoAO2++l66kcQS6O+mGl1IDJrNPUaZfXLU9jbC/98g3uzMfcpMCUu4cHEXJtTw0oi7PrTXcG
 2eDewj0XdwmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="209050411"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="209050411"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:21:43 -0700
IronPort-SDR: /08WP0qn50HLBtdiMdTo6E6rcAb9CUZQan5fiYL8VajZmofS8j8m/KSlLR89117o4DRzTLyHuC
 rKwpVW7HVggA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="357633718"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by orsmga001.jf.intel.com with ESMTP; 06 Jul 2020 19:21:38 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        kyung.min.park@intel.com, jpoimboe@redhat.com,
        gregkh@linuxfoundation.org, ak@linux.intel.com,
        dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com, Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH v2 0/4] Expose new features for intel processor
Date:   Tue,  7 Jul 2020 10:16:19 +0800
Message-Id: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is to expose two new features for intel
processors which support them, like Sapphire Rapids.
SERIALIZE is a faster serializing instruction which
does not modify registers, arithmetic flags or memory,
will not cause VM exit. TSX suspend load tracking
instruction aims to give a way to choose which memory
accesses do not need to be tracked in the TSX read set.

Changelog:
v2	Add kernel feature enumeration patch to fix build error

Cathy Zhang (2):
  x86: Expose SERIALIZE for supported cpuid
  x86: Expose TSX Suspend Load Address Tracking

Ricardo Neri (1):
  x86/cpufeatures: Add enumeration for SERIALIZE instruction

Kyung Min Park (1):
  x86/cpufeatures: Enumerate TSX suspend load address tracking
    instructions

 arch/x86/include/asm/cpufeatures.h | 2 ++
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--
1.8.3.1

