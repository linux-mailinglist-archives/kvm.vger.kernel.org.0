Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDF86633AF
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 23:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbjAIWHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 17:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbjAIWHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 17:07:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510E63FA31;
        Mon,  9 Jan 2023 14:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673302038; x=1704838038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lIj2TgXu0uNOBYx9NLJiiT4w8s70JqzyfODrisGvkTE=;
  b=iZyxznAxltGs6FPZ7X7KV+daAo3SDKrc+pqPU8FjsPdCkvuuvS2BNwnu
   nl6/AadJCJ1Oxqn5C/XlkVxDqSecUQrzv7X0SA2LxvRxe+qzy3PkcIWjc
   txTP59PogqqLuXj7AyVQd8+P8/yZV9ri4iq09sPTyG3a4QA7djkqaUmo+
   sUjA49TA2SxlxdffnLFY51+2XaEolOjgVWEuMYoYZk4zOh2MtrnzejnUH
   y3IwBeBB5iOaEP1t57XaH9JMZNaDNIdl/C49VCA9qfSmvQMegHl4qNOGW
   u+k9o/Fqr3VANa1pzdwx/aJjkrt+Sxdc8rXwbb3xAgTwLKbSuQl3PV4WR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="350209389"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="350209389"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 14:07:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="985544827"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="985544827"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2023 14:07:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 14:07:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 14:07:17 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 14:07:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBzVbVSg6fJoJQ9oqhXK3f9bRvKJa4sWt8H5sJHJz2oam+sKvcs0aw7FOsmOTSBPRHKaFOksxiMezRnXvmnJ2HKc/yAOCBNgSdPvR8w6OlZjwWFlS590meidwo3QMj18raUzwkyvJD3odld2xKJY8qSC1ROcre7nbHFFhQhnAqJas1oAtSmqVnGnCT7DK7hY9oh/m+sCeWfvHhadZVPjD0F7Yyrb8LRpb7EfL8Yu/klkqCHj4/QAZpw0ht4w5xS8MizHlhA4x4xlMYuPT7yrYhfoPgR4hLiD64DzpNpshlLYmUZECIDjoDVyl6nHU249RwpCdH7+epZ5DYXJDcEXhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIj2TgXu0uNOBYx9NLJiiT4w8s70JqzyfODrisGvkTE=;
 b=g47+TPyF6x9WgY61yTjFD0obJULxxSYgWRKzD4lNMNtr1ZvQ/NjnCUxNkAf+aQcxqqKgzXyuA2znI74WC9seQc5ch24L+OmRjZuDDdXUYJXfnNHrFaVo+j95lNkr3LDN9fBXCCfTJ9OiSo0YzPpog8o9mjZTu1rvHkDg/rycGw7Invc6GnHX0vuLlOn8EVM727y0O3/ESA8eQErwBmwklQBTORj/knisQu4+Rm/D8lYapA189+wm3VASecqBriN97jkMnLkSRnX9V4kg2ZCyREg07cxvlroHeQlewVH6rhg67/sxWAGZ9Qw77Og41+X00ZP/IZxjYaVzPH00PBjiOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4558.namprd11.prod.outlook.com (2603:10b6:806:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 22:07:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 22:07:12 +0000
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZC5gFuAba9tjOq0ycIRHt8DkLjK6R1lgAgAQ7+ICAAJ4/AIAAJbEA
Date:   Mon, 9 Jan 2023 22:07:12 +0000
Message-ID: <95de773544dfe4e13c3599a5f83f6fcad3c00e11.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
         <d1093b3e-cdab-b138-d488-19b9456be978@intel.com>
         <e605ce95f1b92fae630bf6abb801774bc28d8072.camel@intel.com>
         <bea7dbd0-f6ec-5103-9d00-9617154d6be9@intel.com>
In-Reply-To: <bea7dbd0-f6ec-5103-9d00-9617154d6be9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4558:EE_
x-ms-office365-filtering-correlation-id: c08d46ee-155d-4645-843e-08daf28ddc0f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMg25SZVRobKK2C/rgRo5IcT9oWJua7jYHP398Jitim2vRjRPejavhpZlglVO+ml6UR0RlRulmyVkF3v7ktbyIpoGodWnb8RrRoT2bCB0T1WiItuGD1ZOCcMo7zubDSmEOGj16THVrl8y6SNhhb1Kj96yXuv1ATR4Yffz8FUsm1rDYQ+hYOB7Bq2QbHBSIvz5npggsrbBiZJtjh8ijIH7Wm97IJF+6NnQc1UCDhOH0O90WHn5dKwxYshBodkoO+Z9ePdB1FFqNWFYtq3G4IKAfn/5yTGXelA0gNHcsn3CD5QSA5K7aTNx16sxlRTGUpoofnDu2JyfrqcpeO8vinKnjTfRlpo2PDlnqmy9N7h92i/7QE4Du81A/2HkbIRFZ2f2PyY5+GYcLO4kd8C7mYVkMdld5mqXuSuZi5UAUmiwDA9luZ4WLc90LIT3WgkDrQZzrLZzVhlaYboflRNl77ViWGm1cnTYw0J6q91FtcFWvBLjCEoFPwSpnRLKf5kuD/wH8EOcT8cm9bQmUADcQPK1QSm862nYCAdEhVezUCQKWBuZ5yeRSGAb/ipHXh+Ci2CXnydOpRugKoCv42R5iHcHy8pKF+vVKBkKRBYGSDsi9W+ce0FHMU5ZdLyC+twWNkY1ZoWfYzdFzCRGFqmPLbAkfHGgQEo5mlQsjuoTgYzDaIZBA0bvrobeaH70/xvGFrN2xpX2hJpM7L5BTuLsnOlDG/2ONtwCvRX0ObZzugAzCtY7bKZo5v/f76n2HngDOqkyIr7EYKc4+fKHTbddthZrvlPnH4oFRuD9bfB+Y/aOGw0Kf6Whn5LwNs1J/X4gtkw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199015)(38070700005)(316002)(5660300002)(7416002)(71200400001)(186003)(26005)(6512007)(6486002)(966005)(2616005)(478600001)(41300700001)(66946007)(91956017)(4326008)(66446008)(110136005)(66556008)(66476007)(64756008)(54906003)(76116006)(8676002)(83380400001)(8936002)(36756003)(86362001)(53546011)(6506007)(122000001)(82960400001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTFOZlczUndWRDZGTkhNODBxNzNwNy9nQWNnV0g3UHlyTUc5VjJDem9pUzZI?=
 =?utf-8?B?SS9qMmhHWFgzcXhGamFCK2xHVVFDd2hMK0xTWUprckRrSUhNRUpCNlpHZFQv?=
 =?utf-8?B?UzhhNE5JSHhscUcyM0dPdlF3NWMvNm81bGRVd3V4ckZLbzcwMGJwUTM4YnZH?=
 =?utf-8?B?M2IwSUFFcHhHVTB4Vk5uSGtPOGRCbGxaL25Eei9FRVVEdmlvSGcyUjVjK3ky?=
 =?utf-8?B?OXdTOEVFaW4zMWR1Wnc4bVA4SFdaaWQ2UVFzblJqeEdNVkZzRXV2VFI4MGRG?=
 =?utf-8?B?L3ZMLytUcGY5VGEyUTNiMGFaSzdQWHI0OTBzNEYyWXpXdXRLV3N2SG5uN1g5?=
 =?utf-8?B?a2EwK0NyODNZV0NZUlNvR3JpQlMyK0NSemtmWDZ6MjUyS1JRTjQveEFreGJW?=
 =?utf-8?B?eW9zalJEZlJucXBRU2poaW5YMW1IZ0xpMlkvSWdnZENjL2Q3d3E0VXRjZ0dZ?=
 =?utf-8?B?ZEZlRnJ1a0pkSFI0dno1WFo0YXQ0bm1vM09ncDRwc3NyZExycGFzdHBGT21R?=
 =?utf-8?B?QzRiVzRTeFZNWHBsN1FKdDBHUVorSzV1S1cvQlRpMmEyeSsvY2ZFaGhla2ph?=
 =?utf-8?B?MHYxMWVEZzVKYkpXeGt1VkVaL3o0MjFpbjM3d1ByQVhPK09LSVg2WHkrMVdP?=
 =?utf-8?B?eDl4cmxXaW0vVE8ydVYxbFhyWitXZG1DR2ozMFdSZHR5VXNNMFUyU3RybTRC?=
 =?utf-8?B?UHEyQUJ4UVgvTXNTQ0duQVh6ZXJ5bVRQTmtqbFI3Q01kM2JNUHNXczdTZTRs?=
 =?utf-8?B?SUZqSFhsaFJqczZIazdhemVQcFR3Sm9qNjVUNEFNQTc5bi9mODBFb0dEcXpL?=
 =?utf-8?B?OWE3d3VuS3lhdmNYRHdOU2tVejFIYWJrWHoyWWZSWCtJc1RDd2JCOVFKbml1?=
 =?utf-8?B?VWI1TXZCQk1ONndjNEd2WWZJajFSdlB6ZnpEYkhFTStkaitoZVlRZTd6UFBH?=
 =?utf-8?B?REJiejhGL1UrL0cyUlpqYWtFSzFHVm9XS1pFMnhZeWl3NVlpOHNqV293OFhG?=
 =?utf-8?B?akZ1aHBuQzQxVTlEL3hUb3FNajRwOGZOdTAxeTF0eCsxRW9hcGhScEhmQm9L?=
 =?utf-8?B?aTJ0OUZESHVINVp0RXdBVzJVQzQ0YTl2ZDEybVNlYkdJMXhDM2hqdTZNa0sv?=
 =?utf-8?B?NWUweGxRZk53MjdBT0RBMzM3L3JNUXlheXRQOG9zY2lBcVptSEVvSmgzNFJl?=
 =?utf-8?B?TnJRR3RjTDgwRHMzUDdkUFgwVkxYUUZseVA0enZiRWJxWW1YOGxNRWEyWjJL?=
 =?utf-8?B?b1krczlBODF2b0dxeDZpcjVnZzBHYVAxM0hwcmZROXduQ2NLMDROVTNVc3oz?=
 =?utf-8?B?NldsMnFTTU0rYzAwWitzWUVBUTRaZjJpSkkzdmJkYUFSaUM1R3hMZExvR0g2?=
 =?utf-8?B?S214UnI4c0UzSE1Ob0ZZKzdINUhKRW5hSUkvbEppUjMvS1FmeVNtNXZvZDJZ?=
 =?utf-8?B?MWE5cFV1eWJ1TzBhRHlmcTFXaUkzeVlyd0Z5TlNtNWZocTM5VjNWeWVGd3dW?=
 =?utf-8?B?bkZYbUxFOTE2Sm9qYURCR0MxYlh1UlVSZkVDVDBIUE1KNXRFQWpoeVpOQUkx?=
 =?utf-8?B?NUxURGk5OUdiZHdsU1I5NkMwaXQyR3NVQWxna2xOeFA3L0dzb3NPL0xGSllQ?=
 =?utf-8?B?RUZSVlZaUEROZUlPTlFPSG50VmdTZjNtbXRvV3MwRVJrVXZXaU95YnFQVGJD?=
 =?utf-8?B?VEhZZDFrZ1R6d0UyR1JiNTVKa3dZY0hWQXRlR01URUlvUDIyalpvRUd5blVt?=
 =?utf-8?B?MWxmRHUzR0FYMnFYR0J3MG5VZW9nc0ZxQmZGNjEvZUhIc2dUL0tkNlhRcGZB?=
 =?utf-8?B?ZWk4SzRlV3BJUkhUSkxjNGIwdTJNRzk0MTRvOU1QRWhwcnNaV3BJcDk1anFu?=
 =?utf-8?B?MDNFOHFmVmE4QjMyU21uNjRsZGtzK1F6YW15c0xBZHIwM3ZqT3FxWjFyekx5?=
 =?utf-8?B?alYwU3ZLVCtVdnRMMDF2VlREM2dCQXVpRlQwRHJNVE1tcXlVWmVJaVRBY1Zk?=
 =?utf-8?B?c3Y3Qm9XTUVJM3FYbTFJOXlQRzVyYjkxdDBsMXBzVmIrVE5ockIrdy80bVB5?=
 =?utf-8?B?RzdsZEM5OGV1S1Y5R1NzQVFGQk53SW1EeGgvUlVSSzVQdTV2Y1NFTVlzQmQy?=
 =?utf-8?B?NlpIck1FZGVEeUNtaGZUWHRXdUhRaWRLZHJZdXFYbllLUjdKOTVkRmtRZWoz?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CB89FE92DEB5E42B4F331BF5B624E0F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08d46ee-155d-4645-843e-08daf28ddc0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 22:07:12.2505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TPqJP33heUT7awnRpHfsTQyx0BthaENWiXzwHnliFWGZjlSokDANKUSs+fCVyzBkNowuotLHUTDCiNQo+7LKow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4558
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

T24gTW9uLCAyMDIzLTAxLTA5IGF0IDExOjUyIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEvOS8yMyAwMjoyNSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjMtMDEt
MDYgYXQgMDk6NDYgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiAuLi4NCj4gPiA+ID4gTm90
ZSBub3QgYWxsIG1lbWJlcnMgaW4gdGhlIDEwMjQgYnl0ZXMgVERYIG1vZHVsZSBpbmZvcm1hdGlv
biBhcmUgdXNlZA0KPiA+ID4gPiAoZXZlbiBieSB0aGUgS1ZNKS4NCj4gPiA+IA0KPiA+ID4gSSdt
IG5vdCBzdXJlIHdoYXQgdGhpcyBoYXMgdG8gZG8gd2l0aCBhbnl0aGluZy4NCj4gPiANCj4gPiBZ
b3UgbWVudGlvbmVkIGluIHY3IHRoYXQ6DQo+ID4gPiA+ID4gVGhpcyBpcyBhbHNvIGEgZ3JlYXQg
cGxhY2UgdG8gbWVudGlvbiB0aGF0IHRoZSB0ZHN5c2luZm9fc3RydWN0DQo+IGNvbnRhaW5zDQo+
ID4gPiA+IGEgKmxvdCogb2YgZ3VuayB3aGljaCB3aWxsIG5vdCBiZSB1c2VkIGZvciBhIGJpdCBv
ciB0aGF0IG1heSBuZXZlciBnZXQNCj4gPiA+ID4gdXNlZC4NCj4gPiANCj4gPiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9saW51eC1tbS9jYzE5NWViNjQ5OWNmMDIxYjRjZTJlOTM3MjAwNTcxOTE1
YmZlNjZmLmNhbWVsQGludGVsLmNvbS9ULyNtMTY4ZTYxOWFhYzk0NWZhNDE4Y2NiMWQ2NjUyMTEz
MDAzMjQzZDg5NQ0KPiA+IA0KPiA+IFBlcmhhcHMgSSBtaXN1bmRlcnN0b29kIHNvbWV0aGluZyBi
dXQgSSB3YXMgdHJ5aW5nIHRvIGFkZHJlc3MgdGhpcy4NCj4gPiANCj4gPiBTaG91bGQgSSByZW1v
dmUgdGhpcyBzZW50ZW5jZT8NCj4gDQo+IElmIHNvbWVvbmUgZ29lcyBsb29raW5nIGF0IHRoaXMg
cGF0Y2gsIHRoZSBzZWUgdGRzeXNpbmZvX3N0cnVjdCB3aXRoDQo+IHNvbWV0aGluZyBsaWtlIHR3
byBkb3plbiBkZWZpbmVkIGZpZWxkcy4gIEJ1dCwgdmVyeSBmZXcgb2YgdGhlbSBnZXQgdXNlZA0K
PiBpbiB0aGlzIHBhdGNoLiAgV2h5PyAgSnVzdCBzYXlpbmcgdGhhdCB0aGV5IGFyZSB1bnVzZWQg
aXMgYSBiaXQgc2lsbHkuDQo+IA0KPiAJVGhlICd0ZHN5c2luZm9fc3RydWN0JyBpcyBmYWlybHkg
bGFyZ2UgKDFrKSBhbmQgY29udGFpbnMgYSBsb3QNCj4gCW9mIGluZm8gYWJvdXQgdGhlIFRELiAg
RnVsbHkgZGVmaW5lIHRoZSBlbnRpcmUgc3RydWN0dXJlLCBidXQNCgkJCSAgXg0KCQlzaG91bGQg
YmU6ICJhYm91dCB0aGUgVERYIG1vZHVsZSI/DQoJCQkNCj4gCW9ubHkgdXNlIHRoZSBmaWVsZHMg
bmVjZXNzYXJ5IHRvIGJ1aWxkIHRoZSBQQU1UIGFuZCBURE1ScyBhbmQNCj4gCXByX2luZm8oKSBz
b21lIGJhc2ljcyBhYm91dCB0aGUgbW9kdWxlLg0KDQpBYm92ZSBsb29rcyBncmVhdCEgIFRoYW5r
cy4NCg0KPiANCj4gCVRoZSByZXN0IG9mIHRoZSBmaWVsZHMgd2lsbCBnZXQgdXNlZC4uLiAoYnkg
a3ZtPyAgbmV2ZXI/PykNCg0KVGhlIGN1cnJlbnQgS1ZNIFREWCBzdXBwb3J0IHNlcmllcyB1c2Vz
IG1ham9yaXR5IG9mIHRoZSByZXN0IGZpZWxkczoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC85OWU1ZmNmMmE3MTI3MzQ3ODE2OTgyMzU1ZmQ0MTQxZWUxMDM4YTU0LjE2NjcxMTAyNDAu
Z2l0LmlzYWt1LnlhbWFoYXRhQGludGVsLmNvbS8NCg0KT25seSBvbmUgZmllbGQgaXNuJ3QgdXNl
ZCwgYnV0IEkgZG9uJ3Qgd2FudCB0byBhc3N1bWUgaXQgd29uJ3QgYmUgdXNlZCBmb3JldmVyLA0K
c28gSSB0aGluayAiVGhlIHJlc3Qgb2YgdGhlIGZpZWxkcyB3aWxsIGdldCB1c2VkIGJ5IEtWTS4i
IGlzIGdvb2QgZW5vdWdoLg0KDQo+IA0KPiAuLi4NCj4gPiA+ID4gKwlzdHJ1Y3QgdGRzeXNpbmZv
X3N0cnVjdCAqc3lzaW5mbyA9ICZQQURERURfU1RSVUNUKHRkc3lzaW5mbyk7DQo+ID4gPiA+ICsJ
aW50IHJldDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCXJldCA9IHRkeF9nZXRfc3lzaW5mbyhzeXNp
bmZvLCBjbXJfYXJyYXkpOw0KPiA+ID4gPiArCWlmIChyZXQpDQo+ID4gPiA+ICsJCWdvdG8gb3V0
Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICAJLyoNCj4gPiA+ID4gIAkgKiBUT0RPOg0KPiA+ID4gPiAg
CSAqDQo+ID4gPiA+IC0JICogIC0gR2V0IFREWCBtb2R1bGUgaW5mb3JtYXRpb24gYW5kIFREWC1j
YXBhYmxlIG1lbW9yeSByZWdpb25zLg0KPiA+ID4gPiAgCSAqICAtIEJ1aWxkIHRoZSBsaXN0IG9m
IFREWC11c2FibGUgbWVtb3J5IHJlZ2lvbnMuDQo+ID4gPiA+ICAJICogIC0gQ29uc3RydWN0IGEg
bGlzdCBvZiBURE1ScyB0byBjb3ZlciBhbGwgVERYLXVzYWJsZSBtZW1vcnkNCj4gPiA+ID4gIAkg
KiAgICByZWdpb25zLg0KPiA+ID4gPiBAQCAtMTY2LDcgKzIzOSw5IEBAIHN0YXRpYyBpbnQgaW5p
dF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gPiA+ICAJICoNCj4gPiA+ID4gIAkgKiAgUmV0dXJuIGVy
cm9yIGJlZm9yZSBhbGwgc3RlcHMgYXJlIGRvbmUuDQo+ID4gPiA+ICAJICovDQo+ID4gPiA+IC0J
cmV0dXJuIC1FSU5WQUw7DQo+ID4gPiA+ICsJcmV0ID0gLUVJTlZBTDsNCj4gPiA+ID4gK291dDoN
Cj4gPiA+ID4gKwlyZXR1cm4gcmV0Ow0KPiA+ID4gPiAgfQ0KPiA+ID4gDQo+ID4gPiBJJ20gZ29p
bmcgdG8gYmUgbGF6eSBhbmQgbm90IGxvb2sgaW50byB0aGUgZnV0dXJlLiAgQnV0LCB5b3UgZG9u
J3QgbmVlZA0KPiA+ID4gdGhlICJvdXQ6IiBsYWJlbCBoZXJlLCB5ZXQuICBJdCBkb2VzbidzZXJ2
ZSBhbnkgcHVycG9zZSBsaWtlIHRoaXMsIHNvDQo+ID4gPiB3aHkgaW50cm9kdWNlIGl0IGhlcmU/
DQo+ID4gDQo+ID4gVGhlICdvdXQnIGxhYmVsIGlzIGhlcmUgYmVjYXVzZSBvZiBiZWxvdyBjb2Rl
Og0KPiA+IA0KPiA+IAlyZXQgPSB0ZHhfZ2V0X3N5c2luZm8oLi4uKTsNCj4gPiAJaWYgKHJldCkN
Cj4gPiAJCWdvdG8gb3V0Ow0KPiA+IA0KPiA+IElmIEkgZG9uJ3QgaGF2ZSAnb3V0JyBsYWJlbCBo
ZXJlIGluIHRoaXMgcGF0Y2gsIGRvIHlvdSBtZWFuIHNvbWV0aGluZyBiZWxvdz8NCj4gPiANCj4g
PiAJcmV0ID0gdGR4X2dldF9zeXNpbmZvKC4uLik7DQo+ID4gCWlmIChyZXQpDQo+ID4gCQlyZXR1
cm4gcmV0Ow0KPiA+IA0KPiA+IAkvKg0KPiA+IAkgKiBUT0RPOg0KPiA+IAkgKiAuLi4NCj4gPiAJ
ICogUmV0dXJuIGVycm9yIGJlZm9yZSBhbGwgc3RlcHMgYXJlIGRvbmUuDQo+ID4gCSAqLw0KPiA+
IAlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IFllcywgaWYgeW91IHJlbW92ZSB0aGUgJ291dDonIGxh
YmVsIGxpa2UgeW91J3ZlIHNob3duIGluIHlvdXIgcmVwbHksDQo+IGl0J3MgYWN0dWFsbHkgX2xl
c3NfIGNvZGUuICBUaGUgbGFiZWxzIGFyZSByZWFsbHkgb25seSBuZWNlc3Nhcnkgd2hlbg0KPiB5
b3UgaGF2ZSBjb21tb24gd29yayB0byAidW5kbyIgc29tZXRoaW5nIGJlZm9yZSByZXR1cm5pbmcg
ZnJvbSB0aGUNCj4gZnVuY3Rpb24uICBIZXJlLCB5b3UgY2FuIGp1c3QgcmV0dXJuLg0KPiANCg0K
VGhhbmtzIHdpbGwgZG8uDQoNCkkgdGhpbmsgdGhpcyBhcHBsaWVzIHRvIGNvbnN0cnVjdF90ZG1y
cygpIHRvbyAocGF0Y2ggMDkgLSAxMSkuICBJJ2xsIGNoZWNrIHRoYXQNCnBhcnQgdG9vIGJhc2Vk
IG9uIHlvdXIgYWJvdmUgaWRlYS4NCg==
