Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEBC2B1B82
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKMM5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 07:57:52 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:51758 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgKMM5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 07:57:52 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fae82ce0000>; Fri, 13 Nov 2020 20:57:50 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 13 Nov
 2020 12:57:46 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 13 Nov 2020 12:57:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHflnqkD4g2kVNqyXleBTb55nkrbiNp0y3TyFuqubQeq4jOB0C5oICDWH98+r/raPiCTfBMS3NkTE5BFPdR0WcfzhNCFLOktu8WynPzCtvxPBqYD/SNiDvyBKtqZejvUEINbpXUQRmR4aAQPF6E5rI5lxGeJC4Y8nFQmLPcGfgvbwAwTsDGfQSprREd3IB1Kk6zmz3ei6h6GMNxs/qkYnbRlEz/2osJkUY7XwIv49TasOzgKyiytA/eFXAVGnlyP7GuO58TFtuaJEu8Ag4/GYEuB4RMi+Lt0XSFdNjnmoctUfcXI3Y7VpzWVlUfdn1UoH4HuwgQce0tYowb7ysSyDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88q+NJg8uHj1mjh9JQL6I9Wy/6llGi5MMBDreJZj/Xo=;
 b=eaWpet8bsENllQOH5RC18udyyBgZCiPPK2SfP/ToZI0lCX/oR7cVhMDhgs4zWKed+3cWCL1hIhupSI5uju5bA4Hr9NIRo55EZXk+mEIViHmaT8pLeG/7CH6aa7jfclL1mZxdZ5kHl2u0f31i2fkHmENvgHmiu0QtFR9wpanB4nKtE56DAmCNmSmJyDmoXolmtxjoDgYuXiqwZ6FqFHApyy9BEak6gnVBDgxCwict5BfKqQugyKscUxsq/mtG6cBE/fqUDcow0dd4YCFmxXfGINmdPypnV6m8SHBD1fVDKU6htPMOSTxld4PJJGAE8WHsfLzFQOygazr8ip27omoFUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4578.namprd12.prod.outlook.com (2603:10b6:5:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 12:57:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Fri, 13 Nov 2020
 12:57:43 +0000
Date:   Fri, 13 Nov 2020 08:57:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Bjorn Helgaas" <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Message-ID: <20201113125741.GC917484@nvidia.com>
References: <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:208:2d::45) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR03CA0032.namprd03.prod.outlook.com (2603:10b6:208:2d::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Fri, 13 Nov 2020 12:57:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kdYe5-004PSk-67; Fri, 13 Nov 2020 08:57:41 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605272270; bh=88q+NJg8uHj1mjh9JQL6I9Wy/6llGi5MMBDreJZj/Xo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=T8nzUdlk54dCUyIylx03y9ojHhT1+6tVfO7NoFj2j+DuyA6Fu+Kd3ZdDd4JRQtUkB
         HzWEhWVRhkx74ICBw7ezSc6lMGOJpi2S+qSV15NVx4LHBJTyplsLXizlkXdz5Nprix
         Oq+eMYmcctiypw8rx8jARZuWyYuUbR0Kw4cJK07s55Urhq43sgJtwfvjtz3JVrIO84
         2M1hhB32BipUhQ4ouii8pmHTkNMAcZq7o5YxJc2GDjWaq+J9CSNSZ8YxfTTuH9tkfT
         HcItI47bYnjNWv8tl2IoRkQEy0n+QkT06IBT83RlhYtZwJQkkCKx67QJz6T6UPzM2e
         EwZkEI9L/HsHQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 13, 2020 at 02:42:02AM +0000, Tian, Kevin wrote:

> CPUID#1_ECX is a x86 thing. Do we need to figure out probably_on_
> bare_metal for every architecture altogether, or is it OK to just
> handle it for x86 arch at this stage? Based on previous discussions 
> ims is just one piece of multiple technologies to enable SIOV-like
> scalability. Ideally arch-specific enablement beyond ims (e.g. the 
> IOMMU part) will be required for such scaled usage thus we 
> may just leave ims disabled for non-x86 and wait until that time to 
> figure out arch specific probably_on_bare_metal?

At the very least you need to ensure that
pci_subdevice_msi_create_irq_domain() fails entirely on other
architectures until they can sort out these sorts of issues..

Jason
