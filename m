Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51F86CCE12
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 01:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjC1XeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 19:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC1XeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 19:34:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A543199
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680046441; x=1711582441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r6mqDFPipJrHP77rPfvkc8jk+4WyqM2eD48Qz/RNR2Y=;
  b=BYt+G8VnwqGwTnY8XfVmd5sF39BYwFU00PYwY3zrDPdZ7SV+qZdNPlqi
   30MeO7IPOAl5zvVEpDzmnv5Or2xaPK+8CBVZ99wnjJq+KATog6qi4DYY+
   bwniTfFKboRT73Cz4XzWuiSKRxZifbWh1NxR1OoBzbaBsQE4MRl4XrJ6W
   WRwSdN7Izf11WLGect8CSLiVJKcUDiW+FlDLiaDyUzCN9UeWmxVNGRusT
   JA6nN4Cq0vtc9KNIRxdoFl8586jMy0Ooo14oHvmfQ5ANNS0ioRhTX/vEa
   ZsxB+ZpF2V4GuJgRXrcLZ0/oWvzhazjHqnlwiZYaWZ63r4iaFsKeHe7yt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="368492552"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="368492552"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 16:33:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="684062579"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="684062579"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 28 Mar 2023 16:33:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 16:33:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 16:33:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 16:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aU9FcvC1frXKnAtufTjcfa/Rmu2G25iwWJ+wWhCtqYC36KWIY5P6FauBzoL1vNikxgE8Yxw3uBm4YswyR14Ep7bw95mpGiU4CkltWY7J75NXI/U9JYx5VNRDQVPjE8VR1D48PL/K1jFO4VH0y/lgNj4jrmz0rOxaaofnEvl8dRp6tvI9gGz/IIXvsQrXaj4PHkyhw/FzbGpWBucdqaCcPAiN68nhrqlpiXrQjrdgQqrzophjWBrF7YRDqzuGMmc8w1jr+jX94xqY4pkoS937FoSz/JJdnxM1+wNp+3e6keAvOqIaKJ+NymJCl86K8ExSnspk4Dm4ATXa9Ubm5/eDbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6mqDFPipJrHP77rPfvkc8jk+4WyqM2eD48Qz/RNR2Y=;
 b=OGiMolWUOTQe7DOeu2MnsuVZycLRSD8TLDre4WI8pSfnEX1P2BGesK8mI+ufW4iTfYpxWsvo1x3w9XnRB5zdMab+MvJ15xIr1PBPPjr5o0gHoLgF1wBoAJRGUsz8HfvtSwzH8IOQmNUDi43tSFcTudUNH3Wc+wnsn2UiSbLh05lM5BYWXNOIhcMHhI383VxcxD1yuOrSWsjkQswhWUDRgLvxoOB7I1EKBjPdLUzw1jDdHV9imNKezPW40bMN5jf+5c52/lEZll8s+K4JgB4ffIc+7waodCaUxHWsVLfOYe3aoE6ucycfWmKQrSDxCpSL6kIZ3q1MmBX0mLrEK8tQ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7373.namprd11.prod.outlook.com (2603:10b6:8:103::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 23:33:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Tue, 28 Mar 2023
 23:33:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgA==
Date:   Tue, 28 Mar 2023 23:33:46 +0000
Message-ID: <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
         <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
In-Reply-To: <ZBojJgTG/SNFS+3H@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7373:EE_
x-ms-office365-filtering-correlation-id: 48465b83-8574-4ac8-ec4a-08db2fe4e02a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Qs0HDdzOOcOqNZup+ibmJlqnLZ6Mnv02DwZKK3XlG3f9sNCnCos54OJUq/r6lxvj7jOEyjd5X3k2chJO7xH/Y5JIuGcN7731yPyD/po1Pvu9xaZctoCPJuZ6YK6kGILx2gKrz6ZVjC1018RoDZuY0fyNuOFVvMC0cRvUObeBSXibD6ff2Mv13Bzdized1EEjU8+Jl+40wvFxM+bXjwgLeWG0Bs1OWRI6yr2YNAwPw36F/Snw4/C4qRnO7AzzJdrf+zHrVJAaK/yRN6y17WJueb3jblsfjt8abSb8NfhH515jKRF8bLBeIQYrs/dXCQ82PIGYKLU+NV/RYXe4LxdBWEfleDQy+FQvhaEvKlP/hEgnNrtp7RFIkhgKW3bULWE5qM30s1SYhdWc0hx1Os2CYW9pBOUOJV3q6T7f1cnmaQv8ZQzRYrOqBy/q8bcmmrnCnnU6lb4+1AE0OlNiOHxRd/HFPUxzj5HFmc8T3jVeMz6LVh7e97Rg807VPuHB5sFz7zcEI360eTfNfjhq4kU9FvVqLdqoEAoOxLNEv76C3XWcsZPv5TX2L2oyQoyZKaYFZgcxFuZ0ufsvFsH4bVg5iOxG9+3G1YPkjldRhTo1pJCXOUMU/AqMMMxltSrng0b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199021)(316002)(6636002)(110136005)(478600001)(54906003)(8936002)(122000001)(36756003)(38070700005)(82960400001)(86362001)(5660300002)(76116006)(38100700002)(4326008)(66476007)(66446008)(66946007)(2906002)(8676002)(91956017)(66556008)(41300700001)(6506007)(64756008)(186003)(6512007)(26005)(2616005)(71200400001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTN3aUg2bTlabjZxWHlYK3lHMFdzSCtpWjhQTnQ2LzhuN1VNajN0aDBOeTJ3?=
 =?utf-8?B?Sis3NXNJdzRhRVJKQWtNbkI1RlZYM0tBUXhDQjlpelRtR3hSZXg4alVLQXA0?=
 =?utf-8?B?aVN1blp5YzdId2RZZktXZk9kc0JmTG9LOHJneGhHMTZOYXZlckhHN1NjNU9Q?=
 =?utf-8?B?ZWdaZGJFNDhacXNnM1ZVTkJGeTBTb2VTRFIrakp2STV3b0pLZ0JxZEhKRmtw?=
 =?utf-8?B?OGxRREdReFJhV2RpdHVXM3V1aE5MNWJLSTVsRUZiMXp4T280b0xVY2ZJZXRx?=
 =?utf-8?B?WjBhazQ3SVVVMmFTS1QrbDFJK2FIckpWMjdKeVZ1clFTeG41Q1NOWmFIclZr?=
 =?utf-8?B?UnJSVFBkeE1MbnlsNjFqUnR3RWVVSlg5U01zN042ZWY5SnMzMUpWNS82VmVT?=
 =?utf-8?B?NVliRHRaTUJMTUpkTnFYL3o5cmhtOXdRVVRDYUo1ampXVjVXa3FVRFM5bG80?=
 =?utf-8?B?akFjenN1NEIreElCV3QweVVKUTh6dThCcGs5aWVKMWlQVmNuRG1LS2Q3bEhH?=
 =?utf-8?B?VDhQTG5FTUZvMmpSei96VDBJM3FEdjRCdjRWWFdpZis1MlVRK0EvRU9MWXBx?=
 =?utf-8?B?Y3paM1VyTExJQW9zSWhhNHFDWUNRemRjODVSQ3kvN01UZ25UdlRWcFJ5ZUV5?=
 =?utf-8?B?MFl3cTE3K29yc25NRU9tUitWa3FsSmZyWkZPbEx3b3IvVWJUQVVZVmlvckN1?=
 =?utf-8?B?NG82VDhkTXROUTlmQnlZbnJzaFgrSmQyeGlwaExDa0tyb2VJaXAyS1l5a1A5?=
 =?utf-8?B?MmNlSjJPZW9BQWh6aWZ4NG02LytJSXA4UVRKSGVwUG1WM0pPbmpEQzRPQnZY?=
 =?utf-8?B?S2NMWVRZeUNVREVpTUhkdmFrYVA4aUZweUgxQUMrbVVVSjAvcDk4b1kyNGR1?=
 =?utf-8?B?WTdrSGhCQ0pMOUZtb1FRY3o1WWFTZEJBdU5BbFBYUGxaWHVVS2xONFZsTHBH?=
 =?utf-8?B?bTNxeDZZRTNDY0lZWEh3U2p5My9NaUt2Zk5BcmVYZGw0OURzaTBXUnRuVkJa?=
 =?utf-8?B?Q0Zla0dRRHNvMU5OUlV2ZUlzT0J6MEdpdGJCMWxHQ2NnUlJEeTRPcWJZZTBz?=
 =?utf-8?B?My9sTWJCS0xoM3BnYnB5WlR0LzR6dVZOcC8yZXR6U1RjclVOcjBPdERzVUVQ?=
 =?utf-8?B?a3VRRm11djh6dnIwN3FKOUR0WWVjQ2k3NEVLdHZrWXhCbitaQVp5bzNoOUtM?=
 =?utf-8?B?ckFDMGtSMktXZzRhQVB1QjNVZXdNMzdWTFptR3dCMU5wUFNpSU00bUhkdmdT?=
 =?utf-8?B?aGRFeXF0MUZkWHIwbTBqdldONUtPRW9maTNTRjMxdGs0WHJ5M2txMExRbEky?=
 =?utf-8?B?SzZ6Skh0Vm90d2dIYVRPMzlCUkl4bW00VzRtSzNNUVBwM3NWa2RpbTJGVjY0?=
 =?utf-8?B?UVNFUDFna0EzbVoyVGc5NDBIaWM4RXVnVHNoVndTVEk5Ny9kZndEWm1iblNs?=
 =?utf-8?B?MHBkQThCU3dSWDdlNkttWVE5OHVmQWZKZTZFenRCSWFKUmgveEdMVEtZZytC?=
 =?utf-8?B?TmNLQkEzaFBTUDdZZFdjZkVzdWdPZ3ZLbzNlenFib2JqQkFBbnZVd0d4SWls?=
 =?utf-8?B?bnZ0T2E0b2ZOeHdNT0hCT3Q5WDJKQnJRNmRveFIwWDdBU05HVnlGZmFhZ0ND?=
 =?utf-8?B?R1d2WGhHZG9sQm11RkZES3l2aFhkSVVrcjduOVpSS1dCcjF6Ym1jTmVDM3k4?=
 =?utf-8?B?cmd6Z1dKalRtL1BRWDZ4VDdpNFQvVVNISkVCelVQZWhsVzM1TWRSV0hHUFIy?=
 =?utf-8?B?R2prVi9WU2JOVVZxOVdEd0U2N3pzWU9CTEYyRDY1blBFd0QyV3ZYeU82OERy?=
 =?utf-8?B?b0RORmRxWWRhUG0vTGFVa2lUSkdGYS8yaXo4ZVlTNlJ4VjY2bkVyV3dzOUpX?=
 =?utf-8?B?YjBxVmFiWlJkQ1Z3UWp1azFjNnhUUXEzclR4TFk4UG1TZ1BBc1kyL0VyT3Vs?=
 =?utf-8?B?V3plenhoZUFJNXE4dzFNeFduZEI5Qy8yaDNnT0NyNlY5R3lMMk5ncGdIK09H?=
 =?utf-8?B?Y3NqRGJ0MTQ2N0xiaDN4YVRmU1lEZVRtRVJnSDREN29odndVbWc4S0JGd3Ev?=
 =?utf-8?B?QnBTalFKSXJQNEFYOThxWHpQWGIzZTNLMHR1eTNYTS9tMUZWeitCeEwrM1VL?=
 =?utf-8?Q?bX7niV8q7oiWWcmMDdOU9kKPQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <377C7AC81EEB264EA6D469E1C8C2662D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48465b83-8574-4ac8-ec4a-08db2fe4e02a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 23:33:46.2546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0N9I1SUHADyDRlp3zcZPsbOe+vQvdmnejZpP12MYUJ5r3ZEliDEJdCA6zfo52zNCreuUfpYhajD85K9cBKxgig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7373
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTIxIGF0IDE0OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1hciAyMCwgMjAyMywgQ2hhbyBHYW8gd3JvdGU6DQo+ID4gT24gU3Vu
LCBNYXIgMTksIDIwMjMgYXQgMDQ6NDk6MjJQTSArMDgwMCwgQmluYmluIFd1IHdyb3RlOg0KPiA+
ID4gZ2V0X3ZteF9tZW1fYWRkcmVzcygpIGFuZCBzZ3hfZ2V0X2VuY2xzX2d2YSgpIHVzZSBpc19s
b25nX21vZGUoKQ0KPiA+ID4gdG8gY2hlY2sgNjQtYml0IG1vZGUuIFNob3VsZCB1c2UgaXNfNjRf
Yml0X21vZGUoKSBpbnN0ZWFkLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogZjllYjRhZjY3YzlkICgi
S1ZNOiBuVk1YOiBWTVggaW5zdHJ1Y3Rpb25zOiBhZGQgY2hlY2tzIGZvciAjR1AvI1NTIGV4Y2Vw
dGlvbnMiKQ0KPiA+ID4gRml4ZXM6IDcwMjEwYzA0NGI0ZSAoIktWTTogVk1YOiBBZGQgU0dYIEVO
Q0xTW0VDUkVBVEVdIGhhbmRsZXIgdG8gZW5mb3JjZSBDUFVJRCByZXN0cmljdGlvbnMiKQ0KPiA+
IA0KPiA+IEl0IGlzIGJldHRlciB0byBzcGxpdCB0aGlzIHBhdGNoIGludG8gdHdvOiBvbmUgZm9y
IG5lc3RlZCBhbmQgb25lIGZvcg0KPiA+IFNHWC4NCj4gPiANCj4gPiBJdCBpcyBwb3NzaWJsZSB0
aGF0IHRoZXJlIGlzIGEga2VybmVsIHJlbGVhc2Ugd2hpY2ggaGFzIGp1c3Qgb25lIG9mDQo+ID4g
YWJvdmUgdHdvIGZsYXdlZCBjb21taXRzLCB0aGVuIHRoaXMgZml4IHBhdGNoIGNhbm5vdCBiZSBh
cHBsaWVkIGNsZWFubHkNCj4gPiB0byB0aGUgcmVsZWFzZS4NCj4gDQo+IFRoZSBuVk1YIGNvZGUg
aXNuJ3QgYnVnZ3ksIFZNWCBpbnN0cnVjdGlvbnMgI1VEIGluIGNvbXBhdGliaWxpdHkgbW9kZSwg
YW5kIGV4Y2VwdA0KPiBmb3IgVk1DQUxMLCB0aGF0ICNVRCBoYXMgaGlnaGVyIHByaW9yaXR5IHRo
YW4gVk0tRXhpdCBpbnRlcmNlcHRpb24uICBTbyBJJ2Qgc2F5DQo+IGp1c3QgZHJvcCB0aGUgblZN
WCBzaWRlIG9mIHRoaW5ncy4NCg0KQnV0IGl0IGxvb2tzIHRoZSBvbGQgY29kZSBkb2Vzbid0IHVu
Y29uZGl0aW9uYWxseSBpbmplY3QgI1VEIHdoZW4gaW4NCmNvbXBhdGliaWxpdHkgbW9kZT8NCg0K
ICAgICAgICAvKiBDaGVja3MgZm9yICNHUC8jU1MgZXhjZXB0aW9ucy4gKi8gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICBleG4gPSBmYWxzZTsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICBp
ZiAoaXNfbG9uZ19tb2RlKHZjcHUpKSB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgIC8qICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAq
IFRoZSB2aXJ0dWFsL2xpbmVhciBhZGRyZXNzIGlzIG5ldmVyIHRydW5jYXRlZCBpbiA2NC1iaXQg
ICAgIA0KICAgICAgICAgICAgICAgICAqIG1vZGUsIGUuZy4gYSAzMi1iaXQgYWRkcmVzcyBzaXpl
IGNhbiB5aWVsZCBhIDY0LWJpdCB2aXJ0dWFsIA0KICAgICAgICAgICAgICAgICAqIGFkZHJlc3Mg
d2hlbiB1c2luZyBGUy9HUyB3aXRoIGEgbm9uLXplcm8gYmFzZS4gICAgICAgICAgICAgIA0KICAg
ICAgICAgICAgICAgICAqLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgIGlmIChzZWdfcmVnID09IFZDUFVf
U1JFR19GUyB8fCBzZWdfcmVnID09IFZDUFVfU1JFR19HUykgICAgICAgIA0KICAgICAgICAgICAg
ICAgICAgICAgICAgKnJldCA9IHMuYmFzZSArIG9mZjsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIA0KICAgICAgICAgICAgICAgIGVsc2UgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAg
ICAgKnJldCA9IG9mZjsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgLyog
TG9uZyBtb2RlOiAjR1AoMCkvI1NTKDApIGlmIHRoZSBtZW1vcnkgYWRkcmVzcyBpcyBpbiBhICAg
ICAgDQogICAgICAgICAgICAgICAgICogbm9uLWNhbm9uaWNhbCBmb3JtLiBUaGlzIGlzIHRoZSBv
bmx5IGNoZWNrIG9uIHRoZSBtZW1vcnkgICAgDQogICAgICAgICAgICAgICAgICogZGVzdGluYXRp
b24gZm9yIGxvbmcgbW9kZSEgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAg
ICAgICAgICAgICAgICovICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgZXhuID0gaXNfbm9uY2Fub25pY2Fs
X2FkZHJlc3MoKnJldCwgdmNwdSk7IA0KCX0NCgkuLi4NCg0KVGhlIGxvZ2ljIG9mIG9ubHkgYWRk
aW5nIHNlZy5iYXNlIGZvciBGUy9HUyB0byBsaW5lYXIgYWRkcmVzcyAoYW5kIGlnbm9yaW5nDQpz
ZWcuYmFzZSBmb3IgYWxsIG90aGVyIHNlZ3MpIG9ubHkgYXBwbGllcyB0byA2NCBiaXQgbW9kZSwg
YnV0IHRoZSBjb2RlIG9ubHkNCmNoZWNrcyBfbG9uZ18gbW9kZS4NCg0KQW0gSSBtaXNzaW5nIHNv
bWV0aGluZz8NCiANCj4gDQo+IEkgY291bGQgaGF2ZSBzd29ybiBFTkNMUyBoYWQgdGhlIHNhbWUg
YmVoYXZpb3IsIGJ1dCB0aGUgU0RNIGRpc2FncmVlcy4gIFRob3VnaCB3aHkNCj4gb24gZWFydGgg
RU5DTFMgaXMgYWxsb3dlZCBpbiBjb21wYXRpYmlsaXR5IG1vZGUgaXMgYmV5b25kIG1lLiAgRU5D
TFUgSSBjYW4ga2luZGENCj4gc29ydGEgdW5kZXJzdGFuZCwgYnV0IEVOQ0xTPyE/ISENCg0KSSBj
YW4gcmVhY2ggb3V0IHRvIEludGVsIGd1eXMgdG8gKHRyeSB0bykgZmluZCB0aGUgYW5zd2VyIGlm
IHlvdSB3YW50IG1lIHRvPyA6KQ0K
