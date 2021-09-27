Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB641987A
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhI0QII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:08:08 -0400
Received: from mail-bn1nam07on2049.outbound.protection.outlook.com ([40.107.212.49]:35654
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235261AbhI0QIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:08:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mhmtlzk7SUnCxPezt6A5tZpfo/+QYvW96WzXWh+r4OsUVNK+9ha3g191aAUEjxKqWjzdbqzrXBnvH35mjlMxYXP5UENV0qf0dMt34ca2gYRXJ8i5QAjx3VZhX1cZugv7Ywkm7FMNWW0LBgGGlLqD4ktNSpIS4gL/l5gruSOj2DVCsa4t/Ze6b7FfZrFCslX5y2Dmx5OV0hkmqp1RUsTqvSyCmIiZ9+4+iiTK5pDIH636p7ccBh3YAeHnARQGcVL1+T+z9pWDFNvjjh2XzV006rVwwI0BbuJGINNkNAZ/sulTeRuG5uCW1Hl/irCKr1sj+fZmSTkOtdispVbH/90fCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EwFszWjD3pr9nnHCtHzzznJtJ7AWQfzFznYTHrTRiOs=;
 b=k1myYQRaZGOrDWlHrPjAzuwQXi/OW3nWLzvhzMzcdVMY1kGGiLM9ybK3jZngntr3tv6t/7KmcKnqVu95+cIbdDgNTA7Wk/7QSTKM8S65zr1c0oiRQ23Qdk2I6MCIwddtNGgRjyTfjNs8XkY2irOPVFAUa9+Sb2G8dHIn6wHFaCs7pyy4f2lKPIxX64Ys7YgD+OouM2YqMqjLfeI7mRqVZ3Gn65EDOqOkb8JUbWVpDUGCHCZNWmBHgDLYnOiDLPgdWyi/kkhhgsSwLGr71mWW8BVLccwv9NDDKSI2wxuGfERdryJwH5h5/kmlldBZ7bvmikk5w8vdTHhf8b0gPLd9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwFszWjD3pr9nnHCtHzzznJtJ7AWQfzFznYTHrTRiOs=;
 b=WhITwuFR/mvoX5lnFBNH/dUViNgJ1jiSqxO0OdtEFzWEa8CXmKVod00hKTjl7YuFYiTkri/lnLMLI05+HTmm2IeFJTKDpFYnLams2q6eCV1SvmHg4MpkmyiLr58zgl8s7JPa5OIbkhKlGlARKLF/Knwl05NioVxKAoH7PoHBxYUCeTmHfO3f3syaqfuR3Klc5o1nvuUvvXdc9PnU5TOGE4N5yzYFqBO/O/Z7jsumaXg/yhRd+dJerfJNTRKtMhmFMasaL0kfA66hEd1y71RvGtUDrIJ+kLgDENEMqAv0NCMDLR5fLlfO68Mi7kQgEBQsgjxZmyrE8vtdxZWR51KbFA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 16:06:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 16:06:28 +0000
Date:   Mon, 27 Sep 2021 13:06:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20210927160627.GC964074@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
 <YVHqlzyIX3099Gtz@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVHqlzyIX3099Gtz@unreal>
X-ClientProxiedBy: BL0PR01CA0023.prod.exchangelabs.com (2603:10b6:208:71::36)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR01CA0023.prod.exchangelabs.com (2603:10b6:208:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 16:06:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUt99-006Ozw-2x; Mon, 27 Sep 2021 13:06:27 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eacff957-0cac-4240-9c82-08d981d0c361
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51112BE4568E9D75ECCF4F24C2A79@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQ+LNTJ9HVpekh7AyJSI0UpvhwKVZNSoMGwMIfffl+tc/aiBfJWaTHv/NV+CdoSuWnJCBgHDuSSo9ajtjVjI8Z286gUjJC4+0wg8Kl6NPI8pyxuevvRCgkp7sXEz0MuMei/pMX091AzeCSIuCAbK7mV/M8O/Qmn6qmMnIZprXA4n/GRSK4AGfO5KGixALaWwwqN/ZGDGtk7nG9YyZZwEtRnflw1sELYom/hxwsRVPHUZf5hTJYTi1B0gYL6YHQ87ukrANyEBIrJx6RMtfP5oEqWTAPxOOmj+uqtRJgIgE8dFhwAQQt2RKlFg7HOOh3SRohA9JmBhfE+YBYtbnJR6wenpVncgT9716junjSA6EYfdS4XyG1g2N8rXkT4hMEsficc3ivxMV9yFB7gBFyBZZKcu3mZC5KM5R7y0EgkKhCtRSDQQUxm2QnBKOkvWUSpBuf2d+RUo6C1UlkeyrBr1mz/1VJ+6+VcdQ9YEUlYYdO3pJyPX42r7EJq7m4FNII6JX642wACiA8LlFPGchTfnYRRDkkAfr43e6RgOiT5oprqkTei7wlCFgvCQsT+bgr48r6v+d3YjW8HBD0HaL4efOF6Wi2NFStSMLwlD8/Ww/6nCM9WTVZ0ghJYn/CACocAWJTaQOMALl2y1KAnHYyclb9VdKQ6sGTT29cy5GDeLX84guaMasf2bsCfNoU/i7iOq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(37006003)(33656002)(6862004)(66476007)(8676002)(9786002)(426003)(2906002)(9746002)(316002)(66556008)(86362001)(2616005)(83380400001)(38100700002)(36756003)(4326008)(26005)(508600001)(54906003)(6636002)(66946007)(186003)(1076003)(8936002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sGOc7ydlgaqsIft1gPvRPkrFkXSzu0SW7RGWXwWIlZvbYqAWv5qdlNWPnuTs?=
 =?us-ascii?Q?GtBwkwKnnkPA+4Jhb0Y1JpiOJgBVbYr4wUv0SKbC4asUvIjDcvedQaA0S0a/?=
 =?us-ascii?Q?VzaA26cqv++4T8okMx62d3iLR6rGfofIR4/wET082BLKnOR59fffnRRsWjuL?=
 =?us-ascii?Q?joRnPWUOKj0DDT/VKGOXX8v3OMKf9UTwFVzr4IxR4jORrSzZcf4OefdeEYaU?=
 =?us-ascii?Q?0Ko0WOD9G5Qc33S0M1wvM96WYzPqJ5BExqwPFSzq3PqzlLnPkAa+5qyijXdT?=
 =?us-ascii?Q?zSx/6qNi+5UGAC42Y8Ovw13L/et8hRQr4YYsReWMCRkPOQVdeE17tVJXMp/4?=
 =?us-ascii?Q?Xksv14F0pAxBQDOvZhMozkhr8rBZGlf8zAi8g9MQnIiWl/K/B5G9xX8mLomE?=
 =?us-ascii?Q?/jR4SeBrprbif77eGATXj4u0QLgaco4OlqiqdGzeSrnark8udsnqwrgpJuZ0?=
 =?us-ascii?Q?X1AaItrLl/7v5zARAGxl3Hj9UBTmxjFGUrbLuCEwAYlvOgU9LRVM9AEN72jS?=
 =?us-ascii?Q?FR7VIMBb1AoO7xDSMwAVlx5nU5tey9Evll/tqjQN+aefn2r9XMj/ZnlXwN1Q?=
 =?us-ascii?Q?0eH/zrGfM47wt1PTcz27bPyPwePb6fu0vnUHhE6Zkpme4RMq5aiojFiJPi5G?=
 =?us-ascii?Q?qhy+9wZNIxWMv3vPfkH608OwY/0eOe2AywqwRdmGPKIv0+AmuaGrwxvCOj1Q?=
 =?us-ascii?Q?NagCfWvEpaPxO4xOfVU9vSONXwuxf+2ULb1btmQajZ+TzryKKgt8H/0LQzcA?=
 =?us-ascii?Q?Mm0cfAGiRjdxIAO6mPyCb49BYkcAoLKDPkrm+oR6ieXrm6Z9xb0QRBhcR99n?=
 =?us-ascii?Q?Rw0UDDvQgvvSQbI7o8o9+ljPR6idbjYG+9aqOSJA9lRqLlDBNn8VrdnprR0V?=
 =?us-ascii?Q?EwVcvMcDW9qpnPux4Q0E67wPtr8ldcSGiezR1T3C4AifzbqW7Jaca4IyHcOD?=
 =?us-ascii?Q?W2+EisWfYBGtp1HDMiE56alt/gtEc8NfvbRBfLETvWN/rYArxK9J1+6QYrMK?=
 =?us-ascii?Q?L0TYflBZ6Rh7myoe69BC2XHKjvBNImB/DTW9+qwIXijW8QqqhDd5MMPUqj15?=
 =?us-ascii?Q?wm+XQKBlmxNxTZjmj+X7OZvr50K3bfEgNKoZczgzN/i9EguomtWi9DHHvkjX?=
 =?us-ascii?Q?YO4+XSyyc/JDQI8AbptRtVG9DWcb1p1RhZmFYVQcL2iLt/mts2KQnH4U65aH?=
 =?us-ascii?Q?rwhD33RZp4KDCtBTPQeW7KcTmmuA+dr7fosWtgs44Z7N9e9VNk4C+A4oPw9X?=
 =?us-ascii?Q?dNVUVyJHU/bD/Osk0S6wZz+IXDUI+BEh2d338o1Q8QBHP35ALtIYpkt5EOfX?=
 =?us-ascii?Q?YLlZSdmma5iDIpeyEfrpon3/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacff957-0cac-4240-9c82-08d981d0c361
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:06:28.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwuAab6Cplqi6v7PHyKCbSft3gALHrjQBRtgxXVbzDsD9P+7jnSCJpxL+7Xw8FpG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 07:00:23PM +0300, Leon Romanovsky wrote:
> On Mon, Sep 27, 2021 at 12:01:19PM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 27, 2021 at 01:46:31PM +0000, Shameerali Kolothum Thodi wrote:
> > 
> > > > > > Nope, this is locked wrong and has no lifetime management.
> > > > >
> > > > > Ok. Holding the device_lock() sufficient here?
> > > > 
> > > > You can't hold a hisi_qm pointer with some kind of lifecycle
> > > > management of that pointer. device_lock/etc is necessary to call
> > > > pci_get_drvdata()
> > > 
> > > Since this migration driver only supports VF devices and the PF
> > > driver will not be removed until all the VF devices gets removed,
> > > is the locking necessary here?
> > 
> > Oh.. That is really busted up. pci_sriov_disable() is called under the
> > device_lock(pf) and obtains the device_lock(vf).
> 
> Yes, indirectly, but yes.
> 
> > 
> > This means a VF driver can never use the device_lock(pf), otherwise it
> > can deadlock itself if PF removal triggers VF removal.
> 
> VF can use pci_dev_trylock() on PF to prevent PF removal.

no, no here, the device_lock is used in too many places for a trylock
to be appropriate

> > 
> > But you can't access these members without using the device_lock(), as
> > there really are no safety guarentees..
> > 
> > The mlx5 patches have this same sketchy problem.
> > 
> > We may need a new special function 'pci_get_sriov_pf_devdata()' that
> > confirms the vf/pf relationship and explicitly interlocks with the
> > pci_sriov_enable/disable instead of using device_lock()
> > 
> > Leon, what do you think?
> 
> I see pci_dev_lock() and similar functions, they are easier to
> understand that specific pci_get_sriov_pf_devdata().

That is just a wrapper for device_lock - it doesnt help anything

The point is to all out a different locking regime that relies on the
sriov enable/disable removing the VF struct devices

Jason
