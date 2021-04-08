Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1CC3583F1
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhDHM6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:58:09 -0400
Received: from mail-bn8nam11on2045.outbound.protection.outlook.com ([40.107.236.45]:39606
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229803AbhDHM6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 08:58:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUG2xDU35g21u3jedkN/TO7/ahEIn+mIgK8++vrq6BS6jbvyLUsO6Ic8jYbvUjNGwN9WCIPy5mJwomw3isbS6xoFmtatIp1uA5Xh0wSBu1mdCkl1gn10suJcfoj0mX7vZEtGe63PwCi87ZoB6zwoovsXIwiFlN6CjaBWfkQsooMGni67QD2Je2Msb1AdZ3X6i53h/lV5yvyAUV7gVSjmcbISprYgP71RWnm0VgdDkHNYztN7zwEPHvhkrPZWw8jp6dXcB8NqsNI+iZiAYalB0PspRaTgz3fGbCeKwRiYAlvl2uv6AShO30Au46DtizXxYta/wqDeyPpIBtSXkHWvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOV2mMbph69FWw1d/prMNb7sGB6JcMqgNSXEAVNYhR4=;
 b=ZqpI3d7+Uw9kWBXUIqowwv2aws6HGIDr6+SX384a3nq8Y5NdlbFi7Z1cGJ0/WMgaYSFo0mQO8UdfQJ+AofvEL8y2VbxbWlsUg92TZ5CP97L4u5BVqbUiejWStrIlM7UjQ9dLY3xUNcN+cnJgUlE3o1zI7gSQ6EShsCj374qXoUSpyIm9SwX2Vh53pzDvm2rQh5DOyOC8qziR35qKtKVa3EyGgKrMJ9vdSuCjeDwJ+Nqb3pYQntNJLVTCTeVtgQF/Xc3Bx98eE9JnCae/O/T18LWcYtzkXO6z0hCWwBzgitzoL4krmTYSNEuaO9DG3opBH6CycYGIwCX3/mJk1SWVKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOV2mMbph69FWw1d/prMNb7sGB6JcMqgNSXEAVNYhR4=;
 b=jbf509GypDkdnhcWoIu7PVCacBme7RWJn6pcIFWTx5BnvV8mFbnbokhVWFaBEjWGRcG88h876qNKIiUsvGuKDk1E66wO0SA5AzmaCrkZfGLs9pUWLIxdFgIl19BlTlWdv677t2d4nx1FrwAnLWdEZOf31QNhb2cz297mGl+4DGqtFZ6NnBytL2oCozbhwXrnsxY6DnkMH0yZmE2lYbp0zQf5Vjy89yK8zU/OqwePouw+MYFdRdBBRGbFIH5vRsZ9zEE0NYPv4lCkyvT9j1MYc2Jppn/IUFe7FNuqi5opNnDXheQWPfgBzUDst61dlWr850nq90Plv3kkE6Ngaky/Rg==
Received: from BN6PR19CA0060.namprd19.prod.outlook.com (2603:10b6:404:e3::22)
 by BN9PR12MB5321.namprd12.prod.outlook.com (2603:10b6:408:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 8 Apr
 2021 12:57:56 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::2f) by BN6PR19CA0060.outlook.office365.com
 (2603:10b6:404:e3::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 12:57:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 12:57:56 +0000
Received: from [172.27.15.189] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 12:57:53 +0000
Subject: Re: [PATCH v2 2/3] virito_pci: add timeout to reset device operation
To:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <cohuck@redhat.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <20210408081109.56537-2-mgurtovoy@nvidia.com>
 <2bead2b3-fa23-dc1e-3200-ddfa24944b75@redhat.com>
 <a00abefe-790d-8239-ac42-9f70daa7a25c@nvidia.com>
 <93221213-8fc3-96ef-7e89-b7c03bea5322@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <7ed9cafa-498e-156d-c667-6da3fa432b18@nvidia.com>
Date:   Thu, 8 Apr 2021 15:57:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <93221213-8fc3-96ef-7e89-b7c03bea5322@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e48e9b6-2c14-4140-b20c-08d8fa8dee38
X-MS-TrafficTypeDiagnostic: BN9PR12MB5321:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53218C7634605D73A0E8FEAADE749@BN9PR12MB5321.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMYnNUOK1NxLA95Yf+QWsEy9ghTGbrMpsBP28+fkMdgkcHiy2jC+zio7O169/8/qhoLSzO+AMJgAkPci4vC5Xx2HhK0mwyCeN7UK84Vvd7082SeJx9G8wsS3SzYLdJk6jL9uvoolP/a5n0HrSXE/wtGck2mvh8YmJ5o69rp+4CB/9JAaSsjKXTVe1/ZW/LtaJBGPSPipt34EJUW1V3fMpgXK3UFDkCbe5WTSJO4wjiUPwvblMZe+yb6pCQXoydsCpKnADM9CRTVpaYqM1oUqqI275H2yCWVOf2XzzfS+ae36wZnFQCTIvvaj08CxNQe5or7X+VQgbuhLnsuSfkamMfFSg4O01g9a0Eb6PkjrXmfDnJ4LHqQ0FjkXTRu7gE2wtI03SLpscRu7CUNMho5sI34uWb6jl70SD4UNrj/UhIBw3txhuLTMhNA/EMcFWTkxrVYJJ/kSLeQQO0oMWE7RO/VplmH2//BFfJZX7UTA8UxIakZ/kBPtVICQ7ezvfrflaroADJIdy1eLDpc7E09h9EeiaAlJTg+HmobMCO9h6DPZOaZWNk4O9OLtXvndmYYQM7576XAhl48X630FexuJa0Zv8ZPQmn2IhpjCa7nrhFg2GbvQ4Kjhdvuw9hZ+XO/arfU3Aghxe25wQ6ZJQSAqt0tMt4rv+GonJZ7VKPrYOWxe+xpMrErToAiVZyh91YA6
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(7636003)(336012)(36860700001)(36906005)(31686004)(82310400003)(16526019)(426003)(53546011)(316002)(5660300002)(2906002)(36756003)(2616005)(47076005)(4326008)(8676002)(31696002)(70586007)(83380400001)(356005)(70206006)(478600001)(86362001)(186003)(54906003)(16576012)(26005)(8936002)(82740400003)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 12:57:56.5082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e48e9b6-2c14-4140-b20c-08d8fa8dee38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5321
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/2021 3:45 PM, Jason Wang wrote:
>
> 在 2021/4/8 下午5:44, Max Gurtovoy 写道:
>>
>> On 4/8/2021 12:01 PM, Jason Wang wrote:
>>>
>>> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>>>> According to the spec after writing 0 to device_status, the driver 
>>>> MUST
>>>> wait for a read of device_status to return 0 before reinitializing the
>>>> device. In case we have a device that won't return 0, the reset
>>>> operation will loop forever and cause the host/vm to stuck. Set 
>>>> timeout
>>>> for 3 minutes before giving up on the device.
>>>>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>   drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
>>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/virtio/virtio_pci_modern.c 
>>>> b/drivers/virtio/virtio_pci_modern.c
>>>> index cc3412a96a17..dcee616e8d21 100644
>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>> @@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
>>>>   {
>>>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>> +    unsigned long timeout = jiffies + msecs_to_jiffies(180000);
>>>>         /* 0 status means a reset. */
>>>>       vp_modern_set_status(mdev, 0);
>>>> @@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
>>>>        * device_status to return 0 before reinitializing the device.
>>>>        * This will flush out the status write, and flush in device 
>>>> writes,
>>>>        * including MSI-X interrupts, if any.
>>>> +     * Set a timeout before giving up on the device.
>>>>        */
>>>> -    while (vp_modern_get_status(mdev))
>>>> +    while (vp_modern_get_status(mdev)) {
>>>> +        if (time_after(jiffies, timeout)) {
>>>
>>>
>>> What happens if the device finish the rest after the timeout?
>>
>>
>> The driver will set VIRTIO_CONFIG_S_FAILED and one can re-probe it 
>> later on (e.g by re-scanning the pci bus).
>
>
> Ok, so do we need the flush through vp_synchronize_vectors() here?

If the device didn't write 0 to status I guess we don't need that.

The device shouldn't raise any interrupt before negotiation finish 
successfully.

MST, is that correct ?

>
> Thanks
>
>
>>
>>
>>>
>>> Thanks
>>>
>>>
>>>> + dev_err(&vdev->dev, "virtio: device not ready. "
>>>> +                "Aborting. Try again later\n");
>>>> +            return -EAGAIN;
>>>> +        }
>>>>           msleep(1);
>>>> +    }
>>>>       /* Flush pending VQ/configuration callbacks. */
>>>>       vp_synchronize_vectors(vdev);
>>>>       return 0;
>>>
>>
>
