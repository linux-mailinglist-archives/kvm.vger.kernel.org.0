Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4086D6AFF8F
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 08:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjCHHRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 02:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCHHR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 02:17:29 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5A8A8E9F;
        Tue,  7 Mar 2023 23:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678259835; x=1709795835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UkkqVl8Wqt5WSbQQ2w0TmqNBO9qJu9Rs0dsl+4p5x8c=;
  b=CEOxUhzSjqebXmf/vnmBVPrJlPgpgLJa033sgVpgJdz0e1oGuUIjeM0v
   E1OsyURl/+A76o1LkhlWZcKAuIUCivoJXCTVRyHVK3g4nahHgRzmgeb3A
   QZaL6khHgi8XPg3q2Nlh98cl1S9HI6AYKjyW5FZZa8u2juzCqs2ZHBn9g
   VpCQqdBnlGh4o885HIHdrj5yP60P6JK0XENvkix3EIK5pQc5X6N6Dj/Eq
   CigvV/W3ARQORNmgAxctztEWfSwDUz21EY7WcrqZ+UUGp6Qx7iczBF7Gq
   NOWK1o2UYDt8k5zRlKeejg0qWd4uYTlT4qTRL0TPV2TGBFkEJN390Xfgk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="334799728"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="334799728"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:17:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="676865283"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="676865283"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 07 Mar 2023 23:17:13 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:17:13 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 23:17:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 23:17:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0gR5Zaz4FRNW3zzT3mpI59WtoeV9LXgvp3/IMEOzZxqg6IOq2Y0qpPOVFe/8SGxuAR99pL94d6hMmOxQm6Ov5eUttSs8gWQimK/d5fRkqdPVUez+eaOfj7OkTCygDuH1d7Y8IcGudaqbR1YDKpEXbztO8nRwcZ7B7bbV9+yFRb8FF/EC9TnTw8c9c3ni/+h0ag2xcdMEElnwBHyB6/r5zOdHtnVsJtSAUSw3BS/V8sdq9HAljjUEWuYPEJl3oT6Pj7OR/cYsw0ptOLykhvkSIM7fY0iDBhUiCtcyOQmmR/L3K3Hw8gshqmfaOYXdtSXM8nNk7azjt9lMhzA0S7S9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkkqVl8Wqt5WSbQQ2w0TmqNBO9qJu9Rs0dsl+4p5x8c=;
 b=e6a9gDSx09lV+0EA8A/DOYCATy8IciWW1algV58fdNOGDXcT60/253fonYxzkrtBblSpNIDYPQ/x/dE+JVrO6MOrYpF8UNhHQyce78olM8ZQzymYvdlatGcmV47L+sZS1SR5FigO+XDemvViuwVSpRJPLbzh+5hNfH+mLpNIUbznxnR+H1JWUig2Mw8O2HAMojI3PS5tcZj5ngLJZYXHObZ/NDmWUlIfj8RZdT5LhKMkdUIF0iWZ1UnhPX8ITqpJWnwajf92TxAm9XSfoCX0y7sRHCHwy9oVk8M4NH08JP2kJJJeWuYkzpXwXknZxBnIRja4KBwBWaZVqjL5+4bssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6563.namprd11.prod.outlook.com (2603:10b6:510:1c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 07:17:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 07:17:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxPC+MDBUMQo0WSWqpmOLb9+K7lqIaAgACN44CAAm82AIAGQfhggABmeoCAAAdAAIABL8HQ
Date:   Wed, 8 Mar 2023 07:17:09 +0000
Message-ID: <BN9PR11MB5276BA0C23E7F3D2B5AF5BA18CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/+Pkbtr8KQmUjVp@nvidia.com>
 <DS0PR11MB7529E16DC2B558E8476D835FC3B39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52760241BBD8D6D670BD17D98CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcwJSK/9UVI9LXu@nvidia.com>
 <DS0PR11MB7529B4EFE9DCF2991F220A65C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529B4EFE9DCF2991F220A65C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6563:EE_
x-ms-office365-filtering-correlation-id: 990b5e3a-050b-4580-1d7f-08db1fa52145
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hAYi92F2BIys/H3cwb7nDeWOxPpldQ+9dDc5hxPq1ly6Z79RZTKl2Zuc+pzOTyp67e0ds4qQPi5me/ZavU6GewIZNJW02UBfRGwHN769SY3vw2h5yDe/pdy0FTTKcdyTA94kQ6qq7c767FWI7/xbva7XhXllz/7vnsaKmehKmm7YqPb2zmlcUpLUJARkkibT53fo5d/el3PQ/FV9vH8+wBgUtGK4hrjGevHxB22Z6HGF0g7VBHjFPSkWAwsJSVx9taHIVCo9D4iDlzsMx1nN9EZ5dFIM41DKXjzeoNVwxaDcwgqL1lXbdXut+Yjng5cG1aiWp8b3JjFqGJ94PBYq/WZfw0jyNtuGJ6PSezQrogv9xgHm1ZRZp6ban+X5qh3KoRfau6MO8LZ7ZtgqYu4N+nPtIP7n5StYRSulano5+QtLlS5RZPxRch2qQdHNACdC5WOtuORRS/e/s7Vw+93W7ms+3YEgk0AyHmYjW0sVEuyeQUInwY0maWqtQQFC7jpgb3e4+HnMsTChxrG085sa9xej/5hCPbH34N+b4iIfO2jSuM+eI5HacWHPAHU1MzAlRa+OwJYJpKv4g6/K5ljDmqpYNQzmExPzyzM0jyzx/0GscospNY2IC0KFvx58xELtYscvbURZ3nRuJtKhDfaPE6y1U+BkfNj9LSQaWSg50ihqKb0owoJDZRr6bCMpwq4b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199018)(7416002)(5660300002)(478600001)(86362001)(9686003)(71200400001)(6506007)(186003)(2906002)(26005)(33656002)(7696005)(966005)(83380400001)(55016003)(76116006)(64756008)(82960400001)(66446008)(66556008)(66946007)(122000001)(8676002)(4326008)(38100700002)(66476007)(52536014)(38070700005)(8936002)(316002)(54906003)(41300700001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkZ6TVRLTnhCTW1lb1psYk1KUWRzR0VDUXVJMDJIVG5SS1FwTklzOTFCeCtk?=
 =?utf-8?B?a1BXZGVDWUdTYkVObHZySGtCUlBibEdZMGVqbys4OEl4RmlvZkVsOFRsWG92?=
 =?utf-8?B?VjhheFI0QTJJUjhTdEV4dmQ1eFpMTTF3UVVubkZxbnRCOUZuZFZyck5EUVZl?=
 =?utf-8?B?ajEzTU0ycjV1QnJpL01HKzN2ZmJDT1hpUWxjTWNPSjRYZTg4eDZ3bWo1ajFa?=
 =?utf-8?B?RjI1MEhscVgzd3RqOHlHMnZTc2dITXdqd3FkcS95MXFpMlUzUzJOcEhsU0JO?=
 =?utf-8?B?K2pIaGJSUXhZdnEydy9GZmI5TkxmeW9tNEpKaURKdElmUDN0cGJQVlovMDJB?=
 =?utf-8?B?RUVtZ3B1RUNjcnJqMGVLenNjR21OTWRTNldYNmFFM0RmMnIxY3kvQnFFb0xS?=
 =?utf-8?B?LzlyaTduL0dTbGQzVTYzMWZnMkpPNFpnMTIrRXdzc3JuL0tFRDNVSXU1N2Zy?=
 =?utf-8?B?VFBmZHVoaVpyV2VGMjk1N1NpdFJVdkNtMVlmWjQzTTViK0taY1oxNkl6dm9l?=
 =?utf-8?B?LzB4eG9HemlVSjZvWjhaTXhoeHhhbVlWaWwzdWNCcXcxMXJXMkNiVzNETmxT?=
 =?utf-8?B?bklsa0c4RWNEYjRvM0k3U3VqbFoxbnBTOXpydkVxN3BjVzZuZ1VGKzhVak5v?=
 =?utf-8?B?S3pBaWQ5TFlkd3dMdDhuUithMlA3NXpOOVFPdXJGOVkyVGRSbXpIS0cyU2E3?=
 =?utf-8?B?V2t6YzFDOEFOTFc3QnFSdHE1WURsbGxhdEVsb3JWQ2kwZkROVFVvdW5jYWJF?=
 =?utf-8?B?VHhrN3E1clh6dGdQUHo3VmlIR1Qxc3Y2NHlYK0pkcGtYalpwaEx4VlEyQ0Jo?=
 =?utf-8?B?RVh5bmo3Q2JGTUcyTG5mRENYMGEza2FMYXJoM1FiTmpqc1QrcTVFUEJPcVZy?=
 =?utf-8?B?WkRuUmJrTzJDYzAzTS9kcVM3ZXpZMGdTeVZKeC9Fay92U1BKd01lMktnSE8y?=
 =?utf-8?B?YU9rZlVXZEhFS1VvVERqWHcyTzN5SUhjaU0vU2JsaXVQYjl4ZG9YVi9SMXhI?=
 =?utf-8?B?WEptN3ZTL0phcnAwalVacThuUk5kbit1NnQ5MWc1YWhYSWxDVHZNdFhUVExO?=
 =?utf-8?B?eVFhaHVpZkVkTldNMjlLWGdlem9qMXFSYmdrT0Mya0JOZ0hCTXViVU91ZHRX?=
 =?utf-8?B?bU1hKzR3dlFKZDg1cFFYQnVLNkRhT3VEa3U5SU5uak9WQXpTQUluV0ZDQUpn?=
 =?utf-8?B?aENuYWw0WGEwMlErZTFHWjh5bmdZRUtxdWNPakxEZFNjejBqTXNoSkduTi9K?=
 =?utf-8?B?VkpMVVRFRTFnUGFhalVPSGVka2kycDkwbWppUkRuUTRhbDk0SjB6VW02UlZt?=
 =?utf-8?B?Y2U4Sy9ZWXd0ZTdJY0diOXcrSGNrLy91S21ZRGN0Uk9SZ3N3V04zWUFncUg4?=
 =?utf-8?B?Ni9HYklzU3kyKzdPdTF4ZERtQWcwbmM0TVlDZ3NYbFQySDRBTkNROVpQMTh0?=
 =?utf-8?B?czBlTmI0bStPTThCVUJuQTlrYWxLRlloTTlWbDhJNGd4UWIvdmZBOXRuVlk4?=
 =?utf-8?B?Q043cmZ0T3VxVFdoR1pYWGVLMmdaK2I1a3hYRGVnaVhhcWdPSVBCOUJ5NU9z?=
 =?utf-8?B?aGJxMjNITGxrUHIzb1FHSjM2R2xaTG81Rlo5TU5Gd3Q4YXJqVTI2cnVTMTdh?=
 =?utf-8?B?M0tJc0djOGNzdTlnMmU5SEhVTUtmUXowUjZYdlR5U1Btd3dPR2VRcEFocG9W?=
 =?utf-8?B?YkxRclJRd25tWEp0dkMwc09SMnhIY2hGV2x4c0ZFdGlOOHhieHNlRTJyVmdI?=
 =?utf-8?B?TWp6SVVGSDVXMU5mUVZvVXZJSXZIZ0x2ZmNMcXBudElsMXFLV0Ftek5uSVpq?=
 =?utf-8?B?ajVpd3VvNi9zLzl5d1NOTndPQVIxUWl6K01mZnlodGpZeHp2dFBoTDdVaGRO?=
 =?utf-8?B?OXRKY0MrcldlWUUxUVZGRTdBNFRKSjZSN0k5blN1N0hYNXdVaCtZZUhFTjZt?=
 =?utf-8?B?cUpjTHhSQUNPU2RjVUFYdDcxN284TmJKd2U4TSthNTQ3VENFOEVIMktXRzBv?=
 =?utf-8?B?dkpLK0RVcjVlcXNBSURqM1JTelNaUUtjcHl6VmE2bmRVUnhNZk40NEhjbFpp?=
 =?utf-8?B?SHNSdDU5S0NZcFN1V1dHN1lQTTNoSDFQcnhvamJDOHRCdXhvN2J0MmlwS1Jq?=
 =?utf-8?Q?DxmYvc/C2U814BxpWPaylrKgg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 990b5e3a-050b-4580-1d7f-08db1fa52145
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 07:17:09.1143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PCFDs23sV3gu5bElejXwYJILf2Af2Kt4DDf+NDspC7ovAyvYKAm2HmvImcSN7WmR8CtJzXb4rXzKqpug9MVUFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
TWFyY2ggNywgMjAyMyA5OjA0IFBNDQo+IA0KPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdn
QG52aWRpYS5jb20+DQo+ID4gU2VudDogVHVlc2RheSwgTWFyY2ggNywgMjAyMyA4OjM4IFBNDQo+
ID4NCj4gPiBPbiBUdWUsIE1hciAwNywgMjAyMyBhdCAwNjozODo1OUFNICswMDAwLCBUaWFuLCBL
ZXZpbiB3cm90ZToNCj4gPiA+ID4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+
DQo+ID4gPiA+IFNlbnQ6IEZyaWRheSwgTWFyY2ggMywgMjAyMyAyOjU4IFBNDQo+ID4gPiA+DQo+
ID4gPiA+ID4gV2hhdCBzaG91bGQgd2UgcmV0dXJuIGhlcmUgYW55aG93IGlmIGFuIGFjY2VzcyB3
YXMgY3JlYXRlZD8NCj4gPiA+ID4NCj4gPiA+ID4gaW9tbXVmZF9hY2Nlc3MtPm9iai5pZC4gc2hv
dWxkIGJlIGZpbmUuIElzIGl0Pw0KPiA+ID4NCj4gPiA+IFRoaW5raW5nIG1vcmUgSSdtIG5vdCBz
dXJlIHdoZXRoZXIgaXQncyBhIGdvb2QgaWRlYSB0byBmaWxsIHRoZQ0KPiA+ID4gZGV2X2lkIGZp
ZWxkIHdpdGggYW4gYWNjZXNzIG9iamVjdCBpZCBhbmQgdGhlbiBsYXRlciBjb25mdXNlDQo+ID4g
PiB0aGUgdXNlciB0byBnZXQgYW4gLUVOT0VOVCBlcnJvciB3aGVuIHRyeWluZyB0byBhbGxvY2F0
ZSBhDQo+ID4gPiBod3B0IHdpdGggYW4gYWNjZXNzIG9iamVjdCBpZC4NCj4gPiA+DQo+ID4gPiBI
b3cgY2FuIHVzZXIgZGlmZmVyZW50aWF0ZSBpdCBmcm9tIHRoZSByZWFsIGVycm9yIGNhc2Ugd2hl
cmUNCj4gPiA+IGludmFsaWQgaW9tbXVmZCBvYmplY3QgaXMgdXNlZD8NCj4gPiA+DQo+ID4gPiBJ
dCBzb3VuZHMgY2xlYXJlciB0byByZXR1cm4gZGV2X2lkIG9ubHkgd2hlbiB0aGVyZSBpcyBhIHRy
dWUNCj4gPiA+IGRldmljZSBvYmplY3QgYmVpbmcgY3JlYXRlZCBieSB0aGUgYmluZF9pb21tdWZk
IGNtZC4gVGhlbg0KPiA+ID4gdGhlIHVzZXIgY2FuIHVzZSBpdCB0byBkZWNpZGUgd2hldGhlciAg
dG8gZnVydGhlciBhdHRlbXB0DQo+ID4gPiBkZXZfaWQgcmVsYXRlZCBjbWRzLg0KPiA+DQo+ID4g
SXQgbWVhbnMgd2UgY2FuIG5ldmVyIHJldHVybiBhbiBhY2Nlc3NfaWQNCj4gPg0KPiA+IEkgZG9u
J3QgdGhpbmsgdGhpcyBpcyBhIHByb2JsZW0sIHRoZSBmaXJzdCB0aGluZyB1c2Vyc3BhY2Ugc2hv
dWxkIGRvDQo+ID4gaXMgYSBnZXQgaW5mbyB0byB0aGUgZGV2X2lkIHdoaWNoIGlzIG5lZWRlZCB0
byBsZWFybiB3aGljaCBpb21tdQ0KPiA+IGRyaXZlciBpcyBydW5uaW5nIGl0LCBpZiB0aGF0IHJl
dHVybnMgRU9QTk9UU1VQUCB0aGVuIGl0IGlzbid0IGENCj4gPiBwaHlzaWNhbCBpb21tdSBkZXZp
Y2UuDQo+IA0KPiBUaGlzIG1heSBtZWFuIHlvdXIgYmVsb3cgcGF0Y2ggZGVwZW5kcyBvbiB0aGUg
Z2V0IGluZm8gc2VyaWVzLiDwn5iKDQo+IEFsc28gbmVlZCB0byB1cGRhdGUgdGhlIGRlc2NyaXB0
aW9uIHRvIHRoZSBpb2N0bC4NCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWlv
bW11LzEyLXYxLTc2MTJmODhjMTlmNSsyZjIxLQ0KPiBpb21tdWZkX2FsbG9jX2pnZ0BudmlkaWEu
Y29tLw0KPiANCg0KUHJvYmFibHkgbm90IG5lY2Vzc2FyeS4gSXQncyB1c2VyIHRvIGdldCBpbmZv
IGFuZCB0aGVuIGNyZWF0ZSBod3B0Lg0KSSBkb24ndCB0aGluayB3ZSdsbCBldmVyIGFkZCBhIGNo
ZWNrIHdoZXRoZXIgdGhlIHVzZXIgaGFzIGFjcXVpcmVkDQp0aGUgaW5mbyBiZWZvcmUgY3JlYXRp
bmcgdGhlIGh3cHQuIEZyb20gdGhpcyBhbmdsZSB0aGVyZSBpcyBubw0KZGVwZW5kZW5jeSBpbiBj
b2RlLXdpc2UuDQoNCk15IGVhcmxpZXIgY29tbWVudCB3YXMgYmFzZWQgb24gdGhlIHVzZXIgY3Jl
YXRpbmcgaHdwdCB3L28NCnF1ZXJ5aW5nIHRoZSBpbmZvLiBMb29rcyBpdCdzIGp1c3QgdXNlcidz
IGpvYiB0byBtYWtlIGl0IHJpZ2h0LiBXZQ0KbWF5IGNsYXJpZnkgdGhpcyBwb2ludCBpbiBod3B0
X2FsbG9jIHVBUEkgY29tbWVudC4NCg==
