Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEEF2AE676
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 03:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgKKCfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 21:35:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:30167 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgKKCfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 21:35:42 -0500
IronPort-SDR: Ap8vW5Umid5jZwBF+t+Hy4hQpCtaAJKzxPb3Io656Iy3jVb444cqLE8Jj5fRvnOe7QnKsRr1ny
 JQ6Wk/uDzoZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="234248852"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="234248852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 18:35:40 -0800
IronPort-SDR: +FJvNCiHpYYVbP0yCKuJ/Wk2vKDNRI4mNCYxCWHJpvdXyEhpF51Vpq5OTIHHAemPqdKnn79Yj9
 necyQ9gnMHlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="356433438"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 10 Nov 2020 18:35:39 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 18:35:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Nov 2020 18:35:39 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 10 Nov 2020 18:35:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBJRJGo2kcK9Jkh87hmwQiPb58DzN0nYAm8dYLZ6WAOp0Kic4cciUSdkNyOYXuYyhVnlFg6ByYV0sjueUivuwnAJUUvWzkto4xMF5uR/5VOPDcDW7JDeqFltdvk9zti9mM4/Z8t1O5FTovrVka9NrBxu0BINYDroow0V8f0tdL8kXe5WzretAExkqXXLytYkXWxSe8VFQlHutjM7JfGiw+VRHCGw/Fms7f/66YkVohAGYO8CO3W1rCg+gMcieUVg0Yv8bk5/jVrUWKlVlaC5+TOmIezC9pPZLBI3rWT3jiD2Beh9FIkVacQURknal9dvHy9wByhSnZ/qpgiK0ua0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdBoeaRmm/EmoNEsg55QgLbnXaW6ask0zBh19c0zNwA=;
 b=Yx2sKmxfAFpZLLnuxNbCgjuG/GF0yYLizH60cWbDmWwJBhhkskuYv3NVoWaQMPe0Q+POWl0978kLnw3lQhP0SvaMVYmLXYKkiTcRajeu6sX21rLGQM8CvYIgJ3oEibin4CI0yqjC36tWB7FdiwBsUHlhreynPGgEiaoCwp/gYB+MZC/1WiziLWNfz1IjazhLvTQSVnSXAkiK8wAMD4JlNmuTvpNVecNgtCfKeBozJ4MVyP6RQL+hrM7+g0NvdKaORSBo4+GpLR6AxPAm57TkyfkkJnb8LZQqJ87oVd9B3KeUhXtzd4WZSNB6TAUDH6Umup2WLu9PtN93zhv+Hivdjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdBoeaRmm/EmoNEsg55QgLbnXaW6ask0zBh19c0zNwA=;
 b=Zq7A/2k5p9bzBfHYB+ZqwFbA1WmyHxXvtGjLFuJjB3Hcu7uptKWvUJVJj6q9l7i/siSMeCrLi+t5rdutim37qmsV9iu1spfMxVEwMoxcyd6qY3CjRXuSIqaWTakYxJZQ1Zu8HVm0EwPWBPg8lONekMAC8iKjmyfXJBGYBr2ioMc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1247.namprd11.prod.outlook.com (2603:10b6:300:2a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 02:35:25 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.025; Wed, 11 Nov
 2020 02:35:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAJg3AIAAy40Q
Date:   Wed, 11 Nov 2020 02:35:25 +0000
Message-ID: <MWHPR11MB1645F8914071A5A98BA89F358CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <20201110141900.GO2620339@nvidia.com>
In-Reply-To: <20201110141900.GO2620339@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d73c8ce-1e9e-4632-9657-08d885ea7200
x-ms-traffictypediagnostic: MWHPR11MB1247:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB124747FCE4F7BA9F3DDAC1C18CE80@MWHPR11MB1247.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5lQlXMNkUFhlwBEmMQAWJzB/8mG7uMc4jtob9QDF4by7KfH9NYygUXDNZu4jMwnwyGr1p1syngKKmSdGRhG+GD/RqfWBnoYmqmkLrDFmesRwk02NFigRkf1zdGsghyozlEey+MAeGsRWVfWYp1WVaqwl9loH4PwAJMe1dgWZoZ/ywVeieBEAiJSMgkQTffw6USm9/b8EHGteOqIxWKzHKEWd+Zk0olJCoBD6g1rJivD7w40mqgcDf18K3EU4euTA79VBppbkhOjfmI5U8q6a0ST7wEjRs4klL7whafjM76nUrx6Uloi9Qm58eW58sed9sg1E+yaqU2Zr0E63lOnEGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(2906002)(66476007)(66946007)(8676002)(66446008)(33656002)(83380400001)(478600001)(52536014)(5660300002)(76116006)(7696005)(54906003)(64756008)(86362001)(110136005)(8936002)(4326008)(66556008)(71200400001)(186003)(316002)(26005)(6636002)(55016002)(7416002)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9f4X22qoU1Wop6+EOuKIUGIXk6IwgqGbl0VNJ4I6N1sXc5RsWDLPkd2sx3b8HyliNDBSoLGjyeNxowFoHCjPQCv4W77T1dAozt6C/fPECoKb98Q8Or5XKJ8/53WEtgsZlALtfc35OG7ui60QiT9YdQ4Dm1fvv0yJi/qwv17vwntA2co0+3ZsESXVpBXRcRhy56e6vGzymiIK75H7cFIDvyj0bCVRnIbYz93OsimfDsdZMjDUfDcs59XLXCTohlmmbvm6yFeM2d0rrNsbmFE9Pmtl8YbvxR3KrItBr/w6XZdkMgtFaNdF/f+nDq0QD9SPKcx4uBYFhd0Ja/gyCWdq1MAWCNE3JxrMkm4o+TFcSxwuJ/WXP5dA3wPEAo75DN5Ahm4JzTQVPjEm+F6U/htWzX8UEmVKWL9ebpMOzGvxDXZPDWQ6KjurvXm3lLxd6/hLoKqdMEhO62otuqS8YdztT1O8PXBjck7vDkcXmsFG3J/ggCoR8xb8JskYU0lVHi5ruJO3PpdlZwU+i0PzqF9uVVv2Ok+P6viDU8TE8i4tv+lyqomsluxl4UNNb8MlJ0xFZjf2AqsSB7zVuEOdPRJ8gFmIDNvSlI0e6BV4AxekUPV5QVPkkHALejL8Zv+Lssl6I+ZF9wUm9yecrnJJI+Y49A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d73c8ce-1e9e-4632-9657-08d885ea7200
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 02:35:25.2848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jCKT3OZv4n5jA6bc+feHyuGMVmTC+jD6eQ3azJB4u7bIftHSk6//i6z1gmggQL1cBcxrIYJ4ZUPO8l6GJzstLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1247
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 10, 2020 10:19 PM
> On Mon, Nov 09, 2020 at 09:14:12PM -0800, Raj, Ashok wrote:
>=20
> > was used for interrupt message storage (on the wire they follow the
> > same format), and also to ensure interoperability of devices
> > supporting IMS across CPU vendors (who may not support PASID TLP
> > prefix).  This is one reason that led to interrupts from IMS to not
> > use PASID (and match the wire format of MSI/MSI-X generated
> > interrupts).  The other problem was disambiguation between DMA to
> > SVM v/s interrupts.
>=20
> This is a defect in the IOMMU, not something fundamental.
>=20
> The IOMMU needs to know if the interrupt range is active or not for
> each PASID. Process based SVA will, of course, not enable interrupts
> on the PASID, VM Guest based PASID will.
>=20

Unfortunately it's more than that. The interrupt message is firstly recogni=
zed
at root complex today and then routed to the IOMMU, unlike other DMA
requests. I'm not saying it's an unsolvable limitation, but just wants to p=
oint
out that to achieve such goal there are more things to be considered beyond=
=20
the IOMMU.

Thanks
Kevin
