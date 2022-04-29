Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAAC5148DC
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350244AbiD2MLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiD2MLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:11:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200EFA76DD
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWJriUqXTT2MaKORVvJpdeOGYiBjejl/cn60WBBO/NBRJIW7cm5jTPNItu3fqn7ZqDxvf+tzqXHAzIMugZbafGTWzQs9b/+oWilQYoGTBwYtJ2Da8MSsAFzpyzTRRXMiBiOTh7RbyuBvtcgSdbJjKXBMKdOBIwinrQQo7o46eDtZoumeUCxArg+q8rdMlIQlU5T1S+aQB1bJDC3OAUEp2WqyvEPwbXFZllvKl+M9htQZICkANG64sGYtIHYnCdSaIWAVHkO2P2nwQVMjkhRJhd+KX1alm3PtIJlwMTubsoH+GzumR8iuYZGQ9HImlWQdnmVhbiXAi92qOfl2RRHvtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMmH6Wo7W6o3IwuYTZLDY8JrqJ5lp9UXE4eBc3PKa0E=;
 b=Xra2G2EkQ232RskiCQ49XBzI4LOwVFT0k8IG1sAwPk3TXJQjGNCwBMTktHl+A+tAFghYiaeUcCUBODX2asP3O0uhgbU4ORJb6k9Ktml8JbHeGKi476LUNOk63t7jLlpniwn+4bRyo6LAxFDfMFoaiWsvqreGx+3WsEqd4uOtS3fmqzqyo9rVT6pRktgV7Y92fKIbjKepXH6M5VIQjLKojhViETOBpWJzAdcQJJT6TBSg+alAFF7e9qKMMdoy3vdY9BnsFvJBhs1EP0pEJutmqrbQcXyAVjyDmHvFslY820J3Rx+AhE6b22x+1VJMKrF8yBj79jAaxF7fo1PUULgNhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMmH6Wo7W6o3IwuYTZLDY8JrqJ5lp9UXE4eBc3PKa0E=;
 b=mwgCPZ8hTERNKVfXkAt5s2+3jyXp23fMzYAGS7xVX5OAxvuq6Dg9xLhokoB+l5W8qI8+++9of3KKkdxQXNk28RKmM0Ko6C/fGdDpsh3tsoWmOvNqWlQJdHtA4TEd7HIlST6riHLFst15ec++L2sX1q0NLRA8FZjPk+9hrXyMImYIdRUq6+iaKgAY1WemMbrKyvEEjB42XAC3U9e0DWjJ2i0riFkiZ4CeCb0p1NTqYAccOsrbtyIb2zQMNqrCE4lk8mlO+Pwh2J29w9lqzX5aFbDhVemVQzy/of9rV8ycp0rR4mjG7ILMvcg7q76PoUhFMbAP3cRV85CuCg3w+FV5FQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4942.namprd12.prod.outlook.com (2603:10b6:5:1be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 12:08:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 12:08:22 +0000
Date:   Fri, 29 Apr 2022 09:08:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 01/19] iommu: Add iommu_domain ops for dirty tracking
Message-ID: <20220429120820.GQ8364@nvidia.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428210933.3583-2-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR19CA0040.namprd19.prod.outlook.com
 (2603:10b6:208:19b::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97c5aa66-c2d2-4f31-054e-08da29d8f498
X-MS-TrafficTypeDiagnostic: DM6PR12MB4942:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB494271D2B00973E5859B5498C2FC9@DM6PR12MB4942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/eOiNBAciNrI5l1vyxQz3gC7k2OF8423425icAQaNy+esNlyhqbaHPTMpPjh3ixk2mYb6zzL3rYktg/NrwlVY7RKqkZ/miBG0x5g//ajkhtm3Tu1IRMC0Z/btDMAteKNbu/InhNmnTDof9ApqY5rcPLj952apmSymO0U1ZBMw30/AdXBaw4sj4zD70PYrRYVsrwL1oXfYh1TL0QbFz0Z8nSHZWHd7JHevXvHqggM5F1Qu3K9gvN1JI/gW2OmcT7C8BOBLGZyoSTUz/qGYpcwea2l3akUMJ0lb6XmWlZX2szmYjOn0zlcvfqbRFyGYG+CXYcrTakLtHz0J6ZqA6bgVsJxiV4ZoZriGsuqRiIzpvJuNhQllXokhb8bA7QQYctk+xdlTqw/0q6kR9mQOD0F6+rpzyORO1PA5VVg4t6Hyon6H1wUOYlxLoURAIN+s31o0e9zBED45cWzrzk7aMIHiTeuBggbaugARWlr00jwOVLKpMAqMSZlM76GFnhTIHbZVidlLiQV6r+4FRHyhJpgmL/7yEjoTsH2oTXox6BF5IgnPLHThG0XzDIaI7R9pqMW/YKvHgTbmu3iPvwQSTH2ZJM5pKw+qnxdiV9Ddu+Ra+F20IAaV/vevWSeNSohCjHM9GrmQJswz/hgLaTgnDBsmrRzTf1MqZJw28VPkRpt2DbgdqGBO0deDfB6dkZUBXdlEMD1dPs7CZbAxiduNQKtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(26005)(6512007)(7416002)(316002)(54906003)(5660300002)(8936002)(6506007)(6916009)(66476007)(8676002)(4326008)(508600001)(86362001)(66946007)(66556008)(38100700002)(186003)(1076003)(36756003)(2616005)(83380400001)(33656002)(2906002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lXql1s+8pyTjYIOL2vNGG8pQvRsv7Ul8o+c0UEnLlaEBOwN5K2a3Jg9ITwzz?=
 =?us-ascii?Q?Aid154uPB/oXjVU07y0lgWZkLlmVuP15PMi4jckLeji3tHDseExLYD2QS9Hs?=
 =?us-ascii?Q?y/a7U/LNRtN2skvrKX9nhgYcCjp9qLR/SLi8dRtFH9WasttfBuCDiQXpalkv?=
 =?us-ascii?Q?INwZuC8q3DsTQt7/F9Jil5gPtUvFgqZ8RF7irbmClpuYH2JUHhLf+1yTTbB5?=
 =?us-ascii?Q?Xp+x0wV61odlCokf3PYfJTELvJs8+QzSn6JOB+4x8Kmfcij42yH1nAKu0MBu?=
 =?us-ascii?Q?7pak8PNlJIm4j421F1tSW+wmO87UT1ni6Jhxwm1LhtBphGQ4VmIOb1/PsQVk?=
 =?us-ascii?Q?n5euYQKjGa5sezVJ1V1e8wYTjZJxe/x/sjzbOJjaPxILVPMPdM8jDZEaqJGj?=
 =?us-ascii?Q?M2iEpw6IiyRz9sQ1K8ON1Hea6T/E1iBHxAOI1BGpdtn1r3y7HpjZTi8o63ag?=
 =?us-ascii?Q?1HUUrvTWyhSjzVbbwjVZAMRlmX1z6/w2mXzZ8F3j7Lgaf4PcgZ6rfkx3jVII?=
 =?us-ascii?Q?/Xka9B9AIan4roUm4iLp5DekjJEsQfGwLhECTFpTln/nK89Lu6yJLMi7Sscs?=
 =?us-ascii?Q?A28CVar6SocGCAtIxGl4KnASkBTZcrtagx8RMtZSnmC8M4dmV0AaGT1GakS8?=
 =?us-ascii?Q?fJFRAqFDBsKZB7o0RY6psPv114tNC/DVPyJQUKYmMFAdbV8rbJ8pp3XEh+iD?=
 =?us-ascii?Q?HtfeFgOMUyZT42/2l+Z9Ox0iUWkO2zAwgzD3qB8b6slCj0Y0SBxoEV9N0Sky?=
 =?us-ascii?Q?mUqICHg4fuJcIcAAjLlMbzAOHIHJsBVAirj0soJJIaiJVVNAgQbPpOpM1/Zo?=
 =?us-ascii?Q?aOYDxGXeADlIvCIibT5QzSr4RQ7vAFkno2pTgu2AZck7reWZUkU2fxbnlgbx?=
 =?us-ascii?Q?2T3I2vxu+gYQOUvHpGCrZmLlT1UV5AVJq/HWIw1TDIsMFJ4Fw+Hbo/BF03wy?=
 =?us-ascii?Q?MJ41I8Oi0S+kWcMqDp30HygG0WPfNJpcl48WOyUsI/y/lbHnbJNvpjGbNKyI?=
 =?us-ascii?Q?MLznJFeE7sjmzLkgEGDzrcbzWUwPNfEMi7w08xz0fQFqCuE5Axkfy1mQiltH?=
 =?us-ascii?Q?hY90cpzoUM2+/69npILyMuXf0cRG7qIt06m4Emc079REPC1lHN+V3A+PoLFU?=
 =?us-ascii?Q?E+SXnxNfYKRUNGcD/o+ygH8FfLKKtVfW5sg8Cbpfkdgq3rvc5hFsaqxDQRlR?=
 =?us-ascii?Q?EEHe2dmN2YKu5JlHdTaU++/oNUDdsI35jg1e/65ub3CH7Amsv8UZU15qzhFO?=
 =?us-ascii?Q?f+b7IW7sOC+u6Q2TKLFdfnyE+uyBlb09gtOAyEejqU4BqhK6tlYcCNyuJuqK?=
 =?us-ascii?Q?3acZFxlPnNQKBePrrINCNu/etPPjvFWqWHbpc+haQJrqDHE9d3vsYaZy+Ra9?=
 =?us-ascii?Q?/OO2NVNvNs3nL64d5TtFRD4L1WxzPh5nYQpxsRMGIbm0vylKlR5+K6BqO4W0?=
 =?us-ascii?Q?Sqdu/lKR/UZafLnw0zwVpF7PFeloERMrH+FTWuuFES320MzmvXSXmJ/RpmbN?=
 =?us-ascii?Q?3GG4Xi40dJrZroWoJBrnzd/LnyxkiqFvWe3RpovEb5KrmQKP4B/ICOse/Sh0?=
 =?us-ascii?Q?JwRYcMn87SwUnUFSdpFt5G/227ZCyZT1hkkwVnHAjZ0lG04l8YPrzfMoES8a?=
 =?us-ascii?Q?DhUjZ1OgdRMwsVoRVmG4cD9Gpr2fHg8Qx8N3IpRXm79U4RTMeJMKmOKtRQrO?=
 =?us-ascii?Q?T02ZWoxgNn+zLNSw5cFgvmGzIHcD/n7lv9WMiQdeH0+vUQLbS/wFaXfUUL+m?=
 =?us-ascii?Q?IEwi84DU8Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c5aa66-c2d2-4f31-054e-08da29d8f498
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:08:22.1655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8UirdQSJpaZiP3rzniXwGqRxj4izz50IkEsc0N4Si6Q7FMCW5+oGFGHuHnhLSxth
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4942
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 10:09:15PM +0100, Joao Martins wrote:
> +
> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
> +				       unsigned long iova, unsigned long length)
> +{

Lets put iommu_dirty_bitmap in its own patch, the VFIO driver side
will want to use this same data structure.

> +	while (nbits > 0) {
> +		kaddr = kmap(dirty->pages[idx]) + start_offset;

kmap_local?

> +/**
> + * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
> + *
> + * @iova: IOVA representing the start of the bitmap, the first bit of the bitmap
> + * @pgshift: Page granularity of the bitmap
> + * @gather: Range information for a pending IOTLB flush
> + * @start_offset: Offset of the first user page
> + * @pages: User pages representing the bitmap region
> + * @npages: Number of user pages pinned
> + */
> +struct iommu_dirty_bitmap {
> +	unsigned long iova;
> +	unsigned long pgshift;
> +	struct iommu_iotlb_gather *gather;
> +	unsigned long start_offset;
> +	unsigned long npages;
> +	struct page **pages;

In many (all?) cases I would expect this to be called from a process
context, can we just store the __user pointer here, or is the idea
that with modern kernels poking a u64 to userspace is slower than a
kmap?

I'm particularly concerend that this starts to require high
order allocations with more than 2M of bitmap.. Maybe one direction is
to GUP 2M chunks at a time and walk the __user pointer.

> +static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
> +					   unsigned long base,
> +					   unsigned long pgshift,
> +					   struct iommu_iotlb_gather *gather)
> +{
> +	memset(dirty, 0, sizeof(*dirty));
> +	dirty->iova = base;
> +	dirty->pgshift = pgshift;
> +	dirty->gather = gather;
> +
> +	if (gather)
> +		iommu_iotlb_gather_init(dirty->gather);
> +}

I would expect all the GUPing logic to be here too?

Jason
