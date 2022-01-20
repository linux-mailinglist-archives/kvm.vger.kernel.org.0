Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2FD494716
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 07:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358649AbiATGFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 01:05:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:29571 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbiATGFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 01:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642658730; x=1674194730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4yIMwpAQHpg+W4EiKTx6nyojdlXTHv3T2fPnEPiOlXA=;
  b=If+kKqQnBxmVwdb5M0dfAl1wovKfLIk74h+lTGDoz+xZc3b716thoRKu
   qBVtCzEubJe2+7qoj86OGMmQE005GZchMvOaPMs5537u0vONvQA8WUswe
   LuxiPKQ/OKlXRMaQ7F29djQH5GzBq2aSaFnwLD8JGIxNDGjN98OKNRzEY
   o+v4qSqbCMHTAWsVSLYCYLtLVkPpvSiELthk5Bjo52i4Rr+WgH1/Qq1hc
   iBNxAztUMDbKAeGqD51FOkMfhsykhy62zNv1Ubpw/cKUQMndubVkob2Zu
   KPQYoli5OhHOXSSRA/C8EulrAI30mMo8uK+mLQb3v5s8n0xgmipJzwJcE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="232642861"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="232642861"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 22:05:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="532631851"
Received: from devel-wwang.sh.intel.com ([10.239.48.106])
  by orsmga008.jf.intel.com with ESMTP; 19 Jan 2022 22:05:28 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     sfr@canb.auug.org.au, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH] docs: kvm: fix WARNINGs from api.rst
Date:   Wed, 19 Jan 2022 23:50:03 -0500
Message-Id: <20220120045003.315177-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the api number 134 for KVM_GET_XSAVE2, instead of 42, which has been
used by KVM_GET_XSAVE.
Also, fix the WARNINGs of the underlines being too short.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d3791a14eb9a..bb8cfddbb22d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5545,8 +5545,8 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 The Stats Data block contains an array of 64-bit values in the same order
 as the descriptors in Descriptors block.
 
-4.42 KVM_GET_XSAVE2
-------------------
+4.134 KVM_GET_XSAVE2
+--------------------
 
 :Capability: KVM_CAP_XSAVE2
 :Architectures: x86
@@ -7363,7 +7363,7 @@ trap and emulate MSRs that are outside of the scope of KVM as well as
 limit the attack surface on KVM's MSR emulation code.
 
 8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
------------------------------
+-------------------------------------
 
 Architectures: x86
 
-- 
2.25.1

