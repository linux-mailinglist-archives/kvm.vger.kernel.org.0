Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8124D35DCEE
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 12:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhDMK4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 06:56:38 -0400
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:13440
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230123AbhDMK4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 06:56:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbQkRXqNz2jhZ9DiwiVngEdPZ14732rBhlwS99/liUqswSVbdjJUbEG43FHTT6JfQjU5xWec0OM4xCzxBeRwEbvFAlsHxZnq/38ATozNYVohiu0wUNl0uxtlvsN8ZfL6GH2pwTBvTkjPZXg/IGcuNsBfNiSyAOi022NJwetze6msvmBHqhIZ67H9CZ4eiXM1m2VRHBqM4lOhPBwhy+T39wa9g33+tZK8PoROWSdi9+h27XDO9Kyjh7BFYZhB5tc5rczf2mMFEH+FnsHRlaBxYvXmtph0AymNBR1Dc06CfkY9Bag6wWknw4d1fTBkhTQEtTWgy7t5/WscW/BFmQUZPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Goy0ldwQQvElj5zuFdVmjoCXh8DKTFeMpjd3/b8SuRI=;
 b=QA8sap8PUZCZLkdcTocAmfnENyy4DNUMzJMwBqbAV4tMFfzZLec2UFLzBxWP7PlgHwO7WL+EDwDM0/16BpUqRcFyF8sobMJT0/b1a7bzrxz9FFb3YYAT+JxEu8Ui1vSpxGmb7PN3frD1OTc13Hi/gIb7wT2o6ec44BVfT7Y6TWcJqsji3HGrvZQAcV4gEfv9Eo9Imky/HZ6oJGdcyUhsIgVNdbh+mK/jQn/ItgmU1f1UpjDZBP0j/wu3CzFegJsh6aLdR4YOx8Z2n7vE8i0eqS7jGFxmGP8a0d4+bTXWtqPw3uaOyKLl6zf686Ol0m1Q5GLQ0ydQsRReJ/tEr3Q7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Goy0ldwQQvElj5zuFdVmjoCXh8DKTFeMpjd3/b8SuRI=;
 b=o+6mZkzkSiVicS8QyBfKqoY7WmWDTIJxyPqazCkwECYzx1Z0QL5+21V5Ps0ywuIhTcc+e5kyBiZ7U0pP3ufDTChsFoCxjy4JQCzUzERrrEBh8dqomDLz6cR8Ri4AoSI7fY4ROzLsb4rGFWrTZ977RgjUYQ6qL0b7q7UGqVZlZIHOvvUuBBzN04SsNkEOzcsybm5cUvNRRJ0fQT/stLTv9vxZsgXpiJkq/HCjWGhZcX7XLR3LX3HpjcmLxPiSx68aCVy/XBlqZ1Qu6DeYTyQYgm1LtNmKxat9S7qROQePf+frZgk0VvrsKPCE8bLdKYIhVCInsD5cupSLmdXO5C6aRw==
Received: from MWHPR2201CA0059.namprd22.prod.outlook.com
 (2603:10b6:301:16::33) by MN2PR12MB3760.namprd12.prod.outlook.com
 (2603:10b6:208:158::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 10:56:14 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::c5) by MWHPR2201CA0059.outlook.office365.com
 (2603:10b6:301:16::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Tue, 13 Apr 2021 10:56:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 10:56:13 +0000
Received: from [10.223.2.15] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Apr
 2021 10:56:11 +0000
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
 <10e099a9-2e3d-8c39-138a-17b2674b5389@nvidia.com>
 <20210413002531-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <b3127da1-fc54-7ce7-326b-139f259bc0c6@nvidia.com>
Date:   Tue, 13 Apr 2021 13:56:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413002531-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58d60528-538a-4a45-a956-08d8fe6ac19e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3760:
X-Microsoft-Antispam-PRVS: <MN2PR12MB376099C5288CE14DD6FA1EE8DE4F9@MN2PR12MB3760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cQPNUAHsV9kKyU08PJQCjzFf0osGjPSwV26k95fztjHSztGMS93xJGnd9kpYRKgsb+BTu32rUGhDAezZH6cDwP6FCNv76BbLnx3ElO3DullhQy762TkpgM07h13cSi34YNN9BOWzJ2LZ5y4jFJy0b0jJT5QQb0XNd2CjZyw/X59KE0taLUMroFZq7opoTUsWcmlbbfhWPh3ozcKWQ5Pe18XY0wVk6xlZYPIpsMkctP7mW7oDFNh3YkpLnLi93QQdRFyC++LdDc/Ug9JY2MGL8vxf88F+UxEONA+Uaumobcu95UIdp51KlnCSFUf9HdxXr1LPCMe7lRii73dpOdTFp1bvnUpUsq7nlwxsV8Q/Ycu4iJHqLS21r25HmbZf1AjQpqYFhdXhPcsJGQHgEPKr0usOWTMDP3S+Y1rAfg/Y9m7x6jlokJ567+QE2eOjCTETkx2hGoddyxkZQVEjJeue5r82OCSbwld/cNz8oCw/i4YFgXefMJFHJAuk/gNKzkLUPVWp1YZ0aVt1MopFVpysdSbUWwDFurRjOJKp23m16lrg7thuUsnnWlpP2dHZPsxI9SxUNL/oAWwg17ZaOvPBkxdHFm0LwX1+AQzf8h4ZoyruyVOzIvhmgMbFtAx7OUHNb5CGtegv2joNwvaUS5miPo+tlBacQU0ibbVxKh5EjDuALrYOvNnyWF0S7WN3Ggcb1LNeFetP2kp0dVmQro1F5Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(8936002)(70206006)(8676002)(53546011)(186003)(82310400003)(4326008)(70586007)(31686004)(16526019)(5660300002)(2616005)(316002)(426003)(26005)(336012)(2906002)(15650500001)(6666004)(478600001)(6916009)(30864003)(31696002)(83380400001)(47076005)(36860700001)(36756003)(86362001)(54906003)(36906005)(356005)(7636003)(16576012)(82740400003)(60764002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 10:56:13.9965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d60528-538a-4a45-a956-08d8fe6ac19e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3760
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/13/2021 7:42 AM, Michael S. Tsirkin wrote:
> On Tue, Apr 13, 2021 at 01:53:02AM +0300, Max Gurtovoy wrote:
>> On 4/13/2021 12:23 AM, Michael S. Tsirkin wrote:
>>> On Mon, Apr 12, 2021 at 04:03:02PM +0300, Max Gurtovoy wrote:
>>>> On 4/12/2021 3:04 PM, Michael S. Tsirkin wrote:
>>>>> On Mon, Apr 12, 2021 at 02:55:27PM +0300, Max Gurtovoy wrote:
>>>>>> On 4/8/2021 6:56 PM, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Apr 08, 2021 at 12:56:52PM +0300, Max Gurtovoy wrote:
>>>>>>>> On 4/8/2021 11:58 AM, Jason Wang wrote:
>>>>>>>>> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>>>>>>>>>> The reset device operation, usually is an operation that might fail from
>>>>>>>>>> various reasons. For example, the controller might be in a bad state and
>>>>>>>>>> can't answer to any request. Usually, the paravirt SW based virtio
>>>>>>>>>> devices always succeed in reset operation but this is not the case for
>>>>>>>>>> HW based virtio devices.
>>>>>>>>> I would like to know under what condition that the reset operation may
>>>>>>>>> fail (except for the case of a bugg guest).
>>>>>>>> The controller might not be ready or stuck. This is a real use case for many
>>>>>>>> PCI devices.
>>>>>>>>
>>>>>>>> For real devices the FW might be in a bad state and it can happen also for
>>>>>>>> paravirt device if you have a bug in the controller code or if you entered
>>>>>>>> some error flow (Out of memory).
>>>>>>>>
>>>>>>>> You don't want to be stuck because of one bad device.
>>>>>>> OK so maybe we can do more to detect the bad device.
>>>>>>> Won't we get all 1's on a read in this case?
>>>>>> No. how can we guarantee it ?
>>>>>>
>>>>> Well this is what you tend to get if e.g. you disable device memory.
>>>>>
>>>>> Anyway, you know about hardware, I don't ... It's not returning 0 after
>>>>> reset as it should ... what does it return? Hopefully not random noise -
>>>>> I don't think it's very practical to write a driver for a device that
>>>>> starts doing that at random times ...
>>>> The device may return 0x40 (NEEDS_RESET). It doesn't have to return all 1's.
>>>>
>>>> For paravirt devices, think of a situation that you can't allocate some
>>>> internal buffers (malloc failed) and you want to wait for few seconds until
>>>> the system memory will free some pages.
>>>>
>>>> So you may return NEEDS_RESET that indicates some error state of the device.
>>>> Once the system memory freed by other application for example, your internal
>>>> virtio device malloc succeeded and you may return 0.
>>>>
>>>> In this case, you don't want to stall the other virtio devices to probe
>>>> (they might be real HW devices that driven by the same driver), right ?
>>> So the device is very busy then? Not sure it's smart to just assume
>>> it's safe to free all memory allocated for it then ...
>>>
>>> I guess the lesson is don't make device reset depend on malloc
>>> of some memory?
>> The device is not ready yet. And the malloc is just one example I gave you
>> to emphasize the case.
>>
>> Another example can be a bad FW installed.
> Surely this will wedge the host device to the point where vdpa won't
> even be probed?

what VDPA device ?


>
>> The host/guest driver is trying to enable the device but the device is not
>> ready. This is the real life use case and I gave many examples for reasons
>> for device not to be ready. For paravirt and HW devices.
>>
>> Endless loop and stalling next devices probe is not the way to go. PCI
>> drivers can't allow this to happen.
>>
>> Think of a situation that host it's booting from virtio-blk device but it
>> has another virtio-net device that has bad FW or other internal error (it
>> doesn't matter what it is for the example) and the virtio pci driver is
>> probing virtio-net device first.
>>
>> The host will never boot successfully. This is fatal.
> It's not nice for sure. But broken hardware is broken hardware.

what does it mean ?

broken SW is broken SW as well.

And maybe it's not something that can't be solved manually. why do you 
insist on breaking application in case of error flows ?

what will happen if, for example, virtiofsd process will be killed ? do 
you want the entire guest to suffer ?


> Try not to have it is still best advice.
> Making very sure this will never regress any useful flows is high
> priority though.  Thus the focus on addressing specific issues
> not just falling over the moment something seems a bit fishy.
>
>> Error flows are critical when working with real PCI HW and I understand that
>> in paravirt devices with strong hypervisor you will be ok in 99% of the time
>> but you need to be aware also for bugs and error flows in both paravirt and
>> HW world.
>>
>> So first we need to handle this endless loop (with this patch set or with
>> async probing mechanism) and later we should update the specification.
>>
>> The virtio world now is not only guest and paravirt devices. Bare metal
>> hosts start using virtio devices and drivers more and more.
> Excellent so can we please stop talking hypotheticals and discuss how
> does actual hardware behave, and how best to recover in each case?

Why hypothetical ? if you say that SW bugs in paravirt controllers or 
some system stress is hypothetical so I dis-agree.

For HW devices, I gave you an example of broken FW.

In DPU solutions you enter a world with entire matrix of errors that can 
happen.

Error sometimes are recoverable, but virtio driver probes in sync way 
and this is wrong.

I gave you an example of booting from virtio-blk device that might be fatal.


> Recovering from weird scenarious like bad firmware is nice to have but
> not at risk of e.g. corrupting kernel memory. Which blindly removing the
> driver with an active device has a good chance to do.

weird ? This is the reality. If we will ignore it, this will not be fixed.

Error flows are not nice to have. They are the building blocks of 
developing robust solutions.


>
> Just to stress the importance of addressing actual issues,
> how was this patch even tested? Worth mentioning in the commit log.

With NVIDIA virtio-blk SNAP device.

I plugged virtio-blk pci function to host pci subsystem, and I entered 
the controller to error state.

Then I plugged another function in good state but it was never probed 
without this patch set.

With this patch set, after a timeout the first device failed to probed 
and cleaned all needed resources and the second device probed successfully.

later on, I moved the first controller from error state to good state 
and re-scanned the pci bus to re-probe it (There are other ways to cause 
the driver to re-probe it).

>
> And by the way, there are actually use-cases I am aware of where we spin
> forever and really should not, for example it would be super nice to
> support surprise removal so host can drop the driver after device is
> gone without waiting for guest. This allows allocating the device to
> another VM.  In that case too, an out of the blue timeout and blindly
> assuming all is well is not the way to go, you need to probe device to
> check whether it's dead or alive.
> Maybe your error recovery can fit in such a framework.
>
Spinning forever in kernel is not a good practice and we can think of 
many scenarios. But we should start somewhere and continue improving the 
stack.


>>>
>>>>>>>>>> This commit is also a preparation for adding a timeout mechanism for
>>>>>>>>>> resetting virtio devices.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>>>> ---
>>>>>>>>>>
>>>>>>>>>> changes from v1:
>>>>>>>>>>       - update virtio_ccw.c (Cornelia)
>>>>>>>>>>       - update virtio_uml.c
>>>>>>>>>>       - update mlxbf-tmfifo.c
>>>>>>>>> Note that virtio driver may call reset, so you probably need to convert
>>>>>>>>> them.
>>>>>>>> I'm sure I understand.
>>>>>>>>
>>>>>>>> Convert to what ?
>>>>>>>>
>>>>>>>> Thanks.
>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>> ---
>>>>>>>>>>       arch/um/drivers/virtio_uml.c             |  4 +++-
>>>>>>>>>>       drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
>>>>>>>>>>       drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
>>>>>>>>>>       drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
>>>>>>>>>>       drivers/virtio/virtio.c                  | 22 +++++++++++++++-------
>>>>>>>>>>       drivers/virtio/virtio_mmio.c             |  3 ++-
>>>>>>>>>>       drivers/virtio/virtio_pci_legacy.c       |  4 +++-
>>>>>>>>>>       drivers/virtio/virtio_pci_modern.c       |  3 ++-
>>>>>>>>>>       drivers/virtio/virtio_vdpa.c             |  4 +++-
>>>>>>>>>>       include/linux/virtio_config.h            |  5 +++--
>>>>>>>>>>       10 files changed, 43 insertions(+), 19 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
>>>>>>>>>> index 91ddf74ca888..b6e66265ed32 100644
>>>>>>>>>> --- a/arch/um/drivers/virtio_uml.c
>>>>>>>>>> +++ b/arch/um/drivers/virtio_uml.c
>>>>>>>>>> @@ -827,11 +827,13 @@ static void vu_set_status(struct virtio_device
>>>>>>>>>> *vdev, u8 status)
>>>>>>>>>>           vu_dev->status = status;
>>>>>>>>>>       }
>>>>>>>>>>       -static void vu_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int vu_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>>>>>>>>>>             vu_dev->status = 0;
>>>>>>>>>> +
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         static void vu_del_vq(struct virtqueue *vq)
>>>>>>>>>> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>>>> b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>>>> index bbc4e71a16ff..c192b8ac5d9e 100644
>>>>>>>>>> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>>>> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>>>> @@ -980,11 +980,13 @@ static void
>>>>>>>>>> mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
>>>>>>>>>>       }
>>>>>>>>>>         /* Reset the device. Not much here for now. */
>>>>>>>>>> -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
>>>>>>>>>>             tm_vdev->status = 0;
>>>>>>>>>> +
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         /* Read the value of a configuration field. */
>>>>>>>>>> diff --git a/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>>>> b/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>>>> index 0cc617f76068..ca9573c62c3d 100644
>>>>>>>>>> --- a/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>>>> +++ b/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>>>> @@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct
>>>>>>>>>> virtio_device *vdev, u8 status)
>>>>>>>>>>           dev_dbg(&vdev->dev, "status: %d\n", status);
>>>>>>>>>>       }
>>>>>>>>>>       -static void rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
>>>>>>>>>>           struct fw_rsc_vdev *rsc;
>>>>>>>>>> @@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct
>>>>>>>>>> virtio_device *vdev)
>>>>>>>>>>             rsc->status = 0;
>>>>>>>>>>           dev_dbg(&vdev->dev, "reset !\n");
>>>>>>>>>> +
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         /* provide the vdev features as retrieved from the firmware */
>>>>>>>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>>>> b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>>>> index 54e686dca6de..52b32555e746 100644
>>>>>>>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>>>> @@ -732,14 +732,15 @@ static int virtio_ccw_find_vqs(struct
>>>>>>>>>> virtio_device *vdev, unsigned nvqs,
>>>>>>>>>>           return ret;
>>>>>>>>>>       }
>>>>>>>>>>       -static void virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>>>>>>>>>>           struct ccw1 *ccw;
>>>>>>>>>> +    int ret;
>>>>>>>>>>             ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
>>>>>>>>>>           if (!ccw)
>>>>>>>>>> -        return;
>>>>>>>>>> +        return -ENOMEM;
>>>>>>>>>>             /* Zero status bits. */
>>>>>>>>>>           vcdev->dma_area->status = 0;
>>>>>>>>>> @@ -749,8 +750,10 @@ static void virtio_ccw_reset(struct
>>>>>>>>>> virtio_device *vdev)
>>>>>>>>>>           ccw->flags = 0;
>>>>>>>>>>           ccw->count = 0;
>>>>>>>>>>           ccw->cda = 0;
>>>>>>>>>> -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>>>>>>>> +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>>>>>>>>           ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
>>>>>>>>>> +
>>>>>>>>>> +    return ret;
>>>>>>>>>>       }
>>>>>>>>>>         static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>>>>>>>>>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>>>>>>>>>> index 4b15c00c0a0a..ddbfd5b5f3bd 100644
>>>>>>>>>> --- a/drivers/virtio/virtio.c
>>>>>>>>>> +++ b/drivers/virtio/virtio.c
>>>>>>>>>> @@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device
>>>>>>>>>> *dev)
>>>>>>>>>>           /* Assign a unique device index and hence name. */
>>>>>>>>>>           err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
>>>>>>>>>>           if (err < 0)
>>>>>>>>>> -        goto out;
>>>>>>>>>> +        goto out_err;
>>>>>>>>>>             dev->index = err;
>>>>>>>>>>           dev_set_name(&dev->dev, "virtio%u", dev->index);
>>>>>>>>>> @@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device
>>>>>>>>>> *dev)
>>>>>>>>>>             /* We always start by resetting the device, in case a previous
>>>>>>>>>>            * driver messed it up.  This also tests that code path a
>>>>>>>>>> little. */
>>>>>>>>>> -    dev->config->reset(dev);
>>>>>>>>>> +    err = dev->config->reset(dev);
>>>>>>>>>> +    if (err)
>>>>>>>>>> +        goto out_ida;
>>>>>>>>>>             /* Acknowledge that we've seen the device. */
>>>>>>>>>>           virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>>>>>>>> @@ -362,10 +364,14 @@ int register_virtio_device(struct
>>>>>>>>>> virtio_device *dev)
>>>>>>>>>>            */
>>>>>>>>>>           err = device_add(&dev->dev);
>>>>>>>>>>           if (err)
>>>>>>>>>> -        ida_simple_remove(&virtio_index_ida, dev->index);
>>>>>>>>>> -out:
>>>>>>>>>> -    if (err)
>>>>>>>>>> -        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>>>>>>>> +        goto out_ida;
>>>>>>>>>> +
>>>>>>>>>> +    return 0;
>>>>>>>>>> +
>>>>>>>>>> +out_ida:
>>>>>>>>>> +    ida_simple_remove(&virtio_index_ida, dev->index);
>>>>>>>>>> +out_err:
>>>>>>>>>> +    virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>>>>>>>>           return err;
>>>>>>>>>>       }
>>>>>>>>>>       EXPORT_SYMBOL_GPL(register_virtio_device);
>>>>>>>>>> @@ -408,7 +414,9 @@ int virtio_device_restore(struct virtio_device *dev)
>>>>>>>>>>             /* We always start by resetting the device, in case a previous
>>>>>>>>>>            * driver messed it up. */
>>>>>>>>>> -    dev->config->reset(dev);
>>>>>>>>>> +    ret = dev->config->reset(dev);
>>>>>>>>>> +    if (ret)
>>>>>>>>>> +        goto err;
>>>>>>>>>>             /* Acknowledge that we've seen the device. */
>>>>>>>>>>           virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>>>>>>>> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
>>>>>>>>>> index 56128b9c46eb..12b8f048c48d 100644
>>>>>>>>>> --- a/drivers/virtio/virtio_mmio.c
>>>>>>>>>> +++ b/drivers/virtio/virtio_mmio.c
>>>>>>>>>> @@ -256,12 +256,13 @@ static void vm_set_status(struct virtio_device
>>>>>>>>>> *vdev, u8 status)
>>>>>>>>>>           writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>>>>>>>>       }
>>>>>>>>>>       -static void vm_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int vm_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>>>>>>>>>>             /* 0 status means a reset. */
>>>>>>>>>>           writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         diff --git a/drivers/virtio/virtio_pci_legacy.c
>>>>>>>>>> b/drivers/virtio/virtio_pci_legacy.c
>>>>>>>>>> index d62e9835aeec..0b5d95e3efa1 100644
>>>>>>>>>> --- a/drivers/virtio/virtio_pci_legacy.c
>>>>>>>>>> +++ b/drivers/virtio/virtio_pci_legacy.c
>>>>>>>>>> @@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device
>>>>>>>>>> *vdev, u8 status)
>>>>>>>>>>           iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>>>>>>>>       }
>>>>>>>>>>       -static void vp_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int vp_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>>>>>>           /* 0 status means a reset. */
>>>>>>>>>> @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
>>>>>>>>>>           ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>>>>>>>>           /* Flush pending VQ/configuration callbacks. */
>>>>>>>>>>           vp_synchronize_vectors(vdev);
>>>>>>>>>> +
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         static u16 vp_config_vector(struct virtio_pci_device *vp_dev,
>>>>>>>>>> u16 vector)
>>>>>>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>> index fbd4ebc00eb6..cc3412a96a17 100644
>>>>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>> @@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device
>>>>>>>>>> *vdev, u8 status)
>>>>>>>>>>           vp_modern_set_status(&vp_dev->mdev, status);
>>>>>>>>>>       }
>>>>>>>>>>       -static void vp_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int vp_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>>>>>>           struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>>>>>>>> @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
>>>>>>>>>>               msleep(1);
>>>>>>>>>>           /* Flush pending VQ/configuration callbacks. */
>>>>>>>>>>           vp_synchronize_vectors(vdev);
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         static u16 vp_config_vector(struct virtio_pci_device *vp_dev,
>>>>>>>>>> u16 vector)
>>>>>>>>>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
>>>>>>>>>> index e28acf482e0c..5fd4e627a9b0 100644
>>>>>>>>>> --- a/drivers/virtio/virtio_vdpa.c
>>>>>>>>>> +++ b/drivers/virtio/virtio_vdpa.c
>>>>>>>>>> @@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct
>>>>>>>>>> virtio_device *vdev, u8 status)
>>>>>>>>>>           return ops->set_status(vdpa, status);
>>>>>>>>>>       }
>>>>>>>>>>       -static void virtio_vdpa_reset(struct virtio_device *vdev)
>>>>>>>>>> +static int virtio_vdpa_reset(struct virtio_device *vdev)
>>>>>>>>>>       {
>>>>>>>>>>           struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>>>>>>>>>>             vdpa_reset(vdpa);
>>>>>>>>>> +
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>         static bool virtio_vdpa_notify(struct virtqueue *vq)
>>>>>>>>>> diff --git a/include/linux/virtio_config.h
>>>>>>>>>> b/include/linux/virtio_config.h
>>>>>>>>>> index 8519b3ae5d52..d2b0f1699a75 100644
>>>>>>>>>> --- a/include/linux/virtio_config.h
>>>>>>>>>> +++ b/include/linux/virtio_config.h
>>>>>>>>>> @@ -44,9 +44,10 @@ struct virtio_shm_region {
>>>>>>>>>>        *    status: the new status byte
>>>>>>>>>>        * @reset: reset the device
>>>>>>>>>>        *    vdev: the virtio device
>>>>>>>>>> - *    After this, status and feature negotiation must be done again
>>>>>>>>>> + *    Upon success, status and feature negotiation must be done again
>>>>>>>>>>        *    Device must not be reset from its vq/config callbacks, or in
>>>>>>>>>>        *    parallel with being added/removed.
>>>>>>>>>> + *    Returns 0 on success or error status.
>>>>>>>>>>        * @find_vqs: find virtqueues and instantiate them.
>>>>>>>>>>        *    vdev: the virtio_device
>>>>>>>>>>        *    nvqs: the number of virtqueues to find
>>>>>>>>>> @@ -82,7 +83,7 @@ struct virtio_config_ops {
>>>>>>>>>>           u32 (*generation)(struct virtio_device *vdev);
>>>>>>>>>>           u8 (*get_status)(struct virtio_device *vdev);
>>>>>>>>>>           void (*set_status)(struct virtio_device *vdev, u8 status);
>>>>>>>>>> -    void (*reset)(struct virtio_device *vdev);
>>>>>>>>>> +    int (*reset)(struct virtio_device *vdev);
>>>>>>>>>>           int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>>>>>>>>>>                   struct virtqueue *vqs[], vq_callback_t *callbacks[],
>>>>>>>>>>                   const char * const names[], const bool *ctx,
