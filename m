Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706C26408A8
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiLBOoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 09:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiLBOod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 09:44:33 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08603AC6DB
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 06:44:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNmuW6kxvY/7DZe7tmhq6TFSxPdGtcOQgbJX6DJcReIquUmS0rIZA5kUR/5ughpHxg4EWUhEvsenQ4HuWtG8sCcL7cRplv2leLRgZMO/F41GbhgyyOhVby99l09/eEvho7/5Pt4EoJxOVD7rpttiCf7F3fJB9tsylQLN9OFNez618/0cDAnIGFdCJ3nP0PkVvRs+x0yWppUaJy81zUURMxmekONvnVXi88C9Dh9zDlu30WM/aDgIekI9VrIdTrlJkKrlc9B4Zu1SZHRg7Vt0/uPv6aD6S99qOXciroW1z0kkVsyrAwY7SmJOcZsHzrE/SyAjRDd5SRpR2pfJoruG6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRCXwtR3pbQwISt8erzRNdtl93Oqzop2zVIQky1MglE=;
 b=j9SJ2EfZuFRiygdTtswD8CvfQuooaL4VQMQ8A6J3ZlPIfsZmxH5kIMRzIXSGoRGKGADj2Hk6iSSeziN31JPUn8yMypzoUoMoiqfKo5I5MuG4szrW5+CjbdqGd9Q4RK70BbxDIBSGi/3hPXg9ZPAZkt8Ql7KGq6jtsdRWS7GVkm4jnidvTQhuhtsCmFvDAm85lU3jp/Cegf4n5OKw5nTXZ9qKHHDVMCmIRB447STCQUF4dZ9t7cbwy/znD4yYBYXk2yC9RSh02OuAYm1uBLHrZWjtlWNgl/5reMVYqyYpmT/cyl9LSNZKRchSpLhK3/N/U6Bus2kCCBjZzQ+rnpozyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRCXwtR3pbQwISt8erzRNdtl93Oqzop2zVIQky1MglE=;
 b=NmRlLrs4yQwASyCrQeWfX/db9LU6Kf2wKhlLmh88nxOyOYYQlrpxIa/fW0oXz9i04N1gPLWDor12CBUbU5kOOE43Y05i+ocA2yKb186zWknduuuocupjgcG1RMiKuAz3XlkouVaUp/Ft/zCN84ilAGDnRj+7euKlKYEjvw/2uO5awtvNO/az8ibPGdTXcvWYQtvO/PySj/D0c7Lo7cK1w5wY6tnw9gSmGKYnAKOERBtWl0orRG5QlFP8jC3XsdngAFvFTvWfRTjiiUaUeIrYxZVJa3GdWgzORvGSRIS3P3+AKGOP0ULjhY1KQ9igOb9MntroEy3gDlMStlhLFGcyjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 14:44:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 14:44:31 +0000
Date:   Fri, 2 Dec 2022 10:44:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com
Subject: Re: [PATCH 00/10] Move group specific code into group.c
Message-ID: <Y4oPTjCTlQ/ozjoZ@nvidia.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <Y4kRC0SRD9kpKFWS@nvidia.com>
 <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
X-ClientProxiedBy: MN2PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:208:d4::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4299:EE_
X-MS-Office365-Filtering-Correlation-Id: c16365f6-4495-44f3-2fae-08dad473b897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ozovTicE2MiCPP0o5bQ8U2EK0kcUY2NWSy5DSqyRbLdjwtUhGgbe+jAV0fokx6lGjb0/fAV3MmXXxHXdMn8V1IUB/QDjrlaZwhCXYqdt0ROM5kZIDcVXlJDH6AUPhXNZYrZMhcdObJ00JsvdVgtZirLNgSHlCGg8yhFogGDCi0Wj4nRkytbj5p3O2ncCXQDA1fS3EgcYrxTdALH9rlkPF1rY8UK/C1UeQplQkSStwAS+fR+AhkmeTLQ86nhhP9MCZ2Vw/DBUaX99iiJ0avIZzl3s1orQAeU4+TMxpCuNefwFKdMIGsOqUhoDJtODvVggVrb3dZZD6CHzp5qctUYHcma3tg3Vgcv279mRmEpzuJ4BEgkJ8hw0euSqzjex3iszDjFufhEhN5xN32fzovzm0suLauQZ+HRVHelfrbNuHaqNH9+Ovx0mJ4jp84zxYphuk1DAZ/Qj69kLtEQnUi0dfVFQ5jqWUrUvk3YucItX8hvIJWcb1GukhR/F+7R6yHnI60tzhRFlwx/P/a2UQJgQTf5PlaS55DpYJMMzhpYAESsyNLso5XN09VLGgcqStsS0Eh0JBNyR5aYJXRLp18gtqnoqP0SNjoMEdERQgDfn8cs/EqwQqt7A8mYER1KY1vrhBAzfE6lzKnFmtMI3ohlo8DJ6mCanqBeiwxjwJnioJ7AOXmAngRYijWLL/vV/AL9nVp2fz9P0KVJbI/w2ck+RLXy+XRkppgcbl6vgyOejhFxhgcCk9gBth8lG5auFNUv5BrptkbhYEFMwJ+Ui9rNYZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(6506007)(53546011)(966005)(6486002)(6512007)(186003)(26005)(316002)(478600001)(6916009)(66556008)(4326008)(8676002)(66476007)(66946007)(2616005)(41300700001)(8936002)(5660300002)(83380400001)(2906002)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBxMgsVgF5a40RyIERX1rpbQc3EkoRrUIxju2BIlnaGyPsoNClPdN0P0CxoE?=
 =?us-ascii?Q?jg0ZDeLbjk+QsJKRFOoSXKKqOzqEgpYBswebJXcgEXIuoiTR2+2cbIr0ZAFz?=
 =?us-ascii?Q?h2VtQngrUgHykXwcNbaxTP29n0I/1pgVTbqFFWLcFPeTlCghmnTsOxsG0tQy?=
 =?us-ascii?Q?sLK10LlTeOcGKrkTU7j1BK+Ca+Esr4x/snvycfrrDBrLuZdFHXMCcvm2zphN?=
 =?us-ascii?Q?F/+IHLH/prlpfJnbG0TgHECSjKPlqDq/qB5e8rohrnUDGI8fg8iYx3yUh1Ok?=
 =?us-ascii?Q?trdWcgipBZxWjrbn+l5vnjMz33L80z0lvm24Lij12I/ticMPROFaE94vPOkB?=
 =?us-ascii?Q?meuoxQRnqS/wY+DfjlF27VgpEQ+CEhJz21MmmSIwMWh2VnoKl2NymdxI8qT+?=
 =?us-ascii?Q?rNRexMiO3AeRaZ/A31IH3+AW08uxMB0EVqSZKCwMn/Av2xVNvO7cCUm0N+zB?=
 =?us-ascii?Q?LqGrRU07pjwR0m+1AQW0RDPQpHzXrQYRxCVpfXYCDvEtGbNNfy4s4klCK+Le?=
 =?us-ascii?Q?VrML0RX3Ljcc8DQQZeNocR2BrFwab19TDYwYHhQFesnpuQHblAs4rguRzRrd?=
 =?us-ascii?Q?+9aCHIRBzqkcZJYUmHHkZ4K++HRlYlxqf8exi23E+usZrS8lnT+iB8GkKr7i?=
 =?us-ascii?Q?8e2lL784LPo2FJ2aT4aw4EIwImLDX/WkY06A3M2gFcnJHDgqymMgpZ7beg/R?=
 =?us-ascii?Q?ehqnDgEZIPkdBKq84QnFHazVdT2xAqSlRogVM4oGhBTpSViRit2PkO+QDb9I?=
 =?us-ascii?Q?jBoqW+vkoUIiUex8OXQ4yx+0+KF3jNbBU4H9/blGju2UNj8Xxq2b8opzNg3e?=
 =?us-ascii?Q?WGvjTCalDSNQi4S6tucY0hYcoel95EPEhUEKJBFwC+c/tmmKnL5ZwJtBU5oI?=
 =?us-ascii?Q?l0GucCQcnp7xM0D/tJMmX+R8VwEDHi7prH3z7IWdLN2papz9oIe3iQjoj+MJ?=
 =?us-ascii?Q?GhaV9Y6dlnWfl7MYesgMigJ5OWWzC3Pv6lpPsMuE8d6zDxmxc/MXZbBcjHdX?=
 =?us-ascii?Q?tp/L1Uztpi3IWRiwJp77I6SYITUs/FLs6Vl3VWskf9/3dPuWWxYgQUyniOn0?=
 =?us-ascii?Q?s/6b/8YRUpLfT0Ylov3eP+muYfppygUMcclF7w/ofWBIPgO+yQowvU4Iaphy?=
 =?us-ascii?Q?5b1BV/K1djA3p0RcoQtAqXzW5UX1erWXJqGfoupqD001+cxySn3T+MfoFiYk?=
 =?us-ascii?Q?kbqQNrTTGv2dfOtdBeUyWA0BHxthFn96QcwzFWy4N9EXwoPpQyHYC5S9tGuM?=
 =?us-ascii?Q?v2j67vL3cai76ZA505AixYo/1iPJeQk3qNW5OrG9yNj1cEpVStc4K6O/c0sA?=
 =?us-ascii?Q?PWqtpGOPK8D+ZOmkqcT0PtAfj8nPt9PXZPLQEajX4sF0dSgxE9fxLfOZ7PwW?=
 =?us-ascii?Q?TT2KJp200eoX3aLOvwpFwFDMIeLQR11zL17xDnzY3PXtF0GTi2R1rrgJt2Wv?=
 =?us-ascii?Q?ocTfOC2d5gh7Iked48RmN9HhB9k7ruSrGPdqiE1FSDC4ffC6nv2a1DBtvYE3?=
 =?us-ascii?Q?dfSUU2q1iQOxfDNfqC1oW5+Z1fXwwXBEfHocoJQY7E2+ltp+FOARqkzF56Yy?=
 =?us-ascii?Q?ozK9BbpU+D4rf13yGyQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c16365f6-4495-44f3-2fae-08dad473b897
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 14:44:31.0527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fuz2MwwPazujnF8lWO2Dy4UN+hro8jO8Z7CfQeduwjLeDGFUDhlr2YFTduzd01hf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022 at 09:57:45PM +0800, Yi Liu wrote:
> On 2022/12/2 04:39, Jason Gunthorpe wrote:
> > On Thu, Dec 01, 2022 at 06:55:25AM -0800, Yi Liu wrote:
> > > With the introduction of iommufd[1], VFIO is towarding to provide device
> > > centric uAPI after adapting to iommufd. With this trend, existing VFIO
> > > group infrastructure is optional once VFIO converted to device centric.
> > > 
> > > This series moves the group specific code out of vfio_main.c, prepares
> > > for compiling group infrastructure out after adding vfio device cdev[2]
> > > 
> > > Complete code in below branch:
> > > 
> > > https://github.com/yiliu1765/iommufd/commits/vfio_group_split_v1
> > > 
> > > This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
> > > dma_unmap callback tolerant to unmaps come before device open"[4]
> > > 
> > > [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
> > > [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
> > > [3] https://lore.kernel.org/kvm/0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/
> > > [4] https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/
> > 
> > This looks good to me, and it applies OK to my branch here:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/
> > 
> > Alex, if you ack this in the next few days I can include it in the
> > iommufd PR, otherwise it can go into the vfio tree in January
> > 
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > 
> 
> thanks. btw. I've updated my github to incorporate Kevin's nit and also
> r-b from you and Kevin.

Please rebase it on the above branch also

Thanks,
Jason
