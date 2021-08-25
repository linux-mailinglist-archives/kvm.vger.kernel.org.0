Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F93F3F7656
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbhHYNwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:52:47 -0400
Received: from mail-bn8nam12on2080.outbound.protection.outlook.com ([40.107.237.80]:2208
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240294AbhHYNwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:52:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bT0tWTbuWudaogVMMVrBopuHIVNRZNLwErfOvKS7OffcqlwVgiD7/3hqdnMgN3w+QF4GUySEKSqamqTjv8HF5fumczIkWu5yLbEkWEumrVmfCbF71FuVGyWYY4M1sOwz2flIkz8krCPRtZy7lwznVEgd187FTICTyKL4uVlOpO7I8MPoyPTiwbannG0BKJtdz+0mn9K46RD42YuXlvY7VMwzFOqvfUU6V/Xsf9DlNAwwa9mganaVOdqZ0aCZNWR++dkOUARWTCiUHSP5ihXYJ9gVQ3d/jZT5xe4RxPMjLPQWbG6e+54PUsmt55yqlAXCne+/56chgTPyFbMUGP3roQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yrSRaR+bqQt1ZpL8ctIvtTSSPVi3OiuoGWr8xwrr2w=;
 b=hMDFihFat+7GhovQ9F49bcN7GUkDLl7WWO2+oKE0eYBtR8elFdMdCVVS9UxT3pdCPec76b21va6e7WeAJPOzZU58sHFn+HzjhDLSL1I2IGD7dwuqJGET/Z8W8SVeo/ef+jcDlPfWGzUKm8V2jsDF/YDt0rHlEmeM4pqYak/vLS6CTkrCL8vwLnwkhi/ic6CI7FQTs7n4tmjHG3ceUWxKscJ6R6a0L5qVLl9b9k42FzRwsKw/BYKrSDWo5zz8goI3YdycauyrLV7s896onW2j4iHU4XrpwFzTPR0ipU8EGstFdXsGrjq7t3kRjpQmupaGA7rilD16sQyiknE6UcR6Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yrSRaR+bqQt1ZpL8ctIvtTSSPVi3OiuoGWr8xwrr2w=;
 b=XfE+WGlUKm0urIgzKXxKwOxq/sRxlL9y4YAfgLlbTNDd5KgwIsrv27cWlsbfBPPdpTmdeqoUmhEESdoGC7Hx14iM0cJR0FPytq6goce7gBFlCOiCCSQZVXkh2c1JQDt3B5p5OrmROOnWtlHtud1MantyJHt4re/vXgE5HErPxqhgY4xzUUL6mzUgWQnnRRzIezG0RZxpTn3A5sxZy8rAnvrEuyLfnARM9qBddrJ5B/W9Ld6q5sD0w2NVsoe2Rv2G78fdwAx29bOlWvtQRZ4dS2EjaLMKJ+TnU0O5Pv/YS+A7Q5v0o2KVltqQxC6/YvJSgC8dikZuIugg03VZjzAk8w==
Received: from MWHPR22CA0059.namprd22.prod.outlook.com (2603:10b6:300:12a::21)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 13:51:58 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::5b) by MWHPR22CA0059.outlook.office365.com
 (2603:10b6:300:12a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Wed, 25 Aug 2021 13:51:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:51:57 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:51:57 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:51:53 -0700
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
Subject: [PATCH V4 00/13] Introduce vfio_pci_core subsystem
Date:   Wed, 25 Aug 2021 16:51:26 +0300
Message-ID: <20210825135139.79034-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee104d5b-ef27-47b1-9234-08d967cf8194
X-MS-TrafficTypeDiagnostic: BY5PR12MB4067:
X-Microsoft-Antispam-PRVS: <BY5PR12MB40676716AC508C0FC511999EC3C69@BY5PR12MB4067.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q7ax3xXo2P+VybE99ppf1yIAbUKFa/mB/ckki+sFHE6BdVU87J0bEDA4nCiiHzYzaNqP4hFAI4lnZYJDpTv4dKzMOnfxYy0ANgNlJ614J0Mokqdgr8RRmTL12ODgZ52ysKB8A2hs27I/mV86tpHKwGSyIXcJJP8pWPtLGNRtpPKdaWeRHa7Pn0YmLVdwL18PdvIHbP+ULYNu4fxK98cj0cFAK0A1MAh8+xS3MxJqY7EVGYg51OOf1xVtOm2TYU+2pXIZP7Oh6YOs9Yh+HTMceOLZd6z6jiLjm4UY1OWxnpNIuIpG+Hcba7Ga+6uOXmbzDOw7xSUqXb8LgH2i7j1j2Fe8okILJY+2KSMNUho6qnplXUaOa0N50EtPLc0RsL+VeXiZXM0kXFZRGy1U+5pAtuVBMEnrrs0ttw56puyoYUczU2BZM1T+wBRGh+O0Yowq9t58v4YLs6zf/uM3SKdMg8BmrMdspIb/jLwpxFueUL14RB2UjDFvJB/z9lyJqRymFjvVwBKxX5i5d7Zts7t3pB7YHbaogh52/inQ5+GccA3HrUmQcx4qHEjLdviz5cziUhI8KYpCIADXmbCW8D7NkV+ooAr3hmq3Eta3BeLHTK0kOF5rCojWQNa8cmLHt6D0ecgO5eUQFwYNkqYnwFJJa2VoefTqejpeDJmziQ9noH2EVa/GqyqSD+cg9Wer3UopKQ7U1peP94iwC/oXkyzbNb50dTWCeiFmHDsIPuYeZJLHAvliYlCJenVN/4mTRWcDSyNbZfcKsV9RTSeHqJiqKRkiN5hnJ3+V0oFa11iDnhMeTIa49OHoppq+RRGGvdU3DgMgLmpSNU8SDg6cGqFezQqTGREEmynyeX2Xg1BZ2co=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(82740400003)(70206006)(426003)(2906002)(6666004)(8676002)(336012)(26005)(356005)(186003)(70586007)(5660300002)(36756003)(110136005)(86362001)(4326008)(478600001)(966005)(2616005)(82310400003)(54906003)(7696005)(7636003)(83380400001)(36906005)(7416002)(316002)(36860700001)(107886003)(47076005)(1076003)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:51:57.8205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee104d5b-ef27-47b1-9234-08d967cf8194
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

v4:
Patch #6:
- Delete might_sleep() from the vfio_pci_sriov_configure() path as the
  annotation through mutex_lock() which is used down the road is enough
  on its own.

Patch #13:
- Add include/linux/vfio_pci_core.h to the MAINTAINERS file as was
  previously asked by Alex Williamson.

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
 MAINTAINERS                                   |    1 +
 drivers/pci/pci-driver.c                      |   28 +-
 drivers/vfio/Kconfig                          |   29 +-
 drivers/vfio/fsl-mc/Kconfig                   |    3 +-
 drivers/vfio/mdev/Kconfig                     |    1 -
 drivers/vfio/pci/Kconfig                      |   40 +-
 drivers/vfio/pci/Makefile                     |    8 +-
 drivers/vfio/pci/vfio_pci.c                   | 2262 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2158 ++++++++++++++++
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
 22 files changed, 2516 insertions(+), 2311 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)

-- 
2.18.1

