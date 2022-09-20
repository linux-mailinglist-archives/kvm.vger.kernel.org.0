Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175FB5BE78C
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiITNuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiITNur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:50:47 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFF32AC4B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 06:50:43 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MX2rq53r7zlW2W;
        Tue, 20 Sep 2022 21:46:35 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 21:50:41 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <anup@brainfault.org>, <atishp@atishpatra.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>
CC:     <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <xiujianfeng@huawei.com>
Subject: [PATCH -next] RISC-V: KVM: add __init annotation to riscv_kvm_init()
Date:   Tue, 20 Sep 2022 21:47:03 +0800
Message-ID: <20220920134703.132216-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's module_init entry, add __init annotation to it.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 arch/riscv/kvm/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 1549205fe5fe..df2d8716851f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -122,7 +122,7 @@ void kvm_arch_exit(void)
 {
 }
 
-static int riscv_kvm_init(void)
+static int __init riscv_kvm_init(void)
 {
 	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 }
-- 
2.17.1

