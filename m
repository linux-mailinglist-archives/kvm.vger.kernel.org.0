Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D103399A52
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 07:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhFCFzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 01:55:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:15129 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFCFzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 01:55:08 -0400
IronPort-SDR: F+n4S5xg6w2wHhcjP3UVDHYRkJ51JpAUBXMykfyBNOkX4y1OP4vdJi6GtltxfcgcDKV+ZEjzCg
 +MP+RD91gekw==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="183650244"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="183650244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 22:53:10 -0700
IronPort-SDR: nod3IKZ2cGXus34ZgCGM2/Lo9GXT1IMMSzR9CeHWX0tm8wFOEJV94lEisRpKPYea46fQ0XNIq9
 QkIXNEOnc5bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="446134987"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 02 Jun 2021 22:53:10 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 22:53:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 22:53:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 22:53:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2eHSiTUplLyvL4oNPB3rE2Z1JFAamc45cG8Hku075QgdWhdtthSZK80WQNAgFRxxGpG+O9XA91x9jF1g/Uoa1EmwEI+1K7+rO7JiF4TLBfH6BZvivkKGA8CzgJLTUWXddg6sZrdsvGTzVicX99EFGn786Up6du8tLsRzfxAbW9G7zOH00ycv4HnWOE4K07OhZTAaJvNbcFcZjoqYNglgF+0gLRVUjgy1mvVn1Slj61Oig79El+HZl/23Fx2I5C5JqNLLJXrz0RJ1Dm6pQQT7f0O2cgJRljAHuvDeVy6WIWH2tA9jk7el0+QkDLBWW7vbNX7q7fRpwCvI9nE5zJ1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBUrvJ0L3G5LkbkEQnQAYAroDIEARsvf+enuhVBeuR4=;
 b=mxVE31XLbmVrKDOo+HQN6YJljz47llpNhXnUclMIMblE6p9YdRRyni70UqG+vOP0+K1SZUlEy0K47RxADTLByR64Tq5rXvSHXybZmFHu50Usp5rLOoFHbhxUq5EPO25ovEmemz0nUCwcfdA/IMU/FQTW0U1EokEDbkVlas4uIYAQfZ7jLG0HKjWPg5TK73yHfBAOYhOpd+tWKclapN3PIYGFzIETcTNwBH7Nu8BsbBcQUdNzV5vwFcykSA57ICcXwy2x+/ghk3LrX/0zRdzF9Iq/pzmWSad5U7b+/Jw1BS6uZYz/E8+rSLzUFFKEfybwsL+R57gOgkggdr8atAxfYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBUrvJ0L3G5LkbkEQnQAYAroDIEARsvf+enuhVBeuR4=;
 b=RQ/6RxfS7KHfjFtOZosBqQuWW76Zt04BZhgI0Br+qhMm5P/Xa5Hqp1ZWZ3N/laWnBlcMZFGFcfb6ciOJ1SGyYVKAFQItppX6M7gyDO8/SI3ReFLm0R0PTfcYYsbiTxktSYtgUgsYFaN3qtgvKtwByYdMZNzFHm9k5rVug5+JPTs=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1662.namprd11.prod.outlook.com (2603:10b6:301:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 05:52:59 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 05:52:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Index: AQHXTqAZRXZQVBJp50eOXR3CymY0rKrxt7OAgA82YYCAAH+rgIAAHwJQgAALZACAAD0zgA==
Date:   Thu, 3 Jun 2021 05:52:58 +0000
Message-ID: <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
In-Reply-To: <20210603014932.GN1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edd88873-8885-4706-3877-08d92653d774
x-ms-traffictypediagnostic: MWHPR11MB1662:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB166225EAF9F150C6D3A74B538C3C9@MWHPR11MB1662.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2HPkxA4mG5ACWG0/l0mEmmJH7XO17YQId2a65v/D7VXQhoJHtmD/WJSzdDJYyjxgRLs6NVDzi6KzyRVh6GAg7y2Qll7/QOnBnj1ixu5NR3pXc2ODHSQKprZi3zc9gBwsGDjDjdl98cIjGjP20AudluIZV/DUAN3lRhQNg09zA64wFbuBDvQ4fdiiKRZkWP38qGfAcAmJ6hApRbJKS+gJOd3AL0vbI36cx2d5w7hLWcBUHTm52FbVmlkHWmNSK3/SGa+A95NZRa2WK/c9m5YeovkwpESvJnnpgMYN2uwB1IiEkwq2BwfwmEpgGzBOxFtpEYK6/JJz/IJtkJtLdb6gYQa+zEwwIXdTQyUoCEnXWDrgfNegRaYjWcREIkWBjmrZ8ezgWgOW/6x/j+0S3XogipmjyPSK22/GtlZ4jcadPR8L869ftonvGalY/0oL7NiprlfvmAjimJRLAe2xxXow0RcImV+NaWZgYKbtPEdf9/4QhAyRHnQTtZT5Lf58qwDxFWnE+f8LoHLCquoCtqJNXCzra6UmRwrinl/9e9NWDWmYw80acYvx37qLIVHzx0LInS36h6A4aZjA45NQFuW08WSyy2ZJ6skSik4caAHhEI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(316002)(26005)(110136005)(83380400001)(4326008)(71200400001)(186003)(64756008)(38100700002)(66556008)(122000001)(55016002)(9686003)(66476007)(54906003)(8936002)(6506007)(33656002)(52536014)(5660300002)(66946007)(7416002)(478600001)(7696005)(2906002)(8676002)(86362001)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Q8i4j/AsPm09SEnVu9MW2Uc3X5XCxGLfSX0TeJPSk/pmIG+G5/1bl6gKdxh2?=
 =?us-ascii?Q?pHBmGnBx1cv9Q2Q5NCEhA7I2E18lItdCwapU/zNS9nWl07QikSlFzrZ3gfB8?=
 =?us-ascii?Q?wkqElcXiY0KxLzqJwCDwesVuu1JoM6lYxaTlfCVMQpRwBt5u/mmgXgiB/meZ?=
 =?us-ascii?Q?sloB5Bq1EjchGLcGd2XjhHEf6vzliooPjtXtJGfQkh3QKMPc8tauKJ0g0zqJ?=
 =?us-ascii?Q?wcDPtTPqOWIqoUmB0wMPBzFaW+PfnBhaQOSU2awkI07rXFtapCxTglatjdZP?=
 =?us-ascii?Q?teriV3DkOWfCeWgf94pifNwBDjTiZzzHXOn9L9Pi3ykyVdTIMQyyZwNA0Nd1?=
 =?us-ascii?Q?CzhBO5ruNwTEEa+7Y/KNvffh/BDwXrBvXL8iTG8hLIEOCv5jG+bmqgQfaePu?=
 =?us-ascii?Q?w759JBQTAZXw2/MaHv0jcmL4PAjpg4Hp1CgvTAGUKdSdeUg7v7khC5RTAwcP?=
 =?us-ascii?Q?VrovacWphR2pmiXn8gGVKry6/L1LauYNPU0Y9eo7AD1ZlivwWZcC1IggDR7v?=
 =?us-ascii?Q?Dlu18wih5y+OOXQC0OX2flemkdHUmam6MIWUI7MUsMSYei/u9ZCXTpJB/vwl?=
 =?us-ascii?Q?NNOmEwIUXXob/7Gt8RluwereL+gdQR8dGb6VXogwafGiWRy7H48Z8hV4yFcb?=
 =?us-ascii?Q?iXh3TDx4PMgqcuVnMuFEwscoLOuZNv/fUyotdAoc/QhjhXtdV+x+FuelijAD?=
 =?us-ascii?Q?fcILNwavEOkoKQUFRg92l9zOMAmMiRporU5Gwx5pw7iO02DO7wvNq+EzdrsR?=
 =?us-ascii?Q?7yPw2z3hSB639nyz0v+3VoQYTNXbrzd/Uq601WGN1HBhIHclfoI6K3YKXjEa?=
 =?us-ascii?Q?Zcu1M3QNB6iOUYyXxKvsSRdscpt3fM22j3qE40aX2VigcXog9ppt9OrlJDEV?=
 =?us-ascii?Q?fe2fEfAAD+UfX6UqsNHHufM+sj4ZmPICItmRTeXOTMcY0AFWzMwsN2sV3RUo?=
 =?us-ascii?Q?GA6TCE6sNIgHXgKaDWA8PRYJT4JbkRil6BbjBQkSFjqSWGI0IuwGGqIMDqeU?=
 =?us-ascii?Q?B/l6E0MBkL9IxSUzZq1D8/7jjPZEHmfTlT663fYgkugnSLJIC9AP9DsvFMLO?=
 =?us-ascii?Q?Hagzy9NXwOVNEM6GSfnWX5UMi/PU8LZTA576sVPEMF9c3q6oyT4aGhVpbsL/?=
 =?us-ascii?Q?9ZWAXS2vEW7AhjszqjZ0YwfrqmvtQgTEFl152qZ4Duep5TNWZqTOQxRbUtw0?=
 =?us-ascii?Q?QCHmBdAFiq8KC3bdvv8Fr2P7N/5kqnr7sIrqTT6dobuw6rULUistzJMr3n7V?=
 =?us-ascii?Q?3x/g+vs8GO/r8LeOTr6dHOb1MKJchu3fT30y9pDr1L/q/lNf+lrJWAGQ7b/h?=
 =?us-ascii?Q?HxcMqPWhiQTke3fULG2lZSyJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd88873-8885-4706-3877-08d92653d774
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 05:52:58.7545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XaLAh1I15Ig5iSATFtXNcVtUox25EcrLDUUE+9vai5c+VGN3bS3aDwaKRfQ8X2P3hlcU3elkNcEajELWDMGszw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1662
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 3, 2021 9:50 AM
>=20
> On Thu, Jun 03, 2021 at 01:11:37AM +0000, Tian, Kevin wrote:
>=20
> > Jason, can you clarify your attitude on mdev guid stuff? Are you
> > completely against it or case-by-case? If the former, this is a big
> > decision thus it's better to have consensus with Alex/Kirti. If the
> > latter, would like to hear your criteria for when it can be used
> > and when not...
>=20
> I dislike it generally, but it exists so <shrug>. I know others feel
> more strongly about it being un-kernely and the wrong way to use sysfs.
>=20
> Here I was remarking how the example in the cover letter made the mdev
> part seem totally pointless. If it is pointless then don't do it.

Is your point about that as long as a mdev requires pre-config
through driver specific sysfs then it doesn't make sense to use
mdev guid interface anymore?

The value of mdev guid interface is providing a vendor-agnostic
interface for mdev life-cycle management which allows one-
enable-fit-all in upper management stack. Requiring vendor
specific pre-config does blur the boundary here.

Alex/Kirt/Cornelia, what about your opinion here? It's better=20
we can have an consensus on when and where the existing
mdev sysfs could be used, as this will affect every new mdev
implementation from now on.

>=20
> Remember we have stripped away the actual special need to use
> mdev. You don't *have* to use mdev anymore to use vfio. That is a
> significant ideology change even from a few months ago.
>=20

Yes, "don't have to" but if there is value of doing so  it's
not necessary to blocking it? One point in my mind is that if
we should minimize vendor-specific contracts for user to
manage mdev or subdevice...

Thanks
Kevin
