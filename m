Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FD02423E4
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 03:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgHLB6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 21:58:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:12362 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLB6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 21:58:53 -0400
IronPort-SDR: EBzl03NnnNKwGnuQQnnKxuKjcsJ7PbI81wXvw0+lL+6mnkJaoRiJrjyL6YRswHnXRVeQcN6/dY
 B1imOTPyfpAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="133396855"
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="133396855"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 18:58:17 -0700
IronPort-SDR: lAC6aKrvlPw0Kj/DZPiPqyAwUEB8zm3svBy1RzHSezNooZ5dnRh2iue8bz0NPEnBWM6J3G1oMa
 By5SKE6AaSEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="495351503"
Received: from orsmsx601-2.jf.intel.com (HELO ORSMSX601.amr.corp.intel.com) ([10.22.229.81])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2020 18:58:16 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 18:58:16 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 18:58:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Aug 2020 18:58:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTJBb0YJprtkadEsP5eSZFZQMIp7+5bFHR4K51lurGqkQAgKcqvA7ZLqFJLTmk4TgGcBv8MBOAN9zY/DXIGGrn3pp5Lg2LPF3v0uHShEJqaY6tlTH/dvUCAircn55FZN6nXfg+u8w0xgdAzV815atIAn3ANFP5IF3Og5VpaWborDznyUpVc5VYYqpX0fSB7fN+hT7tAhRSC5GaIp1t7XG1b9pf+7xxv7qcpMwH9WQrLJkFlbbpzSRJXAJRrzh2nOjvkvg4g9M1NQr5FNlB2VKK0O/qJgBNdqCec+a04UM+nDLsipB8SWlJT8+gmZJQI3qbVNnRb3fv3RzOmgchRmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEHf6gnbMJHegtQeOQU7H2PySW3clwWygNNbCgQZMfI=;
 b=HFrMwn+NJ75NyP2X3pcVur3M0y7wPDF8b2H1KkEtLKq30Xi40gmjmMTbAH1KN42gfRAjqEu/q7PDN6KzXqGa/WhEjCvTvJbBwTwZaYNmOzY4VWqbn449MnzF8bfxxM23i1B3M9bUg6kRI4RDOBj8j3CRdgEkoT3w/krLH/az8FOqaC/CRMUfKI9j7xI6B5Ebqy/NcG/SllNkJ8hwW+dbgcMAIzW08euCG2VGm2MnddpkHls4CnPJqMd2SM6BGu3BxoYJfL6cICpUwVnY7wXKBuk5BXrq2mHJ16HoG/M1GSoefzUFmhMJfpzADUhcBCC/sHMEpdQDXUysss4+FGdvKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEHf6gnbMJHegtQeOQU7H2PySW3clwWygNNbCgQZMfI=;
 b=OKrEkIY/OWzlW5RDgj3aq9s7wfKxwPdokU+4GpEP+h5bZyd36EDjpinf+gTjVkp60vsse27kEZtLn64wriDtlxRJyiaiideE9bizVoqqS/ixQlxx5p46kpQarsciNmVkZXZoY4KUGyDC6zrYsSQfwNJEjbqMb95lY1XsvYGrmnE=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 12 Aug
 2020 01:58:00 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3261.025; Wed, 12 Aug 2020
 01:58:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
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
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIACZAIAgACUIGA=
Date:   Wed, 12 Aug 2020 01:58:00 +0000
Message-ID: <MWHPR11MB16451E4BEC7BF29C241FD69C8C420@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
        <20200721164527.GD2021248@mellanox.com>
        <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
        <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
        <20200807121955.GS16789@nvidia.com>
        <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200811110036.7d337837@x1.home>
In-Reply-To: <20200811110036.7d337837@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c27bae72-9e89-46df-dc2c-08d83e632489
x-ms-traffictypediagnostic: MW3PR11MB4764:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB476469C7D7294EC1D239E1178C420@MW3PR11MB4764.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(7416002)(110136005)(86362001)(66446008)(66556008)(66476007)(26005)(71200400001)(76116006)(66946007)(52536014)(64756008)(83380400001)(55016002)(7696005)(54906003)(33656002)(8676002)(478600001)(9686003)(8936002)(316002)(6506007)(5660300002)(2906002)(4326008)(186003);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27bae72-9e89-46df-dc2c-08d83e632489
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 01:58:00.7004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrN90VF86erUqB3iyTa6QbzUBfQyXR75gCZxLJh6miqM0Rkqs9HkonslZmLaqfAN0Lpr4rrfuBC5LdUScRCIYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, August 12, 2020 1:01 AM
>=20
> On Mon, 10 Aug 2020 07:32:24 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, August 7, 2020 8:20 PM
> > >
> > > On Wed, Aug 05, 2020 at 07:22:58PM -0600, Alex Williamson wrote:
> > >
> > > > If you see this as an abuse of the framework, then let's identify t=
hose
> > > > specific issues and come up with a better approach.  As we've discu=
ssed
> > > > before, things like basic PCI config space emulation are acceptable
> > > > overhead and low risk (imo) and some degree of register emulation i=
s
> > > > well within the territory of an mdev driver.
> > >
> > > What troubles me is that idxd already has a direct userspace interfac=
e
> > > to its HW, and does userspace DMA. The purpose of this mdev is to
> > > provide a second direct userspace interface that is a little differen=
t
> > > and trivially plugs into the virtualization stack.
> >
> > No. Userspace DMA and subdevice passthrough (what mdev provides)
> > are two distinct usages IMO (at least in idxd context). and this might
> > be the main divergence between us, thus let me put more words here.
> > If we could reach consensus in this matter, which direction to go
> > would be clearer.
> >
> > First, a passthrough interface requires some unique requirements
> > which are not commonly observed in an userspace DMA interface, e.g.:
> >
> > - Tracking DMA dirty pages for live migration;
> > - A set of interfaces for using SVA inside guest;
> > 	* PASID allocation/free (on some platforms);
> > 	* bind/unbind guest mm/page table (nested translation);
> > 	* invalidate IOMMU cache/iotlb for guest page table changes;
> > 	* report page request from device to guest;
> > 	* forward page response from guest to device;
> > - Configuring irqbypass for posted interrupt;
> > - ...
> >
> > Second, a passthrough interface requires delegating raw controllability
> > of subdevice to guest driver, while the same delegation might not be
> > required for implementing an userspace DMA interface (especially for
> > modern devices which support SVA). For example, idxd allows following
> > setting per wq (guest driver may configure them in any combination):
> > 	- put in dedicated or shared mode;
> > 	- enable/disable SVA;
> > 	- Associate guest-provided PASID to MSI/IMS entry;
> > 	- set threshold;
> > 	- allow/deny privileged access;
> > 	- allocate/free interrupt handle (enlightened for guest);
> > 	- collect error status;
> > 	- ...
> >
> > We plan to support idxd userspace DMA with SVA. The driver just needs
> > to prepare a wq with a predefined configuration (e.g. shared, SVA,
> > etc.), bind the process mm to IOMMU (non-nested) and then map
> > the portal to userspace. The goal that userspace can do DMA to
> > associated wq doesn't change the fact that the wq is still *owned*
> > and *controlled* by kernel driver. However as far as passthrough
> > is concerned, the wq is considered 'owned' by the guest driver thus
> > we need an interface which can support low-level *controllability*
> > from guest driver. It is sort of a mess in uAPI when mixing the
> > two together.
> >
> > Based on above two reasons, we see distinct requirements between
> > userspace DMA and passthrough interfaces, at least in idxd context
> > (though other devices may have less distinction in-between). Therefore,
> > we didn't see the value/necessity of reinventing the wheel that mdev
> > already handles well to evolve an simple application-oriented usespace
> > DMA interface to a complex guest-driver-oriented passthrough interface.
> > The complexity of doing so would incur far more kernel-side changes
> > than the portion of emulation code that you've been concerned about...
> >
> > >
> > > I don't think VFIO should be the only entry point to
> > > virtualization. If we say the universe of devices doing user space DM=
A
> > > must also implement a VFIO mdev to plug into virtualization then it
> > > will be alot of mdevs.
> >
> > Certainly VFIO will not be the only entry point. and This has to be a
> > case-by-case decision.  If an userspace DMA interface can be easily
> > adapted to be a passthrough one, it might be the choice. But for idxd,
> > we see mdev a much better fit here, given the big difference between
> > what userspace DMA requires and what guest driver requires in this hw.
> >
> > >
> > > I would prefer to see that the existing userspace interface have the
> > > extra needed bits for virtualization (eg by having appropriate
> > > internal kernel APIs to make this easy) and all the emulation to buil=
d
> > > the synthetic PCI device be done in userspace.
> >
> > In the end what decides the direction is the amount of changes that
> > we have to put in kernel, not whether we call it 'emulation'. For idxd,
> > adding special passthrough requirements (guest SVA, dirty tracking,
> > etc.) and raw controllability to the simple userspace DMA interface
> > is for sure making kernel more complex than reusing the mdev
> > framework (plus some degree of emulation mockup behind). Not to
> > mention the merit of uAPI compatibility with mdev...
>=20
> I agree with a lot of this argument, exposing a device through a
> userspace interface versus allowing user access to a device through a
> userspace interface are different levels of abstraction and control.
> In an ideal world, perhaps we could compose one from the other, but I
> don't think the existence of one is proof that the other is redundant.
> That's not to say that mdev/vfio isn't ripe for abuse in this space,
> but I'm afraid the test for that abuse is probably much more subtle.
>=20
> I'll also remind folks that LPC is coming up in just a couple short
> weeks and this might be something we should discuss (virtually)
> in-person.  uconf CfPs are currently open. </plug>   Thanks,
>=20

Yes, LPC is a good place to reach consensus. btw I saw there is=20
already one VFIO topic called "device assignment/sub-assignment".
Do you think whether this can be covered under that topic, or
makes more sense to be a new one?

Thanks
Kevin
