Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE775114B3F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 03:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLFCyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 21:54:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726207AbfLFCyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 21:54:09 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AC3B0FAFD8AEFA6BE712;
        Fri,  6 Dec 2019 10:54:07 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 6 Dec 2019
 10:53:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <alex.williamson@redhat.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2]  use jump label to handle resource release in irq_bypass_register_*
Date:   Fri, 6 Dec 2019 10:53:51 +0800
Message-ID: <1575600833-12839-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use out_err jump label to help handle resource release.
It's a good practice to release resource in one place
and help eliminate some duplicated code.

Miaohe Lin (2):
  KVM: lib: use jump label to handle resource release in
    irq_bypass_register_consumer()
  KVM: lib: use jump label to handle resource release in
    irq_bypass_register_producer()

 virt/lib/irqbypass.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

-- 
2.19.1

