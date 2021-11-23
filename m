Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857A645991E
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhKWAZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:25:15 -0500
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:12518
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229853AbhKWAZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 19:25:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEkpjr0KaT3Rvir1aSS8PsV1cGw1DYeo9CZezxzgambrWclqC4flaXfHqWYMuq8dzujaLYDhkJjpneQ1btGfCbOA74LLafPkOvQyMs3+hKFkKcL0zm33DoI5ANEC228NdVNZqx9tZo3FUH/p8sIxvxXnIooPi549h0glJVPoyZ//EqkSYbyZZ9Ni7akN8qEWJDeOxQqtaLHDfwstOhCADp7Vq6fBg2gFQAd3lOjY91hWvaOTdrHHYyZ30IOb2HUCcYTNVE1iuakjyfYOSpQtqVYXHWZOHIVyqDhDKg/gFA+uLljRSL1v+ueC3rrmZtfKfvsg3MqN3D4cjLoKOlfGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybc/KBnMUHIuYtpvieAyUer5LsKhNofasqSc+8x43yY=;
 b=iSYyqx2w+G/7XwPGtF7jwXlIC3EluoWedpmrskMwd5+Vk/hb/iuVV11QWW4MkD0hkWM9ltXOH9+S10pqTh55tVfMlWrOEAhZq70gm4rAJpcn5pVi0akC5ZEsby5cQl/5iXDjjG/V/lO/EIn0pLc10Ng5PSsthOmGuyD8pJSwp8WTrqtdGSbTlYZEbHJB40Vl7EUQU4GbuxBj1aoarAPVs0KyZvFil6Frd57HTgDbjyek+GZOCdFhnl7QJDWI9nRMPh7eGDJawYj1KJwg46VBhQQltWpvJHQjNf6gXRFcsmy5KtIHpHRbK6CvZJZC7FNkrb1W/JyVjmgspxdg9pMRiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybc/KBnMUHIuYtpvieAyUer5LsKhNofasqSc+8x43yY=;
 b=sm2zqh8IHPo61etiplE9qiBV6MaWaKa56O2VS0rGZBJWSUaK3SNPU3R4KySpXR5hX5phvnAgoPtGtyQMWL7Yr3utZxpEdfcdhA9/vCSahw4Mq9iak7MF8zdQb5Bj8+jHtN4ZumLJJUtF7iVLuTj0pYVH6W9pu6brEZ38OQJY1kakU6e4PXvTNBeG2wfoxsolSaW9OK/7OgZe3B0fmEj89q8Xl3M5ybPE3o8LKC+PXolbQtZ6Mzx28coJxwaFICsy7F3FEr0xRR+Ky0xDxywJzoaRo5w6bPVXuN01Doz1XpNZTDtbM/h50Fh+5FjmqcLodViNMKlgER7P/bGI3+Mo9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 00:22:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 00:22:00 +0000
Date:   Mon, 22 Nov 2021 20:20:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-doc@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
Message-ID: <20211123002042.GQ2105516@nvidia.com>
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <875yskvsod.fsf@meer.lwn.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yskvsod.fsf@meer.lwn.net>
X-ClientProxiedBy: MN2PR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:208:19b::40) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR19CA0063.namprd19.prod.outlook.com (2603:10b6:208:19b::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 00:21:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mpJYA-00E2Uf-Fo; Mon, 22 Nov 2021 20:20:42 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb1ec671-c7b9-4755-cf27-08d9ae17440a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5285D1F57C750BD8755F5C3AC2609@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4h83Da1E7I8Q0Wbdy3SnbyRhXMyeEl0NgvjsPGIoGBX5+m/S8aqOi8EKlfZNvXAIE5rFGLy3V5Zsr8pqV+fmCETYcGPtX+s8ZyWMlIiDtm5gcw4W3UPrJhzd04+c5vbVVehGs8MlhvFgQykEwwbnbXSjo/9jRVtubDTaxrQRLETjNhSsGDCid8NFpjK5AQezQIt05w7V7zQRplG5DWpDJ3ynmIw25pB+zjQrWLyKbYNtgfF2lxnDuC0fz7n9JjTo+cYSqd2dkkcQ4GYJyRd43b4Fn7sgfMPhGokK7MU7FgYLjUjCQ90R1hE8EUEQyxrJ9YcPOGqXip64bk0EDwVu+fCPfTcDbbNYXDGc1CElB679/t9Qb2VIVLg7m2O2KoP2eHtMBGMxbYa9Ky2GBDtdq4vMAPi6ge6vPDLlncGnQRTfS1dRXXvweL+cJiGuSP8OGHFfSkr1wooN7GLwCLanUBd0bM7w9xAs/5EzQUIFMKHBpK5GreB9px0GehaXUwifZ/NZofkuFxOXJ21Rke6qYZX9cp87pIc5Xt5ijhAFiFLGmRN8qUupcZB4LZVcbmHWi0lyZckrGMcfk9NStfAqfCU3v6cPutL9zkkyX5LMZ6vmR20SQzhR+j6xJ8GeRVJDqg32mz/dQzAB27nM4h948w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(8676002)(33656002)(4326008)(26005)(316002)(6916009)(38100700002)(66476007)(1076003)(66946007)(2616005)(66556008)(426003)(83380400001)(186003)(5660300002)(9746002)(9786002)(2906002)(86362001)(54906003)(36756003)(8936002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8KGHqo9lnnwuH5/nIiktKJiLe46RU8fitQZOrX+e6bALFx62psWOCO0V3tdV?=
 =?us-ascii?Q?8+J369aBo3v35UL4kqCqWjwXwNtMSZxbCKjqDn1ZE8hECozOhrHHsYGTJTsD?=
 =?us-ascii?Q?wExG873UzozgExV2mSvkUUDiqIEuYByxSbeAVdeCPndaP6TrKyZG8P9HUFhW?=
 =?us-ascii?Q?NX42qOuu4lVAzE3jNU5x+RFYLe+AuJsws9GjCcVTYqDLdweat+mNiOFIRgUM?=
 =?us-ascii?Q?L0aYScRevbpwU0+qIxJmmkDZecgdDtnfM3/D+mu2MKUtp4qgoQO71bBdslMd?=
 =?us-ascii?Q?g4qxWyhFJtCU95vsRn5QWbY49dpsoSu6IDTOrqj3DN7ekSE6P5B35q4tdnr4?=
 =?us-ascii?Q?dcFcBc0K9aex3gz9FxwMLVZTQA1UvHi2CdbwbMH+uH5o+Q0WpyGCkOyrRqaj?=
 =?us-ascii?Q?roaQ2QYGQF2OcNn7KTjsSItCndprmqDrLCKf81/iRfZ9lb3avTYQQOGi4Iap?=
 =?us-ascii?Q?aLmrM6F8/QicFB4uLCSfjF0E39xoTIzdalMJO4Czl+ehori/lRbFwp/63Rn7?=
 =?us-ascii?Q?jnf2bYLg9J6KSIhjJaRfybPBRi/4xFP57nmmi3oN65Ftk9cT9laQ5feZoVAP?=
 =?us-ascii?Q?8+p9EKwDAkrFmhDPiiO35i6ZWDuAXxceHVPxqESnKOvHNgLlPJQRhFYqYIiC?=
 =?us-ascii?Q?T+0m2XmM7OwFI+OAgPrwhpPzdPMx1DjWiNFW1Kf8rUc2x2s3bkKI7p+5hW/x?=
 =?us-ascii?Q?KqCz/fyZ7tjAM7NjLBZDAKUZISMQLRGPWM1fyxsSQFCPg2dqZ6g1ja5tnsB7?=
 =?us-ascii?Q?ZAjNJ2xtHhadb258/9NWkvjGMC5bbSOyMW+/9WH7qD/Ebz8hdEmSEUU1Bx26?=
 =?us-ascii?Q?Q7DtagRcIFJhx3D/L+mxAmqULK3mjeBIIjJ+2+/l1swdLhDnQgauP7gFdyzY?=
 =?us-ascii?Q?6BA1Ah8+GqFSfQnz8rGusfvDbgWg6AYYI8kMtjYOCuHJk9LWn77WvCK/Md/p?=
 =?us-ascii?Q?tim4IJl0O7D00hOxlRJCW/myrx5Wi0+OSQPuDfagoJQRIaxdSmHAn2AZ8vf5?=
 =?us-ascii?Q?AUqYSN3E61MtzBxgVe7JYb3uHs814xPSuIMGoI19srXZ2Lmezm94GgEo00iw?=
 =?us-ascii?Q?xC9bTOO4xV4eMh64ycTBZSPElIY82ruz7Y9+4ke32veZGgFzPjj4UgyuJ/cQ?=
 =?us-ascii?Q?zvKSbQOG5tUyTOOBd0jQ7DEezOdJLH/M98hcZFpgZlJaqLe9kERWbqQU86nu?=
 =?us-ascii?Q?QhnYmjnMyIxR3vjJyuOwEWlFsV+H5xAsIEN2Zp9fYe+lVdfT8pzDIKa3nXDW?=
 =?us-ascii?Q?485AyeHcyEtrYnPgQQm+I5nAoswgjBhOEsmz40q/SNn0UCdrJ6hPFHng0ODV?=
 =?us-ascii?Q?d+i6AJ6yK9MNWp8FqB0x+L4B9ObNU4kZDGdFsoRntXVf8FC2noxinbUD+5Jc?=
 =?us-ascii?Q?gJQYVVtH2kwftUqHmDNBbAsvPMHMyVWcOJLUaoQE+vW3KuQS9tY5PCNpkVKM?=
 =?us-ascii?Q?LGz+d7Nw8+9OI0iU0MSYd09r5GsGUVLJTJtqz0WPR1vv1w2nSvDPPZGj4+gq?=
 =?us-ascii?Q?/5ydoqlugSEtAVNoi7QQjZGKbdqc60+CawqVpkWvwxcOgFTCVTGZHUr9wjO4?=
 =?us-ascii?Q?i1gupcwVBztX2rm2sbI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1ec671-c7b9-4755-cf27-08d9ae17440a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 00:22:00.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QCpo+Rx8XxGs+sNrE+pKsNBP4Frc/oQ9EJQ88ATOWIWVQc+bz0pjIhElWtr1+8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 01:31:14PM -0700, Jonathan Corbet wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > Provide some more complete documentation for the migration region's
> > behavior, specifically focusing on the device_state bits and the whole
> > system view from a VMM.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  Documentation/driver-api/vfio.rst | 208 +++++++++++++++++++++++++++++-
> >  1 file changed, 207 insertions(+), 1 deletion(-)
> >
> > Alex/Cornelia, here is the first draft of the requested documentation I promised
> >
> > We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
> >
> > Our thinking is that NDMA would be implemented like this:
> >
> >    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
> >
> > And a .add_capability ops will be used to signal to userspace driver support:
> >
> >    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6
> >
> > I've described DIRTY TRACKING as a seperate concept here. With the current
> > uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
> > change in direction this would be per-tracker control, but no semantic change.
> >
> > Upon some agreement we'll include this patch in the next iteration of the mlx5 driver
> > along with the NDMA bits.
> >
> > Thanks,
> > Jason
> >
> > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> > index c663b6f978255b..b28c6fb89ee92f 100644
> > +++ b/Documentation/driver-api/vfio.rst
> > @@ -242,7 +242,213 @@ group and can access them as follows::
> >  VFIO User API
> >  
> > -Please see include/linux/vfio.h for complete API documentation.
> > +Please see include/uapi/linux/vfio.h for complete API documentation.
> > +
> > +-------------------------------------------------------------------------------
> > +
> > +VFIO migration driver API
> > +-------------------------------------------------------------------------------
> > +
> > +VFIO drivers that support migration implement a migration control register
> > +called device_state in the struct vfio_device_migration_info which is in its
> > +VFIO_REGION_TYPE_MIGRATION region.
> > +
> > +The device_state triggers device action both when bits are set/cleared and
> > +continuous behavior for each bit. For VMMs they can also control if the VCPUs in
> > +a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
> > +TRACKING). These two controls are not part of the device_state register, KVM
> > +will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
> > +container controls dirty tracking.
> > +
> > +Along with the device_state the migration driver provides a data window which
> > +allows streaming migration data into or out of the device.
> > +
> > +A lot of flexibility is provided to userspace in how it operates these bits. The
> > +reference flow for saving device state in a live migration, with all features:
> > +
> > +  RUNNING, VCPU_RUNNING
> > +     Normal operating state
> > +  RUNNING, DIRTY TRACKING, VCPU RUNNING
> > +     Log DMAs
> > +     Stream all memory
> 
> So I'd recommend actually building the docs and looking at the result;
> this will not render the way you expect it to.  

Hum... It is really close to what I'd like, with the state names
bolded and in something like an enumerated list

But on close inspection I see the text fragments have been assembled
together. I'd probably try to make them into sentances than go to a
literal block?

Thanks,
Jason
