Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF16DD0B4
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 06:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjDKEOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 00:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjDKEOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 00:14:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1AD26A1;
        Mon, 10 Apr 2023 21:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681186489; x=1712722489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SSjRMwD0fMa1K2pVZy5wQDIh1fK85pgp70FLAjELLeE=;
  b=TtN0H4GGh4516APw9/3QrXyOox0HpGMmFUQLVAJupJgDJ6Rj7UybU5oV
   F7BCKq1XS6tHKnfeg85NE4StksLBLFROp+zQ14iBErH7nrazjaqwFobuO
   rZYmucVP3SxU2FbzppIf2VTaQsjamBaTe9/iKzVq+lBAsoSqP1bMP7xZG
   nsJR+IbXy/UTZJF6qTtKUCQs82DToxncg5WPSGtClnhx2C+p37BZaTfep
   6k/UujZeSKZEDgbJ++l1ypaR7vh4qj9O/4Uz2GWG6ncI312AIN76Qq+63
   bSbYZNdwZLOMkAr2nwj+mJtqW0LRvyOnT+la6Q3K7GhU16uUeq3na/Xq8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="345306135"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; 
   d="scan'208";a="345306135"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 21:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="777761508"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; 
   d="scan'208";a="777761508"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2023 21:14:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 21:14:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 21:14:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 21:14:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWWG6UF2WxmQ+/rsBYJDB+F8H5iyPJ2buxPMz1tPV+HhWRg91mac5vW4i0WtlIGeIUeOjFI57aZ4nXZeIOT3ZUMAL+jyd84+tijtqK4MwFJf7Hc7xe+dvGIOYYPkUISEfiJgv2WNE2EYHgo/nvhT07UUE6s8br6v9nH836y2dpNbnhn7E1WWe364PsnxmF13vH1GpcXgC2WdI9K3dL2unwZYOa7NeRtJID2ha5/BsrMW9syIN2mFkhlKUcbfZCXuzj//a+fhMCYqHxtkKf+hP7HI2vWQ2U89QdVOUOxsjw5X0lA2L86cfXMHxeEi3xGCkiFM6J2uS/MjqvvsnULrqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSjRMwD0fMa1K2pVZy5wQDIh1fK85pgp70FLAjELLeE=;
 b=WPr6NYEMJkC3+IUjdfm5bkqGngPuD49HKj8gso6EdjOTcRl4ULhFOiyW/N+Zs5qSF+4EU+HRwYL5kbzdcZKT3Z7gG0BLZuavWXJzGeBakfyHzFiUMhawF0zRBNJqdN3trONmBhhqWCTEIFnl/WY8G7XO7zaPpwqDOkin/M769vRrg1uvCMHUJHu94g/3IsaU66JEs7Q+eK8nEweGbC475FCaeQOpR/o+XIl9KZYtfdNVQMDVLXzSBswx97goqF/1c+5S9QVYI6ojFFz5aURLrGLmq9jTUNrFnczGILU1nhrWKQ5eLp7lldC3ZNsKJLS7CMYTFUdGZlsxd074LLZuQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB6451.namprd11.prod.outlook.com (2603:10b6:510:1f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 11 Apr
 2023 04:14:45 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 04:14:45 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: RE: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Topic: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Index: AQHZa4g5E/QemdFnfket3mQeyiRQG68k3+WAgAACSoCAAA0+AIAABuSg
Date:   Tue, 11 Apr 2023 04:14:45 +0000
Message-ID: <SA1PR11MB67347309287CC9207A6C1391A89A9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
 <SA1PR11MB6734C0AE97E8B5ACF70CA32AA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
 <20230410193254.GAZDRkZjBURP9BydHB@fat_crate.local>
In-Reply-To: <20230410193254.GAZDRkZjBURP9BydHB@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB6451:EE_
x-ms-office365-filtering-correlation-id: a3874dc5-7faf-4a9b-7f4f-08db3a434839
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ia49kBlVWYrOO/R7URXDiXSeNfXOjqCaR8L/dMBaqrIrth/pjqs8kYXNAbTm+CGy/5OzX3oSQ2yKrhjOdDFkLqU/B+yAh/PnmrkL0R+e+jJD0mbNSG+QuJ1Kd80bjVH0uDu/3y5THqR9Itv8Fewgkem0jpPCVBccQ0GemNKQgzM+QyyFC9TEltuwttC9QxEtUJutwY96ICrkfeyvRl7nJwtgxHye1T1WCEsI61FKL5T9CMwNpdV1lQZSBa/rpDESioFUhjRIh60n6aiGFz8Dhl0BHdd48v/44aOJVDWY5+8N8ZY5RH3j1SK3pWf//mMyyz3OSWJP9/bA2Qcn0gagtpmF/VMdDaPiaPvskfLYavrUXRu0ftBtQQOo3ZOiUqpUmZIzSqwQe/RQNFNv9yXB4GdX7ncp40ZkS7Dlgug/cTVDTZgpNxhyC3+t/735MXrCE2kWU2Q4V1zZ4secn7mhsU2Has1hyy6UpjBT6LvCMSSykEPDBBG3eY1y3oVZTRivEpjAJtDmu0/5aW57AbO3CRa5nNtv0uFLyinqNhB7J/YBonjGUPN5ieD1nfgx9Al768y6KLpg+zZnEFJQlWsniyPK+tltXGca9gvemedftmk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(86362001)(38070700005)(55016003)(2906002)(82960400001)(41300700001)(4326008)(66574015)(6916009)(7416002)(8936002)(66476007)(52536014)(966005)(66946007)(26005)(9686003)(38100700002)(478600001)(64756008)(54906003)(66556008)(5660300002)(7696005)(83380400001)(71200400001)(33656002)(76116006)(122000001)(66446008)(186003)(316002)(8676002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHVQa3NYZmhIZFIrSTRyNDIvVDhKVnl1ZmtQV0hlVHNiSWx5c1kzT0RZY3hV?=
 =?utf-8?B?RS9pWVV3R2dkbjhhMkdCSWJEdjg3UUdNeFhZeDJTOER4cWErMUZHYWw3eHhq?=
 =?utf-8?B?NStFUlorYVhkK3o2WTZTZ0Q0VC9aTWtxOENIaUU0MmJXN0RiZjI5UUt6RFpw?=
 =?utf-8?B?Yzc4VFNJN2tVaExNUHVtcVFVc3ZtR1ZzdHpMTnBJU09oRUVnZ2U1OVRZbFoz?=
 =?utf-8?B?UEk5Smd3eHpRSkV3czdWcE5TYjRBYVJpMG1idDQ3ZDJDV3NyOEJGelFaRUdC?=
 =?utf-8?B?ZVVncDZYZXJqS2E5c3gvQmEyOXQ5N2hiL2pXeDFmdWU4N1ZmNE5OSGpDTW5i?=
 =?utf-8?B?SXc2bmt2T2ovYllQbE5JY0d5a1U2ZkVGN2o3ZU8xS1k5NWF5VE5MMGRrbEww?=
 =?utf-8?B?OVE2eS9pTzBOTm1QRzFQVkt1blRDMDROdHp4bXZ2ZFFkZ2U4MkZOQms5aWpH?=
 =?utf-8?B?ZXI1eVpGa3NsenkxQ3p3V0R3UzgrbVhMdkVCVk5xa0k2MDZTSExPN1N4MytQ?=
 =?utf-8?B?OTlsRFZnbWU0V01GVjlRRGl6N3RQTkwzNndiMmZYQkIzSzVPbDhtK0EzUHhG?=
 =?utf-8?B?KytOc1JkMXRVYW0rYllNRno4dW9jZVU2azlUbllxQjlhVytTWHR1NW9xMzd1?=
 =?utf-8?B?cHQ4dUJFYzczMXp0K0J6ZHIxS2dqVUkrZ1JFb2ZFRUhnWnBQZW9yMnJGMW1W?=
 =?utf-8?B?RzNocU53RUNGNnlCeGFaMHBNQ3NwWXVVb0VTa1owNDNZc3ZnZ0h4eDJxVXZP?=
 =?utf-8?B?ZmxDbzJFWjdJVU5CT0lTRlF5UVFNbUZaVWhTcUhMYTN2NE9nTzFqY1VRRkVp?=
 =?utf-8?B?a2lPaHk1djRqMG9xWlZsd1Y3TWgvUi9hdVp1cDBuWWZRZm9FSmtka3BocG4v?=
 =?utf-8?B?b2s0OVZBN3Z1UzhBZ2loUEFCK2RlZzk2d0x6K21vQnJVOHc1SE5wNVpDN2xW?=
 =?utf-8?B?cmtuRVVlZUVtc2UyOHE5azlPMEtGSEJlMHZERXkzNUhIVE1wNnpSSk9RTUFr?=
 =?utf-8?B?Z2xveDZlOUdtYjE0MjYzSjJYYkRSRmt3S0c5b1BuMG9yVlF1Rnk4cjF4aTZz?=
 =?utf-8?B?c05lL1RCdzJaWHVBTHdobmx6d0hSWFh1Q2c3U0NCMjl5dU95R3hTUXJuZWx2?=
 =?utf-8?B?bHlMcW9yb1ZicURXL3FYeVh5K1pudHVPK2RRd3lYaDZDQ2dLZFd3Nk4xZS90?=
 =?utf-8?B?RG1BSjVxaHFkRTJLd2JFbWV2ZldBVDB3SlRBdm1QdWxyZEtCMjV5YzZNV0hE?=
 =?utf-8?B?NDRlUlljVVZjUk5FRjJCVVZUVVhLS1RaSjNMdTlHUzA0U1cyV1F2SjBUZmRu?=
 =?utf-8?B?STdEMkdjaFlQQmxwbmdWb0JpOFU0SUhQNm81Q3U1Q2tlSk43SmgvSzFhRkx3?=
 =?utf-8?B?MElPSGV0L1hySlR5ZEtZZkt0QXVKNEcxSDFyS0Y1WVUrVzc3WmkvQ2tkRnhW?=
 =?utf-8?B?am1lUVhDaHBLdTVINXlpTUFIQnk1Vi8rY2dLUjljUW9PQVppckt3NHArNHI3?=
 =?utf-8?B?Mlh1alJkRFlPOXpTb0wzalo1T0tIQ3FVQURObnRxd1J2VFVkaGxIY2pVdzlY?=
 =?utf-8?B?YVlwV3hCdFIyVEt6RStSSDdnSEFLUkIySlRkN2YzQ1lmUzMySlY1S21TYi9n?=
 =?utf-8?B?MElYR3BKZFVGZHc5Vkx2Z09kcnQydUJzUEk3a1phdUowdEQ2bTVEbFVybTAv?=
 =?utf-8?B?Y2tWa1ZjOFByWmMrRzFocHRCRitlQ0gwYmdFc3h0ZlNvYlB5NDVDSEJvL1hu?=
 =?utf-8?B?MzJyNWNOWDBhelA2WGY1T1AwTUpQZzdHRDJ4V2VtbTRlbHczNnBHNW1Ya1N3?=
 =?utf-8?B?ZThLVmwvVXo1Y0RDN2FhQmNrS0lCSFcrdm5GaVVDNXdNSWVJM1ZEdUVKQkd3?=
 =?utf-8?B?dnNqcThRODdVN0dNUG1YbUNzSlc4U3REK3hteWZ4WHZ6YmdoQlQxMWU1RE4y?=
 =?utf-8?B?L1cxR045TmFUeTcvTXdUSVoxQmllSjMyY3Qxd1AxV1kwOUpUVFFHRmI1WXZU?=
 =?utf-8?B?WW5YU05nS0ZYdXAwRmdTb2xKTkZWaWNIK2dyeDkwanlIYWxvR2o4b1ZBb0VH?=
 =?utf-8?B?d1hLTWVUS0hWWmdRM2VyN25iem9xb05WS00xRE5PMnRlUTRwdmR6d2NYNjY4?=
 =?utf-8?Q?e7BU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3874dc5-7faf-4a9b-7f4f-08db3a434839
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 04:14:45.1456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXrTQbtS8mEfbcSd5j8S59OBUrTM+dDrQjKuGvo/kjVUBc7hYKvVocMyCPK8yRjYmsKjSPn+F9MTJZo9/dZUHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6451
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJcyBGUkVEIGluIGFueSBoYXJkd2FyZSBpbmNhcm5hdGlvbiB0byBydXNoIGl0Pw0KDQpDdXJy
ZW50IHBsYW4gaXMgdG8gaGF2ZSBGUkVEIEhXIGF2YWlsYWJsZSBpbiBJbnRlbCBkZXZlbG9wZXIg
Q2xvdWQgaW4gMUgnMjAyNC4NCg0KQXMgdGhlIGNvdmVyIGxldHRlciBtZW50aW9uZWQsIGZvciBu
b3csIGl0J3MgYXZhaWxhYmxlIHRocm91Z2ggSW50ZWwgU2ltaWNzDQogIGh0dHBzOi8vd3d3Lmlu
dGVsLmNvbS9jb250ZW50L3d3dy91cy9lbi9kZXZlbG9wZXIvYXJ0aWNsZXMvdG9vbC9zaW1pY3Mt
c2ltdWxhdG9yLmh0bWwgDQosIGFuZCBhIGRldmVsb3BlciBoYXMgdG8gaW5zdGFsbCBpdCBvbiBh
IGRldiBtYWNoaW5lLg0KDQpGUkVEIHdpbGwgYWxzbyBiZSBhdmFpbGFibGUgcHVibGljbHkgdGhy
b3VnaCBhIFNpbWljcyBjbG91ZCBzZXJ2aWNlIGluIFEyJzIzLA0KaW4gd2hpY2ggYSBTaW1pY3Mg
aW5zdGFuY2UgaXMgY3JlYXRlZCBmb3IgZGV2ZWxvcG1lbnQvUUEgdXNlLg0KDQpGUkVEIGlzIGEg
YmFzZWxpbmUgZmVhdHVyZSwgYW5kIHRoZXJlIGFyZSBzb21lIEhXIGZlYXR1cmVzIG9uIHRvcCBv
ZiBpdC4gU29tZSBvZiB0aGUNCm5ldyBmZWF0dXJlcyBtaWdodCBiZSBsYXVuY2hlZCB3aXRoIHRo
ZSBmaXJzdCBGUkVEIEhXLg0KDQpJbiBhZGRpdGlvbiwgdGhlIEtWTSBGUkVEIHBhdGNoIHNldCBp
cyBvbiB0b3Agb2YgdGhpcyBwYXRjaCBzZXQuDQoNCj4gSWYgbm8sIGJlIHBhdGllbnQsIGFkZHJl
c3MgdGhlIHJldmlldyBjb21tZW50cyBvbmNlIHlvdSBoYXZlIHRoZW0gYW5kIGRvIG5vdA0KPiBz
cGFtIG9uY2UgYSB3ZWVrIGp1c3QgYmVjYXVzZS4gQXMgRGF2ZSBzYWlkLCB0aGlzIGlzIHdhbnRl
ZCBieSBhbGwgYW5kIGl0IHdpbGwgZ2V0DQo+IHJldmlld2VkIGV2ZW50dWFsbHkuIEJ1dCBpdCBp
cyBub3Qgc29tZXRoaW5nIHRoYXQgbmVlZHMgdG8gZ28gaW4gbm93IHNvIHlvdSBkb24ndA0KPiBo
YXZlIHRvIGNyZWF0ZSB1bm5lY2Vzc2FyeSBwcmVzc3VyZS4NCg0KSXQgd2Fzbid0IG15IGludGVu
c2lvbiB0byBwYXRjaC1ib21iIHRoZSBsaXN0LiBCdXQgSSB3aWxsIHBheSBhdHRlbnRpb24NCnJl
Z2FyZGluZyB0aGlzIGNvbmNlcm4uDQoNClRoYW5rcyENCiAgWGluDQoNCg==
