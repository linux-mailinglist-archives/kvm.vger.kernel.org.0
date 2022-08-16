Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C33595BC7
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 14:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiHPMaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 08:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiHPMaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 08:30:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C3677EA6
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 05:30:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpR8vu10vNlWTKCof68KQqlBh2vWghILapalkAI82+aPIwyLxpMb/cGGKTmuuXIEwhWljP2oAoNAv0piki5AYh+ZtG6ME+qy9HNawPVqJNk/e5ZeobbGgjTh891YpCOSCSR3pFzHjX5ePU9zU/LoGc3iRk1Nzz7RHpOMiLjsJd52W7zxLTvbiKPS12S+SJiSBmRY596+EuHn43OaVx16KjfL9672H7yOmcVSY8OjsRFtJIgWINcNi3D+jQMISG4he+atz1zv64BAx0RsJzsI4O5mG51evSOQwYBFCFvXzBUlfXGj6po0SuWIHsXYz8JvGwv6E+a2GCYs+POuRtcHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdqxUMGsou67lZHraEZhe4X+ahcO6NC+ksx7D4BIC9Y=;
 b=nF7vpkYU+SL0V3LM8oCrXKcaHMxDlZm9hDySRxmF1m2cVu2OdNzRoVmS26fh2iDR6p9i83XCfXvajdeEsqPIcNO3rxfgkyBXSwkM0OXS79B0a8wO7/w5bFbAy9c/TV2S6Jk1ULTvTUplg5BSLCfEqUj8f+nqTyY5jBatkUfFLa1bKFtvKfg9VlUO5C0pKQTCmdiNeIQDwqIBwe/yI00AEGS6BbROCbkCkvKIBndbYEE1SW5fWFPejddXTRKxmarhYwQm4sNBuW4zZdv1vEQUfWNz3ti9vA9ReqX/FjwnfLFPESeRZPIa+RaP0mgG+TmF1s7KKRYAzWNTZaPyu2E46A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdqxUMGsou67lZHraEZhe4X+ahcO6NC+ksx7D4BIC9Y=;
 b=swaCKWzgJ97pp2joUcY+UwvGlZvyc1NzpHQLJNSnZPZU8DGZYEYGO+vSZj6QqVEaKsu+Dzy77QpR8cpie+31wK2peqEu20bW4tEcGciTPquumLeCppIxz/3/dn1kz6g+ZwLXzr59U6JvdJU0SfBc+NZCuSe9hh6Hx3WlEnE6+Kamw/KjYW232LnIMRrUBGfKp7sZXVSCs+xIloV6mVpshiq5JbDqfEy1RH7YAPAUdzpOPeEAsR/zeqNZZRogJ/pin2dwB+T2C8nXsgRYTDGctojRJik/5vqK2ZhJumw0lev7EKPXLGsWrTwfqzz/ztqzzbQPVqhpE1esIgJewk66aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 12:29:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 12:29:58 +0000
Date:   Tue, 16 Aug 2022 09:29:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: Remove vfio_group dev_counter
Message-ID: <YvuNxRhOynTDJV4D@nvidia.com>
References: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
 <1e4626c7-4eba-d1d6-a85d-6042acd64991@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e4626c7-4eba-d1d6-a85d-6042acd64991@intel.com>
X-ClientProxiedBy: MN2PR19CA0023.namprd19.prod.outlook.com
 (2603:10b6:208:178::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 836a48b3-ecb3-43d0-a4e2-08da7f83086b
X-MS-TrafficTypeDiagnostic: CH2PR12MB4038:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DO4+eDsKLBzaF72/aQ4UKbjp5Hpm689v7XSJ9df2T8A/iGjy84yrnqmtwNbyGv3ljJZR9uue0Dp4qBubHBq1piMy8gnaoZCye0QdDvPAxzwo6Aves7a5Zv1TDsacl95eqtDHkOy6ubWhGkaqWhEAO/SF3y08rWN2r2VL29DJjBZR5+NEzbsyAYPqykxHm4WGOvFuPfgFAmv/VuO1/2zv/DFY+EwXTn9vAFpQ0cBhxbeBDUES/cXcPvDWS08duD0grT7MsH0ozbNOwxIdFON8fVwJMMT+zR+XRWRXWPSXpwEIAlUTIe1vR2KPYAD66RPKtngf+4aFxiRnj4oze8e4odsFy+nWLEoDonAwUEgaf+UpkKBHCG8m8Td4xenQ1f2PXFK6ecAVv9kB+WHbixYCLrNjjF5UBbWaQkkS8rFCpTdiV9OFhabBWuv7VPlen/z/mY8bvmEl0i7kjAx4Cg4Flf0K88V0gjCPBaPrMyn3+TC8LNirK2oP7ri3UBIlG9tDpBjlb323gbjvESKea98NaCkjs/Uhm510+Sc7uF81JUh8gswRiAs55hC442JZdGQFuKysgl2qM4PQK8kRaXmqw6HpcVdRApkyCuLQtewXTUw2x7JMY09K+TGeDD+wA9Yt5egnAWORxeBE+0gOfjxAQdmO1KglNWJL1xjEwjmLDjWGB83u2GNF2toWaSmYxBCi54Ta8Fa50BabUfl77SnZAlgDgZ2/yAD7NmVfpN3cHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(2906002)(6486002)(5660300002)(478600001)(66476007)(66946007)(66556008)(8936002)(38100700002)(8676002)(6506007)(86362001)(26005)(186003)(36756003)(6512007)(54906003)(2616005)(53546011)(41300700001)(4326008)(6916009)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/8FDldEAZp6v3aFad1gEQLm2hQCt7hQRxxxqsKlPUs1oMNJHZnBGkw/2PR9y?=
 =?us-ascii?Q?qNa6o0t/PQ1IC9m5WYXrhuYa4McVXWnp1iJWCmWda3cIyqjmTuBn3LChOfBH?=
 =?us-ascii?Q?yed55XuOXj1oWCgRytNM75uZDVE60ultBadOn+ar09Orfq4rI7hHjGhh9g/b?=
 =?us-ascii?Q?S+OVTx2IQYeppQS97RgVLoky1SKgOlnCpvJeQoWAOO0dWTJRVuN9ohPiYe+w?=
 =?us-ascii?Q?15r39PLOvG3zKJAYm3T11EDAPsDIDFavlScMhv35UDCXXkfMeDginAX+jgdr?=
 =?us-ascii?Q?ZEA6uWlXuINs8voM8bQ/C5IFrDlu8d1mBP4jsHIi0pEDSIGl6KPYgJXTJCUt?=
 =?us-ascii?Q?SO+djtyaU7ArMBMLhBMAEKbO7DE3GQM28kWqI066BhM37/XlXJtVXWG9suHS?=
 =?us-ascii?Q?cfj7b+PRhl4KULAXr/LD/MhhjnoZW5v1BDiUS/VcW/kEAdYa7z4K4oYqBX7M?=
 =?us-ascii?Q?MCS4s6WONp1kEUF0+DgjV2b2aKbA3nz4zTVDKTV9PghUK73rnGcqJVvuvBUv?=
 =?us-ascii?Q?/0Qst1CHUyeID01Wu6XaFx4bm7K7dJyxQOEsZ3ITSF2Dpvj8wReHuasm3tZL?=
 =?us-ascii?Q?n28kkOtJOK5aMADIcnx5v4WNvrITYCVbRI2uePyLw1Mf9RVfZeC9FoXam4as?=
 =?us-ascii?Q?WOcwZzH8UwzGEPf55SXj7V6/swCjqpRf4ITazYEPRoKfGSOxO2+i2HuNLGof?=
 =?us-ascii?Q?q9QdxFzT32Bzw6CBJcw8u+2AugfyguG/hfGkqTR/ARnsRrTilkpUNWy+46aY?=
 =?us-ascii?Q?7S3HPAG6RkxKEqRrmybv4w3xo+I/+3U1kk1iy8FQHPvIL6hQFPiZxnV3+2L/?=
 =?us-ascii?Q?bVeS2Ea34G3crNTBlzCU5TDLozM6GUBPNohGPCtQt488v+bf9uGQ05DUAPCX?=
 =?us-ascii?Q?W+JCqc0JApt5QnPZHsyLSmSBjPwbJ916qPly4/03aewtyxHkBkx11GtnsIwQ?=
 =?us-ascii?Q?0sjXEVlHKtzj3w0WfUKYP4ef3WIfksrdq4oDy93B46mwnFRSDtjn4MznFYT2?=
 =?us-ascii?Q?NfQDfTv17zMpSk9O6d9iPnp+sQAeYD3s2RKwWzFqsAav5KUwgjC+kaMFfqwM?=
 =?us-ascii?Q?ED0M4VNajkW+EJUiV5T08U2Nfjn2GrBx7tsTPwxtIWwe0snxBXzH5MvV/WK6?=
 =?us-ascii?Q?dhxTJ71qtjBr+gU/C904RaxjumdBOe3HmKKkKeGitIWwxlXIBm8t0l8clcNe?=
 =?us-ascii?Q?EmyLfrFrV8de+PeBU+7Xv3Gp/6sQJcs3wG9aldyKGuE+agXrC2mMRbTdCbHC?=
 =?us-ascii?Q?GKD2f0C/kGs1jgQIMLdgU/c4cIxQWNkJPt2tYjVY+RH3fdYeRYHHtkARuWAi?=
 =?us-ascii?Q?j83zQIpi/3bGGaHoChxI3u4c1rXqgCWy8FayiPc38nBLaRS8gpVANFbSurR0?=
 =?us-ascii?Q?xPqToYbhTw0NiyoFTTvNPRznLyeDSmiyCiJQzDk1sNhAhvYlPxVEj1Gks6nb?=
 =?us-ascii?Q?5V5hfbtOELcmGItFbhfskdJOwk1R5asEVtZfFDKYaybMnqMr6HV09ip8JMs+?=
 =?us-ascii?Q?EWOMR6o4MJAx7qgkFAJ1BfFPwSdT5Mt12nU5sWz0lg5dVIskcOESTF8qtYsp?=
 =?us-ascii?Q?rbxpwQQF39yRPVjDQ/9uCeEZckRDJnFDAcy5FSnU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836a48b3-ecb3-43d0-a4e2-08da7f83086b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 12:29:58.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykc7OwUe09gIzjgK1/xF9cvzdsmgwaPFSx+MNqbFPxlqL/xSa5e+D0+gVoj7e+3M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 09:21:05AM +0800, Yi Liu wrote:
> Hi Jason,
> 
> On 2022/8/16 00:50, Jason Gunthorpe wrote:
> > This counts the number of devices attached to a vfio_group, ie the number
> > of items in the group->device_list.
> 
> yes. This dev_counter is added to ensure only singleton vfio group supports
> pin page. Although I don't think it is a good approach as it only counts the
> registered devices.

Ah, I missed explaining this, lets try again:

vfio: Remove vfio_group dev_counter

This counts the number of devices attached to a vfio_group, ie the number
of items in the group->device_list.

It has two purposes
 - To ensure the vfio_device is opened
 - To assert the group is singleton because the dirty tracking code in the
   type1 iommu has limitations

However, vfio_pin_pages() already calls vfio_assert_device_open() so the
first is taken care of, and all callers of vfio_pin_pages() use now use
vfio_register_emulated_iommu_dev() which guarentees single groups by
constrution.

So delete dev_counter and leave a note that vfio_pin_pages() can only be
used with vfio_register_emulated_iommu_dev().

Jason
