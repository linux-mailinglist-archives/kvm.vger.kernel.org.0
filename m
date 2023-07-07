Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB674B44D
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 17:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjGGP2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 11:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjGGP2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 11:28:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CD326BA;
        Fri,  7 Jul 2023 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688743711; x=1720279711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ICy53bHJFfjrr/S32qJfePaTFJjfOO+00MGjKrt9teI=;
  b=ggFZuDeu05jyvAixIGCFkOS7XYNE5GWcwvaBvVweho96T1grypxyakhX
   yHkyJQjB8vAsOoBppubVz6vABrzoLHKzECvkzZ97LenlUei7+PgI8/jEx
   NYgRUXl6Urcvsijoj7L2NzLqhScovtef+PdQtKcpZ632UxyGJYlbZ6kvf
   IGSWySIPryeFw67A31E2X6s7YC5/MS7vAvFORnqzCMv5u5ldgRAVGCsRL
   yESMTxxtiwwsuWqobDLzo7B2EOCpQZ4A4OEY3kZ8Q+1ZVi/QxIkolz2ge
   QkUAPw9yZOY0qszNgnEXoiISqhMd0cUa5qS1PIfayM/52wFtZ+fPeEiOh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10764"; a="362779331"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="362779331"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2023 08:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10764"; a="864591811"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="864591811"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jul 2023 08:28:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 7 Jul 2023 08:28:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 7 Jul 2023 08:28:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 7 Jul 2023 08:28:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVP1CxW2O5Sop1vmIBzZCGfQGtbjuE3kg3Ogx+/MYHfW7NmskNtACttVgwmL2ZeTxQ0n230Ou72CgX//sDRK0m+Ead6lufXqhMIGZlZlJ5mEXbvwOTgX8TNf89k6PYhMEyeonH2jiAoazHlOJASMx1vRzKfBMe3Rb7baREB806DDS7tlHLRfeVuGt5sNUep3oaMAff7zk3WQyOEgf3oDug7nNKltTlDk7MU5FBkFvwzaTNvghH3JKYRElUNW6+7gnMVHYFXyxQ4m43csit2SRXf0h3tmJ7HkLvVnt43nXzxpQFDMfIeUQGkeSsJFk1qYdxRin4490OtlGB5klBJGXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICy53bHJFfjrr/S32qJfePaTFJjfOO+00MGjKrt9teI=;
 b=JhBgdQ1ppqYj4g3KAo656a66uxVi3vG3zcdVNXsldVR3pei67Db7J6mYOlWsMa3iu3fPhcjJQrI0RYmQSA7gOVyZpxol2wP4LJtU3KX1DXyR7ANUn5cWnzNUly6JlQkYZqFRANM95irMKWwb9fOgcJeCdHHE1hV1OVMeAsRfyEXyNA4DpLIlDWWXEVy07ukqtWYfmu+F62uJiDK3TAlgNjq3KY1zspBLnWbsPZ4/JYuiwj8Ws0BaNJNXssYMb6f2Vbort9yFwKPjhvjL34isfgCsXwDA/xxGtaT3VwQ3AQGPZb3MGlRTAQMFUr/4BK4eGKYfFD8vTeRj57tT0LmI+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.24; Fri, 7 Jul
 2023 15:28:20 +0000
Received: from CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::f52a:b1c2:3bdf:36d0]) by CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::f52a:b1c2:3bdf:36d0%3]) with mapi id 15.20.6565.025; Fri, 7 Jul 2023
 15:28:20 +0000
From:   "Neiger, Gil" <gil.neiger@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: RE: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
Thread-Topic: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
Thread-Index: AQHZsLLjyijh88Pkl0yKkuqqRi3f2a+ubavQ
Date:   Fri, 7 Jul 2023 15:28:20 +0000
Message-ID: <CO1PR11MB5107B7D19F70CC6F91DE4DBE912DA@CO1PR11MB5107.namprd11.prod.outlook.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
 <ZJYwg3Lnq3nJZgQf@google.com>
 <30b8d82b-ae2a-7022-2343-6cef9416510a@intel.com>
In-Reply-To: <30b8d82b-ae2a-7022-2343-6cef9416510a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5107:EE_|DM4PR11MB6287:EE_
x-ms-office365-filtering-correlation-id: 778c12b6-62e1-4731-dbdf-08db7efecb96
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: blmWoQACl76W5NS9illWOL2loXZluJF1RixmLdSPwZikdxCsrc6qRn1L7mJsr/urOZuE9MFQdP5PgkQL1BTf2FgP0vyvoVnweZAN2kISDZK7wS4oBRnxOxoKRBUdpFjz8M3MY/nuklhtujkgDdwguY31IifZirycrJcg956jq/yKx6H9mRS23e8DbvHBU7gtroD3c5U23HMPZDVl/1ztjGMnadx0q56TfFQQ03HvVmLZOmYLsSWEWk75ntrULs8gxJ99LHVTq07uOGDYJINCbbESaBocLzrZmsPdSeBc02Gn+1h2onGcbmAxiK22iQoMUxPn/rly7c3uAlfijEtAFsz5pkkYsA1z1NwoZ1XvbBkV4xa/a5KCrkiu8NeQo/v8zY1aBP2wpLtjtz2KLI7Xldh4j+Gxgl8byMnMvfhWb9lO9vcCgcFJ/ghmu9IFMjJn+eLPdz64D+72AaTQQjDuxtOfD1HCkZuSZHJv6/AzGIv8viUGnhPWbTTajhhY05hTeAOHE3lOlpms0Tqp0cKtY4sIlo47dA6Z2QZnKHMwCo1ZGv5hdc7ABQl4Pumc+lRELxejmSKV10s4lsJ6+qK18iWrV474Z2qYwoVz62wm+crYQIc1h/kFtUZtkqLZoBCp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199021)(5660300002)(8936002)(478600001)(52536014)(8676002)(66556008)(76116006)(66946007)(66446008)(64756008)(4326008)(316002)(66476007)(2906002)(41300700001)(54906003)(110136005)(7696005)(71200400001)(66899021)(26005)(9686003)(53546011)(186003)(122000001)(82960400001)(83380400001)(6506007)(33656002)(38100700002)(86362001)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHNZQ0dmTC9aMjRIRXBRV09VY0ZEWTBCdzZ3ZzhLMUtwMnVpSVcvckVxSDdK?=
 =?utf-8?B?dXFLRDdvMnNKd3hhY2U2SGdKaVg3SDY3eEdWY0VMKzZnZ1ZGL0w0Ti82eUNZ?=
 =?utf-8?B?ZDlMWHZVZk9DOFZJSjBsYisvaThPRXUzNEQzV1BTMWJMRWorcWxCNnFXRGFL?=
 =?utf-8?B?WG9kdEU0cmFpbTI5MWZ6aUVvN1NTREJPTlplRlFFaS85OVUrdnpBQ05tOXpH?=
 =?utf-8?B?NUNtRm4vcTg3S1dqeFdNeThVeFZNSWVIU3BoclJacWpyZTh6b2VRdWZDa0Zy?=
 =?utf-8?B?djRocnBXYVl5b05wcEpXVFhsVmQ5cnlTUkd4L3JPMG1iU2R0dHlEWkJuQk5R?=
 =?utf-8?B?QjZZQytRaGU4V2tTZTNDVXlGcE9OSUJUNFdaY1JpVXJSWnR4cENvQ1B0UlpK?=
 =?utf-8?B?RWs2R283RHlLSlBoYzRvVEJwRXJQQmI0cU8vS1ZscnZaditOcG1VRlc2azdJ?=
 =?utf-8?B?Z2hqMFNzR2JNSGk5RHAzbUFadUFJdUNBb1pTWWFYMGZ3QUFpaHFLakhaWXJq?=
 =?utf-8?B?eDZjMmNmWVJ2LzRyKzFVTHgzMWxrcWFTM0VublNkaTk3d2NQY1lFS0hkZ0M1?=
 =?utf-8?B?cHptOUFKa3FnUVgzRGZvMEM2ZEx6K3BYMFpKbDRPbVlRNlVWK1BaUUk4WU1s?=
 =?utf-8?B?RW9rRUJQK2ZTZVBtWWhHTWsrUy9Gd0VzZ2UxclBEUEFJMEp0ZW5sSDduRHhI?=
 =?utf-8?B?cTRaWHFNTjVZWkJoVWY0REVEMEdwL0VzTlJaVGdlV3JtbW1GVzZrcXEvbXYv?=
 =?utf-8?B?UWY1elpMdGpQeUs3WXVsNHB4elMvZUdGa3ZyRGVINEpZRUlLNnhEeGN1Q1lx?=
 =?utf-8?B?UmJMQ3hkdllJVmg2SUcwWXE3encvZllyQWNJU1poVURFL3dSWkllaG11RGNz?=
 =?utf-8?B?clQ3TlFEYS9PbXF0eFZGLy9yUVE0TlRsWXVRaCtlYlE5NFFKTEl2bnVhdVNW?=
 =?utf-8?B?aDhOYi9UaWtLNHlCb3dTWTY4L2RwTGhSTHB3NzBRSnhmUG5TUlcwZDE0dmJv?=
 =?utf-8?B?VUx2amhYVTdIZlJWbUp6bHJKLzh2ckpKenl0eEpTcW14S0tnU2lEMi9aYnFN?=
 =?utf-8?B?Q3Y4LzNxSVYzRDdrVjVCblJxTkxWYmY5QXpScnc2dUdmYzBtdE1Kck5LUC92?=
 =?utf-8?B?K2VGUlkvK0JNdkdROS9iTjBUZFMwN2Jpd3dteGdEeVdVWHZpVlQ4MWEyMVhl?=
 =?utf-8?B?aDhUK0Y1czFRMWVnbUUxVEY3RkhNYkRBOENVODZKdTh2SktXZnlPK3FwbmRT?=
 =?utf-8?B?NWpzVHluVWtIbm8vTTY5Q3hOQWNaTUFML3BZak1FNXNnRWUvd2RFa0QzQ0VQ?=
 =?utf-8?B?SkpLOWFxVkhXSFFDbm55R2FZYnRsSGxxUVF4blFhUDBBWlgzUGZOTy9WbGVa?=
 =?utf-8?B?eS8rN3hBRHFPNnJ0MEVRV09KdkhGcEpTanArRTZSdHQzcm5ORzVUVkVaVHYv?=
 =?utf-8?B?ZWpneDFJL1dHZXFDNFBjbHRDL1U5MktwU2xjVFBxRmRtWGs0MDBjYlhTNU5h?=
 =?utf-8?B?bEpYdnF0KzdBRnNrZThubDkvTW4vZS9rS1NqNTJsWkFrMlVqQUVnalBsQ2l5?=
 =?utf-8?B?Q2lBZnRzdFJIUENUMU0xeG1mSWJmOWxUc1dYdXk0ODN5bk5KR3FKSkRGV0dr?=
 =?utf-8?B?VkVZbitjc2pPTmRSSzFlN1NMZDV6SzBDQlBiWFJJYVA2VG16U01IU2VENEJT?=
 =?utf-8?B?dGRTR252aisvTHkwWGVyN3N6MldLcEMrZHovQitkOWpEbVUzRDNIaEJyNW5Y?=
 =?utf-8?B?aUVCeWRiTGNzdi9MODBDb21NcEpHZWlrN1JZMXd1b3FMbFZqVVZRRlIwTitH?=
 =?utf-8?B?Z3B6WnRUL2pLQlQybjVIVUtwSnpjQ01QM0U5bFBPdnMxRVpYTjNSVTRNSjdi?=
 =?utf-8?B?VGVrWVA4OFV4QXFIamVvZ0hiTVNtdk5Tck1jZ0h6emdtYko5NjBtWjRFWnZR?=
 =?utf-8?B?MUQwU3FWaHBmNG9Lc2hOam1peTlkZUg0M2JicEovclhWQUJEUjRsUHJnWXJr?=
 =?utf-8?B?N1puUCthTzZmR2lwb2lLZGVvcDJnUzRPWk55QWtFYVpxOHlnU09UaFFjV1N1?=
 =?utf-8?B?Smd1NXJTV2RFdDNJenF1b0Exalp0QU9wRUptYS91S0drOHQ5SUp3NHNyZEVo?=
 =?utf-8?Q?eq2XtekO+En0IP003xutOHPQ3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778c12b6-62e1-4731-dbdf-08db7efecb96
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2023 15:28:20.4963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dUdpu6q36O96/sY5Q7IMDOecpTUqOSSfTh6pUCjgLvonoelvDfKMXGSX7VjpILwlgR9I0XZ6xrfv7KiCQEO2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
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

VGhlcmUgaXMgYSBzbWFsbCB0eXBvIGJlbG93ICh3aGljaCBjYW1lIGZyb20gbWUgb3JpZ2luYWxs
eSk6DQoNCldoZXJlIGl0IHNheXMsICJJZiB0aGUgVk1NIHNldHMgZWl0aGVyIGJpdCAwIG9yIGJp
dCAxIHNldCwgaXQgc2hvdWxkIGluamVjdCBhICNHUCIgLSBpdCBzaG91bGQgYmUgIklmIHRoZSBW
TU0gX3NlZXNfIC4uLiIuDQoNCgktIEdpbA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogWWFuZywgV2VpamlhbmcgPHdlaWppYW5nLnlhbmdAaW50ZWwuY29tPiANClNlbnQ6IEZy
aWRheSwgSnVseSA3LCAyMDIzIDAyOjEwDQpUbzogQ2hyaXN0b3BoZXJzb24sLCBTZWFuIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCkNjOiBwYm9uemluaUByZWRoYXQuY29tOyBrdm1Admdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBwZXRlcnpAaW5mcmFkZWFkLm9yZzsg
cnBwdEBrZXJuZWwub3JnOyBiaW5iaW4ud3VAbGludXguaW50ZWwuY29tOyBFZGdlY29tYmUsIFJp
Y2sgUCA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+OyBqb2huLmFsbGVuQGFtZC5jb207IFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+OyBOZWln
ZXIsIEdpbCA8Z2lsLm5laWdlckBpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIIHYzIDEz
LzIxXSBLVk06Vk1YOiBFbXVsYXRlIHJlYWRzIGFuZCB3cml0ZXMgdG8gQ0VUIE1TUnMNCg0KDQo+
PiArCWNhc2UgTVNSX0lBMzJfUEwzX1NTUDoNCj4+ICsJCWlmICgha3ZtX2NldF9pc19tc3JfYWNj
ZXNzaWJsZSh2Y3B1LCBtc3JfaW5mbykpDQo+PiArCQkJcmV0dXJuIDE7DQo+PiArCQlpZiAoaXNf
bm9uY2Fub25pY2FsX2FkZHJlc3MoZGF0YSwgdmNwdSkpDQo+PiArCQkJcmV0dXJuIDE7DQo+PiAr
CQlpZiAobXNyX2luZGV4ID09IE1TUl9JQTMyX1VfQ0VUICYmIChkYXRhICYgR0VOTUFTSyg5LCA2
KSkpDQo+PiArCQkJcmV0dXJuIDE7DQo+PiArCQlpZiAobXNyX2luZGV4ID09IE1TUl9JQTMyX1BM
M19TU1AgJiYgKGRhdGEgJiBHRU5NQVNLKDIsIDApKSkNCj4gUGxlYXNlICNkZWZpbmUgcmVzZXJ2
ZWQgYml0cywgaWRlYWxseSB1c2luZyB0aGUgaW52ZXJzZSBvZiB0aGUgdmFsaWQgDQo+IG1hc2tz
LiAgQW5kIGZvciBTU1AsIGl0IG1pZ2h0IGJlIGJldHRlciB0byBkbyBJU19BTElHTkVEKGRhdGEs
IDgpIChvciANCj4gNCwgcGVuZGluZyBteSBxdWVzdGlvbiBhYm91dCB0aGUgU0RNJ3Mgd29yZGlu
ZykuDQo+DQo+IFNpZGUgdG9waWMsIHdoYXQgb24gZWFydGggZG9lcyB0aGUgU0RNIG1lYW4gYnkg
dGhpcz8hPw0KPg0KPiAgICBUaGUgbGluZWFyIGFkZHJlc3Mgd3JpdHRlbiBtdXN0IGJlIGFsaWdu
ZWQgdG8gOCBieXRlcyBhbmQgYml0cyAyOjAgbXVzdCBiZSAwDQo+ICAgIChoYXJkd2FyZSByZXF1
aXJlcyBiaXRzIDE6MCB0byBiZSAwKS4NCj4NCj4gSSBrbm93IEludGVsIHJldHJvYWN0aXZlbHkg
Y2hhbmdlZCB0aGUgYWxpZ25tZW50IHJlcXVpcmVtZW50cywgYnV0IHRoZSANCj4gYWJvdmUgaXMg
bm9uc2Vuc2ljYWwuICBJZiB1Y29kZSBwcmV2ZW50cyB3cml0aW5nIGJpdHMgMjowLCB3aG8gY2Fy
ZXMgDQo+IHdoYXQgaGFyZHdhcmUgcmVxdWlyZXM/DQoNCkhpLCBTZWFuLA0KDQpSZWdhcmRpbmcg
dGhlIGFsaWdubWVudCBjaGVjaywgSSBnb3QgdXBkYXRlIGZyb20gR2lsOg0KDQo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KDQpUaGUgV1JNU1IgaW5z
dHJ1Y3Rpb24gdG8gbG9hZCBJQTMyX1BMWzAtM11fU1NQIHdpbGwgI0dQIGlmIHRoZSB2YWx1ZSB0
byBiZSBsb2FkZWQgc2V0cyBlaXRoZXIgYml0IDAgb3IgYml0IDEuwqAgSXQgZG9lcyBub3QgY2hl
Y2sgYml0IDIuDQpJRFQgZXZlbnQgZGVsaXZlcnksIHdoZW4gY2hhbmdpbmcgdG8gcmluZ3MgMC0y
IHdpbGwgbG9hZCBTU1AgZnJvbSB0aGUgTVNSIGNvcnJlc3BvbmRpbmcgdG8gdGhlIG5ldyByaW5n
LsKgIFRoZXNlIHRyYW5zaXRpb25zIGNoZWNrIHRoYXQgYml0cw0KMjowIG9mIHRoZSBuZXcgdmFs
dWUgYXJlIGFsbCB6ZXJvIGFuZCB3aWxsIGdlbmVyYXRlIGEgbmVzdGVkIGZhdWx0IGlmIGFueSBv
ZiB0aG9zZSBiaXRzIGFyZSBzZXQuwqAgKEZhciBDQUxMIHVzaW5nIGEgY2FsbCBnYXRlIGFsc28g
Y2hlY2tzIHRoaXMgaWYgY2hhbmdpbmcgQ1BMLikNCg0KRm9yIGEgVk1NIHRoYXQgaXMgZW11bGF0
aW5nIGEgV1JNU1IgYnkgYSBndWVzdCBPUyAoYmVjYXVzZSBpdCB3YXMgaW50ZXJjZXB0aW5nIHdy
aXRlcyB0byB0aGF0IE1TUiksIGl0IHN1ZmZpY2VzIHRvIHBlcmZvcm0gdGhlIHNhbWUgY2hlY2tz
IGFzIHRoZSBDUFUgd291bGQgKGkuZS4sIG9ubHkgYml0cyAxOjApOg0K4oCiwqDCoMKgIElmIHRo
ZSBWTU0gc2VlcyBiaXRzIDE6MCBjbGVhciwgaXQgY2FuIHBlcmZvcm0gdGhlIHdyaXRlIG9uIHRo
ZSBwYXJ0IG9mIHRoZSBndWVzdCBPUy7CoCBJZiB0aGUgZ3Vlc3QgT1MgbGF0ZXIgZW5jb3VudGVy
cyBhICNHUCBkdXJpbmcgSURUIGV2ZW50IGRlbGl2ZXJ5IChiZWNhdXNlIGJpdCAyIGlzIHNldCks
IGl0IGlzIGl0cyBvd24gZmF1bHQuDQrigKLCoMKgwqAgSWYgdGhlIFZNTSBzZXRzIGVpdGhlciBi
aXQgMCBvciBiaXQgMSBzZXQsIGl0IHNob3VsZCBpbmplY3QgYSAjR1AgaW50byB0aGUgZ3Vlc3Qs
IGFzIHRoYXQgaXMgd2hhdCB0aGUgQ1BVIHdvdWxkIGRvIGluIHRoaXMgY2FzZS4NCg0KRm9yIGFu
IE9TIHRoYXQgaXMgd3JpdGluZyB0byB0aGUgTVNScyB0byBzZXQgdXAgc2hhZG93IHN0YWNrcywg
aXQgc2hvdWxkIFdSTVNSIHRoZSBiYXNlIGFkZHJlc3NlcyBvZiB0aG9zZSBzdGFja3MuwqAgQmVj
YXVzZSBvZiB0aGUgdG9rZW4tYmFzZWQgYXJjaGl0ZWN0dXJlIHVzZWQgZm9yIHN1cGVydmlzb3Ig
c2hhZG93IHN0YWNrcyAoZm9yIHJpbmdzIDAtMiksIHRoZSBiYXNlIGFkZHJlc3NlcyBvZiB0aG9z
ZSBzdGFja3Mgc2hvdWxkIGJlIDgtYnl0ZSBhbGlnbmVkIChjbGVhcmluZyBiaXRzIDI6MCkuIFRo
dXMsIHRoZSB2YWx1ZXMgdGhhdCBhbiBPUyB3cml0ZXMgdG8gdGhlIGNvcnJlc3BvbmRpbmcgTVNS
cyBzaG91bGQgY2xlYXIgYml0cyAyOjAuDQoNCihPZiBjb3Vyc2UsIG1vc3QgT1PigJlzIHdpbGwg
dXNlIG9ubHkgdGhlIE1TUiBmb3IgcmluZyAwLCBhcyBtb3N0IE9T4oCZcyBkbyBub3QgdXNlIHJp
bmdzIDEgYW5kIDIuKQ0KDQpJbiBjb250cmFzdCwgdGhlIElBMzJfUEwzX1NTUCBNU1IgaG9sZHMg
dGhlIGN1cnJlbnQgU1NQIGZvciB1c2VyIHNvZnR3YXJlLsKgIFdoZW4gYSB1c2VyIHRocmVhZCBp
cyBjcmVhdGVkLCBJIHN1cHBvc2UgaXQgbWF5IHJlZmVyZW5jZSB0aGUgYmFzZSBvZiB0aGUgdXNl
ciBzaGFkb3cgc3RhY2suwqAgRm9yIGEgMzItYml0IGFwcCwgdGhhdCBuZWVkcyB0byBiZSA0LWJ5
dGUgYWxpZ25lZCAoYml0cyAxOjAgY2xlYXIpOyBmb3IgYSA2NC1iaXQgYXBwLCBpdCBtYXkgYmUg
bmVjZXNzYXJ5IGZvciBpdCB0byBiZSA4LWJ5dGUgYWxpZ25lZCAoYml0cyAyOjApIGNsZWFyLg0K
DQpPbmNlIHRoZSB1c2VyIHRocmVhZCBpcyBleGVjdXRpbmcsIHRoZSBDUFUgd2lsbCBsb2FkIElB
MzJfUEwzX1NTUCB3aXRoIHRoZSB1c2Vy4oCZcyB2YWx1ZSBvZiBTU1Agb24gZXZlcnkgZXhjZXB0
aW9uIGFuZCBpbnRlcnJ1cHQgdG8gcmluZyAwLsKgIFRoZSB2YWx1ZSBhdCB0aGF0IHRpbWUgbWF5
IGJlIDQtYnl0ZSBvciA4LWJ5dGUgYWxpZ25lZCwgZGVwZW5kaW5nIG9uIGhvdyB0aGUgdXNlciB0
aHJlYWQgaXMgdXNpbmcgdGhlIHNoYWRvdyBzdGFjay7CoCBPbiBjb250ZXh0IHN3aXRjaGVzLCB0
aGUgT1Mgc2hvdWxkIFdSTVNSIHdoYXRldmVyIHZhbHVlIHdhcyBzYXZlZCAoYnkgUkRNU1IpIHRo
ZSBsYXN0IHRpbWUgdGhlcmUgd2FzIGEgY29udGV4dCBzd2l0Y2ggYXdheSBmcm9tIHRoZSBpbmNv
bWluZyB0aHJlYWQuwqAgVGhlIE9TIHNob3VsZCBub3QgbmVlZCB0byBpbnNwZWN0IG9yIGNoYW5n
ZSB0aGlzIHZhbHVlLg0KDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCg0KQmFzZWQgb24gaGlzIGZlZWRiYWNrLCBJIHRoaW5rIFZNTSBuZWVkcyB0
byBjaGVjayBiaXRzIDE6MCB3aGVuIHdyaXRlIHRoZSBTU1AgTVNScy4gSXMgaXQ/DQoNCg==
