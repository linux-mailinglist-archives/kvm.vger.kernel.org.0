Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CA94B53D6
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355457AbiBNO4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:56:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355454AbiBNO4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:56:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD439A;
        Mon, 14 Feb 2022 06:56:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0AULJ0ahX09Jg7Wi2mNpduExirYkmRQLyoP5dDIA3v/kKFOw22PPgB2wuqe9M+Zj3QwMaY+9EjP47ccUUidEDUpxbRABfU2Dg+O4v/6KwDELTF7eTq7ji2u2bDc3C6WLaNBsb99mnZgqbB6o79PcJG3H0p92QBQQW6/O4CLTRzup8J1CwYF7XG9ZNNC+EnXVy9TkjVWc6tgKy09FZJB3fDiV8npCbLMGvuognJXgn4aLCkv1y2WiEx0qq/xPggSqQjRQOTQ+yDy3lEhJtsy9AUCH7F6nnJ3XDMW3dW12MOcX92q8ntv/FyhFfbizmuWPAUB8xVf5a+R0Ooz34z7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNBFwnlpNqFtO21MFhSAS3LRrbSp15l1SNb+H8X/zlI=;
 b=fyMouoHopCGbQhu4uqxGqATPisp9UPgAl7U82K+37eTMOuITsskENtW7RYSPRwuylqYQ9zeuffwf/FMXOplTGrBxPTpOhyiyGhnJDLNpPdJjS6B1qtI3vco732yCXyTWI3BACYidDsHS8ziw3H29mMvkiEtB34EwjgPskQgV9eEnHCXTvEN7E3vAggpfuPh6JCECh+6fMX6RHVkOIiTNEbSGDbIrw9AajbVNIF3XjaF/YFVOC8GxyK2EK1yFrsh6lauSxkkTqlq5ECgbPbs2WaPnMBYuzuyE537Nn4eDfZb6PXvsjt1154JBu7H3prIo6SaeuTCQSa4npbN1yMVjiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNBFwnlpNqFtO21MFhSAS3LRrbSp15l1SNb+H8X/zlI=;
 b=XHBMUf5lYWJ7SVpnpzTu4ZK7guV8rKvarHtfOD6CEM6X0TsDUoE0QdFAwQvIS6jO9Ymzp1cb0ZJQkVv5mK4sUcmCjFrpFS+pRx1zuFrFoq5e/POioiWGYljjM38eRbISqQtZ3moit13D05oHthhA5MjGD6T8n2y4ZDKIkKJQQKBu1lVznBJopjCsqZq/BS8oa6dFv4IfBA6DHk9LspiJcBDG0Q+NAXMiEvV3h10AoVifn3YB1T9IJhTlls9lCOK3/Eke6Q0MKBTBKNia1fbysFYiEkgLFrw2YkthR+Mg39n2d1NIPQ2G8EBerzv0dbIX0RfaN2sxSmxqeGz3nEEA2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3225.namprd12.prod.outlook.com (2603:10b6:5:188::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 14:56:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 14:56:29 +0000
Date:   Mon, 14 Feb 2022 10:56:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Message-ID: <20220214145627.GD4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
 <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
 <20220214124518.GU4160@nvidia.com>
 <1347f0ef-e046-1332-32f0-07347cc2079c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347f0ef-e046-1332-32f0-07347cc2079c@arm.com>
X-ClientProxiedBy: MN2PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:23a::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbc6bdcb-a86d-4c61-d676-08d9efca2e69
X-MS-TrafficTypeDiagnostic: DM6PR12MB3225:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB322520A75B20131391BF1C08C2339@DM6PR12MB3225.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FQHxdbM45cvrKVGqo2jErwsASyXrg1WBDuQc6YAX4+qE/NRDvHgqOX1HS9nLykO0ebKqlLGvn7cyBC1J6UB5JxPczC9xJXNGj5/xZqbWcXB5GUPKbyLFzrjsn2MjYNIIu9fJ0J0O+wJyf8BDFC7kU4jRb5co+rP0VKRwDLrBWt2Y3iV2pbTazlS7Jn03x0WyuvqWqsiUPtbEYFuFBD1t5Su7/K59/nQY/yHT+bpIOlagoGf6uEPSVZIPYRP5IqduRhf83ir+iDQjyjbEQ7qQrMpLp2eW/gPPniXhe6JNbk+GaWf1mAzgNK0MhtbVouCQld6du4dhpOoLtiTaBYi5BTWHx7HojyWdHaNTj4UtH+ZMn5BAMHL8KrYzjGbeUM35jWP3AcgcpnBsmmEyqkKlODPrjoTN29NbxGD7+TIY9ktF13Y0TFEdk5UiSZ3ilITfZOF1BTD9jNrPJuqDq1PrFs0YGCcNBpU4zgqOiAFzTX6Lnj1MAsqop700OYQKPKrxYWYbEfBJ+iODZRWv4AzWhJL58ECEzVSsR2X7FNhues1D4dauRtl3WoOtYSqcBUN4G6cOS+iN6H/YXfCzkboBnsfDpfTtaaHO4wfZs8koU7PkMcw8eKi2a6SFcsdKIHKHUwTbcKjJW0L3PV/bR93C5pv6zuG0jreLmqkL48RpeRk9HXg7A3q+66Vn2RHDN//Rc43mJA7VQX+4tRAGzrRSe4h0FlCSVjpWyd57cGN/Cy0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(508600001)(4326008)(6916009)(66946007)(66556008)(66476007)(53546011)(83380400001)(316002)(38100700002)(8676002)(33656002)(8936002)(54906003)(86362001)(966005)(6506007)(6512007)(5660300002)(7416002)(2906002)(186003)(1076003)(2616005)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?78iadrStW0bvaihyaAdNTHS7kouJb2CosD/6GNNAxEKZWqjtS20F+AtxO1qE?=
 =?us-ascii?Q?C9EPLeSi3LPAMNnH43s9i6UF9OVhKQ7/uJb+dTyNsKK+wpEekMrLA9ntSCSd?=
 =?us-ascii?Q?uxII0BKS5UDKhZYKFZCL9EF/mtNmAwJWl0mxbDlSHbO0jvfC5KwDVpgNuKp6?=
 =?us-ascii?Q?dIUy7uvujN/vc6Z6mQEu6PihhzIeZwZjGXgs1vCKdKYBLYHa5b+EZFnCF8GL?=
 =?us-ascii?Q?6igzeruaIlnyfxIt22fFvdpbzIn6AsRdv6kh/5Xlb3sHXwE6k1r6UJckF1AP?=
 =?us-ascii?Q?Okd4VRIuFUqSfdQJgpWgqCCkDjmW0yShM258/UQp6uci8XU1+xLIdVJaQCQS?=
 =?us-ascii?Q?FfSfKR+vWcZ/NLxadEZREZvnxw1VP+eJy6i7DLncobU2hapP8p708/I/ay93?=
 =?us-ascii?Q?YcDcZ33fIgBOZpRgYzqRLfDRInb97S+uDKn5+t5213y6Udxd0nAZ57f6UtFM?=
 =?us-ascii?Q?yEviYlM4oiclseJVZTp/Ok8Q9aaTM55+B4391KCPQZkNeGYx6uu622FXwdCT?=
 =?us-ascii?Q?V1iJksXQxTJTwrU8cWF/aQw2LnZJJh9qMwBPYf8pwLWvjt73dUB6vaQzAcgu?=
 =?us-ascii?Q?HNpbl5H3VHHNZeggT2VabhpkDUGItNuE/aZ9DNkrUOrY6KAIKpDZ7xXra1jT?=
 =?us-ascii?Q?YevEKRusqE8fsAv4ow3/kz3jg7rVc3A668IFRYB/E8TvAwrQWFl/IitccNba?=
 =?us-ascii?Q?0LbdDGUjv/1Xxl+/9UcmdUO1iyh6M377CZe47punJEklVXvfIhkoT01c72bQ?=
 =?us-ascii?Q?AR4nx00UyVxzI5OySJ0hN18UguOtJ2iznu55JI9Frqg63v+CvfxoLPE060dD?=
 =?us-ascii?Q?qgHXffvJx/yFMzcTnRhY05fUK6KaQPDtbC71QlMDn2UU5AWQs7A4ZiTRdq5z?=
 =?us-ascii?Q?aTKjmALYbWL5sfGnhYRRuAiMxC4pMc/+iC26RrzBsjd65MeQCbBjqn1K64XI?=
 =?us-ascii?Q?t5d9P0+FFWmwqi9rGEsGNZ470sU7ORxdxZYMm/gLnSsmcPRxfjZYfoI3out/?=
 =?us-ascii?Q?wzp9kRldVSJPOQpab4tRnX5Z++Y+u6BOCBL/bVDyWd4yEWJZKeTFiS+p9pVA?=
 =?us-ascii?Q?xBGI1omb6NSh8RTIKAt8bfivmEO63BjJA0YNeN7YTxCosihpRVfC9reVEOxU?=
 =?us-ascii?Q?VJDmrB2gHhCiePIYCbZfdFNVKXuU0/yxKBJN8YXlEYMSROR/GzFK54cbTups?=
 =?us-ascii?Q?Typf8ZlFQ1NXW7rvvzidT1TeULwLbHHyMCLPVaDlhAjvfYjCkWXHHkKPcC+s?=
 =?us-ascii?Q?oPIJQ2Rvrgcf15z3v3QqQcFdk5qwDGUL4zPml6rpBBsC9arE1vleNkafor0p?=
 =?us-ascii?Q?xIE1gQMehmurTDiQ+lR1Aa6/S+3dFjyn2hk80axwLv2ESmCWCR0tX2gZ4zcE?=
 =?us-ascii?Q?d9KB6jCsdXsNPy7jYweGbJIa8Yi5KakddNOgZAMmT2xfx4X5OGShJnrnZQPk?=
 =?us-ascii?Q?nbQJTBLx+uNVC7gwSF/aWHeXgFeaLX3VGHlND0uZVuhfNuolt6ypW045itTq?=
 =?us-ascii?Q?nGCB2pNekML8IX3mka5/4xrhfMJiVf4FgnAood++TcQUmZBeOby5sqFAZ9tB?=
 =?us-ascii?Q?iL21V61JsZ4XHH/jJ2U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc6bdcb-a86d-4c61-d676-08d9efca2e69
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:56:29.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daFMem3J53YBAcAKfTDWkctR1VzKLeETv7NFUZ5kLgTsT8OA+YqVWEL+905tym6K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3225
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 02:10:19PM +0000, Robin Murphy wrote:
> On 2022-02-14 12:45, Jason Gunthorpe wrote:
> > On Mon, Feb 14, 2022 at 12:09:36PM +0000, Robin Murphy wrote:
> > > On 2022-01-06 02:20, Lu Baolu wrote:
> > > > Expose an interface to replace the domain of an iommu group for frameworks
> > > > like vfio which claims the ownership of the whole iommu group.
> > > 
> > > But if the underlying point is the new expectation that
> > > iommu_{attach,detach}_device() operate on the device's whole group where
> > > relevant, why should we invent some special mechanism for VFIO to be
> > > needlessly inconsistent?
> > > 
> > > I said before that it's trivial for VFIO to resolve a suitable device if it
> > > needs to; by now I've actually written the patch ;)
> > > 
> > > https://gitlab.arm.com/linux-arm/linux-rm/-/commit/9f37d8c17c9b606abc96e1f1001c0b97c8b93ed5
> > 
> > Er, how does locking work there? What keeps busdev from being
> > concurrently unplugged?
> 
> Same thing that prevents the bus pointer from suddenly becoming invalid in
> the current code, I guess :)

Oooh, yes, that does look broken now too. :(

> > How can iommu_group_get() be safely called on
> > this pointer?
> 
> What matters is being able to call *other* device-based IOMMU API
> interfaces in the long term.

Yes, this is what I mean, those are the ones that call
iommu_group_get().

> > All of the above only works normally inside a probe/remove context
> > where the driver core is blocking concurrent unplug and descruction.
> > 
> > I think I said this last time you brought it up that lifetime was the
> > challenge with this idea.
> 
> Indeed, but it's a challenge that needs tackling, because the bus-based
> interfaces need to go away. So either we figure it out now and let this
> attach interface rework benefit immediately, or I spend three times as long

IMHO your path is easier if you let VFIO stay with the group interface
and use something like:

   domain = iommu_group_alloc_domain(group)

Which is what VFIO is trying to accomplish. Since Lu removed the only
other user of iommu_group_for_each_dev() it means we can de-export
that interface.

This works better because the iommu code can hold the internal group
while it finds the bus/device and then invokes the driver op. We don't
have a lifetime problem anymore under that lock.

The remaining VFIO use of bus for iommu_capable() is better done
against the domain or the group object, as appropriate.

In the bigger picture, VFIO should stop doing
'iommu_group_alloc_domain' by moving the domain alloc to
VFIO_GROUP_GET_DEVICE_FD where we have a struct device to use.

We've already been experimenting with this for iommufd and the subtle
difference in the uapi doesn't seem relevant.

> solving it on my own and end up deleting
> iommu_group_replace_domain() in about 6 months' time anyway.

I expect this API to remain until we figure out a solution to the PPC
problem, and come up with an alternative way to change the attached
domain on the fly.

Jason
