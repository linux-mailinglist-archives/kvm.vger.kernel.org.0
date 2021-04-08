Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8B357F9D
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 11:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhDHJpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 05:45:18 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:29553
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231372AbhDHJpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 05:45:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7FcHlaqjaBD9mUNKHQINfWg+1jvLY4FVSuA4G9vkobhJ4AY7MSIiwVb1/NHk2qKA0ENsVIVW8loWlDgGitu5mPFuqrFe6k5k72WAFiw+gwAJjEV5uBk+WoGj6XUSyg/1Ti5Vhd+v8JqAbr2CA0yK/evlQ3S0cirSU88YHuQaoLa+xvPcnfJbvLTr+viZ6gtB0yBCXizQOD+U3ysK4OSV37fZcYDCCTRoKi5KkUZ8wysYBiXtdVwqeFR463Lz2apy1olfKkJlKW/ONqx3/9E/VsIg0EZS2ku9L7POFn3Rnwa08V58iE4WEYgI+3jVPCsudQ3lzCwuRcSMoEJWjCfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ2pllR6rB0K3wZJRMBfAYMEjtADUynL8dSoi6xwv7I=;
 b=OLDLjNY2F39SGAZRVwvkFuZB9v01xLXlWhEb22tLMgjEhGwRY+T8w3kNncvNFqIJOAmNoKMOGBD2pgA89gA8vc+F8+sQ0lDaexZrffHjEUAomPdzSEghSgJaDSfuTIza7JGtKKVG+RHFnXLxV4kPrjkpzaaMI7R2m+E6eD0Y/Lslp8I3WThLiqrsUJKZ3+Db4bZBylTAHs3DoAZqpby+YtLQ7WyDHxOcgoxvn5qFoePB66a72NtZM+TeDHYy4HY6BwU/hG64KXHH4VMXpzN9hFcx7k/AtFSzs5xxAbs3gybvrOC7EJCqOc1gmvWnG0UfizedCxBMRAWEGVf5jlVZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ2pllR6rB0K3wZJRMBfAYMEjtADUynL8dSoi6xwv7I=;
 b=WGR8Virmh6yJcS9HTTigxf+Hwl6d8aQ5rzvecYcn03knPDL/ftz8ib8RVRJHm8sTzM9uRca6gbP2AgiXPjevnPoehbiEUjruUUTM2d5vLlDH8NKw/Nx2R5pFtcDiY7CMUh3Mtf9d3LStfJ6NW1oRkjwUXzGgIw/Klr1xWI0cKjHlgbTW/Lcc5lANNqS3vNhbtwXlHiGi8fHQ7vDi97qBHkggVJZyBaLzaFUjIl8v06cXWzeG5slpi5wqkmnV5awnUn87GVuTg2AqUBHAogKLDukFMCvO5lrsv1ERH+LFCFrgVVh9wmS+uxPrR14USwKCtkAntaqJ39kyLx7rRV4ycQ==
Received: from DM5PR07CA0168.namprd07.prod.outlook.com (2603:10b6:3:ee::34) by
 BYAPR12MB2758.namprd12.prod.outlook.com (2603:10b6:a03:6f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Thu, 8 Apr 2021 09:45:01 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ee:cafe::10) by DM5PR07CA0168.outlook.office365.com
 (2603:10b6:3:ee::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Thu, 8 Apr 2021 09:45:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:45:01 +0000
Received: from [172.27.15.189] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:44:59 +0000
Subject: Re: [PATCH v2 2/3] virito_pci: add timeout to reset device operation
To:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <cohuck@redhat.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <20210408081109.56537-2-mgurtovoy@nvidia.com>
 <2bead2b3-fa23-dc1e-3200-ddfa24944b75@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <a00abefe-790d-8239-ac42-9f70daa7a25c@nvidia.com>
Date:   Thu, 8 Apr 2021 12:44:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <2bead2b3-fa23-dc1e-3200-ddfa24944b75@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd29f2ad-fe3d-4068-5172-08d8fa72faf7
X-MS-TrafficTypeDiagnostic: BYAPR12MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR12MB275881F4C6A1EB56BDCC1ED2DE749@BYAPR12MB2758.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTU/cZBr3miXiEls93ApWLUzsgtSf9K5/G7cotoBSQD6rndd72tj4NFf9+td6IkswZVsBoAKtWNNXUkm37Pt0Q+jhZUi3Wz9UONAfCmcr0nOY294NIyEubufOqjFnnUawvqUJK3qYKCrCo5qnss+LD9U+2OWFnFnqfRlkF4UNWtS/WXXp5DCdQBmicG+pwWj1CbLBUp9UapSdxrgm17xIvi9xVryZ8abWoS8NT8fkdCBl9ieBtIfQfUihyvtxDrj2LaEw5zFuHfn7XOVBVrW/jhZ8KKx/tEqhRuYVZdCMXPrrhg5DpDfwIhQ3/4h5+SoBYMn5DPjPdqyAA9R0I5uLwwe0lj3BzZNG6v//zvlA0GbN4iV20JnGaTnDVH1L81ZD6M/g6aRmePXXe+TzW2khFRiFhuUcvszAmVmVyg/81JaivG3AKWycwNXqSdPAy2w2vImOvGj+ld3R+IoO+1Y5CMN8T7W/U2otAIyWR8YS8tir6tBTucDtYTjjcTry7SwUnnjp8bEouSCGQs/hGc/pH1L32pzr0brM7YJro9kBEXiY6Xb2exLJGqP8hQhO7luSMMNDrGZqS+nXKMXbrI1AMqfNm9kUhvZeIiDEojkYpHHFllRQISiKhwj87MZH3pRpYBalfUHk7JKAJ3SI5LKIjQbMbIox1SxjVfY5lKZxQCQcntWrUS/lwxJ3jUoJ4TW
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(83380400001)(82740400003)(5660300002)(356005)(6666004)(426003)(36860700001)(16526019)(26005)(7636003)(36756003)(316002)(2906002)(54906003)(16576012)(36906005)(82310400003)(186003)(53546011)(2616005)(70586007)(110136005)(70206006)(8936002)(31686004)(4326008)(336012)(8676002)(478600001)(86362001)(31696002)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:45:01.5533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd29f2ad-fe3d-4068-5172-08d8fa72faf7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2758
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/2021 12:01 PM, Jason Wang wrote:
>
> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>> According to the spec after writing 0 to device_status, the driver MUST
>> wait for a read of device_status to return 0 before reinitializing the
>> device. In case we have a device that won't return 0, the reset
>> operation will loop forever and cause the host/vm to stuck. Set timeout
>> for 3 minutes before giving up on the device.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/virtio/virtio_pci_modern.c 
>> b/drivers/virtio/virtio_pci_modern.c
>> index cc3412a96a17..dcee616e8d21 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
>>   {
>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>> +    unsigned long timeout = jiffies + msecs_to_jiffies(180000);
>>         /* 0 status means a reset. */
>>       vp_modern_set_status(mdev, 0);
>> @@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
>>        * device_status to return 0 before reinitializing the device.
>>        * This will flush out the status write, and flush in device 
>> writes,
>>        * including MSI-X interrupts, if any.
>> +     * Set a timeout before giving up on the device.
>>        */
>> -    while (vp_modern_get_status(mdev))
>> +    while (vp_modern_get_status(mdev)) {
>> +        if (time_after(jiffies, timeout)) {
>
>
> What happens if the device finish the rest after the timeout?


The driver will set VIRTIO_CONFIG_S_FAILED and one can re-probe it later 
on (e.g by re-scanning the pci bus).


>
> Thanks
>
>
>> +            dev_err(&vdev->dev, "virtio: device not ready. "
>> +                "Aborting. Try again later\n");
>> +            return -EAGAIN;
>> +        }
>>           msleep(1);
>> +    }
>>       /* Flush pending VQ/configuration callbacks. */
>>       vp_synchronize_vectors(vdev);
>>       return 0;
>
