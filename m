Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913B058BDBA
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbiHGWIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiHGWG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:06:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED920B87F;
        Sun,  7 Aug 2022 15:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909794; x=1691445794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fb3dBDV4drTH1Irv7AqwIGDFRaog5goehiwWHDo/z9Q=;
  b=ITdtNvhDXRbOAz0I/lmzGb4skOR1NLJv6tXNTARPJJ0NWPkRR4FhCosH
   ypxIQnWaRm7H7iJ8B3Ap2rtsIhiW4svTMFGRvm/d+5+MWNRIkVyGjL5wf
   8F9HRzOvp9I8T6nFlSWjCE5rQNuAhcSFop9F8MtDK1/1DomKDV71kq+Z2
   1x8aRfNqFTN7n5Xj6lPKj7t52dB02Hin/xHzpH8xct9Nr0yZeBA2KVXfF
   TTQykmZfSysmkA8hC+E0fTB133gfycEnE8k0lefygYsoyu14KU0h6/sCj
   GzydZqIn2mBebO1gCYOSwRzbhGSpBNxsBov2Z1kDtV37FLpIr8Z/F9pQm
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224137"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224137"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682587"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 045/103] [MARKER] The start of TDX KVM patch series: TDX EPT violation
Date:   Sun,  7 Aug 2022 15:01:30 -0700
Message-Id: <93fde3d36a3678eeaf7ada6d37a51b718ba94f4b.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TDX EPT
violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index d5cace00c433..c3e675bea802 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -19,12 +19,12 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Not yet
+* TDX EPT violation:                    Applying
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
 * KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applying
+* KVM TDP MMU hooks:                    Applied
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

