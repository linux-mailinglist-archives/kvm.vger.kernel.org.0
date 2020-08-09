Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35523FD40
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 09:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHIHxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 03:53:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:53373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgHIHxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 03:53:07 -0400
IronPort-SDR: uTdu0WnETwMpV9IgQMY5EeiXwdG9hh+RGX6AXRfNfi0tI564tCm62gTP2m+CeFRSyUxZg5jHMc
 668zncq4hQZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9707"; a="217734909"
X-IronPort-AV: E=Sophos;i="5.75,452,1589266800"; 
   d="scan'208";a="217734909"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2020 00:53:06 -0700
IronPort-SDR: kF4gYMiUwIdTNdNaYqdtwFP1fqW6C8uXoxz0o5s5VIQlgpCFsT3o1PWBhgtAOPKC+3AJaIgy8A
 c8wzo7x1WjaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,452,1589266800"; 
   d="scan'208";a="277033463"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2020 00:53:01 -0700
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
Subject: [PATCH v3 0/2] Expose new features for Intel processor
Date:   Sun,  9 Aug 2020 15:47:20 +0800
Message-Id: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is to expose two new features, SERIALIZE and
TSX suspend load tracking to KVM CPUID for processors which 
support them. KVM reports this information and guest can 
make use of them finally.

Detailed information on the instructions and CPUID feature
flags can be found in the latest "extensions" manual [1].

This series applies on top of TIP tree as it depends on

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=85b23fbc7d88f8c6e3951721802d7845bc39663d

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
  x86/kvm: Expose new features for supported cpuid

Kyung Min Park (1):
  x86/cpufeatures: Enumerate TSX suspend load address tracking
    instructions

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
1.8.3.1

