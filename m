Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A61A5AEDC7
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242158AbiIFOju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiIFOiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:38:23 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7631F99B73
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 07:00:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNz07BIl6+u/pHKgPp/rVAu3ejVv9Y2PglSjFmVQZcr3nSaXAoHXRdKAy9zgzzatL/KcupAcEFaa1ZhSDh2prvZdGxXvKgVmeXl2JwA6dN1xPpiHu9oAnbXvDBrBnYi9haQCV4UtjGDiuIeIe5Z8/0RsdFyf6ZwkSI8y5dkePy3pJyAQtotcuVaLv3Dcb/rdks+LfuBVTs2keVAMcnTr8oCDKdTJau7tRjnc97FEvpJTpw56arIfX1IoYDrSTQa6etGdAga18VCbD5EhrGVf2mrFv3ODjTS4+FbdLTeRk9ncI/8FyYnI10Zvfbi1ZwKQensykwa8icgbeM3lbHSe8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twTBX3xvzitCPZ6+Pq+34RJj3NkEAP70+yMkxqWh0r4=;
 b=e2F6tOkHA16QQkl7ZN5yEFllI+dSJRrFAJdBPDNsC/jethIN2wXb72GIqP8s2fiVhniEgJyYz/ZgLv3nYy4POn2nKiV5yOheCHSCLlsG01CBx+4GyvB9EYgWl9z2DVwPHZU6/SfKcOKivl619jKqzLuZ30He7nUbnoEvRi/175Fh7J/z2Mp9WhAhiliMh40BcvMjl9G7tLnhOLrCXqNgbF1P6dDOb7gYRnV5+UnuO/mZ+5pyg4G2it9RRFv+kxcZlui3fqZPLfX+NPXLWMvnQEc2P5HFJ1j01gAgaM1cjG52fdz1YD50URUOYP1FN1uRq8N6l3kLOM7TrxLxV8ZE8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twTBX3xvzitCPZ6+Pq+34RJj3NkEAP70+yMkxqWh0r4=;
 b=An6z+yj2ntXgjYfybqLnKfdqQ96ly9WSrqMf4mo7aZacfnc2YfXhZGdmbj3Y6yQzXKHV5mZWjDvsoe/EBgyBIUprX9YYGl2TwLTp9klC2L7y6L5jUmupyovbqHh9n7/rR3VnC2v8uUJclHs7ASV6r3WFVUIl2tshs/a2aRB0ElTtGERNAL++jeKupRnqLcTI8vpXA3RxiahpITbn75kfmiw96We96HrvRs6aMBm7VoA+joWfZvDGuivPOuz58wNjJbsK/9DVP7H8FSXlCHZ1ugoiV2rl5Wl77d9Zseu8sLu7L57vOSiHo2wk2N67KbHMB6s0Z0rdWQR/Q4y0JwGFeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5348.namprd12.prod.outlook.com (2603:10b6:610:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 13:59:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 13:59:05 +0000
Date:   Tue, 6 Sep 2022 10:59:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: Re: [PATCH v2] vfio: Remove vfio_group dev_counter
Message-ID: <YxdSJ05uMye4Cm9/@nvidia.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220822123532.49dd0e0e.alex.williamson@redhat.com>
 <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220824003808.GE4090@nvidia.com>
 <20220824160201.1902d6c4.alex.williamson@redhat.com>
 <20220825004346.GB4068@nvidia.com>
 <BN9PR11MB527619A0314F21B4FD21182D8C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527619A0314F21B4FD21182D8C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:208:234::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e607007-7ec0-468f-6735-08da900ff60c
X-MS-TrafficTypeDiagnostic: CH0PR12MB5348:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDaQ4S9ZprA6+21Vkkx4gaYF0NHlBDcI/tdFakmL/FGUWbyUVdm4cxc0jRoYemGG4sEw39+qY4mOudvjhvsXzoeEldKpRR8+BlY6PvhE9DZ8VsC39BmXTUpYP92n4iWUaLeLo+s6WHyzc/xw7y81moNydT+eaaDf9rhjH02UOUplpVK9v4MDj4sLDz3Z8Bo1eG3s+BgRNzDS6XQH14oOEqsOwXR/9vZ67ijWq4+oSOy9nK5EniOhvkJOBaQgLBNp4hcivD7T/iSJ6P/aYquRZeTG9//Q2tFQAwhkUWzBwXMIInIV1FG6xe7tI+mpV0XIPC9ogFfghAa7FjIGWYSTBYJSef895yyJvRKEHmu8gcf9RSfrWpYAo3U/MreYAJ7YyBii4aAHu6/V82rPQaUYDUz48BaNJi5UeSSm0659uxve5/MWZP0FiB9fZ5u1wuVF30dDttFjGp6CDuVeKXwlw2gNIQoT/jPuCgRkIYxVdSZpLYqkyfeAl/paGvOuAoNpDnDlbN3duLVZBcLdPcAYw9xaL9gOsUSj9HJYxApRJihmi7tSu0sRxAcfYdJ3OVp3p6yLYW4R57WHt26slMAEy1IL1dUT7vI1FRhmBtDgBTAFnMlEmiLYWetwZNDvsGxX3JB13myRsCzlUVGrAM+/g9n7TJGOR0FL5CQttP9B+VKD3kaWSg9gvrGNPasI0rZ2uGXGvg/ykPR8LEmYvlJuzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(26005)(6506007)(478600001)(41300700001)(6512007)(2906002)(2616005)(5660300002)(8936002)(6916009)(6486002)(186003)(54906003)(66476007)(66556008)(66946007)(4326008)(36756003)(8676002)(86362001)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wCqSyHASEyJPEcA/LssIXgOx5LpSGWx4ffC/Dbx0XvIcrcooUYzncH77xPHu?=
 =?us-ascii?Q?xs6mePYluUPc+AyAlvjsNcqacmkLvYXHs56hGUm1A5sq6qAddoBiN35hb4/V?=
 =?us-ascii?Q?tDIoSE4imsm0wK2tmNXC+GFIlkvwyeStifKu3zCh4MSCk9bb/2ewXDXAW5Tx?=
 =?us-ascii?Q?/OE5pJQcF2P4hwEUUye5y3I09gIwo2LLXOMou85fRwEb0AXfAhF6fvHzPl8u?=
 =?us-ascii?Q?HBJVMTOoq6DmtgtJXtnwy8K+ecGGw24fAzUcA86o6HNq1S0Rz3qa70spHiPm?=
 =?us-ascii?Q?46PImWAptUhZ4+QyM93rTzmj7fhIuaHPI0/gtM6+ZFg8zd5FHsBoUjZhwI7m?=
 =?us-ascii?Q?EdNBX6CKhfgd94nXJdek/nzzqz4tzvR6GK+TJWhrjJ2//rvi+pcI89uY+rbA?=
 =?us-ascii?Q?M1TJz7Gu6AdtDYJuzE6zFp3iPG6lG6zSL4O7/362QezSayE6KmxPRfL7+6Qb?=
 =?us-ascii?Q?cR7T8Cx39J2T1HJo8dVzOWbvH2MlaGEq9nCfDFce00QE1LAkO+6T64+m8SXN?=
 =?us-ascii?Q?qmKlqj1KAPMq81Ocqy10XOprf1rPemMqQxmAiqpH9rkFvF3I9yP3xtd1g9qu?=
 =?us-ascii?Q?dF0QlO7XNPrQXjhrPNB54ctgaFLJ7sZc9lWs84r03ElO0G42eFS5ushyVKMs?=
 =?us-ascii?Q?T6Fs4+ClmvnGF9NvqCAwu5VW0BJC/NqIUUgJBnc9cVyyzKovWKkCoyik7+A+?=
 =?us-ascii?Q?QTyqegxYM+kQBKPMm//XhgZjCU35874CECEP5IZ+3vnmYZyZAcEGYKlhg8cc?=
 =?us-ascii?Q?gKBGIaG/K0U8VF0LN1KHxyzZ1aguNWfVah7JyenbR1WCd16eodvlHqSKN1aB?=
 =?us-ascii?Q?eHJFej+ZR3ZXP+q9rZZKR/u6uGyTpHbB6U2VrzuG26DKNv53OQtaTnWHWYzJ?=
 =?us-ascii?Q?KnTCNADAmzVSADreEyNEh7B9ihMj+ZH5SU3cOyIACF8EYOhg7Cm+JtfRisYl?=
 =?us-ascii?Q?+7d12m+HDi26zimzN3RyiQV9xu6gHUkwRpf3bOM8NZbK+aM6dCZZB6YJcu/U?=
 =?us-ascii?Q?hNM0xvKtbCHUts1D4MGeWvNEPPHGcTx9BhxWAIPsmBJcwkiIQFHQP0WN3l7o?=
 =?us-ascii?Q?MoHYFHBEcC81EYnU4P86w3LLGj2+DiLFnRM27jQuJFLlNKjtaUWe1quEHTnY?=
 =?us-ascii?Q?7qd8s8CUExvzEKIcHDK/d8WteJDQCMOXG25mBK9QUrBHYc+Mid/uSWL8S/eP?=
 =?us-ascii?Q?1yzRudu8xfQjV8SQBVnApsALs5x4Io1AD/sAozyN5mLpOB1+iXswFUgrK3Sp?=
 =?us-ascii?Q?UOOB/aSpuxXESHRDMmxf54leGs+fjv6MqybeCx/Rfb8Xkl+bBqW6Aa/c3zLV?=
 =?us-ascii?Q?12RqnlXJpzC3N1R90T5g0SmdEbXAYwUAxpVu5SogrzUOFOQI7M4Su3FQjETl?=
 =?us-ascii?Q?rU7RK0B8NqwJlBbML5O/S4NJGGAUMwWrY1uwgvEp6PxOhiAkO291grFos8xG?=
 =?us-ascii?Q?fKlPfnt61f/zOROwg/H39InC8EgN40cVeLA3hcv3RFpK0ckssGXbHdOWzhdN?=
 =?us-ascii?Q?li4Ao429J466lAHOfLMoqoyjaetdUC6qJg4cF0JkXJvek35xnKHLo6HjW9tv?=
 =?us-ascii?Q?IJaX4efTuFyVa7AOSjXcHP4txcl8nCyPTu4hWcKV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e607007-7ec0-468f-6735-08da900ff60c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:59:05.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWlX/ZtkMS896TGKyKDpO+wdXls6XbMHCL6iGvkmJgJkUVMhko22ZbURgAoswJOF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5348
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 09:21:35AM +0000, Tian, Kevin wrote:

> Although mlx5 internal tracking is not generic, the uAPI proposed
> in Yishai's series is pretty generic. I wonder whether it can be extended
> as a formal interface in iommufd with iommu dirty tracking also being
> a dirty tracker implementation.

It probably could, but I don't think it is helpful

> Currently the concept between Yishai's and Joao's series is actually
> similar, both having a capability interface and a command to read/clear
> the bitmap of a tracked range except that Yishai's series allows
> userspace to do range-based tracking while Joao's series currently
> have the tracking enabled per the entire page table.

This similarity is deliberate
 
> But in concept iommu dirty tracking can support range-based interfaces
> too. For global dirty bit control (e.g. Intel and AMD) the iommu driver
> can just turn it on globally upon any enabled range. For per-PTE
> dirty bit control (e.g. ARM) it's actually a nice fit for range-based
> tracking.

We don't actually have a use case for range-based tracking. The reason
it exists for mlx5 is only because the device just cannot do global
tracking.

I was hoping not to bring that complexity into the system iommu side.

> This pays the complexity of introducing a new object (dirty tracker)
> in iommufd object hierarchy, with the gain of providing a single
> dirty tracking interface to userspace.

Well, it isn't single, it still two interfaces that work in two quite
different ways. Userspace has to know exactly which of the two ways it
is working in and do everything accordingly.

We get to share some structs and ioctl #s, but I don't see a
real simplification here.

If anything the false sharing creates a new kind of complexity:

> Kind of like an page table can have a list of dirty trackers and each
> tracker is used by a list of devices.
> 
> If iommu dirty tracker is available it is preferred to and used by all
> devices (except mdev) attached to the page table.
> 
> Otherwise mlx5 etc. picks a vendor specific dirty tracker if available.
> 
> mdev's just share a generic software dirty tracker, not affected by 
> the presence of iommu dirty tracker.
> 
> Multiple trackers might be used for a page table at the same time.
> 
> Is above all worth it?

Because now we are trying to create one master interface but now we
need new APIs to control what trackers exists, what trackers are
turned on, and so forth. Now we've added complexity.

You end up with iommufd proxying a VFIO object that is completely
unrelated to drivers/iommu - I don't like it just on that basis.

The tracker is a vfio object, created by a vfio driver, with an
interface deliberately similar to iommufd's interface to ease the
implementation in userspace. It is not realed to drivers/iommu and it
doesn't benefit from anything in drivers/iommu beyond the shared code
to manage the shared uapi.

Jason
