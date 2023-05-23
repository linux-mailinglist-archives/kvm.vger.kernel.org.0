Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E67170D08E
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjEWBfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbjEWBe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:34:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337428E;
        Mon, 22 May 2023 18:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684805695; x=1716341695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V67rZaIUJ6elR4ht1YnQrHFkxiyEXuUQ+vw/KRNtf50=;
  b=U8r5QdMjMeRZhM2U8lJ5rqLHh670oDBdBeaYWtwjmr9AO+OoPUxQtgrD
   vY29EhFYRJ8qN4rxjE6LIgYbckFf9THIyj708Dro2BEEMY4Lu8Fiz7rpm
   5u3OoABY4WQBb8LTOt2gFQY39KpcnFD5DQDBYPc9ZXBODVS/LkOHFHVqn
   BIisQW8YCKQBCB3rNtdUa8f6HnZrSP3b95z09D7fSehUnrcwUkqNYiDCE
   7R84VZ0+DEHXggm6ysKxVidDUU2kmYFSZnCcals3J34YH648Eng0Y4JSU
   PDHPX8tjz/Dd38lUn9p6QqlQfgaH2nDxbkR14DIPyvYR8gaKeS2UL0YXA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="418801854"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="418801854"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 18:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="697847416"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="697847416"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 22 May 2023 18:34:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 18:34:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 18:34:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 18:34:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d54YSCkp+EhfrBf2idTqGFVGwnQ+xQK/adDgFMIBqpxAODwtOQhDTsyHyu73P48XbJOr130OqDkRuuPblXg96RJurrT+U+ZAD6pfrjTO1DxOnYnq9p0/l+ITCyse4KYMD9wRhtqLj1aGqCoxGF016aaVFQUDs4rv82FYCoDUNS9BJ7sjazAjUlgng0WlRwc4Py7jaecZYBZa9OGQc7Cqd6ZCZi3jufaQ0ouXz6+2PhFcDwmN5tCPV2ITTf3EBlOJCKh2tondsIAXJR+edgvyVtCxS5ljpOoVoMm998rzdIHGYTPbfv+XBGI3Cj+8X0bNeSZ/GQHaJX8vVrJyAt5iuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V67rZaIUJ6elR4ht1YnQrHFkxiyEXuUQ+vw/KRNtf50=;
 b=k73tgQjj4wv33WkYFpDeQ0l+2JEJrzYzGmPLlX9C+q0m2JsF6Q8A/SGCCG+MYb0T7prwfKTZjkJmxf8De2YSsisJH/4ErJ/8pfNnTzjb5TwgsqGdlNkhCOyLPx50S+6b7rO1i0h2XwgjjhFzQ4e9IoLGUGg714uELq9Hc2HwH757cIEhiaRsb2nddFZF01TDCPYha6KBT+igGoZjTTxBarZUyRjfMIEdft5EsVkaw41XY9aY0Q3eyYiLJSGI7K4/uOO2LO40fsGIueI3ds0D/BGGA/mfqhYK5LvLQ8Q9KrSeTQnLh+V4YUVW0JxgHKruHjscn3k8aZ4j5zfMNIcGow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7978.namprd11.prod.outlook.com (2603:10b6:806:2fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Tue, 23 May
 2023 01:34:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 01:34:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 13/23] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v11 13/23] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZhZ7fhw1sN1Mb6026DosHebcneq9m0auAgAADnYCAAEucMA==
Date:   Tue, 23 May 2023 01:34:47 +0000
Message-ID: <DS0PR11MB7529D89EDA7B5D49DBEB7F2DC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-14-yi.l.liu@intel.com>
        <20230522144617.63dcfead.alex.williamson@redhat.com>
 <20230522145913.2f13cda3.alex.williamson@redhat.com>
In-Reply-To: <20230522145913.2f13cda3.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7978:EE_
x-ms-office365-filtering-correlation-id: bd8b589c-3065-41dd-1292-08db5b2de4f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fFh8giQdnA4fALCw3uYy6WFXx3n0NN7V/WMJyo/UWVIakobEaoNd9vHK1LTGsU5RmM4lyDWpICqdX0N9Pl/s0I9fygXPwsCnwpV77iCXZaTJNRZUSj2WJBRm+dHvlq6VLZcyax7jAkKLJFYDLRs3HAnAwZDHeZh3z5cW7CKWw3uWOCo/Pmb1s7FoW68EbGPPmupzJxLUkwJEapounORAqsiF1ep4dKwvvi5n8BaQbd3xJvEj2VrGe4QZjFYMAI9xAxE6iyqTJIdXB/QUbsgGKccImPyvuaSLJJRgnJEH2wkIP/+p4tpIbkSlWgsthK3VDMxtyax9/g9U2xSvcnTajCry9go1Wdta/ye6d1ynqfCOl3WYsAZv20Fh9NeRNASC6RgcBPpllQFLtUqeAibHHc4AZcS2cLOFLwmXI7Zw+DSq8LeRiK3K4xikqX4H0cAFc8/ck1aXaI3l5bH5UpUB641B4Wt4A6sIc/j2A3a5HAfs/iTGMYJ5GflAZ9CUyIFs2x0FlB0yeGBkn1jkEXs1ASw0v5A4zQCi2O2nS8yxPqhhZOOxcN8+Kvis66K5A/VrVwYd/NzaKELt7chEf5TvLrOvvoTbsv39ZnrEx2Ni037enioZsne5yEBPhgLE9go1LOUD1jOxGSZvXDdqUP8uqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199021)(66446008)(64756008)(6916009)(66556008)(4326008)(66946007)(66476007)(76116006)(478600001)(316002)(54906003)(38070700005)(33656002)(86362001)(83380400001)(26005)(9686003)(186003)(6506007)(52536014)(30864003)(5660300002)(7416002)(71200400001)(8676002)(8936002)(2906002)(7696005)(55016003)(38100700002)(41300700001)(122000001)(82960400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ymt5VmlVSmpIa1gxSEVCc2g5NXNQczRObTBrME9ycnFIOENpMjZFdC9Jcm5i?=
 =?utf-8?B?UTRaK3JvSGpaMW13cG9Udld4TXY5UHRBMUJZVzBheXRub2lQRjRYYlRML21S?=
 =?utf-8?B?cWx6RGNrVHJJbkpISTRUNVdiV3h0dTk0UWYwaGE4NFdHSkhKbXVHekVhdmkz?=
 =?utf-8?B?eDMzRTZ0ZnphYlcrY0FiK0NsQlhYVDlUaGZCZkErd3g1dGpNWWxjWlMrNStI?=
 =?utf-8?B?Uk5mVjRqWkJMckhRRjhkZy82eDBveHhFN3BaaDhXdDQwK2hValZ6eTlyamta?=
 =?utf-8?B?bEtZNFluMzQveE12M29HNkJzSzM2RDdiU0l6QVVSVjFIYlV5TlB5bUpBbkRE?=
 =?utf-8?B?eFRmUzczaEtiYVMrcncrUVlmMkJZVndQZ3ZDYitGUWsvWHBSN0JmNHZFRHJO?=
 =?utf-8?B?bWR4R01MSkFqNDU2ZG9UNUx2YzBDY2tnV3B1ZENScCtYSUN6UVNXa3FUU2Z0?=
 =?utf-8?B?ZUhKc25Fa09ySnNpc2xOWmg5U2dUd1pwazQ3TlJlcDZBU040YXRORk9PQzdI?=
 =?utf-8?B?L1djVzVwaE42VVhRaWhUSEJNS1JHZTNaaEpDV3d0QTA5bVdrQmFhTUNEaDhR?=
 =?utf-8?B?Rys4NmVjZHJtcGVwTStVZjB1MDNndHFuZlE2L1o3K0htb0ttNFIwZ1REZVpj?=
 =?utf-8?B?dkFpU2JBQ1JDQnk0alE1bDFFVGtoRXB2aE9IV01ZQ29FUmZvSE1OT3hZVTZ6?=
 =?utf-8?B?eko4dHdqcVNvQm5RVjd2TTMyQVNjc2wzOGxwUm5najNhNXY2S09vUlQ5SG5m?=
 =?utf-8?B?STZtUEl3a0hmRnlTSHZhZ3lieTlHYmxGZTVhSkJmeVpHSFdETkpCWU5relVn?=
 =?utf-8?B?MWFsekNYS2ROQWZoWm00M1NaTzJ3R2Q1TEErMXBERDNOMDhudWdiNUJsWDY4?=
 =?utf-8?B?ODlOaUFsVXFDYnVremp4VGpYWnhvei9PWUF3UWszbExVdUt4dThzTE9FcDR0?=
 =?utf-8?B?TlBLa1hKZnJjNjJtM2NhZVFEdzBaa0FqKzRjVG84NWx6ai9NaGhBMDI4MU1L?=
 =?utf-8?B?dE5WMngzMnVRL0JOQzAwMTBjNHJXWnFpVkVIWWFMcmxlekprS2tsSEpnckhJ?=
 =?utf-8?B?VnMzc3dTVWNzb0hjeW1sVUtaSVFML09rcmhKMmxRcUFaQWJHYlhxaExkVDc2?=
 =?utf-8?B?SnU5RmVja281L0VlMVVsM0dscnhyc3lYRm1KbHBmRTBrdlA5QnMzWTNrVkk1?=
 =?utf-8?B?dE55WVlnL3J0YzhuR2c2RzV2ZjVNK0tDMTVNNFZOVFRTeU1DMFlQT2dKdldT?=
 =?utf-8?B?Z3B6eWJoMWNQdHBCTFF6eXMzdFkweENOR1VkeEpwLzk3bGZSekJ2b0IzTjIv?=
 =?utf-8?B?YVJDQWpMc0xodUN3dVVFRkIxbUNXVWdSYU1hckRnNGlLa2s2ZjRVakhlblpw?=
 =?utf-8?B?bm9wWlhMc3ZJby9lWVhyS1FUR2VkYnBKTUZhZnBvSFgwK2N3ZS82Smh1Y3Ax?=
 =?utf-8?B?MFdMaE1xR2hZR0orZStYYmRNOHhjaXlsOVgyUmxwVG9mUCsrbGQxeURRWkMr?=
 =?utf-8?B?QnBpQnBrQVNDUytMOGhFYmNhWVRWaTd1U3p1eEpGSlNFSnN0bjVRMnNpZmRX?=
 =?utf-8?B?MVBHZ1RSUy9QamEyQjRXLzFhMHhDcnVDRkU5cGQwcTBCWWo2NTRjNnJCM1RU?=
 =?utf-8?B?ZytQYmtMeSsvZ1ljRDFZUlMxNDBWRTZKRFJpU1BjTm1rMkE0S3FOT1BvQUQ5?=
 =?utf-8?B?cC9XOVpBQ2F5eGpxSUlMR2tmSy93T29CeFRyOXBYSDM4K2N4N2dOa3NQUEFW?=
 =?utf-8?B?M1ZtbGhJb0xJZko5bDBnMkNiREFTZ3RFWUxWMlZoTDN2RWxvTnpKaG4xRkFr?=
 =?utf-8?B?Z2F4SDA0ZmhRMnJNNWMrNFovd2F0WE55U3JEUW56RnVjQVd0c0lwd1ZDMm1V?=
 =?utf-8?B?OTVOd1BQdUhld1pRMWJIZjdDaGtFK0lWK3JiMVh5ODRlbHJ2TkpTOUMzVEdO?=
 =?utf-8?B?MzNaeFBaaEhEeXFTcXZlMjZBWkFWOWV5ays3d290SXZTM0k0aDl6N21FblEz?=
 =?utf-8?B?aWJaVTBURVVlTG5obkJkNk53emVuVWs2N3dZanhUejdNWjVLN3YyeUJYdlZH?=
 =?utf-8?B?VGVtWEVlc2lobjgyTTU1ZisxbENJdHFPVzRBdWJ0OWRGT0R5WVpoOW9LRksy?=
 =?utf-8?Q?jZTqUqwW/upTiqqOozLbdMHCZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8b589c-3065-41dd-1292-08db5b2de4f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 01:34:47.6023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQPjecAFuP+/cbyj2XT8uN5dc5BJHJUk6ouYCJORDPbKTxFUmCD3Jx4gupiqIl9+HGvMs3PFGe3twCnV3Msnpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7978
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

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBNYXkgMjMsIDIwMjMgNDo1OSBBTQ0KPiANCj4gT24gTW9uLCAyMiBNYXkg
MjAyMyAxNDo0NjoxNyAtMDYwMA0KPiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU2F0LCAxMyBNYXkgMjAyMyAwNjoyODoxNyAt
MDcwMA0KPiA+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4g
dGhpcyBwcmVwYXJlcyBmb3IgYWRkaW5nIERFVEFDSCBpb2N0bCBmb3IgcGh5c2ljYWwgVkZJTyBk
ZXZpY2VzLg0KPiA+ID4NCj4gPiA+IFJldmlld2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50aWFu
QGludGVsLmNvbT4NCj4gPiA+IFRlc3RlZC1ieTogVGVycmVuY2UgWHUgPHRlcnJlbmNlLnh1QGlu
dGVsLmNvbT4NCj4gPiA+IFRlc3RlZC1ieTogTmljb2xpbiBDaGVuIDxuaWNvbGluY0BudmlkaWEu
Y29tPg0KPiA+ID4gVGVzdGVkLWJ5OiBNYXR0aGV3IFJvc2F0byA8bWpyb3NhdG9AbGludXguaWJt
LmNvbT4NCj4gPiA+IFRlc3RlZC1ieTogWWFudGluZyBKaWFuZyA8eWFudGluZy5qaWFuZ0BpbnRl
bC5jb20+DQo+ID4gPiBUZXN0ZWQtYnk6IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29s
b3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWku
bC5saXVAaW50ZWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgRG9jdW1lbnRhdGlvbi9kcml2ZXIt
YXBpL3ZmaW8ucnN0ICAgICAgICAgICAgIHwgIDggKysrKystLS0NCj4gPiA+ICBkcml2ZXJzL3Zm
aW8vZnNsLW1jL3ZmaW9fZnNsX21jLmMgICAgICAgICAgICAgfCAgMSArDQo+ID4gPiAgZHJpdmVy
cy92ZmlvL2lvbW11ZmQuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgMjAgKysrKysrKysrKysr
KysrKysrKw0KPiA+ID4gIC4uLi92ZmlvL3BjaS9oaXNpbGljb24vaGlzaV9hY2NfdmZpb19wY2ku
YyAgICB8ICAyICsrDQo+ID4gPiAgZHJpdmVycy92ZmlvL3BjaS9tbHg1L21haW4uYyAgICAgICAg
ICAgICAgICAgIHwgIDEgKw0KPiA+ID4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYyAgICAg
ICAgICAgICAgICAgICB8ICAxICsNCj4gPiA+ICBkcml2ZXJzL3ZmaW8vcGxhdGZvcm0vdmZpb19h
bWJhLmMgICAgICAgICAgICAgfCAgMSArDQo+ID4gPiAgZHJpdmVycy92ZmlvL3BsYXRmb3JtL3Zm
aW9fcGxhdGZvcm0uYyAgICAgICAgIHwgIDEgKw0KPiA+ID4gIGRyaXZlcnMvdmZpby92ZmlvX21h
aW4uYyAgICAgICAgICAgICAgICAgICAgICB8ICAzICsrLQ0KPiA+ID4gIGluY2x1ZGUvbGludXgv
dmZpby5oICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA4ICsrKysrKystDQo+ID4gPiAgMTAg
ZmlsZXMgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPiA+DQo+
ID4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0IGIvRG9j
dW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0DQo+ID4gPiBpbmRleCA2OGFiYzA4OWQ2ZGQu
LjM2M2UxMmM5MGI4NyAxMDA2NDQNCj4gPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZHJpdmVyLWFw
aS92ZmlvLnJzdA0KPiA+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0
DQo+ID4gPiBAQCAtMjc5LDYgKzI3OSw3IEBAIHNpbWlsYXIgdG8gYSBmaWxlIG9wZXJhdGlvbnMg
c3RydWN0dXJlOjoNCj4gPiA+ICAJCQkJCXN0cnVjdCBpb21tdWZkX2N0eCAqaWN0eCwgdTMyICpv
dXRfZGV2aWNlX2lkKTsNCj4gPiA+ICAJCXZvaWQJKCp1bmJpbmRfaW9tbXVmZCkoc3RydWN0IHZm
aW9fZGV2aWNlICp2ZGV2KTsNCj4gPiA+ICAJCWludAkoKmF0dGFjaF9pb2FzKShzdHJ1Y3QgdmZp
b19kZXZpY2UgKnZkZXYsIHUzMiAqcHRfaWQpOw0KPiA+ID4gKwkJdm9pZAkoKmRldGFjaF9pb2Fz
KShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYpOw0KPiA+ID4gIAkJaW50CSgqb3Blbl9kZXZpY2Up
KHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldik7DQo+ID4gPiAgCQl2b2lkCSgqY2xvc2VfZGV2aWNl
KShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYpOw0KPiA+ID4gIAkJc3NpemVfdAkoKnJlYWQpKHN0
cnVjdCB2ZmlvX2RldmljZSAqdmRldiwgY2hhciBfX3VzZXIgKmJ1ZiwNCj4gPiA+IEBAIC0zMTUs
OSArMzE2LDEwIEBAIGNvbnRhaW5lcl9vZigpLg0KPiA+ID4gIAktIFRoZSBbdW5dYmluZF9pb21t
dWZkIGNhbGxiYWNrcyBhcmUgaXNzdWVkIHdoZW4gdGhlIGRldmljZSBpcyBib3VuZCB0bw0KPiA+
ID4gIAkgIGFuZCB1bmJvdW5kIGZyb20gaW9tbXVmZC4NCj4gPiA+DQo+ID4gPiAtCS0gVGhlIGF0
dGFjaF9pb2FzIGNhbGxiYWNrIGlzIGlzc3VlZCB3aGVuIHRoZSBkZXZpY2UgaXMgYXR0YWNoZWQg
dG8gYW4NCj4gPiA+IC0JICBJT0FTIG1hbmFnZWQgYnkgdGhlIGJvdW5kIGlvbW11ZmQuIFRoZSBh
dHRhY2hlZCBJT0FTIGlzIGF1dG9tYXRpY2FsbHkNCj4gPiA+IC0JICBkZXRhY2hlZCB3aGVuIHRo
ZSBkZXZpY2UgaXMgdW5ib3VuZCBmcm9tIGlvbW11ZmQuDQo+ID4gPiArCS0gVGhlIFtkZV1hdHRh
Y2hfaW9hcyBjYWxsYmFjayBpcyBpc3N1ZWQgd2hlbiB0aGUgZGV2aWNlIGlzIGF0dGFjaGVkIHRv
DQo+ID4gPiArCSAgYW5kIGRldGFjaGVkIGZyb20gYW4gSU9BUyBtYW5hZ2VkIGJ5IHRoZSBib3Vu
ZCBpb21tdWZkLiBIb3dldmVyLCB0aGUNCj4gPiA+ICsJICBhdHRhY2hlZCBJT0FTIGNhbiBhbHNv
IGJlIGF1dG9tYXRpY2FsbHkgZGV0YWNoZWQgd2hlbiB0aGUgZGV2aWNlIGlzDQo+ID4gPiArCSAg
dW5ib3VuZCBmcm9tIGlvbW11ZmQuDQo+ID4gPg0KPiA+ID4gIAktIFRoZSByZWFkL3dyaXRlL21t
YXAgY2FsbGJhY2tzIGltcGxlbWVudCB0aGUgZGV2aWNlIHJlZ2lvbiBhY2Nlc3MgZGVmaW5lZA0K
PiA+ID4gIAkgIGJ5IHRoZSBkZXZpY2UncyBvd24gVkZJT19ERVZJQ0VfR0VUX1JFR0lPTl9JTkZP
IGlvY3RsLg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9mc2wtbWMvdmZpb19mc2xf
bWMuYyBiL2RyaXZlcnMvdmZpby9mc2wtbWMvdmZpb19mc2xfbWMuYw0KPiA+ID4gaW5kZXggYzg5
YTA0N2E0Y2Q4Li5kNTQwY2Y2ODNkOTMgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8v
ZnNsLW1jL3ZmaW9fZnNsX21jLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdmZpby9mc2wtbWMvdmZp
b19mc2xfbWMuYw0KPiA+ID4gQEAgLTU5NCw2ICs1OTQsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IHZmaW9fZGV2aWNlX29wcyB2ZmlvX2ZzbF9tY19vcHMgPSB7DQo+ID4gPiAgCS5iaW5kX2lvbW11
ZmQJPSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfYmluZCwNCj4gPiA+ICAJLnVuYmluZF9pb21tdWZk
CT0gdmZpb19pb21tdWZkX3BoeXNpY2FsX3VuYmluZCwNCj4gPiA+ICAJLmF0dGFjaF9pb2FzCT0g
dmZpb19pb21tdWZkX3BoeXNpY2FsX2F0dGFjaF9pb2FzLA0KPiA+ID4gKwkuZGV0YWNoX2lvYXMJ
PSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfZGV0YWNoX2lvYXMsDQo+ID4gPiAgfTsNCj4gPiA+DQo+
ID4gPiAgc3RhdGljIHN0cnVjdCBmc2xfbWNfZHJpdmVyIHZmaW9fZnNsX21jX2RyaXZlciA9IHsN
Cj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vaW9tbXVmZC5jIGIvZHJpdmVycy92Zmlv
L2lvbW11ZmQuYw0KPiA+ID4gaW5kZXggMDdiNThjNDYyNWI1Li5lMzk1M2UxNjE3YTUgMTAwNjQ0
DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vaW9tbXVmZC5jDQo+ID4gPiArKysgYi9kcml2ZXJz
L3ZmaW8vaW9tbXVmZC5jDQo+ID4gPiBAQCAtMTY3LDYgKzE2NywxNCBAQCBpbnQgdmZpb19pb21t
dWZkX3BoeXNpY2FsX2F0dGFjaF9pb2FzKHN0cnVjdCB2ZmlvX2RldmljZQ0KPiAqdmRldiwgdTMy
ICpwdF9pZCkNCj4gPiA+ICB7DQo+ID4gPiAgCWludCByYzsNCj4gPiA+DQo+ID4gPiArCWxvY2tk
ZXBfYXNzZXJ0X2hlbGQoJnZkZXYtPmRldl9zZXQtPmxvY2spOw0KPiA+ID4gKw0KPiA+ID4gKwlp
ZiAoV0FSTl9PTighdmRldi0+aW9tbXVmZF9kZXZpY2UpKQ0KPiA+ID4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ID4gPiArDQo+ID4gPiArCWlmICh2ZGV2LT5pb21tdWZkX2F0dGFjaGVkKQ0KPiA+ID4g
KwkJcmV0dXJuIC1FQlVTWTsNCj4gPiA+ICsNCj4gPiA+ICAJcmMgPSBpb21tdWZkX2RldmljZV9h
dHRhY2godmRldi0+aW9tbXVmZF9kZXZpY2UsIHB0X2lkKTsNCj4gPiA+ICAJaWYgKHJjKQ0KPiA+
ID4gIAkJcmV0dXJuIHJjOw0KPiA+ID4gQEAgLTE3NSw2ICsxODMsMTggQEAgaW50IHZmaW9faW9t
bXVmZF9waHlzaWNhbF9hdHRhY2hfaW9hcyhzdHJ1Y3QgdmZpb19kZXZpY2UNCj4gKnZkZXYsIHUz
MiAqcHRfaWQpDQo+ID4gPiAgfQ0KPiA+ID4gIEVYUE9SVF9TWU1CT0xfR1BMKHZmaW9faW9tbXVm
ZF9waHlzaWNhbF9hdHRhY2hfaW9hcyk7DQo+ID4gPg0KPiA+ID4gK3ZvaWQgdmZpb19pb21tdWZk
X3BoeXNpY2FsX2RldGFjaF9pb2FzKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldikNCj4gPiA+ICt7
DQo+ID4gPiArCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJnZkZXYtPmRldl9zZXQtPmxvY2spOw0KPiA+
ID4gKw0KPiA+ID4gKwlpZiAoV0FSTl9PTighdmRldi0+aW9tbXVmZF9kZXZpY2UpIHx8ICF2ZGV2
LT5pb21tdWZkX2F0dGFjaGVkKQ0KPiA+ID4gKwkJcmV0dXJuOw0KPiA+ID4gKw0KPiA+ID4gKwlp
b21tdWZkX2RldmljZV9kZXRhY2godmRldi0+aW9tbXVmZF9kZXZpY2UpOw0KPiA+ID4gKwl2ZGV2
LT5pb21tdWZkX2F0dGFjaGVkID0gZmFsc2U7DQo+ID4gPiArfQ0KPiA+ID4gK0VYUE9SVF9TWU1C
T0xfR1BMKHZmaW9faW9tbXVmZF9waHlzaWNhbF9kZXRhY2hfaW9hcyk7DQo+ID4NCj4gPiBDYW4n
dCBhIHVzZXIgdHJpZ2dlciB0aGlzIFdBUk5fT04gYnkgc2ltcGx5IHJlcGVhdGVkbHkgY2FsbGlu
ZyB0aGUNCj4gPiB0by1iZS1hZGRlZCBkZXRhY2ggaW9jdGw/ICBUaGFua3MsDQo+IA0KPiBPb3Bz
LCBkaWRuJ3QgdHJhY2sgdGhlIGNsb3NlIHBhcmVuIGNvcnJlY3RseSwgZGlzcmVnYXJkLiAgVGhh
bmtzLA0KDQpOb3Qgc3VyZSBpbGwgaXQgYmUgY2xlYXJlciB0byBoYXZlICF2ZGV2LT5pb21tdWZk
X2F0dGFjaGVkIGluIHRoZSBuZXh0DQpsaW5lPyDwn5iKDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
PiBBbGV4DQo+IA0KPiA+ID4gKw0KPiA+ID4gIC8qDQo+ID4gPiAgICogVGhlIGVtdWxhdGVkIHN0
YW5kYXJkIG9wcyBtZWFuIHRoYXQgdmZpb19kZXZpY2UgaXMgZ29pbmcgdG8gdXNlIHRoZQ0KPiA+
ID4gICAqICJtZGV2IHBhdGgiIGFuZCB3aWxsIGNhbGwgdmZpb19waW5fcGFnZXMoKS92ZmlvX2Rt
YV9ydygpLiBEcml2ZXJzIHVzaW5nIHRoaXMNCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zm
aW8vcGNpL2hpc2lsaWNvbi9oaXNpX2FjY192ZmlvX3BjaS5jDQo+IGIvZHJpdmVycy92ZmlvL3Bj
aS9oaXNpbGljb24vaGlzaV9hY2NfdmZpb19wY2kuYw0KPiA+ID4gaW5kZXggYTExN2VhZjIxYzE0
Li5iMmY5Nzc4YzgzNjYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vcGNpL2hpc2ls
aWNvbi9oaXNpX2FjY192ZmlvX3BjaS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL2hp
c2lsaWNvbi9oaXNpX2FjY192ZmlvX3BjaS5jDQo+ID4gPiBAQCAtMTM3Myw2ICsxMzczLDcgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCB2ZmlvX2RldmljZV9vcHMNCj4gaGlzaV9hY2NfdmZpb19wY2lf
bWlncm5fb3BzID0gew0KPiA+ID4gIAkuYmluZF9pb21tdWZkID0gdmZpb19pb21tdWZkX3BoeXNp
Y2FsX2JpbmQsDQo+ID4gPiAgCS51bmJpbmRfaW9tbXVmZCA9IHZmaW9faW9tbXVmZF9waHlzaWNh
bF91bmJpbmQsDQo+ID4gPiAgCS5hdHRhY2hfaW9hcyA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9h
dHRhY2hfaW9hcywNCj4gPiA+ICsJLmRldGFjaF9pb2FzID0gdmZpb19pb21tdWZkX3BoeXNpY2Fs
X2RldGFjaF9pb2FzLA0KPiA+ID4gIH07DQo+ID4gPg0KPiA+ID4gIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgdmZpb19kZXZpY2Vfb3BzIGhpc2lfYWNjX3ZmaW9fcGNpX29wcyA9IHsNCj4gPiA+IEBAIC0x
MzkxLDYgKzEzOTIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHZmaW9fZGV2aWNlX29wcyBoaXNp
X2FjY192ZmlvX3BjaV9vcHMgPQ0KPiB7DQo+ID4gPiAgCS5iaW5kX2lvbW11ZmQgPSB2ZmlvX2lv
bW11ZmRfcGh5c2ljYWxfYmluZCwNCj4gPiA+ICAJLnVuYmluZF9pb21tdWZkID0gdmZpb19pb21t
dWZkX3BoeXNpY2FsX3VuYmluZCwNCj4gPiA+ICAJLmF0dGFjaF9pb2FzID0gdmZpb19pb21tdWZk
X3BoeXNpY2FsX2F0dGFjaF9pb2FzLA0KPiA+ID4gKwkuZGV0YWNoX2lvYXMgPSB2ZmlvX2lvbW11
ZmRfcGh5c2ljYWxfZGV0YWNoX2lvYXMsDQo+ID4gPiAgfTsNCj4gPiA+DQo+ID4gPiAgc3RhdGlj
IGludCBoaXNpX2FjY192ZmlvX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qg
c3RydWN0IHBjaV9kZXZpY2VfaWQNCj4gKmlkKQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmZpby9wY2kvbWx4NS9tYWluLmMgYi9kcml2ZXJzL3ZmaW8vcGNpL21seDUvbWFpbi5jDQo+ID4g
PiBpbmRleCBkOTVmZDM4MjgxNGMuLjQyZWM1NzRhODYyMiAxMDA2NDQNCj4gPiA+IC0tLSBhL2Ry
aXZlcnMvdmZpby9wY2kvbWx4NS9tYWluLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdmZpby9wY2kv
bWx4NS9tYWluLmMNCj4gPiA+IEBAIC0xMzIwLDYgKzEzMjAsNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IHZmaW9fZGV2aWNlX29wcyBtbHg1dmZfcGNpX29wcyA9IHsNCj4gPiA+ICAJLmJpbmRfaW9t
bXVmZCA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9iaW5kLA0KPiA+ID4gIAkudW5iaW5kX2lvbW11
ZmQgPSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfdW5iaW5kLA0KPiA+ID4gIAkuYXR0YWNoX2lvYXMg
PSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfYXR0YWNoX2lvYXMsDQo+ID4gPiArCS5kZXRhY2hfaW9h
cyA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9kZXRhY2hfaW9hcywNCj4gPiA+ICB9Ow0KPiA+ID4N
Cj4gPiA+ICBzdGF0aWMgaW50IG1seDV2Zl9wY2lfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYs
DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaS5jIGIvZHJpdmVy
cy92ZmlvL3BjaS92ZmlvX3BjaS5jDQo+ID4gPiBpbmRleCAyOTA5MWVlMmU5ODQuLmNiNWI3Zjg2
NWQ1OCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYw0KPiA+
ID4gKysrIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaS5jDQo+ID4gPiBAQCAtMTQxLDYgKzE0
MSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdmZpb19kZXZpY2Vfb3BzIHZmaW9fcGNpX29wcyA9
IHsNCj4gPiA+ICAJLmJpbmRfaW9tbXVmZAk9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9iaW5kLA0K
PiA+ID4gIAkudW5iaW5kX2lvbW11ZmQJPSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfdW5iaW5kLA0K
PiA+ID4gIAkuYXR0YWNoX2lvYXMJPSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfYXR0YWNoX2lvYXMs
DQo+ID4gPiArCS5kZXRhY2hfaW9hcwk9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9kZXRhY2hfaW9h
cywNCj4gPiA+ICB9Ow0KPiA+ID4NCj4gPiA+ICBzdGF0aWMgaW50IHZmaW9fcGNpX3Byb2JlKHN0
cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpDQo+ID4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BsYXRmb3JtL3ZmaW9fYW1iYS5jIGIvZHJpdmVy
cy92ZmlvL3BsYXRmb3JtL3ZmaW9fYW1iYS5jDQo+ID4gPiBpbmRleCA4M2ZlNTQwMTU1OTUuLjY0
NjRiMzkzOWViYyAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvdmZpby9wbGF0Zm9ybS92Zmlv
X2FtYmEuYw0KPiA+ID4gKysrIGIvZHJpdmVycy92ZmlvL3BsYXRmb3JtL3ZmaW9fYW1iYS5jDQo+
ID4gPiBAQCAtMTE5LDYgKzExOSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdmZpb19kZXZpY2Vf
b3BzIHZmaW9fYW1iYV9vcHMgPSB7DQo+ID4gPiAgCS5iaW5kX2lvbW11ZmQJPSB2ZmlvX2lvbW11
ZmRfcGh5c2ljYWxfYmluZCwNCj4gPiA+ICAJLnVuYmluZF9pb21tdWZkCT0gdmZpb19pb21tdWZk
X3BoeXNpY2FsX3VuYmluZCwNCj4gPiA+ICAJLmF0dGFjaF9pb2FzCT0gdmZpb19pb21tdWZkX3Bo
eXNpY2FsX2F0dGFjaF9pb2FzLA0KPiA+ID4gKwkuZGV0YWNoX2lvYXMJPSB2ZmlvX2lvbW11ZmRf
cGh5c2ljYWxfZGV0YWNoX2lvYXMsDQo+ID4gPiAgfTsNCj4gPiA+DQo+ID4gPiAgc3RhdGljIGNv
bnN0IHN0cnVjdCBhbWJhX2lkIHBsMzMwX2lkc1tdID0gew0KPiA+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdmZpby9wbGF0Zm9ybS92ZmlvX3BsYXRmb3JtLmMNCj4gYi9kcml2ZXJzL3ZmaW8vcGxh
dGZvcm0vdmZpb19wbGF0Zm9ybS5jDQo+ID4gPiBpbmRleCAyMmExZWZjYTMyYTguLjhjZjIyZmE2
NWJhYSAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvdmZpby9wbGF0Zm9ybS92ZmlvX3BsYXRm
b3JtLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdmZpby9wbGF0Zm9ybS92ZmlvX3BsYXRmb3JtLmMN
Cj4gPiA+IEBAIC0xMDgsNiArMTA4LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB2ZmlvX2Rldmlj
ZV9vcHMgdmZpb19wbGF0Zm9ybV9vcHMgPSB7DQo+ID4gPiAgCS5iaW5kX2lvbW11ZmQJPSB2Zmlv
X2lvbW11ZmRfcGh5c2ljYWxfYmluZCwNCj4gPiA+ICAJLnVuYmluZF9pb21tdWZkCT0gdmZpb19p
b21tdWZkX3BoeXNpY2FsX3VuYmluZCwNCj4gPiA+ICAJLmF0dGFjaF9pb2FzCT0gdmZpb19pb21t
dWZkX3BoeXNpY2FsX2F0dGFjaF9pb2FzLA0KPiA+ID4gKwkuZGV0YWNoX2lvYXMJPSB2ZmlvX2lv
bW11ZmRfcGh5c2ljYWxfZGV0YWNoX2lvYXMsDQo+ID4gPiAgfTsNCj4gPiA+DQo+ID4gPiAgc3Rh
dGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgdmZpb19wbGF0Zm9ybV9kcml2ZXIgPSB7DQo+ID4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jIGIvZHJpdmVycy92ZmlvL3Zm
aW9fbWFpbi5jDQo+ID4gPiBpbmRleCAzOWQ1NTJlNTE2MGIuLjU5OWQ1NTFmYzRiNSAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYw0KPiA+ID4gKysrIGIvZHJpdmVy
cy92ZmlvL3ZmaW9fbWFpbi5jDQo+ID4gPiBAQCAtMjczLDcgKzI3Myw4IEBAIHN0YXRpYyBpbnQg
X192ZmlvX3JlZ2lzdGVyX2RldihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCj4gPiA+ICAJ
aWYgKFdBUk5fT04oSVNfRU5BQkxFRChDT05GSUdfSU9NTVVGRCkgJiYNCj4gPiA+ICAJCSAgICAo
IWRldmljZS0+b3BzLT5iaW5kX2lvbW11ZmQgfHwNCj4gPiA+ICAJCSAgICAgIWRldmljZS0+b3Bz
LT51bmJpbmRfaW9tbXVmZCB8fA0KPiA+ID4gLQkJICAgICAhZGV2aWNlLT5vcHMtPmF0dGFjaF9p
b2FzKSkpDQo+ID4gPiArCQkgICAgICFkZXZpY2UtPm9wcy0+YXR0YWNoX2lvYXMgfHwNCj4gPiA+
ICsJCSAgICAgIWRldmljZS0+b3BzLT5kZXRhY2hfaW9hcykpKQ0KPiA+ID4gIAkJcmV0dXJuIC1F
SU5WQUw7DQo+ID4gPg0KPiA+ID4gIAkvKg0KPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGlu
dXgvdmZpby5oIGIvaW5jbHVkZS9saW51eC92ZmlvLmgNCj4gPiA+IGluZGV4IDQzMWViODJlMDU5
NS4uZjQ0NmY1OTAxZTQ2IDEwMDY0NA0KPiA+ID4gLS0tIGEvaW5jbHVkZS9saW51eC92ZmlvLmgN
Cj4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvdmZpby5oDQo+ID4gPiBAQCAtNzQsNyArNzQsOSBA
QCBzdHJ1Y3QgdmZpb19kZXZpY2Ugew0KPiA+ID4gICAqIEBiaW5kX2lvbW11ZmQ6IENhbGxlZCB3
aGVuIGJpbmRpbmcgdGhlIGRldmljZSB0byBhbiBpb21tdWZkDQo+ID4gPiAgICogQHVuYmluZF9p
b21tdWZkOiBPcHBvc2l0ZSBvZiBiaW5kX2lvbW11ZmQNCj4gPiA+ICAgKiBAYXR0YWNoX2lvYXM6
IENhbGxlZCB3aGVuIGF0dGFjaGluZyBkZXZpY2UgdG8gYW4gSU9BUy9IV1BUIG1hbmFnZWQgYnkg
dGhlDQo+ID4gPiAtICoJCSBib3VuZCBpb21tdWZkLiBVbmRvIGluIHVuYmluZF9pb21tdWZkLg0K
PiA+ID4gKyAqCQkgYm91bmQgaW9tbXVmZC4gVW5kbyBpbiB1bmJpbmRfaW9tbXVmZCBpZiBAZGV0
YWNoX2lvYXMgaXMgbm90DQo+ID4gPiArICoJCSBjYWxsZWQuDQo+ID4gPiArICogQGRldGFjaF9p
b2FzOiBPcHBvc2l0ZSBvZiBhdHRhY2hfaW9hcw0KPiA+ID4gICAqIEBvcGVuX2RldmljZTogQ2Fs
bGVkIHdoZW4gdGhlIGZpcnN0IGZpbGUgZGVzY3JpcHRvciBpcyBvcGVuZWQgZm9yIHRoaXMgZGV2
aWNlDQo+ID4gPiAgICogQGNsb3NlX2RldmljZTogT3Bwb3NpdGUgb2Ygb3Blbl9kZXZpY2UNCj4g
PiA+ICAgKiBAcmVhZDogUGVyZm9ybSByZWFkKDIpIG9uIGRldmljZSBmaWxlIGRlc2NyaXB0b3IN
Cj4gPiA+IEBAIC05OCw2ICsxMDAsNyBAQCBzdHJ1Y3QgdmZpb19kZXZpY2Vfb3BzIHsNCj4gPiA+
ICAJCQkJc3RydWN0IGlvbW11ZmRfY3R4ICppY3R4LCB1MzIgKm91dF9kZXZpY2VfaWQpOw0KPiA+
ID4gIAl2b2lkCSgqdW5iaW5kX2lvbW11ZmQpKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldik7DQo+
ID4gPiAgCWludAkoKmF0dGFjaF9pb2FzKShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYsIHUzMiAq
cHRfaWQpOw0KPiA+ID4gKwl2b2lkCSgqZGV0YWNoX2lvYXMpKHN0cnVjdCB2ZmlvX2RldmljZSAq
dmRldik7DQo+ID4gPiAgCWludAkoKm9wZW5fZGV2aWNlKShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZk
ZXYpOw0KPiA+ID4gIAl2b2lkCSgqY2xvc2VfZGV2aWNlKShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZk
ZXYpOw0KPiA+ID4gIAlzc2l6ZV90CSgqcmVhZCkoc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2LCBj
aGFyIF9fdXNlciAqYnVmLA0KPiA+ID4gQEAgLTEyMSw2ICsxMjQsNyBAQCBpbnQgdmZpb19pb21t
dWZkX3BoeXNpY2FsX2JpbmQoc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2LA0KPiA+ID4gIAkJCSAg
ICAgICBzdHJ1Y3QgaW9tbXVmZF9jdHggKmljdHgsIHUzMiAqb3V0X2RldmljZV9pZCk7DQo+ID4g
PiAgdm9pZCB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfdW5iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAq
dmRldik7DQo+ID4gPiAgaW50IHZmaW9faW9tbXVmZF9waHlzaWNhbF9hdHRhY2hfaW9hcyhzdHJ1
Y3QgdmZpb19kZXZpY2UgKnZkZXYsIHUzMiAqcHRfaWQpOw0KPiA+ID4gK3ZvaWQgdmZpb19pb21t
dWZkX3BoeXNpY2FsX2RldGFjaF9pb2FzKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldik7DQo+ID4g
PiAgaW50IHZmaW9faW9tbXVmZF9lbXVsYXRlZF9iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRl
diwNCj4gPiA+ICAJCQkgICAgICAgc3RydWN0IGlvbW11ZmRfY3R4ICppY3R4LCB1MzIgKm91dF9k
ZXZpY2VfaWQpOw0KPiA+ID4gIHZvaWQgdmZpb19pb21tdWZkX2VtdWxhdGVkX3VuYmluZChzdHJ1
Y3QgdmZpb19kZXZpY2UgKnZkZXYpOw0KPiA+ID4gQEAgLTE0NSw2ICsxNDksOCBAQCB2ZmlvX2lv
bW11ZmRfcGh5c2ljYWxfZGV2aWQoc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2KQ0KPiA+ID4gIAko
KHZvaWQgKCopKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldikpIE5VTEwpDQo+ID4gPiAgI2RlZmlu
ZSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfYXR0YWNoX2lvYXMgXA0KPiA+ID4gIAkoKGludCAoKiko
c3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2LCB1MzIgKnB0X2lkKSkgTlVMTCkNCj4gPiA+ICsjZGVm
aW5lIHZmaW9faW9tbXVmZF9waHlzaWNhbF9kZXRhY2hfaW9hcyBcDQo+ID4gPiArCSgodm9pZCAo
Kikoc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2KSkgTlVMTCkNCj4gPiA+ICAjZGVmaW5lIHZmaW9f
aW9tbXVmZF9lbXVsYXRlZF9iaW5kICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQo+ID4gPiAgCSgoaW50ICgqKShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYsIHN0cnVjdCBp
b21tdWZkX2N0eCAqaWN0eCwgICBcDQo+ID4gPiAgCQkgIHUzMiAqb3V0X2RldmljZV9pZCkpIE5V
TEwpDQo+ID4NCg0K
