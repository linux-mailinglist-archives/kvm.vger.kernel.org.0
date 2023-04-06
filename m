Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5F6D8DD1
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 05:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbjDFDCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 23:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbjDFDCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 23:02:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FCD93C4;
        Wed,  5 Apr 2023 20:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680750158; x=1712286158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cCsrIOspZ+EMoyPyzaacUNWgFS9OixjEv+7EkhIY+QI=;
  b=eSzX9BQr++g/eCkuZvd3nqQWAhqZhNShLwOESjKTMNmlD5B2yfQ28wRc
   YRRScNZD/2iUEiOPj/U1Te/VlWEu77IbdGVFG37IyYWDJ3pNKjl70o55r
   BTfBNB1eruktwAfw+dHoT7WpCk5A0ZtJcQQo0psjGPfRzp/fL2VUxIQ7D
   LGJBIF5FFQ2JJPVSjjLd4at1FYVtMln5VmFpMGthnz1fXyDpZT3lWoQCD
   XQz60tLyfQGxQ6j+t0GOMpyfLw4ryUoUTVrbRWOXz7H11o82EWWyp5wSm
   eaBxNST1c/POqeKpUC26UIR3T+k9xlcbLiGyl8W3CDioAS3Taaj/2hfk1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="341352890"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="341352890"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 20:02:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="686974244"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="686974244"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 05 Apr 2023 20:02:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 20:02:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 20:02:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 20:02:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koUl4nzgpi/BZi3654aj4Og4fYDulYvmhY3HzlwRMm3Ox6gT6cMv4Ld/XcjjKQnFKuWnAeEgchWkx6xJoFp5jsTkKvuf067S8mkIq9RAE/4RxegPfMIbgm37LuOQ9IA9vQKtYtg7TM6458ljIEdeGDk6kGegJie/ddG3ivc5BsehRu9tPt/vdyWLTDgExZJuXhrAi1TDFIITxVtZ1QkRF5i8U8i7t7/yJcK0THxz0tzacWT/iU/X2lJ31Ya5fKTdKHLMqFxY/lulEZmEi3EgdeibYZgb5fhjMPDzPnb3T3avMTUiP3sTz4njrM15iQBZI+0k5K1wqUAR2XEpiSIPFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCsrIOspZ+EMoyPyzaacUNWgFS9OixjEv+7EkhIY+QI=;
 b=OIBX1O6qyeom5UrXcKl0G92SyEsCE6wO131AX04+N8VbPSVMDlPrHjleGDqXNYdN9vK8O8ZaqLpnYkUO+TbeA6+ZQkzNkgBShuy9AYaFTfF9IuKicJrYAufIQTlAPzWdBD3bm/yERy/gShIt92dWcsVVkZFuQLXeGnku5r4drIoEpseC7Bk2KPZ0TPXjW+t3nVZWtBQHr8Z//NtNL0kP14Q3R0CfDiSB6E6dUw4rPBYWkVdRpj9MFiC633kEJtLpMetf6ZgRpRDfmDWLa7Xyygelbeo6Rhm1CBuGCR+KzLKQoTD1XArhFL1KKzuOu5AiMBIm+LHO+pe4DNcMBI45qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8129.namprd11.prod.outlook.com (2603:10b6:8:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 03:02:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 03:02:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Topic: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Index: AQHZZ1neYlqkq4ONyEOC8NUatF9pta8cityAgAD5CACAABXYgA==
Date:   Thu, 6 Apr 2023 03:02:29 +0000
Message-ID: <2cedc5ca5e1d126a0abf3b651c6fef1a8970fcfd.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <20230405005911.423699-2-seanjc@google.com>
         <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
         <ZC4j37H2+2945xxb@google.com>
In-Reply-To: <ZC4j37H2+2945xxb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8129:EE_
x-ms-office365-filtering-correlation-id: 8f3527e3-f238-4ca5-7730-08db364b5bbe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A7uzWITbQvGoWvgjUNfZ7xz00dW1w3HYzb4MrdxBYqrgXcjY+Bvm80/vE52awQlpg/3/AKLtsjL9pNyAIdfUK6tSO/2HaYVgm3PqyDSmM8FMnC44X8yP3kgVu59ZqK5tgOD3Mk+uuyJChFnYqyR62UfAAWHaEnd96izrWDlXuwqZRZIlf2Gw2jwbCRkTu2CYwmX6xq12SA6EOJUxVoItkiyRrokHi7fEkl58olWbsuAO+xSjW0dUvO73DpPYsSRrVFOB/ga0RHwpwMkWvUg/muPsiBujGpVhZ7aSxB7g7QGaFIdL2Sfa2FouPLiYfJvHU7be01EzSJs4/S4dSkw/fwXlyDKuPznhI/KcX4Vh8XK5FCo9X+qRfD3H5W0v4QCDopReACTX7YlfuedFTeuTllEA/+uZ2oHWW5p4sA6kvt1CgNH8al5r0kjuxPOyLJgoK7103oRTtvmvlVoUXIf7cjzbPm15isFrhuvSpvP27eDWF7eMtUG3nNgWUTH4yHDTFRSlqaRFY0qsLjKtvvUJS2Dv3NvzV7VvIu5+8oY0kc5YxlWGDeR77hhtmeGrJV4q34AA9Nr7hv8A7bdxPeMkRKyEjoPz1DkTkq0T5+1WOmXw0b3SKI00FucEgmlC8I8Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199021)(71200400001)(26005)(6512007)(6506007)(86362001)(91956017)(186003)(316002)(54906003)(6486002)(8936002)(36756003)(5660300002)(82960400001)(2906002)(38070700005)(66556008)(66946007)(8676002)(4326008)(66446008)(38100700002)(76116006)(6916009)(122000001)(64756008)(41300700001)(66476007)(478600001)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHRIZ1c2ajJYTEVGV2sxdGl2YkFjSkZSSmdDdWtmZzE2NjJ1OXNuRmdJdkxM?=
 =?utf-8?B?akNUVisrSmxvdGJBMzRxdllGNlIrSm9tUTYzazdwMXZYOUpTU1BoZXZtcDJO?=
 =?utf-8?B?Y1lGUWI4OFQ2MzdRSEc4RnJwU1ByanBJbENZK1VuL1U0emIyS3pzUUdxbStI?=
 =?utf-8?B?UGFBMjYzUGRhV0RRakFIdk1uZ0t0c010UjBDTEhBVjhpdTB6ajhkNkVHbWtQ?=
 =?utf-8?B?c3BiQkxsMmlSOUNCSDZjS2p0SzlnM0I4Y1E2d3l2aXd1TTVFdENuK3dXUFRE?=
 =?utf-8?B?M0JZSzlrcE1MRWQvcGlSdHFhd2hOT1BQN2ExYU5zV1h0RDIwLzFHSEs1dlNC?=
 =?utf-8?B?STZKS25ZNFg5RzBUMzhEdDg5WS9PUGF5WmVVWWtZYXQ3c0E3M2dFRGc1THg3?=
 =?utf-8?B?MitYendZMjdOTTE0R2lNZWFYaUVXbDkvcHkyVGNQVTArUVRuRlUrODdsWWZp?=
 =?utf-8?B?WHhxMzFkMHJtcUZxT1ZVWFFKbC9xVEdVQ3dqeGQ2bnNMQTBSZWN4dm8yYTNN?=
 =?utf-8?B?dktsVnFMeG41dzQ3ZVBubGtyeUFJWkM5UkFRcFVIN2YyMXQveXlUR3FCWnY1?=
 =?utf-8?B?TVlUZnhDcGVaSVRSRkRHZ25uaTh0Qk9rQU9kdndxYTBDY0p3WnRDSk5lR1Fn?=
 =?utf-8?B?Z1ozMGswdURMUHlwcmI4d2pySnB2THZwenBoaUdqY3BWUVNqQmVEUHdQTmVW?=
 =?utf-8?B?NUVGZ1pmaUZGb25OeGdGRis1NmRvaTYzdjd5NU1nYmFMME4zQXR3QTYyZU5h?=
 =?utf-8?B?cjlpcm9XTnFIcnZDSSs3djZ5ZTExSEVPQUVrZlBZTUZybkdOYUt0cUQrQ24w?=
 =?utf-8?B?cjdqcDdwVUdVWUZ3ZlN5aXVJUjY4dkFPOVY5bnRHWXRNdnJuQjNGaHN4ZGg5?=
 =?utf-8?B?TFZYM2VHOFlHT0NLRFpCN1lLWkthNmdEcDlPYU44UmhIekcrZjhjWUdhZ1lF?=
 =?utf-8?B?WUhQTWljSW9iSmJJR0dQNjhXbStLYk5HYWpvK01jSWNLN29oODFIUkhUVEs0?=
 =?utf-8?B?cWE0V1V2UmNXaTU5b0Fsam9nRHU4ZzJIMFR6eTdkbGJPYzhSSEx5bWxkWG5m?=
 =?utf-8?B?Z0h2R3NIUWN0L3JJWFlpNE9rS2xsRUlDV3NTTjZXd0xlbnhsOEc0Q29Db2F4?=
 =?utf-8?B?NU1xTUQwUVpIaXFNb2ZuRjZoU2U3dm52NmExMmlnUWM5UHpEcDRVQUh6NTIv?=
 =?utf-8?B?bTRSYkZEeHJSZjZYTFg4c3J6Qld5MmlPMVJ5T0tXa3NEL0R4ZkRGTlhpWUxy?=
 =?utf-8?B?dlNmVExqM2tyWUhleTZoN0MrNTZ0bkY0aExWZGM1S0tBcEwvNkdxUGtJbWty?=
 =?utf-8?B?NDE4OW05QmFBRGlZSTV3N2FZdFlSemwrb3FJYnllSWVFWUNML0RpcVB2RU16?=
 =?utf-8?B?V1JQQVdoRkRpWUlCN3FDeXgzb1ZKdnZxeCthdnVIdHBYSmcwaWVWQjd2cHZS?=
 =?utf-8?B?ZVNDd2pXRzlIcmV6cS8vMVM5VkpzQWxGN1U0Q3EySzhzSkFId0VoOUFLWERu?=
 =?utf-8?B?VzhjYlZsREVLY3laTUl4aCt0b3VEVldQUWNWM2E3TldnOTh3cmY1UVNvV1VM?=
 =?utf-8?B?OS9nWVlRS1pOc1lFQ3dJTFBqTUNjeHRCbWlUdFJBZ0puSkkrd1VwQ3I3V2JW?=
 =?utf-8?B?MXgzbzNnN09uamJUYVQ1NFJzNm1EWmRSMW1UOUhLMk50eUdlNyt4MjNIVzRY?=
 =?utf-8?B?TWROVHE4N0VMZ3NrL3NQak9vUHhPNGl6L2lVSER5VDFHTzZRTzM2WW51eUV2?=
 =?utf-8?B?azZFQnZCWk1NK3FCTGNIRHdEMFBiOHExM2krdDN3blVBeUNBT2x2cERiR0RS?=
 =?utf-8?B?U3VENnRLcXBha3I0TWtKaVNuU0JvT1RtK0tJSXJyb2QwdklKS2JzZkIzOXZQ?=
 =?utf-8?B?dEsrOXVBOFBaODFGajRKWGx3WkcxZzA3YTJ5c0ZLYzl2aTVnbUJJWmtKem9a?=
 =?utf-8?B?ZndQRlNzczBoVFJSeTBoenVqZFBHY1ZxVmRzdWJseHJDdlJlbmYxZGxKSXpM?=
 =?utf-8?B?Smk3VVFHN2tIQlN1OUM4eHowMmV6Vk4zSlhLb0VIMkVzZG1ZR0dMQjg4WWdo?=
 =?utf-8?B?b0g5VXBwS2FKTW9VUlJ6U0x2OUZmd3F3eS9ERVhIcGliaWw2Uk5HUit6cHlL?=
 =?utf-8?Q?br/yDptm9OaXSf2fKZjv10yil?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE6B576EC42E0F4582B104BBAC1C64EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3527e3-f238-4ca5-7730-08db364b5bbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 03:02:29.2489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ahlD1gfS7jqSydMFsJwhvm0SP3xc8PxiAxBiWkAi57pKv0qQKU4OmvDJJi4671Ve2eo6YmaaPBXgwcUXmED9KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8129
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTA1IGF0IDE4OjQ0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAwNSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjMtMDQtMDQgYXQgMTc6NTkgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBFeHBsaWNpdGx5IGNoZWNrIHRoZSB2Q1BVJ3Mgc3VwcG9ydGVkIFhDUjAgd2hlbiBk
ZXRlcm1pbmluZyB3aGV0aGVyIG9yIG5vdA0KPiA+ID4gdGhlIFhGUk0gZm9yIEVDUkVBVEUgaXMg
dmFsaWQuICBDaGVja2luZyBDUFVJRCB3b3JrcyBiZWNhdXNlIEtWTSB1cGRhdGVzDQo+ID4gPiBn
dWVzdCBDUFVJRC4weDEyLjEgdG8gcmVzdHJpY3QgdGhlIGxlYWYgdG8gYSBzdWJzZXQgb2YgdGhl
IGd1ZXN0J3MgYWxsb3dlZA0KPiA+ID4gWENSMCwgYnV0IHRoYXQgaXMgcmF0aGVyIHN1YnRsZSBh
bmQgS1ZNIHNob3VsZCBub3QgbW9kaWZ5IGd1ZXN0IENQVUlEDQo+ID4gPiBleGNlcHQgZm9yIG1v
ZGVsaW5nIHRydWUgcnVudGltZSBiZWhhdmlvciAoYWxsb3dlZCBYRlJNIGlzIG1vc3QgZGVmaW5p
dGVseQ0KPiA+ID4gbm90ICJydW50aW1lIiBiZWhhdmlvcikuDQo+ID4gPiANCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4g
LS0tDQo+ID4gPiAgYXJjaC94ODYva3ZtL3ZteC9zZ3guYyB8IDMgKystDQo+ID4gPiAgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC9zZ3guYyBiL2FyY2gveDg2L2t2bS92bXgvc2d4
LmMNCj4gPiA+IGluZGV4IGFhNTNjOTgwMzRiZi4uMzYyYTMxYjE5YjBlIDEwMDY0NA0KPiA+ID4g
LS0tIGEvYXJjaC94ODYva3ZtL3ZteC9zZ3guYw0KPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC9zZ3guYw0KPiA+ID4gQEAgLTE3NSw3ICsxNzUsOCBAQCBzdGF0aWMgaW50IF9faGFuZGxlX2Vu
Y2xzX2VjcmVhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ID4gIAkgICAgKHUzMilhdHRy
aWJ1dGVzICYgfnNneF8xMl8xLT5lYXggfHwNCj4gPiA+ICAJICAgICh1MzIpKGF0dHJpYnV0ZXMg
Pj4gMzIpICYgfnNneF8xMl8xLT5lYnggfHwNCj4gPiA+ICAJICAgICh1MzIpeGZybSAmIH5zZ3hf
MTJfMS0+ZWN4IHx8DQo+ID4gPiAtCSAgICAodTMyKSh4ZnJtID4+IDMyKSAmIH5zZ3hfMTJfMS0+
ZWR4KSB7DQo+ID4gPiArCSAgICAodTMyKSh4ZnJtID4+IDMyKSAmIH5zZ3hfMTJfMS0+ZWR4IHx8
DQo+ID4gPiArCSAgICB4ZnJtICYgfnZjcHUtPmFyY2guZ3Vlc3Rfc3VwcG9ydGVkX3hjcjApIHsN
Cj4gPiANCj4gPiBQZXJoYXBzIHRoaXMgY2hhbmdlIGlzIG5lZWRlZCBldmVuIHdpdGhvdXQgcGF0
Y2ggMj8NCj4gPiANCj4gPiBUaGlzIGlzIGJlY2F1c2Ugd2hlbiBDUFVJRCAweEQgZG9lc24ndCBl
eGlzdCwgZ3Vlc3Rfc3VwcG9ydGVkX3hjcjAgaXMgMC4gIEJ1dA0KPiA+IHdoZW4gQ1BVSUQgMHhE
IGRvZXNuJ3QgZXhpc3QsIElJVUMgY3VycmVudGx5IEtWTSBkb2Vzbid0IGNsZWFyIFNHWCBpbiBD
UFVJRCwgYW5kDQo+ID4gc2d4XzEyXzEtPmVjeCBpcyBhbHdheXMgc2V0IHRvIDB4My4NCj4gDQo+
IEhybSwgdGhhdCdzIGEgYnVnIGluIHRoaXMgcGF0Y2guICBEcmF0LiAgTW9yZSBiZWxvdy4NCj4g
DQo+ID4gX19oYW5kbGVfZW5jbHNfZXJlYXRlKCkgZG9lc24ndCBjaGVjayBDUFVJRCAweEQgZWl0
aGVyLCBzbyB3L28gYWJvdmUgZXhwbGljaXQNCj4gPiBjaGVjayB4ZnJtIGFnYWluc3QgZ3Vlc3Rf
c3VwcG9ydGVkX3hjcjAsIGl0IHNlZW1zIGd1ZXN0IGNhbiBzdWNjZXNzZnVsbHkgcnVuDQo+ID4g
RUNSRUFURSB3aGVuIGl0IGRvZXNuJ3QgaGF2ZSBDUFVJRCAweEQ/DQo+IA0KPiBFQ1JFQVRFIGRv
ZXNuJ3QgaGF2ZSBhIHN0cmljdCBkZXBlbmRlbmN5IG9uIENQVUlEIDB4RCBvciBYU0FWRS4gIFRo
aXMgZXhhY3Qgc2NlbmFyaW8NCj4gaXMgY2FsbGVkIG91dCBpbiB0aGUgU0RNOg0KPiANCj4gICBM
ZWdhbCB2YWx1ZXMgZm9yIFNFQ1MuQVRUUklCVVRFUy5YRlJNIGNvbmZvcm0gdG8gdGhlc2UgcmVx
dWlyZW1lbnRzOg0KPiAgICAgKiBYRlJNWzE6MF0gbXVzdCBiZSBzZXQgdG8gMHgzLg0KPiAgICAg
KiBJZiB0aGUgcHJvY2Vzc29yIGRvZXMgc3VwcG9ydCBYU0FWRSwgWEZSTSBtdXN0IGNvbnRhaW4g
YSB2YWx1ZSB0aGF0IHdvdWxkDQo+ICAgICAgIGJlIGxlZ2FsIGlmIGxvYWRlZCBpbnRvIFhDUjAu
DQo+ICAgICAqIElmIHRoZSBwcm9jZXNzb3IgZG9lcyBub3Qgc3VwcG9ydCBYU0FWRSwgb3IgaWYg
dGhlIHN5c3RlbSBzb2Z0d2FyZSBoYXMgbm90DQo+ICAgICAgIGVuYWJsZWQgWFNBVkUsIHRoZW4g
WEZSTVs2MzoyXSBtdXN0IGJlIHplcm8uDQo+IA0KPiBTbyB0aGUgYWJvdmUgbmVlZHMgdG8gYmUg
ZWl0aGVyDQo+IA0KPiAJeGZybSAmIH4odmNwdS0+YXJjaC5ndWVzdF9zdXBwb3J0ZWRfeGNyMCB8
IFhGRUFUVVJFX01BU0tfRlBTU0UpDQo+IA0KPiBvcg0KPiANCj4gCSh4ZnJtICYgflhGRUFUVVJF
X01BU0tfRlBTU0UgJiB+dmNwdS0+YXJjaC5ndWVzdF9zdXBwb3J0ZWRfeGNyMCkNCj4gDQo+IA0K
PiBJIHRoaW5rIEkgcHJlZmVyIHRoZSBmaXJzdCBvbmUgYXMgSSBmaW5kIGl0IHNsaWdodGx5IG1v
cmUgb2J2aW91cyB0aGF0IEZQK1NTRSBhcmUNCj4gYWxsb3dlZCBpbiBhZGRpdGlvbiB0byB0aGUg
WENSMCBiaXRzLg0KDQpUaGUgYWJvdmUgY2hlY2sgZG9lc24ndCB2ZXJpZnkgeGZybSBpcyBhIHN1
cGVyIHNldCBvZiAweDMuICBJIHRoaW5rIHdlIHZlcmlmeQ0KdGhhdCBwZXIgU0RNOg0KDQozOS43
LjMgUHJvY2Vzc29yIEV4dGVuZGVkIFN0YXRlcyBhbmQgRU5DTFNbRUNSRUFURV0NCg0KVGhlIEVD
UkVBVEUgbGVhZiBmdW5jdGlvbiBvZiB0aGUgRU5DTFMgaW5zdHJ1Y3Rpb24gZW5mb3JjZXMgYSBu
dW1iZXIgb2YNCmNvbnNpc3RlbmN5IGNoZWNrcyBkZXNjcmliZWQgZWFybGllci4gVGhlIGV4ZWN1
dGlvbiBvZiBFTkNMU1tFQ1JFQVRFXSBsZWFmDQpmdW5jdGlvbiByZXN1bHRzIGluIGEgI0dQKDAp
IGluIGFueSBvZiB0aGUgZm9sbG93aW5nIGNhc2VzOg0KICDigKIgU0VDUy5BVFRSSUJVVEVTLlhG
Uk1bMTowXSBpcyBub3QgMy4NCiAg4oCiIFRoZSBwcm9jZXNzb3IgZG9lcyBub3Qgc3VwcG9ydCBY
U0FWRSBhbmQgYW55IG9mIHRoZSBmb2xsb3dpbmcgaXMgdHJ1ZToNCgnigJQgU0VDUy5BVFRSSUJV
VEVTLlhGUk1bNjM6Ml0gaXMgbm90IDAuDQoJ4oCUIFNFQ1MuU1NBRlJBTUVTSVpFIGlzIDAuDQog
IOKAoiBUaGUgcHJvY2Vzc29yIHN1cHBvcnRzIFhTQVZFIGFuZCBhbnkgb2YgdGhlIGZvbGxvd2lu
ZyBpcyB0cnVlOg0KCeKAlCBYU0VUQlYgd291bGQgZmF1bHQgb24gYW4gYXR0ZW1wdCB0byBsb2Fk
IFhGUk0gaW50byBYQ1IwLg0KCeKAlCBYRlJNWzYzXT0xLg0KCeKAlCBUaGUgU1NBRlJBTUUgaXMg
dG9vIHNtYWxsIHRvIGhvbGQgcmVxdWlyZWQsIGVuYWJsZWQgc3RhdGVzIC4uLg0KDQoNCkFuZCBp
biB0aGUgRUNSRUFURSBwc2V1ZG8gY29kZSwgdGhlIHJlbGV2YW50IHBhcnRzIHNlZW0gdG8gYmU6
DQoNCgkoKiBDaGVjayBsb3dlciAyIGJpdHMgb2YgWEZSTSBhcmUgc2V0ICopDQoJSUYgKCAoIERT
OlRNUF9TRUNTLkFUVFJJQlVURVMuWEZSTSBCaXR3aXNlQU5EIDAzSCkg4omgIDAzSCkNCgkJVEhF
TiAjR1AoMCk7IEZJOw0KDQoJSUYgKFhGUk0gaXMgaWxsZWdhbCkNCgkJVEhFTiAjR1AoMCk7IEZJ
Ow0KDQpUaGUgZmlyc3QgcGFydCBpcyBjbGVhciwgYnV0IHRoZSBzZWNvbmQgcGFydCBpcyB2YWd1
ZS4gDQoNCkkgYW0gbm90IHN1cmUgaW4gaGFyZHdhcmUgYmVoYXZpb3VyLCB3aGV0aGVyIFhDUjAg
aXMgYWN0dWFsbHkgY2hlY2tlZCBpbg0KRUNSRUFURS4gIEl0J3MgbW9yZSBsaWtlbHkgWENSTyBp
cyBhY3R1YWxseSBjaGVja2VkIGluIEVFTlRFUi4gwqANCg0KQnV0IEkgdGhpbmsgaXQncyBqdXN0
IGZpbmUgdG8gYWxzbyBjaGVjayBhZ2FpbnN0IFhDUjAgaGVyZS4NCg==
