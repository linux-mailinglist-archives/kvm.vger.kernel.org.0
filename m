Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C56D8ED4
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 07:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjDFFcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 01:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbjDFFcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 01:32:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF67693ED;
        Wed,  5 Apr 2023 22:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680759120; x=1712295120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+RSN4l1FRg5tElMFHlBWXpmdA2lP1/T8qtU/05H+c4Y=;
  b=HIbT93akLfKk7ZcCjYl/dN4URvtqtrx1+GHEvMcLZZEYdHkMg6TDubgp
   ftOW8VXZ5W/1N//8sv6Px+5xBSmvnyt9ZXlu75Gla7qM+34f55AAwD5n4
   0Eh87xatMi+yTXIHl2iVegg1hxsgST/anWne6P9YL9A3q9LcU4vSrk0nx
   nVWzmjDpAdqYu5J0gOs8MMu+MDSYzpOPA6nTJvwkcCKCVldObwonhIMzV
   jZ2zZgshhP/CPO8QlynKakoQxt00fd1NaIAPywG5Ma4KlsqtYpQJTM0aJ
   wo+0ZTfDHLwPIINCh+rgvqyMK9nW0Qh/EwCGV8W4UXrlGedhoFuofj3o/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="326685292"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="326685292"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 22:32:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="810869026"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="810869026"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2023 22:31:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 22:31:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 22:31:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 22:31:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXOOMzBkOQU7WyKQpyNweKDUyV4cLeW4QJxgd6rsZJlSg/KmlcULMRHm1CdcDRqAydZplDgKyugaCgXF6rkS5+nyiMzQrMxUPkPD/XJPQLg9xms3KArx7KDt2q86BoLFbt5cKJ8mbmtDyfVncDnHbsLGYlUtqxi16YwOz9dDsyttslwV8nxq3S2MuSuC4TPsLddDjeArW/hsOhdZm3F3ZrUKIxvMFBey7g/oul+w5KOSYpIJExv0NJlXwaVJu9s2H/WDjl1tDajhgsuXRRGzRmNbFExe91My2l30TEB2dRuenPKjfLU9VVbjAlwMyhdJ3VY3jTAyD+NJ4uAAzzwrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RSN4l1FRg5tElMFHlBWXpmdA2lP1/T8qtU/05H+c4Y=;
 b=B45togGMTZaIzvTYky+5kOBwbp9orwaQ4ngNs3MyG9LqRl1p4TYt1ATH581toNdIXO2J6twM/w4j2fwR6wlWbFI9nsCNkfmJzRuDTLfhdPodm6h+uXrI+620B0aJI7a4qB5qB9thcJxQ/tXr/F199PbHnRbH0uuHBjJ8o5u3kXP4Lri/PbGGrwMN+6P6P0irXlb3W6PtmFa25K7kyCNv/Upa9ePyzsQtBAeCqw7UoXYSnulp/Yr2CnyI6DOtS27YVafq592AKUTXP0jJrmMHrBGfggzj8hO1mzvEqZfdOQSfpFmIF6QjoTJ9sjBIy9Q0OEdPmeYJ8kCeiU97I8yKTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB8179.namprd11.prod.outlook.com (2603:10b6:8:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Thu, 6 Apr
 2023 05:31:56 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 05:31:55 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAGdGAgADAhkA=
Date:   Thu, 6 Apr 2023 05:31:55 +0000
Message-ID: <DS0PR11MB752979133CAE037FD09222FEC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
 <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405102545.41a61424.alex.williamson@redhat.com>
 <afbfbfe5-5334-6e18-6211-a3908816dc6e@redhat.com>
In-Reply-To: <afbfbfe5-5334-6e18-6211-a3908816dc6e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB8179:EE_
x-ms-office365-filtering-correlation-id: 1a96555e-7e7a-4190-eb1a-08db36603c23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JTuC/E95OFaZAZiEuccUV0fi9riNtQmeyQ6rtudSiovjUqRfmJ4CEwvA7wcnNA0iLn63111lcitK3XAp48hnFjZdAPCKZzUdXYkimk4gyVAyOqFcsUs2CluVBAHHm42JDcfgW2GRFXHB8rdhWjCMPn6Tt3XaQr8Q3mwvgk7ijw/UWfTikgbs7GBXNSnrhIA6l/TBcR1PLyL3Xi8CYg/Fm5ZXd150XHtfLAT8OGvpr8e7hP01/VfmEkuFmqNCwHJKj0cVvas9/5V26LraIWNsjaUocs8nDD93GMuSt5iGiUsbcJto1+uFEnV0rXtosGXQoGEnQya36Tudv4R6JtTyjd3F1bvRuhlKdwTi7bvbxy9alAqlUGLgVLe1l2PN1I/xFAOSd4NuQMuz1/ywMEXTO7nTCNlzO/bIlr3VOeNawMcqBcdUKmR8Yf8EvMwJvXgo3WqPu8hCAhItNBj1I5L5U9rNUPGYV9GW41xAg7SMKZxcLJImDFut8wrPm/gJPws+/Tx2/gI3aSnf93PZP7QBhJUzH7nBrbUzq4QZA+YVJQoGDBX+nLkPQJkg85556v1Kw9NniaAdzuyrE4BiG7+W0ivtB0kcIMllGxrra4DLj/2deZt4eSwp4yZoNNgD1x4QsA/vgvHP3c+C5qMJo++FRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199021)(82960400001)(71200400001)(38070700005)(122000001)(38100700002)(7696005)(86362001)(33656002)(55016003)(186003)(54906003)(9686003)(110136005)(26005)(2906002)(6506007)(66946007)(76116006)(5660300002)(66556008)(8676002)(41300700001)(66476007)(66446008)(478600001)(7416002)(52536014)(8936002)(316002)(64756008)(83380400001)(4326008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXhqTVdSYVNYWG1xbkFhSGdnYmtRZGNxV0E3amtYZkFIWlkyWXNOcXl6RnpL?=
 =?utf-8?B?ckZiOGtpNUlEZnNMaWwyR0lmblZLTUpwM1VYTEp6akFDbVQ5d0RnMlg3MktI?=
 =?utf-8?B?aXpMVjJEekVGVzRMa0Jkd2xhR1BOQjIvbWQ5bHl3cTV3TzMxZi9kTlZRdG40?=
 =?utf-8?B?eWJKeEtBclJuRnZCdFFZSDJZeCtZWEpzV00wN29iWllOVjdqOHplSmRBckFn?=
 =?utf-8?B?eExYRXRUeTFEZDNVVHViZ0JwVGNQbEwrcDVDVjhjRm5ZZndtWkxrVXJVY05Y?=
 =?utf-8?B?U1VRUmo5Y3Nib3pSYkRPaG9CQ2RCYW1oWkRlUnhvSjdRZ1lTN1NmNVgreG9S?=
 =?utf-8?B?ckhzK2JEVG80OHBLZlJiS29vVU8zSE1NWms3d3VSSUtHT3dtMjljZUhIQ3A0?=
 =?utf-8?B?VmtPd2FaTmJQcVdaS0VhOE5BTEE1OFpUT3hxYU55V3NvRWlJSjN0MTd2UEFE?=
 =?utf-8?B?cTFGdU1BU2twK3RIV1BvdmFyWGQvRk5ZdFJYTTQ5RU1UV1p5bEhBVmVSNVJP?=
 =?utf-8?B?ZDl0ZnBad3BkcHBQNk9BOG1yNysyOU1aSzJIREl1Mm9adlNqRHdIUGtZc3Yv?=
 =?utf-8?B?WG9iNW11OEJRc0NNaVFad3BaMmE2NVk4c0dPNE5xNDErWjBLQW5NaGsya2k0?=
 =?utf-8?B?bzRsZm9aNnVEdEViZnVBci9MNGloVUdkYkxJc3pUTVhWMXhpdzdNd1J6U2xj?=
 =?utf-8?B?RWdBU3VKRXd0V0tFWTZNMW14cExIRTM0RHJLRHZZWjhtU3BIY2E4WnFmc3VT?=
 =?utf-8?B?azVEL0FJQ2RxQkdta3BGTkxLT0daL0xyc0FwZmJSV1c3bkR1bWNZV2FxQS9j?=
 =?utf-8?B?NC94TEw5UnhRNkQrWm9ybk5uK0E2WWlaWUd1UWdObXVDS2VEei8wYlFVdHJL?=
 =?utf-8?B?NEV2RkdUeWlLaWI1ZU5qMjhqZ3A3RVUrVVFpbUVxUjJKeGFMZVI1QmpyRzdo?=
 =?utf-8?B?Zmh5c3dZb0lwdGszc3MvYVkyNGhCVXcvb2R4ZGFNUzA4b3d3cDdpMmlHVUFH?=
 =?utf-8?B?Q0tidDZKUnluSXVCeEtCekVOZGhLaS9BTXQwYStqTnlzazArVkV4WFFqMVoy?=
 =?utf-8?B?Rm1JK2J6aGJwR0FmMUQxamVOU0pWUmZyeFhWa3N3a3FQbWRLYU1PSFZKVDBO?=
 =?utf-8?B?U0Y1Tm5JUW5EQXoyWnRsb0pBM21zVHo4QkUzQk1WcWdEWisyeXFXSEIwQTRa?=
 =?utf-8?B?clJaelA5WEwxa2xEa25qbHZXSW1LNlF6NEpydEczTFRXdFhEbUR1T1R4b2Fm?=
 =?utf-8?B?VGl6MkNhK051eXlUOWVsZE1XNnVpZGpFQitwSCtabzJKenN6d0RhcVBxSGV3?=
 =?utf-8?B?aTNiVkZFNWZET3dDaTV6RmpKYmpUNXI0ZkgvQXVuN0t6eCtqQ09UVCtTK2Nn?=
 =?utf-8?B?NkVFR3NoU0RlVVFRcTZORnRzdDVDb241NHArV0FWUWRYV094MlA2bFZVU3du?=
 =?utf-8?B?R1cvS3pEdFNrZEVxMGJheUJlc2docW9ubGtudFNoVnA5Q09rV0ZGdDRlZXo0?=
 =?utf-8?B?a1JsMGc2RzFMTlRzNitPUmE2eGFsSHdHSE15RFRmTWJDR3Bmb29tREJRY0tT?=
 =?utf-8?B?ZUQrdTVyNVdOOGdEWFN3VVlpVlpMRjZQU01WOWFCRTFTQStKUWEyVzJJOFYx?=
 =?utf-8?B?T3M5SWU2SHlNZklpU0JzWFVmcTF0bXloNnNjVlFBbmUwYWd4MmNXRnNIV25J?=
 =?utf-8?B?YUVnV25FaGtROEZNQjdJWTBoS0ZWMHRGUm1JV3FvbHlsRUtnZjRkeWRqVXdy?=
 =?utf-8?B?YS9SQXJkaitDUHQwSXJQQTlWUHVQai9ZQTVMcUdXbWxtdFJxcmlQVURoTzZR?=
 =?utf-8?B?elUwSlFhc0VnaGR0NlVrZ1c3dFFDTFc2RWcwOTE0TDdWb21zVmFqSTJQVXNi?=
 =?utf-8?B?MzdJbWN2V29vSDFzRmNQeHd3Yk1MSDBTdFlvQlNkS20yd0daeTdjWTBmSkRB?=
 =?utf-8?B?d0lKVjZpUmw4bXdPNlZWckduOXJNU1lkSFpwYzUzQTVwYUU0blBKUy85ZG9K?=
 =?utf-8?B?Y1pJVERhcXRWRjZQV3FXU0JJNHVLdFJLRFlqRVplK01sYjByVSt6eElGRm5L?=
 =?utf-8?B?eGhCUjM2eWZYalNMZ3BWVXlHa3FtWVhiS3NJZU4vL29UeXpYT0J6R29Rb1lu?=
 =?utf-8?Q?1QJfToa3EImtZ2Q1KK5g36xcr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a96555e-7e7a-4190-eb1a-08db36603c23
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 05:31:55.6547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGBJUMcfErflnvGSnwWiZeFzrIB/WRzUiLcV+2Su89RxtG6f9eUgaR2s/X8UR3W3x7xGkS0/gL52mgD3pSIe8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCA2LCAyMDIzIDE6NTggQU0NClsuLi5dDQo+ID4+Pj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggYi9pbmNsdWRlL3VhcGkvbGludXgv
dmZpby5oDQo+ID4+Pj4gaW5kZXggMjU0MzJlZjIxM2VlLi41YTM0MzY0ZTNiOTQgMTAwNjQ0DQo+
ID4+Pj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+Pj4+ICsrKyBiL2luY2x1
ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPj4+PiBAQCAtNjUwLDExICs2NTAsMzIgQEAgZW51bSB7
DQo+ID4+Pj4gICAqIFZGSU9fREVWSUNFX0dFVF9QQ0lfSE9UX1JFU0VUX0lORk8gLSBfSU9XUihW
RklPX1RZUEUsIFZGSU9fQkFTRSArDQo+IDEyLA0KPiA+Pj4+ICAgKgkJCQkJICAgICAgc3RydWN0
IHZmaW9fcGNpX2hvdF9yZXNldF9pbmZvKQ0KPiA+Pj4+ICAgKg0KPiA+Pj4+ICsgKiBUaGlzIGNv
bW1hbmQgaXMgdXNlZCB0byBxdWVyeSB0aGUgYWZmZWN0ZWQgZGV2aWNlcyBpbiB0aGUgaG90IHJl
c2V0IGZvcg0KPiA+Pj4+ICsgKiBhIGdpdmVuIGRldmljZS4gIFVzZXIgY291bGQgdXNlIHRoZSBp
bmZvcm1hdGlvbiByZXBvcnRlZCBieSB0aGlzIGNvbW1hbmQNCj4gPj4+PiArICogdG8gZmlndXJl
IG91dCB0aGUgYWZmZWN0ZWQgZGV2aWNlcyBhbW9uZyB0aGUgZGV2aWNlcyBpdCBoYXMgb3BlbmVk
Lg0KPiB0aGUgJ29wZW5lZCcgdGVybWlub2xvZ3kgZG9lcyBub3QgbG9vayBzdWZmaWNpZW50IGhl
cmUgYmVjYXVzZSBpdCBpcyBub3QNCj4gb25seSBhIG1hdHRlciBvZiB0aGUgZGV2aWNlIGJlaW5n
IG9wZW5lZCB1c2luZyBjZGV2IGJ1dCBpdCBhbHNvIG5lZWRzIHRvDQo+IGhhdmUgYmVlbiBib3Vu
ZCB0byBhbiBpb21tdWZkLCBkZXZfaWQgYmVpbmcgdGhlIG91dHB1dCBvZiB0aGUNCj4gZGV2LWlv
bW11ZmQgYmluZGluZy4NCj4gDQo+IEJ5IHRoZSB3YXkgSSBhbSBub3cgY29uZnVzZWQuIFdoYXQg
ZG9lcyBoYXBwZW4gaWYgdGhlIHJlc2V0IGltcGFjdCBzb21lDQo+IGRldmljZXMgd2hpY2ggYXJl
IG5vdCBib3VuZCB0byBhbiBpb21tdSBjdHguIFByZXZpb3VzbHkgd2UgcmV0dXJuZWQgdGhlDQo+
IGlvbW11IGdyb3VwIHdoaWNoIGFsd2F5cyBwcmUtZXhpc3RzIGJ1dCBub3cgeW91IHdpbGwgcmVw
b3J0IGludmFsaWQgaWQ/DQoNCkZvciBzdWNoIGRldmljZXMsIHVzZXIgY291bGQgdXNlIHRoZSBi
ZGYgaW5mb3JtYXRpb24gdG8gY2hlY2sgaWYNCmFmZmVjdGVkIGRldmljZSBpcyBvcGVuZWQgYnkg
dGhlIHVzZXIuIElmIHllcywgZG8gc29tZSBuZWNlc3NhcnkNCnByZXBhcmF0aW9uIG9uIHRoZSBk
ZXZpY2UgYmVmb3JlIGlzc3VpbmcgaG90IHJlc2V0Lg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4g
Pj4+PiArICogVGhpcyBjb21tYW5kIGFsd2F5cyByZXBvcnRzIHRoZSBzZWdtZW50LCBidXMgYW5k
IGRldmZuIGluZm9ybWF0aW9uIGZvcg0KPiA+Pj4+ICsgKiBlYWNoIGFmZmVjdGVkIGRldmljZSwg
YW5kIHNlbGVjdGl2ZWx5IHJlcG9ydCB0aGUgZ3JvdXBfaWQgb3IgdGhlIGRldl9pZA0KPiA+Pj4+
ICsgKiBwZXIgdGhlIHdheSBob3cgdGhlIGRldmljZSBiZWluZyBxdWVyaWVkIGlzIG9wZW5lZC4N
Cj4gPj4+PiArICoJLSBJZiB0aGUgZGV2aWNlIGlzIG9wZW5lZCB2aWEgdGhlIHRyYWRpdGlvbmFs
IGdyb3VwL2NvbnRhaW5lciBtYW5uZXIsDQo+ID4+Pj4gKyAqCSAgdGhpcyBjb21tYW5kIHJlcG9y
dHMgdGhlIGdyb3VwX2lkIGZvciBlYWNoIGFmZmVjdGVkIGRldmljZS4NCj4gPj4+PiArICoNCj4g
Pj4+PiArICoJLSBJZiB0aGUgZGV2aWNlIGlzIG9wZW5lZCBhcyBhIGNkZXYsIHRoaXMgY29tbWFu
ZCBuZWVkcyB0byByZXBvcnQNCj4gPj4+IHMvbmVlZHMgdG8gcmVwb3J0L3JlcG9ydHMNCj4gPj4g
Z290IGl0Lg0KPiA+Pg0KPiA+Pj4+ICsgKgkgIGRldl9pZCBmb3IgZWFjaCBhZmZlY3RlZCBkZXZp
Y2UgYW5kIHNldCB0aGUNCj4gPj4+PiArICoJICBWRklPX1BDSV9IT1RfUkVTRVRfRkxBR19JT01N
VUZEX0RFVl9JRCBmbGFnLiAgRm9yIHRoZQ0KPiBhZmZlY3RlZA0KPiA+Pj4+ICsgKgkgIGRldmlj
ZXMgdGhhdCBhcmUgbm90IG9wZW5lZCBhcyBjZGV2IG9yIGJvdW5kIHRvIGRpZmZlcmVudCBpb21t
dWZkcw0KPiA+Pj4+ICsgKgkgIHdpdGggdGhlIGRldmljZSB0aGF0IGlzIHF1ZXJpZWQsIHJlcG9y
dCBhbiBpbnZhbGlkIGRldl9pZCB0byBhdm9pZA0KPiBvciBub3QgYm91bmQgYXQgYWxsDQo+ID4+
PiBzL2JvdW5kIHRvIGRpZmZlcmVudCBpb21tdWZkcyB3aXRoIHRoZSBkZXZpY2UgdGhhdCBpcyBx
dWVyaWVkL2JvdW5kIHRvDQo+ID4+PiBpb21tdWZkcyBkaWZmZXJlbnQgZnJvbSB0aGUgcmVzZXQg
ZGV2aWNlIG9uZT8NCj4gPj4gaG1tbSwgSSdtIG5vdCBhIG5hdGl2ZSBzcGVha2VyIGhlcmUuIFRo
aXMgX0lORk8gaXMgdG8gcXVlcnkgaWYgd2FudA0KPiA+PiBob3QgcmVzZXQgYSBnaXZlbiBkZXZp
Y2UsIHdoYXQgZGV2aWNlcyB3b3VsZCBiZSBhZmZlY3RlZC4gU28gaXQgYXBwZWFycw0KPiA+PiB0
aGUgcXVlcmllZCBkZXZpY2UgaXMgYmV0dGVyLiBCdXQgSSdkIGFkbWl0ICJ0aGUgcXVlcmllZCBk
ZXZpY2UiIGlzIGFsc28NCj4gPj4gInRoZSByZXNldCBkZXZpY2UiLiBtYXkgQWxleCBoZWxwIHBp
Y2sgb25lLiDwn5iKDQo+ID4gCS0gSWYgdGhlIGNhbGxpbmcgZGV2aWNlIGlzIG9wZW5lZCBkaXJl
Y3RseSB2aWEgY2RldiByYXRoZXIgdGhhbg0KPiA+IAkgIGFjY2Vzc2VkIHRocm91Z2ggdGhlIHZm
aW8gZ3JvdXAsIHRoZSByZXR1cm5lZA0KPiA+IAkgIHZmaW9fcGNpX2RlcGRlbmRlbnRfZGV2aWNl
IHN0cnVjdHVyZSByZXBvcnRzIHRoZSBkZXZfaWQNCj4gPiAJICByYXRoZXIgdGhhbiB0aGUgZ3Jv
dXBfaWQsIHdoaWNoIGlzIGluZGljYXRlZCBieSB0aGUNCj4gPiAJICBWRklPX1BDSV9IT1RfUkVT
RVRfRkxBR19JT01NVUZEX0RFVl9JRCBmbGFnIGluDQo+ID4gCSAgdmZpb19wY2lfaG90X3Jlc2V0
X2luZm8uICBJZiB0aGUgcmVzZXQgYWZmZWN0cyBkZXZpY2VzIHRoYXQNCj4gPiAJICBhcmUgbm90
IG9wZW5lZCB3aXRoaW4gdGhlIHNhbWUgaW9tbXVmZCBjb250ZXh0IGFzIHRoZSBjYWxsaW5nDQo+
ID4gCSAgZGV2aWNlLCBJT01NVUZEX0lOVkFMSURfSUQgd2lsbCBiZSBwcm92aWRlZCBhcyB0aGUg
ZGV2X2lkLg0KPiA+DQo+ID4gQnV0IHRoYXQga2luZCBvZiBicmluZ3MgdG8gbGlnaHQgdGhlIHF1
ZXN0aW9uIG9mIHdoYXQgZG9lcyB0aGUgdXNlciBkbw0KPiA+IHdoZW4gdGhleSBlbmNvdW50ZXIg
dGhpcyBzaXR1YXRpb24uICBJZiB0aGUgZGV2aWNlIGlzIG5vdCBvcGVuZWQsIHRoZQ0KPiA+IHJl
c2V0IGNhbiBjb21wbGV0ZS4gIElmIHRoZSBkZXZpY2UgaXMgb3BlbmVkIGJ5IGEgZGlmZmVyZW50
IHVzZXIsIHRoZQ0KPiA+IHJlc2V0IGlzIGJsb2NrZWQuICBUaGUgb25seSBsb2dpY2FsIGNvbmNs
dXNpb24gaXMgdGhhdCB0aGUgdXNlciBzaG91bGQNCj4gPiB0cnkgdGhlIHJlc2V0IHJlZ2FyZGxl
c3Mgb2YgdGhlIHJlc3VsdCBvZiB0aGUgaW5mbyBpb2N0bCwgd2hpY2ggdGhlDQo+ID4gbnVsbC1h
cnJheSBhcHByb2FjaCBmdXJ0aGVyIHNvbGlkaWZpZXMgYXMgdGhlIGRpcmVjdGlvbiBvZiB0aGUg
QVBJLg0KPiA+IEknbSBub3QgbGlraW5nIHRoaXMuICBUaGFua3MsDQo+ID4NCj4gPiBBbGV4DQo+
IA0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCj4gPg0KPiA+DQo+ID4+Pj4gKyAqCSAgcG90ZW50aWFs
IGRldl9pZCBjb25mbGljdCBhcyBkZXZfaWQgaXMgbG9jYWwgdG8gaW9tbXVmZC4gIEZvciBzdWNo
DQo+ID4+Pj4gKyAqCSAgYWZmZWN0ZWQgZGV2aWNlcywgdXNlciBzaGFsbCBmYWxsIGJhY2sgdG8g
dXNlIHRoZSBzZWdtZW50LCBidXMgYW5kDQo+ID4+Pj4gKyAqCSAgZGV2Zm4gaW5mbyB0byBtYXAg
aXQgdG8gb3BlbmVkIGRldmljZS4NCj4gPj4+PiArICoNCj4gPj4+PiAgICogUmV0dXJuOiAwIG9u
IHN1Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlOg0KPiA+Pj4+ICAgKgktZW5vc3BjID0gaW5zdWZm
aWNpZW50IGJ1ZmZlciwgLWVub2RldiA9IHVuc3VwcG9ydGVkIGZvciBkZXZpY2UuDQo+ID4+Pj4g
ICAqLw0KPiA+Pj4+ICBzdHJ1Y3QgdmZpb19wY2lfZGVwZW5kZW50X2RldmljZSB7DQo+ID4+Pj4g
LQlfX3UzMglncm91cF9pZDsNCj4gPj4+PiArCXVuaW9uIHsNCj4gPj4+PiArCQlfX3UzMiAgIGdy
b3VwX2lkOw0KPiA+Pj4+ICsJCV9fdTMyCWRldl9pZDsNCj4gPj4+PiArCX07DQo+ID4+Pj4gIAlf
X3UxNglzZWdtZW50Ow0KPiA+Pj4+ICAJX191OAlidXM7DQo+ID4+Pj4gIAlfX3U4CWRldmZuOyAv
KiBVc2UgUENJX1NMT1QvUENJX0ZVTkMgKi8NCj4gPj4+PiBAQCAtNjYzLDYgKzY4NCw3IEBAIHN0
cnVjdCB2ZmlvX3BjaV9kZXBlbmRlbnRfZGV2aWNlIHsNCj4gPj4+PiAgc3RydWN0IHZmaW9fcGNp
X2hvdF9yZXNldF9pbmZvIHsNCj4gPj4+PiAgCV9fdTMyCWFyZ3N6Ow0KPiA+Pj4+ICAJX191MzIJ
ZmxhZ3M7DQo+ID4+Pj4gKyNkZWZpbmUgVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfSU9NTVVGRF9E
RVZfSUQJKDEgPDwgMCkNCj4gPj4+PiAgCV9fdTMyCWNvdW50Ow0KPiA+Pj4+ICAJc3RydWN0IHZm
aW9fcGNpX2RlcGVuZGVudF9kZXZpY2UJZGV2aWNlc1tdOw0KPiA+Pj4+ICB9Ow0KPiA+Pj4gRXJp
Yw0KDQo=
