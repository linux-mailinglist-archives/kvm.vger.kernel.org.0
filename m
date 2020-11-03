Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D12F2A3A90
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 03:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgKCCtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 21:49:35 -0500
Received: from mga03.intel.com ([134.134.136.65]:38812 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCCte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 21:49:34 -0500
IronPort-SDR: PbZYa9+dEx7hE34YwV97ZUCd+ZkytHtFe19OieU2rXVJuCq295n13M486c20xMStJn6AwMS4+w
 AIVT6wql2v5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="169091693"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="169091693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 18:49:33 -0800
IronPort-SDR: BAxubBem+Z88SJ8LZT1GuJCYO2EjwdOsOAB7KXomQyzqR1uW7ACd8EkUbHRpeNS1Ub8iJg/BiN
 w8gmTeahHQMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="528244981"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 02 Nov 2020 18:49:32 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 2 Nov 2020 18:49:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 2 Nov 2020 18:49:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 2 Nov 2020 18:49:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 2 Nov 2020 18:49:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUwHRCZNPLky1Ey16bSJzy+UE9UjkBSQspVeNwLuE0BOEvxDlV2OUTrTVXJQI+/USCAP+Dd+jktIRtDzCPyzXr3SFKrUMteA+XmWW6/IYeSG3yQwOaNjlMtwtcubwPerqduVKq2L4V+uIVUn2fLg3oB1Vw9bj/8NefgnA51FQBoAboz4cUfIQa7g35EiA4yZSgy8mSEY1O8ti582tcCUx+6g4fMoD9lxeMtNC9SpZz1u23NSDTw2gsedtG3C6JDexz0QHQXVLkwLmrFDhWu0OVxdWa1HhfeRv06SFnWMa9nFQuNhC3Yy0dkQABbp0JonHkpHh00nmGN9TlwsnG4qbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu38W76DVdQt46Ge6xsLcokw4Ipe3oimNFwx7JgX1Oc=;
 b=ASXbmlv6m9xOQxJoHsakNn7gOempaHJoEmt0iPh3gDp2Nl+tR5Q3TfAfIsUOl5eUeBpMBpMdCe7kn9ECqdNUqfYVLDHe5FAObj5rAn232eEGdoAzMXW1Q/tODMkO7GxDptNKONw31ny6FS7pCZ568JLweEH+XvMhfEIBDGNldQZdb1uzuqxwGpcQ9K4eVwLMWbRfbroqRm/TezJNeEQn8ngBNaPdZEcmaO2gUNg49TQ/ONVyZQcQLWYUXa1ucQo6gMFowmp8lU8wsR62/oDnFycDcBtfthj7/GS6hOqE6Z21XxOy0bbEaAf/87NHGbMBzgycCuLmzul9z2BoDK3HqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu38W76DVdQt46Ge6xsLcokw4Ipe3oimNFwx7JgX1Oc=;
 b=vRHdt+4/OGrGgNh/3JqWI7nfRSrYgNcLrQ1bWSQX+vPOnCvhilKqdlE3DQANLlH9jwhkZwcS9QWbXPBpyA+LUMg0egSWQpPgX2aimcqyAsiIqjlSzSyEcLzbd0lb713Kh6xcMAce0NODYCnxLiONnZCmFhVdEUhllSSt8AW6Sio=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB0014.namprd11.prod.outlook.com (2603:10b6:301:64::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 02:49:27 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5%8]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 02:49:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
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
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcA==
Date:   Tue, 3 Nov 2020 02:49:27 +0000
Message-ID: <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
In-Reply-To: <20201102132158.GA3352700@nvidia.com>
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
x-ms-office365-filtering-correlation-id: e4fe5fa9-f191-472f-cf99-08d87fa314d2
x-ms-traffictypediagnostic: MWHPR11MB0014:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB001485E6E4CB0D70738662F58C110@MWHPR11MB0014.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2syT44pI/ANQdwtWbMQP51PAcLnAj8o2IZk7lttkuvwN3N+B23VtXKB1/5HZvQaJqvkg6ZFlPrUlskHC0MMKZdEud7ulGDV3M2CumfZlkOCmRyY7aCMLWiAG3fhuWV5F/qNtNYJAsVXTxjJPgAXgNlrb6Nr4g3VlehKC8dTNyJ1GPKnm4k8svvezifobaeXwMWVWVhQ6V7ntD/bCm/2gMDggsrydRCwJNweKpjokFRvSwaubAbkC3vvbPhzhFYo74QFTWZyph1QEydaw21Y8a9YTdvpPe2hf0yReZ18CpcrId+nma9PP1SyaOodUL8Kr52AMJcK6VAAEC/vmHko9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(8676002)(316002)(86362001)(186003)(55016002)(83380400001)(9686003)(8936002)(26005)(110136005)(7696005)(33656002)(54906003)(66556008)(6506007)(64756008)(76116006)(66476007)(53546011)(66946007)(52536014)(7416002)(4326008)(478600001)(71200400001)(66446008)(5660300002)(6636002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0lCvFjfnSkq4+ButBtKrN8d28ab44inaVZMg7fF8aLklpDZEuvD+GgtJXT/NASobPMoe37CqZtZjJKc3NEWbNz2iyR/XFkp2YvRRioaRBkXb2dScXmgMj5mOUhBsICLposjTJo7F4+HjQDQvqQ6JhUNv4b6G8sfrXFFzfPv+rNjzPH4ByUhnKEiZDZLdYSAoMv5b5TMYIYpJQNJUvv2f2j7upqNTTHuOW3LzwOhZg7UlpyX+kixyD6V6P7D+CtLXJQtlAvHkI9KumpY2GsLKhTY6Wg3CiYc6hic2vf0/DMJbL2lPZhtCKK3B/K3RBUp6tNnsQNO9+JnYqrHTfUYO7xgHTikjFpPYVNGSr+vwd+1hymfztoRzIPjvgy/E4+FwN8ESy5qu51DdS7hCtP9p2cNnlclzhYUB8h++1rJmgwGpeSyFDY77LZdozR/NOmUtxD7WG0wzLxe9jahZzvuv2tVrWzG0yGaT0u0G9pS8JWmWEIc90YWNbGzX+VG4O63tCI/SeNyUSk2qD5G4wh31e4ZqplEl1t3A1CksoDw4KE5swQxVx0nydqyT4Eiel9F8rx9NF2Bn7s9+pWmmSV0nvEo0FsJ+8CVY1ITJU6cm1zh7ZFUZVF9n9nDVn2DUPtzZ9+EZCsJ2vqOtknazb6KKIA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fe5fa9-f191-472f-cf99-08d87fa314d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 02:49:27.6393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5f8qzreQDmCVmRXAp5ExrsiL/Py6OuP1Tizp2bLKDpbNvsD69is6MKHbi4VeuEWqsIcNSuxA9eSk1Gycxp+VXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0014
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, November 2, 2020 9:22 PM
>=20
> On Fri, Oct 30, 2020 at 03:49:22PM -0700, Dave Jiang wrote:
> >
> >
> > On 10/30/2020 3:45 PM, Jason Gunthorpe wrote:
> > > On Fri, Oct 30, 2020 at 02:20:03PM -0700, Dave Jiang wrote:
> > > > So the intel-iommu driver checks for the SIOV cap. And the idxd dri=
ver
> > > > checks for SIOV and IMS cap. There will be other upcoming drivers t=
hat
> will
> > > > check for such cap too. It is Intel vendor specific right now, but =
SIOV is
> > > > public and other vendors may implement to the spec. Is there a good
> place to
> > > > put the common capability check for that?
> > >
> > > I'm still really unhappy with these SIOV caps. It was explained this
> > > is just a hack to make up for pci_ims_array_create_msi_irq_domain()
> > > succeeding in VM cases when it doesn't actually work.
> > >
> > > Someday this is likely to get fixed, so tying platform behavior to PC=
I
> > > caps is completely wrong.
> > >
> > > This needs to be solved in the platform code,
> > > pci_ims_array_create_msi_irq_domain() should not succeed in these
> > > cases.
> >
> > That sounds reasonable. Are you asking that the IMS cap check should ga=
te
> > the success/failure of pci_ims_array_create_msi_irq_domain() rather tha=
n
> the
> > driver?
>=20
> There shouldn't be an IMS cap at all
>=20
> As I understand, the problem here is the only way to establish new
> VT-d IRQ routing is by trapping and emulating MSI/MSI-X related
> activities and triggering routing of the vectors into the guest.
>=20
> There is a missing hypercall to allow the guest to do this on its own,
> presumably it will someday be fixed so IMS can work in guests.

Hypercall is VMM specific, while IMS cap provides a VMM-agnostic
interface so any guest driver (if following the spec) can seamlessly
work on all hypervisors.

Thanks
Kevin


