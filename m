Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E945C249764
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 09:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgHSH36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 03:29:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:25275 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbgHSH3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 03:29:54 -0400
IronPort-SDR: YLKm1efn5xwNBaPTBVAhf7RJDCA7sY1d8D84DmwvjW3UUm2U6Ao+dPVMA01xR8pWkLjD+5ot53
 zbw8eh2nhojw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="155032359"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="155032359"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 00:29:53 -0700
IronPort-SDR: NJUtkLg0HgKlVcWiCGIswdwlYrCgo3+PvldB23TW1KukMOkbjRsON1SPb8rZFJjyfO1cm0es2G
 dzod5EKk6RqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="293032181"
Received: from orsmsx601-2.jf.intel.com (HELO ORSMSX601.amr.corp.intel.com) ([10.22.229.81])
  by orsmga003.jf.intel.com with ESMTP; 19 Aug 2020 00:29:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Aug 2020 00:29:52 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 19 Aug 2020 00:29:52 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 19 Aug 2020 00:29:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bA+Zw5J2Y3UMT1+7U85WKKzN3rJ0tmSNJHmQJmWU5hQx87/H7raiChdsSADxI5kgFvt/RqV2RcLu5qnorP2XLH7pH6fjOxZZ1QoTl+C08MLzNdYKlytdEw7nLPEkIXR4HoJ4B6Z8wPUR2+wOWB5zFIl/FZQ/9xsXc2LSI9cdJwYiewoWvigAywpzjNOgWmjixbgL1UNJNeH68eJKIU4X+wTsW2NUf4bxlWbN21nng09fv6x635Ixp69sL+mahsVee0UwNAwjaYEGrRanBrJl2FKDtxgfoEDS+IlyqoeuRpVvwGNgrQiiaOg6szbXDbzae+3jU9e556vUL8lgvDmBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsnPIgZe3ByZJjaLyfB3d3pyBbJ5gZBVExNiaU/Nt94=;
 b=i6iHXJ80j0sABrjBOopYC+BvRLKqyKdVPPiZzzDIcRNKS68nGBMwatp6QZQEZvfA+NWaUWL6QvQoz1wQJaeorYoEmpXAvP7wvXoxe/H0uUWBGOxtsB4V7Rg5JqAKAgKE8cylybN/Tkl3ds1b4smXlh37Hw+ZHpbqN+pE0ujup+BGM91+vZRZVjpNdzhadfEWO+eUlwGI3lKoSXLPsFS0/2tmlrB2pmOPF2gHsfWuKq5Y+l/NW+/XcqnOXBBP/CxHkLBiI3l39Ka3uhAVyCYxbF5HTXjcOSfA8dx3+GHxQylfaiqN2mbOMnk9AHmHsc/OpAd19jRMoufOI/t36wYqWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsnPIgZe3ByZJjaLyfB3d3pyBbJ5gZBVExNiaU/Nt94=;
 b=FXLM4z1m8jhTYQLigO8ACKrEZvOpvUQm4KKqnct1RaEuQwEvTNG6PFyGq0YC1Kch0jizpgp0YvpIAUgXRzDCQNGyASlR3BTGAhPtlgRCmWejXsdLMaVOHi+Rekw8LqhZOykYGddNIpMcdZ3vzKrPTemfrLV7q/WPMv3b4eemHLk=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1710.namprd11.prod.outlook.com (2603:10b6:300:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 07:29:49 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 07:29:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
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
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIAG4akAgAPzRxCAAX50gIAAAjDAgAC3+4CAATW4oA==
Date:   Wed, 19 Aug 2020 07:29:49 +0000
Message-ID: <MWHPR11MB1645FC76A1866EA6A7C9DA6F8C5D0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818004343.GG1152540@nvidia.com>
 <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818115003.GM1152540@nvidia.com>
In-Reply-To: <20200818115003.GM1152540@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ce6a325-c078-45be-1d2d-08d84411a819
x-ms-traffictypediagnostic: MWHPR11MB1710:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1710B7813EB6D51D7381A5CF8C5D0@MWHPR11MB1710.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrFrot8wT3Yu5hh8VSn8ZdTZ7ojQsGuy+2ZIFXN+4nxHQv+Ifrq+rYj/s62u/9J2JGwX8cE6V34bGrSF801vaw4RW/Olj5hd6e9asZkH1b+TzMEn8XqO833u0UCcZC0cGx2rzcCJLdtAV9f0cGCXIuEmQkEok8xx4YqS4Jhzjitvdk1rAfFnlmcju6DjXJ69T+nhOOhe9s2jLUgx9QH2Ec+7+RwptYJfWBdBMX6yao0Lb9DjCA4CkfumOCnuz3dbpu+SZ/NrupRy9k1zKmQ9inPowb844g/ccP35ptetVmRv+wQgs4I0bTbyR8b0akcl1f04rXtDMJfA1HZGkP67+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(5660300002)(66556008)(66476007)(52536014)(83380400001)(7416002)(6506007)(26005)(66946007)(8676002)(316002)(64756008)(66446008)(54906003)(9686003)(76116006)(7696005)(55016002)(4326008)(186003)(478600001)(6916009)(86362001)(8936002)(2906002)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: muCPMC/4aG6qvOza8gaVDkJo30FcCmsOjAtOKJaCf3srlBU8QUwLoiJMDMmw2LkfgSUIKaoikljI1y349VJgexz2r5MfEZJuo8GY4TwQWha+iZuOcvuTYtWfikUqJP0EXK4FqGAZAVbIUlAlDanNFh9NYS98It8bbAO7M1ePjvfSrmjsxPmn0j3NxzwvYmNKXEO6GfwUEh/+1OCb7mS71NYGltWMnCiDG4/ncdaiR0BvC6ag+hvs19ERimBbL3OOla6v6iHXbke5NFK7aX56ytnxN8oVmPgXQgkPQAk/K4LajB8nkEi1efu5XO9u1Dk0ezpfWyMlWgfXM4g00HwQ5M3+l9IZ28cxJIUMUtrh9MS6nmzkqQKE/aQdPoCKteK+I8ghEDYNqSt0Orb+TjSn229gRHRDraTfS8a60KLGb4XKeApen6KYeNs9VtXZjDx5kdzSlOXZAaXNj/7Xc6CTBtaqwCDbH2ACElVglg0rh9W0bY7ep8EQTFWoqhgeRMKxv4TaPwIsfL/IuZ391nggZa8MKKOZvdq6ph81qWdapWBQQAtpbl/IYjjddhVNBdgAXezUSiQktMiVT1g+O8ievYINWhL/pl0egnGqONb8iPFX9zHjYBnL7D53Z8A1afEK/Ul16VDK5jrJCpqNMWohlQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce6a325-c078-45be-1d2d-08d84411a819
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2020 07:29:49.3628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CDGtMIkovCwhYlRPI8N0nvjsBtx2AaDFlTG65ZanhxMcFpOqEAJKP08BCShRHW4AQwjQE24V60Wtdj81yyu1mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1710
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 18, 2020 7:50 PM
>=20
> On Tue, Aug 18, 2020 at 01:09:01AM +0000, Tian, Kevin wrote:
> > The difference in my reply is not just about the implementation gap
> > of growing a userspace DMA framework to a passthrough framework.
> > My real point is about the different goals that each wants to achieve.
> > Userspace DMA is purely about allowing userspace to directly access
> > the portal and do DMA, but the wq configuration is always under kernel
> > driver's control. On the other hand, passthrough means delegating full
> > control of the wq to the guest and then associated mock-up (live migrat=
ion,
> > vSVA, posted interrupt, etc.) for that to work. I really didn't see the
> > value of mixing them together when there is already a good candidate
> > to handle passthrough...
>=20
> In Linux a 'VM' and virtualization has always been a normal system
> process that uses a few extra kernel features. This has been more or
> less the cornerstone of that design since the start.
>=20
> In that view it doesn't make any sense to say that uAPI from idxd that
> is useful for virtualization somehow doesn't belong as part of the
> standard uAPI.

The point is that we already have a more standard uAPI (VFIO) which
is unified and vendor-agnostic to userspace. Creating a idxd specific
uAPI to absorb similar requirements that VFIO already does is not=20
compelling and instead causes more trouble to Qemu or other VMMs=20
as they need to deal with every such driver uAPI even when Qemu=20
itself has no interest in the device detail (since the real user is inside=
=20
guest).=20

>=20
> Especially when it is such a small detail like what APIs are used to
> configure the wq.
>=20
> For instance, what about suspend/resume of containers using idxd?
> Wouldn't you want to have the same basic approach of controlling the
> wq from userspace that virtualization uses?
>=20

I'm not familiar with how container suspend/resume is done today.
But my gut-feeling is that it's different from virtualization. For=20
virtualization, the whole wq is assigned to the guest thus the uAPI
must provide a way to save the wq state including its configuration=20
at suspsend, and then restore the state to what guest expects when
resume. However in container case which does userspace DMA, the
wq is managed by host kernel and could be shared between multiple
containers. So the wq state is irrelevant to container. The only relevant
state is the in-fly workloads which needs a draining interface. In this
view I think the two have a major difference.

Thanks
Kevin
