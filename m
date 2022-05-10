Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F9522476
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 21:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbiEJTAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 15:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbiEJTAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 15:00:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F9557104
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 12:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dF95P3+j+ScUiQ9xBo+nJM5rvUS4slaj+PusXePpNKQ0R+hQf8Q0xI8A+vXk/l/8FrOjcnd0bZGfj4jzW3TkBXwlX9g5IRjnAzl9KQQPv3+ztjdXtxLrWO2MwipLSge/rLoy51enldJiyAoiaBBgdsqA/AGLxqrUE1xQE63dxPhnXTecm+mDEGh1i17Vnj0c8VLcocl1P4eZmSOfapa9yob4dqo9HdoO8JrMQfoXMA0sCJDCSKqqCGWy34prKM6Jx4DvBDEK9IfpDnPTQnLPZ9reNt9iRo/3gsEXVYECWrb635QMC9zN96jg0TI93meOQk1UaRh4vrL97aciH/ErTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESMDL6dURRYuBabrGGN3p+KcPwU2JqM3gnzAW+lQSl4=;
 b=TYFj4wZ4/C8JctH1l7GQ6GpJDDHmosXxwH8FvbvR1GnQLcNdMKDxDiRoZemoJ042UEWB6avxLhfEBWPOKgw6jTCtCWKrFDypMu2Fru/dcASKufLXgSdn8SIQIRm0avC1gQQG4mC46XR2NDBZP/IHmpfWRBa4L8BTgYyjeghUS5zUzmQfCeTxf5Sfn9UbPOVKm6XcUOG/4kwyGjfioLsULvEIhQbFreSLpb9c1nHo2jrgfLW9u3HoDsHZC6YfmgrEjDL9JbbRHrKrFjshxbY98I2I894L01TbkfuSeKtIVgXTaJBYWCqsHt2H3wjbauzqqpJl5BvzqYvViIFcwbAPBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESMDL6dURRYuBabrGGN3p+KcPwU2JqM3gnzAW+lQSl4=;
 b=I3PYy2xp6k89SANNshJRDCU4UdG601lHrNPeDIFSidwZD2TK5IODGCKcjsu1Jd7223MmfaxFkyHnmrspBTnp8p/MRa29+KC3fNdbP4zXztiau9ZpQWW3ze1IZ7uCHPUdNRjmHdiCzbAKpKzAiWvlUqen3UiOfmboAkd2PGrIUeorBoLskefiX0uDYlpKIUpgohwmDg/So28e/YSda3fdEamVFzuBYYnbX+5bOU5NEH+V9xE7iCfVMmwJjnMPTCSuu6om5nzT5xwQjtMU4NrE0tHVpsWkrC7OeLDeUPjM5M5EHvQijoZQMQ5D7Pu0f1HbtiFh3Xvq8KXzeyDypPy3Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5780.namprd12.prod.outlook.com (2603:10b6:208:393::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 10 May
 2022 19:00:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:00:11 +0000
Date:   Tue, 10 May 2022 16:00:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220510190009.GO49344@nvidia.com>
References: <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com>
 <YniuUMCBjy0BaJC6@yekko>
 <20220509140041.GK49344@nvidia.com>
 <YnoQREfceIoLATDA@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnoQREfceIoLATDA@yekko>
X-ClientProxiedBy: BLAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:32b::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8861c1e2-b08c-4c52-7be7-08da32b74e8c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5780:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5780BC0FE9483D9F457506B5C2C99@BL1PR12MB5780.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mg2Fs3EQUN8XvjM6PiFdSj5xwagQnBVbh9G3zHj+azsJQjTkDt77vV7e09OE0yrbzZ4NOwyRYfdRUknBAvBF+uRnPuU0MRj+aKxMcu50nppvzVjmHYqmS6hUIqoP2PMqGJYMltF4OsLcMiP/d2VF5FjXXouq3xssAbkU5+YOrWbnnVPAOQBEqEzHZlm0k8zONf2ZDXSbT4K1AI8I4EESERWCu4xMGyChn1do/G3yy2nc2GfBCfBmYFzA/5qdoaSmddXe6jF20pKY6x+eXD5ijgAt7xwWl75bIrCnpVBK9MWfVrch3zypcUf4mwxk1qoT6RwNonmxQMkLW2YNWmWowkGXyrEgMnuk45eGPqIIRjS9r80NpdVnuG8Bt+1aN34bUIaOKBCP3KQnfCmyPDelXoZyNq/Lp27CupQBfrzcFUUyY+9dSKQRgXhIyvNoqEyLN3JvD8HM27wrh7X7JmX10rPv7niqngkplzFEq8FY6Xw+kwwEY+GD2sEuR24lDBPdQqAjKF055GxJGNRd14/a1rbKMQP24OpkBXDnsEsHjKSjLwKoeUxquIQ46j4xWVSmc73OxITmwR6QG3fdBJh5p5MgAW5lATEFo0J5PrvDNb7X2gFokk/xh1u6ue6ASt9Od1PvguGMs88UO5KVT0yErA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(38100700002)(26005)(186003)(1076003)(2616005)(86362001)(33656002)(66476007)(83380400001)(316002)(4326008)(66556008)(66946007)(8676002)(36756003)(7416002)(2906002)(8936002)(6916009)(6486002)(54906003)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7PP7cuzLZht7UwMbrmSQQXrudTfzGT6sLYgWv0CdREpBXMVR6NatEN60qF/x?=
 =?us-ascii?Q?9iaFnH/ok9hTMhBdXokkva3ibV3/iggtdYUmYn5oonWoTdNEApxT5LPUKM+J?=
 =?us-ascii?Q?OxXBXqDRXE9bMdo60XShf9NDGvCVgkO4AntiHiYG/CnmazcRaiN4IBL+OlGr?=
 =?us-ascii?Q?l3jsIuPxkdL206oIh/Jyw6/Gcr8tQm2RpwVUmhn8ucrFj39G7+JwkXwcfICA?=
 =?us-ascii?Q?+cUMBShpOFe1EMV8yVgGeMRJMSubZzhY56aGMKLdEXDfpYbMtQchA6IIeP+d?=
 =?us-ascii?Q?LmUpmgt/WAQDZ9A315/Z5FKaBLEZU36PbYixdxKBEroaB+MEoj3229EAYSNV?=
 =?us-ascii?Q?IwArx3a6ZO0d0GBYgbN5QlEvJF3GOAdjG/gePVip/5aN4O797ZS28oAGAyib?=
 =?us-ascii?Q?Z/hlXRf/cOPM+e1V4iUc2uFedE3C3kJYxzch3n29ItadjlCxg5j4YaSXa9Mp?=
 =?us-ascii?Q?pWFBFOqWi3MEdcA3uTmGkP/rJOIDSKaZIV393sBvwzQIair5/KJhZlQSqDS5?=
 =?us-ascii?Q?nAF3qLOURD7lm+bh8Mv0jHytwa19IRcNHdrawRO2IC4Ste1YFzRivuvME+GD?=
 =?us-ascii?Q?hhS/DLs5O0ZWXJUaH364kPQLDh8ER6mCIprGTpNwItxj/LjJa7buYePzd8Cd?=
 =?us-ascii?Q?5D1tBRFpMX+VobI5yjTOagT/dHTAMo2Y5viIPKgbxLS/OBmG8qU3aTfLq2MA?=
 =?us-ascii?Q?RJhFJpjl/N9VcfAnWYlwz5hUtZl9OTOyFFSwz2Y0hyut1QoTiTIUU8SDKXWZ?=
 =?us-ascii?Q?+tt4tb2WKzmvsLbV1oZRG08oRdPFal3YtZYZxzvr7txSUdyM99W17eKJ7n7x?=
 =?us-ascii?Q?0rJBbFGcOOIUvqU3Q1a+TJce8lBAwYZUHN9BcYn/mTd6nFK+3SNEyaGO2yuw?=
 =?us-ascii?Q?6d07sTHlv68Kfq4TnfPZYCgmTeCF6pF1A96lH462y/+BAwYnjIzckKYmJUsD?=
 =?us-ascii?Q?beaGrJJPP2AU9src+BB5mme0ShXNFxnKCLr2hVt8W06Y7VFRsUAhUSUahOWb?=
 =?us-ascii?Q?ge/AspUEYbaE8pxaKdFeg7KbeIDk+hn39pFplBuSjPXaFceXlbKHwsRcSCAq?=
 =?us-ascii?Q?FAEuWiQh6p3kIivFTFDDsLsIxNveN9C31+bWuL+evVIXInBacNm9xVNvZ4RT?=
 =?us-ascii?Q?ANu9KvWu6XyA8qkLVe5hlOTaCsdRpWQODApUY6JYmvQUYm5BN+8IwUtqUKFN?=
 =?us-ascii?Q?oiROYt5a7a8zywe2n8DxL1rsFmtBAHq8vC1WNIO7wSXkK47kiZYr/z/A3QnY?=
 =?us-ascii?Q?HE4fOwdAFgyIUpH1Q/nc6Lw2G+f2xJk45Kx9ng3abLPfiQUbHobJY+3m4KNB?=
 =?us-ascii?Q?AwBBXw+YPJvL7mTkOqHOUvBfzB16xMUzwkqiOOIdJg52xY/hYDOPQgz8f7Li?=
 =?us-ascii?Q?LQoeVBM71N9vLH/9etTEngZXC1eZ5duRzeiDIm/f8kIC0jpV66qgPGUBhz88?=
 =?us-ascii?Q?OTo4ryBnq3G+dRi/S0G8zuK0oOkcxtrIyex44gCUxRaqUtSK5Vq1gA5o0TJw?=
 =?us-ascii?Q?WCAvqBcRs6yGmgaDSRnb7lGY+f2e6CdyIC2z3KiL5xGmSMJtQTzORHovD/QU?=
 =?us-ascii?Q?5vRIWuMVPOPAPqNtjoWnkzbdRGm6E+76q1HxtklODR436Nnzd8hpGTo7THNf?=
 =?us-ascii?Q?8YXMuZ8qp7zM1h3MKY8zD5mvTQHE/Fnk3PTgM4JbQtC7mTiwj5S2ygAwCDJX?=
 =?us-ascii?Q?kDvfWiOyEsx6AQPw48zJmAWqqltOORyoBG+MerlOq5pVStK4qgeuRpoBKl64?=
 =?us-ascii?Q?BR0apQUomA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8861c1e2-b08c-4c52-7be7-08da32b74e8c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:00:11.0828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/hCQzcbQL3qYYBCn+7m8zaGu+9wZWqZlsogOkVX8OshZCX3/8P6X8TyXDZlUK6+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5780
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 05:12:04PM +1000, David Gibson wrote:
> On Mon, May 09, 2022 at 11:00:41AM -0300, Jason Gunthorpe wrote:
> > On Mon, May 09, 2022 at 04:01:52PM +1000, David Gibson wrote:
> > 
> > > > The default iommu_domain that the iommu driver creates will be used
> > > > here, it is up to the iommu driver to choose something reasonable for
> > > > use by applications like DPDK. ie PPC should probably pick its biggest
> > > > x86-like aperture.
> > > 
> > > So, using the big aperture means a very high base IOVA
> > > (1<<59)... which means that it won't work at all if you want to attach
> > > any devices that aren't capable of 64-bit DMA.
> > 
> > I'd expect to include the 32 bit window too..
> 
> I'm not entirely sure what you mean.  Are you working on the
> assumption that we've extended to allowing multiple apertures, so we'd
> default to advertising both a small/low aperture and a large/high
> aperture?

Yes

> > No, this just makes it fragile in the other direction because now
> > userspace has to know what platform specific things to ask for *or it
> > doesn't work at all*. This is not a improvement for the DPDK cases.
> 
> Um.. no.  The idea is that userspace requests *what it needs*, not
> anything platform specific.  In the case of DPDK that would be nothing
> more than the (minimum) aperture size.  Nothing platform specific
> about that.

Except a 32 bit platform can only maybe do a < 4G aperture, a 64 bit
platform can do more, but it varies how much more, etc.

There is no constant value DPDK could stuff in this request, unless it
needs a really small amount of IOVA, like 1G or something.

> > It isn't like there is some hard coded value we can put into DPDK that
> > will work on every platform. So kernel must pick for DPDK, IMHO. I
> > don't see any feasible alternative.
> 
> Yes, hence *optionally specified* base address only.

Okay, so imagine we've already done this and DPDK is not optionally
specifying anything :)

The structs can be extended so we can add this as an input to creation
when a driver can implement it.

> > The ppc specific driver would be on the generic side of qemu in its
> > viommu support framework. There is lots of host driver optimization
> > possible here with knowledge of the underlying host iommu HW. It
> > should not be connected to the qemu target.
> 
> Thinking through this...
> 
> So, I guess we could have basically the same logic I'm suggesting be
> in the qemu backend iommu driver instead.  So the target side (machine
> type, strictly speaking) would request of the host side the apertures
> it needs, and the host side driver would see if it can do that, based
> on both specific knowledge of that driver and the query reponses.

Yes, this is what I'm thinking

> ppc on x86 should work with that.. at least if the x86 aperture is
> large enough to reach up to ppc's high window.  I guess we'd have the
> option here of using either the generic host driver or the
> x86-specific driver.  The latter would mean qemu maintaining an
> x86-format shadow of the io pagetables; mildly tedious, but doable.

The appeal of having userspace page tables is performance, so it is
tedious to shadow, but it should run faster.

> So... is there any way of backing out of this gracefully.  We could
> detach the device, but in the meantime ongoing DMA maps from
> previous devices might have failed.  

This sounds like a good use case for qemu to communicate ranges - but
as I mentioned before Alex said qemu didn't know the ranges..

> We could pre-attach the new device to a new IOAS and check the
> apertures there - but when we move it to the final IOAS is it
> guaranteed that the apertures will be (at least) the intersection of
> the old and new apertures, or is that just the probable outcome. 

Should be guarenteed

> Ok.. you convinced me.  As long as we have some way to handle the
> device hotplug case, we can work with this.

I like the communicate ranges for hotplug, so long as we can actually
implement it in qemu - I'm a bit unclear on that honestly.

> Ok, I see.  That can certainly be done.  I was really hoping we could
> have a working, though non-optimized, implementation using just the
> generic interface.

Oh, sure that should largely work as well too, this is just an
additional direction people may find interesting and helps explain why
qemu should have an iommu layer inside.

> "holes" versus "windows".  We can choose either one; I think "windows"
> rather than "holes" makes more sense, but it doesn't really matter.

Yes, I picked windows aka ranges for the uAPI - we translate the holes
from the groups into windows and intersect them with the apertures.

> > > Another approach would be to give the required apertures / pagesizes
> > > in the initial creation of the domain/IOAS.  In that case they would
> > > be static for the IOAS, as well as the underlying iommu_domains: any
> > > ATTACH which would be incompatible would fail.
> > 
> > This is the device-specific iommu_domain creation path. The domain can
> > have information defining its aperture.
> 
> But that also requires managing the pagetables yourself; I think tying
> these two concepts together is inflexible.

Oh, no, those need to be independent for HW nesting already

One device-specific creation path will create the kernel owned
map/unmap iommu_domain with device-specific parameters to allow it to
be the root of a nest - ie specify S2 on ARM.

The second device-specific creation path will create the user owned
iommu_domain with device-specific parameters, with the first as a
parent.

So you get to do both.

> > Which is why the current scheme is fully automatic and we rely on the
> > iommu driver to automatically select something sane for DPDK/etc
> > today.
> 
> But the cost is that the allowable addresses can change implicitly
> with every ATTACH.

Yes, dpdk/etc don't care.
 
> I see the problem if you have an app where there's a difference
> between the smallest window it can cope with versus the largest window
> it can take advantage of.  Not sure if that's likely in pratice.
> AFAIK, DPDK will alway require it's hugepage memory pool mapped, can't
> deal with less, can't benefit from more.  But maybe there's some use
> case for this I haven't thought of.

Other apps I've seen don't even have a fixed memory pool, they just
malloc and can't really predict how much IOVA they
need. "approximately the same amount as a process VA" is a reasonable
goal for the kernel to default too.

A tunable to allow efficiency from smaller allocations sounds great -
but let's have driver support before adding the uAPI for
it. Intel/AMD/ARM support to have fewer page table levels for instance
would be perfect.
 
> Ok... here's a revised version of my proposal which I think addresses
> your concerns and simplfies things.
> 
> - No new operations, but IOAS_MAP gets some new flags (and IOAS_COPY
>   will probably need matching changes)
> 
> - By default the IOVA given to IOAS_MAP is a hint only, and the IOVA
>   is chosen by the kernel within the aperture(s).  This is closer to
>   how mmap() operates, and DPDK and similar shouldn't care about
>   having specific IOVAs, even at the individual mapping level.
>
> - IOAS_MAP gets an IOMAP_FIXED flag, analagous to mmap()'s MAP_FIXED,
>   for when you really do want to control the IOVA (qemu, maybe some
>   special userspace driver cases)

We already did both of these, the flag is called
IOMMU_IOAS_MAP_FIXED_IOVA - if it is not specified then kernel will
select the IOVA internally.

> - ATTACH will fail if the new device would shrink the aperture to
>   exclude any already established mappings (I assume this is already
>   the case)

Yes

> - IOAS_MAP gets an IOMAP_RESERVE flag, which operates a bit like a
>   PROT_NONE mmap().  It reserves that IOVA space, so other (non-FIXED)
>   MAPs won't use it, but doesn't actually put anything into the IO
>   pagetables.
>     - Like a regular mapping, ATTACHes that are incompatible with an
>       IOMAP_RESERVEed region will fail
>     - An IOMAP_RESERVEed area can be overmapped with an IOMAP_FIXED
>       mapping

Yeah, this seems OK, I'm thinking a new API might make sense because
you don't really want mmap replacement semantics but a permanent
record of what IOVA must always be valid.

IOMMU_IOA_REQUIRE_IOVA perhaps, similar signature to
IOMMUFD_CMD_IOAS_IOVA_RANGES:

struct iommu_ioas_require_iova {
        __u32 size;
        __u32 ioas_id;
        __u32 num_iovas;
        __u32 __reserved;
        struct iommu_required_iovas {
                __aligned_u64 start;
                __aligned_u64 last;
        } required_iovas[];
};

> So, for DPDK the sequence would be:
> 
> 1. Create IOAS
> 2. ATTACH devices
> 3. IOAS_MAP some stuff
> 4. Do DMA with the IOVAs that IOAS_MAP returned
> 
> (Note, not even any need for QUERY in simple cases)

Yes, this is done already

> For (unoptimized) qemu it would be:
> 
> 1. Create IOAS
> 2. IOAS_MAP(IOMAP_FIXED|IOMAP_RESERVE) the valid IOVA regions of the
>    guest platform
> 3. ATTACH devices (this will fail if they're not compatible with the
>    reserved IOVA regions)
> 4. Boot the guest
> 
>   (on guest map/invalidate) -> IOAS_MAP(IOMAP_FIXED) to overmap part of
>                                the reserved regions
>   (on dev hotplug) -> ATTACH (which might fail, if it conflicts with the
>                       reserved regions)
>   (on vIOMMU reconfiguration) -> UNMAP/MAP reserved regions as
>                                  necessary (which might fail)

OK, I will take care of it

Thanks,
Jason
