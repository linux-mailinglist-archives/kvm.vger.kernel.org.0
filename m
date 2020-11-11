Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F782AE644
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 03:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgKKCR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 21:17:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:26905 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgKKCR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 21:17:56 -0500
IronPort-SDR: gvJa1vqc+gsVH60QlIsJ3xgucy0EXELrmtV7yohZ631lehLpHwNZfuvm5L2OdqRcjxQ/dbb3Jl
 czO2lrebquuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="166573332"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="166573332"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 18:17:54 -0800
IronPort-SDR: knA9b7EIO06nGNpERojkFkQmBdCZfFO8v09ss5gcb8M6+30Bs3DLzw//tILvREhjDgxSMCsyNG
 /nzWJIoOzRPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="356428338"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 10 Nov 2020 18:17:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 18:17:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Nov 2020 18:17:53 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 10 Nov 2020 18:17:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noM2Qt1sd0oQSQmMl1yZTKrGy4jJB/s1H3hqHwjey/c+a0Mg8IsHGjpy00JMJVpQAEIpnE56mn4yVFaEE946tMGlOk0HyC2adID4oBYEttfzF3ArUykXqNlWofyunfNMmNNJtHFRe8iPN5wMb9kMdroC5CtPV/2QudKwsi5t18F2/wRAgwcOYrRVg+TXS2j1wZtvjQf08IopsdNyJa1qFXRyT2tN/ry4nbR5NXos0e9OFlAlBZPAH5gX42oKsE4hIG0/TG73BTCcAnSl93sYdo3quDSVXzB/0k/6cXqWPq81gOyLMCuhtoC/rvF82oBVqDBQ6pm4dUxiATKDJuSUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=592p6QdDSo2xgCQtZT+LKKqRbmRDfn7+FD4hXWYI/Lo=;
 b=V3KMAc5r8rOmRCKzW9a41iiudStOuavYgvy50f5HbpqbSNeRVs+fTegSLv+hy5OUqeZJKLmB9ZhGsXywqylrHMd9LJ0esaIDaPZDFWww3joAocsP2l4yaEVJ3k0NQFf7zsRA5AxU/P2GXEIHv7fWDYFADf7PwDsDyeateR4jkKDuuD60mRpNgwa8K3eIviGdBrmcQfabp/buBjNfu+heZh7Quiu2tqunTzG1WCjaEnfAeOjkFo9tUTpdPY7kFrc0BiIsVwIVaeZfHerklT9ji/AqNHAbt+vRf18P7JGtQX/+09tLzDEGITnfADXzUORmfW2eNJBmDyE9HAJGw4rBHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=592p6QdDSo2xgCQtZT+LKKqRbmRDfn7+FD4hXWYI/Lo=;
 b=Oak9p5vGMOsOspkz6weMXuaIA2NOSlCWpchzetP2x1Ud8gKlCWMeqC+FRVfsOtwyPHWsXP6fiyXqM6eGGNnc4RDxrHBdM5z5W0g1CMjCjbzKuhG/Bp6eeIb9suw5db1WVK3KGm18zHr1OaCN1BKafrnTUw6JxP015c/h5kw74dM=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2094.namprd11.prod.outlook.com (2603:10b6:301:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Wed, 11 Nov
 2020 02:17:49 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.025; Wed, 11 Nov
 2020 02:17:48 +0000
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
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAFeIgIAAPx2AgAAC4ACAAMRZYA==
Date:   Wed, 11 Nov 2020 02:17:48 +0000
Message-ID: <MWHPR11MB16459716A1897F79E860AB4D8CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
 <20201110142340.GP2620339@nvidia.com>
In-Reply-To: <20201110142340.GP2620339@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 51fd4889-6bd7-4014-1769-08d885e7fc4c
x-ms-traffictypediagnostic: MWHPR1101MB2094:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2094E0B33804776B3A5707F48CE80@MWHPR1101MB2094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syV29+0M0ZgcQnm10gZ1NsXla6a98ym34SsZx8Df4Y9uoZy/kJqJRXB/16NzMzPH4LbApg1ymtLv0IDOR+J8esLimF+KMqfwxXURrHT+xDOhqrfRNQTLvbmSAlmoeo2h1vGS73QO+7laVb1xGW/xWOSU9FBTC+5eEBSvuzN2XgzMQza7y0esVIm/J2CEAjcl6UZmupdwcQR3yyH0d1hp5FIhJtxoyPhVillSdspfHVdd17WrYkGB5uTcW6hUprL1EqlwFWQPICLulidfwVlFviSQrJujaDUzMn+pbMMPGXt7riCKb+EKp4iRqWd4Namhi6LgKudY+eHCXBfnQ5U9oA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(66946007)(52536014)(66446008)(66556008)(71200400001)(76116006)(186003)(6506007)(9686003)(33656002)(55016002)(5660300002)(478600001)(86362001)(7416002)(7696005)(66476007)(316002)(110136005)(83380400001)(26005)(8936002)(2906002)(6636002)(54906003)(4326008)(64756008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: POQu/ggoqUHLBKX2tnm6XkhK54g+s/qH2U5oAwWqCkkm7jsPoByjTAHnbqjLGmFFhp6oirRXpz5Y442cqaFpJIzaz+k00WqncjsYcTVtycyJkQxUlJBTgQpcUgsX9fb4nXCC0Dlkwo9fQgjeEN4TBE/5XhADoW/0iUo5SJ8QCmTg04y9spjHCCd7JQgE/Ei+lySvZpbuusfmrVS3MwCXX8VykiR7NyPnI7NhkjuJg+dZuXk36t8qsgvfD8cQt//vPtQQy7d4b+TUtgLBki3L2K+gBNwerylUIVOQUxJkpfN6RUnm1dJemlspNpJq5IwMuE0UoUqX4RmDr+2WqkaWBdZKtWTYoMPds1FXPMKczCr0L04g0QbXe4pnnp6BJdH/jAyWy6wrHpmkdTeONYopBjMbXxswQWrsRK3ok+tHRMixPmaF+tDxPhHXo2I0qYWf27CGFK4vwPNk49S7NWATEWw8CFwkoPX0/lBl8kAJ+nJCukdZlRP/sNvu/iI4jxr1ev3nUagXL/vsBLWIi8a/Yf2d9iSyDLcsm+lkkvVbSrhX0b6dmxhlwEYiA2EvbsXp+3oqrNRsgrXQn5uRvHLCgYp8rhC4vTlHZunnckTbnPSgGUf1bhuAXRh4cB/PCPpMsH20xpXReyuG0BqOEqMUSQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fd4889-6bd7-4014-1769-08d885e7fc4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 02:17:48.8750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k3K5WZAzwWwoPVCF5yn035BDrrwigpNSIsDP/7xQCC8dOyf1hkgTlT/O5t3ZzEbdAQQUyYBcnw7Nvyiijzh50g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2094
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 10, 2020 10:24 PM
>=20
> On Tue, Nov 10, 2020 at 06:13:23AM -0800, Raj, Ashok wrote:
>=20
> > This isn't just for idxd, as I mentioned earlier, there are vendors oth=
er
> > than Intel already working on this. In all cases the need for guest dir=
ect
> > manipulation of interrupt store hasn't come up. From the discussion, it
> > seems like there are devices today or in future that will require direc=
t
> > manipulation of interrupt store in the guest. This needs additional wor=
k
> > in both the device hardware providing the right plumbing and OS work to
> > comprehend those.
>=20
> We'd want to see SRIOV's assigned to guests to be able to use
> IMS. This allows a SRIOV instance in a guest to spawn SIOV's which is
> useful.

Does your VF support both MSI/IMS or IMS only? If it is the former can't
we adopt a phased approach or parallel effort between forcing guest
to use MSI and adding hypercall to enable IMS on VF? Finding a way
to disable IMS is anyway required per earlier discussion when hypercall
is not available, and it could still provide a functional though suboptimal
model for such VFs.

>=20
> SIOV's assigned to guests could use IMS, but the use cases we see in
> the short term can be handled by using SRIOV instead.
>=20
> I would expect in general for SIOV to use MSI-X emulation to expose
> interrupts - it would be really weird for a SIOV emulator to do
> something else and we should probably discourage that.
>=20

I agree with this point. This leaves hardware gaps in IOMMU and root
complex less an immediate blocker and to be addressed in the long term.

Thanks
Kevin
