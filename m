Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A5E663661
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbjAJApg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbjAJApe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:45:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764BCE035;
        Mon,  9 Jan 2023 16:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673311533; x=1704847533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NTAMO632sRZzhNDBR6fmfZrSNfgrSFBGpI2Fw+FXrbY=;
  b=CS7yOVH3HqbPd+C7lJ1BU0A+Gqzk3BDzL0YSV7pkRlAfc8xR9z782fue
   wFsAke+YrBJGoDeqyY/sMS47CmW7nT61Fh9RMKrIUX/94TGh8NA80B8Uu
   5O8s4KHDfSfHrMpvSCNmOd6fDhThzbKmnLhI6TFZK6kTJS/dY+ogAsukN
   XGj16RAmczj8lbJrUqs8AJQWQoOvpeCFS3dSuiP/fwUSLJ6Ry+NZKuVMo
   9Z6FrTDq9WSh9F6T+j8l7hlNQgw1dvTx1DwWV1nnhzO/uNTlm4TM+vZw1
   LhXW5tcXchvgZl5ri9opYBrZhB/APoAaj1DFjSyiSHkn0RI/PvXM0Qx8w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302721590"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="302721590"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:45:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="985582671"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="985582671"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2023 16:45:32 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 16:45:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 16:45:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 16:45:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKKBQ8WOpFF7IVYRRrV/HhCBX/TCuV5JBBmizvioUa3EK0xl8N19uOkmEiWSMqfaSoZb6Ab+s9V6zDjScgV34D6/dUb2FD9K+lNap52kWpzCFRSYWH42l1yS5OKUCTdhcZB/d+/Vfip7ukUDjlsFSiwPcCnK0oyKoeuAoibRa5JSeaRKWgbGLOSx/Pre1+sMvaZ4jNY8ICJcQS1twiwnWzVmWZ4Q7sfCcZPq+ySxdN6ZoYjeYDlYZgYQM5DvH42oBeiY9K8t6K2mt/Zuh9qRbnIddFnygozO72ULT10YKnQJSUiI6pcOaDvOSDmlGWCtINFvmQuGzVsggGB4JPBdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTAMO632sRZzhNDBR6fmfZrSNfgrSFBGpI2Fw+FXrbY=;
 b=EtIluDFQ6VG1K/Sz4xWpJPvt1GIQ8eK+TIkJtng4JTW+C+VoEmVa6MuRuRZjc18yhxRTK6daQhQmXsXzracpdJzL7PvWNRUkj3LhTTMvTm+6MEemmYHVcR0AFweB3hhx53eZ8TsFp6j7OEhwPDAnvUtXeUW1P1DQlRmCqCgr9lE0q0c8flMkaPAlC1fh3nx0sJlWJMnulOITAdgxDqMRYObrssPLjVKosD4ULFpzoUCAtqclgRL0hZvjz7fygPTKikmYG0c37BbwMmp+1fHqr36CtgRQt7gmTAcqdvY1mgGuFEmloUFk8WaSbGENNe/O8ieOnbF7euF2wjSnGtNMxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW5PR11MB5883.namprd11.prod.outlook.com (2603:10b6:303:19f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:45:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:45:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 09/16] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v8 09/16] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZC5gQweYEwNbFiUS1kEgN1eKRI66R9SqAgAUNTYA=
Date:   Tue, 10 Jan 2023 00:45:27 +0000
Message-ID: <6424005dd5706cc56a328f984598d922e74b32b9.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <6f9c0bc1074501fa2431bde73bdea57279bf0085.1670566861.git.kai.huang@intel.com>
         <725de6e9-e468-48ef-3bae-1e8a1b7ef0f7@intel.com>
In-Reply-To: <725de6e9-e468-48ef-3bae-1e8a1b7ef0f7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW5PR11MB5883:EE_
x-ms-office365-filtering-correlation-id: 3d4cf8d8-416a-4081-4c94-08daf2a3f774
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SDrj+ETJMb1aAm5WbdnJEjF5rvp4fcHtWQcmZQRzatzB53l6vwzXaSlC7vgcunyp9KfhLzgUJfc8o6GJ9HldnnoAP/VihdW0cTpChCgEpOu9WjuDgqOPkySDf34E/2JVPMW3lL3DxV4ny5oTT3JPBeyqinc4myxBuziu718AE+oxe7T71G+m3iWkBRG8L/MgojJIgri1is3ZoNDyA4eR6djbGXLs3+iJGQAblRiCfDcJFfRZTi4sZLtg1OvrfqimBEruYcOjykVhUb3rPCuZilCJN15j/1xvsI2ETyY6MoJNZcXL56oBqibmS0IFqmOo++yYUMvjO0F/stG/CAVdGFPnaD4pBciWsdxwZHgQdaTG96ueiF35nfeK+yc67oWiYu2pURR89tN3GTXf7J3ecVbXw1PtfnuKbZqk9oiOHpvaBR0EZqdtRlDDocOHYWsUBn7cfjgMMO3bg6yjJbuFKu7a8GLeQuEaQsbMUPCBMHmWcBZSyT80uXsqOA8O97YNBdqe6YTtEo4DpTnrOhWrv+4lBW28G1zQuQxfejeGeQs3403Vm8P+9pxbLAwblOh/YswruTsu7XvJo3zlZ3I34fJoTUX4xfOwRZqqzF5CLivaIeTnlPTSylVPbTnj/zI20s/0e9f1T6wvvgxWPsI4S+OPaTLO4AeTorw/bcf9s0idv84H8eHEd9OwUpC9Qf/NBmg0hyTMNYck/KGMNjXeMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(83380400001)(2906002)(54906003)(2616005)(66446008)(66476007)(64756008)(66556008)(7416002)(5660300002)(66946007)(53546011)(122000001)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(82960400001)(76116006)(38100700002)(110136005)(8676002)(41300700001)(6486002)(38070700005)(86362001)(4326008)(91956017)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTRIQm9GWnBsSDV0VmEvWlAxeGRBVlRpTm9tNjlCNlRxWjhVSEYveW5Vc2sv?=
 =?utf-8?B?QVhwb29wNnEyTk1EdmRBVjhZNHdtNDhIcytJSjhNUDVNMWIxUFAyNFpVa1FS?=
 =?utf-8?B?NFVRSkJyTVh0SVkxM1pGd2NDQ1dMc3k2dENDanlodFNnY0VCbG5qWUttWFBi?=
 =?utf-8?B?N1krK3M5R1ZCMWN5UHFuK1hHM1JQSDJLZjBkbGRTNG1TTDd3aXpDTThJK2pR?=
 =?utf-8?B?VWdpZzhkcDRzOEIzeVkzS3lBeCs5STU4d09pSWdHNkRIRVdQU2VvUEhFSHpy?=
 =?utf-8?B?ZDRESndYRTN3UU5qNVN2WXJCYStOTW5tclV3eVd4RzU3RUo3WDByM3gwbExS?=
 =?utf-8?B?TUJhQWtldlhDN1RkNWNJRXNXR0pnVU96V0JLUEpxVjcrRXNiQ0ZzUTYxWUxD?=
 =?utf-8?B?dk02NVlJMWE2bXNqNGhKYTNjeFVGUjNxSlpCdjJ6MTVJZVhUSmVuS3BZMlM5?=
 =?utf-8?B?Yi8rMXJKQ0tzYVAzWWJ5dVBtbGEyQnQyTDFxWWk2dUhKMllOL3YzN3FQb3di?=
 =?utf-8?B?OW1DbTBGMnFUVkgycWhJRnJzOGd4Q0Z3cDhYbm54Z21icnk0NmxDekFyTDR1?=
 =?utf-8?B?eU9HS2VLVlUyOWRGbkwvZUdvQ0FhT08vSFVBNDBudy9GcnB6OWxyTnlaQWdK?=
 =?utf-8?B?VWk4UlVZUXpYa1hSb0pCVXo4ZWVTaGZMYjJDamlJOUkzdXFJbjhicE1Ha1hF?=
 =?utf-8?B?NUNZNHRKV3ZDMnFsZHdxZWNjTXBCTXJxeHBZUGNuOUZVUDgranh5SktvZ1Nl?=
 =?utf-8?B?Z3FkRzVVL3JnS3o4NjhNUnJZS1MwbXFnQlVoYkNYOXMvMUw2ekl4Q2JDUTk0?=
 =?utf-8?B?OVg2TnZHV1M3N1J3T0tNckZGNW1Bdjc2TUJmVGhIVTl4YzNFUUI5Zm0zdE0w?=
 =?utf-8?B?R3hMS0FUZlh5N0M2WDUzQUR5UjcyeFhVNTl1MjMxMjVFTUhHSGJqRDhMZjhu?=
 =?utf-8?B?MjJHUDlwWHgwWkNSOWwvRDFTbkgyaTZGdmJZWGxBaHh2Y0FKbkU4d1B5Vnhn?=
 =?utf-8?B?VzlPT2FlWlpJYW12OWhMTG9kYVFVRlczSFBDdEwyTGFQcmpUbkdnaDFwelEv?=
 =?utf-8?B?YnEvQ0VKOXQvVTBnZW8yanltVWRXSzJnSCtaME9rUUVXTG5MQmUrb0RSWmR1?=
 =?utf-8?B?ckNJUmM2OHNRUEI4U0EweHo2S2kvQ3FZUG5NaVIvRjNSVUx0RTAyRUU1U2Ir?=
 =?utf-8?B?QzhLWUo3SlZ3cFRqeXM5SktFb3pIRVJ1aGFkTy9yaHNPYkVmZFFIUXhKcFJD?=
 =?utf-8?B?OVhrZkptRmFIWDJLQVl3ZkRNRTVrcUNjRkl3TU8xUXZoU0dtSUVpSkI1NXlw?=
 =?utf-8?B?R0FvemEzZUV1L2ppcTdpR0JIdTNDUnJ0VFkzcFZvbVFBOUViMmpUcTk3eXd4?=
 =?utf-8?B?ODAxYmhkOVZteWgwUzlTNEpQaHZQMWdiUTRWMUYxTzQwT0tVaVNqRHJhNEs0?=
 =?utf-8?B?cW42YXl6SlJYdUJxNnI3djgyQlJyT3h0YmlrMkVPOFY1SzBwcU9GQzRBTFE5?=
 =?utf-8?B?eWluQjl6cGlnV3diYmdJTlRISDhBaVVOYzc1aDY5eEpxTWRvS2I1UWhiU0lU?=
 =?utf-8?B?OXlwVjRzS1dOWm1teWswUnExQ1VsUG82eUNpZDVxc2FONkhLQTFldGlRdFg1?=
 =?utf-8?B?cERhbUxkYWlZc3RwOG8way8ySkR5aktNUnY3YkIxOHNBeFhBbmR2VnpqY210?=
 =?utf-8?B?UVNRRlhkVS95TXdpQXBKRDVkS0lQS1kxQnRxM2lJbnoxbFV0ZlgwQUVzWnZs?=
 =?utf-8?B?TStuSkRXMDl2VWpVVVFlWUUrTWxtVGZFWDh4dThVSUFaMncrcVFYa1NFUmtD?=
 =?utf-8?B?VGFZS0dHak9KUFk3K1VWSFhiMUVzYXdXK0Jkbm1LTDdLMHRFOS9YU2ZoWGkw?=
 =?utf-8?B?dUt5eWhKMTZkWlc0RW5VVlZMR0ttQ3c1RjhxWFU4Q1RnQ0tpbGF3V1h1ODQr?=
 =?utf-8?B?TjRxZDIzZFNES202UHBaZkpHOVdhempsS0xyeVZsWlF5N29NVU5Za1VaNWk0?=
 =?utf-8?B?UjJzWUpIVWlEUUk4OE9nVHhPOGcrL3M5MnZubm5ZL2JvdDE1bEF3d3VRb2xV?=
 =?utf-8?B?azkzbE9WdkZ1dW9qWEdzTDBCc1JIR0xDQi9FR3pBdkZIdDlnTmdNcEM1d0F4?=
 =?utf-8?B?bmsvSXNPMlJteXFEbU1CbjB6SDR4b3k0L21lMzk2MXFPczJZSUxBdVV1c3pQ?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEE75D34C318C14F913D0DCAB61D6B6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4cf8d8-416a-4081-4c94-08daf2a3f774
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 00:45:27.0906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1JBCZI9qm1qCAKWKRlxwN56ldrGia+3eH6VSKw4df5NVK1JDEbv6OosZYauxpYFDOmgOHO95rVK+0wvVsFWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5883
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDExOjM2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFN0YXJ0IHRvIHRyYW5zaXQg
b3V0IHRoZSAibXVsdGktc3RlcHMiIHRvIGNvbnN0cnVjdCBhIGxpc3Qgb2YgIlREIE1lbW9yeQ0K
PiA+IFJlZ2lvbnMiIChURE1ScykgdG8gY292ZXIgYWxsIFREWC11c2FibGUgbWVtb3J5IHJlZ2lv
bnMuDQo+ID4gDQo+ID4gVGhlIGtlcm5lbCBjb25maWd1cmVzIFREWC11c2FibGUgbWVtb3J5IHJl
Z2lvbnMgYnkgcGFzc2luZyBhIGxpc3Qgb2YNCj4gPiBURE1ScyAiVEQgTWVtb3J5IFJlZ2lvbnMi
IChURE1ScykgdG8gdGhlIFREWCBtb2R1bGUuICBFYWNoIFRETVIgY29udGFpbnMNCj4gPiB0aGUg
aW5mb3JtYXRpb24gb2YgdGhlIGJhc2Uvc2l6ZSBvZiBhIG1lbW9yeSByZWdpb24sIHRoZSBiYXNl
L3NpemUgb2YgdGhlDQo+ID4gYXNzb2NpYXRlZCBQaHlzaWNhbCBBZGRyZXNzIE1ldGFkYXRhIFRh
YmxlIChQQU1UKSBhbmQgYSBsaXN0IG9mIHJlc2VydmVkDQo+ID4gYXJlYXMgaW4gdGhlIHJlZ2lv
bi4NCj4gPiANCj4gPiBEbyB0aGUgZmlyc3Qgc3RlcCB0byBmaWxsIG91dCBhIG51bWJlciBvZiBU
RE1ScyB0byBjb3ZlciBhbGwgVERYIG1lbW9yeQ0KPiA+IHJlZ2lvbnMuICBUbyBrZWVwIGl0IHNp
bXBsZSwgYWx3YXlzIHRyeSB0byB1c2Ugb25lIFRETVIgZm9yIGVhY2ggbWVtb3J5DQo+ID4gcmVn
aW9uLiAgQXMgdGhlIGZpcnN0IHN0ZXAgb25seSBzZXQgdXAgdGhlIGJhc2Uvc2l6ZSBmb3IgZWFj
aCBURE1SLg0KPiA+IA0KPiA+IEVhY2ggVERNUiBtdXN0IGJlIDFHIGFsaWduZWQgYW5kIHRoZSBz
aXplIG11c3QgYmUgaW4gMUcgZ3JhbnVsYXJpdHkuDQo+ID4gVGhpcyBpbXBsaWVzIHRoYXQgb25l
IFRETVIgY291bGQgY292ZXIgbXVsdGlwbGUgbWVtb3J5IHJlZ2lvbnMuICBJZiBhDQo+ID4gbWVt
b3J5IHJlZ2lvbiBzcGFucyB0aGUgMUdCIGJvdW5kYXJ5IGFuZCB0aGUgZm9ybWVyIHBhcnQgaXMg
YWxyZWFkeQ0KPiA+IGNvdmVyZWQgYnkgdGhlIHByZXZpb3VzIFRETVIsIGp1c3QgdXNlIGEgbmV3
IFRETVIgZm9yIHRoZSByZW1haW5pbmcNCj4gPiBwYXJ0Lg0KPiA+IA0KPiA+IFREWCBvbmx5IHN1
cHBvcnRzIGEgbGltaXRlZCBudW1iZXIgb2YgVERNUnMuICBEaXNhYmxlIFREWCBpZiBhbGwgVERN
UnMNCj4gPiBhcmUgY29uc3VtZWQgYnV0IHRoZXJlIGlzIG1vcmUgbWVtb3J5IHJlZ2lvbiB0byBj
b3Zlci4NCj4gDQo+IFRoaXMgY291bGQgcHJvYmFibHkgdXNlIHNvbWUgZGlzY3Vzc2lvbiBvZiB3
aHkgaXQgaXMgbm90IGJlaW5nDQo+IGZ1dHVyZS1wcm9vZmVkLiAgTWF5YmU6DQo+IA0KPiAJVGhl
cmUgYXJlIGZhbmNpZXIgdGhpbmdzIHRoYXQgY291bGQgYmUgZG9uZSBsaWtlIHRyeWluZyB0byBt
ZXJnZQ0KPiAJYWRqYWNlbnQgVERNUnMuICBUaGlzIHdvdWxkIGFsbG93IG1vcmUgcGF0aG9sb2dp
Y2FsIG1lbW9yeQ0KPiAJbGF5b3V0cyB0byBiZSBzdXBwb3J0ZWQuICBCdXQsIGN1cnJlbnQgc3lz
dGVtcyBhcmUgbm90IGV2ZW4NCj4gCWNsb3NlIHRvIGV4aGF1c3RpbmcgdGhlIGV4aXN0aW5nIFRE
TVIgcmVzb3VyY2VzIGluIHByYWN0aWNlLg0KPiAJRm9yIG5vdywga2VlcCBpdCBzaW1wbGUuDQoN
Ckxvb2tzIGdyZWF0LiAgVGhhbmtzLg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBpbmRl
eCBkMzZhYzcyZWYyOTkuLjViMWRlMDIwMGM2YiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMN
Cj4gPiBAQCAtNDA3LDYgKzQwNyw5MCBAQCBzdGF0aWMgdm9pZCBmcmVlX3RkbXJfbGlzdChzdHJ1
Y3QgdGRtcl9pbmZvX2xpc3QgKnRkbXJfbGlzdCkNCj4gPiAgCQkJdGRtcl9saXN0LT5tYXhfdGRt
cnMgKiB0ZG1yX2xpc3QtPnRkbXJfc3opOw0KPiA+ICB9DQo+ID4gIA0KPiA+ICsvKiBHZXQgdGhl
IFRETVIgZnJvbSB0aGUgbGlzdCBhdCB0aGUgZ2l2ZW4gaW5kZXguICovDQo+ID4gK3N0YXRpYyBz
dHJ1Y3QgdGRtcl9pbmZvICp0ZG1yX2VudHJ5KHN0cnVjdCB0ZG1yX2luZm9fbGlzdCAqdGRtcl9s
aXN0LA0KPiA+ICsJCQkJICAgIGludCBpZHgpDQo+ID4gK3sNCj4gPiArCXJldHVybiAoc3RydWN0
IHRkbXJfaW5mbyAqKSgodW5zaWduZWQgbG9uZyl0ZG1yX2xpc3QtPmZpcnN0X3RkbXIgKw0KPiA+
ICsJCQl0ZG1yX2xpc3QtPnRkbXJfc3ogKiBpZHgpOw0KPiA+ICt9DQo+IA0KPiBJIHRoaW5rIHRo
YXQncyBtb3JlIGNvbXBsaWNhdGVkIGFuZCBoYXMgbW9yZSBjYXN0aW5nIHRoYW4gbmVjZXNzYXJ5
Lg0KPiBUaGlzIGxvb2tzIG5pY2VyOg0KPiANCj4gCWludCB0ZG1yX2luZm9fb2Zmc2V0ID0gdGRt
cl9saXN0LT50ZG1yX3N6ICogaWR4Ow0KPiANCj4gCXJldHVybiAodm9pZCAqKXRkbXJfbGlzdC0+
Zmlyc3RfdGRtciArIHRkbXJfaW5mb19vZmZzZXQ7DQo+IA0KPiBBbHNvLCBpdCBtaWdodCBldmVu
IGJlIHdvcnRoIGtlZXBpbmcgLT5maXJzdF90ZG1yIGFzIGEgdm9pZCouICBJdCBpc24ndA0KPiBh
IHJlYWwgQyBhcnJheSBhbmQga2VlcGluZyBpdCBhcyB2b2lkKiB3b3VsZCBrZWVwIGFueW9uZSBm
cm9tIGRvaW5nOg0KPiANCj4gCXRkbXJfZm9vID0gdGRtcl9saXN0LT5maXJzdF90ZG1yW2Zvb107
DQoNClllcyBnb29kIHBvaW50LiAgV2lsbCBkby4NCg0KW3NuaXBdDQoNCg0KPiANCj4gT3RoZXJ3
aXNlIHRoaXMgYWN0dWFsbHkgbG9va3MgZmluZS4NCg0KVGhhbmtzLg0KDQo=
