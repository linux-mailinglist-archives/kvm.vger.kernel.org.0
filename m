Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E8FA53F7
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 12:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbfIBK0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 06:26:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:47036 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfIBK0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 06:26:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Sep 2019 03:26:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,457,1559545200"; 
   d="scan'208";a="183277100"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.44])
  by fmsmga007.fm.intel.com with ESMTP; 02 Sep 2019 03:26:35 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] doc: kvm: fix return description of KVM_SET_MSRS
Date:   Mon,  2 Sep 2019 18:12:14 +0800
Message-Id: <20190902101214.77833-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/api.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..a2efc19e0f4e 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -586,7 +586,7 @@ Capability: basic
 Architectures: x86
 Type: vcpu ioctl
 Parameters: struct kvm_msrs (in)
-Returns: 0 on success, -1 on error
+Returns: number of msrs successfully set, -1 on error
 
 Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
 data structures.
-- 
2.19.1

