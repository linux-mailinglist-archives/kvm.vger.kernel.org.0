Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB39612816
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJ3G1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJ3GZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:25:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481F21B;
        Sat, 29 Oct 2022 23:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111054; x=1698647054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A805Zxruh6yYNtylIzj9f+DsWSAMkPS9vWZxb71Yd8s=;
  b=OT8PLz3E2XxRTMRIaHvbZJGenE5ZQ8q+KWaJ90YxbYJAr7yKCLA+R9Dt
   mAls/trPDDrGHiEZHxEQ7v2hp2y9YdnDl8ARtiDDG/pgulk+/ce0DKN0K
   h+xcB3AE7DZgI994hBmsBdbQgUjkfBQHOSzV9sWcS6sxMjBXSNx4BBUGl
   rZKYW/6Y4zX4J2Q82p7SocWjlqIzeDI/0oLYISgKRrhYK6pdKdduIXuuM
   2PTbRHm3ReSW1TZrDolC93DEEKVXO4B864oDf6A95XTxbs6DNNszeosKi
   teL5Et+8SvR5ETs5FNb26VJg7evwhyj029RrxrBBP9yDjAv0bKlgz9Opg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037172"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037172"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393036"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393036"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 059/108] [MARKER] The start of TDX KVM patch series: KVM TDP MMU MapGPA
Date:   Sat, 29 Oct 2022 23:23:00 -0700
Message-Id: <a2ce87719dc269162349e1d29167c917e362432f.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM TDP MMU
MapGPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index c3e675bea802..5797d172176d 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -11,6 +11,7 @@ What qemu can do
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
 - Qemu can create/destroy vcpu of TDX vm type.
+- Qemu can populate initial guest memory image.
 
 Patch Layer status
 ------------------
@@ -19,7 +20,7 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applying
+* TDX EPT violation:                    Applied
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
-- 
2.25.1

