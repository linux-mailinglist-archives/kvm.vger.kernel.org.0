Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6074A28881E
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388255AbgJIL5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 07:57:43 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10414 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732480AbgJIL5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 07:57:43 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f804ffe0000>; Fri, 09 Oct 2020 04:56:46 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 11:57:42 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 11:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvrUxQPlXnyV9CeIGniPf+V8s/rP7ADVK4e66aaSJTdrx+dab1VgJTjCXZjUFUwA+f4LPFL6hIJVsjrAG7b2J+JZE8LJkhI00eEJGgXARyhAu6pT9WuixMrFSgGTgNqGXQszl0fJgQ+26vscv1TFtdbyFx7wDjmXo0Fdmu2hug65yDIVyIE09SxauyE7ZmYTTvvPY9s0PftFbnXRDLXv+ERFJNQXVEZER0VcMFnzjg/owv4axEDCFjZNGkrEO5yOtfbrL17YGmS1bnZ8QaR4kRidIaUzsEWaU+r91JoiHcT4Igsui2ujotoLiMYj2ALJTaE8DPGaxNQv3Bv42vKqeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuNFOkVvS+Zf5/DO+Q6L2tltqT555sMBAanpEkNoGBc=;
 b=IK5mc+heraa1qAiuP/+P59nvpRfCEIGJ11r/LwnDJfz92xi3FPRPjLTkDRCd8AuIwFQw9FLJJRRIGz6+BT4vLqv/No5CwoNqjQvVKlFja4wXCzrtNAgpHJqCafz0jq4UHl5wsBZM6ED7r1ljMRKTpq9H3eQo+p5bTlkJ4mwE4E3D1DwX/K7CZQV6/jykRlJwHCkaAfOlQWDsvqgdzcRE9wB1Hz752P8gSBiZ2m8mcF8gfKgEoIaSNUBKOUz87v8TS522szv0wbtJxJ/MopQBl/5pWfGCtTQYUE1zg/7HVe6JTbZahApt/9lhFSX8Q3h3ItIcHNRv4+Iw3kw7kKZ/vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 11:57:40 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3455.026; Fri, 9 Oct 2020
 11:57:39 +0000
Date:   Fri, 9 Oct 2020 08:57:37 -0300
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
Message-ID: <20201009115737.GI4734@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com>
 <20201009012231.GA60263@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201009012231.GA60263@otc-nc-03>
X-ClientProxiedBy: MN2PR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:208:237::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0041.namprd15.prod.outlook.com (2603:10b6:208:237::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Fri, 9 Oct 2020 11:57:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kQr1l-001xP1-CZ; Fri, 09 Oct 2020 08:57:37 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602244606; bh=vuNFOkVvS+Zf5/DO+Q6L2tltqT555sMBAanpEkNoGBc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=BbrNDoVMJ4Cn+J3fVi80gJ7wltUQTj5GNM+ZoauKPqtyhvW4N7B4POQhFOYMpDJNu
         GB6jHCpRGuylid+lYjvfPAYHN1mTZWUS9xreBLlbYVind/S3bed6ct+BitDRbicRPf
         EpBgCWHg7hhmJETSrkAGw/ydaMjtcXiSvkIqClKcbAKtchbHu+t/gmUirLiU9gVleT
         5VN3miLPZUScCtdcga+9Bql5Kt/Q82rRL4ZclaO5sE0KdyBLOte3Glo0mEeKHM3+nj
         8bjrTD4a8yzzulyiexmAJJQfRHwXuRaSDANzXQB4+YxMu43Wy8yMIXERy3cSDHgR6O
         GQlwXjZ3iWoCA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08, 2020 at 06:22:31PM -0700, Raj, Ashok wrote:

> Not randomly put there Jason :-).. There is a good reason for it. 

Sure the PASID value being associated with the IRQ make sense, but
combining that register with the interrupt mask is just a compltely
random thing to do.

If this HW was using MSI-X PASID would have been given its own
register.

Jason
