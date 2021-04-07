Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E9B356E22
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352768AbhDGOGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:06:40 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:28209
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234067AbhDGOGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:06:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g11fWSjSY39BNc85r33bEjKuOKgwffpphybMhBkFpxprdqzBhhA7Z4OGTFSejL3fUn5LsAKm0XFC7rnieubepfqbP0HCLb1NbjhJMGPisn2UNCGCldVh2aTn+kI6/ka2GE8xDTwRCCqhKW5ul1RksflGAf6E2OQSuZn11SBCrUg6g1FHRcK5ATKQ0GwHuSrSC9VaUDT9WU6A4bn8plie+PRo/BnzEjElAFyoGqCHWDQDCAx9M87g+Jd0nIGk5O1ApOBtxl0nl27GyKIG5XYNWqfbLU6yFJU+98We6LRGIj5HApAaXXmaIJgpoXMYVYFM/uhwNpK4ac/kEM8sR7tfNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+0UMWfLyXXGrCmtJ8R3dhfLnBOs5OMPnyd/1zzbdF4=;
 b=Gtc9j+T1zxSb/WNf5/nvEINi8MYLSK9L9v8wJEx22IJky7IOJsi9nk4FbnDXc7HkHvtcvAiHhBepJXUM2BV0vsJBajxCM62R2rPOSUG/x7MLAgcm78klhjvc9zobkXxElBNPAGIETS/WBy+O0A8Dngh+z6FYafLevd4rW65PE1p5AH6JfCmcFMjw4m+1cJyE0chXIyvnq3JXbinp5V0AW4itmEjmG3EzGw3qKUO+g3xDHNqIQeZSJlh4wYJbomXWPiQOd4dVcjKKdybCqzf4+MCFdpoc1GDaQRlssmkOevsgrI/r8ov9yvlwhTGZkWDT+Yn53avGq59GxsTRyoaPtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+0UMWfLyXXGrCmtJ8R3dhfLnBOs5OMPnyd/1zzbdF4=;
 b=HMCUJDQw55Bub39FWUS9oiHkhRYnzBoFPCVHqNQIEInMyZLoIuTYZBcRvY2fjTsNu52pQjui9CMxRWKeeAltAUO6mRnCYHEmG6E/H3ni1Kp6U5Sonu74yCCjA65LcpKilobANe3hP5wEsE3QV9dl080eyXuzbHFMxlxPLkPJC067IjnHvqUxCNK42+pVHh0xH3uIYa8/nvLaAXA+hH4w41k3mqcBw4sS/E66iKyUbZJxlBsY0xJSwHXFhcACjDaVAiVFwPCC+QlvefmcT/pS/WO9lRyS0u4ncTjxYZc6k/V6mqG8lbUruaNt8Ijxw9aywusqymsEOdQ+vch/684v8g==
Received: from MWHPR15CA0052.namprd15.prod.outlook.com (2603:10b6:301:4c::14)
 by CY4PR12MB1128.namprd12.prod.outlook.com (2603:10b6:903:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Wed, 7 Apr
 2021 14:06:28 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::86) by MWHPR15CA0052.outlook.office365.com
 (2603:10b6:301:4c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 14:06:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 14:06:28 +0000
Received: from [172.27.11.15] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 14:06:25 +0000
Subject: Re: [PATCH 2/3] virito_pci: add timeout to reset device operation
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <jasowang@redhat.com>, <oren@nvidia.com>, <nitzanc@nvidia.com>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
 <20210407120924.133294-2-mgurtovoy@nvidia.com>
 <20210407094228-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <02cc0471-af5f-8cae-51a5-855bbe90021b@nvidia.com>
Date:   Wed, 7 Apr 2021 17:06:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407094228-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39e66907-1659-4ad5-8911-08d8f9ce5668
X-MS-TrafficTypeDiagnostic: CY4PR12MB1128:
X-Microsoft-Antispam-PRVS: <CY4PR12MB112858E2561BA7EE4B0FF032DE759@CY4PR12MB1128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FS+fqACLpW15pqX4vcVZgi3UBFmbr9o1BfCtv6SG240JV1Pli7Kj5WOWY/+4Mptqbh7vwqZu5XXFhiD7Sq1JAssFPJwtTcVuytTGKT+SxP7yngZP95Q1dYOGSH2L6cI0Tu3KX1BdQtaVfqPvSP/iOpWKt1k14cO29ESJvtknjCPYzjs/mAJQIr7BieS2xRklkXgZ+Ivo6yjBe5hmCArht1sP+rSmxUIXJqvFyh9epBKzNOAW6AKVouxf5Wl02WwpEfYXDLfaMnLyZM1xBtR4lSXFs9VkI4mltbmAnwFb/Ir1s4+NopZShu3nR4uMWQOa2BE5ls88ypowIt4S5Rw+wBNF4/jJkaBilOxn40r4NVrewoOdb8L7dDgBSl/vmX7eb6fRtDHrKiXii8oYGHw3uXEl4RFahu4y5YxLClcjm5pmvAUn/fi+P3q/YrK+jGLG/XEQbbcJP6AxmWqBAVNzDkQ9MpxY+YMKovTal5bT1Di3Jya6m4eo7Ot4rfnpPYrrXK5p41Sw+LBiKJLmdCYjVhkVUpLGW2NTC2cU4wkI0mu2xr8fN0oG6ovgNGiJXEa13nPyjuiIar4NkEJaMMPC0/GPKEQiiJu7o8Y26gVuiucbWW2LxUxl1InqlG5jR0jdWACrY5q6QSw8AaPay+zAi8p4nqPCricxHcx9dh5EzmCBovMuif8bds8uOvNelesH
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(478600001)(7636003)(6666004)(4326008)(82310400003)(8676002)(82740400003)(31696002)(47076005)(36860700001)(36906005)(6916009)(31686004)(107886003)(70586007)(16526019)(5660300002)(83380400001)(356005)(54906003)(53546011)(36756003)(70206006)(426003)(316002)(336012)(2906002)(16576012)(26005)(8936002)(2616005)(86362001)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 14:06:28.0136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e66907-1659-4ad5-8911-08d8f9ce5668
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/2021 4:45 PM, Michael S. Tsirkin wrote:
> On Wed, Apr 07, 2021 at 12:09:23PM +0000, Max Gurtovoy wrote:
>> According to the spec after writing 0 to device_status, the driver MUST
>> wait for a read of device_status to return 0 before reinitializing the
>> device. In case we have a device that won't return 0, the reset
>> operation will loop forever and cause the host/vm to stuck. Set timeout
>> for 3 minutes before giving up on the device.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>> index cc3412a96a17..dcee616e8d21 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
>>   {
>>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>   	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>> +	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
>>   
>>   	/* 0 status means a reset. */
>>   	vp_modern_set_status(mdev, 0);
>> @@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
>>   	 * device_status to return 0 before reinitializing the device.
>>   	 * This will flush out the status write, and flush in device writes,
>>   	 * including MSI-X interrupts, if any.
>> +	 * Set a timeout before giving up on the device.
>>   	 */
>> -	while (vp_modern_get_status(mdev))
>> +	while (vp_modern_get_status(mdev)) {
>> +		if (time_after(jiffies, timeout)) {
>> +			dev_err(&vdev->dev, "virtio: device not ready. "
>> +				"Aborting. Try again later\n");
>> +			return -EAGAIN;
>> +		}
>>   		msleep(1);
>> +	}
>>   	/* Flush pending VQ/configuration callbacks. */
>>   	vp_synchronize_vectors(vdev);
>>   	return 0;
> Problem is everyone just ignores the return code from reset.
> Timing out like that has a chance to cause a lot of trouble
> if the device remains active - we need to make reset robust.

But in commit 1/3 I added a code that doesn't ignore the reset return code.


>
> What exactly is going on with the device that
> get status never returns 0? E.g. maybe it's in a state
> where it's returning all 1's because it's wedged permanently -
> using that would be better...

In HW devices you might have situations that the controller is in bad 
state (maybe bad FW) but still can be seen under the PCI bus.

As long as the device is not returning 0, this is legal. But in today's 
code, it will cause the kernel to be in endless while loop because of 
one bad device (that might recover later).

If we have 10 devices, and the first will stuck, all the others will 
wait forever to be probed.

By Virtio spec, setting FAILED is allowed in case "..driver didn’t like 
the device for some reason, or even a fatal error during device operation."

For example, in the NVMe spec there is TO (timeout) register that "is 
the worst case time that host software shall wait for CSTS.RDY to 
transition from: ..." and the driver wait for this time until it 
understands that the device is not ready to operate.

I tried to add similar logic to virtio.

>
>
>
>> -- 
>> 2.25.4
