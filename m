Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DDF6A7FEB
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 11:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCBK0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 05:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBK0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 05:26:50 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A15F1C7DD;
        Thu,  2 Mar 2023 02:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677752809; x=1709288809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8+kFNUfz0o70YXrzm00qd9nC6GGBv3dv4TXTkrILlrs=;
  b=gaw+Yin/LKhodC/PxcK8BmRfbbdOR66Du4KVzQ2td30Zpr3ZO61aUm6C
   fhuQGHKQmnoW52dORyKmXjR1YKum49ld7hg/FXAMgh8apeEzsHdKeLOba
   suApjDsSuKewp1p8D4oE2gojXrHECnSu5Bz0iGzTN49sLeBSQuoN9/EYX
   OCm+CcmKV01b2/wCMinTegSG+Ehkjmr/LvaBV85niZcTQU0BKb/l2/DVI
   VvllkROoy1X2HNujyMyit0STfb/B8aCew/W94/MeWCnGSouu8gokx/z+R
   D/fzyjUmMpEBsAOO/BtHtmNz0jwoKsbD5cGOokFM0AVSk8enEcgmkdvnD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="314346483"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="314346483"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 02:26:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="798773808"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="798773808"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 02 Mar 2023 02:26:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 02:26:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 02:26:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 02:26:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrilJ4iyJ3TwZoJH48GQ+ws+ZJYiuV+Bf1enYnOCffv8n794coPlhps+NNT2OM/nAFOCuh4t652RzSxjDHkmmKY94/NXbXyRVhCa39lKdN70jnNM4OGwQzjhmeLl284nBk3OCEaW3epXy59QcOu1BtTfS2WroMfXCLFNmwo0lfhQ73CmF5jypgQ8NfaCaTz3dqOOlt1taBn8yEuDS8aq7nok9zB4mrSXb5y6EhIOs4ppa9z5TTndFezWqrgI6qVhPgIcgL7QkCv1yN/pmDMm6yCc2gaRTDUMZSvMDxejjZVHGcXicBnzHHMJ3/1XzIy3Q39srkcrSqcfW+CK+lHdAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+kFNUfz0o70YXrzm00qd9nC6GGBv3dv4TXTkrILlrs=;
 b=TTKe41M7FJ1JDa8zYQ71sNBUA5Nb+rck7X/LzCpQaB/HdUaIdpVMaaCo8myrxZbOxxoCmrohL/y+7tbviWK9PHA57CpRzWQ5c/NjGT454D06kwgwQZl8cTk2E59QKaxH+mYaUGzulKShdFM2GPwcMrxYnGO7AW6a7d40YSTTFGX39fT74PfIj5y9rAr64j4Xrphmm7VO/ofcLCFGC2JM1zmIOjsAtyia3NJOIDDcmiVK/ecLxYI5Lf4kOUkuZnbNEoKfceJxUaXLd8UcWFo2/X8AFxECZvI5A0+1uh5JOqfGx1YdIqWZJUOXjK/6hJRFfrTf2F24Mpe5mOQ0ygoK1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB6572.namprd11.prod.outlook.com (2603:10b6:303:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 10:26:46 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 10:26:45 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Mingwei Zhang <mizhang@google.com>
CC:     David Matlack <dmatlack@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Topic: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Index: AQHZTEMoO+JAZhQRUE2mrtrpaO2QJ67mVMSAgABZTgCAAD+sAIAAV8fg
Date:   Thu, 2 Mar 2023 10:26:45 +0000
Message-ID: <DS0PR11MB6373DAA05CEF9AB8A83A6499DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
 <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZAAsIBUuIIO1prZT@google.com>
In-Reply-To: <ZAAsIBUuIIO1prZT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB6572:EE_
x-ms-office365-filtering-correlation-id: 5855a69e-cc14-453a-7428-08db1b089fc8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6IGVMubebzceW4k1gCx8/xvXzGYthQQqAkNk2ZuUlLFkrlzW4nkArpsy/2IugJMhJ4YM0d8j9sDz2wFVkikWtN1C7FK0MavQAT8EdFSmAoHTYqJkFncB5nLfg9e6/XAKYgQntM8/tCU33OKW0/kPblnaGITJZkoYWfoEIeX9Phvw1zpQjAAoDD1BTGRvqfZSWDfwDiiSYEqoApLDPD8KjFeiqsE8lKBBfhLfDhQ+7iYKBDu3XpEQOjGoPjdWrmx0UzkhGljpCei2op7W+EBLImSjUpcvRJMPnh0yK5sqKE44NZnJKTKEDGg93HjkHSP5jtxdSpHKV8YIfLXG0talRrBQjfqzahsHL19hK7CBeB6jN3czmhlEJb1uJOuIjdZAUXpG2zhtXwCpu6Tn+dY9zReQtSohmbBnZk+YTCJdHoKC7g7ouoSlfhdOIY5NUCDYH0+IiAD82WrUN+45AOXhfh7D9trjlH9aKHYz7t3UVQFXVHdnR8N4PCw4tua8UAnqEaBJrDcDaNjaM70XDH/7WJLEd3YJwzDsWbMdwMBCmOO+eoWvS5AzqKSr61E+JlLmxEIZ6onMUliBnA8GyZwSNoi16kbAmID6VSToDrx7bfRPsJFMXmd7UdVYNMaK/vqDNBFwxWDj1tGv9lNPBWUJnVrvx8rXgKhPS07/fOmeTJnuPIuo8MQkT1bjk5Ckaz0FUKLgaURXZuUual5NnF1Dag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199018)(52536014)(53546011)(6506007)(186003)(26005)(9686003)(316002)(41300700001)(54906003)(76116006)(7696005)(6916009)(66446008)(8676002)(4326008)(4744005)(66946007)(2906002)(64756008)(8936002)(82960400001)(478600001)(5660300002)(122000001)(38100700002)(33656002)(86362001)(71200400001)(38070700005)(55016003)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDFzZHJLL0hXRjV4dHZqc09CclVxYjBlMm55aTdoN1ErVmRvZ3ZRQTlVRzVk?=
 =?utf-8?B?OVZwWWdQaWwzSWR0emc3bHEvVmhGb3FLWjZjSmFWWWZ3bzJzcGYxYUVsaVEz?=
 =?utf-8?B?N05iUmU3Ukk5QVFoN3NIbnQ5L3UyUnU4bGowOWJtMFJvSUZPb2JPeTBZMjYy?=
 =?utf-8?B?VDFCcG9Zd281eVBCK0NKQm83S0J0MXJvaWVIK3BZUnpPT0laS0RPNGN3ZTIv?=
 =?utf-8?B?QzdKRnFJVGpUVm1wZU9jTDdQcDdoOVhFanBtalVtK3VjUHFkSWtySk40UEJl?=
 =?utf-8?B?a21YVWYrVG1qZFljdU45a1p4eTFsU2U1KzBBS2ZnNTZ5ZVdWSlZDeDBYN1ha?=
 =?utf-8?B?TDdVSC9hdk4wWWhSQmh4K0t4Q1BVekU0dkgvYmY1dmUweFBPYzJRcGhCUnQw?=
 =?utf-8?B?NnVlcUh2andRQ0RhOTJtdVlZVi9WYnBpS25PMEFkWDVENFdOeG5YRDQ2UVVB?=
 =?utf-8?B?dFFjQU9DSTNjU2liQmxBc01wNXZreHFHY0FlSXo4NXgyYlJkSS8rd3FhKytP?=
 =?utf-8?B?WC9ZSWpwZ2IrTTRML05sbUVHcVNHMVJrSUN3cTNLVi9pdWphdWxlb0lGbjE1?=
 =?utf-8?B?QVR3VnlPdisvWmZFRlY3Y3k1U2E0MTFuUFE5aFlOZ0EyY2hGdFRNOElzaEsr?=
 =?utf-8?B?TVE4cng3NUNyZ05PeDg5L2o4SWJjTmVwb0JYWEVtckQ2WmFDa2tJaFpkVVNn?=
 =?utf-8?B?MjF4b3F5VEsyczBxZXZEVGZ4bjdvT3V3bkdTUHdMbjNqWlNNR2c1ejgxYzhH?=
 =?utf-8?B?eUFwdy9GcVFZbEF3VElYNXpwR09TbVJFUnhKek1rc09pWVFQeGJQSFZvaXlm?=
 =?utf-8?B?c2ZSaDFmWGpmaGRSMkNnVE1ucWRXbHRLWjlBS1BJbzBYSWd3YjU3SUE1WUVJ?=
 =?utf-8?B?R3ArUzJWUVRpYndZQXRaU0lrb1VJOCtNVWdDR0xpSUxKeDhGb1R5TnZrb29r?=
 =?utf-8?B?dkxDc0M2Ty94YTlBYU1jY0p6bkRIeUZEZHpBc0M4M0JINTZ2dVF6UXJFaTN0?=
 =?utf-8?B?Vm5zdWNCZ09kdlVBK28zeW9BM2c2VEl3S0FnM2R1c3FvRS9sRkcyTzNUQ0tr?=
 =?utf-8?B?eXlvVGQ4R3NLekZKMi8rTFBJeHNVRmhGbU5hb3l5OTRuMW1mbFZOWnRKQlY2?=
 =?utf-8?B?SGhCNUVMVkNzY2V0NnAwc095djFoME83N1B4S0VYNC9wK0ozS2ZlUzdMQmlF?=
 =?utf-8?B?MVc1U05ZYldHdmRpcHVJY24yK2x1a0VsNjRTV0NDMlI2V1ZDZm9kZXdaZFAw?=
 =?utf-8?B?ZmhkWkVCTWhobjNJblVmYlZoWXJ5UVlObjU5SUlQeWpiTmV4T1BXV05tQ2VN?=
 =?utf-8?B?SE5uTTNEYXBxQVVhUklqNHFCN3JJUjI0bjNSRVJpMFQxWFZuZXFmQzZkYnBq?=
 =?utf-8?B?RUo0Y2k5YUllWE9oNThLYUpndW11akJvWk5PaGZUc3JJTEI0SS85NDgxRWo4?=
 =?utf-8?B?c2F4L0RiaCtpa2N1d3VVWUdzRGZyTTYwYXluemkybStSTXJmZTdIQjJLZDg4?=
 =?utf-8?B?R3N6cndzZDd6Z2trZi8vekdjY2tsOVVDUDc4ZG0yNHBuMmQwTWlVUTFmUWhN?=
 =?utf-8?B?WG9yOHZ6NE1WenJKcGE3eHNrd2x5bkRONE40djJYN0tQMVVvZEQxNGl4YU9j?=
 =?utf-8?B?K2VBT0dvTWpWMGJEVXNoM1VFV1RvY1V1MFMrRkJrS3RXalRLWFAzalo1Vi9U?=
 =?utf-8?B?aWVuNlpoa1hkSjd1TzFoVWppRlZyYmNmQXZscEx0RFVnaVZ3L0NpTTZaZ2ha?=
 =?utf-8?B?aTJrY3BWVEk5bHluR1J6cEV1eWgyaGNyaVZ6M0JwODZIQlp2YjNCUU1QWHl3?=
 =?utf-8?B?YVpOc2J4N2RsWFo5d3crM2xJRkM0b0RFc1M3RStmeER0UXVwWjZCTEFpQnN1?=
 =?utf-8?B?T3ErVnlsSnlnNzlKS2hmMVhFMitXRGF3RkM1NWhLbGJEMHN4cFViUFlOa3pY?=
 =?utf-8?B?bG9iSDkySEU5bnVBZjZYRWZROWVleUg2YzZTb1NYR0grLzg3UlhWZ2dyMitv?=
 =?utf-8?B?eVl0NWNzbGZTV1JvL01qcFZoYlErQVRKZkk0U0VSUGtUZmdsdWhaUTNGdXhD?=
 =?utf-8?B?ak8zOGVvdzMxY1VZQ2VVNWcyYnVRSENpSTVtb3B4Qmh4U1BNelE3VGNnMGZm?=
 =?utf-8?Q?2Gr9H11qZzOGDfATLOxfaBxvO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5855a69e-cc14-453a-7428-08db1b089fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 10:26:45.7303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fiq1SlH6twW4J6EIiHcRLKv99s+DdbdxgNoGrxnaaTP82Iv+hJO1Eiubzr8NtTweDZlvRuIB1WgUARHwOO1CiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6572
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnNkYXksIE1hcmNoIDIsIDIwMjMgMTI6NTUgUE0sIE1pbmd3ZWkgWmhhbmcgd3JvdGU6
DQo+IEkgZG9uJ3QgZ2V0IGl0LiBXaHkgYm90aGVyaW5nIHRoZSB0eXBlIGlmIHdlIGp1c3QgZG8g
dGhpcz8NCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNs
dWRlL2xpbnV4L2t2bV9ob3N0LmggaW5kZXgNCj4gNGYyNmIyNDRmNmQwLi4xMDQ1NTI1M2M2ZWEg
MTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiArKysgYi9pbmNsdWRl
L2xpbnV4L2t2bV9ob3N0LmgNCj4gQEAgLTg0OCw3ICs4NDgsNyBAQCBzdGF0aWMgaW5saW5lIHZv
aWQga3ZtX3ZtX2J1Z2dlZChzdHJ1Y3Qga3ZtICprdm0pDQo+IA0KPiAgI2RlZmluZSBLVk1fQlVH
KGNvbmQsIGt2bSwgZm10Li4uKQkJCQlcDQo+ICAoewkJCQkJCQkJXA0KPiAtCWludCBfX3JldCA9
IChjb25kKTsJCQkJCVwNCj4gKwlpbnQgX19yZXQgPSAhIShjb25kKTsJCQkJCVwNCg0KVGhpcyBp
cyBlc3NlbnRpYWxseSAiYm9vbCBfX3JldCIuIE5vIGJpZ2dpZSB0byBjaGFuZ2UgaXQgdGhpcyB3
YXkuDQpCdXQgSSdtIGluY2xpbmVkIHRvIHJldGFpbiB0aGUgb3JpZ2luYWwgaW50ZW50aW9uIHRv
IGhhdmUgdGhlIG1hY3JvIHJldHVybg0KdGhlIHZhbHVlIHRoYXQgd2FzIHBhc3NlZCBpbjoNCnR5
cGVvZihjb25kKSBfX3JldCA9IChjb25kKTsNCg0KTGV0J3Mgd2hhdCBvdGhlcnMgdm90ZSBmb3Iu
DQo=
