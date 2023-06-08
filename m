Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D94727D27
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbjFHKtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 06:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjFHKtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 06:49:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BB3E6C;
        Thu,  8 Jun 2023 03:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686221343; x=1717757343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qk5PFhUwYvyxnRy7e+Wu5RuDE17DfCPT7gKViJ0+kvU=;
  b=C5JOGD8V8EGByeLf4yU6092jlQihV981vNNOy7TrJug0anp5+FaGhhI+
   wNuYWsCX39Xkmy8wnnlER0bsMod+O1FJyicUx9277lb9eHXP2KkAmcatR
   qPFcXGaY6iz6wEwkZXP52sUyy25NLIgkK6HRNxQqUBJBAzipO7L/4in/d
   9B23neA55eJZpCLvLosZ8KaYzGxwtEj5RY/tZC/StC1Mlv9kW5xQ7ea2J
   0UXlREkQEgWc0q1N04VwUxFHhk4wylw6kgvT564EJtFX3vq5EzGn//Xli
   4wzlr76xwZXdfq0BYpmmWJCE0+dyxAQwS/UgLFyMkKBu1of6DxlOaMEmw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="360609415"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="360609415"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 03:49:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="1040075148"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="1040075148"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2023 03:49:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 03:49:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 03:49:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 03:49:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j09I06nlDCMKLmKvOisRmjLkSeibqy8acG0aKfcMKr3O6mh5x7sEhPQYTj25EFZj8K33dOc46nf+CGn8t6mKJqMz7WK2vnYAufsdGxC6HVjdfQa3h7D7J//KKz203qHVMMuM1ianMYdhf9DtRQVFXykjRA5U0dS94+euT70ZKlqqoRgNn3n15GljnKKkWXW9u/MZzUiWtq6edPMmo1WZrfHJ2zdSBWL7Bq3MXOrIY1o3FkAYlfOt5C4JgSv6h186XarXyPK7OvKlNSxu7TlBq3kmvYTqxTY2LcRjyifeC9qczVDrKBco3nxAqHpgZJOXxnBObwF/vdC7j0Sso61Zhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qk5PFhUwYvyxnRy7e+Wu5RuDE17DfCPT7gKViJ0+kvU=;
 b=FiGf9rqmP7BWLOTQ7ldb5lMe//zjRvKptgWyVzV62IEJpyj7W1NCCD1Sdef939PsZXj8/oNVFix1o8bnpA3myd2Oqwf5E4nkwI+T08AMKzL4ueWE185rYt/HvFILtHuAb5s+oJY4k5srhfepELFt5733eLeYydBE3vKlnaSYa3VLDzmOXSIKeX2G5HfACiT7R0/7K011rv+0WXesXRm2RvVUp1O5Mwd1vVQkfyme6+/sdM7RQCXoGTQUtaWYoWNZzJ19yZyteaR1l0QFF6HhHsLwp4KVApdtpxKV/IwXCskGX2/oLEf/eWC7NDTYDccFYPbY3CWa3MvDe08unXXFIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW6PR11MB8390.namprd11.prod.outlook.com (2603:10b6:303:240::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Thu, 8 Jun
 2023 10:48:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:48:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK9/hdAAgAE59IA=
Date:   Thu, 8 Jun 2023 10:48:59 +0000
Message-ID: <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
In-Reply-To: <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW6PR11MB8390:EE_
x-ms-office365-filtering-correlation-id: 69edd437-d09d-4155-8c46-08db680df757
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrUv/kUKgl5tgdXju6pmQ8hImt/LroSWkbJpEBWVMBr2jJud2qQxTO3Ki1QDNuy/0i+458iwTQof3Ml1ZLvyKsyT1IeogVOAW4siQqKEGyZ4fuyD6ERLzPQemzgnoA5BaCVSCVaGRRC0+LlUIiLncZ2C6Et2jAyGJ9L+h0tH7ZiHPrnPWYmkV4tGtgkjnr6gRCHnf1HZC0e+9Tjbvwd7Z/i5wMrj6tAANHyrTyFeHtAcjRWuzIknR8YVPamRTn5+8xG5qqjUt2CQwwQ1gVcNs7ZiR1Aqyi7Yu0TfVmSEy6A3yvLxh5bHRMGJAfhRHdhUtQLLUA4vWwRJJXB8G5fqJP9aHxL4xqG2emHamgykGnZ5RvpJTGypuk2RPzE6WXt7qJ3RgmzcLyd5XRmSK8tbXiq0H861RNRH1OggGEK93b7cK14OU5tR596k15luQsDb+OgonseMmLhzyVlcWFWltM9cKgLMZMGtPqCbl9RiOukDhmB8inE9j1Wp/VJwVFQynG1sRG8cs4cYKxde3DvTIsn0SU99GUzpIbG5iLfgn2w/fsXnT+LRBBWF2e8H9mCT6x6jJSuYbJ/ptY4w8mcR+2d8VxCsAzPstMKsrjG0wS9stwyqCeY/OErIZ/xFi9cS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199021)(86362001)(4326008)(7416002)(91956017)(5660300002)(2906002)(66446008)(64756008)(8676002)(38070700005)(41300700001)(316002)(66556008)(76116006)(66946007)(66476007)(38100700002)(110136005)(54906003)(122000001)(8936002)(82960400001)(478600001)(53546011)(71200400001)(6486002)(186003)(26005)(6512007)(2616005)(36756003)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUI0SFFYMXFEb1BKMWtKamxSdEZ2RzBXdnlnYVBNWGp1cHl0cjZzS2tyZC9r?=
 =?utf-8?B?RlNrRDdmY29heXIzTzkwZEVudW45T0lNL2c4NEl3bkZ0eGtIR3g1a0lCWWtq?=
 =?utf-8?B?b0lDQ0dVYWFWWnhUTjE1V2lMdHMzWFowTHBxc1lSc0dibEtCbmUzNkRXVXZy?=
 =?utf-8?B?NFgrejdrRXM1bk8xTHpUekE0UUJkV0x5bTNsYUVBL1NrTHZzbjU1RHlaVUQ1?=
 =?utf-8?B?TUZyRzJ2QkNzTjZmNjR5cVMrTEdvVlA1cXdDdVUyOHdaeXVKMXAySmZ4L2x1?=
 =?utf-8?B?Y2VmeG5YOU1pSWVJdTRoZ0Z0SFdtVExER0MxMWZwYXMza3ZzWXZUdkRWRXZy?=
 =?utf-8?B?Qi9OOTlYajlEeHN2L1Qyc1ovVHVDdGUxczV3K0dtNGt6eUdlUGowc3A4SGdp?=
 =?utf-8?B?eXRhZ2x2eWIrNHJFNTh3NlY2enp2NC9ySjlmRHBGc1FhcTArUmlGOFZLU3JW?=
 =?utf-8?B?OWdWSzFZNWFjcHYzNGdWOEVZV2kvZ1NpaGQ1NXJFREljYURlZlN6ZzJTZC9j?=
 =?utf-8?B?MXZIcEpEdnhKcjFYSDd3c0J4ZGtTdVFtTUszNlRHUE1YQ2xVZCs5ejkwQWk4?=
 =?utf-8?B?clZQRm4ySUVsbE5iYWF4VjR2L2I1UU9DeGlOQVQxcjRMcnA0eXBITG5GMlUx?=
 =?utf-8?B?dXhFVUx6Vk1EMGZRMnBoTjlQdFdQWllQREw1M2NiQlpYS2FiRjBVMjRYaTJx?=
 =?utf-8?B?dkEyU243Mk45VWxvVjBHUmpSRG5zZS9kU3JnVnk0WW9GR1dXdXJBQ0hTbW1s?=
 =?utf-8?B?QXo2c0hyRlEzY2U0dlAzaFFoUGFFL2YrV2N4MjhoSGhBNTVuQjkrQXl2cWta?=
 =?utf-8?B?Y3lxREQ1ekk4ZXZkTFU0TDAvUTNCUmVtbzRSdzVnT1RoWUVKMUwzR1hDWjAw?=
 =?utf-8?B?RmxsV1d6TVROVTVtOFp3TlRWZFpuTmRFZmRQSGlTQlFOU3hvVTJQd3pzZGNr?=
 =?utf-8?B?ZEJHYnVLSVVrZWlpT2hpVnNQVllGempOeTZyVTJrbU1Lb1RyT3FjVjd5RGdq?=
 =?utf-8?B?UkN4S1FlNzZXcm4wdzdVcENQcXhEZmNhSXpxSVQ4c1hmZnMzdHJIYnZ5S3Nu?=
 =?utf-8?B?d2RzT244R3dGeWt4eFNWMEk3Lzc0NzdEVnFrempsYjIrc0tQUnFOZ0VJMVg1?=
 =?utf-8?B?SFNtc215TzF6LzFNdDRtVTd3OHdZNlh6NFp3VFptemF4bzdsbmEvdDNDeXVv?=
 =?utf-8?B?dzF5dk1LNFlJWE55bHVkTTRveHRhSllJQzJORUt6NXZVRmlQSFg0ajFPd0Rp?=
 =?utf-8?B?Sy9aNXhocVBjeTVlNUdVb1hKUmJIc0lqdzV0NjdyOTFUUzhzUm9RMkd1MVNF?=
 =?utf-8?B?SHAyRGVleGZVWU9JVytJbDRsQmI3UjhTa0kzYS9Gc09EejNsRTFuQUNlZHFs?=
 =?utf-8?B?dGYyRXNrNGw1Q1pJVDJBNXlBWjkxeFR5b3RvbjBQRnpTdFhzQ1RSeUZ5R1Ft?=
 =?utf-8?B?MVVhTjQ4cEwrLy9mM2E1cG5LN1lENjJ6dFhOTzlTV2dOVVNlRXFCdG1qS1ZD?=
 =?utf-8?B?UkpzaHlhcm9hd1BueHU5NGJKSVFlbDlPS0l0Z0p2WDdoS2lVMVA4cHpFRHRR?=
 =?utf-8?B?Tmc4amF0MHV3dU5DMjVzTVNCMXVjaUZXbzFRL1IxbEUwYlBZS2F3TlprT096?=
 =?utf-8?B?bDNyOWNvNXRUWlVQd1ZQWDhaUTUxVlRJSytvVVgxSW41c254NWlBQndObytl?=
 =?utf-8?B?L1dsdHFhNEFybzYvU3JwSWtya3pWVmZ3YmhCYTRjZU9JVHA3U05YMjlrb25p?=
 =?utf-8?B?VFcyNzVRcExCdnI1aUlOZ25ET0V6eC9QRzFZR1laL2hxMTJnS0tnQW5oaUxa?=
 =?utf-8?B?QTlXSDlMM1lhaWcrNVAxQ0Z3eHA1c1l2M1F5S0xBUW9hdFJEQllRRDBadG1M?=
 =?utf-8?B?amdmVGZSSmh5bDZYMER5bUY3NUFkRTZSNEhvM2d1dmJJTU5EOUVCdDgrRWRi?=
 =?utf-8?B?VFhQWE1hdURMZ1RJNTIwaEFTWUlyYXBpYk1JRWtqcmQrSmpHaXN4bDkvS1RF?=
 =?utf-8?B?WmVwY3VGSG1rNWFYZW1MZHkrdnpyaS9KT3k4ZmZHT1lZVWozbHdJV21RUEda?=
 =?utf-8?B?SzZNU0FKaFY2ZW5mVU4yTVZyVER4OXN0cEQwUEIxVFN1ci9nM1dtUTZGMkI1?=
 =?utf-8?B?eHhYSzVlME9IOHZ6VTRMc3hkbGJ3UW1uUHh4cWVBMnFZdGkxSFM0SGNsYnha?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5CC114CB821574196FE00F4A5790D05@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69edd437-d09d-4155-8c46-08db680df757
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 10:48:59.6260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qo2Zu+avLOwzDsclRaKQcKEeV2nHVPlpnGhIEqV7ENAcmkk6cKF6Pqc1wocJnl3I22QVbwYkc74cbx/luF8PbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA5OjA1IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi80LzIzIDA3OjI3LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gKwkvKg0KPiA+ICsJICogTG9v
cCBvdmVyIFREWCBtZW1vcnkgcmVnaW9ucyBhbmQgZmlsbCBvdXQgVERNUnMgdG8gY292ZXIgdGhl
bS4NCj4gPiArCSAqIFRvIGtlZXAgaXQgc2ltcGxlLCBhbHdheXMgdHJ5IHRvIHVzZSBvbmUgVERN
UiB0byBjb3ZlciBvbmUNCj4gPiArCSAqIG1lbW9yeSByZWdpb24uDQo+ID4gKwkgKg0KPiA+ICsJ
ICogSW4gcHJhY3RpY2UgVERYMS4wIHN1cHBvcnRzIDY0IFRETVJzLCB3aGljaCBpcyBiaWcgZW5v
dWdoIHRvDQo+ID4gKwkgKiBjb3ZlciBhbGwgbWVtb3J5IHJlZ2lvbnMgaW4gcmVhbGl0eSBpZiB0
aGUgYWRtaW4gZG9lc24ndCB1c2UNCj4gPiArCSAqICdtZW1tYXAnIHRvIGNyZWF0ZSBhIGJ1bmNo
IG9mIGRpc2NyZXRlIG1lbW9yeSByZWdpb25zLiAgV2hlbg0KPiA+ICsJICogdGhlcmUncyBhIHJl
YWwgcHJvYmxlbSwgZW5oYW5jZW1lbnQgY2FuIGJlIGRvbmUgdG8gbWVyZ2UgVERNUnMNCj4gPiAr
CSAqIHRvIHJlZHVjZSB0aGUgZmluYWwgbnVtYmVyIG9mIFRETVJzLg0KPiA+ICsJICovDQo+IA0K
PiBSYXRoZXIgdGhhbiBmb2N1cyBpbiBvbiBvbmUgc3BlY2lmaWMgY29tbWFuZC1saW5lIHBhcmFt
ZXRlciwgbGV0J3MganVzdCBzYXk6DQo+IA0KPiAJSW4gcHJhY3RpY2UgVERYIHN1cHBvcnRzIGF0
IGxlYXN0IDY0IFRETVJzLiAgQSAyLXNvY2tldCBzeXN0ZW0NCj4gCXR5cGljYWxseSBvbmx5IGNv
bnN1bWVzIDxOVU1CRVI+IG9mIHRob3NlLiAgVGhpcyBjb2RlIGlzIGR1bWINCj4gCWFuZCBzaW1w
bGUgYW5kIG1heSB1c2UgbW9yZSBUTURScyB0aGFuIGlzIHN0cmljdGx5IHJlcXVpcmVkLg0KDQpU
aGFua3Mgd2lsbCBkby4gIFdpbGwgdGFrZSBhIGxvb2sgYXQgbWFjaGluZSB0byBnZXQgdGhlIDxO
VU1CRVI+Lg0KDQo+IA0KPiBMZXQncyBhbHNvIHB1dCBhIHByX3dhcm4oKSBpbiBoZXJlIGlmIHdl
IGV4Y2VlZCwgc2F5IDEvMiBvciBtYXliZSAzLzQgb2YNCj4gdGhlIDY0LiAgV2UnbGwgaG9wZWZ1
bGx5IHN0YXJ0IHRvIGdldCByZXBvcnRzIHNvbWV3aGF0IGluIGFkdmFuY2UgaWYNCj4gc3lzdGVt
cyBnZXQgY2xvc2UgdG8gdGhlIGxpbWl0Lg0KDQpNYXkgSSBhc2sgd2h5IHRoaXMgaXMgdXNlZnVs
PyAgVERYIG1vZHVsZSBjYW4gb25seSBiZSBpbml0aWFsaXplZCBvbmNlLCBzbyBpZg0Kbm90IGNv
bnNpZGVyaW5nIG1vZHVsZSBydW50aW1lIHVwZGF0ZSBjYXNlLCB0aGUga2VybmVsIGNhbiBvbmx5
IGdldCB0d28gcmVzdWx0cw0KZm9yIG9uY2U6wqANCg0KMSkgU3VjY2VlZCB0byBpbml0aWFsaXpl
OiBjb25zdW1lZCBURE1ScyBkb2Vzbid0IGV4Y2VlZCBtYXhpbXVtIFRETVJzDQoyKSBGYWlsIHRv
IGluaXRpYWxpemU6IGNvbnN1bWVkIFRETVJzIGV4Y2VlZHMgbWF4aW11bSBURE1Scw0KDQpXaGF0
J3MgdGhlIHZhbHVlIG9mIHByX3dhcm4oKSB1c2VyIHdoZW4gY29uc3VtZWQgVERNUnMgZXhjZWVk
cyBzb21lIHRocmVzaG9sZD8NCg0KQW55d2F5LCBpZiB5b3Ugd2FudCBpdCwgaG93IGRvZXMgYmVs
b3cgY29kZSBsb29rPw0KDQogc3RhdGljIGludCBmaWxsX291dF90ZG1ycyhzdHJ1Y3QgbGlzdF9o
ZWFkICp0bWJfbGlzdCwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHRkbXJfaW5m
b19saXN0ICp0ZG1yX2xpc3QpDQogew0KKyAgICAgICBpbnQgY29uc3VtZWRfdGRtcnNfdGhyZXNo
b2xkLCB0ZG1yX2lkeCA9IDA7DQogICAgICAgIHN0cnVjdCB0ZHhfbWVtYmxvY2sgKnRtYjsNCi0g
ICAgICAgaW50IHRkbXJfaWR4ID0gMDsNCiANCiAgICAgICAgLyoNCiAgICAgICAgICogTG9vcCBv
dmVyIFREWCBtZW1vcnkgcmVnaW9ucyBhbmQgZmlsbCBvdXQgVERNUnMgdG8gY292ZXIgdGhlbS4N
CiAgICAgICAgICogVG8ga2VlcCBpdCBzaW1wbGUsIGFsd2F5cyB0cnkgdG8gdXNlIG9uZSBURE1S
IHRvIGNvdmVyIG9uZQ0KICAgICAgICAgKiBtZW1vcnkgcmVnaW9uLg0KICAgICAgICAgKg0KLSAg
ICAgICAgKiBJbiBwcmFjdGljZSBURFgxLjAgc3VwcG9ydHMgNjQgVERNUnMsIHdoaWNoIGlzIGJp
ZyBlbm91Z2ggdG8NCi0gICAgICAgICogY292ZXIgYWxsIG1lbW9yeSByZWdpb25zIGluIHJlYWxp
dHkgaWYgdGhlIGFkbWluIGRvZXNuJ3QgdXNlDQotICAgICAgICAqICdtZW1tYXAnIHRvIGNyZWF0
ZSBhIGJ1bmNoIG9mIGRpc2NyZXRlIG1lbW9yeSByZWdpb25zLiAgV2hlbg0KLSAgICAgICAgKiB0
aGVyZSdzIGEgcmVhbCBwcm9ibGVtLCBlbmhhbmNlbWVudCBjYW4gYmUgZG9uZSB0byBtZXJnZSBU
RE1Scw0KLSAgICAgICAgKiB0byByZWR1Y2UgdGhlIGZpbmFsIG51bWJlciBvZiBURE1Scy4NCisg
ICAgICAgICogSW4gcHJhY3RpY2UgVERYIHN1cHBvcnRzIGF0IGxlYXN0IDY0IFRETVJzLiAgQSAy
LXNvY2tldCBzeXN0ZW0NCisgICAgICAgICogdHlwaWNhbGx5IG9ubHkgY29uc3VtZXMgPE5VTUJF
Uj4gb2YgdGhvc2UuICBUaGlzIGNvZGUgaXMgZHVtYg0KKyAgICAgICAgKiBhbmQgc2ltcGxlIGFu
ZCBtYXkgdXNlIG1vcmUgVE1EUnMgdGhhbiBpcyBzdHJpY3RseSByZXF1aXJlZC4NCisgICAgICAg
ICoNCisgICAgICAgICogQWxzbyBzZXQgYSB0aHJlc2hvbGQgb2YgY29uc3VtZWQgVERNUnMsIGFu
ZCBwcl93YXJuKCkgdG8gd2Fybg0KKyAgICAgICAgKiB0aGUgdXNlciB0aGUgc3lzdGVtIGlzIGdl
dHRpbmcgY2xvc2UgdG8gdGhlIGxpbWl0IG9mIHN1cHBvcnRlZA0KKyAgICAgICAgKiBudW1iZXIg
b2YgVERNUnMgaWYgdGhlIG51bWJlciBvZiBjb25zdW1lZCBURE1ScyBleGNlZWRzIHRoZQ0KKyAg
ICAgICAgKiB0aHJlc2hvbGQuDQogICAgICAgICAqLw0KKyAgICAgICBjb25zdW1lZF90ZG1yc190
aHJlc2hvbGQgPSB0ZG1yX2xpc3QtPm1heF90ZG1ycyAqIDMgLyA0Ow0KICAgICAgICBsaXN0X2Zv
cl9lYWNoX2VudHJ5KHRtYiwgdG1iX2xpc3QsIGxpc3QpIHsNCiAgICAgICAgICAgICAgICBzdHJ1
Y3QgdGRtcl9pbmZvICp0ZG1yID0gdGRtcl9lbnRyeSh0ZG1yX2xpc3QsIHRkbXJfaWR4KTsNCiAg
ICAgICAgICAgICAgICB1NjQgc3RhcnQsIGVuZDsNCkBAIC00NjMsNiArNDY3LDEwIEBAIHN0YXRp
YyBpbnQgZmlsbF9vdXRfdGRtcnMoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QsDQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRU5PU1BDOw0KICAgICAgICAgICAgICAg
ICAgICAgICAgfQ0KIA0KKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHRkbXJfaWR4ID09IGNv
bnN1bWVkX3RkbXJzX3RocmVzaG9sZCkNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
cHJfd2FybigiY29uc3VtZWQgVERNUnMgcmVhY2hpbmcgbGltaXQ6ICVkIHVzZWQNCihvdXQgb2Yg
JWQpXG4iLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dGRtcl9pZHgsIHRkbXJfbGlzdC0+bWF4X3RkbXJzKTsNCisNCiAgICAgICAgICAgICAgICAgICAg
ICAgIHRkbXIgPSB0ZG1yX2VudHJ5KHRkbXJfbGlzdCwgdGRtcl9pZHgpOw0KICAgICAgICAgICAg
ICAgIH0NCg0KDQo=
