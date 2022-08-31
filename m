Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE05A7655
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 08:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiHaGOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 02:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiHaGOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 02:14:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127EDBCC18;
        Tue, 30 Aug 2022 23:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661926456; x=1693462456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WEaVVbUn3YGPFBExFxm9qak0D4y0RGoVl0kACZyaFXM=;
  b=bAy4mE/eh6omWIvPgdm94Bed/ku+RDA1ohW8PrOUk0PA2FKkqCDdGJoT
   7O94JYSUmtv5SiY5xXxemFkqjE7eQah2cabYpZ7VU/u7uY3uSuO4/hxIn
   Ew1CX2G8/vVzXV1W4lMnsgoQ8U3ADWQE0ctWyQLDjzRu8J37T7bF+REtT
   phmfcNb8LGgP9MQW8KfLBQlgGs4xi/kVA7wjKNXAjwyTWlsGyoJMCmfps
   lA0yqH+LwNXlElc38vQc+xqhSYgki2Z6Pv+UMPYl3J9qHvowL68X18qNz
   wVKkio6H3VSQHcDvyuK47kX2OAL9jge7uDNhlIaUfxiCq23qmyMy/joqN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="359341082"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="359341082"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 23:14:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="754319719"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 30 Aug 2022 23:14:15 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 23:14:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 23:14:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 23:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwh6tkoz6W76e5TzQkDKuiHPTZZwoqVcthKNb17zso7l4ItKz2hI6uQ84SzGvrcMl9W/8XeqRpvK9pL6Sru2XtcpuEIkGS7GxRyRQl3HWExY9NQDZ4CVC+DCAkFc0ZAGnIBi21Dt4EkN474C22uqxRLIHBohZcRohG3wySxvgCMsGUSCu0H+NfnQI/toS32FdkGBo7ts91+engR/CD+GYk3g4c0VnlaB8tMKeNYUR1BRH0VFePnv1UcDOmryzQZxoTO7V83RSeK9DDJJWPQ2KH4R43URRFM7nLlP4Eu0iOKlxm2uP//wlKykHnRn1k0tLFUFOGH9bb2TxGYRfPe8Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEaVVbUn3YGPFBExFxm9qak0D4y0RGoVl0kACZyaFXM=;
 b=BKT5LtCpuSZVqumWIFhYsbCyGAzykrapap268ddVZwj7ihcN+t748oAXGjaDjrs4NCZgYtKoPdVgp5XbEGORM3PS7BevmbmzQWS0mhMcXAB8SZogxovBUuSyo9iadsmM1B6nJLVb8uqYn3pz13LhuphteNDpj2yGpeB0PkT7paT8JbR9PWZltzA/Wt2EfTGkxWqzyEcDaAvlrgn0e8+z8zND37Ye80HJXS4BEDf5Ul2Cw88co6JU9APpuc1ip8kzv516+4uADl4lPtMEhGHK2eA//ZgvUmIxh3CyYobRer1e1+Yl9QvW+iunO6SRYddg9XYTgUwh+3f8/5aFUI8h4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR1101MB2233.namprd11.prod.outlook.com (2603:10b6:4:4f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Wed, 31 Aug
 2022 06:14:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 06:14:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Peter Oberparleiter" <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 10/15] vfio/fsl-mc: Use the new device life cycle helpers
Thread-Topic: [PATCH 10/15] vfio/fsl-mc: Use the new device life cycle helpers
Thread-Index: AQHYufqRg4aE4TfjN0eFCB8lkLOEkK3IK44AgABhWIA=
Date:   Wed, 31 Aug 2022 06:14:11 +0000
Message-ID: <BN9PR11MB5276D146255D42CC00E1AD048C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220827171037.30297-1-kevin.tian@intel.com>
 <20220827171037.30297-11-kevin.tian@intel.com> <Yw6pxrS1zb5JKt8q@ziepe.ca>
In-Reply-To: <Yw6pxrS1zb5JKt8q@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1ccf5e1-daab-4b2b-f2cd-08da8b1805dc
x-ms-traffictypediagnostic: DM5PR1101MB2233:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1vtDwP3cGE2GHwaH1VoIFRtQb3AYMgFdrlteZPmPTEptqOVlfiyehu/zE8K0END8HeElfpL8vPhUz7aPOenxT4+awDL0OLWawtLcQh608N7+XjLoP9srtcVJJAscs7LB1NOJZqTRXsumVajtJJXRtqaRxKk3QC07An4TCkj3ltGSIXCqW27Z2YjI4gskI7iogCY7QIMnINlOcnYFJ/UT8pxNaKsLYHomoS/7XXZozQLxi6sY3VBK5VY97A4tL9yOkRWQb7NXdvsVcJFEk6p1zX4Oom/W/64XGhJ+x9xtPeo2WYfVgPFBdAj9YNp+aw+ACeBoM7tO6CbB4onOjxdTrgYhM63113c/ScKPK3jfvzy4XQyatbr053VRlBRHg+GM8WBHBFcdPT1Vew9dTw9AkBildqmigHN1Wt5nnxQim0kJ77G7J2i2KXwPr1H4lZicJJSPVPbjKRYJOIUsEq99aWCa+HcV5BOd1eGVquDlpVhyaOL6LZ4n8juJwX6vLZpwIYgkZEqnp5Nfdf7mxeH/COK2uu431vQ51afqwZ9wl2BGCCBJzHAfRXjc6Gp20fl/LPmXZSZoRihlavly3G6oUcSOQdDEOmIno+jDaDGoDK5ohMlWZAMTjKs99mHxY7cnVSzNhDYsrUpvlhnZJXJGdv1rL/yZWRkostEnDtcjvbHQUAhUKXAotXqOhMZ3OPxYsnvV+kcMDp26s8Tde03e5ltWYUpZY3jI2i0hOtRJ9sfXMZMqsJfsXjsLZy65VvBtZWTwJVX+tNSNe94knMJuhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(396003)(346002)(136003)(39860400002)(38070700005)(4326008)(26005)(7696005)(9686003)(41300700001)(86362001)(478600001)(71200400001)(122000001)(6506007)(54906003)(66446008)(82960400001)(186003)(38100700002)(66946007)(5660300002)(7406005)(2906002)(7416002)(76116006)(52536014)(66556008)(8936002)(33656002)(55016003)(6916009)(64756008)(316002)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P9lBK4oM48CfULDBI9CMX5f+eZZHcVArGf2XAKV22mtv6PyV3MWAAjUNMl03?=
 =?us-ascii?Q?U9yScuy0ttHfyfNqwBabNqeBfKB9OlklsSw/cVtvOaVac5hJ1vuSiUyGC8iX?=
 =?us-ascii?Q?A9geSjKHtiSPNFWEeHLtB2Km9jEYowsg2W+lc4MvkoL9TiuYP553BSmWo7xt?=
 =?us-ascii?Q?8222Bhor/xF0Xg2T0aL6whCKRBSl32cVtTUFAopEyR7BailJJroejrcauqzd?=
 =?us-ascii?Q?4PPP/98nFBZUAoaAw3Kl345hDeDMbtFelupdHB5eGHrKFlgEC0PJV0KfIDaY?=
 =?us-ascii?Q?0xVvyE5pGkNrJ07mF+LmUif0sKCIrxx38TPs+Fpz7L58Eco9C+6qBeRC5+pS?=
 =?us-ascii?Q?3Y4cwUcXSPvKngfFOoat2FvD6DhYH4iPMGAjOGkRc4TrLnhSPOuN3TdSyvkt?=
 =?us-ascii?Q?l7FpzAEcxEtA2WN0RxvDJqTNqG14DcQbKZHTttAbSmOAQf45RoNTYt7J1Gpy?=
 =?us-ascii?Q?II5c16mvRwf6rjQnu1mKLm3UoRTNoqW5EciYyy3J880uVM5589jhfEEwsQq5?=
 =?us-ascii?Q?dRJ1nB24JnDDwdoWAG64TYTKriw8Y2kZ7zv2oh8ybYc1wTZre5R/Gz/mf13r?=
 =?us-ascii?Q?vmu6g3B6vNZ9nTUe3mEe1lCgAOEn27Q20kZMV0AwZAfKsOUAiHOZMz8Ek2FO?=
 =?us-ascii?Q?Y3llBadKZN9FstFqL31Ar22f5imU21BSGkRWl+GZBqbpJyE/JqEKwncw2WrH?=
 =?us-ascii?Q?4POKy5QJE3Ll74znXVPhR8/ddD7caseFCD/xuMe2e88b0/Uayca36i0MF+R2?=
 =?us-ascii?Q?QtqCMQOiBz3TI+9N+6rHnZJZhHsJM43kGOtKCueR34la7j6kLhUf59d8hLWU?=
 =?us-ascii?Q?ZUcdsClSnV1/uGjtI35wsc/p2sI9bCG4ON01Bgn1LhyHM5PvazPxeR5ZEYWw?=
 =?us-ascii?Q?weOKGWmnT/V08b8dd/yPTr6wC7PVQH7a23r2O+vPY7rCtPjwnmqi6Iu/Ja5Q?=
 =?us-ascii?Q?TBHyPveuHlooRxlNHeII9lGPfbvp0Zfgf2ADImG5sN9Lupgmhv+NsyppacjP?=
 =?us-ascii?Q?BvpqX9NRFuo8KChZppXqCqGCUsDL4HxlIoQvEK8ikk0UDyDubucL683oB/5q?=
 =?us-ascii?Q?JPvYEbmCgzNzqI5lQGmpDLY99xgFBeIsx8hFjdMwGwHs5VJtsKtK8gfOS+nz?=
 =?us-ascii?Q?TfXKXnY9M5vHPFGR0TzfELIJgghKprml1AeOrLkn59N7t9qowZgSBRER9GWB?=
 =?us-ascii?Q?L8YtmTVqnUJbuCQM3WARAYMmdzfJY5ywnuFp6FCDM5vbtG/KHOPjsf7Afc6b?=
 =?us-ascii?Q?WrHB1DhPEDd63/eN1sZK7/9biqjIzLaDA0MPh8NPw6MDbjOkAzqQfkmNNqU1?=
 =?us-ascii?Q?DM27afz9pzfOKqTSJRjPHsS2gBAWPFBA/aPa3SKepW09+yr7153px8DrqivF?=
 =?us-ascii?Q?9bp7EUSEQDBtkXvxMKID2rn+dXH/Y9iF0xvxwSO5VO7w8YCiR4aCqpFYaChZ?=
 =?us-ascii?Q?xCBgUNBk+Zj12yRuyUjDXngDtfYxNri/aSO6X0Ld3YQ6HuEGF8wPN2k3IXNR?=
 =?us-ascii?Q?gyx3+mSuNazKodtaXhj347SlcdXpFDqma1oFeAMONrwFFjg6N6ZSBM8uhjwJ?=
 =?us-ascii?Q?bwkKTkjq1KWq0B/DtfkhHaPqzf9eCOK2BtdpDyMB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ccf5e1-daab-4b2b-f2cd-08da8b1805dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 06:14:11.9876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OC+o4cp8fuMu1Vas7qNGch+NAsS5vA7dYdhu1BPJG+JomioOxdr4pdDqoDr7yGpzmFIeD3iu8rfWQfi5Wi4oWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2233
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, August 31, 2022 8:23 AM
>=20
> On Sun, Aug 28, 2022 at 01:10:32AM +0800, Kevin Tian wrote:
> > From: Yi Liu <yi.l.liu@intel.com>
> >
> > Export symbol of vfio_release_device_set() so fsl-mc @init can handle
> > the error path cleanly instead of assuming certain vfio core API can
> > help release device_set afterwards.
>=20
> I think you should leave it as is, the "device_set" cleanup is just
> something handled completely internally to vfio
>=20
> If ops->init fails then we expect the core code to clean the
> device_set, and it does because it calls vfio_init_device() already.
>=20
> Having a single weirdly placed release in the driver is pretty
> confusing, IMHO.
>=20

I considered both. In the end I chose the current way being it's
clearer if just looking at @init. But yes having a release called
by driver is also confusing. Probably having a pair of assign/deassign
helpers is more clearer, but I'll not continue this path for unnecessary
complexity.

So I'll leave it as is and add a comment to clarify it.

