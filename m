Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471A23B2420
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 02:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFXADG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 20:03:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:41461 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFXADF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 20:03:05 -0400
IronPort-SDR: QFdTjsHgktUlDfjHPfgtCR6PX2cbtdrymlreUwxcotOIbmavcYDZGc6QeNvGJgKm+rLo/x2pTj
 nVctNaoOHC1w==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="187747060"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="187747060"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 17:00:46 -0700
IronPort-SDR: tQgp+gEEQwDIgqwL7YDNAHHoKKbcJ6Q+fPgSumUZdLkBun1epexIboQwsn4WHcxUTRg/0w94d4
 JTw/qoiyQW2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="423877008"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2021 17:00:41 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 17:00:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 17:00:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 17:00:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdWIS91Xgxbwr8gEM7Mr0ksTQi/9oejQTITdYv3i4rE1lSCkXvVFxGP+37CIVJh0LX0ASY3bN5IUNtfgFB4JKZdua3cvlq4+05UJ7FhuBzjmQW3MDEtY9t1Rjvodr4iHf4JKGGeraQKhVItvHUcUFYuIzV/PIaR1rleiZ0PPk88BFiiitQ0LZ8OGFzLm80EeEAjefPgxuhWiYqnjy3H3vqc16YpIneupQ0hYpn3BqtEOq3IOt1WOvlnpjeqPKsfkfMk6YB8QVYry2Zk56F0sgcRnYJWhwcZ49jxz/zIn3ZO19p4+6kT5gMFlTlEkp4fg0W81BNh98CCqxXlKsfFf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6u5+fs0HE3dA3HdCCnXlR8+0ZfbOLyjp+m0ZS2CBiw=;
 b=Dh1mLp7fxe/aG4SfUs3iPjsyD69UI9pxZqZ2oPVmEPuPVXGTxnFEnm+otKMS+p4p1IRATA0wuG6Bh0Qi6u9wtHa5oI1X4td3jbNpN82nWj523vv1vFlxT7YrItEWX7LI1jfjaPDxL8LAdzW2ZbucQgxLSiq/t/JksjR8IVGBxg3xlEkP8VRm6yhGsdQV8AS3nFiRBrffGgTMOdSOtm6BopB/kDo2zgG/Le7j0mbv9lMQajcCVzaNa36+BEiDDlUFU6g0y3gx6gaHLsioJEMg/a9Ph8nk4UpGcNfO9TFMmY3WKCqeN6WVKjnv4j5UOKiVNhwtaA47vc/cvxPLa0+aWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6u5+fs0HE3dA3HdCCnXlR8+0ZfbOLyjp+m0ZS2CBiw=;
 b=f6mape/7xq8ThsX1mtGS65iBJgkNA3QJyX0P1WhSnBu+2QPfV5JErV89yWkaQndd2yNVEo8dXeCjawfPAXefUJVBytJpXT9fpsW0syLOmevraTnKB5CegHVu/zW4exLSYUSoaOZj5cFuS9ESNW4uwEZruSnJllnCuvLVl9ViQ00=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Thu, 24 Jun
 2021 00:00:37 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 00:00:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "Bjorn Helgaas" <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAZ7UiAAAoHBgAAICMUgAARvpSQ
Date:   Thu, 24 Jun 2021 00:00:37 +0000
Message-ID: <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
        <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
 <20210623091935.3ab3e378.alex.williamson@redhat.com>
In-Reply-To: <20210623091935.3ab3e378.alex.williamson@redhat.com>
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
x-ms-office365-filtering-correlation-id: d7e8a6d4-dcb5-4919-85bc-08d936a318ca
x-ms-traffictypediagnostic: CO1PR11MB4962:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4962E541D0BEBFC3067EE9768C079@CO1PR11MB4962.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dTHfjCNmUz8u7sWKlgAw4kYwlV+Dt/pmvil3zcz4Ur49eRGMSDj2q+HF0hCe/F8mF/Akg41aUDGfkpMDGOVDQk0Eig/7KIH5ad/oi9HFM/AanwPlbiRyYWjci/XtTYLBsSe5ngVNDeyoyEDeIGQHyoeX/lbaPgBXYM6S7516Uf3UuAK4EbJOqDltoOBc9nLrXdX5xRJIepbgSPNBvA0L60jz6I2NKmXWl7rlyW8ayPaIlkCRsnm78O6w/Kp9OxXE4jStFY///ggZLLyx0ul5POu2kpexCuXzlttF5EKgwMJs8TG+yQ8rYAOL+yJ9UsiDmLF8hLPwEKNWr7P1vWptJkm2+oQu49ABXxUqWTQ2Anbzy/uOdxJzNycVkhDX4ODZ1BQVZukSYMsAwiiVOJ7rIyM2qgT0RJUINH6lTM+cY8CMaZe7v2Li6AaJP+lQ/fbxW6r4Ea6h+Tp4wcIh8rH3gHoHvO/LlRmw23M7zrosjuEyyu8oi0Ufy4CR9X9c2O4CT0aM+V12sDJoKLN3B4SVXsP2Ep8G+cWz/+PZ+eKRN0OComjuEXdr88eN3Vp4gGUYVRCNoYivfRSSnMUU/PkY0wV1N4dpbXOoNbOkDMOMlD8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(86362001)(71200400001)(55016002)(9686003)(122000001)(54906003)(110136005)(8676002)(316002)(7696005)(4326008)(5660300002)(2906002)(76116006)(8936002)(6506007)(478600001)(64756008)(26005)(33656002)(66446008)(66556008)(66476007)(66946007)(52536014)(186003)(7416002)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+KKHj/U4bm3fznX4Oj7pgVHU7am5Lyy1DMZ2gP2IDOMhyX+5ztefrnNcOekq?=
 =?us-ascii?Q?qO4Qm5SPv8p7/6wBkz3dLxB8AkR5qa0lfGc1ert836sdKsi9K1RCfGfw0e9Y?=
 =?us-ascii?Q?QIK0WDVwnjke+R3U+F6wzaWSBEdaKY39IjXjZWVdDHQIjnKzftlokHd8NSMD?=
 =?us-ascii?Q?l/E8vmLmNcT/knzBghdGXqAZ2aC6XIo4eScykh6ehF+q/KJuut5wsauzS1cC?=
 =?us-ascii?Q?yQdrnJ3N9RRhz+6iaUe+vlU75bW7MEkVjw9iNqO23STAP6pHXDVcdcvkV+Ba?=
 =?us-ascii?Q?3p6hpz5iDT8rBYhg70ID9jbIQP0XOy5peJrkg7vxmxhxeNEp/QV9n1jfZLZy?=
 =?us-ascii?Q?clS4s+R3uM2qQOpGHoIJP1gQYWP4ND1hGxJ9zIW1zl9iCUGM6uqQDk88xFAM?=
 =?us-ascii?Q?K0x4OFOy8itH/GPp0iDj926caBoXsJ43bPknPbX+7yuM2hyEYm6yDa9ztC9d?=
 =?us-ascii?Q?PMRMnaIxntTUu7qnyostsiVe/GjZVWxAft0ZysALybpc9/0OHVhelAp0HMGl?=
 =?us-ascii?Q?trrrJ2uAz3JQHpXG/g7/pmYbDvV9q+vDqBmJm5zy0LqyOV+2tcFNjF1lIXSN?=
 =?us-ascii?Q?QCAoBFOgYGqoUpKJ5QXSTEDQQ9Lp5VAHk9v+NII4Lh9erGyKpy3AIpkUavdc?=
 =?us-ascii?Q?rOQ4R0ubNRyfz81eDWuNvYqHfDE1g7Vc+MbXPGvIoGbgjSGg26SILq5eTk8j?=
 =?us-ascii?Q?mzavG73/5kcpOmPd5VA6cnxXPUgm4oLzoCUGL95FEo9tlLNNiAZcBt+FPg9R?=
 =?us-ascii?Q?wORQj+YTozjF3L5A+J/cHrhmBcVaw7ufZJJYVuxbvV9QMyn0AnM34Wy+dwlu?=
 =?us-ascii?Q?XUxYOVrOFJIZJ1vWjLRRYwmRGmXDNJWd397H5oUt0i3++N3uWZDf4+6PWIMO?=
 =?us-ascii?Q?L7x3wOEta9Oj3/gL2bMzos5UA9CmM2IjUE94lE5xVeB9LK5BwekaxZFO9HBm?=
 =?us-ascii?Q?BxTIIdJbuUQXV8zJtblip1/epWMBb4IMA2Ddmj50KdrkXKb306buVbLGkp2P?=
 =?us-ascii?Q?HvbHyp4gfXWCE1/MvUSt9f5RJhyZOz/IHL+z7hXvte1LjZkhX4kzrycCsPT3?=
 =?us-ascii?Q?Wtgqzj/Hlq1/7Y8A1O2qEY+HsxSEgGKACmPCdVBGTdUM+XrT2TzJVpSeNrlM?=
 =?us-ascii?Q?wqBbyxHpPmU2vAjQSXBknU402SJfhZuUzbUmgZgyZ9C7C2gOdEhdM/kF+kyA?=
 =?us-ascii?Q?WqL/RaFeh/X7PmiouNdqHnTfhh30y64HEedRtWb52SDyHE7RRAbt6LhpEz3k?=
 =?us-ascii?Q?D6/uEcSYAHy+QfWI/Ks/NmunU4yvesQt0l/XUERquqTWAhzucHEC0hrkK20U?=
 =?us-ascii?Q?IKXtxd82mAq2R5HLOtJGxmbH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e8a6d4-dcb5-4919-85bc-08d936a318ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 00:00:37.1101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WasvzdC6ylQ4U3UXMNmM/lJbOKVBK0/olx1iuA9VgKJwwiiUX7SRHMsZoA/4xYz8ChpanGzuW6R0OL+ERoqvqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, June 23, 2021 11:20 PM
>
[...]
 > > So the only downside today of allocating more MSI-X vectors than
> > necessary is memory consumption for the irq descriptors.
>=20
> As above, this is a QEMU policy of essentially trying to be a good
> citizen and allocate only what we can infer the guest is using.  What's
> a good way for QEMU, or any userspace, to know it's running on a host
> where vector exhaustion is not an issue?

In my proposal a new command (VFIO_DEVICE_ALLOC_IRQS) is
introduced to separate allocation from enabling. The availability
of this command could be the indicator whether vector=20
exhaustion is not an issue now?

> >
> > So no, we are not going to proliferate this complete ignorance of how
> > MSI-X actually works and just cram another "feature" into code which is
> > known to be incorrect.
>=20
> Some of the issues of virtualizing MSI-X are unsolvable without
> creating a new paravirtual interface, but obviously we want to work
> with existing drivers and unmodified guests, so that's not an option.
>=20
> To work with what we've got, the vfio API describes the limitation of
> the host interfaces via the VFIO_IRQ_INFO_NORESIZE flag.  QEMU then
> makes a choice in an attempt to better reflect what we can infer of the
> guest programming of the device to incrementally enable vectors.  We

It's a surprise to me that Qemu even doesn't look at this flag today after
searching its code...

> could a) work to provide host kernel interfaces that allow us to remove
> that noresize flag and b) decide whether QEMU's usage policy can be
> improved on kernels where vector exhaustion is no longer an issue.

Thomas can help confirm but looks noresize limitation is still there.=20
b) makes more sense since Thomas thinks vector exhaustion is not=20
an issue now (except one minor open about irte).

Thanks
Kevin
