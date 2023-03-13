Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E149B6B6CE5
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 01:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCMAws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 20:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCMAwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 20:52:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F44D2A98D;
        Sun, 12 Mar 2023 17:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678668766; x=1710204766;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8IWbdbkKWzot952+1EhsyVT5FHgpZFa8YrCWPenKpjc=;
  b=EeqBjUzi8M3YbPCB/k+bXRFU2nlBcwnIjnQp8VkdnR+AdcxxEseI44pd
   +eYb4q07m9DvOwaDKzFF4KLdvgIsvMnC7EaZzsw4KC91g20jIUpN6AlAp
   iJ2Tz38ISilqXQ+Fi5FN1DM0B5VcMgbAsUZfv/Dm45r3fBbKb2ql5dljk
   Eqfr5t02UFCioVsoOHhh7ZU2alJtUnpXMDD3J7e7FaGrt49kx2384ppg3
   2fNPeWc32B2p09SUqabQrb8jkySz3pTwgLix1uziPg5zFwabuD1QWTcYe
   RFQiQBkK4zxL6e2zT4CpCPTlhxuuJ3f2dyuxx7kc+30EigBQbukpfwDJn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337057204"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="337057204"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 17:52:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742673844"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742673844"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 12 Mar 2023 17:52:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 17:52:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 17:52:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 17:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VG1WqAEWYayqTzuJNMNq6Tlx/iB7y+XV4xOZ/8VZ7G5KCNF4xE5Mgl3DgkJ2z2Dyws4Pk6FVQxCgCa3gIkmUmJT5w0oJsNwVSCxlkXoJpajeU6EYlwa2GRe6vik+r9haVd1daEkxjYGSzAOvaDti1K766Z+rE6LjztEUzlJ9jK6qE3T9NmoVgacS5bkbUaTf+etA11Pv4uHMc0U4vJOypawV38QCH2UaJs2lVe85fjyfcW3YMXkWVL3rD9BDGEUet8KIwAllzXzyH9ufu4AoF/gSqxHA7Y48B8vYEKFHDxjKkvarhskxIaEF8/WgBiDJUy+k4UNnyTDMDIPGoAENow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IWbdbkKWzot952+1EhsyVT5FHgpZFa8YrCWPenKpjc=;
 b=VQRpCSx5icRe6ZIFtGo4mpR/dM5BTfLloYBlaZP6LndfvVzR9k3kLsRx3uT0KXQ7ryAu9WNK0/7eGTGUoMAFYIbc+gSICAiqRziVRJ0GuEt8Wjf/ulQcLF4ljTAeYFcO79phWWKxc+ggC1rBjtyWz6asuLbQra5lYvrm3jJP/W6Q4/6gdc0gyiCXv0ae6YIgCmZ8mbAjfIXdwpncnQzb++gN2PRcpgHp26wV1vsaIX17PVV7/jvMku5YaA1qti3m8fd3jjunjwY0H6Wz6wClWUxYEkoChZvBZ9N2PNzp2zQjbZ5Mml8IjWD/3FzpBgxoHzsw+jrZ/8adlB0vsN7z+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4889.namprd11.prod.outlook.com (2603:10b6:806:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Mon, 13 Mar
 2023 00:52:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 00:52:43 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Topic: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Index: AQHZU5lNLkv1cCahbEC0lBpbSQHWdK735QYA
Date:   Mon, 13 Mar 2023 00:52:42 +0000
Message-ID: <ce2330db94b05605a0649a3da0595211c5bd71dd.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-6-seanjc@google.com>
In-Reply-To: <20230310214232.806108-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4889:EE_
x-ms-office365-filtering-correlation-id: 59a9a5d4-c823-4463-d262-08db235d40d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QZMxR1jTfNA3LW5DwGym6uLqzqZgFWirieRDICRWdHtJ28nboUXW80j0izeJNUzFTtHeyicuv1o2C63Ttnxi1VzmydwfdDTg/5pvW1BCy62dXSGXLP2nbTLhJlkI3rcrRS93V+doqj1u4J/HxLJrfUkAPR878n2viksL8kTdJlfb+/1gv7bEc3O8YiALAiTxafRBOl+12L74BtjSmTLw00DvHZDS7iJNI97RJTAXcEf/BU4Vlhs+XWG2dTFdybiS8mogwCBkAXxnEgHIv+W7sNOTsYdsOtHdWwhmBV6AigQrvS+gNCvguDLXYr2oVhjnUc8dIMEKdjp7Il/OTZdc3uO7XmNb2DaZgCZXrNW45Rm8HEzZL+Hn0sFJmsBiHCRzWYtGq9s1aaejNmP/5swMt4DB/xmb25T04+12fCHy8kZa40smg70kzkSBNq+zf8YV1h80qz0TnxkWSBNe1DYFW2XzT7B4tm3pAxjmzhw8y64uXbJ1Nv+sf9h2v2Jv4NdvTO7QwEeZRxRFZgdsjKlrrwdX+gNhL0yzsxua6qX4mAEFRqejiC5akHZvk37iEtR3ql8w3cJpT7hBibW+MgQykllHvcQTv5BtbhcITxnQC1RD+dIyEDNYQRvzXB/DRRoFEyRlptuG8BxpQpw7Xva83djU55WMndmjcAWnMtY1Bh8GoXtjZ5Gp4V43rDFnRmGmSe4ZDpMeLoIxTJzNe1735g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(36756003)(110136005)(54906003)(478600001)(71200400001)(5660300002)(316002)(6486002)(7416002)(2906002)(8676002)(8936002)(64756008)(91956017)(76116006)(66556008)(66946007)(66476007)(66446008)(41300700001)(4326008)(122000001)(82960400001)(38070700005)(86362001)(38100700002)(6512007)(186003)(6506007)(2616005)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFBlaU5SOFpRMEppQkVMalh6ZFRpbHhKa2FQREl2cjJhZWR2M3Y5bjltVTlV?=
 =?utf-8?B?M0cxNzljSWZMd3BoakR1bUF5SEdvQU9rRnAyaFNRbU5PQTNPbkRJOG9UTXQw?=
 =?utf-8?B?bDBJckRiYnBrdUF4Y2Q1ZzI2emYzOVlibXFTTVJhRGhZSXlnU2o2Z2NwRSs5?=
 =?utf-8?B?dGR6dUxhUkdWdUtKb1c0bTV4TkRRUklha2FTNi9mdkRLbTFtYVM1Rlo2ZFNz?=
 =?utf-8?B?eHV4T3NjSGNHTGFFVHF1QXZuOE8wa3RUVU9XcXFuY1NnaWJBVmlLWlBRU0Nh?=
 =?utf-8?B?SmQ3OFAzdXFLZWRQK1V0N0NnOElTSDlnRkcvOUN1dkdsK09vSlVYM2dUclAw?=
 =?utf-8?B?Uzk1Mng1WEcrK2treHhlVHZ2dmNVWHo2UnE2amlPYkxGaWxKRG9Fd0RFdyta?=
 =?utf-8?B?anliVGg5aHlwekV0R1cxT29BUDNDdVovZXB4cDFia3dWa0VLVGlzeFRtSHhY?=
 =?utf-8?B?cnlMdWFHOUZaU21ybWNjNUhvMUZRUjdybUd5SGI3dFZpbU5qRFB4aVBWL21n?=
 =?utf-8?B?UEUxVm5xM0llZkJRUlRUcnl5MjJWVUVPNmJSNlUvdGtoQUpUd1hGajlPNnNj?=
 =?utf-8?B?TGJWamoxampwZG13b0cyYkM3ajJoeVEreE9NdUFvVmd6VFhQYm9HaS9US2la?=
 =?utf-8?B?c1d1WWJzOGZjWE11RVNoS2phUldnMTFCZmxpMzBjbHA0bUd0SlVvK3pJZVZm?=
 =?utf-8?B?YUZLa3MxbFE5YzZmOTR6WmhIZCtyVkZwZWNadEx1S0o1YWRCK2drN1JsVUxr?=
 =?utf-8?B?YlpueUlaK0pwUWNseEM1TFAzWGR1ZlNtalNObUtMNGJIQTB5ekdPajIwdHdx?=
 =?utf-8?B?TmRuN1Nma09wWVdxcXFIa2tKMTdLeWNZaUZ3Tzc2TWhucm1hMEVRcWN2K0Zm?=
 =?utf-8?B?WDNQbW5udDNVQlF6d2pJWkZTOGo2RThsb2t3N0kvL1o3Rkt2dTQxQmRkOUpx?=
 =?utf-8?B?Z0pkYVB5S1ZqeUQyOVlPR0laL253YlJIUVQ1SjJFbUNiWHZucmtmVFZjVjNr?=
 =?utf-8?B?WWxTWGY1bnFqM3FkUVBSVTVOc1Q2OENIcmpST0Z1dGZNU1dxTFlvS1FWb1Bp?=
 =?utf-8?B?Y21XQVhNN09xandWS3JQZ1ZtQXlrUUlvNEJlc0RXbnNyMDFwNnAzLy9IcDcx?=
 =?utf-8?B?RkowRGFYdXBiZjViaHEzWmNJZGtyZDQ3SDBTMTVXSGVSZnErVlg4eC9TazFr?=
 =?utf-8?B?dHFRajJQa0tjWG9hdEcwdWRzSmlCM2pXZE1pL25ZTWdhYndqNTJTdHIzanlY?=
 =?utf-8?B?NElkbGhOUi9jTXNYVXNWOHB6QkkreTJmRFBicUFCWUs3Z0R4VXRtNGRja2dZ?=
 =?utf-8?B?ZXNsdlZaR0JhV01RYVlUNHFpY1JrSnZxMXl3amJjQ3NzL2RyYVZkcll0dmlC?=
 =?utf-8?B?dDVpWnRyS2R6U0tDOE9vUkFjOStZNk9CWlJxM2hzUWZEaUpKdEVNUmpiQnFG?=
 =?utf-8?B?NFBYdkM1Y1kzLzNCSGhPVzhEY05pT05ERmtHMTNNaENZd0NWQlVhZGxra0FN?=
 =?utf-8?B?bVNiOTVwVDJsTGpjbTIyb011NXF2UlpSREhYOW9HS2hnOFFJS0VKN2k3NmZL?=
 =?utf-8?B?bGVJWkRWT1Q3Z2xiM3lFK0kvRzRqZ1RNLzRGR1hKYW45QlVIT0VkNnRnQk5D?=
 =?utf-8?B?WnFLemlaVGNORGw2TGQ4ZzVVdkEvMjlDSlN0SkVsTHNWSTJ5ZEk4TEVtY0hE?=
 =?utf-8?B?bEFpcWFTVjFMR3lWUUU3Q1hrYngwRmZBRVpiUHkyVFZhWGN6UXdBK1BUZzVU?=
 =?utf-8?B?T1VDclBhNWltS2VvSnJUSHU3cEpyUjBHVXJQbUoyaXNBZklOdDBteVB3L1RZ?=
 =?utf-8?B?dUhXYTBtR3lXTFRIR0IzZkdQdU5lS1lFOVdCVUdzb0Z0VHpTZFJBOFAzcDNq?=
 =?utf-8?B?YkdjWWE2UHJzOXpUbFZJNU1pQXhwaGtCc3pveHVmZDd3TDIyUGhXLzByVlc0?=
 =?utf-8?B?Sk96VFlMQ0p2N2RNWWtxaUc2MUpPOXRKN2x5akJ5VXpXZjJMWm9ycDJFemJk?=
 =?utf-8?B?RkY1cUYyaGhiYkJlL1hiRVVCWkFwNXhqanRIRnRGd2NKRjJRN1BsTmtNTGJi?=
 =?utf-8?B?cnBEM1FrVkJQOXI0UzRXQnBIRTU5V1c3QUtDWnBVL3A0a0pPOXFjNzc4OVY4?=
 =?utf-8?B?UFZ0Vk5NMmI0aUZqSk1QSm9wcXNhSGdCMXpZS09TR1BsTUpDamFWdHhsQXcx?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40200137F190AD418F770B6DDC1F6D9C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a9a5d4-c823-4463-d262-08db235d40d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 00:52:42.9208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SwM6EuFriaM5Px3LM0/UNCoAkBPeV/nbzDsUSguhokH4GWJw5gtEhRGAgI/gyYDHUyj7kuuUvpw2YATcENWyqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4889
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTEwIGF0IDEzOjQyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgdGhlIHZpcnQgY2FsbGJhY2sgdG8gZGlzYWJsZSBTVk0gKGFuZCBzZXQgR0lG
PTEpIGR1cmluZyBhbiBlbWVyZ2VuY3kNCj4gaW5zdGVhZCBvZiBibGluZGx5IGF0dGVtcHRpbmcg
dG8gZGlzYWJsZSBTVk0uwqAgTGlrZSB0aGUgVk1YIGNhc2UsIGlmIEtWTQ0KPiAob3IgYW4gb3V0
LW9mLXRyZWUgaHlwZXJ2aXNvcikgaXNuJ3QgbG9hZGVkL2FjdGl2ZSwgU1ZNIGNhbid0IGJlIGlu
IHVzZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bn
b29nbGUuY29tPg0KDQpbLi4uXQ0KDQo+IC0jaWYgSVNfRU5BQkxFRChDT05GSUdfS1ZNX0lOVEVM
KQ0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0tWTV9JTlRFTCkgfHwgSVNfRU5BQkxFRChDT05G
SUdfS1ZNX0FNRCkNCj4gwqAvKiBSQ1UtcHJvdGVjdGVkIGNhbGxiYWNrIHRvIGRpc2FibGUgdmly
dHVhbGl6YXRpb24gcHJpb3IgdG8gcmVib290LiAqLw0KPiDCoHN0YXRpYyBjcHVfZW1lcmdlbmN5
X3ZpcnRfY2IgX19yY3UgKmNwdV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjazsNCj4gwqANCj4gQEAg
LTgyMSw3ICs4MjEsNyBAQCBpbnQgY3Jhc2hpbmdfY3B1ID0gLTE7DQo+IMKgICovDQo+IMKgdm9p
ZCBjcHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gwqB7DQo+IC0j
aWYgSVNfRU5BQkxFRChDT05GSUdfS1ZNX0lOVEVMKQ0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklH
X0tWTV9JTlRFTCkgfHwgSVNfRU5BQkxFRChDT05GSUdfS1ZNX0FNRCkNCj4gwqAJY3B1X2VtZXJn
ZW5jeV92aXJ0X2NiICpjYWxsYmFjazsNCj4gwqANCj4gwqAJcmN1X3JlYWRfbG9jaygpOw0KPiBA
QCAtODMwLDggKzgzMCw2IEBAIHZvaWQgY3B1X2VtZXJnZW5jeV9kaXNhYmxlX3ZpcnR1YWxpemF0
aW9uKHZvaWQpDQo+IMKgCQljYWxsYmFjaygpOw0KPiDCoAlyY3VfcmVhZF91bmxvY2soKTsNCj4g
wqAjZW5kaWYNCj4gLQkvKiBLVk1fQU1EIGRvZXNuJ3QgeWV0IHV0aWxpemUgdGhlIGNvbW1vbiBj
YWxsYmFjay4gKi8NCj4gLQljcHVfZW1lcmdlbmN5X3N2bV9kaXNhYmxlKCk7DQo+IMKgfQ0KDQpT
aG91bGRuJ3QgdGhlIGNhbGxiYWNrIGJlIGFsd2F5cyBwcmVzZW50IHNpbmNlIHlvdSB3YW50IHRv
IGNvbnNpZGVyICdvdXQtb2YtDQp0cmVlJyBoeXBlcnZpc29yIGNhc2U/DQo=
