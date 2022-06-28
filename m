Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8193855C3AF
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344798AbiF1KJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344750AbiF1KJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:09:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7632F669
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 03:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656410990; x=1687946990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zQn283bfjI+3s54dDAnpRurRGurt1/w8EtSc1Yu+oXY=;
  b=EfnWVFS2KoFQO3QrIGY6Ue9PfXdv8oSsKlWr2O0ZcbhwaSD7VoDx/ig5
   VZCimQ2IqpaY8jySgpT+R2XvycrvP84qBiF+LNXAevKUXqbFa3gTY8m4g
   cnhwXj5oFlcJD47EHb2cWSG90m5HM8mHuF3IfdCxqT/Oc8ShWJ3KLCGKj
   GeLfqr6igzPncEHVW28K1wGT2g1+pDCTav4jt0uL3G/zrc2Jgq0qAjFpi
   Q6StoH3zdz0zh/wPziTYNTdWFVDC4wS9ikTje7XRVF+tp5gbUnNDFEW/z
   Ql3qBNQnjHh4tgxoBv1rbq0gZPWwZ/fckgChSxF8HvDjuI3sboxuZsNV/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264739819"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264739819"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 03:09:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="717394309"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2022 03:09:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 03:09:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 03:09:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 03:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGFKhgISY4S++9OhkiX8CGukWamkkS7vlvg6ZS/EBNq7fJYHLbB5tlp+wuuoRxkuPQHhwKw2pmiJRgLtKB5NqD2vQiD35lPiIf3oWTz8VWV++5dWES9Woe45NdFBXVFfa6XRKBca38zlaJxQHZVv1ROXlk+VfgAVhI9oRzIZxyJYI3vhXJNtSVmCS3Ef4TF7Lw0pm5s+8TjiAmCF6CUeuJCPS5r519MCAs8OCM4xGbj6a0fTrTd5OM4io8bIp6AlGln0nLfpa7aIM4xEPgsCjAKas8BQC79Ba+XGGWwaQ7gmBH91TnjECR/V0A7tuGUoMSqoqfCzox8p2NLEqV4szA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQn283bfjI+3s54dDAnpRurRGurt1/w8EtSc1Yu+oXY=;
 b=fEId2fY8wJmhipx9Oe4SlMc1MrE3QsumqnWZXxwTX7fQV5RnkFLoFLqNHXPEBmijeXwb+hn22xRF4gux2fl6m8S7/F2xM2yWdn3V2vVYRL619ngKbo28Hoqeq2Nz2qMKnLRphsScBHAEjiFLSMuTg9ZRkEbZah9qyXW8DU03jOEopuIN1tcE3hk0tYHXV23wj/bqAaq3eRPJ86jBvZFy6jV9ouyAN7nbmgnOySK7bb4VNxMZgYdr3Hdx6BlnsZQRoyR1pMzsWQwy6hRAM1dymF/j9d/xHIQW+B0GqwN9oNftMgkl9xTwa6jE0C6cc+MR+Hl+/nIkXOOnNe3jjl8fjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4655.namprd11.prod.outlook.com (2603:10b6:806:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 10:09:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 10:09:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: RE: [PATCH v2] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Thread-Topic: [PATCH v2] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Thread-Index: AQHYiflUnV79oQbkUkOobotxHOSWWK1kmlSw
Date:   Tue, 28 Jun 2022 10:09:47 +0000
Message-ID: <BN9PR11MB5276317755433ECC124A57958CB89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220627074119.523274-1-yi.l.liu@intel.com>
In-Reply-To: <20220627074119.523274-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4cb86ff-ae5e-4e82-e38a-08da58ee5503
x-ms-traffictypediagnostic: SA0PR11MB4655:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QAwQv8GA067zUnI7ilQ6WSF0H3JJdlHutqFrv0BbmhoN9kBa1LqiT6JhIQppf0qSh6HQmINvn4tJcGUXj5Skwy4NxK90v6vn9m/iJ1/eWWxiXHuZyfohJl9Wsbb1pSgZlR6N/sJmysKT8lWHLRbSs+yNzwNaHqGtl7tKJpC5seTmGxfzPKuLrLEtXjhrou/bzPBDfnDXWlqrqjK+jUBAFjz16LRxpiWLgPgNorN/pP/QE+0bORMOlcvsyYnxSf2PMhG//6NB5ufAwgGLJRO+RiPTyvCto/itQ3pR4TXl5669QZU45srqCvwLohk0XAb7121YWTPzpsQTyOsEvp5SbgtpweXmQrEq0dDv42cPswfpl12R+KgU/XwiJxO11S7gOOiZsnA9J+vSovXfstKwUq/DoHk1MeaAtMoZSycLiqN5Zuy31oBSmDCcZFvgan3qEBdVcXiYMGVMkZ6+hZxxURVPTUp+YSAsAbSqf54N97AdI+S7Mismqa6bj1TLe0ZFFYSDAz9U0KhONb2Qq3njG48F4thugGPPFb9vCJhGSqbSCNugsws/YjcvIw30zZV/Qgqv8ig2ULXN1IgXlCo5XMwaqtzgUQsl4+JMNEdr+sNKmEeDyzpiA9Axo5bNbIEwNtJobVMUE8dKTR6uMzS7gSqzXF/bPom8L0dMQL7OLHe8Yv5/VRIv5jL3oSBBgEttmPWKpwYE4W5wdkYFLuPIOj4VgDZV4r78ZjMCUoFhXao9ZByUgMzrwsOsWwmNd+2Gvf8p80j8RD5F+dA3DXSbonAOEZaYQlZrsw0lv3L+Mqo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(346002)(376002)(39860400002)(83380400001)(2906002)(7696005)(316002)(6506007)(4326008)(82960400001)(122000001)(9686003)(86362001)(4744005)(54906003)(110136005)(76116006)(52536014)(26005)(5660300002)(41300700001)(8936002)(55016003)(64756008)(71200400001)(38070700005)(66556008)(38100700002)(8676002)(66446008)(66476007)(33656002)(66946007)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AWBJaTp1eegB7CLUXhE+n28gMFvC8V+LBIRbdRmtIiVfS7lbeDSaFRdvIiaL?=
 =?us-ascii?Q?B62of3AEl41PwJWk2c4rK4Zk/e7zW91r0sSoFqjFVBOhAx4A36Y24l8g4J7d?=
 =?us-ascii?Q?7IFePmJlz1lQSXYttOeSgR7rm1qLLSmDFskDvxp7/N7qbgWtLkr37lIXa+/E?=
 =?us-ascii?Q?OwCoZRYi23jvZnPlySB59TBak0+MSuHs+Tqq6weIZ5g3HHgMX4qU0AC6TXs/?=
 =?us-ascii?Q?MkhWwSCVvEtXeMvb92uyZzQHobqyt/eLVjLQPmfHcxuePISkwBdjQhlgcVZQ?=
 =?us-ascii?Q?cceZvmF56f5uQLxLavOvnzUr2ynzK8HLw1oC4CVrQ2G8VSbovVtyjC8MUg0R?=
 =?us-ascii?Q?FNIw2l2YiH5OUwewDewrOSlVtBqncIOYPimsAJ9Bo5StuHMMsQYvpmpCD+cC?=
 =?us-ascii?Q?e7UsFPHmvD7Bm73Yz4DuGa7JpZqAVn7/QVWuhdSZPoJ2RVAtNO6ar1xUf0H0?=
 =?us-ascii?Q?bEnpXduxEdLSl9NqeMFZpepBDpd9Or2Y57jpB0Dx/24vSfXedtTMgiD9erRR?=
 =?us-ascii?Q?ZqxebHl5P4I+3xUKZ0PcUm/wQxYqpGG0PiajDoiFtvGaRb9AUKidVR/Zc6sI?=
 =?us-ascii?Q?PxFnJdmOHo8Z0LogyAprORavEUnKDF0y2Zh0xXlTSEiEpMdPl6cog8a5cnwO?=
 =?us-ascii?Q?3l4o59GdSfXnIe8y2WBeBZweRb0ek2Uxy9bIFXFO4SmsSm9urCukmuQ5fTJ5?=
 =?us-ascii?Q?8Vsd9M+HMfAgxq7z2Bh3CWF2w1lzfMBzU8Uhaxw9yU346DEcMLLKjYc46X2q?=
 =?us-ascii?Q?/Lxd87NQQnjs8CGV6MArrt6SjgeWxsChPAdhIE5bZG9zj75FU7SGTeAAkuUd?=
 =?us-ascii?Q?lZJtO3Z1pNgM7roIpHzMmBLYH0fBmla2CmXM//LjTFU64YpjZyGlguguuUOu?=
 =?us-ascii?Q?iKKrJXpE9MT/0Yyk5jHxAAlpSaMZwSnQM9DsF6ER7Kw3fQ9qIeqtUinbjyN9?=
 =?us-ascii?Q?bvCIM7I3wXhH30Md1wwVZ5sCnPUcAidQIbQ0qfQzNwT18OJRbnq44r0+2JVX?=
 =?us-ascii?Q?7xtDTODF9ztW9xlyvzNRRNEW73ZCBQA6uEhO6hL5xc6ikUPQzz7GCKtWNEXj?=
 =?us-ascii?Q?m1SNPI4Le6R2P3fv74dCcTQw0mjaoKX/kcEq+XS3KW+fVuTlto/ufKDLa7/+?=
 =?us-ascii?Q?0AQmQYZlh8ABzlFE/emzUI5E/ruuOs0iHBbcRFPIbUoL7kksItEsbpcQ5rlX?=
 =?us-ascii?Q?qU/UvUxaSGqMYVEn1MrDRuD1Kz2BGJ8wzAsMuP2hfhLvlF5erleQxMs+pXiF?=
 =?us-ascii?Q?zhSAkt64Jc/eFgCntiW/kPcjfmUw8I0Pe+6OobB79LPJMMBGZyh8YfiDeU71?=
 =?us-ascii?Q?TgJZVNLiD9+KlFyPe59RxiCoXrxJbncPb30nHvzElt+iv0ZZK8iIrHbf0XIi?=
 =?us-ascii?Q?FMtIwdXX9bIkjshIcIt/KEVmarhrtbgbQyq5FzXk1XnTYYKOVo7pJe6Qqp+f?=
 =?us-ascii?Q?6Vch0QLBtSKdMGeEBN/Mpn4ZaBoMND7qzj8dtNeXdlfH9I59d0QaMLOSd//t?=
 =?us-ascii?Q?jjdGvX2+ud6Y3GNkEiHAlIZdWBBPAED9vn7bFVSaHDCcssPmNaBmzt9QaLhz?=
 =?us-ascii?Q?eMmEFBGDiWDXBTywNbsJY+TX955rEiYHHzAjOSlo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cb86ff-ae5e-4e82-e38a-08da58ee5503
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 10:09:47.7656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xM7dKTgOsfgVi04ZwhZxJJDd2q8+vuLBCYeXIjeiW1mveme4G66sBd3KuundKjc3QFT1hlIi/IY3RKpd/6I8tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4655
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, June 27, 2022 3:41 PM
>=20
> We do not protect the vfio_device::open_count with group_rwsem
> elsewhere (see
> vfio_device_fops_release as a comparison, where we already drop
> group_rwsem
> before open_count--). So move the group_rwsem unlock prior to
> open_count--.
>=20
> This change now also drops group_rswem before setting device->kvm =3D NUL=
L,
> but that's also OK (again, just like vfio_device_fops_release). The setti=
ng
> of device->kvm before open_device is technically done while holding the
> group_rwsem, this is done to protect the group kvm value we are copying
> from,
> and we should not be relying on that to protect the contents of device->k=
vm;
> instead we assume this value will not change until after the device is cl=
osed
> and while under the dev_set->lock.
>=20
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
