Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FDA215047
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 01:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgGEXFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 19:05:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:22784 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgGEXFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 19:05:11 -0400
IronPort-SDR: l1XRvknSfJpxrIl3BdiqmlF5ASTMWJw/RCb7dOnZwyxcIC/SW1uGP1pM35AJ8sFxdi4l4IWDwA
 0A7JXw3U+zeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="147344297"
X-IronPort-AV: E=Sophos;i="5.75,317,1589266800"; 
   d="scan'208";a="147344297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2020 16:05:10 -0700
IronPort-SDR: i0jCGVlWBSYwbFFrXWQhgxWDVRBwjxs/MsO0mwfKmvr3XN1mUpgZnvqFTrCNdpfjeSSe7VA7TR
 232RjCbNGKRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,317,1589266800"; 
   d="scan'208";a="388043365"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jul 2020 16:05:07 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        kyung.min.park@intel.com, Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH 0/2] Expose new features for intel processor
Date:   Mon,  6 Jul 2020 06:59:50 +0800
Message-Id: <1593989992-10019-1-git-send-email-cathy.zhang@intel.com>
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

Cathy Zhang (2):
  x86: Expose SERIALIZE for supported cpuid
  x86: Expose TSX Suspend Load Address Tracking

 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.3.1

