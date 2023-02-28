Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB156A5985
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjB1MyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1MyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:54:02 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E61199CA;
        Tue, 28 Feb 2023 04:54:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeK9aCA2FnKoo+Yb5TPRlGdvFWvdUV+78NM/Az5K6kTRMsHw4HOzJ1YLb3HOv7Wh7eDsJNSKr1Gh5HMD03AuzEfYTq2z93NLqMqvVK2h777a8lFr9KtpIgGUBI5z4Wv7013qFsyyp22H0P+Hw1LVknL1xvCbJlqOuWckj6qwzMo3PSaEku7D+VQwfOA0F/ClhcwT+iIoHAErdFLreH7Dd24JBKN2q/1T1FY/WkogI6WHA7+7FH0mS1MKKlwS2MNZ9775tDVU4J7Ei3TuapXvyGsIkDtyoQYXgEcBnXxX5gsIviA8g5bWoop0zvkJR9qz6JSr0xsA7Gtm07geWYQGfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1f5U9cORps9v7ZYy/dHmLMGNa9BO0TLi9W3CbHCCmKw=;
 b=a3av5FuJSl2F78Pbl75YO+ViFN44l9dPMxl5gQ/KEHkc0mGr/h+jdCLq3WR5PDA/YrlwCI2Xs4J9iGVH1ctQ3YqWQd+4R2wUzH4cxLvUyVUCWwfVFtgRBzjYwU0OqG3N/dOHoxGwhMGwhTJ2MvYFW3rX43s0F/UvAZpdn032VcVSwyPeTW7nO0BzwCwLst4jQzDfoLOhAFOfOcd+TOUPwOhniTGs2oGFzxlagVx5CmCn9xAygVeg4ZEeFIOH0Vwpu+EzYOhmEwQjjSLuj03osOIG7coPl1PtpCfvsZIe6j1yfBP48vS8bhRBT1ZYJJwPXLdRz3ArmoKECYLJzUDSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f5U9cORps9v7ZYy/dHmLMGNa9BO0TLi9W3CbHCCmKw=;
 b=fUgVIo5ydlERdwq3o6HgeFYZTBmlaaCAkvbGPQ6+5YaG6Wc8YH2rSO+SKbfnwdZ9yHJELr219kFRS8jp5wAAZK1GCwvQuzXHdGV4wRYiwsqV7ynHhBUgZfV8MxGnCLVWSTmhstkc8/oWVDlMpjWMMmfH0aNVMfIGXShdIh509W0RBnGA4o6PMT56WIZ15vahOCH/w6YqoDbzOyK9xWsLJkP+D5TucMV+IjYw0U6GgC2P9HVzkd3bMJ/I7RJFB7ndq5QkhtAiVVMV24KJSARm31IJQvloPJwSr4oWGiWYc6SpyIsfhX7dE5dlvW9MTd30Adzcpx/y39nbqw/IyASzBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB5006.namprd12.prod.outlook.com (2603:10b6:5:1b8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:53:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:53:59 +0000
Date:   Tue, 28 Feb 2023 08:53:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Message-ID: <Y/35ZTi69p9cCuPn@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com>
 <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:208:237::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB5006:EE_
X-MS-Office365-Filtering-Correlation-Id: bb544be6-3682-42bc-21f8-08db198adbda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0SX2Jtw69gtA1MWe2JCMDdJhL+LTlt1AIDTQ7m0zKC6ly4LEVJ37I8gjh2eFbWHsJCXJdxB03hTz4qGn7bC6hwzfr/MP2mGWKoLHt9dBStcQmm84IOc2Tj4xeX9Bs8cnj+CebjtsnLA2UrDJ68DUL5ceMiAeO6na9tRbwq5ydXKHci5kdqIxLPQHAi9Iy36IKT8e39P3bVfQR8fCFBxzxi2G4gTGf6yrm3riHrLlCUFJC4+ogv43m3YnIH7FqvqSaGX/TQdnmCnbQJ7mEcVP5DU9mFugs1m/GdqpGZS0fIRPuFZTGvvHQmEjS6oDDUZtfhcK3lYUFxlHcOya54uGasikQ8SVnELHpYkulFiE228tsD1/Q1VXFMVy3gaYCyGFITglpf99f5WzrVcdUudYlfmcIZpFG9oA7RcLt1iRYOmbMAP1uDNNnBUU4wgDNLy/+xGet60XkRP8iKdMUDSWaRUgxDB7r8Da1GFwA5tnPecuXSpQsUVbHEqIgycjKc2PqIu9E2Yl7W4h5cm5w8S6Bl1/rqGEd861Oiq4pGIu2jMiTQK1q2w9Bq1OezVzcL/8C3Isq2Vd9uqIpIyrmmmuSEptDikue2fThTftMu27yBPZupRUybhh8WfFUnv8D1h7iZwOxZcoARYMUlpynZmMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(36756003)(8676002)(4326008)(41300700001)(86362001)(66476007)(66946007)(66556008)(5660300002)(7416002)(6916009)(8936002)(2906002)(38100700002)(6486002)(478600001)(54906003)(316002)(26005)(2616005)(186003)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9nUmuQwlX2ShC6ZGj7Vw/7cKzWaob/NHgp0TpdodJnJEFnTKFlt0x85s3xV0?=
 =?us-ascii?Q?7ZdK5/jHM3hGk8Lus3NwEzKULNWIlaczCt2PxQtdcgYSb2gJrRZO5dpFpUxK?=
 =?us-ascii?Q?QSnwi1d/Nl5VV1DbQjmwTHPjksNHD266TbGl8PmYS5A1M573VzfB+rdMPt7f?=
 =?us-ascii?Q?f/l0eJegmdwY/sjkT3OlSyF5EKyG1pDdSkUDR5ughDElYs39XGV0Xe2B2SEf?=
 =?us-ascii?Q?s1Xh+NvXk6TwzElHQCGN7bDFnlHJz8Eor2OTia/XYsUrpwvHtde1Rl8/tG8S?=
 =?us-ascii?Q?fZtOCsw/oDfffvv11Lx+7bipECBmXisjMa0YSqNpDmBsZdNtf01zyRMu7ps8?=
 =?us-ascii?Q?a1GD5jLZBjOA9Kzdk7zFAltTS+ejrhW4HVdxMwjUKLBjHoGPM3bDnLb4OWAz?=
 =?us-ascii?Q?4YshGRamLf0Z8dYU4MpT+cPXbeDjb0OIWxGDxJZSKkWZ3PkXk4nIpES66bpl?=
 =?us-ascii?Q?RleTZhaN3LBTYI/yR32XZ1JE5fVvlc2G/QUSoRS3V++pD26o895k9NF9QY51?=
 =?us-ascii?Q?QrswyzfC+dGVetC4V+29BlgayWUAPsRIWaPJOcjbHS6R27l/TKBLevshRrki?=
 =?us-ascii?Q?0XSnIG2lhvV/QjKLsTqJSEHP7JOP7qMpFVSvFQSBoeT60UJwGYDjq1xHa0qm?=
 =?us-ascii?Q?jb0d+dASLreXPwKgiM5onDBSG3HL5C9D+Q/o0rW3UvLERZVfG2ytW9x/OFHO?=
 =?us-ascii?Q?N08YDJuR+4GAff8/opPPdyy54zqfLuMC8WCOVwnAyl+w2cn7uEvzffnb+PUu?=
 =?us-ascii?Q?5kzOV4Xl9gdNEbof8U3x/NEQzqy9sTe0b8NLdekWOH4C29Dz5ZzkY/+9joWe?=
 =?us-ascii?Q?NIy69XcuwFJAljDKqQk20TetH4DiGl5CjSY6uCtwBNPdS2xeI/L5FpjHhZHk?=
 =?us-ascii?Q?QalShBllOozuAjgJVvajMn+nbaMogNHRyZT8QNldulRnbNeKCjKX+zUKw7g1?=
 =?us-ascii?Q?3aL6AEKmy+oXkty1MYb4ZAeFCgzX1ZiNvB4ecw1y2TjWMdhzSTSYdmPIQ3je?=
 =?us-ascii?Q?FWxSFiSD7AtsBYGbLlZOpm8JLeCl9rgbbsNPor0TNoIJh4T0mjoV9Yh8KqeO?=
 =?us-ascii?Q?GlxtgeCmtTrv84/qPRgWx23mDJcQp9v61s5uvQ1jpy7+glUEJmL0I3aouozR?=
 =?us-ascii?Q?Ti8QwK1IZInkytIGaIIikF3xoF04CHxeF0hFjaKXuap6gDSb9OL7zwMxvtIs?=
 =?us-ascii?Q?TGDt62wQAZAXjZS0ohyMjNYAN22WlOC+qit9eqSdK8avytjnLtU0qwKLqs5z?=
 =?us-ascii?Q?3mxjzSLCyZ54DPbLBMfDQFi+0lyhKKR9NYTyia33gcktJ0nIWEQLvI9F/Fae?=
 =?us-ascii?Q?QQ0pGOWUWJeBjTDO1p8x1HGAh5Jwk81Ec9u5YpaXP8aO9ea/+o+oo6ifCsom?=
 =?us-ascii?Q?Yaxk14PCO5JBWR5zisxY3lVECNDlfv3q8YhJhjjkKpZRwI378KdjDJkYcUGt?=
 =?us-ascii?Q?9t78Za5SET0a24FomReYPPZDFWx7LMvAUiAwduVZNrSrVN9BP0YJ7o/Qg4um?=
 =?us-ascii?Q?NQGwDTAPND48zDIJzr1BkehRa041r3LaX64YbfFFrZbHKDzRLj6DoQzO6TiG?=
 =?us-ascii?Q?3y5/RBt8IWMolJTDDNEK7LV++2lGXNNTztIag9Zi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb544be6-3682-42bc-21f8-08db198adbda
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:53:59.0087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpiNHOPhv2BYShclfAnxrZ70dCMUfPly34dbitgIv/9Zhsbi23lmXV+lacUngpeN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5006
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 12:42:31PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 8:32 PM
> > 
> > On Tue, Feb 28, 2023 at 02:51:28AM +0000, Liu, Yi L wrote:
> > > > This seems strange. no iommu mode should have a NULL dev-
> > >iommufctx.
> > > > Why do we have a df->noiommu at all?
> > >
> > > This is due to the vfio_device_first_open(). Detail as below comment (part
> > of
> > > patch 0016).
> > >
> > > +	/*
> > > +	 * For group/container path, iommufd pointer is NULL when comes
> > > +	 * into this helper. Its noiommu support is handled by
> > > +	 * vfio_device_group_use_iommu()
> > > +	 *
> > > +	 * For iommufd compat mode, iommufd pointer here is a valid value.
> > > +	 * Its noiommu support is in vfio_iommufd_bind().
> > > +	 *
> > > +	 * For device cdev path, iommufd pointer here is a valid value for
> > > +	 * normal cases, but it is NULL if it's noiommu. Check df->noiommu
> > > +	 * to differentiate cdev noiommu from the group/container path
> > which
> > > +	 * also passes NULL iommufd pointer in. If set then do nothing.
> > > +	 */
> > 
> > If the group is in iommufd mode then it should set this pointer too.
> 
> Yes, but the key point is that both the group in legacy mode and the
> cdev path sets iommufd==NULL. And the handling for the two should
> be different. So needs this extra info to differentiate them in
> vfio_device_first_open().

Don't encode that in the iommufd pointer, it is confusing.

A null iommufd pointer and a bound df flag is sufficient to see that
it is compat mode.

Jason
