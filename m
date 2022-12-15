Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B434664DAA8
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLOLwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLOLwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:52:11 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C81FFB7;
        Thu, 15 Dec 2022 03:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671105130; x=1702641130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qKv8YzwKV8F4cKvrnTDTKO+eHs8skuBa0gr084Ivhzw=;
  b=I43HxyMz3m2qvosVlIBHsSN9eIKLe8H129/EhDnH8dSikLd7SEBEjlXW
   hIqRGLcS+70GvVMCQZW27AURxXFx8RYZasCIaEe+5eUadIbLc1GDYvxKh
   1QrXUg893Znelv1xXR8faQIVHY2md0eiijsX65O/0yOBmevLhYsv245hI
   yGhUtJYOOJs5K2hC37gHL1rhy1aKqcOSMtD5hYgoNPhOUrflDOM4YM+oI
   qfjfZllQEWghDpz4wsiaa9vD6H4D2FJqeXw+Zcq9399hsbrKge9YYnFwS
   VWMbavedKaIrvXZhBc8p7wLBByXbHZ5bSw7gLBZ+jrVXw/G6iHWVTN3T4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="345743395"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="345743395"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 03:52:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="791606570"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="791606570"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2022 03:52:09 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1] KVM: x86: add KVM_CAP_DEVICE_CTRL
Date:   Thu, 15 Dec 2022 19:52:07 +0800
Message-Id: <20221215115207.14784-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_DEVICE_CTRL allows userspace to create emulated device in KVM.
For example, userspace VFIO implementation needs to create a kvm_device
(i.e. KVM_DEV_TYPE_VFIO) on x86. So add the cap to allow userspace for
such use cases.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69227f77b201..1cdc4469652c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4410,6 +4410,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+	case KVM_CAP_DEVICE_CTRL:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.32.0

