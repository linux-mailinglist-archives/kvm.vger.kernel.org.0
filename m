Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A49570FC98
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 19:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjEXRZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 13:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbjEXRZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 13:25:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7BBE7F;
        Wed, 24 May 2023 10:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684949067; x=1716485067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PduKorIOoxp6zAqGwW1Ke2aE3v2tuVoo5G+LK9jc9Qo=;
  b=LGYiuZZTs6y3Xw5KtPuTmrmx7Pt5jVmJuvQb4lYrkrtMpy6jKTEHGOvQ
   kbUblbxrzEUtgeg12QaOA1/rGu/Q9Qx2k7Ul95E06MvYWcv30zJJFvoeD
   RQvOS7cGISN39gbvR+60i54y+Bm3wcMvE9ik1sFPdthKp2/IuBF9NMVMt
   zMHaUgsSktBIbci22blew86NmPHrsOtEppDUoEx8O30PWAWcGSuUAIKW8
   C4KlhaHx3EgpmpKQPAl2DzQs3ZYZpAOlnS5GLfiWTQnj5e9HOUP3c2M11
   5mo4AL5jjYx8AS2AkqeE0vnaFopBqQK+bvpT/+Ef9vTEdv9CXru2A7e7D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="381882095"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="381882095"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 10:24:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="816672085"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="816672085"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 24 May 2023 10:24:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 10:24:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 10:24:25 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 10:24:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eejbklL19FI2EadNgBbmtO0QuJVHf4ZMDyFGFGuBaxoDy93Cqor0kRI9EqnIXaC6wPC50YY+XtiZqqdSdza41kXW5GIMrIAIjbCIZ+Ac9plnjMqvkR2tPhoQgT85Mh72GFJWONg7g1qKHG4VA2tjBgBeAcBhKIbDJeVAAgy+jATFzptqaglP7myXjRzvz0tjkC4TkbtLmfoCs/8YBtMxRNvlkQsKjIAUdT/SovyVE+kLtlqI/9xVq7OLsZ/ARNPvEC28ca79J2zsKF8l3Z1wL5GR6YE45jl8KkwXXg/0dGJ+mO4Wx26kYCmcdJJ2xHG7Ck5t2FmeAdVatepv6mCHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PduKorIOoxp6zAqGwW1Ke2aE3v2tuVoo5G+LK9jc9Qo=;
 b=YeMrW1qqLLbrIXWJhPWKQvbJUF3u/4pZUwf9WV7cVWl5WDLv8Ze41g+H9Aerxp9GssBl/kMQy9UIG0DAK5CsUt1ffpFts9ndUALL/tPuPBvUL11gm4jGcYX92je16PuP70+TybZBEh4eVXQ13ubrcI4a/9NLp0aYRNDaAoyHxcbffI5PkFa8g6W11JazscsB0CoN7u4p8FlJ4yVYvzufGknKt4suaADd9q6RB+OF4R6jYfbJIx+GCztYJS3i4e62HF2m8wzl2KwNa17tfISKCykHrxLwfhvI5gJilm7L9wxAZOz++NbmHnTknR1kZe672HZOrfbe3G1ZYaYNQf/HLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 17:24:23 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::c6c4:7e98:bcea:f07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::c6c4:7e98:bcea:f07d%4]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 17:24:23 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "john.allen@amd.com" <john.allen@amd.com>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Thread-Topic: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Thread-Index: AQHZjlgZ1tFS5gCtHUqRoMcpmbTaTa9prHeA
Date:   Wed, 24 May 2023 17:24:23 +0000
Message-ID: <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
References: <20230524155339.415820-1-john.allen@amd.com>
         <20230524155339.415820-7-john.allen@amd.com>
In-Reply-To: <20230524155339.415820-7-john.allen@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|CY8PR11MB7825:EE_
x-ms-office365-filtering-correlation-id: 298cc868-be70-4a73-9280-08db5c7bb76a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 32SYYsPW/Mk9vXTdKyG94LZATradJQBrpLfKGjAKYQxLJ7oaL851hNu6qlv7OVnCzgvy2KqNdR9RPeOJYzeipFWvC4BRBj4pwnWsASc2dCZYciurFbcgi2HR8kgNrEphe4iU73jNl/VEwB4u1x5Oht2urzXl/kR/B9y6yod8w0w+BBX9a0HEu2a4BHX6SnxLPMPseFwsUxY+JcKzNHhAKoZHZ/2Zw8/JsiKyn1Ym+nbTYaNPPX9uTfbTXU9EDcG7YqVmZFnQU9knN+ZIWFXVQwaWDZ+6RULAs8nDfKxGA4kbCdg6WcBKhVEOuLu6a0W669P5RGjuBemaZpnUKnQC2eWNI4a80b4J29S9MgIhfHHQ5redRcKp1FDO2vfvYnXMJ+wxfO0XEi2LHhTD66dJ8Jo519NKuoNKJlT8f4Rjn/z+We/ETwY2lnNp0EMx3tdmsjPxNt54efI/SBLry1svJcnEiv0qyYKc7/IkH5kDbVDU2AZCVnkWI/T+6UsUNk6jzQQkIomJKmS0ZwCA5/X19bMkLFGRc1eBe2AIK9XA2LOeT5HveteDDolLMRPVkQNGZT2KLSYfupzkzYXoleH+OvG4coEX2mKNfVuG18QUXKvRQck6jKIz7r1s4mJCyQaF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199021)(26005)(6512007)(6506007)(186003)(2906002)(2616005)(316002)(71200400001)(36756003)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(76116006)(91956017)(122000001)(82960400001)(6486002)(41300700001)(38100700002)(86362001)(54906003)(110136005)(478600001)(38070700005)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjBBd2ZpaUNTV25WeWgvdjBNRWNkVWVXTVB2bll1SjlIUDYrVUdKaVVlZkcx?=
 =?utf-8?B?Z0Fmc3gzc3JyWWVjeVBXaGdibnFWUFR3YSsxRFlKWSthVUo3UzE3KzBaY0E3?=
 =?utf-8?B?M2F3K3Z3d0hpa3VycmV0ekhFaDI2WHk0UGhPSjdOeE1kSkVMc1RpQmJkOGxU?=
 =?utf-8?B?Mmk0MUhqU0hLajBNaWkweUpwdUw5UUlNQXZUaTZmbFdKSWZtY0xBZElmU1F5?=
 =?utf-8?B?SVdDNGpwUWVYUVRMNHJYbUhVckJPMU9vVExwZm43Uk1QZ2FScEgranpxcW4z?=
 =?utf-8?B?WDhWL1FndDhXdnBxQlREV1F6SnNpVFl6SDNiNmhqVE84djlwNHZsa3BkdkV5?=
 =?utf-8?B?T295VDJBVDNLR0UxZEdZTVdPeGdBNkEyQVN1aVQ5eGtjZnQyVFQzQUpXUUd0?=
 =?utf-8?B?NUJJWnZsdlJkM0NHUk9KUmhuVGkvRUEvaXFJTUwvU2U1QUVpNmtmVjI3S0ty?=
 =?utf-8?B?VGs2VE9lRU01WGlpeEhXZFBXOU9kUXNPMEI2RzFkK1F6ZGxmRDZ3dnRVL0tW?=
 =?utf-8?B?ZVgyMUJvZFFoaHRBeENJQm9wdUczcmsyTUgxb0NwSjVET2tndlNhNk1RUW5T?=
 =?utf-8?B?L1hXNmp2MFJBdGxHc3F4ckJsaGhFNkI5RUY0REJvMTJuOUpnQm94bXArQjlU?=
 =?utf-8?B?VmRiWmFpOUhnRFc0VEp5bFhpM3RjVzNPTFJSTWpMNkI5Y0Q5MG9rOFZ3dWls?=
 =?utf-8?B?ekZpaThFWWRsbUNVNzZvOEFxME5ObWhKOXdTSUZENzVldUNRZEpkMmZDS21Y?=
 =?utf-8?B?VEhmWDFXd3pQVEI5WC9tSkJCKzZMQ2RzT2F2QlNxT0Nmb1dtWnd0L0luRTg0?=
 =?utf-8?B?RHphbHgwY2lqejNLc0VudDdiMUc1dEJ2OTZzcEMwcnE4MW9ldzluaHU3UWVi?=
 =?utf-8?B?MnRFVmdhZ3R0VFZpQW9TSWpmUHdEZlRhd0UzZENFR3hibkJCWWpLb2taUHMw?=
 =?utf-8?B?YUc5SXVZU3lRZkV2K2NWWFM2dGxTUGNZVi9qUnEwak5FTVN5d2ltNVdZcXFu?=
 =?utf-8?B?T21IcHo3NVczaEo0elJpSVN4WUMzMCtOdGI5SFpHa3hDc2d4MEs5TzArRFI5?=
 =?utf-8?B?UHJrSTlBL1ZTWmJFYXFYSVJDd3pXcUNDR0pGM3BOS3Q3aCt0ZDY1Skd0M0Uw?=
 =?utf-8?B?SE5iRWVMYnB0VlpDOTVVMGhLb21qTVJrRTVtakU3SEMxb3lVSEMzeVNFWFp5?=
 =?utf-8?B?eXZwMzgrcDloemVCWW9HRThJZmhIRUFSRm9wZXdGbGRNemtmSmFWUk5lS0F1?=
 =?utf-8?B?dkdEVVppMEFlYkNoRmRKR2gxWVhrc1ZudDRWQkRUWkJFdnZrMXFSNkw5UFd3?=
 =?utf-8?B?NVFGSHRqd2ZWUjY3Vi9Ha3doa21ScEY2cytFUytvQkxsQ1hUMzdmZmlCV2d6?=
 =?utf-8?B?SHNWSDZNR2tvUWorZE9hNTNMR2VHeGpwVXlLdFNFMXN6TkMvWXJJUU1MbmhT?=
 =?utf-8?B?dFZ3VDdCbDBjNnFaZlJwZlZQUEVVZzJma3dlRDVxVnVRVlBkbWw0SnZOc1VJ?=
 =?utf-8?B?V0ZaQ0NGRm83WHNzQzdFR0dvSFRveHpxem92aVFuVDRpYnB4bWpBS2ZiL2dm?=
 =?utf-8?B?Q0VMYmFxc09RektXa3M4R1ZPUVNITmRUNmNWcXFwN2NzQVlZdUhIcTVhM3Qz?=
 =?utf-8?B?OW9Fc0w5RnRnV2FWTFNSOS9haVIvcVVINnUwWnBPYlM1dmNtUjMzYnJYZ1ov?=
 =?utf-8?B?ZElFVitkbWdVTmp2MnpqUlJIREhmYktSYktNc2FEbmpVYnVPWjBTaEFLV1BZ?=
 =?utf-8?B?SWdPK01pSVRtQTN3WE02YUFsdHZnQWVXQlRZZlFqYkNZcWpWVVJZWCtHck02?=
 =?utf-8?B?R2pIdU8vUVo4TmVFcDZCQnh5OHViM1kwV2JrRzlqVk9memFPUm9YZi84Znh1?=
 =?utf-8?B?ejA3WHVxa2FtclVBNVZ3SVR6MlpaTTBrbmNCWEVycGt5bW1vL1Jtdkx0NEtu?=
 =?utf-8?B?UkpBTHpBdEF3SDV4T0dPOEZsSENzU3VUZDYzdUk4V2xac2RXNnY2RmNpd0ln?=
 =?utf-8?B?eXJ5TzQ3S3hueUc3UW1pU3hwd0NpejJ2ckppVFpwdUdBZGU0bllZV2ZaOStQ?=
 =?utf-8?B?TlUrRDlubVVobFk3VFY2OWZKbkxMbkJNazhTNVlWWG1LeGgydksrbXpUQ3Yv?=
 =?utf-8?B?UDdKdWQ2RGFKNWgyRTVNNkdMWWJlMnVrOUZWUXNTcU1lVm12bkpSYnJQMWhW?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91E07D94C326AE4CA191BF28575E43F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298cc868-be70-4a73-9280-08db5c7bb76a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 17:24:23.0643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZ3TckepWS/LhFdrazKaOAGz/s5Iipoi/qS09kJ8SjkYpIz+Nc4ccS4EAGXeCsvmhbQxUMYj7+jGyxZ0Fc9qmtsXzJm4Q9e8F/TBEAYzZFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTI0IGF0IDE1OjUzICswMDAwLCBKb2huIEFsbGVuIHdyb3RlOg0KPiBJ
ZiB0aGUgQ1BVIHN1cHBvcnRzIENFVCwgYWRkIENFVCBYU0FWRVMgZmVhdHVyZSBiaXRzIHRvIHRo
ZQ0KPiBzdXBwb3J0ZWRfeHNzIG1hc2suDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKb2huIEFsbGVu
IDxqb2huLmFsbGVuQGFtZC5jb20+DQo+IC0tLQ0KPiB2MjoNCj4gwqAgLSBSZW1vdmUgY3VybHkg
YnJhY2VzIGFyb3VuZCBpZiBzdGF0ZW1lbnQNCj4gLS0tDQo+IMKgYXJjaC94ODYva3ZtL3N2bS9z
dm0uYyB8IDQgKysrKw0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+
IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS9z
dm0uYw0KPiBpbmRleCA2YWZkMmM0NGZkYjYuLmNlZTQ5NmJlZTBhOSAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+
IEBAIC01MDcwLDYgKzUwNzAsMTAgQEAgc3RhdGljIF9faW5pdCB2b2lkIHN2bV9zZXRfY3B1X2Nh
cHModm9pZCkNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBib290X2NwdV9oYXMoWDg2X0ZFQVRV
UkVfQU1EX1NTQkQpKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9jcHVf
Y2FwX3NldChYODZfRkVBVFVSRV9WSVJUX1NTQkQpOw0KPiDCoA0KPiArwqDCoMKgwqDCoMKgwqBp
ZiAoa3ZtX2NwdV9jYXBfaGFzKFg4Nl9GRUFUVVJFX1NIU1RLKSkNCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGt2bV9jYXBzLnN1cHBvcnRlZF94c3MgfD0gWEZFQVRVUkVfTUFTS19D
RVRfVVNFUiB8DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBYRkVBVFVSRV9NQVNLX0NFVF9L
RVJORUw7DQo+ICsNCg0KSXMgc2V0dGluZyBYRkVBVFVSRV9NQVNLX0NFVF9LRVJORUwgaGVyZSBv
az8gVGhlIGhvc3Qga2VybmVsIHdpbGwgbm90DQpzdXBwb3J0IFhGRUFUVVJFX01BU0tfQ0VUX0tF
Uk5FTC4gSSBndWVzcyBhZnRlciB0aGlzIHRoZXJlIGlzIGEgc21hbGwNCndpbmRvdyBvZiB0aW1l
IHdoZXJlIGhvc3QgSUEzMl9YU1MgY291bGQgaGF2ZSBub24taG9zdCBzdXBwb3J0ZWQNCnN1cGVy
dmlzb3Igc3RhdGUuDQoNClNvcnQgb2Ygc2VwYXJhdGVseSwgaG93IGRvZXMgU1ZNIHdvcmsgd2l0
aCByZXNwZWN0IHRvIHNhdmluZyBhbmQNCnJlc3RvcmluZyBndWVzdCBzdXBlcnZpc29yIENFVCBz
dGF0ZSAoSSBtZWFuIHRoZSBDRVRfUyBzdHVmZik/DQoNCkknbSBub3Qgc3VyZSB0aGVyZSBpcyBh
bnkgcHJvYmxlbSwgYnV0IGp1c3Qgd29uZGVyaW5nIGhvdyBpdCBhbGwgd29ya3MuDQpUaGFua3Mu
DQo=
