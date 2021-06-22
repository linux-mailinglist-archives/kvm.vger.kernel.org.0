Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8B3B011E
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 12:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFVKSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 06:18:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:49457 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhFVKSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 06:18:40 -0400
IronPort-SDR: xTiqMMzl1uuXBKwjqkKqzrPEwQeLGBZ/bdLNcKY+jcJK18lt4wYq1hckpHeOaIeat/tjhLJT4J
 PmCBhFErZePA==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="186714442"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="186714442"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 03:16:22 -0700
IronPort-SDR: e0YPGfSGj5LRHxzDMKKPSsbS3e3Qhn4oe7U+hxWJn/4XZ8EkcYXROsE2MeggEOVMFURc7xLAfy
 hJ8So1mHqeTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="406279574"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 22 Jun 2021 03:16:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 22 Jun 2021 03:16:19 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 22 Jun 2021 03:16:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 22 Jun 2021 03:16:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 22 Jun 2021 03:16:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQNz2Yqj7jFSDLqfF6SNo5ysjzHRU1Y9SypWuxWwfcgk0C09xdIEjxux/ziWiRSZPGyCAZA1KmhhPtSunerVaCAk0/UJFhr2G99QIrqriui7Q/6FboIFqJdwPz4pwK4p5tn0s3Xp4BPyGgEnT84MmwDyXO45LyysAXjkoJmEtsdiWtBm7f9RzSSj36S+uJPi+9681uLck35yHE+SvVYIu6se9NYywebsZdXwgmCRO16gWOlJsVR/CnX6dfmkOtrcYCrh0rzSJ2uKnqNoUZkO1hnWwj0ULgEUDDt8BUpKDUhXtwqk+nCerfPy1IMAc4A6+MkBupvQiEPcVmn2iYWKvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOIkVQQrSr4b6gm8AnzHShSPk4CQWtfeSFjjedLEAok=;
 b=gSfcYCyrgN3vKXrP71LLp3uGjk0nQZ+wR8Z123RegY393Ps3PFdAgCM9oWsC9/EKRORhDglaDUy0NwGy5uH3DhKYAbLVrApZpg9BIc/8Qw6SsKvGaBI7RqSWpMwz39qzQRprNuS1MZPd4IrQzY8T8MAId2xp60oxC99xXZZmHwbznmL49pQzLy7GpJXaZmHLxu3oahkFMBEmnSh7RHXbiJq8Y6S6RXdlb/NfahIJg4Ta0jKRp3aCR4+ltQh6mywmoJZCJ61Q41sRgPhfWoqyPPEXWR3ba79t3xUZbQaKWo1cIaHLVO2Pupt0wPqeQgE5Rkuet+gecXaTSwCG1+m8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOIkVQQrSr4b6gm8AnzHShSPk4CQWtfeSFjjedLEAok=;
 b=crY920wil0o1LKYX23Cguk7BMbjE6AsxrneOfsLukOjmFCZt73G8FeJRVFEdq+aCV9yl0Njf4DlUMOTQv2swL+bPf0pt4zoQQMF8/umG05looHgaxvojawvTaJ1+4esln3X939GQlnjmi6azoTagUj6xb8w8YlJ46JDbRsCi+us=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2174.namprd11.prod.outlook.com (2603:10b6:301:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Tue, 22 Jun
 2021 10:16:16 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.023; Tue, 22 Jun
 2021 10:16:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQ==
Date:   Tue, 22 Jun 2021 10:16:15 +0000
Message-ID: <MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afdf8e84-fc02-4117-75bb-08d93566c526
x-ms-traffictypediagnostic: MWHPR1101MB2174:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2174677081D8EDB59FB66FD58C099@MWHPR1101MB2174.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mHt8IFmM50eD7l0iMYWWqFa6rdSw0KGZkqnxdOloVjkwARmX180fUqBNVtqGTpTDOdFOPTmh8r1hdFwxnnZCUxXmuAUwgHMPLnBcTa/x/86zEEgtAxUwfz5pnXVSgGAAU85hTb71aquHff/cfzCe3u5BBygujdQqVna7ficrXFLcTiQU09r4XGE9Ac6X5uJYN1MNRBD7hJmTuWUxlit8yKhNOGyHR2nRavBS2qegr6qCmlRUzCyKVPFmqw3TwvRgjLGWLpbZ1h3AEsKwi/KXa/HUlwuyDs4EAEbK0HRlkIV2SLwyhjQAITu6xchzg+pBnyioA9PfHZFpcJYxszpN3fjy1PhmPbEZi9oiFqFcvy/0EsSKsi0NTzu3UUION3DG/VJY0vtbRi9BA03rJPJuqrW+js3opdXPDkAs6fwOLWo4CEKCS8pRYqGFkNI11oF2mpb9WZRNFHzLGr7byHpKduWCxPj7WejAFkbd8rhVAmqgGmfVtiwW3wxxBsjOYNGD7Zrgj2Y3CwY+3/mI9vd7dYbqDPbLPVw1UCR/0Ixwex4yUfOhsgskmiD0p8LP1mlXxZUu3LZ5EZVQg5Z2ycjY6ICNZQclaLvQRwSmdorKgUvydrefDGeW3jcmH5LwIdbNqxtToQx/N5Php/epyrVNimb5sBwbYFKdfvNOkZjlMDL9d9s4jdnqijYXzHmIIbI2FnkfWlBSvAYaq7MTMqzpN/Tow5RG7EiciNCh6Uzh2NJUY1pRNGCBHQfBOF085P9fgyTt0P6Hfe0JlU8Zy52kdogdulsDXyftKdW7Ck+nrpyq91+kswNFwsPZgrGnnMFu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(66446008)(76116006)(64756008)(66556008)(55016002)(66476007)(9686003)(5660300002)(86362001)(33656002)(66946007)(7696005)(8936002)(38100700002)(71200400001)(6506007)(2906002)(54906003)(26005)(4326008)(84040400003)(83380400001)(52536014)(478600001)(186003)(966005)(6916009)(8676002)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TYTHlO5/roAblwf3Iv1OwSKXEeLR7bvooN7T8PIeSVRuavllZ73Q3cT0f1z5?=
 =?us-ascii?Q?G3c2s1UqKy4aUlVCRBJlTH7JVy13cU6WsRG2CplpadpFHFWdkIM5SQZOhBiy?=
 =?us-ascii?Q?kBDYRkbX1/YakZ2ZWIeX/0X+FCsnGkd3b4ACNtRlnxg7TeFfTNOr+Ilh7u4G?=
 =?us-ascii?Q?xWTnm1uXFikV1m5b4bhiix5ZDQh0L16PfTUQWPiNMWx9bXGeyW8txYopjBsV?=
 =?us-ascii?Q?WzZQK3fm/Z9Sq1lj3TDjnVa7qFhvT13ZxG8gceJS4Joxm7RSGbZHUs3JOp6F?=
 =?us-ascii?Q?QCXvo1VAlVzINo3+8Ii9DXEAloHCOCX/eh6skk/IDFmzlukot9R6meZ2HJEt?=
 =?us-ascii?Q?esThi8/6ErxifZD77iD2FEtubCkq+7+EbNyq0rF80dvGOJY/vLnV6sUGbPY+?=
 =?us-ascii?Q?XwHVZTlRyEAEchpOpaSTcG+9x6Ood5ZjInWDgQkvuwdUMgXK6y/w+EOG6itL?=
 =?us-ascii?Q?ovYSI/qXjYIAG+9hSuIr1p4kli05g1jOJSIys6+AYwNlSsYbtFEiEAK2NmWz?=
 =?us-ascii?Q?qqeD9J7AN8pC8Hxm7X//D+4uQqQ+tcn4xwgvRbVCb4FP5xATdIzsQiVpe7nB?=
 =?us-ascii?Q?jPv3qkmiwzC3pFSbZM34tS3qIm6K8MxEiYGkdSb9dZJTq9PJ68ifm6ScK85c?=
 =?us-ascii?Q?Fj+pCXi6lNOBn4Ia41OPuy/W3UnGlLMHcL+KHRRZ2LZD3N18IuAzLjLg5/FK?=
 =?us-ascii?Q?ZV6r0Mp/U5RFc8GYQ41ECgJpK9Dd/8uJ+qHAit3KwY06MHOSPEDfC8AzGi5e?=
 =?us-ascii?Q?UvFvj/aT85BmDwebdEp5MaOnJxuQGLW3TGZ6f9mjyhDd1Bfha0hhHQRty6oH?=
 =?us-ascii?Q?3vzBIqDKNV3zxUkQvGLQeAKz485+euQ/zduCN1etLEZrNMipxf3uAt+4OvDW?=
 =?us-ascii?Q?C9BFWwD6JRIADS898iI98Ipn+fWpy6deqtspyREV0FYOlXSmPnEMXAXMXehr?=
 =?us-ascii?Q?XSXiiVDGbprQ9aBFUyqige4La1Uzo4etbFNXlgE6imdyugwD6T0kB280WioG?=
 =?us-ascii?Q?S25w2pRn4jEc5PMvlDI8BVkWOTDJzsI8xGhnxXoO4zm7AiMRPOWxICjNHZ2y?=
 =?us-ascii?Q?lOr1NgDuP7CbpOgzauR34or61J19CF0l9367ZaJvhopgetfIGDJLXMu++ZdU?=
 =?us-ascii?Q?DDuhiF3/3XJyDpVjBsELN1pXFUovP5QiLy6ALno5kyqjf5TSdvA4McnxNYA1?=
 =?us-ascii?Q?JUtLrPcJuE/T5WGWtIbVh3X/hu9yq8YjaBoEsDsoS0OYs60Qr6xfzK0WajpQ?=
 =?us-ascii?Q?lNX1mPp/UB1TAO48DwKAto+VJwrOC+gg+NXQXIbO1aaDpjjVb9CGfbuaR+Cr?=
 =?us-ascii?Q?SuVX+Lpy6B5g4ekydQ/S74DI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afdf8e84-fc02-4117-75bb-08d93566c526
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:16:15.9154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blcLbqoFJR2so6Yp2CXPLSyDW3eZxJn9vcFIcEjqzSDzFl1zD2XZAqJwsacfrwFxff5RYUQAcHusrEHP08FVdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

Need your help to understand the current MSI-X virtualization flow in=20
VFIO. Some background info first.

Recently we are discussing how to virtualize MSI-X with Interrupt=20
Message Storage (IMS) on mdev:
	https://lore.kernel.org/kvm/87im2lyiv6.ffs@nanos.tec.linutronix.de/=20

IMS is a device specific interrupt storage, allowing an optimized and=20
scalable manner for generating interrupts. idxd mdev exposes virtual=20
MSI-X capability to guest but uses IMS entries physically for generating=20
interrupts.=20

Thomas has helped implement a generic ims irqchip driver:
	https://lore.kernel.org/linux-hyperv/20200826112335.202234502@linutronix.d=
e/

idxd device allows software to specify an IMS entry (for triggering=20
completion interrupt) when submitting a descriptor. To prevent one=20
mdev triggering malicious interrupt into another mdev (by specifying=20
an arbitrary entry), idxd ims entry includes a PASID field for validation -=
=20
only a matching PASID in the executed descriptor can trigger interrupt=20
via this entry. idxd driver is expected to program ims entries with=20
PASIDs that are allocated to the mdev which owns those entries.

Other devices may have different ID and format to isolate ims entries.=20
But we need abstract a generic means for programming vendor-specific=20
ID into vendor-specific ims entry, without violating the layering model.=20

Thomas suggested vendor driver to first register ID information (possibly=20
plus the location where to write ID to) in msi_desc when allocating irqs=20
(extend existing alloc function or via new helper function) and then have=20
the generic ims irqchip driver to update ID to the ims entry when it's=20
started up by request_irq().

Then there are two questions to be answered:

    1) How does vendor driver decide the ID to be registered to msi_desc?
    2) How is Thomas's model mapped to the MSI-X virtualization flow in VFI=
O?

For the 1st open, there are two types of PASIDs on idxd mdev:

    1) default PASID: one per mdev and allocated when mdev is created;
    2) sva PASIDs: multiple per mdev and allocated on-demand (via vIOMMU);

If vIOMMU is not exposed, all ims entries of this mdev should be=20
programmed with default PASID which is always available in mdev's=20
lifespan.

If vIOMMU is exposed and guest sva is enabled, entries used for sva=20
should be tagged with sva PASIDs, leaving others tagged with default=20
PASID. To help achieve intra-guest interrupt isolation, guest idxd driver=20
needs program guest sva PASIDs into virtual MSIX_PERM register (one=20
per MSI-X entry) for validation. Access to MSIX_PERM is trap-and-emulated=20
by host idxd driver which then figure out which PASID to register to=20
msi_desc (require PASID translation info via new /dev/iommu proposal).

The guest driver is expected to update MSIX_PERM before request_irq().

Now the 2nd open requires your help. Below is what I learned from=20
current vfio/qemu code (for vfio-pci device):

    0) Qemu doesn't attempt to allocate all irqs as reported by msix->
        table_size. It is done in an dynamic and incremental way.

    1) VFIO provides just one command (VFIO_DEVICE_SET_IRQS) for=20
         allocating/enabling irqs given a set of vMSIX vectors [start, coun=
t]:

        a) if irqs not allocated, allocate irqs [start+count]. Enable irqs =
for=20
            specified vectors [start, count] via request_irq();
        b) if irqs already allocated, enable irqs for specified vectors;
        c) if irq already enabled, disable and re-enable irqs for specified
             vectors because user may specify a different eventfd;

    2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
        DEVICE_SET_IRQS to enable vector#0, even though it's currently=20
        masked by the guest. Interrupts are received by Qemu but blocked
        from guest via mask/pending bit emulation. The main intention is=20
        to enable physical MSI-X;

    3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
        DEVICE_SET_IRQS to enable vector#0 again, with a eventfd different
        from the one provided in 2);

    4) When guest unmasks vector#1, Qemu finds it's outside of allocated
        vectors (only vector#0 now):

        a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free=20
            irq for vector#0;

        b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
            irqs for both vector#0 and vector#1;

     5) When guest unmasks vector#2, same flow in 4) continues.

     ....

If above understanding is correct, how is lost interrupt avoided between=20
4.a) and 4.b) given that irq has been torn down for vector#0 in the middle
while from guest p.o.v this vector is actually unmasked? There must be
a mechanism in place, but I just didn't figure it out...

Given above flow is robust, mapping Thomas's model to this flow is
straightforward. Assume idxd mdev has two vectors: vector#0 for
misc/error interrupt and vector#1 as completion interrupt for guest
sva. VFIO_DEVICE_SET_IRQS is handled by idxd mdev driver:

    2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
        DEVICE_SET_IRQS to enable vector#0. Because vector#0 is not
        used for sva, MSIX_PERM#0 has PASID disabled. Host idxd driver=20
        knows to register default PASID to msi_desc#0 when allocating irqs.=
=20
        Then .startup() callback of ims irqchip is called to program defaul=
t=20
        PASID saved in msi_desc#0 to the target ims entry when request_irq(=
).

    3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
        DEVICE_SET_IRQS to enable vector#0 again. Following same logic
        as vfio-pci, idxd driver first disable irq#0 via free_irq() and the=
n
        re-enable irq#0 via request_irq(). It's still default PASID being u=
sed
        according to msi_desc#0.

    4) When guest unmasks vector#1, Qemu finds it's outside of allocated
        vectors (only vector#0 now):

        a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free=20
            irq for vector#0. msi_desc#0 is also freed.

        b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
            irqs for both vector#0 and vector#1. At this point, MSIX_PERM#0
           has PASID disabled while MSIX_PERM#1 has a valid guest PASID1
           for sva. idxd driver registers default PASID to msix_desc#0 and=
=20
           host PASID2 (translated from guest PASID1) to msix_desc#1 when
           allocating irqs. Later when both irqs are enabled via request_ir=
q(),
           ims irqchip driver updates the target ims entries according to=20
           msix_desc#0 and misx_desc#1 respectively.

But this is specific to how Qemu virtualizes MSI-X today. What about it
may change (or another device model) to allocate all table_size irqs=20
when guest enables MSI-X capability? At that point we don't have valid
MSIX_PERM content to register PASID info to msix_desc. Possibly what=20
we really require is a separate helper function allowing driver to update=20
msix_desc after irq allocation, e.g. when guest unmasks a vector...

and do you see any other facets which are overlooked here?

Thanks
Kevin
