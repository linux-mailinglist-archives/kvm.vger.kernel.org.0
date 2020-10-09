Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E121328899C
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 15:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgJINM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 09:12:28 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:23093 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388027AbgJINM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 09:12:28 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8061b80000>; Fri, 09 Oct 2020 21:12:25 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 13:12:22 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.51) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 13:12:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLY1lNYAlYa3ftuObNzV9rP+kIDHMbQGXYoKlho+ApCkgDtB//gKkvyMkEzGM97BV6MHJrwdxrlEd3wCI00NU0NbeO5RDVBRyR3HeBnqcuwaMJDs8vfIsv2EwQPorU9OTF7MK25ZKwX8azIQp1MWtNqOk0t50/9R00n8sq40xOHisJ4VBPg0+S5yov9OYmakRdkbCcmiTrs66DBivdpmE/a3PPNe2XrMf40YRJSn3HGrVQ0w+XlGNqGm6/VnCPmjvKgmwK3NmTmlklCr7ZSckomBjfqR7bJ+ETCxJm618RZLOtyzTd92pjbXOWAK28WyqSh3MZWZcLpkOCrDrxaz1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMJvCp9uSZGd4bgPbV0kh2vM4gvpbShBUiuJWASSEGA=;
 b=WrhM2kVS4Klgtf8LEJJT1QwhCDDS0j1xHH924QTxLTxuMjOsh0RqqGKcC7RRy/avzdz5Xwe08xpojoTpFvGAdjyXYOvWA+hQ40rz4/DUa1QUtbC4tAdfAu9t9mh4MgyxoYEkbrJ7ftnJUJaACQtdp3rGhmaTFPNO5GLFgaLMa6ekn6xnGP1HJv9geCJbipu4CMOAvQDtMSctdKxRECbqpph8JifPgb3n5HZkGodIZ8tVAAEQGOpeWX9YP2NZO5TnHYbZTv7bUSwGT7Sieczbx384wTXY6oKCPOZMxYAgSY05963LexeXpdGJPDEn9KS7bTqqgmmCoQyUmUHKFe4lsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2603.namprd12.prod.outlook.com (2603:10b6:5:49::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 9 Oct
 2020 13:12:20 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3455.026; Fri, 9 Oct 2020
 13:12:20 +0000
Date:   Fri, 9 Oct 2020 10:12:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
Message-ID: <20201009131218.GK4734@nvidia.com>
References: <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com>
 <20201009012231.GA60263@otc-nc-03> <20201009115737.GI4734@nvidia.com>
 <20201009124307.GA63643@otc-nc-03> <20201009124945.GJ4734@nvidia.com>
 <20201009130208.GC63643@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201009130208.GC63643@otc-nc-03>
X-ClientProxiedBy: MN2PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:208:15e::38) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR17CA0025.namprd17.prod.outlook.com (2603:10b6:208:15e::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Fri, 9 Oct 2020 13:12:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kQsC2-001yWu-4V; Fri, 09 Oct 2020 10:12:18 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602249145; bh=sMJvCp9uSZGd4bgPbV0kh2vM4gvpbShBUiuJWASSEGA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=OWSEhBBCwgco1UoumhBENLmlvDhR3Z/Elcop1VFPJoj4weIHxClEtElEi4djSHpVf
         Pw4V5Enph/SGAmyf069UBjdxOIHJn5gQEFGwAo0ieRbjWFmvV+1BcTBZqarsVIkXuL
         LZVaToXYfDdjuKFz9ubqZ6kfIBDi6GY+HzrTZ6MgKYxSXhDjgmWChkeMreJQ55eZNu
         wBDV/4zyhpC1rJr9Bdf8IbAZTHQEePc9o1ANoNrkQjo41jAJl1FAa+tfHdhJPow04Y
         IsE56eaYVoJvOCWkhfguXfzO2OM/4B0EeKjV6Ly+jATdo9t4N6RjR1KmbCSmVJ9BKe
         lATvL0Q1DQDeA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 06:02:09AM -0700, Raj, Ashok wrote:
> On Fri, Oct 09, 2020 at 09:49:45AM -0300, Jason Gunthorpe wrote:
> > On Fri, Oct 09, 2020 at 05:43:07AM -0700, Raj, Ashok wrote:
> > > On Fri, Oct 09, 2020 at 08:57:37AM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Oct 08, 2020 at 06:22:31PM -0700, Raj, Ashok wrote:
> > > > 
> > > > > Not randomly put there Jason :-).. There is a good reason for it. 
> > > > 
> > > > Sure the PASID value being associated with the IRQ make sense, but
> > > > combining that register with the interrupt mask is just a compltely
> > > > random thing to do.
> > > 
> > > Hummm... Not sure what you are complaining.. but in any case giving
> > > hardware a more efficient way to store interrupt entries breaking any
> > > boundaries that maybe implied by the spec is why IMS was defined.
> > 
> > I'm saying this PASID stuff is just some HW detail of IDXD and nothing
> > that the core irqchip code should concern itself with
> 
> Ok, so you are saying this is device specific why is generic framework
> having to worry about the PASID stuff? 
> 
> I thought we are consolidating code that otherwise similar drivers would
> require anyway. I thought that's what Thomas was accomplishing with the new
> framework.

My point is why would another driver combine PASID and the IRQ mask in
one register? There is no spec saying to do this, no common design
reason, it has *nothing* to do with the IRQ mask other than IDXD made
a completely random choice to put the IRQ mask and PASID in the same 32
bit register.

At the very least we should see a bunch more drivers doing this same
thing before we declare some kind of pattern

Jason
