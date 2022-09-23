Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF835E7C2E
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 15:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiIWNqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 09:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiIWNq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 09:46:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EBDE4D93
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 06:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPKC+OQIxR+OIj6wYP1D8iUXusZEAvauhNGns/IEXaW5qYsf+yNOb+OjVhFB6yQas3SCwPH8w+amLP1Lp/4JlEW+1Fxa+pnolOw+RqakTtsrK4Nbs04ZNmog8MMSsuSqfCbugGL6eVUO8zWuUF4vWNfU9M17ZDlfCEKSFwri9kpZnTzIrpVNXA15LaSFjX8kIOSZnw8rJboN4w7r+8eOzcIP9jTdc/hTXYSDBfv2HtsrMRPHVq+wt7yGGOhPzUMoJfmeXR86ylOZyWqcfJRRhXC2p0rv/nQznRtEwUtR/sXCKceuR+kLwxBkbOlqPeLc55Jtx9Z9D5vsCoPDCP+bjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPWEOR8PTY6J33aiX6su0dQu8XmCisI8GsOtVq6So20=;
 b=koCoMKVDIkJIcpq7iGLLENmTGRckFwSmA8bFd4onQBfxcAIS6p3nxxr2XUUu0h090pwv7bkRQhObXRY+jStZipcVQn4TBGsVpoEzhFc0HUpqfPcileZtODfhVg4R8u30emidycTpW8hjS87f3asyxP/qBmLIl4Pb4LCbysnFrXHvLQYQIxGRno3bSfRrc4p/0meZkN/CNnckIh5PJ34Wt9ZJhXQsWt4f9n2O3slz3/gXW7RU8xuldKR0HbhDliY9R/Kpv+qFUliwkcl26Pu79mueTtTYcJvv974EMRCBnCn6VU4t7bG3CjjWL9P+fac7JKkpjy6yPO4QpmjpM68z0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPWEOR8PTY6J33aiX6su0dQu8XmCisI8GsOtVq6So20=;
 b=QSG+rom/u8oRYwkGWEADoYvJbCV+4j8zAnJlRExPPGtT2Vtvc4y9fRK+5NOZ4Dc5CYMeysaiHpVyT0lDus8U5Cfec6sqrIKKAu6+7YzkEFvfXRKtiC1kYE6P8QBmrC1g059/Br6fdZJW5j+HcNqTCV9PxeiGrQ45cZCqSZ5EJtYn0I//HnYb7FTK2QZemo3CYI76ZzUNTHc3LDG0df6T7ipFRq0Db4hjLUGK/NtIjaXNZOtdr+l1vZZJbRmw3E2AlIkSFYDKmWBzphzLWkLLVRqFYxU1SHMC7KYUoPyRmtrJ+Dxg+IRXO9EpTQEZFCHVcB0UwCHqGQXwboi0s6vfJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6151.namprd12.prod.outlook.com (2603:10b6:208:3c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Fri, 23 Sep
 2022 13:46:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 13:46:22 +0000
Date:   Fri, 23 Sep 2022 10:46:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
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
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yy24rX8NQkxR2KCV@nvidia.com>
References: <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
 <Yyx/yDQ/nDVOTKSD@nvidia.com>
 <Yy10WIgQK3Q74nBm@redhat.com>
 <Yy20xURdYLzf0ikS@nvidia.com>
 <Yy22GFgrcyMyt3q1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yy22GFgrcyMyt3q1@redhat.com>
X-ClientProxiedBy: BL1P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|MN0PR12MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f599e70-1388-43b2-fbbe-08da9d6a0067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEPZdFCUrWUWlEa29Iq5nxSMkXHpnQEZJIhtWWKErH8TnrvcjsNQNCmHpz7XfHfVlW7pXsr+VijvktUJdKyo8eZGwrVtT2+pFcbZ8MmGgRUuW2xJq6bsNoZMFbmIbXykxNLi3F7IHE9NWPQ1f7UxHvSxyoER/sJ8etKEw3WZ3KcNt/PfAOTqe+jQSTsXPCjU2J6oFTl7/EQ0GEWy/ONZUz226nyWJ14ksiXruu1zwG9jOMm+jFC1ILgrBhJZ7HkKZB+H/JjzLRxfpieztFVCF0kLOQrP4LDBXUv6062wQaCuxmuBKrkAQ9o+blNQCsVyFxA1rZ2DXZ50rUdzC+27c5rBEbJXwA3qYR9plJ5TrZo+Dt76DeXVNTOfDyb1Y9U0LbqeqNT+p5x4n8eC8llyAwgUJRZKk8Lp1juLJEh0R/EfK2BNsW9raT0lvm6KyT45s9eksgqnkknHc8tleihuRax03KMm7Mzl1Oa8DulhAD66EghL9fCHB4QJePrFxDBbZdVmVS32l7Isw4KTeHXQbFPThoasNDa4kNYJxr4/yLUrpRrf0yd22RLjGZOsUj9Bul9FPl3TkZWW1Xj7dQPAxg/grWOdyC6O2lfXH3CVRDnNENTBlEENB2v6FrIqP383iXKgVerYq10gSE6Ypf+tIbgBbsifCwTJOI2aVC1vHXkFD4dRPXNhdF0B+vr1XZH+MhFD0g1/+CA7w9GlUsHFbNO/XH7HtoN9zT9J6aWgxIVaXVcaJFKn+scmBRyEZGVN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199015)(66946007)(2616005)(6512007)(86362001)(478600001)(6486002)(83380400001)(6506007)(36756003)(41300700001)(186003)(26005)(4744005)(7416002)(5660300002)(8676002)(2906002)(38100700002)(8936002)(316002)(6916009)(54906003)(66556008)(66476007)(4326008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2lObzBzM1JwT3dqTkw2M0N2U1E0YnB1eWlXVE04YVFPaHJ2eXM5aEczL1k1?=
 =?utf-8?B?VHh0czAvZlpKc2E5YnNHazQzNGpMOUtXOWZCN2hzZHA0aTQwSkxETkxLYVhH?=
 =?utf-8?B?c2NLNGJwOG1taUtEV2tEOXp0c25LMUJVK0QrR0E0WnlXeEV3WDBlcmxWei93?=
 =?utf-8?B?bzZpZlhpSU4zZXp5dmtVT2J1QTYrckRBekxqNkVOWDhPd0JhZGQzeGhFUHN1?=
 =?utf-8?B?a21ydTMxTE0rcGpYU2VQYzlkb0Q5RTRRS2x0bENwNUhFakNIUjAwbnA2em9C?=
 =?utf-8?B?QnIrTjJyKzVBVHBIK25BZnV0QXVSZHIxQW5tYmhtak80TU9MSFA3NUtXRjR1?=
 =?utf-8?B?REovTkJ1TkRpOXZCYzQwdXY4WS9Ld1pxanpCWlE4bUcrV0lkUUNzTGpOS1oz?=
 =?utf-8?B?bXlFWWRLMno1Mk5Sb1gyM2xLcjB4NW8rWnppUnVabVRmUUk2NUxXT2N0dGFD?=
 =?utf-8?B?S245TSt0T0JoK0VvbVcwV21XNjZabVFKRDBsL0tzT1poemhqMEl6T2txcG9Z?=
 =?utf-8?B?TUFheEZLTVkvYVZmbnFhS0JtMmh0TlhaQ08xZ0h5SVZPa1dUMlo0ZHVqRnJU?=
 =?utf-8?B?UEI0VFkwb1pKVkJuaFdISkYyUkZ1RXQ2bld4akxUT1h2WHVjY1RjaENiWDl1?=
 =?utf-8?B?VnViS3N0U0RaZUNBTFVXWWd1OVBVV08wdDhFSUd4blFEb05BNThRTzJqdHg4?=
 =?utf-8?B?bFFWTWxsQUxDVTNqcXRGdFpxek1rS2pXN2NnZnkyQmlOdW1XRUdlb2Y4UWdI?=
 =?utf-8?B?TnBlWHllVkluTEJDZ1VYZ21ZdUFia1RScTZOT3R0eU9VdFNaSGhYNms2dmc0?=
 =?utf-8?B?c1QyRW9SWklCc2Q3R2VhQkZCanZtZUtBeldqZUc3ZkhDSi9aODd6azZJQjdG?=
 =?utf-8?B?WU1TREE0N1RUVCtVY1luZm5XRm5KVm1Bajc4b0FES0pTWXJTTzMxVk82UzRl?=
 =?utf-8?B?VURSdS80dFFVQW9jN3crQU0reFpIbUllUng2Y29HWnBuYXYyN1hOdGc1UUJm?=
 =?utf-8?B?NWEwUXFmVWJVaXdTZkpoRjBuaGVXazYvVmlYM1g3K2dpVDg2dzJlVDBsVWNM?=
 =?utf-8?B?U3RQUXVsUThjOVVQclhaUjV3eTAzZ3ZobVJIZ09XLzRxaXgxVFRaMkozR3l3?=
 =?utf-8?B?L3NEQTRkb3RUcWg4Y216QzFoNWRaL05ua1RuY0habVF3ZnkxK2REK2JxVkxk?=
 =?utf-8?B?bXJ2WTZONUx6MG1uTEwzbjRseTdDb0UyZTBDMDJGWnhBNGl1NnVia052VEov?=
 =?utf-8?B?alhGWmNOZTV1NkYvdy9mbDNjOXFkYUxuVnpKNzRFMnBSOXBJLzlJRG95Smtv?=
 =?utf-8?B?TDdhdWlWblRDR01nMGpKMHB4cTU4RUpQUXB2a2liOEk5eEpZeThscjU5Rjdt?=
 =?utf-8?B?Zmh4OWZHMmZIWFJxc0hPV0lZT2I1MEhsbER2UU1lZkZyNWZYeXZsQ3RBU25r?=
 =?utf-8?B?NFhYYU9ZeXZEOEplRXNWU2NSVyszNG9Gaml5Qm1XVXZWOFh6K1ZqcGNtMzI5?=
 =?utf-8?B?REhudkRudk9Tend5NnZBK0loM1gxVTgvQTYzb1FiOUFLSEY1ZXBrY3YrYklI?=
 =?utf-8?B?elZwZ1ZnR3ZUY0xwWjhBNGljbGxkcDlSTzJodHJsVkEwTmluY1JIclBGaHM4?=
 =?utf-8?B?ZjNmYUMrVjRYZTh4dWh3cll6cElYMGRMUFZuL0Y1WHBKS0xFMXZwcUZVVnox?=
 =?utf-8?B?bGN4WkJrdFZYbFlQeEJORFJDOWlISjNRb1hGajlTMnVKdDU5a1FUbHI5dU1p?=
 =?utf-8?B?cjMrTDFNQ2M0TDE0L2ZMK3YwdzBTVTE3OVpET1ZUOEtkc1J3VDYrN2tUdkdT?=
 =?utf-8?B?Ump4dzc3TzhzdVFweG5uQWZFTGZhSWhNdERkNUFCWFV4dExjdTQ4aTFlRVFP?=
 =?utf-8?B?N3JEYWQxaE9aRi9hOHZJTmJVTUNOazMybVdiT2s1NFZEeUlrNHdodzQyS3Zo?=
 =?utf-8?B?TXBFdEsxZTJBSjhBQkRHM2JmcXROdnpXeVlrV21TUG1GcVZqQjZIa0hGRUt3?=
 =?utf-8?B?VDhCMEswZnZzdVBYaURCb016SVZUZmpxQ0tOcmRlQzdnRkhIc2JSaisrQzN1?=
 =?utf-8?B?cFF1Wkd2SUo4OXJKNkhrVkFwMGZWSnRTK2tqVzR2MWpYMFF1aENjTjhPcE1U?=
 =?utf-8?Q?YuhRDuNQwuYwpeYuKf4xH+oE7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f599e70-1388-43b2-fbbe-08da9d6a0067
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 13:46:22.8067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hk8Bptx7AZ5vZ6xKNygCUCVFwUbPCZ3ZOnzTU+33V3sOATiQLrib9Zuth5qemLoY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6151
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 02:35:20PM +0100, Daniel P. Berrangé wrote:
> On Fri, Sep 23, 2022 at 10:29:41AM -0300, Jason Gunthorpe wrote:
> > On Fri, Sep 23, 2022 at 09:54:48AM +0100, Daniel P. Berrangé wrote:
> > 
> > > Yes, we use cgroups extensively already.
> > 
> > Ok, I will try to see about this
> > 
> > Can you also tell me if the selinux/seccomp will prevent qemu from
> > opening more than one /dev/vfio/vfio ? I suppose the answer is no?
> 
> I don't believe there's any restriction on the nubmer of open attempts,
> its just a case of allowed or denied globally for the VM.

Ok

For iommufd we plan to have qemu accept a single already opened FD of
/dev/iommu and so the selinux/etc would block all access to the
chardev.

Can you tell me if the thing invoking qmeu that will open /dev/iommu
will have CAP_SYS_RESOURCE ? I assume yes if it is already touching
ulimits..

Jason
