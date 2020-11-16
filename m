Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2B32B5561
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 00:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgKPXvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 18:51:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:51951 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbgKPXvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 18:51:48 -0500
IronPort-SDR: /8dK/cYEtwdS+e2p+XY7rOEFGhZVp8l+wW8HPnkM2knVXEKwdNdnrnWd2G5t1PRo+aQ8QfoHHK
 5ASiXBC+81bA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="167324416"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="167324416"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 15:51:44 -0800
IronPort-SDR: EEML3/oCYGZmRafxlIjeCvW1j6NkXhboXu2o4KlZ8kFJ0jrstc9bHVmkdMd9x7u026PpLqsxGN
 vPXKK9dBA/+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="329875551"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 16 Nov 2020 15:51:42 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Nov 2020 15:51:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Nov 2020 15:51:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Nov 2020 15:51:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 16 Nov 2020 15:51:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WN6wJsNE0Bk64DsFl0VM1Rp11tAZHm0RasFrzrgF818/lDWUnj5whX9ADlqjn0avWgG96E992UtV/Lj7RIvNNIEJz6zvtTpwnQ38u/3rnbaZyDRWM7lDryLFoFNgJMuBTI3XiZMMie0Z0GqJXJ6RarhdyIWxL0G/hz6bimasza+I5Hna5VKzo/VaG57Wl/mrVoDspJyyOj744uDb5PEtsSuwYOcdkzAGxjhuFZqiEHjWwdrLxNCRf7qfbU7hA+QLbyrTJKbdfiu2jMCpH2Zzt76BhMCFb6Mdk0qfyntdRxjH5GHrWt6hhIQm8YylsNMXPZmrgma02NECprnvptvZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tfhFW+k9TFB5uwMLiUb/jCJbyyVv/YRvbtExHoc/8Q=;
 b=lm4K9aHqeXn15foSQR9kFDNQcTnHcSAdmC55M6eAu7jua5jHcWM9n8Yg+hcxSo02VpyA4sRsNzB25rmbXZ2LHYxWB6orjoz/+gYmLG6sQRBdzoG4G57WekD61jxNib9GWlOxXduj7UJvUcTrfAiCZefCUBsWkcnlqPyI5c41Rn+K0BI0CdaMwL8qZbCRJFGKjCczFYAdmEaD2BjwYxkll9CE1pbh6/uoG0onG1AWDBNc4ErKX1lh6xUb/k+zOd/RgYN5uUCBHH/oLij7BMk8vzdi4mRm0H/+nhPsNfo8zHjijhWw6oMx/dONuNpYt6NTENWjbMtx0sww+mGEOAHeWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tfhFW+k9TFB5uwMLiUb/jCJbyyVv/YRvbtExHoc/8Q=;
 b=knRm1pAQioinAtL4stc5nLt0ai1jds70yLJN8mO8Si+s1dWH8O6lb437mZYvDpHitkm7KofN/qr6RmKlAL5E0ndTDL6okaYQOzIO/OAWrXWOxmO1TCV9/zDPDCyttwg0VI2jWkDJxSjwWprVErm5P8XUIoLeup9eG6Iretc2mVc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by CO1PR11MB5123.namprd11.prod.outlook.com (2603:10b6:303:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Mon, 16 Nov
 2020 23:51:35 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::31c9:44c6:7323:61ac]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::31c9:44c6:7323:61ac%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 23:51:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
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
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAFeIgIAAPx2AgAEDTgCAAnqggIAANQ4AgAJZMACAALP3gIAA7NsAgACHqwCAACyRgIAAJKAAgABss7CAAJV6gIAAJFCAgAABt4CAAGAcAA==
Date:   Mon, 16 Nov 2020 23:51:35 +0000
Message-ID: <MWHPR11MB1645E87DBEFFCC017C4849CC8CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
 <877dqmamjl.fsf@nanos.tec.linutronix.de>
 <20201115193156.GB14750@araj-mobl1.jf.intel.com>
 <875z665kz4.fsf@nanos.tec.linutronix.de>
 <20201116002232.GA2440@araj-mobl1.jf.intel.com>
 <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201116154635.GK917484@nvidia.com> <87y2j1xk1a.fsf@nanos.tec.linutronix.de>
 <20201116180241.GP917484@nvidia.com>
In-Reply-To: <20201116180241.GP917484@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af8d7007-35c2-48ce-a276-08d88a8a8d4c
x-ms-traffictypediagnostic: CO1PR11MB5123:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5123338132ED3DBAF3ABA22F8CE30@CO1PR11MB5123.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3TpSnypx/BP+he98Xuyq0JA7+VYs0ltP2306yfAzm4F2Qnl5nIeRAHqxnTU/akIZlgG5Y2LpPFc+/qhQTgwM8yznhQ3AKWWBV6wJbCnTIRhrqfRLf4D23NN+Gcb4Vw3htVCIUhOnyIMoqdO5R9y1ZLV8tJXOIwxQjtDTlHRjqnHoR/TtFK9rgeJPf234AS96b8mEYwTg0YR/rsytyoXTEbjjVJ7LEB+032m45eqbwkUBnyXXPaVN59zD6u2nnE1UXi6zLiSO6WWbhDCY5IazRXzg9lJl2z84R88X8ok1qm3hFXD2cvwXg1r9ydfMu4FPZANT9z49ohertUotoUl4hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(71200400001)(86362001)(52536014)(316002)(9686003)(6506007)(8676002)(33656002)(83380400001)(66556008)(66446008)(66476007)(5660300002)(64756008)(76116006)(66946007)(7696005)(478600001)(55016002)(186003)(2906002)(26005)(4326008)(8936002)(54906003)(110136005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fUL3GDngRlcwlEFgVJ6y4VL9kCBL45yw5BCOL5YKcvc+A1hvpTteKT2ZK7iTM8tnHpLnX+yPf+FWvVi37hKxTvB++8DlerH07PmuxxskhC/hoFVinYElPYGZeGaJTZw55pHavfWgq5F01q+JF6Q6wtnHVCGy42GYOHimlOuy4by5DslNIVAbKih4QiGK8zV2oD/3SX1EvEP08fIMJAGsgWFEg04bc7tcYd0BWvWmw7zJ7ws/Zt6csZYJ0Q3fHevjh8L8KFgJvvgSwLAIW+tW4YjNk1mnkH/t86XFLjQ3ThqozqGkX3ZRkRSR742xUBq1alKWnoPstXGrfUUjovjb9j1vlvq4NwZ8lCodSub5uFsGIsyK8fBLq0rTsHQyRTAWtrmk2Brlg/ihCwlPjSeJW0Jmv1K204ANrITguOOT3ZdasDLQb492+6kJk5R/IMbofQHGx0EwDePir2zljQdqnPG1YqVFA2+MuhMjYCs+ZEpYCvU9OswkOrUy/8FMkv9KLLWcgpHq/xVwX8w7q4UN/cqd54R2biG9FXR6itKaEbO35pKkp13xQDD2uNc4LOex5xbbSx3CeQ2SJK+k2EW6FuWBHNg53a6KQhTJijiKR4Jp5zzL7+IqquYounGYLi192tCE+wCrnrugtVLGFSrb5w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af8d7007-35c2-48ce-a276-08d88a8a8d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 23:51:35.2075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S8VPyXzfEy8uJR2sEIrAOf4WT9fUFsaSnpB8CKP7g7FIezj4hIa8VspUn5uc2rjNYPLXkYjEKMzwleoU7T5DLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5123
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 17, 2020 2:03 AM
>=20
> On Mon, Nov 16, 2020 at 06:56:33PM +0100, Thomas Gleixner wrote:
> > On Mon, Nov 16 2020 at 11:46, Jason Gunthorpe wrote:
> >
> > > On Mon, Nov 16, 2020 at 07:31:49AM +0000, Tian, Kevin wrote:
> > >
> > >> > The subdevices require PASID & IOMMU in native, but inside the gue=
st
> there
> > >> > is no
> > >> > need for IOMMU unless you want to build SVM on top. subdevices
> work
> > >> > without
> > >> > any vIOMMU or hypercall in the guest. Only because they look like
> normal
> > >> > PCI devices we could map interrupts to legacy MSIx.
> > >>
> > >> Guest managed subdevices on PF/VF requires vIOMMU.
> > >
> > > Why? I've never heard we need vIOMMU for our existing SRIOV flows in
> > > VMs??
> >
> > Handing PF/VF into the guest does not require it.
> >
> > But if the PF/VF driver in the guest wants to create and manage the
> > magic mdev subdevices which require PASID support then you surely need
> > it.
>=20
> 'magic mdevs' are only one reason to use IMS in a guest. On mlx5 we
> might want to use IMS for VPDA devices. mlx5 can spawn a VDPA device
> in a guest, against a 'ADI', without ever requiring an IOMMU to do it.
>=20
> We don't even need IOMMU in the hypervisor to create the ADI, mlx5 has
> an internal secure IOMMU that can be used instead of the platform
> IOMMU.
>=20
> Not saying this is a major use case, or a reason not to link things to
> IOMMU detection, but lets be clear that a hard need for IOMMU is a
> another IDXD thing, not general.
>=20

I should use "may require" in original post. and one thing that I obviously
mixed is the requirement of PASID-granular interrupt isolation in the
physical IOMMU instead of virtual IOMMU. But anyway, I didn't attempt
to use above to build hard need for IOMMU, just the opposite when looking
at all three cases together.

btw Jason/Thomas, how do you think about the proposal down in this
thread (ims=3D[auto|on|off])? Does it sound a good tradeoff to move forward=
?

Thanks
Kevin
