Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DA03A1407
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 14:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhFIMSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 08:18:10 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5307 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhFIMSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 08:18:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G0Qtn3X5gz19S62;
        Wed,  9 Jun 2021 20:11:13 +0800 (CST)
Received: from dggemi758-chm.china.huawei.com (10.1.198.144) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 20:16:05 +0800
Received: from huawei.com (10.175.101.6) by dggemi758-chm.china.huawei.com
 (10.1.198.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 20:15:59 +0800
From:   ChenXiaoSong <chenxiaosong2@huawei.com>
To:     <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <x86@kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <chenxiaosong2@huawei.com>
Subject: [PATCH -next] KVM: SVM: fix doc warnings
Date:   Wed, 9 Jun 2021 20:22:17 +0800
Message-ID: <20210609122217.2967131-1-chenxiaosong2@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi758-chm.china.huawei.com (10.1.198.144)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix gcc W=1 warnings:

arch/x86/kvm/svm/avic.c:233: warning: Function parameter or member 'activate' not described in 'avic_update_access_page'
arch/x86/kvm/svm/avic.c:233: warning: Function parameter or member 'kvm' not described in 'avic_update_access_page'
arch/x86/kvm/svm/avic.c:781: warning: Function parameter or member 'e' not described in 'get_pi_vcpu_info'
arch/x86/kvm/svm/avic.c:781: warning: Function parameter or member 'kvm' not described in 'get_pi_vcpu_info'
arch/x86/kvm/svm/avic.c:781: warning: Function parameter or member 'svm' not described in 'get_pi_vcpu_info'
arch/x86/kvm/svm/avic.c:781: warning: Function parameter or member 'vcpu_info' not described in 'get_pi_vcpu_info'
arch/x86/kvm/svm/avic.c:1009: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
---
 arch/x86/kvm/svm/avic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0e62e6a2438c..5e7e920113f3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -221,7 +221,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	return &avic_physical_id_table[index];
 }
 
-/**
+/*
  * Note:
  * AVIC hardware walks the nested page table to check permissions,
  * but does not use the SPA address specified in the leaf page
@@ -764,7 +764,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	return ret;
 }
 
-/**
+/*
  * Note:
  * The HW cannot support posting multicast/broadcast
  * interrupts to a vCPU. So, we still use legacy interrupt
@@ -1005,7 +1005,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-/**
+/*
  * This function is called during VCPU halt/unhalt.
  */
 static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-- 
2.25.4

