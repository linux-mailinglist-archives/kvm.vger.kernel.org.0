Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D9476EAE7
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 15:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbjHCNoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 09:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbjHCNnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 09:43:10 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF025256
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 06:39:57 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RGqdg2qSNzJr9T;
        Thu,  3 Aug 2023 21:37:11 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 3 Aug
 2023 21:39:54 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <yuehaibing@huawei.com>
Subject: [PATCH -next] kvm_host: Remove unused declarations kvm_device_get()/kvm_device_put()
Date:   Thu, 3 Aug 2023 21:39:44 +0800
Message-ID: <20230803133944.25676-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 07f0a7bdec5c ("kvm: destroy emulated devices on VM exit") removed the
function but leave these declarations.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 include/linux/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..c57e6ca8f8e5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2148,8 +2148,6 @@ struct kvm_device_ops {
 	int (*mmap)(struct kvm_device *dev, struct vm_area_struct *vma);
 };
 
-void kvm_device_get(struct kvm_device *dev);
-void kvm_device_put(struct kvm_device *dev);
 struct kvm_device *kvm_device_from_filp(struct file *filp);
 int kvm_register_device_ops(const struct kvm_device_ops *ops, u32 type);
 void kvm_unregister_device_ops(u32 type);
-- 
2.34.1

