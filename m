Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DEF4B2C0D
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352316AbiBKRtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:49:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiBKRti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:49:38 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EC12C9;
        Fri, 11 Feb 2022 09:49:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWqa0G1w3yvBu2+iezlTZd08gs2KCyJn4vQTSJsL6Squhfl6EV3yLOtsixsE3uDF3HaUobKAqljtGtUpo5dzaBW4BkhJlzXe4ENNcTPUObsDZ/+DWKLRExIdZyC8J3SJRp84W7a+kGfutQJXD2G14Koj6d7p9Mr1uq8WBz6j0o5C7o1MuOW+qdhkclISWIw3vJv09W9un+wLWFcf7Wfq9BibVz8JoCpd4mwer4lIBoq4MLRkwCfjIT2fRkBbFgCo/lqgIbWdQGmgEzpztiaGMkvFcsFYIcwUn7c1HExnymM+o4IhM81IMO5JTbo8Ot+5XhnvE6qiT+SLp0XAfuS9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afGExScP9OStQR76DgR37oaIfsgSSadsOfFXjTXUoGE=;
 b=DDqWXe7mZVCaZxVGounpEWBeqaRxcPp2a818ju+veozEpDojxJ+iL8oleeCZ9tJCbazhh6AhkNq36YcdQmakkR2M3XFRg3so5ItRUoVVhtRW2ZcmwBeXowwPwNtkQPfqvyRCYRvW1caf9Cv7JmieVqmnCtcoMWefk0P0eMEeBUOG8HSHgnJiiQaLid06nW6NVwvCbSxi+P6/EMERvIBrQRguAartmHi3ZRdZ5XRbBOF1xa2vf4hyrA6BQk6I+iOqhT6xeZ+tUbqOB1iPnRhVeKa4LzNs26zwzKfxqzHKy4ZeUnfu9YUXpo8P5sRG02ao0WboZ2bv508I2PLqnV7IHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afGExScP9OStQR76DgR37oaIfsgSSadsOfFXjTXUoGE=;
 b=a/r1iR8wevx+0UjmqrxeQ3wUDfGhr+eAQd2Ixv9+qw2Rx66yrhaqm2VSJiqx27xCQRAfdyGf27CqX4DVX4DztSSkO7193E17A3XWzDHWy5/P9jtod5lyac9n5lfkhfIL+UEMDIT+SfeGNYYcdV3cxhX/1NOIaKwYxvnNoqBUv6FIrIj8V/t85qpZWXIsquMoBIP0QZgXLMa70YZzqNs5E1WjEk0jI6x76OFReTlMTFdTHMUJRRgjyMgKJQagwzN6s3cFqUMcX6XLKOnxHFHhcS0odtkHaCdzvhNaSpZYGLHnxiHGZXK7972tTKzzUdJChllzvAvrqvbCrhgtP5U7Hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by LV2PR12MB5775.namprd12.prod.outlook.com (2603:10b6:408:179::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 11 Feb
 2022 17:49:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 17:49:35 +0000
Date:   Fri, 11 Feb 2022 13:49:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220211174933.GQ4160@nvidia.com>
References: <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
X-ClientProxiedBy: MN2PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:208:239::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 129fbce3-1ec7-40dd-226f-08d9ed86dd8c
X-MS-TrafficTypeDiagnostic: LV2PR12MB5775:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB57756D783AC27997CBE7124CC2309@LV2PR12MB5775.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hTV2eCXGLHxM8pUrX+Tu1dyRYXbraU4SxYzPV255ynLsjmOHqoUYcmu16mNam+X5A3wZ2ULnOcPsUuBazjMqi/59R0BdrcyVOsdqm1o+EeD7I0WGmVbw2xqjsoLC1WuRHjB6rsaA6LWBpX48FTcvxwEFpJRNeWMF5cUvMQ5WO0CuJx/c5H7YbTR+kihajmv7w3OX02BJMh0OM8nXB2LeRtMe4fj5raOF2/olL3BDrWZq07ydvGzR7Hp+UKVsI5/8opi6+wfu4WmXHp7vUFEyVJYOEgmmkWT2pdgIS+SA5HACuI8YMWz7t1GzPqOBacpjPKK//Vj85hCITTo5jVeTjP7hTrqIZQ/iIxKrGM5Q3pGJnF8FwAXj/tDFkUQJHxtxZ4qBPMEN4b06f1sYaP5LwNekYFGv7DVgQkcGmDpFngs1ni6Ih4GvX00zWNtQWF2Wyi+u2eTMKp8hlYZ232cBQ7s8ysUMTTuMROTlGdwi88cf/nMufYoEm9PCqg+ZBfePJ2u5MOx6VJCy3xKN0oKIgpflr7s7fi+v53UsibTbg8O//o1qBJs7+On+EADNjFKEyI59vV60cnykj54Fg7hfmG1neOuh7tdZ0qhjeh7DpLZuv9QmbRPDYTru4sHXWRsNJ2k5leJpozRHDihKEbfpM6psRCt/7FSS8/SaIwZrix0tch34rhKFw5apzr4fQYKo7RdSTp81jWsyzzagnb9pDxktwSWiM+xw5PP4CR+9xb81YMjzLXF46cXs4+ayyhCcQrKPA/LKEokAIDEEj1qxsnhTRme+350GdOJAKm3/Fnw3KPmrfbX/PWlVbzm+Ksyp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(66946007)(186003)(26005)(7416002)(8936002)(4326008)(1076003)(2616005)(83380400001)(86362001)(66556008)(66476007)(8676002)(38100700002)(5660300002)(2906002)(508600001)(6506007)(6512007)(36756003)(54906003)(316002)(6916009)(33656002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4tPtrO+mwE+s47jNuWOyWnbz1VW73l32pnEpQkirGWJHn5fi4Ou4fdMa+z9Z?=
 =?us-ascii?Q?D1oBsTErkclmfg+Keyyw9cpB4xesNu0hNcBd2+svTBQk9hiHBSkxAzmZP9y5?=
 =?us-ascii?Q?+XPBfwjFYjjNapWe3k4XWUBDcQuT4lvjLZxPBwz9mG9ynWkiO8HMYx4Vljou?=
 =?us-ascii?Q?vISs3614P3b63/86g8wKvhBG8AlaxZ91enS0SjmF7ZG9BE6+HLjrH37W/gLV?=
 =?us-ascii?Q?NdUTbGi4W3ylEWAo6HFkQoOilE2LS45SPpiK4nKfJ3FRli/hIPIjygG0LFjs?=
 =?us-ascii?Q?7OS0WIS6IoSdjD+fcZYpmPo6GY3th20iu12WDjAy0mtOHqyM85MSIXN5z7cq?=
 =?us-ascii?Q?Sa1AF0O7GHEjdPIvlL/wEg7S2Kmb1MQwEnFbbid+7b9GlTptUaI+KTU89wP3?=
 =?us-ascii?Q?uaAxaVTFmUTv6aD8qbDHnNX0myZmaIVpGQlkaXP72M8H7LkXweMFOJ4dogEs?=
 =?us-ascii?Q?yYmKw7swZgYkb1vwPCCGdVRNtT+G5WJVP5nCFh8g3piGLxjU7q31tK/902U/?=
 =?us-ascii?Q?YUNxYc3jFRUeiAkq65EquUELa6zDagNqS5DlFEJsH1rGXfoXeuC/pM5ijyeA?=
 =?us-ascii?Q?KNj8ebuRNx71BH4i60FVT4jAjQrwnB1AmjGo3hr499GcJ6LTBDIZGKwAOgvd?=
 =?us-ascii?Q?W98F+YVC2VNmKfxqEiOsgoOxQw6cyKG0in3JbI0gh30ElYl6Ny5++AVzFtmR?=
 =?us-ascii?Q?28MtWoXDUWGVwYdW0xjEn0b4LPuZtyqwv+xhxNv6n0ATD8YFhmTdN/s3G6k7?=
 =?us-ascii?Q?QY7SvdIE3WLVTMWHT9kps+iS420uid0LURGhZC/2bnr8L881cm8lsF45QLn+?=
 =?us-ascii?Q?nI0cYOrDLJ8Aa83YCc9PA72yplUIsq/TkdqgrlnC7wnz4hVZc2E1Mtu24h65?=
 =?us-ascii?Q?wwkEPiufaEhaMu4jppLnI8x4jHy1SX4sSrJJbNil22fB0B5blT356jeRkbo7?=
 =?us-ascii?Q?B5c0+Kq2khVYEpLNWm+mjRXliGKgWVujJSthrZ79BlW0XCHDR1lj/tGdLUaG?=
 =?us-ascii?Q?vmTsCubMpTpbcmfHEthVGm1oRtBkAVM7u5CVpy6DA04lMxi8OU6CDiA8oPyR?=
 =?us-ascii?Q?521TtBigv3hmiOjhDhF69TjC2eDaPeOWAPc11fScfg6hoMKfRlsfpTplJLcz?=
 =?us-ascii?Q?IXgFhrPIHnR/kPHqDh+OIdGXcCCqQ34XJwQ2HV7l3YMqOQc1h/shMTir2B8a?=
 =?us-ascii?Q?l1SII0+CbL1g1g33W+gBI6Sd1P7/IyLnumBxt3KrLWj2HmKQQoiQLqODouAA?=
 =?us-ascii?Q?wJRbDvjcVMzUIRamc/CDDpTjucnJT9QloBMmigmYJBTnYR4VLS+H6+lv3k3F?=
 =?us-ascii?Q?P7t+oWK38b9M89w9fPmIiWUZAGCos7UGDLHTMsdSUerZbxXGpQoCNmZe2wgi?=
 =?us-ascii?Q?iKwtdA+2MHw+IpwL1UR0O/itIuIbwujKIU4cM5ZFpOmc3bbgr+kIE4AepG0/?=
 =?us-ascii?Q?BjGjHdOi0sBq55CczzavMiEThcFYhOlk2wt1zdMcFmdP848PnKCeOT/psHLp?=
 =?us-ascii?Q?0XYk3vTT2NL7ljGx4zakgbmPiLyDaKk2anMxbCvgW6dWD22glXvIdTym3pbN?=
 =?us-ascii?Q?+cbrOYNzxL5GPwoSeTQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129fbce3-1ec7-40dd-226f-08d9ed86dd8c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 17:49:35.0484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCVpOTcd60VPnjbZVXfUzFkePKuoNqCLXVILeLNs1tPYVpg0BfzSreAGs/tK+Exd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5775
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 11, 2022 at 05:28:22PM +0000, Joao Martins wrote:

> But well, at the end of the day for an IOMMU driver the domain ops are
> the important stuff, maybe IO pgtable framework isn't as critical
> (Intel for example, doesn't use that at all).

Right, it doesn't matter what library was used to implement the
domain..

> > User space page tables will not be abstracted and the userspace must
> > know the direct HW format of the IOMMU they is being used.
> > 
> That's countering earlier sentence? Because hw format (for me at least)
> means PTE and protection domain config format too. And if iommufd
> abstracts the HW format, modelling after the IOMMU domain and its ops,
> then it's abstracting userspace from those details e.g. it works over
> IOVAs, but not over its vendor representation of how that IOVA is set up.
> 
> I am probably being dense.

It is both ways, one kind of domain provides a kernel supplied
map/unmap that implements the IO PTE manipulation in kernel memory

But if you want the IOPTE to be in user memory then user must
read/write it and it cannot use that - so a user domain will not have
map/unmap.

> > It is basically the same, almost certainly the user API in iommufd
> > will be some 'get dirty bits' and 'unmap and give me the dirty bits'
> > just like vfio has.
> > 
> 
> The 'unmap and give dirty bits' looks to be something TBD even in a VFIO
> migration flow. 

It is essential to implement any kind of viommu behavior where
map/unmap is occuring while the dirty tracking is running. It should
never make a difference except in some ugly edge cases where the dma
and unmap are racing.

> supposed to be happening (excluding P2P)? So perhaps the unmap is
> unneeded after quiescing the VF.

Yes, you don't need to unmap for migration, a simple fully synchronous
read and clear is sufficient. But that final read, while DMA is quite,
must obtain the latest dirty bit data.
 
> We have a bitmap based interface in KVM, but there's also a recent ring
> interface for dirty tracking, which has some probably more determinism than
> a big bitmap. And if we look at hardware, AMD needs to scan NPT pagetables
> and breaking its entries on-demand IIRC, whereas Intel resembles something
> closer to a 512 entries 'ring' with VMX PML, which tells what has been
> dirtied.

KVM has an advantage that it can throttle the rate of dirty generation
so it can rely on logging. The IOMMU can't throttle DMA, so we are
stuck with a bitmap

> > I don't know if mmap should be involed here, the dirty bitmaps are not
> > so big, I suspect a simple get_user_pages_fast() would be entirely OK.
> > 
> Considering that is 32MB of a bitmap per TB maybe it is cheap.

Rigt. GUP fasting a couple huge pages is nothing compared to scanning
1TB of IO page table.

> >> Give me some time (few days only, as I gotta sort some things) and I'll
> >> respond here as follow up with link to a branch with the WIP/PoC patches.
> > 
> > Great!
> >
> Here it is. "A few days" turn into a week sorry :/
> 
> https://github.com/jpemartins/qemu  amd-iommu-hdsup-wip
> https://github.com/jpemartins/linux  amd-vfio-iommu-hdsup-wip
> 
> Note, it is an early PoC. I still need to get the split/collapse thing going,
> and fix the FIXMEs there, and have a second good look at the iommu page tables.

Oh I'll try to look a this thanks

> > You have to mark it as non-present to do the final read out if
> > something unmaps while the tracker is on - eg emulating a viommu or
> > something. Then you mark non-present, flush the iotlb and read back
> > the dirty bit.
> > 
> You would be surprised that AMD IOMMUs have also an accelerated vIOMMU
> too :) without needing VMM intervention (that's also not supported
> in Linux).

I'm sure, but dirty tracking has to happen on the kernel owned page
table, not the user owned one I think..

> > Otherwise AFIAK, you flush the IOTLB to get the latest dirty bits and
> > then read and clear them.
> > 
> It's the other way around AIUI. The dirty bits are sticky, so you flush
> the IOTLB after clearing as means to notify the IOMMU to set the dirty bits
> again on the next memory transaction (or ATS translation).

I guess it depends on how the HW works, if it writes the dirty bit
back to ram instantly on the first dirty, or if it only writes the
dirty bit when flushing the iotlb.

In any case you have to synchronize with the HW in some way to ensure
that all dirty bits are 'pulled back' into system memory to resolve
races (ie you need the iommu HW to release and the CPU to acquire on
the dirty data) before trying to read them, at least for the final
quieced system read.

> I am not entirely sure we need to unmap + mark non-present for non-viommu
> That would actually mean something is not properly quiscieing the VF DMA.
> Maybe we should .. to gate whether if we should actually continue with LM
> if something kept doing DMA when it shouldn't have.

It is certainly an edge case. A device would be misbehaving to
continue DMA.

> > This seems like it would be some interesting amount of driver work,
> > but yes it could be a generic new iommu_domina op.
> 
> I am slightly at odds that .split and .collapse at .switch() are enough.
> But, with iommu if we are working on top of an IOMMU domain object and
> .split and .collapse are iommu_ops perhaps that looks to be enough
> flexibility to give userspace the ability to decide what it wants to
> split, if it starts eargerly/warming-up tracking dirty pages.
> 
> The split and collapsing is something I wanted to work on next, to get
> to a stage closer to that of an RFC on the AMD side.

split/collapse seems kind of orthogonal to me it doesn't really
connect to dirty tracking other than being mostly useful during dirty
tracking.

And I wonder how hard split is when trying to atomically preserve any
dirty bit..

> Hmmm, judging how the IOMMU works I am not sure this is particularly
> affecting DMA performance (not sure yet about RDMA, it's something I
> curious to see how it gets to perform with 4K IOPTEs, and with dirty
> tracking always enabled). Considering how the bits are sticky, and
> unless CPU clears it, it's short of a nop? Unless of course the checking
> for A^D during an atomic memory transaction is expensive. Needs some
> performance testing nonetheless.

If you leave the bits all dirty then why do it? The point is to see
the dirties, which means the iommu is generating a workload of dirty
cachelines while operating it didn't do before.

> I forgot to mention, but the early enablement of IOMMU dirty tracking
> was also meant to fully know since guest creation what needs to be
> sent to the destination. Otherwise, wouldn't we need to send the whole
> pinned set to destination, if we only start tracking dirty pages during
> migration?

? At the start of migration you have to send everything. Dirty
tracking is intended to allow the VM to be stopped and then have only
a small set of data to xfer.
 
> Also, this is probably a differentiator for iommufd, if we were to provide
> split and collapse semantics to IOMMU domain objects that userspace can use.
> That would get more freedom, to switch dirty-tracking, and then do the warm
> up thingie and piggy back on what it wants to split before migration.
> perhaps the switch() should get some flag to pick where to split, I guess.

Yes, right. Split/collapse should be completely seperate from dirty
tracking.

Jason
