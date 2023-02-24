Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A406A1622
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 06:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjBXFJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 00:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBXFJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 00:09:42 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8328A367D5;
        Thu, 23 Feb 2023 21:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677215381; x=1708751381;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9wsVtkMArnV5+KMFBzjrK1H9OdJ3Qmm+Aul5i3mGEVE=;
  b=D3FR4v/M9QDQFfkPJ8Y8GzjTGEn5iSk6eHxkexwQauK7gYMpvlPM0bmN
   HPFrq8dYaDYulvxw1B+J/ry3L7nQv43/th46Jlr7FevvK091Xw/GcFby0
   mLf1K09t+FOyNntFaSI6poYU2oKTBwZp0evjOJF79eQE25N+4qGNAdDNX
   7zpZGXoQDzGsi3OARVuHD2yJFqsaNXhrFCJpDtDTbS6FgeTogAtzeaIve
   gjLhDgzyyU0S5wbyAr2yg/rCzbrYGQIal+LQ3ntiafccP/z1P4/tAf+U/
   dch7fjLc7gBrHhZEHDWCp3yvcpNorOxuTgXOoS2WydordekvI0sOi0K+D
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="419631510"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="419631510"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:09:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="705138740"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="705138740"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2023 21:09:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 21:09:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 21:09:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 21:09:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct/yMUoCWt4avQnEZaEeWjTaxWzTclBaIN2kVNWBK1ALN2W9eq2i9mjrOgCxQN2B4jISmDGOf+TMthdZrTrvR8LDyfo4N0WErxMO3g23D6xJEmkGed5tAU682SYrDLG10TRH1zUrzEShwHnWF8B0fLljcZr5Tn38PcXmliQVNeIw+i6586qz1BLtaiUeCnZVVQZlShtX5QE/X7YLrXXxcy9D8YtTvVA4ZRt+jaqnmA6PIPtLJBR5GoTFHmdySGb4p2Y09K+a8Ys8sfGvdRKT4RwU2a4uIwpbp1rdWjiI7NWEYdd5UX7ZD5Xwo6FF2RJvwTl4S5mwKxDq7vcAC2GGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wsVtkMArnV5+KMFBzjrK1H9OdJ3Qmm+Aul5i3mGEVE=;
 b=mLEiTa6bn0++Xd7rj4euEndM+ZCGnqNTB6m2Yxf3j59ixWgA7gTz1b/Axk5hkifGxLIhQ0PCWof4teqJJKjmO6PSFhH4oY15yVXcEF29ffhmUfPH34nm86DKXCMXsGfZty/VdZIvsx9paXjSvHva32gpo3CeX8Uxk9i4QO/75GKClP+FO7VozPVeTNANpFaATJYaMEDu+z2+/h+0NEUzbHoVxgQDBx8mEYFwVct3a1KHLeAF1sIBqFh88JQRXYST8S2U6CNYlVEBP7xutQ4ob8rX518RiuEGdyXZUYfxA+MDahnUDe5P60zHUR608OwGgs30ZZ6j8BfJ5XQrnVf3lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7682.namprd11.prod.outlook.com (2603:10b6:8:dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 05:09:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%6]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 05:09:31 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRadeNlgrDl2wokCstlukf6hiCq7akpcAgABgJDCAAEUdAIAA9TSAgABbNoCAANnbgIAABBCAgAADaICAAA57UIAABKeAgAATvOA=
Date:   Fri, 24 Feb 2023 05:09:31 +0000
Message-ID: <DS0PR11MB75295E224512B8E05521E778C3A89@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
 <BN9PR11MB52767479FDC6F1CE16275B8D8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529EC1C6A54BC57C1251154C3A89@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276F25F9612B5080CC9B56C8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276F25F9612B5080CC9B56C8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7682:EE_
x-ms-office365-filtering-correlation-id: b6788db7-1c61-4766-b1af-08db16254fee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PVMRnRmhHQ8D2z7QxGqMquhzt5ePTfI6PJVcfaIBXOPYXu5hut2Cy1PWKL3T3CK477O/VDrJljfBnvaVx8sxQ10rbYGbECM+RFGxOzPCjnLPsHeAVBwUtjjXDWfPzIDlo0501yKv7M2K8a6xTJB5qzyRlzajgarx/EucDX1v64Wp+UIA8FV4JhA/v2vRrGOK8iAwq5u7xg+ZO6yrM7+w1wWvm4jX+NjiFFKHmTGnbHhzrIOfbDkqGqI6BvQSavxR4CfmtqGb6cvDX39wyxdnwj9fmpDHNurC4i+yXJVW386/1KwgqGDrhgMGKCcM7/BuD4cO87KPaazRyMs1UOpv9ZoEpOiH1aIEjmr+/hbUazDZxVopY4NDhbSdlnclU0oso3BjFf6jNtFU1D38GXrUb63tP8MXJL0WWp9LZBJf11DI6Wmn4X0p8bjD1hj/Eg84Dac6BrgdUVF2Hb5lIK0ZBjyuwRVRg285Bum3LKCFY5qoaY6ARL5QRjniId5bAPJ/AjA+IDRLLK8UjppqnWbwVvGebrO1efPc/xbZ4ulzTI4ycCbHqdgftFNdz4pKrxKYdsM+TG54eeDXEIAN4EhgNFezFEIlkA2jUujMjUZAP/T0Z/HbwY7teGKtnxWJi5pCyhAyZfPdwHmbxLpjdY970mKJzVowgozI724aPIV4rdWMJ2HKppQYxT9BOTZQSOTIuEmy9KFQgvuYqgywz1C2XTwiz2X0oDxtuGQAvFHxaFU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199018)(64756008)(66476007)(66556008)(66946007)(66446008)(4326008)(8676002)(9686003)(186003)(6506007)(26005)(55016003)(76116006)(478600001)(33656002)(7696005)(71200400001)(316002)(86362001)(110136005)(54906003)(82960400001)(122000001)(52536014)(8936002)(38070700005)(38100700002)(5660300002)(7416002)(2906002)(41300700001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFl6OUU2NE14TER1dUlJMEdkcnR2UEU1VW5iL0JmT3RSS2NIbTRrSDljOWNw?=
 =?utf-8?B?OUFUU1FFdjRMVFQ5empIRjBmSFp6dnRnYUUrRUpqRzEvVTRsdldyVlQ0amw0?=
 =?utf-8?B?b1J2R01jRFQraHZ2UkpBODRRSDNZUXlJN3hJVzFwUnc0bUNvQ1B5T3lhaVR3?=
 =?utf-8?B?ckZqTDJHUDI1dWZPM3RySExwa3lnNkxPUnphc1FNc1ZtanBzUmNjcGFSR2Vy?=
 =?utf-8?B?OE8zaTl3OTNtVlNNY3JvN3kyUXQ5ZTJQdHFkdzM3enlLTktjRkdKdzNjNnNK?=
 =?utf-8?B?SGZkKzhZaElreWkyREt3dTc2aTlOcmFiazhOVld3MFp1WnVKZzFFb0NBempv?=
 =?utf-8?B?OERWa1dORkFOUDUvRVVSMk5SamxmWUxTWjZET3NObjArRnRvN1pKdzV3N2JU?=
 =?utf-8?B?SlNvOU5OVHB1WWJKcXEveUtOeE5TSlBaYkswWG9taFVaaTJZSGIyOHBsdFlZ?=
 =?utf-8?B?YVZZMGZYblBSNENQVlMxQUhsUk9DMU80R281SGVoa0VNZ2dQUW9oRHBTTTVX?=
 =?utf-8?B?ZmZYVVZ3bDZQQlpVaGVNa1YyRkd2YWdqNGJtTytjSzByUkRlOHhUbXpDTkdS?=
 =?utf-8?B?Wkl5QmJyVG03UGhVWjczaGxWZ1ZodUloNy9iWkViU3RwSXk5QUxjUTJMS3Zm?=
 =?utf-8?B?MWlVNVR2Nm5vQjBMSTFuNjdzT1krVUtDeHVDMk52OVRCZVhKTXNlQ3V5Nkll?=
 =?utf-8?B?ZU9tb3gzYXZNMVRNR1I3NnZSYjVrWFl1NkFyZkp5bzMzdWh2dzZDemhlaDFP?=
 =?utf-8?B?MTF6UEh4NFdZK00wek1STEtDM3dKM0hPdVVqY3RQOXJpR254YTR5NmFyWTNs?=
 =?utf-8?B?THFjZlowM3c3OHVubUpsR09sc2s2aGUrS0U1akJNSDV0bERMZHY5UFM4YnNT?=
 =?utf-8?B?WTQ2c3ljOFpVVTlIdm1WSWFXYnR5bTRxMjVIYVNFeFZaYWt6ZFdWUUlaQW83?=
 =?utf-8?B?K0JLV2dTRnhEM2pMQXJEOTA1bW1qS04yaDFLbFlXTFc1MWNoenB0bGt2Tm1j?=
 =?utf-8?B?LzErSk5kSDg4Ynp2SUpiNjVldDBIYm5WR1k1Rnh5N3grYjc5cE90UFVLQkFh?=
 =?utf-8?B?U1JwM2drTGlkTjhNQVBSZ1RIUXlTVWZkbFdZUHFzbm9hOFZjbHNNeEJ3SjRX?=
 =?utf-8?B?dk1EU1BENkg1ZXBaVlJBMUtBYXh3M2xhbE9hd09FTW82a1UxK0J0UVp0QjZT?=
 =?utf-8?B?OUZBMnJncjhlSDBmSnpiMlg2cUVDNlhhdWhTWm1GbW91WnhMTEp4TnhFOTM3?=
 =?utf-8?B?Yi94UDZiWGxZbk0vVi9INWdiU1RwT3M2SDRlL0k0QXVRQXBjZWxiSk44RFV2?=
 =?utf-8?B?dnMyRDR5SkhheWdGMlV2TEdKZGdJbmFJYk01TkN6aUdLU3lpNC9TWDh5cDgr?=
 =?utf-8?B?dHhMOU04TkM1UnVwZ1VrbytneGRCdVZvenZmQks1dEd0VHdlUkJLcFdEVUMx?=
 =?utf-8?B?MjhaNS95bTF1TENVYW1INEY2dkFrdnBrbmsrRGx4YzM5VFNPSmczTzlKMHc3?=
 =?utf-8?B?QnlkSDNCZ0pYV2g2djZjZmVDalpEc2h3eWlBZTBpWnU3WWJiY0k0Y2ovVUgv?=
 =?utf-8?B?Q2UxRlBuditJZGR2OHlyTmNaOVZaUnNNRGJFV3hEeUdsWjZoSkl0STVJaWRk?=
 =?utf-8?B?NlNxbW0zanFqT1BxSWlxZkZKYlJLYWdLelFWWUtnUXZZQ25ScngvVUNNRTVK?=
 =?utf-8?B?MzN1bmJXd2NObXJxSm5UYVlTR2MwbFFFMGxHdGg2bFdzV3QvQng2ZzdtNHIr?=
 =?utf-8?B?V0l1YnB6K3RNQUxrNVNtZnU3S3ltUjlZQWRwMHNGK3lPcFNNdXM2M0V1bC9i?=
 =?utf-8?B?RFFhbnN2VFArbzRhOEN2NU9Kd0pFZ3VaK3N1elJLKzJDUW12VkNaL0MreVdr?=
 =?utf-8?B?NG5pcUwyeHY4Uk1VSUh1SkFUVExWVDJ3TjdOQkNGZVJYY0tuOVoxK29XdVly?=
 =?utf-8?B?OHVEcEg0V3pDZmNrK3k2dXdsUHN1YzRsN25MV3FIRDhvQjF2Q0Vub08wUVIz?=
 =?utf-8?B?eGpWblJPdmh3V0F2MGVqNUpPU2VwTHd1aXRlWkY4cWFrd29tYjlPUzVpeDBV?=
 =?utf-8?B?dnExa0VOZWE1Umh2K2pqaHIyaUJyc3dOQmUzOW4ram5tdXBzNnA5NkttTmQ1?=
 =?utf-8?Q?oaLORJ8a5qsELNY+HPrHRVYoV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6788db7-1c61-4766-b1af-08db16254fee
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 05:09:31.3388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1ixd64dVqSvgU0IkOoOxzLsxZtT3mQxg8yXJni0CJHbF+g+N732dvU2EAX2/QNb0IECJ727NJDkLPnWXSBEcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7682
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRh
eSwgRmVicnVhcnkgMjQsIDIwMjMgMTE6NTcgQU0NCj4gDQo+ID4gRnJvbTogTGl1LCBZaSBMIDx5
aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyNCwgMjAyMyAx
MTo0NCBBTQ0KPiA+ID4gPiBVcG9uIHJlZmxlY3Rpb24gd2UgY2FuIHByb2JhYmx5IG1ha2UgaXQg
ZXZlbiBzaW1wbGVyIGFuZCBqdXN0IGhhdmUgYQ0KPiAwDQo+ID4gPiA+IGxlbmd0aCBmZCBhcnJh
eSBtZWFuIHRvIHVzZSB0aGUgaW9tbXVmZCB0aGUgdmZpb19kZXZpY2UgaXMgYWxyZWFkeQ0KPiA+
ID4gPiBhc3NvY2lhdGVkIHdpdGgNCj4gPiA+ID4NCj4gPiA+ID4gQW5kIHRoZSBjaGVjayBmb3Ig
Y29ycmVjdG5lc3MgY2FuIGJlIHNpbXBsaWZpZWQgdG8gc2ltcGx5IHNlZSBpZiBlYWNoDQo+ID4g
PiA+IHZmaW9fZGV2aWNlIGluIHRoZSBkZXZfc2V0IGlzIGF0dGFjaGVkIHRvIHRoZSBzYW1lIGlv
bW11ZmQgY3R4DQo+ID4gPiA+IHBvaW50ZXIgaW5zdGVhZCBvZiBzZWFyY2hpbmcgdGhlIHhhcnJh
eS4NCj4gPg0KPiA+IEhvdyBhYm91dCB0aGUgaG90IHJlc2V0IGluZm8gcGF0aD8gV2UgY2FuIHN0
aWxsIGtlZXAgcmVwb3J0aW5nIHRoZQ0KPiA+IGN1cnJlbnQgaW5mb3JtYXRpb24gdG8gdXNlcnNw
YWNlLiBJc24ndCBpdD8NCj4gDQo+IE5vIG5lZWQgdG8gY2hhbmdlIHRoYXQuIEl0J3MgYWxyZWFk
eSByZXBvcnRlZCBwZXIgZGV2aWNlLg0KPiANCj4gPg0KPiA+IGFub3RoZXIgdHJpY2t5IHF1ZXN0
aW9uLiBJZiB1c2VyIHBhc3Nlc3MgaW9tbXVmZCBkb3duIGZvciByZXNldA0KPiA+IGluIHRoZSB2
ZmlvIGlvbW11ZmQgY29tcGF0aWJsZSBtb2RlLCBzaG91bGQgd2Ugc3VwcG9ydCBpdCBhcw0KPiA+
IHdlbGw/DQo+ID4NCj4gDQo+IEkgZG9uJ3Qgc2VlIHdoeSB3ZSB3YW50IHRvIGJhbiBpdC4gSXQg
ZG9lcyBjaGFuZ2UgdGhlIHJlc3VsdCBmcm9tDQo+IGVycm9yICh2ZmlvIGNvbnRhaW5lcikgdG8g
c3VjY2VzcyAoaW9tbXVmZCB2ZmlvLWNvbXBhdCkgd2hlbiB1c2luZw0KPiB0aGUgY29udGFpbmVy
IGZkL2lvbW11ZmQuIEJ1dCBkbyB3ZSBhY3R1YWxseSBoYXZlIGEgdXNlIGNhc2UNCj4gcmVseWlu
ZyBvbiBzdWNoIGVycm9yIHBhdHRlcm4/DQo+DQo+IE9uIHRoZSBvdGhlciBoYW5kIGFuIHVzZXIg
d2hvIGtub3dzIHRoZSBwcmVzZW5jZSBvZiB2ZmlvLWNvbXBhdA0KPiBzaG91bGQgYmUgYWxsb3dl
ZCB0byBwYXNzIGlvbW11ZmQgdG8gcmVzZXQgZXZlbiB3aGVuIGl0IHN0aWxsIHVzZXMNCj4gdGhl
IGxlZ2FjeSBncm91cC9jb250YWluZXIgaW50ZXJmYWNlcy4NCg0KWWVzLiBhbHRob3VnaCBJIGd1
ZXNzIG5vIHVzZXIgd291bGQgZG8gc3VjaCBhIHN0cmFuZ2UgdGhpbmcgaWYNCm5vIHNwZWNpYWwg
cmVhc29uLiDwn5iKDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
