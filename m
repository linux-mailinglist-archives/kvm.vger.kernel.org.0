Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA76B365D
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 07:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCJGEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 01:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCJGEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 01:04:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E00E8CE4;
        Thu,  9 Mar 2023 22:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678428248; x=1709964248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ngeVjLXXp6PhhtINcgGbIL+kmtWlCqDUdOjrR1oMfcY=;
  b=VIRUkgXdy+FTT+Ai3qYAjBPPFnP+AtmnmLgj4QUAty3NopjGPnLcDBCN
   pRUHG1P2mgR8FTdHiOuKahu9B6KfPVWx8kHcqcxJDKRzfNuScXoq9MLiG
   lzps8F5gr5kihVfRujn6JJjiL4lyVgImBtUxfgl4elem565pkLOr7F/17
   3L7dZzZEV70UtkrYeV3Be4em78sA1NjYHa+GVtJV/66nJdYaklYjaIMD7
   EXvJUfGTlYf/YdyTQRntLUynguQUIbMJ64+k3Hqe540Fq0rYTEbYJ074o
   tw400kNag1ZwytU7BoZZpKXKp+NBrDsZv2lIUfEeViTmP2g2ydy2v1Uxy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338210957"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="338210957"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 22:04:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="680097894"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="680097894"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2023 22:04:06 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 22:04:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 22:04:06 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 22:04:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBNFc1isI2601lgV36fxRJOnAHRZOJhIFwJ/8MrtcGOhZzmGfH4QqOrXBFOo5oZjxkkC9HPNmWCoqohLLickhcKlttY6c6mrQZU2b0XJky+ueHUJH0CtneaDPgIOcrnQvAyYhba+dfJaggcE4CtKihUel0yCh7NasKPgs78v30yrPYIa5jQihXGoCjNGbGmsv6fUL6NzMUyz5qqotqVufew6QxMRcSyJwpVnSfIVdAKhNxANl+i1pqEBDlqkBUvJsICI0X5nH/RhFnV44BoY59Gi3zJeN3wMvbQDeZlxrqQAPUyG485d0Hn7dDO0d+/p4Lj/ie7dOrgNSG0DzI4o8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngeVjLXXp6PhhtINcgGbIL+kmtWlCqDUdOjrR1oMfcY=;
 b=JRj03HZ8m+L4OSDz52dL5BwU9pSIuinXOddlbJU0ubxlaITAJJnTAWvcZWMyo9+wHVNI06NzxJkqtLxYVGbD8Vol66CckWOt7AvEiqQEbr5zYzEAHUC43SqDYDZGCYNQbj8QtZmh3E751bO5YXEpzdrZZwlJmPdII3mch7TGr82PjY5hj3bMurA9csC8qiVs0wMPdYyEf7wCcBN2fE/9GN0qsSs7zg6LzRsCRfhqZlg5m65Zj8i/aFFlFSjJ09GSTjNkJac+lFQR3uQ1sa0VlFH9gdqShhaoAhmQH/8mL0XARQyWtuREkhLWnerkKnJi1usTWOdH1DmbUQzM87jiOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB7138.namprd11.prod.outlook.com (2603:10b6:806:2a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 06:04:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 06:04:02 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIJ081R6kW/70aeRy5pC5KSt67zf3uAgAAHooA=
Date:   Fri, 10 Mar 2023 06:04:02 +0000
Message-ID: <DS0PR11MB75299B12BFB1A12DF786E6C9C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <BN9PR11MB5276C4BB18EC47CD047D498A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276C4BB18EC47CD047D498A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB7138:EE_
x-ms-office365-filtering-correlation-id: 643a3c62-7c02-4906-fb93-08db212d3f59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3t6GL8JR342b5Aqxyfj7zkiAYiOLPo2h1SegfYgZDw5igxaBbkJQ07zwKNbv5l4PWEwhSBCv92paWBC5Sbl4L/1fscVCDqYAm9PzqK1V37tWm6n5RSzlGNDkJ39O8NBoNUR9a1KchFPV1FLEN+Fq3fX0YyMLZOQ+6LLVUklqR0UbFbsOBYFNLD52fGYKEZ10bP1LbQsP3lJgvegyXbGjzDTUSPBP8gWrTyUYjq9ZA8U104A3FFBFLVjVTpu5d9tpaSgJEnar+vUgFNRLTqZNtEaLPqmhcrGUUBP15WtXSjvGYMVxZk8ovjCKRAuPtFDRLWDq4HCq5qqaZpenwumvsf30bc9Z138UV4LcYPWl4ViOsIhwhqJV401qIqes6xjJkRdSTS2ei0/Y55UAixf54yOnMl+Fn3aN0wG4oi2k2N3ECeEeefmyuEy083+FSntcWtDjPv3tDaRk3iilFAFx2k302Car7JH6Pf/oMhd8I1DK/eUNSbiKk6gBbsahTVWvsabbYRJNL8Px2Y0T5s7KXC6er6Nk0i4M64AXZ8HileaLCx6ZnAG/H5Or9maGNMpqqM9hZCry+Bj4RkzZWvA+Nx5wpRjUqWghgZbc9KKjceYDyjA68fJwBcjKF/Y8uhewSNp0RZsXmQBjoV4O+ic7fpVKAwJTZyigwp+GaagKQG8Ghh31FQKuliZfr2yddO/al0AvLylR4uwtkSlGf45+Fx7pRybFQo3CjX2y2ITKMIE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(110136005)(38070700005)(5660300002)(54906003)(9686003)(186003)(52536014)(478600001)(7416002)(66946007)(66446008)(8676002)(66556008)(66476007)(4326008)(38100700002)(26005)(6506007)(8936002)(64756008)(76116006)(71200400001)(2906002)(7696005)(86362001)(55016003)(41300700001)(82960400001)(122000001)(316002)(33656002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TExxWk9jVjIxMnljZWcyOHd3cHFzekhaNEJ1YjByaFowMzNYQUJMNWVTQUJC?=
 =?utf-8?B?Rll1WUswQjFFZm1vVDZreWZLclZack5icGFFUW5NdklNbEk1aW1NYXZaNTFs?=
 =?utf-8?B?aU1MWExGMFNKVVppYzhvSnBOT1JxSE9kb0Fzc2p3V09iQjc4cmFSR2Y3d20w?=
 =?utf-8?B?T3Z1VWs0QTFseHIwQkR6bWRnTXVhNVY2ZFdodTE2dm1nRU1MMWJ6ZHQ3T3ZK?=
 =?utf-8?B?a01nR216elRmSi9DS29uekRoamtNelBSZjFCVXVOTEJUdnNiUTBNbENna3VR?=
 =?utf-8?B?eFVURXNvWkJHK01BYU5zK3FHM0dKT2lTYUY0bERyK2ZYUmJ4UUo0UERWS3pw?=
 =?utf-8?B?bXBLUVBJU2RRNkp1ZFpnQ2RCQ0ZHTmR3WGVGS2dmOGpIYmxRUmVNSUg3cElH?=
 =?utf-8?B?NWFSRGx4ZXlSZkk4bzF5MkdQUmpyYWwza01wTUo0elE4VFd5bXdhNlFaUnF1?=
 =?utf-8?B?YzZBOW1RcGlkM2JQWk9lRnhpRElJQXpCM3A3M1hlakZWaExzc1FReVp4akdJ?=
 =?utf-8?B?VmxEenRmcXpmOGtwRWhBYXNmWkU3bTlnWDg1QU9pY2NFK0NPR200blhqWXFW?=
 =?utf-8?B?cEFscHFqdVpUVk9YSDFmZi9hTGpxMWlZOHpMM0JobnRNeStpZE1DOUpjbjUv?=
 =?utf-8?B?Ri9mNTRHcU5pZXBHNUIrN0M0YW9PMXpzSzFYbVVSYzlMMGNQd1BWQktRWTcz?=
 =?utf-8?B?K2hFTmRpaktaR1VTakZIVEN3WTY5bFVER21RWlV6TU1hdWNQTUE4SGJWaXhQ?=
 =?utf-8?B?amZ4RkR4VkJkVXVtSzBlNHVBV2ZRaEZ6bkVoVUhVaXduN25pVEFiUkwyNGFY?=
 =?utf-8?B?L3E0M1hCdmg4SXZVN3ZodGxBOEhQRWlEV256bWFVcGRNeDkwbks5Y05jOVht?=
 =?utf-8?B?OE91YUVNVFdQbTVrMEcyODhKS1RjWG9zU3BzNWttVWwwK0tjbTdnQkRqbVFZ?=
 =?utf-8?B?bnNsOUc3b2h6SmNseExHZ3IyalRtSVRGWCtqYy9uMzlTSmpnbE9xc1QvSjhu?=
 =?utf-8?B?SnJIQ0Y5cWw3Vi9WaDZHRmdMRDBpK0t4WEJvdVZHdkZmWVF1enczUE04Z0Nz?=
 =?utf-8?B?T0hieWNmVHhxQlBiUndKZEg1NFJHNmtHN29raVo1OExPV3NKOVJBT3kvZ0Vv?=
 =?utf-8?B?WW9Yd3JvWWE2b2xKbHdXQ25DNUtCVE03dDN2cGhkaEY5T1loc2cwQTRLTVVL?=
 =?utf-8?B?VDhpM1lTWWZPK21XYzZrR04vVHFJWHh5U01sTG1VakFLaE1jYjFsNDBGako1?=
 =?utf-8?B?aWtkMEZNaDlmUk42elVHVmR2VE5ZS2hXUTJtTENrd2JKbnNrZzRTSGdGOXBD?=
 =?utf-8?B?a1kxV3JnekJJbUNiL1l1bkJWKzhzSTFxTHVQZTBOUDhlNVpCckVkblhRa1lR?=
 =?utf-8?B?alBLVlZTcUNiUE12UFlaT2xOdFUzZ1QzYVhIeStUcTEreFVPbndwMGZFRnBr?=
 =?utf-8?B?T1dQNFlXZExva3NqWmNUeHdMaFJ4YlNobzUzVFdOWHFRdHQxeGxwRjU4d3R6?=
 =?utf-8?B?TXJJY2xscjJ4Vk5BTXdRMyt5eVV2VjZoTUNuMDN0RDIrM3FHL00wMFgydFl0?=
 =?utf-8?B?WVRTdytUZGRrYnhrWithMTVabEdEemV2a05mcTFlNzQ5cWlYNVNiSGEvL0x2?=
 =?utf-8?B?Um9teFVCd2dQVlVJNFdqRkFxZUpIQ0lKTk1QUHdOV0Q1cVVySEFoSEpjdFNY?=
 =?utf-8?B?QS9OV3BFRzc1SDBDRURHUjBRSDBmQzliYzViblVhRjFvODVjaXVMVkViMzFT?=
 =?utf-8?B?WlFrYVlwQjd0QWFJR3lPaGlYcUdOczlwaEVwKzBXMFhLODZEb3F1bGRvR1BX?=
 =?utf-8?B?am1Ic09pL0lEbGxWM1VOSUdBOC9NeTlndTdISXZqNWUyNVNwMXRLTTAwZkJR?=
 =?utf-8?B?em9qS3BtNkorMmtuNHVxQkN2djdjb2pWeVZsSGtWSGVheDZ5NHBMeDFQWDJq?=
 =?utf-8?B?NGRTcXZUeW05OFY5dklrekxZckRlQmxLZXJlMUZQWSs1VWd6SG9xN3hhVGhX?=
 =?utf-8?B?R3ZXNlJNNHJpV2NsM0tvT2ZhWXBhNnFWcDBFRytUZ0VSek9CTkZiRG0zR1Vj?=
 =?utf-8?B?WUFraVQxby9Vb0lnKy9BS0w2aFo2OHpsY2xodXhrcEl2cFFpRHc5ZXRLRkdk?=
 =?utf-8?Q?ckn8uhbDKc9/PjcS7pGKTCp0r?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 643a3c62-7c02-4906-fb93-08db212d3f59
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 06:04:02.3007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JdHfQfGVmvrzg7GSK0rgmgg1+r1o9vJWEGVBIiJa/w6LX1EerH9OLgZcsJ+f/T2N1vkbgTaHRUu1l4i9fqsmzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7138
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRh
eSwgTWFyY2ggMTAsIDIwMjMgMTozMSBQTQ0KPiANCj4gPiBGcm9tOiBZaSBMaXUNCj4gPiBTZW50
OiBXZWRuZXNkYXksIE1hcmNoIDgsIDIwMjMgOToyOSBQTQ0KPiA+DQo+ID4gVGhpcyBpcyBhbm90
aGVyIG1ldGhvZCB0byBpc3N1ZSBQQ0kgaG90IHJlc2V0IGZvciB0aGUgdXNlcnMgdGhhdCBib3Vu
ZHMNCj4gPiBkZXZpY2UgdG8gYSBwb3NpdGl2ZSBpb21tdWZkIHZhbHVlLiBJbiBzdWNoIGNhc2Us
IGlvbW11ZmQgaXMgYSBwcm9vZiBvZg0KPiA+IGRldmljZSBvd25lcnNoaXAuIEJ5IHBhc3Npbmcg
YSB6ZXJvLWxlbmd0aCBmZCBhcnJheSwgdXNlciBpbmRpY2F0ZXMga2VybmVsDQo+ID4gdG8gZG8g
b3duZXJzaGlwIGNoZWNrIHdpdGggdGhlIGJvdW5kIGlvbW11ZmQuIEFsbCB0aGUgb3BlbmVkIGRl
dmljZXMNCj4gPiB3aXRoaW4NCj4gPiB0aGUgYWZmZWN0ZWQgZGV2X3NldCBzaG91bGQgaGF2ZSBi
ZWVuIGJvdW5kIHRvIHRoZSBzYW1lIGlvbW11ZmQuIFRoaXMNCj4gaXMNCj4gPiBzaW1wbGVyIGFu
ZCBmYXN0ZXIgYXMgdXNlciBkb2VzIG5vdCBuZWVkIHRvIHBhc3MgYSBzZXQgb2YgZmRzIGFuZCBr
ZXJuZWwNCj4gPiBubyBuZWVkIHRvIHNlYXJjaCB0aGUgZGV2aWNlIHdpdGhpbiB0aGUgZ2l2ZW4g
ZmRzLg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEu
Y29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPg0KPiAN
Cj4gSSB0aGluayB5b3UgYWxzbyBuZWVkIGEgcy1vLWIgZnJvbSBKYXNvbiBzaW5jZSBoZSB3cm90
ZSBtb3N0IG9mIHRoZQ0KPiBjb2RlIGhlcmUuDQoNClllcywgaXQgaXMuIEknbGwgYWRkIGl0IGlm
IG5vIG9iamVjdGlvbiBmcm9tIEphc29uLg0KDQo+ID4gK3N0cnVjdCBpb21tdWZkX2N0eCAqdmZp
b19pb21tdWZkX3BoeXNpY2FsX2N0eChzdHJ1Y3QgdmZpb19kZXZpY2UNCj4gKnZkZXYpDQo+ID4g
K3sNCj4gPiArCS8qIE9ubHkgc2VydmUgZm9yIHBoeXNpY2FsIGRldmljZSAqLw0KPiA+ICsJaWYg
KCF2ZGV2LT5pb21tdWZkX2RldmljZSkNCj4gPiArCQlyZXR1cm4gTlVMTDsNCj4gDQo+IHBvaW50
bGVzcyBjb21tZW50DQoNCldpbGwgcmVtb3ZlIGl0Lg0KDQo+ID4gLS0tIGEvaW5jbHVkZS91YXBp
L2xpbnV4L3ZmaW8uaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPiBA
QCAtNjgyLDYgKzY4MiwxMSBAQCBzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0X2luZm8gew0KPiA+
ICAgKiBUaGUgb3duZXJzaGlwIGNhbiBiZSBwcm92ZWQgYnk6DQo+ID4gICAqICAgLSBBbiBhcnJh
eSBvZiBncm91cCBmZHMNCj4gPiAgICogICAtIEFuIGFycmF5IG9mIGRldmljZSBmZHMNCj4gPiAr
ICogICAtIEEgemVyby1sZW5ndGggYXJyYXkNCj4gPiArICoNCj4gPiArICogSW4gdGhlIGxhc3Qg
Y2FzZSBhbGwgYWZmZWN0ZWQgZGV2aWNlcyB3aGljaCBhcmUgb3BlbmVkIGJ5IHRoaXMgdXNlcg0K
PiA+ICsgKiBtdXN0IGhhdmUgYmVlbiBib3VuZCB0byBhIHNhbWUgaW9tbXVmZF9jdHguICBUaGlz
IGFwcHJvYWNoIGlzIG9ubHkNCj4gPiArICogYXZhaWxhYmxlIGZvciBkZXZpY2VzIGJvdW5kIHRv
IHBvc2l0aXZlIGlvbW11ZmQuDQo+IA0KPiBBcyB3ZSBjaGF0dGVkIGJlZm9yZSBJIHN0aWxsIHRo
aW5rIHRoZSBsYXN0IHNlbnRlbmNlIGlzIHBvaW50bGVzcy4gSWYgYSBkZXZpY2UNCj4gaXMgYm91
bmQgdG8gbmVnYXRpdmUgaW9tbXVmZCB2YWx1ZSAoaS5lLiBub2lvbW11KSBpdCBkb2Vzbid0IGhh
dmUgYQ0KPiB2YWxpZCBpb21tdWZkX2N0eCBzbyB3b24ndCBtZWV0ICJib3VuZCB0byBhIHNhbWUg
aW9tbXVmZF9jdHgiLg0KDQpZZXMsIGl0IGlzLiBCdXQgaW9tbXVmZF9jdHggaXMgbW9yZSBhIGtl
cm5lbCB0aGluZywgdXNlcnNwYWNlIG1heSBqdXN0DQprbm93IHdoZXRoZXIgaXQgaGFzIGJvdW5k
IGEgcG9zaXRpdmUgaW9tbXVmZCBvciBhIG5lZ2F0aXZlIGlvbW11ZmQNCnRvIHRoZSBkZXZpY2Uu
IFNvIHBvc2l0aXZlIGlvbW11ZmQgbWF5IGJlIG1vcmUgc3RyYWlnaHRmb3J3YXJkIHRvDQp1c2Vy
c3BhY2UgcHJvZ3JhbW1lcnMuIPCfmIogSWYgaXQncyByZWFsbHkgcmVkdW5kYW50LCBJIGNhbiBy
ZW1vdmUgaXQNCmFzIHdlbGwuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
