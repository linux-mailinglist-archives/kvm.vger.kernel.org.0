Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9DA2A4565
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 13:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgKCMoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 07:44:07 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:49636 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgKCMoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 07:44:06 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa150940000>; Tue, 03 Nov 2020 20:44:04 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 12:44:00 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Nov 2020 12:44:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWCa2CQQc3+JaU/g1mS9qZZbL3t1JcQ+v+npaNe/8l/CAqgm+/pfk3wJj1YrkeYkqXEln5f+1ChadqgAOmgckRtUf/yL5kfFSbmxm8gARLlMHMnATLxztaCBUsOtHKImvX+P1w4dmO+RmlSekOOYtS+RNyP28MNABQCVCw5vprMXlW0gzAMNgqF4XNTJs0kSpXvgyl6QvM2wU6LV02vOdDiuo9s7jN8w5/gXE4WZ8ktgJDa2V7DQk3kxH8I5vv2YJHlknyQnDT26Vyff2sji1LYKfcLPmGPgGCJhQsw2DrWMOvPAw1fozyrdQ78K3WmBUgzYhvguvb0RLtToASQTYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VITmViDD5s5KksrgEClyFBFCt+4V1E7TiSIsnAbSL/8=;
 b=LqlaPXlcPHJho6F5ZBs7uIX+hW1p1/gsXF9avoXt55GEjX5RLRjttJsElaoQRBbVp3E6hLMQ9jZ2NWQN5kGNs7aU4cgGrJhwGpWo13lH84ipETYm5Yvyn1S3n32fzv6zjU0C/GlLvVyk8dDe9a17yQOvyrGDxoI1zjTcrsRrlk9oH1D6Z2oz3pijk14Gb2eOZbX+hTDlSC2xHcb+cK0+LHTRSWYhFkZsXLTgoEUoAy1nKdqouuBVMbPL8ipt+FCMWyIPltVYvQ+LTTR7B9EbFbadhRy8PiRGKI5/lUXI3rhNaw6O4ypD98c1BGkmT9P5bssTcTwvlsIc20t7kNPM8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1435.namprd12.prod.outlook.com (2603:10b6:3:7a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 12:43:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 12:43:52 +0000
Date:   Tue, 3 Nov 2020 08:43:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201103124351.GM2620339@nvidia.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR0102CA0005.prod.exchangelabs.com
 (2603:10b6:207:18::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0005.prod.exchangelabs.com (2603:10b6:207:18::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 12:43:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZvfD-00FtP6-3p; Tue, 03 Nov 2020 08:43:51 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604407444; bh=VITmViDD5s5KksrgEClyFBFCt+4V1E7TiSIsnAbSL/8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=CJNiQ2y7edfB+SutsDr6bjWrEdovPBeRUU+TYSMbKyU3rpm2kTcO2gJGq4G55hcLN
         X1XQAkhvZLIpUsmaweQiZuakArT9GyU3bcIeIo0BCvItU9i0NPZsunOaJ2jVASXcgH
         knuCyUTvnXeNSs99s9HIu1xX3+A4TjS4fMy3VQTRrUF9FggSJ9KK06MLD9w9QSAK7T
         7Lot1KjIjwyqubbA9Bsoa6wr3SbCb1YMla4nV5VqArfAHzjq7sAw2ZRsQMR+J99PN4
         WENrlQaUh1eel+I1f77X+QRZMAli2lYsswoKsCyHDpwhIRlQ+0XlnsVdB7iroAornT
         AZ3gcTbtZyUdw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 02:49:27AM +0000, Tian, Kevin wrote:

> > There is a missing hypercall to allow the guest to do this on its own,
> > presumably it will someday be fixed so IMS can work in guests.
> 
> Hypercall is VMM specific, while IMS cap provides a VMM-agnostic
> interface so any guest driver (if following the spec) can seamlessly
> work on all hypervisors.

It is a *VMM* issue, not PCI. Adding a PCI cap to describe a VMM issue
is architecturally wrong.

IMS *can not work* in any hypervsior without some special
hypercall. Just block it in the platform code and forget about the PCI
cap.

Jason
