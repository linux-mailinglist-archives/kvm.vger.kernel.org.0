Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF94B5205
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354592AbiBNNnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:43:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354572AbiBNNnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:43:13 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47864B849;
        Mon, 14 Feb 2022 05:43:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QE97dLPkHraPh0FNqwxwbYw5O6+n0MA0ohFAglHsjMfiyak3+ZpVjaYGWj4XXuWS2Bjwx5uMg1ePVE+Zs9CblCnpm5T/DHuX9V/+hXKgJH4TxMly/tS6mxHCkZcWfGcgH85d1HOHEQ2z+NE648VqvGWGiCHd6k5Spy1m3zdvbjE4SorrPYp0YlCjZ/7HujX42xI+1yTXxWy1POZahdCkrUOye3R73E5oq1AUMp06nimqjqHw2bLY+bKBXftUFfQR+c30yJWT38iPzeMm2A0RfRjmLUZUP8vJ6IibzzDLTnd7K211pSX62L1luTzPKDFk2Wtl9xkhLY3Yf/xqOrNZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Cu/DWWuMTq7gTxhLGfwGPUieYNOdIb9/UasU2tzmvE=;
 b=IfbiGiclJmhbE1D5IeLWEFxdteRUNtvlMdfhdcqjlyaJSBmz2tuqsp/FYYw7U9HF8wcgE+oPA7tusBAlnarrb+nn1Znu1b2XiAf98KjT2kzb0suiWBIc3mREfo3byzWzWOqrDcXFubPEh/ldDsAKe5ZcV/h+8EvNuwLWntU1vOrvsdk1BasKflRmBYWmnao17c94CV2XskRgK1EJe95M3tz1fmIEVKn7erI3dgZdf0byU6nbEcB4dkqx+ZoedNELmzaXUA1jf4EumAvXxufu/xwJNwDfv1tUSJaDxNYJGecdDWezQxabO0WWeoVgoASJ2waUAbgIY/ofruyn/kEjBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Cu/DWWuMTq7gTxhLGfwGPUieYNOdIb9/UasU2tzmvE=;
 b=fjrMgi8jRKjtJICw8BsLbHgVmTSaj02keGFJnhsjOd5Tgei7MkzOoi1Ks5uFeApjSlrSLUkn2ZphNvhK8YEZDC22EfPsoOaMs0wltVrWkqb+83yPo2ICjVyiuJAkKzEWjItU+rq3v/jH/MmbqZ4OgNjPfAwSC2VzIbIASHncSzgNJxADL8LuBJlrFkXaFDK7WNUsz5IEYajZPeRNFFBxGMBuPZ12nTTErC1VpJz5Hxve9p5F9Z6MxZhhd0wFB4nnQuQOrnFAGkM46ue8UNjGAEzaNWqztE+Pufbte6LPSMtKJgaZ5Fd8F4LX6F/fnZWBNAz/p4p0pHOmsD6C++ynRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4199.namprd12.prod.outlook.com (2603:10b6:610:a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 13:43:04 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 13:43:04 +0000
Date:   Mon, 14 Feb 2022 09:43:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/14] driver core: platform: Add driver dma ownership
 management
Message-ID: <20220214134303.GA929467@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-5-baolu.lu@linux.intel.com>
 <YgooFjSWLTSapuIs@kroah.com>
 <20220214131853.GY4160@nvidia.com>
 <YgpbC1u6YFN4GefB@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgpbC1u6YFN4GefB@kroah.com>
X-ClientProxiedBy: MN2PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:208:134::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1a356d3-eee0-44f6-6c6a-08d9efbfed0b
X-MS-TrafficTypeDiagnostic: CH2PR12MB4199:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB419913719B1EECA6FB085EE3C2339@CH2PR12MB4199.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5go4pdGe2fK9lXoLg0EOJtLuNUjlSyqdbWZMO3w9Dlw8jS+mCCkexqI7yrutWiFYd0rawwh9+frL6OeNZIQJubzkROv2fui1e52xRl+GnR9+7zBKVIWJ0qX/+bxW9Q5JeK7NfCPF68S6PCHU4w406JDle1KwoopD6YPxslkqK16F6b3piIFwWawoAe1eBmhSyx7Dc08MjDJGxL7StWVvW/avaW9Kp5v/MTJiIhG/LgdAywkkcgwGShqbJXxp8OVkOqVDAvADZDDfIp0Xp2+5GaLn3BMDuQcN5TqkNOUcbG1QJ/zzOC+23BWUFwxlyYnx+w4HIlKMo+D9JJOJN4QsqjGao5OasaVvsGcGJyqy3QVH+P4GEwBzSqfBN6E3AnZG8dA0RNJmdekx2amytQtgMEETwh6EYwvY04L4tqppOYoHcyYp2PV8RTTlzlo5EfBaEzpaS5mrWDGQZiV3QfA0LNhu1MdrrHq7Qum3Sy97ZPMEBOYzPcJ+EvfChrGFrgKXU19F4sL7KpXKGPms//xaFQvi2lBTjD6yzlmNM1elJRMUh0RiJhKjac7CQ0QQ5JcOkgCTCGhAZYf5AmxhwvD1nKrG201tB1rvt3ZwrGwBcVZR5MZksjq5t79RQ+4zHb6CFgyrNTS3wBJGcMQ11C+mFoIWmqb+dm+QMnStwhfESYfX8TOs2p+uW6zCBxLyWi0D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(86362001)(66556008)(66476007)(8676002)(2906002)(8936002)(38100700002)(4326008)(5660300002)(7416002)(186003)(26005)(2616005)(1076003)(316002)(6506007)(6512007)(508600001)(6486002)(36756003)(83380400001)(54906003)(33656002)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wY5NrCssh7UsFtjT4HKjdx3ofwbrFfB/B6YEz6DW7jqmyOIutQosjfHHeuc4?=
 =?us-ascii?Q?FO2vsWMpghgQvFsz+M5heJmk6LX3fi41HilRZLlOCbt5fPS035eG0qOW1gi4?=
 =?us-ascii?Q?V8jeSbycaXpEGN7u0YjiEvzHQfoW1CW8P4ClpjNINF3kFTRCA8nuEyOPVYGi?=
 =?us-ascii?Q?3KNjs6Sa+7sZwiR8bQeMZrIuYuP/76vJa2bZ7H32hGhh7ycAQuWa7Nz5goHK?=
 =?us-ascii?Q?NG5wDCOlnq77MoscOampoL2UtLWRmFrH6JmtrX9ij/tMF66HAoK4zcr5Mq8/?=
 =?us-ascii?Q?Kd9OXuk6RY/c4UpnVHbLHy12epg0MUU3Ufq79G8yPgAR8IWnUBr7Fn69aeuB?=
 =?us-ascii?Q?qwiTNUb1fx6/zxc7PRAkyJnGZLXCrPu0C7A6/THpdgghCobCZqTYafygvThy?=
 =?us-ascii?Q?OF0Fhaxn1epFTbmnkCvB7ZcIjEpDAO3+ut/4I9/MZjapRdELV6MycgIGZwlz?=
 =?us-ascii?Q?mHTus36y67VOewa9bvAQIK3JuprD3/8f1ER20xvjOlYGt888hRtG2WFZqRMO?=
 =?us-ascii?Q?uqCokWRlRMJ7XIvKngmEL6IOOPA0Dk6ozEbGv7RK7jSKnwHS4UqcJZpahShZ?=
 =?us-ascii?Q?+PdUwXfGAxWwxOsqLQhdInNU7IM0rhdXnOex70J8aKai+WfhS/JQXrh7wcHX?=
 =?us-ascii?Q?xURplpQsiJrWJvcg0RFnDZlLLwp2ieMfbUngtgYEW904wejPAKuuGWUfQvXb?=
 =?us-ascii?Q?OV3BdO/oQxqUUMSwhpTh4da25yjxo9wgxB7Xhbb2Kip7+SZq52zno3j9oeEs?=
 =?us-ascii?Q?NLWW9qLxU0RhuBIcRZWP5GuTHYi1kQoCk0GxaK1FT6+KmeLbG6/pi55IVl+E?=
 =?us-ascii?Q?zRcUURKRYuCXujrc+csMwBGZQ7DiSnfNgopacOpU1CWR+6f7WX1Llz9yRxNr?=
 =?us-ascii?Q?WcR+rIaQqas+OodKfwMm0Ey+s7agFen+HJT/zHAmuPKaj/IqNlHONZFN3cBV?=
 =?us-ascii?Q?L/t7ZV/dbtkuiii2L9mHMeXNM1vnm1HfEFet6hqDX3fEgXkVrkr3TWQlBgtH?=
 =?us-ascii?Q?HxqGZqKdYneIQyKoy7zndCngcodYOEk7OSCNBTxuxa9PKbzdarzXBQNRB4dL?=
 =?us-ascii?Q?cet2YRBP2E0u60UH9OfDDvKROkTtePgR3y18cFPwoWrYEPE/dPhzXwShahII?=
 =?us-ascii?Q?2nI+PWKYje2Oku4MHdqQ+Mi08aYHpiy8gJuaB9ORqS7SzU2IME782LXW9zVO?=
 =?us-ascii?Q?opnD5fCHLzmLnFeK/dIgTz+7gaKhXvAZy1LfyTyr9nIB7gIp7tGEWiIw7Koj?=
 =?us-ascii?Q?0RcejXpyEk7JPp6ZImSGUfy90N5BOft/dfLwkK+22TzlaNx3hG5n00iAPwIF?=
 =?us-ascii?Q?6wKsl++kgl+m0V+6F50mVGS3ZnHqm2bfxzu2TyQ2nL6KuLd2oiMCKFMFGq5a?=
 =?us-ascii?Q?7gZgRoR/1QvTZ2bvFIZ/4YL9P3F7bHk4D9aa1CsdM9g1htcw5CDcQrsDRxmB?=
 =?us-ascii?Q?D2453DXtxmDaKWdMYiC9II2V1OqUz4JTgPU5jgsbwsbbfFt7lbm7LcjIOSeh?=
 =?us-ascii?Q?Fg9OFkn0YpsW03GtuGIpHm6PgYoPaOWXRy1RArrrYM116wGSzyeAwqVYsqEL?=
 =?us-ascii?Q?7A0MzDiduWdQVB6tNhA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a356d3-eee0-44f6-6c6a-08d9efbfed0b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:43:04.6890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aN65iW6lHtXqPiaq+FFoSEU9Bxq/jLZTAbMtvxluDOC6cJsdRfFsfM9KlzsTymgK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4199
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 02:37:15PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 14, 2022 at 09:18:53AM -0400, Jason Gunthorpe wrote:
> > On Mon, Feb 14, 2022 at 10:59:50AM +0100, Greg Kroah-Hartman wrote:
> > 
> > > > +	if (ret && !drv->no_kernel_api_dma)
> > > > +		iommu_device_unuse_dma_api(dev);
> > > 
> > > So you are now going to call this for every platform driver _unless_
> > > they set this flag?
> > 
> > Yes, it is necessary because VFIO supports platform devices as well
> > and needs to ensure security. Conflicting kernel driver attachements
> > must be blocked, just like for PCI.
> 
> A platform device shouldn't be using VFIO, but ugh, oh well, that ship
> has sailed :(

I don't know why you say that, but yes, this is was set long ago.

> And stop it with the "security" mess, do not give people a false sense
> of it here please.

I'm confused by what you mean. This is all about what we tend to refer
to as DMA security - meaning a device's DMA can be controled by a
hostile environment and not impact the integrity of the kernel.

Jason
