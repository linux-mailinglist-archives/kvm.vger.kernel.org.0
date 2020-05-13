Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A8C1D0AD7
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgEMIaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:30:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:25584 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgEMIaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:30:18 -0400
IronPort-SDR: DhfuMFUmruyOu/GusEzg74Jc3dxbb4WRHC7uO/uuV03CpuIzjw9zEg2YYp/9qPg+tlPPHRdxSB
 PjRgit37S+hA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 01:30:17 -0700
IronPort-SDR: O200gs2YvUbsqLEcow2csnCHluXZy6srK9Wovlmtj06/wGmgNGeyAcHfDpBuj7nz2nPPR8v6oX
 YbMzik/HJtng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,387,1583222400"; 
   d="scan'208";a="306724111"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2020 01:30:17 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 May 2020 01:30:17 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 May 2020 01:30:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 13 May 2020 01:30:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3ZjXDvLS27e6KGyYbxd4pJu9intbfNa/IqjuhoEVFWrufJyj1QJEwkLw+2nZwC/rCQEE5udPZvR5OmAmG6oisHF/b+qSn7Sug0I5nODuHDNSSVoyGSptP2exFiwrS+3kbeemfc8kyUmeJS9oiLWATrmRT3HzLrWvjELidaZiQ4ElxSFS00m636p1oWkpdZH/03IxQbYUDtWjIp/treVPB4ZC9x4Mmnjl+/gSiELRZZXR957Ix8DUxxCZPd32nsgAxpE+jHAEg79QovxS+x6rr7OaP/N4oiM9oOdLoh30tiJb8I5T4nbgxDwjYNP36uEsLlPMOtr7UPtWLoHpknFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzYAqn3JSJCdjfWXaPVuk31bs1k0XNFTW63Hk+O3h4g=;
 b=Ss8MP33YjG5msKB6BktSU6ZS2cyyIT6IJ7otSXgzyyvJewtdXqf9pkNGogyrPQ0KDQQYKca7dbmksfhh91vzYD69QHTf1rEfrXNnNjzezu63WahWzHR6BIQuzRNiQhnpD7hJgz8Iv6CdKCKOIozzUc3vpS1N4T8P5wNXIvIpSo8mOVx2JGugt4p4A3iL/DWon+/duWRzP9fXh+1QufOScx6Uf0RHRGe/DSIXseQOTSxFkmSBI6AIj4jeXNV3fXUDJfFLrXFreRMeqFJcSzsewmvn7SWOZjbCfDwwmZIwzJ1ozxBh3CtTNa3PBW5c0/9loUgZsGrCID9PFUQD69Jiiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzYAqn3JSJCdjfWXaPVuk31bs1k0XNFTW63Hk+O3h4g=;
 b=cmoclXMDiRuARdoEuIVAMOTqLiLcqMHCldxBY0jpBbIEvdVcKvGcbfyUTzzp80lQ1F3Jpw7sipQPl8eGY3x7mw26ipTATWcxFO/hAH/88DyQYFdLijyQPokBxSwHi+OqN5p845Vxy3EpS1Tb/sWjEZBgXpUgSlVjs+l5MFtfBhk=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1280.namprd11.prod.outlook.com (2603:10b6:300:2b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 08:30:15 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::bc06:71a6:1cdd:59be]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::bc06:71a6:1cdd:59be%9]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 08:30:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Thread-Topic: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wCAAD7wgIAAnasAgAFwKICAAOPOMIAAQj8AgACkdbD//7b+gIACl9WQgACeIICAAI58gIAAiiEAgAAWu4CAAAC9AIADZPhQgA7nFQCAACmhAIAADs6AgADMiYCABdYv8A==
Date:   Wed, 13 May 2020 08:30:15 +0000
Message-ID: <MWHPR11MB1645C60468BC6C6009C3DDE28CBF0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com> <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com> <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03> <20200508231610.GO19158@mellanox.com>
 <20200509000909.GA79981@otc-nc-03> <20200509122113.GP19158@mellanox.com>
In-Reply-To: <20200509122113.GP19158@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38af6b88-b2d1-4f8a-48f4-08d7f717dcaa
x-ms-traffictypediagnostic: MWHPR11MB1280:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1280E0A475FDC0DCD167E2158CBF0@MWHPR11MB1280.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jNsMxH63xNiVQtDr9wzw7tk9uKS/4G1MhkvVaFuy4Tb+lXGI1wG+skKjg7RhRrEGnGTdZvPelI7NPlQ3ZWpAiTfsjvST7rpqKyryq42cZfpL3N8LP+Y5IUv6De7oFAJNgyzMqM3dEUSJja9fsCo8e23Dh4BfdE7nygNLAiKVUf1GhNbp9OpO3HWZhPfttz9gX3ahyiqKIzHD0Ad0I4qQCieBcc469QtO9JjaaGeUQR/z9wnZFnZFv1PCswh25sziOYDX4g2KytYa66ppP96f+UuBqnUZjQ0panR5/eYUhXh1LIB/sUNm3OEMTBUuPpeSzT+/MduOg77RS1hjjk3VljdCrjcTFk2QFBu5AmC9sAj1k4Q8N2NoXfcySAOt+hBdTrNNbzcEB2aOtGaOVTlbuTOXkfroFHChkbDiBBsQM3SU6bvQhXTH0J52I0pTuNJvYeuhDm5tuWuJQ5GNDp+3EDy/Ind78I5nT6GKOcMqLWeT1II/11Ozj9EGfXuwFUZvsacnUGsiOPos6MIW6pBCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(33430700001)(8936002)(55016002)(26005)(76116006)(6506007)(316002)(33656002)(7696005)(4326008)(9686003)(52536014)(33440700001)(7416002)(64756008)(186003)(6636002)(66556008)(66476007)(8676002)(66446008)(86362001)(54906003)(5660300002)(478600001)(71200400001)(66946007)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RrWT69DGCK9QzfhKdGFAkfY0PRX688qN9vROMon99IEsecKbNJucTyJ4mBnP7fOVgy83+/vwTnjBwnWUK4xlcpwWi+XSvhKnnexR65/pRHzr6TzJHq99Xy6TH8UvfFEOrJvScvQdutP6Q3xkaVlMfQXDEMeQzeN6e+bCZvpvdI9pUR7fktAOoT5/P7u1/Z9XlTfFxl3d5Tv6eOXn0ZBXdTs9IswPKpkI3HBeh8oToQ0hJyQWBT2NwUjQO+uMQ5OM5IbrHmOFXWF1/+WZ+jcuFBL0hgg/eg3zrNzH3at+dqX7gd3gyxTr+7EAaewoLdvp1D9Dc4j7wo3nP7DeE9JMedFwzE0BKXSAABwt8/svn8VCHnu0U4EL4wOy97TG4WTUWCVvRUQJ8GdXQ0TPKIR02gTdzThT0ga9dpmmp4R/zkzZPnKdgqrJlO06LDGSXTL5eGmMIncfG5swSFvf1trgjO8OZU61+q9T+nJpTrfF1QQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 38af6b88-b2d1-4f8a-48f4-08d7f717dcaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 08:30:15.1531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7NPaJ3KKvx5w8I0WzkcmTdll9ceCyTjGzykTM6WAwruqtoDyFN1Wfg6Ad2dOKH5ESQZvgLTADc579Uz0qWHLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1280
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Saturday, May 9, 2020 8:21 PM
> > > putting emulation code back into them, except in a more dangerous
> > > kernel location. This does not seem like a net win to me.
> >
> > Its not a whole lot of emulation right? mdev are soft partitioned. Ther=
e is
> > just a single PF, but we can create a separate partition for the guest =
using
> > PASID along with the normal BDF (RID). And exposing a consistent PCI li=
ke
> > interface to user space you get everything else for free.
> >
> > Yes, its not SRIOV, but giving that interface to user space via VFIO, w=
e get
> > all of that functionality without having to reinvent a different way to=
 do it.
> >
> > vDPA went the other way, IRC, they went and put a HW implementation of
> what
> > virtio is in hardware. So they sort of fit the model. Here the instance
> > looks and feels like real hardware for the setup and control aspect.
>=20
> VDPA and this are very similar, of course it depends on the exact HW
> implementation.
>=20

Hi, Jason,

I have more thoughts below. let's see whether making sense to you.

When talking about virtualization, here the target is unmodified guest=20
kernel driver which expects seeing the raw controllability of queues=20
as defined by device spec. In idxd, such controllability includes enable/
disable SVA, dedicated or shared WQ, size, threshold, privilege, fault=20
mode, max batch size, and many other attributes. Different guest OS=20
has its own policy of using all or partial available controllability.=20

When talking about application, we care about providing an efficient
programming interface to userspace. For example with uacce, we
allow an application to submit vaddr-based workloads to a reserved
WQ with kernel bypassed. But it's not necessary to export the raw
controllability of the reserved WQ to userspace, and we still rely on
kernel driver to configure it including bind_mm. I'm not sure whether=20
uacce would like to evolve as a generic queue management system
including non-SVA and all vendor specific raw capabilities as=20
expected by all kinds of guest kernel drivers. It sounds like not=20
worthwhile at this point, given that we already have an highly efficient=20
SVA interface for user applications.

That is why we start with mdev as an evolutionary approach. Mdev is=20
introduced to expose raw controllability of a subdevice (WQ or ADI) to=20
guest. It build a channel between guest kernel driver and host kernel=20
driver and uses device spec as the uAPI by sticking to the mmio interface.
and all virtualization related setups are just consolidated together in vfi=
o.=20
the drawback, as you pointed out, is putting some degree of emulation
code in the kernel. But as explained earlier, they are only small portion o=
f
code. Moreover, most registers are emulated as simple memory read/
write, while the remaining logic mostly belongs to raw controllability=20
(e.g. cmd register) that host driver grants to the guest thus must=20
propagate to the device. For the latter part, I would call it more as=20
'mediation' instead of 'emulation', as required in whatever uapi would=20
be used.

If in the future, there do have such requirement of delegating raw
WQ controllability to pure userspace applications for DMA engines,=20
and there is be a well-defined uAPI to cover a large common set of=20
controllability across multiple vendors, we will look at that option for
sure.

From above p.o.v, I feel vdpa is a different story. virtio/vhost has a=20
well established eco-system between guest and host. The user
space VMM already emulates all available controllability as defined=20
in virtio spec. Host kernel already supports vhost uAPI for vring
setup, iotlb management, etc. Extending that path for data path
offloading sounds a reasonable choice for vdpa...

Thanks
Kevin
