Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A852545DE83
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 17:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356507AbhKYQUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 11:20:02 -0500
Received: from mail-dm6nam08on2074.outbound.protection.outlook.com ([40.107.102.74]:43009
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241521AbhKYQSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 11:18:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4j3njhmigYqvWUS6ho6Z15Mr6dy0G62Wm2aEztnxN1hgl3StU8jakwfgLuscl2Yy058+wVYKcVvVFS5rbfbQq6QL5EPSflwpv//GZKcMsaGpxiXcwO50sKpgdZ5JPi6bWwp7NgVzqg+jDp1O5j92my+jDqV9cHdH6dDaLhggMtJzLU/ltD9wwuNLlVM7WRWw/eViZtF9u1pxBCFCmS+zb7YplmE2aEYTsxpxfYPM38PQA0ftyCHHlJJOgeBiC+a6iGOrU2jmRXktgIRIuZxV9bcbhWjGnVUUFDnwiRTAB5VdEujG/Xrb6upYtms9OBFwWNCn8ur5DcPYUGh7IzQiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKNThpPsSCa6XFv0pbDtYZJElIxBPxMkHtRiQMD8zAc=;
 b=Jd79OxpkLXPVLRDDL6XUskxX5ZEVGnIaJvtOarzuql1Rb+aS6/oi20Wl2d73d9dPWp6kSp4bU9cS0PXoYKeY/BP6CBIbn/5nfCg5LPvaDfhFAy7VWkRNhntspDmYzjUI+YHLJzTUWLA744ty5ciY8c8xs3jvobiqwV8khyqFe9/GUxIXyTZeekKCwyBvOuFR6BISMIj4dHl7S6butIn77F+bbrwdYOGTb8KiqSmD2sn1UllMbXD/sPxVnTwku0Xw6Vsu/5RZmGmxmBghRddIygqTxcFmV58b7w1aRL+CxADSu2ElHrKZURP7Ny2ybY6cvMqxSYQUgzKGG0eK6J/W0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKNThpPsSCa6XFv0pbDtYZJElIxBPxMkHtRiQMD8zAc=;
 b=iUGYzPMp1QvXHbVpd2/T+j+z0r0aa3tl6q0yrC5PsFUmSi1AgE9qJN5XneXke4nLOxxfq0uipRqGpbQTbGf/nBIud13fey9fDXcAhZ93jP71aI7nHfxz62izbKcNAN0SbnfzN9/G7WQ4MfkayYEBWe0xurygGNbsVLgLCECWoIQTBrzMSj8Tw9mN7IE/5XTKQBfh9paY8JQk8yz8MuCaK//lqjd5tUliC49fN+Uj4bS88DpHMDXFp3Xp70wt1sfuw7x8IyLLtCF0c+Bt2kVxjr1iZSS4fqDIuiOUT3FAxVgioT+/2030K3QftESqgsVeyLyDCzpTAAslMygHF6sZvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5288.namprd12.prod.outlook.com (2603:10b6:208:314::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 25 Nov
 2021 16:14:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.023; Thu, 25 Nov 2021
 16:14:48 +0000
Date:   Thu, 25 Nov 2021 12:14:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
Message-ID: <20211125161447.GN4670@nvidia.com>
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com>
 <20211123165352.GA4670@nvidia.com>
 <87fsrljxwq.fsf@redhat.com>
 <20211124184020.GM4670@nvidia.com>
 <87a6hsju8v.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6hsju8v.fsf@redhat.com>
X-ClientProxiedBy: MN2PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:208:23b::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR11CA0020.namprd11.prod.outlook.com (2603:10b6:208:23b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 16:14:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mqHOZ-0021oP-AC; Thu, 25 Nov 2021 12:14:47 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7d1ff48-dc44-4e60-a0f1-08d9b02eb414
X-MS-TrafficTypeDiagnostic: BL1PR12MB5288:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5288F7270F35B878A236BAD8C2629@BL1PR12MB5288.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZrnROGY7Ovdb9UKDohsi9J19klta9gVPereBnTJwnHlFUjURTim85hwfZCQACsFh9qacFK/XW5Az/8GVfDIn6cW/8PDjcuEUS/ueEn2p+w2YuxYYyqXSleZclAHwoX+ALpt8t+owOwUiPBSWvxoe+YoHHRGZSu1LlEGrORoghOsXg79gg6KK1OwoLnJqVgao0UbZOCWYunI/0RdDa0one4S34ZfesDX8woIsDwRodBrANBATP6WwadLXbAJHIIo0mf5gQnNxhbYHyaVSLZNf62n1ZzHpO9aojo1cAkkmRnv1S0RaZmxlcv2Uuic5d6nCf1CVyP/lgWWm7o5yZw2vYUHpKBJfPTdKXHZg+mK7CTKb4I5Onqaapk0HhXJTA2cH4K+y2Jk3v7IfCd4UhB5RcOiNZZiR3V2yEO5WBA18JjJKdWysS0TnYhRR3Bpbieasp8zRLGG3v42wSPaRBcWhHmuEARVNMH7/FPOpV6binp/H+guJicACZoxfzyOGG4VQ9m8BSv9pIlXuu9TDNmCpDaVVnto9u8NW+KqxwlKxGbRA/ESW5Fn6YLb0iZ5dqf9KZlVtFNwyk/J7K3t01Wf93F0jASh2Fz4/5cKF8KXM8fVGLQAHUBfhUoX6+XbWFngmYhrdgjz0BEyEqwauPlZSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(316002)(86362001)(83380400001)(426003)(8936002)(107886003)(2906002)(8676002)(6916009)(186003)(66946007)(66556008)(66476007)(38100700002)(26005)(54906003)(36756003)(33656002)(4326008)(2616005)(5660300002)(9786002)(9746002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86PAxUP3bXK0h5+STeJAZwGmI67M29kRmx+tpdZvOGGUYbPU0Hd5ego+plSJ?=
 =?us-ascii?Q?ynnPsGIviCTm60Nam00/0pKUCcTlKglHXFGXZ+4usGYn0ER9uoLAXxDzM7f9?=
 =?us-ascii?Q?jNVHbaDx1eY96jF0cOXc6pG8BS3FI3os7cVlnMKsXU+f+yMYqhxonziRRW94?=
 =?us-ascii?Q?vndT3Fo4vgdb3kCwoL3CewcWsgYS0Gmir7wE5XFxp7N/obJ5btsnlCizjnsi?=
 =?us-ascii?Q?555DI37oP2MmsO6SqPf2DAM6qxv40+NN6JRaQTO9RAQtbhzeuLhcp+gotCOl?=
 =?us-ascii?Q?nA2Lig8yYOKSBzLpAVluVeGRyB8cgPy7sSWhyZIIeOGnX5+9FPBbsewU7O8Q?=
 =?us-ascii?Q?TgZPMzq8emQ+zmB1zV5wCHLpXhTQSxwqCwYohz/9rxsXJWotJH0+Vw6/xJN1?=
 =?us-ascii?Q?dg3ISRJFTu1GZVdSvjg8Q+98/MRFLjPACt/vSLF8ggP+MMc5lwwHmkSP9q9w?=
 =?us-ascii?Q?d3x4lqcsM+9arvYWnnUv4INxxOp0HIvCVMO2dHpsli+Vr5jy4v72EaekpOVP?=
 =?us-ascii?Q?6FHLlIZgrQdfR4Z7px3gVXoCNgcNzb4Uxds7Q8Bl4mwVXFJVvyg7PQguw9t1?=
 =?us-ascii?Q?fCEYYpiZaSnQivRZUwUZcze6eMtqd0Hq/epH2QMBWV6yvFFHNEY6C2GplNk/?=
 =?us-ascii?Q?GFKh6jQGDy9qHjwtxer8j/fPYKtKhdipQA6jHDrPbC5SrMuNbwwkgkS6KJqi?=
 =?us-ascii?Q?NxfLCxWr9bfLrWrguCH+znKVaM1GvwemPUl+C6OBvDXuxyxK9vyF/cBHOQue?=
 =?us-ascii?Q?lr9baX4fe8HlSiD8JwLhFqHAEDQR6ND1cG2QK5fByA+Bkyqp20x4mZpERUiI?=
 =?us-ascii?Q?KlheJwF0HZktylD31VYKzEfyE2JTQFZkGZNh/m8USPDIMTke4DJ1kx7bysnX?=
 =?us-ascii?Q?4YuHxu2lKa7IQ1y57ulmtzweoZRQrVwAs/4v40iSqbD1/cl1lbpGhk50Z5Uu?=
 =?us-ascii?Q?VcOII6+2CGO0VoqcXN4UUmIvCR1CjidnnyRkCzDIlsobAhb94w50pJiUoxuj?=
 =?us-ascii?Q?z9G4BkdEJc6qBmFnIc1c6AC1bBmqoBfTV0Lwfzvg7wRjqLx3PwyQmWVk8es2?=
 =?us-ascii?Q?t5AdtUVb3PpPVfSoSDhTUPsXEnnozOLcFzaZ87uIZBC1h7Elt8rEMiAkRKdE?=
 =?us-ascii?Q?hPZ1AnqvXM74NJZzA77609NFjbsAuaD5zosESpmtRkBJNfYHrT9qtK09F/16?=
 =?us-ascii?Q?yAN0RTiBm4wPhbC777yJXGeWEjENzlUJK+r4JsUH6whMeYAls2pZKvmJ+kjX?=
 =?us-ascii?Q?noWp6/Efqov5WhHbOZ5CXQFfFQAvlWs7d9NvDy88N6akPoUDhVKn2D3kU0hx?=
 =?us-ascii?Q?/G9TqviVUTVVnQfPYREpM8JMS+lHKF/Oaq8UcvY/0kSt/H9POkupSD36kr1u?=
 =?us-ascii?Q?QU9TIcdYaJt5WcKEphvaGCSTkqotG2M0jkmF0BDdiFK6GrrBjYzZxlxl6/2p?=
 =?us-ascii?Q?a7ioLqkkLMzv0lA1Ev0hhFZM15QsCZE2sKVyW0gQEasgSng1R741cIOdzCJo?=
 =?us-ascii?Q?JEoJIFnk1Xlg8T9PF6ecEVHHM7EFbJOlFBF9/YFoyLKsM6tNLBZ9zBUNY/3T?=
 =?us-ascii?Q?SbrBhHIHbZ5GDQENvew=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d1ff48-dc44-4e60-a0f1-08d9b02eb414
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 16:14:48.8788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzWveEfbinyZMmhpdkeKgcQNyV/YdN4OBFPBVGt1vYnrvH7LxhCs7sWl2XmAiTTy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5288
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021 at 01:27:12PM +0100, Cornelia Huck wrote:
> On Wed, Nov 24 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Nov 24, 2021 at 05:55:49PM +0100, Cornelia Huck wrote:
> 
> >> What I meant to say: If we give userspace the flexibility to operate
> >> this, we also must give different device types some flexibility. While
> >> subchannels will follow the general flow, they'll probably condense/omit
> >> some steps, as I/O is quite different to PCI there.
> >
> > I would say no - migration is general, no device type should get to
> > violate this spec.  Did you have something specific in mind? There is
> > very little PCI specific here already
> 
> I'm not really thinking about violating the spec, but more omitting
> things that do not really apply to the hardware. For example, it is
> really easy to shut up a subchannel, we don't really need to wait until
> nothing happens anymore, and it doesn't even have MMIO. 

I've never really looked closely at the s390 mdev drivers..

What does something like AP even do anyhow? The ioctl handler doesn't
do anything, there is no mmap hook, how does the VFIO userspace
interact with this thing?

> > In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
> > device back to device_state RUNNING. When a migration driver executes this
> > ioctl it should discard the data window and set migration_state to RUNNING as
> > part of resetting the device to a clean state. This must happen even if the
> > migration_state has errored. A freshly opened device FD should always be in
> > the RUNNING state.
> 
> Can the state immediately change from RUNNING to ERROR again?

Immediately? State change can only happen in response to the ioctl or
the reset.

""The migration_state cannot change asynchronously, upon writing the
migration_state the driver will either keep the current state and return
failure, return failure and go to ERROR, or succeed and go to the new state.""

> > However, a device may not compromise system integrity if it is subjected to a
> > MMIO. It can not trigger an error TLP, it can not trigger a Machine Check, and
> > it can not compromise device isolation.
> 
> "Machine Check" may be confusing to readers coming from s390; there, the
> device does not trigger the machine check, but the channel subsystem
> does, and we cannot prevent it. Maybe we can word it more as an example,
> so readers get an idea what the limits in this state are?

Lets say x86 machine check then which is a kernel-fatal event.

> Although I would like to see some more feedback from others, I think
> this is already a huge step in the right direction.

Thanks, I made all your other changes

Will send a v2 next week

Jason 
