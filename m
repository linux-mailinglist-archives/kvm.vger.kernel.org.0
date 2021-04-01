Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8E3517D1
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhDARmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhDARjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:39:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905ECC05BD3B;
        Thu,  1 Apr 2021 06:12:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mi4JUVs/RhWnDcPnh4OzgBjlxgADvRZdKfbkqekxjT9vcUjOjF0AMqukn83FPJ5fS8sivBTYTmYdEr+XNx+aPB68baigsopesum5MScLbk1UZxVqFl63mrEGd1HyGldUQWM4EYIodZWYYH29zYw1SVMTaAuxtsc/tQpo9dCXtQ7D+rLtDaA65iNxBvx8FhTc2hy7W0uHOoHGvSsJcxylUy2iCD2z5U5DfwhfSF6bBL3tYWvzHH7agzSScWVbDlcGjUNIzKx/OmoiBHIbUVLn1O8KoAxWMVabOarwkFsFd5PCA0igRP/piOsUXnLBjTf8b4N2Dj1trsAfCZdeDal/Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybeFRWEwGVsFG8ikK6z6UITgVU5sGtbaTB4U9CHvex0=;
 b=NJaqultIjhoI1JPnC/ccJox9e3YMm8mqs8QYo2Nm/Om2RpqKZ5VQ29NWYq4588FMMuYnI0ytCY6RWkeR0iI+zEopagsXl1JbJn7LLmx/GFGJyEJgl65Pz0+JNZWYniSSyKAbmmSxB48Fjt1cO0JL2rakhjWyhpND7l2mUCW/NSR+uVCPreOHbALFaR4ISlhstCdEgDECgT1SjfpWqbOyQLsCP2X8yNehtXNhweXGm0KY8Oe45duSwtnMlFAGg78bXSzTweQUBe2nKQoRH/HAGCrNoWgyqWJHMt6jTobBuQLTulnIN+mAyRtDUq3x2HbO76vcCUX4zpQdT2OWSKFMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybeFRWEwGVsFG8ikK6z6UITgVU5sGtbaTB4U9CHvex0=;
 b=clQk8CQ91VotZ2ARsvpDRpyO9tpGF2s3+Onu0qwaR/qcw2ep79sd42Zi/0uKJS0bj9NMFpOjRA1QT8r32hZFChsQa67N3tP9TZEd0I30Yf57+AG7GaHj1fhs1/FDE7xMLSf63uIMVOkRdcDtrqSO3kUPgRf8Wc5slwO+A1Y+gOUsR207XRqa9KOmq7vO2iMSab92URVipNQvAYSFV+zkETL5v9PK31DrismCE55dq3/e4r37yNzSiDPU/NX0DY/dCdCvYtHQGCNmBaIs5hK1N1HS0r8Uxa6J8KtsKqsPHLXk8+Xxwk9maTMJOMiN14IQxz/Ujev4qABVGDe80fMXug==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 13:12:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 13:12:29 +0000
Date:   Thu, 1 Apr 2021 10:12:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210401131227.GC1463678@nvidia.com>
References: <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210319150809.31bcd292@omen.home.shazbot.org>
 <20210319225943.GH2356281@nvidia.com>
 <20210319224028.51b01435@x1.home.shazbot.org>
 <20210321125818.GM2356281@nvidia.com>
 <20210322104016.36eb3c1f@omen.home.shazbot.org>
 <20210323193213.GM2356281@nvidia.com>
 <20210329171053.7a2ebce3@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329171053.7a2ebce3@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:208:120::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:208:120::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:12:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lRx7b-006kWx-Cl; Thu, 01 Apr 2021 10:12:27 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cb00d9f-4082-4e91-943a-08d8f50fcd50
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB285810E98FBF81447BBE36C7C27B9@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5F5axLj5xeWdqjjtI6ACGC2dAqEMCjoGsHzcD57WkWaBg8VpQ7dcj/NoGr6iKtckmnBKjS9ycAzdaLOFd5HSyGdFF5NAT/krLd8oomHx8biwlACnJGEYsozCIlb4HqoPBiHvgvuggnRY8a3rE8fIMNirzB++iG7vaNb8ot1TrRfGYDU6nXDDfn7zgY5pTgC5gBRrNm3B1ormBo2aKhr9b8lDC1233TpVoMTlLpF15z9vDon1vJz69zx3A6MAnQ9lJJNHRI0ZS/+7/IpRS+hBTtWchfJ2tPIHSrwg2/8D207xXzf6ENzcCX7wH8USpiKKUx7NH0uX0L3xbd9f0ZStJs/5hvnSqiXx9nZyULpkq0LU6S44WL7K/Zs9lOJVFv0WOMCk+3lh6eEGbRMbD7q9sF4v4nQYR7bLEo3kxjX7919nhPkoI1nJo+xA/i1nzYNxtNCVVq7gUHGLc3dyVMXq88yP9Ui48XWr0GmK9Aj0RVtG8M4sBNV1fho2Rnk8oS7Q6R0ifa1jnatSo5prn25928hP4PkxbWuf6eg3FqdqpApi6sWMpQxI3h8UQ6Lhks1yGGbDalnYvM0xVQ6O3ncKWHkfYanrG08pTX3tL8C2R8pjXOnlEGqPXPN8SlD7sU6EuyXrSuRrtiWENCKFL4aUDHAqLSuUS5sPNhmg2r0PlE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(1076003)(86362001)(66476007)(54906003)(186003)(38100700001)(9786002)(66556008)(9746002)(36756003)(66946007)(2906002)(5660300002)(6916009)(8936002)(8676002)(316002)(426003)(83380400001)(478600001)(26005)(4326008)(33656002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y1y7b28CEA9nnTrDAwZHTYIufryxFbKu6UhiNyRW0383/tEf9Xu/6tM5OKeK?=
 =?us-ascii?Q?kgWHi52HDVb+i2JnzDtc9CRrXFze8fm0ZOE5Oq7w0/AplVYp75hwYmTjXklY?=
 =?us-ascii?Q?BKQpY2wxjHL5UrcL5pMORHo1UuVWrQLUtMoSqAib3Aaw1EMErgev/j+kkdyy?=
 =?us-ascii?Q?Jt7LoEtAiJBcopJjpN+cLJrtnCyrjpuas/rGfn8rCFPBEOM040MhEdeV9oWF?=
 =?us-ascii?Q?1n0ds/cBRZym6Jo/MWHojfPfWIScHhZOvyeGTHcf8z4LoZhY7W/eTKWWE5UC?=
 =?us-ascii?Q?eL3kEMpSAw7YnXJ4H2CfzL+R1/2DfyVYOR6xLRMtwfDp6KZ4/FEuiE7DmW/b?=
 =?us-ascii?Q?MGwCeBc1NyW6ogN+gIW+og+4viRYE5k0W2qPQ0DsjHKKK+mxr2WMVI7INCG/?=
 =?us-ascii?Q?/kEMLOZFRddfUsKFpvCZVjEgx0lWts3Y0/4b0to1ghyPBH16m1hd0keOykFx?=
 =?us-ascii?Q?NbCzOVM7S4X40oBgIfpiMtG3MkCd0aZQF9umALUv2giyGy3iZLx6F3qUusdX?=
 =?us-ascii?Q?ES+t7G1qs4d9m1keOWzMOXg8/HhnUu5/NGRL9efLLA4CBPUYbbuLOwzXJ/cK?=
 =?us-ascii?Q?MHJ5YAHN4q+iRkE7oI5vcEXtgQI+2l6VpK8R0cly6WvGSKdyw7d13RgeSuHG?=
 =?us-ascii?Q?8tISJ9XhCS6ZABVE+Pkkdni6HQei7qVeldKFsdj7rGWNJ4QS/x8iZ1sF1bEW?=
 =?us-ascii?Q?GBPdiNxHhAFMX70ujB+ofRRF2MzV8UecOhF/6PiZpIneutWTvL3GTvdXySLa?=
 =?us-ascii?Q?yAclQ36waWkTPBcwFdFbzCWds4hutPxvlZrUgC27RVGrTi42lBd+dYBQKmlZ?=
 =?us-ascii?Q?I4ojuyQJb+uXepi2tcIwVh+0WlvRFZp61CWSN5jNz+6wo3X1XQjV0qiozixL?=
 =?us-ascii?Q?Qzmeps+WhKmZfMF9cQ6lgdF7FwUr7ah6di9pZx8xGzDOBBikh86iIsmTLCZJ?=
 =?us-ascii?Q?1SJxAhpv5HIYTdEqerQYAwLVAJuKpaA1555fxyjxriKheiGKHbs1umf+O9N/?=
 =?us-ascii?Q?T5+A/GW6HzXyyDt5h3lXRQVY+KIT8ew7eSjrupjPrbkUk66pLBT/7+89WQ55?=
 =?us-ascii?Q?fbNjjrvm+nMXOwrlrZrL8xQPm2sfm/jk8gdBnJfKK1sGU59WrrOt8SjGxqAB?=
 =?us-ascii?Q?PJ+UPldpOdHHwoKisiEYgDa86d7HibcjduMOdYeMLljhQnNS5sgGK+buMoQJ?=
 =?us-ascii?Q?e1vD794MCDRcWxDizMT87PLuuMw+yOdqEmxiGig2r/i0dvxdByireuHjA3PV?=
 =?us-ascii?Q?BTLGJI6QQ0CN8l0ekih8CQ2LcWPDO5lP+Kx8vLNTk9MvQtpoDOVjLp6yovYE?=
 =?us-ascii?Q?DeELrqsfH9kXn/+AqhBQ9HBE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb00d9f-4082-4e91-943a-08d8f50fcd50
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:12:29.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkNMSUZ6Q6HDh44RNX/s/ufCEVC7wZN/NC/fqVWBlLWp2GD8mO21dvJaYXXWkQ0Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 05:10:53PM -0600, Alex Williamson wrote:
> On Tue, 23 Mar 2021 16:32:13 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Mar 22, 2021 at 10:40:16AM -0600, Alex Williamson wrote:
> > 
> > > Of course if you start looking at features like migration support,
> > > that's more than likely not simply an additional region with optional
> > > information, it would need to interact with the actual state of the
> > > device.  For those, I would very much support use of a specific
> > > id_table.  That's not these.  
> > 
> > What I don't understand is why do we need two different ways of
> > inserting vendor code?
> 
> Because a PCI id table only identifies the device, these drivers are
> looking for a device in the context of firmware dependencies.

The firmware dependencies only exist for a defined list of ID's, so I
don't entirely agree with this statement. I agree with below though,
so lets leave it be.

> > I understood he ment that NVIDI GPUs *without* NVLINK can exist, but
> > the ID table we have here is supposed to be the NVLINK compatible
> > ID's.
> 
> Those IDs are just for the SXM2 variants of the device that can
> exist on a variety of platforms, only one of which includes the
> firmware tables to activate the vfio support.

AFAIK, SXM2 is a special physical form factor that has the nvlink
physical connection - it is only for this specific generation of power
servers that can accept the specific nvlink those cards have.

> I think you're looking for a significant inflection in vendor's stated
> support for vfio use cases, beyond the "best-effort, give it a try",
> that we currently have.

I see, so they don't want to. Lets leave it then.

Though if Xe breaks everything they need to add/maintain a proper ID
table, not more hackery.

> > And again, I feel this is all a big tangent, especially now that HCH
> > wants to delete the nvlink stuff we should just leave igd alone.
> 
> Determining which things stay in vfio-pci-core and which things are
> split to variant drivers and how those variant drivers can match the
> devices they intend to support seems very inline with this series.  

IMHO, the main litmus test for core is if variant drivers will need it
or not.

No variant driver should be stacked on an igd device, or if it someday
is, it should implement the special igd hackery internally (and have a
proper ID table). So when we split it up igd goes into vfio_pci.ko as
some special behavior vfio_pci.ko's universal driver provides for IGD.

Every variant driver will still need the zdev data to be exposed to
userspace, and every PCI device on s390 has that extra information. So
vdev goes to vfio_pci_core.ko

Future things going into vfio_pci.ko need a really good reason why
they can't be varian drivers instead.

Jason
