Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C898310F917
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 08:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLCHo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 02:44:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727459AbfLCHoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 02:44:55 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2F25094BB710449FBC82;
        Tue,  3 Dec 2019 15:44:53 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Tue, 3 Dec 2019 15:44:46 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: Remove duplicated declaration of kvm_vcpu_kick
Date:   Tue, 3 Dec 2019 15:44:08 +0800
Message-ID: <20191203074408.1758-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two declarations of kvm_vcpu_kick() in kvm_host.h where
one of them is redundant. Remove to keep the git grep a bit cleaner.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 include/linux/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ed1e2f8641e..92ce5e205622 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -982,7 +982,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
-void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
-- 
2.19.1


