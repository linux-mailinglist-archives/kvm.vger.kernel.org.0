Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C9C34A04E
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 04:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCZDg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 23:36:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:57166 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230434AbhCZDgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 23:36:16 -0400
IronPort-SDR: tSjRMcMZv2hnqYBfB3uC/u9k0IYVcIwPru1W/X7RYf0KdcU/5ng0iiocONsy9gLBhEDxVcEgw9
 Fa7R/pE+F/HA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="187775101"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="187775101"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 20:36:15 -0700
IronPort-SDR: RL4luNzm2zuhV0TyScQPEtBFvMDwuZuyJVcYEms/9+WkDI4zIDwxEa28Yjys6kv5yjHUVtyPGn
 DvEd9Mr6MXpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="377102315"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 25 Mar 2021 20:36:15 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:36:14 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:36:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 20:36:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 20:36:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R97SnI0M7ts8ER0thXc6eTH06ZmwabtMef3P9n04yIyex32U2W3KyZcgfV4rUskY5iZJ4BeMoF1lbDFSmu5GHm6S2tqMq5bdTcQZ4aZkRw4yg2ubv0w5lkZgz4UUTlUT0DE5+zX5r0yGvxXwlqT7oN0NSBCXKwnTVjHF/to9y9VAYDXwkcLCOjQYuWZzrkCP0IpInTiW4/IjupIltvgTje1mcjr7hz3/dWfTNaCE4j9vZ8wo8cxHh4YY56Wa3fIYTg/SMpsZtGxVkaZiPrhmgQp8T7gf5lr9hKED3SXPohJCRxoihxmYBbw2JRU3hbPZ9WVJJOcG5OYXhPaFDQx5ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aePzA7zgvrOMtADitgHWm5JYSF9mLIpoIrTgF4vKbRg=;
 b=MpNGkfaJSuCI9U1q0eGhjsh1iRmwtPbAxtJHvfvViCAel3YARJGXz3brji92gH8Cstl3u1tdWr/VlIAkjA3rhQaP8KgfiJwchoKymNWgUD8PmvgfTE6IJ0ycvikX3FWFVvlkerej+Grw/egOkkdZrmX1jpByvpPG9+isZ+D7heAbHuLasRKls8C3QjTCLyEaU9sOKFZ6mZbStOY/RJAxoPdArG5bkmQJ3CZx2abGC9hVcHd3lDE5kQiTsYt3c31THHp28tYTZIqkfWn9EkUi8jkC0o98wn+zz4BAE/vpoL/ZO+gAzwNkX1CHo/G5+BTDMtMXrK3O1aqphR9mlE33uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aePzA7zgvrOMtADitgHWm5JYSF9mLIpoIrTgF4vKbRg=;
 b=lfW/UXubSEBw6wbPDGAaf64t8kaUOQoCybO1UD3WDrTuIWONPfOvLZEqPCkINu+ObWgsoiV7qcV1kwAOyfGiAAbccvMidtcguneBfCb31vxccpBExzWcUY7qmBQxRxujVU88osAbqbWviHh2afT1ukj7JtRso9dEmFuHZB5t+uM=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1518.namprd11.prod.outlook.com (2603:10b6:301:c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 03:36:12 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 03:36:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Thread-Topic: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Thread-Index: AQHXIA3q9lE4ogaG6kK1jMCZehbxM6qR8xwAgAOt21CAAAEVQA==
Date:   Fri, 26 Mar 2021 03:36:12 +0000
Message-ID: <MWHPR11MB1886CC39AD587271CFA0D9448C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <20210323192040.GF17735@lst.de>
 <MWHPR11MB1886DED32FA634ACF81BD0B78C619@MWHPR11MB1886.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1886DED32FA634ACF81BD0B78C619@MWHPR11MB1886.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0cafe7b-5643-461b-1e29-08d8f0084d78
x-ms-traffictypediagnostic: MWHPR11MB1518:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB15180134B1B84260E2755AF88C619@MWHPR11MB1518.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mLsBqAcn4Jrym70i9rcSOhvd3dKUem+d9w6nrXnmJYwSgYcyt1BHxa7MVWmh+jqbUF87QQXDdKRfEtbn37cj0Lk7AvCDumgDHcyyablNcd6qOUPvjT/N0ctYUqY3rSaHzEcImyx4IHnw0eZn2XFdm7o0zRDSdd5En506b0lADyOsQDH+OpXJMl+4J6Srw3mQ9iGb3TPDuiCkIKON5Ln+Y4GAkAIcKnPW+3YFbb+iccaPCPHoI55GmnzP8Ol0beujxrYsOTliN0CHjMpk6jZqyOP/V2Cxp3X5tcjCSO8gZxi1diszaDDeuPqdtSLHqMW97TR7Hu+Yzl82EycXMVWid0nPHP2n6YAcAgml9pFgJ04tROWH3zXoFoCnUGxVL7Tq9sQNu0WmrfGM55cEf5+cwI8Ph7nxBibjVVZlE0HxAkTf05E3qRcNiFilkMLo+qGW/imM9NwdCh3M1jqK2J6NfmaaSWu4aVpqa7n/9c3sCnyuFfacGCJAUI3C4LnDmouB5/4YHHVV1z0rqQU0UP0PM28NzTyRAtuAL67uUGnHJJdLEVJDLm84IpcemR10TdAaAXikJol10ul0rIV4MQ+RYMwdoxvDksayRWLv9VoMLme/UtTvYqd8XemUnehfs7ZE9cWrJ1YMIxkPpi/LtvYwkzgHdnpJ9D/3ZAJnE3DsjGA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39860400002)(376002)(478600001)(66476007)(9686003)(66446008)(7696005)(64756008)(66556008)(76116006)(2940100002)(55016002)(83380400001)(7416002)(66946007)(54906003)(4326008)(86362001)(316002)(110136005)(33656002)(8936002)(71200400001)(8676002)(4744005)(26005)(6506007)(2906002)(186003)(38100700001)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zfQqOpC4Gpvcrl75xUluP8aIYJD1TpKEQ2sjqm+b2riGwwjtJ16XVpuiDyUY?=
 =?us-ascii?Q?z4Q3y7lmc5V7vH7a0hXT6+cPVoXwF/h2cEvDJqsa1u7/ohbIAAEe5PXEo/O2?=
 =?us-ascii?Q?Hup0hs4KFbTdHpnSpqoCYo5I/J9OSSFzs+rj3rwa2duBsOs0w0CkWRlVqSlC?=
 =?us-ascii?Q?Y3RMVCXfqLkDNdax18LEzIl0l3EwE/DubQ4s4l1kJrg1PulY+aXA2CNpZzpL?=
 =?us-ascii?Q?/pRLOVdAQuoRoWHY+Gt2czyAjyhSeYaN9Eq05DvA5Wp89ljUAmhsvRV8+mnH?=
 =?us-ascii?Q?YitaSqeJV53DERzOYuV81ml0JM6ISUFnopFhsqqitiwbNQDGEm3gx5vhJEYr?=
 =?us-ascii?Q?n/yHQecnbd0+747cKwo+ahOWceWPor7lVU1wha5zi7keIxaI/swBnvrnCbsh?=
 =?us-ascii?Q?nm9EDYp0Inm8EFneSygy56qAVZlurIBQJq5DzmaHMLKL2MZXP7gvkFYkqtv6?=
 =?us-ascii?Q?Vl1S0Ns0UBEACaxGTk4xfUdnEziQAsfVcSgJRx+M0n4aYSwG8m82gIeRwaPf?=
 =?us-ascii?Q?W1PB/hUGoFqMF9sIpTpE60/EzyqM/QVLZY6yp64pFxCdgibPso+VKCtPq0R2?=
 =?us-ascii?Q?wEE3AiCCweu2Xaj0FJ9mTmfF67/An3vqHTlvkJIAxhV7cqxfpWQR3UMMfxzZ?=
 =?us-ascii?Q?LNClmvqILfAR/n7ZLpykIvBH8uqshJnza2pPcQtRDqo6wm426ETjAnFCVAg+?=
 =?us-ascii?Q?VGEG6SSANxQ/yb5Dgzamnn2SbW4YsuFhAKAK4IlOZwEn0wLhkZlFp7vo8VMg?=
 =?us-ascii?Q?vJPhHbf66jMC9pVRD2QG5w+/MyheUNz5DsZ9Y0RwYyqS/mcH2R1xtcFA/dED?=
 =?us-ascii?Q?4EvnXlvbmdWe1ug3MJpDaXHQTQ8AS9BPFogEPxbKAOWkN3OTxbPxiQTNn9K3?=
 =?us-ascii?Q?GzFgk/6Zamrtx/YK67l/3ueEuJu8ncnrTsqFXrNjiSTVwuvYZpXtU8mDEzA6?=
 =?us-ascii?Q?njf+iuFdQtpGyQC2CU1UdrvMicMoJbXOE1pc6VcnprOVLlE687/Kh9D67uGX?=
 =?us-ascii?Q?Gw/ujELuyrExf1XLo71Y4ppjtjoVlQ7FSJdqhOBd9nMPpDjY0yPw8ak2ryDd?=
 =?us-ascii?Q?JDZqtcrkqXpn4I5/B7o5gZ54Nrzrb1TmL7Bf3bxF1ohAkNG9rqtsAl4jxlmi?=
 =?us-ascii?Q?zrZCX3gyxybtPSaSqfqbPxyvvNECupc98Qo+Cm7rmOWmrKiqaSoq+5+12xUe?=
 =?us-ascii?Q?CNqF8YhCkS1BA8IGPvQnWOvOv/Q4T43BtygOlVBPN2n22wNphmydA4vI7nqA?=
 =?us-ascii?Q?slQQaW5kpreVdVmgkdtseyK2u4heZOQzO8btBfXpXcGd0aewHEz53WcQqSpT?=
 =?us-ascii?Q?44qy/DdNd/R2KEoLjWi5vGHt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0cafe7b-5643-461b-1e29-08d8f0084d78
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 03:36:12.1588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pjoPl4QWjG9ltFDm9Zi1Xy5pltPfFgLuhno9eu7jnulImIUIrs07QTpxpoYAQ+1IjD+QM8EyrK/Inp400V7QXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1518
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, March 26, 2021 11:34 AM
>=20
> > From: Christoph Hellwig <hch@lst.de>
> > Sent: Wednesday, March 24, 2021 3:21 AM
> >
> > >  	up_read(&parent->unreg_sem);
> > > -	put_device(&mdev->dev);
> > >  mdev_fail:
> > >
> > >
> > >
> > > -	mdev_put_parent(parent);
> > > +	put_device(&mdev->dev);
> >
> > That mdev_fail label is not very descriptive, what about free_device
> > instead?
> >
>=20
> There is only one goto to this place after this patch. Possibly just
> call it trylock_fail.

oops, please forget this comment as another goto comes in next patch...
