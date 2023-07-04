Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0E746AC0
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 09:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjGDHg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 03:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjGDHgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 03:36:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36E0E7A
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 00:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688456174; x=1719992174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v98bo9CaaVVNkq3CO3FwyyvS0XvWb486s+JqHDIZXwU=;
  b=IU5lRuUS2vWSmWTz8TZAxLbAYg/e87t3aBGmVm/tE5/yKha6iMGbOXlP
   PTZQOhBoeSn73alXR0LX1IA3iLeee2nz4adGrYhFqXo9sQE8oLGJFe3gy
   GCN2MpZ0PJUS7pA18pDsnyIxbGxKlZh5pmfFO9FGzt6uftngK1xue676G
   JDoo2Q5XRbvFLXIrENGZaWdUUzUURDhP446xb3DkasU35h2ERgc+g6Hhg
   KS6dODg3xvQSRrS02jWsgq37zjix2SPBvo2VHKBE+WgQkPUBDoRDo3g0K
   aoOjANPbushssqBcvuWeCPL7gJhEIGbpwSoxIaznmF/A3E5rLK3Tv2cvC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="363096163"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="363096163"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 00:36:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="892784940"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="892784940"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 04 Jul 2023 00:36:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 4 Jul 2023 00:36:06 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 4 Jul 2023 00:36:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 4 Jul 2023 00:36:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 4 Jul 2023 00:36:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IL1OEgNXJ80jVTjWG7tJze1Z/svc0TiwC/3CLCt8tBgRAbd7r6odbNQQgPBvI4ytGntdRME0GcaPXr5baHYf31AEvsSCJt9cHPzzPQqvnUohM/BNGShdUFb68lSFyy/DyUJCMtBsnYVhwDtqr3Tcmrr42azqwtGmK7NC17GbYn+2tS7AwbBu315m/wfB2S5xkY8cCcspV0L+KSPHWjWKZWHpap6qm1Bc52lPQPvkIQxPXjYNFf9PDOTbtvM5zUoed96uIZ85/Q6fTnbC0fFhU2z6d6eEa6GBBa4FURWYHmz/5CwXilsBrJdqTX/l7CswaXd5dAZ/atDojQzi2QV6fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v98bo9CaaVVNkq3CO3FwyyvS0XvWb486s+JqHDIZXwU=;
 b=TY/ddbtpGGypb8zQYbyRVtnkazKrOQ5n54+y+4NIG7A3wmmMuko82KceQGVeZv3WDdG1TmksJOVb2Wc/yXHntXaLUkEsJhSOUR0gaMZZLO437enufvkL2oFjqrA204E4/Z2WyUx21TqPOZljB0IGNRKwOEyIyg5Llw4ILsCnCcPnzu4YDsKE1JfNvx4P6NhuqmCxPBqq9J57k1pMtsm/f1zVAFZ3AAtLkYDzHjoPSRQjKN18skrboLaytz9N+phbnDBsxd+hFcihiaMWSeYgMQrvqHNOkIfx3RIQIPmu87gAsyDyL0nFWfyUiT1MnUbNgv/KCdOtXNR1R9UeWhQsZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6053.namprd11.prod.outlook.com (2603:10b6:510:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Tue, 4 Jul
 2023 07:35:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6565.016; Tue, 4 Jul 2023
 07:35:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Cao, Yahui" <yahui.cao@intel.com>
CC:     "Liu, Lingyu" <lingyu.liu@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next V2 10/15] ice: save and restore
 TX queue head
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next V2 10/15] ice: save and
 restore TX queue head
Thread-Index: AQHZpCB1ah9A4W1eO0m2o54BmDbDWa+VU4CAgAjlZSCACV0SgIABBYSAgACv4PA=
Date:   Tue, 4 Jul 2023 07:35:56 +0000
Message-ID: <BN9PR11MB5276EF85C570A9DE1A16A1AE8C2EA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230621091112.44945-1-lingyu.liu@intel.com>
 <20230621091112.44945-11-lingyu.liu@intel.com> <ZJMLHSq9rjGIVS4V@nvidia.com>
 <BN9PR11MB5276EAA78AD4E3B7B7A93B168C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ba8ccf89-6045-4fd7-02b9-308d50226251@intel.com>
 <ZKM3t7FDH09zeJg1@nvidia.com>
In-Reply-To: <ZKM3t7FDH09zeJg1@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6053:EE_
x-ms-office365-filtering-correlation-id: 43846964-3943-4afc-98fe-08db7c614e3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9niSbMTh/DUa813hRo+e3a35Y0LNPt7HMUotzFLIsBsS16TNfzxVZ5h1Slg+TArBKyZnhcyOxWbmw18vW5WGd2NR+rKGpCcELMFYdAuupdUcMFZm3WYal28Ozrhw3n/Kag0sKW/Z83zBWxzGqdZ82a9BOL5gTcYarVOFoGIzxz0iAFu7GLtkSv2/YToC+1PBIgLWJtNh0s0/eZ16uOOFQcj61GbvUEbYljhaG0HYZ68n0nHIQr7bm0Y//au3ZTDwR4WdoTj9/h60DxAHmcv2nnb0fFoD1XI2rH8xnIFwBofswezJdeMUxU4fg2VJAyAJ5dosGy9FUWLCwUwq1oyExEZ39Mm2G/LqPHEPbS6wdGvQ7qIWxPT0E1e1wTDfvd0k2OjcMRtBMFsA/6O+gjC+C7V8eOWPzCdXCRidfDDeYjsNWvOOf7FJRZI45kD+qIAHOGANN8l6rKK2n38lXIpLu21gcwMN45/PVkMF5T/30mzpPmFveG0QrisqbTP4wXR32G3GxFTFPy9x9fvB9So3VZqTagDCVfurTYhwIswfdsTFAsa+ulDj2vjOeWNmh7IsbVTE0Ov85wi2YYunNpqH3n2NFAOjiNmBw/jW2qSQ92L1NQkYX/AAf0BfcH6n2un
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199021)(38070700005)(2906002)(41300700001)(8936002)(8676002)(52536014)(33656002)(55016003)(5660300002)(86362001)(186003)(478600001)(26005)(6506007)(9686003)(71200400001)(82960400001)(76116006)(7696005)(122000001)(316002)(66556008)(4326008)(64756008)(6636002)(66446008)(66946007)(38100700002)(54906003)(66476007)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wmo9sNpqulkFKEO9hc4NGHuhUbSqdDttkqXvgR+F/MCzxFynwnvdBJX9mDdI?=
 =?us-ascii?Q?5m7Uwyq6EHhw2FLGyptXgZGtvsrAPYYu3TjiReWoxYac+/oA7ySAKJ5CF+py?=
 =?us-ascii?Q?Az10MPA5SGO7s9g0GWc+hqKLxs7ypWNijuoJ0RZFdWywpzcqYPaLoxpMlAF4?=
 =?us-ascii?Q?zoXX7sxJwDXMGRdB1lC4sYXMtKeeIYQH42gZwC0yS7iqQC/k1MrH3cx1aROL?=
 =?us-ascii?Q?c3r/j2pe4M6WAouBZwIkvZZeZMtaTVK0fHlQQoPcL3/l2Azx3K95rPoJ8T4p?=
 =?us-ascii?Q?qZXBnZYVK45Xzf+RtKsLncnK3kApKQ9h6iC4bD5SwR8/SJuWakFh8Q83TkZA?=
 =?us-ascii?Q?LWDn3rHWs2gRTRni74JHJy7XoOTPUPw8FzDq44ifJ9fHTlrLXpZw0x45ZoM7?=
 =?us-ascii?Q?VJbGBMOJd5ph+FZ5C5aMjaV2ApyQkVdS5zUR7kFSz5/EutzxEz9dUMQPsacb?=
 =?us-ascii?Q?v7HDsINqKZkc7ZYoyQli7jFFW3RXd8h2gourSGyAKSpL8hhXICn1V+uFMrhK?=
 =?us-ascii?Q?bZrbPfxs7lJZrYtlNz17gqEzkv1va5MvjaDDuo3t7/7uQVicGXZx+wF4br0Q?=
 =?us-ascii?Q?n18uI3xFR2XA6ljKbbzucDz0KZ/851Wi5BxcmMJXOnci16p2w6CI4ZQwuM0q?=
 =?us-ascii?Q?AohErVoL1WJSMpZdu5lsG0vQWKuznZI3kZUKZWsxLkLBgQstcUMrLtZztRTs?=
 =?us-ascii?Q?DrpqTMl4tmE6jbaSE5DSPvC/NAF35eUFbrkKwBor04BMzW3sPlV0RnO0Qr54?=
 =?us-ascii?Q?kIyCbkkV+6Bv48NxClMfFNqwA+B2mhfLWzE/yXld2NIbKTZGRMk3CQ0Y5N05?=
 =?us-ascii?Q?Xb3er5UvRS0zVni/pyInSvTETkEQRZ78CoECGGXBKs3raa7dUgtjDgiJQtlH?=
 =?us-ascii?Q?WEeWFcrRNnvwSL6V8p7lqdGBVQyr1nJrpdapaT0SM/qAroXa5mni1bLAn8PP?=
 =?us-ascii?Q?Z3Xn9+LS0veBYiut3O/uwpI31gpWmuTFRV+vs/c0Fkx/9I5zkOmWjWCGeA/w?=
 =?us-ascii?Q?478TUsYpAAhGe6/PyINVMyi994F8rnCbV4MZ4JnU6hOg4xKnVVqsvmZJdnfm?=
 =?us-ascii?Q?/QVGRxnQ9F5lx4vcQsxRtjYMWqG441fuJ6L+WYOMTUQ8xaKFSzp7aFSzT9yw?=
 =?us-ascii?Q?g38pEhzT2UJOPgu8FgPb0wFpFP5x0H+IE2Vx8FRt0g/t+P9GMDYTRCksozZw?=
 =?us-ascii?Q?3XlpkN9B2oXWn8u0XBrdJy5J2xO+cAB51T0vz6bw2KIC4Ht31epvifBP3snE?=
 =?us-ascii?Q?jLwS7p8FE3gEOtd2qDwDkXuyQy4eSMw/vnxNk7+ySqSaglMpqB3xHU2qJdad?=
 =?us-ascii?Q?RGRKheDTpLKrInBDa+jwsE/yxvhC/IcwMQTf03rUwJ9mM8RUX1FLZ7ETNsdI?=
 =?us-ascii?Q?kbZRIqYheH8MxwEbBCrMYdW/eXnnKzJ90v4mX7enZzDbF0oFZ7sDfyBp1SNd?=
 =?us-ascii?Q?aMATsDWgO44bgYrRpLlwVokZ9zjED09HLdjya25EbcvcFmgdO4nW3ITdXwRU?=
 =?us-ascii?Q?h30z0ifUM110Y0ajIt8rZoKsmczoFuc58LnAdE89iR4h7/kzouO91zyVky3R?=
 =?us-ascii?Q?qTJjPh6HjjEvCx3ENMff7XP629mIrWd4XAe7i/1p?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43846964-3943-4afc-98fe-08db7c614e3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2023 07:35:56.8921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7clGc08biNRrM9i1wdVA4gQPWiR8+umLrKKQC+8N+1ugzVSmIttuGQ8qRuelGungWq24m009R8pdacLujSytKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, July 4, 2023 5:04 AM
>=20
> On Mon, Jul 03, 2023 at 01:27:51PM +0800, Cao, Yahui wrote:
>=20
> > > > We also don't have any guarentees defined for the VFIO protocol abo=
ut
> > > > what state the vIOMMU will be in prior to reaching RUNNING.
> > > This is a good point. Actually it's not just a gap on vIOMMU. it's ki=
nd
> > > of a dependency on IOMMUFD no matter the IOAS which the migrated
> > > device is currently attached to is GPA or GIOVA. The device state can
> > > be restored only after IOMMUFD is fully recovered and the device is
> > > re-attached to the IOAS.
> > >
> > > Need a way for migration driver to advocate such dependency to the us=
er.
> >
> > Since this part is new to me, may need further guidance on how to resol=
ve
> > the dependency from you and other community experts.
>=20
> Personally I'm quite uncomfortable with a driver that tries to work
> this way, I'm not sure we should encourage this. Can Intel really be
> convincing that this is safe and correct?
>=20

I dislike it too. Will discuss with Yahui on the correctness of this approa=
ch
and any cleaner alternative.
