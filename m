Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951363F3FD4
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhHVOhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:37:39 -0400
Received: from mail-bn8nam11on2076.outbound.protection.outlook.com ([40.107.236.76]:62084
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233009AbhHVOhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:37:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOJws1GootFIn1jA6SVC6qQn95rpBMMqx//CoF9MVv6G3ZXxuvU0eDsgVd8NRTgs+bOkLTYCXebQaFEwnO+K2QkJmmAXv3Xkiz2IYmwmw9ngyAzVCDZl6VzfsVtqWZYs9m6tKShYD/t6iliuBEXGwBJFVkstn+O5sZ73MDekLJlw2UCS4RsQJbb1/hVPYgvbESZWCD5bXlX8+1f4ZS0tupd91SWob1MDK3Cx1O+7sCxnAleifI9b4jIQc6arDfZVpdNact+kutGqPDFsbWdR8bUnHIAMY2ZB3/MUqyFyi7+ySPV4E1uc5BT2xZnnExbW6U0sgbNCGfUO0Dpc6NG/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA4q+NGPv66yFxtD6G8mvChZBXyE3HbO9Du7FbA7wc4=;
 b=VZPSB5wpxNWoQM7jC5gdKQPHNhcQLfIqxotpKR/TfFt3lSbhK81DxJ6nnR3uHvhyUumI1gATGxfELnh6GxMgW8lIrGW4wsK/GOvVoFnEE6gj2KDe16O6qeRjDsz0rixCP0XKjpuzr2A4yHpnqbkZVTvCkeT2Ifotyxp7+kG6AZOfs/v5da0HW4joy5gBMEKbp14myn5ntgy82XZ2sqq9TY5/ittv3B6zy6xlOX4G7mUmQQG5ngwMqct5YaB3qPie+bSaM53FkJTheucRWW9qtIDPprvspl8KJn2M+6Jkv1sEZnkxiMhpmYhaDAxv9B2xf8PfjGMhI41NIP2rh4JO3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA4q+NGPv66yFxtD6G8mvChZBXyE3HbO9Du7FbA7wc4=;
 b=nFHpul+b07ZdmaqqQdPoGa4UvTtANgxSBfWXwpfY5oEQeArTfG9VgKc64Ey+V3/dJOBW07w9Tx93ia1pWbV2vB7Pa1Hh0uv9CBTm+gJsPKujdxvq2WenvTKngMbC6fgfIGz0iONwMmWvwJmpIkJCjZVIOiFBps3xBcNmRTSKujbkDd3wKBeCFNu1KU/ttGXS5w5+SP5CKlEEGlrxSwAKXEjVfHypZpVKo/X19FRUa08TfkYMIYO/rONFyWNtXM5Lxq6eFhqo6vJ5Ir8FFHUgQBktJrOh+jlezF3EHhMQSvgEtPpcsGxX4S9G/wQV9eX1Rtkf/GXv38jpMqj7oAjIYg==
Received: from BN8PR16CA0014.namprd16.prod.outlook.com (2603:10b6:408:4c::27)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Sun, 22 Aug
 2021 14:36:55 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::fc) by BN8PR16CA0014.outlook.office365.com
 (2603:10b6:408:4c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:36:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:36:54 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 07:36:54 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:36:50 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V3 00/13] Introduce vfio_pci_core subsystem
Date:   Sun, 22 Aug 2021 17:35:49 +0300
Message-ID: <20210822143602.153816-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ac7bf8c-438b-4a1d-a8a9-08d9657a49f0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-Microsoft-Antispam-PRVS: <DM6PR12MB42674FA0C3932F34EDB0CAE6C3C39@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuqED++V1a6cjwpfTEnZbP6em+6yg+GlPTHT/z7e5u0j4PQeO4F+wxv5U+FZEnSL9QzztZpcpUCzhvlX4iIyzPnmcFj/km2CQxblg9uw1/Mf8hTZbTHPCp39dG7JgINPKy6TUOrnpM8wgrjcQKkEmPAXCo7ywZ5GKWDMvdvSCw7z0xEQImsWTm5NsnTIiN5RdObidvMwVJc8p/nPlQZRCt3MDjJ/PuU+hWrgH9kwaZ0mrsnUZPZInXtbQLI7GiSdDQ+DCqfNPoSD+dvKTnsmcWRKobRDrj+lkdT8534gEz0bUpQNiKf0NjPqJji/7HkUilvSuSMv9g2H/k+BmZzPfjwj+oRnrogeAkk2FA9ks9367S1wHob0SaDyBB8DDU/axrRlzPK+iO4cUEq1vGl/Qw9vAoGiXsrxzzOBjUe0BZtBfusxubctkgz65TUwI5ypIpuPTa2pljk175J/U5GF+PwZp+28/4fZOCi+bk4aeVQh1aOwYYqMOdyLVTmWxY/41oz93lK+QVv0KoJcv2SpsrddHbxPw3EtM4ywjAOsemSCRQ6t9o/FuKLaQpplpRCWJn3NdCDDLrfV2PsLK7dQHIrMrsmRlmqbsamqERcQ6DKVAAN8OpmU6Yb+mYMFm3QAjnMkQ++m88uzC0R8T4oDTrj5lqbg4S0sCOHBVfgXqtyRV+NctT3qjOEjXB4Is0f6DSYYssFgsm9HT4PO6TWs2AEilDOfOrLPAX0ZuYkcyaC34co0TZPGKQppjNZ2eAV2myK8A6CiZQ6fR9QzKlqThum/k+Adxemgfeuf64aK/o0YBXsUCizsc+vnAvser0h53lh3hNKduIuQrZ4+Dqmc9Cozh2ZnSjF8XKO7Oo6zSRQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(426003)(70206006)(107886003)(336012)(8676002)(26005)(2906002)(8936002)(70586007)(7416002)(1076003)(36756003)(7696005)(47076005)(82310400003)(86362001)(83380400001)(2616005)(54906003)(110136005)(5660300002)(508600001)(4326008)(966005)(36860700001)(7636003)(356005)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:36:54.7661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac7bf8c-438b-4a1d-a8a9-08d9657a49f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prologue:

This is the second series of three to send the "mlx5_vfio_pci" driver
that has been discussed on the list for a while now. It comes on top of
the first series (i.e. Reorganize reflck to support splitting vfio_pci)
that was merged already.

 - Split vfio_pci into vfio_pci/vfio_pci_core and provide infrastructure
   for non-generic VFIO PCI drivers.
 - The new driver mlx5_vfio_pci that is a full implementation of
   suspend/resume functionality for mlx5 devices.

A preview of the third series for mlx5_vfio_pci can be seen here:
https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
=====================

From Max Gurtovoy:
====================
This series splits the vfio_pci driver into two parts, a PCI driver and
a subsystem driver that will also be library of code. The main PCI
driver, vfio_pci.ko, will remain as before and it will use the library
module vfio_pci_core.ko to help create the vfio_device.

This series is intended to solve the issues that were raised in the
previous attempts for extending vfio-pci for device specific
functionality:

1.
https://lore.kernel.org/kvm/20200518024202.13996-1-yan.y.zhao@intel.com
   by Yan Zhao
2.
https://lore.kernel.org/kvm/20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com
   by Longfang Liu

Also to support proposed future changes to virtio and other common
protocols to support migration:

https://lists.oasis-open.org/archives/virtio-comment/202106/msg00044.html

This subsystem framework will also ease adding new device specific
functionality to VFIO devices in the future by allowing another module
to provide the pci_driver that can setup a number of details before
registering to the VFIO subsystem, such as injecting its own operations.

This series also extends the "driver_override" mechanism. A flag is
added for PCI drivers that will declare themselves as "driver_override"
capable which sends their match table to the modules.alias file but
otherwise leaves them outside of the normal driver core auto-binding
world, like vfio_pci.

In order to get the best match for "driver_override" drivers, one can
create a userspace program to inspect the modules.alias, an example can
be found at:

https://github.com/maxgurtovoy/linux_tools/blob/main/vfio/bind_vfio_pci_driver.py

Which finds the 'best match' according to a simple algorithm: "the
driver with the fewest '*' matches wins."

For example, the vfio-pci driver will match to any pci device. So it
will have the maximal '*' matches.

In case we are looking for a match to a mlx5 based device, we'll have a
match to vfio-pci.ko and mlx5-vfio-pci.ko. We'll prefer mlx5-vfio-pci.ko
since it will have less '*' matches (probably vendor and device IDs will
match). This will work in the future for NVMe/Virtio devices that can
match according to a class code or other criteria.

v3:
Patch #6:
- Upon error flow, print PF driver name instead of hard-coded vfio-pci.
Patch #9:
- Split into two patches and follow the notes given by Bjorn Helgaas.

v2:
Patch #6:
- Drop DRIVER_VERSION as it's useless and not required any more.

Patch #9:
- Follow Bjorn Helgaas suggestion to enable having "vfio_" prefix in
  modules.alias file without the unnecessary VFIO connection in
  pci_match_device.

- Add the sequence of commands/algorithm that is required by
  userspace to discover the matching driver to the commit message to let
  the patch documentation be self-contained.

Patch #12:
- Save compatibility with Kconfig as was asked in the mailing list.
- Drop DRIVER_VERSION as it's useless and not required any more.

Yishai

Jason Gunthorpe (2):
  vfio: Use select for eventfd
  vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'

Max Gurtovoy (10):
  vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
  vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
  vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
  vfio/pci: Rename ops functions to fit core namings
  vfio/pci: Include vfio header in vfio_pci_core.h
  vfio/pci: Split the pci_driver code out of vfio_pci_core.c
  vfio/pci: Move igd initialization to vfio_pci.c
  PCI: Add 'override_only' field to struct pci_device_id
  PCI / VFIO: Add 'override_only' support for VFIO PCI sub system
  vfio/pci: Introduce vfio_pci_core.ko

Yishai Hadas (1):
  vfio/pci: Move module parameters to vfio_pci.c

 Documentation/PCI/pci.rst                     |    1 +
 drivers/pci/pci-driver.c                      |   28 +-
 drivers/vfio/Kconfig                          |   29 +-
 drivers/vfio/fsl-mc/Kconfig                   |    3 +-
 drivers/vfio/mdev/Kconfig                     |    1 -
 drivers/vfio/pci/Kconfig                      |   40 +-
 drivers/vfio/pci/Makefile                     |    8 +-
 drivers/vfio/pci/vfio_pci.c                   | 2262 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2160 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
 drivers/vfio/platform/Kconfig                 |    6 +-
 drivers/vfio/platform/reset/Kconfig           |    4 +-
 include/linux/mod_devicetable.h               |    6 +
 include/linux/pci.h                           |   29 +
 .../linux/vfio_pci_core.h                     |   89 +-
 scripts/mod/devicetable-offsets.c             |    1 +
 scripts/mod/file2alias.c                      |    8 +-
 21 files changed, 2518 insertions(+), 2310 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)

-- 
2.18.1

