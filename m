Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB902AB1CC
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 08:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgKIHhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 02:37:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:60401 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbgKIHhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 02:37:13 -0500
IronPort-SDR: DDxMAX7p85ha4DKze4wObul6eyDSgftOjXFLMsw+pTkfcPg3ewqXt8ZpJf7uOQYcL7OoQKGakb
 y/ZwFFKUwnXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="156770217"
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="156770217"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 23:37:12 -0800
IronPort-SDR: PWAe3ffPVTDN3tiiaKcWeEZdPRC3dLxWuE9FNmMgWda29KaKmdxnly4CwMxnyQCIxO2dY/7ngb
 U9E+WmWTaK/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="355564601"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 08 Nov 2020 23:37:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Nov 2020 23:37:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Nov 2020 23:37:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 8 Nov 2020 23:37:10 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 8 Nov 2020 23:37:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1fsAFoUU9faETcCEEqnF0cIAcQjRJRt6XULY+wYx9fcYJVtQ8lS42Qvq1QFs+Gy/QOIqt5AhvKuXn2Z+cdq2JGrX0v1xAeb2CLArdKYbRDEq5DFG/Ae/g4Trn6tC7RG46szhRathd0aUb9zUENpvJ0ZJtYLfUqPu7yKNqkgt1pS66j3Pcbmp0CT6j43TMUxEWbKwSlvhQYX0pFvwm592xEsUB/eFbsLJu+mmYsZOmFp9BmvwhKOtRJqQI7hh9lIF0NfUVnFKk4+SMkolIYuKfZ7d4lk2k2T6FUEVnKwT+5ygK9xNzf0RmmCW9lI7NjkEqY4AJTYTnfGkqOh/+rxtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqbyd1Ks5S1emA/nt56/BlcjAjc/gZbLlUcxTonyIY8=;
 b=h4dIyoX6LJPEOBe0+rDkNZxUDgo+32X4ZgtZEK5scOZ3fVeJ5EZSzRb4X9LkWLN31yNZM8b7Pwr9Uflnsq2qiw0qJvU6zmLiEZkK7uDkSkZ6ZRHctDlwUqohU8m/ae2S4MdtfPNzyn9jl6w3MvlueJ9LVe0kDv311+BV22+FrFsbMKm6syMeV/7/kEGJkgD2lf44Gd43VRMRn4CmDbUYFNwRE0igUhCYu3uLM6jtbi9ioXn2x4a9NXhdUIQUWXEG0GnKH3M6uK5viXAscfIi/mh1zMh48AXjhLIL6JO4bS3fhhyLIJdjiKlxx4BSYaLDvjR2hFcPvztZI+wV21cZfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqbyd1Ks5S1emA/nt56/BlcjAjc/gZbLlUcxTonyIY8=;
 b=FgM22fXbZr7q/dz6my4DntEPO12RdeqOZSfLKltL7PROCCG5D//8CJxFiq07jnAiVG2q6NimNlzHfwmdsj9jnz/GtRChXuGb657oZm3Karaiybg/tFOKZvsqv8ZsPQBNtd6O5wezxDPunFYGbjq2HVvSozehFmt9V7yTcekK15U=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2206.namprd11.prod.outlook.com (2603:10b6:301:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Mon, 9 Nov
 2020 07:37:04 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.023; Mon, 9 Nov 2020
 07:37:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAATTGAgABlZPA=
Date:   Mon, 9 Nov 2020 07:37:03 +0000
Message-ID: <MWHPR11MB164578A1CC38EB28F6EA8F918CEA0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108232341.GB2620339@nvidia.com>
In-Reply-To: <20201108232341.GB2620339@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 6d73305a-59ab-4642-5b27-08d8848240e4
x-ms-traffictypediagnostic: MWHPR1101MB2206:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2206806E51BF9827DAF82BA38CEA0@MWHPR1101MB2206.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WIyELlJpcnC1XAVr4hAAlBGzSHn+xN1mrvdRH3kGJ3Vsafe67V3FlM3OnwW3KOYhoTxhPuTI6dz/ijiTkuqH1V01XdKYeqFbeZJqCuA3Oe4670zQ33fS7PaCGHg2j+b/yxlt/NXpkU8wFc5+eb6jyB56k4H4PoEKw6zcgO4FGgYuHbOKJgcFvNHSSsPc2lX6MYHsMHPS/fLJ2A1J/ZAYzWRXFVJ48l+I19kwyuqSZSQ2m5JnZaRLAyzqBDx1FUxAmTb0+e0f/l1+6VtScCxOx3NMC0AeFhsQX5WEkVDaxiAZ4yP//qMB5FSMFH2dUFKeSOzRWzYHQHAndQwlf3fqzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(8676002)(7696005)(52536014)(71200400001)(6506007)(316002)(4326008)(86362001)(5660300002)(64756008)(66476007)(8936002)(66556008)(66946007)(66446008)(76116006)(26005)(9686003)(110136005)(478600001)(33656002)(7416002)(83380400001)(2906002)(55016002)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v35ow8Y2eEEHKQqj3nBITSkJKQ83xmP3JoGEvZNuV9t9HH6ovUgFWWosb0bqqlfzzxqJhdbd1gMto1w/wna8VACxcgemto/LkImk8dienGQwsN3bk6y7nTApquSy+a7710ldub0Y4orliVdiUgKxsqQwjx0WhYmq3a38knSmXGwbawgaJ6gKyRdFPjKAuvIMqgGD/78Zl8PkbOtHI11w5p6SLs5C2wMnNGYMqi1FTSaZc4ybtNQRGD0T/kf3Kj4HCtkNYTpZBzoy9T/7bu1WGcw1hkO8jpx4t5mEMMD37hH+tVshPi+lfQzYYD+lT8ig8uk3xgdbKuA4gbSX52pmkdAvGtXYggncTC8f0+Zfr11flRAP86JtnQ7nIQ0gUkuXCAYsGF+pOuEjVhUWav/Vy34HXi4nWbvpT1MsckmE2xswdNgRPBJPf6Nj5jP1t6Iv5fkPt3aW/88FAG6LB23+pjJIU7pUqecz48/mf2Ne0QAiF1fUh9nYuuhqyy5ipcjPEgz7nhn4LhoeTZlmYdVEFM1MsNXEzFkyOEXP5bJVkicpbnkjgvFzjDP+XZPoK7OB4zeG3cxf1f8IOqJOE2pi35foDnhG0JMIxT8biKVQcKb2KYCgS3anCXTWyXtNhSik4Ge3CzClJZdMgHeUz+kI8g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d73305a-59ab-4642-5b27-08d8848240e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 07:37:03.9778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6f030XVkADOJW8aQjimoULpF8tEw6FVWeoNcHyrONJ3vyp+tpipirKi1M+4T9eO4uRfTSe4K9XK7qnXdZp53HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2206
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, November 9, 2020 7:24 AM
>=20
> On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
> >
> > That means the guest needs a way to ask the hypervisor for a proper
> > translation, i.e. a hypercall. Now where to do that? Looking at the
> > above remapping case it's pretty obvious:
> >
> >
> >                      |
> >                      |
> >   [CPU]       -- [VI | RT]  -- [Bridge] --    Bus    -- [Device]
> >                      |
> >   Alloc          "Compose"                   Store         Use
> >
> >   Vectordomain   HCALLdomain                Busdomain
> >                  |        ^
> >                  |        |
> >                  v        |
> >             Hypervisor
> >                Alloc + Compose
>=20
> Yes, this will describes what I have been thinking

Agree

>=20
> > Now the question which I can't answer is whether this can work correctl=
y
> > in terms of isolation. If the IMS storage is in guest memory (queue
> > storage) then the guest driver can obviously write random crap into it
> > which the device will happily send. (For MSI and IDXD style IMS it
> > still can trap the store).
>=20
> There are four cases of interest here:
>=20
>  1) Bare metal, PF and VF devices just deliver whatever addr/data pairs
>     to the APIC. IMS works perfectly with
> pci_subdevice_msi_create_irq_domain()
>=20
>  2) SRIOV VF assigned to the guest.
>=20
>     The guest can cause any MemWr TLP to any addr/data pair
>     and the iommu/platform/vmm is supposed to use the
>     Bus/device/function to isolate & secure the interrupt address
>     range.
>=20
>     IMS can work in the guest if the guest knows the details of the
>     address range and can make hypercalls to setup routing. So
>     pci_subdevice_msi_create_irq_domain() works if the hypercalls
>     exist and fails if they don't.
>=20
>  3) SIOV sub device assigned to the guest.
>=20
>     The difference between SIOV and SRIOV is the device must attach a
>     PASID to every TLP triggered by the guest. Logically we'd expect
>     when IMS is used in this situation the interrupt MemWr is tagged
>     with bus/device/function/PASID to uniquly ID the guest and the same
>     security protection scheme from #2 applies.

Unfortunately no. Intel VT-d only treats MemWr w/o PASID to 0xFEExxxxx
as interrupt request. MemWr w/ PASID, even to 0xFEE, is translated
normally through DMA remapping page table. I don't know other IOMMU
vendors. But at least on Intel platform such device would not get the=20
desired effect, since the IOMMU only guarantees interrupt isolation in=20
BDF-level.

Does your device already implement such capability? We can bring this=20
request back to the hardware team.=20

>=20
>  4) SIOV sub device assigned to the guest, but with emulation.
>=20
>     This SIOV device cannot tag interrupts with PASID so cannot do #2
>     (or the platform cannot recieve a PASID tagged interrupt message).
>=20
>     Since the interrupts are being delivered with TLPs pointing at the
>     hypervisor the only solution is for the hypervisor to exclusively
>     control the interrupt table. MSI table like emulation for IMS is
>     needed and the hypervisor will use
> pci_subdevice_msi_create_irq_domain()
>     to get the real interrupts.
>=20
>     pci_subdevice_msi_create_irq_domain() needs to return the 'fake'
>     addr/data pairs which are actually an ABI between the guest and
>     hypervisor carried in the hidden hypercall of the emulation.
>     (ie it works like MSI works today)
>=20
> IDXD is worring about case #4, I think, but I didn't follow in that
> whole discussion about the IMS table layout if they PASID tag the IMS
> MemWr or not?? Ashok can you clarify?
>=20
> > Is the IOMMU/Interrupt remapping unit able to catch such messages which
> > go outside the space to which the guest is allowed to signal to? If yes=
,
> > problem solved. If no, then IMS storage in guest memory can't ever work=
.
>=20
> Right. Only PASID on the interrupt messages can resolve this securely.
>=20
> > So in case that the HCALL domain is missing, the Vector domain needs
> > return an error code on domain creation. If the HCALL domain is there
> > then the domain creation works and in case of actual interrupt
> > allocation the hypercall either returns a valid composed message or an
> > appropriate error code.
>=20
> Yes
>=20
> > But there's a catch:
> >
> > This only works when the guest OS actually knows that it runs in a
> > VM. If the guest can't figure that out, i.e. via CPUID, this cannot be
> > solved because from the guest OS view that's the same as running on bar=
e
> > metal. Obviously on bare metal the Vector domain can and must handle
> > this.
>=20
> Yes
>=20
> The flip side is today, the way pci_subdevice_msi_create_irq_domain()
> works a VF using it on baremetal will succeed and if that same VF is
> assigned to a guest then pci_subdevice_msi_create_irq_domain()
> succeeds but the interrupt never comes - so the driver is broken.

Yes, this is the main worry here. While all agree that using hypercall is=20
the proper way to virtualize IMS, how to disable it when hypercall is
not available is a more urgent demand at current stage.

>=20
> Yes, if we add some ACPI/etc flag that is not going to magically fix
> old kvm's, but at least *something* exists that works right and
> generically.

Agree. We can work together on this definition.=20

btw in reality such ACPI extension doesn't exist yet, which likely will
take some time. In the meantime we already have pending usages=20
like IDXD. Do you suggest holding these patches until we get ASWG=20
to accept the extension, or accept using Intel IMS cap as a vendor
specific mitigation to move forward while the platform flag is being=20
worked on? Anyway the IMS cap is already defined and can help fix=20
some broken cases.

>=20
> If we follow Intel's path then we need special KVM level support for
> *every* device, PCI cap mangling and so on. Forever. Sounds horrible
> to me..
>=20
> This feels like one of these things where no matter what we do
> something is broken. Picking the least breakage is the challenge here.
>=20
> > So this needs some thought.
>=20
> I think your HAOLL diagram is the only sane architecture.
>=20
> If go that way then case #4 will still work, in this case the HCALL
> will return addr/data pairs that conform to what the emulation
> expects. Or fail if the VMM can't do emulation for the device.
>=20

Thanks
Kevin
