Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD397507F60
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 05:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359191AbiDTDIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 23:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359137AbiDTDIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 23:08:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D70464C3
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 20:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650423907; x=1681959907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XsQBEuDW089rQkuVg1K/qcdtIYLChYpAPIeFQzvaQ24=;
  b=dJZ5u5IQTeZq+gES9jYUPzbno7PbQZ8Bs09zeEu0TSmiS8zAbcKkz3HE
   ETP0UhdoMg896Y9pMN+D9go67aa55JzBRPZis7d/LqRq5rlEJ37BAiURP
   S8N8DqkQPOrpkRYXzcWIpQZHWv7zOhIN1KAQpxNPt8Ez9zStl5UDkr/N4
   HKce0CNpmtWpVnuI4PcppdI+gIoWjGoys948mvIbtfQAlYzzNGWFYDQFb
   YCG9o38+5PcTY7oy9trwLRHuZqt+ipJ6TeTWONSKhUWOY8F1TW0NYp3JQ
   IS0nQf9bD9waraAJsjuAs/Pq9DBUPwi+FhSteavjZFYSnuabuQV7qJ5KN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="243856791"
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="243856791"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 20:05:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="593015805"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 19 Apr 2022 20:05:06 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 19 Apr 2022 20:05:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 19 Apr 2022 20:05:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Apr 2022 20:05:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPAxWeJjdvqkMJU0QOmucq4NRBSWXiQV3WOu4oAIWew0UaPubF9MtH90prPyUfQs4Zchoxd/mvxHb1DqYpqx4Y1BbyoWcPloU0m81gJGQvtev0qOpiBMSRiJ9v+QFIv0dyUiv/wvKmwwgtJ0xSq+cVi4pdDSI4sWSU2aV2W5K53R87ho5Op6IcVSfYtE7EuP3ogMIhrARqsHjDaU0g9XujP+F2OsT5rwxiDYT/Y6m3bSqmD5vl41beX/7xwyEdxmKjRmCn1dI19evLG5NTvwStiFo3lphyUFUJ1zP8Yu+yen62fC3Wj/tSrcyNOkBPWYpsI4PifQlgQusUwWPDtfhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6Iq05eVwqbTACzq6eCISP6VbeV5yVIZtoieQqLeXcE=;
 b=CKIrNpzeLuiOEySH/lUUNOCW7n+nyJCzJOGfSi6lf3ZLP4JIaViiZSOL9Kxp6WyfU5OVgecBrXJ8jEPOmEvfTLftpHNURFl+i5LKbSO7UQGTL75Vjzb/IEvjtHjyqxMQZCG1fY/mR8Jw6S7X2AClQIK6OdqtPcNltzppJk/U3WsRiZ7A445o8AOGSjdz0SnmxVnMPMHHvBcJMRApY722mo5eWn2zTAJ/8hYiTr9M3s6kxjNM6JeTMbxJkOD/iMvoRQvhl+iUsuF51QyDcSqG2qSPW5e/xtySQM1BePkRA/ru3lCDS0hVLNUQU8kxotV2h/y8Pre3tX1ut3jrH4n4cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB2553.namprd11.prod.outlook.com (2603:10b6:5:bf::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 03:05:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 03:05:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 07/10] vfio: Move vfio_external_check_extension() to
 vfio_file_ops
Thread-Topic: [PATCH 07/10] vfio: Move vfio_external_check_extension() to
 vfio_file_ops
Thread-Index: AQHYUDAIkIUMxipe40ybaDZVxgqmQqzwWxNggAdKgACAAHuiAA==
Date:   Wed, 20 Apr 2022 03:05:04 +0000
Message-ID: <BN9PR11MB5276B926E3920F2CE240C22B8CF59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <7-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52761E7F5FB90976888A24088CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220419192340.GB1251821@nvidia.com>
In-Reply-To: <20220419192340.GB1251821@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a5dba2e-634a-49e3-dad2-08da227a9138
x-ms-traffictypediagnostic: DM6PR11MB2553:EE_
x-microsoft-antispam-prvs: <DM6PR11MB255397656BFE3283197724E78CF59@DM6PR11MB2553.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xNlaLWnpYFL+tE/kZKqiIv2buQCdiKL91xzNVloLHoS5wNTqeWQK94QM2V2AHcg1ya3BbgabRCFCZswVQHyVNUBYp1JMu7QNsS38k6ARU0fWGXuA70eZDuguY8BbEqZ/g16h2QMmwhPoMzAjaMJ7ZnwCmvhmmfaXbvCb1M66fa4q4lFEsidYG1rJuG6Qtruju+s05kZdhht4ZKyOn4ObxTtq8md3kPFzQ/2jdSErpf5jWWglQ5M7/P5RYHeMdxzpmJCq0slcC6eUm5QTStKLx7WZOMBjDDfMYqMKSzwO1ZriJzkpKQ82juh9TVQliz3nStClnoCJHgV071FnjFRyQKFgNC2X1mvNiaOTCczADW82IkkJb0Glsa8mwv8jeyBdDfN043maskiqAc10jxIM5veItmiDFaP+n8CY26BcX1oek5jPVTLQaezdNuCb9uy+eVb7W/Sf3+Jeb6gVKMO5dsmfh72ETX1Aq628EVQaF1JV5VBQYINTcXyR7PdWw7upLaCRmfkfGbwmmDHnU2hiQKwV9Z/I/1hEHY7HYQUEg3hlkAKiHcXTYu5E2DEnU5AeocHFT36bMpjVbo8c7yWagUq+K9X3utCpUYJyuMb0GUYA+0SYqEw7TyoRImrG90AVzKS/HpttT0E1IsLU1x0067Z/rJ+GHbIcImwLF64ZldMxFvxX2JeTkafqDO1drd/Ww8GiQ2lQe7Q0DRTusMtpTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(122000001)(33656002)(5660300002)(8936002)(52536014)(2906002)(55016003)(82960400001)(71200400001)(54906003)(316002)(9686003)(6916009)(107886003)(26005)(38070700005)(38100700002)(186003)(86362001)(4326008)(8676002)(6506007)(7696005)(66946007)(66476007)(76116006)(66556008)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GH7gXGJh6eqyupInCssW7cT1yxDjkC7sXiTtutEiCMxZqxwG5NfjB93c4T7L?=
 =?us-ascii?Q?EL5pUeBCqXV8GEJ20imHk1ddiFVvZLmVINjXzAo6RfUroUZ3fIwWoqr4ndMv?=
 =?us-ascii?Q?D2ov8zR3lAkw1XT7SOee2s0rLZ5WSpx1XQW0L++dVofhW81UnycAPqSidTeC?=
 =?us-ascii?Q?kHUCgHc/davaQisUbvyKLJUcpu4AqZjNJqEucZbHi9P6IHIIaAWqUbvAvWBQ?=
 =?us-ascii?Q?j9ziwIVnMVYGyuQVuUL0iQIu8o0gQe1qyO28yAwBcMGxyKRhpcuNXxMRwdR5?=
 =?us-ascii?Q?+fHKLhJ/I+5G974aLzeFjOjaRfMJuZh1dXF+Nmrcpjj3bJQfWx+jru3I1PYM?=
 =?us-ascii?Q?dXX/4/mOIhgRyxCJT7kwlS8r2KOjIBQA89UE/hXROBpkENRuJMTDQmS5jiOz?=
 =?us-ascii?Q?LSS2ARlr8/FoFQPuv5gk/cHjAOVo/Esk1mefhXJo+9NRATK31G/mxl7g35jF?=
 =?us-ascii?Q?0II8PjrJJbwhEMgfs9Z48BJfvNjIEh6Qj72XNDtS9iPrm70ZQcTF/OfijkE+?=
 =?us-ascii?Q?8S+JSntdUK0355FNADzME8aV50BY9rpHu9tL9Thie+FLb/fq5A5hbdT/scx/?=
 =?us-ascii?Q?UruokWI/HcFhB/KYWGU61wjdnrqi/N1HoUM02dZyWl+yd2VFKskUSDuLCRWg?=
 =?us-ascii?Q?AOK9t+hBmjekKzIGOGQ8oGCGDkcHBoTd3LwkXkBjXIi8F+Jrs8ugO2GIQMjt?=
 =?us-ascii?Q?Awqr7lH8WJhkjBL94zaMl7YAyLUv1OWv4WocCtBCvqHy4c/IrYLzrcbLUkGO?=
 =?us-ascii?Q?R3fTNpaYQw+Sw5tfp4ATSXjzx7ILnYWf0ZvFgqymc66cNlORueZXxkrIpXiF?=
 =?us-ascii?Q?JXdBaJH56jzY9OJuM45cYY0oEwMc+LrKls5PzzXiwGm6c0IXbhNBT51w79h4?=
 =?us-ascii?Q?SSJDhOPSU+ncKTPo8DEX+VRQmxTD48XoNNSPg3OBMpkkwPX0ivWZVmf/jKYO?=
 =?us-ascii?Q?SxViDf5WkAxnO7IcJdPeEWc+DzRvT9J5xXvuPsQjbJfAeloIxOCtZbYQx98f?=
 =?us-ascii?Q?AwkP6IrMfOteZaJIk+8iwOEVYKRk4NF6i4AWEnwG/6a8vTctIRRULUVeSR2l?=
 =?us-ascii?Q?otQkVoBR9jbn60uo6Bmf5OKveGxI7koMkk0ZZdhrN/VfeqwZ1mCQSer6+NWt?=
 =?us-ascii?Q?3IO+/FtyeI1XqGdIB1POmkXxB1d8ddEykT3cGX7PISou9ZO8EreNPe8G3zTg?=
 =?us-ascii?Q?TPlD39NtXSG7DLwcXMrSweVYR72cxYKnI3ZAk1czKFN3plxqd/kCdRZqc2EM?=
 =?us-ascii?Q?jEUYbJstw0Qrx1/nmrOHwY4EKLiS3vEp9pOV8Iqk7cgOsyQGRKQ1N/6ycbPI?=
 =?us-ascii?Q?K/mmIvIQHkRu/b90lr+YrMbriEWolucBdHs6aVZZN59KVIjTp8ImI3U3ZwAd?=
 =?us-ascii?Q?3NKH6MPlOJsMWIkhqIlUd8Vv1Ln6OBidE3awDQfp9iaqtaJqhG3IRA0mCCHF?=
 =?us-ascii?Q?DF8zZ2b7pB7AyCj1IWIP4CQvXx266a0UaPphI8jm/k+BiuCZdUSTsfuBRFRV?=
 =?us-ascii?Q?IaAvhS/t3V2h3b7vUJIrwB/546IBMZuUj+4Cf4YT39tnTkFYs9qYfgp6ckmU?=
 =?us-ascii?Q?tX1xtv5an7Rfe9vEkQUvGG24dzqnhztf2W7mC03volSiTN83gVOvGBNQ/WFo?=
 =?us-ascii?Q?gSA2MFx0b/LyPJAHiZ8C99OwKWuxpz/ppCwLjPvEn6Mk6Th+PehGMHiKS22H?=
 =?us-ascii?Q?bmmKhekHL+LSEJQkHHFKlSqUO/0+fkdbFOVwoy2yZdxX1XRvld5WBTmjDFWW?=
 =?us-ascii?Q?HsBxFEZhCw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5dba2e-634a-49e3-dad2-08da227a9138
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 03:05:04.3343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kMJ1eAfTWhGjT4w90pU91lfYbao88QM58ujsL2Pr0RefQN1ySIdXBRuFiUNGJwQ097vBT13AhU1j5A0N/zeXVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2553
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 20, 2022 3:24 AM
>=20
> On Fri, Apr 15, 2022 at 04:07:51AM +0000, Tian, Kevin wrote:
>=20
> > > +	struct vfio_group *group =3D filep->private_data;
> > > +	bool ret;
> > > +
> > > +	/*
> > > +	 * Since the coherency state is determined only once a container is
> > > +	 * attached the user must do so before they can prove they have
> > > +	 * permission.
> > > +	 */
> > > +	if (vfio_group_add_container_user(group))
> > > +		return true;
> >
> > I wonder whether it's better to return error here and let KVM to
> > decide whether it wants to allow wbinvd in such case (though
> > likely the conclusion is same) or simply rejects adding the group.
>=20
> Since the new model is to present proof at add it is OK - it just
> means the user doesn't have a proof to enable wbinvd.

it is OK if this interface is called vfio_file_is_wbinvd_required().

But now it is called vfio_file_enforced_coherent() then whether=20
it is a proof for wbinvd is a caller-side knowledge. It is clearer
to stick to the fact about cache coherency and if it cannot be
determined at this point then simply return error to the caller
to handle the situation.

Also it sounds more reasonable for KVM to fail adding group
if a container hasn't been attached instead of moving forward
assuming an incorrect coherency and then getting an error
later.

Thanks
Kevin
