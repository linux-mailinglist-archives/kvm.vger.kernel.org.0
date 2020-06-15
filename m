Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15ED1F96C3
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgFOMjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:39:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:28265 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgFOMjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 08:39:46 -0400
IronPort-SDR: DhyCq68Nwn2o5PcD6CUIEV04CK9gkD1J7kAJwvwu2cWrANW2EtqXtwIaMGCb4FcLTOVEFheoMu
 Iw/NlXx6hEvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 05:39:43 -0700
IronPort-SDR: 8ahugOWleSOYmag3ktHAHwVFudD2Qb+R/UDNDLaTsEdzs/y+bxrX1SYbYZPW6y38fbZBw74TSF
 /DQ9WB1kkjNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="272756106"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga003.jf.intel.com with ESMTP; 15 Jun 2020 05:39:43 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 05:39:42 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX126.amr.corp.intel.com (10.22.240.126) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 05:39:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 05:39:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWfIyMD0WRsyBsTjdwsIsHseavtgW1u9kvscDIi2jSTs4UfDFLLCc6v+zEYE0rxhaPcrYpOeA+FwIcHLlGDHXHfyyOqueELJUsVefjITwZv+jE/HZjCT6ZmggKTPb/pkbntTJivp0lSS7PIfAWg/FN7JMmpnlWWZbs3sROVh5Po8qcumadOOVm2JFD1qpxkNXP8vQcZWplea+3SiKwdMYIPgil7F2D9fzZwalGd3EAm7VqhFwdnXGKTY5qhwND5Gl/NRhbxhv7jaoWGMsag1ve+2xjjt0EX630AuFMnEwjaGBz8fJlhdCqXn1Q4fO/+B6yDq+NiaBm+t4ahH88aPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLMsGXSVuuIs8wyR0zgMnsIv3XiMpvn0ABsrm5aWcko=;
 b=UchB8s2qCVKZKo31BCyk2C9R8A9GnAlK5L+NZdxRyBt/Zq5CQWXsVWN0V4CdRKqVGR1c/S6wXtCZ9mFEK8jXX2lYAMiRBOmOYgdWigQwfCXAREuZHP5subg6PSodHlrU+HvK7r09mNcCfDnZEeFrcKRANgRqxaC/quj0eOGlbNOBq07xhHzQpimP1ilvyqq0CQIly/OSy6j3p7p59XlzujL1n5c5iP7q2a6Jn+yEyO6fdjEUWTJYj/Tea/zMUX9TyyyhFq2r7zTRD3cwaC0XPnvh8VakDr71nNYk2XwSpxD7ZXDqecZoP0Hs/YESbsS2A3HG9TTPgqfIZKvd/R4hGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLMsGXSVuuIs8wyR0zgMnsIv3XiMpvn0ABsrm5aWcko=;
 b=wMNF/zrh1Ri0Zd1js+0RzcqyJwBv7zVxWBxfGy403Sr6CqfGPg4U3HNSnWD340tkcvPZzCYva1y6bJQYRGLriDCgihtLq2qXT+/4qK5AWbTTiYwwqQLwQFtqdcBGT61CfXT1Sic9Eh9bKNs3s4aKIKBhL3aPShXsb1y9p4W5v78=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4074.namprd11.prod.outlook.com (2603:10b6:5:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3088.25; Mon, 15 Jun 2020 12:39:40 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3088.029; Mon, 15 Jun 2020
 12:39:40 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Index: AQHWP+kpbV8I76mMTUKWVPLrPDAapajZeEMAgAAfcNA=
Date:   Mon, 15 Jun 2020 12:39:40 +0000
Message-ID: <DM5PR11MB143598745517132685DF1D09C39C0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
In-Reply-To: <20200615100214.GC1491454@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf702bf7-20e5-427b-7d29-08d811292c3b
x-ms-traffictypediagnostic: DM6PR11MB4074:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB407410D7FAE5D94425A214EDC39C0@DM6PR11MB4074.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04359FAD81
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sUf/16cEknD97CZe6yl79mNm3tIQyEF+72C74VWW/KVC8Uwtl8FWVpgSYaWp49gzPdggh0v98fgPylZFouRdZQHYKlMH+MM+dcPmBN+UmMG1bcQLca3O2CxthhgeIwaGvIXLy8RXRTi3vZSd+TT4AOS5aOqnFw2gD7hHz8j/hLttrp04qHcJOZISAU15FUSSH32+optBwhVOjg7KTeYDWguFtcNm/69/bGW9S8wTKyu42llRKfGRgnx4eVk233ZDbVdscVwPeMkvMNzeHlRuDpB393Y/eX6Ax4PNOgy/VZfM1uxb7QA/vBMhaAAd9dtSuleYSmpWSc82VOJZJjKaGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(6916009)(2906002)(478600001)(5660300002)(52536014)(186003)(54906003)(4326008)(26005)(55016002)(86362001)(9686003)(8676002)(66946007)(6506007)(7416002)(316002)(76116006)(64756008)(83380400001)(33656002)(7696005)(66476007)(66556008)(71200400001)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6xNPYBeB+GqOkXGm++XB97Y+8Ldj4bHtlbeaPUX9ISmXXwrkz1FQTEfuWChhc9HOTQYLcgfFIBThQj+ZHuQD2J2zQJYUBgTbz6Mvnoz+Cvb3NPNW4P7nTRct+L4NnwBfcJMwxNRLWMhdAL7oKBIoG7NI5/DnifRYzIELF3vxwS2RkDCEIxxCy3ofDybuqY+leVTMHIuS7HOz5UKd1BfQMfdKZ7uyBpirbRNHHWWTEgiBeS7IR8mw0LxPRIV20YxP8NRquFY2uPc4rmy93FUqtR0A2e64+6Jlts2PNO02znWxZElfLqTWUpVHlBt7pZDiV1gdkbQqFVBi4LPA1jjvQehVVTlDarIlnG5eb8mqCjB/8FkBUgDFlhmvbIZ5PBN0OKaAZahyz3mOuGIT+eH32umFCCbt73cZsw72h65T8lXxn54nym7iJPTE6XXhIDaXrqn9NwzMRWWRHhz3teKkF3vNqbXBrnFMYaJmW4IARgE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bf702bf7-20e5-427b-7d29-08d811292c3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2020 12:39:40.5083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eXNwWJyb3uiLr296M02ZBSYUG4b46MNJZ71VMaQfZ+A73KnT1M8ix4aUWrKYwERiNpIsxRSTl6JX6YEWtJ7EZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4074
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, June 15, 2020 6:02 PM
>=20
> On Thu, Jun 11, 2020 at 05:15:19AM -0700, Liu Yi L wrote:
> > Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> > Intel platforms allows address space sharing between device DMA and
> > applications. SVA can reduce programming complexity and enhance securit=
y.
> >
> > This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> > guest application address space with passthru devices. This is called
> > vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> > changes. For IOMMU and QEMU changes, they are in separate series (liste=
d
> > in the "Related series").
> >
> > The high-level architecture for SVA virtualization is as below, the key
> > design of vSVA support is to utilize the dual-stage IOMMU translation (
> > also known as IOMMU nesting translation) capability in host IOMMU.
> >
> >
> >     .-------------.  .---------------------------.
> >     |   vIOMMU    |  | Guest process CR3, FL only|
> >     |             |  '---------------------------'
> >     .----------------/
> >     | PASID Entry |--- PASID cache flush -
> >     '-------------'                       |
> >     |             |                       V
> >     |             |                CR3 in GPA
> >     '-------------'
> > Guest
> > ------| Shadow |--------------------------|--------
> >       v        v                          v
> > Host
> >     .-------------.  .----------------------.
> >     |   pIOMMU    |  | Bind FL for GVA-GPA  |
> >     |             |  '----------------------'
> >     .----------------/  |
> >     | PASID Entry |     V (Nested xlate)
> >     '----------------\.------------------------------.
> >     |             |   |SL for GPA-HPA, default domain|
> >     |             |   '------------------------------'
> >     '-------------'
> > Where:
> >  - FL =3D First level/stage one page tables
> >  - SL =3D Second level/stage two page tables
>=20
> Hi,
> Looks like an interesting feature!

thanks for the interest. Stefan :-)

> To check I understand this feature: can applications now pass virtual
> addresses to devices instead of translating to IOVAs?

yes, application could pass virtual addresses to device directly. As
long as the virtual address is mapped in cpu page table, then IOMMU
would get it translated to physical address.

> If yes, can guest applications restrict the vSVA address space so the
> device only has access to certain regions?

do you mean restrict the access of certain virtual address regions of
guest application ? or certain guest memory? :-)

> On one hand replacing IOVA translation with virtual addresses simplifies
> the application programming model, but does it give up isolation if the
> device can now access all application memory?

yeah, you are right, SVA simplifies application programming model. And
today, we do allow access all application memory by SVA. this is also
another benefit of SVA. e.g. say an accelerator gets a copy of data from
a buffer written by cpu. If there is some other data which is directed
by a pointer (a virtual address) within the data got from memory, accelerat=
or
could do another DMA to fetch it without cpu's involvement.

Regards,
Yi Liu

> Thanks,
> Stefan
