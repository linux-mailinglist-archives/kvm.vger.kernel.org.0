Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BDC484C48
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 02:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiAEB7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 20:59:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:9837 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234434AbiAEB7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 20:59:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641347975; x=1672883975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hf4EXUKK5CJaOMb+ikpIn4sx4eilgQFj9PpxXVRMHEA=;
  b=GJbCBA7UcGYjisfaRIDoavMiKQbADXkaGdmXTP9NFaoYGwZg86YKOoYb
   699DbqUpClUABwPKcLm7JzARsDg3wAxxRbgKCQaw7IKl8gfgdAdhfyXS9
   7NACbA3lok3cLqjSeMMFdqgEraWI8MqtM8QbPGKQVkkrs8OJjqWtcFk8H
   BVhLQEd4Cho5xZgFO5O7fHPECZhTPpa8ZMXKvNuwREebz172EELWmNf40
   NlsTbz/cJQuO4EgYnxydPRd/874EghlNJjnzXElwcficmdjv/r2yFpaZQ
   2l9Dzq5blczVOmzruB1S9TdLW3Ap3ikF0GqckYRo+6Wt5PjlfSw5LhnRG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="328693119"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="328693119"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 17:59:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="611295943"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jan 2022 17:59:34 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 17:59:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 4 Jan 2022 17:59:34 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 4 Jan 2022 17:59:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W85dCle6MbQcYiT6yjowkQcT0waumsfxTEakXk6/FV98ssqqAZS8O8fbDbVbKaev11OqA9AFoMxNTtq9icuHpyGcSQgCwW7pHBlSGsFUTtihfEg///+fWoXmr1VHa+pfg61T8NGmXyury6LZa6Eun8ndhdVgtkAeHMepBxSdyRzhj8s4GOvJWVyq6mcDAaqBAAMDgdQojqhK/0wPmLEZSDrLnLGJU1p3qHf2Cj0r8H2lNbj/Rm6SeyNYlcNjcdlr0sVEAszm9FaeXot6rESVHnkJ9gzUFLmMcorj1p7HBDMH7PSzqP7BZjxeH6WSIL2DQZZHqd44PfVuVGOvx4xk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hf4EXUKK5CJaOMb+ikpIn4sx4eilgQFj9PpxXVRMHEA=;
 b=bSz0A0QZelUhWSKXCnGVh/hPbvHkcR2gWKI2Zgkiqu0HcUHXF1M3r0Dg1q83M1AGtYPqx9zYsWx2xxyYvCozmAu60Zw5pcnAr5lfp/GeDKCqTOI3OHz2TwJiIWat6oiP3mtewgeMqNtn4GFo1HJmNszfOOCRUvHZ5lqNwtZMhGRtzy8hCzIh//ac9QmDZ3wv6YOBHBhmqE7ohh4gb7bnRhMB6YbmzrIh/VNy6tnIGRCaYpwBf75n4YuZfL7SrZQL1n4CfqqNuDtxh5bnAHvbaBUAK2C3u2rpSA9jqA3AOTUY9/8nDHiLqppxF1zMCIvsYgxANXSMUpZCbrnIPAiiLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB4180.namprd11.prod.outlook.com (2603:10b6:405:7c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 01:59:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 01:59:31 +0000
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
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IA==
Date:   Wed, 5 Jan 2022 01:59:31 +0000
Message-ID: <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
In-Reply-To: <20220104160959.GJ2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 181c0de6-24b3-455c-7cff-08d9cfef03c1
x-ms-traffictypediagnostic: BN6PR11MB4180:EE_
x-microsoft-antispam-prvs: <BN6PR11MB4180B58BAD95901B370E0EDC8C4B9@BN6PR11MB4180.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlMQ7dEjMYvlNl6ogg5FB1vg+cS3nCHO/SG0hK/r5AUUm1kH1yzcZQ7Yg7FKlPe8uc+6JLfI4lArifxdVbBzGvRR63cBrpXed5CSDwggCU4OmoVdHt31x7FLAur/mHa0ad+0RZ/yRW/3GG0W4MVC8HIVZFan5isGt28/IFWBPh1Psf4GZoThTQAKz58V7TMe9+1g3eIRXoC6uIYMYXJ4KDbCLjrHC0OPD1ao2iwCsIG/FKofs6J2mZK8OrHnj2O5BQMpyzvBrzJN6EA5Taqb30gZR7422X7Q1GHZMM09iW1tfcXKhkt+PxhTB3XH6CeqfCmPhTccpiLMLTUI1M6vrAjZ/VI8n48pIarA/Y3J5TKxFJq2sSque0fUg7ShK58hkJWWlDXMxnC7pbFD33yXwj3EfrsIXZPmIspQlisv3AR6Pqev1Hf+oc8cqhApi32bqSv0havTjnPOD4v/eZkbSrcRwvhLM0mql0AY7X9B08djs79jvfsEAoLVLsk2njMka1GKC0QlfeNfg8nOZl7yatNCZf18JWnuhHdZ0Nui0YmDati3N2pcQFiEu3HmZxpLb56+BOpigREi7QP7Dx0T0NghLtQmzP7Qb3FNz+MXPYRyORwg/lOICeX5C8nWcRUSlX4zRRUUeg0y2zMeaGJkNEdguHy0RAX81Ena/qH5NtOdD+Uue3NByTyMCC8+hJtZT+oBAkogOBHQTeVyr7SH2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(55016003)(38070700005)(186003)(82960400001)(5660300002)(508600001)(7696005)(33656002)(316002)(71200400001)(122000001)(6506007)(66946007)(66446008)(66556008)(66476007)(64756008)(86362001)(107886003)(54906003)(8936002)(2906002)(26005)(83380400001)(52536014)(76116006)(8676002)(6916009)(38100700002)(4326008)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zZBU6sBWwWpKukYNGZaZvtl5Zh7M168n37N4v3waXcOWnHkR2J3geM0WoZP0?=
 =?us-ascii?Q?44o1n2CyAWbfl2IdthLBkelWyS93AWk+uTjFm+gbcUGvl0ZI25BkSaBeI0eE?=
 =?us-ascii?Q?14JI/2BoYAQ6gTmt1bmtGFyaqcOFUnbQ4AGwQPpzxq93tLSZrqtWAvNmVVqI?=
 =?us-ascii?Q?iTLJBTj44Vd71RxwBSQ5wKL4RUs19t8Q86ntdKS33NzbwuGz76a8vMKovNcM?=
 =?us-ascii?Q?mUXDmYRlhzhGSzz0FD/8YI4w0lCV5pk0LWANHmRkB3HyO+6a612jHX10MHh1?=
 =?us-ascii?Q?hDM1T3p8MMNbd1xnKS5BZOiXPdXL1irnTqIVbE0jxbvVbE5xUCoFnw5J0z0W?=
 =?us-ascii?Q?17vi+mx5Imb8Du2JXgKQhsizHsFqV6LaFRQ1nVxQqcJpTMPMTe0BEbadaIaT?=
 =?us-ascii?Q?sBQJ9/rpRvbDYUJr2wvLt2gdKvIzG3hdrg77uMOJGqZBFEQpLbIrJEomz/c4?=
 =?us-ascii?Q?ey9XV/DqYoHMdwp0dvgJmTQgoo1W7/hXcUM5KGOhSon0bYYaTy2wfNelP4DE?=
 =?us-ascii?Q?Z+cHqyT93IimDUd/6ZooWP08pmKEAO+cpWSZlVkOb04N6l67kF12m0vRzhSi?=
 =?us-ascii?Q?dyFPjZgcBBNHmKJZmfBp2f50cepTml8qCrgDUYlhoJR7ARRD41RkGMNCHt34?=
 =?us-ascii?Q?KzvDNTX/9FLKv7huvKuj0FXt/4Ux/DTs5iLSK2ge1cig8YC9GMs0TsSpetaD?=
 =?us-ascii?Q?/blayflgYHBAERpRN3cdbiRbRKXmZVd67a/fuM9R3FklgJKEvLRh7kcz+7z3?=
 =?us-ascii?Q?NvCPjAoyLmI/WE3D25euRvTNqyin3omHvUCeda+c3OzKxKFxaZAixuKVC9GA?=
 =?us-ascii?Q?31Tlx0e7/FJV3SnzIXjwzgDVzneK8haYhJ7Nibi85o6uG7FFFc6PRe0CiEMv?=
 =?us-ascii?Q?0Ad6nru3HexXkDuU6rrUj/1fVHamjN7IzJCIjTkYuHC1mTv+rQyFIbrpDB0Q?=
 =?us-ascii?Q?As1s+/QfHcio95JQZnfKJR4SvjrRtx8c2xWEu51RLURqvXb6WIlhp+P5Ydeg?=
 =?us-ascii?Q?rDAZz8X11PFJeGFtw/r6ATxk/lppN5QQyQZFd55rf+gAOqY0Nv/f9unj/UFV?=
 =?us-ascii?Q?22vztwNWVDskFUqewG3+DWpjYeZOs6YKBvfX/6XmNuoLrbscG0PB6uZtK2mI?=
 =?us-ascii?Q?ImIrSwBmCKqmq+4lkz3kPKo9dpMn6L5dAFPyBpUtPbQYQm5zCOsaXcAuT4Kf?=
 =?us-ascii?Q?fgngNtNr+UFIwmYkLq6W9rJzG1DpNCqwzOYvmjqN76hyVj1vwUvMb29K0FDt?=
 =?us-ascii?Q?qc+KqCvOtLnS83lMOWzvA6yz9WHy2QgJepYgmhdec6JyS/w5hOfxtbJwWqk+?=
 =?us-ascii?Q?s78ylsrG8BAjNQkq3ar2fyt7o8JIqWNXFR66yCEE90GMNKMfOGMBozIk0B/K?=
 =?us-ascii?Q?6kshZFFwBZGfqr8DeZKfGit2Dk/Np2YcCBuulOZUKyvOy+pfm/W5HgOzJp+p?=
 =?us-ascii?Q?gCIYw2MzRjWST8DaiWE3kFdZSQuJKSXzBg52X+srC1g3BILJnkTWTwOQxrwC?=
 =?us-ascii?Q?5qwNbrCUA/X+OE2Ooi5HX/q9ArvxzlHHWjucNZ/CEvcljyrXdxXk3rnW5u0z?=
 =?us-ascii?Q?xqYTMXhJyPNaQhx3Tz1qySEUScwWNwVt4ReZjmlTbBaApnP8ApmXLe6fkMNk?=
 =?us-ascii?Q?Wx8Jrx7s2w/dSw+P7W6GFfQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181c0de6-24b3-455c-7cff-08d9cfef03c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 01:59:31.6024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yCeLUnXiZLzdzJjFO15m1QCQEhHDxlFKZKr1xlV2fbw5EpqNPKi4qrUEsba7/21zC2ahym8e6vq+fhmgVnw5hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4180
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 5, 2022 12:10 AM
>=20
> On Tue, Jan 04, 2022 at 03:49:07AM +0000, Tian, Kevin wrote:
>=20
> > btw can you elaborate the DOS concern? The device is assigned
> > to an user application, which has one thread (migration thread)
> > blocked on another thread (vcpu thread) when transiting the
> > device to NDMA state. What service outside of this application
> > is denied here?
>=20
> The problem is the VM controls when the vPRI is responded and
> migration cannot proceed until this is done.
>=20
> So the basic DOS is for a hostile VM to trigger a vPRI and then never
> answer it. Even trivially done from userspace with a vSVA and
> userfaultfd, for instance.
>=20
> This will block the hypervisor from ever migrating the VM in a very
> poor way - it will just hang in the middle of a migration request.

it's poor but 'hang' won't happen. PCI spec defines completion timeout
for ATS translation request. If timeout the device will abort the in-fly
request and report error back to software.=20

>=20
> Regardless of the complaints of the IP designers, this is a very poor
> direction.
>=20
> Progress in the hypervisor should never be contingent on a guest VM.
>=20

Whether the said DOS is a real concern and how severe it is are usage=20
specific things. Why would we want to hardcode such restriction on
an uAPI? Just give the choice to the admin (as long as this restriction is
clearly communicated to userspace clearly)...

IMHO encouraging IP designers to work out better hardware shouldn't
block supporting current hardware which has limitations but also values
in scenarios where those limitations are tolerable.

Thanks
Kevin
