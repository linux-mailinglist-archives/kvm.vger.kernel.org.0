Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13AF661DCE
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 05:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbjAIEcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 23:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbjAIEbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 23:31:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBBF55A0
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 20:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673237627; x=1704773627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IfMY7NPSlM8Cz0Wl2FM9cuVfqg7vK1hyfykVNVdVUyM=;
  b=OQoiFF3CL67C1vVRnhcOZAziqvPSrkdkOyTRE9xIAMJw4mQdn9nWn1PL
   +4SESptSWv3p3jtgctlpv9TtDyxD/p40nhXQHvyLfli8P0Ii0iMd534Lk
   YZp+woIIs7AoUlBBxv9etywAdxjGOzS2eSI7KrBpJXTPeVDIfZCh2T41x
   58Qhmg2xr8s/TDGqGABkgdG4lcvy+ZMKSxIPW2HrDY2IecUg6ijcyU0FF
   6D3M1r+neWWiQdO37Oyfs7euAv5ETp02HTyrcrcsGScC5q1Yk9dXCO1wX
   B4VpuzA1MhbHSBgFn+eN/xD0gVBWqLMNiB9KBNbRY16wX4JDcX4wQwdtp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="302488141"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="302488141"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 20:13:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="830468342"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="830468342"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 08 Jan 2023 20:13:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 20:13:45 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 20:13:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 20:13:44 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 20:13:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nir0tRdZPRzFgCAcyDRIfQcqLl4z6nCyjhKdig2XG446jprmJxAZ8N61+fOKrLDkRsHuknMjqXjf+lqBoWiNGWo2Lu6ET1gubHbETQb3rx90spKLdbnwsOKuAyXtvmRg0BEt7L5Ya6KdVsabN+FesVLODDcejxSnPUaRW149Ght1UIIPj6qla7IppUkRFuwYqY92h86zQS8xV+ptM6UTfRxMWcweWG5LncF7oKuHnGw0dZzRWP2N4nTKMAMMsuxwkAm5p6mPeH8PfPOKZOwPJAu0zfindjU3ewaN9qhtycuinnLE9oMeKvnVWqWCaO5MS7FU9Nm1bsnqlqxwyY9MyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Ksb77IyWWwhKwpeSgx2q5lvgLpQ9A9BFCpyMiwHdaY=;
 b=R8ECjnQw/gcPZwM9mxmlnIHGX7hAW7WnfIhcWfyr1gpEKHvKw1NlrCZu15dSVpculRumgPfO+lotkQEUohz98hubqTmgXN6vZwtc7Gorz4jSw2XfwzLKHQGZ8KwtAxI/WGiuU1DmPGQnXuC+u9OcaDi68ugO6YyKJw3vF58GBqaJrEGjzU1The9ML+NFfKm3qpT90q2dCId4QUgRyDaPYfrlm2zThBRstiTL2dCNu2lYifNefpi8pirpyznhk8/I70MiAzsBuWx7QnrWkexvqSibcIP29wdUtuK8aeVhXoytNc5UZKHtLjLpJT2WTpF/aPpdIDWfxUbDEu1r1Syyfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7627.namprd11.prod.outlook.com (2603:10b6:806:320::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 04:13:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 04:13:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 03/12] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Topic: [RFC 03/12] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Index: AQHZE4aUoco4n7f4C0+MZKWU7rSYp653rrfAgBb+D4CABu1sIA==
Date:   Mon, 9 Jan 2023 04:13:42 +0000
Message-ID: <BN9PR11MB5276733E9332C5F64C196C7F8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-4-yi.l.liu@intel.com>
 <BN9PR11MB527678C180EE0BBD1F40E3698CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y7XEld4Kx8kXYC+Z@nvidia.com>
In-Reply-To: <Y7XEld4Kx8kXYC+Z@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7627:EE_
x-ms-office365-filtering-correlation-id: 11802154-6a55-43bb-9be6-08daf1f7e4e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sx8rNo905ZQdYuWuI+FkDFpp9DmIT+Hb7SaTJSNY/Z/xCanyZFofumCKv7p2JrrZWz1hHDWabiW/u9wUqHZulVZ4pGVGRMYKbhg6hLDpMPOjuLaf7W/EefbGoIcxgy8qnpaIoaYc8BJC68vjMclsZ+SafGxBtBtAENC0XlQti6x+TtbgK2JcpEycvJEj9IyhEbB4baTfnNpdZ2yy4ctrHgnRLZqcIYIr7vuRIsYJmemoazAkmkr7CZtE33eh/pJ/ea3IAO6AsluWd4xCOH6UsUlmjtbiqkYkJUqe8Yif2glKlETZQW1YIuUadtUD4rwzIZK9RDoMj0Y2sG3A5lgPxKS11ZrwIAEnnjhCTZa86TtMThT/MtCNFl2N/eAWE6o4e/TV3s3y91OQW+ezuxylub9LfgGf95CjKQwm/PKs51m7c+ebI3OyX0af+S1DvUWk9nSu/Wu7uC+QuPVp3240wCFyUpXddh3v5gwhWteg0OlDIwT4mQ56yZG+5tkz7Xqedh9H2xC1lKsBL/NV2TVoFhtUn5SpC5k2vY6ug40Eo8BO98Cp5jyEo8eNrg6YAaSpvBlNp90DKe0Sw+tkBk0sfm+gMZt+3wUqv3yedWWJbi7ZAWKtg5VTX7/OJma1alf2n8E1ibfbUxbV5BxLcD1hVwD8VK/2iWpujz2oe70KN9TyDr+7viWS259nlknTgXyIv27BuYSHLL2UrXutM/jwXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(41300700001)(54906003)(316002)(4326008)(6916009)(66476007)(66446008)(66556008)(8676002)(64756008)(76116006)(66946007)(8936002)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(5660300002)(52536014)(4744005)(33656002)(7416002)(55016003)(2906002)(6506007)(71200400001)(7696005)(186003)(9686003)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QRBHFUA3d/s/HrvyLRugxbH2N8itIbasJ+1Ce9oJIvl0mXxyKnUtynRLJoEC?=
 =?us-ascii?Q?ibTXduVIYHNulRj2KOTxEBfN1FWKxJQQKBU8ff1DNcDWg45b57hJWSceeEtG?=
 =?us-ascii?Q?yYu609awUFpMNlZ8A1Wpl0lpn/Yyiw8KWg138sNpzi6njRS6dZpZGMjTftRC?=
 =?us-ascii?Q?imPj3bDWJMeq4VsJy9Hq5OfdbzJVrjPgdo1cicupTujhc8poRIXIBtReiN4U?=
 =?us-ascii?Q?dM7xKIWdARGv5eVClklvUFr5PlHoUgq7M7QcHs5ECrhL9Hl4maC0zwwVraHo?=
 =?us-ascii?Q?dB1iNDa3qaJh1jzlMKmvYLanVfcsYbTjMrWIQEC5T9J1a8Y5/pKl2fsiyZYo?=
 =?us-ascii?Q?caJOYFPBdMlQ+ybNEzr72i4eT/556YEa2eLykKFbglcFYquusnVPrqx9+Sj/?=
 =?us-ascii?Q?/vVyfrCtcOhD8vqRITGEP0ItK/Dgq/48XQUH+sMO4KSmQWC8Bi+5WXeXySgi?=
 =?us-ascii?Q?7OMQvSD6rRvVMjXMnG04SvEpPIVdhD1fxHWsKcygZdusvF3RkwdgjdZ4mMoG?=
 =?us-ascii?Q?iUcKG4XB853ajn6o0H4FKgC/029AIotnb3op2x2yfs+uKTCzwsyD48vDfeYB?=
 =?us-ascii?Q?91VDej0460NPmWHnap4oTaP9f2G4NRcrIPvqiqARr05uqgk6qnkLwxHbr+Yy?=
 =?us-ascii?Q?5rB3N5BukTdxysPvOaeLfJke4RdXVDrl1uUGHLtjwD4VHbN35Ok6BLAYmhOp?=
 =?us-ascii?Q?5jSWn3eC7K/OII75/UJSocB8X2ElMiM0qAWCnOKU8O+NMwvRCjANRCEL8/Ii?=
 =?us-ascii?Q?AJG0p7swkZlx1Jljx/pBbqjksZ0M3KeoWrHft5fsXOmy+hsnO36Gihe4fEhm?=
 =?us-ascii?Q?BxUk6QjwGu1oCw8GQ3FSFbC/ZPy4lODFJiyUrkjrLnr+xt9s1TL0kdOLzB4A?=
 =?us-ascii?Q?xnwnexphN4coOyk1IBoDDsKK8+nye6zgn1uk2uKkBq25ruTnus0JJczzr1A1?=
 =?us-ascii?Q?j16wXkGY092c/YknNYzigzp2UUFblPWODmDT3jfobInYz2mHInf0tN2moePp?=
 =?us-ascii?Q?kUGK3VfIMsoHhVkzUmrvv0cyqPu7vOupjasqUALr1mgsSzoqULt1ISr9iWOl?=
 =?us-ascii?Q?k+oUuAPDK+paVRW6Vx86ZbM2qGAtZ1cZp7g/hGR/MRM+6EElMM2JfQ138njh?=
 =?us-ascii?Q?wFER9AaNJJB3D0t2FFO1ZQqFVCz8DURNePKw1jO57MonEhyaJoRNTEQ0PQwn?=
 =?us-ascii?Q?Qshmqhm2d0jsRDp2mKV0/f0SO6xD2q0FQ8kY73DSkwHpQhiup+pTJfHt00kN?=
 =?us-ascii?Q?oSlNV1rlIkrDSr24fWcbjkvZECRID0vr1M6eTDTinWUT2Y1cATVkShA14C9p?=
 =?us-ascii?Q?3/FlzOnO5gDTwOoKEuFyj65aWA6x6X2hQK2AUXaEPmRpOjdhaNuApTzzFR5R?=
 =?us-ascii?Q?BVGVCT/w6eEgv/Tf0LRT/8w4b3ZfLiwpxs8XT5xLeISy9j5B7DckN9Gwmzph?=
 =?us-ascii?Q?fDxBJdpjDy7ZEj86b+BMje5817KlHGpbBKcPhi0Si82SiI2H3qC1W2Y/09lU?=
 =?us-ascii?Q?8piK8JK3ed81k1jDQyrzhha11Xgwe2/UUJqSkzlqgW8V+BQ8fWbu1sYTEH2K?=
 =?us-ascii?Q?+Xg02sSv2IPCngcgrKS6HdF0dBn5QZpBTL75K4u7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11802154-6a55-43bb-9be6-08daf1f7e4e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 04:13:42.5412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pEoluvSZk9rvjOHzvrAlxogqrF8cYQgTR+9b3442QFE8g7bSOAqc5eAk4YR3gn5xD/YrdBtzU84Pq/aErgwVYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, January 5, 2023 2:25 AM
>=20
> On Wed, Dec 21, 2022 at 04:07:42AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, December 19, 2022 4:47 PM
> > >
> > > +static bool vfio_device_enforced_coherent(struct vfio_device *device=
)
> > > +{
> > > +	bool ret;
> > > +
> > > +	if (!vfio_device_try_get_registration(device))
> > > +		return true;
> > > +
> > > +	ret =3D device_iommu_capable(device->dev,
> > > +
> > > IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
> > > +
> > > +	vfio_device_put_registration(device);
> > > +	return ret;
> > > +}
> >
> > This probably needs an explanation that recounting is required because
> > this might be called before vfio_device_open() is called to hold the
> > count.
>=20
> How does that happen? The only call site already has a struct file and
> the struct file implicitly holds the registration. This should be
> removed.
>=20

You are right.
