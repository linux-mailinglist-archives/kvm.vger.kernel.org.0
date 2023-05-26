Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916DF712263
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbjEZIij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 04:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242271AbjEZIih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 04:38:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F9D9B;
        Fri, 26 May 2023 01:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685090311; x=1716626311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=slaBaYU3upWvF/ktA4u3e/15Xv7fNY8seq0/4Y12t7U=;
  b=dnq4+6pxSACM1JsBH73UinfSolyeUgOD1SoTNN4jBhz4nhs2dRV+VMal
   hWgAkm2cGOsQWBdRiT/1Ej8cA7tGt1NV9BIRgMLC9KqgpunMhhNwD/saS
   +hGAGSSU7lb2CKHvlwO+H+UQQvY6DGyDn/r10ErdryHF78u+Z9TG7NOzA
   kaFdtZmCzKuJyKhkiVBbsnTmfcMYte6ZRDmcwhiJ2T+TOy3Ic4yttrZg6
   YQbuExkqie0OMx9CV+CTudXm+w1gXO+MsSO7o7SK5qyoLW9N9ahD3pmCb
   NlPreh0H2wdNDDZWB+C7ZJVL2zb5QIV05lQKp1hoZHvML8IPz3XcUiZZ3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="334503375"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="334503375"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 01:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="705122170"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="705122170"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 26 May 2023 01:38:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 01:38:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 26 May 2023 01:38:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 26 May 2023 01:38:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2YBWABJvTHv5a1PUKMeFRLnSFDoiFlrvpeXWzzKO+SlA+OHu7aFaxxmGAsU+x8nTw+cUNdlpUxx2S4YC/d30q/rZ9UFeQ4mA3ORHLmkd+gWDjKTcbhdUgCp6kjg21k7FR3RKOkO8fwqARhcAXMie503Ss/7r9ZnSsLIdb/Hb5oTnmx/1SkseBzh3qE821ML5IxmgpfKTTfznvs99px7E75UnOdZa7YB6mxc8Y5blk/xDwZ36B2D7Z1z4jskWYRSVdlOrIqy/vzM91KuGuvM2Wyds0aCyKzSOSsdU8mF/xu+Mo5819l8ZD8bGUqWhJDusf5RXzVFHwP/aEUPV5JTSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slaBaYU3upWvF/ktA4u3e/15Xv7fNY8seq0/4Y12t7U=;
 b=VHUWoXI66GmVIELkyKaR9VVqFLExDDime7/toQoCRpa0UpRo+VbNYy6722zap3PZ9BAyCp5D6CkiXXqQWtRVbCzRxM2y+djS1OvMfaqtMwUwiOjN5yDwekg5vuBmqAK9PTHzzn9hRB1tb2GR12LLL9rPag+osePmr4Uxx0/2xr07SnLwz3e79wq2bcBGA2NRmi2c3xXp4hY27dI4QwbMQuMEHLQ+2/AKzhvFvRsVuKbBW2wAJJdlf4Us6coL4INEfiFa6eyThmZlPsGlkD1VzC7ojubefBIyismO9I+Pqu0LgJyNnaCdt6iOjvqKEKuoDj/83pF/X2lfqTbxcOR9RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV8PR11MB8511.namprd11.prod.outlook.com (2603:10b6:408:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 08:38:27 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Fri, 26 May 2023
 08:38:26 +0000
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
Subject: RE: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Index: AQHZhZ7iKUbaAh4TKEGwflpEYDXvra9m6p0AgAAxWMCAAPVhgIAAqe5QgADjLACAAASTYIABlZGAgADoeUA=
Date:   Fri, 26 May 2023 08:38:25 +0000
Message-ID: <DS0PR11MB7529C82439CDC8B7BC324345C3479@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-21-yi.l.liu@intel.com>
        <20230522161534.32f3bf8e.alex.williamson@redhat.com>
        <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230523095025.1898297c.alex.williamson@redhat.com>
        <DS0PR11MB75292161F081F27C0650EFB3C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230524093142.3cac798e.alex.williamson@redhat.com>
        <DS0PR11MB7529407F01EE55AE4A0A9F1FC3469@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230525095939.37ddb8ce.alex.williamson@redhat.com>
In-Reply-To: <20230525095939.37ddb8ce.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|LV8PR11MB8511:EE_
x-ms-office365-filtering-correlation-id: d8ed8656-15af-40c6-f77b-08db5dc492c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7kN8NFLN4LJmO4wmvOI6GmujO58L1JdVJQ6XbCY+vDubNpHiAFDbOOq1CKoXpPzB7P3M6iBZI4kXtkIGIOvfAI5QwnqdpB9Sef0cGtQYZmeeOkQcidxsn6dRQ1DiGZ7MUvLdh9DP3PibUInI0s4hC7R4+GbbFv//2QN5xR5A+RWAMlxsFdK8fmwLGxB4T/cc4bZSWIjrghF660M4ztNukFoIELBfSrw6Am7pG/lZBAoqbiqFRYCncfvvpOsg/c3kEXOOQBxlyIELVpWt9YZQo0pTib/nfI03GTNMhKk1vyQwmvil2cL+n+RN2cNqaTsWJ9OfOblz8svFi3Y+LsXmyFN4YbmTLFxfrEAKJot4qQMf9sdkMuBzKg37qRrywXmkb0YW9hngtDzr35xBgHcoJy+iicrlJx77hKVWJ7f8SbgVztE1gnAFVQUCVDhaCla4tT6vFSSN++wLE5gqD3lh+rYwJfp/taymMDVBRGhEs6a1KzRpxR7l8RuG3rt/mVMd3+uZtxtWtFBXFDaHwo1ZP/uli95b1TP4Rt9Eg46cyqMwCpkwYi17SL2Pvdhul084QNKS5rrfJKcGTEHdZAYoRFHDgyqG+mkOTOJski3vkGPaucswQFDYJT1/UrmMwIGJjrWBrAqf+tVUNeI52hHIEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199021)(6506007)(478600001)(7696005)(71200400001)(54906003)(66899021)(26005)(9686003)(66476007)(66946007)(186003)(64756008)(76116006)(66556008)(66446008)(6916009)(4326008)(33656002)(5660300002)(52536014)(82960400001)(41300700001)(55016003)(38070700005)(86362001)(83380400001)(8676002)(2906002)(38100700002)(8936002)(7416002)(316002)(122000001)(83133001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXJ5a3BVUzZydSs4Znd2dDd4N3Y2RTludENtUFRKMkFoMitWd0tIWGZramdC?=
 =?utf-8?B?QjdzclJReHk2eVZ3NmdFUUVZTlBjdmNEMklvQjMzMFZPWHhQaUtKdVJObElB?=
 =?utf-8?B?aW40ZzFOejdKeGFsWHFPbWRaTnhoVEhRd0pQcStQTloyOU9IaERLT0VscTFo?=
 =?utf-8?B?M01mL0QzN09aNS9tY28rdno5dGhYR1Y5Ly91dXRzRTc1emtta2xFK2hCcjZQ?=
 =?utf-8?B?dnlDMHFxbTNLM0luaUtkK2VJL0xaU3FpU0JFV01LUUg4NE54RTU1L05Ed3dw?=
 =?utf-8?B?WUgxUXIwR3BZTGEzRytlOE45eHF6emExbVJEMy9xM3JkVms2V2QvOTlySnZO?=
 =?utf-8?B?L2FOeWNrR3VOcXMzcWFzb0ZuTXQ0Z05VNEZXQXJkZTA0QTBxS0xVRUE0RnRj?=
 =?utf-8?B?NCt5N2ZIbnd3YkZvZG11WXVjZEtXTmk1R0JsalU3V2FzbUVSZnNVNEhreDlB?=
 =?utf-8?B?b0F6R3BtRUIxS3NKTUh5ZzZYd0JTYjN2M0pyRlB2VDJRUXpwQ3NQeWlTK1FL?=
 =?utf-8?B?TmhBZjJxVlA4Y2FVRkVzMmtISzB3OXhXM1J2K0M3V3ZidUxMVkd1SWNoMUFX?=
 =?utf-8?B?c3VWZDhleFZuWlQ0NzVydGF0eHk0YTJhbk1WdzNIdEU5LzZiMVRhdk52dUZH?=
 =?utf-8?B?bTk0dWpKUjU0K05nWFZzN0pZMmMvSG11alJ0SnNqUU82eUlWM0J4dWhTdmt3?=
 =?utf-8?B?bXkyZVNlRkJBSFpCaGpMSUpzK2FSY09KVWJPZFg0RW0wcUhPSllOOG45aXdL?=
 =?utf-8?B?V0VUYmxHWUhQaUNOZXhnUEorNm5nZTd3cTh1bk9HVlBsTlpCOUVyV1RuK0RT?=
 =?utf-8?B?U3B2TzNSdmlneDMwVWxRT1lUVXNIZ29vekwxVzdYaDF5azJlSjFncjZBUVl1?=
 =?utf-8?B?NHNVTHlFaDQ1SnBlVWRGekxCWkJSSk5ZcHljcVZmUDRURlg5VENDT3pxc3Nn?=
 =?utf-8?B?dGVVS0xwc3orV2JqN2IwbERZOHQrREJSSktGNExHdkNOS3FWMHhIbWxhc24v?=
 =?utf-8?B?RUFLV3FpYmdFSWpUY0RZTEFvb2xpZHhyUzJlZ2N0VWtSbTNTMDNaMkEremVX?=
 =?utf-8?B?VWlIcHM0T2k4dnpyNjdpVUs4TjdyMHNZeUFmS2orNUtXRUp6SkhpY1YwV1pj?=
 =?utf-8?B?dkxHVjEwUmFIVVh1V0JUcFR6ZXZETWVXODM5SkdnampFN2NWd1NEUGR0THFn?=
 =?utf-8?B?SktoUjlwb2N2eTNmeE5qWWtrbjA3VXRqTThlTk9IOHJsWkxDdFFKRTY2NzNE?=
 =?utf-8?B?RlBEQ3ZnS3dzTjhJR3F5SW9lT2p2MjN5OXJLWVFoOXFlejdwTkRld2xRNlVB?=
 =?utf-8?B?Z3FEUTBBYlRzM2k2OGFXRUJoaVRacitzM0orakZnemNVUE5DNS8wakVGOXBN?=
 =?utf-8?B?TTlqMWVjNWZZZFdRMmpCTGsyTWJvSDhmenJjR2tIRlB1VWN3a0FxWGVMVFBF?=
 =?utf-8?B?SjArOUFrYUI1aUdSZlo4T2ZmdmszK2svb3lmVXplelFhSXY5T1UySTdrNS9M?=
 =?utf-8?B?L2p2Y3dZOUd1SjUwU3QvRVJBZmR1T2pBZmcxR3RCaXRMOFdNdGtOWWlNak1N?=
 =?utf-8?B?Sm5WNXc3ckFVK0VYYWJ1aG9XUUFEZTA3R0dZNHhsNGVsdkVHazlrUW1BNXZ4?=
 =?utf-8?B?b2VST2NYcDFudDFGYjBQQ2FvbnhjSFBaeWhneTNkZjl4S3dxQlp0MUJ5SzZr?=
 =?utf-8?B?eCs0cEFuNmhlZzF1cEhjUFBOU3JMWkZLMjZrR0hIcDMrSi92TGdWUTZnT3RL?=
 =?utf-8?B?cEJWWnRrVjJjNjVPSmRtN1V1TUV6UHQ4L0NzS29HS1hnd0NTa2wzT1FBSXZa?=
 =?utf-8?B?MzBFQ3I0NkhTNlhPYi9ycGZGbVdIQlNzQ2c5YnkyOGEyckZZYTFic2ZIZS8v?=
 =?utf-8?B?dzI2TUhnZkkxalZWQ21lZzBqU08wL3BxNlJkQkZVRndJYzhXWUpLZDZoblRH?=
 =?utf-8?B?L3R6RHkvNGRwb01KMHVuTmFMcHZNUEtLM2VHbWtpQkx2WEtYRDA0a2xTYnJP?=
 =?utf-8?B?bVVORkpxR0dERzVERVZPamo4dGFENFlMcVZmT2dPVnJacDQrQVdKYm1ONU50?=
 =?utf-8?B?b1VJMTNSelhWYmRCV1I3bno2QTBZZkYzMlgzTGw1NGx2MTYzdTB5VWk0OGVE?=
 =?utf-8?Q?oQ/hjH4LGWjtE0OKDlEcnaeoG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ed8656-15af-40c6-f77b-08db5dc492c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 08:38:26.0107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hy4m2XF0Eu8yd5b2aEJap2QIZc9VcSkfmFGUVCJKwAzgGXnLNM8msHABRhIYv98oc3mXVOFkK/1IuVsGrJV62g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8511
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
ZW50OiBGcmlkYXksIE1heSAyNiwgMjAyMyAxMjowMCBBTQ0KPiANCj4gT24gVGh1LCAyNSBNYXkg
MjAyMyAwMzowMzo1NCArMDAwMA0KPiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29tPiB3
cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkBy
ZWRoYXQuY29tPg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBNYXkgMjQsIDIwMjMgMTE6MzIgUE0N
Cj4gPiA+DQo+ID4gPiBPbiBXZWQsIDI0IE1heSAyMDIzIDAyOjEyOjE0ICswMDAwDQo+ID4gPiAi
TGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+ID4g
RnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiA+
ID4gPiBTZW50OiBUdWVzZGF5LCBNYXkgMjMsIDIwMjMgMTE6NTAgUE0NCj4gPiA+ID4gPg0KPiA+
ID4gPiA+IE9uIFR1ZSwgMjMgTWF5IDIwMjMgMDE6MjA6MTcgKzAwMDANCj4gPiA+ID4gPiAiTGl1
LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0K
PiA+ID4gPiA+ID4gPiBTZW50OiBUdWVzZGF5LCBNYXkgMjMsIDIwMjMgNjoxNiBBTQ0KPiA+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBPbiBTYXQsIDEzIE1heSAyMDIzIDA2OjI4OjI0IC0wNzAw
DQo+ID4gPiA+ID4gPiA+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiAgCXJldHVybiBrYXNwcmludGYoR0ZQX0tFUk5FTCwg
InZmaW8vZGV2aWNlcy8lcyIsIGRldl9uYW1lKGRldikpOw0KPiA+ID4gPiA+ID4gPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3ZmaW8vaW9tbXVmZC5jIGIvZHJpdmVycy92ZmlvL2lvbW11ZmQuYw0K
PiA+ID4gPiA+ID4gPiA+IGluZGV4IDgzNTc1YjY1ZWEwMS4uNzk5ZWEzMjJhN2Q0IDEwMDY0NA0K
PiA+ID4gPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvdmZpby9pb21tdWZkLmMNCj4gPiA+ID4gPiA+
ID4gPiArKysgYi9kcml2ZXJzL3ZmaW8vaW9tbXVmZC5jDQo+ID4gPiA+ID4gPiA+ID4gQEAgLTEx
Miw2ICsxMTIsMjQgQEAgdm9pZCB2ZmlvX2lvbW11ZmRfdW5iaW5kKHN0cnVjdCB2ZmlvX2Rldmlj
ZV9maWxlDQo+ICpkZikNCj4gPiA+ID4gPiA+ID4gPiAgCQl2ZGV2LT5vcHMtPnVuYmluZF9pb21t
dWZkKHZkZXYpOw0KPiA+ID4gPiA+ID4gPiA+ICB9DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4g
PiA+ID4gPiAraW50IHZmaW9faW9tbXVmZF9hdHRhY2goc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2
LCB1MzIgKnB0X2lkKQ0KPiA+ID4gPiA+ID4gPiA+ICt7DQo+ID4gPiA+ID4gPiA+ID4gKwlsb2Nr
ZGVwX2Fzc2VydF9oZWxkKCZ2ZGV2LT5kZXZfc2V0LT5sb2NrKTsNCj4gPiA+ID4gPiA+ID4gPiAr
DQo+ID4gPiA+ID4gPiA+ID4gKwlpZiAodmZpb19kZXZpY2VfaXNfbm9pb21tdSh2ZGV2KSkNCj4g
PiA+ID4gPiA+ID4gPiArCQlyZXR1cm4gMDsNCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4g
SXNuJ3QgdGhpcyBhbiBpbnZhbGlkIG9wZXJhdGlvbiBmb3IgYSBub2lvbW11IGNkZXYsIGllLiAt
RUlOVkFMPyAgV2UNCj4gPiA+ID4gPiA+ID4gcmV0dXJuIHN1Y2Nlc3MgYW5kIGNvcHkgYmFjayB0
aGUgcHJvdmlkZWQgcHRfaWQsIHdoeSB3b3VsZCBhIHVzZXIgbm90DQo+ID4gPiA+ID4gPiA+IGNv
bnNpZGVyIGl0IGEgYnVnIHRoYXQgdGhleSBjYW4ndCB1c2Ugd2hhdGV2ZXIgdmFsdWUgd2FzIHRo
ZXJlIHdpdGgNCj4gPiA+ID4gPiA+ID4gaW9tbXVmZD8NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4g
PiBZZXMsIHRoaXMgaXMgdGhlIHF1ZXN0aW9uIEkgYXNrZWQgaW4gWzFdLiBBdCB0aGF0IHRpbWUs
IGl0IGFwcGVhcnMgdG8gbWUNCj4gPiA+ID4gPiA+IHRoYXQgYmV0dGVyIHRvIGFsbG93IGl0IFsy
XS4gTWF5YmUgaXQncyBtb3JlIHN1aXRhYmxlIHRvIGFzayBpdCBoZXJlLg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gRnJvbSBhbiBBUEkgcGVyc3BlY3RpdmUgaXQgc2VlbXMgd3JvbmcuICBXZSByZXR1
cm4gc3VjY2VzcyB3aXRob3V0DQo+ID4gPiA+ID4gZG9pbmcgYW55dGhpbmcuICBBIHVzZXIgd291
bGQgYmUgcmlnaHQgdG8gY29uc2lkZXIgaXQgYSBidWcgdGhhdCB0aGUNCj4gPiA+ID4gPiBhdHRh
Y2ggb3BlcmF0aW9uIHdvcmtzIGJ1dCB0aGVyZSdzIG5vdCBhY3R1YWxseSBhbnkgYXNzb2NpYXRp
b24gdG8gdGhlDQo+ID4gPiA+ID4gSU9BUy4gIFRoYW5rcywNCj4gPiA+ID4NCj4gPiA+ID4gVGhl
IGN1cnJlbnQgdmVyc2lvbiBpcyBraW5kIG9mIHRyYWRlb2ZmIGJhc2VkIG9uIHByaW9yIHJlbWFy
a3Mgd2hlbg0KPiA+ID4gPiBJIGFza2VkIHRoZSBxdWVzdGlvbi4gQXMgcHJpb3IgY29tbWVudFsy
XSwgaXQgYXBwZWFycyB0byBtZSB0aGUgYXR0YWNoDQo+ID4gPiA+IHNoYWxsIHN1Y2Nlc3MgZm9y
IG5vaW9tbXUgZGV2aWNlcyBhcyB3ZWxsLCBidXQgcGVyIHlvdXIgcmVtYXJrIGl0IHNlZW1zDQo+
ID4gPiA+IG5vdCBpbiBwbGFuLiBTbyBhbnl3YXksIHdlIG1heSBqdXN0IGZhaWwgdGhlIGF0dGFj
aC9kZXRhY2ggZm9yIG5vaW9tbXUNCj4gPiA+ID4gZGV2aWNlcy4gSXMgaXQ/DQo+ID4gPg0KPiA+
ID4gSWYgYSB1c2VyIGNyZWF0ZXMgYW4gaW9hcyB3aXRoaW4gYW4gaW9tbXVmZCwgYXR0YWNoZXMg
YSBkZXZpY2UgdG8gdGhhdA0KPiA+ID4gaW9hcyBhbmQgcG9wdWxhdGVzIGl0IHdpdGggbWFwcGlu
Z3MsIHdvdWxkbid0IHRoZSB1c2VyIGV4cGVjdCB0aGUNCj4gPiA+IGRldmljZSB0byBoYXZlIGFj
Y2VzcyB0byBhbmQgaG9ub3IgdGhvc2UgbWFwcGluZ3M/ICBJIHRoaW5rIHRoYXQncyB0aGUNCj4g
PiA+IHBhdGggd2UncmUgaGVhZGVkIGRvd24gaWYgd2UgcmVwb3J0IGEgc3VjY2Vzc2Z1bCBhdHRh
Y2ggb2YgYSBub2lvbW11DQo+ID4gPiBkZXZpY2UgdG8gYW4gaW9hcy4NCj4gPg0KPiA+IG1ha2Vz
IHNlbnNlLiBMZXQncyBqdXN0IGZhaWwgYXR0YWNoL2RldGFjaCBmb3Igbm9pb21tdSBkZXZpY2Vz
Lg0KPiA+DQo+ID4gPg0KPiA+ID4gV2UgbmVlZCB0byBrZWVwIGluIG1pbmQgdGhhdCBub2lvbW11
IHdhcyBtZWFudCB0byBiZSBhIG1pbmltYWxseQ0KPiA+ID4gaW50cnVzaXZlIG1lY2hhbmlzbSB0
byBwcm92aWRlIGEgZHVtbXkgdmZpbyBJT01NVSBiYWNrZW5kIGFuZCBzYXRpc2Z5DQo+ID4gPiB0
aGUgZ3JvdXAgcmVxdWlyZW1lbnRzLCBzb2xlbHkgZm9yIHRoZSBwdXJwb3NlIG9mIG1ha2luZyB1
c2Ugb2YgdGhlDQo+ID4gPiB2ZmlvIGRldmljZSBpbnRlcmZhY2UgYW5kIHdpdGhvdXQgcHJvdmlk
aW5nIGFueSBETUEgbWFwcGluZyBzZXJ2aWNlcyBvcg0KPiA+ID4gZXhwZWN0YXRpb25zLiAgSU1P
LCBhbiBhcmd1bWVudCB0aGF0IHdlIG5lZWQgdGhlIGF0dGFjaCBvcCB0byBzdWNjZWVkIGluDQo+
ID4gPiBvcmRlciB0byBhdm9pZCB0b28gbXVjaCBkaXNydXB0aW9uIGluIHVzZXJzcGFjZSBjb2Rl
IGlzIG5vbnNlbnNlLiAgT24NCj4gPiA+IHRoZSBjb250cmFyeSwgdXNlcnNwYWNlIG5lZWRzIHRv
IGJlIHZlcnkgYXdhcmUgb2YgdGhpcyBkaWZmZXJlbmNlIGFuZA0KPiA+ID4gd2Ugc2hvdWxkbid0
IGludmVzdCBlZmZvcnQgdHJ5aW5nIHRvIG1ha2Ugbm9pb21tdSBtb3JlIGNvbnZlbmllbnQgdG8N
Cj4gPiA+IHVzZS4gIEl0J3MgaW5oZXJlbnRseSB1bnNhZmUuDQo+ID4gPg0KPiA+ID4gSSdtIG5v
dCBmb25kIG9mIHdoYXQgYSBtZXNzIG5vaW9tbXUgaGFzIGJlY29tZSB3aXRoIGNkZXYsIHdlJ3Jl
IHdlbGwNCj4gPiA+IGJleW9uZCB0aGUgbWluaW1hbCBjb2RlIHRyaWNrZXJ5IG9mIHRoZSBsZWdh
Y3kgaW1wbGVtZW50YXRpb24uICBJIGhhdGUNCj4gPiA+IHRvIGFzaywgYnV0IGNvdWxkIHdlIHJl
aXRlcmF0ZSBvdXIgcmVxdWlyZW1lbnRzIGZvciBub2lvbW11IGFzIGEgcGFydCBvZg0KPiA+ID4g
dGhlIG5hdGl2ZSBpb21tdWZkIGludGVyZmFjZSBmb3IgdmZpbz8gIFRoZSBuZXN0ZWQgdXNlcnNw
YWNlIHJlcXVpcmVtZW50DQo+ID4gPiBpcyBnb25lIG5vdyB0aGF0IGh5cGVydmlzb3JzIGhhdmUg
dklPTU1VIHN1cHBvcnQsIHNvIG15IGFzc3VtcHRpb24gaXMNCj4gPiA+IHRoYXQgdGhpcyBpcyBv
bmx5IGZvciBiYXJlIG1ldGFsIHN5c3RlbXMgd2l0aG91dCBhbiBJT01NVSwgd2hpY2gNCj4gPiA+
IGlkZWFsbHkgYXJlIGxlc3MgYW5kIGxlc3MgcHJldmFsZW50LiAgQXJlIHRoZXJlIGFueSBub2lv
bW11IHVzZXJzcGFjZXMNCj4gPiA+IHRoYXQgYXJlIGFjdHVhbGx5IGdvaW5nIHRvIGFkb3B0IHRo
ZSBub2lvbW11IGNkZXYgaW50ZXJmYWNlPyAgV2hhdA0KPiA+ID4gdGVycmlibGUgdGhpbmdzIGhh
cHBlbiBpZiBub2lvbW11IG9ubHkgZXhpc3RzIGluIHRoZSB2ZmlvIGdyb3VwIGNvbXBhdA0KPiA+
ID4gaW50ZXJmYWNlIHRvIGlvbW11ZmQgYW5kIGF0IHNvbWUgZGlzdGFudCBwb2ludCBpbiB0aGUg
ZnV0dXJlIGRpZXMgd2hlbg0KPiA+ID4gdGhhdCBnZXRzIGRpc2FibGVkPw0KPiA+DQo+ID4gdklP
TU1VIG1heSBpbnRyb2R1Y2Ugc29tZSBwZXJmb3JtYW5jZSBkZWR1Y3Rpb24gaWYgdGhlcmUNCj4g
PiBhcmUgZnJlcXVlbnQgbWFwL3VubWFwLg0KPiANCj4gV2UgdXNlIHBhc3N0aHJvdWdoIG1vZGUg
b2YgdGhlIHZJT01NVSB0byBuZWdhdGUgdGhhdCBvdmVyaGVhZCBmb3IgZ3Vlc3QNCj4gZHJpdmVy
cyBhbmQgdmZpbyBkcml2ZXJzIGhhdmUgdHlwaWNhbGx5IGxlYXJuZWQgYnkgbm93IHRoYXQgZHlu
YW1pYw0KPiBtYXBwaW5ncyB1c2luZyB0aGUgdmZpbyB0eXBlMSBtYXBwaW5nIEFQSSBhcmUgYSBi
YWQgaWRlYS4NCg0KWWVzLCB0aGlzIGNhbiBhdm9pZCB0aGlzIG92ZXJoZWFkLg0KDQo+IA0KPiA+
IEFzIGZhciBhcyBJIGtub3csIHNvbWUgY2xvdWQgc2VydmljZQ0KPiA+IHByb3ZpZGVycyBhcmUg
bW9yZSB3aWxsaW5nIHRvIHVzZSBub2lvbW11IG1vZGUgd2l0aGluIFZNLg0KPiANCj4gU3VyZSwg
dGhlIFZNIGl0c2VsZiBpcyBzdGlsbCBpc29sYXRlZCBieSB0aGUgaG9zdCBJT01NVSwgYnV0IGl0
J3MNCj4gY2xlYXJseSBhbiBleHRyYSBtYWludGVuYW5jZSBhbmQgZGV2ZWxvcG1lbnQgYnVyZGVu
IHdoZW4gd2Ugc2hvdWxkDQo+IGluc3RlYWQgYmUgZW5jb3VyYWdpbmcgdGhvc2UgdXNlIGNhc2Vz
IHRvIHVzZSB2SU9NTVUgcmF0aGVyIHRoYW4NCj4gcG9ydGluZyB0byBhIGRpZmZlcmVudCBub2lv
bW11IHVBUEkuICBFdmVuIGlmIHRoZSBob3N0IGlzIG5vdCBleHBvc2VkLA0KPiBhbnkgc29ydCBv
ZiBzZWN1cml0eSBhbmQgc3VwcG9ydCBiZXN0IHByYWN0aWNlcyBpbiB0aGUgZ3Vlc3Qgc2hvdWxk
DQo+IGZhdm9yIGEgdklPTU1VIHNvbHV0aW9uLg0KPiANCj4gPiBCZXNpZGVzIHRoZSBwZXJmb3Jt
YW5jZSBjb25zaWRlcmF0aW9uLCB1c2luZyBhIGJvb3RpbmcgYSBWTQ0KPiA+IHdpdGhvdXQgdklP
TU1VIGlzIHN1cHBvc2VkIHRvIGJlIG1vcmUgcm9idXN0LiBCdXQgSSdtIG5vdA0KPiANCj4gV2hh
dCBjbGFpbXMgZG8geW91IGhhdmUgdG8gc3VwcG9ydCBsYWNrIG9mIHJvYnVzdG5lc3MgaW4gdklP
TU1VPyAgQ2FuDQo+IHRoZXkgYmUgZml4ZWQ/DQoNCklmIG5vIHZJT01NVSwgdGhlIFFlbXUgbG9n
aWMgaXMgc2ltcGxlci4gSGVuY2UgbGVzcyBjaGFuY2UgdG8gaGF2ZSBlcnJvcnMuDQpUaGF0J3Mg
d2hhdCBJIGhlYXJkLg0KDQo+ID4gc3VyZSBpZiB0aGUgbm9pb21tdSB1c2Vyc3BhY2Ugd2lsbCBh
ZGFwdCB0byBjZGV2IG5vaW9tbXUuDQo+ID4gUGVyaGFwcyB5ZXMgaWYgZ3JvdXAgbWF5IGJlIGRl
cHJlY2F0ZWQgaW4gZnV0dXJlLg0KPiANCj4gRGVwcmVjYXRpb24gaXMgZ29pbmcgdG8gdGFrZSBh
IGxvbmcgdGltZS4gIElNTywgdGhlIFZNIHVzZSBjYXNlcyBzaG91bGQNCj4gYWxsIGJlIGVuY291
cmFnZWQgdG8gYWRvcHQgYSB2SU9NTVUgc29sdXRpb24gcmF0aGVyIHRoYW4gcG9ydCB0byBhIG5l
dw0KPiBjZGV2IG5vaW9tbXUgaW50ZXJmYWNlLiAgVGhlIHF1ZXN0aW9uIHRoZW4gaXMgd2hldGhl
ciB0aGVyZSBhcmUgb25nb2luZw0KPiBiYXJlIG1ldGFsIG5vaW9tbXUgdXNlIGNhc2VzIGFuZCBo
b3cgbG9uZyB0aG9zZSB3aWxsIGRyYWcgb3V0IHRoZSB2ZmlvDQo+IGdyb3VwIGRlcHJlY2F0aW9u
LiBXZSBjb3VsZCBhbHdheXMgYWRkIG5vaW9tbXUgdG8gdGhlIG5hdGl2ZSB2ZmlvIGNkZXYNCj4g
aW50ZXJmYWNlIGxhdGVyIGlmIHRoZXJlJ3Mgc3RpbGwgZGVtYW5kLg0KDQpTbyB3ZSBob3BlIHRo
ZXJlIGlzIG5vIG5vaW9tbXUgdXNlcnNwYWNlIGFwcCBhZnRlciBkZXByZWNhdGluZyB2ZmlvX2dy
b3VwLg0KQnV0IGlmIHN0aWxsIG5lZWRlZCwgdGhlbiBhZGQgaXQgaW4gY2Rldi4gSXMgaXQ/IHNv
dW5kcyBsaWtlIGEgcGxhbiBhcw0KdmZpb19ub2lvbW11IGlzIGFsc28gbm90IHRoZXJlIGZyb20g
dmZpbyBkYXkxLiDwn5iKDQoNCkkgc3RpbGwgd2FudCB0byBhc2sgaWYgd2UgaGF2ZSBhbnkgY2hh
bm5lbCB0byBrbm93IGlmIG5vaW9tbXUgaXMgc3Ryb25nbHkNCm5lZWRlZCBpbiBzb21lIGNlcnRh
aW4gc2NlbmFyaW9ycz8gSWYgdGhlcmUgaXMgYSBzdHJvbmcgbmVlZCBhbmQgd2UgZG9u4oCZdA0K
c2VlIGdhcCBpbiB0aGUgY3VycmVudCBub2lvbW11IGltcGxlbWVudGF0aW9uIGluIHRoZSBjZGV2
IHNlcmllcywgd291bGQNCml0IGJlIGdvb2QgdG8gaGF2ZSBpdCBpbiBjZGV2IGRheTEgaW5zdGVh
ZCBvZiBhZGRpbmcgaXQgaW4gZnV0dXJlPw0KDQo+ID4gPiA+IGJ0dy4gU2hvdWxkIHdlIGRvY3Vt
ZW50IGl0IHNvbWV3aGVyZSBhcyB3ZWxsPyBFLmcuIG5vaW9tbXUgdXNlcnNwYWNlDQo+ID4gPiA+
IGRvZXMgbm90IHN1cHBvcnQgYXR0YWNoL2RldGFjaD8gVXNlcnNwYWNlIHNob3VsZCBrbm93IGl0
IGlzIG9wZW5pbmcNCj4gPiA+ID4gbm9pb21tdSBkZXZpY2VzLg0KPiA+ID4NCj4gPiA+IERvY3Vt
ZW50YXRpb24gbmV2ZXIgaHVydHMuICBUaGlzIGlzIHN1Y2ggYSBzcGVjaWFsaXplZCB1c2UgY2Fz
ZSBJJ20gbm90DQo+ID4gPiBzdXJlIHdlJ3ZlIGJvdGhlcmVkIHRvIGRvIG11Y2ggZG9jdW1lbnRh
dGlvbiBmb3Igbm9pb21tdSBwcmV2aW91c2x5Lg0KPiA+DQo+ID4gU2VlbXMgbm8sIEkgZGlkbid0
IGZpbmQgc3BlY2lhbCBkb2N1bWVudGF0aW9uIGZvciBub2lvbW11LiBQZXJoYXBzDQo+ID4gYSBj
b21tZW50IGluIHRoZSBzb3VyY2UgY29kZSBpcyBlbm91Z2guIERlcGVuZHMgb24geW91ciB0YXN0
ZS4NCj4gDQo+IElmIHdlJ3JlIG9ubHkgY29udGludWluZyB0aGUgZ3JvdXAgY29tcGF0IG5vaW9t
bXUgc3VwcG9ydCwgSSBjYW4ndCB2ZXJ5DQo+IHdlbGwgcmVxdWlyZSBuZXcgZG9jdW1lbnRhdGlv
bi4gIFdlIGhhdmUgYSBzaW1wbGUgbW9kZWwgdGhlcmUsIG5vaW9tbXUNCj4gZGV2aWNlcyBvbmx5
IHN1cHBvcnQgdGhlIG5vaW9tbXUgY29udGFpbmVyIHR5cGUgYW5kIHByb3ZpZGUgbm8gbWFwcGlu
Zw0KPiBpbnRlcmZhY2VzLiAgVGhlIGlvbW11ZmQgaW50ZXJmYWNlIHJlbGF0aXZlIHRvIG5vaW9t
bXUgc2VlbXMgbW9yZQ0KPiBudWFuY2VkIGFuZCBwcm9iYWJseSBuZWVkcyB0byBkb2N1bWVudGF0
aW9uIHNob3VsZCB3ZSBkZWNpZGUgdG8gcHVyc3VlDQo+IGl0Lg0KDQpZZXMuIGRlcGVuZHMgb24g
d2hldGhlciB3ZSB3YW50IHRvIHB1cnN1ZSBpdC4NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo=
