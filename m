Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7596F665998
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjAKK7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 05:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbjAKK6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 05:58:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5745FB7;
        Wed, 11 Jan 2023 02:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673434683; x=1704970683;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JgXPcyroUrvK/IHVUlD5Wzgf7LgRKDRvsvYbu0j17Yo=;
  b=G0rRJUmTgLACIwUvvjcs3OFv0ReETuNtd9KpDoGtj7jmw2pr6e4enFO3
   jw1XGldJbBbQnoJgz9fEdyp2O0nTL/r3DSApWZcdl67VnfOAEZ3d5axpB
   IxotlRMrgPr4OLHCygZbnfJQtQrkJbpekSHv/91SzKjgRgGfZhTSR7aYm
   M0yHMmQV+hLTJK8+oc3Ny1miawhcWwmvhkiMx/DL1dEiouj8Y1XKESqTU
   kNjS679gUFRorS0/hO0LqdTVUFLwYgrERsXdE1AnvhyoyK+Tes/+53xXY
   lg5BYTfmt514ppZqMj4RV4LjWy2G7PcaV5RbYGDHNEOBfexfd5+IyVZzv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="311193864"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="311193864"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 02:58:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="689728518"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="689728518"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 11 Jan 2023 02:58:02 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 02:58:02 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 02:58:02 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 02:58:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NO7Z1e9eNyaNeDKKVpRm+wdJgYP0bMzJQjM7jfb7WzRs59QavC7HfBGQDZFwAay3Nr9ALhK0v57JaPg3AFyVUtii4QBM4PX5o6rp3Bo90q4Nxfg4kiRG75rgz5cmGKSoLDyNcrOVsK6kRiphCU0JyjCsGpttppYD7gn7wmFHDtSpFxForOXkhJBVu7o3pKbI9MqTAimYKEiiqeVwuSOWp1LqrKfYsB4xgb/8Azu2EEr7CTuiZNG82/TeEzvAwSeC7ooXlfiohoZ2+gCPaP6WuAV7odRrmcrPms9zaQ1DEFsBJqOzaSZDK/wYoQijuPFy0fUDZpfPc8A8fGwkSHeMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JgXPcyroUrvK/IHVUlD5Wzgf7LgRKDRvsvYbu0j17Yo=;
 b=GcNoxP8KCrSXX7C6Y8bskHIdLCNCwSRZpB0hbpnaSq80ngAc9wnImsaZP/azH/dCz8TFu7yoA9GBRysakvrp7li1R5AVUEqXT56tDjqswoh3m/0g+EQXJ787fX6OJyo+yY+XGGCEy81yiUngXT8shwSci64p8pBDtS6r7fh9ueLb7ReaMVVdbjQh2T0+qjm6xgMMYffesnzjq73UE+PrTOhL5Qq/zX6D10kFnZqL6bwQdxlrXSmKnK4OzrzbNkq3ZLbgOiCU7bGQI92ZsqHiQrzGqHjW8xRyYiz3B4SmUbkd5srQZlW7zywUds2uspwSHs09w8bKvg2UOsXe7InRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS0PR11MB7928.namprd11.prod.outlook.com (2603:10b6:8:fe::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 10:57:57 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 10:57:57 +0000
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Topic: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Index: AQHZC5gQ3FCTeDpWDE6DayveLyjo/66SH22AgATsd4CAAADVAIAAoeWAgABIIwCAAUktAA==
Date:   Wed, 11 Jan 2023 10:57:57 +0000
Message-ID: <a7f8c807df3bbe1923f21e30817b23e785776260.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
         <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
         <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
         <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
         <24ea02aa4db7d470adeb7a64b7692d8bd5a428ca.camel@intel.com>
         <3bfe283e-6a90-54cb-1ba2-45ce6d022206@intel.com>
In-Reply-To: <3bfe283e-6a90-54cb-1ba2-45ce6d022206@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS0PR11MB7928:EE_
x-ms-office365-filtering-correlation-id: 6369ea0d-3a24-46b7-4b71-08daf3c2b2ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 86PqT8PEDAwBJDOH8ziSGUcOeqe2RDUQ0rZI/90LqvKHXlcDyKYBS34D5fWBKPdg37XcWrFUzFY8JwcJ5xQEUxSFEUAzAxMhCyVvw01AxkXYlgJqEegbzztYw4oLQ9Ljdy04y4+3ifJhsGDMuOs6vJKWHTHQH33Ub5V8QcCfVcfud7VDDKIMG+j2bmmPyP0UW3rJ2U7LdVlyrSCayDT/UjPqM6oVa/B058yhVAVmX4ZTuTuV2+i4lxs4ybIeFQpVJqHjg/Z25awjitAg34mVfiDq1rypDIEtel1d2nutm5nuR9ckDERluvaNn5/oqU1Q+a0Y+Pv+LvuGi1D2igTblHMBz8M8mEQjfe0i0kQWsHGUeOLx48P/vYgyN2nd9YY7HUGHMV6ns1M9dFl0Fi6Ga2Hz+XWzLgpOIhrs0PKq43JC+eZ0QrCRaXJDbG+HIhAOs6Qa7zWfRZkuFmw34zpX+q7QSvYIesB5Wsj6K0J8kW81J/MRUbdvPSp8tScjKtbodDkv63GNUHXrHLNXsNXTcW3el/hxpNA0sxPP3YaxG3AgI2Y0TKkTgywkeXmi+sbqIE0dAkQ/j4MrlztrpztlMCZqx9lHUmONSPyRL71tvfLVjzOkIiQmAssu47p+/UBKQmWniId4J60xaopg0oNyX1lGqrxH/yZRcfzDG/YkAAGJyYpwypt/ZzYb3AAWiLVhmIeCxVrABUpx4Os8czTP09h2u1Dq9XRRKFXMtfg5KyE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(6506007)(82960400001)(122000001)(38100700002)(53546011)(2906002)(6486002)(2616005)(38070700005)(6512007)(186003)(71200400001)(316002)(5660300002)(7416002)(26005)(478600001)(86362001)(8936002)(83380400001)(36756003)(41300700001)(66446008)(76116006)(8676002)(66946007)(110136005)(66556008)(66476007)(4326008)(54906003)(64756008)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFFNekJMQ3JRSFpnZzJFeVY1eEp5VDh5SjBKNk5GZ1gzRGdzUDNIU21ZNGNY?=
 =?utf-8?B?YklZNUpWYnozMGhBTkl4ZW1LSlNkM0NXaFVkSkJuZEVBZFVRT0QxWXdNRU5W?=
 =?utf-8?B?TDg3K3RTZXVwSERETXJLNHR3RkpTYk05QmFrMWw0d3NIY2IyWlliYUxYaGxN?=
 =?utf-8?B?bk4vN1VmWkJNVG1yTXNCcGNnTk9Lc0Vsd2pkaWlUeGgzWXFDOWdKeGt5Z0dy?=
 =?utf-8?B?SjM5VXY0RFpmSmRmUExTWEVIQ2xFQjFDQUlwa1dqOWxxcDRwU2E0c2ZKWW5E?=
 =?utf-8?B?TFRvRCtTV2puVDc1Qm00YmlTMFQ3ZHVJTEttczFkbENmNjR2VmhEdG1nbmll?=
 =?utf-8?B?dy94REs1YWdsTTkvTDVPVEI2UFBCVGl2c2htdUhYcDlmSmRMY1I5Y2d3QWR0?=
 =?utf-8?B?R0YxZ1loTHVBRHRlMjBTWm5OLzBsOFhydFRJdFpTTTFsM3czN3crS2dKanBQ?=
 =?utf-8?B?WlRpR2RBRDF0QW9Mc2lVK1FYWWFtbFI2dmxWc2R6d2IxSUdDMVd6SXR2STFq?=
 =?utf-8?B?MHBaK1RzbmpHSVA0amR6NHYrQWluTTRBNng5TncxcTM4UmxyS0NxdmZzVlds?=
 =?utf-8?B?R2o5VXhNak8xVm4vcHdtNWxWK0UwamE5OUFJNEFXK3hCbm9LbTA2S0JhU1Rs?=
 =?utf-8?B?UWI4WkhzUnVpbGhvMXpHYUxuK2kzWnFxa2xZZkZITyt2WUNLcVdkem45THZu?=
 =?utf-8?B?SXkxL1g3SzhlSmsvSWJFMFRFdnN2MXhZVmNDS0xQcmx0OGU3Q3ZyRjlyVTlP?=
 =?utf-8?B?bkNtQXFqbzdockdmSU85UkxCN29td3pPakJKSDdIZ0RNWXpCNytwQ1pWU3Z5?=
 =?utf-8?B?TDlhanBOam1RMzhBVFVoWjhLL0RQWlk4b21YbCtQREVpOFMwdmhmeUFLdC82?=
 =?utf-8?B?UjU4b1dFUG5GQVFDK05Xd1NCRmRCR3I1SkQxREljT1VEQmJWY0Y2a1paV0RW?=
 =?utf-8?B?UDF1SVdNWkZ3Ynhic29VUTFtcXphK1lTdE4wcXdSOEw4bElnaXp2UFlJbG1o?=
 =?utf-8?B?RUIyYk1NZkRuVktOQ3IvdU5KUkVzRHdJZ2dWaDR0c1JQVGJiWnRpME43bjBm?=
 =?utf-8?B?WU54ZFlOWjVDMFBqeWlKU1BsU01GOHBXd2ZSdFhoKy9CSXJMVlI0ZlhqaTZW?=
 =?utf-8?B?RWxLUGdOQXc0ZGFwbFo3bDNIVjRDd0t6MlloQTdTcGJ1Zks0MTI2Qmd1Yzdr?=
 =?utf-8?B?VGRNZUovVDJjOExXcGZyS0Ixb1hFMjlzN2c4YjdCemNreVhDeFI4VTQyQ2x2?=
 =?utf-8?B?bDFycTZacFRUTlhEU0srdSt6QmdZMnVwNWNrc2d4cnVoYTdQRi9ETlBPZDVw?=
 =?utf-8?B?S3JyWHV2N2ZrTENzM0luamtiZmlmR1pQT1MzMFAwM2lTZmd1M1lUendiMERh?=
 =?utf-8?B?U2JrNGhNcWc1UkdMVXdFWk4xZFJYQUt5MWZrWFV1VHBDMnB0QUYyTXpWVC9y?=
 =?utf-8?B?OEdUamFjKzRObDdqWHd5TVBlcS9uK2xrVGFIbkhLcmZ1ZmE1Z1dsczZoUTVz?=
 =?utf-8?B?TXlicEdpaU9xNHhaMEp2NWtBNGtSei95YUkxQUR3SmF2bG9WK0JjL00xSEc0?=
 =?utf-8?B?S3VsYUI4czNLQkNiZ3BNUzVjOFllNTBvRHR3QzFmNVhNR0tMdml6L1dJMVVZ?=
 =?utf-8?B?S3J4eWl3dExRcktmajdjNVBWT0JPczFZWGE1MDQ1TXE1L3JSL1llMFNpZjI3?=
 =?utf-8?B?VW4xbmRuTUJiK1JoVEt2M0hxM0FvZ3ZxRVp6NEFsbmQ4aE5nVHhMdWhlL25q?=
 =?utf-8?B?MUZ5Z2pKSDBueDFwMHJsMHhXeFF1TlFXR2xvL21pazNvaUZnclVrNE1jK09B?=
 =?utf-8?B?QkdnSWhtem9GSHgra2gyN1AxYVllb01FRmVTb2ltV1IzZjRFOWdzak5Ob3M3?=
 =?utf-8?B?cUhpTlArTERjc3dOc2Ivekdud0RGYTZCSjdYVXhPMU5EV3BqMkREbUs3N2Zs?=
 =?utf-8?B?RG9IdjU4WFNSZGNrb0JlVko3QS80ZDJsZHU1emJpVEJVSWNFMWliblJpWFFs?=
 =?utf-8?B?YlgvQ0pLalQ3elRtbkNYeWlyVWRQZmF1MUgzS1daZFdjNHZ1OGR3SUdYUEpy?=
 =?utf-8?B?Z0E4UHFvbkR3TnZMcHZUVFpSV1hsNjdJcjNCbVJ6VHROaW1TNHpPWDJEcTlN?=
 =?utf-8?B?N2U2NHEvNXJyUXNuT25IU3dKN0pEU3ZHcVV4WXVvNDFNTjJlbDR1dXFaUW5J?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5F748A03FD70C4AAD9EEF6063918C20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6369ea0d-3a24-46b7-4b71-08daf3c2b2ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 10:57:57.2849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nolsBSrDTUTehVtDvPO7LOMIxU4jp8lIIg3rn4eFcRaFwo4P8eyIVx8KJN18jUX1KY9k5T4ZFJLN3J4BT74vCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7928
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

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDA3OjE5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS8xMC8yMyAwMzowMSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjMtMDEt
MDkgYXQgMTc6MjIgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gT24gMS85LzIzIDE3
OjE5LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiA+IEl0J3MgcHJvYmFibHkgYWxzbyB3b3J0
aCBub3RpbmcgKnNvbWV3aGVyZSogdGhhdCB0aGVyZSdzIGEgYmFsYW5jZSB0byBiZQ0KPiA+ID4g
PiA+IGhhZCBiZXR3ZWVuIFRETVJzIGFuZCByZXNlcnZlZCBhcmVhcy4gIEEgc3lzdGVtIHRoYXQg
aXMgcnVubmluZyBvdXQgb2YNCj4gPiA+ID4gPiByZXNlcnZlZCBhcmVhcyBpbiBhIFRETVIgY291
bGQgc3BsaXQgYSBURE1SIHRvIGdldCBtb3JlIHJlc2VydmVkIGFyZWFzLg0KPiA+ID4gPiA+IEEg
c3lzdGVtIHRoYXQgaGFzIHJ1biBvdXQgb2YgVERNUnMgY291bGQgcmVsYXRpdmVseSBlYXNpbHkg
Y29hbGVzY2UgdHdvDQo+ID4gPiA+ID4gYWRqYWNlbnQgVERNUnMgKGJlZm9yZSB0aGUgUEFNVHMg
YXJlIGFsbG9jYXRlZCkgYW5kIHVzZSBhIHJlc2VydmVkIGFyZWENCj4gPiA+ID4gPiBpZiB0aGVy
ZSB3YXMgYSBnYXAgYmV0d2VlbiB0aGVtLg0KPiA+ID4gPiBXZSBjYW4gYWRkIGFib3ZlIHRvIHRo
ZSBjaGFuZ2Vsb2cgb2YgdGhpcyBwYXRjaCwgb3IgdGhlIHBhdGNoIDA5ICgieDg2L3ZpcnQvdGR4
Og0KPiA+ID4gPiBGaWxsIG91dCBURE1ScyB0byBjb3ZlciBhbGwgVERYIG1lbW9yeSByZWdpb25z
IikuICBUaGUgbGF0dGVyIHBlcmhhcHMgaXMgYmV0dGVyDQo+ID4gPiA+IHNpbmNlIHRoYXQgcGF0
Y2ggaXMgdGhlIGZpcnN0IHBsYWNlIHdoZXJlIHRoZSBiYWxhbmNlIG9mIFRETVJzIGFuZCByZXNl
cnZlZA0KPiA+ID4gPiBhcmVhcyBpcyByZWxhdGVkLg0KPiA+ID4gPiANCj4gPiA+ID4gV2hhdCBp
cyB5b3VyIHN1Z2dlc3Rpb24/DQo+ID4gPiBKdXN0IHB1dCBpdCBjbG9zZSB0byB0aGUgY29kZSB0
aGF0IGFjdHVhbGx5IGhpdHMgdGhlIHByb2JsZW0gc28gdGhlDQo+ID4gPiBwb3RlbnRpYWwgc29s
dXRpb24gaXMgY2xvc2UgYXQgaGFuZCB0byB3aG9ldmVyIGhpdHMgdGhlIHByb2JsZW0uDQo+ID4g
PiANCj4gPiBTb3JyeSB0byBkb3VibGUgY2hlY2s6wqB0aGUgY29kZSB3aGljaCBoaXRzIHRoZSBw
cm9ibGVtIGlzIHRoZSAnaWYgKGlkeCA+PQ0KPiA+IG1heF9yZXNlcnZlZF9wZXJfdGRtciknIGNo
ZWNrIGluIHRkbXJfYWRkX3JzdmRfYXJlYSgpLCBzbyBJIHRoaW5rIEkgY2FuIGFkZA0KPiA+IHJp
Z2h0IGJlZm9yZSB0aGlzIGNoZWNrPw0KPiANCj4gUGxlYXNlIGp1c3QgaGFjayB0b2dldGhlciBo
b3cgeW91IHRoaW5rIGl0IHNob3VsZCBsb29rIGFuZCBlaXRoZXIgcmVwbHkNCj4gd2l0aCBhbiB1
cGRhdGVkIHBhdGNoLCBvciBwYXN0ZSB0aGUgcmVsZXZhbnQgY29kZSBzbmlwcGV0IGluIHlvdXIg
cmVwbHkuDQo+ICBUaGF0J2xsIGtlZXAgbWUgZnJvbSBoYXZpbmcgdG8gZ28gY2hhc2UgdGhpcyBj
b2RlIGJhY2sgZG93bi4NCj4gDQoNClRoYW5rcyBmb3IgdGhlIHRpcC4gIEhvdyBhYm91dCBiZWxv
dz8NCg0Kc3RhdGljIGludCB0ZG1yX2FkZF9yc3ZkX2FyZWEoc3RydWN0IHRkbXJfaW5mbyAqdGRt
ciwgaW50ICpwX2lkeCwgdTY0IGFkZHIsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1
NjQgc2l6ZSwgdTE2IG1heF9yZXNlcnZlZF9wZXJfdGRtcikNCnsNCiAgICAgICAgc3RydWN0IHRk
bXJfcmVzZXJ2ZWRfYXJlYSAqcnN2ZF9hcmVhcyA9IHRkbXItPnJlc2VydmVkX2FyZWFzOw0KICAg
ICAgICBpbnQgaWR4ID0gKnBfaWR4Ow0KDQogICAgICAgIC8qIFJlc2VydmVkIGFyZWEgbXVzdCBi
ZSA0SyBhbGlnbmVkIGluIG9mZnNldCBhbmQgc2l6ZSAqLw0KICAgICAgICBpZiAoV0FSTl9PTihh
ZGRyICYgflBBR0VfTUFTSyB8fCBzaXplICYgflBBR0VfTUFTSykpDQogICAgICAgICAgICAgICAg
cmV0dXJuIC1FSU5WQUw7DQoNCiAgICAgICAgLyoNCiAgICAgICAgICogVGhlIFREWCBtb2R1bGUg
c3VwcG9ydHMgb25seSBsaW1pdGVkIG51bWJlciBvZiBURE1ScyBhbmQNCiAgICAgICAgICogbGlt
aXRlZCBudW1iZXIgb2YgcmVzZXJ2ZWQgYXJlYXMgZm9yIGVhY2ggVERNUi4gIFRoZXJlJ3MgYQ0K
ICAgICAgICAgKiBiYWxhbmNlIHRvIGJlIGhhZCBiZXR3ZWVuIFRETVJzIGFuZCByZXNlcnZlZCBh
cmVhcy4gIEEgc3lzdGVtDQogICAgICAgICAqIHRoYXQgaXMgcnVubmluZyBvdXQgb2YgcmVzZXJ2
ZWQgYXJlYXMgaW4gYSBURE1SIGNvdWxkIHNwbGl0IGENCiAgICAgICAgICogVERNUiB0byBnZXQg
bW9yZSByZXNlcnZlZCBhcmVhcy4gIEEgc3lzdGVtIHRoYXQgaGFzIHJ1biBvdXQNCiAgICAgICAg
ICogb2YgVERNUnMgY291bGQgcmVsYXRpdmVseSBlYXNpbHkgY29hbGVzY2UgdHdvIGFkamFjZW50
IFRETVJzDQogICAgICAgICAqIChiZWZvcmUgdGhlIFBBTVRzIGFyZSBhbGxvY2F0ZWQpIGFuZCB1
c2UgYSByZXNlcnZlZCBhcmVhIGlmDQogICAgICAgICAqIHRoZXJlIHdhcyBhIGdhcCBiZXR3ZWVu
IHRoZW0uDQogICAgICAgICAqLw0KICAgICAgICBpZiAoaWR4ID49IG1heF9yZXNlcnZlZF9wZXJf
dGRtcikgew0KICAgICAgICAgICAgICAgIHByX3dhcm4oInRvbyBtYW55IHJlc2VydmVkIGFyZWFz
IGZvciBURE1SIFsweCVsbHgsIDB4JWxseClcbiIsDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHRkbXItPmJhc2UsIHRkbXJfZW5kKHRkbXIpKTsNCiAgICAgICAgICAgICAgICByZXR1
cm4gLUVOT1NQQzsNCiAgICAgICAgfQ0KDQogICAgICAgIC8qDQogICAgICAgICAqIENvbnN1bWUg
b25lIHJlc2VydmVkIGFyZWEgcGVyIGNhbGwuICBNYWtlIG5vIGVmZm9ydCB0bw0KICAgICAgICAg
KiBvcHRpbWl6ZSBvciByZWR1Y2UgdGhlIG51bWJlciBvZiByZXNlcnZlZCBhcmVhcyB3aGljaCBh
cmUNCiAgICAgICAgICogY29uc3VtZWQgYnkgY29udGlndW91cyByZXNlcnZlZCBhcmVhcywgZm9y
IGluc3RhbmNlLg0KICAgICAgICAgKi8NCiAgICAgICAgcnN2ZF9hcmVhc1tpZHhdLm9mZnNldCA9
IGFkZHIgLSB0ZG1yLT5iYXNlOw0KICAgICAgICByc3ZkX2FyZWFzW2lkeF0uc2l6ZSA9IHNpemU7
DQoNCiAgICAgICAgKnBfaWR4ID0gaWR4ICsgMTsNCg0KICAgICAgICByZXR1cm4gMDsNCn0NCg0K
