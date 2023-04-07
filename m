Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6404D6DA869
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 07:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjDGFEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 01:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDGFEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 01:04:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E394C4C20;
        Thu,  6 Apr 2023 22:04:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1m2b3Zz5Vvz9xtyP6fKmfjCVXT/2h4nqWDaL2uw26CaDviz7ZR4ji0nm+S2hZ5n8iIuG6iuCBfsATz9pfkmnoFBgSfJTXAziF6jmso4hWNH3OinaWoVxxQKpVyPFtT5eqlKpKPXwlUeOWzM7Tu+YwNHneHkjVguSenTCUTAUfnE1lzcQP3ITuKpip4OGpvW+dHYRpOecCX45fMTMyjY39H4CsyX55xtqqjImsge+315P3CJteaxX4A9Loks5ThRLSvCUMe/vdk+Qae0lqK2FZ5XrzLZLqSqR8yrNyH6O11d5+K+jaaOXMZLoM1GwijsN9lO7TmDupdoUnEEyji4wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQmNlBq4VdtRNwsCblS6MAb9TMFtnsct1KmGP3tHAZ8=;
 b=TXo8XXBTDvrZEADB8RanGuRe9SDROc/H5cjvH6FxVHcJQSPtyQH996oVjGiqzsXztOoOjHrA2K1zJydzZbzQI4QZihUmuk3/LbCQpP5mcFqRpxRdH6DCR20ibhgzJSJ5ZNx3WFq0tIg2znz1sre062/mFODueb57lf3v1d9QolbvryzIFbRlJg/QPABtPTZGzwRoMGBj8SX+t9ruXLkODLNPNEI2FbsQ6lbuKIItLJDbgv08x/1F+7cv7BE4/5zq/wzcCieY0bpqs+IViPPXfSCFemWjq2W4fyY98L6p9NmrBXfGx3gXOLZ/Ap48iN0iRAkvzAJZ8JmVw8aAWfKj3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQmNlBq4VdtRNwsCblS6MAb9TMFtnsct1KmGP3tHAZ8=;
 b=QSMV5TAwbHYbGYjlX8MoXnfl+eptkUS5w9BG4htcE31ZbW4MdvJMZog3U/80D+WTRb6eer+Snvkeuq2zhwdpZ02SydxsSXtVM6qQK1laVK/PLJrPXrgD+M6aRGtxsKGAy7aH8WkoSa+dYjv3I3mnXeNQzjZpsxTKdbZIG6JkfNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 05:04:47 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::72ca:e9ef:88e5:26d0]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::72ca:e9ef:88e5:26d0%4]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 05:04:47 +0000
Message-ID: <74b2dad2-1165-9509-111a-48407e2a1319@amd.com>
Date:   Fri, 7 Apr 2023 10:33:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] vfio/cdx: add support for CDX bus
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, git@amd.com, harpreet.anand@amd.com,
        michal.simek@amd.com, "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
        okaya@kernel.org
References: <20230403142525.29494-1-nipun.gupta@amd.com>
 <ZC2U0/v0toRVSWhf@ziepe.ca>
Content-Language: en-US
From:   Nipun Gupta <nipun.gupta@amd.com>
In-Reply-To: <ZC2U0/v0toRVSWhf@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0227.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::14) To DM6PR12MB3082.namprd12.prod.outlook.com
 (2603:10b6:5:11b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: 70c5d49c-13be-4cb4-90fa-08db37259b88
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lw7xh16OT1W7s9Wd5Qu7RVuVKFMf9VoWkxG+BirLJ4Iond8z1wMQEycEyGiqKA+/ZaAPli83Tmm1dSozgOWWutIW9ZUVDNcWPfeIL5euppY02pYTrLUiKXqWmeO6TV7bZjFWazEeq1hvvy+4mQjxDbL20Q+haL0JBy71femmVlF/NxIOCJv9B4JCaIBI9pLmKUwY76XeuYpIzvgOyX29qE8HEoX8nvhLPuE77pgMgbSTzxsW1XUPB2Ujn4uxKbtVKn3x2H9WvE10tzKnmffipmQb9rsctmggSLdaOwRibEBnO7iB2c2Fah2fJb0ZD3JP2ZfzFZtrJ3cMy00gWogScdPe0LAnSC8ta+voFWlc90qy1Dv3Cc8/j4r8U31Ug+tmHKLNBOqg9niSSeKGZ602zUouETcUntqY30V55S9ALJcyrGtk7cdNvrSVJKsoL7Q+1Vr4SjBrczN3jxMSa+iPiiRV1m4mM9uZ34SADQWxyJkg+QIxifwbPQqdIyQ4bpRi4U4rtGk3ENaopWyePKylzSYCqCtvnJeP2zhl4bg3Q3HKEM1kjyUceD2eP57NXD9zXdfJAQtcZPYgoGtraXkK/7glIjy4bSiCkH2dYtE/z9efbE+XgcjCric5FPEeLgzHKFXci3BLT3NE0EbqrOij4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199021)(6506007)(186003)(6512007)(26005)(53546011)(66946007)(38100700002)(41300700001)(6486002)(31686004)(83380400001)(2616005)(478600001)(54906003)(316002)(6666004)(5660300002)(44832011)(31696002)(86362001)(66556008)(66476007)(8676002)(4326008)(6916009)(36756003)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXpjQlVwZHo2UWMxRXZTTi9ITTdqUWkweDRtQmpoOTJnYTFicHBkMnlwRmw2?=
 =?utf-8?B?VEMvZldLcjFWYWt4Rnk3Uk9DSXlwUnFIdzdIcE9ObnBrRzdEMm42TXBvS0Nw?=
 =?utf-8?B?RVlQZllmbU9BOXY5VGhoTktES0lVTGtGbGMzUXVKSmtIdEpoL2VJc3Zkc2Vk?=
 =?utf-8?B?Wm1OS3VLUy9vR2pHS0xUZ0FPN3lXdGlJTkNjaUhIeWtwZWdJd3BUSHE5YVJw?=
 =?utf-8?B?eDVTUGJIdDhlSE1XcS9kK3JXaVcvd3krQUw5VFlEOS9KL1VnUUtBbm1IUDVF?=
 =?utf-8?B?U0xTSEtJTjBYWmZwWDNpMUlkcFBOYWx6cW9xQjllbGRaM1VoYzdVVFdRcDJL?=
 =?utf-8?B?a1ljcTNJc0xYN1pPejdIZU5LQzlRV2JmWDg1Vi9yVXk3SHlYOWJmb1gxTUZi?=
 =?utf-8?B?aFppaGNZUHV4KzMyVE14eGFZZjVGVWU5dDNhaWZDV205L3BJYUgvMzNUSG5N?=
 =?utf-8?B?dlJQZkFCbGJXUi91NnNOYi9iTEhzQVdWYkQ0dGFoWnVhWjdTbmhtYVpycm5p?=
 =?utf-8?B?eUxlbHo5VG1oSnZmTGt0OTFMc0grUHpTazg1ZG5MTWdTT054SkpKZ3dZNEVj?=
 =?utf-8?B?QjhHYndmamlIRVJnWmlnQThJKytoVHRTajg2N0R0bllBZmp2YVQ3Q1ZMRWZC?=
 =?utf-8?B?T1ZtYmRtMVpOeGFDNzlzY3NES2ZvNFZjQ1p5a1ExalhweWl3dlgySXFadkVk?=
 =?utf-8?B?MTFxT0tmZE1sR0R5VHZJN2FzY1Z2RFhYZHR2c2VFRGhGY3dUQmNKekhYNDk4?=
 =?utf-8?B?RmpKeUxkaVZJTURxZ2dQU09VQ1pwZ3BCRFVBWG94RXhCRER3U2tsZThyY0xu?=
 =?utf-8?B?cXRiSjYxR21qTkZyaThtSHhSRUh2RjF6TE0yR1lGVm5rMEZvRU5GcHhHNElh?=
 =?utf-8?B?c05uckl0RWptOVFIL2dtQXNIR0VPbkc5YlFNMXJqQ3RXaVRnRXZNVldPYlBZ?=
 =?utf-8?B?RmZ6blRZWXhKUFI1TGpQZUlvc1dzRVhtRnh6TmtFZGZsVE5Xczk2dWhhMXR4?=
 =?utf-8?B?Q1pxU2N0ZTZ4U050K1pxZ09HNWpvam1JS3FrdHZXelhtWDF4S3l2bnN5ZlU1?=
 =?utf-8?B?a2tOUE9qTUNxY2NseWxIMVRvaEszc2JQTWtRdko4YnpFNXNUaVdwVjhYVUxl?=
 =?utf-8?B?QTFxeW5MWUxwMGJVWm5OMlduYmhESEJKT28wRlNhVzh4N040YW9iVFNlMEds?=
 =?utf-8?B?V1BxRUp5TitwUlpjWWpNZlJvMW1SVXBuWFZPSTExQ0grdExjODhsUG1yMzhV?=
 =?utf-8?B?MjhWRHI0czViMVVqVzlEREwwdW5Gelo3bFh1N2Z2WjNLRkNndVBYbm9sOWFm?=
 =?utf-8?B?NHZNb3BDWnR3Q3ZmLzBjQVpLSWhFZ3BWRnZzcWsrNEliSXRWdVhNSGE4NDZX?=
 =?utf-8?B?bHhRYjc2ZDFRWnRHUGowSjBMK3Y1T2RPeHRmMXcrRDZKYVo4dWoxV1NndjJI?=
 =?utf-8?B?OStTN05MMFRvQmk4Vyt2Ni9UcFp4ZkU1RURyTWR0eFl6YldtdUFNOGRCN0Y4?=
 =?utf-8?B?eWtYTkJvSFV1dHNxOFg4aXNtTVFNUUt2eW1UMHRIbkl5cll3SUVqK1ozWmdl?=
 =?utf-8?B?cVppN1ZUREMzZm5Yc0xOYmlwVVdyaThReEdURDUybERtK3RFWER2KzFhQ05R?=
 =?utf-8?B?Sk9SQjUzaWVTSkJJSUNqNGtVY0NmamFoZzk5aEI4ZU01TExyUHlwMVRkVko5?=
 =?utf-8?B?NzA2NzVGdVpmNklmVXlXR3g5OWJ3b21RNkJFUmF3VTl0T0RleXUwR3BUdncr?=
 =?utf-8?B?V25nRzRrL3V6Nmp3aEh1TElZMlhVWTAra1o3cmRPVDJYSEdMTUgxNlNvVXRy?=
 =?utf-8?B?Y3lXTnJBTFNoTkFaNnQrQzUwT1VINHB2SlBGbjdSL05TNnlVMkVoZ3NMTy9y?=
 =?utf-8?B?cVBzbHJ4a1dHemM5cXc0SGM0ckxxb0g2ZFlBWVFTZ21oTkp4MldDdWZOVDVF?=
 =?utf-8?B?eUJBdGxKMGpkMFBaUzdQQ3hiUm9zRVkwLzJoNi9VYS9qWE8xOHZzVHpiOG9L?=
 =?utf-8?B?NmtZcE9KNEtMa01xdjFObVZnZ0ZmckZRSEdrUVB5Zlh0cGxOS3BHN3grM3Zy?=
 =?utf-8?B?K1Y4Z3JiUlhJMnpOTHN5TWpIelNRanNYVEdxUWNPUGVWWlRQM2FXaVN3YnVo?=
 =?utf-8?Q?bzvmCHHryDJK9QDzoQLO47Kj1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c5d49c-13be-4cb4-90fa-08db37259b88
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 05:04:47.1310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 732FTHBWWA5rrWUqIBUNYpWrn6Xlh3GuowE2Dk22H+vnq08BI5dX7fFZHIQDHy3N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/2023 9:03 PM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, Apr 03, 2023 at 07:55:25PM +0530, Nipun Gupta wrote:
> 
>> +enum {
>> +     CDX_ID_F_VFIO_DRIVER_OVERRIDE = 1,
>> +};
> 
> This seems to be missing the file2alias part.

Sure. Will add this.

> 
>> +static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
>> +{
>> +     kfree(vdev->regions);
>> +}
>> +
>> +static int vfio_cdx_reset_device(struct vfio_cdx_device *vdev)
>> +{
>> +     return cdx_dev_reset(&vdev->cdx_dev->dev);
>> +}
> 
> Wrapper functions should be avoided.

Agree

> 
>> +static void vfio_cdx_close_device(struct vfio_device *core_vdev)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     int ret;
>> +
>> +     vfio_cdx_regions_cleanup(vdev);
>> +
>> +     /* reset the device before cleaning up the interrupts */
>> +     ret = vfio_cdx_reset_device(vdev);
>> +     if (WARN_ON(ret))
>> +             dev_warn(core_vdev->dev,
>> +                      "VFIO_CDX: reset device has failed (%d)\n", ret);
> 
> This is pretty problematic.. if the reset can fail the device is
> returned to the system in an unknown state and it seems pretty likely
> that it can be a way to attack the kernel.

We will update the code to disable the device in case of failures.

> 
>> +     case VFIO_DEVICE_RESET:
>> +     {
>> +             return vfio_cdx_reset_device(vdev);
>> +     }
> 
> What happens to MMIO access during this reset?

There is no config space here; and access to mmap space will go as usual 
but user may not see the expected behavior as the device is being reset. 
It is responsibility of user of VFIO device to serialize such access and 
reset.

> 
>> +static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
>> +                           struct vm_area_struct *vma)
>> +{
>> +     u64 size = vma->vm_end - vma->vm_start;
>> +     u64 pgoff, base;
>> +
>> +     pgoff = vma->vm_pgoff &
>> +             ((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +     base = pgoff << PAGE_SHIFT;
>> +
>> +     if (region.size < PAGE_SIZE || base + size > region.size)
>> +             return -EINVAL;
>> +
>> +     vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>> +     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> 
> pgprot_device

Will update..

> 
>> +     return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +                            size, vma->vm_page_prot);
> 
> io_remap_pfn_range
>> +static int vfio_cdx_mmap(struct vfio_device *core_vdev,
>> +                      struct vm_area_struct *vma)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     struct cdx_device *cdx_dev = vdev->cdx_dev;
>> +     unsigned int index;
>> +
>> +     index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
>> +
>> +     if (vma->vm_end < vma->vm_start)
>> +             return -EINVAL;
>> +     if (vma->vm_start & ~PAGE_MASK)
>> +             return -EINVAL;
>> +     if (vma->vm_end & ~PAGE_MASK)
>> +             return -EINVAL;
> 
> The core code already assures these checks.

Sure will remove these unnecessary checks.

> 
>> +     if (!(vma->vm_flags & VM_SHARED))
>> +             return -EINVAL;
>> +     if (index >= cdx_dev->res_count)
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
>> +         (vma->vm_flags & VM_READ))
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
>> +         (vma->vm_flags & VM_WRITE))
>> +             return -EINVAL;
>> +
>> +     vma->vm_private_data = cdx_dev;
> 
> not needed

Okay

> 
>> diff --git a/drivers/vfio/cdx/vfio_cdx_private.h b/drivers/vfio/cdx/vfio_cdx_private.h
>> new file mode 100644
>> index 000000000000..8b6f1ee3f5cd
>> --- /dev/null
>> +++ b/drivers/vfio/cdx/vfio_cdx_private.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
>> + */
>> +
>> +#ifndef VFIO_CDX_PRIVATE_H
>> +#define VFIO_CDX_PRIVATE_H
>> +
>> +#define VFIO_CDX_OFFSET_SHIFT    40
>> +#define VFIO_CDX_OFFSET_MASK (((u64)(1) << VFIO_CDX_OFFSET_SHIFT) - 1)
>> +
>> +#define VFIO_CDX_OFFSET_TO_INDEX(off) ((off) >> VFIO_CDX_OFFSET_SHIFT)
>> +
>> +#define VFIO_CDX_INDEX_TO_OFFSET(index)      \
>> +     ((u64)(index) << VFIO_CDX_OFFSET_SHIFT)
> 
> use static inlines for function-line macros

Okay. Will update the code.

> 
>> +struct vfio_cdx_region {
>> +     u32                     flags;
>> +     u32                     type;
>> +     u64                     addr;
>> +     resource_size_t         size;
>> +     void __iomem            *ioaddr;
>> +};
>> +
>> +struct vfio_cdx_device {
>> +     struct vfio_device      vdev;
>> +     struct cdx_device       *cdx_dev;
>> +     struct device           *dev;
>> +     struct vfio_cdx_region  *regions;
>> +};
> 
> This header file does not seem necessary right now

There is work in progress which would add support of MSI in VFIO-CDX 
driver, and where would be additional file/s. So we would like to keep 
the header file separate.

Thanks,
Nipun

> 
> Jason
