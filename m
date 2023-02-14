Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1643369551F
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 01:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBNAC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 19:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBNACy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 19:02:54 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325924EE6;
        Mon, 13 Feb 2023 16:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676332973; x=1707868973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VDIDxcZMzynvHjrZB9gegltHgI2XihUh0snQU021fJY=;
  b=iLi4ELrNyH/CVB2yknH53PXWd0WkI6mTPJiUVJ9X2WLIk5I7ORBIFoVW
   1CuValQUsZae8TpOx3e2GCTvEDUqkaaGin9APq8ECfRf4fu0xw/I3+CoS
   K9Jy1AxdddceGd5JEP0UHhLTjujW2F/zXrvUxEIvd8qGFtItJq8EwOGWB
   Hbxql/TrmYfo571Ii19OBsQ7Bi9HuvoBBBH6wE5cneSn0JJmb/s/gSBjz
   GpJY/q6N4utSIFyMP+pkofdBLiuCdpoJMRLWtjXknisJTjObcGhPrgvkM
   jwMaS//QmnK+2U8Ey2F+dKJIZ5zqXwnPEiI6pP3ZUx1ni3blWk9cJmlWV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="332346018"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="332346018"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 16:02:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="914526903"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="914526903"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2023 16:02:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 16:02:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 16:02:28 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 16:02:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ1q3MvJ/dqnAFNrlSJi9+CykLEi81Q5bjUXGmUdhKPZC02Twk5gW33KnkRF6oUO/jQx3eiWU8LgPY96gD0QJwj0U0wecco9bQpsHX5mbGGiQyDYUIBHEfWCsW5bR48jqtv2stTDutP/sPHgN8CwiCGKxlYkWYxMgXbdF/iaYV9h3K0HY0JLA361brVgzVYuo+yqKv9BXQEwGb540tqzZzHbhqoOZ0ya3/6XllxT7t3+Ux3Q35sycWnUwB/A7WgRisOJRLhm2NDYt5wu3AUsvzAyHCiQYBdrKZo7MUvFLbv/qiPwARhbFdRuxcom1TGIEnWHdZJcdqyEVcU1uk/lSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDIDxcZMzynvHjrZB9gegltHgI2XihUh0snQU021fJY=;
 b=W/KRN7w7lT+WLgchHDCE9MUHUpxd6PhL9h3nJH/m5pX/v9gXKgx3lZpRjACx9xapks5EEcyFQR0BLt15UgDz6Mh9DtGNz+fOjFKeq51u1B6Geya1Sieoeg5JoxcC9Fy71hJrA7toPYadSli8ksgRoQ1ZRf/GmrDWa45ya2zuPmCkC/GVHNiVXE9z/5H7Yq0MbJGsWmRQ4LVeY9WK9wZ+ViJZU9C2Jraz+sMlbLuXTO89JUIiGWlq5WLmnKnP5YWk4uO5jtBvqdx5IPYtVMvuWgHyVrivx8BwFaZ+ccFiF7/w0F5tAzp4Uh3WnuDFJ9szAVotRtuGtzuMVj1XxGnZ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5940.namprd11.prod.outlook.com (2603:10b6:a03:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 00:02:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 00:02:22 +0000
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
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NKpCAgAA2qfCAABiqAIAAFhiA
Date:   Tue, 14 Feb 2023 00:02:22 +0000
Message-ID: <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
         <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
In-Reply-To: <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5940:EE_
x-ms-office365-filtering-correlation-id: 86fdf4eb-1a81-4f33-2f9f-08db0e1ebf31
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUmCM9xtmZL03RcOjNgadz0Kw3Rv/vLCDAsw8MERTPFRkbIKqULPoI4AxoaotsoD5Dg5TmnO8NygMhxFTpeGv1jcPPyRr37orr5VfErh4whWdrNyiFZTYSt3oqtfkwBuJGEoeElQ2XgmTqTwH00OZrVWAuzUiY/98EyU3M7d7sC50fKQCGRlNIk4Wj1gZu52JnE3138oQa3rFdBybYhKIPK91eJSoE54yPK6UciQa8t+6/GksGUC8032A9DQdhxXVCtoAP6LR1GJjZ9jNL7rLpuv2R2Kk+nPo/sHE2aP/Pd0zZiIiVdPh5TLiofAVkWB8arB44KIIJ4pBwCE8TiQCn4IQR/vhWhzlXRmaw9HuASdH1UXP5ZIqtL8IiwrxR9CKMx5W0i8RJ0m2rm42/Se9+4K57NfM8m+uiFd4UqaovpA8v+Us2ZuUC/RIoOK824Llwx7ncNfsaPblRCH6kbVzbVtd3zW0WBGyiI9iLAcQAF6/Bf69euaQYzgP9w491GD2N4Iz4ZD4+fzdCTKVOu4vcgc9714Q709uBeyfmQJlw7vX5xmrc9+lw94PuWXW3Lw1UKAFlD9SsjzUaBgQ6buhLwFn1hzvRvhJNte6KbSXRjNrg0fyBj8i85AUf9j7mTFJFFju5++iSwCbuxuOnCbS3JPyKegn7i2eBftscxqd0YTHab8TYPgRU7MXygdf+ogDsAX0RmA1aQI4Wqz2wHvkFqhLpcdzjz5d6fvzBdDEP8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199018)(5660300002)(41300700001)(53546011)(7416002)(71200400001)(4326008)(186003)(6512007)(26005)(6506007)(8936002)(2906002)(38100700002)(38070700005)(478600001)(6486002)(86362001)(54906003)(316002)(8676002)(966005)(64756008)(76116006)(91956017)(66446008)(110136005)(66556008)(66476007)(66946007)(66899018)(2616005)(83380400001)(36756003)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1NPNUpubmUxTUptTi95Z2FiOGtjSmZmWENKZFNPRUE0QUU2a3loK1VybVZ6?=
 =?utf-8?B?WjlkZ3pQVGE4TXM5WDBvUHZWcnZuZmxoZk43aldUamhGaTJYQlR3emRCcHZm?=
 =?utf-8?B?Uk9laUVFbWNxVVR4WGdYWU42Ri9KTEJNM3o2R2x5TXFwcCtoT0U1ZmRDcEZ4?=
 =?utf-8?B?K1NHZnRKR2lkd1NVUVhJL29wbm9IckY5OFVUL09pemRqT2hvbzBKV3paVTBO?=
 =?utf-8?B?OFo3NGpFdWo2T3pld3hmMUYxNWhOck43WDlPRG42OThzWWtPTHUrTmtCMDVz?=
 =?utf-8?B?cnhpbDd1WmMxWGM4TDZ3SERNQWdmQjBvZzNoSlAzL01sN000dFk4TXZBVmZM?=
 =?utf-8?B?OWs1ajM0cndjUnVtb2JCZ1U1L2crWHlJbU1uVXdrUGc5TElGNnV6SjRsaGZw?=
 =?utf-8?B?dGFsdlhkWVRybzNGOUxJeXRmdnZnZ0RvdWhDTzNYeCs1L3ZNVllaQnlxMDQx?=
 =?utf-8?B?Nm42NytXbUIxRUt6bG9pVHBhK2tSSmNkSkdlV0Vaekd6RGNJRXAzZG13T1pz?=
 =?utf-8?B?Z0hpWGExbGQ1eDVKOWZiVHNTdFhlUlZ3b3Q4QWJOMHZEa3ZaRFJyVlJjWk9n?=
 =?utf-8?B?N1dpcSt2Rlpxb2s5N1FxdFlYaDZJd0hUemRydHpPb1lXNmFmcHpZRVVYU3Uw?=
 =?utf-8?B?cGsydDZYMFVWNWsvcmhCMTNmeHp3bG0rSDFyOCtwaTlMcVJrbEpIV2JFMXZR?=
 =?utf-8?B?akh6MEo0Kzdod0ZVS0lsNC9xWFpwbEo0Vml5UlZnalhuM0hObldpMjZTYjJl?=
 =?utf-8?B?dTVqczlBU0hsRG9MM2VBUmppT1B2Rkw2eHc5a1VRUDdTT1k1L1U5T3BzeXRV?=
 =?utf-8?B?QzN5ZTR4eGp0WXdaRWl2akpWRERkWHhMeDFITzBxMk81MEE2aW1pUXhDaVh1?=
 =?utf-8?B?QTNOYXJCbTRodFRjU2NXZm5tbzVpb2Z1OHFKL2QvWXRhSmF6SW04L2o3bHhU?=
 =?utf-8?B?d0Z1SjlCeEdpOE1pbWZqbEJPSGdZUnoxR3h3N1JTUE9JZk5weVF5QlBybnNY?=
 =?utf-8?B?S0x0ZHlvWDBTeFh6K2VBSnBWZE1FazhpMkU3MTZkWjNBaG1sZ1ZtSlRyWkti?=
 =?utf-8?B?dnNzbXpPWVp1ZmhnUzkwZ3JDTmNjbHk0dFNTL3I3YVBBZmFXdjh6ZzlkenpQ?=
 =?utf-8?B?RmtjNEZ1RDU3RVlnN2xFTXVBQi8ydHUxczJleEg0ZTBQdFkwVzFVV1MzSzh5?=
 =?utf-8?B?ak9mWGtLZjR5ZnBad0hVOWlvZEU4VGc2T21aMU9qRWtqQnhQdTF3RnU5Z3lC?=
 =?utf-8?B?enlQWU1TZ09QbW1xNEk2V3RsbmlqbWtqbkU5dzhmLzVwVFcwbVFMWi9jWDRj?=
 =?utf-8?B?STd6eWZvUG1wUlV1NmJFSWh5Z1R3SE9heHdqdkJaajVXZ2NWMVVkUVJaT2oz?=
 =?utf-8?B?QjJIRFRZamlyNEZROHpvWnlhM2M0Y3NTSGhYVVhMaHVtUnM1R2hteGFOdSts?=
 =?utf-8?B?dEV1dGEzMi9HZnZOT2Iza01UeHBWK0lFM2RaRHlkS08vU0lGNk1Fa0tlbUY2?=
 =?utf-8?B?RWpnalFlMm1tSTJKa1VIUWU1QXkrdVY4QVFMYWQyNmwwMnhJaG80QmVqQWlF?=
 =?utf-8?B?dWNLZEtoaTJIbGJKWExxaSt2VCtBNVhTVnp5L0c5dkxGcDZTcU5OOXlJT1E0?=
 =?utf-8?B?VFZzSkovSk5FZnFHbW5laXhwc3FneWdEUStoQktZSGZYTU9SVFQ2dnhpbmdI?=
 =?utf-8?B?M0h3RFJQYUhBa0pjOG0zQVp2N3JJeDZKWFFmb2xPVGVhRzBMVXhna1JIKzdS?=
 =?utf-8?B?OThTQllreWxMc3ZKa1QwWHZRem1uclA2bXpWcVNHQ0lFbXM4MmxyVzV4ZnQv?=
 =?utf-8?B?QlRFVUJjT2ZtcHR3cDd1Nnp6VWtRd0lzUkxJQWZOUDFsZUFSOU4yZXJ4d0RF?=
 =?utf-8?B?eGYzT1BKdlc4V2NtMld1TytGOFdHYSswRjBCYjB5RC9GSUVOeVRRUEdmU1pZ?=
 =?utf-8?B?RE5hQzlzZU9hbWhNeDZIY0hUVDJpcy9yLzVzd2RlK0IydHdVSlhOM3dWbWps?=
 =?utf-8?B?S2NEUExvRWxSR2I3Z2Z2dGJJVlZnNUN4WmYza0ZJTlJjMFNFTXI4eEZZVE5X?=
 =?utf-8?B?MVBnRmJiL29NdW5CQ0hoNHFiNGg5dDc2Mzk0d1NZdVR5WlhMbGZmRnRoRmNC?=
 =?utf-8?B?dkVkdVFkU2UxRnpwczEyRTBsckQvU1lEMnNQY2xLN3Uzb3F3RDZxSGlBVjAv?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F09C0DCABDC543428D8D4C97BA4DFEFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fdf4eb-1a81-4f33-2f9f-08db0e1ebf31
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 00:02:22.2224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fa4FlmOrRrNz+H0ZM4Dxl3qHbdBdQwGuizsudAyCyIPZ1XZOmMJqc0gbFnJaI14Z4kxUYbznjUuiQ4JoThtx4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5940
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

T24gTW9uLCAyMDIzLTAyLTEzIGF0IDE0OjQzIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xMy8yMyAxMzoxOSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IE9uIDIvMTMvMjMgMDM6
NTksIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+ID4gVG8gYXZvaWQgZHVwbGljYXRlZCBjb2RlLCBh
ZGQgYQ0KPiA+ID4gPiBoZWxwZXIgdG8gY2FsbCBTRUFNQ0FMTCBvbiBhbGwgb25saW5lIGNwdXMg
b25lIGJ5IG9uZSBidXQgd2l0aCBhIHNraXANCj4gPiA+ID4gZnVuY3Rpb24gdG8gY2hlY2sgd2hl
dGhlciB0byBza2lwIGNlcnRhaW4gY3B1cywgYW5kIHVzZSB0aGF0IGhlbHBlciB0bw0KPiA+ID4g
PiBkbyB0aGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbi4NCj4gPiA+IC4uLg0KPiA+ID4gPiArLyoN
Cj4gPiA+ID4gKyAqIENhbGwgQGZ1bmMgb24gYWxsIG9ubGluZSBjcHVzIG9uZSBieSBvbmUgYnV0
IHNraXAgdGhvc2UgY3B1cw0KPiA+ID4gPiArICogd2hlbiBAc2tpcF9mdW5jIGlzIHZhbGlkIGFu
ZCByZXR1cm5zIHRydWUgZm9yIHRoZW0uDQo+ID4gPiA+ICsgKi8NCj4gPiA+ID4gK3N0YXRpYyBp
bnQgdGR4X29uX2VhY2hfY3B1X2NvbmQoaW50ICgqZnVuYykodm9pZCAqKSwgdm9pZCAqZnVuY19k
YXRhLA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgYm9vbCAoKnNraXBfZnVu
YykoaW50IGNwdSwgdm9pZCAqKSwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
IHZvaWQgKnNraXBfZGF0YSkNCj4gPiA+IEkgb25seSBzZWUgb25lIGNhbGxlciBvZiB0aGlzLiAg
V2hlcmUgaXMgdGhlIGR1cGxpY2F0ZWQgY29kZT8NCj4gPiBUaGUgb3RoZXIgY2FsbGVyIGlzIGlu
IHBhdGNoIDE1ICh4ODYvdmlydC90ZHg6IENvbmZpZ3VyZSBnbG9iYWwgS2V5SUQgb24gYWxsIHBh
Y2thZ2VzKS4NCj4gPiANCj4gPiBJIGtpbmRhIG1lbnRpb25lZCB0aGlzIGluIHRoZSBjaGFuZ2Vs
b2c6DQo+ID4gDQo+ID4gICAgICAgICAiIFNpbWlsYXIgdG8gdGhlIHBlci1jcHUgbW9kdWxlIGlu
aXRpYWxpemF0aW9uLCBhIGxhdGVyIHN0ZXAgdG8gY29uZmlnIHRoZSBrZXkgZm9yIHRoZSBnbG9i
YWwgS2V5SUQuLi4iDQo+ID4gDQo+ID4gSWYgd2UgZG9uJ3QgaGF2ZSB0aGlzIGhlbHBlciwgdGhl
biB3ZSBjYW4gZW5kIHVwIHdpdGggaGF2aW5nIGJlbG93IGxvb3AgaW4gdHdvIGZ1bmN0aW9uczoN
Cj4gPiANCj4gPiAgICAgICAgIGZvcl9lYWNoX29ubGluZShjcHUpIHsNCj4gPiAgICAgICAgICAg
ICAgICAgaWYgKHNob3VsZF9za2lwKGNwdSkpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
Y29udGludWU7DQo+ID4gDQo+ID4gICAgICAgICAgICAgICAgIC8vIGNhbGwgQGZ1bmMgb24gQGNw
dS4NCj4gPiAgICAgICAgIH0NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgc2F2aW5nIHR3byBsaW5lcyBv
ZiBhY3R1YWwgY29kZSBpcyB3b3J0aCB0aGUgb3BhY2l0eSB0aGF0DQo+IHJlc3VsdHMgZnJvbSB0
aGlzIGFic3RyYWN0aW9uLg0KDQpBbHJpZ2h0IHRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24uICBJ
J2xsIHJlbW92ZSB0aGlzIHRkeF9vbl9lYWNoX2NwdV9jb25kKCkgYW5kDQpkbyBkaXJlY3RseS4N
Cg0KQnV0IGp1c3QgY2hlY2tpbmc6DQoNCkxQLklOSVQgY2FuIGFjdHVhbGx5IGJlIGNhbGxlZCBp
biBwYXJhbGxlbCBvbiBkaWZmZXJlbnQgY3B1cyAoZG9lc24ndCBoYXZlIHRvLA0Kb2YgY291cnNl
KSwgc28gd2UgY2FuIGFjdHVhbGx5IGp1c3QgdXNlIG9uX2VhY2hfY3B1X2NvbmQoKSBmb3IgTFAu
SU5JVDoNCg0KCW9uX2VhY2hfY3B1X2NvbmQoc2hvdWxkX3NraXBfY3B1LCBzbXBfZnVuY19tb2R1
bGVfbHBfaW5pdCwgTlVMTCwgdHJ1ZSk7DQoNCkJ1dCBJSVVDIFBldGVyIGRvZXNuJ3QgbGlrZSB1
c2luZyBJUEkgYW5kIHByZWZlcnMgdXNpbmcgdmlhIHdvcms6DQoNCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvWTMwZHVqdVhDOHdsTHdvUUBoaXJlei5wcm9ncmFtbWluZy5raWNrcy1hc3Mu
bmV0Lw0KDQpTbyBJIHVzZWQgc21wX2NhbGxfb25fY3B1KCkgaGVyZSwgd2hpY2ggb25seSBjYWxs
cyBAZnVuYyBvbiBvbmUgY3B1LCBidXQgbm90IGENCmNwdW1hc2suICBGb3IgTFAuSU5JVCBpZGVh
bGx5IHdlIGNhbiBoYXZlIHNvbWV0aGluZyBsaWtlOg0KDQoJc2NoZWR1bGVfb25fY3B1KHN0cnVj
dCBjcHVtYXNrICpjcHVzLCB3b3JrX2Z1bmNfdCBmdW5jKTsNCg0KdG8gY2FsbCBAZnVuYyBvbiBh
IGNwdSBzZXQsIGJ1dCB0aGF0IGRvZXNuJ3QgZXhpc3Qgbm93LCBhbmQgSSBkb24ndCB0aGluayBp
dCdzDQp3b3J0aCB0byBpbnRyb2R1Y2UgaXQ/DQoNClNvLCBzaG91bGQgSSB1c2Ugb25fZWFjaF9j
cHVfY29uZCgpLCBvciB1c2Ugc21wX2NhbGxfb25fY3B1KCkgaGVyZT8NCg0KKGJ0dyBmb3IgdGhl
IFRESC5TWVMuS0VZLkNPTkZJRyB3ZSBtdXN0IGRvIG9uZSBieSBvbmUgYXMgaXQgY2Fubm90IHJ1
biBpbg0KcGFyYWxsZWwgb24gbXVsdGkgY3B1cywgc28gSSdsbCB1c2Ugc21wX2NhbGxfb25fY3B1
KCkuKQ0K
