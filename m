Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2E75FC797
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 16:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJLOlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 10:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJLOlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 10:41:06 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D9E9E681
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 07:41:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBpWMx5+GpcZTkTPe8LZZn9L27CmWdKCVGLqxIPsSjpvjPtQe1wdwgEsONzxgQRP/vRPxqyI2ZBQUfiqmwykd12xmm7I9lwNcbSlBU6yZ1M9y4lDqmRNtR+9IdE6fxxy/Cf8pD5epMeH2c2qovT+vhSO7LCGi9TqLKD9wptKc5kLKMfqsx+DKDhTAVpM+TX7EHUFrGSm1KHxQbnpB2QHZdwCTNWasYh6qMl632PttafqcPAfaMFafP6c/c85EY5sgEANAIV2e9Vhm2+eVwMw/vyWzcfgwiHrz6iCYYQP+Bxta3P8G5LXj4AXAmxQ+s64AfC9BKoFUZQEO4I91aW5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEG91Qwa9tPxZ2LxrTdS7itF4XhWMMvOr83joLZfvRM=;
 b=S2i19gem4WBz4UxnP0QwNyFqZ30Z4AiRq3KS/oHft1Vpvr8RAThCWPIMg1niOdtaxB/3+OfpNrEWb6CWzlRnRnrS6pIap8e8WPURQid3IBrbmC2jcE8Cnt1TCHlS3B/3flhKsGtxVtX9A2pyWd1gxpg6E5jBLRmP21c4gs8BuBYCfVws9WW+hzIU4w/bQweQJQ3GqH5qSOq0II0XlqXeeP0/9JTPgeqA54g1X9FR6On/xjE7wHTPg9Iu/tRAGjxhlIwI6LcnD2J71b3nMc++BLv3RDDISZfxE994Qeo++SN5ozYZ2qU7sk3i9mxm+0E2aS/Qchi+pUrhdPi0YkMgHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEG91Qwa9tPxZ2LxrTdS7itF4XhWMMvOr83joLZfvRM=;
 b=JbzSYdy0dHwSZRuoZlAGUSMZLNr/Q18YAfPPzDE6xvdQH/DKNxm2eb8hKlSYNmpIOtfpDn/bfIyK0PSPEwDqnYmogBn2RCEujD7U/5figEvIFWnrS20kKPU/uH4fG0LV1/wIPY7d4Nn9hUrpPPzC/ML0lkD+k5000hfV2IvbbcMzJ9qxHX6SKNg1YFfnirI1zkmZKJsd2L2MdbVxqPbI6pm24ZIj6eoA7w5Nq5C1Qi00kHlEm2WFEr3D/OY6F9tTP/VZJf/y03S3e+J2C4ctWQhII19utupH+HajgJXjy2n7gIJNcGTxyZdisrGhh8OPeRlJknMg/T7nOVmAjipoVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6579.namprd12.prod.outlook.com (2603:10b6:208:3a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 14:40:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 14:40:59 +0000
Date:   Wed, 12 Oct 2022 11:40:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
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
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Y0bR+lJ9Li2E/hfJ@nvidia.com>
References: <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com>
 <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
 <Y0Vh868qUQPazQlr@nvidia.com>
 <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
 <Y0az8pNrA9jOA79k@nvidia.com>
 <f9e6ea0b-ebd9-151e-4cf6-6b208476f863@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e6ea0b-ebd9-151e-4cf6-6b208476f863@oracle.com>
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6579:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c639943-d7fb-489b-e4b6-08daac5fc774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ULTYltyYtyv7PuoK9MVjHiLg9P/vUA2VVloyEmtxijwP6f9GFj5zP8Zi1djYljxF5FnRdujmvx3AsE7nyYpdDdpJrsQjKLuWYdX93NpyAI8NU//1anhUY3SG2pv7o0JXxV/CLQDtlNLZYGTDqfDIc2Q/RatZVijpSxcq2sEIzefeJ55bBM5IZ/dpRpLMT16Uow43IClTxDzYsExc5dVNvD5xpJ8NkfP7heJGTuyitWIsEOw49CCmg8TH9i/hwKQmH5qQ8ska8T2bEVqFnu3UDfPT60mcSSyxxW9HDtwJt0/wWhCViEIB+Or6YDdF+YMRHsqfqifFrLdYMtr595oX2ZqYBzvQ8A25x9fjjbEf17FD5kdlN7VlO4aI23ztSnfz9BJIBWl3/Y6u75AAnb2VYA6+aGkEpU0ZkjXb5/7olrL7n6xOkP+wqV/RjaeVagOm2qplShwLTJAJVJHcdLyElB5IBcB+SbO+mMThlWN0TOBZEwhF2ZCpJaYG6nJElkE7VQmxu6evlBr+6sNQKppT0XLCq09iDFe0AgxPbdbqm6+35TznBDVwQQPDBXuD0cU/Yfr6dfu71vAcQ9+uNHKqmMWLrxttS4vJigpidAt9ZX8+1AQ6qQ88RxWZGDuOX/0m6h8ku3gVIa+SqbDzanMnSu8/qHjjo8qbJEnoAsHQqUDAd/0NxTe/Uv43uhA6372s1Nc5Wn6TYlQzMBy5QWHuLWQeuyReTDQ9lRyfS0kzkqlaSIR8sby6y+bgsD3mdtm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(7416002)(8676002)(8936002)(4326008)(66476007)(4744005)(5660300002)(66946007)(41300700001)(38100700002)(2906002)(26005)(36756003)(6512007)(66556008)(186003)(2616005)(6506007)(6916009)(54906003)(6486002)(478600001)(86362001)(316002)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8wIYyClATQ3KWuhBN7SBkTiAbaTWt0CJorXQ8LmQdVuLtJYcwUi5TJ+GD3Ro?=
 =?us-ascii?Q?fPugAS2pPNtuWU9io5YVVQwUhdXajodK8H7JbNcce42mZSqVkBhxCXgo3Ea+?=
 =?us-ascii?Q?SD9UvzvMdCBnvIgrZaP6e3UV2v3MHfa92lepTTtvn2NeVR3EG9e3LNiLew+D?=
 =?us-ascii?Q?FhXJgeCd43fLrKRGogw+OR2xxQlgtuI+IZw9QHmdq+nvNC9g9SBChcf0t6do?=
 =?us-ascii?Q?uCVSdN/0Hn/65MPgFfKzLNWKq+iWAZu494j1ZZk8fbECbJ1GoVLtX8Z1BDtn?=
 =?us-ascii?Q?x/AyWEhb5F6C0hEn8ZXEp+jfCbQ4fQf4zGRqcNCW5jO0vrEEfjBSiEA6JzZB?=
 =?us-ascii?Q?TEX2QDVjHUsDtlFw91cjxSLMhjmPLUyBa5sjMTYO1oKEXE9fwfWF6skt7Ee9?=
 =?us-ascii?Q?F2+4RslnPC9IMRBo1gZynceHO5iHkW+GqVyIljpDtc9o9uSajZ7aHLTNpqMN?=
 =?us-ascii?Q?ABOWZh+uaaJsjyDXcK8vtElnb70qqs+uZPulivRzAmX+THaPxuKWVn+sqBhi?=
 =?us-ascii?Q?J3/THx1/uD4tbbpJroYShDNFIPvjy4KtAp3wOAdjdjsdiIHxBxwn8HjEcxDp?=
 =?us-ascii?Q?e5G92qF5+br+AskAc1dzKepvS2WFVrluyMVreDgZEOsf5XyP0vrRz3Lqq0fB?=
 =?us-ascii?Q?/PrT0pTK/psAqmwL3+48mUVL3LDIEps7AYsAneVtX6ycmZlg2ltYbkctUFGW?=
 =?us-ascii?Q?gbGIUmAdZ16FJQ/Nb7xVDnM4uGn936W54r/HIVJJf1BWBcD4QdpbeAkZCvYr?=
 =?us-ascii?Q?3GZte5xoI+AEOMaVvB1UY4HFubUz/h7ThOcIn4FDqOtCU8u//0amfWmm5RVK?=
 =?us-ascii?Q?SwbJCqQLOe72AoMp21tkyT1PzEhimh2SOkw9MBiB/tmdWPrJ4U8WZi8YTOYO?=
 =?us-ascii?Q?nsDg+tRA3G1cZuS35N1l9bQhKmB4BQsPfD1vRnXiOEhvfmylJf4hKdQgo3SQ?=
 =?us-ascii?Q?HYTOmk0EH1VapG5aK0CN6g8VcctrzTU9GKUvUtKdlJ14ExjXOlvkzw2oeSZE?=
 =?us-ascii?Q?JEzKcE9E/vv/cjHKXL5g/qO8TaKUERM1dIFIZmPiYIw3zWLEyv19xkrn5AX6?=
 =?us-ascii?Q?QKJ/c2+SDXNBZcmEnMVnZkgtOG1XzS9CSRAoeQy04E3MWKIA4Knz+RnMZuhd?=
 =?us-ascii?Q?vp46ABFKVBmm3taxzD0ka9SfdxlJsZmBf3+PPILeJsG+Vddy58k2+hCDkyVI?=
 =?us-ascii?Q?EeF9s9lNqTQyXRIES+x+nQvidCHqK9k7taFQwZ9u21u9pGdQql0+Jfj9OXnq?=
 =?us-ascii?Q?qgghtw9YlCdvC9dTf2EQOZ9olAJpT9TjQpSMMv9XvKFo/NC9xv2bI625ssuM?=
 =?us-ascii?Q?jyo+WP+Oc/eTV+QhMTsDM8Qw2TZOm+XOYIPh5SsOgahvCVeDtU22APAmMCzn?=
 =?us-ascii?Q?DG9cp0/1Mu6UNbSRbKa1OQ8zr5eqRI3jNj9KtT5GbW6++MQVgAoGlR3XED3s?=
 =?us-ascii?Q?bcPZ25u9rN7/Ua6GxgQh5pU+NgpoSGHDYTmB9T6fIQRmCoCtniRtfW6jFyBJ?=
 =?us-ascii?Q?E3NLUHNHhX57I684IOJrQk9uq9xbrGt/rju33NCW35h2LhzNteJEAyxCCg2i?=
 =?us-ascii?Q?1JCjUGxA1OUINCu7rZA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c639943-d7fb-489b-e4b6-08daac5fc774
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 14:40:59.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Cb1wstoK4f7+DvwQy+l1MTd8qyY3LJhgMBJeWU/8i7SsPt7StVeDyeec19aACvY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6579
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 09:50:53AM -0400, Steven Sistare wrote:

> > Anyhow, I think this conversation has convinced me there is no way to
> > fix VFIO_DMA_UNMAP_FLAG_VADDR. I'll send a patch reverting it due to
> > it being a security bug, basically.
> 
> Please do not.  Please give me the courtesy of time to develop a replacement 
> before we delete it. Surely you can make progress on other opens areas of iommufd
> without needing to delete this immediately.

I'm not worried about iommufd, I'm worried about shipping kernels with
a significant security problem backed into them.

As we cannot salvage this interface it should quickly deleted so that
it doesn't cause any incidents.

It will not effect your ability to create a replacement.

Jason
