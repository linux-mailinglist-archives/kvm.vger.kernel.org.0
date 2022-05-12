Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A946D524C3B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353481AbiELL7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 07:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353479AbiELL7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 07:59:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA62A94DA
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 04:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TaaA0DJ0kUz1FlQwA4RkShoWo8urJHIxEtdxhlY8p7Nuzo5yNFFO63KhZBVGLC+g05D1F6O7C3d4GbsZ7s6tfPufPz+aMLQ3gJRP5fhf5mm1sSoRcGbZW9UtWNkDIizpPs4BFyOIA0mDRUNcT34jmw9B4FGdCRWd7MdNB4wnClbHmKv1o82s108Xoa7wi/7AHiag94KfLwLc6J4KMCbpGvXiYrfHucYR6sagC5guelJnEp/whRb9Zy9s/tRBuAmSSSQUfDYgY/sPmZyGlT9YDBAk0zNrwHM+QhSCWc7OzhwgvZV66A6euNvtAREmn61y7PZ9Qw22R7T9Q2YdHEw/eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fP+aIDFPnvSU1wfo1pDmRvDR+XhuPabbsVt16h1mxd4=;
 b=kpGMzgoM22AZgynJ1HNOo9rlOddHjymRLbgUWUNLqUK4mPoB7OxBNPpvxXL6GVBuX6MJEFqXcFUq7L6bKpz6R1JpQtCAr++uJah+zG+0uPsdnKtUpeGtWHpD2H9FLqdG3JSMRiKNPWLN07YpG4O+i9kJZN9QIpD0aN9HDUbyHFdIjlPvVBUzZfhkvwg7j/b5QCYRtrQLGgoh5f7u42hGdYSlaW5MhrVtJY0YW1tXsLXIOJzVIxs/LLWqb6mj45wvGi0EjrcOJlSJzFI8LSjPRFslxfrsDHJr2ngyIZ0eylJUp9Z0D+4KZp5rFQQArAHT4OnL4SkCv+S4cvPRWRa+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fP+aIDFPnvSU1wfo1pDmRvDR+XhuPabbsVt16h1mxd4=;
 b=Ppzx+3+DavHUkzS7VhJPj3QLmlQlP87RqBpqtyOR5zXgzX1lTt1o/6NGANwwNlnBYyTrQq7tJqKxuVBUf0TGkF0C/kq3r6Z6dJ2Q2tJQnKAvsCZEvj2THi6/uEXFqwr5gb16MwsT0HmZHoO96W/l8dWUp35Li4X5lFaIcjMubPpGVITKTCzpx7Cr3Txf90KF/Ut47pQvKomKCFxEJobgi2LYpTxqXzGK7qIW0jw2HnjvVDA2ny+d0PjfEqrAl34UoeYBWF6T2bKfEAyUQSfsebmM3hHpWYs/7HkXPaT4IOw9iT301PFvP5ksSApWIp8abIm6FZyk+iUpx7JwPv4cMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1585.namprd12.prod.outlook.com (2603:10b6:405:9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 11:59:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 11:59:07 +0000
Date:   Thu, 12 May 2022 08:59:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vivek Kumar Gautam <Vivek.Gautam@arm.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <20220512115906.GX49344@nvidia.com>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <0e2f7cb8-f0d9-8209-6bc2-ca87fff57f1f@arm.com>
 <20220510181327.GM49344@nvidia.com>
 <6c6f3ecb-6339-4093-a15a-fcf95a7c61fb@linaro.org>
 <20220512113241.GQ49344@nvidia.com>
 <tencent_64CD1D42838611CFDB6E6A224DF469C10D08@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_64CD1D42838611CFDB6E6A224DF469C10D08@qq.com>
X-ClientProxiedBy: MN2PR01CA0066.prod.exchangelabs.com (2603:10b6:208:23f::35)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09a258ea-196c-48c6-a929-08da340ed189
X-MS-TrafficTypeDiagnostic: BN6PR12MB1585:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1585309EC24566D312D1A1F3C2CB9@BN6PR12MB1585.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcSO2g9Yi8aPMjrYtfoGVsphR82zLadTXkXzEhZKdXRbxBHgRwrJsUfIW+M1FHeTGiRSR+Y4SPAsQhlL02WqM6cSCXozu775SQL+pNdAM9MOH/LnzYPgo1UNRC+cIMmIQPI/wZkqs/tjQu5ET+Gbv0WBLGE5nn5uaTCneTazIG/0kVDhzcWm56Mg9ySfSjuzFau/Uq8zcEHdyr6rV2ybwxZRt6miBnBYusIsmcBWQpBlMMkR3RvXif9awEjNfnFN7y2xivw4YXwq7Dh/9wR1jmWIPriHaDeD56i46a4SjXOn6VXO0Ig/RXZaBfbSOPqXUnYJqIhK4l8lmM21C1a6hvAjhg50HuD5ZN8vXBBdXkL0putitTUbtu1seKd6b8rbLJYCLpVOwAFC45q6TEL/PAtK3wyf0NywsqJ0NvJzNltX6DMwGDnJs7MMuiEA9eCh/MF/rgNQ+cEnQItGFEzhBpukn+E8tqsgtpGR2DN6UHJ1GvKWPPjeBwpMZvBGvPJad+T3BGhup7x9zibDqzEV13OJU+kOP0sSHcL9iP73VhseBxiaysSLXPMuYeWZlytde/+CnyRFoCo5nC6bvcR+HQSh40mv4tbS9naVppnpxrNIQcYnstTsPqhLo+Jit46D0bUtOTx6E2QQrF2e2R0y3pnx5QgquBi7S50kPXV1tz+knlPSVPL77oocxfOJGPhwzmLtLYDJMgJhDrfSlmf33g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(66476007)(7416002)(26005)(5660300002)(6512007)(316002)(1076003)(83380400001)(54906003)(2616005)(86362001)(38100700002)(6506007)(6916009)(6486002)(66946007)(66556008)(4326008)(36756003)(8676002)(8936002)(33656002)(508600001)(2906002)(48020200002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVA4UWIwTjBXZnpuSzZVREtBZjlOWWVvZzNIZlkyUU4zQTV6MDNxNVdJalND?=
 =?utf-8?B?K2VOYy9DMlhFRGtMbDdxOEs2Z1lTOXYveGI2d1ZwT1FPdWtMK2FNbklFUWlD?=
 =?utf-8?B?Qk9HY2k3NTBmYlFQZDZkSllwbUxDT1BENEhJVXVpRU1FWi84SzlCMTJvYXEy?=
 =?utf-8?B?MW1JQjU4VUhUc3Y1RG5mc3k1YW5FR1FHQzZoME85WTNSdDFyOUE0SzhkUUUx?=
 =?utf-8?B?OTZad0Rwa0FTY0huZGVIdUQ1VkU1VkpvRlJ4ZFovcENoYUlVZ1NYZDUzNGlv?=
 =?utf-8?B?bFlKbjFVWUIxZkp1NmJjQnpaSlhJNkkyUjEwV1BCc3k4dEpmWE9ISWtxYUZX?=
 =?utf-8?B?ejJZWHd2UVllcjR2RVZTY09mb2ZXRWUxRU1XMnpac2VYWVhRMGwxZ0hZVlVv?=
 =?utf-8?B?VHNhSGRCb3A5cmQ0ZnJqMVJmZTJrRjZMT2VvcEM4NVNqelZ3d0EveWhYQUNS?=
 =?utf-8?B?alpTZFBCdzJRS096UFNUSkZtK2FYa0hXdGNMNWkyNVVTV2NYOXNreUtMdy9X?=
 =?utf-8?B?c0JLNXBxSVlUb1lWL2ZCWmNJQXVTUFg0Z3p5V0F6MnZlT0VWNDlIREFhTEJn?=
 =?utf-8?B?NWFmMkZWUCtIblpxaW1mVGUwTHBYQ0g0TUxaTC81UGZPZnhkTS9nSDc5Y05w?=
 =?utf-8?B?c3ZvbGU5OG9rMmx3RWc3VFI4S1NwZ3dJZWtuM0Fqc1RmOXBmTDdjTzEyOGJJ?=
 =?utf-8?B?MUhuL2FvUFArZ3BqdG9tcE9lVmdsbHdjeXZyRTZ5c1crQTVrTllEcU1KdEdZ?=
 =?utf-8?B?bEN2YUw2NXNPdnpWcGVRMEt0c3p4VVV6LzZjbmdRRDZpOGY5VnBFMjVYaUVn?=
 =?utf-8?B?Y3lDRW94YlB6aWxRTUJNcUNQb1h1VE83cTdLQlR6bWdTTkVLMlQzWHdRMFdU?=
 =?utf-8?B?UW54a0JQNmIvNStYRUsxbkFvenlZYklVZi9FcHRuMitPWCtjOWFCVUFJUkxO?=
 =?utf-8?B?SXBqVkRQa2JJWDdjMHVMS2U3QzNTSDRVL2tEU1dlNXEzMDI1ZXVHM0R1eVgx?=
 =?utf-8?B?dHFjR3RKMjBkODYyOWZMMnVnRFdhb3ZFOHN5cGs1OEt5SW82MFV6WFhXRG5v?=
 =?utf-8?B?K1lPRTVReGNjK0t5VU92eDFVaXBiajFLQ0JvS2cvNVpXUTdsZS9WaWhCSXlo?=
 =?utf-8?B?TjEwVWpDOVZaYk1Cd3NjRjNmV3NsK00yVWljV2hMQmxqb1o5aElENWp5OXNo?=
 =?utf-8?B?YU4vcEJhRGN0K0U2THdUUmo1VU1IWWhXR2x2VEFBbnJDS0R5ZUh2MVlPZXNs?=
 =?utf-8?B?bURGSGQ2MFZVK1ZTTlZyc3d6OGdsUkQ1czh0cXYwL3hxZWdnaElTVUJpK3hk?=
 =?utf-8?B?VEp3NEczb3Y5eWU5QXNCb3R4cUlPZFVoaDdoSTA5ZVFWR0JWQ0RTYmxiUlNE?=
 =?utf-8?B?U1VKeVoyTmtYQUdRUnM0V1Y0MkJIc3ZwNTB1OXZhYXZaU1c1VnFzRDlDZllX?=
 =?utf-8?B?dG9TR0ttUDF4Y2EyOEdLTklaUGt0ZDNuUWVYNUxQT0J0VWxiWGhiS0t6b1N6?=
 =?utf-8?B?WWFKamZPeWNuV1J4bjBIeTJySjZGT2pOdnNKQk55cGhaM2ZKQS9BaTk4QTQz?=
 =?utf-8?B?UW8vWFFvUFBXa2xvMDZCc253Ri9tenkwWGU5Yzc0dXlZSnc1TWc2MXVEMXZK?=
 =?utf-8?B?ajlUcU5lR3ZMc1Rndk1NQWdtYlVNSlNVWDJSVDJpdVhKaUMwb1JiTG4xLzVk?=
 =?utf-8?B?V1RMbGxFV0h3MlZqK2xRQ2gwQ1lYMEtEZWoyODZvbkJuN3JBU1ZIWWVXSDBR?=
 =?utf-8?B?dWFLN2Z4SGxlQ3gzY2p5NEUyU3NmMHVBV0s1WnRqUGtBMkZlMkt6eUJ4WUlJ?=
 =?utf-8?B?RmowbGFDVFJPL1NLWDc1ZmpHSm8zc2ZXLzY3d3lMUUtvbS9wZXVYazcxZEk5?=
 =?utf-8?B?VWMvdis5M3NWZnk5TVlhK2NKTjRsZnYvNWUzMk1hT0daUUJVYXNFMkRsK3Fj?=
 =?utf-8?B?UG8rNWRSUjdvR21YOXZVZkdSZHNSUm5taFFWb3ZJK3pFOTZVQ1pPWTcrVkYx?=
 =?utf-8?B?TGx4a0ZRZ2FES1RLL21BVDFrVVRjMThpb2NOKzZ4RnFpci9LcUY3cU9zNVRY?=
 =?utf-8?B?aGkrQUowYk0yYnBYQmZvRmVtWGhOL1lFVVBtMWVLdkQ3b1NneDVYTmdxY3Zz?=
 =?utf-8?B?aDhpbGFhaXgzYXdHeE5LZFo3eDkwdmtzbkdVSjdNOTl3OWhWbGtRUFFsMGVr?=
 =?utf-8?B?WEZ3eUZmVyt1Yzd6Nkp1TllyMlhLcC9jVmUxQk5YQnJLQTV6cFUxRTdYZEhJ?=
 =?utf-8?B?YnJIQ0NMR1ZIWFdjY0RKSENMVkExYUFyNDRyeS83Rm1kaGR1WkNtK2JaOHlQ?=
 =?utf-8?B?ZVFrZ3A1N29PS3lGUStjWEZRa0FlTk1FcjM3YmdSbXRvL25hZ1llQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a258ea-196c-48c6-a929-08da340ed189
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 11:59:07.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P088getIBo0D9CpEX/yqZD0R+NHjwc2bSuqB8q+2TNaZl5imEzSvUsCOPGA2qYT+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1585
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 07:57:26PM +0800, zhangfei.gao@foxmail.com wrote:
> 
> 
> On 2022/5/12 下午7:32, Jason Gunthorpe via iommu wrote:
> > On Thu, May 12, 2022 at 03:07:09PM +0800, Zhangfei Gao wrote:
> > > > > I can't help feeling a little wary about removing this until IOMMUFD
> > > > > can actually offer a functional replacement - is it in the way of
> > > > > anything upcoming?
> > > >   From an upstream perspective if someone has a patched kernel to
> > > > complete the feature, then they can patch this part in as well, we
> > > > should not carry dead code like this in the kernel and in the uapi.
> > > > 
> > > > It is not directly in the way, but this needs to get done at some
> > > > point, I'd rather just get it out of the way.
> > > We are using this interface for nested mode.
> > How are you using it? It doesn't do anything. Do you have out of tree
> > patches as well?
> 
> Yes, there are some patches out of tree, since they are pending for almost
> one year.
> 
> By the way, I am trying to test nesting mode based on iommufd, still
> requires iommu_enable_nesting,
> which is removed in this patch as well.

This is temporary.

> So can we wait for alternative patch then remove them?

Do you see a problem with patching this along with all the other
patches you need?

Jason
