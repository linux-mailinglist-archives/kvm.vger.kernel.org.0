Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB87A4B5879
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357077AbiBNR0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 12:26:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiBNR0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 12:26:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB1B65400;
        Mon, 14 Feb 2022 09:25:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTuxaDMq7NKhwGJ81o+m3Mmpwb3lEPzAeNoHVbTkhgTCJc8WT8l62GkqwOurMqsy7tgy4rGPCuMV9jyrLu1A2Csy1jZC/lwyBO0H9N4UKfty1Lt7G+pu5cP/qGJkrWAeu8lkF5qLxffsHRuYDQrViDsamO+ai+Q4rKZKaEi3kjSU+myhksKxcvlJzc8wPOBfPzz4cVw5UPcOEZOY7H4xBlS83ligaJr9tTboBiDE+MCSeZmDfHstG3alsC5Y54D/1WH8XThe+MVe75tQF6kd9ddbKWaUu8wr2NxUShPY8TKERcZtlgnS6D12+okrv7121nJWEN7qq5wOEuYH3nL72g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ont5jCVmwF1hdRyLLtKJraWBrR7S7aQGb7XiDAAhxg8=;
 b=euyPTirpsq7vxNYmWdoP3Yl7llnubifjZH7YMnOoSeRd/aREr9bsGNDTdEdsPPy8IwvRpPoYxOgNCJJpfFQCW+8RAV1tJQf8BGOqTo+0A3uAz/ytsdwzCt/V/ml34YNz5muLv7Z77fCCmvGMGzImT35+Bip2BnzLY0pLr492HsUcPuj97KchhCRAR/lj7WPJD+1WiV+s/hbiSBuLpUjGhox90wMAOtO3szDQShnG1Yjsc1XMaz1VhsHQNtCTyGKmZu17knRe0vmc8PpUQKKhhKg1EnUEpwNa8R8iGNWS/dqq/Whte72bkKAMHg+JRWj9amA+oqfPxVce+mFLrCP/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ont5jCVmwF1hdRyLLtKJraWBrR7S7aQGb7XiDAAhxg8=;
 b=IQYLXMhadALxEwBaOS6leX0Rjg5tyma40mpeKBLOWWqChQxSHq82PwDCxgczm7ITkDyKm1SzhCYY1UA8e6iH3FU5Wt9qgTBuvw2QgWGR0nP117OYpXoHkd8h+n7CJpwe1lThue/NberFi+h/7nxjx7rV45xGo1hmZRTR8QzMlT78iP7T3SC4dMSHUTCVMIDc5aeXF4lZpg4OvTedYEiOudcLzkjTRYnKbrqJeyx3eSNianmXlH37LSzwRayqA2d0sTWSWygNXcCAAs45+a4fnuYt1bST4f+H2lkJt2DTA714FSwgivvAV+1pqhQ7A0EMQaxE/bB43sOagq+Jznc6zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5329.namprd12.prod.outlook.com (2603:10b6:610:d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 17:25:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 17:25:53 +0000
Date:   Mon, 14 Feb 2022 13:25:52 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     kvm@vger.kernel.org, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Message-ID: <20220214172552.GG4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
 <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
 <20220214124518.GU4160@nvidia.com>
 <1347f0ef-e046-1332-32f0-07347cc2079c@arm.com>
 <20220214145627.GD4160@nvidia.com>
 <f302e823-ecc3-2aae-e275-85a56e26fb25@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f302e823-ecc3-2aae-e275-85a56e26fb25@arm.com>
X-ClientProxiedBy: BL1P222CA0003.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5e48e49-12b7-499d-5466-08d9efdf0d80
X-MS-TrafficTypeDiagnostic: CH0PR12MB5329:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53293E4D99484B48DB6C34E5C2339@CH0PR12MB5329.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RT3W4Z4xWmfhzdUrhGQWjnnBJeXI2ehJDSLXNlTunjqoUfCJZ/VLF0RcBRZ8QcU/7dooty3a3wi+HpY+a+uzoDZHc5sfnGyjGyMvHiHz781aNW08LPkkVkkMUQdRsAkrVTa2WIoCCLXaVfvvx4T5sN6xqQTOOCaPhCJRcUWs5mb3/lEqrN+tSwpYJWMJAVR0ED7iMa3VcOFM/f1gPw/WttB8fu1iV4Emaef/AdvFm6QaN6VPmpwIdsM/sb409JYvSl3fu4FYoSKCJ3j5axR3tw2IQtESeytJe3c9XMrUagvaFpilSOpUJhqcGx6TvBR04c8gfM01bjVYtn6jaIeOClbq/yyO4GNOjyaXpKfywnYxUjfFZ5mBHATQemksyLviLvwrdGOJgXwdLzl/rTUnkMa+qJi5wjTEeQwikWySvTx6XSbVOKOdp1saBdOeDeIxv65TC44h2HTimQRVGlefqgpCBjdlsnf+DKeoQLZlIU0HRY+dR8LoLN1ekox7fUykkyv7FmcukWRUN2r9uA4ro/2S5abFzQcG/iJ8yZ853Z/SFM/akgUzHeWnS6dGtBzHUqjmA9hqyFmJykeATBw11i2VXyBps7r1X9h06njaQIbiQ4whB+gVO6O7rlpm32ll81nJ5r/KcwW8lO7xGQPA7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(2906002)(83380400001)(8936002)(5660300002)(7416002)(4326008)(66556008)(66946007)(33656002)(36756003)(8676002)(2616005)(6512007)(508600001)(6486002)(6916009)(316002)(86362001)(186003)(26005)(54906003)(1076003)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uaju35t9Ff8Qe3PTZa8hYqEvktyon5I3wxo46vpyYzO9N2evh4Qas3WycMu1?=
 =?us-ascii?Q?xWIR1MsHjqjJmJSzKhd2lVofQLVjNREosui0uKtwzpxat5briOvPaOns0bND?=
 =?us-ascii?Q?GWPTM06H/EqqVfUkOSSlhgeAg5d07j1a5R+RUKhzfNDNL92sT+beFVFPQuip?=
 =?us-ascii?Q?WB+r267VpQRZrs7MvuvqOdZj0wtZGPDLWWjA68PrCcIOGeBXpZRiI6uIErxQ?=
 =?us-ascii?Q?jXrJquZoohbJLLwhewWVDtpf945vkJi5puZWprACjaWZgldopWjx63Q9qNHO?=
 =?us-ascii?Q?tULNEdXNTKGseG5uXOZU1yVCuIQRZIZOFHn5ELtqzVZ40L34YpGxfzDwnNKM?=
 =?us-ascii?Q?+c3HNEcbv7GMOHXdr17hm/ViNHIcj5+Wisqw3BZI0v2SrgcS4RAaD51B2JUA?=
 =?us-ascii?Q?2nUq2jTXH+jpSrMKZuPjX4TytjaQ81B6/LtJ7fT5GecPeUD+Ztm7AbkMcx8X?=
 =?us-ascii?Q?TZJnjqV3YJfifwkJxcIdnD4C6MII/X4/ISiZbq8jfXE4rTRC66rDfV7mxk8D?=
 =?us-ascii?Q?wFpzjXRd8v3PbHUUc9D1Ifvrye44v0yhrhNYwikTjrv6R/DY75+KpRo8p1Sb?=
 =?us-ascii?Q?sOiBVF24AhyVtdRFXGyTaadBJwt7e6Zox5E/o55M6IulXqZh+KVtQSNCW6Dt?=
 =?us-ascii?Q?n9RqkXmCcXrgzU/WHj9wMWB5G6DKE/bvhSj9F/4tZuIhMncLSdjDQsEAt1xy?=
 =?us-ascii?Q?8VFxlBvbMsNaHHQB+HofXWTENJZK/pdvR+cIE7a+oK+5Kp7veK9KQFrfjHkv?=
 =?us-ascii?Q?grHG3lRn7wJOPjbSXJfqkW19TTcpimcPxSdf8rJLhBbgmbgpArHUGcmR0e8I?=
 =?us-ascii?Q?znIZ6GFNuNjAqy3F+ajea/Ob0kFCyWK6iKHhuztVtfJiKt/iM0PTfXJv9fPM?=
 =?us-ascii?Q?XvmW4jKWeGJJzYbe5nzsxatXoKlqMk5QD2jBj8NfRucRfoW+INzrw7Vx/Spx?=
 =?us-ascii?Q?pvc4gbtGuR0XFhi8ipqJJkZwmr25QU9ZTrnjcDkkTZ7qz+KNCIoUYYxFUEDA?=
 =?us-ascii?Q?5AT/sE4MCcm1udGFiLIsiRgPeo4lj4a+w8dShImuT6cdfLrOXevMsixJm7EW?=
 =?us-ascii?Q?Ql7f69Ahlp8YqWRdVLNew8CxpuYwymk3vtymnHyasENO6icDaIxZFYXwh2yt?=
 =?us-ascii?Q?KzK6Jv6+EzxB7zUuygsiFC2s6RQ6k5fmK9kWSjmO2PRzKia2Of859ioOmRhz?=
 =?us-ascii?Q?sLLLkBYugt2EaCg+1IXBdYXRDQGJqmK159HlahwGs7I2ZP318BNAbHeMcRQ3?=
 =?us-ascii?Q?4CWYoyiNXglQRevAkVcGoTLrweQugc95Tg19BPG4YwlyQ4qgvrwhCwlxjp+u?=
 =?us-ascii?Q?FGPzN4CjeAwoRZzjjp2U8fC2mP9RnLseEldPQrKN4rPFP6SAkk4hwOkcxCVN?=
 =?us-ascii?Q?01e0wxq0s+2WjtDF1R+dLqqMQYX72Wz1plbYoRi491wJTVUa57llGkmO/Uo1?=
 =?us-ascii?Q?B28JitSU8D5gT2n98KTGe5lCDSsNnywqsBmtUEJGAG6tMtNtxUeJswfUx3Rt?=
 =?us-ascii?Q?krtxBnfSZe1dEvMXXpeWippQDkFVgdhCrdnARAPmzc0asp4Sq2BQfzL4a5Lu?=
 =?us-ascii?Q?zcUA6sRZ0vya24Y+wZ0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e48e49-12b7-499d-5466-08d9efdf0d80
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 17:25:53.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecvXsN8jXnMqX92/sX6PzrbzVyNPBsOeyaru/HlerWSpDZiqSaZJnGzyv8uAOyph
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5329
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 04:38:23PM +0000, Robin Murphy wrote:

> > This works better because the iommu code can hold the internal group
> > while it finds the bus/device and then invokes the driver op. We don't
> > have a lifetime problem anymore under that lock.
> 
> That's certainly one of the cleaner possibilities - per the theme of this
> thread I'm not hugely keen on proliferating special VFIO-specific
> versions

IMHO this is still a net better than VFIO open coding buggy versions
as it has done.

> of IOMMU APIs, but trying to take the dev->mutex might be a bit heavy-handed
> and risky,

The container->group lock is held during this code, and the
container->group_lock is taken during probe under the
dev_mutex. Acquiring the dev_mutex inside the group_lock should not be
done.

> and getting at the vfio_group->device_lock a bit fiddly, so if I
> can't come up with anything nicer or more general it might be a fair
> compromise.

Actually that doesn't look so bad. A 'vfio allocate domain from group'
function that used the above trick looks OK to me right now.

If we could move the iommu_capable() test to a domain that would make
this pretty nice - getting the bus safely is a bit more of a PITA -
I'm much less keen on holding the device_lock for the whole function.

> > The remaining VFIO use of bus for iommu_capable() is better done
> > against the domain or the group object, as appropriate.
> 
> Indeed, although half the implementations of .capable are nonsense already,
> so I'm treating that one as a secondary priority for the moment (with an aim
> to come back afterwards and just try to kill it off as far as possible).
> RDMA and VFIO shouldn't be a serious concern for the kind of systems with
> heterogeneous IOMMUs at this point.

Well, lets see:

drivers/infiniband/hw/usnic/usnic_uiom.c:       if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
drivers/vhost/vdpa.c:   if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))

These are kind of hacky ways to say "userspace can actually do DMA
because we don't need privileged cache flush instructions on this
platform". I would love it if these could be moved to some struct
device API - I've aruged with Christoph a couple of times we need
something like that..

drivers/vfio/vfio_iommu_type1.c:        if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))

This is doing the above, and also the no-snoop mess that Intel has
mixed in. How to exactly properly expose their special no-snoop
behavior is definitely something that should be on the domain.

drivers/pci/controller/vmd.c:   if (iommu_capable(vmd->dev->dev.bus, IOMMU_CAP_INTR_REMAP) ||
drivers/vfio/vfio_iommu_type1.c:                    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);

Not sure about VMD, but the VFIO one is a security statement. It could
be quite happy as a domain query, or a flag 'require secure MSI
interrupts' as input to attach_domain.

> > > solving it on my own and end up deleting
> > > iommu_group_replace_domain() in about 6 months' time anyway.
> > 
> > I expect this API to remain until we figure out a solution to the PPC
> > problem, and come up with an alternative way to change the attached
> > domain on the fly.
> 
> I though PPC wasn't using the IOMMU API at all... or is that the problem?

It needs it both ways, a way to get all the DMA security properties
from Lu's series without currently using an iommu_domain to get
them. So the design is to attach a NULL domain for PPC and leave it
like that.

It is surely eventually fixable to introduce a domain to PPC, I would
just prefer we not make anything contingent on actually doing that. :\

Jason
