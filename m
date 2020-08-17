Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205C0245AA4
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 04:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHQCM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 22:12:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:48970 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgHQCM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 22:12:56 -0400
IronPort-SDR: KSkSoYR4chvZP7gSTv7x8j1SVkKc9bAFT+BgIs5D9VHYM48QH9UJl9/4nGZEUeMtIB0V4eFqwO
 B5xX7wWrkRqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="172677203"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="172677203"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 19:12:56 -0700
IronPort-SDR: 9ipYxT8Pn5lg+60KITjwmE4sViwsRl3doUC2/3ZF820G9KvYCsntBANKL++w2zBHri0ieVC1ZL
 00IRtOgsj85w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="370428437"
Received: from unknown (HELO fmsmsx604.amr.corp.intel.com) ([10.18.84.214])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2020 19:12:55 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 16 Aug 2020 19:12:52 -0700
Received: from fmsmsx103.amr.corp.intel.com (10.18.124.201) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 16 Aug 2020 19:12:52 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 16 Aug 2020 19:12:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Sun, 16 Aug 2020 19:12:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1K8oV+qYr3UEUWiaPRp/5+lEqpVVWmnAfpT+IzG3kpim0XLGf7dPR+GdGFr6jvKWuq59bLYbwhmQf4X5jEIezDpcjCAdzyzaBkoxMW2S4cecCBksqSB+BKoeIcNQAp6A2o9ak7Xl5/CXygJ0L358yJN02O+UDsmMbVB6Di5m3/y7+Hzo3/W1KFBtWLy4EHuVKtmHpV5stLcLPi/b80NqFdsGczoWl++I28qMtWWC88XRTuaiUhUpiw3pHs9uUfBAs/ANPdCbkhL7YwVP9KFJZVgHgMY/PlZnJHXvyaAxxn7shF18yWBp3uRZ5XOLiSAU9jirTT/1xRcOgW3l+uSTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpRcjphMc/8RrOhtA7SllUEb1auoZ0lLAdbGViWnv3I=;
 b=Jpa96gvFlonCH/CCRo+NAz4dkHf6zr+9ggsLMZyQ7sTwrJsxNKxCyqCqpWm91qzj9p/4Gd5nUgI2cDoOhkGUlginhwLr1Ip1xlRfBjttYsjw8mTiEBKWR7fll8V/lyYFtc9adBwwWld4u4sEF09Qk5OSkFnu5NThlZkaekZtVpQNNalgJU7dgUeSl/hsW16F3sogpXEoXuyBL/Zv2UagZbmzHpPh8OoWyLgWum5lQWQ9uW6bg7W1qOj2pg04NWwERWIGJJMjh46UBbKfvlY8W3QrhWPtF8XB/5JkJj+Tg3YE2VACXwGMkJUMYtofworoRZhBqCfyNW/3n4xXZK5V/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpRcjphMc/8RrOhtA7SllUEb1auoZ0lLAdbGViWnv3I=;
 b=sXyWCwueiNwlhOksOVG8fCTUvkm9SOgoTl37tr3nvSGukbpQyZjhDqNfa3iziNAr9Ouy3yhH4xwlbhG13DjK/WvtoUDm8p55/vLhbQU9QEOu4ld/oypTV0xjKoomS9DrVN/NVMioxIfjPnjEwVYGIkKUemmusXqA5mB6LFf05gs=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2094.namprd11.prod.outlook.com (2603:10b6:301:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 02:12:44 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3283.027; Mon, 17 Aug 2020
 02:12:44 +0000
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
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIAG4akAgAPzRxA=
Date:   Mon, 17 Aug 2020 02:12:44 +0000
Message-ID: <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
In-Reply-To: <20200814133522.GE1152540@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5401b0f-19c5-4679-b40d-08d842530749
x-ms-traffictypediagnostic: MWHPR1101MB2094:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2094538ECCBA3D4EEB0157D18C5F0@MWHPR1101MB2094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3qw3iICC0+BJ6GMZZB1vRDw/4SNE732NzDG3OycrjPfYfQ0GT+9eJfR5LCDP6jq9rtNT17Co28VVrkdRf2yIxtd6o0DROBb2bqgV3lMdEkcHofMOBWsN68JW8HDraP+nFmABL8ka3U0t+cADiazo41PkAWt6POLVXb3XibWKc7XS3p7CmZZmqwcCIIuVaCdXu3GJzG9zGv04usfzsCq4iawjQofnE1XIWoO9/bVkR+a4rd29b6wqd/pMsGFkLopGYFJEvXS6pgjX8r0eHqSsPXvyXmgXMlN6T6HrevVV7awNo1TxyBworDZyZ2SygghxqLvrJzt2+in6w/1Yb91mpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(6506007)(478600001)(26005)(6916009)(7416002)(7696005)(4326008)(9686003)(186003)(2906002)(8936002)(66946007)(64756008)(76116006)(66476007)(66446008)(55016002)(8676002)(54906003)(86362001)(33656002)(71200400001)(66556008)(52536014)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RMF+B6Kvg11cV7qWbUZkjoeWpAlIOENJZqw8IauDu2ppxlGhiQoUp1gWozs5PmKVAQSxCn8hvhcmahCUamNhOWw8z9sTyIJKT7RuqhvugjJZl0s7/BL0JWimwGyziPADeBcdzc9OJGA98dozxWaiDxLkClaqZphKSoPJf7bX8vccnCMoyL8IIk86GylWN/fITXRGgSDPExUQ//eAWVhFFlRGwUFB/0k9WaCXy12ndI62v10G6SigIFttQPjds1Lg7ZW1NLQYdUxC42b4thADRwTy4Ir4RnavablvoA0uOraWz0lXhsGIl1YCbiQVY9CFSZ6S0BAADTXwHAAP1WVXclBpiYx4naPcx0011rjMCZdshdEetU7Hu6x0u/4E/hPxjvi91+9hxIpUv/XK3wULDReIEVwNAyoroKurDlMDGH89h8ogV0YZS8/ragZKlqJTGYRMMWFcihf3CqcvlTemWoauapVIfk/LvmG5hMjSY6+PVc+f7f4mW+qEXD+/ZpKO1j9s5taBdQOjDhM25XhazO+4aGuIPX4bhYKlDltBvskjO2qVvufU9SyfMIunMM0e5yrTDGctrEbPygyl9vRx+SRPEOvby7D4gGkzusOri7Hr1RB3+X6rA7RA2GzoLadmqQFizmP/RL6yRtth67k9hA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5401b0f-19c5-4679-b40d-08d842530749
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 02:12:44.2635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bKJx4V4JxaYDTDFJNAnA/5Sc+VQuBvKpXXkfLFj0nVqb9cpNC/JqgNLU5P4vkJu14oAlzP0/Ey20hXtOqap08g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2094
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Friday, August 14, 2020 9:35 PM
>=20
> On Mon, Aug 10, 2020 at 07:32:24AM +0000, Tian, Kevin wrote:
>=20
> > > I would prefer to see that the existing userspace interface have the
> > > extra needed bits for virtualization (eg by having appropriate
> > > internal kernel APIs to make this easy) and all the emulation to buil=
d
> > > the synthetic PCI device be done in userspace.
> >
> > In the end what decides the direction is the amount of changes that
> > we have to put in kernel, not whether we call it 'emulation'.
>=20
> No, this is not right. The decision should be based on what will end
> up more maintable in the long run.
>=20
> Yes it would be more code to dis-aggregate some of the things
> currently only bundled as uAPI inside VFIO (eg your vSVA argument
> above) but once it is disaggregated the maintability of the whole
> solution will be better overall, and more drivers will be able to use
> this functionality.
>=20

Disaggregation is an orthogonal topic to the main divergence in=20
this thread, which is passthrough vs. userspace DMA. I gave detail
explanation about the difference between the two in last reply.
the possibility of dis-aggregating something between passthrough
frameworks (e.g. VFIO and vDPA) is not the reason for growing=20
every userspace DMA framework to be a passthrough framework.
Doing that is instead hurting maintainability in general...

Thanks
Kevin
