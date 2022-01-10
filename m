Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D790488EDF
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 04:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238316AbiAJDOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 22:14:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:53725 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbiAJDOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 22:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641784490; x=1673320490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MNSQ60qc0c5A/j10FNlj4lHVO0VL67gFxNtX+6O3cok=;
  b=NlErkrkimzmtAeXVKqKoInOGlnXxbXxDiz7slhZog00mSn5PwYCZIjY7
   4dLxn4kMAjIuX1fjM9ZxTMPCAUqNzy9eJbfJAD+s046YrdogcQBvObUBU
   mre0GqBGE+pTEeiafjNr3LhFhtQ2x4GjQCxgXY3js7vv9Kge9LjBnwHsa
   UydbWkJvFijjWyygJ7SpEW9wktnitIk1AOiLzUYKt+sPMXiMh6KIVD9Rf
   ahWzuA4p6FsDFJiNg3lomiH4PapP0Tp5sOGTNrnrB0sRDtxWlyET8YMXz
   GKFsACuNVpwu2V/YMvXctcbch8vgsiLBwvIq4kHJaO7fhfVVZ1xR2CcOE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267467133"
X-IronPort-AV: E=Sophos;i="5.88,275,1635231600"; 
   d="scan'208";a="267467133"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 19:14:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,275,1635231600"; 
   d="scan'208";a="527830298"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jan 2022 19:14:49 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 19:14:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 19:14:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 9 Jan 2022 19:14:48 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 9 Jan 2022 19:14:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIUAgbJiaF0X9RH2emk1NqXPapAlx11ZLKLQNDUEMQEgsiz/mggDhpWRjInKriQdqo8KcKlojnPjRrg4ZrIjCoaBMeIu1Vp+iD2OoGAGV4nv47Ep49soA/VWRmVKq2PbCEtwXv8AaO81WLXCqje7GujxzDbyr9Nj0EjlfTT64UOjHU7cMCBkOOZCkjeRxtr2FIVx4hwt7QErZUZpKf6uHh1jFX+gEQ++yJr5dDCkzhSKmMHV5gr3V1rNbSkl4ke0qCipvhQAKUGB0n8PAtXwcSHz78mKbyqnnXTAJwVDmLXArEiZm1lerfGSbQ+HZCdOyD9etKR3+/oxmJdJFDXV8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulkki1XtzkcYiHifxf30cwaeMRSf8TbWbLz/MoAQr0s=;
 b=TFLExm6ntcxPxeFBlPX0Q4He0L5cF/hUNRt7hU7LU6+a78I86IA6nCF1du7meU7M/cIS7jnFN7/JrJpevVgtHTS8m4MipEEC7aEGgA5MqrPqJIx9xyXcikkStAxWCfWoNRyROKhnrjvCN4iychV8+WXZXPb+ywVba1VOQel0g5/vTZDj+2b6rcw/dH0xPtEkG7IdnldmjIiykanePw2S4SUqryJwsBzW6CGgAvHmIglqsp/Lodd+gEq5mNWr4iuRqvCSeDPPgFtK4W2FGW9j1gFoHS0LeQ6wdvbcvOnYlcJIwnwNqKroF4UZZmTDgHSS8P60RejMRNdCrBWjKDqVnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1859.namprd11.prod.outlook.com (2603:10b6:404:104::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Mon, 10 Jan
 2022 03:14:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 03:14:44 +0000
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
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IIAAwDmAgAES3TCAALDYAIAAhPxggAAOagCAABW50IABBXcAgAO9hLA=
Date:   Mon, 10 Jan 2022 03:14:44 +0000
Message-ID: <BN9PR11MB52766CFF8183099A16DFEFC68C509@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
 <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107002950.GO2328285@nvidia.com>
 <BN9PR11MB5276177829EE5ED89AAD82398C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107172324.GV2328285@nvidia.com>
In-Reply-To: <20220107172324.GV2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8af65438-03bf-485a-cbe1-08d9d3e7598e
x-ms-traffictypediagnostic: BN6PR11MB1859:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1859ED9BB73AECF456EF4DB58C509@BN6PR11MB1859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C9GS/peji1r5oF4+sX89UWR9ink7/9NhW5OR9+rQCJgzS0dJ7U3masqe8Q7RAbhfgWHtemBusU5EOZxGSLj9ky8OGz2HfgFLVWRTfU0tQtvexL5DZOTXYJCVwuBdMfn/sY+dx8wMglBgNJsR3TyhVQZnqqP6krRXNLjGxYqf1qOjuysHOPJHlKAc/xaAwVhcEG9Oq+gM6osXmA4g5STbFc/pyCFkBAf/Mx2GYfX7HXw0PI9nlIIqywwpEX4qN1PuYdFvCM0yn8MB8yKiy2Gf+A338Ve82s9P6eRw5XQi5zKUBBn+Fn9BVojntD1IZCR41tqIMB35ZRg/NQZwnSjRkBsv4BPP6cs3L3p3C5gz4cKZVqauBk0GgFog6xDDQd9ICiZOyhV1fNzOVqQIUVfeHOQcjbGNvxZaV39vs4AP7/q1eTfkumwYai1PeXZ+BHD9iJPB1auEXMNoAoEBwzbH7p1SLAeP+qwJ315qTt0t2ZGKX+krDUmaD5w4dLZ53EvAq4mcKUsIJVrSNKF4Q2g4rb9sWSa97zA9PI+h6Cv5XXhPJxsXOB074G4X01QF1tubx+68DKRcQg2A9UbJ6fq7mpldJ7kElhveAiGv9CFaIJKqh23OOqdyjkor7wgdm1baKu+KWyvY1jRYh+Y8CwQY2Yzh3swGGi9RZDi7wTAm84rqsd6x4y+l5eZyvF/XvBfajKVMmuLzKdMWFBWueQxkHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(66946007)(86362001)(71200400001)(6916009)(66556008)(4326008)(5660300002)(83380400001)(7696005)(82960400001)(55016003)(316002)(122000001)(66446008)(52536014)(186003)(38100700002)(508600001)(8936002)(66476007)(76116006)(6506007)(33656002)(8676002)(9686003)(38070700005)(2906002)(26005)(64756008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1sgQAmXr8kyayYmGCxKxxurBwggKNeKRK9l0spZ6MEH6pX0ewKAxaTQ8+ZAu?=
 =?us-ascii?Q?xy05Ex8Kx7LRxWn5ti6DdSXcA2p3zD3mgZO3kPpJaO2XnWNB4AEOdm0PnhmW?=
 =?us-ascii?Q?gCUhy3J5dYR1U6sBe17PcH+cPrG1he4ngscSAgbR/yAqcIu96Kd+zB5HLN5D?=
 =?us-ascii?Q?KVf29xdS3Mkyv4qooVbXDzer1n0sqTv/aSZXi3q9kcQWXQZP3hDSpS4yHHR6?=
 =?us-ascii?Q?H0Cg/fvP3RHqUruMnYMBxFgDAl+6auwQt1S57TeZJAcjmCZAxG9mNLthOGKn?=
 =?us-ascii?Q?xwbuEKzSB5SeWEfmYkm/gqbuhX2j60GwpUtdQPjUPuV923iAdtfaPXSHVFvl?=
 =?us-ascii?Q?BrAfxayqi75stFgJ/+jZOXcndbUPDNVI9uzU2XmVLh1YCxkvpZk32hH7wEv6?=
 =?us-ascii?Q?oSZTWLCM7AC+Au/GBXBIxy3/s3DN1/jK2nf+54+hzZxuBaJs2mtB+CetS488?=
 =?us-ascii?Q?V0aBZSru2pBH9XBTRE+8ercz/H57vdCP7bsjo7s9ZC9Q5P8L1btAxwKp0HiI?=
 =?us-ascii?Q?fH9ONOfUe9CS3/22reRjzAgQh0Bl3GQpFGZwytCEBJduKz4UEwwWIol4UwOV?=
 =?us-ascii?Q?dUoYIdr+vDN6u/T14OulUJVT0Sjd03BjqmD6CjBM8AmO8rCFEGbVZ5cT/EgM?=
 =?us-ascii?Q?+Nnoh8TtD10lECi9I83F+yH9n5r/1KGQBeysaIrMaFHPdlj9jJmBZu0wrNMX?=
 =?us-ascii?Q?fmrUGaeyZDw4AM4Qq4GwUHoIaVjy7JeQQdS4899OBK9RpnArje1RTzQBKtVy?=
 =?us-ascii?Q?b/TlhZjm7jia/j9U98AtqTvkYih8YVS53guyIYN5hdohK+nOctktDXwIPtpJ?=
 =?us-ascii?Q?ktcc6sdxUC3oW22tje/vSgB5wzPAOuGgs6BbBU3/w135xn5G0NIuWfeYjByL?=
 =?us-ascii?Q?rUubt3l43WDdSfE3nP5kGYaiz5lAxi5QQyEYcDiMbrWYtn08ZGHWOoBwhnH+?=
 =?us-ascii?Q?eSnOFGvbQiuB+Pryv1sbIAzPuXoQfZ40cefpFQAjyvylA4x4V+biQvtTGi2D?=
 =?us-ascii?Q?OFB2L2tpLY3mrNoKR0xaesMPJXYkXpxRf0b8Zya7PAZFpxiBENVZrBYmBWYV?=
 =?us-ascii?Q?sTrUIOwgeC7k+PVAKsWzJpFGMuEfC7Z7k4AAHKH7t2I5sK4eOTUoZfQVU1y5?=
 =?us-ascii?Q?qVHkwF8lNbNc9nGQsEVhqv8+TCxxN/rauqKXr0iwFT2KrFLkBEwxLgWA8kNN?=
 =?us-ascii?Q?QhLJnl/jn8ZmvdCgaWBvKBhF8vQOd8OES8wen53JFvwdPprCuSykdM1RRSzC?=
 =?us-ascii?Q?pE96WgcxnvW++uWXw+kf4vX3XkBYSZ6NNjTjZSNZf72Jzjrs/bbvpnYXrFYT?=
 =?us-ascii?Q?1YpcRbKwUr6KLsZkboG8HPBn1ihwBclQLRTnayjAuy9Us4LOWiBCjmljJizy?=
 =?us-ascii?Q?LHtUbi0bEwNt9WIQ19MUAewvdkumxW+LJWjF1GzVJlShviJ0DgURH9s0ymAS?=
 =?us-ascii?Q?HnkrchrmxIMeu7TLkZEI9+8l754E/rRFTrzNoHnjs1dB36pFLmZzoDQejwsi?=
 =?us-ascii?Q?ar0tAnOytC7GlxGdhTOOTeCs6vOFsY1JnxbcpsjAZCT3UC2SEP4+RoHmjSvE?=
 =?us-ascii?Q?rEm+hOkI+oaeCw0QcXi8h4F3b6Bly4LF0S/WKLJGsDZf3Oqy2PWVyUA/f3/Y?=
 =?us-ascii?Q?Xdk45Aq6Y4LAvXps4okmgls=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af65438-03bf-485a-cbe1-08d9d3e7598e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 03:14:44.2116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9IRNY0ZaHndkm19c3+CkvX3bjFMskwOHxG1jDVW2dR6FCTFdWIOEEqs/Xke0BpdaZpWDMlY7DUaPTZvE5NOGgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1859
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, January 8, 2022 1:23 AM
>=20
> On Fri, Jan 07, 2022 at 02:01:55AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, January 7, 2022 8:30 AM
> > >
> > > On Fri, Jan 07, 2022 at 12:00:13AM +0000, Tian, Kevin wrote:
> > > > > Devices that are poorly designed here will have very long migrati=
on
> > > > > downtime latencies and people simply won't want to use them.
> > > >
> > > > Different usages have different latency requirement. Do we just wan=
t
> > > > people to decide whether to manage state for a device by
> > > > measurement?
> > >
> > > It doesn't seem unreasonable to allow userspace to set max timer for
> > > NDMA for SLA purposes on devices that have unbounded NDMA times. It
> > > would probably be some new optional ioctl for devices that can
> > > implement it.
> >
> > Yes, that's my point.
> >
> > >
> > > However, this basically gives up on the idea that a VM can be migrate=
d
> > > as any migration can timeout and fail under this philosophy. I think
> > > that is still very poor.
> > >
> > > Optional migration really can't be sane path forward.
> > >
> >
> > How is it different from the scenario where the guest generates a very
> > high dirty rate so the precopy phase can never converge to a pre-define=
d
> > threshold then abort the migration after certain timeout?
>=20
> The hypervisor can halt the VCPU and put a stop to this and complete
> the migration.
>=20
> There is a difference between optional migration under a SLA and
> mandatory migration with no SLA - I think both must be supported to be
> sane.
>=20
> > IMHO live migration is always a try-and-fail flavor. A previous migrati=
on
> > failure doesn't prevent the orchestration stack to retry at a later poi=
nt.
>=20
> An operator might need to emergency migrate a VM without the
> possibility for failure. For instance there is something wrong with
> the base HW. SLA ignored, migration must be done.

How is it done today when no assigned device supports migration?
If any constraint is tolerable today, I don't see why supporting only
optional migration cannot be accepted  which removes some=20
constraints while still bears a subset in those deployments. This can
be seen as an intermediate step in the transition path toward the=20
perfect world where both optional and mandatory migration are=20
supported.

>=20
> IMHO it is completely wrong to view migration as optional, that is a
> terrible standard to design HW to.
>=20

I don't want to argue 'wrong' or 'terrible' here since different person
certainly has different view based their own usages.

But based on the whole discussion I hope we are aligned on:

- It's necessary to support existing HW though it may only supports
  optional migration due to unbounded time of stopping DMA;

- We should influence IP designers to design HW to allow preempting
  in-fly requests and stop DMA quickly (also implying the capability of
  aborting/resuming in-fly PRI requests);

- Specific to the device state management uAPI, it should not assume
  a specific usage and instead allow the user to set a timeout value so
  transitioning to NDMA is failed if the operation cannot be completed
  within the specified timeout value. If the user doesn't set it, the=20
  migration driver could conservatively use a default timeout value to
  gate any potentially unbounded operation.

Thanks
Kevin
