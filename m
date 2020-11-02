Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426182A3150
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 18:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgKBRTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 12:19:16 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4603 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgKBRTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 12:19:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa03f950000>; Mon, 02 Nov 2020 09:19:17 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 17:19:12 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 2 Nov 2020 17:19:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBofhKrYw67gYuIQcYel+JBrz6r6Pt9hJDUnJrk/IPRP8GRXV6Mnr+zYOCWMs7kZz7xjeML9UKtLmbpyuA2G5xaWBGfc177JQMUivcK71Kdk4E6Soch9rblLy6gOjCH4jh9kW0yIPg0pA4v7ZfW/4Muq0BWOnt19OWcgul9X5qC99u9jQvtirKIZ5a/5Acc4rRwwXNe18yGB3WCocLSzt8vixs130c0J7OKN9H0hKAvmnNrpBtFVV5dV0hDqb+Y5iTIJgBZm2Kpm2jII5PprSMUx22tR414Q59aKWdnWHr0Lx0w9oHhc0eihpxya2y+tXdkVUqLuvgXvnkXeQabtQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUGbF3EC9mhBBWFzgbgI8Z1POjSmtFvbIupe/xRP6Ok=;
 b=HlY6lkBSB3nHcHvH4tw3mmDpfSgjXHRwO1PMY3Fy2kn+rIvl6qHdgWS3c9tJpKvdGnpTWp125urfDkj2Urwc+quXUy08iurzesLS6liXd+OLPsunoISoa/WdC0UVt93PPW/KGqkT0KQP0BlcKXKICp96XamcZmDZ13dQ58Iq0JrNmx3a/sTK/k94qhszgWOTWlpTrhSD7BDF2D9OhOqvMXDi9J6zvc6RUAKAROMo+D1QTphjSQdUMzR1LbMgUx4pGHaskF7xM7Uj3Dn86qIEsLyXem6Xhqn/9zd1v1rVeOF2qH/q/D3BnO2oP7j/ClJC2/GqsjvbwGONvknt2l+BzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3113.namprd12.prod.outlook.com (2603:10b6:5:11b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 17:19:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 17:19:11 +0000
Date:   Mon, 2 Nov 2020 13:19:09 -0400
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
        <mona.hossain@intel.com>, Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201102171909.GF2620339@nvidia.com>
References: <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com> <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com> <20201030204307.GA683@otc-nc-03>
 <87h7qbkt18.fsf@nanos.tec.linutronix.de>
 <20201031235359.GA23878@araj-mobl1.jf.intel.com>
 <20201102132036.GX2620339@nvidia.com> <20201102162043.GB20783@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201102162043.GB20783@otc-nc-03>
X-ClientProxiedBy: MN2PR01CA0012.prod.exchangelabs.com (2603:10b6:208:10c::25)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR01CA0012.prod.exchangelabs.com (2603:10b6:208:10c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 17:19:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZdU5-00FIC9-Gk; Mon, 02 Nov 2020 13:19:09 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604337557; bh=CUGbF3EC9mhBBWFzgbgI8Z1POjSmtFvbIupe/xRP6Ok=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=XBStnYkfy12+iKEesNZouO20IlKli4THIMphcLNCXQJIgU3A0rE1O2wkzbsC4j44K
         Bi5aXfTpGs+1LuGVf/pEixXJvE6LvMskHLP8hykMW13jKCu/EoPg+4lN4duxD3P/Z8
         0/v8kc77C2VOtvc9be/A81ORRIQSDWfY3tgZZDhjesBxRc4pIHGOyVi+sd1ak9MsgO
         BeA2DmYpR79+aVStH1cw0gGvQMs8WG3dSLSBEwWuh1zPHWPXiP6qMP3prJh0DH00jd
         NX4t36t40qhuZkztB1AcbyRFyxO6vX63EmeY2jB5Phvja86gxz86Q4gGjyBfLlqOAJ
         Lqp8tBkgKDUOQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 08:20:43AM -0800, Raj, Ashok wrote:
> Creating these private interfaces for intra-module are just 1-1 and not
> general purpose and every accelerator needs to create these instances.

This is where we are going, auxillary bus should be merged soon which
is specifically to connect these kinds of devices across subsystems

Jason
