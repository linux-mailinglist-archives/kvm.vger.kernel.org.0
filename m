Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B7B325E7B
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 08:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBZHx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 02:53:28 -0500
Received: from mga14.intel.com ([192.55.52.115]:37006 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhBZHx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 02:53:27 -0500
IronPort-SDR: mLrEcBkzPIr+vDDeeuGV5SXYyQB01Com7YTau375syMxkCaUvHtzMDGUMMgoJn8qv12CyszAWB
 rUU1l8uMZnrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185118894"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185118894"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 23:52:46 -0800
IronPort-SDR: EgQBwrnMWF0ZF+1qC1DNq57FF0ROm0nZzUn5xBIEH0yhP9YyNd0DLRFAVQLnbR96GGWsly9/PX
 zW4Csgc/frdA==
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404797767"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 23:52:33 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Documentation: rectify rst markup in kvm_run->flags
Date:   Fri, 26 Feb 2021 15:55:41 +0800
Message-Id: <20210226075541.27179-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c32b1b896d2a ("KVM: X86: Add the Document for
KVM_CAP_X86_BUS_LOCK_EXIT") added a new flag in kvm_run->flags
documentation, and caused warning in make htmldocs:

  Documentation/virt/kvm/api.rst:5004: WARNING: Unexpected indentation
  Documentation/virt/kvm/api.rst:5004: WARNING: Inline emphasis start-string without end-string

Fix this rst markup issue.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aed52b0fc16e..0717bf523034 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5000,7 +5000,8 @@ local APIC is not used.
 	__u16 flags;
 
 More architecture-specific flags detailing state of the VCPU that may
-affect the device's behavior. Current defined flags:
+affect the device's behavior. Current defined flags::
+
   /* x86, set if the VCPU is in system management mode */
   #define KVM_RUN_X86_SMM     (1 << 0)
   /* x86, set if bus lock detected in VM */
-- 
2.17.1

