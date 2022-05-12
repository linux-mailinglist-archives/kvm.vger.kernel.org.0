Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C8152585F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359529AbiELXgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359530AbiELXgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:36:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD641FCED
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4W+/9SLEvAec59RKH9dHJr6um7tnX9bJDTONJgGdWXNPyJbXx/Ijc6kAQ0om6ZRThFthnMGLvZ2ENvk0HzcmC6NUqpgQ9NM3inocNqH+bb6S93YpjfJ7lQGPjgtz27/om+a1yHv5nueOLKrFY5FK5dENH9paz9h30mV1/ywmCIJ9KTowcPozR8rqGVVYIjYvvF6Jh2SfbhcgwVeG+LT9AUPcFM8AfiOm1n3SGYz8GuPv77LC5rnPwsr6WMgBfFmVb+xzwg5ayzzli9iSGdiZcXpnVpgjhxzKukLiScaudb2TGS2qJlMcWdt+P0APeyV11sPwzQeESvPW06zHczDjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RZl+z0FC5pDrbNEzJUtj4NYwHBtPl/NxKbQhHs+mUQ=;
 b=HIeV8ipD73yxZzcDjgUgkjrLWfe3vxmG9AzIjLPzq+Se4ThTM6vhIrkGb8r25kV1HCpgr8baKYRjshBMkgXM4vMJTUtY6mXVxHI4LCymBM1cKF0p0CNqjTdhND2X6IAD+dFcK2km5xMldeaBmRglRLPz2tMt38ZuT2syGFj/n5e/DKxZ2BXo+gYQJvdK7MIuEEDMLi/wNT626HR8Cb8itjlQe8fzMuUzMZIg8TWteypFq1L9gppsNkih/2GDeHfcmjHzF8omBA28QevQYVgiF1jeA+4MRfbY7JqyYv5ziYbl7ajTig+M7V1N0iFIRnswQyol2R4LPYiBXQO14YurWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RZl+z0FC5pDrbNEzJUtj4NYwHBtPl/NxKbQhHs+mUQ=;
 b=r/EeaSAg7adGQvShxPOIsI+daFJdGKx0GrvHOBsHog5q4yrq37GPThfc/REC+PSEt+uqr8gDmSDMsqVXYKDQO60+yUFydxIEQYOu0q1Gxt5IrQRppbwX07rYDdNHnwiKlremLYp6ow2s6jCtCiu7mJtFervoA56n3icE7lh7vZpSLCRJXPE9hKn2QkqDHjDZ2mexEqlvqnWQ1Ficpjdp8etTWEns/yFJRq7DlSa5GUrHTTxLo7EWsUEgYF+qfwQvidUTFfZXlf/WEV4w/UUK8Vab3e7s8BCPh1J4CjHHTzWsFXXfX7XPhcAgUqIzuSa82ABaDyQv1F20O/lbvPsuNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB2549.namprd12.prod.outlook.com (2603:10b6:903:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 23:36:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 23:36:00 +0000
Date:   Thu, 12 May 2022 20:35:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] vfio: Simplify the life cycle of the group FD
Message-ID: <20220512233559.GI1343366@nvidia.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <5-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <20220510135959.20266cfd.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510135959.20266cfd.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0112.namprd02.prod.outlook.com
 (2603:10b6:208:35::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f076809-620d-452f-c2bb-08da34702bfa
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2549:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB254935D482B48E1269374E98C2CB9@CY4PR1201MB2549.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SrupbRDUn6NJG2W5hrGNd4qVPDLb0Unt0os9acK64ZtwRWhrFX3pDMsle6HxzFhWXl0AKfJx2IfmoCTc5UpXid4sZBGe7daeSpc8d+lx6sQxvPrBwETw9r5SW3QrFK9dA80C7iKiDp/mrGVdYARDfR/jKVrom3zTZr8GMB/HxaPushKElvnbAyz1UlvQjYYCWEaezJdk1hhzONVveHgN8KOxb0YMEXevrYFcfjxcnoUm36x+kXAa/cJzlAjrLV7PD0ath+apyczyMhxAssfnVyQcwjU+mPKbjUgS/pSzCVBJDa9EjbBiaNqliCSJjTDO706+APMeCYI+JYKPbe2QrEnXjOsQ69guEsw+jBKVZQEPw6Y8mgLcWpNoiR3r2QVIjADJYrMNoVOJwcPNzSppsLKiU7eoaI01ArKC0RdmKsEpYCMqvBJBn7keIccHqF8XtdA4n9N/AgzH7n7Wmj73ETC2J0Oj9/tIOLGeVIIEC910fOL+8OOTo80pmbl1l9XiQWGlDqAj82jH/1l9PN2o2KfyCfjv31dfym3WcqzArD+JQCyf4h0Q0gfaGe3/LT2Na1DoPrsWsvDWwUA08dfrD0dgyDeiygQqqz7kA34SfVnLGMAqLnULfx1jde0BzCWQZkK2PXsOZSdcI4xz7t+2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(66476007)(26005)(66556008)(316002)(66946007)(8676002)(5660300002)(8936002)(2906002)(4326008)(38100700002)(1076003)(2616005)(86362001)(186003)(6506007)(83380400001)(54906003)(6916009)(508600001)(36756003)(33656002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tz+efI3nO3gMKy4cP8uhCR8J8r0BvNMPscH6YpvdogsBnxyzvHgPFJMNKgEt?=
 =?us-ascii?Q?oIEyidXgJNM+zp8HOQWM3f0jEtzcpbI9HGDvp6FdhEu/Ee04r0+OV3Eom3Xo?=
 =?us-ascii?Q?mACbD9dWSOYJ3LAWt6KryvHHqGcWLZKsiRFVwRXuvQH8rys0068g55kZ2lU/?=
 =?us-ascii?Q?SA5yltfkhA7cqNlXeOxaeH7nTXygC6EvA6FStX+d9we87h/PaLEYBQlU2R1x?=
 =?us-ascii?Q?OQ/HfWFycf9QVKnL6lRmLU2NuTFm/BOT3FW87miG9kn2xoQHgHeeViqfJkl9?=
 =?us-ascii?Q?//tWk6Q+kVs+EGPIv7UWHDySnoQynRQCdOQsuULYy0V5HZYTI2YkpMuCRKRi?=
 =?us-ascii?Q?Spq9e01Ep6xSaZ96LuK9+kKlhIOoffowuJVGXKFuDM7us3x8eHRW5L/lUJVy?=
 =?us-ascii?Q?3itGECqZ9ZLYQym5s3t5zXXtCpswPBgXUXlPaFq0INRBR5rFMvgCpodCghyY?=
 =?us-ascii?Q?cCBDpnwYuoiqxhKKmlYnsuPtrjTzGB7jRXACvWcBxDbrpR/l+sdvrBzk9tOp?=
 =?us-ascii?Q?kF0OeoYGXuXDNN1B86AQXEBFXwDSLX474kIutuOHAIEjIAjwmSrX1xB0dS+Z?=
 =?us-ascii?Q?WGWhrZY01JfsJRJ/XPEN3qSKqQ1xY1UHHTPO9xN+UoGOE4t/U9UIP2FyNawM?=
 =?us-ascii?Q?fenWfyckIkkJJtJqIRJfzjPs6xmF8Z0XIQ97RmUmBQAFRpfw/3vghN0ESE01?=
 =?us-ascii?Q?q9eYSM7CBQ8f4l9lXMvNZPKOIW9zyrwsoF3MiNwPUHcbiK7puRY/7bUz+f9R?=
 =?us-ascii?Q?DDzHt1b3W6iJjW+7JmkRY7tq1FQg/oBo16/XYCHUhwjW/tcteJDsx7EMX2z9?=
 =?us-ascii?Q?GePC0w6LFB66TDbgdFjrbRyamHqub8f5QTF+gPEG9zqBPH6C/ZTyr7xAA7k9?=
 =?us-ascii?Q?ykXE4NJT2e7h1NzAaMBAR7GZT8jau1WidsTb+lp5qiqgTHdkAGp2uxk420AE?=
 =?us-ascii?Q?ey1fJkifnH6NLmBKALvQ8K2uy8rS3fMK4jzktEJn4ACPSk954hGbXOPe1lej?=
 =?us-ascii?Q?m5WBwJQKhlk/+FiY7BYuvB4wsHo0utGmseDQ+b/pRMXLZdiNnYJVXFqwvzkM?=
 =?us-ascii?Q?bdVGUnC4NphDI+uKawCR60Zg16kJHPMd/luyncCXC5WnoDpqdiOTkZLWyfEe?=
 =?us-ascii?Q?n/7QewhYT38Y3e971X4YtCX8D6AcO1yt82lbIPuPWoJNxCxDU0hjzG+K3NK9?=
 =?us-ascii?Q?D9tdJ/GaiADak5TbuRA98crrDolk3cBWz3MG3PdMD81OqdkkJ4iBYKObUqlD?=
 =?us-ascii?Q?I/JbHskbboHirdqHYavUcXmOrDQLmBmkjGhzDzWLCzZX7cygX/jN+z7+RJHx?=
 =?us-ascii?Q?rEaNU2wwdzrUuUa/+BI43v+5GWzv28M1L2ADLx5lwNX4Xh9gjisddZT7adld?=
 =?us-ascii?Q?HNQvsVJv/QKje+eVNxNkUJSIdDOrmcp1gqi2L/0RxEKYWNJn/fDM4QWCmp2d?=
 =?us-ascii?Q?hqOkjJDxQjjxZ7wfUwzCzxS8qnr6aZ8i1evCwParwDdLnQw/R4D2dM6NWCwm?=
 =?us-ascii?Q?UhxRyHjKmz5uzC/7BJ95z3ep0W6pEiBjOuiYBTDz+Cnqlk7GBJKwKQIlKAPI?=
 =?us-ascii?Q?A0Uu50ldU4Qi0vSo8OhJTHQ0jK58OvY2KW1dVvSJhynELcj9NaugvbKTxDlP?=
 =?us-ascii?Q?VB5mXafgvGy7sp6q2D0xruowMpBVvEMMGWTGIeoZmYewua0+cXGJfYIKfxuA?=
 =?us-ascii?Q?FHl2t6caDRJhN3t0y1hy5Y2veJYzNl91+aYWSyzTeF8sevQFrUvN1qB+VRYN?=
 =?us-ascii?Q?JEoHWMXEVQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f076809-620d-452f-c2bb-08da34702bfa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 23:36:00.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vby5FWEIFvlpGyAxauAM8j6FiJkxEyzHzn3Roaq2/WXzXdWWgKbbaa6zt1S9pMY1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2549
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 01:59:59PM -0600, Alex Williamson wrote:
> On Thu,  5 May 2022 21:25:05 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Once userspace opens a group FD it is prevented from opening another
> > instance of that same group FD until all the prior group FDs and users of
> > the container are done.
> > 
> > The first is done trivially by checking the group->owned during group FD
> > open.
> > 
> > However, things get a little weird if userspace creates a device FD and
> > then closes the group FD. The group FD still cannot be re-opened, but this
> > time it is because the group->container is still set and container_users
> > is elevated by the device FD.
> > 
> > Due to this mismatched lifecycle we have the
> > vfio_group_try_dissolve_container() which tries to auto-free a container
> > after the group FD is closed but the device FD remains open.
> > 
> > Instead have the device FD hold onto a reference to the single group
> > FD. This directly prevents vfio_group_fops_release() from being called
> > when any device FD exists and makes the lifecycle model more
> > understandable.
> > 
> > vfio_group_try_dissolve_container() is removed as the only place a
> > container is auto-deleted is during vfio_group_fops_release(). At this
> > point the container_users is either 1 or 0 since all device FDs must be
> > closed.
> > 
> > Change group->owner to group->singleton_filep which points to the single
> > struct file * that is open for the group. If the group->singleton_filep is
> > NULL then group->container == NULL.
> > 
> > If all device FDs have closed then the group's notifier list must be
> > empty.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 49 +++++++++++++++++++--------------------------
> >  1 file changed, 21 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 63f7fa872eae60..94ab415190011d 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -73,12 +73,12 @@ struct vfio_group {
> >  	struct mutex			device_lock;
> >  	struct list_head		vfio_next;
> >  	struct list_head		container_next;
> > -	bool				opened;
> >  	wait_queue_head_t		container_q;
> >  	enum vfio_group_type		type;
> >  	unsigned int			dev_counter;
> >  	struct rw_semaphore		group_rwsem;
> >  	struct kvm			*kvm;
> > +	struct file			*singleton_file;
> 
> I'm not really a fan of this name, if we have a single struct file
> pointer on the group, it's necessarily singleton.  Maybe just
> "opened_file"?

Sure

> > @@ -1315,10 +1304,14 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
> >  
> >  	filep->private_data = NULL;
> >  
> > -	vfio_group_try_dissolve_container(group);
> > -
> >  	down_write(&group->group_rwsem);
> > -	group->opened = false;
> > +	/* All device FDs must be released before the group fd releases. */
> 
> This sounds more like a user directive as it's phrased, maybe something
> like:
> 
> 	/*
> 	 * Device FDs hold a group file reference, therefore the group
> 	 * release is only called when there are no open devices.
> 	 */

OK

What do you want to do with this series?

As-posted it requires the iommu series, and Joerg has vanished again
so I don't know what will happen there.

However, it doesn't require it, there are just some textual conflicts.

It does need the KVM series though, which I expect we will just go
ahead with unacked. Oh well.

Do you want to still try to get it in, or just give up for this cycle?
If yes, which base should I use :)

Thanks,
Jason
