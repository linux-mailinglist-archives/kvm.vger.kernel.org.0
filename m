Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0776620F22
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 12:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiKHLdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 06:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbiKHLdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 06:33:23 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56965262E;
        Tue,  8 Nov 2022 03:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667907202; x=1699443202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S8g2cgxm0XkvKABDo9lBb54Wb/JIUYvkql9q46/tkiE=;
  b=DinQRuIX5mdAgFcdPdteAl2/3eQw7O1ItVjTHrMTUpLqYXvRuxkP5Y+U
   wgLi6oF8s5g57h4zm69IH06zWoZfWqatxcSJXnQQvqpC7gDxq9DGfaxcm
   a/XVtbdwvJzzZrrUVf0UvQhEb1DOzyVAOLAaRl66lOSJXNTan/2hRYLQY
   W4zdlOjSPFvP2sC9V2pcD9k7rNYN2JGznjB6zGeJlvZkKWqyQVnFHJCnE
   btYPYxHmfFOxliAhL9T+xBlzwhuz+sFq5OpgMRclmw5MfqYtVTjrovXcL
   5GJwstjhkisYxRDoqbshv8hOw0qNBKRWF4f6eeekrFdDNy8ku6k8vmcuN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311827203"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="311827203"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 03:33:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="778894233"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="778894233"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 08 Nov 2022 03:33:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 03:33:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 03:33:20 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 03:33:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gj5JtWtH+4YQh9rLGHA0AAjviqmI8v4kheYDxt5IizKsSRZq20zqNqXdaOFoAOsbFvg2HFbUfO9pWpMbwaM7NcduiP6oWAvn3p33nxOzR8a1Bq6KF2SEeLUhAmLeOKJ8aTz4UX6A0Du3TLHgEhUed0bs3gGXOAJ3MfDzT3lOYMoKrxs3fAVtix4z3D/44brrtTNE01vNyO4qjblGfDFtroGDbgOqN7U3U9fss52ombOaVrXy+hDRNYe609UROGW/7cWXGFUcvRZRIy6GMYIBmkcNAQwIt2mSFG6H2FF6pDIIZPWSiCBGIOgnweXiTV5DR1mReJERTtqpImjpjr+rnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8g2cgxm0XkvKABDo9lBb54Wb/JIUYvkql9q46/tkiE=;
 b=D90BdrgEPEcUiaXV5YYZJ9RYi1ACelW8c3/WFEHRcm1p5TGIMfZ6Lmr8NrGf25W8X6yp+BtieVQVK0jcf08yNa+V9Oq15mCMsmfSMQIqgcEgVfxOohISp61+RHuMMhjN8+vdZUqAUBN2ggVoZNvJzoYlMTvgsex0FP+HxtJ19GwOhjyJG+EMcACKYJDcJwW0xsCfu7f64wWHr75iuXcZ30zMFD/uOqHYWoeSKCGxGR+ZXI+CFoLllYZNwEhCQDe561efzrY0lXQaBpDrnAJQ0ccauCUU9yEsLXr+agqHAMOV6+6ce/q8J3RBOnhcHI1DGfn7H0XCRz58djWUmn1XSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 11:33:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 11:33:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 031/108] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Thread-Topic: [PATCH v10 031/108] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Thread-Index: AQHY7ChqFm18Dc57R0q52gblRqNeNK4083KA
Date:   Tue, 8 Nov 2022 11:33:12 +0000
Message-ID: <eab804a34b96dfdd74a816b92039fca9a81475f0.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <0de1d5dfbce49b5e9d4f93289296b726180b8dd0.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <0de1d5dfbce49b5e9d4f93289296b726180b8dd0.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4606:EE_
x-ms-office365-filtering-correlation-id: d896db59-969c-4208-fbc7-08dac17d053e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9qnoOm+ZTbumIbMDiP4xKR3V/HTEoDX5Dv6Z4qtCltJzu+kkLhh02NR++9QS0OmHy9b7y+F/Gifb98Zir5Yplh9lz5IdU7PRZh+UTFBL45BtV3GNR9z+BKHUlImz3attpbXjPF5VsvmF13FwrChExs8OaD8W3gjUsvO+Y4N1rJIHBjYrKEyL2gzzskEWXwslrbKt9VySejolqeRzFqrsg5WCUOpnsrALq9F9YFs1QixO8TXmAQx7zcoo8oxuKwv1Ko42nk8s+5wkjMGAexLJVeUQCXoqlhTN0GZQ+vlfnTvFCaUTXwWIhB/xaEkzgKCgUv/KgFKoDA6wGvyQFJzpCqfecJb3LC1WpGEDvfapuR6+T1lbOTRxm0DJEL3sQfMOzh0ydQgyCT1oTNRkI0TPI0Vn8zlMABk3iVtSDLOHb5qgNIf52rn87BDsmS4UqwIeXSxVC0YT4ec4vbhlv6PA/NlSwQ9v8mwyWVQlTnULQXzwEgsG0zg6JBDJFdJiWV5PcQ4cfWElrM0w13WL266yCR47/5SuBi/aF4xhtnKi54zw/zYicbYdye/U5OufStUZBEh/bp0hzhP5SqzFPIIJrlk7CwfKIcW5eyHG7B920vrKFi7SHiC31utwDU3Nm2LvVtx5m2uT4qgvTBqDE8Gy1+9x/sh4DZ/weUNfcHSNyaazQLJlV7xPKSBcFelGwtBfkvW2yDHQSmxKm7KZB5wuO4mcvq+zfUqfoZEgl5AEqyjaZCo1+ljQ6Y3ScxMioE28RWoZFP8Lk3BUr3029ga3BZugZtG27ZgROydflaMjtDU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199015)(478600001)(966005)(6486002)(71200400001)(38100700002)(122000001)(82960400001)(110136005)(54906003)(6636002)(86362001)(36756003)(8936002)(316002)(6506007)(91956017)(26005)(41300700001)(6512007)(66946007)(38070700005)(66556008)(8676002)(4326008)(76116006)(66476007)(4744005)(64756008)(4001150100001)(66446008)(186003)(2616005)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEcvYm9MSDZCSEVxaHVSTkgwOWY0Z0xvaldmeEJaUkxEcGd1YUtKcmllYUFV?=
 =?utf-8?B?aXBzNExDcHNrdWx4TWdBYW85Z1JmYnhwNDkrYytYS1hIemV0ZXF0TjJLRFNn?=
 =?utf-8?B?M1VjTFNzdmRteEZENzRxcERnUWRHZitVYnpadkVyc2pyS3o3VW56eGtpdVk0?=
 =?utf-8?B?UXdEd2xIOUt4dkVCZm1aY1dhN1I1ZUxUUnBRWlN5THpOSTYveDhsU1NQUmxr?=
 =?utf-8?B?ZDBYS1lMS1o5d2lwdGYxQmtvYkFraEF6NVI2OTZsZjlZejdSazdaTmFYZjNU?=
 =?utf-8?B?NjdpWUFvd1VZbG81TDJLY1l6YzRaUXUwbU1ndXFvZm5aVTlMTW1LbWVnWDJz?=
 =?utf-8?B?WmpkMkljV2xZeEJRbzg0ampGRHFtSERaRlZFN1RQaXdpeVl5VjM4NlFDSGJE?=
 =?utf-8?B?U01GNjRGTEFVL0ZhTmJvS3ZEOG5ZemdQOE1na2x1eDZuc29aSE5YSmxTYURJ?=
 =?utf-8?B?Y2Q0bzIyNUNFVXBEWnVHOHA3aGx3bnZBRmU0ZjE1ekFwZkNHUElNdDVjcVNU?=
 =?utf-8?B?dWN2WncvQ1Jtek53NXRQeVhQZVBpQVJmSE13RC9Kb0tlVmJsRHZnTkZQNkhJ?=
 =?utf-8?B?V25MYUpHZUVHT1kvT05MV3lIRDNFY1gvcXZ4QnRCN3JRdkNyMyswOHJFdkdJ?=
 =?utf-8?B?NlRwK0JtU1RyODRhamFRcm1mdGthUUowLzMrYnBjdDg3WTlJdzFvQUFvRGs1?=
 =?utf-8?B?RUIxRVp1c3lBNDBSekpyUm5OajB2VVFWK25YMkVtOG0vTUsxWTljYUlmM2Vy?=
 =?utf-8?B?MjdXMm1xaThCNzc5TG1RczlGbEVWOUdsc0RHRFFqK2pWWlU4ME1UV3lPc1g0?=
 =?utf-8?B?aVRSN0FTeitUQmlZL3NDcU9MMHN6VzB4WjZMdERZMFBnYW04TTBqL0JaSDZK?=
 =?utf-8?B?TkVzbDdDYlpkQlNyTEFUWHVGZDZOQlQ4emRZbXlSaXltT1RTQ1dIZ0IzNzhk?=
 =?utf-8?B?bDU2VHRWRXRDeWljcmVUSkUyWnlyc3RQY21EWHAwYnpCaURyR1N6RGJTenps?=
 =?utf-8?B?eFcyWTRUODFzQUlFSUdwN1RTRzlHb3B3eGlmTFRDclM2UzhLUXRZaFJ5QmJj?=
 =?utf-8?B?NGQ5Y0NuWTFtaG4rc0plM3JRcWJVZ0RPVWZPOXExbVp0OHVjWmhQWUFqcSto?=
 =?utf-8?B?c3h0akhxdThaMitSRzZnMjRWWkdna09JTGVDR1MyUm9HWCtuMVlwL1JmUGpt?=
 =?utf-8?B?QkUvejRSTjgwWTRXZGtrVWJhRjlKUmxSMkVBZTJYNVlEU1VYZ01oeGRSa3dU?=
 =?utf-8?B?NHljaWZmaS9VaFllb3dDaVFXSU5CSk45c0Z2M0Jhalk1L2JLWklEb01FRmhB?=
 =?utf-8?B?SWVncmpBQWcyQUhaYTZtcC93UDZER2dZalc5cC9reXRPT3VsVXlPYUJRU3pH?=
 =?utf-8?B?TXl0SFhzSjd5ZHlCb3FUeEpjbnZlVUloa21tejBncXBDSWNSS2RyalJPZnI0?=
 =?utf-8?B?dk42T25wTkVaNXdmK21EZDJ5S0QrbUxRcFFReXp3b214OTAxTC9KbzhNUWEz?=
 =?utf-8?B?Ykc4VndTUDdFd3Zqa0RRUnAvV0JqSFM0V0RjemwyU0xwWUR1cmkwNkV4eVhj?=
 =?utf-8?B?RVhNTUdVdSt5YXYyVFZpVjRua09aT0kzWVlsNlZ2UG5YK2tDNzh5L1pFeDFG?=
 =?utf-8?B?dEpYMnFyNkJNSENMdlRhWGtyNVNTVDFxK2lQQXFYNUpKYmJ6TisxYzFNN2hP?=
 =?utf-8?B?c0tRVzk0YXZuRWp4WjdIZndieEU2bUhzOVRuemo5UVpYQWZLNXdjU1B2YVp5?=
 =?utf-8?B?YkpxWUFNZ1NDdUFSQW1ob01WYjQyVitmK0FaRlRBb2kwMTBuVWU1ZzloVHRv?=
 =?utf-8?B?dkQ1b2RIK3VXL0JhOTNBT2pPaW1RZGNIeHZnK3I3U1VDNnNkU2RIaS9KUXpV?=
 =?utf-8?B?eFZYR2ZudGJ2VWxLOVVCNTFQWWo4NEtUcDZZSlFKSFcrTmZCS0JMSW9IQjVK?=
 =?utf-8?B?c2JvMUNIK3pBVDEzeC9oVzhpVERNNjl2TEYvSXpxRE5URk1hNGJ6ekNhUXBM?=
 =?utf-8?B?QXhHTkhEWGdOVE81RVUxOHdDRUNad1h3ekp6d3lSMHdkOGdtK3N0WmV4ZTly?=
 =?utf-8?B?dEs3U2ZybHpDQnpHbzlPcG1oK2NDQlZxZTRMcElwb1JxM1d4OFVORU9zVHBD?=
 =?utf-8?B?K2dYVCtSVDQwN1NQYUtFZG1UZk52eXk3MTdZZHN4VVE3eEJHREtWbnJJdnVZ?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0391E4CC912D5440995F9A3AB101D05E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d896db59-969c-4208-fbc7-08dac17d053e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 11:33:12.8808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MVZsY7dUFQCKJXXwhwbUZ3D883b6lxK3LTlyfa/IIekeL50ALCchibP4b1L7dWKPpXl+i/QsFqUh+Mh+hxuE2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
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

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IFRoZSBwbGFuIGlzIHRvIHVuY29uZGl0aW9uYWxseSBzZXQgdGhlICJzdXBw
cmVzcyAjVkUiIGJpdCBmb3IgYm90aCBBTUQgYW5kDQo+IEludGVsIGFzOiAxKSBBTUQgaGFyZHdh
cmUgZG9lc24ndCB1c2UgdGhpcyBiaXQ7IDIpIGZvciBjb252ZW50aW9uYWwgVk1YDQo+IGd1ZXN0
cywgS1ZNIG5ldmVyIGVuYWJsZXMgdGhlICJFUFQtdmlvbGF0aW9uICNWRSIgaW4gVk1DUyBjb250
cm9sIGFuZA0KPiAic3VwcHJlc3MgI1ZFIiBiaXQgaXMgaWdub3JlZCBieSBoYXJkd2FyZS4NCg0K
SGkgSXNha3UsDQoNCiJBTUQgaGFyZHdhcmUgZG9lc24ndCB1c2UgdGhpcyBiaXQiIGlzIHdyb25n
Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2NvdmVyLjE2NTk4NTQ3OTAuZ2l0Lmlz
YWt1LnlhbWFoYXRhQGludGVsLmNvbS9ULyNtNWVkNTk0MDRkYTQzNjc3ZTk5YWM1MWRkMTM2MGRj
MjJiOTY0YmNiYg0K
