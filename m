Return-Path: <kvm+bounces-2969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F31F7FF3E5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96DDD1C20DD4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A19537FC;
	Thu, 30 Nov 2023 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="efFM8g98"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DF110E6
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 07:47:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHhcZR9V9Dthz8FrDeTlvFSDvq4sZoHeoYtLrkE2q2T+YTrmYUIu5WwH4vCGr7THElsdbStEo2KxSinUUp9VKbS0Hqet1fAU67ksSA41Emn3ABhizIc6KPlOABfxqIT+8nzq010dkzUnzQc44rLIwSMp9Qmo5XLL39vHPhDhRR3nmTLIAN8m2rcipmHnswXcyKP8390MDRZibGrkXrQXydQLjun3/dNUDUBykIUrQHPiMEqEWy4Py1mcuEBhVRt4aT5fu3KFvUPi4FnSJ4xO2fBi03qK5gxLzqvmSm2p8bWXs5YDCq1nz39wyvghoABscXQzHf+jHVNCATZVesYFeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8bAd+fLYY19MZQ7tYTTnKcnvY4veCvDoaN1rmiO12I=;
 b=WnvDkaRcij75/+43fxy1rXDssVInRGXUCnOrS63F12YHKOhKaThMr8J/mHKcB2ipXTzQ2NzPwFBsvykmvQ8CIMGDPHIG7UyJIkXroDHYMOGd1uO8D9MGT+1oyFz9Dnd0DWTHtSeliVpZpU4+j6GzwTvUBeqD6hg/LOe9dQTzOQj0xWB54hOLf4oMd2U5qfHCaBfg7LvzHzU03FcfnclwWM08B8Fmf+NnS9Z1dTBi/3c49lPIQhJ3y8HB8IfBDbEzNV9M61wP0kmekbTSOjryyAIs0B8stQE+1FBfEwob0FoNptX2fHro7B5p4PCqt8eIFOzNJ8eQdf736RC12B0YlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8bAd+fLYY19MZQ7tYTTnKcnvY4veCvDoaN1rmiO12I=;
 b=efFM8g98F+J1u8xXKBvzhoNVnk3AejOifF0BT5iJnjTU+ESlPskwqtJtScPRHXHI5F6EfrFXaYzs5qzBxWo7GRfdxo/rKIrYzp1joxKz1z/kvk8/twCgGCI9PhdmpJgkHaJ4NTFFG1CJj/pT3AGNeSSn/aYz2JLtPUikKYKQ7eAdq56n4eW1d+SOf3jIzEEgVmFsqsYZxqkC6+3h0pTZ/sEKb6VhsAuJi+iXnv1XsYQb5jkxymn/r6JNao73TrO/5CalnkD50Y3J1ueFcXq47tCDSpEVFMFS8i4EnhSTk31wUsqydBz2Gx1SXjLwBRDm9Oonm8JxAm0lS9TtCnEsvg==
Received: from CY8PR11CA0046.namprd11.prod.outlook.com (2603:10b6:930:4a::6)
 by CY5PR12MB6384.namprd12.prod.outlook.com (2603:10b6:930:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Thu, 30 Nov
 2023 15:47:36 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:930:4a:cafe::c9) by CY8PR11CA0046.outlook.office365.com
 (2603:10b6:930:4a::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23 via Frontend
 Transport; Thu, 30 Nov 2023 15:47:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Thu, 30 Nov 2023 15:47:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 30 Nov
 2023 07:47:20 -0800
Received: from [172.27.21.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 30 Nov
 2023 07:47:16 -0800
Message-ID: <df152b26-799f-4fe7-9fcc-5818fce680e0@nvidia.com>
Date: Thu, 30 Nov 2023 17:47:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 vfio 0/9] Introduce a vfio driver over virtio devices
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <jasowang@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
	<maorg@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
 <20231130050648-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231130050648-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|CY5PR12MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: fec9496f-5237-4fdc-1004-08dbf1bbacb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wg+3a52kMm/Y20ZxLLwbkhs73vhvxp6GpfMnyeME/GnIqqmRKcOqIKQjSoEgAeAqfTweh5QnXgWZ74pm9wnX+VcnMn2oz/o2pYCa3ceoa1oyM0dE/LWpnXm0laesB6z5GkrpfBioBskNGZp48DmJ+iUGcBiXSjvdcrEyW1AQqCZjKiC4RJC9eCL8YN4xYKuTVGFGwr080Jod2aWMe6nyKIPe5yjrhwI3pN4WXquF9JpL0YFK0FM5/8ygo5FTzNU4rEhMOVQfVFLAyumAFKeGQbj32luXaDdvgdLMBBO6gkd0OeuuF+qs4oPEnwsRb/l3z7CO7oLSnWf5aULJv6s6A2SRd+nvEfFWSVFlOoHrEtuPomE89tDNK9rLsPuurOFcYaa3KIYyu37yss0+1c90r61D8oM3u8OQmHhjwXSTBFuyVs7+OvJYi7ZKPOuv5677pPOAlYjTwwFgB5yORRB7G6NqHMOs6ZzzWuUIARVigSFcVqI8h5KzYDflzMN93X6rWnfGNWGXyzbDIxQG1yXDeaYbpUcVb/Lt8bexQ6Mtpy5YtEFn6mi5mK/bd6vf07ABY06wXmRgId/OZ2mqt538WUJ69trdwr8+9ZcMcvE62OYKMyeQl1tD2YjV3wAj+hceWNX2ev7oir4Aoer8B5Seqs5IY+xBjoi0bm2FiH4oMHOpaleeuKYStshnIaVoaewGWe8ShNXMUtnMscxN2imNW16Xm4RWwYDvs8GKbc5Su6259MM0sECPpv2cchO0fwU2UxjLnDpLdjMK3J0Z44JY3AK0z8ZRlmiaMjmigyCrub+8M8Ll4umqcmzWpd5sNifwCF+Re+8vVItYigvgnYr6WLV5OXKWqBy1Lx5vMgmZ6HRKY4J3H7fSrwo0lGF/QP+Q
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(82310400011)(451199024)(64100799003)(186009)(1800799012)(36840700001)(46966006)(40470700004)(31686004)(2906002)(40480700001)(5660300002)(40460700003)(36860700001)(8936002)(8676002)(47076005)(426003)(4326008)(336012)(53546011)(7636003)(41300700001)(478600001)(2616005)(82740400003)(356005)(83380400001)(966005)(70586007)(16576012)(36756003)(316002)(70206006)(26005)(16526019)(31696002)(107886003)(54906003)(86362001)(110136005)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 15:47:36.0910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fec9496f-5237-4fdc-1004-08dbf1bbacb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6384

On 30/11/2023 12:07, Michael S. Tsirkin wrote:
> On Wed, Nov 29, 2023 at 04:37:37PM +0200, Yishai Hadas wrote:
>> This series introduce a vfio driver over virtio devices to support the
>> legacy interface functionality for VFs.
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
>> The first 6 patches are in the virtio area and handle the below:
>> - Introduce the admin virtqueue infrastcture.
>> - Expose the layout of the commands that should be used for
>>    supporting the legacy access.
>> - Expose APIs to enable upper layers as of vfio, net, etc
>>    to execute admin commands.
>>
>> The above follows the virtio spec that was lastly accepted in that area
>> [1].
>>
>> The last 3 patches are in the vfio area and handle the below:
>> - Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
>> - Introduce a vfio driver over virtio devices to support the legacy
>>    interface functionality for VFs.
>>
>> The series was tested successfully over virtio-net VFs in the host,
>> while running in the guest both modern and legacy drivers.
>>
>> [1]
>> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> 
> 
> 
> I sent a minor question, but besides that, patches 1-6 look ok
> Acked-by: Michael S. Tsirkin <mst@redhat.com
Thanks Michael

I'll add your Acked-by for the above patches as part of V5 and will drop 
the unused macro (i.e.VIRTIO_ADMIN_MAX_CMD_OPCODE) as you asked.

> 
> I take no stance on patches 7-9 this is up to Alex.

Alex,
Are we fine with the rest of series from your side ?

Thanks,
Yishai

> 
> 
>> Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
>> Virtio:
>> - Rebase on top of 6.7 rc3.
>> Vfio:
>> - Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.
>>
>> Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
>> Virtio:
>> - Rebase on top of 6.7 rc1.
>> - Add a mutex to serialize admin commands execution and virtqueue
>>    deletion, as was suggested by Michael.
>> - Remove the 'ref_count' usage which is not needed any more.
>> - Reduce the depth of the admin vq to match a single command at a given time.
>> - Add a supported check upon command execution and move to use a single
>>    flow of virtqueue_exec_admin_cmd().
>> - Improve the description of the exported commands to better match the
>>    specification and the expected usage as was asked by Michael.
>>
>> Vfio:
>> - Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
>>    supply the 'offset' within the relevant configuration area, following
>>    the virtio exported APIs.
>>
>> Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
>> Virtio:
>> - Drop its first patch, it was accepted upstream already.
>> - Add a new patch (#6) which initializes the supported admin commands
>>    upon admin queue activation as was suggested by Michael.
>> - Split the legacy_io_read/write commands per common/device
>>    configuration as was asked by Michael.
>> - Don't expose any more the list query/used APIs outside of virtio.
>> - Instead, expose an API to check whether the legacy io functionality is
>>    supported as was suggested by Michael.
>> - Fix some Krobot's note by adding the missing include file.
>>
>> Vfio:
>> - Refer specifically to virtio-net as part of the driver/module description
>>    as Alex asked.
>> - Change to check MSIX enablement based on the irq type of the given vfio
>>    core device. In addition, drop its capable checking from the probe flow
>>    as was asked by Alex.
>> - Adapt to use the new virtio exposed APIs and clean some code accordingly.
>> - Adapt to some cleaner style code in some places (if/else) as was suggested
>>    by Alex.
>> - Fix the range_intersect_range() function and adapt its usage as was
>>    pointed by Alex.
>> - Make struct virtiovf_pci_core_device better packed.
>> - Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
>>    the ML.
>> - Add support for the 'bar sizing negotiation' as was asked by Alex.
>> - Drop the 'acc' from the 'ops' as Alex asked.
>>
>> Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html
>>
>> Virtio:
>> - Fix the common config map size issue that was reported by Michael
>>    Tsirkin.
>> - Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
>>    Michael, instead skip the AQ specifically.
>> - Move admin vq implementation into virtio_pci_modern.c as was asked by
>>    Michael.
>> - Rename structure virtio_avq to virtio_pci_admin_vq and some extra
>>    corresponding renames.
>> - Remove exported symbols virtio_pci_vf_get_pf_dev(),
>>    virtio_admin_cmd_exec() as now callers are local to the module.
>> - Handle inflight commands as part of the device reset flow.
>> - Introduce APIs per admin command in virtio-pci as was asked by Michael.
>>
>> Vfio:
>> - Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
>>    vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
>>    Alex.
>> - Drop the intermediate patch which prepares the commands and calls the
>>    generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
>> - Instead, call directly to the new APIs per admin command that are
>>    exported from Virtio - based on Michael's request.
>> - Enable only virtio-net as part of the pci_device_id table to enforce
>>    upon binding only what is supported as suggested by Alex.
>> - Add support for byte-wise access (read/write) over the device config
>>    region as was asked by Alex.
>> - Consider whether MSIX is practically enabled/disabled to choose the
>>    right opcode upon issuing read/write admin command, as mentioned
>>    by Michael.
>> - Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
>>    as was suggested by Michael.
>> - Set the '.close_device' op to vfio_pci_core_close_device() as was
>>    pointed by Alex.
>> - Adapt to Vfio multi-line comment style in a few places.
>> - Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
>>    to be CCed for the new driver as was suggested by Jason.
>>
>> Yishai
>>
>> Feng Liu (4):
>>    virtio: Define feature bit for administration virtqueue
>>    virtio-pci: Introduce admin virtqueue
>>    virtio-pci: Introduce admin command sending function
>>    virtio-pci: Introduce admin commands
>>
>> Yishai Hadas (5):
>>    virtio-pci: Initialize the supported admin commands
>>    virtio-pci: Introduce APIs to execute legacy IO admin commands
>>    vfio/pci: Expose vfio_pci_core_setup_barmap()
>>    vfio/pci: Expose vfio_pci_iowrite/read##size()
>>    vfio/virtio: Introduce a vfio driver over virtio devices
>>
>>   MAINTAINERS                            |   7 +
>>   drivers/vfio/pci/Kconfig               |   2 +
>>   drivers/vfio/pci/Makefile              |   2 +
>>   drivers/vfio/pci/vfio_pci_core.c       |  25 ++
>>   drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
>>   drivers/vfio/pci/virtio/Kconfig        |  16 +
>>   drivers/vfio/pci/virtio/Makefile       |   4 +
>>   drivers/vfio/pci/virtio/main.c         | 554 +++++++++++++++++++++++++
>>   drivers/virtio/virtio.c                |  37 +-
>>   drivers/virtio/virtio_pci_common.c     |  14 +
>>   drivers/virtio/virtio_pci_common.h     |  21 +-
>>   drivers/virtio/virtio_pci_modern.c     | 503 +++++++++++++++++++++-
>>   drivers/virtio/virtio_pci_modern_dev.c |  24 +-
>>   include/linux/vfio_pci_core.h          |  20 +
>>   include/linux/virtio.h                 |   8 +
>>   include/linux/virtio_config.h          |   4 +
>>   include/linux/virtio_pci_admin.h       |  21 +
>>   include/linux/virtio_pci_modern.h      |   2 +
>>   include/uapi/linux/virtio_config.h     |   8 +-
>>   include/uapi/linux/virtio_pci.h        |  71 ++++
>>   20 files changed, 1342 insertions(+), 39 deletions(-)
>>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>>   create mode 100644 drivers/vfio/pci/virtio/main.c
>>   create mode 100644 include/linux/virtio_pci_admin.h
>>
>> -- 
>> 2.27.0
> 


