Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC89F7C8923
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 17:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjJMPwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjJMPwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:52:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65ECB7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7HwF8/ydbmAItC1JRcPyxn3X4fu8mXayzafVveCvIgTz/Rvwk9HKeyZZCOiJP2s4rLCk/biLTnKrqt2kwg4LYmjMvpNKf6fIn01KqP29yAz4uu5J2u+3NKr2eTP/TED+kmyu6i9nwmtCU8uBzSRriAr/J2nxefRpRSnxay3dnwG50McU70dgU9c9y/0JKwfVK0wChrofZh23H7kAhWWaWR41ek3a4S9diCrUG2eFzOUq57vML5WJoVaHhgkFl2EeeYAq+XUAh3SEYTmrgILUfpF4S7oSt/gZWJneetC93tZAm3T6FQ8yhTOQGidVz1fo1Wrv6bJ0bn9PPloFfpTKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7Ouqw1iUbAuTAoXATRsYk70TYP+zrE6Q+EOAmQmz1o=;
 b=UZDky3M5aoj1GSpNHQrCbZIP5Qw4xYrrnA+he/C9PSPT+Fh1r0+qn0gBgszh2Sb/XM2vOrjYXr4FD5f6lixyXbF3Qk8+3XUbMvzCdtSzigY0O8ZFXBWr0xV6r5GVkUiae9Q2zE14ZPu6B/D3aZ+uhJdLtUwkGQWs6Awa8S7W+s3CXSU3ewaWnb0PPiaimwUaNlFiHcjVzeZq1NdgE1+TPkXo43r3Y3gHTa0X6Fh0GuYXWnhl+/haJY4VOmLttDIS+AQNO/v/0vpHI4N49UGpdafm7cKZw5HOtjX+f+l6yMPj92B5HdP9v7Wp31j+L7BJhnBODJKKmHuH8fKWB6eTFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7Ouqw1iUbAuTAoXATRsYk70TYP+zrE6Q+EOAmQmz1o=;
 b=XOKSqT1M9li12M/fp5Ltsf0NL7RUv3NXcrBE8uswX/BWhDxX5G6ez5Bbqv0FJa1eFr8icdBfyb+uqn1DLKB0KTWRbjljdQ/xUK4nTc/7k4aCszr1D/ckx7zyYeh65MbfmeoGhCmaioXmjwEhAZngBbMX/RYLO1NcOpR+YCsIm7FxiR4XjCSzBKrd18D4NK4T5Phie15df83aEo/ePqCOFqdNtFl9UYbP/5O48JPpuF6VCs+t9iEU6nwgsoHrlWZ/cZUbMXqX3hBNuwxuXRw+VcUZbR3JCbPIGQBYLdW6/BAd3GJdY+qoJz8eKFHtXOczJN6oIQk7izz1Az+2TmNvcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.46; Fri, 13 Oct 2023 15:52:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 15:52:11 +0000
Date:   Fri, 13 Oct 2023 12:52:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/19] iommufd: Add a flag to enforce dirty tracking
 on attach
Message-ID: <20231013155208.GY3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-5-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-5-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL1P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0c2ef5-a9be-4a6b-848f-08dbcc045cbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDOQ5+2UbS+OKVvttdcezO2hGpAIddsHBD18KcbiCn+cbOknbydX1+EeToRWu0ue1M4Q89jFCsXbqj3FWIYWi+uPnwQpDKMZeOhxehxCT5QFGDvu4FerZohIzk2zEhIGyiYDtQ3dZJs0zFmW7IuOKb51DlgiGrEfStTMijgOxS15VKtXupJ6ek4J+Hwysg6Uj3AU2gzyHkDOz/anIf+LcesUztxVWOAnbvCORD0I+QhU3+zRC9mneVG5kzooqyduBQib7otw4clrKFpPZVUMRFSlu44QvkArGNHe9As+5pmC6jviOiawn7mYIpVqLf+/CMPDTCsGD3w3HG59MVAhhBNcKjo+Z9WJXB2GI07zxvqwFwL2LacESQR5/A+4NR2+4KJmzaTbHr3Gx7Y3PwVzwgJ6JS7gfF/DhjSit7gba7Y7bLtgND5+TtQDrVaPEfxP64rBCYLJD2KSha8UyIoBGrcyfviEJxg9OVrnfhcl5ne/W009rg0in+/idcrJ3epmf6inTcRmbHazEKMwFjj3bLIYKgf+/R0gvxquxLalS/r/871l72wHwiRq0Y9rhi+d5LHrP9juO47N0r7jhL++KixXRw1CtcnNKMM7pVIuECMGH8yIQgZZaJWxfDA9eOkcsoAbM64ZKZvRIFO+Xhn/0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(54906003)(66946007)(6916009)(66556008)(66476007)(316002)(966005)(6486002)(478600001)(6666004)(2906002)(86362001)(7416002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(1076003)(2616005)(33656002)(83380400001)(26005)(38100700002)(6506007)(36756003)(6512007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pXTdaG/xKBP5Rq9UTCCkZNQN4hjS/CjPmcCkg8sF9M3bJtbGTNvO7C3VJKiH?=
 =?us-ascii?Q?w4Z94yb1NSU35GoWM4yrXaPal2JndgB0XCdC++GgvYC6Vajr3/uGevb9wZyg?=
 =?us-ascii?Q?+iPAoQsOCUQnQDxGGML6cmknNI8PUbUucbPmqgpDHSleToMCKb6tYYSlpH5b?=
 =?us-ascii?Q?++LAgHRRRHm1ZDW4kdSDEow8eqs7mb/3nQ7y4/DVT5YEmOT5t5dBnkUaP2GZ?=
 =?us-ascii?Q?45qxg1dB18bjCqmg/tozxpadw4R7ZAl06+UOW3U0hvGPRM6nQk8B3YFkx7iX?=
 =?us-ascii?Q?xYcMfcb9kAuqDnvL/YukJ1R3jCR6YvcWfk7NUHpA3JiTGGkCVLnbHBbYM5S6?=
 =?us-ascii?Q?Y53tTOTp04KNefMyT15hQsoBaHH1FiJxBCfCqJZIhuu40CNJKj4WQYKoCM8T?=
 =?us-ascii?Q?vbakcyEqbkehJmtxC+ngckrshQWsRpVL1ns+0daeSVtVL2putELpjmDE5dre?=
 =?us-ascii?Q?WWjp+M9s9YG2OXVP4FHFLRDAUPYbJg+xEtuFQ7P6Vm11LcaVXbInU3zLw2O0?=
 =?us-ascii?Q?hO3M8RjG5sE5RECvYuArvPaVqT0DMPKWz2NwSu+LqesLpFMwIJDReezzPi0f?=
 =?us-ascii?Q?mRrP5rGw68xLfFU6uMhfLEiD/GaucYYCt/zS2R+KiR48mfAUxYdP+8cijK/V?=
 =?us-ascii?Q?GeGQEJ5ZaLsBIvkhXGYJYkrfNPz8RknCEDLxz184QhMdhx4vVWJz1OiKeLoD?=
 =?us-ascii?Q?4J8ZYsOSXgIc/iamkW7lRQBSYFtxOd8WwTBSuU0vpOb/S9hZQBNUK+Wamryz?=
 =?us-ascii?Q?QMgdJDifoiyuXJATsgHda4Mzb9tqqbv+H57/yykhF0T/enquGjWO09JAOGHC?=
 =?us-ascii?Q?qf2X59NZMoa9pShnHgruB2vKl9lWRFLLr9Mjaef6cPtXYf14YTpsMeHAjIQR?=
 =?us-ascii?Q?RopEV3EmYw9zmCAT4KElX6zpob5RiqI5MnAZUwwH1d+VyhbAd/ideNn9PrLw?=
 =?us-ascii?Q?rlmtjZt77MbpsE4Q67yGvve61QD4YSWNfBFtV15buP4FHccrfu31BfMoAIW8?=
 =?us-ascii?Q?/NcjqdBFBb/XLHwCK23fvWZ1Z90atHKI4K4pj9gUC1VYdXab6R0KxXgypJta?=
 =?us-ascii?Q?a7IdBFFo4lnH0FY+qb+2e1EinS0cPiN1wjWHx7SASZXDgKXjOyEJwBuU8i+E?=
 =?us-ascii?Q?vcFBSKycalqNI++IVdzofU5smI+VKzXoLeGzVMkBKYFXsnVQhwOo41N4SihX?=
 =?us-ascii?Q?fwjwP9pu5s5o6OTEGhGxCq4YVv2Z8Le7VBz12XvqX0hiultr3n4zvVLpUMy1?=
 =?us-ascii?Q?WVpw85Jeszf8ZN9C+Jo4cthWLg//xDWaBqBsgUwSovPpUXs7H3bI22RuGJEW?=
 =?us-ascii?Q?Pfz3NqHmsHrwJauhillulZdkiYXSgKBqRMTbmT2vnguWL84IaVRk8PkuIoHo?=
 =?us-ascii?Q?R76ky8Pmg7AT5v1D2cz2prISnYLP3zcjAR6G4Hdd2OEf4/UXNQ/+9M7vjSIT?=
 =?us-ascii?Q?ChDW6r8XKbO3RTb79e6Dv6iJ2Iny5qSOInt4cgkKCo8+B5MHHYcKSELoulDr?=
 =?us-ascii?Q?L93jlpKi/1A0K7Pdka4cyYbcwNsj21eZ8WxBsdeAsBeP2qXmboI8ghTkgQ2D?=
 =?us-ascii?Q?syYvKW4gXFn1+P4A6znX2uMoUWLcghGuLkJ0H/Ue?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0c2ef5-a9be-4a6b-848f-08dbcc045cbe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 15:52:11.3206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSbqcg5L67H5yfCwroN7HLN9LLnztpBLjO59yytuqp5LYYZGbKPUQQfCjMIH3t63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:24:56AM +0100, Joao Martins wrote:
> Throughout IOMMU domain lifetime that wants to use dirty tracking, some
> guarantees are needed such that any device attached to the iommu_domain
> supports dirty tracking.
> 
> The idea is to handle a case where IOMMU in the system are assymetric
> feature-wise and thus the capability may not be supported for all devices.
> The enforcement is done by adding a flag into HWPT_ALLOC namely:
> 
> 	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY
> 
> .. Passed in HWPT_ALLOC ioctl() flags. The enforcement is done by creating
> a iommu_domain via domain_alloc_user() and validating the requested flags
> with what the device IOMMU supports (and failing accordingly) advertised).
> Advertising the new IOMMU domain feature flag requires that the individual
> iommu driver capability is supported when a future device attachment
> happens.
> 
> Link: https://lore.kernel.org/kvm/20220721142421.GB4609@nvidia.com/
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/hw_pagetable.c | 8 ++++++--
>  include/uapi/linux/iommufd.h         | 3 +++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> index 26a8a818ffa3..32e259245314 100644
> --- a/drivers/iommu/iommufd/hw_pagetable.c
> +++ b/drivers/iommu/iommufd/hw_pagetable.c
> @@ -83,7 +83,9 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
>  
>  	lockdep_assert_held(&ioas->mutex);
>  
> -	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ops->domain_alloc_user)
> +	if ((flags & (IOMMU_HWPT_ALLOC_NEST_PARENT|
> +		      IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) &&
> +	    !ops->domain_alloc_user)
>  		return ERR_PTR(-EOPNOTSUPP);

This seems strange, why are we testing flags here? shouldn't this just
be 

 if (flags && !ops->domain_alloc_user)
  		return ERR_PTR(-EOPNOTSUPP);

?

>  	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
> @@ -157,7 +159,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
>  	struct iommufd_ioas *ioas;
>  	int rc;
>  
> -	if (cmd->flags & ~IOMMU_HWPT_ALLOC_NEST_PARENT || cmd->__reserved)
> +	if ((cmd->flags &
> +	    ~(IOMMU_HWPT_ALLOC_NEST_PARENT|IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
> +	    cmd->__reserved)
>  		return -EOPNOTSUPP;

Please checkpatch your stuff, and even better feed the patches to
clang-format and do most of what it says.

Otherwise seems like the right thing to do

Jason
