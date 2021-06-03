Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7239A554
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhFCQKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:04 -0400
Received: from mail-dm3nam07on2078.outbound.protection.outlook.com ([40.107.95.78]:24154
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229617AbhFCQKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzlyN9pM6cDyC8lehS1EYm98J0wjLrfd9GB/asTBJ1kjSsiywKi2wIh9xkuH4r3R/Y6puEdQnlMUOyyD+f1rV8p9KNOnDyEdYh6z2M8lZvt6LbDCkPtV1SNmD3K0+5i3HKZouI4o8Ee0AdYzTs4GQVg+a+m5ycrS0eQ5XC5oJN13BYveLjMv/26P15aycw6bko5N9iaXjwbxhswcnzG0IzsxApEtsryu/ILlgHPRThmSsZdLWB4pq+DI9j5FH6vMhpC1E3EEbqFnmzrjtR9RrL0+xq5Wgm6+MDNwsdr+ock4WlUhGxSlksAkItoMFp0K1qBHxxV6qyi/J8ws4QBRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5NkaT2XbpgBVY7GKGjspMoQF4uowgbqstgI22ylhqY=;
 b=ULaFu8DFeVE6ycMQIcAjbqySfXxru8u0r9WEug7bzAkoIIlGzx7aIp8c9Z2dun4cGPdkc4lXPy4xB3Wxoolo+JSfaWkoAmYBsXNoAOxX3BRCSd2OR+vz/rgLANUU2uDw+ohgD6xGlE62g6muqlH9spalQE+P1Wv2lIBS1+/sJiLjgChlZj0/LAjruCC83FyAAPKz0wRd7QZyFifA8tcPmK7sfhoAAAA9vQHdyiNM60vLh8b1Ye68Lu0U3jybOQQuLkXqZS1h9Fk3+W3xvUD96yt71KI+ClBaYYo9A7CBjvaOyb2vLzgEiMTR6DRChSTKca6L2d7aFDV2FmYhG978cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5NkaT2XbpgBVY7GKGjspMoQF4uowgbqstgI22ylhqY=;
 b=K2NXxN81DzfjoGwENqxfs3k2Lmg3RfVw7B6HKugv6PkZdHItBWjHLZ+WdG5nd6vxDmCk/iWwulPulOPOLXcvkAF8sUr42i/Ieg7wJR3SYC+tMFHiUx7ZLLCxgtbhw8Vg6nK7WvvSZhwVWaKuykReqSC9a+GEM7ydmxiCTYSg60tOozqsfz8fvFWRon13C2aUoD8kz3nxLlHIKlwxEgmtA92tSplTW+H7Eo8S+SGGid3CDA+WgaHGCECkrYhUJzkQVkISLU0DnXF7LFMf/uO01pateSBUtMOdSj+y0tL6WS8eft3gUkcWBUXwJgBqZ9oc9jzVWjt2X6Cnlx9FsJDDKg==
Received: from DM6PR13CA0063.namprd13.prod.outlook.com (2603:10b6:5:134::40)
 by DM4PR12MB5343.namprd12.prod.outlook.com (2603:10b6:5:39f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 3 Jun
 2021 16:08:18 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::95) by DM6PR13CA0063.outlook.office365.com
 (2603:10b6:5:134::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:16 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:15 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:10 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jgg@nvidia.com>
CC:     <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [RFC PATCH v4 00/11] Introduce vfio-pci-core subsystem
Date:   Thu, 3 Jun 2021 19:07:58 +0300
Message-ID: <20210603160809.15845-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82896737-a9cd-480d-6bf3-08d926a9cc38
X-MS-TrafficTypeDiagnostic: DM4PR12MB5343:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5343A4DB32677231390B2848DE3C9@DM4PR12MB5343.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l84bgSK1hVob4ihwSP25ZIFVxhR/dYAmnIIDRsa/9Ik+HwfeXTe+VfaWIko6koTyDe/bkofTLx++3UVeVT8axr2yZD9cb+tvra0AalQzxTzaeRE6fD2Xc9Ze2DZayP/oJUBtjz4HFNJTXiXnOPCah9irvIgWtjku3xADUxp7gDP66Cbecwtf3qSWae0iRCZ1P5RLETBeTey1AHiS6HpqsjFpiAI5f889WHGhO1m2fcvKBKVwHr1fSoOaFxi6fbHcoqDRtMaNGOzTjlUOtse03jV6f6yWQ5oQr7zk2ixzlfEFSGdo+jplR+RE1fu11iiRac9GxbzAxhgLpMCmMlYoJtS5QBDuyXI2U8VyAnzzfK4kCQwLlnIZJNwgFpk+qKKyCyAIOGohXkdxRfR0+iha9YplYk3Hoo4RiMmBViuCQyamrVK90JioKTz+9wIflhORHilgfE3dUa9ZjWwAV8qRT609yFVGGDDkG/VY3dVeYCe/sHOavO1bA1DaRgtuRKHj/BZsD8fuqPIMBlWncabNVCqqvpyg8yq64ZsIabmk33viWyTWkWojEm04HTO5BXhQIiNMA7Z59vlW9XtuGOUkIlJNJ+L58mitY3dnSnrK3mQyYdnCvmpfhfb7ijHTcZKO8d9kyePBLGmJnYEzg73HVO+m03OZBO2AWkolxaJjzEc9jRY48u2ZuR5mwFm/HcZsrGbxea+5YqRIDLx9m0x7q0hlTbogfbHwwPh2eAHoN9G7OEs6n6OhvXp0R8ZO6qyLVchtx6jJk3kr+5JMxABBG2Jx5DUxNv5DZgdWwQZKQnw9NCd4KfPk4vLXQlyRO9AS
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(6636002)(26005)(186003)(356005)(36756003)(7636003)(5660300002)(47076005)(83380400001)(2906002)(70586007)(86362001)(70206006)(6666004)(4326008)(82310400003)(498600001)(336012)(110136005)(107886003)(966005)(36860700001)(36906005)(426003)(2616005)(1076003)(8676002)(8936002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:16.6205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82896737-a9cd-480d-6bf3-08d926a9cc38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5343
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Cornelia, Jason and Co,

This series split the vfio_pci driver into 2 parts: pci drivers and a
subsystem driver that will also be library of code. The main pci driver,
vfio_pci.ko will be used as before and it will bind to the subsystem
driver vfio_pci_core.ko to register to the VFIO subsystem.

This series is coming to solve some of the issues that were raised in
the previous attempts for extending vfio-pci for vendor specific
functionality:
1. https://lkml.org/lkml/2020/5/17/376 by Yan Zhao.
2. https://www.spinics.net/lists/kernel/msg3903996.html by Longfang Liu

This subsystem framework will also ease on adding new vendor specific
functionality to VFIO devices in the future by allowing another module
to provide the pci_driver that can setup number of details before
registering to VFIO subsystem (such as inject its own operations).

This series also extends the "driver_override" mechanism. We added a flag
for pci drivers that will declare themselves as "driver_override" capable
and only declared drivers can use this mechanism in the PCI subsystem.
Other drivers will not be able to bind to devices that use "driver_override".
Also, the PCI driver matching will always look for ID table and will never
generate dummy "match_all" ID table in the PCI subsystem layer. In this
way, we ensure deterministic behaviour with no races with the original
pci drivers. In order to get the best match for "driver_override" drivers,
one can create a userspace program (example can be found at
https://github.com/maxgurtovoy/linux_tools/blob/main/vfio/bind_vfio_pci_driver.py)
that find the 'best match' according to simple algorithm: "the driver
with the fewest '*' matches wins."
For example, the vfio-pci driver will match to any pci device. So it
will have the maximal '*' matches (for all matching IDs: vendor, device,
subvendor, ...).
In case we are looking for a match to mlx5 based device, we'll have a
match to vfio-pci.ko and mlx5-vfio-pci.ko. We'll prefer mlx5-vfio-pci.ko
since it will have less '*' matches (probably vendor and device IDs will
match). This will work in the future for NVMe/Virtio devices that can
match according to a class code or other criteria.

The main goal of this series is to agree on the vfio_pci module split and the
"driver_override" extensions. The follow-up version will include an extended
mlx5_vfio_pci driver that will support VF suspend/resume as well.

This series applied cleanly on top of vfio reflck re-design (still haven't sent
for review) and can be found at:
https://github.com/Mellanox/NVMEoF-P2P/tree/vfio-v4-external.

Max Gurtovoy (11):
  vfio-pci: rename vfio_pci.c to vfio_pci_core.c
  vfio-pci: rename vfio_pci_private.h to vfio_pci_core.h
  vfio-pci: rename vfio_pci_device to vfio_pci_core_device
  vfio-pci: rename ops functions to fit core namings
  vfio-pci: include vfio header in vfio_pci_core.h
  vfio-pci: introduce vfio_pci.c
  vfio-pci: move igd initialization to vfio_pci.c
  PCI: add flags field to pci_device_id structure
  PCI: add matching checks for driver_override binding
  vfio-pci: introduce vfio_pci_core subsystem driver
  mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices

 Documentation/ABI/testing/sysfs-bus-pci       |    6 +-
 Documentation/PCI/pci.rst                     |    1 +
 drivers/pci/pci-driver.c                      |   22 +-
 drivers/vfio/pci/Kconfig                      |   27 +-
 drivers/vfio/pci/Makefile                     |   12 +-
 drivers/vfio/pci/mlx5_vfio_pci.c              |  130 +
 drivers/vfio/pci/vfio_pci.c                   | 2329 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2239 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_igd.c               |   16 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
 include/linux/mod_devicetable.h               |    9 +
 include/linux/pci.h                           |   27 +
 .../linux/vfio_pci_core.h                     |   93 +-
 scripts/mod/devicetable-offsets.c             |    1 +
 scripts/mod/file2alias.c                      |    8 +-
 18 files changed, 2695 insertions(+), 2359 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)

-- 
2.21.0

