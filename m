Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2C674723
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjASXYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjASXYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:24:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEC31F90D;
        Thu, 19 Jan 2023 15:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674170652; x=1705706652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+/sno7dazBfaMrTyuFvt713rz8UHVVugmhHLx/hw1Cw=;
  b=GwSTjdFq4thJO2gfLBfU70BGLd7KpjhtN7MChOIUHRRUAR3gQR5uR4sp
   +lvnFoYsvnt5vhxg3B0/uj91G9PWkzlN58gngd+MvJeX4Tyxtitrrgy8l
   5cok6+mYu0EuT2zYcMhzCCQfIiwT5HbHPpxESdZ1ysyuundxDFECV4Eg0
   79CmgbjITVD5CuSG9hdGkf6ymtzkCmgaHf35u1+lxNT/bGDoEj2S8YJtt
   VZimJKTV3D4YFMwKWKsZ7AJ9cIGJ432uOFSCvAK7iEVwhlZ8krWJOzAiC
   YhywWYvk+SJ8vLC6Aoizt+juD7IA7Qb2oAqc4aZJVQY7akagEw2VakmlV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313347873"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="313347873"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:24:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="690824426"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="690824426"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 19 Jan 2023 15:24:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:24:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:24:11 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:24:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEXCY7OinOuq1Ut29TD/c5ZiW94TLR0A6HiN/ZB/34v7i5/wUx/krsFRshAP1xWy3gK/G1F6Y1CiVWwLBoVCuRk85Tl4xA9Zo31krCEe5lCkUhwomA6dp/HX8eA8cX4FXPgHwoH89r79d2qkQ86HsY8AIToTrFpyhGVzQpZgv4LDz9g6cshx+dxaxD6hUAI4pi2MWSb8tQoj1jtN3GZchpOKbdMm7E9z0qb1pY8qMYGSFcYzxL0wgz3kIIc4otCQMV6pImjqqRnNz6zAQbOton5z3eI9Mb4oEEK3sYZDvOXdBtcZDSxZRbGZO41Hq8qhNGtKYeFoa262V87gzZGQOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/sno7dazBfaMrTyuFvt713rz8UHVVugmhHLx/hw1Cw=;
 b=k7CLxoiztKBcXJrXIu4RnQQ+KimIu6iqJJt0EvUwso9/qNk+T8/LxHn0bnZ95Bz9Zc0W8v4uqrJ/CWDtJktYOCtA4T2otzo/Cx0EB+s43eqRnE8nUPNhu5JeWUiSkympwcYF3t0k14txXQsS3SFCYDghPo7T6oD5gzsXJhBsdjXFPI0pOlXOmCucz6LtXyi+aCWakKUKR3awTq1NM9aWiEWqE8ogkXuE/EAI0cfWHf7Rqqa2RVw7XR5BM074/vh4LS9mO1LbUmbEH/gayLKE6btFdiMD63R+L/lKHymsJLnGmdx1HaVbv0DOoW+T8yw+IPUT/UA9+LWRKeI6XBNRdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB8174.namprd11.prod.outlook.com (2603:10b6:208:450::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 23:24:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:24:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAABm5AIAAAM8AgAADfwA=
Date:   Thu, 19 Jan 2023 23:24:03 +0000
Message-ID: <6ad5de218ba9be52d63ebb5846ad6b2d1aa3eab8.camel@intel.com>
References: <20230114111621.00001840@gmail.com>  <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>     <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
         <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
         <Y8ljwsrrBBdh1aYw@google.com>
         <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
         <Y8m34OEVBfL7Q4Ns@google.com>
         <38f506575caacd5488f73315b231c3282f893d46.camel@intel.com>
         <Y8nOIjkskcXAi00V@google.com>
In-Reply-To: <Y8nOIjkskcXAi00V@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB8174:EE_
x-ms-office365-filtering-correlation-id: 1abd1589-7827-4136-ee49-08dafa7440a1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dN1mCNPzB8XPOot6uQITmZJ5LHI78JsCIfsRZYhZJEbMR2zA+9EVA6mdzWC+jOvqz2l0o4m1fYfIUOavD7uDpk1/yV+ixDMhkLECQIrTsApFfVE3uXZkgS8QO6ZEjKx8O8oV83VIEoXoFkyZ8S4DODub2GQ0ZRaFmQ80oBDYf+Gtsybvvlyzl/wwnC5Sc6VYRyrzQZNV0z/2GC1a1dQ/CdwPtYfTYjT9UFxGjeAjRflCWNars8c8cuPuc6G67TFt5gdTzAJt2WVdCTgJRGm6b4JWQASa3T6RjL2zDIF/OzQDEG3nhlAdB3zbX+1aj6ZPuE9YLjCanWeJmMaomgLp3vzbdrj8B10Oks4P0oel9e9gOjwQcLZk4qrUbaj/pfRTy6bM3JKVeRLJ9WOH8t1sNrMltfinhaDnHG5ErA5yl6aTA5KlsPWaUOkchzwGiT4N4WCWp7IGmX1qJDKmX/WxnNd0csIK5iSxCvu58JlDZg+saNR9F8g7k26TTn8pOxDRQkJw1Alk7fdd2Lt9Run2KQe9zEci06BiZJOyh+kRqqHbJMm1frjvtx3GlE1JmnnAEQHyUmNyA01o5+QSMQdYJALvFRZ3X15cxX/m9eOctlS6f88RB2VORa3mfPinIhtubnY9mxq/OO9estBzYfZ5ya7kk1wc3ynN+B7VmA+l3ymkGXl0BJEgRTvU/TfF/fcq/Pyc4EkjCn7W6EqKY0Dddg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(6486002)(478600001)(86362001)(66556008)(122000001)(66946007)(2906002)(91956017)(8936002)(5660300002)(66476007)(82960400001)(76116006)(38100700002)(316002)(54906003)(107886003)(71200400001)(38070700005)(6506007)(36756003)(26005)(64756008)(8676002)(4326008)(66446008)(41300700001)(6916009)(2616005)(186003)(6512007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU4rUGtSbytvSFh5LzdEcjdrNnJ1amkyVkdUQW1GN1RDTy8rMi9PSGpHSzdZ?=
 =?utf-8?B?T3NDaWwxR3htME9MRktMZ2pLQkdNenhBeDN3QU1VeHRrYmlRMzlyMytGZTYy?=
 =?utf-8?B?bnV0V1lqTTl1SktqMm1SbmhRSGdWMzNGeU1IdHNvZ2J1QmdIUmV5dVQ5Mi9G?=
 =?utf-8?B?SDBUdzBWT20xejFPOFVQWDFjUk9TZDBjWE8vanBlQWVLRGhrOEVYMHp6K05n?=
 =?utf-8?B?N1pjWWFFMUF6MlVUTHJXemYzeTNua1Y3ZDdnRUl6VFBOVlJkYjRVN3FNVU1v?=
 =?utf-8?B?VC8zVXdPL3V4YWRRWWN4RXhjZ3FXOW5Tb2VCMGJ4aDcrclgrQkRQakoxUThz?=
 =?utf-8?B?NTl6MDlGa3Y3QytDdHduME9hcXlwOFBzZkZpL0pzc0J4WlFMOGFxUG83aE5F?=
 =?utf-8?B?UWMvb2ZSQVkyL012OG92SnlHWVdoUWJCVHJiZGRGSmc4Q0ZhLzhZS21CWS83?=
 =?utf-8?B?SWpzNzNEa2VQMkF0QXhLY0M4dUNmVEh4dGRPRGJITjR6eWYrVk5lcWNpb0to?=
 =?utf-8?B?c2x0WmVOMEpLaVlhK0J6MW5ZMHRSditkTWJjTkNHVTMxZFZLRTREbXMrajgy?=
 =?utf-8?B?Q0ZVMFJpdmZOY29iUExHam1kSGpPbWNrOTJWaTNUWWJKN2R1VUh3SDhkU0Jj?=
 =?utf-8?B?ZWc5QmVraTNWRWUrcy9oQnduZVJ0RTZWZ3k3NmVqQXVaRStJWkVUSGxrSlVo?=
 =?utf-8?B?Q05nSUpiTDQrRXRXTnlxd0g0ZmRCaTZzVmVyRW9HRlVqZk44Tk45NHdaZE50?=
 =?utf-8?B?OFBUWnNQTGdoQm4wK005SGljR2ZMWkdOdGd6ZGJFK25oNmZQQzZZKzJVKy92?=
 =?utf-8?B?RllPL3hPSUEvU2FDS0Z4VDFhZ2hnMTJlMVlSOUZkOEIzQUk0b1doeDVlNkg2?=
 =?utf-8?B?a2ZMOCtuNXEyQzhpVm9TR3djTGRCRHVZRE5tSkZaODFuN1JLVHJMQVNQWjlq?=
 =?utf-8?B?YlZvWDluaC8wUitBOWlPa1BLRFBXUTY1K3RMaDh1NXZ3REZtRk00QjRJak03?=
 =?utf-8?B?UUR0bHplSmZmUGRXVGJ0aWhMRXFRa1JtcXg2MTNYNGF6SnpIaWRXK3pGd2Ri?=
 =?utf-8?B?RFRJa0VaNVZlSnJrV3dUbjlhYlV6NkFJejRGL004NER2cnF1Z0NWZDFVS05D?=
 =?utf-8?B?VEg4ZGJGQTRYQjNqVU53Z1FGSEJWNktsb3hkaFVucXNvV0x4b080NTJjWnV0?=
 =?utf-8?B?blF2RW9TczMxZm5KR29hTk94VThUdDQ2dGxYOVE5OHgwNEpzMjdkUk82ZStX?=
 =?utf-8?B?RWQzM0tJWkZ5Y01kYU9iNU0yMUlQb1pJaDNIdzBIMkU5QW9nZmZhUnhvaTJK?=
 =?utf-8?B?Rk8wdm1qZGpHdEFCREFYUXAzclVmTXBOUTk1RkEzRnEraTV5cWs2RVJOK2ND?=
 =?utf-8?B?Q1N0cG8ybTNTek9DVFBFd0E3QU5LWS9BTDI4OWQ4MlJJWTFrUDhsb1ZQbHRX?=
 =?utf-8?B?bC80TWsrZDkzSGdRM2JhWk9NZE4wZmhKbkdyNExsZ0w0blhia1g0MExzdG1s?=
 =?utf-8?B?TjNmZVQ4Rm1ScWppVkpldHJqSFRPNGFYazhzS0NFdkVvaDZYc25NVkNsN3Uv?=
 =?utf-8?B?dFViMzYyMDVqT2p6ZFNoQ2dyaFhpYUZ5Z2poNnBCWUthNFp3bWl3eVFVR2wz?=
 =?utf-8?B?NTBzbzF6TXRVRmVBMkVlZnJLV3U4L2VzcnpKMlEvcGFsd0RhQWpjbjVaTzk3?=
 =?utf-8?B?ejVOSGIzbmU4aVNUQUNkVDAyMUVKQW85UXpjU0xpbm5wQXp6QkZIQXNBWmdC?=
 =?utf-8?B?ZlFxSktZNE5QZnVNS1l1WUNQWll1cFhOVkU2MGx6MzNDYjFVVVBtTzdocnVX?=
 =?utf-8?B?a2pMTFNzSXBkT1B2ZGpyMUhLN2xncWtyM2lFM2xVRXFwR3RJZzZSbzFBYThZ?=
 =?utf-8?B?V0ZlY1NPdXpuU2JwenJScTZjQzF5TFJiQjBLekpRRFNOSklDWUlPa2VkVDU5?=
 =?utf-8?B?MmlrS3BrVDA3YUFrdFJzS3NDZzJjNW51SDR3eHEza0dXcXQ1bW5NQ29XQkh5?=
 =?utf-8?B?TzdJZGpYVG9GdHp2VDhQWEJLbmc4VzZPMldLbklHSUtYMzNrZ3Fwei84VkNh?=
 =?utf-8?B?K2V3cFplSnlwVlJtQjN4bWtuQWFwckdtMFVqamMyUFJycXZnK2RzZmc3RWcx?=
 =?utf-8?B?Q1VwNVdoNjdOZWJaZnZscENYWnNEZktwTWtpS1JQSVFZYXdrREhHOTVMdSs5?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <254C9417E07EBB4499E8019EC78C7068@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1abd1589-7827-4136-ee49-08dafa7440a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 23:24:03.3537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+U1PkmjesCeLdnsUfwFF4IDSXAtFx0+Cdv7mQKnEz3DM8KWOlSkCa5HikMjICCDjDvK73ioK3TlMaBjVnguRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDIzOjExICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAxOSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDEtMTkgYXQgMjE6MzYgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBPbiBUaHUsIEphbiAxOSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
T24gVGh1LCAyMDIzLTAxLTE5IGF0IDE1OjM3ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiA+IE9uIFRodSwgSmFuIDE5LCAyMDIzLCBIdWFuZywgS2FpIHdyb3RlOg0K
PiA+ID4gPiA+ID4gT24gVHVlLCAyMDIzLTAxLTE3IGF0IDIxOjAxICswMDAwLCBTZWFuIENocmlz
dG9waGVyc29uIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBUdWUsIEphbiAxNywgMjAyMywgU2Vh
biBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiBPbiBUdWUsIEphbiAxNywg
MjAyMywgWmhpIFdhbmcgd3JvdGU6DQo+ID4gPiA+ID4gPiA+IE9oLCB0aGUgb3RoZXIgaW1wb3J0
YW50IHBpZWNlIEkgZm9yZ290IHRvIG1lbnRpb24gaXMgdGhhdCBkcm9wcGluZyBtbXVfbG9jayBk
ZWVwDQo+ID4gPiA+ID4gPiA+IGluIEtWTSdzIE1NVSBpbiBvcmRlciB0byB3YWl0IGlzbid0IGFs
d2F5cyBhbiBvcHRpb24uICBNb3N0IGZsb3dzIHdvdWxkIHBsYXkgbmljZQ0KPiA+ID4gPiA+ID4g
PiB3aXRoIGRyb3BwaW5nIG1tdV9sb2NrIGFuZCBzbGVlcGluZywgYnV0IHNvbWUgcGF0aHMsIGUu
Zy4gZnJvbSB0aGUgbW11X25vdGlmaWVyLA0KPiA+ID4gPiA+ID4gPiAoY29uZGl0aW9uYWxseSkg
ZGlzYWxsb3cgc2xlZXBpbmcuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IENvdWxkIHdlIGRv
IHNvbWV0aGluZyBzaW1pbGFyIHRvIHRkcF9tbXVfaXRlcl9jb25kX3Jlc2NoZWQoKSBidXQgbm90
IHNpbXBsZSBidXN5DQo+ID4gPiA+ID4gPiByZXRyeWluZyAiWCB0aW1lcyIsICBhdCBsZWFzdCBh
dCB0aG9zZSBwYXRocyB0aGF0IGNhbiByZWxlYXNlIG1tdV9sb2NrKCk/DQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gVGhhdCdzIGVmZmVjdGl2ZWx5IHdoYXQgaGFwcGVucyBieSB1bndpbmRpbmcgdXAg
dGhlIHN0YWsgd2l0aCBhbiBlcnJvciBjb2RlLg0KPiA+ID4gPiA+IEV2ZW50dWFsbHkgdGhlIHBh
Z2UgZmF1bHQgaGFuZGxlciB3aWxsIGdldCB0aGUgZXJyb3IgYW5kIHJldHJ5IHRoZSBndWVzdC4N
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEJhc2ljYWxseSB3ZSB0cmVhdCBURFhfT1BFUkFORF9C
VVNZIGFzIHNlYW1jYWxsX25lZWRicmVhaygpLCBzaW1pbGFyIHRvDQo+ID4gPiA+ID4gPiByd2xv
Y2tfbmVlZGJyZWFrKCkuICBJIGhhdmVuJ3QgdGhvdWdodCBhYm91dCBkZXRhaWxzIHRob3VnaC4N
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJIGFtIHN0cm9uZ2x5IG9wcG9zZWQgdG8gdGhhdCBhcHBy
b2FjaC4gIEkgZG8gbm90IHdhbnQgdG8gcG9sbHV0ZSBLVk0ncyBNTVUgY29kZQ0KPiA+ID4gPiA+
IHdpdGggYSBidW5jaCBvZiByZXRyeSBsb2dpYyBhbmQgZXJyb3IgaGFuZGxpbmcganVzdCBiZWNh
dXNlIHRoZSBURFggbW9kdWxlIGlzDQo+ID4gPiA+ID4gdWx0cmEgcGFyYW5vaWQgYW5kIGhvc3Rp
bGUgdG8gaHlwZXJ2aXNvcnMuDQo+ID4gPiA+IA0KPiA+ID4gPiBSaWdodC4gIEJ1dCBJSVVDIHRo
ZXJlJ3MgbGVnYWwgY2FzZXMgdGhhdCBTRVBUIFNFQU1DQUxMIGNhbiByZXR1cm4gQlVTWSBkdWUg
dG8NCj4gPiA+ID4gbXVsdGlwbGUgdGhyZWFkcyB0cnlpbmcgdG8gcmVhZC9tb2RpZnkgU0VQVCBz
aW11bHRhbmVvdXNseSBpbiBjYXNlIG9mIFREUCBNTVUuIA0KPiA+ID4gPiBGb3IgaW5zdGFuY2Us
IHBhcmFsbGVsIHBhZ2UgZmF1bHRzIG9uIGRpZmZlcmVudCB2Y3B1cyBvbiBwcml2YXRlIHBhZ2Vz
LiAgSQ0KPiA+ID4gPiBiZWxpZXZlIHRoaXMgaXMgdGhlIG1haW4gcmVhc29uIHRvIHJldHJ5Lg0K
PiA+ID4gDQo+ID4gPiBVbSwgY3J1ZC4gIEkgdGhpbmsgdGhlcmUncyBhIGJpZ2dlciBpc3N1ZS4g
IEtWTSBhbHdheXMgb3BlcmF0ZXMgb24gaXRzIGNvcHkgb2YgdGhlDQo+ID4gPiBTLUVQVCB0YWJs
ZXMgYW5kIGFzc3VtZXMgdGhlIHRoZSByZWFsIFMtRVBUIHRhYmxlcyB3aWxsIGFsd2F5cyBiZSBz
eW5jaHJvbml6ZWQgd2l0aA0KPiA+ID4gS1ZNJ3MgbWlycm9yLiAgVGhhdCBhc3N1bXB0aW9uIGRv
ZXNuJ3QgaG9sZCB0cnVlIHdpdGhvdXQgc2VyaWFsaXppbmcgU0VBTUNBTExzIGluDQo+ID4gPiBz
b21lIHdheS4gIEUuZy4gaWYgYSBTUFRFIGlzIHphcHBlZCBhbmQgbWFwcGVkIGF0IHRoZSBzYW1l
IHRpbWUsIHdlIGNhbiBlbmQgdXAgd2l0aDoNCj4gPiA+IA0KPiA+ID4gICB2Q1BVMCAgICAgICAg
ICAgICAgICAgICAgICB2Q1BVMQ0KPiA+ID4gICA9PT09PSAgICAgICAgICAgICAgICAgICAgICA9
PT09PQ0KPiA+ID4gICBtaXJyb3JbeF0gPSB4eXoNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgb2xkX3NwdGUgPSBtaXJyb3JbeF0NCj4gPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbWlycm9yW3hdID0gUkVNT1ZFRF9TUFRFDQo+ID4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHNlcHRbeF0gPSBSRU1PVkVEX1NQVEUNCj4gPiA+ICAgc2VwdFt4XSA9IHh5
eg0KPiA+IA0KPiA+IElJVUMgdGhpcyBjYXNlIGNhbm5vdCBoYXBwZW4sIGFzIHRoZSB0d28gc3Rl
cHMgaW4gdGhlIHZjcHUwIGFyZSB3aXRoaW4gcmVhZA0KPiA+IGxvY2ssIHdoaWNoIHByZXZlbnRz
IGZyb20gdmNwdTEsIHdoaWNoIGhvbGRzIHRoZSB3cml0ZSBsb2NrIGR1cmluZyB6YXBwaW5nIFNQ
VEUuDQo+IA0KPiBaYXBwaW5nIFNQVEVzIGNhbiBoYXBwZW4gd2hpbGUgaG9sZGluZyBtbXVfbG9j
ayBmb3IgcmVhZCwgZS5nLiBzZWUgdGhlIGJ1ZyBmaXhlZA0KPiBieSBjb21taXQgMjFhMzZhYzZi
NmM3ICgiS1ZNOiB4ODYvbW11OiBSZS1jaGVjayB1bmRlciBsb2NrIHRoYXQgVERQIE1NVSBTUCBo
dWdlcGFnZQ0KPiBpcyBkaXNhbGxvd2VkIikuDQoNClNvcnJ5LCBJIG5vdyByZWNhbGwgdGhhdCBJ
IG9uY2UgaGFkIHBhdGNoIHRvIGNoYW5nZSB3cml0ZSBwYXRoIHRvIGhvbGQNCndyaXRlX2xvY2so
KSBmb3IgVERYIGd1ZXN0IHRvIGF2b2lkIHN1Y2ggcHJvYmxlbS4gIEkgdGhvdWdodCBpdCB3YXMg
dXBzdHJlYW0NCmJlaGF2aW91ciA6KQ0K
