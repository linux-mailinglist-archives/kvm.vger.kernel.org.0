Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79D1A97DA
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 03:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfIEBML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 21:12:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:7752 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbfIEBML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 21:12:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 18:12:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,468,1559545200"; 
   d="scan'208";a="184081805"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.44])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2019 18:12:08 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] doc: kvm: Fix return description of KVM_SET_MSRS
Date:   Thu,  5 Sep 2019 08:57:37 +0800
Message-Id: <20190905005737.131067-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can use ioctl KVM_SET_MSRS to update a set of MSRs of guest.
This ioctl set specified MSRs one by one. If it fails to set an MSR,
e.g., due to setting reserved bits, the MSR is not supported/emulated by
KVM, etc..., it stops processing the MSR list and returns the number of
MSRs have been set successfully.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v3:
  refine the description based on Sean's comment.  

v2:
  elaborate the changelog and description of ioctl KVM_SET_MSRS based on
  Sean's comments.
---
 Documentation/virt/kvm/api.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..24541e52e96e 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -586,7 +586,7 @@ Capability: basic
 Architectures: x86
 Type: vcpu ioctl
 Parameters: struct kvm_msrs (in)
-Returns: 0 on success, -1 on error
+Returns: number of msrs successfully set (see below), -1 on error
 
 Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
 data structures.
@@ -595,6 +595,11 @@ Application code should set the 'nmsrs' member (which indicates the
 size of the entries array), and the 'index' and 'data' members of each
 array entry.
 
+It tries to set the MSRs in array entries[] one by one. If setting an MSR
+fails, e.g., due to setting reserved bits, the MSR isn't supported/emulated
+by KVM, etc..., it stops processing the MSR list and returns the number of
+MSRs that have been set successfully.
+
 
 4.20 KVM_SET_CPUID
 
-- 
2.19.1

