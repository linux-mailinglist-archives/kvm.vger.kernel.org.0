Return-Path: <kvm+bounces-3599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1B4805ABB
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D53131F216CD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989CE692A1;
	Tue,  5 Dec 2023 17:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r0ELxZ2M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB701B6
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PydCQuV6bLUx4cRlPGGV3qgD1gitQBAOW0DzB2BdGbiuQT5E+fgBJBbF0m8wptHvOZCpR9S1QDwuini6CJujRTyKJgYiW41zEdMwtI5kTM4tYUXw8ZrAV65TAE1LpBv1ftfb7tg7mpUB/vDDrfLBAgWvCNWG7v5Q2Uh1JEEix1V9LuIeaBJ397T9aQzg3p4w7Bnn/WFZUHpdlS21/VtMJLxG68S75XeydfGmi1Oc8ON4jvJj/f6Whh07fDUUVDWqn3Yj9fOXNE2q0VdYp8r8S9rnR2m3aZy7h7ySJm6fu7nuXI1pKL36kNBSi3MFCng2EzYuQ2Vyj8VDp7x+3lEM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5CXY6sMad8zz+R1/moTWKOwYAoLMiqU1RZLbT6gEWo=;
 b=Cvz/oXPI3v08H3lqn8faBLFj3x4aKcYofr9BmlCYfx0LF6W3EQK45sR+7EOLGWN+bGeudqdnnIC6Qfg8qyIlMWFbJHKTViihPpLEfZHWR/1w0mFY7j8AbwTkpJKBuNbxkmj/6gTa7hhRJkdAIO1FCcSgXEus2KDAnzjHGasfs+4BYTvmb8nt8HfFD5cxvyVyyiF91zRrcaVaLNKEamzYUjo0i2n5IiLJvtJxYbPadk+G8Kj2+omaiZBCfkf+BIrGEFnqgzIzuBCq0gqt3SgRzLO7DyfKxYtke1dc8GbSA3CTRIkYj07QMvRBM2cig7y1/880zhIZVzWCGVekTECV8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5CXY6sMad8zz+R1/moTWKOwYAoLMiqU1RZLbT6gEWo=;
 b=r0ELxZ2McQkQY6UcRaQg0X5ITYFm2eijN06JNJkkg26yifgiz0MA/5BkOPdTkgeZ+idh+qmQFWQ53jjcZxWm4WfTilbh/PZaz35eZ0BPDsLRGa3v7IsjHBbppOpWeb3xDmuPAizzWpz2xwvdlfEbpp9Ipfr5Yd2641yXdUj2xhahJg5wg7NnZYvj5aomuiYaQUSkjG8lVBWiZSsRTMG3NY9x679ZirV7dB3aBh27xxrjxFQl7QxzKAmRZpxsQo7zI41CQ2LKRjazlL64Rh6Qu1hGHO0Dkw41YR90cRv0FIIt+IoDSa7UzDHqtO5zeDP+joioN72R6JD7iz4vrT43TA==
Received: from MW4PR04CA0128.namprd04.prod.outlook.com (2603:10b6:303:84::13)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:12 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:303:84:cafe::3a) by MW4PR04CA0128.outlook.office365.com
 (2603:10b6:303:84::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 17:07:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:06:53 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:06:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:06:49 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Tue, 5 Dec 2023 19:06:14 +0200
Message-ID: <20231205170623.197877-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: db0e5474-17d1-4e4a-896a-08dbf5b49f4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8i+7+7gldj3V80fY1YL7jVq64OpPDt3m740U/q0JC1HUjUvjBacwSDFCol47kyy2DuF/AToCYwpKgTAQofTVOwgL9mLzV5teXhnABAYNrB8pX21PqeIkK1QLGsbc7BhTkISx2D0G1OkKeSOgihp2j/GoTZXZ2d1gn/AG3MvSkhL06U3z6gCQGWevSx6+8TjDYHTpqrdk4EaviX61o7w7hxVBP5q3MKxygKrmzuEWbwto4ifqGi1ehQYJspaceaHALK08gBj7ilWP5bgs8HrYfvZ6FTilCRSRErlB7L5EC6OVm6Dr21rT2rygApsrh6ZJTAYbxk5WCRTCiqgtMUdeWy+eAqTteiBfyEMq/fAp46OD2vxkN2vIyCT4+rKgrFuI3D1mgqfhvhczhDGYHrtSgoFbz6KA898zDuloK/iKLmaFdcQXPx01qg/ZBSvCJRuMX6NeEFLep5dGhxuYD49HN+PgCR8LUSl1jSjA48Dmn6XP5HppB1f6Lp4bect3dnN2LpQ+UZf9aidCz2/8y16Sj6ky8Q6OlGHY8QuZ8N2hEWXXOkmYrrbPMUEj8lPBZ+tjtS/xfwrsIFY5htMWCjZJSwiQkUZ5V4suhBsD5gGTpTytLcTgqvKcnV3t+DViZDj9ZlmvFF05zbCu/qkL2lkA6m4oLD+K9QKzDxPJCbye7OT7ZocQy3lOtZgPwc/cmSV3LoE99EDHFxAuFbuGR9Q/A5vzcaJfT14t72UEbex7DqUcPCuMsXvYuGkrEKZgFVTQH5ZyYYtV1BNT1aUjXNYtM40A+vdp/gE496+dEsxvK2mH7JY4U+1LmOuk50+i22KB51SAB8pn0VP4f1rpLcEwDm20ZE4S+m5E+ZIJPUjKKf4=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(36840700001)(40470700004)(46966006)(40480700001)(36860700001)(2906002)(316002)(110136005)(54906003)(6636002)(7636003)(70586007)(8676002)(86362001)(70206006)(36756003)(41300700001)(8936002)(4326008)(356005)(47076005)(5660300002)(82740400003)(966005)(83380400001)(478600001)(40460700003)(426003)(26005)(1076003)(336012)(7696005)(107886003)(6666004)(2616005)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:11.6940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db0e5474-17d1-4e4a-896a-08dbf5b49f4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056

This series introduce a vfio driver over virtio devices to support the
legacy interface functionality for VFs.

Background, from the virtio spec [1].
--------------------------------------------------------------------
In some systems, there is a need to support a virtio legacy driver with
a device that does not directly support the legacy interface. In such
scenarios, a group owner device can provide the legacy interface
functionality for the group member devices. The driver of the owner
device can then access the legacy interface of a member device on behalf
of the legacy member device driver.

For example, with the SR-IOV group type, group members (VFs) can not
present the legacy interface in an I/O BAR in BAR0 as expected by the
legacy pci driver. If the legacy driver is running inside a virtual
machine, the hypervisor executing the virtual machine can present a
virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
legacy driver accesses to this I/O BAR and forwards them to the group
owner device (PF) using group administration commands.
--------------------------------------------------------------------

The first 6 patches are in the virtio area and handle the below:
- Introduce the admin virtqueue infrastcture.
- Expose the layout of the commands that should be used for
  supporting the legacy access.
- Expose APIs to enable upper layers as of vfio, net, etc
  to execute admin commands.

The above follows the virtio spec that was lastly accepted in that area
[1].

The last 3 patches are in the vfio area and handle the below:
- Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
- Introduce a vfio driver over virtio devices to support the legacy
  interface functionality for VFs. 

The series was tested successfully over virtio-net VFs in the host,
while running in the guest both modern and legacy drivers.

[1]
https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c

Changes from V4: https://lore.kernel.org/all/20231129143746.6153-7-yishaih@nvidia.com/T/
Virtio:
- Drop the unused macro 'VIRTIO_ADMIN_MAX_CMD_OPCODE' as was asked by
  Michael.
- Add Acked-by: Michael S. Tsirkin <mst@redhat.com>
Vfio:
- Export vfio_pci_core_setup_barmap() in place and rename
  vfio_pci_iowrite/read<xxx> to have the 'core' prefix as part of the
  functions names, as was discussed with Alex.
- Improve packing of struct virtiovf_pci_core_device, as was suggested
  by Alex.
- Upon reset, set 'pci_cmd' back to zero, in addition, if
  the user didn't set the 'PCI_COMMAND_IO' bit, return -EIO upon any
  read/write towards the IO bar, as was suggested by Alex.
- Enforce by BUILD_BUG_ON that 'bar0_virtual_buf_size' is power of 2 as
  part of virtiovf_pci_init_device() and clean the 'sizing calculation'
  code accordingly, as was suggested by Alex.

Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
Virtio:
- Rebase on top of 6.7 rc3.
Vfio:
- Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.

Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
Virtio:
- Rebase on top of 6.7 rc1.
- Add a mutex to serialize admin commands execution and virtqueue
  deletion, as was suggested by Michael.
- Remove the 'ref_count' usage which is not needed any more.
- Reduce the depth of the admin vq to match a single command at a given time.
- Add a supported check upon command execution and move to use a single
  flow of virtqueue_exec_admin_cmd().
- Improve the description of the exported commands to better match the
  specification and the expected usage as was asked by Michael.

Vfio:
- Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
  supply the 'offset' within the relevant configuration area, following
  the virtio exported APIs.

Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
Virtio:
- Drop its first patch, it was accepted upstream already.
- Add a new patch (#6) which initializes the supported admin commands
  upon admin queue activation as was suggested by Michael.
- Split the legacy_io_read/write commands per common/device
  configuration as was asked by Michael.
- Don't expose any more the list query/used APIs outside of virtio.
- Instead, expose an API to check whether the legacy io functionality is
  supported as was suggested by Michael.
- Fix some Krobot's note by adding the missing include file.

Vfio:
- Refer specifically to virtio-net as part of the driver/module description
  as Alex asked.
- Change to check MSIX enablement based on the irq type of the given vfio
  core device. In addition, drop its capable checking from the probe flow
  as was asked by Alex.
- Adapt to use the new virtio exposed APIs and clean some code accordingly.
- Adapt to some cleaner style code in some places (if/else) as was suggested
  by Alex.
- Fix the range_intersect_range() function and adapt its usage as was
  pointed by Alex.
- Make struct virtiovf_pci_core_device better packed.
- Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
  the ML.
- Add support for the 'bar sizing negotiation' as was asked by Alex.
- Drop the 'acc' from the 'ops' as Alex asked.

Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html

Virtio:
- Fix the common config map size issue that was reported by Michael
  Tsirkin.
- Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
  Michael, instead skip the AQ specifically.
- Move admin vq implementation into virtio_pci_modern.c as was asked by
  Michael.
- Rename structure virtio_avq to virtio_pci_admin_vq and some extra
  corresponding renames.
- Remove exported symbols virtio_pci_vf_get_pf_dev(),
  virtio_admin_cmd_exec() as now callers are local to the module.
- Handle inflight commands as part of the device reset flow.
- Introduce APIs per admin command in virtio-pci as was asked by Michael.

Vfio:
- Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
  vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
  Alex.
- Drop the intermediate patch which prepares the commands and calls the
  generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
- Instead, call directly to the new APIs per admin command that are
  exported from Virtio - based on Michael's request.
- Enable only virtio-net as part of the pci_device_id table to enforce
  upon binding only what is supported as suggested by Alex.
- Add support for byte-wise access (read/write) over the device config
  region as was asked by Alex.
- Consider whether MSIX is practically enabled/disabled to choose the
  right opcode upon issuing read/write admin command, as mentioned
  by Michael.
- Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
  as was suggested by Michael.
- Set the '.close_device' op to vfio_pci_core_close_device() as was
  pointed by Alex.
- Adapt to Vfio multi-line comment style in a few places.
- Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
  to be CCed for the new driver as was suggested by Jason.

Yishai

Feng Liu (4):
  virtio: Define feature bit for administration virtqueue
  virtio-pci: Introduce admin virtqueue
  virtio-pci: Introduce admin command sending function
  virtio-pci: Introduce admin commands

Yishai Hadas (5):
  virtio-pci: Initialize the supported admin commands
  virtio-pci: Introduce APIs to execute legacy IO admin commands
  vfio/pci: Expose vfio_pci_core_setup_barmap()
  vfio/pci: Expose vfio_pci_core_iowrite/read##size()
  vfio/virtio: Introduce a vfio driver over virtio devices

 MAINTAINERS                            |   7 +
 drivers/vfio/pci/Kconfig               |   2 +
 drivers/vfio/pci/Makefile              |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c       |  53 +--
 drivers/vfio/pci/virtio/Kconfig        |  16 +
 drivers/vfio/pci/virtio/Makefile       |   4 +
 drivers/vfio/pci/virtio/main.c         | 569 +++++++++++++++++++++++++
 drivers/virtio/virtio.c                |  37 +-
 drivers/virtio/virtio_pci_common.c     |  14 +
 drivers/virtio/virtio_pci_common.h     |  21 +-
 drivers/virtio/virtio_pci_modern.c     | 503 +++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  24 +-
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |   8 +
 include/linux/virtio_config.h          |   4 +
 include/linux/virtio_pci_admin.h       |  21 +
 include/linux/virtio_pci_modern.h      |   2 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  68 +++
 19 files changed, 1349 insertions(+), 34 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


