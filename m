Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36F5029A6
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 14:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349874AbiDOM2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 08:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353407AbiDOM1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 08:27:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2082.outbound.protection.outlook.com [40.107.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F2F8B6E8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 05:25:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNJBQ+HyfUWbeRd6BXe1vO+Jd0Bs7eQPmtjwTSu+1MniuJAXcdZMUX0EwDET1VmTcIz0phhdf2+2YRfK4CcB87JHgmHUX8t2fKCmx6Gr2xx/XN1lIjR/gLmAVWuNgyMqWHWB0Wb0RF8FTvNNV3BUqytU1Wkw9NG8DQNKN3B/J01xa0XLWJ0f+gxqnapfssfeJcdFoHgT66kADYfkPV7ePwdrqfJtFAMoNeUAnGQJrl9NXxuBxM1RxRa97J7VYmOCK5IC4TxpPYpWqHsCnvEf1tPtQ1unpij/d7Q1aorS0gtYP/7CHZ/mNoiMB5Fo2zKrGHIao6jftpy4WjpatvSE0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDGtH+OSDFopcb/YXZl2YnuKfk2N5qz9UtcKAhHD8uc=;
 b=Wn3DcD29C7CEd8GnkvBnNGATF7JJw0c1mbsKLTL6bH875UDpkHujYAZgu+jDyfDiOhWccWkX8EnuqcPBkzPhJOOoQiBCm4B3Y7MtR8YOAsA9zWAdkcL48PA/Q4JlMFhB258lB9ygOiP+r+BwTmdtyxNGYhwKHoGngF8/ncTJ23L3miTY7SzZRbT5mabZtMc8rHKuSt28Yf6Pt+IAEB6O9wLvu6V+DQgsSTar6KEDxISfNthek11apCA1352ynsM3RgZPJyASQiTf1qAjdthKzGZt9QcVJbnCi3Peo0Fgsez5f1R0bSSxcOkjuhdYjG/59bX56C2uLpKm/URSzaFTsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDGtH+OSDFopcb/YXZl2YnuKfk2N5qz9UtcKAhHD8uc=;
 b=ee+bkKQrRJWRU/PnE6K7WEIIBRqwfMQgIK7/XmeL6fcev0zlIFlqd3wTYw0zR8tzMgRLwc3P2biP0RQKzhbStHjUVmAezy29xGl2JRxTIPWrmDUHBxNOFpLFdDpEx7qAdFXCMUcIM4jInfr+Yr1PM/LfoB13prxY3ewLjZm5/psFQlJ14TjAqPwqmKXJUAzYNGprK0M30x3xXhk10V9eEUJIQ6mqspHvyy+sGZIJFdy7VLDr8wy7zVijDTXrwbGahVmqA3pOcSmjocwimicYQt7vYWIZm4P3Zpk4TSr5KoEyHa9971Hc/zzC7GSjjKXWr9GFGcW2qNsG9WEbxed5ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4289.namprd12.prod.outlook.com (2603:10b6:a03:204::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 12:25:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:25:11 +0000
Date:   Fri, 15 Apr 2022 09:25:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 05/10] vfio: Move vfio_external_user_iommu_id() to
 vfio_file_ops
Message-ID: <20220415122510.GJ2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <20220415073125.GC24824@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415073125.GC24824@lst.de>
X-ClientProxiedBy: MN2PR15CA0015.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43750a35-b96e-422e-b904-08da1edafca4
X-MS-TrafficTypeDiagnostic: BY5PR12MB4289:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42893BF68ADF84722835FAA3C2EE9@BY5PR12MB4289.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0S0aE5DFskZjo4WGSJNSgotZWKZoXcc3Q39F2pKxQMntdlL1WMpe1Rs/t0U/I+rlVEF3v9A8c4eITBM6aIj+YfDOYSZdkzroVRJNOxdo6CMDUC1Q7OmrIaD41SPdDIQ5b+9/GmkOlU0+MvtKR8GhxRfeiGc5OcX2OpEU3oa+0ozm2yB+lPNfPR0zuSzxY/fW/z5e3XeqsUOxfMp9SOMC/Uh40dy3Xv52CAmewfK5t2BWM4Qbk2qFZLPL88solgJM7JPOv+TUJcvd+kaYLtgky2Dlh2u/ugYdzOLdieiRXorMQ6V6cqMQ+q728VPDFVGN32xoDShEgiDbVT4k+Z6AD7k0SpiV8PAIucHFu6EVySzCiNypdi7nklauOpc6aQqbo1HKGNB+4BcW+1Suwg7QtJqK1BDxL5emzacMCqyAJmqz1JEqOQ85LSdkMI/e+DJ6qUN2OjzDAAsU2WqBrnUo54lhj6pTMKMfRKRd1VVhNT8bxVtoWVP3u/8HYS1qBF0hQXLL6shcsnDuG1YMOUpcHGwLJ9UStMjB5GyafN7iGXrIG35+Gf6vhW29q2kmBt5T0KipGQhR74eTnkt5/pbvDxOnxK1ijBFxRVcwHHJ+IWqRqWDt71X3Z3pCIVvser2ohWx8cv1c7wJ7fdSbMpp8bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6506007)(26005)(6916009)(6486002)(508600001)(5660300002)(54906003)(86362001)(6512007)(186003)(2616005)(66476007)(66556008)(66946007)(4326008)(8676002)(38100700002)(1076003)(2906002)(36756003)(33656002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOEeI8xqBnKxlb0kBwzcRR6Kd3Qb4dByCOkM8kepz+mwCgkSMqXi6W5zMrv7?=
 =?us-ascii?Q?88ZB1/TceYV1Q6fk9pU6subgqGUhGus65h3MDT59nSgldQXuK7dp3ik1v0FX?=
 =?us-ascii?Q?PENjm5PFPE2wh7glyD/0Fkp+5Fze+o/zJf6z4ByF9Ff4W2yWt4aRZGMTCQl+?=
 =?us-ascii?Q?NMIsOf6heVy+VKdSppxWVQH+pccI1FmRcHQR54iEmLNWEBO3sBtRea9TjTNB?=
 =?us-ascii?Q?bL9U2K8D9ElwLRSALHB8iAUAXVeNTaTr1gO4G1+GE7I0teU6qAZvUHlSMQWr?=
 =?us-ascii?Q?IgVhe22SpDufVRvpAeREfxBw/oKbCBaakt7S8BniE9B0+E+pUJhCtl0jyaJS?=
 =?us-ascii?Q?k4mpdDiIjMI2M7+wZ87CIENWP/rlCk2kHF/kXNvy7LGbu3083oGPotmVJW9b?=
 =?us-ascii?Q?Yh8k3aoAG6g3NoH+KCFyALQVXK1iSXoNW35i1fdiN8O0fQ03/vwJIaivmdn0?=
 =?us-ascii?Q?WjoSGe1IyBQ9yn0e3wB4bvdfE3P8ooguWqLj+GjniK+GRscPZPTiciY1wzJc?=
 =?us-ascii?Q?X2NW4b7V+xU1FLTAMLmU+lzr4+gG6YuDC41DEb8RRA0ZUg1nCvMoEsnud92/?=
 =?us-ascii?Q?QIo24YxxINKFWPBAYL03xE03/3+tmraVtzkEYTDO+1Mzg7544+GFb75QnheT?=
 =?us-ascii?Q?08g1bPLLbJ48HrASVaYzfR/qe5FSXa52Xw+sWnYNNvnB6FtDOc8o7eYY8lMx?=
 =?us-ascii?Q?8UzHp+qfyhmgI0rYD8Q6V+A2P9xLk/Yb2q3lFdjGAOkHj6Wy0Fc2OMZkw5q4?=
 =?us-ascii?Q?wAxZjTRQHi/oNbcWSA6kQ0MMwqEGP9tE3ev3Uqj1n6bj6hmcFuBSswGawc9G?=
 =?us-ascii?Q?NGl5LEcnl5J/Scp8Mh28r6UJAVP5i2CULEbWmPsq/EIXS7pRKYO+aqv9+2EA?=
 =?us-ascii?Q?SzRGI5or5bRWthB8CxjQTYCNesXJ7pOS+A50wiBywRgNwNWFF0xZLV0SLce9?=
 =?us-ascii?Q?4pWidYDi+Wv7i9glQ/TFpCaKZjULiGnbc6eGe2mC99twXikbBTGEUCu3uFXK?=
 =?us-ascii?Q?W6wx9gnYg9gGqR7VPRLzB8ifBhhlWrhF0UpyT3F+AHACzrJ+C5X9R4vGnvbq?=
 =?us-ascii?Q?689enNz0cvImHCAkoUoPto9U8MJ3D7yU3fSlaMbCSdOwsQEwcMCDsSE9bjhS?=
 =?us-ascii?Q?0LCWayHBVfx1BbEkaESbnRcVZAcLrgRT+j5kgINC48PGuyTMy4WWsHZXAYPm?=
 =?us-ascii?Q?6e2eirXZWj5ekEDSuaSv5tM8Wf09yh6SM+pmrHQn3+suYdN9fiCuu/dutijl?=
 =?us-ascii?Q?jZr/NGhtLLSiYajZzw372Y47VlgI0K+6bTdGnTm/dAqVq0NUjbyJvNH5PJQq?=
 =?us-ascii?Q?oB2LWxzxW/5i9qsbucq4rJUWA5OXxdoYa7V9ZNSH7XgVQXdJu2u6MK74Rmp4?=
 =?us-ascii?Q?l7PSvdh4/2v1KgfcsqlIHRWCBWde0420PlK26seQN+AFLSZnLhyrVNq7GZgb?=
 =?us-ascii?Q?3S1N8RKYzJwJSS963OhseHWcPGchh+mjg+aQ3zU/Y9ogOpkkRoZ6E9GH/rge?=
 =?us-ascii?Q?dMk/h9U+QFHDdzuK1Beze7FpxD8bAbzq3w5O/Yk5xHj64xc/iDcDUQGLdziv?=
 =?us-ascii?Q?stTyaytmofrYq5CCJsLUE+Lj/cEQ3cSUeIF+l6RP5nlyZQy/fVL7rEKCqXS1?=
 =?us-ascii?Q?3QIxlXUxc8W12v1Cig3gLUBoF8mGhn5tDCT12bSx4Juy5ctE1xoSiztL5SeC?=
 =?us-ascii?Q?qnVWHMpr+33P/4VPU83+AQ+kZrZv4aIxmBFTEGXoXgoTD6gFZ/LwjL6NCySy?=
 =?us-ascii?Q?ZqgKWIxKyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43750a35-b96e-422e-b904-08da1edafca4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 12:25:11.7953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Czh4hm1IfIS8OGq5OyEteqrR57fhaGw8b7W76nhXNSLo38LsZCwgaWeD/vLn1ybS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4289
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:31:25AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 14, 2022 at 03:46:04PM -0300, Jason Gunthorpe wrote:
> > The only user wants to get a pointer to the struct iommu_group associated
> > with the VFIO file being used. Instead of returning the group ID then
> > searching sysfs for that string just directly return the iommu_group
> > pointer already held by the vfio_group struct.
> > 
> > It already has a safe lifetime due to the struct file kref.
> 
> Except for the strange function pointer indirection this does looks
> sensible to me, but I wonder if we want to do this change even more
> high level: The only thing that needs the IOMMU group is the PPC
> kvm_spapr_tce_attach_iommu_group / kvm_spapr_tce_release_vfio_group
> helpers.  And these use it only to find the iommu_table_group
> structure.  Why can't we just have the vfio_group point to that
> table group diretly in vfio or the vfio SPAPR backend and remove
> all the convoluted lookups?

The PPC specific iommu_table_group is PPC's "drvdata" for the common
struct iommu_group - it is obtained trivially by group->iommu_data

I think using iommu_group as the handle for it in common code is the
right thing to do.

What I don't entirely understand is what is 'tablefd' doing in all
this, or why the lookup of the kvmppc_spapr_tce_table is so
weird. PPC's unique iommu uapi is still a mystery to me.

Jason
