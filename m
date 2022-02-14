Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67C34B52AA
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354824AbiBNOCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:02:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiBNOCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:02:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAB12E4;
        Mon, 14 Feb 2022 06:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4tpOkX8oHkveNGCPQcoIV5lqSx3w6WAAOSL6LUn+Y/ZFnRQPoI/ZvEU8VYVMHQpPUQdGqPye4ze3B04JLHTCCw8piQHVjGr+FRCI86GU8rYRZLk10/ogCRZ3UUI4md+PNjNNfdRksSdsspa44ztN1TB2ztv8wGLNpYp4gHtJPpRkAPWTvYniOyacOk3M8jv51Hc+5WLpKHa850OE7ejim18BKDEgOLZ2yCUMdL3nYebWVaXGqesd5L+5/4dv2dEnJMY3oHLp36mbNZio1zwmH6o7z3Do6PBeziLS18PM9b18tCO8qTti5vYDmlWgfDxlU+N7pdLdiXT9QH9d+UosQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y31IvswqEg/8ddV7W0PHU9lZtEYbQrRXQskMocsL+NI=;
 b=huOnk9LYU3BNCqbFpLBHGlyJwqmCJv9LyHvW7Pb1eLW1RHgsAWFO+XKfSov2CSP8riYmLMi04YIm0EhcxKicYju48vCB1YO+pC/D0xk35neflCHrrp1rUugxxP1kPy1um4K59V30GWiMnto8hYxsyNmo888jQJAtGkFWPYREFahcpV1fHSPPG27VTzjfjb6m3deKY2JgTJRyO3JNSRVp5gM7HEAzrVyTMs1JBqKZi8N3wIMecHbL6hwMitwnSaNzuxJ68oP9Zu17DnIHL2cYsToQipK0UBjCZNub/G6+EHKiGGMa5q2AeM35CElXkDXF4GJzMpSVExOtwRpPvVLmPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y31IvswqEg/8ddV7W0PHU9lZtEYbQrRXQskMocsL+NI=;
 b=A1hbgfuX0xbf9zXFCL/T9dqXoOeZavKnx+3Zd/xdgh6Z7CkNBlD2csOAa1vfnRnfiqvcE2Aua3zn2w1y4MxEtOL5Pqcz3cBHNEkU5mPNyBlUm3i+aPKCSEbbRvAVe3vIWPNKPtQm2ulZl737eCkwtoMItHKp/w8vvtBqbb+5S71QDzEHY7vfh5sWKKm2G/Fh6oTxbDGyu+Wmww4sX1mcsypqgOwiuZ/VOueM4NstCEl19EOKivhn8tC4da9v6lxdO420Y529NhN0jfJACN4f0jGa7j9ciBLNbcfao7k06Gn+xarsOx94gJ712x4imP889FiMPWjCypOmhahw2JdfHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3287.namprd12.prod.outlook.com (2603:10b6:a03:131::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Mon, 14 Feb
 2022 14:02:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 14:02:37 +0000
Date:   Mon, 14 Feb 2022 10:02:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 5/8] iommu/amd: Use iommu_attach/detach_device()
Message-ID: <20220214140236.GC929467@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-6-baolu.lu@linux.intel.com>
 <20220106143345.GC2328285@nvidia.com>
 <Ygo8iek2CwtPp2hj@8bytes.org>
 <20220214131544.GX4160@nvidia.com>
 <Ygpb6CxmTdUHiN50@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygpb6CxmTdUHiN50@8bytes.org>
X-ClientProxiedBy: BLAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:32b::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44e4c1fa-5e6c-43a1-2c48-08d9efc2a7de
X-MS-TrafficTypeDiagnostic: BYAPR12MB3287:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3287C8B5AC688D33CE902C47C2339@BYAPR12MB3287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXLqlHVjpUrsl4KJYyRJbt2B9MEvlG9NJtBM14PpQKnCAVOfHXWv4M1pIMFR317AhN3bJ5gKMRX9y4ilgwOc2z1+u4YwNecz7ESoG3+rgweThqMWaPrAO2pHFrZg3i8CMRfwV4swWX7a36PXdgmjWU5HFd5/82myf6JQ30xOl0k/ZfpH4xYbED3I+tj7l3DWFw0vIzqmE0m55fADSQFX4N3TYeE81xYOKc71QHjy8BGvopoTZpaaSYCzflBmTvQut4rYVCgA8xGtQ1jVQTUwUkicwJGV8yWr78WmJyuUU9BPgAx2d/lBL5xgYnxsg0fb56rowsQlU5sPy6h1vOZatH+UjtYtqnsyhwge0OBp60qHRw9HvDbvZ+H/b0UGx7WotddS2vATTUUvobhuhb2qcWxgDm5ZmD7SFKl6hbuU9p1IHsvpGpEBhRf1Ni4e60MVnUGJXJQI9oB6JYghH6+6ESuJn/BLvhUJd6KaVKIXGvkMFeisRolLzyV38HqCpS8djTiF8QeoNpfEbOsZAOoV4H211BNDxe94WVLLzQMvQ7/TVS1RaLvAvOsC+iZp2G9U9hYL4S7qN86Q3CfiThKMwwKt3/IPSPUtNnC5qe+wCFLI98SJKqMSGsfMmAxTuvQ7MPs/xudh/5z1fRQPSA3BZsmj3Yu6ulrFLJDzmcGTkd+uRxkHqtx/8TZkwQ1QAuqB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(36756003)(2906002)(508600001)(5660300002)(6506007)(7416002)(6916009)(54906003)(26005)(33656002)(316002)(1076003)(6512007)(4326008)(83380400001)(2616005)(86362001)(38100700002)(186003)(8936002)(66946007)(66556008)(66476007)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?71+cAmYQtR9Ir+MR0PCUJTxBz6hQmgPSWjGNRsE2D1Bbh40RgF0uZr84P66A?=
 =?us-ascii?Q?1ZFbZyLznLwt3GhG480LdrJ9WTt2poz7AgGieBBB4Nt3vz7QB3PFOj3n1qAZ?=
 =?us-ascii?Q?n5h6LeQFirzSuZpq8ItN4Jnj5Ct3GCt+ff1Q4ZpUvue3QyKYPKaHChVTk0TE?=
 =?us-ascii?Q?W++QAqBTmUXssXzRRbsNdB4p9fYhx5O9z1FEQg9O1tg4vRe/aDOpra3lHMQh?=
 =?us-ascii?Q?6AFooNlElvAWCF/Acih2WP9tbzgY7hfoV+vU5zRfq4FvuvSD0ZE1nyVOlt5X?=
 =?us-ascii?Q?VreBlbOLmNfvZ1WGk8+wfNJwsJSdRcxV0bZyEGt0zM9un4iaCHHVKi0tpRsB?=
 =?us-ascii?Q?bItpcK6C+12swLP3V1RtSIUe4phokhIjMtit+MBy2OPjKEJu/cawUGW2W1fG?=
 =?us-ascii?Q?JCqdPc8KKmxKf6s4LumwPKRU2PGmIfLv8O7PsqkiECKfJvR3grFMDmHJhHQu?=
 =?us-ascii?Q?3jKOMDfgHpzCAk+V0+3V7pcZ2f1h3Z3pYK+bi+dJvJnjMoXMA1tsuGzhGeDY?=
 =?us-ascii?Q?ZezAJKocVBgljp9V2s8J5pu5Mu8GiPNGruVjrbp5PXIH8hKr1O6NXWJgeSdG?=
 =?us-ascii?Q?cJJYz9P6aWucRyZHZB40BFF0HpN9kMqOkYlhHtUoYnJ4NOp2nvu99qmyL30w?=
 =?us-ascii?Q?OCgOeF46STMBklDSYmbwRz2Trjy28jxPZZNwRhRukBc1UYfnneVJ67/LkDdf?=
 =?us-ascii?Q?hg/6UJG1GC5xTbYIWmnhkclVdn1oI7qGjSPEDFyCAR6yUnOaD5k+MrQZhIb2?=
 =?us-ascii?Q?+7vvdaBBv2Gnhaf+5/iMaA16I0QCtSkJr/mOSlykD494hfUj/QyZOQl33FNp?=
 =?us-ascii?Q?ej/97Csy3yyzI0S8QnXMhLuWUcUMCroBnksuUoCkaO6OPwhm1uadk3zEZRPM?=
 =?us-ascii?Q?ZeC2hGAOXn2CBp/Ax4HfQNxQkCJn5rPpleTlUDWZzIfyxme2lvfv18wPE04S?=
 =?us-ascii?Q?yjvjU3819Ya+63THLPjhK1Q7emq+74SmOn9HxYzI/FzENKDVV+3AnJb3rKR9?=
 =?us-ascii?Q?TsX1nPTndCTtRxtAHtkMo5Njqa0HwAJR2yf79DbevIaO3d+uExBPBXrMzVHc?=
 =?us-ascii?Q?e0IlegIRbbDgEpN6DBIo6mkDsdKAEXb6WrXDVPpAzgMrKF5eHKTrBZH+Astm?=
 =?us-ascii?Q?W9UoeaSiVpPIJibNsnnjDIx8X8WYd9ROxzYZIS2qtwM/gvc/dats8ElIBNxf?=
 =?us-ascii?Q?FFx7XicTJCMfatKnPQgcyYQ2FF+TyTunYwNl8IVdtq0bK7lWkwvFvSMWCIsT?=
 =?us-ascii?Q?MTfbx/tcZW/Pd0fMuVbXo+8obB4PWuA/M14sIE7ekfXgjGEtcytiHPxsUfSy?=
 =?us-ascii?Q?estJGR4AA+kIciN319k0Et782G9pn0b/Q1WPjsssvYWVjWZaFImB54SioIDd?=
 =?us-ascii?Q?Ns5DZHRTcCZ1yI6GbehFrX2LHiRoYq0BHXRlHeXpD4NmIbkkIuB1ngYNy3WB?=
 =?us-ascii?Q?qHiZ9hnAX568AVJjTVYEd7oRnXoMXm/mMI0mNKS7/oj12GTL+dh7P5jNr49b?=
 =?us-ascii?Q?CYYNwfyxKTA+vv1ePqSVIZLzip0FoBfKvkXBPTzXzzI3RAnfSKsr84vgwGQM?=
 =?us-ascii?Q?l7jmqnm9SFhRaIrKB2M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e4c1fa-5e6c-43a1-2c48-08d9efc2a7de
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:02:37.0091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sVy6m37oW1I3lDQSnKbjr9KyjF8WdqBAdqkOZRt7HrNTbGhU8QmVfaiivm/PH/i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3287
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 02:40:56PM +0100, Joerg Roedel wrote:
> On Mon, Feb 14, 2022 at 09:15:44AM -0400, Jason Gunthorpe wrote:
> > But how does the sound device know that this has been done to it?
> > 
> > eg how do we know the sound device hasn't been bound to VFIO or
> > something at this point?
> 
> The iommu_attach_group() call will fail when the group (which includes
> GPU and sound device) it not in its default-domain. So if VFIO attached
> the group to its own domain, there is a failure in this init function.

That works for VFIO, but it doesn't work for other in-kernel
drivers.. Is there something ensuring the group is only the GPU and
sound device? Is the GPU never an addin card?

I'd say the right way to code this after Lu's series to have both the
GPU and sound driver call iommu_attach_device() during their probe()'s
and specify the identity domain as the attaching domain.

That would be quite similar to how the Tegra drivers got arranged.

And then maybe someone could better guess what the "sound driver" is
since it would be marked with an iommu_attach_device() call..

Jason
