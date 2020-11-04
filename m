Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326182A5D2E
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 04:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgKDDlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 22:41:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:16420 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgKDDlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 22:41:44 -0500
IronPort-SDR: Hp+l6EvQlQZipCvzwWTQMQXMDPk8Bc06YMCxigwEjdrlIJrCiO/ZTb3TroVpJGKdMXS7ugg1yv
 DrpmvSQD9q5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="169298660"
X-IronPort-AV: E=Sophos;i="5.77,449,1596524400"; 
   d="scan'208";a="169298660"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 19:41:43 -0800
IronPort-SDR: 1w/deEhnq1qlKzypwQ2DFh+Ph1d3EC3xqVgCSaWtW1vVLKH4KHCV1zKhGNEAAiLT7+J00SojOF
 s8iZTZho4REQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,449,1596524400"; 
   d="scan'208";a="363260501"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Nov 2020 19:41:43 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Nov 2020 19:41:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 3 Nov 2020 19:41:38 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 3 Nov 2020 19:41:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ce85supRDPMKcRGvYwzuGtUkxVnKodC3QLJx0iWAuaUoQ004LbtHA09jzfoOLoqzdtUA1I+uAE3n3bPh4QL1E/dPfOKVDOWEjnNPSikBzoqzK6Zxv9PCbstG2KBM3hCqrerZx321vyDdjuYnosRXsm2jF2ctEeLCiAsmZnU/3lcK7P+BBYxgCo4vWc3+e/AdsKAfFHA0FzvL8BhB7uVC0eY+AxYyp52AIhFtiosQGzGBVlj9bAE7RWZBSbhvH87E6kr85EszfQDUDNRZUAC95eKKjFJmlwdbihBIMMca/Nm01u7fJub+EtZZRMtwreQq+ZKIMSV+GTHoKgh5tZFC6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKV6tKPZM+gfFqEaFXYnfMaoDxnTSCfUv9nmCMAmqJI=;
 b=W2o9ABLVXBy4baNmxLWb0GZ/YX3t6zr+/5HOAWe1NMEqWFETYQ7xO/G6CTaCdJl/tVVf7oVTmT7lpj+l18gY0XCjfJB+De5uzm436GQ+IhhaPe8lYKs7n0P2ZefiUTD23RaWOnuIWes3kWT9UkaKALUfAsZ/mbLtuNGgeCja7KRUzKKTWgN2bnsBoiTom/42j7C0siKeSHc+xRuhDBuPksSdArKF+yEH1Gf3o0eRiTmOIDJ6a96/DgNWbn142Uf5W+pP2VSS5lTeRlWPrci8vhj5e0xd36DV76jCJcnESs0S+7lfe2OBwzDn4+RX556SMM0QiJUwgoeZY9tkbi9yZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKV6tKPZM+gfFqEaFXYnfMaoDxnTSCfUv9nmCMAmqJI=;
 b=Ib8ATDtCZhOrY1InnL9VB+oRXhwqMQMGF9E/V6V8vLGEG8DWWpi9PpWPU5z/b8vo2P/7aJPFvmz9i7GxGeEzRIunPd38kSwI7+DIHQfs5uhqOqmNssGZrbZAmSP6C33hQsvQWE9+U/oW3tznOKckUc4Z+WoDD7F0ajG+kemCUoA=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2253.namprd11.prod.outlook.com (2603:10b6:301:52::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Wed, 4 Nov
 2020 03:41:34 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5%8]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 03:41:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
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
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diA=
Date:   Wed, 4 Nov 2020 03:41:33 +0000
Message-ID: <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
In-Reply-To: <20201103124351.GM2620339@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8803bb8-42d2-42f6-a8a1-08d880738694
x-ms-traffictypediagnostic: MWHPR1101MB2253:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB22531083977A71EB814DC1E08CEF0@MWHPR1101MB2253.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8GkBJJU7OBDBjWgyYiUdy4C9POdyJU8f79F25IT4MkV8Miy9RNJQbbcICpIXxVOVXjG8FqwNLq6kNjvUOHmn6yHzWv7S1WQIMIAt+KIUmtw15l+nqNGOeA5D6asOh0iOatJaB1D6SgAUmDcmuDp0yK6w+W2aszWXD6J3ECPg0aYsLP8Po/H5CjamY3upy9Xh5gSJTqNTtozwxCEUIgpJV3WsRX7eVeSjyKXzHnkoOmbDX02JFjgFkx/0MmuHZ8oqONNbtKEZaheWw3iqovHX87kunDYyWYqtRZcqz8KrnIAVdOILY2tYozAn5kywRF3xVp9JSZsONGaCYU4alLJ0Iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(26005)(6506007)(2906002)(33656002)(54906003)(7416002)(186003)(52536014)(478600001)(83380400001)(71200400001)(76116006)(8676002)(64756008)(66446008)(66476007)(4326008)(5660300002)(66556008)(316002)(66946007)(86362001)(8936002)(7696005)(55016002)(9686003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: IDAokuLJkoz9grSwwb+YtQVgxOlFWBwuV3TsTp/NNm16M+U3a6XGtZnWe4QqQ2kA+oTgkOL4YGa8R0209wnZyJbWZN9lo2dlD9OjaSZp9tcaZuV374qQXCcAuXl/je01TcZawb62cfhGbRwb0G9OZdvLjRzEzr3na4kVx1LPOzkeJxk6k9+OEELHMiwrKtpq4iGwXltQx13Fcf7U5WtKqR9KmdQ9ZzCHvqwxuOpZK8+hnTsbfPSgo1UJiGX5AF2EXlzXeQ1flh0VugPoTUfnWu9oXoz3dQwvks9YoRNJq0WU8CUd7X6lfJrXmXPN8X8VKLYiuoc3hm4mnS3YLFu60abtK+0uf/CEDNnjn3gXvZPZCCLa21l4ChkFPv0lf/9oOefoBcPhdwJpWtCJ9mFA1JD4nH8F863GZKhI5+YNaBcpBWWqxBTc75zJtNojQmG2cXHgpDeeWRtEA8kBB+AoqZ1DKDu/jtdg3lggqmwv6ZrmZTzWuwdtiW7w3qFVpX3x9sUl5zEPz2yb9IjAweivkfyiYDOnH3/S+BVVMzlXcFs5DWUlDw1h0U6YoTDLRMPJaLpMiNPMrhbcFnUXfHT5viVdvxzT6Z0ACfq7onPPIXBrVdjoGwE+BmJTjDDDJW8TekfUBgEae0kfbkAB4ygNQw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8803bb8-42d2-42f6-a8a1-08d880738694
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 03:41:33.8679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tOxeakVhu5ZuA8lG7rV2zzCvor2Xj51X7zCYXDXaAS8wBlTJKkx6qo14wfh0dN7rPgfi/UeUFHtvuCJfFOMMQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2253
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 3, 2020 8:44 PM
>=20
> On Tue, Nov 03, 2020 at 02:49:27AM +0000, Tian, Kevin wrote:
>=20
> > > There is a missing hypercall to allow the guest to do this on its own=
,
> > > presumably it will someday be fixed so IMS can work in guests.
> >
> > Hypercall is VMM specific, while IMS cap provides a VMM-agnostic
> > interface so any guest driver (if following the spec) can seamlessly
> > work on all hypervisors.
>=20
> It is a *VMM* issue, not PCI. Adding a PCI cap to describe a VMM issue
> is architecturally wrong.
>=20
> IMS *can not work* in any hypervsior without some special
> hypercall. Just block it in the platform code and forget about the PCI
> cap.
>=20

It's per-device thing instead of platform thing. If the VMM understands
the IMS format of a specific device and virtualize it to the guest, the
guest can use IMS w/o any hypercall. If the VMM doesn't understand, it
simply clears the IMS cap bit for this device which forces the guest to
use the standard PCI MSI/MSI-X interface. In VMM side the decision is
based on device virtualization knowledge, e.g. in VFIO, instead of in=20
platform virtualization logic. Your platform argument is based on the=20
hypercall assumption, which is what we want to avoid instead.

Thanks
Kevin
