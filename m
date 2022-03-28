Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E284EA0BB
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 21:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344131AbiC1Tv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 15:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345663AbiC1TuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 15:50:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47284112C
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 12:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kv7QI1lXWFD+J4a8ylFZYi+YJsgmP/5zM1OogT3QuD27Z/yEtpIkyOY+oMdHeaoe72Kq89VO8ZbWmlhFdJRjhUIkOqml6U4RGQRTZQ9ZVqXITyDEYTeSr2HI+bfNxznhbVpWJ87H0nLgQ1eYct5vu0P//TvZu0rg9NmtO16dnWxt0H6Zw78xoVpeNNRwf9RnuaKNJL0kdMQ5KNjKsU+67VsljJxrPKmckUIJeCvl/IhEjsnuQTN/9BaxvYL9zxc8oKFqnBgAESpy7QYB5QOeUrbo4p9+Kdcqv9atJOJ8FgxysjTdu5QNb1g8z/6XwAfrSWxZWEdPMTpcAC0zvD+Rrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fhQznTWnsIYpiz/BVgNfIZ8RJkswgK9lYdyJsqZPLY=;
 b=n4Uc65R/V1NreD+NUJ4LsoK+oRtmKQfAkZdevmpfYuuKVSq3wDQQwSgD6iIJYD5VVRqpvOy3mNpwCnDtrvqk0wM9HQJ02qzOLp2lBHCr/GuR5tqynKaXNRylXeYfq3NAHowEvxu6mGGqR7RSdqvFNBElXnggk8VyRRKXGKvV+OVTPimD3OWPhoBw75S9ptKQjeaC/hov2dTpZFM6yew5XOnEE56DB/wAuSms08FqaJXQEbm+TBOUVicjYdcGB8PaJisBcqmsxG0BhKrmySX4QwiSi/2xIzOmn/VA4tMLep8mhpDusNo5Lqe0rX5pJCWi7Wr1WduVUqy4OCps7+ZcJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fhQznTWnsIYpiz/BVgNfIZ8RJkswgK9lYdyJsqZPLY=;
 b=mjLz1C5bSXRAZWcRQsqztxfetMWwB3O4tsTqn9o6c/MRVcWK1PHfJM/0sEYbMt3p31ZTtwIV/FJSGYOpIf6DqJ0JFWAelC1pjkhCLyoHtr3aehsYqvIZ+37n9PH47nKOM40jCqi8CplUHakd6iW6o/+tDzWZJHO0zQOYIITm425rC3hkkS2XjrHGAUEBHJcghIk5QB2D+BkqfUVRFJRSJ9vlqnNk3FPtMEMoFCvBDJYCQm840tM3vgjeNVYL+PjFgaEYbVGoD3VUgfcEikkxm5/16q2slyuCp9gKrJRj5wycAUcS+X56fben3DA4PXgFTtJ2w7DSo+k8NSEedW3Rnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB2900.namprd12.prod.outlook.com (2603:10b6:408:69::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 19:47:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 19:47:51 +0000
Date:   Mon, 28 Mar 2022 16:47:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220328194749.GA1746678@nvidia.com>
References: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323131038.3b5cb95b.alex.williamson@redhat.com>
 <20220323193439.GS11336@nvidia.com>
 <20220323140446.097fd8cc.alex.williamson@redhat.com>
 <20220323203418.GT11336@nvidia.com>
 <20220323225438.GA1228113@nvidia.com>
 <BN9PR11MB5276EB80AFCC3003955A46248C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220324134622.GB1184709@nvidia.com>
 <20220328111723.24fa5118.alex.williamson@redhat.com>
 <20220328185753.GA1716663@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328185753.GA1716663@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0320.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8871fa3d-2f51-446f-55a6-08da10f3d74b
X-MS-TrafficTypeDiagnostic: BN8PR12MB2900:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB29000BE3FE7CEDDF9036D04CC21D9@BN8PR12MB2900.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ehmf8r9rcTgG5htAEaqLJ+9Jh9efi9MigG7gh0JIwRaADjFSB3KAK2bSaaKKFtoBOjpMsLtkT/7AphvxtebcCIZhUb9+7rUzUgZPciRplOT/j4vK6Aos48vkJbWi5I4V6WmVY+61CQJceW7Tw4qaa2fPOJ0yV3MV1/Hu2FznPEch/B/zGAkJB69Fwi0whbREczbP0rmIUl0+f2lrtHOQXrz060DQxLJUzDrHM35yCRbWzsYmIKb1KfA8M3PeHKMN7LCJ3w8iz31uOOgMusrGsqk/tYUX8TtHzEDBFsgIZqaECVxk7E62BADVJONP7Er04+PAM02J2nNqpsQFrh175WzIPyUwMVpQ2ujx3wv9xHl155lv+x/k8a9doa9vW4beLgoENswDqBi6doGvQk7Mg8wfG2qa1vLpaDc0uzo8e+HQkpskzkQzinW0x0tBhW1FmUEy1ylIRsfrp+uaD58tbGFCBIxwl7dxkvq4pHRWuvERwK6Lgr1TphP8ZN1E1Oqk+Cqz2At/f8eibeaykJvuf/IEQN0Jej3tmbDpJWdJjDzSx8YqSk+O5cEmXrhaBpyuv41bQqTY79yq3KBTr0w5R5k7NBnkXHCJNEJObXpd3Z2acGZgr5tiBbIsMd6aqmKiPOkuC+0071WajNjkCGtXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6916009)(38100700002)(54906003)(316002)(66946007)(66476007)(8676002)(26005)(36756003)(66556008)(186003)(1076003)(4326008)(83380400001)(2906002)(33656002)(7416002)(6512007)(5660300002)(508600001)(2616005)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pqGiuR3wPoTrd/M4dv8R5nr0+nxQBN8E4+78dB1apGMoyP9b/g77QkVbmBeK?=
 =?us-ascii?Q?RVEKLiQAKogi7Tcrwy3fUjxJKk+fAtGLhtOwhoAzFeMNIIa34+uZ2aSAF0fD?=
 =?us-ascii?Q?g28YuswZZY6OFdQpgs4P15fWSViHVK2yucSCMPI42V7RdmGN7QfgFSjtDPu8?=
 =?us-ascii?Q?aKLIoMU+Jyg9WHji/J8fy2S0ySWmaIxlAsY5kduZRvJU8DRWKmbmBI52DDAf?=
 =?us-ascii?Q?h2QflKoNpJINa9BgqOILICIY9zpr4fuy9kXmpfvuhr8BxntNAioxIbv0xS3x?=
 =?us-ascii?Q?41yR7Xxgx93v5kln/1CvsyLj3odZfwnxqmxSz8qMcgtRGWrAjrlpDd31RGI/?=
 =?us-ascii?Q?ZV5V6TTnVMofnrkodAs3fI7ec8/ZJj1BAyAVlaVcsGoXwcyLf2rBz4LCcFoW?=
 =?us-ascii?Q?ILKU/7bIL/xl+vFx1yythhZmYQDQ1DknEzySRV+fm4nqM/TdyKgquj1jcQXj?=
 =?us-ascii?Q?Co06T5uC+JO4Pyzg9pQteTAiMf471uU6yBm0tv7qzQVJ27iANEGvNQ+enEhA?=
 =?us-ascii?Q?L6wSzfZ0i5RS9Ex6UAfP1ghDWk78QIV/t/C9Nb+HF27likKT8VYy3LohHRZp?=
 =?us-ascii?Q?LrO8lA03A9siC+a2QH5D0Z+cLRQfxPifMvzSbXfreBsSGseSF6G1oU8cf7J+?=
 =?us-ascii?Q?qt+oTGlE+8908qELE8y9UhNGc6O7M30kWJypHi+E2eBMKcrfD5CJBb4X/Nem?=
 =?us-ascii?Q?IIKxwD56t3CJBKW6TL43R2KXhvRMy0DFpUdbVDtJeGy9u2/0GB1/g+hGZ5rU?=
 =?us-ascii?Q?gECVTC0xlyPzx+GPOHBnYK9C4CQRLa9GbunXXafe0pCduq7IOg96DbVFMRJo?=
 =?us-ascii?Q?YB1qr9S1R4EyDpvdPKEHjUOT5U+NDSGRgOnXp5GzQoxyQiNyxvL3+lolnw19?=
 =?us-ascii?Q?N63LH1odlPOV76NGwTTwJl8hrv9KxZhf0XoCHyoFu3F8QbB4rZS7G/KV/wTe?=
 =?us-ascii?Q?BdIMIdg+FcvMt2wORpYnf/14Mrt49TQ4y/gV0vZuZ/xbPBkAdNWEZfccjB14?=
 =?us-ascii?Q?X/SUbF5CQ6s//4DB5CH+1bmOF7wk40ThpDb9nz1e62/AcYTEs271W0Cm6LPU?=
 =?us-ascii?Q?FQCVe3fKXjHymMwHf0ETiudcadsyjAY28elTVNDMVJihykEfzXN3idfev+o+?=
 =?us-ascii?Q?CZL1MoPL+tfWHzqH2EIMpI0famUTWNTwgjuMqoPjnoO9E+bG+ctdzneUI9Ux?=
 =?us-ascii?Q?NGGyaPFErleridcu315hYiMrh1RwAfVRQ4FftXzidtT2x+Jfs514aSUKyYCb?=
 =?us-ascii?Q?mrU19Sor9a1ztmME/OAzBSUFCgC7cr7BB2a/+j1aUq+KM4pdAk4KlnnMqRJJ?=
 =?us-ascii?Q?wk/4MUWI/uqk9oveWaRbPOuZlBf1jO1FAlAzYFSVX4aqZQxHOD6zTp3+CGov?=
 =?us-ascii?Q?Xpen2c6Pn2rR6DDj4ksP7d27k0C8Jyhj4Tdc6p/SsCcys6bxziUA4vdnoVO7?=
 =?us-ascii?Q?Tl/kVoKN5ylyWJVdg3bTCplf446H1XLJAvf9PZkhmjvSeFIBP7wLgX5IZ4fA?=
 =?us-ascii?Q?4ZGa4xzoXGDBv4cyW2fPft1zoW0u8phWBFJl8PoUAeYAuh+AwTv970AQPf0o?=
 =?us-ascii?Q?O4nrUkAvg25QIixNpCE+USgclExA7dKL3mXZTQOi+RaHCAbgdm3WCTEDgjTW?=
 =?us-ascii?Q?/T/Ocw2d4IAsav7SIiLrtCo4KBd7XqJbaxt0X8ILWVF/HsOdTY1ijsZDFyOt?=
 =?us-ascii?Q?Vm4omXc3FXpIOipU6c7QEzcyaWSk1xqe2TueGf5xJU38BDCDP3PdtbeukuLJ?=
 =?us-ascii?Q?M4mJgVW8Kg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8871fa3d-2f51-446f-55a6-08da10f3d74b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 19:47:51.0387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qN6RJqrtZERy5qWWU+FytuiRLuvTz4cOWrV6lNTUB7TB9j+BcriOovYuFOVS+H8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2900
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 03:57:53PM -0300, Jason Gunthorpe wrote:

> So, currently AMD and Intel have exactly the same HW feature with a
> different kAPI..

I fixed it like below and made the ordering changes Kevin pointed
to. Will send next week after the merge window:

527e438a974a06 iommu: Delete IOMMU_CAP_CACHE_COHERENCY
5cbc8603ffdf20 vfio: Move the Intel no-snoop control off of IOMMU_CACHE
ebc961f93d1af3 iommu: Introduce the domain op enforce_cache_coherency()
79c52a2bb1e60b vfio: Require that devices support DMA cache coherence
02168f961b6a75 iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with dev_is_dma_coherent()

'79c can be avoided, we'd just drive IOMMU_CACHE off of
dev_is_dma_coherent() - but if we do that I'd like to properly
document the arch/iommu/platform/kvm combination that is using this..

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3c0ac3c34a7f9a..f144eb9fea8e31 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2269,6 +2269,12 @@ static int amd_iommu_def_domain_type(struct device *dev)
 	return 0;
 }
 
+static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	/* IOMMU_PTE_FC is always set */
+	return true;
+}
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
@@ -2291,6 +2297,7 @@ const struct iommu_ops amd_iommu_ops = {
 		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
 		.iotlb_sync	= amd_iommu_iotlb_sync,
 		.free		= amd_iommu_domain_free,
+		.enforce_cache_coherency = amd_iommu_enforce_cache_coherency,
 	}
 };

Thanks,
Jason
