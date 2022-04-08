Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349134F9578
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiDHMUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiDHMUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 08:20:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADD531A2AD
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 05:18:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRTbVHlATlcfl3FtkJfR/B7pDER4lMMt4kzqnOkINnbCfyNxwO1IhbVnuS/3k1TGAlm9/QcqHo+x3xTE0BKon3IGTW6FAzgB7/6E4NqzY7b6fIt7XSpqUErdQvx/1jzhSU5czf77fj3raljjIbWUXm/frLTYn855MtWgJsSWBOwPABNPCTO69H6tRB4GXdQpQhoM1GE1h7PEmhmqHPL2s4AGNp5UEHkP8NaEouKw5oYOlOsyWass+BryhTu/Kd6Goe0rCfnyvwENhQt7ov3OMuemQhvJB30zXMrqpvx//r0BNUEU/cObyuR1Ihgq/N0en7/yt6G6VKNYfnb1Zigsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CiXHt/wGMznGEF7gDhrjZvwv2qWFFKvHICgRyCApWg=;
 b=fL3ZF77kqX3B7HP2igws2ugGUSWJUc73VjOTKr6mlJsOUSTYUcT7YG2+wWCx5zblLwWIwfg9bpUV47K9Eos7hysZ+3XHbrhwF/tSayM1e8nt/MLLjO5miKVet7/X17Do+M9wBqxMb7c3sMoGuLltsTsCw8FxuoRF4uhqiX6Hb63skuu9lV/OrE0/Cru+2/a4pC4+MI05PnJkrDOY7HkT7KEacNSTU726od2BQq4ZTszrgUpQPxhDP7vB3/oWyiGoBrDu/OSS9niJYWF2iqy1Dw4dP+vR3YmMvjc8JdwhK5KTyu+0liObKC8ON5M+mt+0bwEsIocci7z8/QPKBFAtqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CiXHt/wGMznGEF7gDhrjZvwv2qWFFKvHICgRyCApWg=;
 b=kYVrCW2Itu5uQns0coyBG7mTpmf3E4XefpYaerr52UQXRWYyfqOEUr1SNYomNdzpW7aXHlCfy0NY4bKph1MNZ2zzXXtA7P1GX6I6BLBnXL0tjMFI5epmn3tx5nTIdkufjZxlg7XWKeeC2kdeJyvm9E6dBEyNX5wQIh/JwtUgbVSqDCTK5oHcOjAFcq1LAzT5PeUSrMMBiZ0l85CGqbWsqC0JpuxPNve3JlbwTQxHv+ogN0KD4N7qiiwRG5DVoio16u2qoBOjyaYQHoMmaV/lbkIXrhSzGcHPPqpRQV+9WU+axbRTDMvEFdtj3TSfLcNpz1jhZzNVVLE2b4UKvfz9FQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2354.namprd12.prod.outlook.com (2603:10b6:207:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 12:18:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 12:18:47 +0000
Date:   Fri, 8 Apr 2022 09:18:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Message-ID: <20220408121845.GT2120790@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
 <20220407174326.GR2120790@nvidia.com>
 <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
 <20220407190824.GS2120790@nvidia.com>
 <4cc084a5-7d25-8e81-bdc1-1501c3346a0c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cc084a5-7d25-8e81-bdc1-1501c3346a0c@arm.com>
X-ClientProxiedBy: MN2PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:208:15e::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e7f5534-7eeb-4d23-634d-08da1959ee5f
X-MS-TrafficTypeDiagnostic: BL0PR12MB2354:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB23547616D0FF676AD703934FC2E99@BL0PR12MB2354.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wNj4XSzdXA/MTzWUsRSnL5qVEh4mWHRx1HPt6mkIFFaeJkMroFfSs3d8C3LlGFrz5VMTsmvdpIn2WiyuxDw5MnYTOeUo0PDjrUuYdbaA4uGbAaMDtvDuagdQMyCPE6jHIrAUwsyr2NnCCcFOcgxCxVz13xOmtLwE8K4F6kvx/H0uWxO5v0HBBZQcO0m3/p/2KLKocxuK3LC134O1GwX1TSvHFhNUXJyUFAaHQVgNKFY9kT2/h0xnisoSf/0I+GDM7P0AhSH4tlnrdW9DbKmoC2GvK17XZx0Z/oaRBSybIJAGaSo0ZficU7MMs9koBpk07YXAiKkZMgvNt35Rljv8EEHjaHZM8RnF/Gs1qHzyWMF36s/0LNvcFxPYqpfuw9yysAGHqcdTcZpDsZk4TETBlwOyLxfZbggHkfMpasHjlZE/9H9FLFVGFcOnUyeSIh0g126LdDYxLujV/S7V3IcC7Vvi4CP9q6Lft4xLGb+NZFUafxw2/t/3DjyB4Ah38aSbQ7EFAOQldL8/caMCbFstqLeUymawTltSqVHiDxC7IMigESxTbEFz0+t43kgqI5R+eiCA/rfHvTA8Ri+PZDPftoKEzsgK6fn5lVT6h6PU1eIIEOucU7UZNZZac9mzJGE29ShNZzaZ51UfjNfquB+F/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(83380400001)(316002)(1076003)(6486002)(7416002)(66476007)(8676002)(4326008)(6512007)(36756003)(2906002)(6506007)(53546011)(38100700002)(66556008)(86362001)(8936002)(33656002)(54906003)(2616005)(66946007)(6916009)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aal8Okd2yYyjgKXVB/yma+5z+D6fBSvw2WDrNh/KMDJHlgkFJOGT+Kwc6ptS?=
 =?us-ascii?Q?PZ2lt1AxWZ39bZE9TW9p489N5xWh7E4ctOLk58Q3y6TWDnDanVwzySENs/7o?=
 =?us-ascii?Q?9xHEXjSLsaXF7S6kcbNM3ke7i8Gaufay0kZNmFIn85KwPSmfefsvbpz2FPad?=
 =?us-ascii?Q?PSO9kC771g9tHJaBKFhefzhA+9pS18Gl2Btug54UMjPup7/HwHzK0BfMcsEt?=
 =?us-ascii?Q?NL1AfrUvlwcjQGWPU8JmWnWDjVep2tXOEIgH9PwSqoQLPoOUMp1ivIziBFvs?=
 =?us-ascii?Q?uWtbrVnyHvaO3T5r0AnGx6iuPE78nyXj8Dlib92MrzPRurZfs+Ggo/hWQyM/?=
 =?us-ascii?Q?M+mq6OcKV0kTOOaRGxgXM5PlQKM616Cq82SfZFrO1+SZJZCS9UZJ3V8qFinS?=
 =?us-ascii?Q?HNrbIyIn2RsjLLy1iX+DjpRTf3MyLfV+/tQiqhK9Z01tjxfqfvakpp++WEzQ?=
 =?us-ascii?Q?e1Xf/y8A7d5e+J8pE6sc5HLHQhixKd7FwT9qoq+DI+5JUpph9vX2nf/YEXBk?=
 =?us-ascii?Q?yw2A1Y0BhInWc4f5tD805KT0FSteV/xPNJebBL8jHfiHyQyn1FN3cf4pi9hs?=
 =?us-ascii?Q?NGUqJFA/Jdlz1Q3Flbh50WWa9lAi9IKVSpEWsQ4q78ZXIHnc+3wQgeIHQHZz?=
 =?us-ascii?Q?MyXwdQBbFQyQJKm7y+Ho2g3ZQgttkYV+bAeKW54UaD52+dSt45BUR3JDt5tm?=
 =?us-ascii?Q?owEiIZjylxdLQSvq+DftruGDPXBrfEGR32yId2wiZGwxnaf5rOZDaH9/ZZ0t?=
 =?us-ascii?Q?Gv5tSy9K6e8HuW22v27xXk2YNax4flRU+O0yITBk6YhDA+BIb9aSMXlJPGOV?=
 =?us-ascii?Q?l+Rz0YkP3Ml5CFtIS0Zq84q3aKq/ecBChdMxMO60KlQhnEvB7fwnzsSJeh8R?=
 =?us-ascii?Q?kuNmRGT61rTvVg4llJb1raM8mfnIXTuHpsg5SeFcvERyWpKrX0woYt8mnawG?=
 =?us-ascii?Q?zcXahrPQnWsci2OxtR3Mbij4lst4PENyc/fkPjii9KA2kVA2+Rl4wLfwrMSJ?=
 =?us-ascii?Q?QO27uDeinM7zKjzQfvHq1EaoixSGTDmvWh1mef53+p15P7cnViZjbIEfHrf4?=
 =?us-ascii?Q?hZYfUt+ryYY8t4TjUuJK5jp87DW7Wrzt8GH4W1Jrztu+JMJ+22r2jPfUOFmv?=
 =?us-ascii?Q?fYtBPdTCpTRKVErMBdC/M32VDMQqcuIn+yZXobkQmR84UXLDmXn2P+NE2613?=
 =?us-ascii?Q?hthtxBte379XVTWjicSNuKvasPZ2S8bO0LX+v/Avu5BkVMF0NCMmi/rguPey?=
 =?us-ascii?Q?ki33wiy5+Ug3IMCahlD8F4RJ8bdZ7A+gdfAHaKbIZ7gpDHHW6OYE6AmbYC34?=
 =?us-ascii?Q?gMYZZk3xTlwMzD68mzW0Cu3iRmIiUQeSb1ftTWKgdZruKqHLCy8efQft/qNv?=
 =?us-ascii?Q?2388uYsEXW1CUbOYz74R+fFJ9MMKupZNIdJs0jSvRoaIork1RTWiUpD5W+sJ?=
 =?us-ascii?Q?s/BT3tgFKA2QjbJMfT/X5HhZx2XjIxnw9mMXnpsy6d4mH8VM9S0sJhcPVr4p?=
 =?us-ascii?Q?qUDX6K8dG8+LIVWQIz+vXDZM7Fj5aAWuRmqtmW8iqT+qdRtE2S9hpUgmXV0P?=
 =?us-ascii?Q?LuQprhnxGTwwN3V7w3TRDM+6zEovW089TJGwr8Du9dntVCA5/f5OA+f0coTI?=
 =?us-ascii?Q?ZjygHZs2/vbmLDIhdfWBMk7ce+Kcte6ohGbpbKKg5q26O2Jou/0yJxOrwvRS?=
 =?us-ascii?Q?AUz87s6cr/4e6KOUwzf4yK0/RY+kDPPAloxYduhnf8nHX7CAvCufHgYz/xdd?=
 =?us-ascii?Q?UFPoLJ3CQg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7f5534-7eeb-4d23-634d-08da1959ee5f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:18:47.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKtN832G92L8CfXwpDh/0w0/D107WRnGiVy/j1lNF7UkgDHVDJ149Dfk7dPJzOWe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2354
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 08:27:05PM +0100, Robin Murphy wrote:
> On 2022-04-07 20:08, Jason Gunthorpe wrote:
> > On Thu, Apr 07, 2022 at 07:02:03PM +0100, Robin Murphy wrote:
> > > On 2022-04-07 18:43, Jason Gunthorpe wrote:
> > > > On Thu, Apr 07, 2022 at 06:03:37PM +0100, Robin Murphy wrote:
> > > > > At a glance, this all looks about the right shape to me now, thanks!
> > > > 
> > > > Thanks!
> > > > 
> > > > > Ideally I'd hope patch #4 could go straight to device_iommu_capable() from
> > > > > my Thunderbolt series, but we can figure that out in a couple of weeks once
> > > > 
> > > > Yes, this does helps that because now the only iommu_capable call is
> > > > in a context where a device is available :)
> > > 
> > > Derp, of course I have *two* VFIO patches waiting, the other one touching
> > > the iommu_capable() calls (there's still IOMMU_CAP_INTR_REMAP, which, much
> > > as I hate it and would love to boot all that stuff over to
> > > drivers/irqchip,
> > 
> > Oh me too...
> > 
> > > it's not in my way so I'm leaving it be for now). I'll have to rebase that
> > > anyway, so merging this as-is is absolutely fine!
> > 
> > This might help your effort - after this series and this below there
> > are no 'bus' users of iommu_capable left at all.
> 
> Thanks, but I still need a device for the iommu_domain_alloc() as well, so
> at that point the interrupt check is OK to stay where it is. 

It is a simple enough change that could avoid introducing the
device_iommu_capable() at all perhaps.

> I figured out a locking strategy per my original idea that seems
> pretty clean, it just needs vfio_group_viable() to go away first:

I think this should be more like:

  	        struct vfio_device *vdev;

		mutex_lock(&group->device_lock);
		vdev = list_first_entry(group->device_list, struct vfio_device, group_next);
		ret = driver->ops->attach_group(data, group->iommu_group,
						group->type,
						vdev->dev);
		mutex_unlock(&group->device_lock);

Then don't do the iommu_group_for_each_dev() at all.

The problem with iommu_group_for_each_dev() is that it may select a
struct device that does not have a vfio_device bound to it, so we
would be using a random struct device that is not protected by any
VFIO device_driver.

However, this creates an oddball situation where the vfio_device and
it's struct device could become unplugged from the system while the
domain that the struct device spawned continues to exist and remains
attached to other devices in the same group. ie the iommu driver has
to be careful not to retain the struct device input..

I suppose that is inevitable to have sharing of domains across
devices, so the iommu drivers will have to accommodate this.

Jason
