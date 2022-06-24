Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F07559B3A
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiFXONF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiFXOMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:12:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DC350004
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHc2Ddzbjsf4Qmz6+n/4ZrMgRDBi1VecgVw6CgraJFzrWWGw+w5MxohN3NmAJ418KFCuF/RC84ERyDQADJ+atgz/5/6gGAXBrhYlLVc8WChit3Z/4vqcqSYpwMQ5UVP252fhNY8S62BsHq7z85Pl1wYInzfWPwvB3yjihHcHmBa7eL5F9U63aK7jtxp8DZhBtbZYmb/cvxkOrWIuDrBgrDRTbOCxwC4pPNWsRnERlWch1kaBGV5G1DprFJ/+MMD1FP3mTEda2y2rMrgfRbk/2xkgy0uPI9yZsV1s7Tjc8dM8Vo2U8Jtr1Sq3ouMUaIraZhJzK1+21d0l84zS/mR4lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqWxjqIynfv3Lt7c97NDoWk+F2y+UwnyeVRHa0Vy5Qc=;
 b=GjUzNRNkyBONIzCBqYXmwODr1GQIHrZbznVIzhB8WtNMvFO9pQqBbx8gO71iYxUxP0VXVIxwXTZXgeCFFjJWP6nT5+QYVxzLbrqt2xn2HwqDpNZIJ8ICd8XKk1sm0ioiFhPAk3kBFnmnSlt8NVH3A2Pd+/S5wp/K9wPKLIKYzWYSOFf6py8ZXGzU3sh76Z1mH8tfbuLI9bcRxoPd03dJ3xFkORoLAEZObmKA9QYqPU0rr2SS9HHf93yjb82evz41vhEz+7vHudwr6VL/8CFA0b0T7bG+dkjkUObeA69Od+Hd9TYAIXuJ/KYeahg25QG/d1zpaQG/IaQIYJ1dnN5y2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqWxjqIynfv3Lt7c97NDoWk+F2y+UwnyeVRHa0Vy5Qc=;
 b=WreJvQGFj2WC8N6W1mAzwDODF3TRauVFk9VidsMdtyxlHKXBxdWutxxSanvcIzlwyszRQh/DfrfL8kf969lvqbb/UgJazeDP4ZR3DZFm9bUZhUGTZL95CLSkeiQYtxqgS4n3YxjaamHoLef81KDIZqFMmoEHg2pPsrGtFwAjjZkFuEg81GjtOdaKGpqsIjT1WNYQlr+6+6Ee9FcT2DZLRH0YGcBXCj5DLcq63DB2TnPFduphYuTWOqO61il6FWX5nm8J9bH2JS8CFGAW5BjS0F7rYMuRKYaCKViVFp97IFZaLgCFGD8+6Qp/gYQhXe4UPhclRKJrype7Sbzh5gtmMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2483.namprd12.prod.outlook.com (2603:10b6:207:4c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 24 Jun
 2022 14:12:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 14:12:39 +0000
Date:   Fri, 24 Jun 2022 11:12:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220624141237.GQ4147@nvidia.com>
References: <20220606085619.7757-3-yishaih@nvidia.com>
 <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
 <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
 <20220616170118.497620ba.alex.williamson@redhat.com>
 <6f6b36765fe9408f902d1d644b149df3@huawei.com>
 <20220617084723.00298d67.alex.williamson@redhat.com>
 <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
 <20220620034909.GC5219@nvidia.com>
 <20220621104146.368b429a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621104146.368b429a.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0015.namprd15.prod.outlook.com
 (2603:10b6:207:17::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adcb2799-5a6e-4374-6037-08da55eb98b1
X-MS-TrafficTypeDiagnostic: BL0PR12MB2483:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +pXlssJDMJpWoyBPkevpJg6Yu2P2hI/5XD2SBmk9SrucuqslkpBlbG442CmsQ8TZrfkmuUXe0DfY894hWzyTtBZlA2iHMEA96FMK4+OvHNsPvFPDMjykI18IWYpyA6/SENh96Jf21A/F1m0YyrFrUZ35QHT5yeRGCRHjVqPM3TjNINcZ5ezWntXicGqbHH+BhoiXvgL00w/qgkVmPtndVXcUCLMGBZ+86Br1/mYoLxpfArFueCIr78IVeMQf8d9s0RA5yVSm4Xb0Wo3CxNgRamSD/pJg0hBw/ntDn9paVQ2HaeaqXMLu8wzY5LmFc9YpbANhZL3Nx5oa8tHbCRXxchKmCaZveaEO0kj78QZR9P/ab1iUViN5MR+BKvaCgpC2Cv7Z9WEHApxfcb+Lpln2hXa1tNADxdqDv1x8jLB3lJlepBBg6Far4UN3xbX7piF++JOAiVYcc7IBT8zLRdLpPWLMVEWhE3raSQty9qaUWjjZCXuiZ/TZ1EiK5kepXcOvmWCAZ2nBMcwspqNqSPL59470i0tX1ennFocKiYqlnRTspuNUbT/sIISH7trgJQlhaioAqUuPFjMB2pda+BWiFkJbOJbJe/15Rprpl8+Vxo6rTykztZmvZDuiXGYzvvsxNXnX3Xk2ECzXNPi2yUeORhyUGALx8MDTRYt7hFHmWtwJTvoEwdDiSRGpFALJWuO7chLyJfGbHylYhN32rTex/h3E+6hG7MWeURaNLvM+y3zSTtWXs0J0v9M4HfstgkE3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(5660300002)(6506007)(6486002)(478600001)(66556008)(83380400001)(26005)(6916009)(8936002)(6512007)(33656002)(86362001)(2906002)(1076003)(2616005)(36756003)(66946007)(54906003)(4326008)(186003)(8676002)(66476007)(316002)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2nbprvWSdIdvUawp02wKmUSKvtmA8UxSjXqkV6OItX+/MU5e7+gb4xv1lWBo?=
 =?us-ascii?Q?RqVLBs2LbHPx72jxP2SN1k3i7wMvctiua1KeVihQrIM+uea6HygXLETDrppg?=
 =?us-ascii?Q?sx1tZhi2K9/2jJTQF/KE3+nRiv6z2b6qnqZ3syWin5C2Bhl5lB2dORfY8kNz?=
 =?us-ascii?Q?dfgiCr9+Frri1BhpVBNFyZMDb3uwpH8wAvwbIFwebY8mI5AnoUDJ4CnKFFWV?=
 =?us-ascii?Q?Vhb5UuplPfGwMdkrGAhIzjhpm64aLRCW9EFnlRVLpsQSC1SH+AncHl+jGnQz?=
 =?us-ascii?Q?uwQ0uE6DuyfvpfQ+DPqGFKSEK9bUrLJmyC4wFZ8dpsBH2Y9vFVj8Ain64Jf0?=
 =?us-ascii?Q?H4LH+wp//wAtWIAqR4tC1Y4vbayYemD+9rRIBFh4cq20g+R8HgYm0ny8Mkzf?=
 =?us-ascii?Q?++SwTRp6hcrQIr7FtffbDeeuGs4Z/7OwN9vYjuWiAY9tzEz0sPboaIgw2b+q?=
 =?us-ascii?Q?pqMrMMhrPGxQZ7UV20xM7r8j7BemxebPeawvnuo/IOBoYW4K3bT0sTfq6D0x?=
 =?us-ascii?Q?sWQz6RLQt97rrZk2aGoDmPnhlAlXckMPSPQQAxiT6CLn+YllhP5HVRtX8g8g?=
 =?us-ascii?Q?04JFJ/4/u1VDE5ABWl4DzJEm0OiyINq1VupzsiHBRagBs9kq48b5deSJYW7M?=
 =?us-ascii?Q?EsVjAlPH2uasZL8C8Wh27clATo1m8ShlGqadwBczTHJ/PtVpUTwISs9AHNqf?=
 =?us-ascii?Q?jgEHLYF2iuBKS/f+k62BpQMxij0ZGwiyQdQMhIj+QHcFGqf5Zcun0MrnW07h?=
 =?us-ascii?Q?k22x5Db3+0qAnJj7W2mSdhS4T+12WtSLXP2V0UKZnnhZBkMVV/2hOxs1PV9f?=
 =?us-ascii?Q?CFufKJUQntKeQRWWpR5EPAsofxD0fADWoNoMaRE+GqLI8ucMiJkxNje9xZm2?=
 =?us-ascii?Q?SE60XAjcDPtFo1zPPYGG99tT0257+IEurpAIXxorHMmIejTAWYu5hSA1/OUc?=
 =?us-ascii?Q?jhMpY8U3jvZT/hJ6ru3gdgNL1GjiLm3EPVf6tCkDfaViMMt0Ws5ub4W6oyvh?=
 =?us-ascii?Q?7Hmer4bmDnny2kv9nYXJ27awDx4uXlh7kRGg73xdYAqNnLmuIKitJk4DccZB?=
 =?us-ascii?Q?SOpRlyLL863MerDGBGIuVuLJpf3h9gamsHZp3m2w6a3XPkhQ6q2Fiq+PrT9j?=
 =?us-ascii?Q?aND1YWqIjvhwWsGd8Qspz+MF3s7saaBSnOEUZjNPh/U8IGPsQjABQNXUfSvw?=
 =?us-ascii?Q?HMf6LMYwJwCUp8tDwWacd7vupUW9xzHpNndy/e+WdqWWhhq2d8MWc3aK6sXT?=
 =?us-ascii?Q?T1mAAeSixoSiaQieW045cg50YdwQAWYSPoiBvpWy2Ewtax0Uoo3HN792Wnsm?=
 =?us-ascii?Q?WijGZ1AqbomhR2HUu3osi2UwVMi1acvTnbk84f4ZE6xp+/kE3X3l8JiNB+D1?=
 =?us-ascii?Q?xYPWqeWrTlYl5htkWEu1qFXEaT0q3zU1Yi91qREt3/DwRLz9HhZwRdWPUC8Q?=
 =?us-ascii?Q?gwrGfI4CV2GGI78/03Oq0gyDvJ5lnYrHvVTEi5NzLVT2+2Ryw6lZlVNWD3z9?=
 =?us-ascii?Q?comh87AxOzNQ22c1Jg6rhCMX9UeeW3buAVY35aCFTOdX6QVZLRdW3QQ9nksX?=
 =?us-ascii?Q?sIk2uwn2VMPshyDOdcbtM0oyadtpjcOQnAILE3MF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adcb2799-5a6e-4374-6037-08da55eb98b1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 14:12:39.6439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2A/11nIOT+qLqXbi+IhAeyEzaX1MSKugN7su4gK/YMxBt01ZAiJYy5aIjVFJrpZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2483
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 10:41:46AM -0600, Alex Williamson wrote:
> On Mon, 20 Jun 2022 00:49:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Sun, Jun 19, 2022 at 12:25:50PM +0300, Yishai Hadas wrote:
> > 
> > > Means, staying with a single device_ops but just inline a check whether
> > > migration is really supported inside the migration get/set state callbacks
> > > and let the core call it unconditionally.  
> > 
> > I find it much cleaner to have op == NULL means unsupported.
> > 
> > As soon as you start linking supported/unsupported to other flags it
> > can get very complicated fairly fast. I have this experiance from RDMA
> > where we've spent a long time now ripping out hundreds of flag tests
> > and replacing them with NULL op checks. Many bugs were fixed doing
> > this as drivers never fully understood what the flags mean and ended
> > up with flags set that their driver doesn't properly implement.
> > 
> > The mistake we made in RDMA was not splitting the ops, instead the ops
> > were left mutable so the driver could load the right combination based
> > on HW ability.
> 
> I don't really have an issue with splitting the ops, but what
> techniques have you learned from RDMA to make drivers setting ops less
> ad-hoc than proposed here?  Are drivers expected to set ops before a
> formally defined registration point?  

Yes, the flow is the same three step process as in VFIO:

 vfio_init_group_dev()
 [driver continues to prepare the vfio_device]
 vfio_register_group_dev()

I included the 'ops' as an argument to vfio_init_group_dev() as a code
reduction not a statement that the ops must be fully set before
vfio_init_group_dev() returns.

The entire point of the init step is to allow the core and driver to
co-operate and fully initialize the object before moving to register.

So I don't view it as ad-hoc that the object needs further setup after
vfio_init_group_dev().

> Is there an API for setting ops or is it open coded per driver?

RDMA uses a function ib_set_device_ops() but that is only because
there is alot of code in that function to do the copying of ops
pointers. Splitting avoids the copying so we don't really need a
function.

Jason
