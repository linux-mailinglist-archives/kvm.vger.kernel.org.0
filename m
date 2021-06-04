Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1422B39C3BD
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 01:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFDXNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 19:13:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:53504 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhFDXN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 19:13:29 -0400
IronPort-SDR: wvV0B1Z4WHb4+A1SKXxUsXYB4UE7//Puuyz3DcZ8hwhIu0Byro24Zryb7mghrIkyY2rlWszZbO
 gTGMjPmKUuRQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="191720050"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="191720050"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 16:11:41 -0700
IronPort-SDR: ma44dKrYh2QJP/wo0Q/u386sU/oWzUrr7wr1Rq8WdIHTfL7Wp9fztbdcWvZvpksBnPOE573iHY
 iKd1oxPEafnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="417898526"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 04 Jun 2021 16:11:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 16:11:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 16:11:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 16:11:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 16:11:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZKV+jUztoTHyO5vT+JfO1F2OHtM8QJuEV6pRFZZxH2EH6pVTJ8VlGQEIA3L+hP93ohk3BeI1HBEqcAl5FxfUUJRpz7QZXxol0YUI4vqgqyZ31R6jCAa/astXHIgd8a6xX6xHWto9PtRJkKoDyjqHgGxO4t8wTK3QZq0jq2mMfefedB+usPbI9r29BZLr+42+fLg4h/5+Np+fXpmwNyGmn6yIzVC8Va7Hi1+GUlOPD/TFCySONbErqm75WahDFPP41eL3ahh2+7cEpqn2hZkGPpf2kGAdZ75ylD72pKrM8aarY5fxjUrSuMSKDW+nSS2mZpByZLbDW1ct5iKEue6HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEFrWVYjY6b2fAUM1CiFjj8gpWJVAterNPGNJjAt2BQ=;
 b=D/eXScAGQ+o5l7kwQzXZx3m6z0d5hhj7OHWYehPZRSHOtoew9hqEivnx5uvTcCbbEHk05zeyWNo1VjUTFalxTujXw3JAhVV9Gdj5CJjKt18WHlPPTy5d/RbR7sAc8VML3WyUbKifjLVaNQ4dZHAF/PhJsBp7Pd2O25rZL8GMEkLcNZEI8tPtSBpzVAico8TfhSGaNqnoQr/zuCQV9Qd3q5ceXO67fgF9Lb2bISmjgujYIOV/nGdHnlnmmLd+tcFjHN9zh55G7Z/ex/AzkMDvUZqvWMLGFrXZ0UPvP8/Plgca4vbCBt742WS6W1W35mIUqcht/ciie7sKDHK7wprxOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEFrWVYjY6b2fAUM1CiFjj8gpWJVAterNPGNJjAt2BQ=;
 b=dfBSKA/wDVxAltYeNkh7v9XwHCw43LwpM8Mk4a7/EF4kB7GGXskDml/Almqd/TszuSPePu3Ts3VckcxAlN8AQf0yNyyqrYFedz6cJw3vtb1hB2IkvGtFfWnm97tEoitF8M0TdlU7wyY43tU95sU+rDU8cWEb8T84LayzTYi44s4=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1773.namprd11.prod.outlook.com (2603:10b6:300:10f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Fri, 4 Jun
 2021 23:10:53 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 23:10:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBTUTCAAQiuDaAADwOFgAAkifcgAAvJlIAAFvXwwA==
Date:   Fri, 4 Jun 2021 23:10:53 +0000
Message-ID: <MWHPR11MB18863B2D785138E12193983A8C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603130519.GY1002214@nvidia.com>
 <MWHPR11MB1886B04D5A3D212B5623EB978C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604120903.GI1002214@nvidia.com>
In-Reply-To: <20210604120903.GI1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dbed59d-3ca8-4821-ae4f-08d927ae005f
x-ms-traffictypediagnostic: MWHPR11MB1773:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1773F84DCE7B8CCDA05817E28C3B9@MWHPR11MB1773.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t5IpDpvUwhRoZuIu63WkO3O10Yzjy34k9emUwto/oikkre/OzTKMMaziaUo+39kj3HHbGPQnsGNhhQQqYwxAZnsOhyvJaneq12yX2nwj8LJeUJn1iYQB5AmWvvP73+Zlokpli9Nv/jov4QiGYQy+DEoX/+ZpDY4EODnONQwTx+Ae7dhU9QLefOlFPYmRlveuPXVAMeMvdGoETxkGCz3a4dzF1oGgmenHC0fhVmd94P0dSNYnyn/eBrGnJUmllee2mylITlgTrbA3W5xpmx95kCj/zU0nW6ZmCjmN9ELiLtumIGrrdUIKu9E36+VNBdPCubsX8gVI8fRnHtpHWAdChivYi1DbQtxOoV6rHcx8yWoBSlIiIceqkAdtxzj2mOyjWMbymJ5szCesmiCFjkkAMYi6BeTmGEFzZp5DjpzLUQt7XC3oWREaT9MZvfyjUaMeWRPXja8w4X1+9jdRfYEKgiuDZ/0nYJO71cJnNYgt5pZjskSKBfbxPWHautI/pnsq2QCm1saiLlz5q6YkEbSy+62WfCFYub5XjLLtWCMT/xGhI3mGhJG6n+r4ZcSCftr9FlsOkltLegfOyh1ATMhhDpcMSCz7JVj3wYzY07CIsu8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(8676002)(38100700002)(122000001)(2906002)(8936002)(86362001)(83380400001)(71200400001)(55016002)(9686003)(33656002)(76116006)(66446008)(6506007)(26005)(186003)(52536014)(66476007)(4326008)(66946007)(64756008)(66556008)(478600001)(6916009)(7416002)(7696005)(5660300002)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XrJMHm/4un68yJkdFGnNhwq6RNsmNsp6KyYrxXvLYDHavuZbTETyqG+OF7VC?=
 =?us-ascii?Q?3wVKU3v4/GVt6fAP52/Gidhp9vVeN/f7YX1+CYDJuV22mnBnlzc/W3RSYXur?=
 =?us-ascii?Q?39EmS67NfGjBhjnSS4Qa5T7qATfMqg4YbIDEZU1K9noh9edAp666DmWYcp7X?=
 =?us-ascii?Q?REXdH//f/2GDEGSsPDcuEl4yjxNxuWtsaI2gnDXujfDcY/a/P/heHxomsPCz?=
 =?us-ascii?Q?GJgbLGaK4StBoEu5NBNSP+2Die8oLcBOQhienZmzI42pJ1wc4wu8sDJUsr7m?=
 =?us-ascii?Q?2hO0yd1SYvezLhnVQHPoJeJuFJYAxFNxr+fAIhd2Z4c4uj3Jn9Ej8BDm2gvS?=
 =?us-ascii?Q?BunH4FXZUm0Pz4NoroSZgbGJ6EQ7CPYXsEGiJE3INYueFzCzjHN5VtQFQxM/?=
 =?us-ascii?Q?Bo0Cn4qKjaGvFbSHBJ+rPmvo7W0OBjlqBc9EyYjHnsfDhKrHcoT3nVvO1xD9?=
 =?us-ascii?Q?wRmwEs36H+XUk01aAAusYX1wwoOij9rB/KN3OBsQRQKoz+NZ9Nh4pfmvhnGI?=
 =?us-ascii?Q?b39OwzOCMEnWLOcOVvEeEH59rv+CTE4/YTUZr3h0LQcyAmTvNhG/O7MM3xDW?=
 =?us-ascii?Q?XNJRFqCKkY7zJ7/EJ19mTvrvG3PihEkI7i04e/OdrpC04J/tCAHPJrb3qOu/?=
 =?us-ascii?Q?b2+z6zcUu7kt5h6HLIeeRURI5aTONgpjmgzCrq3chQX6MJiEndNljOUuiScK?=
 =?us-ascii?Q?fVsjY+AKIMqmgfaH1XD6y9zQmIq88DLec64LbLg/z6r8Bz+k5q8Yfs9KK1Cl?=
 =?us-ascii?Q?3j6n6PtYn3xbnRBQNRkntKWLHy8f8JaBiLVy/8xE0ag5N5PSaHSdYSWqQpqv?=
 =?us-ascii?Q?wh2IWs+z14tbyg0ywO9TPHkzT6jCrxgeqL5HCG5Qkv7ME566OlVpjWfmnURy?=
 =?us-ascii?Q?TmCz4mzzNcBK5IVct26BcDllmTzLAuhajNs98tY0tYS3PQMo+VMpWlpRzk9y?=
 =?us-ascii?Q?K2kEDypWjZ6lWSOzlzqFbe6gqKvoAouLYiWNjus2IvLTOEKS38x3kncgLulg?=
 =?us-ascii?Q?Dw94kLb5HkD5RPctJVEhWyPMv+CuRwOn1mPJThfRarj7A1XqvtgxHXHQcsE/?=
 =?us-ascii?Q?DMeRZvBhbX8LTIs+I3kqX23LC8OoSmAzqigQeEib2RrzLqnMI00PZFO4OaRR?=
 =?us-ascii?Q?qpxLeoz+/s6kTSiF8pFbXKMW2gzPjh+jOO6pB/IxJZWN6p19al7W32qMafTJ?=
 =?us-ascii?Q?Y6/l/rDHnSQkKdzpQWoBxAje2hLTmfXyt/qNgKvqjPbux28j2okH6T6NzTMP?=
 =?us-ascii?Q?e7zDwTKhrHV+Hl//DbzqdplmpaRAVAZanlGtwhZr241Bc7RwH70XFqkq8ij1?=
 =?us-ascii?Q?X/KnRSs67vHfNKRK35Qyhpft?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbed59d-3ca8-4821-ae4f-08d927ae005f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 23:10:53.2629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CHjyUbwZx+RxjaWLHOSpwZHzmN63NNaFWLVumQR8l5S811sprqOtRe52I3ZB5ghcj47xUJxfMhG9MXg6cv4wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1773
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, June 4, 2021 8:09 PM
>=20
> On Fri, Jun 04, 2021 at 06:37:26AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe
> > > Sent: Thursday, June 3, 2021 9:05 PM
> > >
> > > > >
> > > > > 3) Device accepts any PASIDs from the guest. No
> > > > >    vPASID/pPASID translation is possible. (classic vfio_pci)
> > > > > 4) Device accepts any PASID from the guest and has an
> > > > >    internal vPASID/pPASID translation (enhanced vfio_pci)
> > > >
> > > > what is enhanced vfio_pci? In my writing this is for mdev
> > > > which doesn't support ENQCMD
> > >
> > > This is a vfio_pci that mediates some element of the device interface
> > > to communicate the vPASID/pPASID table to the device, using Max's
> > > series for vfio_pci drivers to inject itself into VFIO.
> > >
> > > For instance a device might send a message through the PF that the VF
> > > has a certain vPASID/pPASID translation table. This would be useful
> > > for devices that cannot use ENQCMD but still want to support migratio=
n
> > > and thus need vPASID.
> >
> > I still don't quite get. If it's a PCI device why is PASID translation =
required?
> > Just delegate the per-RID PASID space to user as type-3 then migrating =
the
> > vPASID space is just straightforward.
>=20
> This is only possible if we get rid of the global pPASID allocation
> (honestly is my preference as it makes the HW a lot simpler)
>=20

In this proposal global vs. per-RID allocation is a per-device policy.
for vfio-pci it can always use per-RID (regardless of whether the
device is partially mediated or not) and no vPASID/pPASID conversion.=20
Even for mdev if no ENQCMD we can still do per-RID conversion.
only for mdev which has ENQCMD we need global pPASID allocation.

I think this is the motivation you explained earlier that it's not good
to have one global PASID allocator in the kernel. per-RID vs. global
should be selected per device.

Thanks
Kevin
