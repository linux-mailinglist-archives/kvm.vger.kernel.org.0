Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A32F6BC5D7
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 06:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCPFt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 01:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjCPFt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 01:49:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65013B86B;
        Wed, 15 Mar 2023 22:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678945763; x=1710481763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M20WeviNdIqzI0Q2JWkKS3gcD/OXxCLxf0mX4oCC1Wk=;
  b=T1HuI0a1WE5v1woUN5rekLFJSnwElQXx3xBDjStDPO13bKrLh1dNOfrN
   EcriKlXNmJHCZBIOuciqk0pE6Dd5VAZv/8UDCDdA+uvBNoqhXbJh79Cm0
   Qxvvrh6tWnlxMJ2pRVPsiFQmZ+ONgYkTtICkKrwtjJERk8lYPrM+pCwu5
   /1tRZGwIamiZ3rZJnybDt9rFegwAwFE/yEn7VEoRzJg+8N7sBA5tnbbZx
   JxkssLfneUtjf/MIKrwfvThuwew8M/BHqAT8PG+KeLTpoKfSzyrRkj4IZ
   4id5363CM7usHYbPpSTB1AyeysTFacrcvxobpqR/oDlQrNj3xBPXcfmth
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="365586075"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="365586075"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 22:49:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="790138102"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790138102"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2023 22:49:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 22:49:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 22:49:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 22:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjDIQxtWGStUPrqP64vQ+by8V1UMVZaUZ1F/UqHmgn/P+9vhGCw2d02pbS8erC1IUVbMR+ROyWlRzi/kGACQmu9F2vNHkhMP59xGFe03bKPzIP941D2NNap+yQw3gKXqrBEZpXBdi1KP3jJ6bzn3mY6ZDL2i/69qnlhRKaVadQa0Q2d+khmYU7OS3xvO+Tl4A+KJkMpP6X/AW9IZx/dt76M9mY3TLA2AsBnFKQE7iQxCBy04JegIYSxoSH25PCGHH9jau8j+ZdAbm8CGHhNTvVD+BCip2m7TQ6TaqfrNSxFXHr2nXJm16l1Mj/UlHiTigD2HTjm0LERn+bqFK75E0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9R4qQBMvRuycCevjyoEdyn4/ZV4Jm3KZ/c52aJvkPc=;
 b=n3jI7x4Bn7iVMbJX9DFszJS5hT1BaHU8kMiPIJFR6rUllScg4sA5r4ME/nRu7X5Deezape2b/anOdu8AZukBftbAB3wqID30i3L6VHe86d8ocmjWa1jAPOi3RA4DLrU+eOjDtRE8sLJtltS2C/tV3chv3IDzh62I18VbjyM7EwdDUCMHKGYCCMlDikvMSI2+tQ89NlSVwJ8U5Jp7grAPRXAiuwKF71HfTqiE29UCoAhwHh2M3wtXnVxO0As6FQKl63P2QUCGV1Bg8Bt/Zm6faq96ZRWxxqVaLUyP9XVVhEzNj5T8jLu42iWR0CbwBePzG1eJ2iW9KLhEtxlkJrZMpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5061.namprd11.prod.outlook.com (2603:10b6:510:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 05:49:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 05:49:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq70SikAgAWuFwCAAReSgIAAVgYwgAAGiICAAAEI4IAAKQWAgAEmOLCAADF8gIAAAJiQgAACV4CAAAB8sA==
Date:   Thu, 16 Mar 2023 05:49:20 +0000
Message-ID: <BN9PR11MB5276229F63C9BE37CC8542868CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <ZAtqlnCk7uccR5E7@nvidia.com> <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
 <BN9PR11MB5276EDB7E88E9AE5F059C8948CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBKsldu+EKT5jd98@Asurada-Nvidia>
In-Reply-To: <ZBKsldu+EKT5jd98@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5061:EE_
x-ms-office365-filtering-correlation-id: ad75e6df-a600-4e83-5bee-08db25e2303f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YiI1YiBcx/PgNEuZJYmcgMp1KXDnFQg3/AlfgE8cMc+8Lq/HsmM1WyWPHPNgm1DKJs4ltkcf0dHFnQd/z7FyRLHwCsR7tVm3QB2NE7gnqC9KwjIAA98iVBr8x7UCh3Dqa2Eol/2rDXmVv4De6K2B9phLHeqUv8X8qdZFR5FnyfbVfbM33P6AAtNCtLoAF0ASpZDekBOBW/gAx42idGkyNmdsYcgCpduFNCGYKacgE6/GOjGm5wN82hqQJhIfzQHaDKLPngw5ZYbQRqMxTqbMKYCryJ4lWSCHvwX0wVTOZTdhvZgCfF9HF7eNtmLTsyyHkNPY9eYbEeM0KZZJfAP+mrHPMjOBmCKOewdMOgPQQe6RHLYorkpQVJQCTbXTzhqtKx8O1mLhV3cBk4UW7uUCCvniDfBK0cp8KSo21i4ZgZN0cL+CUzX4HYGsz1FF4DPpNhtL79Q7r4laeh6Nvzop991R1Rw/7xWP7clxU/ALKd9mOh8M76SmC3/rsc/rQQJg+UFzLqKUsCXxOrQnHcsHpCJFqxGNotutcQbpBBIQ7LUIIX03U8ojKdUJ1wupFy9cyfcwQFRDukZ9cJaeeVpiUn86POHy6hDS8Pg/kFZi8sIo2Yi6rUgyo9eXbRBE3jvmBGt8eDZBizOcXTSSUUXorTg4V/ESg8pbS7zfO9N3O2HLS6KfiQFT00oAE85r7ESB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199018)(122000001)(316002)(55016003)(966005)(82960400001)(7696005)(9686003)(186003)(71200400001)(478600001)(83380400001)(86362001)(5660300002)(8936002)(26005)(52536014)(41300700001)(7416002)(33656002)(6506007)(6916009)(54906003)(2906002)(66446008)(8676002)(64756008)(4326008)(38100700002)(66556008)(66476007)(76116006)(38070700005)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wZlgAInw+/9fBwR+DM1Ve1DVVekSUD6P39qGXPnAY92DoLeLu5YpEXrbEe2M?=
 =?us-ascii?Q?uZEcDMahblkUS6fTl6af9HAYsrnINmqli/sqTN7BjvVv2d+CySiw2yrqGZc6?=
 =?us-ascii?Q?GWxvZ2aG4iz4yB4rCjKYU9diG2uYEYF8RzL2fWIq3l5aK/OrKCFuJrRf08Y9?=
 =?us-ascii?Q?mFNZulHm6LlwhrAvsiR//iEeGz2UiRG+SXd9UrwyyFy3rYuS1DlQKKUeEIWV?=
 =?us-ascii?Q?6sziU0P7YSXCYbo8AwzYK+xCgRS8ci5xJyslqeCxKcu9IoHyb0c92tqE3xN7?=
 =?us-ascii?Q?9R1f9yDW/8v0oKx02PUyA+XAGwkcVJ8Hln0yH0ZapcsTnKHf8J4ZC7EkJZRi?=
 =?us-ascii?Q?lizl0n8nWsudyq0ryfaMOUN04c3826umk+7v8dfiZ1/eA27c+c243HEFvquw?=
 =?us-ascii?Q?ARTqbJAo9qF9c71dmctrn4ViUckSu49k4JSR790PHmxuaiGzNKe1slN02mSG?=
 =?us-ascii?Q?cLUTHsOQfEow5Ec57VGPcwtoRpj8lZxck0ZHzqsSYlO/COYuZO5sydEApcJQ?=
 =?us-ascii?Q?/Bl8Lu9EMFmXOFuG2m53sj6TnPL2eNLA/XUxsqLT5TEooO7f8vxvw7p/vFYc?=
 =?us-ascii?Q?ZpqDVlVpASZkjeBxVwtfFOTP3zxiBz932rH8zhvHaEfUFpRLDPIu4Nh7tRVb?=
 =?us-ascii?Q?ambUdniVpKOjjET1ILWA2OGrUOWg5MNDlY6Sl6E7N9sIe/o5aHRtvudnPbjM?=
 =?us-ascii?Q?MSVqUfqTh/07C6GzAoEPtPTR4qpPT9tNGKW8X9gS8XOpO6ekPB5N1yIw6TFF?=
 =?us-ascii?Q?RWd9QYXE2bbRojXkK9PQh383W/kLc7w9SU/wnbAtBfDItrGwZwsFlMweFRcH?=
 =?us-ascii?Q?tHIPz6d3Qi5aTph3J2xaNR19HeyQVwlI3IgLlUb6tzljOnqSgTU4P2FTeVCE?=
 =?us-ascii?Q?yc2pJSRbOxO3gBs0MxOn4N0ZNAguyL2eCSQZEsLSjuWTeHNaW5cDPWYajpli?=
 =?us-ascii?Q?4x48MviedJVy0mN1up0ORd2to9YA6KPgEI9zsaUulXDJTdHBQ/JdFwQGX0lK?=
 =?us-ascii?Q?tghh1HvDf180YTUWJq02yrUiTihCqq6vVdNDZ3qxZ0//6HuXmKdAkqeI1Ri+?=
 =?us-ascii?Q?26yro96qbV8idMhlVLm+qVD3RiXOc0jIhcnuFV1la9uIu2qH0mfnNQvzU+vM?=
 =?us-ascii?Q?lPANoUpnxEqDX1GwU4T+Nm6eiuFfPrhIUaG3Sxk0JYOn2VpiGUd20ws/Okwu?=
 =?us-ascii?Q?OcRia9UNQFAHVy9k4auAu2Os9k+De2E4j0FxzgrxoHNpb6hn8SuwtGaEP2Kq?=
 =?us-ascii?Q?xz672JBFb5gESjDcwcLGN9gpHqOs+Nv+ELi/b+yA2xzFfbcz17GdFfk46ocy?=
 =?us-ascii?Q?reG5zcEEyj8uwN5JHauggVhOKaG26G/zLzAfVC6SEebWUiLRBpQnCKAE5Vp9?=
 =?us-ascii?Q?1IgiyAWx4o7N7PzRFyBlqiCWBTcZr6CxJVdxkAHvkWJrU+pHaYXHi0AzyZha?=
 =?us-ascii?Q?7cBsl6RMaaBkoQzkN82Bi9lTyOFzNEXuhAag6+sLOGDzBtPlxXcXUBdmHErq?=
 =?us-ascii?Q?y1BfJ7XHqydA+ur9E6xxFcshFCclrKZ9JlVbKm90ga1NqPRiKqi7p8gsKY2q?=
 =?us-ascii?Q?mQTVjV6d9VWOImhazWZtG1bU3/9wvojHQs3B02rM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad75e6df-a600-4e83-5bee-08db25e2303f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 05:49:20.4727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cZjE0uTFeLL0Vbdih0Uh39zfJHEvXX/6hJVOcAM3kgRE4o8keYJvoeHi9bYwTu0fyuiwvqrTG68a6VDvnTr7MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5061
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen
> Sent: Thursday, March 16, 2023 1:44 PM
>=20
> On Thu, Mar 16, 2023 at 05:38:41AM +0000, Tian, Kevin wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Thursday, March 16, 2023 1:33 PM
> > >
> > > Hi Kevin,
> > >
> > > I've fixed the other two commits. Here is the one that I am
> > > not sure about:
> > >
> > > On Thu, Mar 16, 2023 at 02:53:50AM +0000, Tian, Kevin wrote:
> > >
> > > > > [2] This adds iommufd_access_detach() in the cdev series:
> > > > >     "iommufd/device: Add iommufd_access_detach() API"
> > > > >
> > > > >
> > >
> https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > > > > 097e2c9d9e26af4
> > > >
> > > > also add a check if old_ioas exists it must equal to the new_ioas i=
n
> attach.
> > >
> > > This is the commit adding detach(). And there's a check in it:
> > >       if (WARN_ON(!access->ioas))
> > >
> > > Do you mean having an "if (access->ioas) return -EBUSY;" line
> > > in the commit adding attach()?
> >
> > if (access->ioas && access->ioas !=3D new_ioas)
> >         return -EBUSY;
> >
> > yes this is for attach.
>=20
> OK. For attach(), the access->ioas shouldn't be !NULL, I think.
> At the point of adding attach(), the uAPI doesn't support the
> replacement use case yet. And later we have a separate API for
> that.

what about user calling attach twice in cdev?

>=20
> So I think it'd be just:
> 	if (access->ioas)
> 		return -EBUSY;
>=20
> The reason why I didn't add it is actually because the caller
> vfio_iommufd_emulated_attach_ioas() has a check of "attached"
> already. Yet, it doesn't hurt to have one more in the API.
>=20

but here the slight difference is that in physical path we allow
attach twice to the same hwpt. they should be consistent:

	if (idev->igroup->hwpt !=3D NULL && idev->igroup->hwpt !=3D hwpt)
		return -EINVAL;
