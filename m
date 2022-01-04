Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AD7483988
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 01:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiADAsv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 3 Jan 2022 19:48:51 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16681 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiADAsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 19:48:51 -0500
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JSYmz5H06zZdxm;
        Tue,  4 Jan 2022 08:45:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 08:48:49 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 08:48:48 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.020;
 Tue, 4 Jan 2022 08:48:48 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH 0/2] kvm/msi: do explicit commit when adding msi routes
Thread-Topic: [PATCH 0/2] kvm/msi: do explicit commit when adding msi routes
Thread-Index: AQHX7psu1N6+1Tf/akGsiLQxqZd2LaxSLE7Q
Date:   Tue, 4 Jan 2022 00:48:48 +0000
Message-ID: <c9eba7e294ae4bc68bf1095ace98fa34@huawei.com>
References: <20211211142703.1941-1-longpeng2@huawei.com>
In-Reply-To: <20211211142703.1941-1-longpeng2@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi guys,

Ping...

> -----Original Message-----
> From: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> Sent: Saturday, December 11, 2021 10:27 PM
> To: pbonzini@redhat.com; alex.williamson@redhat.com; mst@redhat.com;
> mtosatti@redhat.com
> Cc: kvm@vger.kernel.org; qemu-devel@nongnu.org; Gonglei (Arei)
> <arei.gonglei@huawei.com>; Longpeng (Mike, Cloud Infrastructure Service
> Product Dept.) <longpeng2@huawei.com>
> Subject: [PATCH 0/2] kvm/msi: do explicit commit when adding msi routes
> 
> From: Longpeng <longpeng2@huawei.com>
> 
> This patchset moves the call to kvm_irqchip_commit_routes() out of
> kvm_irqchip_add_msi_route(). An optimization of vfio migration [1]
> depends on this changes.
> 
> [1] https://lists.gnu.org/archive/html/qemu-devel/2021-11/msg00968.html
> 
> Longpeng (Mike) (2):
>   kvm-irqchip: introduce new API to support route change
>   kvm/msi: do explicit commit when adding msi routes
> 
>  accel/kvm/kvm-all.c    |  7 ++++---
>  accel/stubs/kvm-stub.c |  2 +-
>  hw/misc/ivshmem.c      |  5 ++++-
>  hw/vfio/pci.c          |  5 ++++-
>  hw/virtio/virtio-pci.c |  4 +++-
>  include/sysemu/kvm.h   | 23 +++++++++++++++++++++--
>  target/i386/kvm/kvm.c  |  4 +++-
>  7 files changed, 40 insertions(+), 10 deletions(-)
> 
> --
> 2.23.0

