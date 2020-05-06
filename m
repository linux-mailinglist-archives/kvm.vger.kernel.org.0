Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C557A1C6E5C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 12:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgEFK1p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 May 2020 06:27:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:29055 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbgEFK1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 06:27:44 -0400
IronPort-SDR: ag+EIYoBR4TVmXtX0WzlfT7BJzQlj/KzLh3belSJjnNk++1+b7qalEMpUjPj9Q2HgHiMIYOs1P
 5MrsgL/O6jow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 03:27:44 -0700
IronPort-SDR: GUoiCivGoWEh00L1AYi7caXVsRR8Ir6+hS6yJ7Kdnc1B/DhsaZ5KbxJl3siUuW2Zssx26Lc+dC
 i6VhSvMUWXgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="369757094"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga001.fm.intel.com with ESMTP; 06 May 2020 03:27:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 May 2020 03:27:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 03:27:43 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 May 2020 03:27:43 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.210]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.95]) with mapi id 14.03.0439.000;
 Wed, 6 May 2020 18:27:40 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Dey, Megha" <megha.dey@linux.intel.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
Thread-Topic: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
Thread-Index: AQHWGDVoji+pYTNAZUCFs9wcRhPwDaiGoCsAgAy5aQCAAyNRgIAABFYAgAABv4CAABuEAIAAxfiAgAOJvpA=
Date:   Wed, 6 May 2020 10:27:40 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D903AED@SHSMSX104.ccr.corp.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
 <20200423201118.GA29567@ziepe.ca>
 <35f701d9-1034-09c7-8117-87fb8796a017@linux.intel.com>
 <20200503222513.GS26002@ziepe.ca>
 <1ededeb8-deff-4db7-40e5-1d5e8a800f52@linux.intel.com>
 <20200503224659.GU26002@ziepe.ca>
 <8ff2aace-0697-b8ef-de68-1bcc49d6727f@linux.intel.com>
 <20200504121401.GV26002@ziepe.ca>
In-Reply-To: <20200504121401.GV26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, May 4, 2020 8:14 PM
> 
> On Sun, May 03, 2020 at 05:25:28PM -0700, Dey, Megha wrote:
> > > > The use case if when we have a device assigned to a guest and we
> > > > want to allocate IMS(platform-msi) interrupts for that
> > > > guest-assigned device. Currently, this is abstracted through a mdev
> > > > interface.
> > >
> > > And the mdev has the pci_device internally, so it should simply pass
> > > that pci_device to the platform_msi machinery.
> >
> > hmm i am not sure I follow this. mdev has a pci_device internally? which
> > struct are you referring to here?
> 
> mdev in general may not, but any ADI trying to use mdev will
> necessarily have access to a struct pci_device.

Agree here. Mdev is just driver internal concept. It doesn't make sense to
expose it in driver/base, just like how we avoided exposing mdev in iommu
layer.

Megha, every mdev/ADI has a parent device, which is the struct pci_device
that Jason refers to. In irq domain level, it only needs to care about the
PCI device and related IMS management. It doesn't matter whether the
allocated IMS entry is used for a mdev or by parent driver itself.

Thanks
Kevin
