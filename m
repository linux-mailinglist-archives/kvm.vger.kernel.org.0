Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9303A287F24
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 01:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgJHXcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 19:32:18 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2986 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgJHXcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 19:32:17 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7fa1490000>; Thu, 08 Oct 2020 16:31:21 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 23:32:15 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 23:32:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWNHKUdaDPE1VNAPxR6Gt2K5FuH2pqnpqwaEj03IGPuwVHyxyqjgl2pktCKBJb/SW+mMZJPPqxSHugGaWbz3/gzvjdha1zW3OzOhBdeV9wQM86Vdu2s4QLL5Jrgvb6Wk/apl74D9/xG52igA1ACd8c6zhEdr1/kVLpAyDLgEBAT99/gGBmRI64AhJAa2/UW+m0SAIcSJITsWrJwWSMnOBon++DDVb6htZ1u+VIbqVLCukaiI+YpE2YvzBhljQoM/zLQcdDx8s+KfGTtx7LlKoR3VUmfx1uOXLSnlj5eWg2vBbwAXbOlv3WJ6KH7oUJ/0EJn9rnukwIiwBJSWcp1Vlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBtcuxQxGJxVZM+1oIT81t1EHEQwgCbCuLxZ/puM0lM=;
 b=Ng8NwShyoTROn0u6U5WEyQMWzqKTTTZ2S7UfXi4myfX7LvqOMM8OwcGC1i83MaV5tnor/cuQ+Cn8YQqIzNmvmHcZGtk3GiXehjoasKWzSphbpgypnFbKDbuTwu7BU3mBv0/tuA3SRHNS5oByZqMAsbPjJQyM6vD8Ajvo1NbxnJc2VNIZpO4BKYOL4+46jU+oWsx5vGn5Mep3cO9pLeYwdiD6+ilMP7clwaeFAlaE068HDpQi+492O3e6qBqMxE8W5DCI15xwgmtJ8NOLuAEPEWewOnrcsbb9HxZJW0YaVeFjAdQRFv5TS3ySpsPRkGkQvwl7zIkuxAzztHosbGv9WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Thu, 8 Oct
 2020 23:32:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 23:32:12 +0000
Date:   Thu, 8 Oct 2020 20:32:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>, <rafael@kernel.org>,
        <netanelg@mellanox.com>, <shahafs@mellanox.com>,
        <yan.y.zhao@linux.intel.com>, <pbonzini@redhat.com>,
        <samuel.ortiz@intel.com>, <mona.hossain@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
Message-ID: <20201008233210.GH4734@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87y2kgux2l.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Thu, 8 Oct 2020 23:32:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kQfOM-001m41-HQ; Thu, 08 Oct 2020 20:32:10 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602199881; bh=aBtcuxQxGJxVZM+1oIT81t1EHEQwgCbCuLxZ/puM0lM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=B/JDEQlZM46MkF3BhLd4T+hnuXCsrXAHZucvFPgqloQbGFehwUZBZlljDAGFWQ06A
         cFLP0poowVHeHzDZrxYUhSnsK14XZYbBqN0A+teX0lffrc3E5PAlrbTbx8FvDhGRN/
         YvAG7hKXOVlYo9CdMthkfEe4Y08kP2srpuNWN526VeqRCWrMJyTV52H09tBSeS+q/2
         C5JtWR/2sjTE9p/O34uvcEPHQxMkuR1uY/qOFvE+guM/Ep1LlyOMCwr6EMqbrtm2f3
         E+nwpUQ8y2AKKWxwY5khNN9yaNxpFENbmZSESJOtqNjAGUb+xkr+WMIwNYBaF0Ufe/
         ysW7kPitaWw4g==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 01:17:38AM +0200, Thomas Gleixner wrote:
> Dave,
> 
> On Thu, Oct 08 2020 at 09:51, Dave Jiang wrote:
> > On 10/8/2020 12:39 AM, Thomas Gleixner wrote:
> >> On Wed, Oct 07 2020 at 14:54, Dave Jiang wrote:
> >>> On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
> >>>> Aside of that this is fiddling in the IMS storage array behind the irq
> >>>> chips back without any comment here and a big fat comment about the
> >>>> shared usage of ims_slot::ctrl in the irq chip driver.
> >>>>
> >>> This is to program the pasid fields in the IMS table entry. Was
> >>> thinking the pasid fields may be considered device specific so didn't
> >>> attempt to add the support to the core code.
> >> 
> >> Well, the problem is that this is not really irq chip functionality.
> >> 
> >> But the PASID programming needs to touch the IMS storage which is also
> >> touched by the irq chip.
> >> 
> >> This might be correct as is, but without a big fat comment explaining
> >> WHY it is safe to do so without any form of serialization this is just
> >> voodoo and unreviewable.
> >> 
> >> Can you please explain when the PASID is programmed and what the state
> >> of the interrupt is at that point? Is this a one off setup operation or
> >> does this happen dynamically at random points during runtime?
> >
> > I will put in comments for the function to explain why and when we modify the 
> > pasid field for the IMS entry. Programming of the pasid is done right before we 
> > request irq. And the clearing is done after we free the irq. We will not be 
> > touching the IMS field at runtime. So the touching of the entry should be safe.
> 
> Thanks for clarifying that.
> 
> Thinking more about it, that very same thing will be needed for any
> other IMS device and of course this is not going to end well because
> some driver will fiddle with the PASID at the wrong time.

Why? This looks like some quirk of the IDXD HW where it just randomly
put PASID along with the IRQ mask register. Probably because PASID is
not the full 32 bits.

AFAIK the PASID is not tagged on the MemWr TLP triggering the
interrupt, so it really is unrelated to the irq.

I think the ioread to get the PASID is rather ugly, it should pluck
the PASID out of some driver specific data structure with proper
locking, and thus use the sleepable version of the irqchip?

This is really not that different from what I was describing for queue
contexts - the queue context needs to be assigned to the irq # before
it can be used in the irq chip other wise there is no idea where to
write the msg to. Just like pasid here.

Jason
