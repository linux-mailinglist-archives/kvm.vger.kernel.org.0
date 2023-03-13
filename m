Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6446B7C15
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCMPhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjCMPho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:37:44 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939D030B3C;
        Mon, 13 Mar 2023 08:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678721863; x=1710257863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T8XOBmK9O3C8Y1EnkUB89TlRFAzEVYxtQ9JcwRBkamQ=;
  b=UYa0TiwEZJPa76IFr6+csTgSt3yHrVoyYZEIiIr4gi4XeE38sO+10xw6
   KXE/2fGInHYkg3jh6QcHialN9CHj+k8rbSmzW9rj8wZ1JQozV4p+h17B1
   L/bz9T3zDgqookTqgfu/blDXrE1ikWWn0TXSnz0Ahp/249IClRPDIUfiF
   nozHnOwMoZeBy7Z7tCJN+qp8W6wWo7Uq16shGmRIlChE2SsRp+oSc5tsA
   nSt7pEaIwnvA3r6IpyXjFQngfqiC1jJDNK8ixCk8DsFZqZGh92NAgYI1U
   oprsRsRrZ1zxYIk/gAnMuf/G9+xK63Ypt35LhRfczf3oyie9xW30soPr0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334652910"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="334652910"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 08:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="681075049"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="681075049"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2023 08:37:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 08:37:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 08:37:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 08:37:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzJpWGBtt6kqEF373hlqw9vYsOp0aCvdWDpHkHSyHhnylWAPuyIxFHC4UFVrcgUL+6jP0x5UOOpSkFd3EF0wvfik74zj82lxYhzBTLO4L3OOjQxULkaaQ3y+cDV8mLb5xithlxC3UOXHHCYV1kAquW9w8bf7EI2AWZGEgaLWKMBCkl15n9kjYvhu46wbBpBhIuVaO9A/tJTy9Ghrr8sPXHaAu0d/1Mi45ljfp59IpITBI6fWc8DRoNx0DT/ZOCW4ON1tnEqrlxLcq1LfTowPkmTRxBI92bN+4AVI3HeCUvhVyz1I3Ot+ocoKvWvfv+0telJBv0fRM4EOiSc34EUoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8XOBmK9O3C8Y1EnkUB89TlRFAzEVYxtQ9JcwRBkamQ=;
 b=LiRLLIsLxnvA7s4sYh1aWa6pZaPxc6Ne3BOxaMVe17BQmqWT+DtoEvhzt1S+uXBD2LfOYe3ZUaBH9XVhs3gRF5gFIsiAYd+Pek++I1FiPQ46kJjSOjLP8fg7e8plQWtPqJUsoDQUROVv82wp500nRop6AMRHve0HePFKf8yegqseGzyqdJrXy16K0ErfLkIzMcCDsSi+WaT6ogo9TO1Jl8oRrINmFhL7BP9NKR5xGJ3+3ciett1Wlc4yNoxp4IDamgVAF5GBYuMYpyTuvQKZMcTM5gDmVm+HGgA4e6VTv9+FClWPeW9we1piRd8ecKwaHzVvsGGtIipVwfLaRzeVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CY5PR11MB6461.namprd11.prod.outlook.com (2603:10b6:930:33::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 15:37:21 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6178.023; Mon, 13 Mar 2023
 15:37:21 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: RE: [PATCH v2 01/27] drm/i915/gvt: Verify pfn is "valid" before
 dereferencing "struct page"
Thread-Topic: [PATCH v2 01/27] drm/i915/gvt: Verify pfn is "valid" before
 dereferencing "struct page"
Thread-Index: AQHZU6+4GVKiIACBwkGy0oYb+xDBAK742ESw
Date:   Mon, 13 Mar 2023 15:37:21 +0000
Message-ID: <DS0PR11MB63733BCF5AEBBF5F38FD2C01DCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-2-seanjc@google.com>
In-Reply-To: <20230311002258.852397-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CY5PR11MB6461:EE_
x-ms-office365-filtering-correlation-id: 8bb071ed-cac7-4d1f-ffc2-08db23d8d629
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oe92AZQresBPFcMKDzQlhl0LKfzdgD4X/Ev+o8oOCSDQib6T9rGz6hKpbU9d6P7yD+Xc4PE8J09XnMAG0P4jW0eC53JU8crIrsLYW2hP/CFmBNMcXu5NSwky4jKWdMc/qOk/rKiS/5s2vQecxL6wEiJU4FjDH/ZS8ejJhjU6y4LKnNDkBL1j4uF/8cWhA2rVofgyyGBbrhvPCsXpwMledSz+eHZkHiYkYvFFTHQdFELWj4YjnGwTTaUPJolvM5z0v3FEDkt3P62Gh/yFYMGt9u8hACYLamYmHQkVNnWhtVRe2iKbPfzAck9CQk8F4y6IaTTKpt3hQYjUaODKAmPLNfllZ6aJShlHkKA1YNobZpcpP8rsx9nNthwIWgeKtt2bJCM6CLpQb5XNdt1PjDV7bGgPIee9U0YVZBpNVfm0N/Xo6sfwQWPFlhUmtHB/0LltDNBG3wis7rGHLelmH0KSBQeLfyB9oou5TyIhCkV6V0kBg8tDZOA3pfexfelnw2FEl8pksTtMf45u95jMOG3Y5otPb/fd+wcm3TzWb8NzVVNPoTlnGmg9EX2TcaahFHZ2QMLmbb/SMUrNf1xZ8LpCvhlO7we9/c6O8rIuuA9xola4849vmUFc+XvINqiKlcHcCBUeybxXwIONPtmeLw3tTL21zlvOUmGWmlCtHnsSVTUZ2kzwm6jTGlbRzHfggZaii5bjzNoXvgBQh0v1VfKkNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(8936002)(2906002)(41300700001)(66476007)(66946007)(5660300002)(66446008)(66556008)(4326008)(64756008)(8676002)(4744005)(76116006)(52536014)(316002)(478600001)(54906003)(110136005)(6636002)(7696005)(71200400001)(6506007)(26005)(53546011)(186003)(9686003)(55016003)(33656002)(82960400001)(122000001)(38100700002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RG5ldjAzNHFvUm5NQktjR0xBOHZCOXBhbjM4VDA5d0xhOGorSlpqRXc4TUwv?=
 =?utf-8?B?OUNMRTEyZ3Vjc3ZLNXlTb3B6cmsxVkI1ekRSZm1IekZQczdkdWI5dFFTQjkx?=
 =?utf-8?B?U21GbW1OZVZzSnlWaHkwMHdlNjdvZ2RaZjZsRzkzKzFDeTJmN21VdHBxZUNL?=
 =?utf-8?B?L0hSMURibGRmL3NRL2FqYTB3VmxTWnFsRGpZbDBDeGJ0Wk9tY29jaXZTd29P?=
 =?utf-8?B?UWhOYUFDYWh6VW82VUY2ZTlwb1dGVjQwcUswR2c3dVFYcXlJTE9ISVhTelYy?=
 =?utf-8?B?MjkxWEptNno0cFRqcXBOTW9JeHAxait3Z3pVNVJhQldrQ0FyelpocFBoUmZa?=
 =?utf-8?B?YkwwMEM1K1VlTHdDS2dBbGdsV09wdndXUXRRM2NjOFBFNmNJc1c2U25ESjVG?=
 =?utf-8?B?TG5OUlBBTmZHbGE1VThoUkdTUUdCb2dCSUFZSkp0K1VxWUk2MVY5WjRBbGtC?=
 =?utf-8?B?VU9JTFBld3diQ3diRDJyYjNYRitvVEg0TDNuODVxWmE3SFl6OURGRk9oZS9Z?=
 =?utf-8?B?NXpVUi91MlRMUjI4VWpSOXdpbGEyWEg2M25iQXdzazJOdUtMaWkrd3E0RmJx?=
 =?utf-8?B?UFVaanlyOFRpT1BPS3BJUkpPNG40V01UakM5Y3VsOGEzNFhTeVBvNktCdC9z?=
 =?utf-8?B?V3hTZnhKd3BzWnNFRFIyZ3BHWlFHdTBLdmsxQk84NU9MMFJhc0l4OG1wQXNZ?=
 =?utf-8?B?dkFJRGtrZ1o4ejIyaG5ZS29wY0IxUWZLcWl3OWk3VFpXSkRHUTlSVm44STNN?=
 =?utf-8?B?amxQc3dGRUpkYm5TT0FkRjhiN3R5ZXpFMkJuUHhhMGlucnRQNlBQRFhtU3FZ?=
 =?utf-8?B?K1d3WHdZd1ZrUUYwZDJQRVdoWDg5Mys2a0ZPblpFb2dqb216cktJU3dtWGdn?=
 =?utf-8?B?RnoraE9YbFlUaXV0K3VJNXJqbTN3aUJxa01KZGhvQUU1V1JZbGpmZHpZL01D?=
 =?utf-8?B?bXRKTzNaZEc4cUxLV2ZoSHJ1dWhJalNOS05OWEZWNCt5UytHelluMitzanBq?=
 =?utf-8?B?V0hjMjhXTmtia2hQRWRWWjZzYVlCUkJmcmYraTdSa0c5QVZha3FRbTNaQUVU?=
 =?utf-8?B?bVhzYko5dUVGUllwZDRLc0tHait5MXJHZ0I1RU41aWZuNkZWMGpHMkpJd2Fw?=
 =?utf-8?B?ZkI2RnBiSUxOZFNzTHc3djhXMFYrQ2dabU11SGtJSzl1YXVrTkpWRDY1ZHV5?=
 =?utf-8?B?QzBNUUx3ckdFbTYyNW9SZStlSGhUVmE3a3l3TmJ3bGdhMURCWTZ1SDJ1RGxE?=
 =?utf-8?B?cUdNZ3p5YStuU0hyUFZhYWtSRUZVczYyMllCSzIxVjhhcVFuNmlUejdaT1A5?=
 =?utf-8?B?b0IzdmNqKzV0S2w1RXdqL0l1bVVtMGdrbHFGTHRVSm9qNWJQdGRKNGRxajhK?=
 =?utf-8?B?T3dxbVRQYTZaZ1dEUXgwSTZmNGlZc0Nqb1VtamdZUVRVVDQvMks1V0xjK0Ev?=
 =?utf-8?B?cnJGK3VrR3NlZWZESldwbzNiSzZBNzhXVm9rOTFEWjBVZEdVMjhFeGQ4ZEFN?=
 =?utf-8?B?azg4MTNIeUNoLzdhNFFCbHg4RzF2V0cyQlVxZDBXRGJxTlNDWkhxSFRSZm9Q?=
 =?utf-8?B?cXNHKzJjMUFVcWVoSHZZR1hycmcyOHpqdEdmNkxtOStXeGR3YUU2ZVlDT1Z4?=
 =?utf-8?B?N0FVaEh0MWZFQzcyR1JhcDltWG13KzFpazhCWG14VTVNc1UxMXNpVWZETGR0?=
 =?utf-8?B?d1B2OFNuQ01INHJPeTBSdUJtSmdnSnV5Q0g5b0pQS0hjdHQ5dlI3ZXBlY052?=
 =?utf-8?B?eitxR0dWWmZPRUpBc1lWdmE1aTFZQ25zeGszZ2o2b2hQYVJmTnBqZVNHeXR5?=
 =?utf-8?B?UUxXMmlKVGZjUUVKOCtWdzZlVFpNakJ5L25rODV5cUp2STRuelJjSm1BRW54?=
 =?utf-8?B?SnJWbHlUTDkvL0VKUW9zU04yUjhRNzljOTl1RVdJYWp2MzllZk5vdjM4MTlC?=
 =?utf-8?B?VmFYcmdmWTJCUnVWS1hoQUwveitoS0RYU0xDMDcrZW0yeE1jbzRTRzdhUllp?=
 =?utf-8?B?VG9Ud3RHYmF0RkhkZWl4SGVZdWtoMTRvb2ZYL0E5dlRjSE4wekRZb3NPRW9z?=
 =?utf-8?B?d0dCaDMwOE9CWTlyMWx5aE5YUXhTbVk0b3hqaDUwbm9HaFRvdGsvRG9QTGNG?=
 =?utf-8?Q?K6oBcysmR8/LQjJG1XvntYezZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb071ed-cac7-4d1f-ffc2-08db23d8d629
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 15:37:21.5573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdmqLxivBV55EwxYdNbu3iQ2B+9o7IEq3zEdbs/X1lBNUqIPf4N0ayR7b4CA5vCX9Hb8nlR3A71UeHbspjLLRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6461
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0dXJkYXksIE1hcmNoIDExLCAyMDIzIDg6MjMgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQvZ3R0LmMgYi9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQvZ3R0LmMNCj4gaW5kZXggNGVjODUzMDgzNzlhLi41OGI5
YjMxNmFlNDYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9ndHQuYw0K
PiArKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQvZ3R0LmMNCj4gQEAgLTExODMsNiArMTE4
MywxMCBAQCBzdGF0aWMgaW50IGlzXzJNQl9ndHRfcG9zc2libGUoc3RydWN0IGludGVsX3ZncHUN
Cj4gKnZncHUsDQo+ICAJcGZuID0gZ2ZuX3RvX3Bmbih2Z3B1LT52ZmlvX2RldmljZS5rdm0sIG9w
cy0+Z2V0X3BmbihlbnRyeSkpOw0KPiAgCWlmIChpc19lcnJvcl9ub3Nsb3RfcGZuKHBmbikpDQo+
ICAJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJaWYgKCFwZm5fdmFsaWQocGZuKSkNCj4gKwkJ
cmV0dXJuIC1FSU5WQUw7DQo+ICsNCg0KTWVyZ2UgdGhlIHR3byBlcnJvcnMgaW4gb25lICJpZiIg
dG8gaGF2ZSBsZXNzIExPQz8NCmkuZS4NCmlmIChpc19lcnJvcl9ub3Nsb3RfcGZuKHBmbikgfHwg
IXBmbl92YWxpZChwZm4pKQ0KICAgIHJldHVybiAtRUlOVkFMOw0K
