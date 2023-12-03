Return-Path: <kvm+bounces-3270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 633C78024DF
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 15:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D33D9280E27
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 14:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3B414F60;
	Sun,  3 Dec 2023 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gs3/wEpY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9D0E8
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 06:54:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeNyCkTuy/SnaBcuyLm1stWRCiH0JESn1OkVKAuGHbTh6PzwWYUOx3KXyt0/KoRZ/HkvsbMLJc0VelHImA2Z4dQlvTxMXBLJctbJ6llzJWiSVnHwBnik0GB78StrxM6QB3gfg1pOc4eJS2v0lWHj3mMeUDRBpRHVzHtVj4Y3CMVikANfEwsiAnhDNA1pH+S5r7YXKRuhMWfW48WO0uwlsZUud1tvcfoli+D5Pqt8HPDQtzmABNi63T2lYjPw/XpKczzigGeUDkuWz+3TAlUQa77JO8Pj+ZPrrdk2pVUTdxPVVxBhWVe8lmjB5l/hMWMKWDR9Lai5Hj2YtKMzFOIcHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMgEYQQmlWgoY8wt2ZtCtBgTogPdEqUF23ykxBVBW9k=;
 b=PTxJOhGxHI4ErvU0yhvxK88vccgRHhO+knLxvSBB5hV3EHzvdpBihQni0TE0jhTj9dVU4zdQZ9hMQ8yq0/htzQff+QxUb3WZclBRkc1OfNrks+H7eMwry7ZRiXMGkLPORgu/NXDe3W1eZ7JGn4uu9w6Yvdfulk+u1JXWY+g9y6rclRG2wR3lxiQh5VE0+M+4UpIdD9WaozFWv/EbheOLTGbHvGV106OrLObEDA50BNQId9DHA3P4KA+7SX/j9slP10Qt1SQTdIrOruH62ybNAnBE7BBXzeypgPTbkIIOESWsY83mprb/pdIOwmCc4j9v6oC7K2LX1Wgqug2vO/kzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMgEYQQmlWgoY8wt2ZtCtBgTogPdEqUF23ykxBVBW9k=;
 b=gs3/wEpYK+HZS1ea4EejaNP43ALX0/pWqk3fped8NlNQUkv4Skzo5CdFfkFlZqcRigEU4SPH+1ffThuiRooMrxieTWpZ+a2SYD/W1bVmtPv7PepHkfb+Enfr3DQ6eDPzoNntjMUo5S1LLFPI4UxYsyv5ByoDCcuW390dO3knwNbi2XRTy/Apeik2QkEvC5zqjlPrEI/oSWVAI8Io0ZXbDiNi/9Ancxp48p7PeZzyjxIEb4RChyPy+yEnjKq0JC9MIMuqt6lSgExk0TDY1UExibth1ja+tMmExpYt6+NvFsuti8RdqRP55+nmGlEUrnaEPT8w865rkuSdNFaeskp48A==
Received: from DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11) by
 IA1PR12MB6281.namprd12.prod.outlook.com (2603:10b6:208:3e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Sun, 3 Dec
 2023 14:54:51 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:5:296:cafe::e6) by DM6PR01CA0006.outlook.office365.com
 (2603:10b6:5:296::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33 via Frontend
 Transport; Sun, 3 Dec 2023 14:54:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Sun, 3 Dec 2023 14:54:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 3 Dec 2023
 06:54:49 -0800
Received: from [172.27.21.98] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 3 Dec 2023
 06:54:44 -0800
Message-ID: <a1c51a88-65db-479d-90c8-730acaf1b664@nvidia.com>
Date: Sun, 3 Dec 2023 16:54:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>, <tzurielk@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
 <20231129143746.6153-10-yishaih@nvidia.com>
 <20231130151025.045bdddf.alex.williamson@redhat.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231130151025.045bdddf.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|IA1PR12MB6281:EE_
X-MS-Office365-Filtering-Correlation-Id: 25d11cc4-b294-4474-4c69-08dbf40fcda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i9lklvldb9D19MuYdB7x7kpe2ZXpCTvOLxaZSb6lZ+4sWCidNQXF4v85GmJk2K5Be0eclP5BWWYbdWUO5lcZXxHwCKVXh2dPvIpQCd08i+RQsG8oNOVBY8Ezr57JAa7KN0h36Cpsde9Z3xOnvQll1bnq3MWLdw385X1+fLPtPbJdW6anqz0KdBah+CXuk3315L2XRN1KYRbHUXbUYfH+njNaaP+5UIDzghR1FPUEfK5bBJ3ia+1g8iUdyrnc4zgfrCp7BCMA8m2ET+8/aM9J1xBVMdqQfUN78wEMLUGOPzxv4pyCn8VZrDV0twcVrkvpL8n+cLgkqimB/Mk3rvDuuxZBLqS18kUb/XItpfXf3FzcY5m3ycGUOrpW/cFClTzm0q2scX9lhaStb5LPdCF+uTGF+VwwdjcFwxQE4EaDAy0oHKozFO+yK20NCO0Ws+F3SR/Oc4IT12BOxGHdtH5ROwTKTIBGZpuD5LTU/Ga0pB5PN5CSaW/uEwFmfsbfKlnuvn9R6crMM2smaxzDc7/Kn6wEBfhHzyiqrb7YhWK5Ofh391ikmSuJlu2NJxnRuLgq7NMkNhiXPOG61CDJUAgSAUtcwm7uWFxVZXPta9hic3ZUSrfifnpXz5gQTzmJk/IFiozHe76rYzT/FeAPCOckKzvd63/8Q23hpHimS1qlKjkwiU6qC0WEyuKDhZBsjWn2xNF4qe+DVuq4yjT321KJOfTiiykk+j5lltJudfQZsg9rRRBBbrMoJJLwaDdAV3MscW5luWRh6xeu8E27vepTdbliWZv39xIdTG1WiLY3Zwsql8Mfr1d+AgD/9X5xrOCPXKfw26S6JAIOFXJ1U85M9A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(396003)(136003)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(6666004)(47076005)(40460700003)(336012)(426003)(107886003)(478600001)(2616005)(16526019)(26005)(83380400001)(6916009)(70586007)(2906002)(53546011)(36860700001)(5660300002)(41300700001)(966005)(70206006)(16576012)(8936002)(54906003)(4326008)(8676002)(316002)(7636003)(356005)(82740400003)(36756003)(86362001)(30864003)(31696002)(31686004)(40480700001)(3714002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2023 14:54:51.3631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d11cc4-b294-4474-4c69-08dbf40fcda7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6281

On 01/12/2023 0:10, Alex Williamson wrote:
> On Wed, 29 Nov 2023 16:37:46 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> Introduce a vfio driver over virtio devices to support the legacy
>> interface functionality for VFs.
>>
>> Background, from the virtio spec [1].
>> --------------------------------------------------------------------
>> In some systems, there is a need to support a virtio legacy driver with
>> a device that does not directly support the legacy interface. In such
>> scenarios, a group owner device can provide the legacy interface
>> functionality for the group member devices. The driver of the owner
>> device can then access the legacy interface of a member device on behalf
>> of the legacy member device driver.
>>
>> For example, with the SR-IOV group type, group members (VFs) can not
>> present the legacy interface in an I/O BAR in BAR0 as expected by the
>> legacy pci driver. If the legacy driver is running inside a virtual
>> machine, the hypervisor executing the virtual machine can present a
>> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
>> legacy driver accesses to this I/O BAR and forwards them to the group
>> owner device (PF) using group administration commands.
>> --------------------------------------------------------------------
>>
>> Specifically, this driver adds support for a virtio-net VF to be exposed
>> as a transitional device to a guest driver and allows the legacy IO BAR
>> functionality on top.
>>
>> This allows a VM which uses a legacy virtio-net driver in the guest to
>> work transparently over a VF which its driver in the host is that new
>> driver.
>>
>> The driver can be extended easily to support some other types of virtio
>> devices (e.g virtio-blk), by adding in a few places the specific type
>> properties as was done for virtio-net.
>>
>> For now, only the virtio-net use case was tested and as such we introduce
>> the support only for such a device.
>>
>> Practically,
>> Upon probing a VF for a virtio-net device, in case its PF supports
>> legacy access over the virtio admin commands and the VF doesn't have BAR
>> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
>> transitional device with I/O BAR in BAR 0.
>>
>> The existence of the simulated I/O bar is reported later on by
>> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
>> exposes itself as a transitional device by overwriting some properties
>> upon reading its config space.
>>
>> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
>> guest may use it via read/write calls according to the virtio
>> specification.
>>
>> Any read/write towards the control parts of the BAR will be captured by
>> the new driver and will be translated into admin commands towards the
>> device.
>>
>> Any data path read/write access (i.e. virtio driver notifications) will
>> be forwarded to the physical BAR which its properties were supplied by
>> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
>> probing/init flow.
>>
>> With that code in place a legacy driver in the guest has the look and
>> feel as if having a transitional device with legacy support for both its
>> control and data path flows.
>>
>> [1]
>> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   MAINTAINERS                      |   7 +
>>   drivers/vfio/pci/Kconfig         |   2 +
>>   drivers/vfio/pci/Makefile        |   2 +
>>   drivers/vfio/pci/virtio/Kconfig  |  16 +
>>   drivers/vfio/pci/virtio/Makefile |   4 +
>>   drivers/vfio/pci/virtio/main.c   | 554 +++++++++++++++++++++++++++++++
>>   6 files changed, 585 insertions(+)
>>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>>   create mode 100644 drivers/vfio/pci/virtio/main.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 012df8ccf34e..b246b769092d 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
>>   S:	Maintained
>>   F:	drivers/vfio/pci/mlx5/
>>   
>> +VFIO VIRTIO PCI DRIVER
>> +M:	Yishai Hadas <yishaih@nvidia.com>
>> +L:	kvm@vger.kernel.org
>> +L:	virtualization@lists.linux-foundation.org
>> +S:	Maintained
>> +F:	drivers/vfio/pci/virtio
>> +
>>   VFIO PCI DEVICE SPECIFIC DRIVERS
>>   R:	Jason Gunthorpe <jgg@nvidia.com>
>>   R:	Yishai Hadas <yishaih@nvidia.com>
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 8125e5f37832..18c397df566d 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>>   
>>   source "drivers/vfio/pci/pds/Kconfig"
>>   
>> +source "drivers/vfio/pci/virtio/Kconfig"
>> +
>>   endmenu
>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>> index 45167be462d8..046139a4eca5 100644
>> --- a/drivers/vfio/pci/Makefile
>> +++ b/drivers/vfio/pci/Makefile
>> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>>   obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>>   
>>   obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>> +
>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
>> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
>> new file mode 100644
>> index 000000000000..3a6707639220
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/Kconfig
>> @@ -0,0 +1,16 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +config VIRTIO_VFIO_PCI
>> +        tristate "VFIO support for VIRTIO NET PCI devices"
>> +        depends on VIRTIO_PCI
>> +        select VFIO_PCI_CORE
>> +        help
>> +          This provides support for exposing VIRTIO NET VF devices which support
>> +          legacy IO access, using the VFIO framework that can work with a legacy
>> +          virtio driver in the guest.
>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>> +          not indicate I/O Space.
>> +          As of that this driver emulated I/O BAR in software to let a VF be
>> +          seen as a transitional device in the guest and let it work with
>> +          a legacy driver.
>> +
>> +          If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
>> new file mode 100644
>> index 000000000000..2039b39fb723
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/Makefile
>> @@ -0,0 +1,4 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
>> +virtio-vfio-pci-y := main.o
>> +
>> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
>> new file mode 100644
>> index 000000000000..3ca19c891673
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/main.c
>> @@ -0,0 +1,554 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pci.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_pci_core.h>
>> +#include <linux/virtio_pci.h>
>> +#include <linux/virtio_net.h>
>> +#include <linux/virtio_pci_admin.h>
>> +
>> +struct virtiovf_pci_core_device {
>> +	struct vfio_pci_core_device core_device;
>> +	u8 bar0_virtual_buf_size;
> 
> Poor packing here, move it down with notify_bar.

OK

> 
>> +	u8 *bar0_virtual_buf;
>> +	/* synchronize access to the virtual buf */
>> +	struct mutex bar_mutex;
>> +	void __iomem *notify_addr;
>> +	u64 notify_offset;
>> +	__le32 pci_base_addr_0;
>> +	__le16 pci_cmd;
>> +	u8 notify_bar;
>> +};
>> +
>> +static int
>> +virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
>> +			     loff_t pos, char __user *buf,
>> +			     size_t count, bool read)
>> +{
>> +	bool msix_enabled =
>> +		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
> 
> This is racy, the irq_type could change, do we care or does that fall
> into poor driver behavior?

This clearly falls into a poor driver behavior (e.g QEMU reads from a 
given offset considering current irq_type once it changes it in parallel).

> 
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
>> +	bool common;
>> +	u8 offset;
>> +	int ret;
>> +
>> +	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);
> 
> I don't understand virtio, but this looks like it has the effect of the
> mac and status fields shifting in IO BAR depending on whether MSIX
> is enabled.  Doesn't that give the user access to 4 bytes beyond the
> status field? 

It is accessing 4 bytes within the device io region that the device 
would support.

  Is that how it's supposed to work or should we be
> dropping accesses to the 4-bytes MSIX support adds when not enabled?

This is how it's supposed to work, accessing that area has no side effects.

> 
>> +	/* offset within the relevant configuration area */
>> +	offset = common ? pos : pos - VIRTIO_PCI_CONFIG_OFF(msix_enabled);
>> +	mutex_lock(&virtvdev->bar_mutex);
>> +	if (read) {
>> +		if (common)
>> +			ret = virtio_pci_admin_legacy_common_io_read(pdev, offset,
>> +					count, bar0_buf + pos);
>> +		else
>> +			ret = virtio_pci_admin_legacy_device_io_read(pdev, offset,
>> +					count, bar0_buf + pos);
>> +		if (ret)
>> +			goto out;
>> +		if (copy_to_user(buf, bar0_buf + pos, count))
>> +			ret = -EFAULT;
>> +	} else {
>> +		if (copy_from_user(bar0_buf + pos, buf, count)) {
>> +			ret = -EFAULT;
>> +			goto out;
>> +		}
>> +
>> +		if (common)
>> +			ret = virtio_pci_admin_legacy_common_io_write(pdev, offset,
>> +					count, bar0_buf + pos);
>> +		else
>> +			ret = virtio_pci_admin_legacy_device_io_write(pdev, offset,
>> +					count, bar0_buf + pos);
>> +	}
>> +out:
>> +	mutex_unlock(&virtvdev->bar_mutex);
>> +	return ret;
>> +}
>> +
>> +static int
>> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
>> +			    loff_t pos, char __user *buf,
>> +			    size_t count, bool read)
>> +{
>> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
>> +	u16 queue_notify;
>> +	int ret;
>> +
>> +	if (pos + count > virtvdev->bar0_virtual_buf_size)
>> +		return -EINVAL;
>> +
>> +	switch (pos) {
>> +	case VIRTIO_PCI_QUEUE_NOTIFY:
>> +		if (count != sizeof(queue_notify))
>> +			return -EINVAL;
>> +		if (read) {
>> +			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
>> +						virtvdev->notify_addr);
>> +			if (ret)
>> +				return ret;
>> +			if (copy_to_user(buf, &queue_notify,
>> +					 sizeof(queue_notify)))
>> +				return -EFAULT;
>> +		} else {
>> +			if (copy_from_user(&queue_notify, buf, count))
>> +				return -EFAULT;
>> +			ret = vfio_pci_iowrite16(core_device, true, queue_notify,
>> +						 virtvdev->notify_addr);
>> +		}
>> +		break;
>> +	default:
>> +		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
>> +						   read);
>> +	}
>> +
>> +	return ret ? ret : count;
>> +}
>> +
>> +static bool range_intersect_range(loff_t range1_start, size_t count1,
>> +				  loff_t range2_start, size_t count2,
>> +				  loff_t *start_offset,
>> +				  size_t *intersect_count,
>> +				  size_t *register_offset)
>> +{
>> +	if (range1_start <= range2_start &&
>> +	    range1_start + count1 > range2_start) {
>> +		*start_offset = range2_start - range1_start;
>> +		*intersect_count = min_t(size_t, count2,
>> +					 range1_start + count1 - range2_start);
>> +		*register_offset = 0;
>> +		return true;
>> +	}
>> +
>> +	if (range1_start > range2_start &&
>> +	    range1_start < range2_start + count2) {
>> +		*start_offset = 0;
>> +		*intersect_count = min_t(size_t, count1,
>> +					 range2_start + count2 - range1_start);
>> +		*register_offset = range1_start - range2_start;
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>> +					char __user *buf, size_t count,
>> +					loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	size_t register_offset;
>> +	loff_t copy_offset;
>> +	size_t copy_count;
>> +	__le32 val32;
>> +	__le16 val16;
>> +	u8 val8;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
>> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
>> +				   copy_count))
>> +			return -EFAULT;
>> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
>> +				 copy_count))
>> +			return -EFAULT;
>> +	}
> 
> Seems like COMMAND_IO survives across reset, pci_cmd is only ever
> modified by user writes.

I see.

If so, we may need to add a callback for pci_error_handlers.reset_done 
to set it back to zero.

I'll add as part of V5.

> 
> I also don't see that we honor COMMAND_IO for accesses.  Shouldn't reads
> return -1 and writes get dropped if COMMAND_IO is cleared?

You mean that if the 'COMMAND_IO' bit was not set, we should not allow 
read/write towards the IO bar, right ?

If so, I would expect to return -EFAULT from 
translate_io_bar_to_mem_bar() in that case for both read/write and let 
the upper SW layers (e.g. QEMU) to consider that as '-1 (0xfff) data' 
for read and ignore it upon writes.

Agree ?


> 
>> +
>> +	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		/* Transional needs to have revision 0 */
>> +		val8 = 0;
>> +		if (copy_to_user(buf + copy_offset, &val8, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		u8 log_bar_size = ilog2(roundup_pow_of_two(virtvdev->bar0_virtual_buf_size));
>> +		u32 mask_size = ~((BIT(log_bar_size) - 1));
> 
> bar0_virtual_buf_size already needs to be a power-of-2, the size we
> report here needs to match the REGION_INFO size, so we should enforce
> the size in virtio_vf_pci_init_device().  I think it's 32bytes, so
> we're actually good on the size,

Yes, this is 32 bytes which is power of 2 and we should be fine as you 
wrote.

Do you suggest to enforce the calculated size explicitly as part of 
virtio_vf_pci_init_device() to be power of 2 with some check ?


  but the above makes no sense, ie.
> rounding a value that's already a power-of-2 to a power-of-2, getting
> the log2 size, shifting that back into the size we started with to get
> a mask... why isn't it just:
> 
> 		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
> ?

Yes, it makes sense, will use that formula as part of V5.

> 
> 
>> +		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
>> +
>> +		val32 = cpu_to_le32((pci_base_addr_0 & mask_size) | PCI_BASE_ADDRESS_SPACE_IO);
> 
> Looks like what I suggested to Ankit :)
> 
> Per our prior variant driver agreement, we're going to need to enlist
> another reviewer as well.  Thanks,
> 

OK

Hopefully V5 will address the latest notes from you and be ready as a 
candidate for other people to review.

Thanks,
Yishai

> Alex
> 
>> +		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		/*
>> +		 * Transitional devices use the PCI subsystem device id as
>> +		 * virtio device id, same as legacy driver always did.
>> +		 */
>> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
>> +				 copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
>> +				 copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	return count;
>> +}
>> +
>> +static ssize_t
>> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>> +		       size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
>> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
>> +
>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
>> +
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>> +	if (ret) {
>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
>> +				     ret);
>> +		return -EIO;
>> +	}
>> +
>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
>> +	pm_runtime_put(&pdev->dev);
>> +	return ret;
>> +}
>> +
>> +static ssize_t
>> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
>> +			size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
>> +		size_t register_offset;
>> +		loff_t copy_offset;
>> +		size_t copy_count;
>> +
>> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +
>> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
>> +					  sizeof(virtvdev->pci_base_addr_0),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +	}
>> +
>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
>> +
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>> +	if (ret) {
>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
>> +		return -EIO;
>> +	}
>> +
>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
>> +	pm_runtime_put(&pdev->dev);
>> +	return ret;
>> +}
>> +
>> +static int
>> +virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>> +				   unsigned int cmd, unsigned long arg)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
>> +	void __user *uarg = (void __user *)arg;
>> +	struct vfio_region_info info = {};
>> +
>> +	if (copy_from_user(&info, uarg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (info.argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	switch (info.index) {
>> +	case VFIO_PCI_BAR0_REGION_INDEX:
>> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>> +		info.size = virtvdev->bar0_virtual_buf_size;
>> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
>> +			     VFIO_REGION_INFO_FLAG_WRITE;
>> +		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
>> +	default:
>> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>> +	}
>> +}
>> +
>> +static long
>> +virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>> +			     unsigned long arg)
>> +{
>> +	switch (cmd) {
>> +	case VFIO_DEVICE_GET_REGION_INFO:
>> +		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
>> +	default:
>> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>> +	}
>> +}
>> +
>> +static int
>> +virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
>> +{
>> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
>> +	int ret;
>> +
>> +	/*
>> +	 * Setup the BAR where the 'notify' exists to be used by vfio as well
>> +	 * This will let us mmap it only once and use it when needed.
>> +	 */
>> +	ret = vfio_pci_core_setup_barmap(core_device,
>> +					 virtvdev->notify_bar);
>> +	if (ret)
>> +		return ret;
>> +
>> +	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
>> +			virtvdev->notify_offset;
>> +	return 0;
>> +}
>> +
>> +static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_enable(vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (virtvdev->bar0_virtual_buf) {
>> +		/*
>> +		 * Upon close_device() the vfio_pci_core_disable() is called
>> +		 * and will close all the previous mmaps, so it seems that the
>> +		 * valid life cycle for the 'notify' addr is per open/close.
>> +		 */
>> +		ret = virtiovf_set_notify_addr(virtvdev);
>> +		if (ret) {
>> +			vfio_pci_core_disable(vdev);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	vfio_pci_core_finish_enable(vdev);
>> +	return 0;
>> +}
>> +
>> +static int virtiovf_get_device_config_size(unsigned short device)
>> +{
>> +	/* Network card */
>> +	return offsetofend(struct virtio_net_config, status);
>> +}
>> +
>> +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
>> +{
>> +	u64 offset;
>> +	int ret;
>> +	u8 bar;
>> +
>> +	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
>> +				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
>> +				&bar, &offset);
>> +	if (ret)
>> +		return ret;
>> +
>> +	virtvdev->notify_bar = bar;
>> +	virtvdev->notify_offset = offset;
>> +	return 0;
>> +}
>> +
>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_init_dev(core_vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	pdev = virtvdev->core_device.pdev;
>> +	ret = virtiovf_read_notify_info(virtvdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Being ready with a buffer that supports MSIX */
>> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>> +				virtiovf_get_device_config_size(pdev->device);
>> +	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
>> +					     GFP_KERNEL);
>> +	if (!virtvdev->bar0_virtual_buf)
>> +		return -ENOMEM;
>> +	mutex_init(&virtvdev->bar_mutex);
>> +	return 0;
>> +}
>> +
>> +static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +
>> +	kfree(virtvdev->bar0_virtual_buf);
>> +	vfio_pci_core_release_dev(core_vdev);
>> +}
>> +
>> +static const struct vfio_device_ops virtiovf_vfio_pci_tran_ops = {
>> +	.name = "virtio-vfio-pci-trans",
>> +	.init = virtiovf_pci_init_device,
>> +	.release = virtiovf_pci_core_release_dev,
>> +	.open_device = virtiovf_pci_open_device,
>> +	.close_device = vfio_pci_core_close_device,
>> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
>> +	.read = virtiovf_pci_core_read,
>> +	.write = virtiovf_pci_core_write,
>> +	.mmap = vfio_pci_core_mmap,
>> +	.request = vfio_pci_core_request,
>> +	.match = vfio_pci_core_match,
>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
>> +	.name = "virtio-vfio-pci",
>> +	.init = vfio_pci_core_init_dev,
>> +	.release = vfio_pci_core_release_dev,
>> +	.open_device = virtiovf_pci_open_device,
>> +	.close_device = vfio_pci_core_close_device,
>> +	.ioctl = vfio_pci_core_ioctl,
>> +	.device_feature = vfio_pci_core_ioctl_feature,
>> +	.read = vfio_pci_core_read,
>> +	.write = vfio_pci_core_write,
>> +	.mmap = vfio_pci_core_mmap,
>> +	.request = vfio_pci_core_request,
>> +	.match = vfio_pci_core_match,
>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
>> +{
>> +	struct resource *res = pdev->resource;
>> +
>> +	return res->flags ? true : false;
>> +}
>> +
>> +static int virtiovf_pci_probe(struct pci_dev *pdev,
>> +			      const struct pci_device_id *id)
>> +{
>> +	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
>> +	struct virtiovf_pci_core_device *virtvdev;
>> +	int ret;
>> +
>> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
>> +	    !virtiovf_bar0_exists(pdev))
>> +		ops = &virtiovf_vfio_pci_tran_ops;
>> +
>> +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
>> +				     &pdev->dev, ops);
>> +	if (IS_ERR(virtvdev))
>> +		return PTR_ERR(virtvdev);
>> +
>> +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
>> +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
>> +	if (ret)
>> +		goto out;
>> +	return 0;
>> +out:
>> +	vfio_put_device(&virtvdev->core_device.vdev);
>> +	return ret;
>> +}
>> +
>> +static void virtiovf_pci_remove(struct pci_dev *pdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
>> +
>> +	vfio_pci_core_unregister_device(&virtvdev->core_device);
>> +	vfio_put_device(&virtvdev->core_device.vdev);
>> +}
>> +
>> +static const struct pci_device_id virtiovf_pci_table[] = {
>> +	/* Only virtio-net is supported/tested so far */
>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
>> +	{}
>> +};
>> +
>> +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
>> +
>> +static struct pci_driver virtiovf_pci_driver = {
>> +	.name = KBUILD_MODNAME,
>> +	.id_table = virtiovf_pci_table,
>> +	.probe = virtiovf_pci_probe,
>> +	.remove = virtiovf_pci_remove,
>> +	.err_handler = &vfio_pci_core_err_handlers,
>> +	.driver_managed_dma = true,
>> +};
>> +
>> +module_pci_driver(virtiovf_pci_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
>> +MODULE_DESCRIPTION(
>> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
> 


