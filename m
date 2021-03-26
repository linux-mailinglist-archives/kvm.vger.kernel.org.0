Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8A734A342
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhCZIhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:37:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14614 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCZIhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 04:37:07 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6Fdy0HxGz19JkV;
        Fri, 26 Mar 2021 16:35:02 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 16:36:52 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/4] vfio: fix a couple of spelling mistakes detected by codespell tool
Date:   Fri, 26 Mar 2021 16:35:24 +0800
Message-ID: <20210326083528.1329-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This detection and correction covers the entire driver/vfio directory.

Zhen Lei (4):
  vfio/type1: fix a couple of spelling mistakes
  vfio/mdev: Fix spelling mistake "interal" -> "internal"
  vfio/pci: fix a couple of spelling mistakes
  vfio/platform: Fix spelling mistake "registe" -> "register"

 drivers/vfio/mdev/mdev_private.h                         | 2 +-
 drivers/vfio/pci/vfio_pci.c                              | 2 +-
 drivers/vfio/pci/vfio_pci_config.c                       | 2 +-
 drivers/vfio/pci/vfio_pci_nvlink2.c                      | 4 ++--
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 +-
 drivers/vfio/vfio_iommu_type1.c                          | 6 +++---
 6 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.8.3


