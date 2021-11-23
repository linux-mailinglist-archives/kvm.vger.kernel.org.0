Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61C945A950
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhKWQ5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 11:57:04 -0500
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:44225
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230510AbhKWQ5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 11:57:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVXuZuOG1Xy19sPYs49pwwIm7bB2/npm7k4atSqRbKdVbGnOeRD71BUkckng5dche/GaG7nsGknyLXmQjpLmrar5oK01152vVJSemLYhvW2WqSEG+/mOWNdscVOVHJjx5SVr3QP+IedyWWWDk5iVa6jgRVhbilUQTVTewDGBHTaPCPZYAlvT7sLT7z5/OHcaquu5f1gEoETY4Dr+O2p0dke+ScYtnPVuvdfjSjdS6jesJgO4cBR8cSy9u25cAFzwC16iKpRKSq2vd5PRfQFjiyVSSW9U4JhZwwIcnksqWUUVnm4QwOx8KOJzKZTl9QS2ZmmTt2e8LV3VwzoJI4C/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8GBsNILoW6eZJy5jdxDNQj1+I5E5xS7NBM6gyrlJG4=;
 b=B8C5KOocPxnoTw1hYFwzoFuQ4BzbLhGQlGcNGuG3kgPv5LegRpFzo7F41DeYkT9XmgubH1vc/PycAv3GdcgjvViflbbF/KvvZ0HEP07kjIsapCTbtAl7Va0GvLLrCIplo8EFl/MtShGGjtT8SRgWk9RE3tHIqglfzPBUh6NmwPtjS8DGZ4Jcg16oug51e1+m4pP13TFkfbITWrP9cpBWg9biYbtqLUnBadw6dgjGBG88vGDBvRVITb4hRa4Y9+4rur0y6x82VCgwUuXx0PdUniqZTzO2hCYKVWOYsVZI8XIEmhwZa9q9prI15XW73CHv9ZnLn6TVl20BRRP7AbbOPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8GBsNILoW6eZJy5jdxDNQj1+I5E5xS7NBM6gyrlJG4=;
 b=ClS5rwA/4FBNnRSNIGLjAC+GDY9kafNponVmb2Wy6wyjums5S3VwBVpD75Gtzq+ouAc1hiTiw6aXlvZey1vvPHBgV3CJ7c9qnmdOEwsJOzqiTV1N0qZwvtEvJnEWKaGGyl62z/AKQzwJgPcW5VNxz5+GDzUiYG1CMlvxtv/D7FtwRBQ+/bNudzEPlXWId21PwLN/KaclrwsR8bxD1+w9pwcKHOHBCpaqGEnF13v1Om5fhIXxR9UwuFnvZ0G2GIylmac2+Zm3DULnHzBAgls9FRMVtxvuoLun9Wx/IFUbFmXTElLtm52c6jW7rJK6P9GwzpN6FnurIaqEyJ/yx5mt7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5553.namprd12.prod.outlook.com (2603:10b6:208:1c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 16:53:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 16:53:53 +0000
Date:   Tue, 23 Nov 2021 12:53:52 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
Message-ID: <20211123165352.GA4670@nvidia.com>
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgpvj6lp.fsf@redhat.com>
X-ClientProxiedBy: BL0PR02CA0072.namprd02.prod.outlook.com
 (2603:10b6:207:3d::49) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0072.namprd02.prod.outlook.com (2603:10b6:207:3d::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Tue, 23 Nov 2021 16:53:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mpZ3I-000DHu-Dd; Tue, 23 Nov 2021 12:53:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6979fc8e-29dc-4bb7-0d55-08d9aea1d4ca
X-MS-TrafficTypeDiagnostic: BL0PR12MB5553:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55537DBA04F1AB25A26BAF20C2609@BL0PR12MB5553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ht+VYnS2QfUL51O9LfDMQbj1aWYEvog2TU8mmUCu6OKFJ4q1dIwnlnVPPQdve1QonxDvnzqFv75BYIzEbsBqSvQc5UjJeLOReeeiJk8JlZycW61cWaYtk8zi8ZGj5GVXlHY9AP0t6SL9C152baeSIs7fGFnxXSilXXvHi5ktyAazF9QlMtACkqMVBS61qJ1h/tH98Ct0PMwsPwByoDT4adJiQPSjcIrT0w114B2kbLbuDDZQL5CBFUatwONdMxFJedi5C6NGcG+vK/N92ThPTw8ts6T3uB4UhNC6Gwbynf5PeF21BaPLHsIcrKEKkvAvsZ+CXyMzWkR52asE2oORjqafP6c4CE+9dQPJs5V0zzZDMc7A74lqXqp3w/NHQNiIGwNz8bGQUkINTd/wkE8Zy1wpjI/G5Ylcvw+bVYb7i2L9tzNkJXf/tZ28IXDx1fv9xMExvkW5eLaBW3rsqBRrEifCdFILzXt9fuou1fWRpmDOST5xxLh5qd6HDjj5YnZ4wGZ3B5ka5wN/b5QBKCUaL4R+g03IV5FXryHBIPa0yNkYwIesW125xqZzi+NAylRSZYFzGkfmkjpg+SCR21aCuUcv4DNw1ylUmpTQLdXd8Er6hhYIV/U/6BQ4y791GGYso9NX476cVYEVmRUVKiZQaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(107886003)(83380400001)(508600001)(86362001)(6916009)(1076003)(38100700002)(33656002)(5660300002)(26005)(66556008)(66946007)(2616005)(8936002)(186003)(8676002)(426003)(54906003)(36756003)(316002)(2906002)(9786002)(66476007)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Gy++GGFPjYNx4pNUMadB7opdQTCH6MgWYLXAiXS1hsgbHsuBbRgKbfzK3xF?=
 =?us-ascii?Q?DWaNrysDWSyp3KIqSJBC3MRZH8iKPMi/Z+Vx6A9x4GjGUK8+SljvZbzJxBQn?=
 =?us-ascii?Q?c4R+JUcsjHW3v9C4el8nDlaZnTFY80Gp3fYKpY2jQfya2xxtpeLPCfgyZSzz?=
 =?us-ascii?Q?Eg5RUI3SdfQbfj+dBVzHJMS6JsRdlXf/MOKX3GtPkkqx6hfUMnefwwtutk2J?=
 =?us-ascii?Q?HnLyeiVyxrzD9yldcUguYs+wljfIR+HiUINuN7FWheTjs3dTbs21lWdyEg1z?=
 =?us-ascii?Q?lMDSwZFO+542OmSK1BelFMj+LtuEeMLmJcl9SLUKkeR+kduu11sBjIfBE0UI?=
 =?us-ascii?Q?M7q3vPSKPiB1gf7vmVom1DUnkusr50IwbLSAX4JAvsQkBCDlF2W7G4uARgzG?=
 =?us-ascii?Q?4r/QOuE9gtVQmIbxfwV3FgkFFg3tbnVmzuNrfTjWS3s4+jOvOXB+DLz4VSte?=
 =?us-ascii?Q?Gba8KQcNf/Kqkst4Ak1RA1m1sx4oEOamOsx0KPhLixTJ36VG52k0c1LorlaK?=
 =?us-ascii?Q?fMs3jfD0lKU8InUBtH4feN60ZDa5SdwGXh2a5De8Gc65hLdwMFb8r/NL76Ox?=
 =?us-ascii?Q?O6Cwmjm44tCWgXkUktH4DYgThk43/R1abWQuucJe1zud5T2SbzWZcEA292vw?=
 =?us-ascii?Q?j1D1/5EY2GusCl24GR8McHt94diiw13MqJEAir0/itVoOCGDEZS9gRpi6Dqn?=
 =?us-ascii?Q?OUPekAzehSE8XdfD598k+ZbXPp18jiPp/K9lCONFlrAYqkyYgLbO3IlT5sFS?=
 =?us-ascii?Q?8ubTDQrQwY1nxfRLIRMQQDrut52OZkg68ywu6tmecBR6ssgOJDYI25HTIsDv?=
 =?us-ascii?Q?rBMJC997F85pTeqBRa3VhCPHDGpIMENnchGXV1oymmrLxMd42Rpui8Mae1Mj?=
 =?us-ascii?Q?EMiq2gUnzb8mmK7MWOsa0sQ8DqN2BLcJsDRdl/lEeowGMoAbvAHfqGrymnIh?=
 =?us-ascii?Q?mBV/dUpDUpJpOTYKwxeLakEBGUBhjUWoPjHh195H/J6eUvAGZSDoajvNZ0MR?=
 =?us-ascii?Q?+/n5In5L93nh0yIJGewJ6l+Asy94ZriAVBWjhrm7mgWCo2M+bM0Awf0QIMA+?=
 =?us-ascii?Q?MW65YBR1qz2Idgt2j4m9ok2ey5Xb98NswwIf64DjoLQXLb1NJFNWWq6KLkbG?=
 =?us-ascii?Q?udHyx7TC6cW1Id8oYmH8EE4P5yLLe/f8na0Kj8YH7bvZ0cyuJcxV+kMpgrR/?=
 =?us-ascii?Q?j9FOp0E0JaAy6Z4relDh2zOkXMSxHtP5fOz/ui3Wt0/klpxSY8TE7zXn72Ch?=
 =?us-ascii?Q?n7hST0b0KFIXlNjtwtCYiOX9qL6E3c9E3+gBySkKkpHt3vf1A1SAAEBPrdvz?=
 =?us-ascii?Q?w0R8Zkk6zSfBmBIe0MGEkpTAj9Pw31oknFRR6kLZugqYUSczWuU0+tdZOIXJ?=
 =?us-ascii?Q?0+cuev41AOUobTXkDWQfpUF8gHkdI8orz4mjG4mbjojVt6LxstiGoZyBkdpq?=
 =?us-ascii?Q?0eHawe58L8zsA4EOzXlLgqc/tYxeJCUnhNRQp0uZpIuFH9wVjY/sCcllRD88?=
 =?us-ascii?Q?mZSeI97e+Cfiqj1kcD/+u7K5k6tt3V8N2NXWz3RBW4SbMz67XzZoIVAw8eRM?=
 =?us-ascii?Q?gaB86jjfoWSaawMygbU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6979fc8e-29dc-4bb7-0d55-08d9aea1d4ca
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 16:53:53.7214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8eoCMRIwsLI3tJdqcEQBjx1MEri9xM5b9PtzZnaYrdZMUJKP85HdZCj86Rv+dvn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5553
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021 at 03:21:06PM +0100, Cornelia Huck wrote:
> On Mon, Nov 22 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Provide some more complete documentation for the migration region's
> > behavior, specifically focusing on the device_state bits and the whole
> > system view from a VMM.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  Documentation/driver-api/vfio.rst | 208 +++++++++++++++++++++++++++++-
> >  1 file changed, 207 insertions(+), 1 deletion(-)
> >
> > Alex/Cornelia, here is the first draft of the requested documentation I promised
> 
> Thanks, I'm taking a quick first look.
> 
> [As it's Thanksgiving week in the US, I don't think Alex will be reading
> this right now.]

Sure. I've made a lot of changes already so I'll try to post a v2 next
week

> > +The device_state triggers device action both when bits are set/cleared and
> > +continuous behavior for each bit.
> 
> I had trouble parsing this sentence, until I read further down... maybe
> use something like the following:
> 
> The device_state controls both device action and continuous behaviour.
> Setting/clearing a bit triggers device action, and each bit controls
> continuous behaviour.

OK

> > For VMMs they can also control if the VCPUs in
> > +a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
> > +TRACKING). These two controls are not part of the device_state register, KVM
> > +will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
> > +container controls dirty tracking.
> 
> We usually try to keep kvm out of documentation for the vfio
> interfaces; better frame that as an example?

It is important, we can't clearly explain how things like PRI work or
NDMA without talking about a 'VCPU' concept. I think this is a case
where trying to be general is only going to hurt understandability.

Lets add some more text like 'VCPU RUNNING is used to model the
ability of the VFIO userspace to mutate the device. For VMM cases this
would be mapped to a KVM control on a VCPU, but non VMMs must also
similarly suspend their use of the VFIO device in !VCPU_RUNNING'

> > +Along with the device_state the migration driver provides a data window which
> > +allows streaming migration data into or out of the device.
> > +
> > +A lot of flexibility is provided to userspace in how it operates these bits. The
> > +reference flow for saving device state in a live migration, with all features:
> 
> It may also vary depending on the device being migrated (a subchannel
> passed via vfio-ccw will behave differently than a pci device.)

I don't think I like this statement - why/where would the overall flow
differ?
 
> > +  RUNNING, VCPU_RUNNING
> 
> Nit: everywhere else you used "VCPU RUNNING".

Oh, lets stick with the _ version then
 
> Also, can we separate device state bits as defined in vfio.h and VMM
> state bits visually a bit :) better?

Any idea? I used | for the migration_state and , for the externa ones.

> > +     Normal operating state
> > +  RUNNING, DIRTY TRACKING, VCPU RUNNING
> > +     Log DMAs
> > +     Stream all memory
> 
> all memory accessed by the device?

In this reference flow this is all VCPU memory. Ie you start global
dirty tracking both in VFIO and in the VCPU and start copying all VM
memory.

> > +Actions on Set/Clear:
> > + - SAVING | RUNNING
> > +   The device clears the data window and begins streaming 'pre copy' migration
> > +   data through the window. Device that cannot log internal state changes return
> > +   a 0 length migration stream.
> 
> Hm. This and the following are "combination states", i.e. not what I'd
> expect if I read about setting/clearing bits. 

If you examine the mlx5 driver you'll see this is how the logic is
actually implemented. It is actually very subtly complicated to
implement this properly. I also added this text:

 When multiple bits change in the migration_state the migration driver must
 process them in a priority order:

 - SAVING | RUNNING
 - !RUNNING
 - !NDMA
 - SAVING | !RUNNING
 - RESUMING
 - !RESUMING
 - NDMA
 - RUNNING

The combination states are actually two bit states and entry/exit are
defined in terms of both bits.

> What you describe is what happens if the device has RUNNING set and
> additionally SAVING is set, isn't it? 

Any change in SAVING & RUNNING that results in the new value being
SAVING | RUNNING must follow the above description.

So
  SAVING|0 -> SAVING|RUNNING
  0|RUNNING -> SAVING|RUNNING
  0 -> SAVING|RUNNING

Are all valid ways to reach this action.

This is the substantive difference between the actions and the
continuous, here something specific happes only on entry: 'clears the
data window and begins'

vs something like NDMA which is just continuously preventing DMA.

> > + - SAVING | !RUNNING
> > +   The device captures its internal state and begins streaming migration data
> > +   through the migration window
> > +
> > + - RESUMING
> > +   The data window is opened and can receive the migration data.
> > +
> > + - !RESUMING
> > +   All the data transferred into the data window is loaded into the device's
> > +   internal state. The migration driver can rely on userspace issuing a
> > +   VFIO_DEVICE_RESET prior to starting RESUMING.
> 
> Can we also fail migration? I.e. clearing RESUMING without setting RUNNING.

No, once RESUMING clears migration cannot be forced to fail, to abort
userspace should trigger reset.

This deserves some more language:

If the migration data is invalid the device should go to the ERROR state.

> > + - DIRTY TRACKING
> > +   On set clear the DMA log and start logging
> > +
> > +   On clear freeze the DMA log and allow userspace to read it. Userspace must
> > +   take care to ensure that DMA is suspended before clearing DIRTY TRACKING, for
> > +   instance by using NDMA.
> > +
> > +   DMA logs should be readable with an "atomic test and clear" to allow
> > +   continuous non-disruptive sampling of the log.
> 
> I'm not sure whether including DIRTY TRACKING with the bits in
> device_state could lead to confusion...

It is part of the flow and userspace must sequence it properly, just
like VCPU. We can't properly describe everything without talking about
it.

> > +Continuous Actions:
> > +  - NDMA
> > +    The device is not allowed to issue new DMA operations.
> 
> Doesn't that make it an action trigger as well? I.e. when NDMA is set, a
> blocker for DMA operations is in place?

For clarity I didn't split things like that. All the continuous
behaviors start when the given bits begins and stop when the bits
end.

Most of the actions talk about changes in the data window
 
> > +    Before NDMA returns all in progress DMAs must be completed.
> 
> What does that mean? That the operation setting NDMA in device_state
> returns? 

Yes, it must be a synchronous behavior.

> > +  - !RUNNING
> > +    The device should not change its internal state. Implies NDMA. Any internal
> > +    state logging can stop.
> 
> So we have:
> - !RUNNING -- no DMA, regardless whether NDMA is set
> - RUNNING|NDMA -- the device can change its internal state, but not do
>   DMA
> 
> !RUNNING|!NDMA would basically be a valid state if a device is stopped
> before RESUMING, but not for outbound migration?

The reference flows are just examples we can all think on, it is
always valid to go to any of the legal bit patterns, but may not be
useful.
 
This specifically not a FSM so any before/after migration_state is
technically legal and the device should behave as described here.

> > +  - SAVING | !RUNNING
> > +    RESUMING | !RUNNING
> > +    The device may assume there are no incoming MMIO operations.
> > +
> > +  - RUNNING
> > +    The device can alter its internal state and must respond to incoming MMIO.
> > +
> > +  - SAVING | RUNNING
> > +    The device is logging changes to the internal state.
> > +
> > +  - !VCPU RUNNING
> > +    The CPU must not generate dirty pages or issue MMIO operations to devices.
> > +
> > +  - DIRTY TRACKING
> > +    DMAs are logged
> > +
> > +  - ERROR
> > +    The behavior of the device is undefined. The device must be recovered by
> > +    issuing VFIO_DEVICE_RESET.
> > +
> 
> I'm wondering whether it would be better to distinguish between
> individual bit meanings vs composite states than set/clear actions vs
> continuous actions. This could give us a good overview about what a
> device can/should do while in a certain state and what flipping a
> certain bit implies.

Again, refer to the mlx5 implementation, there are not actually
individual bits here controlling specific things. SAVING for instance
has no device behavior meaning when discussed in isolation.

Thanks,
Jason
