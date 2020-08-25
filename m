Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD46250DDF
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgHYAx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 20:53:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:44396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHYAx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 20:53:57 -0400
IronPort-SDR: s/5ZfokiSKpQq8n8WseAR4E+QzvMF4ydRlp5prEJ++FlTnHz5tUZuZe892EBUFWw60FS/gjrkh
 RKYQL8bapG4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="220284855"
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="220284855"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:53:52 -0700
IronPort-SDR: CjSlxqYRBr9+F4QcLIAi6bJu3kzeaxyz8Q5SQtD+YbMYl3ZrSkJ2cmcPRpOZpRHry3x38tzrAx
 i932oJdbbDNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="281351912"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2020 17:53:47 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        tony.luck@intel.com, dave.hansen@intel.com,
        kyung.min.park@intel.com, ricardo.neri-calderon@linux.intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        jpoimboe@redhat.com, ak@linux.intel.com, ravi.v.shankar@intel.com,
        Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH v4 0/2] Expose new feature for Intel processor
Date:   Tue, 25 Aug 2020 08:47:56 +0800
Message-Id: <1598316478-23337-1-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is to introduce TSX suspend load tracking feature 
and expose it to KVM CPUID for processors which support it. KVM 
reports this information and guests can make use of it finally.

Detailed information on the instruction and CPUID feature
flag can be found in the latest "extensions" manual [1].

Changes since v3:
  * Remove SERIALIZE part from kvm patch and update commit message 

Changes since v2:
  * Combine the two kvm patches into a single one.
  * Provide features' overview introduction in kvm patch commit message.
  * Get the latest kernel patches.
  * Change definition from TSX_LDTRK to TSXLDTRK for TSX new feature.
  * Change kernel patches Author to the owner.
  * Remove SERIALIZE enumeration patch.

Reference:
[1]. https://software.intel.com/content/dam/develop/public/us/en/documents/architecture-instruction-set-extensions-programming-reference.pdf

Cathy Zhang (1):
  x86/kvm: Expose TSX Suspend Load Tracking feature

Kyung Min Park (1):
  x86/cpufeatures: Enumerate TSX suspend load address tracking
    instructions

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.3.1

