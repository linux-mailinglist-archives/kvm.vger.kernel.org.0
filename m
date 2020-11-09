Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0BB2AB20C
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 08:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgKIH71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 02:59:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:33867 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgKIH70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 02:59:26 -0500
IronPort-SDR: Z4gEKKh4GmxtdgqXue6OXDoE+bHh5k1OJ2yw8RONoBgckFjMT3lEf08UjGFCm5x/b3RxjJoo9x
 doGRrcyxAKBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="168980543"
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="168980543"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 23:59:25 -0800
IronPort-SDR: sGgrPWSt0+ab80EQWOgB4K6kzIWgaN+AcDXOn4mgBycaCgPXVX+6mNrwjVxVN/XIQAx2ukJqQ+
 TDUwF3LmkgxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="355580861"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 08 Nov 2020 23:59:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Nov 2020 23:59:24 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 8 Nov 2020 23:59:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 8 Nov 2020 23:59:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hn0+4mFZlwNsMBdKrzkaE6TbOEBHlTLiBx4k4cXbqNmp0DjGdxG9lD+Fxhe09gdotxFYvL78u+A4GpNzH9p9DSxlXdHOR0MWmjAvOiuk9hjA4bO4hlNihsKJ+4sGnDXlbLF8f6PIYQLCHf9Y0+VklNZISve6q5Ruxf0vOg4fRxt+II+x7PJnRsgTkeyHce5qr/cNv0vWC4ymZCWLbKRUfMBrynUIKG2/pu4qwguobtNJ1x3yN7uDIvo7goP1ism7sZ6fkUVft1/QxE3nYjSbO38wYhWK86ZzDcFLKpuL8E9ssdrhcGiNQ6R+b4gfeFIASdg9WeOBqL5n1DboCUOV/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olPVd312HMCfViRrYYZkCyUiuvM3j/DpXsbCMTXEEaw=;
 b=GnzNysNnCd/ku/Iy+jR8vRuBC7ccRxX4PBNQteuUtIH5HKTaR0kx0Z6IECH0HnKwxwCUKTFroKPs/IpBggNXkULqXuSgjjEpVPEu+cHFqSfaMmgU8MKTqkGi5D9B+mrA59wSah4J4CBskyKFahC3ae6GXuIQvX7WOZre3wBrvvwF50AdFYNlEaeZOfIvv0TCEoF/1p1IxjxsNFEeEhHSoYgWPSpJJaq+p/TbGVuupf9Uoeri8e9RPGpIhRTYE1Ymnecq3cZ+5EDEuHo2DdduVYGvAxsCbqcVwb3VUc+Puqd3A3UnkX5AsmE1UnWVne5O/6wRagNmoIi2b+G6OSQngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olPVd312HMCfViRrYYZkCyUiuvM3j/DpXsbCMTXEEaw=;
 b=M10gKEIvxY8LBKcieN7IlYQilU1DRbCTdenAeZdXHN8oTIC0SgURt+pFxSI4AUQ4BvDFfyHEMwYclBX6U5rth3PG0VLycrvbbZ59WIy2D9hTElgHZXSl+EqluRybjN96EV1mua3qvPqC2Jyj+ysFD8Jn/GjurTnASsUXyHwUwN8=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by CO1PR11MB4770.namprd11.prod.outlook.com (2603:10b6:303:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 07:59:19 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.023; Mon, 9 Nov 2020
 07:59:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgACAXDA=
Date:   Mon, 9 Nov 2020 07:59:19 +0000
Message-ID: <MWHPR11MB1645A346723C7A334AC0EA3D8CEA0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
In-Reply-To: <20201108235852.GC32074@araj-mobl1.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7407af1-dffe-44e8-7dd3-08d884855cec
x-ms-traffictypediagnostic: CO1PR11MB4770:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB47709B8F268453B6D866FEA08CEA0@CO1PR11MB4770.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w+KV7d5GT1LOdVf00zrLULGgDQAyvyStrcUjnasKC+WkERGiDzS0HUYq/GR/bSve20ZupWN0RiZR3zrE68j9kIkKirjyclUfJSXnjIyeqvJznm3TNX7S1KvFNz4lNSpGt2vUx4J0h0FzHerv8FF2eiYgHhYgS40D8MAJHHkGpPg7cJOUhM7Mvu6JYidFRnSgjsBvsCG8n9du8ZUfmt6flj2L/V4XhPAVNzNO67woRIKaEhFaK8HHEPDLEHcukg5iv5A8HJ6YePofU4cuM7Lgk6TyAe6qT/I5r3HjakjOErD9CLPcBy5YAcOHOyg4ElxFKnsd08Pxqyh/DctJNNj7Aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(26005)(186003)(6506007)(4326008)(478600001)(71200400001)(45080400002)(83380400001)(9686003)(2906002)(55016002)(110136005)(7696005)(7416002)(66446008)(64756008)(66556008)(66476007)(76116006)(66946007)(33656002)(8676002)(5660300002)(8936002)(52536014)(54906003)(86362001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +GqdiL0F5GCcBGLSmd0mA6mL4tUeuDZopTuMR5H5ltk9haGhOnFs5ChASmi4xYhTW70S+OQrrbBWaeILFWuYJ3hrU5rkwqO+BT/VRT4xGBITaTy2u7LNavdG26iiNUiigZ9PRHpoFx3KU+g+rN8eUhxUyRi8vZ5YOowq7eyH4dbIFFxzKQYRVn7/z5lt4W/JcWZ0id7j+EvDa53HTqvWh99DjNfK2/TdQ3GSpK1j0RJobaR4RmN2ioUeP463LoOXc/KkbLqR4Ija79aKtZI1vZ39UN3FyqashU9EphiIrbBIEcotoinJi67OaK9Ty0+658/G2NdiVuj73SvS7eDsQgFllA6ksFsc4NxV7lyK3hWJNyd7IlSXkrXoIjWC5hIQ4q8hz3O4+bBsWBSm/HG9WM2HOscqkNq7SKGkJ06GFvnT/ohwlHVxYODFEzhYGIoVgI4dDEkepVWtACu2RArfaf0j/6jWZie+shbx357OQ7D0PYcGlvKFEOREYEMFuQgtayXa9L2UOgHzWca+FuVt53AIC5Ucs/muDEepVK1MB0ABH7ATWG82DBZ3w2+r3AHHYu1YNg4RSnltOhmzJFgHbIExISLsANJlsG/YDOXy+FLaBZ+1jJtyFQT9Xroi/9N0aiIvbpiPpSmoR99UI3UUGQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7407af1-dffe-44e8-7dd3-08d884855cec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 07:59:19.5565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xVURdrle//ZvQhJmnpzlyo9xz5Ycb+YYy5OBKsMP0R538oM2tIv36nuG34DXJIesDOG5onWmN5HqyVAKfNX8Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4770
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Raj, Ashok <ashok.raj@intel.com>
> Sent: Monday, November 9, 2020 7:59 AM
>=20
> Hi Thomas,
>=20
> [-] Jing, She isn't working at Intel anymore.
>=20
> Now this is getting compiled as a book :-).. Thanks a ton!
>=20
> One question on the hypercall case that isn't immediately
> clear to me.
>=20
> On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
> >
> >
> > Now if we look at the virtualization scenario and device hand through
> > then the structure in the guest view is not any different from the basi=
c
> > case. This works with PCI-MSI[X] and the IDXD IMS variant because the
> > hypervisor can trap the access to the storage and translate the message=
:
> >
> >                    |
> >                    |
> >   [CPU]    -- [Bri | dge] -- Bus -- [Device]
> >                    |
> >   Alloc +
> >   Compose                   Store     Use
> >                              |
> >                              | Trap
> >                              v
> >                              Hypervisor translates and stores
> >
>=20
> The above case, VMM is responsible for writing to the message
> store. In both cases if its IMS or Legacy MSI/MSIx. VMM handles
> the writes to the device interrupt region and to the IRTE tables.
>=20
> > But obviously with an IMS storage location which is software controlled
> > by the guest side driver (the case Jason is interested in) the above
> > cannot work for obvious reasons.
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
> >
> > Why? Because it reflects the boundaries and leaves the busdomain part
> > agnostic as it should be. And it works for _all_ variants of Busdomains=
.
> >
> > Now the question which I can't answer is whether this can work correctl=
y
> > in terms of isolation. If the IMS storage is in guest memory (queue
> > storage) then the guest driver can obviously write random crap into it
> > which the device will happily send. (For MSI and IDXD style IMS it
> > still can trap the store).
>=20
> The isolation problem is not just the guest memory being used as interrru=
pt
> store right? If the Store to device region is not trapped and controlled =
by
> VMM, there is no gaurantee the guest OS has done the right thing?
>=20
>=20
> Thinking about it, guest memory might be more problematic since its not
> trappable and VMM can't enforce what is written. This is something that
> needs more attension. But for now the devices supporting memory on device
> the trap and store by VMM seems to satisfy the security properties you
> highlight here.
>=20

Just want to clarify the trap part.

Guest memory is not trappable in Jason's example, which has queue/IMS
storage swapped between device/memory and requires special command=20
to sync the state.

But there is also other forms of in-memory IMS implementation. e.g. Some
devices serve work requests based on command buffers instead of HW work
queues. The command buffers are linked in per-process contexts (both in=20
memory) thus similarly IMS could be stored in each context too. There is no
swap per se. The context is allocated by the driver and then registered to=
=20
the device through a mgmt. interface. When the mgmt. interface is mediated,=
=20
the hypervisor knows the IMS location and could mark it as read-only in=20
EPT page table to enable trapping of guest writes. Of course this approach
is awkward if the complexity is paid just for virtualizing IMS.

Thanks
Kevin
