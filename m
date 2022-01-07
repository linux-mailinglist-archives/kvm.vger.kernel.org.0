Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B745F48701C
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345343AbiAGCCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 21:02:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:55174 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345338AbiAGCCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 21:02:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641520920; x=1673056920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AT3LVJ5QShzsc0zSse9pwBtVPBJD9I1J0U9qdtRGWTQ=;
  b=lZG4Vgy3YHutOTWk4lSSVbInssjrE4HG8X43hCCegx0XFd83CGYFm4zl
   V3jnuUNxkuNCI3mksHkmMhuZFh+0aXUSepw6LsFJS3hIwIzG515Qr251Q
   ggT7OGmIhFyVIs5Lb12/lCDej5ZZcbP6viN9QExEQqJHMicyRxJWKhWvY
   wU9+VE4088gyJUMTe+n4W3CWe3DDS7wSUOyu6i0XnyUZihun6TKUJGP9T
   iLhR8alQghApTjXvnLP8LGfikFTeivhabyiW2R9saEjdQaFD7kHQU5UaV
   wMRHg1om/8uq6cvJKmgU9PL+lZ/6rTijO0M/M8cz7CkyItWEZaMlWrNfU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="230130431"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="230130431"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 18:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="763705352"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jan 2022 18:01:57 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 18:01:57 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 18:01:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 6 Jan 2022 18:01:56 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 6 Jan 2022 18:01:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ken7UbpQj59X+SPqbkw1D7EbCf1rPgBrvgHgRSFttKuKDPQXozh8PdthYMHQq0Mpd+m0Zlis4ynnIbCrjsTSyFObfKCdghXI61jGW2K9SFEbyjMMgcXx+kiVSuX/yUW8E9qqRGxjtDOvaSlrGiVNVAJZnxs7vZBR8GQo1r5gbMVahzK8+c8vl66OL0Re4hK5RbCq1xv09tBZ26bbDJTUQQQecNsQGzM0MmB81IuZlR7AvC8ZLM848vMi0kbnsJF4sTPO17bF8yCHV7MyNXGQ+9RwxGKFA0prc303xxfqYELJXt1ZkV1R0ykNAAfvgYVDPMB9dkPYC7oMzFqYn9vPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AT3LVJ5QShzsc0zSse9pwBtVPBJD9I1J0U9qdtRGWTQ=;
 b=VWjoRL+DEo2GkUHZTj3lMUA1NyMEW2+aN9lIZKyvm4sMD9d6Gveyu/cqXwt/Jwm8ycFGANDDZ5qEmc+yVTYwpzdNOAULSWL5xrmZdMji/K0if+SO17i3VuBZQ+unHt53uh8Rall3W575yIfJVxyrDQ5vdnLkw9iW2I+8nQ4hcakmz2kS00VNJR7stc+m66U7R/tidQnu33dAdJzy3cdfpukiyDAxffmIPMnHrlDL26O4EKtq7QAOpBPuxlxB5T9ZwUTI8ZXa2rPuUSTytNx5SsmOC2jCckjz3Q3B/wc2XS5XIu4wAI1Qc5PQa5uwPs2PTbTIfq3hFAXH+qPVC0jALg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1923.namprd11.prod.outlook.com (2603:10b6:404:107::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Fri, 7 Jan
 2022 02:01:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.010; Fri, 7 Jan 2022
 02:01:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IIAAwDmAgAES3TCAALDYAIAAhPxggAAOagCAABW50A==
Date:   Fri, 7 Jan 2022 02:01:55 +0000
Message-ID: <BN9PR11MB5276177829EE5ED89AAD82398C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
 <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107002950.GO2328285@nvidia.com>
In-Reply-To: <20220107002950.GO2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fd45512-5970-42a2-d385-08d9d181ae5b
x-ms-traffictypediagnostic: BN6PR11MB1923:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1923FE7C1CD607D68F4FFED58C4D9@BN6PR11MB1923.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v00apn6iVk8zld8RJHUABJ0xBEDYp7wK5w505OqoogaV1gbnxwYcxiolP96AK7BI20LpJa4lYBizkBDfq4B8PeCfRa9ot9nzRw6WjbA91r4S6v8hManZQcGRN9c/eT1gBp80G47z0mjOUIfx/JJAagRbdkEaSYD4NAIMGQb78qyiXNbEfE10xm1vH0S8TjPkf5U2H6/fDJSM9ZrX7JQYvLsJkiXICkx20zQPwmVjA60B66+YqbYK72LGS6zLROpj9F7wHEnhXGdiQJOxnUMgv2wmxIJtXER2ER9dXYr5hQWLTEwXS5F3LubuSCdSbEwb0iyeUkBF02JTd6bB+nfSM1g/KfeCyQq2TZMlMeYA2VMJj2A7XbqyzOAxX8RWqOQ3g+1MP2w3Hx97GQRWTQ77GaJEUo2DWc/RXtSpVeNATxXchNhP8UXugFh8U58YuFVpjLEUbfn98CFTtgqwrHjUjVfzNx96xMAxRQBhUHBpSbzVvI6jjgiYLSdapDUW1neQhkDzk1/PnH/mjknVLtAvrCgFVn3oMX8KvwftQVW0D/ekIwHA9FQOiI2ZVHp4wq1dCE6576NG5RzjmUTFh6CnN9+wF6qve7eCubRa3NMdIJ90q3ph2NKLz06Qyx771V+zQR8pprT9hmoZk95XJOxA+dgz7U0aM/YOsnmjFqyrzrXmx+E2Kc6ZBoYcz1LuosZFKaF6XpsgqGadZCV13kPt2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(6916009)(107886003)(38070700005)(83380400001)(66446008)(122000001)(54906003)(26005)(186003)(6506007)(38100700002)(71200400001)(33656002)(9686003)(8936002)(7696005)(82960400001)(508600001)(86362001)(55016003)(8676002)(4326008)(66946007)(66556008)(316002)(2906002)(5660300002)(66476007)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8g9AZlst56UvSzzByxH3aLUIF8gCz701u3y+uAouy6W26cvK/x3BQEkPEuq2?=
 =?us-ascii?Q?yf6AvL2AzkP+tarE1Tc0uwhpJaEIpiWvEEKRxPJfKScz4IzQrPfooirGLwtE?=
 =?us-ascii?Q?N3eOgfVc07BHFW65RCWpA/No+1lmY69T/vSqmZwjX0MfqE6qgT7kCzkvo7DF?=
 =?us-ascii?Q?nXkK0r6b5Sv1DKrBaTeC+aJYl700RL6BQPvzkelHlFdw1Rqk8iLM7RxYrkjJ?=
 =?us-ascii?Q?Hte/BC/fnggGYvdRTQpUdfo/LIaJrY88js8M359fzel9eEMQr7tSkjru0gnD?=
 =?us-ascii?Q?nzxrw/kls86C4zFc++/vRe7bK6zZ8q6fxRrnEG78reW6reHr1PX3dnQriRtm?=
 =?us-ascii?Q?EzI+jWQUYDoRVjee9Yx/O3r8U+KM6haUhJxrCjnpVMazsu9B5g0eY87SMWUJ?=
 =?us-ascii?Q?jXjVaz2lrJ4XPkFZMeWXliZz7cnG440wBjuDjOMsxz5HivwnXb3Q6BSJWq/b?=
 =?us-ascii?Q?4b+79C0TaqLcW8Fru3qZtPHGKBGSko5oHmKVXihukCLiris3S9W9vjuQD0gx?=
 =?us-ascii?Q?7qwo76hh8LUBHlVZc6lBlEN49ox1FN35I9JfjXQ+bVEeuVJkssZnYsZu0QMI?=
 =?us-ascii?Q?GVz9ygXTwZnSTHEaqqa2J2+SZbLpz+8vX13XExIUR7EmTiWPa7XmdBMPtuS3?=
 =?us-ascii?Q?6f2LQ0TOIJcP/dmKMfIfSIiWuBEVIDKuxflFl9wY7RKY2Z2L5gVjFprqAX8R?=
 =?us-ascii?Q?8s2eZGVAKOy+rOrL97Y8kLGXIFj/ceE2T1kkq0GECCilHEIa71krvS6gUZ0T?=
 =?us-ascii?Q?ZO5YBudOjFg88R4D5R7VcuuF+DMKT6EpdxS8DPgCw5VuVFrymCbkwGRmtij+?=
 =?us-ascii?Q?lfdJbtCSDcCm2+sZYDZqv4uL6du/G2lr40CCMI0gVbsF1tQdS/F6pVdEwuEX?=
 =?us-ascii?Q?uAFqxPO7NwsnqQUqDbAZbTxPoU4nd6YjOJjtnM9JBmKrHQyTOCSxpJ7U/2D6?=
 =?us-ascii?Q?bActv9cdgkgw7LQCieBMl1IBkZs3+SJVfdOihPGNGE+ghepmJrFts8zJoL5N?=
 =?us-ascii?Q?uMlC5MpXptIJmaCp8dr3mlpQUx+WTgzal6GA3HaPbEi7MaYDmPWiE+ScyZxK?=
 =?us-ascii?Q?ESIZPIRiKSnJ5NaBMRQjTQtsvAlIFpQ8/GsR8S8yQgEaMlUCx8+0X4+s3YMn?=
 =?us-ascii?Q?KbGlwOGk8cY93lSxhlIqIyHa/JuR03sA63y4Ocli+Yf0XesW5wCx+NQlgI8t?=
 =?us-ascii?Q?Vv7wKHa6PvYPxW+dxLBVsqQaRBToaB7rVyAvE5V41KAF6PZeUAB+1x/HHql8?=
 =?us-ascii?Q?KaBmaXvF6ncCYXAM86itC+f8T3zE74D47OA+DvS67OtHdBrKkcGvG+7Cg05m?=
 =?us-ascii?Q?GYobJ4IuSdxTmVke480CCeQcXq7Ttifiqp3tjRWpIOqPR9Q63yvZHk/P5d74?=
 =?us-ascii?Q?XLJR+cuTKiOw7Bq8HpquyKZaCCTM62a9oc4Zn89sdd2xHNwJVWh69okLqeta?=
 =?us-ascii?Q?etHBSHne3rDcJmlkPNS4x2+2qvjzTg/kokV3yq+hN1FAvGhiJVONfM5qYzcD?=
 =?us-ascii?Q?BWDtObAPdfHW4P8Wqrb2a8QoByPnZj9aDjaRz/CnovhNPDefctEjdUnNChT9?=
 =?us-ascii?Q?oOzf4KH0/R/NFc40ajIJwcBEznYnozvXcDkrfS//Ou00CYm6/dds+W3Wek80?=
 =?us-ascii?Q?O1gITP+LfY/ffmWRLcFvL3g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd45512-5970-42a2-d385-08d9d181ae5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 02:01:55.4561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHZOulha4VmYmonl19bzdzohrX5eyrBPFYpYacF192fHJJPPomvUa8lGv/vUX0gLVl4dhlbqgcUIgvwXdzuEpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1923
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, January 7, 2022 8:30 AM
>=20
> On Fri, Jan 07, 2022 at 12:00:13AM +0000, Tian, Kevin wrote:
> > > Devices that are poorly designed here will have very long migration
> > > downtime latencies and people simply won't want to use them.
> >
> > Different usages have different latency requirement. Do we just want
> > people to decide whether to manage state for a device by
> > measurement?
>=20
> It doesn't seem unreasonable to allow userspace to set max timer for
> NDMA for SLA purposes on devices that have unbounded NDMA times. It
> would probably be some new optional ioctl for devices that can
> implement it.

Yes, that's my point.

>=20
> However, this basically gives up on the idea that a VM can be migrated
> as any migration can timeout and fail under this philosophy. I think
> that is still very poor.
>=20
> Optional migration really can't be sane path forward.
>=20

How is it different from the scenario where the guest generates a very
high dirty rate so the precopy phase can never converge to a pre-defined
threshold then abort the migration after certain timeout?

IMHO live migration is always a try-and-fail flavor. A previous migration
failure doesn't prevent the orchestration stack to retry at a later point.

In the meantime people do explore various optimizations to increase=20
the success rate. Having the device to stop DMA quickly is one such
optimization from the hardware side.=20

Thanks
Kevin
