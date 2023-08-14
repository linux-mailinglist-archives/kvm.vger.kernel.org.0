Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F2777BAE4
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 16:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjHNOFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 10:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjHNOEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 10:04:51 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC1CE6D;
        Mon, 14 Aug 2023 07:04:50 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RPbhV3zSlz1GDbN;
        Mon, 14 Aug 2023 22:03:06 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 14 Aug
 2023 22:04:24 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yuehaibing@huawei.com>, <nitesh@redhat.com>,
        <scottwood@freescale.com>
Subject: [PATCH v2 -next] kvm_host: Remove unused declarations
Date:   Mon, 14 Aug 2023 22:03:39 +0800
Message-ID: <20230814140339.47732-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 07f0a7bdec5c ("kvm: destroy emulated devices on VM exit") removed the
functions but not these declarations.
Commit 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
declared but never implemented kvm_make_cpus_request_mask()

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
v2: Also remove kvm_make_cpus_request_mask()
---
 include/linux/kvm_host.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cb86108c624d..c354874519e8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -190,8 +190,6 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except);
-bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
-				unsigned long *vcpu_bitmap);
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
@@ -2167,8 +2165,6 @@ struct kvm_device_ops {
 	int (*mmap)(struct kvm_device *dev, struct vm_area_struct *vma);
 };
 
-void kvm_device_get(struct kvm_device *dev);
-void kvm_device_put(struct kvm_device *dev);
 struct kvm_device *kvm_device_from_filp(struct file *filp);
 int kvm_register_device_ops(const struct kvm_device_ops *ops, u32 type);
 void kvm_unregister_device_ops(u32 type);
-- 
2.34.1

