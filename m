Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CAA4A74C5
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 16:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345480AbiBBPju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 10:39:50 -0500
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:38729
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233663AbiBBPjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 10:39:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3qreNpelhkHIdRLcl+mcegwDdxWEFtyriThGidlGfZcRIUd+Nucb475BrlH0Fcvbnh46ED8O2JW4IeEsWofgH3ak0lhyusbTONyrO5N5UbsFQLMhimtgLOYnqiTS12OXephGUIR19tZTRyLwpnwKEZe2C7vWUObeSC8/fMa5upsdp8ziSHlqY4GKFcgeRrSLWs4hK/YnnE3FtfU5PkmInnjfaYASPuXEh3NYBCuimYCWFZY2+povRckzopbw5+u4yDUK6/MuJO7q5/4UxM2f1awwQvRNnWYISatmLsuQBLFYzoZcagpBMmdHqhw20AHpo3z67kkBPBQHpkEn2yKpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joc/QWnnJvGBCLRycoEcdiKv6QU+UyUvNbyskxvN0MM=;
 b=LbyASfqwCdcoWg/3gya0Mn5BtR0jFbHIYFtmmJiyez9+pLyx7WVV84fQDizS+MSaH647rtWEXEjXdfG3V68elvOMtPPeEeRMORpRFcS7iGxDjojdtGZCPr//x6sHj3OW78F4uB/C4rKmi8V+CyXiehMlSMoSy85WD/fcOO+MS+j+1ngGRq8kojo+l5l0olXKdJPkNDUpmrE86w7OE6Vlg0Nl7mGLn48OaMdNthzPB1HpFGQ/nU8GKwNwxDm3aZ5HIZ8jvMsHSNOmGaJ7ZOw233ggqYWe89xK309vxg0VRpoYH63wZvD6WIuhuJxZojcVSbaPoo0uWij4QKHpuAZyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joc/QWnnJvGBCLRycoEcdiKv6QU+UyUvNbyskxvN0MM=;
 b=HDBZsvuKauLZtc4EhxHsskQ99DsjV0xJsvEOArCjTC3GioqVBb7HDmEc7zXPFhibt5UhcxS09SoFzZ9iLm7RD6lyfvRYePPlLNSOHqq5jULrsPU41z27BFd7F3mLsf45RBPilNBR7HD4VaOsclQPoI6KcB0t1oy6uarvILTkSEwy5IYnMUTWJTtAKepercyrZGa9nOQEf8vT/vTmoMzOeO/UAyBHyhCTI/KuFAUZNPW+upObo0Ex3bxDOTzu5b1/n27uwk1h9RDWvjQXedaUguVai0PF14M7XuymIIdiMVlj8zRM/45Ax12up0l99fMFigo+IhwZri5DOWbYaKTkhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1180.namprd12.prod.outlook.com (2603:10b6:3:74::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 2 Feb 2022 15:39:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 15:39:46 +0000
Date:   Wed, 2 Feb 2022 11:39:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220202153945.GT1786498@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a29ae3ea51344e18b9659424772a4b42@huawei.com>
X-ClientProxiedBy: BL0PR1501CA0021.namprd15.prod.outlook.com
 (2603:10b6:207:17::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c264ac89-5b12-4d60-394c-08d9e6623db9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1180:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1180611BCAEA0D079C1EB3A2C2279@DM5PR12MB1180.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhwmnZY8fQU4/rBMQK7dQSsY/9f2untOAeUAmh4KC7PuOMm0vqosGlL/EBp4415pVfNvAafbUcX4SpHJqszk+OiJy31luEOKQv9Yo0VNZoiEcZur2q9nr5v5o1/LAVuCD6hB7b0j8dy5RlYSxmBd3IuR7WIF7qkxCEcpC5Y14ZSYhY/rHpfhlYDqOMUPnqL5iA8QW272ITzHL03RJqzxylaTqxVZRvfHK8QincRmUc4Egwh1Wn5dFhFTg+PxBhmjjWwHLx9UPUKJWe26HnlDhUGhyXqjO9n3+oz2PvaQdGTx/Q0P/7A31ElcZu7wg1atL9VcXN/j5Ded4ckIXzBRrsDJqKYD6Wjw0BDeJ0nRT5C1OOHfu9UGVBZ2iBxCwlZdbIU8+wF661XYqXEvna5MjRJx/nbYx7As3fW2UOBU6z7bPRpBYqeW1EcX/v/+NygYy7fzXU5eUlpmpnE56IZmMzP6LGF/v6zQ7oOXA8ssE788W25yBxvc6ZJKuuptXvbIcGwVqnXpe/3bYFurTkf+zxNPnJv0Ii++9ilKJkIbyVxVyjJX+uIIjp0TtqSGRaa8c9kMKZpOhHnZ01NGn4HTfxy2EpPOzUDxIp/Q1LUj3fJ5UlQZsMloI4oK16DhcJ1yFEbWVRjZwNAcv5qnK1dlOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6916009)(508600001)(6512007)(38100700002)(86362001)(316002)(36756003)(6486002)(66476007)(66556008)(26005)(66946007)(1076003)(186003)(83380400001)(6506007)(8676002)(8936002)(4326008)(2906002)(33656002)(2616005)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q5DChHyFhR5NdoFrnTu7PeEYvET8J0v26W3uPZ6vKejwNnciLraZ3fdBwauV?=
 =?us-ascii?Q?nj3SF0JshZuSQgqno/o0nBz6AO1UUtYFxE/0whApnypEQX2F9yaHjYtyURPz?=
 =?us-ascii?Q?xfVkaDequIckICBrDYrx/M2Cm0W9vHxDGiquIytJGVG2UvYkLhuEzgIuGm0/?=
 =?us-ascii?Q?6VJBOkNWj0SA0YiISVd9LzuX7KPjd3o+Oxl6a0RyIpwfrCgw3dnW3Z9f0fvt?=
 =?us-ascii?Q?GwI1BVVQ1A/qqGn/D2/SIRCCW6MmpJ5KCtaLHl6p8CQQjR2iyWnQ/62m+pze?=
 =?us-ascii?Q?fx7IDrTyDErhcO5eWC2oMMSotl1MKE4sYXXep+uvElB9nOn2EhCav3ZTHlxt?=
 =?us-ascii?Q?GeREtlDM2IlH+L8dtX1Tg90GQ/N/gUXOau7d2i27e273i801u2XsQYZCUW8t?=
 =?us-ascii?Q?hG0bl6hiXDKAT7umO6qahCr0qbF3wrThUeKPzTuJWe6+I4rVU8cx2ulP+lDt?=
 =?us-ascii?Q?U2WKYARrvB+6xz+1RGXMvzAmpeEMVvWNrAOsdgF1gljiQQn7I0rDFIuCInMV?=
 =?us-ascii?Q?MCyYOHvggbmys1uScfRiO+Sg6HM8qEcheAtGn3EoUj/kzYaM/ZiusJjRKEDD?=
 =?us-ascii?Q?P81dmSHUdI5XLwyYjk58FRtcHdku+xhnrrlPhAbUuYVMRh3LiaFEAkx+7WEJ?=
 =?us-ascii?Q?Uuc5zfy9a9E9vuYCzaTe1cOupgS2IS+rRiv2/27gqnZIXc6KBBTt0PaI38or?=
 =?us-ascii?Q?duzFbEbA9bg4Ck4dL7NOL2bFoHMuLwontRBK6SFMGYjz4xOZNDLYybO4iXO2?=
 =?us-ascii?Q?75LCDIOD3K2qPVpXDhl76UEmJaKuQDxynsLt90ky9sF6R4/0Zj+PJsn84nII?=
 =?us-ascii?Q?Ch0ofawwrO1GxKBg6bVADP5aJucLV1SZ5Y7QnJf3yIUiWl8GCQpIrlDIdtKx?=
 =?us-ascii?Q?FfT2T70Bm3QbuvedzJIIHUlUjnTFFeoow9R57B6rtljIhSfmfE63pISPIMwZ?=
 =?us-ascii?Q?JAtF+7r1kZv5A4WWF8Qq1NcqCim7+USUTxmrd+MocO6Ljj8bnQ2gyccSY1Jk?=
 =?us-ascii?Q?6l3HGxMAHF/YDdEITpwoZRDdGSxnF/VykJ2vLf8W8eaYeaM6/6obptL+6FVf?=
 =?us-ascii?Q?bRfToH8kFFa4INukO57BunK1HMa6NiS6CvTSU1G4zyYq+137VbD6t8mUY/rZ?=
 =?us-ascii?Q?ndMnSwKNz0ycxZa54gK+2xDFF79YRdLeM+oymFc/IZRRpkjejIw3KYRnquOe?=
 =?us-ascii?Q?9G9Dz72eIDf/kO7PZh4GDsifhDKv/xQI59vo1v8YErWWMh2VBpKKn/KoQTkx?=
 =?us-ascii?Q?1LTKcOR6UhmvBCSYFf3aYtVw0hk15XotTkrZ18yNoTC/NIA7ofEx9CA0a2G2?=
 =?us-ascii?Q?rdQ7cicdPubl2OKh8eovTS2aCIlmYmjqjr2HVufx//rJZD9i1uljxQk5CJeV?=
 =?us-ascii?Q?ug+HaW1VMEJP5yxiUSrGQO85IbtRgOGKSd+iRHDtvNQC/KQLdkgCNsCL5KVk?=
 =?us-ascii?Q?5HDdfzrCbMv9B9kSulTC4qkGyqn9q9O5Khc13we3snimJQWIUne+e3QaG3N6?=
 =?us-ascii?Q?UF/GjOm3RhnwgmgFMSzEjkM1r1q/bi8KA/qVRR0fNm8MMoJNFiPm+rOcQUUX?=
 =?us-ascii?Q?zlN58axWb1n+CWNIyEo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c264ac89-5b12-4d60-394c-08d9e6623db9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 15:39:46.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zvnk/wK2FkyRt8qSqKtFUtLchRyeYmsEKJYkdvMlbuNBMxHrZmV+N96MsdMcs2Ik
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1180
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 02:34:52PM +0000, Shameerali Kolothum Thodi wrote:

> > There are few topics to consider:
> >  - Which of the three feature sets (STOP_COPY, P2P and PRECOPY) make
> >    sense for this driver?
> 
> I think it will be STOP_COPY only for now. We might have PRECOPY feature once
> we have the SMMUv3 HTTU support in future.

HTTU is the dirty tracking feature? To be clear VFIO migration support
for PRECOPY has nothing to do with IOMMU based dirty page tracking.
 
> >  - I think we discussed the P2P implementation and decided it would
> >    work for this device? Can you re-read and confirm?
> 
> In our case these devices are Integrated End Point devices and doesn't have
> P2P DMA capability. Hence the FSM arcs will be limited to STOP_COPY feature
> I guess. Also, since we cannot guarantee a NDMA state in STOP, my
> assumption currently is the onus of making sure that no MMIO access happens 
> in STOP is on the user. Is that a valid assumption?

Yes, you can treat RUNNING_P2P as the same as STOP and rely on no MMIO
access to sustain it.

(and I'm wondering sometimes if we should rename RUNNING_P2P to
STOP_P2P - ie the device is stopped but still allows inbound P2P to
make this clearer)

> Do we need to set the below before the feature query?
> Or am I using a wrong Qemu/kernel repo?
> 
> +++ b/hw/vfio/migration.c
> @@ -488,6 +488,7 @@ static int vfio_migration_query_flags(VFIODevice
> *vbasedev, uint64_t *mig_flags)
>      struct vfio_device_feature_migration *mig = (void *)feature->data;
> 
>      feature->argsz = sizeof(buf);
> +    feature->flags = VFIO_DEVICE_FEATURE_MIGRATION | VFIO_DEVICE_FEATURE_GET;
>      if (ioctl(vbasedev->fd, VFIO_DEVICE_FEATURE, feature) != 0)
>          return -EOPNOTSUPP;

Oh, this is my mistake I thought this got pushed to that github
already but didn't, I updated it.

If you have a prototype can you post another RFC?

Thanks,
Jason
