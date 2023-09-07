Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9AD797F37
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 01:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbjIGXav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 19:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjIGXau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 19:30:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E378CF3;
        Thu,  7 Sep 2023 16:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694129446; x=1725665446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wyFF4OBUXfvAO9lBLzRVAteeRKIbHsfzFRqVzq9vweE=;
  b=Cmjtob5IgB2Y61ztnMEiB7mqwf2b5LHIHg5ZCKjn2mV59baKM3Acusyc
   bVhUk49f/gWMUInL5YcRKBujOZFs/wnCD+KCT1G5bK0VLiz2UnpcfxMyr
   yr+F5ZAgRzDm+VfgyIGwEwlbFazTjX1PiHH6breRxz0T7nsdMqke8/Zy2
   pi/xsC7EVTCyGEyQHtHgAhXSAjdlJngp2ZE3zVALBn4HQ2g1Ki14Pg9Q5
   odBo3sNQCpO9I6CCd1Cc4ChqTqo8EM12bZhwVqmA+EWZ0g1kfHI/YXeqQ
   mtPLthN1wSHsp8Z2TsjALdmArrrZUVoc+FC1Lm6sfbsVmmWqxCei+Moyc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="441527789"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="441527789"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2023 16:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="865842520"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="865842520"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Sep 2023 16:30:40 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 7 Sep 2023 16:30:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 7 Sep 2023 16:30:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 7 Sep 2023 16:30:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvqqSRsWKveC9EozJfBpNispDWeitBdZoeYrmKj9zbm6ftRvtoRAIrpo7v8q94wSNF2DDkM3li/41Ya25piN4cb3etpQRVmW6DLqAwDVtSuPeTwqOfuDHIMzNooMur7VvAwANgxeR1bxQl7Pt5b1hj+o13fuBZ1IrSmkjeeoCouFwtgMUxueniuquAO8zzxvJbH3r/Awwv6pqCmu3w2zJXoL3KfhJCXhQi1XFbRcbAaVzKGweHbuSedWUWRk3+LylcR8t0NVkW/O2YJLOV8xfxCqvGNundbDVNf/bvVjK/xSSkYvL1GsV38RE0FBfNEL5V2ByAIUZ/7KhDu380zf4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyFF4OBUXfvAO9lBLzRVAteeRKIbHsfzFRqVzq9vweE=;
 b=jrQ0epNybNfgL+YMy4NzTVwhJ9BUwVeMngJMOLz50j4UAWLZ0X6oaS9D9fX3ZXaVOSRH4rdP11B86sfcy2RRUVZZ9QI/wsI+Qxbimpp6jZXwBjH5UFgLAXKiU9q18vmBCzbJ0nNyWOiME2Pg2/79C8O7os+16/lw9x/7e/KZwQasw1lg/VCTBaOsJa2kldXAyqM1fiaE5CDJJDp+kXxZOAtHRT1lQbpoPHj9s92JIQJN9IndsUnOo04Cjfcb3PTPw7CJXHNUeFc4tvGtbUNu8N8iqi0LNltI4NhuvTfo9tTBxLuwGrcFVebzPYN2ulsn+GPduagFf1V1VCBr6hqYNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 23:30:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Thu, 7 Sep 2023
 23:30:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 1/2] KVM: Allow calling mmu_invalidate_retry_hva() without
 holding mmu_lock
Thread-Topic: [PATCH 1/2] KVM: Allow calling mmu_invalidate_retry_hva()
 without holding mmu_lock
Thread-Index: AQHZ1vmq7tqEg62CYEK+Xs+YXuXO6rAQGKUA
Date:   Thu, 7 Sep 2023 23:30:36 +0000
Message-ID: <01d077d89d22cce541784be25c2f5c2143f8b5da.camel@intel.com>
References: <20230825020733.2849862-1-seanjc@google.com>
         <20230825020733.2849862-2-seanjc@google.com>
In-Reply-To: <20230825020733.2849862-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4820:EE_
x-ms-office365-filtering-correlation-id: f80ddf4d-93f2-42d0-5cda-08dbaffa7094
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nxT4YVSlmR98tru8kTNcVfWStEWffi5vlj4P3vswdSTP468coVuXC5jUtFVjvb/n0qsVq380aYCY+BD5t7jY9pb9PEhkkJs2zkELzL1gKXr6twpeMKDVtZ4X+JyxxSx9mkjc8AZKyi1K9RiuukvBmICM7xsRQ1hs0RrRu7TMpN9dsqw2o5EBf/u+qgp1t/w7cdyi0KRVi2YxZJR+drxDe4pAgmTqyPBk9wy7HVyBolQ5N/oB65K4A2xyJBYF4sr7nQ6TLkHlrZwPVtYKoD33aumQdmrlrB8uCObAdevFSE6vve8xBr29QgM3/D9S0CLGwmG0qsIvzwAXdK2mzC5jhYOOPX2zxl0VNzLzhZIzie7UTxEhd6qRwUU8tq4/PsGTvvHBF9KsA5C6ngbc6OfX1BQdeqT5Y6Uk1Aq67gQcsDkjjhZQiDhXLvDcZw6vGvgzWfk0fEbeWtJHbZQ6jjMeNGGPgFm1UGLcWEtjVxw4FKoFIMYCSisLR35HWzolZlY3tAEPmHTh5adLcbNhKFsAP+NSIyiQco60QbDKllyD7eTvce2DRavbvGOlHRB3HO9TPB62aXQEQnD1AyE3WXwWcCHXDSaAeyMU+HE9Q8Q8GckNsVOQBlVhEIrCKwLTAaoU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(39860400002)(136003)(346002)(186009)(451199024)(1800799009)(6512007)(82960400001)(6506007)(6486002)(2616005)(122000001)(86362001)(110136005)(91956017)(38100700002)(38070700005)(478600001)(71200400001)(107886003)(26005)(66446008)(4326008)(54906003)(8936002)(8676002)(5660300002)(64756008)(316002)(66946007)(66476007)(76116006)(41300700001)(66556008)(2906002)(36756003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjBQeENPRnRVNlNNb2Z1Z1VWNWkvd01IMUxjejhwNE01S000cmNsVURJbVpa?=
 =?utf-8?B?RUs5YXJiSEZWQkY0NVdlZ3VFclhOcGlwY040WlYwVDllMnJXSmxXUDVtTlRM?=
 =?utf-8?B?eFFuL293WUg1elJLdmFTbDRKZGVJaG9mem50UWlsSy9nRGpSV1BtamYycDND?=
 =?utf-8?B?L253RzF1R3VxaDF1SGUrQnNEcnJiQVJtV0FkN2dtYUlxUXIySXBQL0lzTm5C?=
 =?utf-8?B?dkNrY0xPYmJQM3ZkRXFOVm00Q2pORkg1VURmdk1VU2RzWEhSN3ZlRGoxS2gz?=
 =?utf-8?B?RDg2MFFMdUt5M0s5N09HVWJBbEI3Qng4cjNxNnZEejFvZUp5aWIvVWsxMENI?=
 =?utf-8?B?bDYxbmxwUkJoOWx4QXpQa0htaEtEVTU0Szc0SE1DM3RGVnJlTUJUTEtZaVpm?=
 =?utf-8?B?WFdRcUNJdVNrM0xEYmpYZnhVVEZQKy8wajBZa3IrMnBzcVh3WmVFb2RkeEZT?=
 =?utf-8?B?S0FhdHIyM3ZwdzVKV2lFdEQyNnVER2NveW9IOGtKL2JaaU5UdzY3M053U1Zs?=
 =?utf-8?B?Ykw4Wi9iYmZDUCtZaGxPR0JIRjBqa2pHaE1qZitqKzhqRUE1NGZDeVNNN3pH?=
 =?utf-8?B?RDlCM0FySUo2T1IwS0gyQXlQU2kwSEVkRTBaSWs4SkJZMWR1Qk4xS29KRy93?=
 =?utf-8?B?QndLUHpZVWQ4a3hROEI0Znc2WVpPa01pZy91dm1HK0VaaFVtNVpqeFhmbnZw?=
 =?utf-8?B?eXptNUM5T0RZNmVxbDI1RGpoZHNJZlNMcnd0UmF5b0hNS0hrUThtWXhaUkIw?=
 =?utf-8?B?TnRGakFUOWZFL25xcituWHNJc29laTFNMHJ6NHlZbHFyMFUvYTFVM3lQemJt?=
 =?utf-8?B?RXBTVDBmb24yNGVrWkF4d2RVSWVKTzNCVWNvNTJxaE1YR0ZPRlFPM2VXdTV5?=
 =?utf-8?B?WlQrc205U0NPN3IzRFpZV1JiWjdEakd2cm1mR1Fsayt0aGtZQm5SZk1qbUZV?=
 =?utf-8?B?YTFFbnBZdXNSRXNBNTVPSGlWdUhNc0lQeEM1bFlyckRWZlBidHRXT3RTWWFI?=
 =?utf-8?B?L0NydDJhSy9melEvd3dsRkh2R3NKZmZCRFpncG8zRGkyaDRORU5BT3Y4M1dV?=
 =?utf-8?B?TEY0ZjFIRkI5cStiVFFYczAySFhPdkZvT0gxdmV2endwYytjdmtnNi8yN256?=
 =?utf-8?B?T0xaNXJFOFFtdG5OKzI1YkVFeHpCK0sxKzBxMUZQNEN1T2tqTnVteW0veHNl?=
 =?utf-8?B?NG5ZRGVPUGdaV2NzZGV0OGxFSG5aUk9CVm5mbXdrQzdoWjBnWWcyai9QWjZl?=
 =?utf-8?B?Z1FrQ0p1SW5NNmF4T3o1dnBvUkQ1aVdpbXozM2JTR21XWHFESHY4MkFlb0xD?=
 =?utf-8?B?VXRxRnV1TnVWRUxuN2x6cURHMFd3MjVVRFNmSGxLL01JMExSV3M2MmhKY3JJ?=
 =?utf-8?B?L3RKWGFpVFRHRGNpRHB5STE2SWtJSzFTM0RvSmFlbGtoR3VFTWpzZDVMS2E1?=
 =?utf-8?B?dUhCUmpUQVZFdnY4MGh3aGE4SHBIUFlYemNxV2JBTExveGN2bjNnNkdiaGRI?=
 =?utf-8?B?NENiUDF6YkVqcERNYVE1U0p1a0wrN3RXNUVRSGR2TFNkT0RLcXhOdktmMDdp?=
 =?utf-8?B?dUtaWW1ETVFCY04zYkp2cjdUNWxOQWtsU21oaFAybDhtbGZaWVhDZWhXYmV2?=
 =?utf-8?B?WmE3YVJvR3NjbTFSQ1BmeWNRVzZFd21PdHJDa0dqTkxYaEJDYjZwS0RiZWNz?=
 =?utf-8?B?TnpUMUJHdE9mQ1FPSkxXUHU2TU41OUR3WnYvWHFhNjZjcWRaclNoa1J3cVdu?=
 =?utf-8?B?YW1WZGdoQ2Y5OTdnTHg1SlhZY0FyMUhjZ0pGNm15Nkx0eTdpbjMrSnI5RmJC?=
 =?utf-8?B?YVZNbC81RWMwN1ZXMDVqMjM1YU9SSlVrbnVRRjJTdENMeDZlQUx1bFhrcVdR?=
 =?utf-8?B?WWI4YXdzN0ZqaXE4TFp3VG1BWTh4R0VvMUNML2RNbm9XLzc3SnRHSkk2UmNM?=
 =?utf-8?B?MmIvTzQxakt6NGRuZEVyUVFBM1NsT09hbVJpRUlXU05EV0pwbXJzWTVzelpi?=
 =?utf-8?B?bzF5UFBtVVVIMHFPU2NINlhhcjFOWk9BSUcyNENRU1RlOFBCakJkckF5djhN?=
 =?utf-8?B?bzVZbDFqVVFCL0YyYzluUHlUVnBtL29scXptamJiWENGVnQvTUxtZEpzTnJq?=
 =?utf-8?Q?h9Mq+WyrNcma4xpztQQutRzBc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B35EB26E6238A449A058F48D34FAA3FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80ddf4d-93f2-42d0-5cda-08dbaffa7094
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2023 23:30:36.8152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8a53XxoMsK2An8lZ+6wAr6horLUJDLdaau+XpN7ZYfDcL5a63OgIrVfBHVcGdIrklKyL0WSdaZe/yW89JyUNzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4820
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA4LTI0IGF0IDE5OjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBbGxvdyBjaGVja2luZyBtbXVfaW52YWxpZGF0ZV9yZXRyeV9odmEoKSB3aXRob3V0
IGhvbGRpbmcgbW11X2xvY2ssIGV2ZW4NCj4gdGhvdWdoIG1tdV9sb2NrIG11c3QgYmUgaGVsZCB0
byBndWFyYW50ZWUgY29ycmVjdG5lc3MsIGkuZS4gdG8gYXZvaWQNCj4gZmFsc2UgbmVnYXRpdmVz
LiAgRHJvcHBpbmcgdGhlIHJlcXVpcmVtZW50IHRoYXQgbW11X2xvY2sgYmUgaGVsZCB3aWxsDQo+
IGFsbG93IHByZS1jaGVja2luZyBmb3IgcmV0cnkgYmVmb3JlIGFjcXVpcmluZyBtbXVfbG9jaywg
ZS5nLiB0byBhdm9pZA0KPiBjb250ZW5kaW5nIG1tdV9sb2NrIHdoZW4gdGhlIGd1ZXN0IGlzIGFj
Y2Vzc2luZyBhIHJhbmdlIHRoYXQgaXMgYmVpbmcNCj4gaW52YWxpZGF0ZWQgYnkgdGhlIGhvc3Qu
DQo+IA0KPiBDb250ZW5kaW5nIG1tdV9sb2NrIGNhbiBoYXZlIHNldmVyZSBuZWdhdGl2ZSBzaWRl
IGVmZmVjdHMgZm9yIHg4NidzIFREUA0KPiBNTVUgd2hlbiBydW5uaW5nIG9uIHByZWVtcHRpYmxl
IGtlcm5lbHMsIGFzIEtWTSB3aWxsIHlpZWxkIGZyb20gdGhlDQo+IHphcHBpbmcgdGFzayAoaG9s
ZHMgbW11X2xvY2sgZm9yIHdyaXRlKSB3aGVuIHRoZXJlIGlzIGxvY2sgY29udGVudGlvbiwNCj4g
YW5kIHlpZWxkaW5nIGFmdGVyIGFueSBTUFRFcyBoYXZlIGJlZW4gemFwcGVkIHJlcXVpcmVzIGEg
Vk0tc2NvcGVkIFRMQg0KPiBmbHVzaC4NCj4gDQo+IFdyYXAgbW11X2ludmFsaWRhdGVfaW5fcHJv
Z3Jlc3MgaW4gUkVBRF9PTkNFKCkgdG8gZW5zdXJlIHRoYXQgY2FsbGluZw0KPiBtbXVfaW52YWxp
ZGF0ZV9yZXRyeV9odmEoKSBpbiBhIGxvb3Agd29uJ3QgcHV0IEtWTSBpbnRvIGFuIGluZmluaXRl
IGxvb3AsDQo+IGUuZy4gZHVlIHRvIGNhY2hpbmcgdGhlIGluLXByb2dyZXNzIGZsYWcgYW5kIG5l
dmVyIHNlZWluZyBpdCBnbyB0byAnMCcuDQo+IA0KPiBGb3JjZSBhIGxvYWQgb2YgbW11X2ludmFs
aWRhdGVfc2VxIGFzIHdlbGwsIGV2ZW4gdGhvdWdoIGl0IGlzbid0IHN0cmljdGx5DQo+IG5lY2Vz
c2FyeSB0byBhdm9pZCBhbiBpbmZpbml0ZSBsb29wLCBhcyBkb2luZyBzbyBpbXByb3ZlcyB0aGUg
cHJvYmFiaWxpdHkNCj4gdGhhdCBLVk0gd2lsbCBkZXRlY3QgYW4gaW52YWxpZGF0aW9uIHRoYXQg
YWxyZWFkeSBjb21wbGV0ZWQgYmVmb3JlDQo+IGFjcXVpcmluZyBtbXVfbG9jayBhbmQgYmFpbGlu
ZyBhbnl3YXlzLg0KDQpXaXRob3V0IHRoZSBSRUFEX09OQ0UoKSBvbiBtbXVfaW52YWxpZGF0ZV9z
ZXEsIHdpdGggcGF0Y2ggMiBhbmQNCm1tdV9pbnZhbGlkYXRlX3JldHJ5X2h2YSgpIGlubGluZWQg
SUlVQyB0aGUga3ZtX2ZhdWx0aW5fcGZuKCkgY2FuIGxvb2sgbGlrZQ0KdGhpczoNCg0KCWZhdWx0
LT5tbXVfc2VxID0gdmNwdS0+a3ZtLT5tbXVfaW52YWxpZGF0ZV9zZXE7CQk8LS0gKDEpDQoJc21w
X3JtYigpOw0KDQoJLi4uDQoJUkVBRF9PTkNFKHZjcHUtPmt2bS0+bW11X2ludmFsaWRhdGVfaW5f
cHJvZ3Jlc3MpOw0KCS4uLg0KDQoJaWYgKHZjcHUtPmt2bS0+bW11X2ludmFsaWRhdGVfc2VxICE9
IGZhdWx0LT5tbXVfc2VxKQk8LS0gKDIpDQoJCS4uLg0KDQpQZXJoYXBzIHN0dXBpZCBxdWVzdGlv
biA6LSkgV2lsbCBjb21waWxlciBldmVuIGJlbGlldmVzIGJvdGggdmNwdS0+a3ZtLQ0KPm1tdV9p
bnZhbHVkYXRlX3NlcSBhbmQgZmF1bHQtPm1tdV9zZXEgYXJlIG5ldmVyIGNoYW5nZWQgdGh1cyBl
bGltaW5hdGVzIHRoZQ0KY29kZSBpbiAxKSBhbmQgMik/ICBPciBhbGwgdGhlIGJhcnJpZXJzIGJl
dHdlZW4gYXJlIGVub3VnaCB0byBwcmV2ZW50IGNvbXBpbGVyDQp0byBkbyBzdWNoIHN0dXBpZCB0
aGluZz8NCg0KPiANCj4gTm90ZSwgYWRkaW5nIFJFQURfT05DRSgpIGlzbid0IGVudGlyZWx5IGZy
ZWUsIGUuZy4gb24geDg2LCB0aGUgUkVBRF9PTkNFKCkNCj4gbWF5IGdlbmVyYXRlIGEgbG9hZCBp
bnRvIGEgcmVnaXN0ZXIgaW5zdGVhZCBvZiBkb2luZyBhIGRpcmVjdCBjb21wYXJpc29uDQo+IChN
T1YrVEVTVCtKY2MgaW5zdGVhZCBvZiBDTVArSmNjKSwgYnV0IHByYWN0aWNhbGx5IHNwZWFraW5n
IHRoZSBhZGRlZCBjb3N0DQo+IGlzIGEgZmV3IGJ5dGVzIG9mIGNvZGUgYW5kIG1hYWFheWJlIGEg
Y3ljbGUgb3IgdGhyZWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0Lmgg
fCAxNyArKysrKysrKysrKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9rdm1f
aG9zdC5oIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQo+IGluZGV4IDc0MThlODgxYzIxYy4u
NzMxNDEzOGJhNWY0IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgNCj4g
KysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQo+IEBAIC0xOTYyLDE4ICsxOTYyLDI5IEBA
IHN0YXRpYyBpbmxpbmUgaW50IG1tdV9pbnZhbGlkYXRlX3JldHJ5X2h2YShzdHJ1Y3Qga3ZtICpr
dm0sDQo+ICAJCQkJCSAgIHVuc2lnbmVkIGxvbmcgbW11X3NlcSwNCj4gIAkJCQkJICAgdW5zaWdu
ZWQgbG9uZyBodmEpDQo+ICB7DQo+IC0JbG9ja2RlcF9hc3NlcnRfaGVsZCgma3ZtLT5tbXVfbG9j
ayk7DQo+ICAJLyoNCj4gIAkgKiBJZiBtbXVfaW52YWxpZGF0ZV9pbl9wcm9ncmVzcyBpcyBub24t
emVybywgdGhlbiB0aGUgcmFuZ2UgbWFpbnRhaW5lZA0KPiAgCSAqIGJ5IGt2bV9tbXVfbm90aWZp
ZXJfaW52YWxpZGF0ZV9yYW5nZV9zdGFydCBjb250YWlucyBhbGwgYWRkcmVzc2VzDQo+ICAJICog
dGhhdCBtaWdodCBiZSBiZWluZyBpbnZhbGlkYXRlZC4gTm90ZSB0aGF0IGl0IG1heSBpbmNsdWRl
IHNvbWUgZmFsc2UNCj4gIAkgKiBwb3NpdGl2ZXMsIGR1ZSB0byBzaG9ydGN1dHMgd2hlbiBoYW5k
aW5nIGNvbmN1cnJlbnQgaW52YWxpZGF0aW9ucy4NCj4gKwkgKg0KPiArCSAqIE5vdGUgdGhlIGxh
Y2sgb2YgYSBtZW1vcnkgYmFycmllcnMhICBUaGUgY2FsbGVyICptdXN0KiBob2xkIG1tdV9sb2Nr
DQo+ICsJICogdG8gYXZvaWQgZmFsc2UgbmVnYXRpdmVzISAgSG9sZGluZyBtbXVfbG9jayBpcyBu
b3QgbWFuZGF0b3J5IHRob3VnaCwNCj4gKwkgKiBlLmcuIHRvIGFsbG93IHByZS1jaGVja2luZyBm
b3IgYW4gaW4tcHJvZ3Jlc3MgaW52YWxpZGF0aW9uIHRvDQo+ICsJICogYXZvaWRpbmcgY29udGVu
ZGluZyBtbXVfbG9jay4gIEVuc3VyZSB0aGF0IHRoZSBpbi1wcm9ncmVzcyBmbGFnIGFuZA0KPiAr
CSAqIHNlcXVlbmNlIGNvdW50ZXIgYXJlIGFsd2F5cyByZWFkIGZyb20gbWVtb3J5LCBzbyB0aGF0
IGNoZWNraW5nIGZvcg0KPiArCSAqIHJldHJ5IGluIGEgbG9vcCB3b24ndCByZXN1bHQgaW4gYW4g
aW5maW5pdGUgcmV0cnkgbG9vcC4gIERvbid0IGZvcmNlDQo+ICsJICogbG9hZHMgZm9yIHN0YXJ0
K2VuZCwgYXMgdGhlIGtleSB0byBhdm9pZGluZyBhbiBpbmZpbml0ZSByZXRyeSBsb29wcw0KPiAr
CSAqIGlzIG9ic2VydmluZyB0aGUgMT0+MCB0cmFuc2l0aW9uIG9mIGluLXByb2dyZXNzLCBpLmUu
IGdldHRpbmcgZmFsc2UNCj4gKwkgKiBuZWdhdGl2ZXMgKGlmIG1tdV9sb2NrIGlzbid0IGhlbGQp
IGR1ZSB0byBzdGFsZSBzdGFydCtlbmQgdmFsdWVzIGlzDQo+ICsJICogYWNjZXB0YWJsZS4NCj4g
IAkgKi8NCj4gLQlpZiAodW5saWtlbHkoa3ZtLT5tbXVfaW52YWxpZGF0ZV9pbl9wcm9ncmVzcykg
JiYNCj4gKwlpZiAodW5saWtlbHkoUkVBRF9PTkNFKGt2bS0+bW11X2ludmFsaWRhdGVfaW5fcHJv
Z3Jlc3MpKSAmJg0KPiAgCSAgICBodmEgPj0ga3ZtLT5tbXVfaW52YWxpZGF0ZV9yYW5nZV9zdGFy
dCAmJg0KPiAgCSAgICBodmEgPCBrdm0tPm1tdV9pbnZhbGlkYXRlX3JhbmdlX2VuZCkNCj4gIAkJ
cmV0dXJuIDE7DQo+IC0JaWYgKGt2bS0+bW11X2ludmFsaWRhdGVfc2VxICE9IG1tdV9zZXEpDQo+
ICsNCj4gKwlpZiAoUkVBRF9PTkNFKGt2bS0+bW11X2ludmFsaWRhdGVfc2VxKSAhPSBtbXVfc2Vx
KQ0KPiAgCQlyZXR1cm4gMTsNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCg0KSSBhbSBub3Qgc3VyZSBo
b3cgbW11X2ludmFsaWRhdGVfcmV0cnlfaHZhKCkgY2FuIGJlIGNhbGxlZCBpbiBhIGxvb3Agc28g
bG9va3MNCmFsbCB0aG9zZSBzaG91bGQgYmUgdGhlb3JldGljYWwgdGhpbmcsIGJ1dCB0aGUgZXh0
cmEgY29zdCBzaG91bGQgYmUgbmVhcmx5IGVtcHR5DQphcyB5b3Ugc2FpZC4NCg0KQWNrZWQtYnk6
IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KKE9yIHBlcmhhcHMgcGF0Y2ggMS8y
IGNhbiBiZSBqdXN0IG1lcmdlZCB0byBvbmUgcGF0Y2gpDQoNCg==
