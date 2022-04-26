Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39045510C6E
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350749AbiDZXMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 19:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiDZXMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 19:12:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45A6EDB65
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 16:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ5DukxpI/DExe9HDAAOhqjkXZvcuuaVY0FbL9ueuDjq5+JJoTcQP7Y33XKuAAoFs9mhva1E7H0S/isCKx46k4H++IcG1O3Y/Rlx2hrWZNmt9wimmH/t86Z1jRLt1Bs/DtXAGYVc2Jvdz3mdJlSPLPt1RPa2cqK2+0l+eMEa7SBRajl/dssPJ8PmFGjX5PpREl0ltgL2hlLQpiGPzsdkLGfFVNBm881qCmnTUneP1DXRlIAVr9Kje9tN6s3iAyPPzwpJwBhX+h95KsgQ4SKdrG/SyFw442IescPjL19p8iDF59m+dRY3tNqWSaUdH+mu6bG4jsC7BCgGKIgkY8NqOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LoqofToO0tWWEy9sQyiJFyHPf5PMAAb7xxKJG4TqzbE=;
 b=A+SvsgWNXv8CmO0F+GWVDLMWIRBb6vJJLbMIKPf2N6l69mjegmvYXkdPQ3DgH2QfPbJ49+atBjitBtazvx0NWn75gnF2q9iG2LWRihNyC4D5as5ycXnarTfDMFbY3MjYfFrvmIT8wuqAz+84XIL70InQ83mE4DutiAx/PGuNWlKHiHiu7C2FSkc98lHDsBnZ6x81zzIm/CxZUXrUe9Fte01MQ/erYJv26bAurZZwg7CnxdjGE0uTU2RfJvWDLBKG7F/0oQoh8AY2ru/Nl/Bao1HiyxATRXHchAJmqGmFU8uFdazRkopO5nkKlLs37wF7jooGBHGOkzW8Bcs4xIYFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoqofToO0tWWEy9sQyiJFyHPf5PMAAb7xxKJG4TqzbE=;
 b=P/8OYSTfQq5s38fQrzQ5V3XiVmIZ11MaB7SV+TyfdJuI5jDCpYL3xr3eBTJrFsDHQG8RVoIrGBsqIzsBv42hEcaiaz8p4pHsUw904j+jddBZ0VkN27fJA9cyS5wWwjZ82SgOZkP7qkbeflAc1G7zdD0Q2xXZu4lOl7rYoMQhE9kVcNnUQGBqZoNduizTiJnRIdtlgLRF59xiMyJ+lzhItalgMkORL9ajC2N6vygK9jY6QUjPx3q0pdz1eM4CxKQwaagHE2W1XpSgW+Ir1gUF97YuM/bciVkRmQwpgE5szsErNiQ2cr5wmoKxlpUDB3GnbAbN8kJjKT0F0nNUlpaFvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4607.namprd12.prod.outlook.com (2603:10b6:208:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 23:08:56 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 23:08:56 +0000
Date:   Tue, 26 Apr 2022 20:08:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220426230854.GU2125828@nvidia.com>
References: <20220414104710.28534-16-yi.l.liu@intel.com>
 <20220422145815.GK2120790@nvidia.com>
 <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
 <BN9PR11MB5276AD0B0DAA59A44ED705618CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220426134114.GM2125828@nvidia.com>
 <79de081d-31dc-41a4-d38f-1e28327b1152@intel.com>
 <20220426141156.GO2125828@nvidia.com>
 <20220426124541.5f33f357.alex.williamson@redhat.com>
 <20220426192703.GS2125828@nvidia.com>
 <20220426145931.23cb976b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426145931.23cb976b.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6001c4b4-0e67-4043-b917-08da27d9bcf1
X-MS-TrafficTypeDiagnostic: MN2PR12MB4607:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB46074C13AE4C6A7EF87CEFC6C2FB9@MN2PR12MB4607.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmZF+6ZpxahBnCvujCHKc7jua12RyabK38FS7P1uvS75LcLYEtIsJocjcUPCNCe6dGr1OhttEfceW2+Wv5CLqT2GXWXMxVqXYUPIVWvC42FWQBJuEyehirdnT7Wwchu32iG99wH9+o5FJzBxsnWUl08GmaI70aAvVUe2Jf1R9m5HGj6oDYdP3soXXwPYi5BdyxdJyf4pIYtiIFYa4x7xyTULrsestK16ur2YiAuGB7Jb3kK8GhsCL+Wx7vWh/41vPzIfp8V9bH7BWb15V4yRhJVQ/WC/BWJKXJNgGgzAg0pEuZMwRzuVHCjAdmPSYQqIFYJYAybaXLUEE2pTk6fuD+/mtdm4p+D/oqgKySpTYeeCHNFsMyWXUpAP8qJRasQW6tH0vZmx0KtBSQyP0fefiEUw+yszGwj3TaEOI3ojZqxJQXqla+48odzG9h9XHq4j/rpYwSqhc8C9Q6/ZQXKRcOZ3E76ZN2CDiNYPZCN9TmpUNThiaA6+zA3C+UykfxvIF1k0A8t8Lq8THSuEgTxguvSm8+Ti9jQPiMC5Q8EcMuvVwKPyTKJTVlBWI4db7vNa4JgMYVwOA78hH64QObZ/odrt0br/xIIMYqLEP5zNv2UE5Gl1sIUx4v/CzprDM6P6O85j98+TpJRVS1mrNoNMPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(5660300002)(2906002)(6486002)(66476007)(508600001)(7416002)(4326008)(186003)(2616005)(83380400001)(38100700002)(1076003)(6506007)(8936002)(26005)(86362001)(33656002)(66946007)(6916009)(66556008)(316002)(36756003)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DtZ0mYLQ4Kzc8Zc+YsutqlNl8Gp9qipdwljArzUXLIkfO5oIY1DifArHJ4qk?=
 =?us-ascii?Q?26I4qVsjUWOr1CZVOZ+iuYofSNYBEM1ZlKNKFHZeEWgDLDDlygELPRKpdwEL?=
 =?us-ascii?Q?Fd3u0G/c1gmDNvcfHhW8bmW7fb9GPe9DuWccJfYsjxjArtcXdJzVdnVqmNfu?=
 =?us-ascii?Q?/tKTmLyYTsmOjfsEiNY4aBbYCg1WRwhAUdZYsJvBeEhxsPddynR5hAkBxMJs?=
 =?us-ascii?Q?DhdFL/+2BuffSKKX10z+4cyEFBigUFZ5TEIoUcMgviHtKZ8L5aQSjBFeT86I?=
 =?us-ascii?Q?0W8FFaIhfgmRHtImXw25r+L5SSX94hzHaoPi3fm6lgB60OYrDQMH8H+eHq2T?=
 =?us-ascii?Q?s7n38AFS2CjpgOAY3o5N82lzebgHNwwtggIAAYYiW3U6BrRMKzGevkf0Kekp?=
 =?us-ascii?Q?qIvgbTzu6L/EJ4uNQ8I0rGqTUkPWzu4rVhvrFSqlDCpqzH742lh7rwROYi7n?=
 =?us-ascii?Q?jySwgAdWsJ03DBrV9BsFRdAtRASDMEpaq7f+EIbcpi9qxgtDosdtnuit7hAt?=
 =?us-ascii?Q?km4JE9HBMVwx9afrEmuvZao9LuFvs5EhJjXhh1LIie6GHYyzOFrwi04UVW3i?=
 =?us-ascii?Q?thrl/ww4Sc/UcienpMsi2MpT7yk0+oxe1T/tFTUJ5K9B3NHrKRVQJUa4QbhY?=
 =?us-ascii?Q?x1q4y0Zq2o5hQunOFKMBRhK4c15Jlg8bRNL5rH51oH9O/iF1/+lkHwyVhB4x?=
 =?us-ascii?Q?i3NPscPsxdl5mX0GfvYil1H+XOHUJ/fvQXLtzg01w08PO2+BEXxjET8v+em5?=
 =?us-ascii?Q?q5pqf30gjCPAwUERlpex7MSjfmC0GMwM4g9EuvY61UQ7v6b+K/8hYf20ys3c?=
 =?us-ascii?Q?pZBfZl4koQf9udrBTaVQlvgT0G7mlrm3Rt9RGS+/NGNP9enf8kgOsk9RbmDN?=
 =?us-ascii?Q?TdNJ3ATsYrI+c6yi7rMLklNK3ol3aLNLRjKXG9XWqnTkhrHVbQC00EQD8ek5?=
 =?us-ascii?Q?OaBw2s4eNo8KBVqq/wawDsCjbJM0Lq4wLpSBn9ThVRzmmRTz01bx/poehuI4?=
 =?us-ascii?Q?SznFLAXdtLU+8Tf0ceSXWScxjhWGaEIVZvQ/NP3RJIg2lXOzmTkqkPzXpw61?=
 =?us-ascii?Q?flD57Q20/nMgIzi5gzaPrtfMxH5rfsySPZ0Tu2re5IV1UZ8PnPdGI2k3bk/y?=
 =?us-ascii?Q?28wSHLVYPMt87du4Ki4SPmJ0P3HtcxbFgaga9sH6gKJm3ZRbouSMqJd9nxdN?=
 =?us-ascii?Q?r3HVxa83YDhLGPLVtX6EJyGiiGItAqrmToPPwVwgBi6OvaCkUjsJY8ncGx6Q?=
 =?us-ascii?Q?wBHioJZjhvNa4a7pmedEKoGdUl4JCIMAC5Drpln+AK7i+qxsLDsLfQNARnF8?=
 =?us-ascii?Q?d70Q64um41zIxyiCEh6EANGmozuvU7weGQV0gWKlx64vBS6ZDJ531oxHxXxI?=
 =?us-ascii?Q?xeW9R3FtVIL2SALnosFUeFCxN0meEA/s5Ekk7du3DxUYJgznNyjKlvQ4JPcM?=
 =?us-ascii?Q?j1fYZ1X1qUweSBr5XhC3l2Q0WwbgVnZh5m5tMxm7li2Hrqt71fUHehc5YqiL?=
 =?us-ascii?Q?jVX+H3r6o2DPkmUR1VkZGOlvQdp7xUlwadMjhfnUe5ij9yPcynjT4mixDzwM?=
 =?us-ascii?Q?WGxILzYArnFPo/ZFkvB0dUXmDdqhYz7ZvyG/672CJsafVPAn9uO4I2BvsONP?=
 =?us-ascii?Q?PJG4VWkt656/4c07DUN/a7H7rtjAcEl2kOyX0tQcllT0kg8RXSZc0AFNmnwJ?=
 =?us-ascii?Q?LIhxbKeumMxpkNzjBiY2ipZ/vrJRCDl+iIjYXstrs9w6Ux/nkWKJCXRvhh/2?=
 =?us-ascii?Q?JLJswb9tPg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6001c4b4-0e67-4043-b917-08da27d9bcf1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 23:08:56.0815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMPkH+fZeQ7iMeDzFKfZp8x2ve/t2s7j6tunaykCG5zhgwnAl8DWROh8+zP7j1y9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4607
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 02:59:31PM -0600, Alex Williamson wrote:

> > The best you could do is make a dummy IOAS then attach the device,
> > read the mappings, detatch, and then do your unmaps.
> 
> Right, the same thing the kernel does currently.
> 
> > I'm imagining something like IOMMUFD_DEVICE_GET_RANGES that can be
> > called prior to attaching on the device ID.
> 
> Something like /sys/kernel/iommu_groups/$GROUP/reserved_regions?

If we do the above ioctl with iommufd I would want to include the domain
aperture too, but yes.

> > > We must be absolutely certain that there is no DMA to that range
> > > before doing so.  
> > 
> > Yes, but at the same time if the VM thinks it can DMA to that memory
> > then it is quite likely to DMA to it with the new device that doesn't
> > have it mapped in the first place.
> 
> Sorry, this assertion doesn't make sense to me.  We can't assume a
> vIOMMU on x86, so QEMU typically maps the entire VM address space (ie.
> device address space == system memory).  Some of those mappings are
> likely DMA targets (RAM), but only a tiny fraction of the address space
> may actually be used for DMA.  Some of those mappings are exceedingly
> unlikely P2P DMA targets (device memory), so we don't consider mapping
> failures to be fatal to attaching the device.

> If we have a case where a range failed for one device but worked for a
> previous, we're in the latter scenario, because we should have failed
> the device attach otherwise.  Your assertion would require that there
> are existing devices (plural) making use of this mapping and that the
> new device is also likely to make use of this mapping.  I have a hard
> time believing that evidence exists to support that statement.

This is quite normal, we often have multiple NICs and GPUs in the same
system/VM and the expectation is that P2P between the MMIO regions of
all the NICs and all the GPUs will work. Hotplugging in a NIC or GPU
and having it be excluded from P2P maps would be fatal to the VM.

So, while I think it is vanishingly unlikely that a reserved region
conflict would cause a problem, my preference is that this stuff is
deterministic. Either hotplugs fails or hotplug configures it to the
same state it would be if the VM was started with this configuration.

Perhaps this just suggests that qemu should be told by the operator
what kind of P2P to export from a device 'never/auto/always' with auto
being today's behavior.

> P2P use cases are sufficiently rare that this hasn't been an issue.  I
> think there's also still a sufficient healthy dose of FUD whether a
> system supports P2P that drivers do some validation before relying on
> it.

I'm not sure what you mean here, the P2P capability discovery is a
complete mess and never did get standardized. Linux has the
expectation that drivers will use pci_p2pdma_distance() before doing
P2P which weeds out only some of the worst non-working cases.

> > This is why I find it bit strange that qemu doesn't check the
> > ranges. eg I would expect that anything declared as memory in the E820
> > map has to be mappable to the iommu_domain or the device should not
> > attach at all.
> 
> You have some interesting assumptions around associating
> MemoryRegionSegments from the device AddressSpace to something like an
> x86 specific E820 table.  

I'm thinking about it from an OS perspective in the VM, not from qemu
internals. OS's do not randomly DMA everwhere, the firmware tables/etc
do make it predictable where DMA will happen.

> > The P2P is a bit trickier, and I know we don't have a good story
> > because we lack ACPI description, but I would have expected the same
> > kind of thing. Anything P2Pable should be in the iommu_domain or the
> > device should not attach. As with system memory there are only certain
> > parts of the E820 map that an OS would use for P2P.
> > 
> > (ideally ACPI would indicate exactly what combinations of devices are
> > P2Pable and then qemu would use that drive the mandatory address
> > ranges in the IOAS)
> 
> How exactly does ACPI indicate that devices can do P2P?  How can we
> rely on ACPI for a problem that's not unique to platforms that
> implement ACPI?

I am trying to say this never did get standardized. It was talked about
when the pci_p2pdma_distance() was merged and I thought some folks
were going to go off and take care of an ACPI query for it to use. It
would be useful here at least.
 
> > > > > yeah. qemu can filter the P2P BAR mapping and just stop it in qemu. We
> > > > > haven't added it as it is something you will add in future. so didn't
> > > > > add it in this RFC. :-) Please let me know if it feels better to filter
> > > > > it from today.    
> > > > 
> > > > I currently hope it will use a different map API entirely and not rely
> > > > on discovering the P2P via the VMA. eg using a DMABUF FD or something.
> > > > 
> > > > So blocking it in qemu feels like the right thing to do.  
> > > 
> > > Wait a sec, so legacy vfio supports p2p between devices, which has a
> > > least a couple known use cases, primarily involving GPUs for at least
> > > one of the peers, and we're not going to make equivalent support a
> > > feature requirement for iommufd?    
> > 
> > I said "different map API" - something like IOMMU_FD_MAP_DMABUF
> > perhaps.
> 
> For future support, yes, but your last sentence above states to
> outright block it for now, which would be a visible feature regression
> vs legacy vfio.

I'm not sure I understand. Today iommufd does not support MMIO vmas in
IOMMUFD_MAP, and if we do the DMABUF stuff, it never will. So the
correct thing is to block it in qemu and when we decide exactly the
correct interface we will update qemu to use it. Surely this would be
completed before we declare iommufd "ready". Hopefully this happens
not long after we merge the basic iommufd kernel stuff.

> that legacy vfio has various issues currently.  I'm only stating that
> there are use cases for it and if we cannot support those use cases
> then we can't do a transparent switch to iommufd when it's
> available.

P2P is very important to me, I will get it supported, but I can't
tackle every problem at once.

If we can't agree on a secure implementation after a lot of trying
then we can implement follow_pfn like VFIO did.

> Switching would depend not only on kernel/QEMU support, but the
> necessary features for the VM, where we have no means to
> programmatically determine the latter.  Thanks,

I'm not sure what "features for the VM" means?

Jason
