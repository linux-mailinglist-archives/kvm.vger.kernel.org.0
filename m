Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE14F9E1E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 22:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiDHU0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiDHU0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 16:26:43 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2051.outbound.protection.outlook.com [40.107.100.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF822A777D;
        Fri,  8 Apr 2022 13:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFHKkvdgpFn4JhbdiNP4YjknSUfGc7ZlgwHHW1Ni6fhPCKsbVqz2tiwRQodu+riZl0eRaQQ2hLUwomrmqfTU6e8hkAFZd5Md91ltTF/XCloYiJLE4wl03ajVVgOt7HMNFBM8eBZIxM683TVfZC9j50zLUs8dikYWMlmCkjLBlEYn0OQKYvx/xGtdn7w4KUg04iG7KFQAltL6IxG7vEfGvBHXS9tulA7WAzJBgiHHZBiy49e7Js+/GNmySGhsysbfc2lfJkGElqvP0v7ScU1VXTvJqy1MYnDHjWkeUgOMs9LCuEARNxd0Ia4GNEho7GxbVKaoATfKSbLfJAyvmqqy+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfKobq+otFMpGrYKWCo157EVROdoUL3+Gb/T8G872NE=;
 b=bhnwXplUaXpZx7IwG6cxDjgBaWGoosUE5DlY0heshx5Vr7e2idXKs6D7uBBE6+cYmlGvOiwVcwplGlLSXW6nYw3Hjr4Or3zac3v+q6ppy0kpOEbN/zt14ZxIaikR3FmAh4K5SPyoxvmZE/hE9QHLd3mje5C8YXdPUcZ53L+751xAv2pis2pPhCsTclhbWujdmW6USH6Jk2e3Ie/gUAXA8ITT/TT4nhPLX4hdBn4WzkMi80Wls/U/3YUgK1ldAc9fkjsPRrsU/Wt1fSoHD+Jch9uRwX2by2lDrfExRdRCcy39v4R2LV1LF8a5zsIggfcSPBHWK5sX/LyXB/91XNe3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfKobq+otFMpGrYKWCo157EVROdoUL3+Gb/T8G872NE=;
 b=VJ0+u2B+atMxiSSvdi5/Q6c62zOZwm1gnV0zGbM/s7DXLCdTha+BfKJPJyrMUe/W+M9RZplgXkfQgaZoHgmY/f2Xk1c/HHkICYBInxGw6eIptO69Sq6draL2pGs2eBR9bZuhQ3H8GuxVHCvjN7jZjpF35h2TLqfo6kE6YLhKeDewJC+zBm9dY30JuB7xze2aTwP35SigJ8+pPksFrtfAWL4L18rW7oI3LVTPy3i4G+gTlKN/L0LU2PebUaisJ3u7lhq53nhuDyw3EcAFFtfV2tR8anB2J0Sgs0vvNPwBceD3oscI48vbF4EAVM8kQ/twQ2ZQgq5esXBSA6+ypI4ODw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB4849.namprd12.prod.outlook.com (2603:10b6:208:1c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.23; Fri, 8 Apr
 2022 20:24:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 20:24:35 +0000
Date:   Fri, 8 Apr 2022 17:24:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v8 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <20220408202434.GB2120790@nvidia.com>
References: <YlBWrE7kxX9vraOD@8bytes.org>
 <20220408155922.GA317094@bhelgaas>
 <20220408100750.77fd9ffc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408100750.77fd9ffc.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3df9cc82-4865-47e8-6a18-08da199dcbfd
X-MS-TrafficTypeDiagnostic: BL0PR12MB4849:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB48491740215DC27030E61ADCC2E99@BL0PR12MB4849.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mSB8P5MN5zKjC85Md1PkD4cwxLpP/Uzoj8ckUToh+kzN/V3SAIUvk+ZM32yoAGZgYtgXtIkYL3+GseJh7x70ZPGN34925Z/I8ixl9pJf2bIgszkzDbNddLez0QfkU9TOq8yKz+T384/brf/3nErMmaZqkk4FKteYXhprNktC5AUlVp7ncBcIAVPKO/xv1aBlKu8vr959ilw6Eid+WFIeJI0UcNpqkAaRqOY2k18Jc6S9ryz5bXED8emHirS2Nyfzti2vqbjVpw+f4Owp0iw7H6GDnmbX4WcCg1iW68xS5XqfWeB7lQKTrwgjTSEvvpmnXDjAJAcc1GF1FAd01Aw5iSwcdRc+HgKqLI99UvW6dF1r88xq+Lb4MG4okuqv2H1kxO6uyvAtbVzghPHHoKsRYr/WwEIjaziFWyHl9NSAy13Li+X9Ielal1qPXHIpZasEeuWpQP/k7tnFSmeMLS001T8jXiE05AZ7xUgOwZraV2UQyFlXuKClUAmFyZK6YU8pvU4wwOn4EX+dO2EmC/62TV9dmV8fc89iRDrEZRIYSiXpoQtDzLSWL9CIA/DVDdyIEZA/Ux/I7tik2LKZnc0drsFMg6BQWnsrgV4B+BAECRoQx0/j/Ivu9tkoEl2vHuqKdJnD2gaH6VHUF+kUC73Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(8936002)(6512007)(5660300002)(33656002)(6486002)(4326008)(508600001)(8676002)(2616005)(66946007)(186003)(66476007)(26005)(2906002)(7416002)(316002)(1076003)(54906003)(86362001)(38100700002)(36756003)(6506007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M+mJcwhLVf5A237/ULK2HEHv1RGCk6Dse9ulVvcmij2RoJVUQDRqN0LAeQ8o?=
 =?us-ascii?Q?35bLRTg8zuorA98wv6xiSX4fT1LmxNYYiTf5yYOBNcXqJDPY5BioYgrelf2x?=
 =?us-ascii?Q?4TeSanAj1VkKIFyvt6i4E/zLeIDG0KegZtwFepdHXmy+1iipUsiH44hX6EAo?=
 =?us-ascii?Q?iKI3QV9WrOJxOAXly4w2MdScW0tFee3YfUhIYq6v7/dVICx7O3DRChH1N2/C?=
 =?us-ascii?Q?9784oUVwPApT6zDbqDCjEgRMWts1OAUsENq0b6XMh3kMPtzZ4xPh2kS3Mfkv?=
 =?us-ascii?Q?33Sb5fdooBfjG/CDSqXk4CWQAUg4WBqxxUBTKpbX2XMs2dBJ5QYUs3vlIKab?=
 =?us-ascii?Q?OdNwnKWh+WDtsVc9RCuXwByzqD31IdJrxEaeqVXqSPk6Khr0/Y74uzWRAnfD?=
 =?us-ascii?Q?dZiHF+itorhhK87vnC8NKsXOXDRtA+agWrygTCYRYe3xxZuAxGhDxCFmxYdx?=
 =?us-ascii?Q?rfHw34EKaGq8svXOac2rpxe4FFnOjxjbnaKbeLzWn/RL7kXjuGbmERYn4cMp?=
 =?us-ascii?Q?Qz39NNOb+lL+BQcDrLBxurGT/KFqIuPrOtQ7MuvnOut2ylERiMN6UMaR3cN3?=
 =?us-ascii?Q?vsgHIjuozfb0dG/oARnZ8Fe+W2f4zj/e28baSqJDL7hwfsWrHiGG581wRh+o?=
 =?us-ascii?Q?TcerQxpF8rj+DomBLb7XQapTcmjjoQ8+r2rLC9wpn47cHErQMGkK3LawKYrp?=
 =?us-ascii?Q?LIfdDKCnxbbn4/szzR9nac/XQ8+CjF9Z3DXKKFfF8Tv1HtciLmWS/0adXiJx?=
 =?us-ascii?Q?gV4ZY9PP6OqT4F8hgXV+TsbowznYc0m3VmRYMPDYCp6c+sunKr26o2fmnybO?=
 =?us-ascii?Q?kzUvLbk6cbbVHlDsHe/gUpi1sWK8UP6NRWPm0E0laRSkZhlisIrYxs4/RZ88?=
 =?us-ascii?Q?OJONhhG0gEdKlUlUCsOUFpygbbZzk4MaIST278wFEYWNGH2E7v4t4ZsuN8m8?=
 =?us-ascii?Q?RiiT7FRCPJAJM4BP9KBXRYBY0HErRJSnWNSI4LQKoJm2MGn2GcaiKIfOSzpG?=
 =?us-ascii?Q?0e+2Hp71vl68H1n9Xibx9g/Pp15//b78cA9hHAsAzuBSELRdd82qyI62ekoE?=
 =?us-ascii?Q?1YPcapC32B7QNN/g//s20WG3zgeHYNHPIt3vKs4dWCHut2oE1JztxXeWtLWg?=
 =?us-ascii?Q?eHeU9iSWETufP0xn4bwhXGln7oLsUA17twdNp5MEj8R3XU2VFsY6r3KVo+ON?=
 =?us-ascii?Q?ey39vCRMwV/dEEPupA6EArxKoEW2y5v1bbAhM3UTxPw8EXpmOVESaEYDO72d?=
 =?us-ascii?Q?KU/+YsQQQriaTWIxcMvhaCSSI8PhARPZK7NuSTwx+YBvseFeETx0wdoW7Sbn?=
 =?us-ascii?Q?OWsSuxad8mVUKIQ4ecV7te4GckZs2ErHLRBhMSKoLcLY2phvPDtgtzIf4q8n?=
 =?us-ascii?Q?qph0NpKY8WAFjNR8cqasvgdlEdnMY6w8VAzn6mOCXvRDtyVqHYvI1POxUWaF?=
 =?us-ascii?Q?dOMwj3bmXOHs04gufCpoGJOjthYutuWE6/Q+c8/HcIH9rEHFu6tNSBaQaFN0?=
 =?us-ascii?Q?q9aMSB4D0LHE6807vJkm+EGMvUXV72BzWbYkIjpGR7xgk8OvQT/QvGON4sQB?=
 =?us-ascii?Q?/oPaOdGKcYoI+uLTW7StVb6u/EjW4gTNzzwu5Y9UYsbIVjmK87FjwOgd28pY?=
 =?us-ascii?Q?PZQ3Q3F7eI2tFoarzcoqwf5QDWROn/5qhGZ8PpxPXPIc+vGadATR9UAQS2HE?=
 =?us-ascii?Q?626KONK4xCNh7FsQ+m4xKOJkFh2cNmxUi3VW7s6Xn8uraatFV8dCVE+SpzeN?=
 =?us-ascii?Q?4SorTrdYKQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df9cc82-4865-47e8-6a18-08da199dcbfd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:24:35.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWaf7WGcFimP9KGAJcltgh5RanH07JsD5juCmLzCtWxqv7o2yf1auMkwv7gMYzFZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4849
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 10:07:50AM -0600, Alex Williamson wrote:
> On Fri, 8 Apr 2022 10:59:22 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
> > On Fri, Apr 08, 2022 at 05:37:16PM +0200, Joerg Roedel wrote:
> > > On Fri, Apr 08, 2022 at 11:17:47AM -0300, Jason Gunthorpe wrote:  
> > > > You might consider using a linear tree instead of the topic branches,
> > > > topics are tricky and I'm not sure it helps a small subsystem so much.
> > > > Conflicts between topics are a PITA for everyone, and it makes
> > > > handling conflicts with rc much harder than it needs to be.  
> > > 
> > > I like the concept of a branch per driver, because with that I can just
> > > exclude that branch from my next-merge when there are issues with it.
> > > Conflicts between branches happen too, but they are quite manageable
> > > when the branches have the same base.  
> > 
> > FWIW, I use the same topic branch approach for PCI.  I like the
> > ability to squash in fixes or drop things without having to clutter
> > the history with trivial commits and reverts.  I haven't found
> > conflicts to be a problem.
> 
> Same.  I think I've generally modeled my branch handling after Bjorn
> and Joerg, I don't always use topic branches, but will for larger
> contributions and I don't generally find conflicts to be a problem.
> I'm always open to adopting best practices though.  Thanks,

I don't know about best practices, but I see most maintainers fall
somewhere on a continuum between how Andrew Morton works and how David
Miller/Linus work.

Andrew's model is to try and send patches that are perfect and he
manipulates his queue continually. It is never quite clear what will
get merged until Linus actually merges it.

The David/Linus model is that git is immutable and they only move
forward. Never rebase, never manipulate an applied patch.

Andrew has significantly reigned in how much he manipulates his queue
- mostly due to pressure from Linus. Some of the remarks on this topic
over the last year are pretty informative. So I would say changing
patches once applied, or any rebasing, is now being seen as not best
practice. (Indeed if Linus catches it and a mistake was made you are
likely to get a sharp email)

Why I made the note, is that at least in my flow, I would not trade
two weeks of accepting patches for topics. I'll probably have 20-30
patches merged already before rc3 comes out. I never have problems
merging rc's because when a rc conflicts with the next I have only one
branch and can just merge the rc and resolve the conflict, or merge
the rc before applying a patch that would create a conflict in the
first place. Linus has given some guidance on when/how he prefers to
see those merges done.

Though I tend to advocate for a philosophy more like DaveM that the
maintainer role is to hurry up and accept good patches - to emphasize
flow as a way to build involvement and community.

That is not necessarily an entirely appropriate approach in some of
the more critical subsystems like mm/pci - if they are broken in a way
that impacts a large number of people at rc1 then it can cause a lot
of impact. For instance our QA team is always paniced if rc1 doesn't
work on our test environments.

Cheers,
Jason
