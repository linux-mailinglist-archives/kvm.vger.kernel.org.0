Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C0C6DC6E8
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 14:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjDJMu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 08:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDJMuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 08:50:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B08872BE;
        Mon, 10 Apr 2023 05:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681131022; x=1712667022;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EDtZprTCrB2b9phvfiB/TIQk1pW/5Uzc3NiWcZM3c78=;
  b=jC6n3IQp7FGhc4crFuOwE7IGdZJTSrEiM0F/SoptwqO41bIaPEW7Nnwf
   K7V6asiRkhTOmvHn6G3wQLuK/SZh1tPQxLfWOscY473x/KRgOCa9d6SW0
   7zOiR++3KjK8CpjYR4tdBbCIS9wd0HDUEqQIY2rqH1SQCVEDXS5dairmp
   gOr9D226DDhEwIoyzhgrmg/x7r+eIB/fpO0kPhU0C9FJBNTEoPbjyAvEb
   u9z4aGKXqFAwF9Ujzwaxayem4ZlP+soRHAm+KA7Nqa9Pw3g8MZOW8c8RH
   NS0INilbGjNpUTC7Ac6ndP/Bi7wg1fe55/5Z7uPMULVOEH7GRS9iCI/iV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="371183492"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="371183492"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 05:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="638455264"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="638455264"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga003.jf.intel.com with ESMTP; 10 Apr 2023 05:50:19 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaoyao.li@intel.com
Subject: [PATCH 0/2] KVM: VMX: Clean up of vmx_set_cr4()
Date:   Mon, 10 Apr 2023 08:50:15 -0400
Message-Id: <20230410125017.1305238-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two minor patches of vmx_set_cr4() during code inspection.

Patch 1 gets rid of the direct accessing of vcpu->arch.cr4 to avoid
stale value.

Patch 2 moves the code comment to correct place.

Xiaoyao Li (2):
  KVM: VMX: Use kvm_read_cr4() to get cr4 value
  KVM: VMX: Move the comment of CR4.MCE handling right above the code

 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
prerequisite-patch-id: 5c516b453b538845ceb91a76678803ec123834ba
prerequisite-patch-id: 022904226ae3cb6766bba71c3bf407749ab5b5b2
prerequisite-patch-id: cf5655ce89a2390cd29f33c57a4fc307a6045f62
-- 
2.34.1

