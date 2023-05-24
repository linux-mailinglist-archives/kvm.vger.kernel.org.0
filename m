Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D2E70EB72
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbjEXCki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239152AbjEXCkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:40:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AFC18C;
        Tue, 23 May 2023 19:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684896034; x=1716432034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=714PjEPBuHtkF8WESA9llLiU9Jc925oq3PmuReOHxIA=;
  b=ipgYXBs11iUY/2pYIAciRusYoTgzrv2h2yz78HLnRTu3mbFapmyEYsAP
   mcppOCXqQqbuHzjROYWQP0pjeC+JaUeqOP5uaW1E1zHMxTrm+pWrAw342
   5PNiLFuF78TpPOOXvU8ZOkV1RlYH1ATQy0+OYR35z3tC+GVHHUzo10QMM
   +a7hxAHKF1aMoZr81pG3kwyQV4dKHZb/jHAc6MXbeoTRJK+9MVNmshBAE
   Q5lE+5p123yUEP3ILTjN9PmPVCFSlhWulcRp+q2O9n4cpo3YWjeAtvobu
   wznnOmeDhM3hYOuRCaOMachB7JUrHgV+bLP9bpbk6WCogdQmcESO+kX/t
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="333794524"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="333794524"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:40:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="828371720"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="828371720"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 23 May 2023 19:40:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:40:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:40:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:40:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdhyF1nCObqyZWLQsJjqErsq6c0SX/j7sD7xqNu4DMG45hnEUnvFs/xwhOXKgiyW/SDaBgZnQttBulMN5b69UjxbAMK0am170X1EnzEFxqRXlW9EJzRC4HLB84xmUB+kvMx3epB+N9MOzHEuvi1encK94wyQSvFeL3aq3fBXnpELSw9pd+d9zLXltzn5oS29E6ELCANRg5Cw24/jEa0fEDziapU2+wpdvXdtTl0OozD6Y8qkbQuNpSznDFtIwn1A6KG1GjZsfoDjpiQy2hO3PqReUkGfYju+jdC/Kn3WwL0KC0GcsxTaVz9ZR270z4r2eJE69MSJHATIJvcdVusmXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=714PjEPBuHtkF8WESA9llLiU9Jc925oq3PmuReOHxIA=;
 b=g4JkwrXM/P737YMcm/h6SxG5hVgLY/nW7wZQWdANHnSdJMfEB60L9RUIPjsO5wETlIj4VRZYJkoUtZEuyOA1d+Clz3qQnJRlP50O6Io3y+Mam9V9LyVBQtZzQVimPqZYseg9YEViwcVG1kkDsPXUK7LQr/zwzHlq7swqdQ0VlU+bsMy/rannXNHbSqvEEhw+KgOakeFFepmVmEJlMC6sGi2msUYW/WRW8j6xbGYTl+DMmx1swz2lg8ZWVn29CyAR/AnZIqmjbI8MWexQgQ3LAaW9AazZuBlpar9q7yCVO6XbD8PRQdaLQ4gaQJtSm8RA7aIQhqR0r+KoJDCEDP+7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB6541.namprd11.prod.outlook.com (2603:10b6:8:d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 02:40:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 02:40:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZhZ7k65TFikm5KUKI3FkaFFDbUK9m5qgAgAA8RCCAAO6sgIAArYHQgAAHgQCAAAA4gA==
Date:   Wed, 24 May 2023 02:40:30 +0000
Message-ID: <DS0PR11MB7529F262A9088E582700C3AAC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
        <20230522160124.768430b4.alex.williamson@redhat.com>
        <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095121.1a7a255d.alex.williamson@redhat.com>
 <DS0PR11MB75292184D6938DF4193C318EC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276415D558B1BBA5C19A2AA8C419@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276415D558B1BBA5C19A2AA8C419@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB6541:EE_
x-ms-office365-filtering-correlation-id: e1a49a93-334f-4c7b-0510-08db5c003d91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QRmvl8HWKBltm8O4ldTib7rAmsIwiMFVLKARn6FxKA3ht5tUozqIyLYd+hPkAK8800R7RsbBnidXjcKww2QklH2prXJwXoBB4RGtPGSDL3OzqPKGKgeJBIx3F+VzRoYlN8+rrZMWjhlWQ5CM2hVzkBUgLw1NWZMez14nCeLp1dQ9O9Hd3QlArqcFKppQBTggc0C//xZkg9XLhbvkFVoppikPvAh28RrWunQg+p5yD7hB/wb8DeSdpKWBh5+CbpGcZAmH5KDxzICq7YmO2OsVsCa16iG8jr/K0pxuiQmqMjDrhQv0n8LK5TFjGBuBBJg29oVeNqQPSlfRc/UjQ8RJLEBtRSQ1MHyMRODeAT21iERveAujTA9z5uMlXvZuHrF69c5jY8rQxzTdD+Tf/TOIyzp1/64hC/pEiU64g1+jOvikrMdrvJqCz00KgRsShC8YhITvzAESIt7JZDKDHOY/L7yvSnfJ0HLN1IVvfSVGOIBlVzsZBf32qq4O5YcEQEfuDQYg+VuYm2rEI4uOeBBmWZ7rCC3G21V+sIi5xQGnvwcXVzPY7CoDSb+6kqwrZYwGd0144mnycaEf5guyP6HHUdCzSxvRTugLD6Js3mv5IOKy9DlP9675kOv8zgFDm6PGvGL/QX7V4CR6wH/5bNiRWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(9686003)(8936002)(8676002)(7416002)(83380400001)(82960400001)(38100700002)(86362001)(38070700005)(122000001)(33656002)(55016003)(6506007)(4744005)(2906002)(41300700001)(71200400001)(66946007)(76116006)(66556008)(66476007)(66446008)(64756008)(4326008)(7696005)(316002)(5660300002)(110136005)(54906003)(186003)(26005)(478600001)(52536014)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UytaREc5VFpxeDNMeWNxMXZkU2xwL3d0OU12MmRqd0k3SHZLODNWaVJBNVRv?=
 =?utf-8?B?cmphSDZoU2Q5M1RiV2p6L1ZHRzBsd3BVbHJiVXZ2Q1RFeTdnakI2NWN4bkhx?=
 =?utf-8?B?NE44Z0FnSnpNMm5iMitTODQwSlRveE4yREsvRHkyWExJdjh3dnVuM21hYnM4?=
 =?utf-8?B?SnFlaDNPSFNXeGJKcEpnQWJrL1krRTUwZGJOZ2NPSGNDbWFIZDdndy9Ocjg0?=
 =?utf-8?B?NUZnbVIwZTdyNXBpYUlYbEhBUWhiTi9tS29SbEU2U3VMdzVIend4ZGFaYnNM?=
 =?utf-8?B?QWZZRktqQW4xVFNQaW4xYnJDQWVJSG5vVGxncUlqbjFDRlFTZ3RmTW1tY0k2?=
 =?utf-8?B?NHdibU1id1lYcmpVdGNZbDltUDhZYzc2Nkpubmp4ZFJCbDRISS9NK3hXUWVU?=
 =?utf-8?B?UVYzZXJ5SHhDUUQySlh2VmNuaFV5d3BEbTZZLzY4ZkZnVU13RTdVM2NpQ3ln?=
 =?utf-8?B?cUJYRVBOZ25OUk1lSWhCSEl3S3M5eVBWWlNqNnpzUS9wRHJCbmVEblNyM242?=
 =?utf-8?B?K0lFL05FRUR5dWRtV0xybTY2TWlISVNzaDBGVFRndFVZanQrbUc3UWtCYXFX?=
 =?utf-8?B?ZWtqWjhUSnNpWE01TWwrWFZjVW1YWVFzWkY5eG85TlQwNm1BOFI0WndkT1py?=
 =?utf-8?B?emNIZFZNMWQwdS9uSE1aZVo3akd1aFBQbDY5RThNNVJKcGZaVXZQQUczWU12?=
 =?utf-8?B?UUZSV0RSK09TaE1Bb09ERE1lckoxVUJoMVc3bEJtbElOTmxJN09EZExOTVlz?=
 =?utf-8?B?eHQ2aDlCWERhdzRhUlpjZHZRWjJzczV3dFhJTDV6R2t0YmtyQzBJcFdTR0Jl?=
 =?utf-8?B?eGs2UTRWdDFqQXdFZW5ma2lNSzVPNjhxalZKbnJ0emI2MktiY3BlVC83a3FC?=
 =?utf-8?B?cWI4TWpKbkNEa2VOdHJqaFhCaEhDa2NYNGxFMW40dEhrZWxqbzhibk5oN1Zp?=
 =?utf-8?B?bHZWQS9tOVJtdGdsSUtLY05lQURBcmx4ZHo1VlJDRWx5SHRMTGxacHFGVUNZ?=
 =?utf-8?B?SHlDdVdkeDgwaVhaektIbVdkVlh4L1hBcFZUcGE1OHhuTmVxOTZFUWVJRUdz?=
 =?utf-8?B?UzlxYjU4bHpudFdmWHA2RzZZbkh2YnplalViVEZPeHNIMFE1Q1NVcHNUZmFH?=
 =?utf-8?B?Sy9UeTA3NWxSRjg0S2FJNzdSVHBubnp0cDFTcUZDbzJvQ3cxVXQ5Yk1rRDU4?=
 =?utf-8?B?SDZHR1VyOEM1cFp2d0wrOVFGWEsxMDM1aDBuMVlLYmFhczFkVEpKZnNZay9Y?=
 =?utf-8?B?eERWZ3FSdDRTK0JFaXYrWDJ3UkhpeE9wM21EYU8vT0NaSDVCVWMrakEyY2p5?=
 =?utf-8?B?NGpnbUlkc00xY1htczNpQ1RnL0tUOHhKRlh3aHRUeWtvZVBPbjE4Y3IxVUUr?=
 =?utf-8?B?ejBVM0oxaXVLaTFQUTNCWU1XNkRXUmJYVGhGMTV6ZjVybE55NCtyYUtXNWJx?=
 =?utf-8?B?Q3AxeXc2WmJBK1pETVZ3WDZrTGRjSWVqWS9rQnlqVFh4RFZMa0w5RHdXRUNs?=
 =?utf-8?B?OHBWVFJsTmNPbjUxN29WYWhPc3NiS0pqVnZGNHFITjhGTjhzTlhwdGNwYmNV?=
 =?utf-8?B?Q1E5azRLSlZnbC9hS3ZFUWNwVURaTGVScGFpMzZ3b09pV1NZVmVYNTZadmFs?=
 =?utf-8?B?aUdURVd2ajFTdXRINzBKbEdMVHA4RWpMN2MrSXBZbHJySSsvcWM4UThYeGxo?=
 =?utf-8?B?cXBERlpHbndqRnlSS2lONFJCa3N5Rk1RQkhGeGpVZ053SkxXV055d3RYK0JY?=
 =?utf-8?B?Tkt1cmdwSTVJbHh4UCtZTXptNURMN0x2aWpOUFB0MGRPVGlkbnpNenp1dUp2?=
 =?utf-8?B?Rk8zeStoRjBFemt6UnRKWnIwMW9mVU9KMHJ0blpmd204UXhiOTNFeDhMZFgw?=
 =?utf-8?B?MkM0UXVaWG5YTjMrb0JIelZjdnJ0NWR5cHNhcFFiNzZwak5aejBWc3dCNXNY?=
 =?utf-8?B?dHljWXd5Lzh5Q1ZnZ3V6YVYxNUljKytoQW9nSS9LWU0ydGhOTnpHZGR3cFEv?=
 =?utf-8?B?R1lLYTkycHF3bGxLNlFoTHI5dVZGZTI0d3VFT1NYODVxcDJPZW5yWnE3Wkcx?=
 =?utf-8?B?dkFBSXZvSWdnTWpzUWNBbzVRRFc5Q2JJVWxyRDkrSWNCdzV0a3RzcU9nbnVh?=
 =?utf-8?Q?BiIC0ZMxwxa9EreSDcn1EtqvN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a49a93-334f-4c7b-0510-08db5c003d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 02:40:30.5640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: txHcFsPpqRf0PAitTquYUkN4RS09WI6NhU/vgeHC3udWzy6c87+e8W2SliaYQXad0H8Wkyf371SAlQpIsy/Qng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6541
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

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgTWF5IDI0LCAyMDIzIDEwOjM5IEFNDQo+IA0KPiA+IEZyb206IExpdSwgWWkgTCA8eWku
bC5saXVAaW50ZWwuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDI0LCAyMDIzIDEwOjIx
IEFNDQo+ID4NCj4gPiA+ID4NCj4gPiA+ID4gdmZpb19kZXZpY2Vfb3Blbl9maWxlKCkNCj4gPiA+
ID4gew0KPiA+ID4gPiAJZGV2X3dhcm4oZGV2aWNlLT5kZXYsICJ2ZmlvLW5vaW9tbXUgZGV2aWNl
IG9wZW5lZCBieSB1c2VyICINCj4gPiA+ID4gCQkgICAiKCVzOiVkKVxuIiwgY3VycmVudC0+Y29t
bSwgdGFza19waWRfbnIoY3VycmVudCkpOw0KPiA+ID4gPiB9DQo+ID4gPg0KPiA+ID4gVGhlcmUg
bmVlZHMgdG8gYmUgYSB0YWludCB3aGVuIFZGSU9fR1JPVVAgaXMgZGlzYWJsZWQuICBUaGFua3Ms
DQo+ID4gSSBzZWUuIEkgbWlzdW5kZXJzdG9vZCB5b3UuIFlvdSBhcmUgYXNraW5nIGZvciBhIHRh
aW50LiDwn5iKDQo+ID4NCj4gPiBBY3R1YWxseSwgSSd2ZSBjb25zaWRlcmVkIGl0LiBCdXQgaXQg
YXBwZWFycyB0byBtZSB0aGUgdGFpbnQgaW4NCj4gPiB2ZmlvX2dyb3VwX2ZpbmRfb3JfYWxsb2Mo
KSBpcyBkdWUgdG8gdmZpbyBhbGxvY2F0ZXMgZmFrZSBpb21tdV9ncm91cC4NCj4gPiBUaGlzIHNl
ZW1zIHRvIGJlIGEgdGFpbnQgdG8ga2VybmVsLiBCdXQgbm93LCB5b3UgYXJlIHN1Z2dlc3Rpbmcg
dG8gYWRkDQo+ID4gYSB0YWludCBhcyBsb25nIGFzIG5vaW9tbXUgZGV2aWNlIGlzIHJlZ2lzdGVy
ZWQgdG8gdmZpby4gSXMgaXQ/IElmIHNvLA0KPiANCj4gdGFpbnQgaXMgcmVxdWlyZWQgYmVjYXVz
ZSB0aGUga2VybmVsIGlzIGV4cG9zZWQgdG8gdXNlciBETUEgYXR0YWNrDQo+IGR1ZSB0byBsYWNr
aW5nIG9mIElPTU1VIHByb3RlY3Rpb24uDQo+IA0KPiBmYWtlIGlvbW11X2dyb3VwIGlzIGp1c3Qg
dG8gbWVldCB2ZmlvX2dyb3VwIHJlcXVpcmVtZW50Lg0KDQpHb3QgaXQuIHRoYW5rcy4NCg0KUmVn
YXJkcywNCllpIExpdQ0K
