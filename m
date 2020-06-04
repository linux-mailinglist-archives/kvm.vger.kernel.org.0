Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3DB1EEA5F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgFDSiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:38:02 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:26243
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbgFDSiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 14:38:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CimcsL8SYJzFIRLpKcFG6o0c+48M2oDV4INZJujYYfZ6E3IzaSWHMAytlpNfXJKzpWEpJZ09/4d6TFdFV4hI4XptfHpBqwwcJSy1pMjnI95NdJcr365JIlnDYlwJPmsNiluqvEGPOFVgUU8OdsHdLfAN5PRgw7KgzKbDhgeJHVDjz1tSRfZe+qGjGGu5uAJxioWF0yvwszYbY9lihRnYTFfDwRMMAJ/rCt/v2LjzlwUhXh4x2z9bY6Qf9okqxum6Ru5GRz15Ydz5zLlIDGLNMucVYeZ5sd8NdF2mXh/UVZxHJgvVhLNtz3IeROvypv0TvzLdks8tyM3yo1bLAPIwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvDYH/+M92ywXQXWmQCueCz2RHJfwc5cEsL97HtzUPs=;
 b=OurfhXQfzISzsTwTExcOFuQcqAK9c8K4X8+Nl6iZ0gfVols3zGcV/Bxeh+hqPbxrKFIghvJMiqG+C7fV+sQMgIRbOlRIH8II8IIVJKfIulp2ZKgMdVAyKG7uA9KNN0mF5E4dhXATnkghSgm/WMBbtbCXIfY1r185TOiR36BDvnzUh+nANwtLwdO3Gnd8JtKHP77IWtk5ECQT3h2eVTkRMuw1kfnlFvmD6OovHtK96+lAImiMfCgS5IMcJebm3Eh99TgVWk1tr/YwIdMfjrHkdBrqSjkKep4rwBMUeApQA0d67PLyk1vRZqvbrC+gdcfgr4NvnyHiCo0fvLrIWlQQpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvDYH/+M92ywXQXWmQCueCz2RHJfwc5cEsL97HtzUPs=;
 b=NHIgPEGk9MTSDrk5skhF5yj8xRYMU4ev0A5O12ggHeIhLp0/dD3MLu2P0HY+6QAZCplDZujWkUlLcAswpZjJSSCHNEijhO4uZHfU1PRZl61oVieBBI3L1qw50vfAddSHM97rUjy2mxGymWsgpt5ezcu6fG+FUeWRUWMgu88yTbQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from HE1PR0402MB2809.eurprd04.prod.outlook.com (2603:10a6:3:da::17)
 by HE1PR0402MB3580.eurprd04.prod.outlook.com (2603:10a6:7:87::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 18:37:55 +0000
Received: from HE1PR0402MB2809.eurprd04.prod.outlook.com
 ([fe80::c8b6:bdba:be68:289f]) by HE1PR0402MB2809.eurprd04.prod.outlook.com
 ([fe80::c8b6:bdba:be68:289f%8]) with mapi id 15.20.3045.024; Thu, 4 Jun 2020
 18:37:55 +0000
Subject: Re: [PATCH v2 4/9] vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO
 ioctl call
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com, bharatb.linux@gmail.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
 <20200508072039.18146-5-diana.craciun@oss.nxp.com>
 <20200601221231.7527f50b@x1.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <01c6c331-7ac3-f1b9-0b5a-98cee7ef7cc8@oss.nxp.com>
Date:   Thu, 4 Jun 2020 21:37:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200601221231.7527f50b@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0102.eurprd02.prod.outlook.com
 (2603:10a6:208:154::43) To HE1PR0402MB2809.eurprd04.prod.outlook.com
 (2603:10a6:3:da::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.25.133.230) by AM0PR02CA0102.eurprd02.prod.outlook.com (2603:10a6:208:154::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Thu, 4 Jun 2020 18:37:54 +0000
X-Originating-IP: [188.25.133.230]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef61c442-ad26-47db-2559-08d808b66572
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3580:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3580BB5F6E1119196BFD7506BE890@HE1PR0402MB3580.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgp3e/egFPW0rNqyQm2fUNmcJ3s/YOP2yq60d/mECyp6woOb+O2vHLHOha56BkOlRez8lx14apO9Zp8nIf2UL5jhlRbBNQMbrEVn2kVokVc+Lb7+Izbs+9G6H4PLsyOu0hMbBCe280Xj1he+8tODFNXuYth5sakCAotC8wbG9+AWChqz/euSBwRac0kFwrKATMvBqSne3QcVu4ACPmoZyMU6JtSxbb4I3/B745BpKDFU++FyUQ7dnTYqFiRJ91Px4ecdHIroLzPQNo+/x/enidxnFtPfsrkIYTV5qUnpPcQS3XNwqzVzVXOfb0b3EeoRHkCCOEDvxnO3FMs/eUAxIKA0OTBGf1rXfYl8fBfxBrRR54TCtvUa+3lEBO+UXy1a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2809.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(31696002)(316002)(31686004)(6916009)(16576012)(956004)(26005)(6666004)(5660300002)(52116002)(86362001)(8936002)(2616005)(8676002)(53546011)(2906002)(66946007)(4326008)(478600001)(186003)(16526019)(83380400001)(66556008)(6486002)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2ftjDA/E20cPagdZhP9XlqHi3b4mMI5vvnp0OEwl8ogNzLTNkqB0HvPscWUWxBgPUVTjYxowA7rPrkDHEjTlnREh7RF/p4/j/L1pRprVUd1iIg5SN0UsjCxrxNeTHsLqJTApMHuL0oELQJTDbN1xpeUTBm+HOpKLwIe7DliEkkneoXDKL6JZRuQgDJ/sZtQfJ2Rjmk8d/tfRuyoWJUNnisEEmqxRp8pGm/aLr1thU0PomjzPIPQGIOv9u0x9bKH5Q86Z4SasVk1U3EfFdCWupolXb3UY5bcooW9huMKownwa7OcmG1MEj0z3he55TKIwVllzmnQBfntVK+dygrfT4oBG0ln1DhLrgq8xdovbODcKSXsgvMBNyAzFIw5rIwWmt3WbXMf0OGPXpehhMb4cTja/DM+5oqcXHicAvssxCG/xPOZDsllCpVT8hN/ZK3xwSaMziGUdAO1INIXcRGi4e7rabeZ/WUOP21ZOiZj1CPuSgwGIJFIMazN7XSkb25Yz
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef61c442-ad26-47db-2559-08d808b66572
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 18:37:55.7402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFZ5luPvTsqABDt8cZYl4cyiMXEL68aZz45MuOdq6aquX1zxpnwO47Zt3u//xrpmXIuv8vM3xw72+85HXEbVaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3580
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2020 7:12 AM, Alex Williamson wrote:
> On Fri,  8 May 2020 10:20:34 +0300
> Diana Craciun <diana.craciun@oss.nxp.com> wrote:
>
>> Expose to userspace information about the memory regions.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 77 ++++++++++++++++++++++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h | 19 ++++++
>>   2 files changed, 95 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 8a4d3203b176..c162fa27c02c 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -17,16 +17,72 @@
>>   
>>   static struct fsl_mc_driver vfio_fsl_mc_driver;
>>   
>> +static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int count = mc_dev->obj_desc.region_count;
>> +	int i;
>> +
>> +	vdev->regions = kcalloc(count, sizeof(struct vfio_fsl_mc_region),
>> +				GFP_KERNEL);
>> +	if (!vdev->regions)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < count; i++) {
>> +		struct resource *res = &mc_dev->regions[i];
>> +
>> +		vdev->regions[i].addr = res->start;
>> +		vdev->regions[i].size = PAGE_ALIGN((resource_size(res)));
>
> Why do we need this page alignment to resource_size()?  It makes me
> worry that we're actually giving the user access to an extended size
> that might overlap another device or to MMIO that's not backed by any
> device and might trigger a fault when accessed.  In vfio-pci we make
> some effort to reserve resources when we want to allow mmap of sub-page
> ranges.  Thanks,

OK, I will look into this. Theoretically it should work without the need 
of alignment but currently I see an issue that I am investigating.
Anyway the access is safe, the actual size of the device MMIO is page 
aligned (aligned to 64K), just that part of it is reserved and the 
firmware reports the the size that is actually used.

Thanks,
Diana

>
> Alex
>
>
>> +		vdev->regions[i].flags = 0;
>> +	}
>> +
>> +	vdev->num_regions = mc_dev->obj_desc.region_count;
>> +	return 0;
>> +}
>> +
>> +static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	vdev->num_regions = 0;
>> +	kfree(vdev->regions);
>> +}
>> +
>>   static int vfio_fsl_mc_open(void *device_data)
>>   {
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +	int ret;
>> +
>>   	if (!try_module_get(THIS_MODULE))
>>   		return -ENODEV;
>>   
>> +	mutex_lock(&vdev->driver_lock);
>> +	if (!vdev->refcnt) {
>> +		ret = vfio_fsl_mc_regions_init(vdev);
>> +		if (ret)
>> +			goto err_reg_init;
>> +	}
>> +	vdev->refcnt++;
>> +
>> +	mutex_unlock(&vdev->driver_lock);
>> +
>>   	return 0;
>> +
>> +err_reg_init:
>> +	mutex_unlock(&vdev->driver_lock);
>> +	module_put(THIS_MODULE);
>> +	return ret;
>>   }
>>   
>>   static void vfio_fsl_mc_release(void *device_data)
>>   {
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +
>> +	mutex_lock(&vdev->driver_lock);
>> +
>> +	if (!(--vdev->refcnt))
>> +		vfio_fsl_mc_regions_cleanup(vdev);
>> +
>> +	mutex_unlock(&vdev->driver_lock);
>> +
>>   	module_put(THIS_MODULE);
>>   }
>>   
>> @@ -59,7 +115,25 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   	}
>>   	case VFIO_DEVICE_GET_REGION_INFO:
>>   	{
>> -		return -ENOTTY;
>> +		struct vfio_region_info info;
>> +
>> +		minsz = offsetofend(struct vfio_region_info, offset);
>> +
>> +		if (copy_from_user(&info, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (info.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (info.index >= vdev->num_regions)
>> +			return -EINVAL;
>> +
>> +		/* map offset to the physical address  */
>> +		info.offset = VFIO_FSL_MC_INDEX_TO_OFFSET(info.index);
>> +		info.size = vdev->regions[info.index].size;
>> +		info.flags = vdev->regions[info.index].flags;
>> +
>> +		return copy_to_user((void __user *)arg, &info, minsz);
>>   	}
>>   	case VFIO_DEVICE_GET_IRQ_INFO:
>>   	{
>> @@ -201,6 +275,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>   		vfio_iommu_group_put(group, dev);
>>   		return ret;
>>   	}
>> +	mutex_init(&vdev->driver_lock);
>>   
>>   	return ret;
>>   }
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index 37d61eaa58c8..818dfd3df4db 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -7,9 +7,28 @@
>>   #ifndef VFIO_FSL_MC_PRIVATE_H
>>   #define VFIO_FSL_MC_PRIVATE_H
>>   
>> +#define VFIO_FSL_MC_OFFSET_SHIFT    40
>> +#define VFIO_FSL_MC_OFFSET_MASK (((u64)(1) << VFIO_FSL_MC_OFFSET_SHIFT) - 1)
>> +
>> +#define VFIO_FSL_MC_OFFSET_TO_INDEX(off) ((off) >> VFIO_FSL_MC_OFFSET_SHIFT)
>> +
>> +#define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
>> +	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
>> +
>> +struct vfio_fsl_mc_region {
>> +	u32			flags;
>> +	u32			type;
>> +	u64			addr;
>> +	resource_size_t		size;
>> +};
>> +
>>   struct vfio_fsl_mc_device {
>>   	struct fsl_mc_device		*mc_dev;
>>   	struct notifier_block        nb;
>> +	int				refcnt;
>> +	u32				num_regions;
>> +	struct vfio_fsl_mc_region	*regions;
>> +	struct mutex driver_lock;
>>   };
>>   
>>   #endif /* VFIO_FSL_MC_PRIVATE_H */

