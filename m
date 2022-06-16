Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78D054E876
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377849AbiFPRNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377712AbiFPRNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:13:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC04719C17;
        Thu, 16 Jun 2022 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655399593; x=1686935593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WLr7D+YpBUsvglhAeW6R125oRyH8EomQ6y2QLTkRZw8=;
  b=aR679F605LxdNVgkQcnAgDtlLh5PlqU9RCyVtXmnGSt8pO7OTIEvRnRF
   6vMHNkebe2Uy/DqIJzcQ5BRuLACRsTs27wOcVhb/W11jEQzxmaeJXYJZS
   PEHsIV5hSLhCOrLl60jW0llQCt2beb2isdeKlp3DJFAPTvO4ujs4YGTc1
   yHEQ2RBzZo3yqolnGufH2NH6kOyA7kMOpYyy+aZZKkw0N86izj8ELZCbD
   5nE8TQCyqQbhMa0PP9zHiiyJz56AB1PWjw5mxRqEH8x3HcrG8WoClSOoJ
   YCm34wXmpj+q895knk1MROWqquEI3oa/7PcyIskJiTDIhjfuLz+i02JQt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="365652632"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="365652632"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 10:12:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="583711827"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 16 Jun 2022 10:12:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 10:12:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 10:12:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 10:12:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eE96aT4AlpYy/QTkEcG1YxamKW3gZVzoe5KCQgNTlBRG3RhmHJRGMxnP7Mna4ZmUyQplvGdiPJcQQQkdLN4qIVn4yCn0lD7ZlHEDhXcOB8E9swJuyaxmkBH5tW0ICJJB7YqRIEIOmpDjrdjXJu7wWVfqhWUqNshMJIMwELutpIWoiom/cgpwmFm0nhdbBoAg1GK12eVKM/gqX5/6HKKIbTXk9DMohqNgWlkRJyxQQtiRWKHVk8XEOQskaXnaa3RgsYdHGSM1NOS18DJbA/6LJUmU6LFJoBS92mdnT5Eqmkoq7QlrCTK5afD+HXgMBwq2pnO1VA26Hs9v64yx5jvSEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLr7D+YpBUsvglhAeW6R125oRyH8EomQ6y2QLTkRZw8=;
 b=oMVxKt4RiOGFTltR5fgQLgj5xAvltKmu1wkDRjNMIiJ93rFQchPwpZA6q1CcNl3f4qIBuBZM+OCerNeoWwcRuywR+kR4QnwC3kwZeh9jjFT/+6e2nhzNLK9fG7UgiOV5kXy5Yr960ryOqkVPsUL4y4gNk108hvFcOkvX5EtpNSsRvUM1lI7nCmPZkFRS847dTEMIAvylblEVyfaJP5G1WGVr19+MvrinMzSmvGV7qANxab/lq0G90Zjydtv7Tt+lY7GMDtdoKpPsfhbVH+54zqoA9hk/FOK8lVvjZ5iT0vQVZ8ExZex49cE7wS/sOyQ3wdFSdMhxfzIdEZBIKcjCLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by MN0PR11MB6303.namprd11.prod.outlook.com (2603:10b6:208:3c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 17:12:47 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4%12]) with mapi id 15.20.5353.015; Thu, 16 Jun
 2022 17:12:47 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Thread-Topic: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Thread-Index: AQHYgV3BGYVuI+Dv/0Gr8tfHe/6Wwq1R07MAgAByKQA=
Date:   Thu, 16 Jun 2022 17:12:47 +0000
Message-ID: <ca4e04f2dcc33849ebb9bf128f6ff632b5ffe747.camel@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
         <20220616084643.19564-4-weijiang.yang@intel.com>
         <YqsEyoaxPFpZcolP@hirez.programming.kicks-ass.net>
In-Reply-To: <YqsEyoaxPFpZcolP@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c5bd2e0-771d-4459-4cc1-08da4fbb6f5b
x-ms-traffictypediagnostic: MN0PR11MB6303:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN0PR11MB6303C230A52FC8E3FD8A963EC9AC9@MN0PR11MB6303.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LAHv7G4W6kmvzmslEwCBlnQcM84ARFyVKrY4jRF2piNcQ1zw+ecGCwrtP1KJKsb+a1Xk8rUAQRpZaIhn59lULKncsWjjUjlz7vgT9bPqv81vObVjTQ9Tz2MeTtb10cGOICGUtxwlfx6jAxy3mgczk3SJbZebKeBH2mS/uN+d6/fx0pU0dwY3YoOFUEMniHGH2yXrOjlSjgaKpCet2YKjxd70Ank/wp1LRdtW1nquBrCEvIolnf9yVR47fNgm2hE+qCYiVHhh08KABsHsclRnIozYTLi8drxK4o0aZ++jr6arOXtQpI+nMDqiSCNvXsluJxgqMkvi8dfyBvShHjpqSWhmWVPW3goytJXopMLoqZZV2bBWv8Osq6Vy3I4LmzhU9nD/eeYrjcTjlcRvGgiVZouSmBT03uZTKCG34zktkdcdpkDidoDILgzhGw52F+At8d6kBBWb9hM0iQZkjd6kpD5pgES3OBJTot9hhC17NC77GTgzIZqSvBEweDM2WSBHScAZRYfsHBW9U30vSLF/JJBT0BZe3m0s2KWn+5xNs5/4WhZSD1lCw0932IULXRnlY6jHqAVgagujIdbbbWXzl2SRC90Pw1HlkOx2OTSI27E/PcDE/NZUYXHE4Y+JtdgUVKuhlN6jdcDL4ta98GWr20JTJ5TfYiyippz3KbsNkAqhLmxofnUZUdimYCDF37VcNAXgmaAF0QXbIjFJtujP24lg6JSIorAHvmmcFUFIfDY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(71200400001)(6506007)(2906002)(38070700005)(2616005)(508600001)(6512007)(5660300002)(26005)(186003)(316002)(38100700002)(110136005)(86362001)(8936002)(6486002)(36756003)(54906003)(6636002)(82960400001)(8676002)(4326008)(83380400001)(122000001)(64756008)(66946007)(76116006)(66476007)(66556008)(66446008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzhNcERiemtyZXljT3ZzTnJQZTlqdDFVamNoWDc2ZlZxRDNVZUZsQktRMXN0?=
 =?utf-8?B?VGRUNThtSlBIRE1CZHFkNVAxMkpScHMyZmh0TVk5NksxUWJXaWk1bFJud3FJ?=
 =?utf-8?B?TGRzUElFM3FoUlpCWlYxOWQ1dlZFNjJJdU5aYzNWSXFCdHhIWDNYMDBPQ3ZV?=
 =?utf-8?B?aG45NGhlSytWZFhETWU2aVJnNEp4L0lBK3Jxa3RESmtYK1AyMklCNVpsWFhP?=
 =?utf-8?B?SEZHMjhRUVl3M0dvdW1NVjZkV2hIczZSQXFkR2FwbWowSURzN3M1ZkVJcEYr?=
 =?utf-8?B?dlFjbGJ3NWtRTEcyNldMRSt0WDJpc3lrZmhzczZ5VmQ0ZU00d2xDcHBoc1M3?=
 =?utf-8?B?dTd2ZnNrb2hmcGdweThDYWVZNVlNVHZuSkJoZllUVk9DcFVhaE1TOWlMNlFZ?=
 =?utf-8?B?UXRMV1RwODFEWTFtZDcxcmREREdHTWhnT3hKdTc3anRNUk9Da25jK3RFSTRk?=
 =?utf-8?B?UlQ5N0EvMTcyZEdzY21GMisvSVA3MEJ3TWkyOUlNOXFQSWFTaVJ4VnB6R1di?=
 =?utf-8?B?WU9wSnVuUVBVaUhCNWZneHpzTVdBUkpkczVpczY2clBXU3dlY09yajFhTFJv?=
 =?utf-8?B?UU1OV1FTaERCR3ZqWVhxRlJkalQ2bER1dDJLS3FYM2Fyd3JKYjNIMmg1NjhC?=
 =?utf-8?B?U1BIbGxhb0xWUFA5bEdqWHZYckx5K0V0cTZoRlhmRTFuWExVY1ptQytETU1C?=
 =?utf-8?B?VjJYdi9sbGlRZkZNR045YjNqSHBia3VMbFZQTjBvWmVQZkdjbG5reDRwWWRN?=
 =?utf-8?B?Ui9ZNUVXTldPRVZPVTBROTVxbmxZK2tiZ3B1dENJa0ZOeEVtaitZRGEyM0Uy?=
 =?utf-8?B?aFpNZ0VNQklZSGxDclpiOEhKMHlRQk8zVWg5dWZOV1VrWWNLZ3JQNEVqOXBH?=
 =?utf-8?B?S2xzMDJsd1k4ZVZLeHNLR29TVUtUQUorRlpLbUwwL0ZEbnBKV0VkL0M3Z1pz?=
 =?utf-8?B?NUpGZFkrajNORmlFUnFHS0hGYnR2N2tuN0tkc3lOQThLLzI5Snk4eE1ITTZz?=
 =?utf-8?B?Q0NDR2JRb3hNMVRVRHNPdUhvUWN3cG9JaW54RmdWY3U1b0szeW41dENia245?=
 =?utf-8?B?TkdWTTUrS1cyYmxXdVpLOSt0QmxJOHcvK0tsRjVLT2grWWRxYUtOTi9McWJj?=
 =?utf-8?B?WjBsWDlnYzNuTXczZ3dyRzlTWVlsZTBhRUpSM0pMR2l3QWtEZkdJK2FLZHE1?=
 =?utf-8?B?Z3pZRDIybTVDRlNiYjRsbUpVMzZNUFNhVitWVjJ6aStpQmt2Vjk3YUVqM212?=
 =?utf-8?B?L2lKSk9GbUZhTER6YTBqYllOc3dnTUI2VGwrYlZiQWVTZUU5bjdJMUVvRXpO?=
 =?utf-8?B?d0hWVHBnZS9VY2tOdmFkakgwV1ZCUitmYWV6c3hhb2M4WDNuU3JFRHdVMFJY?=
 =?utf-8?B?cEtKUTY5MnBieUNjNHlJcG1NVDBzR212L2FnUGF6OEdWeEJUeUFmQldNQXZj?=
 =?utf-8?B?K2Y1YUNKYit4ZS93a096eFdHdVk4dFFIVjhKT0NuazNzTnBSSEwzWEFoVXJB?=
 =?utf-8?B?SHpuRkdWVUluSmpiU252SzF3VlphZlFTamM3OVpLTVpNUkRJNDdzNUFacGl5?=
 =?utf-8?B?Y004aE9WYXdXTDBnci92a1NBM3JYQ3hJVW5aUDFIelNWYjdRWVFORWZZUFdN?=
 =?utf-8?B?M2pwaHNrSTJ3V3RDdU56Uy9FRFZEN3l2cEhHQ0dZbHBoRlo3ZnNXSjNXQlho?=
 =?utf-8?B?U0MvUVQrZDJKZ3cwc3FkdG9jUGFIcDA0aUNSSVRxZ2J0U2xzT0YvVUNVYUN1?=
 =?utf-8?B?UFRXb3FraHdaRGJFd083bjAraWRQbTNTb0R2b0pvMFRhMHlJZitOQnBjU200?=
 =?utf-8?B?V281OCtGd0liVUR6N1NMVmJNU3NMU3hOd2o5YTkyMUExS3ZnNHIyOG1BZEQ1?=
 =?utf-8?B?bFlyNjY4QmhJN215TjRVQUlucWNGaU53OUNWb0k5MXhtRFVSMTdmS1JyNVJq?=
 =?utf-8?B?R0lQZnN0cTBqTDM4eU56TUJKMXZIV05OeXdjOG9nVzN1SzV6Z0cwNVppalV0?=
 =?utf-8?B?ajJDb3Bjc05veE01aFkyVzNMWWsySEY0eTVFd3N2OW1uWkljM3kyWlFmVjdN?=
 =?utf-8?B?UHdhLzdDUnB6bHgwWTk4UHlzYWZYQWVyUUhaREtwQlpEK3hQdFgvdnhPNURJ?=
 =?utf-8?B?cmtIRDlQeDM1OGRVVXVQU1h6NnJldEE1UjA5YXlYUWZ4U0lvMUp1U0RKdzBP?=
 =?utf-8?B?RnZiL2hiS3pQaHVKRm42cGw4RjlaSzhCUTI2RlQwMzlueUNxRHViYTZEWWtX?=
 =?utf-8?B?ckczV05DVzVPRjE5UUQvTm1hNW95ZWE1aXhodlFOTXdrMGp4UW95WmM5cFF4?=
 =?utf-8?B?TW14MjdIdDdrS0VVeTI0cTh4ODFHL3FqZ2w0cUdaNjNCbFkrYW1sQnRKSnFK?=
 =?utf-8?Q?n9BXOMRLD1oJJykwF0/EpyDPXktSij2CJKKKQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E37DBAA0FE69E4181295DC3E1C2CD6C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5bd2e0-771d-4459-4cc1-08da4fbb6f5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 17:12:47.1767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XuA7xysECwjqAnn6hjY7hzgdZDkEM7Lk3HtVaKkNIKJlwo/AzYoP8LrvT+9uEVoPJJ3LXvMgsqX0qHERfwm0JymLiZBhCoUAribORHe1aaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6303
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTE2IGF0IDEyOjI0ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMTYsIDIwMjIgYXQgMDQ6NDY6MjdBTSAtMDQwMCwgWWFuZyBXZWlqaWFu
ZyB3cm90ZToNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHUuaA0KPiA+ICsrKyBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdS5oDQo+ID4gQEAgLTc0LDcgKzc0LDcgQEAgdm9pZCBp
bml0X2lhMzJfZmVhdF9jdGwoc3RydWN0IGNwdWluZm9feDg2ICpjKTsNCj4gPiAgIHN0YXRpYyBp
bmxpbmUgdm9pZCBpbml0X2lhMzJfZmVhdF9jdGwoc3RydWN0IGNwdWluZm9feDg2ICpjKSB7fQ0K
PiA+ICAgI2VuZGlmDQo+ID4gICANCj4gPiAtZXh0ZXJuIF9fbm9lbmRiciB2b2lkIGNldF9kaXNh
YmxlKHZvaWQpOw0KPiA+ICtleHRlcm4gX19ub2VuZGJyIHZvaWQgaWJ0X2Rpc2FibGUodm9pZCk7
DQo+ID4gICANCj4gPiAgIHN0cnVjdCB1Y29kZV9jcHVfaW5mbzsNCj4gPiAgIA0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jDQo+ID4gYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L2NvbW1vbi5jDQo+ID4gaW5kZXggYzI5NmNiMWMwMTEzLi44NjEwMmE4ZDQ1MWUgMTAw
NjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYw0KPiA+ICsrKyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMNCj4gPiBAQCAtNTk4LDIzICs1OTgsMjMgQEAgX19u
b2VuZGJyIHZvaWQgaWJ0X3Jlc3RvcmUodTY0IHNhdmUpDQo+ID4gICANCj4gPiAtX19ub2VuZGJy
IHZvaWQgY2V0X2Rpc2FibGUodm9pZCkNCj4gPiArX19ub2VuZGJyIHZvaWQgaWJ0X2Rpc2FibGUo
dm9pZCkNCj4gPiAgIHsNCj4gPiAgICAgICAgaWYgKGNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZF
QVRVUkVfSUJUKSkNCj4gPiAgICAgICAgICAgICAgICB3cm1zcmwoTVNSX0lBMzJfU19DRVQsIDAp
Ow0KPiANCj4gTm90IHN1cmUgYWJvdXQgdGhpcyByZW5hbWU7IGl0IHJlYWxseSBkaXNhYmxlcyBh
bGwgb2YgKFMpIENFVC4NCj4gDQo+IFNwZWNpZmljYWxseSwgb25jZSB3ZSBkbyBTLVNIU1RLIChh
ZnRlciBGUkVEKSB3ZSBtaWdodCBhbHNvIHZlcnkgbXVjaA0KPiBuZWVkIHRvIGtpbGwgdGhhdCBm
b3Iga2V4ZWMuDQoNClN1cmUsIHdoYXQgYWJvdXQgc29tZXRoaW5nIGxpa2Ugc3VwX2NldF9kaXNh
YmxlKCk/DQo=
