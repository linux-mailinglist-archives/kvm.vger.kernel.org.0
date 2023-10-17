Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0653A7CC845
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344017AbjJQQB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbjJQQB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:01:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F1E95
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF804DkW/NJxlGapINuoaCixbkiBystSq91MpH00N9pqueGlyyYkk58Yb/QpMGwcgKuo1GZPdHD5uGCoHZa1Talf4hlLgH0YgegOFwAcIGikjvTftdYaNRl+XaWjOREd5YZGlhhhQPLavSIb2nxjhPSi/u5+yzRQw5d2rlw+FTcde/bQZ86edPyVZuRCu+dsVKCRZLaA1QDnyHy+ZMMWen05Yxu3ntmdX8eaZm+IVZvp4xiPSD97w0IFepcO0m2zh63VYQKZtsd2GtHTT/ace72vDyQ/sMgMsWZAM3fd7bnOfgLOeftBm4ZxR/5VqK3JJCSgTDVkNfSCLFqJQBeBBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4eo6hC4jYZ2BGQ8V1JKp5LnqY6taD0+hZWcQ3yq7fA=;
 b=YyaAFmxWG63bqv3Z3Eo/OIrqhSeMHaRPFZzNkZhoiGsp8glVBv77gUhGdE/8NSDpMgNlIH3pmrSdq3xuRWSHBv6FU67JNZ/9lY2HSWkSBWjGl184/IPm6XHff3FzMbraYT11vFAQCfpEzN81fwfhPym+tq50did2WVcmou7CQ6PqnWFrx6JQDvo4fxn3EXKbyQ+ZwfNojsQHLWastjFuuvKluZrGDkgStBNmCgz5XQYatkiV5RpNnmILhe8ivkASDnh0O9wOsx5FXfV712jvKC+ZXZCtuLZWPEfv/UXSrBI0FoHBRpcQgDWRbqz3cUbn2gFXyRqlZR5ruSL81II3FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4eo6hC4jYZ2BGQ8V1JKp5LnqY6taD0+hZWcQ3yq7fA=;
 b=WK4jXEpXI2ra4/maqkm3eIWTIsiF6dQZ8N2tlnJqS/YiYRTgB+i8+xRB5fNshGvpQ9a/1Y/vvBCRW0iUqNp7vxYJ9tHbXpKLmFqGeI9sz63gW7ji55lTZWh/ozzmENZcpQj6ztAiO3Um1ELa1ibP+q1jrzqT+EJ0wd26nZcGFVr2bhfelytOwj/dqL20AWvStUIvjCJlBq7r4UxqHllDv8MXo+IRF9J0oUVIfOVmVG0Kh2brRr7V5Gy1QgxMNuzBDQwel4Ifvf9sM90rP9NJPlBEUhSU1PZDZ7XCArCxc2eg0sUFjBm5vFDcmzdU2RR/q8HL3yy8YQsC/PhEGu0KSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB9254.namprd12.prod.outlook.com (2603:10b6:510:308::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Tue, 17 Oct
 2023 16:01:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 16:01:52 +0000
Date:   Tue, 17 Oct 2023 13:01:51 -0300
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
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Message-ID: <20231017160151.GI3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
 <20231017152924.GD3952@nvidia.com>
 <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
X-ClientProxiedBy: BL1P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB9254:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e5410a-c7ee-4d02-d46a-08dbcf2a60d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vT5G5szHWLZsIyXtQNhSyx6oYEIpp4sdQ0fLB+vH2h53JXVcVt6LrWnT1OxtQy8Pf95LzR9XH8HxMh4TihsZyzx+BORDtlc0EnwdhHgLSd1Bcw4P0qkPFqlkoc8z3hnAbUlYe16kAsUorbLT4QsXtMHjxAsrfM4ZP1CavmhyS8hPSaCsfjpdbBDUxJdaz4Z0/XlHdzspeyoveoyI8YpZmsEivAAAP+4aE4Gkkt/dsmz0l9QyThTjtFW3u0TXjscT4LK8D8k8mIjunX7InfP+DN7qj7vVRkA7lg6mpReimSG/YC2wzRVpeTkzOI+rcjWmVAWj3lNIBvmhFGIqKxkAMRQ/kLDZxhJUzNT0sUy8NJ3m3KrAKkWZTqxRAgobT9wDYJg4g0kYP0ZSYVoHCg8TASeBDdXNWtrYBmsqSumBp2gxZ8+g0OBXLFj3CISuiSVjgWjcPHvovNnCWj4R99u9wJAPsOjIQJvJnfhV/patdxQbsnhkPJSqXYJX8QXIQVGP66o95Cnpl5DqBZQi0IJ8ZTRIWP8CVEqQ6UM4ZatSrtOkOlK1gFCO+ZSmUOZsXRkU+ChDS/NfUAMN3fBbCfSjfpQWV/O/v3M/wa6rFXOc/vg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(1076003)(2616005)(53546011)(6506007)(8676002)(33656002)(4326008)(6512007)(8936002)(6486002)(478600001)(26005)(83380400001)(86362001)(36756003)(54906003)(66556008)(66946007)(66476007)(316002)(7416002)(38100700002)(2906002)(41300700001)(6916009)(5660300002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZMei3Lf+hv8O7LTkyMTrqHmTu4aQnQOlGNSYsHhiMXzUKAtU5IH3ZW2wYYrl?=
 =?us-ascii?Q?4bXBGr7N7f1GPqnVHUr7COFgmO85RpUbpxCjOPO6gfaHS7LIxvgU4jQQdAus?=
 =?us-ascii?Q?PTXapA5+uyEfTb8jphV+GofSXyCtKZ65Jsjt5alCPud6e09Zu5C+0rnjjklo?=
 =?us-ascii?Q?o4Gr3e2kexhsC8TaUaFhRbIFIwzZ2Z0v9sIrmOtsgwrIypnZ7tgs3aUtMN0Y?=
 =?us-ascii?Q?+f4sOOM+ZkIHRmMKcEz1949sIliO7UnF1j9U0S0zixFoGEyKA4YWtcw67l96?=
 =?us-ascii?Q?4f7CkF2vKEpsg9gQXv+eTdx//RCy65nlC2p3bgJN5ZGsXok7dgwRs6mIBRlL?=
 =?us-ascii?Q?5get/OPnLFxlj/P53PD4Njp+/5FKQVNCYnE/cLz64B9Gm6xn7K1pddFqNiJZ?=
 =?us-ascii?Q?gA+JcxQOrtVY9uxaAR9e7JJ6sZZWuK0zLSLciPfEfyh33oJBXMRyDjkhr34T?=
 =?us-ascii?Q?CHSIXNpXhbfKYOWmmzMN9BVRY5tJjP7ZTxA44rEbk7AaHnBVKHeHJu+x6WhU?=
 =?us-ascii?Q?4YXWmwSBTUokHn7ofzi5ygd1mJPBQkiW/NHsTlKYrtBVcemlTDLpA+qkMLAN?=
 =?us-ascii?Q?CYKC2R3aLgCRKsWeVqcErsE/wvLI56iIYA2NKYLNmcY4KGAPB22Hw4sZT/jR?=
 =?us-ascii?Q?YNCMhjXvtc4YRCkzbstg+FfLbQ6gOQpEn/ct/zTGbHWVZtLsFjh3pRn4r5Ew?=
 =?us-ascii?Q?ETkF91rKEjBGOIFBu0IQkJ60g84FqyUp0osd3YinuicJiIlOUIVsvTpvem34?=
 =?us-ascii?Q?XIqYc3QgKmFtmlwA4lT3ANbYyVIkYsXz39uPpc+moPIJkBnifcKQ/QfzNZB0?=
 =?us-ascii?Q?SWLVhU9a0txaMjN+Lv/YiY8UvXByvIKBECK7TY0eWwYp0OH0YiJAfsWXvIfk?=
 =?us-ascii?Q?5EekakxxlvLbu0I62ldFKU9tRTEkUg25nR+581jQyWckSUQ3A6ckDZn7vtON?=
 =?us-ascii?Q?9IlhuA3mJVHvrj0Xs5VFUvXoRGFDEUfjXKBYae5OZY2+THZNhhyIT8MHKA5s?=
 =?us-ascii?Q?sPK97P1fnl8GicehQ+ptsP3OS4bT1rchCVdA8PEz0dzfKQkOLGoG0ix2jVIT?=
 =?us-ascii?Q?4yIJV7+Fcm8l3myWxAOoeshrrF1VlhAjj0J2ZDp41/NadH5/tLJa6Wq3bJMp?=
 =?us-ascii?Q?zJdeLSw3jyz8Yqe5gT9ysjHK1UQGVWfG2cZAZaTNmX3Bdd8vRt9wrWdlX2NQ?=
 =?us-ascii?Q?BmkpCBpGMKm3x37hYnhfgC4TG8u8M7NeFfcN+QL5slQhQWOLJH9eEh38joct?=
 =?us-ascii?Q?2TnABqAZFssR4JQh1UoMP+YjySR7QKXe9j6NKSClgTtB0hFAEO25bLtWg+Q6?=
 =?us-ascii?Q?InGTSy7TxfUQMgOBRNsyJfE6QL3ckpLF2tYno2buw+0X1iS7ziqvL7MB5z0p?=
 =?us-ascii?Q?BfChtugbeE/7q9veG0lmRczgqU8SO03Rop+FWZC3K1l8HQXbVnJ625J4PC2s?=
 =?us-ascii?Q?B8ok+hFp58T7KoegUoysnF22hd7bpCpEPE4wI/OVlcznMLwczNt7iIxobi3I?=
 =?us-ascii?Q?SfklFEzToYmYipkucGYnvrDPJ1DTiqiYLqykXIHC+85PLwyjOSrPy+6DlCxL?=
 =?us-ascii?Q?xO2+RW4fzWTmYgPhLqR1vZLW5obowm/ZXjRDr1Yr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e5410a-c7ee-4d02-d46a-08dbcf2a60d4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 16:01:52.4726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zoDYXhzA6vFef/tlR4SpfgCId3S/UDChQHuK24rGsZ7/t+2kwaeqs/+cFa0mQbY5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9254
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 04:51:25PM +0100, Joao Martins wrote:
> On 17/10/2023 16:29, Jason Gunthorpe wrote:
> > On Tue, Oct 17, 2023 at 01:06:12PM +0100, Joao Martins wrote:
> >> On 23/09/2023 02:40, Joao Martins wrote:
> >>> On 23/09/2023 02:24, Joao Martins wrote:
> >>>> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
> >>>> +				   struct iommu_domain *domain,
> >>>> +				   unsigned long flags,
> >>>> +				   struct iommufd_dirty_data *bitmap)
> >>>> +{
> >>>> +	unsigned long last_iova, iova = bitmap->iova;
> >>>> +	unsigned long length = bitmap->length;
> >>>> +	int ret = -EOPNOTSUPP;
> >>>> +
> >>>> +	if ((iova & (iopt->iova_alignment - 1)))
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	if (check_add_overflow(iova, length - 1, &last_iova))
> >>>> +		return -EOVERFLOW;
> >>>> +
> >>>> +	down_read(&iopt->iova_rwsem);
> >>>> +	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
> >>>> +	up_read(&iopt->iova_rwsem);
> >>>> +	return ret;
> >>>> +}
> >>>
> >>> I need to call out that a mistake I made, noticed while submitting. I should be
> >>> walk over iopt_areas here (or in iommu_read_and_clear_dirty()) to check
> >>> area::pages. So this is a comment I have to fix for next version. 
> >>
> >> Below is how I fixed it.
> >>
> >> Essentially the thinking being that the user passes either an mapped IOVA area
> >> it mapped *or* a subset of a mapped IOVA area. This should also allow the
> >> possibility of having multiple threads read dirties from huge IOVA area splitted
> >> in different chunks (in the case it gets splitted into lowest level).
> > 
> > What happens if the iommu_read_and_clear_dirty is done on unmapped
> > PTEs? It fails?
> 
> If there's no IOPTE or the IOPTE is non-present, it keeps walking to the next
> base page (or level-0 IOVA range). For both drivers in this series.

Hum, so this check doesn't seem quite right then as it is really an
input validation that the iova is within the tree. It should be able
to span contiguous areas.

Write it with the intersection logic:

for (area = iopt_area_iter_first(iopt, iova, iova_last); area;
     area = iopt_area_iter_next(area, iova, iova_last)) {
    if (!area->pages)
       // fail

    if (cur_iova < area_first)
       // fail

    if (last_iova <= area_last)
       // success, do iommu_read_and_clear_dirty()

    cur_iova = area_last + 1;
}

// else fail if not success

Jason
