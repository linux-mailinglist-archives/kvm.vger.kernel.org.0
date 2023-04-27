Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9D36F0144
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbjD0HJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbjD0HJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:09:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A7D269F;
        Thu, 27 Apr 2023 00:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682579395; x=1714115395;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kOXUhbDbfyqhcsZtiGLUtbmE8pRVn6xS4dRJdRBfjcs=;
  b=gzFGTAB1lqrQiaUsce7kpg1dDBKptFxXURQRne7teOWbemL/bg8Cxebe
   FTkdeINZDGPvAJe1s/WorLpz+AQ/ANyHlcWOpr7rI9hlrn4ZspNrALs4Q
   79H0+a7Y0Wn2yM1sbXc4yPmnf+dYNnax8cUOzwagyQTRk5BULsiaYFAeH
   Kkb2kYDx0tZeo92GG6xXQhyv9oXiiF2G9d05ax4KMVXlcp6YjnkqY+O46
   31AuIlFYvoFKztvBSv2TBcd2LRirOTmY5ckHRvajNZADfJJX6PBQLKxzl
   7/fNXMBulYntW6/kH8SAggi5F4+RUZez3bVjhwhswERPFlZDzk8x7Cul7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="346111008"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="346111008"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 00:09:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="940549354"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="940549354"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 27 Apr 2023 00:09:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:09:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 00:09:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 00:09:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uru/JNkh9bFvSQpkQiOaN2T6vfcLttTHPOxANEuXvRS/NKUnSwkyq3oHf4H56tT8e6xE2n/X6TU7qpSAHfKtmD3EvE0/hfXgHu2bQZKJeJh3QlKq+8lLPymWo8vGP+e+OiDdB8Db6B3VlUWvdnfdJrB6QHFNwRJj0BhCC5ar2+SUuZdBkzd2jbYQCWeWkUB0rU/T4qVY8IbG5VICJ2HO+v1SDSbMRbet2Q9bmU/KYosWcNj6N2R007IVUU1mAfk8Xe1wfRUhZ36zfjQWIp3FGBprmj0hbXAOGdv4FyLm7ZXmNEB2O3/J6ALRzUTSZakC6MUpCWe71eGqXbNCn7UXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOXUhbDbfyqhcsZtiGLUtbmE8pRVn6xS4dRJdRBfjcs=;
 b=DCMMHKfRpVa9RB2ff62yRdX8lqxAeyqUymChO3fajLdyYbHNZW4kVVXpLgMHXOHrp5kmnoQyCCNl4frk1Gk/dcX+ta7XWAknbn0D01STAF89VFrzNmHSNbdPUaMHpHgtwlVpWJEebmRRF11LLP4DNiXwfzDABQZLe4vVLM/GoYd3zVBOYf1GVmgYaE5EaVscxD4Rx/I/durXQwMWBIQeScODaX5cZq+96k9yzYGS+cPErUCcOycAE7iX+CO/0nBe07K7+mASt0Ln56YPtB0Qiq52ABheMSIw+ezTKE7/Z5OBp8udcZ3ZCXSPI/f8FTjmwplFCE3M9YsoRT2LUQOt6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB7966.namprd11.prod.outlook.com (2603:10b6:510:25d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 07:09:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 07:09:39 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 6/9] iommufd: Reserved -1 in the iommufd xarray
Thread-Topic: [PATCH v4 6/9] iommufd: Reserved -1 in the iommufd xarray
Thread-Index: AQHZeE8KR0uwp04aWEmqYZMwzqE8468+thcAgAAHUvA=
Date:   Thu, 27 Apr 2023 07:09:38 +0000
Message-ID: <DS0PR11MB752976E4A6838A6769EB1120C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-7-yi.l.liu@intel.com>
 <BN9PR11MB527637C7DBBC4295F5A3BA358C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527637C7DBBC4295F5A3BA358C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB7966:EE_
x-ms-office365-filtering-correlation-id: 39786d26-7556-4ae7-dfc9-08db46ee5d8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wsN5yLvYdQXv50fAgHQxcus1AX7Rj9H+JdypHCaYAuAQJk8tZ6fGpGwjOoxwXZh4gR6LDeWQQIiBK2APCgx42/j19UrjYE+hCRLVNW49VtPGVr3RfTDsOmcCSxkFke0xDHs3q+hOkCaPJKAoB91SFRy7pTmtpZM7e1StASiZYJtsDyTEWFCT5X1lhKVU3FnH5k5nZfrVPUxn/mZtOSdkeDwlizeheM8H2nR06wU0PfOmnmpyxXZB6HVTwRokYspmhZsyhAdE3uALGE7NI0uNZz2F6gGzsyz2Xw3mqWDodqlr1CDqtUn5FwdAxbO3YIcArpqo/Lhgzffj//xKi6Ca/9t12GWpyLV/QWQRa0vxm8PC3Nm8P7RuC1+PvkjqCRNo4aVLtUJZRjDZOYjMwk7NgvjsUkkekfo9VtUtfGSYXgvQN4OcLdgSu0drCDQ3m3Ig/Ooa/n6KjKRMYERC22F4F3AfwAUvbzRcp6UWQbO0cZ8OC1QnyxM0/QpuYUZYq3hoGIMsHUC+LpuDA7W5BX7QdbNMpjbzSyFFkLA2ty9nEBrXVyFuEQm9gbAHg79bLfV0cSX8r3LpxO5+35sYIIqmyVtwvNC8EQ/HhA1xpCGYVqz/ptRqnk19neprvDMlarpY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(52536014)(122000001)(41300700001)(26005)(9686003)(6506007)(5660300002)(82960400001)(38070700005)(8936002)(8676002)(83380400001)(7416002)(2906002)(38100700002)(4326008)(316002)(66556008)(66446008)(66946007)(76116006)(64756008)(66476007)(186003)(478600001)(86362001)(33656002)(55016003)(110136005)(54906003)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUMzdTc5KzhacjgySENiYkVUS0x6Q3FEVis4cWE4cmErOSswQjBrVlZMRGEv?=
 =?utf-8?B?QU1Tb2RXYzBoWjlwUTVMb0Q2QnRybVJ2dE40NHVvRWtsV1Bia1pGeGY1c1o2?=
 =?utf-8?B?ZE5VNlM1SnVzVHNWYUdZL2dQc0k2eHBTZ1FyanQzSWoyTmxyc0Y2TDV3UUdK?=
 =?utf-8?B?OUhRd3ZRaDZGWnBFSWZsSU5EVFMyeFcxUTlKNmNBS25vODBjS0FuVlU4MjVk?=
 =?utf-8?B?d3dmMXBJVWQvSm1wUXpINlcveGlxcGVzUjl0eFowZVdQR1paMWIyK25vRDRM?=
 =?utf-8?B?dHVpTlZrUXlGMWtjeTB0NVhDZXpJUlI1Y1A4TFU4bTVweDhTUDNCcW85bzZw?=
 =?utf-8?B?NWtSV1pMVis3YXBiQWlFbFMwc21sKy9yODlMaHZkMG9ZUGJHdXlHd0FLZkpY?=
 =?utf-8?B?RUtBaEUzbVg2SlZ5YWo3NGlLNE1QR0ZCK1FDOWdOQmk4cU5JbGhLc2FybnJ1?=
 =?utf-8?B?RDhsZHM5R3F5NWxRaFJzS1JlbWovWnFBcng5Wm5RWmNxV0VBaGFWVFJrQ1JN?=
 =?utf-8?B?ZTRPN1k5YjlQZzJTSGV1LzRyYUpJTzQ2YTRRclJ6MmIvYURiejAzenZtUkQz?=
 =?utf-8?B?YWNrZEJvazFjVkVCU3d2UUdOblc5WTA1TS8vL0NtZ1ZpVm5zaVJCc0huWFpD?=
 =?utf-8?B?c2NkYXNNSmNXbDUwdnRjK1NnRVk3TW51blhHdm1IKzJVK2JKWk5VTlVOdjBk?=
 =?utf-8?B?RElGSUVwcnBXQ3pLOCtvNk1ROWhhWDcvYUZVYzZqL1BSdVZRanBUMVJWY2lq?=
 =?utf-8?B?M2VqQ0kvVHcxRmhXSktjdVMyR3BWNkRLNXhvZ2ZMNS9oQUYxUjd3OThpeWlI?=
 =?utf-8?B?SnluK0MwRm8rQlBVaE9IcHBKaHpuclErOGZOWVVFZWhBNWdOdHpFUVRhKzJX?=
 =?utf-8?B?d0tacUVQUkhnUDdkaGVSNndkYUhTN09WcGg2Zlpxa2lEWkpDNFFGYnFkeVJm?=
 =?utf-8?B?RjRaeXIrSWgyL2tVcWJIVXhnVTRvUktlMW9DSDhTTHhWM3ErNlI3QytsaVBo?=
 =?utf-8?B?TVJhUExscDZMamJPMzZub1dPckNPbmJPL3c2WmYrbFdmNDJBeTdOVm9xRU9s?=
 =?utf-8?B?YkF4Y3BJMnB6V2R3SHlkMFRBbEsrNjdzQzZCdHh1V25Xdmo2TzFqWGdhdFVE?=
 =?utf-8?B?M3hUUnhiQXdkOEtFZ1BubmlhMldabEJDYXBIaGFqZFFkVkhQWlRGTHpsaW9N?=
 =?utf-8?B?NEVML1RrTW5qOW9UM0RNeElRUnFqbVArYllpdzkvaW9jZTFtdHRCTGt5bTFV?=
 =?utf-8?B?OU1ET2s0c0J5Lzcya1FIZGwzcGVFS2E1alBnQVptNUp4VDF3UDJKOTVvQnI0?=
 =?utf-8?B?elRUNjNJd3QyYkJtWU1DVXBBVURzdjFKWXBrUFlJN2dmVHdsemdZWUNldDZj?=
 =?utf-8?B?VWZUeWk2b3dzUnExTGVidnk5SzRHeDRlUDd2MGVYZ1ZqNUlSa2FPelExWTJl?=
 =?utf-8?B?Z3ZjZGw2ZWROZWNtaTBaNzU0RmU1KzBlSTlmbEs3cnZEQWJYVTJXMzhzbkEy?=
 =?utf-8?B?T2JtR0NBQlh6L214RWhVbjFMUWJBZERsWkxFRWxHNW5VWko3blZhUzdQcy9j?=
 =?utf-8?B?U2J2WDlNSTBDeVdhNmNGc05pNGp4UzIwckpyWm42WkpPUS9kS2FzZmFGcGdV?=
 =?utf-8?B?OU8vUnhHelpKTUZ2RVZRZ3hReThVZFhJY0JFTWExcVJucWt1N3ZiU0tNWnIz?=
 =?utf-8?B?RUoxOU45V3FNREZGWkU5VjY3TWxEakZQWUFLcVVHT0g4cEd2WGtRWjl6Uzdw?=
 =?utf-8?B?aERkQ0tkQWJDcVVQT2JlREcyN1cxN0NWRENJZnlrRTlrOENQTTRpWHZ2cjVj?=
 =?utf-8?B?ZlhkajF0T1NGV0ZsS1QxQ09WdEN4MU8rcmtXUTZvcjhiSk1aRXJ0Z1ZENDVU?=
 =?utf-8?B?MGdjcHlNMW9TVkNaYng3N0JnY3FaOEFyZXRTb2s5ZmFOdjFRZ2hic1RESHIr?=
 =?utf-8?B?eFFYeEZUZHpaTGFEbm9tKytvOVdJVENFTkFpZzVYNVptMnQzYWFQZ1VBQjhQ?=
 =?utf-8?B?RzgwUFpvZmx6dlgzbWcxUjlNQWFTa3NGb3doOCtYVGlsbC95ZzlJK0VtY0d2?=
 =?utf-8?B?enM0cTR4TFVtSHpNNGxHVDY5S3I5bmxZbXpIRFJEVmwxR2FFdVE3ZVdyQmtO?=
 =?utf-8?Q?Sf+edXxvi7w8b5BPNMD/rh2P0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39786d26-7556-4ae7-dfc9-08db46ee5d8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 07:09:38.8457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 20c4BJsDfJKbP/JvzLEzKlKWhDJelNofda44A4+QmmwmCdTYvKfnnmsv2ukll0TLEyN0D9bv/gllcnnvWOkyMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7966
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBBcHJpbCAyNywgMjAyMyAyOjQyIFBNDQo+IA0KPiA+IEZyb206IExpdSwgWWkgTCA8eWku
bC5saXVAaW50ZWwuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjYsIDIwMjMgMTA6
NTQgUE0NCj4gPg0KPiA+IFZGSU8gbmVlZHMgdHdvIHJlc2VydmVkIHZhbHVlcy4gMCBpcyBhbHJl
YWR5IHJlc2VydmVkIGJ5IGluaXRpYWxpemluZw0KPiA+IHhhcnJheSB3aXRoIFhBX0ZMQUdTX0FM
TE9DMS4gVGhpcyByZXNlcnZlcyAtMSBieSBsaW1pdGluZyB0aGUgeGEgYWxsb2MNCj4gPiByYW5n
ZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPg0K
PiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2lvbW11ZmQvbWFpbi5jIHwgNSArKysrLQ0KPiA+
ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pb21tdWZkL21haW4uYw0KPiA+IGIvZHJpdmVy
cy9pb21tdS9pb21tdWZkL21haW4uYw0KPiA+IGluZGV4IDNmYmU2MzZjM2Q4YS4uNTFiMjdjOTZj
NTJmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW9tbXVmZC9tYWluLmMNCj4gPiAr
KysgYi9kcml2ZXJzL2lvbW11L2lvbW11ZmQvbWFpbi5jDQo+ID4gQEAgLTI4LDYgKzI4LDkgQEAg
c3RydWN0IGlvbW11ZmRfb2JqZWN0X29wcyB7DQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW9t
bXVmZF9vYmplY3Rfb3BzIGlvbW11ZmRfb2JqZWN0X29wc1tdOw0KPiA+ICBzdGF0aWMgc3RydWN0
IG1pc2NkZXZpY2UgdmZpb19taXNjX2RldjsNCj4gPg0KPiA+ICsvKiAtMSBpcyByZXNlcnZlZCAq
Lw0KPiA+ICsjZGVmaW5lIGlvbW11ZmRfeGFfbGltaXRfMzJiIFhBX0xJTUlUKDAsICgtMlUpKQ0K
PiA+ICsNCj4gPiAgc3RydWN0IGlvbW11ZmRfb2JqZWN0ICpfaW9tbXVmZF9vYmplY3RfYWxsb2Mo
c3RydWN0IGlvbW11ZmRfY3R4ICppY3R4LA0KPiA+ICAJCQkJCSAgICAgc2l6ZV90IHNpemUsDQo+
ID4gIAkJCQkJICAgICBlbnVtIGlvbW11ZmRfb2JqZWN0X3R5cGUgdHlwZSkNCj4gPiBAQCAtNTAs
NyArNTMsNyBAQCBzdHJ1Y3QgaW9tbXVmZF9vYmplY3QgKl9pb21tdWZkX29iamVjdF9hbGxvYyhz
dHJ1Y3QNCj4gPiBpb21tdWZkX2N0eCAqaWN0eCwNCj4gPiAgCSAqIGJlZm9yZSBjYWxsaW5nIGlv
bW11ZmRfb2JqZWN0X2ZpbmFsaXplKCkuDQo+ID4gIAkgKi8NCj4gPiAgCXJjID0geGFfYWxsb2Mo
JmljdHgtPm9iamVjdHMsICZvYmotPmlkLCBYQV9aRVJPX0VOVFJZLA0KPiA+IC0JCSAgICAgIHhh
X2xpbWl0XzMyYiwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gPiArCQkgICAgICBpb21tdWZkX3hh
X2xpbWl0XzMyYiwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gDQo+IEp1c3QgZGlyZWN0IHVzZSBY
QV9MSU1JVCgpIGhlcmUuDQoNCk9rLg0KDQo+IGJ0dyBkbyB3ZSBuZWVkIGEgY29udHJhY3Qgc28g
dmZpbyBjYW4gbGVhcm4gMCBhbmQgLTEgYXJlIHJlc2VydmVkIG9yDQo+IGZpbmUgdG8gaGF2ZSBh
IGZpeGVkIGFzc3VtcHRpb24gaW4gbGF0ZXIgcGF0Y2hlcz8NCg0KSSBkb3VidCBob3cgdG8gZG8g
aXQuIOKYuSBASmFzb24/IFdoYXQgYWJvdXQgeW91ciBvcGluaW9uPw0KDQpSZWdhcmRzLA0KWWkg
TGl1DQoNCg==
