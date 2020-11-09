Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5582AB0C8
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 06:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgKIFZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 00:25:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:23293 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgKIFZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 00:25:34 -0500
IronPort-SDR: POOO1aYOvuxm2e4feuYJH1aCp5OF6e3f6e+U+now6fNagf4nG9cwDT1WaqF5MDjy+978BE0WON
 et+c/gAB4/NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="168968185"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="168968185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 21:25:33 -0800
IronPort-SDR: 47M7yD1sDctCmzkKiJjjVitGQzGYxSmA+VbhnX57JiNvGNMLLKiyjJOfApcTFTTNh0BUmnThRE
 /9MhrM5El5pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540693622"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 21:25:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Nov 2020 21:25:32 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Nov 2020 21:25:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 8 Nov 2020 21:25:32 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 8 Nov 2020 21:25:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTZCGqbQQ4aRLAAy4jmhDIqeRur3qF6eUT5p3nWEySYql4SoE1DcaDBcsTKzeXTExs+EHpIAziggICma6dr3CcFLqKecIZ1kYtzX8wwI7/fyu2x8mIGBX8b7GVE/AJWeBiocuGILxEKsIABECPfG6qrQLzU7/c5TKVHXO4t/DnhMpNX8hXP02wYMYULFO58FSw74MdDpJ2kipmb4widEZ6luBN8a6Zgc6/bHpeTW6uKE/IKW99yys2ub1J80Ijn9YYuBqSXjMZrqWJAxMXOpMEI2SW6m2sX1Hu7PdXlwscIzw7KoIDYMMHLMmVPiTVJmPCtrXSXnvRp2yAj1hAYnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luN/CyLxMJyT/ZKjUfMmIFep0vCgTMlteAB/fWTd0+k=;
 b=lsgeHQYjW1Aw+MV7GvlrZeODo4JWjSh16zjLE0Y2VZOMkYcWvWzUFNMlAN2hwzxPTuesHCKTICeLXR9NTtn12X6PvT9LwEeMIS8zEbJXPAwkzsJyPaCKKndKcs0AObcTt5rpht0EyEywJkcpZ0zrIl+VhFdaNPeobQRJaf9sryJw++u4Z5ZTJL3Hbj6jsFl5eYvEOuIbhGcsAquFR+O877Qd5ucMJKIWbOuj7h4S6n8SPNF5VNKg0v+Fkgo8L4cCprSeSH88VqRh76ZTUIQzk9PmJxIjv5sVYveBrqLJIaAuqj7KtjWlM6u+dr/kk4W/bS97rz9ctdgUh/M6CLX8aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luN/CyLxMJyT/ZKjUfMmIFep0vCgTMlteAB/fWTd0+k=;
 b=fI62dAGMOXa6asiVel1niBl8l/ivQ1kMzLrZwoDYVM65+hrPFOHYAFxCiD5QpyDcAeZN7oLUlmOrQ/84/N/eLekDmyFUKdap/n74V8pB48nXMJ5rAvsN945cCJ9TvAe1EGyPzfJWbrdPQ4vJaUowA1fWJHx9hW9jn+p4mHD154A=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Mon, 9 Nov
 2020 05:25:28 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.023; Mon, 9 Nov 2020
 05:25:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
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
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIABITqAgAM2ylA=
Date:   Mon, 9 Nov 2020 05:25:28 +0000
Message-ID: <MWHPR11MB164544DAA22DCC1AE77EE44D8CEA0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <871rh6knvs.fsf@nanos.tec.linutronix.de>
In-Reply-To: <871rh6knvs.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ce42165-d99b-45d5-0f68-08d8846fdecd
x-ms-traffictypediagnostic: MW3PR11MB4748:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4748ABAAF12150E0A0DC3E048CEA0@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FbrZPdi5jbWNPxhwabpl6dqblt5AWgCYRpOR43qPV08kn/isrXc8p8ND8Nzgo1nWKeaXMx47TyUPm6ASYKzO80fHxKgnEbnQUVOnqx7c4ZKQQOnzQahwitB/iXQgGIfYi7u6ek0Ax3+NI81PizhED4mwpMfxaAZR937DYfQzSgscZ09q/1ArFMLVQgc2Olxu7j3QBNoh4gvO7XlEWk/q+28tP0xBCsxIfgBilsuyf3WBCwLlD/8EdZXKSFoa0igytPZgDiphoLXjKoy6ccC2SVVJg9imqEG6mdMfx7XOooGg/CgfzTq1C4D2LxUk3+SbrpA/Sbpe1Xqm5MmB6un71Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(54906003)(86362001)(9686003)(55016002)(8676002)(83380400001)(2906002)(71200400001)(7416002)(33656002)(7696005)(26005)(66446008)(64756008)(53546011)(66556008)(66476007)(478600001)(6506007)(66946007)(5660300002)(8936002)(186003)(110136005)(76116006)(52536014)(316002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3DuBUt4s/A7VWPULekptUBFB6d5l1BGP3u3xXVNLK3PEPdx+oy8JdW/cJRuWCRC8pEWSrHZfMXtVBdWBQxvHaA339gn2yLtvqbSQsEZfuVrNcYHG11MnNZZ80nMCklXPqH7CaNt47gLrYxgdiM7VyVyJE1JyykDpUgSxLpFd/rk5hIf2X7yAT1JaX3aYWW84ZPc9yl+6i/dLdQmRRDM8Je6DX25rWzAhWdBU9lEW6l78TWxr8j+bnX8KwEe9c500nxqFhc7euuffsKFhI633Ilx2gM/+3y5n475eT96ZfjeY1XOCDgPli0Upj7PO8ORbR8oXGj/LDxlgiEUeyXqsig/Guj4EKEpoDGEo1rsZKcHcOxlUCOjMx3BWgqRpwN9rZ7hunKz7Wkgoj1wWI7a0JRD5LJ4u5H57BnheGIYGbt02kkiNBo514L+l/bLetMNJiWbIy5TcR94AegbqKD49Odw5qKvZ28H8u8uSGeBCGLcC9ZQSgFUp3vxFfQB5cIxNDAV9GUhAQ+iuxRIfD80PAaq1w3wTIi73RivmCsiHz3QSpxWllfSPlU+1+MpKzyWO7o6dwz0pSNhF1C26vEYGbROCbgXqD3voMyXdBsOjuUZKy1BufI6Itfj1cl8H481C5WpGSR9pNQuLYoKRIykiAA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce42165-d99b-45d5-0f68-08d8846fdecd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 05:25:28.4923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+Gy/jcLw+nI2TL3qh/29svEl1jafkxWRrMbWpt37LS9cogpSNE9b8kict4zhZjg2505MtNK1Ih4wx/+6maQCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Saturday, November 7, 2020 8:32 AM
> To: Tian, Kevin <kevin.tian@intel.com>; Jason Gunthorpe <jgg@nvidia.com>
> Cc: Jiang, Dave <dave.jiang@intel.com>; Bjorn Helgaas <helgaas@kernel.org=
>;
> vkoul@kernel.org; Dey, Megha <megha.dey@intel.com>; maz@kernel.org;
> bhelgaas@google.com; alex.williamson@redhat.com; Pan, Jacob jun
> <jacob.jun.pan@intel.com>; Raj, Ashok <ashok.raj@intel.com>; Liu, Yi L
> <yi.l.liu@intel.com>; Lu, Baolu <baolu.lu@intel.com>; Kumar, Sanjay K
> <sanjay.k.kumar@intel.com>; Luck, Tony <tony.luck@intel.com>;
> jing.lin@intel.com; Williams, Dan J <dan.j.williams@intel.com>;
> kwankhede@nvidia.com; eric.auger@redhat.com; parav@mellanox.com;
> rafael@kernel.org; netanelg@mellanox.com; shahafs@mellanox.com;
> yan.y.zhao@linux.intel.com; pbonzini@redhat.com; Ortiz, Samuel
> <samuel.ortiz@intel.com>; Hossain, Mona <mona.hossain@intel.com>;
> dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> pci@vger.kernel.org; kvm@vger.kernel.org
> Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
>=20
> On Fri, Nov 06 2020 at 09:48, Kevin Tian wrote:
> >> From: Jason Gunthorpe <jgg@nvidia.com>
> >> On Wed, Nov 04, 2020 at 01:34:08PM +0000, Tian, Kevin wrote:
> >> The interrupt controller is responsible to create an addr/data pair
> >> for an interrupt message. It sets the message format and ensures it
> >> routes to the proper CPU interrupt handler. Everything about the
> >> addr/data pair is owned by the platform interrupt controller.
> >>
> >> Devices do not create interrupts. They only trigger the addr/data pair
> >> the platform gives them.
> >
> > I guess that we may just view it from different angles. On x86 platform=
,
> > a MSI/IMS capable device directly composes interrupt messages, with
> > addr/data pair filled by OS. If there is no IOMMU remapping enabled in
> > the middle, the message just hits the CPU. Your description possibly
> > is from software side, e.g. describing the hierarchical IRQ domain
> > concept?
>=20
> No. The device composes nothing. If the interrupt is raised in the
> device then the MSI block sends the message which was composed by the OS
> and stored in the device's message store. For PCI/MSI that's the MSI or
> MSIX table and for IMS that's either on device memory (as IDXD uses) or
> some completely different location which Jason described.

Sorry being inaccurate here. I actually meant the same thing as
you described since I did mention addr/data pair filled by OS.=20
Unfortunately I mistakenly thought that 'compose' has similar
meaning to 'send' in English but clearly it's not and instead it's
just about the message content. and for sure I also agree with your
other clarifications regarding to architecture independent  manner.

Thanks
Kevin

>=20
> This has absolutely nothing to do with the X86 platform. MSI is a
> architecture independent mechanism: Send whatever the OS put into the
> storage to raise an interrupt in the CPU. The device does neither know
> whether that message is going to be intercepted by an interrupt
> remapping unit or not.
>=20
> Stop claiming that any of this has anything to do with x86. It has
> absolutely nothing to do with x86 and looking at MSI from an x86
> perspective instead of looking at it from the architecture agnostic
> technical reality of MSI is the reason why we have this discussion at
> all.
>=20
> We had a similar discussion vs. the way how IMS interrupts have to be
> dealt with in terms of irq domains. Can you finally stop looking at
> everything as a big x86/intel/platform lump and understand that things
> are very well structured and seperated both at the hardware and at the
> software level?
>=20
> > Do you mind providing the link? There were lots of discussions between
> > you and Thomas. I failed to locate the exact mail when searching above
> > keywords.
>=20
> In this thread: 20200821002424.119492231@linutronix.de and you were on
> Cc
>=20
> Thanks,
>=20
>         tglx
>=20

