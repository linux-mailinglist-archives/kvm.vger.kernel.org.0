Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4578D69F505
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 14:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjBVNAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 08:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjBVNAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 08:00:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D662B63B;
        Wed, 22 Feb 2023 04:59:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnKjAAxrPUJby7ZmS2m53v8RH+FesPX3GXQEaovUGpakuf0Git//ge+kxEZnKcpWJ/7mZCOwZD37MvvAgGq4yoSXOKhdbhjodjNP2IVDVwefqtgdZ2+YemtXkDMjHU/+YkRRu8zvWZgu8LdoRwq2tfZ/uzF3k23pECABhzC4V4vFr9o+nZqnbBjBF+SB4r1vkjNWiC45C4Ovq0gGciHFgh3F3TcqkyNoXHDwLBKqK/QUmSjhE/fZwpQhWCPmmwrVDfANvJfSd8tKcN4k6zXDcnN/1gAuKrQt7QjdUZN/Lvv2gIvAc0gDfJ+IfIvyoQs7C8kTL56b3I3UqbFaEB22sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGOrDpNdVJ0TQTv9bvuqo5HLqqrIZo4p2CzuyxqgnQ0=;
 b=cQ1r+K/G37OWzDEqwS38Nsmdu/LyGk0JGwxxBMxr9hVjlxBeQKSMq/qyEL5OhmCQI13vSlSBGpvAeYTQlMChab3y8+146zpEnjUMFpZFVfA5hVCNrwwX0NrQZ+ihCHAVEnGAP6Pq0qnA5cGOoGv8QVjMb6gJNr4pqfJxo27uDl1NVt66sswXLbd+FY8FG2RmDqi7u7oB+IMdKj1+wCEIlJWFlYEtSHUOF5ova+BDAkUwbDfluRlq4Gqgy37/O2Cl4zwGPlwME7lgKI9IOaEqtMF1KX2L7NTm06mIVo1s3C697pRxWTrMbYfsmCBfODdnx2pCr5AGS3L2+pAod5hjHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGOrDpNdVJ0TQTv9bvuqo5HLqqrIZo4p2CzuyxqgnQ0=;
 b=ExAsA7Z/05OYX2CKoHHpafSYmrfhpSWhTX4PwLwGuFYeqvD8v85CmUYpruoJ0TKGbRpiUw1/9JgDWhmH4RfW6DreKBJpS6Ay0nGgFUnde/94WJGltooE+bupH8F2dHRj6Eyu2SMTixbbfgQTQGFkKidwU5erzkPcac470MJDqgomufWYTsTbkly3ypnRXrU/4h1n1TnBf90nd5CjM3VKM5tOOXppDIIkExeOtbfauyVmFEjWBQImPAfH80vh/pohB/5x5iQRpOnF3Wx30EzMmua+cqiX/w7RUHbKZCTtMovB+2OKMwEaR+U6XGm22dxXE2K8mjke9IP6iPNO5ZwZhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4566.namprd12.prod.outlook.com (2603:10b6:208:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 12:59:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 12:59:53 +0000
Date:   Wed, 22 Feb 2023 08:59:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <Y/YRx7jLuyEoLxZg@nvidia.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:208:329::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4566:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b44785-7fe1-4b35-5edd-08db14d4b05e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qxqf6rf5nCwpunUGHKHonpnEzBTyBuwjU8VucjcLETV4qvdYPAVG/PWbXwAIYkpXqtS/pIW9WBn5hhGG28y7FeAVlTO41QEfulEbGZt3GXQWWw2ZxFEPcJ+Q+CDoDC3Ah05PFv92zFFLmitt5Kwgn+1IRO+aan0W3rKpTDHd1xp+bKbwcFJAuRhtKajar5ARRWixBOhG0o/+FnBULdEL6+U3koPqAJjAhzU3563cYqFDXDH3ZS6AhJSLQewy2qsfLN//+MIykb6sk0dRWOf+8qs4OkanQamv4/SVnA5dH7vwx6QHyhkcy+mVMk3dI5bdvoCxEO2CnON1bCMkWFMUUY4+05n1SzR9Esnv+rNcYhciFrrTWGFoGwBHYi2MAv9kPrdTtEflT+XsKJEoLZpfAOcc65Hg28DrYqzV+FER88RZ29PeLjA+Dy6fYb+z3pQ6J71CEFJVTKxzQR0eT0n2K3+Qln7PV2PTRYVmvk7q+QWu2USsdNf+JBkx1YrcFXD9HXBY0Bc3beqjU/xSgwvTs//i2cuaoyVVYX3qzKFN+VoGcKnahNiRdn17M3UKN4RXGUfem9NuWMfOIwkTNwkh2gVL1nPlPQ2JJhyxLBI9NMVp36s/QB95+e1hQfcRiCHJTxL4HCXLXVLcho3Kj00Owg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(83380400001)(86362001)(2616005)(38100700002)(6512007)(54906003)(36756003)(316002)(26005)(186003)(6506007)(478600001)(6486002)(5660300002)(7416002)(4744005)(2906002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7T6HMW//BNEqmgqqazfCd1xXLilcq1ZxJIItEvk3i3ibqYzztHUW/v8ig/jT?=
 =?us-ascii?Q?4najaq8D0PMfTTW8fdrVrSMaajOqr8cz1xb1iCh420uVy0taizwzIlYQkq6U?=
 =?us-ascii?Q?6oVq3eK5gukrk6+B5wo65WyUrqUpX4cogbzMbYWYKvLAyhQmt4MMMHiW37/U?=
 =?us-ascii?Q?Io1zm74ZLt/qNeesyS77/SGp6d/+yeFXVeAjwFLXidRzfRvF5oOkgFx7e+EJ?=
 =?us-ascii?Q?XKJ4dTxCbll3ee8+nb9tuUHJJs8VP6BsPuKdipVKSxczWoAKsr/jpJrOnZgo?=
 =?us-ascii?Q?qfIwLSKFOGACVa5lqgDcn2M9UqKSIIg8+6yFynK3VEzBdr0d1e6CL2nRkKxg?=
 =?us-ascii?Q?XneYUQNJjkCV9RvMpJm2y9LFwuzUMH/L+zTTBGuiLvsE1QeoMCVITfA+pwZE?=
 =?us-ascii?Q?AoaB4vTFI0yfNgMdSb9Nm4rfZ26d1ZTeerHCAMAsYzYpYbb0v+jU+vsiX1Lx?=
 =?us-ascii?Q?mrCmS1yBM9qDDHMh+osubgXPVPuoBpmTu8pQDoqKeZ6B6sns1PxFpNRNsVHP?=
 =?us-ascii?Q?cveADoNJoTI0/Ihx/iIcxsGHoSYCixrNH6Dwk4vSRX7NDKwKWwL1zRDYc3R4?=
 =?us-ascii?Q?P52w5T/cmMbNuIaFhxhuTrPsfGOJonxYUXhp9gztcgHfnQ2Uz+6dxcsvq2sO?=
 =?us-ascii?Q?gFc99RiCcB3t+31P1XdwDGWBb3eg0avDbTLB8z5DTwtsdTsuKKt5ZWVWBHVV?=
 =?us-ascii?Q?0gH8cC5bYnjIw1vl9epd6tCqsZkED9OkTQzUraLPgNvVeYWlJDWpjIMeTlJb?=
 =?us-ascii?Q?xDRfY9saek6XaKs9cCyG/2m5gx3HZ8k7lAQy5d9Ie/x5dQzom6vTUpBmcgRj?=
 =?us-ascii?Q?OBCeW0BUhVfB+VVesMoZtTwcRt+4OdCnRRZC+uhlaBPgwyZlfJonuTrA4f0q?=
 =?us-ascii?Q?Qi6JtCccECtGOKcMmUT98qMFe0Tjm6Cc2XgLJLqGL5ZOs3w0aRrQzTBDhDAA?=
 =?us-ascii?Q?xxxJSSGRRmTexIiZOx9D6Qy+OzW59la5Rfe68hUE4Iam7ZSieXUZyYQ5rvH7?=
 =?us-ascii?Q?Gssp2H6vt4UkNaja2cvuhRCeF/HaYDslQWtoBRNKLYrVF7g7WCkjuAluTaz/?=
 =?us-ascii?Q?oNC/LxFiY2Cy73soSmqOpu2+40lxHojRHJ3/rO433OnF4hzfK99VX2KneBIn?=
 =?us-ascii?Q?NMsy7Onlbc/FVvTGpdYYYBLW82JyDEgOEVbLh2ShgBuWoRmGjv1bgaR8vuuJ?=
 =?us-ascii?Q?q4jh+pI9jkgQYuhqpSLuDmbfrr39gXPHM5G69NtSYIPiHzBHjpYlTB7J5uq6?=
 =?us-ascii?Q?wJ3V+ufvKIOlHmXmKN1ZHT/eA1OMzQiyb93h5duuv624RbqjJq4eg6FC5mWF?=
 =?us-ascii?Q?PyBQxrqs8mjAqYXyVdsfWuBOXBdgfQ9v5QOhF8dEbm34Ws4BQ1BIz42OdeJo?=
 =?us-ascii?Q?/WbgnzTW+mkjhQBn73f64ye/dwfCwGXSEqz6ElGpzfbZ98zXHRQJqZVy62vS?=
 =?us-ascii?Q?h0szdYzqKxKrSWmirPZC4pnHorm0NNvdRN1/Zyho4AgDVNApCI3gcJV9adFl?=
 =?us-ascii?Q?UB5yYXBDY1rNk4NQeHwMCIL94B/Na5SX+LvVW2dUwc8wBZo5e+MBzWsACT+2?=
 =?us-ascii?Q?3Tcv2k0rgAFHKqx6nDqHDjK274r5tDpmPSpF1H4U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b44785-7fe1-4b35-5edd-08db14d4b05e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 12:59:52.8903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icH6lJDEwD7jD7EWce6Fqbt9MeN7o6Sp7x/oaYKMKvZpGjMfYNX6xcEsFvX57rxC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4566
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 07:44:12AM +0000, Liu, Yi L wrote:
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Wednesday, February 22, 2023 3:40 PM
> > 
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Tuesday, February 21, 2023 11:48 AM
> > >
> > > +
> > > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > > +{
> > > +	struct vfio_device *device = df->device;
> > > +
> > > +	mutex_lock(&device->dev_set->lock);
> > > +	if (!smp_load_acquire(&df->access_granted)) {
> > 
> > there is no contention with another one changing this flag at this
> > point so directly accessing it is fine.
> 
> make sense. 

Have to use READ_ONCE though

Jason
