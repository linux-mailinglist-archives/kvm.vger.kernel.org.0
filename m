Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF802AF5CD
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgKKQJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 11:09:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:60998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKKQJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 11:09:32 -0500
IronPort-SDR: CHnRG5mK8ua0OawsEd3hb4z+8VmUmTvV8Z5SyM90QXNibLLtzJxQUJMSMUe7/b/jUV0fsG4mLT
 Cdpz+ehEo4rg==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="157948171"
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="157948171"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 08:09:25 -0800
IronPort-SDR: EW2Gn5lekgEEaWvuCQ3EyLMVRtnPSYUNZxkgUPKKhjF88REFxVtROUsKgX+GB191bScIonsPAO
 a3PjIGKoDDDg==
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="356697354"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 08:09:24 -0800
Date:   Wed, 11 Nov 2020 08:09:22 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201111160922.GA83266@otc-nc-03>
References: <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
 <20201111154159.GA24059@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111154159.GA24059@infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 03:41:59PM +0000, Christoph Hellwig wrote:
> On Sun, Nov 08, 2020 at 07:36:34PM +0000, David Woodhouse wrote:
> > So it does look like we're going to need a hypercall interface to
> > compose an MSI message on behalf of the guest, for IMS to use. In fact
> > PCI devices assigned to a guest could use that too, and then we'd only
> > need to trap-and-remap any attempt to write a Compatibility Format MSI
> > to the device's MSI table, while letting Remappable Format messages get
> > written directly.
> > 
> > We'd also need a way for an OS running on bare metal to *know* that
> > it's on bare metal and can just compose MSI messages for itself. Since
> > we do expect bare metal to have an IOMMU, perhaps that is just a
> > feature flag on the IOMMU?
> 
> Have the platform firmware advertise if it needs native or virtualized
> IMS handling.  If it advertises neither don't support IMS?

The platform hint can be easily accomplished via DMAR table flags. We could
have an IMS_OPTOUT(similart to x2apic optout flag) flag, when 0 its native 
and IMS is supported.

When vIOMMU is presented to guest, virtual DMAR table will have this flag
set to 1. Indicates to GuestOS, native IMS isn't supported.
