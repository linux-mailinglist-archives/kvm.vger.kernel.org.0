Return-Path: <kvm+bounces-4788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6372E818489
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78C571C23EDC
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A662414A90;
	Tue, 19 Dec 2023 09:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EdGd9oVf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C666B1426D
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i63+QSIGN/YtObDOPhHs+ipAbzTyRMDwdvncgjRNbIm1qz8CYMDCnqU8RAtzuOMMxMyUcc0kl5tvK8YAhZFGlCpfC6//MI5WErWg3xoQthJ0CXcPuaIvQfwtBIpRJzvHhdPElaKFK9y1PXp9eiHe3gKFVk/xfKI8Uho/3tbiBd30Sz7LJMyvXFBzms8GRbn5ugFQzJ0ybGiRoMOQdnZTz+an+U0T4dItMAxSA0EVznvYZpGr42bYgkxu9h5pEAkqPt90KXPEjsJMlfBFFXEHiY52Wa0hSufaRtY0enaGADzVIaiDiHgLLDXA/sPYydINi2+RoYz9P2gkU4Zm80Nx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm4GoWU+mfZxO+11gliW4PTuHQxS3d9n5tVBz/rAb4w=;
 b=fK2YY/4CUFRVkcwPEZVJkCChxwBJA++U5l/4WnWekFE7rCwVA9m9+NAnuAO76tJGXknWcVWHy//2Ol8VzrCk83ZBHwExlpQikHle2fGHUzQmIl0ZrFuBznsUZFuJLfU7Qjz6u74Id/hOlAyfp+mreolEF2BOWcN1gD4in9gCL5pWfZDhDG9Gs6bjONt7QY9xYieQwppKZaPW9on8O4tYJXanZb3vHgo4F6N/Of0WBZCvMdKGwDjHH6IdVFY6/AG3VEcjK59csVfKIvQHC4oRKYZ7r68Jek5hC4dZvRB6ufq0Yhiaj2NNB4pCYQM9IPjWqdoQzQxCMej0yio2Tp1EEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm4GoWU+mfZxO+11gliW4PTuHQxS3d9n5tVBz/rAb4w=;
 b=EdGd9oVfr0uJg8zUI3DsHIW8/vaSTfIUTD6T9V5ghi8X1VQo8/EXyIE+79Ga7ijYWx6Edr9/8an4sl69tK9j0cx8HaG4eA0ZUfSebdKQBHNINaiHA0Re+ich4/GEZAt85+MVgMcY/j42Lvv11ZDYu8GMalKnaPVv+IjhX29geODFDsGaWx3tEvvfB8S7OlfqZwOCVOWHsiKc7bO9Whesr4blJhYW+5PK1WSUgYckmyqEKQhXD/qVMREIYwedvXXcKMObW6x3sRf44k6tM8smOJFPCidzayYM3qwccAl9IfLUE6MHKQxqLNr53bqTAMMEGc51aI2kw1EOwGEvPEFkEA==
Received: from MN2PR12CA0016.namprd12.prod.outlook.com (2603:10b6:208:a8::29)
 by IA0PR12MB8864.namprd12.prod.outlook.com (2603:10b6:208:485::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 09:33:56 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:a8:cafe::66) by MN2PR12CA0016.outlook.office365.com
 (2603:10b6:208:a8::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 09:33:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:33:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:33:46 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:33:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:33:42 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Tue, 19 Dec 2023 11:32:38 +0200
Message-ID: <20231219093247.170936-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|IA0PR12MB8864:EE_
X-MS-Office365-Filtering-Correlation-Id: db0639e9-96a1-45a3-8b4c-08dc00759f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	31HAHD5r4lu0T7bmUEPebqLzB8vt6GKZFiJ2yPEKz9UsXWTRVPwfodq5ohwF3LOEjlVw8L9411qapAON3tEpUtOwcxWAcJPPnIwYWjSrEXfTghcxAKozluF54negLfK4gHSekQ+d8CUBXxi+DagrtOrjA0MNcHmrdopII7g6xEDzN2ecgHp1AhKOy6V1LKUPxxz72eoPY/R5DeL/s9Z87CLk0HXZKxwVk7H6hshH5vBnilT3zIRb1gFYzGM4/4T/vLSvZZdJShIt44prDrj7SFyQ3bRiAE3yKKX+PQIa0yjgkgBJ4buWuus/qDqGK2GbXEosfmGmO5P7GCA0K4JeUWpLrLijVbulL5ivdPH+LeOMZHEFcqar6KhOZx7ACsooNRrbbZKO18Klk/oZE0kCiB43oz7sDD9VqcVvnuaRAQwiJkEGi58bw2NZTUZa6AoaL1K5zgau3hHjW2zipIfwsT4nPTxwYvTdQBlzcb9dtkQ3RmPdSmXxlopSX1+uRJFmPdzO0R8YqbtUqlVgmwlxpidh/iMLh1H+6DzfJ0nxO11mJaQtKxb6xxkaw+3OE0NZni//XIdmNlnohCCfYv4Ej4QXKtw3Nb3xG1n67qBypJE4v8qHjO0wz8RXqbGmTqZstSG6UgLTfQgTWtrQmMEckfZ+tDia8WI61e4EqK4ylmTqaue3XjEK2rHmXKFvpFFi8XTXgNHDWf9NDXz412deFzXbD5ANyhzb7MGnwxG5s1Y6Kp8ChNCgoZKml3/COEtvSNFq6SEql8RHZRQHDQiCiXgMfV+m1Yrxl702uZycFInYS5quZMZd9/v4feZnYlBY
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(1800799012)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40460700003)(47076005)(36860700001)(426003)(336012)(356005)(83380400001)(7636003)(82740400003)(41300700001)(86362001)(5660300002)(966005)(4326008)(8936002)(54906003)(8676002)(70586007)(110136005)(316002)(6636002)(70206006)(26005)(2616005)(107886003)(1076003)(478600001)(7696005)(6666004)(30864003)(2906002)(36756003)(40480700001)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:33:56.2774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db0639e9-96a1-45a3-8b4c-08dc00759f5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8864

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

Changes from V9: https://lore.kernel.org/kvm/20231218083755.96281-1-yishaih@nvidia.com/
Virtio:
- Introduce a new config option VIRTIO_PCI_ADMIN_LEGACY which considers X86 or
  COMPILE_TEST, then use it instead of CONFIG_X86.
Vfio:
Patch #9:
- Change Kconfig to depend on VIRTIO_PCI_ADMIN_LEGACY.
- Drop a redundant blank line at the end of Makefile.

The above changes were suggested by Alex.

Changes from V8: https://lore.kernel.org/kvm/20231214123808.76664-1-yishaih@nvidia.com/
Virtio:
- Adapt to support the legacy IO functionality only on X86, as
  was suggested by Michael.
Vfio:
Patch #9:
- Change Kconfig to depend on X86, as suggested by Alex. 
- Add Reviewed-by: Kevin Tian <kevin.tian@intel.com>.

Changes from V7: https://lore.kernel.org/kvm/20231207102820.74820-1-yishaih@nvidia.com/
Virtio:
Patch #6
- Let virtio_pci_admin_has_legacy_io() return false on non X86 systems,
  as was discussed with Michael.
Vfio:
Patch #7, #8:
- Add Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Patch #9:
- Improve the Kconfig description and the commit log, as was suggested by Kevin.
- Rename translate_io_bar_to_mem_bar() to virtiovf_pci_bar0_rw(), as
  was suggested by Kevin.
- Refactor to have virtiovf_pci_write_config() as we have
  virtiovf_pci_read_config(), as was suggested by Kevin.
- Drop a note about MSIX which doesn't give any real value, as was
  suggested by Kevin.

Changes from V6: https://lore.kernel.org/kvm/20231206083857.241946-1-yishaih@nvidia.com/
Vfio:
- Put the pm_runtime stuff into translate_io_bar_to_mem_bar() and
  organize the callers to be more success oriented, as suggested by Jason.
- Add missing 'ops' (i.e. 'detach_ioas' and 'device_feature'), as mentioned by Jason.
- Clean virtiovf_bar0_exists() to cast to bool automatically, as
  suggested by Jason.
- Add Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>.

Changes from V5: https://lore.kernel.org/kvm/20231205170623.197877-1-yishaih@nvidia.com/
Vfio:
- Rename vfio_pci_iowrite64 to vfio_pci_core_iowrite64 as was mentioned
  by Alex.

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

 MAINTAINERS                                 |   7 +
 drivers/vfio/pci/Kconfig                    |   2 +
 drivers/vfio/pci/Makefile                   |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c            |  57 +-
 drivers/vfio/pci/virtio/Kconfig             |  15 +
 drivers/vfio/pci/virtio/Makefile            |   3 +
 drivers/vfio/pci/virtio/main.c              | 576 ++++++++++++++++++++
 drivers/virtio/Kconfig                      |   5 +
 drivers/virtio/Makefile                     |   1 +
 drivers/virtio/virtio.c                     |  37 +-
 drivers/virtio/virtio_pci_admin_legacy_io.c | 244 +++++++++
 drivers/virtio/virtio_pci_common.c          |  14 +
 drivers/virtio/virtio_pci_common.h          |  42 +-
 drivers/virtio/virtio_pci_modern.c          | 259 ++++++++-
 drivers/virtio/virtio_pci_modern_dev.c      |  24 +-
 include/linux/vfio_pci_core.h               |  20 +
 include/linux/virtio.h                      |   8 +
 include/linux/virtio_config.h               |   4 +
 include/linux/virtio_pci_admin.h            |  23 +
 include/linux/virtio_pci_modern.h           |   2 +
 include/uapi/linux/virtio_config.h          |   8 +-
 include/uapi/linux/virtio_pci.h             |  68 +++
 22 files changed, 1385 insertions(+), 36 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 drivers/virtio/virtio_pci_admin_legacy_io.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


