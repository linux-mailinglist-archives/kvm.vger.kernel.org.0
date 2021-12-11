Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F0C47143A
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 15:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhLKO1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 09:27:11 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29184 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhLKO1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 09:27:11 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JB95l6zLgz90gK;
        Sat, 11 Dec 2021 22:24:59 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 22:27:09 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 22:27:08 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <pbonzini@redhat.com>, <alex.williamson@redhat.com>,
        <mst@redhat.com>, <mtosatti@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <arei.gonglei@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [PATCH 0/2] kvm/msi: do explicit commit when adding msi routes
Date:   Sat, 11 Dec 2021 22:27:01 +0800
Message-ID: <20211211142703.1941-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

This patchset moves the call to kvm_irqchip_commit_routes() out of
kvm_irqchip_add_msi_route(). An optimization of vfio migration [1]
depends on this changes.

[1] https://lists.gnu.org/archive/html/qemu-devel/2021-11/msg00968.html

Longpeng (Mike) (2):
  kvm-irqchip: introduce new API to support route change
  kvm/msi: do explicit commit when adding msi routes

 accel/kvm/kvm-all.c    |  7 ++++---
 accel/stubs/kvm-stub.c |  2 +-
 hw/misc/ivshmem.c      |  5 ++++-
 hw/vfio/pci.c          |  5 ++++-
 hw/virtio/virtio-pci.c |  4 +++-
 include/sysemu/kvm.h   | 23 +++++++++++++++++++++--
 target/i386/kvm/kvm.c  |  4 +++-
 7 files changed, 40 insertions(+), 10 deletions(-)

-- 
2.23.0

