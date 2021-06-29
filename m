Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E833B6BB3
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 02:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhF2AbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 20:31:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:15112 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhF2AbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 20:31:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="271915496"
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="271915496"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 17:28:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="407946973"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2021 17:28:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 17:28:32 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 17:28:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 28 Jun 2021 17:28:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 28 Jun 2021 17:28:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dejz64I7IjfL0PVkFXwY+1ye5k7c3QKagfPSDyW0VmOqM+lQkK/MStD63CpV25EcIlc1128H9jTZqe5lfq6lQMm2EnlOPOkJ7jBcvCLvfK5ruRMhVkmTNeGkDl9y6KQhOq3jrEPqZAQdKKVPs7J8/mLpYYJ3GV+CMaT8UNdaUgI7bYFsdLIRT5+rhotod6Pty+uDxjAoCW1umTJ9JwMlL4vvgCswWdTU+/Gwed3+0CAR3q4gyjxIo+eaeCowDxG+IqfaG7RhsWn0To1pk9WqahibyNRnR7PxjTzKefXFYlRS8dVizRh/NCgqK01mzxkARXpYfJTO/euo3KbNnWWX4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkjpYHlMh7lL/bFAUgBiPwZ85ZKa4tpgwOhcosV/nro=;
 b=CNZK/EVBW/IqLmWlZAvQ/nE8Og/fHywu+d1wRfF2WYdKrEJnqCyANXB6LwtaXQDRmcyOOa5Lh9YLPoOKYrvkZyVMPlWw0tJASqHdivVQNw6lTOiglaSc227JSp4l/OUyBAXy2tqG7l49ouadcQeGg/G1TI0wmg8iTWQ3Lu3EXkMnQUPqZ/ahICPPQ1NvxEBM9kJhg/1lzPG3nYaOyGRHLqs0+759C0Cu6AApcxqLDSMT3NDNe1SVm8AKilt/lnTqJPAoTWQs15EzHLjUAniU9/14Y+4aF0PrcMAEMdYxKDYYPvhG7kUZ1r6kb6GlwQpMhaCENVznyTPg1gp9DV89wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkjpYHlMh7lL/bFAUgBiPwZ85ZKa4tpgwOhcosV/nro=;
 b=h24DD2Vs1oYB27Ql5Tnuvmm/oJ3+MKSQ2HjZX/2E3FqBL13KR2ebfFh+OeDmDTk3GMGKIeOG4WODnomXFo2G5cJNWLibXjyrh+Ahd8QNjY/2qq2H2u5Y5DHVPOo59Doeiu73Ch61iz/yNfgFxNUVhqjnXRw0ABL1Q+mMuQYH+U4=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1329.namprd11.prod.outlook.com (2603:10b6:404:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 00:28:29 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 00:28:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVAAA3a7AAEa314AAD0+zwAAeWnuUAAuEQiAAACT+AAAALlfAAACtcFw
Date:   Tue, 29 Jun 2021 00:28:29 +0000
Message-ID: <BN9PR11MB54330BFEDFD3AEE223AC2CDE8C029@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210616133937.59050e1a.alex.williamson@redhat.com>
        <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210617151452.08beadae.alex.williamson@redhat.com>
        <20210618001956.GA1987166@nvidia.com>
        <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210618182306.GI1002214@nvidia.com>
        <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210625143616.GT2371267@nvidia.com>
        <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210628163145.1a21cca9.alex.williamson@redhat.com>
        <20210628224818.GJ4459@nvidia.com>
 <20210628170902.61c0aa1d.alex.williamson@redhat.com>
In-Reply-To: <20210628170902.61c0aa1d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 034ceef5-a243-44fa-d0a4-08d93a94d1c6
x-ms-traffictypediagnostic: BN6PR11MB1329:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB132988F6815DBE76D81245178C029@BN6PR11MB1329.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3zLDkyWZwKxLJmjAIcbC8iS1vzEV/5PydO3nu5ozOdwUgi+nJw7C7NuRksrY+mkGgQax6FOyROXi0ifu9PEyXEIWetKGpdAEGOBJugn+kkfNG3pN/BHYRhF4ldcChbu1Z1jG3dzNa5ZCMteZXtm4TdR8gDULy+KprjZIaUmPbhwIy30RWCwkGA3oklSdLlXJZGYt5ahwFi70Zj0KwbFYGyhj7aixMCtNavJ0rJCPWkA7owMjVbQyCpaRsfMGE24mS2p7cXcoEO14bQCCahQKSOsTyCQw+RL/ldKzht2uqP98fOlQgwFKaaF5x2GTh/WxZZcHduVgE4W+cEqipX9Z5shHQ3UN8hS+C/TF9LGoQxNFUoqrG9R+r1SumzT7hXde+GWqXdh5JpsyMgCMyhv4AsrNHf2YHr2aMcB1NXsjK/f2tCUbKj9RsVuwaUtnKoxYPJaCp0qEpaUIo1HSgJED0PDFeDel4JQqvKyB33bn7IgNMZIEqQXz/+MiIWQOzjdSUV/K3MAC4yegjOqN85nZf4XHIkMQHtIeQPA77zn/L/DFi1+CgsSXkzEpxt1970cOnY0J10ia78yZlyEHWE0rv4AzVdtdok2r/J8trZSLyGy5gR7cjzP9V+bcQRU662oJFIkoJrdyYJB5pGb3s1M+YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(366004)(346002)(5660300002)(4326008)(66446008)(66476007)(66556008)(64756008)(316002)(76116006)(66946007)(110136005)(52536014)(54906003)(71200400001)(4744005)(7696005)(9686003)(122000001)(6506007)(478600001)(8676002)(2906002)(8936002)(86362001)(186003)(55016002)(38100700002)(26005)(7416002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cuEHJH/FF6B1ATD2OLWOCszmKlKvpATgrwHV9IQUDH4sT9ivNpBToOqjwbYl?=
 =?us-ascii?Q?E+I1nJjvwtd+sH4nyakZHHcifM1Qsf/dyXwyuxLsi2b+bj9S2yPEslid1Fiw?=
 =?us-ascii?Q?4P2fbcuKxyVomDoWFihJ6Sn/+teekeJl0m57kbXwD8LTDPE7htSvgWtuisVU?=
 =?us-ascii?Q?Yk9SjW9rooKk2zeDl8VNI4uwe8EttyMbe7xogmNCUrkbGtSNlC4LqdihSgjO?=
 =?us-ascii?Q?q4yP6lYoPzTRvpCRwgwUhdD5nILLCsSfbabtxSykkYsQSb8c+ZGtx6xpBKGN?=
 =?us-ascii?Q?L7o23xkdUH62vagckrWjmAMgbyHoqqzlctOMjgs7zfFzASOUkhsK8mhFUNa/?=
 =?us-ascii?Q?B2K3pqUJtOUDmfPrg4Br3a5unXBbTvpalBteVEFcr8uj2Cl3Rab+WCjHzLe9?=
 =?us-ascii?Q?n6I3uvUgZCz78aO2FJ88ZsbHh2LhmMG3uZQ1mVH6LrhnjhE3555OsjVIiD46?=
 =?us-ascii?Q?sb+TViHVfRhGOr8WbOhPLGizcSdYDwyqPqqd3XDCpvW3tuBQOJ56GPPaHyTn?=
 =?us-ascii?Q?XKapFYSZQdom5F7BoeCQ8ihxoWC16f2b2ubY2KWH/ooHmCijb2iPK02GU/SA?=
 =?us-ascii?Q?V1woltf+ndb4Yyqob6eDsmAuSWprBuvZ2EnzmgGJ62pDH3W0zfJ/uFs+PfHc?=
 =?us-ascii?Q?46capmjjAgLnEtDV6hCZ5mCgnOx21uzZ9MEqSZiw8R+zRirXNZWbuZd1y9jX?=
 =?us-ascii?Q?1kzI1nNuKvbmF3wmNEhoj/us92HpxGSPjAsyshO1ACGoVbrDNVbvGmWGT2DB?=
 =?us-ascii?Q?F5gLPdPw/2oiPAM1ASonSA2msjmlZ0xzTetcTWfMVdmEY8AmS1MZpAecly/z?=
 =?us-ascii?Q?T9Gb5HGMZBGtgVi+/tPcjOpb3mEUuUf9NT/2clAQEQIrpvkLpLaooCbue3hm?=
 =?us-ascii?Q?XndydlVxsGcYENJQcSJCP5xtvZfU6y/sVU4Wtn+kjoZ5y+gA9fwZJ2pDnhIv?=
 =?us-ascii?Q?PcAnGP44FAAxCXBFwfJ9xngK0Cojv0vQT5CYHckEbniynNhcWOq5Y+idej/e?=
 =?us-ascii?Q?iYJH4N9e+DHIQ/Dv7naXIxY+mfXYoGFhunUSq2n6z5U+yJBhQAtljNM0P3Pn?=
 =?us-ascii?Q?HFLYxzOKkN2vxSk8+v/vC+dAppvIEqtnHxl7Q+KnmLKOk77QuyY43wnq42Re?=
 =?us-ascii?Q?IN6gp6LFLGHv7GYHw8ofkIGEwCqrOUr8I4BnQtGtMDmx88ZpkwWdb9Suxf0J?=
 =?us-ascii?Q?aarlJP12aBU2ZropccHPCCh5IF7B2d14r49j8KM3AwKDS2cUM2mS0jWm+Ffw?=
 =?us-ascii?Q?EE1pU/iv4no33UtzEDp7yhNvAjQCgztzdf4ITPCNg4aYlzxLftiw+i+7T18X?=
 =?us-ascii?Q?g0WDgnE342yqfIVuCn8CGOvb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034ceef5-a243-44fa-d0a4-08d93a94d1c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 00:28:29.7310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZPmUTxJCYtr7g8Vi1Hfyug2ogVzjviMUnguIbSGZ6gdvL6rleGJAPkH3by1mJXQ5dOkV2LwC9LUvM9QRQK9cpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1329
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 29, 2021 7:09 AM
>=20
> > > Ideally vfio would also at least be able to register a type1 IOMMU
> > > backend through the existing uapi, backed by this iommu code, ie. we'=
d
> > > create a new "iommufd" (but without the user visible fd),
> >
> > It would be amazing to be able to achieve this, at least for me there
> > are too many details be able to tell what that would look like
> > exactly. I suggested once that putting the container ioctl interface
> > in the drivers/iommu code may allow for this without too much trouble..
>=20
> If we can't achieve this, then type1 legacy code is going to need to
> live through an extended deprecation period.  I'm hoping that between
> type1 and a native interface we'll have two paths into iommufd to vet
> the design.  Thanks,
>=20

I prefer to keeping type1 legacy code for some time. After the new
device-centric flow works, we can then study how to make type1
as a shim layer atop.

Thanks
Kevin
