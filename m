Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5E72AAE4A
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 00:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgKHXaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 18:30:05 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:49445 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgKHXaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 18:30:05 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa87f750000>; Mon, 09 Nov 2020 07:30:02 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 8 Nov
 2020 23:29:56 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 8 Nov 2020 23:29:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFM41oCMdDVZ445dDT940TMPWdoE3/AhYApVqm0Eu5V8g5bIwDcfJVY9BslUatdIisH7YihMtAEdwxXQCtNaA8lgRjivNVHcZxZcwkD7bg6ETUgS2143nhpnE8BHWvRVMegnLALtt/4MWpM9ioJEg5Rfm4MfM0Ohp6LzyIeYxXgKp3HzWOTevIdm+83jEx9eYZxmB8ZJWoe51juhro0p2eFac0+nMPCsf5L3fp2Y6BzGlXwwfCX326vOvTcuB1HraaHKB9Sdju7yCiXI0/4i4qGrqnMbW1iGU2N6GbS5eL/CEmVDlOxaKhwX9FMqwoojLdT/zY6ZTEhZW9LDkMBn9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFgRLM6watJwTiwnke+62Dh2EIn6GoULkXWrRreQdpE=;
 b=VNxOCvjLXiRcvM+SmkZKwMfOqYHNF096Az4eurCJHgYkvAN9yfnCvDRw8DCiWmnVSr1MIbOoGjEC1KguIPDCGHaJuiPEtNIZYqA70VAZw5JEL5/jZ0RzW+rBsfnT3RsEOfsr9qzile+MlUhUw6vBuoTifC+9rITmaRbf9TERhKJHfvf/qlanuW/9gIUO4AZv9Spq/u5NF8oYGKi+rZhvDafAT6W9ivjfGNyqxwKw3zN1cbJYa2S45w7lPA/hC6cfSFdTQKmxvSMNpLmJynCmtk9lNhV6R6ACRI6o2zUMBcwpq8G1qEymdniRKW7P0qosdf8kUee8SRmui4WVNkXqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1147.namprd12.prod.outlook.com (2603:10b6:3:79::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Sun, 8 Nov
 2020 23:29:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Sun, 8 Nov 2020
 23:29:52 +0000
Date:   Sun, 8 Nov 2020 19:29:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201108232950.GC2620339@nvidia.com>
References: <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
 <87h7pzjwjy.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87h7pzjwjy.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: MN2PR17CA0006.namprd17.prod.outlook.com
 (2603:10b6:208:15e::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR17CA0006.namprd17.prod.outlook.com (2603:10b6:208:15e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sun, 8 Nov 2020 23:29:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kbu86-001jcK-SX; Sun, 08 Nov 2020 19:29:50 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604878202; bh=oFgRLM6watJwTiwnke+62Dh2EIn6GoULkXWrRreQdpE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=ZpFZAmz5dJDkdukggPBz2dGQjyxH7gY6djLfuyozmD9335k/zB9d1380zLyHMwWB2
         m9kGEJZLPA8h+X0lAAbPba4g4THLx9bX/IfkgH2SO+RGlw+kzYqX6N9f1OvGg15y4+
         FEJY3WMLf3IQBFHDnbOXi4xh0c5z/qv60p17+LZbabEjrb1lEtUtJyXStSPhBDQD6n
         ij29Ecl9qvM4JtJxI6OSqyzZFG2aNRYU4l35K5QX6v6+LqS/WTXbS0gpLoVOnC/NJh
         pADLfTMAHxukfYEfM8siaIXOS4Igx9Q7lsXGVUaBG5R1cSkPpcVoC6iyiDrinybvxM
         N+TWtrSKdHeFA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08, 2020 at 11:47:13PM +0100, Thomas Gleixner wrote:

> OTOH, what's the chance that a guest runs on something which
> 
>   1) Does not have X86_FEATURE_HYPERVISOR set in cpuid 1/EDX
> 
> and
> 
>   2) Cannot be identified as Xen domain
> 
> and
> 
>   3) Does not have a DMI vendor entry which identifies the
>      virtualization solution (we don't use that today, but
>      adding that table is trivial enough)
> 
> and
> 
>   4) Has such an IMS device passed through?
> 
> Possible, yes. Likely, no. Do we care?

This is exactly my thinking too. IMS is still very new, if we add some
platform flag to disable it then yes there are broken cases but enough
options for an unlucky user to deal with it:

 - Have their VMM set X86_FEATURE_HYPERVISOR
 - Updating the VMM to set the global disable flag
 - Add some "disable_subdevice_msi" kernel comand line flag in the guest

In exchange we get a much cleaner architecture for the next 10 years..

Jason
