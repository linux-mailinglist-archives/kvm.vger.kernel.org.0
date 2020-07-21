Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DBB228CE8
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 01:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbgGUXzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 19:55:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:11821 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbgGUXzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 19:55:00 -0400
IronPort-SDR: 6BuOvOYqi2bE2tha/K4frxEQqns6rNcIxaX7CBEbBI9dz6nUiF9rnXVssCO5pXdPx+XoOQvQQy
 kscCTF3557eQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="150226648"
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="150226648"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 16:54:59 -0700
IronPort-SDR: Vxj2V1kF4mXHjYzK3GX1GjPgfBnFJ4QJJ5iDo4TP2PDxsHsR8DUVFfObCY9HBhlZqgg5z0pqXQ
 m7GdNIeEw+rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="288098696"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2020 16:54:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jul 2020 16:54:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Jul 2020 16:54:58 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 Jul 2020 16:54:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jul 2020 16:54:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeENuXiWMai6O8gc4cuk0j3QqkNcNExEPds8h9FJaYNLfe8RAScBtCLC+W6gHDUCpurkEhmLZcfaxgtJshXxp6W7Ej1ATaazUSNioc5XVUIzlf0zSRbT5PQAWo7WEmGAY+1m54zJMBjKYUxtAgAwRYDxZ8imhKeGeeegcoSnBodd8ryJQxp6voiMBjEsHaHEQWq2+Vasx++t04cX6nMQ14jIW/QHvvBXiE3dLW++oykAvef/Om1nr9JBE1H7+G9r8IxzFG5Zrj8KK8MIsEo5RheuLd0+3JaBEK1zC/AlEsF9vbjh9eymX/d34Jj62mrv0xna4WDDnKGGcAEjfw8AOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNKnetHN5WVuX6pbFeDkKpnEPUw8pE4b4//MXEzKe4E=;
 b=j3QTvXxIWm81J92vhw47HnsvZM66Sz/DrvxIJyrn+ahzx9bM/y6qNTHvEG6I0KVAf1bV6f9BY5FDA8lDd1354k66raVsXVem67wnfMGR+UMhYkocQ4ka4sahmqYNFW9q07QReL+d4w9vcgawPcEyAjOhJ+JPxmnDaKcmVypBXcf5YQbim1Y3SsZbjhbGQLhcaIX/WsDQ2+yxW4WPBDrLqeZ/wuh7LqN1Ue97ewAWpPnEKUopiqeHXXXojqgylr/zzROprA8rdC1uCKuEdjIumNSDofMU7zQGq84L+ZilXStGfaF9Pd1NLXl//xSNNg/YNIygvTwGqprxhAkmCk4tnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNKnetHN5WVuX6pbFeDkKpnEPUw8pE4b4//MXEzKe4E=;
 b=E6ciXfUph9etTqhgIt9H8TPRys71/o/cGXbFvgU1yc3OYA5vigfwFH/u7UyMDnr5qzKraj5JxfHZhL8dYv1v3eILl+dxZJKKxLyeLeFSujP6ehL1XGdV2nkq1SweAgnJpOBeipgC9gV2+pQJdZs/ADkIhvbrnUEfhvYDkCDaq4Y=
Received: from CY4PR11MB1638.namprd11.prod.outlook.com (2603:10b6:910:e::14)
 by CY4PR11MB0055.namprd11.prod.outlook.com (2603:10b6:910:76::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.26; Tue, 21 Jul
 2020 23:54:49 +0000
Received: from CY4PR11MB1638.namprd11.prod.outlook.com
 ([fe80::84de:bd28:e614:691e]) by CY4PR11MB1638.namprd11.prod.outlook.com
 ([fe80::84de:bd28:e614:691e%12]) with mapi id 15.20.3195.025; Tue, 21 Jul
 2020 23:54:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Jiang, Dave" <dave.jiang@intel.com>
CC:     "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
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
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8A=
Date:   Tue, 21 Jul 2020 23:54:49 +0000
Message-ID: <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
In-Reply-To: <20200721164527.GD2021248@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 667ab292-1dca-4ca5-bf7d-08d82dd1745a
x-ms-traffictypediagnostic: CY4PR11MB0055:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB005580ECFC3ADA894F3151F38C780@CY4PR11MB0055.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUsgjC26U+etxCDs1RDVt2s2T3PyXC8OMGeXIE2gJdal5Ny7PMCMKDvM1t0qjvpanWSoh9cBr4nLcTEcmoPl1NBasL3Y0DHc51gJGLlscbNS3Z7iq/NYfj+E4HF5PZsCZ6YgCkoIqQge0wExQjGQSofmutLJlHg1XGITIgLcgwndlrMxw7FEa9tJo8N/tYm2CIHMCO1JO3TXfAZBU2o8B5kILFeYEMF+xSg9Qh+1w2TwldCs+VkclKmhPpC3y0ZvLcu3FFYsPcC56tGbGBIlSZVXXkqz0U7+h0PU/uB9ZIBuejDCHUn+R+hx/gpodrJ2dCkS4VIpgOtbZVu3XUu/nWfP+2r+yYZqxCSjlgbjNKugyP34so/5Ynkvcwt2G3/VnUfB7oK/drfRMZDnzMNKCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1638.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(86362001)(6506007)(7696005)(64756008)(66946007)(66476007)(66556008)(76116006)(66446008)(55016002)(966005)(316002)(6636002)(52536014)(26005)(5660300002)(478600001)(186003)(7416002)(54906003)(33656002)(2906002)(8936002)(9686003)(71200400001)(8676002)(110136005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aaixaTtn3WR2Z4doep1xw56fynZk6mpixeNx2JVRd3HAgtbWaaWDmr/tv2r8MHrBjj7tgYO9gOHfw+byl8m5f2iLhoiY4z5lWFUgG87EK5qgRQZyND4y3a8Hg4kT72jGeL5D+zzxPsrmcJ+PFbb8jm7N9x7pBYgDwryIeH15qebItDdbelbEbig79fZtGQoiUDlQvDkpWQb1LZgaOSlXelD7ZJNfLRoKl4TEUxwg2VtQwDx5ML5hwa0L/5MnyYf0jUU26T8FHKakg4ADHo/8qKiNOauPXaIUtxuSzF4eZtlD0fr7Ia7Z6/OV/Q9pjQEasuFWObDKCIdRrfHCA3pLSoRHAhydhyHNq0+Mw262jiC8zRP404TB0w48CnCwDJpCPadv/YLaK9t/4OhUTI9lN8e0ioflxgUaaMmUsxKcYzI70l//wzEXJXX0rNPAXFghPvg7P8UgQd0hjGMTx5M3Vv73i3edQq1ZhzkismdpjzKmQ/SyMLPFkTeGFS7dK4j3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1638.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667ab292-1dca-4ca5-bf7d-08d82dd1745a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 23:54:49.3765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvivK2dui8fjYZ93YAFYhXcTRkARZBWSCQB0m7Afa/Fe9o1ZjuogeFPhdmaKd26ZA+halQPNRoRUD+7BINsDfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0055
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@mellanox.com>
> Sent: Wednesday, July 22, 2020 12:45 AM
>=20
> > Link to previous discussions with Jason:
> > https://lore.kernel.org/lkml/57296ad1-20fe-caf2-b83f-
> 46d823ca0b5f@intel.com/
> > The emulation part that can be moved to user space is very small due to
> the majority of the
> > emulations being control bits and need to reside in the kernel. We can
> revisit the necessity of
> > moving the small emulation part to userspace and required architectural
> changes at a later time.
>=20
> The point here is that you already have a user space interface for
> these queues that already has kernel support to twiddle the control
> bits. Generally I'd expect extending that existing kernel code to do
> the small bit more needed for mapping the queue through to PCI
> emulation to be smaller than the 2kloc of new code here to put all the
> emulation and support framework in the kernel, and exposes a lower
> attack surface of kernel code to the guest.
>=20

We discussed in v1 about why extending user space interface is not a
strong motivation at current stage:

https://lore.kernel.org/lkml/20200513124016.GG19158@mellanox.com/

In a nutshell, applications don't require raw WQ controllability as guest
kernel drivers may expect. Extending DSA user space interface to be another
passthrough interface just for virtualization needs is less compelling than
leveraging established VFIO/mdev framework (with the major merit that
existing user space VMMs just work w/o any change as long as they already
support VFIO uAPI).

And in this version we split previous 2kloc mdev patch into three parts:
[09] mdev framework and callbacks; [10] mmio/pci_cfg emulation; and
[11] handling of control commands. Only patch[10] is purely about
emulation (~500LOC), while the other two parts are tightly coupled to
physical resource management.

In last review you said that you didn't hard nak this approach and would
like to hear opinion from virtualization guys. In this version we CCed KVM
mailing list, Paolo (VFIO/Qemu), Alex (VFIO), Samuel (Rust-VMM/Cloud
hypervisor), etc. Let's see how they feel about this approach.

Thanks
Kevin
