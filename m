Return-Path: <kvm+bounces-6309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D4982E92D
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48F391F23756
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 05:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350AA883D;
	Tue, 16 Jan 2024 05:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eWWlhb/v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6DA848D;
	Tue, 16 Jan 2024 05:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I51up3kNdary+u1O18YUDT1lp8+4gVfloXN2wo3h88MlFV6x9GlA9QZmcuCRuowNwvzceM0+YT9Pu649x5xZf9g6H/g4Gf51BaC5a2ENslG7NYHcb+tInAmIHPGFOMmyzBKr9ckIIARw4XuFqmCzPoMiKRje0zFPDImxsKvG+ICjz4qmNYzcg1y58EEAwNr7uD0ubzo5uUgcok4JcWqp432oY21aGnHdIQOv3VJtNJLBUrCNyRHB53d8W+5ywH5LJIPaAwtUmLgrVJyELTzP1AZWWgzF/8jCReKVDQeSiGaXI43iT7Wn/AWKiVwVlAAJC8h8BW1hiu1eRKif5tiRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ooqg87qzWaoQ/LeFa2HQ1pgek4zO8RZ/havdmfYR4Q=;
 b=ZpbbovhQDzVLii9wfx7oNV43yfDQKppL/OGBryztitv9aa4gXI6AemB2h9XOubRnt/cE0yKpYfWVtVlp1nrVBrmAJw89BTWz5+Bie0v7nd5GgkoCjTDFeEhfrO38JEY7YIctitvlT478ILhEqzZ4qzjzrbNmC+uCtVyqzbxm37dZr9vUscazvttKijRtl+78jaid0yXMK6KKDu/uB7IweyeeXH2lKLw6fYxnFCm8w/hBzHbEHrVJrxxId++3V2x2hr70wH2+cVQSi3orBV7Xv92O1ePh63HJC7P5mzxOHIRznNDwIDqb5mUX8sJG2Cl3+fD61Gbet0VJLzBzKYDbcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ooqg87qzWaoQ/LeFa2HQ1pgek4zO8RZ/havdmfYR4Q=;
 b=eWWlhb/vuKxv5fbECVR/x1SQ+yFX439Gs8yJj3jkAH6ckKsWyyrxaerMgSrqI/n/CF+mgDYo2aeNsuWBP/F/kyHYXRgD6dEYCmXip+HNF5PlA1p2nlki+/xBJeJtSsWlb8LqeaP3hQGh0HIQD+5tbejy9HPz8Gfq6wKePbL60M7HTBJDVbnAAoA04bAoxVunSlYoXzZQ1FTsUuqTsEK149LidIzHMAnzJ0wL3YfnZpilgokTEgDiiCFsCPycwvjiF4Kovzz1Cw8GBV8qHnuuDH8eBd4gjS+xRxXlX7WTiu5Jc0lu2VYdZAvNg4zC13pN//41gOnJUUtEGnhi0nCyVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH7PR12MB8054.namprd12.prod.outlook.com (2603:10b6:510:27f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.29; Tue, 16 Jan
 2024 05:24:26 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ab86:edf7:348:d117]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ab86:edf7:348:d117%3]) with mapi id 15.20.7181.020; Tue, 16 Jan 2024
 05:24:26 +0000
References: <20240115211516.635852-1-ankita@nvidia.com>
 <20240115211516.635852-3-ankita@nvidia.com>
User-agent: mu4e 1.10.8; emacs 28.2
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, alex.williamson@redhat.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 eric.auger@redhat.com, brett.creeley@amd.com, horms@kernel.org,
 aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
 anuaggarwal@nvidia.com, mochs@nvidia.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to
 determine range overlap
Date: Mon, 15 Jan 2024 21:19:33 -0800
In-reply-to: <20240115211516.635852-3-ankita@nvidia.com>
Message-ID: <871qahzw8m.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0016.namprd21.prod.outlook.com
 (2603:10b6:a03:114::26) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH7PR12MB8054:EE_
X-MS-Office365-Filtering-Correlation-Id: ac5933cd-492c-40b8-0750-08dc165367f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vWoL96bJNHy2DiEv5/sYhjEdy1tPWTa74CgbmS9JOQTe/y94ObYTRllfwi1L3z1/PHIZAu+yg1EIG8KhXeTPbsZrk0Bcgm9thvSRRpXq7n6DAIhOi0iYYjqqv3N/cbkuJ49QbJk7fSjWrXzLhq5h2UNutKeB+8M81rC9GotNd+ITfMdVowUtMSXj9x0i+bnc1x04yrcFASuYWtGiQs6vJEoWxQ5VFPYLY6fQmE9jNYycvlSLkpV9naKkqkOH8P/J+fO4uWiCSMI2yWFz6lzPuEQ6A+KLtwACslbEqS6tGJuDXd7QgzDf15VKTX1GRd97Tjn+p6i/dZ9vLxHCgtDlKgFOhnCm7JClcpZppfRUG9scQWPmDRCFHTSf8FLYvpL8+EotFiEBdnCwMtJeSl1sJzF6lq1R5Rt+mXFhPqBKv860yPcL+SOMRPVu2M+9U8ikzI1+XgXJRMw1foIIUJc2f52jah/TeDPDtBb5Mh22rbt6KLOAp28P7DgwtBICTqPpVUoU7a/hSIPAj013DVZcCgDoZ3d4jNa6P7bUceFq/dOlfM+FkYjnT2VXn5DL2/JOoEbM2FgyPROFtWLdbpfvUO++qr8HuhKub22oAf/HaYQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(86362001)(83380400001)(2616005)(5660300002)(6486002)(6506007)(26005)(6512007)(38100700002)(4326008)(2906002)(6666004)(478600001)(966005)(37006003)(66476007)(66946007)(6636002)(8936002)(8676002)(34206002)(66556008)(41300700001)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BVnx1AgIfiTB322/rrcKXU9ayM1TFrqCW9Sv2vhGvx4awrTwBSoCdc2AtvyF?=
 =?us-ascii?Q?BsKi7HDNFLQIjAEbakrbZ28edB0ICv7Iq/vnWgpZCYFLhCOSovr5CXFtyum3?=
 =?us-ascii?Q?m+576LN6x8pIx2mhdwbIi+l0h+6T4Y9AKG0ZU+eeWYuATHxT5vCeGUu9UBd5?=
 =?us-ascii?Q?JDGp7KQg/87pDW3rJozb8uOIQvXJmYBvlDC2E1E56AS/cUjHM8hjOSD2osxW?=
 =?us-ascii?Q?zUi3parpCB+ec7mJte4cXBdXwUpBCGgTz6/xYrs8QXg5Wx6NxEoAfjnkrJ0z?=
 =?us-ascii?Q?Ddr+Ck3BlR0WnjE6B8iDwqQbsSGkMl1+IkBZAzd3G+1VyVG2SZGY/5ShYRkg?=
 =?us-ascii?Q?oZp140rSb3lliykCcOHVJRoxiy3+fb9ILaKxx4buJzCznI+yg1NP6LkuaMfX?=
 =?us-ascii?Q?hRsftzQSZeRSXHXbKLIWEYVtQjbBEn6g3LvCl/X4uxtUMuSObTWzCp+8ZieP?=
 =?us-ascii?Q?Qwy08ZXUqD9XI8oxBAPHPZXYjI+pwXkUBc99ck4su5dW+e9K0mZemXZj0peA?=
 =?us-ascii?Q?ntWEKmvoEDJV/kh8jvDB6vHcDSSgm1dnwXLHf1RMoyq4xTlI/fQgMk4flE2J?=
 =?us-ascii?Q?ki4mm0pZwfeSud/RbJs9hdaLvZYIcZW/MDbghr2akzOZ38i+ikt1XEn4Jq2a?=
 =?us-ascii?Q?BpcsdH5ga77GfnxkGU4GTHgDZKWib6TXVOJrZo2LMZdsm3l7phGGl5v1vgO+?=
 =?us-ascii?Q?RE+gdKFFIC6FUVxj8YVgLO6hsZ3FGSDNjNHhhIz2++kC1zeGlJjAeRhzGIMx?=
 =?us-ascii?Q?1wRzJJ9i3otQvcT82kKamSaWzxr8lRXG4FH+kNWONYw5tbOhb+0lJIWS0nDK?=
 =?us-ascii?Q?h4lHZ4KjdKVVWEv1BdnhGiDSp2x6pS06xG+OpeF/+esOhvLWl3KtpJ6/aC8L?=
 =?us-ascii?Q?e/F4D6RZ7nhLSgD+yY+n5qrgFNKSW4VuIrGCXhfiZVtTY/CP1lwdrVxhSgpD?=
 =?us-ascii?Q?agw50RhzbgGJn65Wyqz1HJJ3nIpWHsS5CgBctdbJHxK2S5KylYVtf7KOP4jO?=
 =?us-ascii?Q?bkR0QlReqESS3VgC3nNsFz96F/i88yq9VdW4mcDRpCERiUfmc1QHDQnpvpp8?=
 =?us-ascii?Q?PVYQfxJdyBd3AER7x2SmcH3q5a6crq/gB8s1og/B4HTGFlpT6a3zkldYVozf?=
 =?us-ascii?Q?52mCE84dTeNwJZ2Dhk3HW/9MysrgDtTMKGlhH83w3eOOHs1I6CNBEezxduMe?=
 =?us-ascii?Q?m+86cQCnPgFSnUCUQpuvbCS2m4lzyTRGWiL3OBwdaZqga+LJPXhSpFdrCFsh?=
 =?us-ascii?Q?6ODq1z8h+IANMTsUEHJN3eekOOeqrMqmWcf2kCwclSVTLAvzNMIrpmqkY8I+?=
 =?us-ascii?Q?o10m5z9dtG+/ytIPMqj0WIkk4kKB8+979B3X76gWlJiuRESWQZeECkb5t7wD?=
 =?us-ascii?Q?5V0EiMJk0Eq0bMXyD5rhPGb/1e37v61YJ6ZOH4smAyW0o7gf/fGfXL3kTdhy?=
 =?us-ascii?Q?og3/NUWjXotYcvAsiBy2VZAYfYeLC6UtaTmh2Aui20jNffkRv1whspfKDitD?=
 =?us-ascii?Q?TsoNKbJg273mBWJSndg2BPwK4dG1+m1t7gVimG3xrodsieL24aC58UeyIDDE?=
 =?us-ascii?Q?pcq4AdkEKbfcw5XPCLffpr3rk91Z70CFbWQl5cVT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5933cd-492c-40b8-0750-08dc165367f4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 05:24:26.3505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSYm8nAcy4SIZ5ywD5aKEJHUH4a4+wufWseGUZX79xhX8GEZf+fMdLh3hvRzr93YXSjLi90r5bBDQnVZCqYpjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8054

On Mon, 15 Jan, 2024 21:15:15 +0000 <ankita@nvidia.com> wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
>
> Add a helper function to determine an overlap between two ranges.
> If an overlap, the function returns the overlapping offset and size.
>
> The VFIO PCI variant driver emulates the PCI config space BAR offset
> registers. These offset may be accessed for read/write with a variety
> of lengths including sub-word sizes from sub-word offsets. The driver
> makes use of this helper function to read/write the targeted part of
> the emulated register.
>
> This is replicated from Yishai's work in
> https://lore.kernel.org/all/20231207102820.74820-10-yishaih@nvidia.com
>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Tested-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 28 ++++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h      |  6 ++++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 7e2e62ab0869..b77c96fbc4b2 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1966,3 +1966,31 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  
>  	return done;
>  }
> +
> +bool range_intersect_range(loff_t range1_start, size_t count1,
> +			   loff_t range2_start, size_t count2,
> +			   loff_t *start_offset,
> +			   size_t *intersect_count,
> +			   size_t *register_offset)
> +{
> +	if (range1_start <= range2_start &&
> +	    range1_start + count1 > range2_start) {
> +		*start_offset = range2_start - range1_start;
> +		*intersect_count = min_t(size_t, count2,
> +					 range1_start + count1 - range2_start);
> +		*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (range1_start > range2_start &&
> +	    range1_start < range2_start + count2) {
> +		*start_offset = 0;
> +		*intersect_count = min_t(size_t, count1,
> +					 range2_start + count2 - range1_start);
> +		*register_offset = range1_start - range2_start;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(range_intersect_range);

If this function is being exported, shouldn't the function name follow
the pattern of having the vfio_pci_core_* prefix like the rest of the
symbols exported in this file. Something like
vfio_pci_core_range_intersect_range?

--
Thanks,

Rahul Rameshbabu

