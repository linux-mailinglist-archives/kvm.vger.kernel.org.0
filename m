Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2054973FA38
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 12:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjF0K2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 06:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjF0K20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 06:28:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67CDE4;
        Tue, 27 Jun 2023 03:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687861704; x=1719397704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EAhsCQG4ajXQ6SNX+1w3c+A9QAM1vINPdH1s2AjAuVk=;
  b=f3de5GDflmTZNDYDFDvNhXoa22AMs5dUul2Voq7084LIAxJvpbjZs84Q
   Z7UVzfPOzsMjymU/RUbSDbMNX52zW6J9SIQywH0h0rIC41847GmjBE/p0
   FMGO8w1RXzeS6Qro1U77fixgpWVUi7PEXirbhH7NfVQYXAzntD+eDhP7n
   JMN/vWW2f1N+QnmoYAcMxWwtpze7LbvyjkaaSYSOzAzOheD4z9sk8XbkT
   B79fhYiceel1XhzSJ87GZiVfN4Dea3XCodF3KHKZsLWPHeAgn1J0+61y/
   M2KwT9rK4+46bgKMcvlw1QeQbma7IPp5QRn4hk6MDjPZqVij5+DGmt3Ku
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="447919119"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="447919119"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 03:28:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="781805671"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="781805671"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 27 Jun 2023 03:28:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 03:28:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 03:28:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 03:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnRx+0ch9pCQlanGjHsNeiTprAtn3igwh+6KkNuV1hBp2hFbxkWyZvnmqkDQ14ISLrtFhD6LZsmhlw8jPoMhRmh489h+bchdi2hUe0g3ArGaYqFnA5wdxxZFQRZ1nef5cGcnEmeINTd3kRYmsxPcu/IB1kwZsOMQ1VngFcP1CbyZBt2cHPQze5MWgpXTORk4jJc8oSVt/gd7on1B/PuKdkfhAX04FMYUzH8VfJ66lqf9QmP/DWMfUQmsbMhLrg13em367MElp/WiEJ2uXxqZsX8aTV3StM0cGweKGVkOnlb0dyR9NqdUwdq7+IcwSGygZlAWC6EBJNrldEXZhCg9dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAhsCQG4ajXQ6SNX+1w3c+A9QAM1vINPdH1s2AjAuVk=;
 b=B0wG1N+/uwy4/T+pD/RpBlRjtIv9fUcV9K6c8AbZ0vdD98GTEj5IYcIMgWlNGI3YlI03tPllXVKvSmx8HUIJQvVPerXt4vmtfyFKmKUyNf6nqYrJ/T99y+eMv+T04rV/kgQBVoQFj/VOQZt2utebEQkv3frYtSll4wqEEQveRpDmrru5bNb5ECOJtaqU8CtapqVMhGmn819dYyLNSOd+ZlE8sRQgsU1+Bdfjn4ydAjJ6/rjXbY6zHpqe5ptOjCofZvnM0LK3ttWUrNpSn5tacR7eGmAiT3FUEz/xrkcCwVaNv0NS0r2P3z9W4nPGJUhWqwFYgAycwFHTQpaemBFTww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6425.namprd11.prod.outlook.com (2603:10b6:510:1f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 10:28:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 10:28:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZqDWtRkTpkzZfa0qfwqSEOzdd8q+eaMIAgAAK/QA=
Date:   Tue, 27 Jun 2023 10:28:20 +0000
Message-ID: <102e45dd81589625ed064a742508597e0d118375.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
         <20230627094856.6udzuhzhygc4nzit@box.shutemov.name>
In-Reply-To: <20230627094856.6udzuhzhygc4nzit@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6425:EE_
x-ms-office365-filtering-correlation-id: e4ffb9ac-58fc-41a4-d1b0-08db76f93a6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iy75vzAfAfGpXTNcX1tCkPTj7B0OujPlenbh3B0untecIHu8qQ66yzBcPPa7SIMqNjDBmPsRz2oMEszVV+wyHpfg+dW6IIVIkAkhG7ailDRNVhFg8lSRIsAf3yEkjWwK3Yv81bsJ4I820APnPfwRmugTDs5FmWR31CdMrdo5KVOK5IrXPifosaJGeHD+AegOIn03P5lnrODwWRHvvuwm6tytS3FhPjqXNZ3K7kGCTtAMQjz0LldH+4NTslBu0Hb9xf0uLZ7J6fajdQGrrsLzhEhrvLo6GsdPq/rYUNbL3vgpkzjFi0K9YHZ8zDqILPrPpL0wkRK6ElltgoXQHVXoFRwBLVcj4fnzDml/f3uc/JPVJLXR1O+0PEmpkhWlg7Q94cfrMnNmQN0KmZ3bBNG2YgbZHfX69/SbyOT3DoAp1p6YIjaa9nEN/3kAf9A7caF5e8BzVH3evO7iuD80J2Lw+HNrCKYHpjJVPWS3bddAJH+XLCRvZJL5zD0tKi+nAZsCOrF1bMt+9BJWIRMzpbBpEkFoedqea3AKDBXxsbOfqQPWuvRhzk0fqspqNAL7sZaTM7GLSuwUrs+RX3Ri5C5iFc0Z2Mh81sdDfRy9UG4sByg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(7416002)(5660300002)(66946007)(66556008)(66446008)(4326008)(76116006)(66476007)(91956017)(6916009)(64756008)(478600001)(36756003)(316002)(8676002)(8936002)(2906002)(966005)(54906003)(38070700005)(86362001)(41300700001)(6486002)(71200400001)(186003)(6506007)(6512007)(26005)(82960400001)(38100700002)(122000001)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0Q5TWlIM0F4OGVUSW52MlpOeEtJL3FIQnV5Q1FNZVA2eTFXT3ZpcThnaXZC?=
 =?utf-8?B?MFhIaVM3OXFEUFZmSG1ENEd2WU5NUXNXMkp6ekVnN1VxbW03eXhUcEl4cGlN?=
 =?utf-8?B?R2xOb0JWYmFSQ0daaFYzdUlMRVRiVVhMNVgyUVdWbE03VERwZVBTQ2pHYTNK?=
 =?utf-8?B?WlQvRVZwOFZmbU16ZzlsZWhpeGdaNmlKWGptWHViNTE1RlRlZjg4U05rM2tD?=
 =?utf-8?B?NTVTMW1xZStZWVBOaCtIWkdlakVDcjIybzBybzAybHp2bUlxVzZsQm83cmtD?=
 =?utf-8?B?NU1Jbmx6SW1IODROMGd1amR6SlA4am5YSDJkZkpwTXdLYStiNlI0ajdjc2JF?=
 =?utf-8?B?dTdiYlV6WjkybFFDaVZXR1lWNStKR0ZKVzd1M3NiK2wvdFE1YlFBYVZqRExn?=
 =?utf-8?B?OEd0SkI0Z3BJOUwrSlVvSDZlVDRFcU5acFlFWmFDK0VUZUR1cWdrTnZ0T09F?=
 =?utf-8?B?dk9TSkVwWjU0Y3N4cWs1NWJHNHA4a3FoV2d4TDdaWURKcUsvZlZsNjZBOG4z?=
 =?utf-8?B?SFU0OHVscTU4UlArWjhpYXd5SkNQSTR4bG9iYUJ5cDFFYmlZdTVKSnU1TSt0?=
 =?utf-8?B?cExtV3k2WWdwSm84b1ZTMVQweXFHVmEzRmlKRVEwa0ppcG1UWkY2Z3lDczVQ?=
 =?utf-8?B?YUJhdXpIYnVBV3pUOVBvRlcrQ3RyRUc5ZzBMY3NFc2xJaG9zQlJJdDJtNlNu?=
 =?utf-8?B?OTdEM1pWbktBbnhNdXZkQ3RUdzBGc0pKVkVKNTk3WmhteWRpM0tzbE9ndU9U?=
 =?utf-8?B?dmxvb2VVUHpCRzAvMThpUEY0SnZKMVpHaE02bFVJZWlPbnR2dDk4RWVoRk4y?=
 =?utf-8?B?eFdvd2o0ZzQxdEc3QUh5RitKOWpTZUUzWDU0akMwUXhNWjd3VHdTM3RLS0Fx?=
 =?utf-8?B?cVZvRlFTYlVtVzRMVmdOYW8rLzViUDdVUVppcEIvV0hUK1VnUUp4V0RSZnAr?=
 =?utf-8?B?WTJGVFYvRWlFaDArQmNFeW1XRnpaRGY4eHJtcXN6R2xKS0FzRlRaaUYwRGhv?=
 =?utf-8?B?by9VYmJwT1EzYnVabWpOalNPcmU1QW1TMVZ1Vk1LYzFyWW9OdWt3ODMrUUF5?=
 =?utf-8?B?QTJqTDBqeXZUYnBkOHVMSlBSNGZMMDNUeUc3MUZqMDZoNUFKYlpXUEZBSEV3?=
 =?utf-8?B?WkY5c29JNnVxRHVkVmVwUnFWbGMrV2hkejZXWEp6bm16b3h6VWhxMTNvVzVa?=
 =?utf-8?B?UnpBNlRneElxdzh0Y001cUVlL0RJM0lxbmcrOWFvVHdqY1hJRHRBbElUcjdC?=
 =?utf-8?B?ZVRlWmE1UGk5bkpweXp5WGphYjhyYlh1WU12c1J5bjJQRXBmY0kzVkxmR1RT?=
 =?utf-8?B?VlF0L2lDNUlTK0dUUi9LQm94MXMvWERBd3NCcmxZQmx2eW1VOUdyTFhuSFpj?=
 =?utf-8?B?RTdRRE8xMWJXbTIyUjFnUWx5SHFlUlFDYkxXVWdpOGhJZkErbjhyRnI1ZDZG?=
 =?utf-8?B?aG9rZ2dGdXJCblJ3L3o4dFV5QmFMSlQ2TWtxNitVTG1rNDBiNzBTalhSejBn?=
 =?utf-8?B?L2k1akVUUXVMaENzYzYxSUNuRUliYXhBb0QxWE45SWhlOGIzU2dBdTYwQ0tR?=
 =?utf-8?B?Umc2WWs4dFRwd1Q1SURJbGcvK1pTaFd4RG1QcUFVMW9yNkFtaHk5UFkwUVJF?=
 =?utf-8?B?RGR2QXJsQjNZZHllS3JMZGhEZmhKbjl0cTQ2U2tVbG1aM1BYdThoSjRSbzZZ?=
 =?utf-8?B?Nll0WWVOZkY1aDdyaitnUlJUZHRkLzlGdFVtbGs3YU1zdEJVTGFGVytmdGRJ?=
 =?utf-8?B?aUVTbTVGRWtOT0pjbm52cHJsWDlEWHJmV2lhYW5BdlNKS1FFUVJyVno2dU5h?=
 =?utf-8?B?TUt2ak1ENmI0VEwwWUFyMjBLcTh2SkJQTUF5QVdCRS9ndC81WWZ6blpjUmUv?=
 =?utf-8?B?Y1dHa2ZVRDl4Kzc4aVh6c1pIQkZ4aUFCSUtNVmoxSXE5ckpEODJuL3BhVjJF?=
 =?utf-8?B?MmZTSUF4bmlJRFlRZ2RVSHNTQWtaN1ZoRzBjbDJsMVBBSjU5RHhLTE5RaVlx?=
 =?utf-8?B?YTZCeXRERHZGb1hmcFV2SG9sejhJYk1XQ0dnMTQ0VzdyZ09lT3lQYzdaQ2xC?=
 =?utf-8?B?eWdjdWNPeDNOWGhvaVd6N1l6Znl1THZtV1hrVzArVkhMcFpXcC9ORlFKT3J2?=
 =?utf-8?Q?7SYWk9/7ob4quOMKIautV6MFT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED31A3671B475C45AB862992DB48F7B2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ffb9ac-58fc-41a4-d1b0-08db76f93a6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 10:28:20.2155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MG6GVgFURY+TmtGsw+uBd7YP5CfYKgDBRYe9M5Vfvc+4NYIhAfbXtdr20p5sXGBk8PWFb2nvrnpjQIJD8YK9JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6425
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

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDEyOjQ4ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAyNywgMjAyMyBhdCAwMjoxMjozNUFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gKy8qDQo+ID4gKyAqIFdyYXBwZXIgb2YgX19zZWFt
Y2FsbCgpIHRvIGNvbnZlcnQgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBlcnJvciBjb2RlDQo+ID4g
KyAqIHRvIGtlcm5lbCBlcnJvciBjb2RlLiAgQHNlYW1jYWxsX3JldCBhbmQgQG91dCBjb250YWlu
IHRoZSBTRUFNQ0FMTA0KPiA+ICsgKiBsZWFmIGZ1bmN0aW9uIHJldHVybiBjb2RlIGFuZCB0aGUg
YWRkaXRpb25hbCBvdXRwdXQgcmVzcGVjdGl2ZWx5IGlmDQo+ID4gKyAqIG5vdCBOVUxMLg0KPiA+
ICsgKi8NCj4gPiArc3RhdGljIGludCBfX2Fsd2F5c191bnVzZWQgc2VhbWNhbGwodTY0IGZuLCB1
NjQgcmN4LCB1NjQgcmR4LCB1NjQgcjgsIHU2NCByOSwNCj4gPiArCQkJCSAgICB1NjQgKnNlYW1j
YWxsX3JldCwNCj4gPiArCQkJCSAgICBzdHJ1Y3QgdGR4X21vZHVsZV9vdXRwdXQgKm91dCkNCj4g
PiArew0KPiA+ICsJdTY0IHNyZXQ7DQo+ID4gKwlpbnQgY3B1Ow0KPiA+ICsNCj4gPiArCS8qIE5l
ZWQgYSBzdGFibGUgQ1BVIGlkIGZvciBwcmludGluZyBlcnJvciBtZXNzYWdlICovDQo+ID4gKwlj
cHUgPSBnZXRfY3B1KCk7DQo+ID4gKwlzcmV0ID0gX19zZWFtY2FsbChmbiwgcmN4LCByZHgsIHI4
LCByOSwgb3V0KTsNCj4gPiArCXB1dF9jcHUoKTsNCj4gPiArDQo+ID4gKwkvKiBTYXZlIFNFQU1D
QUxMIHJldHVybiBjb2RlIGlmIHRoZSBjYWxsZXIgd2FudHMgaXQgKi8NCj4gPiArCWlmIChzZWFt
Y2FsbF9yZXQpDQo+ID4gKwkJKnNlYW1jYWxsX3JldCA9IHNyZXQ7DQo+ID4gKw0KPiA+ICsJc3dp
dGNoIChzcmV0KSB7DQo+ID4gKwljYXNlIDA6DQo+ID4gKwkJLyogU0VBTUNBTEwgd2FzIHN1Y2Nl
c3NmdWwgKi8NCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCWNhc2UgVERYX1NFQU1DQUxMX1ZNRkFJ
TElOVkFMSUQ6DQo+ID4gKwkJcHJfZXJyX29uY2UoIm1vZHVsZSBpcyBub3QgbG9hZGVkLlxuIik7
DQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCXByX2Vycl9v
bmNlKCJTRUFNQ0FMTCBmYWlsZWQ6IENQVSAlZDogbGVhZiAlbGx1LCBlcnJvciAweCVsbHguXG4i
LA0KPiA+ICsJCQkJY3B1LCBmbiwgc3JldCk7DQo+ID4gKwkJaWYgKG91dCkNCj4gPiArCQkJcHJf
ZXJyX29uY2UoImFkZGl0aW9uYWwgb3V0cHV0OiByY3ggMHglbGx4LCByZHggMHglbGx4LCByOCAw
eCVsbHgsIHI5IDB4JWxseCwgcjEwIDB4JWxseCwgcjExIDB4JWxseC5cbiIsDQo+ID4gKwkJCQkJ
b3V0LT5yY3gsIG91dC0+cmR4LCBvdXQtPnI4LA0KPiA+ICsJCQkJCW91dC0+cjksIG91dC0+cjEw
LCBvdXQtPnIxMSk7DQo+IA0KPiBUaGlzIGxvb2sgZXhjZXNzaXZlbHkgbm9pc3kuDQo+IA0KPiBE
b24ndCB3ZSBoYXZlIFNFQU1DQUxMIGxlYWZzIHRoYXQgY2FuIGZhaWwgaW4gbm9ybWFsIHNpdHVh
dGlvbj8gTGlrZQ0KPiBURFhfT1BFUkFORF9CVVNZIGVycm9yIGNvZGUgdGhhdCBpbmRpY2F0ZSB0
aGF0IG9wZXJhdGlvbiBsaWtlbHkgd2lsbA0KPiBzdWNjZWVkIG9uIHJldHJ5Lg0KDQpGb3IgVERY
IG1vZHVsZSBpbml0aWFsaXphdGlvbiBURFhfT1BFUkFORF9CVVNZIGNhbm5vdCBoYXBwZW4uICBL
Vk0gbWF5IGhhdmUNCmxlZ2FsIGNhc2VzIHRoYXQgQlVTWSBjYW4gaGFwcGVuLCBlLmcuLCBLVk0n
cyBURFAgTU1VIHN1cHBvcnRzIGhhbmRsaW5nIGZhdWx0cw0KY29uY3VycmVudGx5IG9uIGRpZmZl
cmVudCBjcHVzLCBidXQgdGhhdCBpcyBzdGlsbCB1bmRlciBkaXNjdXNzaW9uLiAgQWxzbyBLVk0N
CnRlbmRzIHRvIHVzZSBfX3NlYW1jYWxsKCkgZGlyZWN0bHk6DQoNCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvM2MyYzE0MmUxNGEwNGE4MzNiNDdmNzdmYWVjYWE5MTg5OWI0NzJjZC4xNjc4
NjQzMDUyLmdpdC5pc2FrdS55YW1haGF0YUBpbnRlbC5jb20vDQoNCkkgZ3Vlc3MgS1ZNIGRvZXNu
J3Qgd2FudCB0byBwcmludCBtZXNzYWdlIGluIGFsbCBjYXNlcyBhcyB5b3Ugc2FpZCwgYnV0IGZv
cg0KbW9kdWxlIGluaXRpYWxpemF0aW9uIGlzIGZpbmUuICBUaG9zZSBlcnJvciBtZXNzYWdlcyBh
cmUgdXNlZnVsIGluIGNhc2UNCnNvbWV0aGluZyBnb2VzIHdyb25nLCBhbmQgcHJpbnRpbmcgdGhl
bSBpbiBzZWFtY2FsbCgpIGhlbHBzIHRvIHJlZHVjZSB0aGUgY29kZQ0KdG8gcHJpbnQgaW4gYWxs
IGNhbGxlcnMuDQoNCj4gDQo+IE9yIGlzIHRoYXQgd3JhcHBlciBvbmx5IHVzZWQgZm9yIG5ldmVy
LWZhaWwgU0VBTUNBTExzPyBJZiBzbywgcGxlYXNlDQo+IGRvY3VtZW50IGl0Lg0KPiANCg0KSG93
IGFib3V0IGFkZGluZyBiZWxvdz8NCg0KCVVzZSBfX3NlYW1jYWxsKCkgZGlyZWN0bHkgaW4gY2Fz
ZXMgdGhhdCBwcmludGluZyBlcnJvciBtZXNzYWdlIGlzbid0DQoJZGVzaXJlZCwgZS5nLiwgd2hl
biBTRUFNQ0FMTCBjYW4gbGVnYWxseSBmYWlsIHdpdGggQlVTWSBhbmQgdGhlIGNhbGxlcg0KCXdh
bnRzIHRvIHJldHJ5Lg0KDQo=
