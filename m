Return-Path: <kvm+bounces-4518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E15DA81359C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11FD81C20B79
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CD35EE81;
	Thu, 14 Dec 2023 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PWGXsSWU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151B310F
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:04:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mse1YxlKCQbOQ0nlf/mZEcmdP8mUc/OiuWsPaSr5z2UKxg3m3/PhtkJT+db7N6z+B3YU5uVH052/YItR3w3bW8NVYyyNdjNrXnMDLvZjlUK13/67l9N4eU5vgSgpy5YnF3kTTBjKEsP9NjBioi6zoYTIPiXWmr9SZ/78Ntwv3909sHubTElY5TSQtmwxm5C8qcGGWMW5e16vk1UyR1V3hAp62q4VF49LDXofQ47lFgc6e64l35zAEsxQ6uwQ9wxA4GG/PKRTU7SamSR290eFmj6LZBM4KqHV+4JhqPqJ0moL/oxYz0he6Nzd89h5xfDHZIoKGmu06moEzj6cv1JiGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6C8ztGZkRtzBabqnTbgj04JaJfDCfGT6BcXZrg6Ju8=;
 b=L9IaBPBmXCjKQGd5K7itFd78ctVbgMbHGti4FcNI/fyi+St4VCdBUgyhYfyIAsTS2BDYa/JwC+Q8slO4Tzg3lzQ+9N2jpOGMuvlBEwsDEQ25/ivAwiYnG/p6psH7Lf78eT1wmDDmeChA4KS9zzoH9Z5goS6hznc7v2OTjb5vBfGTAEN2kK/08RG74W9RNlLROWDfoqtgQYw5oOAp2lZ6Pt9JNRpFqhK7MFcgDkiEZRqjiEci52tVtT7IAj3Zh9i882hMEfzZIFY5R3jYRrMqN1Im5kW8eYmu83FyaryY1lWa1knIjHtG+ONqXix7yOQscWkDM3bG1k2g3QlJ0iJVMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6C8ztGZkRtzBabqnTbgj04JaJfDCfGT6BcXZrg6Ju8=;
 b=PWGXsSWUiBIyhVTsUmkiERmQnRckUh5no4xbBf8c/wmUNGdQuePkFdLXNRGRiI8P1iHIvhVU34wcRFNC3KbTqfQn0MOzo9WNg6jS6edumeQ6qsyUq964uqv76YnfNlCx6LgJNdUN9bSFHnwsSYQ4ThO0tQ1pmvhPzfhCeZ9YVdLT/T9GceHR1eukcA8uQGcmF3jBhCKOsmNXeVs+Yjm/Eo8gQJlMEwTsTW9gNx/eJTw24pagmCg6qHtRWTSbv9ghn5TTaQnaW42veUjuFSHAXAQfLUU+RAmsLGkEKYfdK2RADbv/Avtfld4jjaN/AiLqpiSzZLkx0asyfx80duWYhg==
Received: from BYAPR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:40::17)
 by DM4PR12MB7599.namprd12.prod.outlook.com (2603:10b6:8:109::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 16:03:59 +0000
Received: from CO1PEPF000042AA.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::4a) by BYAPR04CA0004.outlook.office365.com
 (2603:10b6:a03:40::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 16:03:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AA.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 16:03:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 08:03:37 -0800
Received: from [172.27.58.65] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 08:03:33 -0800
Message-ID: <5b596e34-aac9-4786-8f13-4d85986803f0@nvidia.com>
Date: Thu, 14 Dec 2023 18:03:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <jasowang@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
	<maorg@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <20231214013642-mutt-send-email-mst@kernel.org>
 <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
 <20231214041515-mutt-send-email-mst@kernel.org>
 <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
 <20231214075905.59a4a3ba.alex.williamson@redhat.com>
 <20231214100403-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231214100403-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AA:EE_|DM4PR12MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c69ab7-1c62-48fc-a16d-08dbfcbe47ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gfthk+9JdciUJovLdJ3+lr1I7ewth9UZtDalxRxgmAzLzm50mAhf5RjcOqFO9RGUt741HfbOEZ8UpjfVtgkc6+7yPTIilBqp7MiWzKfONd/MAf5Sx8YBPIPhfDZVKEunwSc4/kqLXdl7PxatNQ0TWBGT+kK0sWK669iPsZeTAIAVzIdBinxsD0+BEL3H9SkHONSXiEok4uiBPtVOa6RfiQxWJef2LjSad2LSvaTUbl9K0vnNtACDjjlqg4WUV+WiAr3sVe7CbU4mYUX3ifwnppkO0mQzq6iG6RybFLltBUz39+Rd3UIjmIVnSPPsolE62+p3tUni1x72ddIHUACl5amhYWXCCJRxr7tUQRDN2y5gN7Kf5ocNbTklHR1fkMOe3FG7+qLmV4dmnquf9rMKlUCGMz8IonBc1naC7u3QETJlrHd8OwV8nTxqIA2V+h2MD5qXQt2SncLFiBFHlZ8i/ldLs/X5PExv4OquvPUvIw0TcXmD3v+GUn/3PVbX8G8hKxC6HOwB3GrlXteYA9QRRKFGvc3VFwH0q6piQ6hYIs52LRj+CxFsf5nSzlVZ8/oiusOxF9+HM1DENtPUXtoUQhHOIsyzD8CShYbGd5140sMd1To1ICY7eESTde1dQhYM3uNMlZqcaWnBNWONFXJE0Rp4H40ofB3AK//EnrTlmlCTp5Zu/8iYUWb5mlO38tW/iZDRf7VMbkOkHnigXzQVhBOUcDW74dXT88B1GZhSdTn4AVOKzkSSA8FMK7+u8xqbCm8LCwDd47AMeaV93rYWLarroamr1UdEBltDQJ9R6S9Ds5eWOQYGNKz4+kDU7mZO
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(346002)(39860400002)(230922051799003)(451199024)(186009)(82310400011)(1800799012)(64100799003)(46966006)(36840700001)(40470700004)(31686004)(40480700001)(66899024)(40460700003)(336012)(26005)(426003)(16526019)(107886003)(2616005)(356005)(82740400003)(36756003)(31696002)(86362001)(7636003)(70586007)(47076005)(83380400001)(4326008)(5660300002)(36860700001)(53546011)(316002)(110136005)(70206006)(966005)(8936002)(54906003)(16576012)(41300700001)(2906002)(478600001)(30864003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 16:03:58.2523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c69ab7-1c62-48fc-a16d-08dbfcbe47ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7599

On 14/12/2023 17:05, Michael S. Tsirkin wrote:
> On Thu, Dec 14, 2023 at 07:59:05AM -0700, Alex Williamson wrote:
>> On Thu, 14 Dec 2023 11:37:10 +0200
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>
>>> On 14/12/2023 11:19, Michael S. Tsirkin wrote:
>>>> On Thu, Dec 14, 2023 at 11:03:49AM +0200, Yishai Hadas wrote:
>>>>> On 14/12/2023 8:38, Michael S. Tsirkin wrote:
>>>>>> On Thu, Dec 07, 2023 at 12:28:20PM +0200, Yishai Hadas wrote:
>>>>>>> Introduce a vfio driver over virtio devices to support the legacy
>>>>>>> interface functionality for VFs.
>>>>>>>
>>>>>>> Background, from the virtio spec [1].
>>>>>>> --------------------------------------------------------------------
>>>>>>> In some systems, there is a need to support a virtio legacy driver with
>>>>>>> a device that does not directly support the legacy interface. In such
>>>>>>> scenarios, a group owner device can provide the legacy interface
>>>>>>> functionality for the group member devices. The driver of the owner
>>>>>>> device can then access the legacy interface of a member device on behalf
>>>>>>> of the legacy member device driver.
>>>>>>>
>>>>>>> For example, with the SR-IOV group type, group members (VFs) can not
>>>>>>> present the legacy interface in an I/O BAR in BAR0 as expected by the
>>>>>>> legacy pci driver. If the legacy driver is running inside a virtual
>>>>>>> machine, the hypervisor executing the virtual machine can present a
>>>>>>> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
>>>>>>> legacy driver accesses to this I/O BAR and forwards them to the group
>>>>>>> owner device (PF) using group administration commands.
>>>>>>> --------------------------------------------------------------------
>>>>>>>
>>>>>>> Specifically, this driver adds support for a virtio-net VF to be exposed
>>>>>>> as a transitional device to a guest driver and allows the legacy IO BAR
>>>>>>> functionality on top.
>>>>>>>
>>>>>>> This allows a VM which uses a legacy virtio-net driver in the guest to
>>>>>>> work transparently over a VF which its driver in the host is that new
>>>>>>> driver.
>>>>>>>
>>>>>>> The driver can be extended easily to support some other types of virtio
>>>>>>> devices (e.g virtio-blk), by adding in a few places the specific type
>>>>>>> properties as was done for virtio-net.
>>>>>>>
>>>>>>> For now, only the virtio-net use case was tested and as such we introduce
>>>>>>> the support only for such a device.
>>>>>>>
>>>>>>> Practically,
>>>>>>> Upon probing a VF for a virtio-net device, in case its PF supports
>>>>>>> legacy access over the virtio admin commands and the VF doesn't have BAR
>>>>>>> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
>>>>>>> transitional device with I/O BAR in BAR 0.
>>>>>>>
>>>>>>> The existence of the simulated I/O bar is reported later on by
>>>>>>> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
>>>>>>> exposes itself as a transitional device by overwriting some properties
>>>>>>> upon reading its config space.
>>>>>>>
>>>>>>> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
>>>>>>> guest may use it via read/write calls according to the virtio
>>>>>>> specification.
>>>>>>>
>>>>>>> Any read/write towards the control parts of the BAR will be captured by
>>>>>>> the new driver and will be translated into admin commands towards the
>>>>>>> device.
>>>>>>>
>>>>>>> Any data path read/write access (i.e. virtio driver notifications) will
>>>>>>> be forwarded to the physical BAR which its properties were supplied by
>>>>>>> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
>>>>>>> probing/init flow.
>>>>>>>
>>>>>>> With that code in place a legacy driver in the guest has the look and
>>>>>>> feel as if having a transitional device with legacy support for both its
>>>>>>> control and data path flows.
>>>>>>>
>>>>>>> [1]
>>>>>>> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
>>>>>>>
>>>>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>>>>> ---
>>>>>>>     MAINTAINERS                      |   7 +
>>>>>>>     drivers/vfio/pci/Kconfig         |   2 +
>>>>>>>     drivers/vfio/pci/Makefile        |   2 +
>>>>>>>     drivers/vfio/pci/virtio/Kconfig  |  16 +
>>>>>>>     drivers/vfio/pci/virtio/Makefile |   4 +
>>>>>>>     drivers/vfio/pci/virtio/main.c   | 567 +++++++++++++++++++++++++++++++
>>>>>>>     6 files changed, 598 insertions(+)
>>>>>>>     create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>>>>>>     create mode 100644 drivers/vfio/pci/virtio/Makefile
>>>>>>>     create mode 100644 drivers/vfio/pci/virtio/main.c
>>>>>>>
>>>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>>>> index 012df8ccf34e..b246b769092d 100644
>>>>>>> --- a/MAINTAINERS
>>>>>>> +++ b/MAINTAINERS
>>>>>>> @@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
>>>>>>>     S:	Maintained
>>>>>>>     F:	drivers/vfio/pci/mlx5/
>>>>>>> +VFIO VIRTIO PCI DRIVER
>>>>>>> +M:	Yishai Hadas <yishaih@nvidia.com>
>>>>>>> +L:	kvm@vger.kernel.org
>>>>>>> +L:	virtualization@lists.linux-foundation.org
>>>>>>> +S:	Maintained
>>>>>>> +F:	drivers/vfio/pci/virtio
>>>>>>> +
>>>>>>>     VFIO PCI DEVICE SPECIFIC DRIVERS
>>>>>>>     R:	Jason Gunthorpe <jgg@nvidia.com>
>>>>>>>     R:	Yishai Hadas <yishaih@nvidia.com>
>>>>>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>>>>>> index 8125e5f37832..18c397df566d 100644
>>>>>>> --- a/drivers/vfio/pci/Kconfig
>>>>>>> +++ b/drivers/vfio/pci/Kconfig
>>>>>>> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>>>>>>>     source "drivers/vfio/pci/pds/Kconfig"
>>>>>>> +source "drivers/vfio/pci/virtio/Kconfig"
>>>>>>> +
>>>>>>>     endmenu
>>>>>>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>>>>>>> index 45167be462d8..046139a4eca5 100644
>>>>>>> --- a/drivers/vfio/pci/Makefile
>>>>>>> +++ b/drivers/vfio/pci/Makefile
>>>>>>> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>>>>>>>     obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>>>>>>>     obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>>>>>>> +
>>>>>>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
>>>>>>> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
>>>>>>> new file mode 100644
>>>>>>> index 000000000000..3a6707639220
>>>>>>> --- /dev/null
>>>>>>> +++ b/drivers/vfio/pci/virtio/Kconfig
>>>>>>> @@ -0,0 +1,16 @@
>>>>>>> +# SPDX-License-Identifier: GPL-2.0-only
>>>>>>> +config VIRTIO_VFIO_PCI
>>>>>>> +        tristate "VFIO support for VIRTIO NET PCI devices"
>>>>>>> +        depends on VIRTIO_PCI
>>>>>>> +        select VFIO_PCI_CORE
>>>>>>> +        help
>>>>>>> +          This provides support for exposing VIRTIO NET VF devices which support
>>>>>>> +          legacy IO access, using the VFIO framework that can work with a legacy
>>>>>>> +          virtio driver in the guest.
>>>>>>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>>>>>>> +          not indicate I/O Space.
>>>>>>> +          As of that this driver emulated I/O BAR in software to let a VF be
>>>>>>> +          seen as a transitional device in the guest and let it work with
>>>>>>> +          a legacy driver.
>>>>>>> +
>>>>>>> +          If you don't know what to do here, say N.
>>>>>>
>>>>>> BTW shouldn't this driver be limited to X86? Things like lack of memory
>>>>>> barriers will make legacy virtio racy on e.g. ARM will they not?
>>>>>> And endian-ness will be broken on PPC ...
>>>>>>   
>>>>>
>>>>> OK, if so, we can come with the below extra code.
>>>>> Makes sense ?
>>>>>
>>>>> I'll squash it as part of V8 to the relevant patch.
>>>>>
>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>> index 37a0035f8381..b652e91b9df4 100644
>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>> @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>> *pdev)
>>>>>           struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>>           struct virtio_pci_device *vp_dev;
>>>>>
>>>>> +#ifndef CONFIG_X86
>>>>> +       return false;
>>>>> +#endif
>>>>>           if (!virtio_dev)
>>>>>                   return false;
>>>>>
>>>>> Yishai
>>>>
>>>> Isn't there going to be a bunch more dead code that compiler won't be
>>>> able to elide?
>>>>    
>>>
>>> On my setup the compiler didn't complain about dead-code (I simulated it
>>> by using ifdef CONFIG_X86 return false).
>>>
>>> However, if we suspect that some compiler might complain, we can come
>>> with the below instead.
>>>
>>> Do you prefer that ?
>>>
>>> index 37a0035f8381..53e29824d404 100644
>>> --- a/drivers/virtio/virtio_pci_modern.c
>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>> @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct
>>> virtio_device *vdev)
>>>            BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>>>            BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>>>
>>> +#ifdef CONFIG_X86
>>>    /*
>>>     * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
>>>     * commands are supported
>>> @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>> *pdev)
>>>                   return true;
>>>           return false;
>>>    }
>>> +#else
>>> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
>>> +{
>>> +       return false;
>>> +}
>>> +#endif
>>>    EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
>>
>> Doesn't this also raise the question of the purpose of virtio-vfio-pci
>> on non-x86?  Without any other features it offers nothing over vfio-pci
>> and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
>> Thanks,
>>
>> Alex
> 
> Kconfig dependency is what I had in mind, yes. The X86 specific code in
> virtio_pci_modern.c can be moved to a separate file then use makefile
> tricks to skip it on other platforms.
> 

The next feature for that driver will be the live migration support over 
virtio, once the specification which is WIP those day will be accepted.

The migration functionality is not X86 dependent and doesn't have the 
legacy virtio driver limitations that enforced us to run only on X86.

So, by that time we may need to enable in VFIO the loading of 
virtio-vfio-pci driver and put back the ifdef X86 inside VIRTIO, only on 
the legacy IO API, as I did already in V8.

So using a KCONFIG solution in VFIO is a short term one, which will be 
reverted just later on.

In addition, the virtio_pci_admin_has_legacy_io() API can be used in the 
future not only by VFIO, this was one of the reasons to put it inside 
VIRTIO.

As of that, we may expect that VIRTIO will consider its limitation and 
return false in systems that are not X86 and won't expose its 
concerns/knowledge to other modules.

As of the above, I believe that better staying with the solution inside 
VIRTIO as was suggested here and is part of V8 already.

Makes sense ?

Yishai




