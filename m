Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEEC293E7C
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 16:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408012AbgJTOTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 10:19:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:15932 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407969AbgJTOTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 10:19:45 -0400
IronPort-SDR: I9V8k32EeLztVg6C2KHiZJN5PdKYdoi8anj1HTk/0u5al7KEXKVoYVfrCUDcGkaJKrbafCYYWM
 PXb9Y6XWBwIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="228844844"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="228844844"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 07:19:43 -0700
IronPort-SDR: ayJ9y+Ag0/lCVME8tvfxuKaH72LS+e/ekCve6823VKeEqQzPH9bbag1rZM63XG8fsTj1aSqbGO
 L28/o+tPvNiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="332267973"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 20 Oct 2020 07:19:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 07:19:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 07:19:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 07:19:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 07:19:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdNw2sUqmZStgd0okhW7UfRIM/QfH6ZXH8BzJC0CvRUwu+8GW2MD8IjJ1jhGJsho5hjnRC908tVT/By6+NUFYdGJ/3FmmcgWyNb/mLneGpxM6BTveIms5Jh2htFykQL78ULnmV9Oy/0XsyRBIx6BKd9GdSVKQNl3O0XoQVxkL2hWKnYurdu3gk3nTZNY5HNMoRMEnffBDtwdtoC4STV0HdgSQKFBbwuDq1y5HHTWa1hFbmohmGOtUDEb6DUCmgHsznPStayQIkK2ZzPQ6XcafGodB8CwMIHm05mf6/+oRpMRuQPMl6zKrErhAdpvd2mgGM8Rzmiwk2m/P+ioKBVs3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSc8MN1mZ+rHYPiJS/UBNgZeOs0XAmvcLONVbFTNtz0=;
 b=DJgdzcO7kvHrAHAH7i5cypkrMJCk3pu6tNmHhUGAklQZS4qk2SnKXAE0R6lAcptcFkq+lBnoFjXpeZuDD9XmUYRTF6GMbwjF2OWBBf9qYcvYovtveUGUJ0t8hXKd/84gNps6ZfpdI9Ow5cY5sT9W+aUwfp0qnuAB9lXzEC00eaz0baq/yLq+GN1cDOdV2OZzl/9peutTDDlmFCYVJbFdrQEje6xgvWxZ4+9wX80qm5rfAhLqVkH9180BEtslZF1j0mrpacpRFLQL3hS7Nzs7DWh2zCuTtSSsWBgCxuTWCK6YQESorkv2Z47jxs+jt0N9gj0vZmstR8nvboc21m9UJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSc8MN1mZ+rHYPiJS/UBNgZeOs0XAmvcLONVbFTNtz0=;
 b=F2PrgYSURjIsPSjyFo5g60LNzSFoxPT3H3KLBne08rUPPxbZb3g8Hv4bdKxi+fv1N1HYoRWEdgMMtjZwFv80CVDs0L3QZZ/sq0ikLuGgaTlT2wQP+bF1iTH58vq1JnKkOCxnYRghvr+Zs/mRMi9mfZcDitYqIX4iK2E0RLqakVw=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.28; Tue, 20 Oct 2020 14:19:38 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f%11]) with mapi id 15.20.3477.028; Tue, 20 Oct
 2020 14:19:38 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUABZWmqgAH60bgAAh22vsAAM9nEAACSNTfAADO5TgAAARWag
Date:   Tue, 20 Oct 2020 14:19:38 +0000
Message-ID: <DM5PR11MB1435CCC75952FA94EC050CD7C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201016153632.GM6219@nvidia.com>
 <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
 <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com>
In-Reply-To: <20201020140217.GI6219@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [221.220.190.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc0bfda3-48f7-4fb1-3c97-08d875032de7
x-ms-traffictypediagnostic: DM6PR11MB4202:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB420217C5984D2511326B7569C31F0@DM6PR11MB4202.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 132j27Y53MHm6Xdver5iZGV2cNCfMuGVbvs4EbwOmIJGU2GyfLsrdFRIMIza/I6/jffkV7ejeU7y8/JJL6EhUoI1Pwblqy7IJfdEcGgZZzGzGUGW2xy9mpnAoK3rv42PM3PWSi607tD985xOcka6n2rfHkQ1UHmfypDj5W4oW0pGE9aVyKqj+P1XBsXZn9Prr5x+vhpUnGaNijwmKeRQk5Cr7IxYtEaIWbms4ZAeIlK2Ymlu49eC4QT4Yl8GbGTJ1FitQEjDdRnoWu9fvlT3L5RtBPHTD0vKw/HWINULXTYudkaoaL70g8PTkD7ZYWPU8A4uopmCgFtlpSXAVQIlRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(7696005)(8676002)(71200400001)(6916009)(55016002)(33656002)(186003)(6506007)(26005)(8936002)(7416002)(478600001)(54906003)(2906002)(52536014)(9686003)(4326008)(316002)(86362001)(5660300002)(66446008)(66556008)(66476007)(76116006)(4744005)(66946007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Kselmz+K2grE+chnEyzLgd5tAfoDO0sk8d7KQ4ajgoNuNWc0JauOWOoPZwQpjz7EH+fzP+s6pEmKFlABtWcksM8uUhaRfQLIBVIeHmuYU3lxh47PZO6yEd71/+zOBT5k/YzlS/+HhB72FWCLtBw38DnblDV4Xl6av3hzUoXmYfN9W2L3SxdgweMWdY/8zWMqRYqdsL850LhkJoOEgK9ezXmw61vQYZnPgEeNMs4h6fC2DCV40ocEOUemJ3kkkZ3rMEvxlWvaMT7d1ji8BsiJcfuwiuB6R+QJVM9hD3QAV31OnKfCSxS2Z+bowGmMPEpSK9OdtBkqp68qAww6hpi6S+Xnrx64m1HNTwyNMYsJz+pu6O88PuzpBb9391oYZsuDhgDFPx9gZ5nA+QW/H4gYASCGlK7UJS78RMhodRX/C0RkqSoDuHvrNpf41kTIJRPK34lQYj8jI8qgxCF6NRRHbdwjqSbjrBdIIeVRgUzNOCK4uxbEJnk7UTk0CEUOkQ7Vniq1IlF1IvpvefipjA6Br/106w4x8bdzue03qEP1uzhZmhCGiAQuMoB6YsZvXLRvpuJYaC0aXA3OGSQl6y65u5FBKpuGLI+iRRyZ7Ishsp/qgQT430hPeXyESIXF45JnReMjhqrcwQN5ymwSa0w8XA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0bfda3-48f7-4fb1-3c97-08d875032de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 14:19:38.6996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4FxNonqOBanahmwZrBkOf8EHz/nj+w4JOZ+wC6pEpdebtv+1nI8Xviie+iC+DH2oo0Hmozk/kC2sKrGC9LFGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4202
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 20, 2020 10:02 PM
[...]
> > > Whoever provides the vIOMMU emulation and relays the page fault to th=
e
> guest
> > > has to translate the RID -
> >
> > that's the point. But the device info (especially the sub-device info) =
is
> > within the passthru framework (e.g. VFIO). So page fault reporting need=
s
> > to go through passthru framework.
> >
> > > what does that have to do with VFIO?
> > >
> > > How will VPDA provide the vIOMMU emulation?
> >
> > a pardon here. I believe vIOMMU emulation should be based on IOMMU
> vendor
> > specification, right? you may correct me if I'm missing anything.
>=20
> I'm asking how will VDPA translate the RID when VDPA triggers a page
> fault that has to be relayed to the guest. VDPA also has virtual PCI
> devices it creates.

I've got a question. Does vDPA work with vIOMMU so far? e.g. Intel vIOMMU
or other type vIOMMU.

Regards,
Yi Liu

