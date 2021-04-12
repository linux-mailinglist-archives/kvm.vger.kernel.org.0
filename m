Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B87E35D37C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241472AbhDLWxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:53:36 -0400
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:42991
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238085AbhDLWxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:53:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmMVhP3x2C8Xo7uxcKVAW3wds/FU/AfM2pDFKO+b3cfLtOv2YZdihONkwRrLXoZX6bW0sic7X9SYU8LxfCIASYtGpDNvyfh/lSDas9dzk5uhIc/lcshkKoxLp7ulND8G+K3DxZLiY3b3CUdV0Yo3at0FhGkO0+N7BVj9bX3ZZdYog4SPVW6uF/4OmlXaC5XMzb1jgebpl9kGiY4gWhO4qRRziNQV1rzOvdGGCoW/vfYSrQu+i84ZgpjW12+7TPUTEHhI8z2nYMQzHtoO3vGtGfxcnKPKeX1WWubPgqAT8IdMEsKeEXMiQalJe3ysmP1qM0YjCWF30yYrbxBs6gpP5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS095DsM5HT9n9tGhRgCSoRqEhDwHFv17hM4ec8kcOI=;
 b=XfFwxiS3OY6CTcEn86k39HVGKyTqIpdzw1TuNwtxPcaKjZjOAUM3QvhXRDbA4SDTGdB2PpcqBjeMX6kBitk1MWiSE9IaHPjfAgJkv/RLJJiDLtVEUMazlW40Oq4H5zPw64hl3ZuYRON07AON4TWtnWgygjPu2YRnWik7o1PTEtJGyjnpR5t8UNnLg/vP/Qs4yJIps3WTx7WUvDpuKR8I48zGj0dvoEkDX1GBmXzHhfufVJwu02MSKPrn1uQpAdty9nq7tbz+ND6TfUab1bxkyJXV1R+/REl10txj2wsdwFd48++7BpFj49AxtOBVYqRDn6bX8Jq70Ti64LI0hRff0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS095DsM5HT9n9tGhRgCSoRqEhDwHFv17hM4ec8kcOI=;
 b=c2oYo0XYZDowbl84TkIHopkJJfCcQinA2aKdb3b7NNM4367ibcxhuxu3ujZVB/hdmBkAg0daCjNlf//vv4TJAbZZXzTZ8E0bjonQqUXBDWrC5hFU/SaqDlsan0OUFdLUFNFxa2tisrpIbEbeQH+FYjw/PXHnbRsjGsQFE2BWxOKL9CTMX+e0HPjn0XRCFL3oo6UUMasAkai5p9Wa2m1mwH2pyfGVcuqIfJmv5ds53SMmfozf6eijxduTsnqomhMeqc1Ibef/Qyh54fmDRTQcMdAD1Dw77dsqkkZsomaSVzSKCDMavhHGPwVomsoCasMG3aJ3QzN3o1jBQQPIoI4WJw==
Received: from BN6PR12CA0036.namprd12.prod.outlook.com (2603:10b6:405:70::22)
 by DM5PR12MB1178.namprd12.prod.outlook.com (2603:10b6:3:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Mon, 12 Apr
 2021 22:53:15 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::e9) by BN6PR12CA0036.outlook.office365.com
 (2603:10b6:405:70::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 22:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:53:14 +0000
Received: from [172.27.0.17] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 22:53:11 +0000
Subject: Re: [PATCH v2 1/3] virtio: update reset callback to return status
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <oren@nvidia.com>,
        <nitzanc@nvidia.com>, <cohuck@redhat.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
 <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
 <20210408115524-mutt-send-email-mst@kernel.org>
 <31fa92ca-bce5-b71f-406d-8f3951b2143c@nvidia.com>
 <20210412080051-mutt-send-email-mst@kernel.org>
 <b99e324b-3a78-b3ed-98a8-a3b88a271338@nvidia.com>
 <20210412171858-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <10e099a9-2e3d-8c39-138a-17b2674b5389@nvidia.com>
Date:   Tue, 13 Apr 2021 01:53:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210412171858-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57cd0009-bfbc-45fd-3195-08d8fe05c1a5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1178:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1178AC2E07C7FA1598D1DC08DE709@DM5PR12MB1178.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P6A5UNvanJaUfPUh7bAI4zHq7UC72Fhkhd5dY11UPIlWng5GLnATDEJPu2w1K2iLSanS/0n/z7JfdlOdjR/zbjhFwfCD7gBljY8+X/W98kFhpQPVan+P4QU1btKKE2e7QSVm11ivfNmcUTZQIDbkgZ0kZLrealovdJAWpZUnOwdHq67IehFmyDOATk8C+mvmHNzAELBeQHdg6BEqaB6PpqjGkiafPAizGv2PTjMF15SgXp0RcJo3rs3GbLgyyrOhWWeZrhYxWvGPvK+PLjdlT8NbJkyxF8gj7MWtUR8treS6s3yB1IYM/JMjFHm6mdURDNWT8wYIaUAzV76AZwSFA/NsVwYkVSgvl9mEcspjTxxqtlXQBeW3IbHC6osYyfrx8tBb2W2ukXEQU2afs6ywF5ZrF+WNLTsGj9gaOWeob5lC9GC9j5Xaf9I41PDhIZ4ZyPR7LpvOSzsTKnGEyxBykFSzRDzA0+X6jtR3paXU247rxoQu4cHfKDTteEYAWBCFOrou7XdDPRxjdz6e06pGx37xaaFayfUHZXs6Eh06+Hmtfa6PYZZP+C+D7JSEWC7URe0VnI7h8gCCE/U0Q3RSvTZwWTwD8WAypOO0e8R6IM3PycPlbAmEqYu8HUE8PR6/Fd6s0+VeNtFOsyHf+FOp4ZXpN7lEgv/tn/Rs8LPGw5WIqsMRwz/8NjcTEykIlvZVpJCH8U3vzvbWGkUVCP/Xxg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(36840700001)(46966006)(82310400003)(6666004)(70586007)(426003)(16576012)(8676002)(478600001)(31696002)(6916009)(36860700001)(36906005)(316002)(30864003)(356005)(16526019)(15650500001)(86362001)(2906002)(7636003)(186003)(4326008)(54906003)(2616005)(5660300002)(336012)(83380400001)(31686004)(53546011)(36756003)(26005)(82740400003)(47076005)(8936002)(70206006)(60764002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:53:14.8166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cd0009-bfbc-45fd-3195-08d8fe05c1a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1178
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/13/2021 12:23 AM, Michael S. Tsirkin wrote:
> On Mon, Apr 12, 2021 at 04:03:02PM +0300, Max Gurtovoy wrote:
>> On 4/12/2021 3:04 PM, Michael S. Tsirkin wrote:
>>> On Mon, Apr 12, 2021 at 02:55:27PM +0300, Max Gurtovoy wrote:
>>>> On 4/8/2021 6:56 PM, Michael S. Tsirkin wrote:
>>>>> On Thu, Apr 08, 2021 at 12:56:52PM +0300, Max Gurtovoy wrote:
>>>>>> On 4/8/2021 11:58 AM, Jason Wang wrote:
>>>>>>> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>>>>>>>> The reset device operation, usually is an operation that might fail from
>>>>>>>> various reasons. For example, the controller might be in a bad state and
>>>>>>>> can't answer to any request. Usually, the paravirt SW based virtio
>>>>>>>> devices always succeed in reset operation but this is not the case for
>>>>>>>> HW based virtio devices.
>>>>>>> I would like to know under what condition that the reset operation may
>>>>>>> fail (except for the case of a bugg guest).
>>>>>> The controller might not be ready or stuck. This is a real use case for many
>>>>>> PCI devices.
>>>>>>
>>>>>> For real devices the FW might be in a bad state and it can happen also for
>>>>>> paravirt device if you have a bug in the controller code or if you entered
>>>>>> some error flow (Out of memory).
>>>>>>
>>>>>> You don't want to be stuck because of one bad device.
>>>>> OK so maybe we can do more to detect the bad device.
>>>>> Won't we get all 1's on a read in this case?
>>>> No. how can we guarantee it ?
>>>>
>>> Well this is what you tend to get if e.g. you disable device memory.
>>>
>>> Anyway, you know about hardware, I don't ... It's not returning 0 after
>>> reset as it should ... what does it return? Hopefully not random noise -
>>> I don't think it's very practical to write a driver for a device that
>>> starts doing that at random times ...
>> The device may return 0x40 (NEEDS_RESET). It doesn't have to return all 1's.
>>
>> For paravirt devices, think of a situation that you can't allocate some
>> internal buffers (malloc failed) and you want to wait for few seconds until
>> the system memory will free some pages.
>>
>> So you may return NEEDS_RESET that indicates some error state of the device.
>> Once the system memory freed by other application for example, your internal
>> virtio device malloc succeeded and you may return 0.
>>
>> In this case, you don't want to stall the other virtio devices to probe
>> (they might be real HW devices that driven by the same driver), right ?
> So the device is very busy then? Not sure it's smart to just assume
> it's safe to free all memory allocated for it then ...
>
> I guess the lesson is don't make device reset depend on malloc
> of some memory?

The device is not ready yet. And the malloc is just one example I gave 
you to emphasize the case.

Another example can be a bad FW installed.

The host/guest driver is trying to enable the device but the device is 
not ready. This is the real life use case and I gave many examples for 
reasons for device not to be ready. For paravirt and HW devices.

Endless loop and stalling next devices probe is not the way to go. PCI 
drivers can't allow this to happen.

Think of a situation that host it's booting from virtio-blk device but 
it has another virtio-net device that has bad FW or other internal error 
(it doesn't matter what it is for the example) and the virtio pci driver 
is probing virtio-net device first.

The host will never boot successfully. This is fatal.

Error flows are critical when working with real PCI HW and I understand 
that in paravirt devices with strong hypervisor you will be ok in 99% of 
the time but you need to be aware also for bugs and error flows in both 
paravirt and HW world.

So first we need to handle this endless loop (with this patch set or 
with async probing mechanism) and later we should update the specification.

The virtio world now is not only guest and paravirt devices. Bare metal 
hosts start using virtio devices and drivers more and more.

>
>
>>>>>>>> This commit is also a preparation for adding a timeout mechanism for
>>>>>>>> resetting virtio devices.
>>>>>>>>
>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> changes from v1:
>>>>>>>>      - update virtio_ccw.c (Cornelia)
>>>>>>>>      - update virtio_uml.c
>>>>>>>>      - update mlxbf-tmfifo.c
>>>>>>> Note that virtio driver may call reset, so you probably need to convert
>>>>>>> them.
>>>>>> I'm sure I understand.
>>>>>>
>>>>>> Convert to what ?
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>
>>>>>>>> ---
>>>>>>>>      arch/um/drivers/virtio_uml.c             |  4 +++-
>>>>>>>>      drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
>>>>>>>>      drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
>>>>>>>>      drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
>>>>>>>>      drivers/virtio/virtio.c                  | 22 +++++++++++++++-------
>>>>>>>>      drivers/virtio/virtio_mmio.c             |  3 ++-
>>>>>>>>      drivers/virtio/virtio_pci_legacy.c       |  4 +++-
>>>>>>>>      drivers/virtio/virtio_pci_modern.c       |  3 ++-
>>>>>>>>      drivers/virtio/virtio_vdpa.c             |  4 +++-
>>>>>>>>      include/linux/virtio_config.h            |  5 +++--
>>>>>>>>      10 files changed, 43 insertions(+), 19 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
>>>>>>>> index 91ddf74ca888..b6e66265ed32 100644
>>>>>>>> --- a/arch/um/drivers/virtio_uml.c
>>>>>>>> +++ b/arch/um/drivers/virtio_uml.c
>>>>>>>> @@ -827,11 +827,13 @@ static void vu_set_status(struct virtio_device
>>>>>>>> *vdev, u8 status)
>>>>>>>>          vu_dev->status = status;
>>>>>>>>      }
>>>>>>>>      -static void vu_reset(struct virtio_device *vdev)
>>>>>>>> +static int vu_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>>>>>>>>            vu_dev->status = 0;
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        static void vu_del_vq(struct virtqueue *vq)
>>>>>>>> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> index bbc4e71a16ff..c192b8ac5d9e 100644
>>>>>>>> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> @@ -980,11 +980,13 @@ static void
>>>>>>>> mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
>>>>>>>>      }
>>>>>>>>        /* Reset the device. Not much here for now. */
>>>>>>>> -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>>>>>> +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
>>>>>>>>            tm_vdev->status = 0;
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        /* Read the value of a configuration field. */
>>>>>>>> diff --git a/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> b/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> index 0cc617f76068..ca9573c62c3d 100644
>>>>>>>> --- a/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> +++ b/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> @@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct
>>>>>>>> virtio_device *vdev, u8 status)
>>>>>>>>          dev_dbg(&vdev->dev, "status: %d\n", status);
>>>>>>>>      }
>>>>>>>>      -static void rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>> +static int rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
>>>>>>>>          struct fw_rsc_vdev *rsc;
>>>>>>>> @@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct
>>>>>>>> virtio_device *vdev)
>>>>>>>>            rsc->status = 0;
>>>>>>>>          dev_dbg(&vdev->dev, "reset !\n");
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        /* provide the vdev features as retrieved from the firmware */
>>>>>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> index 54e686dca6de..52b32555e746 100644
>>>>>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> @@ -732,14 +732,15 @@ static int virtio_ccw_find_vqs(struct
>>>>>>>> virtio_device *vdev, unsigned nvqs,
>>>>>>>>          return ret;
>>>>>>>>      }
>>>>>>>>      -static void virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>> +static int virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>>>>>>>>          struct ccw1 *ccw;
>>>>>>>> +    int ret;
>>>>>>>>            ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
>>>>>>>>          if (!ccw)
>>>>>>>> -        return;
>>>>>>>> +        return -ENOMEM;
>>>>>>>>            /* Zero status bits. */
>>>>>>>>          vcdev->dma_area->status = 0;
>>>>>>>> @@ -749,8 +750,10 @@ static void virtio_ccw_reset(struct
>>>>>>>> virtio_device *vdev)
>>>>>>>>          ccw->flags = 0;
>>>>>>>>          ccw->count = 0;
>>>>>>>>          ccw->cda = 0;
>>>>>>>> -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>>>>>> +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>>>>>>          ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
>>>>>>>> +
>>>>>>>> +    return ret;
>>>>>>>>      }
>>>>>>>>        static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>>>>>>>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>>>>>>>> index 4b15c00c0a0a..ddbfd5b5f3bd 100644
>>>>>>>> --- a/drivers/virtio/virtio.c
>>>>>>>> +++ b/drivers/virtio/virtio.c
>>>>>>>> @@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device
>>>>>>>> *dev)
>>>>>>>>          /* Assign a unique device index and hence name. */
>>>>>>>>          err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
>>>>>>>>          if (err < 0)
>>>>>>>> -        goto out;
>>>>>>>> +        goto out_err;
>>>>>>>>            dev->index = err;
>>>>>>>>          dev_set_name(&dev->dev, "virtio%u", dev->index);
>>>>>>>> @@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device
>>>>>>>> *dev)
>>>>>>>>            /* We always start by resetting the device, in case a previous
>>>>>>>>           * driver messed it up.  This also tests that code path a
>>>>>>>> little. */
>>>>>>>> -    dev->config->reset(dev);
>>>>>>>> +    err = dev->config->reset(dev);
>>>>>>>> +    if (err)
>>>>>>>> +        goto out_ida;
>>>>>>>>            /* Acknowledge that we've seen the device. */
>>>>>>>>          virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>>>>>> @@ -362,10 +364,14 @@ int register_virtio_device(struct
>>>>>>>> virtio_device *dev)
>>>>>>>>           */
>>>>>>>>          err = device_add(&dev->dev);
>>>>>>>>          if (err)
>>>>>>>> -        ida_simple_remove(&virtio_index_ida, dev->index);
>>>>>>>> -out:
>>>>>>>> -    if (err)
>>>>>>>> -        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>>>>>> +        goto out_ida;
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>> +
>>>>>>>> +out_ida:
>>>>>>>> +    ida_simple_remove(&virtio_index_ida, dev->index);
>>>>>>>> +out_err:
>>>>>>>> +    virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>>>>>>          return err;
>>>>>>>>      }
>>>>>>>>      EXPORT_SYMBOL_GPL(register_virtio_device);
>>>>>>>> @@ -408,7 +414,9 @@ int virtio_device_restore(struct virtio_device *dev)
>>>>>>>>            /* We always start by resetting the device, in case a previous
>>>>>>>>           * driver messed it up. */
>>>>>>>> -    dev->config->reset(dev);
>>>>>>>> +    ret = dev->config->reset(dev);
>>>>>>>> +    if (ret)
>>>>>>>> +        goto err;
>>>>>>>>            /* Acknowledge that we've seen the device. */
>>>>>>>>          virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>>>>>> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
>>>>>>>> index 56128b9c46eb..12b8f048c48d 100644
>>>>>>>> --- a/drivers/virtio/virtio_mmio.c
>>>>>>>> +++ b/drivers/virtio/virtio_mmio.c
>>>>>>>> @@ -256,12 +256,13 @@ static void vm_set_status(struct virtio_device
>>>>>>>> *vdev, u8 status)
>>>>>>>>          writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>>>>>>      }
>>>>>>>>      -static void vm_reset(struct virtio_device *vdev)
>>>>>>>> +static int vm_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>>>>>>>>            /* 0 status means a reset. */
>>>>>>>>          writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        diff --git a/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> b/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> index d62e9835aeec..0b5d95e3efa1 100644
>>>>>>>> --- a/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> +++ b/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> @@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device
>>>>>>>> *vdev, u8 status)
>>>>>>>>          iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>>>>>>      }
>>>>>>>>      -static void vp_reset(struct virtio_device *vdev)
>>>>>>>> +static int vp_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>>>>          /* 0 status means a reset. */
>>>>>>>> @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
>>>>>>>>          ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>>>>>>          /* Flush pending VQ/configuration callbacks. */
>>>>>>>>          vp_synchronize_vectors(vdev);
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        static u16 vp_config_vector(struct virtio_pci_device *vp_dev,
>>>>>>>> u16 vector)
>>>>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>>>>> index fbd4ebc00eb6..cc3412a96a17 100644
>>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>>> @@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device
>>>>>>>> *vdev, u8 status)
>>>>>>>>          vp_modern_set_status(&vp_dev->mdev, status);
>>>>>>>>      }
>>>>>>>>      -static void vp_reset(struct virtio_device *vdev)
>>>>>>>> +static int vp_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>>>>          struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>>>>>> @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
>>>>>>>>              msleep(1);
>>>>>>>>          /* Flush pending VQ/configuration callbacks. */
>>>>>>>>          vp_synchronize_vectors(vdev);
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        static u16 vp_config_vector(struct virtio_pci_device *vp_dev,
>>>>>>>> u16 vector)
>>>>>>>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
>>>>>>>> index e28acf482e0c..5fd4e627a9b0 100644
>>>>>>>> --- a/drivers/virtio/virtio_vdpa.c
>>>>>>>> +++ b/drivers/virtio/virtio_vdpa.c
>>>>>>>> @@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct
>>>>>>>> virtio_device *vdev, u8 status)
>>>>>>>>          return ops->set_status(vdpa, status);
>>>>>>>>      }
>>>>>>>>      -static void virtio_vdpa_reset(struct virtio_device *vdev)
>>>>>>>> +static int virtio_vdpa_reset(struct virtio_device *vdev)
>>>>>>>>      {
>>>>>>>>          struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>>>>>>>>            vdpa_reset(vdpa);
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>        static bool virtio_vdpa_notify(struct virtqueue *vq)
>>>>>>>> diff --git a/include/linux/virtio_config.h
>>>>>>>> b/include/linux/virtio_config.h
>>>>>>>> index 8519b3ae5d52..d2b0f1699a75 100644
>>>>>>>> --- a/include/linux/virtio_config.h
>>>>>>>> +++ b/include/linux/virtio_config.h
>>>>>>>> @@ -44,9 +44,10 @@ struct virtio_shm_region {
>>>>>>>>       *    status: the new status byte
>>>>>>>>       * @reset: reset the device
>>>>>>>>       *    vdev: the virtio device
>>>>>>>> - *    After this, status and feature negotiation must be done again
>>>>>>>> + *    Upon success, status and feature negotiation must be done again
>>>>>>>>       *    Device must not be reset from its vq/config callbacks, or in
>>>>>>>>       *    parallel with being added/removed.
>>>>>>>> + *    Returns 0 on success or error status.
>>>>>>>>       * @find_vqs: find virtqueues and instantiate them.
>>>>>>>>       *    vdev: the virtio_device
>>>>>>>>       *    nvqs: the number of virtqueues to find
>>>>>>>> @@ -82,7 +83,7 @@ struct virtio_config_ops {
>>>>>>>>          u32 (*generation)(struct virtio_device *vdev);
>>>>>>>>          u8 (*get_status)(struct virtio_device *vdev);
>>>>>>>>          void (*set_status)(struct virtio_device *vdev, u8 status);
>>>>>>>> -    void (*reset)(struct virtio_device *vdev);
>>>>>>>> +    int (*reset)(struct virtio_device *vdev);
>>>>>>>>          int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>>>>>>>>                  struct virtqueue *vqs[], vq_callback_t *callbacks[],
>>>>>>>>                  const char * const names[], const bool *ctx,
