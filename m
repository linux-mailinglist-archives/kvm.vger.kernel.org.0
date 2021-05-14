Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDFB3803A2
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 08:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhENG3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 02:29:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:46503 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhENG3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 02:29:06 -0400
IronPort-SDR: Jtt9cbbqYWmnErpEFhtI9oV8ynTFk2xRG0Z6VVgeIbfLKWUJJgA95KP2Gz9IoL+a24HxhxKKMh
 BNahPW1L1MmA==
X-IronPort-AV: E=McAfee;i="6200,9189,9983"; a="180395911"
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="180395911"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2021 23:27:55 -0700
IronPort-SDR: 1hpxC0wFVaomWwirWPRdJ7SsPN7udCdAk3YKYjj5Pucm0Nrq+lmDoKYjEJLz5oNFYvjXbA+riI
 tdxnOPbpUFeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="624254713"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 13 May 2021 23:27:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 13 May 2021 23:27:55 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 13 May 2021 23:27:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 13 May 2021 23:27:54 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 13 May 2021 23:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2oZQtVKWVyEAqbS+liTuIzARWcFG3107vbXZ9RWx3VadtMLkLZEBrwFJj5r/CsUWrlsAJPv9m0DW3zGTpnmQ3aSoLyolLZYqwfcFtzZezixQV/aJGy2Mpwsg8L6gdszeEufeqWzy4hbLhyjeXMvluW+opZmeVTZGTELMrjL52x+PIHS0Vhzekh22RVedpXVcDo+z59+YjC1RWJclNQS32BYAaGSjpQKIvi5bIJhUvZ5sWFa/iOxu0kszSEZU2cPx+9N7lN6C787eVX7CZyymQMqanH12nIapIEtQ6CcfTrRp2N37QZ+uqX3JsUMVjizN50dngJYfAlEQwv6/A8qyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCKOibZjUMUTfGLK0xDV2gCtVhL8SIGnhgHRGyIpYuk=;
 b=R4cZo7C7PczEkOXjVdlc6qbJVtnAJndmNLSJQIV5EPGbYAYz43X09RXQsS1nTaAxanBHQqK8YkCGcSSfVxdG8JTCzGuHMHVXan4/KrKNuB6YBm7DMlQIGMe5H1npBSMa4jfuTnHP6cTt8o0mFMt9pSD+YLtjDI2BVZfDwscHRkRuy+6FNMMqkKlLERrpdLMlKag0nX9HftflQPF0jhg5zaJXPb6qwJK/5WaLP7lwRDxdKjZdSqVyA1Xj+qF837CmaqrUMAYsDSecYGk5tUYmpqdBw2AqKKOWjUV5ptFoiyDrwHhYA/exNwx+Rok+tMf21q+YdFeG8gLCFzlZYB3YFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCKOibZjUMUTfGLK0xDV2gCtVhL8SIGnhgHRGyIpYuk=;
 b=q2IYgQ4pXRtii6sy86LtlmXpHTygmnj/xtWtkOrNCF6pssf0OklYpfQrSP+aBADab6OdC/OmBFVif4f5W3NeZsQCn/Jw9LPB0QFkHwXWO0/E9pZl0IWC9crkfThkDMpvnieStWBt0FpPZy9bMqaadcnsDnv1kh6alR7nhQ52iGs=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1615.namprd11.prod.outlook.com (2603:10b6:301:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 06:27:53 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4129.026; Fri, 14 May
 2021 06:27:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXRWldX98a1U6w60C1HwYkmNlXK6rc3tAAgAPcBcCAAJmdAIABJmdg
Date:   Fri, 14 May 2021 06:27:52 +0000
Message-ID: <MWHPR11MB18865A22BE30F575676FF7688C509@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de> <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
In-Reply-To: <20210513120058.GG1096940@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16094491-7ecd-41e8-6300-08d916a16754
x-ms-traffictypediagnostic: MWHPR11MB1615:
x-microsoft-antispam-prvs: <MWHPR11MB1615625139DFD4A8DA4FE3DA8C509@MWHPR11MB1615.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AycJDMC+L9ocNAF5EO0gOvz7FiLP9BUaJUgnDQaojw6iEL6EufuIDRPYSfgcaoUj5FmLTLd7iD3X0uVUTu/VAu3L9wJG8iINfYLhZPJolMkICgOpwoch49aljjvXDOEMzJWBjY+mqoRCLF9YoevJPh9zmWc7f7OzrLouLlzo705xqBovewAFiH+Gr2adKKUgi4OveVcNrmaOaNcCLjpErtCJks9F5lslnkWCeYx7/7KIuPpu4pm2PBhnbmpyYjU8KmAnNpObH5WyZx+pXqhs04WcCqvUuE94lRZ2G0TK7lnYI/VnJkk+y7VNoasFF6h7GDPcZbQwdRgYCe/qDpVkADVvJ2/KcRQ6A+KQ7puUGroX/gKL5w7Kl4x9NJBaWVHgvFj5+2ufKsFCEX/Hpv5dzD0l5jhPZ1jzYYBz0z3PyCZZxb4/bFQItU1gSHBnAHNe21kHall0Kp4J95k2i+knGouDSpv2Wc8D0Y354f4sJtTVM1Ismp49ANlGmHLBw9uuFdyi/YrLHU4K48ZNTWM8kCof2QgSrJ2d5Sa4TPpH7RVRu6s0P8fo/fwOngzWajGg7yyIuHIvyg5c8NgDy86udv5Dzphs7RoobhFzNsSt4uE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(7416002)(52536014)(71200400001)(5660300002)(122000001)(38100700002)(54906003)(316002)(76116006)(186003)(66946007)(8936002)(4326008)(2906002)(33656002)(6506007)(26005)(9686003)(7696005)(55016002)(478600001)(6916009)(86362001)(66476007)(64756008)(8676002)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4JhosE1qCUcpL8uEq5dJWIcHQhN2hu5wU5SY7ElMd9QQ+5mjQOvTBZ/Tn8xg?=
 =?us-ascii?Q?9mBhLxGTEIzvlyztAP0LFkD3U3AWC2oTHjRrFQ40a6CGSxYH4nOztIao34S8?=
 =?us-ascii?Q?FjHZD5NtAzDZSfOY7yKGQDW9zXYp8RTI0eSOXIl8pBlY56AZFou7IB4VUEzf?=
 =?us-ascii?Q?t+NnP5kofZkQzV9aJBETmYKel/7KLQp4nMcmir4Q5KZD47MlliLBh3GbCp3i?=
 =?us-ascii?Q?a/RAcCEaHplI01KwbCsVgdaFHm43a6mcBSukTnLBliS3AKckoVx3UFvm4r4+?=
 =?us-ascii?Q?b+teVYu9563kVJEqc5BOaYTPNWfpQsyseFVbP+jRBKvMs8+JjJeoDjhfBNyi?=
 =?us-ascii?Q?hQvG4ZyS4gg1Uk9blLzfTXsxHgCqXM5ntAQUpkMvx72rcHYSzD7/GexR3L0Y?=
 =?us-ascii?Q?iPOK6BnGFLSP1jfvOPgefu1/QZWbM5mdmnaRM5rKJjKyE281FVZJeo/kOm6t?=
 =?us-ascii?Q?W2pNhWsOujq5N+7/Njp2Hd+Q5QjPWxM5JpXBl22wdRB70mSlYuzNGlWti/Xg?=
 =?us-ascii?Q?g/2CN/PsPZCCVchnKir7Va3xpgrBm5LE9vEXiTvJassKlQB7kXyjoiuUX2/k?=
 =?us-ascii?Q?1zeVrWd2rcubqaDZcuoQhQMSaSQiKcICIw17wY0WzzvL+GItmZymDHc1z0yG?=
 =?us-ascii?Q?PXluE0n3n3TAD8xwKre/swN5N3VuOpiviyQbUFwwwvDEZu9cnrfyzBl1JWNJ?=
 =?us-ascii?Q?8ngG12515nCeJWqEfngd5hsxWsAMKaoKGod7UgDSMR+blGc8Z6YPysl1CAbN?=
 =?us-ascii?Q?DriOEPduWkK1PHok84A5G3KCTX7mFA4cX24JT44EJMvo5FCh9JFZ6fFSJgrY?=
 =?us-ascii?Q?D3oJe0WKyG97ro+6/Fl19CyPcXO3vADXFZ7GGXDnWAZZMYp2bdzhtfC7xh+I?=
 =?us-ascii?Q?t/o+iQZ3fJoyzYOUANIqkj2/P2CaGXp3Ahk/it1kpmD30RVuo+lxHmDip6r+?=
 =?us-ascii?Q?kY8kCeKqqA1AcLe57ti8SPP53i7GXA8MU5BgEd81wt/q2FlH/lLtRt6unR8A?=
 =?us-ascii?Q?8U15jrfVuN1C9o9MWJgMjahtGpesFu3OP6lkr+XEdNmtJuv8Eahs6gDtbGQH?=
 =?us-ascii?Q?eIuC9dUyoct2beAxU5CadmaYvFOQaa4FgqQCum5pV+BAgecOZcjjXpA5vDT2?=
 =?us-ascii?Q?8F9GJHHYoifC150GeO/LhcSdjQfcT5/EAThUGMc9uJVVNjT0LcTENPJm3+Up?=
 =?us-ascii?Q?m0ko2F4h61j7TZmQ7qAjo9gJ0dtV2ndPsCxdghzfkvF12UZ/afOrC0dg+hcW?=
 =?us-ascii?Q?BK9cIJPlMwpggiDUq/Fg83r+1eUFPFa6QnY4TQEDWmwEwee92VQts15uh3MF?=
 =?us-ascii?Q?DNY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16094491-7ecd-41e8-6300-08d916a16754
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 06:27:52.8095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1AIDR69Tqi6EjL7vQwHg82+j/da3yWi2r0sfDlNmwygLtiq2ibYvihvNkL9+USizaG4EX7aWpcLXIXIhWodA2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1615
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, May 13, 2021 8:01 PM
>=20
> On Thu, May 13, 2021 at 03:28:52AM +0000, Tian, Kevin wrote:
>=20
> > Are you specially concerned about this iommu_device hack which
> > directly connects mdev_device to iommu layer or the entire removed
> > logic including the aux domain concept? For the former we are now
> > following up the referred thread to find a clean way. But for the latte=
r
> > we feel it's still necessary regardless of how iommu interface is redes=
igned
> > to support device connection from the upper level driver. The reason is
> > that with mdev or subdevice one physical device could be attached to
> > multiple domains now. there could be a primary domain with DOMAIN_
> > DMA type for DMA_API use by parent driver itself, and multiple auxiliar=
y
> > domains with DOMAIN_UNMANAGED types for subdevices assigned to
> > different VMs.
>=20
> Why do we need more domains than just the physical domain for the
> parent? How does auxdomain appear in /dev/ioasid?
>=20

Say the parent device has three WQs. WQ1 is used by parent driver itself,
while WQ2/WQ3 are assigned to VM1/VM2 respectively.

WQ1 is attached to domain1 for an IOVA space to support DMA API=20
operations in parent driver.=20

WQ2 is attached to domain2 for the GPA space of VM1. Domain2 is
created when WQ2 is assigned to VM1 as a mdev.

WQ3 is attached to domain3 for the GPA space of VM2. Domain3 is
created when WQ3 is assigned to VM2 as a mdev.

In this case domain1 is the primary while the other two are auxiliary
to the parent.

auxdomain represents as a normal domain in /dev/ioasid, with only
care required when doing attachment.

e.g. VM1 is assigned with both a pdev and mdev. Qemu creates=20
gpa_ioasid which is associated with a single domain for VM1's=20
GPA space and this domain is shared by both pdev and mdev.

The domain becomes the primary domain of pdev when attaching=20
pdev to gpa_ioasid:
	iommu_attach_device(domain, device);

The domain becomes the auxiliary domain of mdev's parent when
attaching mdev to gpa_ioasid:
	iommu_aux_attach_device(domain, device, pasid);

Thanks
Kevin
