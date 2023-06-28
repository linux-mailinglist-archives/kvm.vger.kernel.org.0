Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8D741C79
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 01:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjF1XaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 19:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjF1XaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 19:30:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D1719B4;
        Wed, 28 Jun 2023 16:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687995017; x=1719531017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YFZhjfsaM7e1tS2oiiOP7dJMZZx9DIXECbXtS0Ym5r0=;
  b=DHf2TQLovdQ5/WWQwPh2GPzKZT2ak98E6F9Lx62P4Sx13xftY4FNHRD2
   9bHL3cb3l07Q5b7n2yEvriC/yG+8LumEfLhWwfkQnPU8sqSclyXXlXMZy
   freilV4bYBMBmDyIIqPV5v/7jiwhD5Kq/jIU+0Lmlt228afFVInfvVRHv
   qX5lcnLE5+BKPd1po2H64mqZ81mK2sCAxyTq/PAqQEq/nZiXEpPSIBhYC
   arjzxtPWHw/7F7YRia7YYPf8iMZUhWPyh4iv/wxrft3liaC4od6l0jPfI
   Ajs5CpCUzsnCMbzhObnH3TXrrAe21laSPYrSDRRDRfFx5QGUEpBSYfLj7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="351780405"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="351780405"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 16:30:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="711219257"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="711219257"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2023 16:30:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 16:30:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 16:30:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 16:30:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+ReF+59ISLhIIgQSIZVtoYMgJRwCcVojydjJzQBImWo7hf9Mth+1XVxbgyjW14EEYK47zP99j+MgB6yp3cH4mSUC9fBq79VIOpx5rXSocvRifVwktEe4DNZwvjoWA2efre7kXYJQ7r7b4aINGWTVqrYP2BTGkHd0LNGrY3YDMzSrpKEl+gdTRa+Cj11AxSZLO19KI06vG9uE29lSM0tOTCKNoFcac3sZRY7EC4Q8jQKOmXRergJMagxPU9+Uepi1pvPySID6Qj9n6ejJ0TM5WWb/0Pj/lLjE+X383ZpTPHkQjokj8l1OIzRgtCsh+8Ak4CIDWBgTnw6vViaOdfwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFZhjfsaM7e1tS2oiiOP7dJMZZx9DIXECbXtS0Ym5r0=;
 b=UFUZW6pq9FYILSbxC4+IOPQ713A7mfX+kjeQNCd6qaINDjoMXyrIcha6zR2HerBna0uovNRV69JfOsvZghSYijF/UdaZ38Fp410legoM82xw7iSJurK7Fb44S7rjCiFpjMMwFx5Pqv3J58k/5DyauoQbkuGNqGnGY7psHHJwHoQ30fu5K/eFjerpOY7g4I1+rOZGBMI6gO/xwr1W6Z5cPV9nhkGLcJNgM1dR1PcfRG7aSxM1RzIQOfXMTygqDuCpql4wyclKNX5B1HKUpf0Hy0pvBCvVqYQ8HELVKuLxJYSrq5Kdu/m2PFFlwgn41dFzy0/5B8ljUxbT974L3e4GLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6785.namprd11.prod.outlook.com (2603:10b6:303:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Wed, 28 Jun
 2023 23:30:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 23:30:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
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
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 06/22] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Topic: [PATCH v12 06/22] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Index: AQHZqDWrow5S501ZUUepy95hcZlc9a+gMUsAgACvPAA=
Date:   Wed, 28 Jun 2023 23:30:11 +0000
Message-ID: <ce71475b745f736ddfd9baada9b38b5d8e371b55.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b5bf58246659572bd68d46b14e90e9e5b37f7f93.1687784645.git.kai.huang@intel.com>
         <20230628130256.GB2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628130256.GB2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6785:EE_
x-ms-office365-filtering-correlation-id: 14af9af8-a9fa-43f9-407f-08db782f9df9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zgcN/BBrE/ui/Uto4MtVYQPpmGEXYbOfmU+GJ2fRucQetdGttOu4ZkISP/UOyt/zD5q3x0IZj0FpreBKlKxnKb6S0Z7uy0Ln1NBU5nghqa6NIOyuBpLZpItglf1PvvVyIe00xoRp284J3cVJlk7U81tFqvDZkL+zhQXHXn7fbOJK59Tx7d63WU08UzJk/k+tzMpvivrnTGMIp/gv+2AxrIKgM3sG3uhs9IxVGc8C8zD+4rdaFZzzPvhyVC80Dt3i8wT/0mr7w2Wpf3mlTNc8lAM7f0qQHK1q1rbfsCHRs37b1xK6RlvTnKRNSRxAaq9Raisin8ueGXcqvt1e9SK/ymjq69XudYv581X67RsiIIYDlpFB/MXI2fDvzPNUIFLMipM3z7WCZtTl1Suixj+OJcJmOQYUthDfvxFEJLSwOGHBOHm4t0nWAvk5fPyh3DRAj/AiTFdx/LRxOvl7RA6k+1bYjnK5jV5CzAXBco07u+lCgUFk+dJR1onHJrXejf1+xETcgp1lebIhWLW+EyvZmExHoiwDmtdocFpfImWfgor8OT04n2uBgSUxg+6isUvz/vkUHLgiNc3C00MtuZGPReNhNLSQgDbQp/tBFl8O//4RFB7G2kc1W/AaerZ9gnvW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199021)(86362001)(2616005)(83380400001)(2906002)(36756003)(38070700005)(122000001)(54906003)(8936002)(38100700002)(82960400001)(41300700001)(316002)(6486002)(5660300002)(8676002)(478600001)(71200400001)(76116006)(6916009)(66946007)(4326008)(66476007)(64756008)(66446008)(66556008)(6512007)(186003)(7416002)(91956017)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU56d29vSU4ySGdQT1daMzdpdjJTQVdDQUlHQzc4Nnd1cDhaY3U3NldaUFFC?=
 =?utf-8?B?T3I1V0YwQmt4eGlOcTRyd3orYWdnWTR3c2c4Y2ErdVJoa2FpUFpDRG1SU0ti?=
 =?utf-8?B?aEdWL2lWa2FOUUZLWkxZMTM3U3UwZHU1ZkNLb3d2MXZNcEhITnp0U3lnRTEr?=
 =?utf-8?B?VGxtVkhqQ3BXQWgvT1RwRGxYWTY1WjlxSWFZeHBNVHI1ZUZVUVEycWFQSHBn?=
 =?utf-8?B?YUNEdkNxTTVBYW4zckZ1S1UrV2V6MXRRQzRqV0lFOU93NG1QRlZYRGFiZGhO?=
 =?utf-8?B?dTQzZVdJUUJ5cFhTWW5vemc1dGJwaFJHbERwUjRGUCs2eENYT2RWSk04MHNq?=
 =?utf-8?B?UHU1ckpBV2xwQlplY0pSNURHcWJveGNnYWNBUS9uRG5nUlZKUmthNlVUM3E0?=
 =?utf-8?B?Ky81UFp2NFpFWW80QVUvckN0a0lQTEdYMEFuQVRyckFGUHg2ZVBBbnNPL0Qy?=
 =?utf-8?B?aDlKT2RqSXhtRlJhWXFMN3dNTTR5MVF1V05Xdm1abURsSVRncnJQTzBvbUpq?=
 =?utf-8?B?WDR4cnR6djBIa2hDNkVVb2Y2QzFEMlhMQWR4dmVCZkZWU1Vya3Qzd3JYdFlT?=
 =?utf-8?B?UGlONFBxaFo0SEpOUEs2b01MUDBpL1JlZU9icFBNN0lBOW94cFRFWmMrSUVr?=
 =?utf-8?B?OVVZNDNYZVVQSXRxMENXUWRSM0IxQytLYzcyYnV0eG1mSThkcmVjVDQ3WVl0?=
 =?utf-8?B?TkRBNXVSSVhvMHhUNEkwcHJZRHJjV2trNWdTOXBxVXBYaUdNS0NhZjFybmx5?=
 =?utf-8?B?Njd1VE1PY0RFUjRWZ1p4T2Z1eGFsM1RwUVdpWkxBR214UVZ2NEhrMTNuckFq?=
 =?utf-8?B?K0RoakgyZ0Rqb20vWXV4NDdSdDVHQ2QxN2NoL05JSXR1Zi9DbGpldEhzZEJL?=
 =?utf-8?B?dlpIWkxEbHlHaTZGbzRmdE96T05DK0ltcFRmYlVFUk1UbkNmUUZ0OHZ5d0p2?=
 =?utf-8?B?a2dsdXRvc2I1cGRERXJ4U1R3clBST1NwUzlkVTZlRGtGbkNWdFpVUVZ1cjBP?=
 =?utf-8?B?Y3dYRWNFQ0duNlpUaVlYUUI0djFJWnppUHBwQ2Znc3EvS1RSNnkrbkdwNnJi?=
 =?utf-8?B?NE9LSS9tSnhrdHBhdlpGNjRBK0Z5bjdydDQ3c0VzSnFQVXNWK2Fhb3p1R2hF?=
 =?utf-8?B?enNOOFlHRjJES3lzR3RJaHExWWdXd2wrQnNVNTJGRE9BaXkyMnpxbEVhYmxX?=
 =?utf-8?B?ZWZMczh4ZldQRWZvRUVKb2pMdGpCK2loZ2ZSUjhYVEdtR1hQeHpRU05pYkpu?=
 =?utf-8?B?U052ZkQwbEVwRGFEcFhFSE1YVFR0Q3R5ZW91a2dYeEphZG9jRVczQ3VpeXI1?=
 =?utf-8?B?K0lhV1VVbVREaDR3TVR0ZzdTVUlSK1EvcmRKNmxzVmdmN25nelFQV1JsbnNo?=
 =?utf-8?B?d3JnUjB4QlhKNTMwT2hnOTlMU3YvazBRMTc3TmtnTWcxVW4xMWxFblpVRHI4?=
 =?utf-8?B?ckZ1ZTVpWmxMRitFaDB6RmpVeFFCbkRoOFUxSjBRMWJnV0N5c3o3bDVHQzRk?=
 =?utf-8?B?VXhTOENVek16ajkxdFpDSXhpWnNIY2JJemRpampwTk1scGJHSkJmZzM4R2Nq?=
 =?utf-8?B?eElwUHdIUTQxWXNVR0hOUEcyYjNzNzc1dmpZZllXM3FYaWg5TXBsWEJlZi9N?=
 =?utf-8?B?ZDU2L2dtNXdDcEx4UHM1NjMrVlNVQ1RqWlEzT0F0cFVESGg1QVZvN1h1Z0Jv?=
 =?utf-8?B?WnptVkJlUnRuS0VOT3pHWW5HS1orcllwYlNZVjZBOEFtNGVuZ2I2ZWg0WVAx?=
 =?utf-8?B?RUQrdGNqbnpHWnh5Mk1KUkZJaEVDK2QwbWVMMTd5QSs0emdzU2NtRDBwMUlZ?=
 =?utf-8?B?SlpDYk1ZTDhNd0h5bVp6QS9vWmZTQUJIZmlnaFZoNzJHQTBOTU1rbjF6SCtv?=
 =?utf-8?B?NDhxODB4Vld0OTU4Q1FCeTZMNndDV2syalJ4Tmo4bEVLdXBqUXhDZ3VMVm9T?=
 =?utf-8?B?ZU5SaTh5dGpjZEw2cmFzekh1Q2xHSjRzdk01UEd2Y1ZjbjY2ZG5CbzlMc0d2?=
 =?utf-8?B?U1VyNWk0VFhUNjh6UnN4NDY1ZW5KR09YeG1hYjZ4TEI3NWNNVkYxZWpxSzNC?=
 =?utf-8?B?YnlPSDg5QXluWFJGazFKVHhVdkFGYWxhaXFQK2FHNWwvNFRqQTQ2RUFBOUg1?=
 =?utf-8?B?emliTXo0TDhlak1PS1pDV2RJQUFSQjlQNmo4V3pacWdCVHBabmJZL01uZ2JT?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8C99FF110D49A4CB6492B9130F18FBF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14af9af8-a9fa-43f9-407f-08db782f9df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 23:30:11.1812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3BR9xc9V4chmXG5T5HZUEsJxAIpEno0Jeyd8S3ihOlGxnDeK426qETg0APgyCv8375hDVY9tA4+y+LT5nZxeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjAyICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzZBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gPiAgCWNwdSA9IGdldF9jcHUoKTsNCj4gPiAtCXNyZXQgPSBfX3NlYW1jYWxs
KGZuLCByY3gsIHJkeCwgcjgsIHI5LCBvdXQpOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBD
ZXJ0YWluIFNFQU1DQUxMIGxlYWYgZnVuY3Rpb25zIG1heSByZXR1cm4gZXJyb3IgZHVlIHRvDQo+
ID4gKwkgKiBydW5uaW5nIG91dCBvZiBlbnRyb3B5LCBpbiB3aGljaCBjYXNlIHRoZSBTRUFNQ0FM
TCBzaG91bGQNCj4gPiArCSAqIGJlIHJldHJpZWQuICBIYW5kbGUgdGhpcyBpbiBTRUFNQ0FMTCBj
b21tb24gZnVuY3Rpb24uDQo+ID4gKwkgKg0KPiA+ICsJICogTWltaWMgcmRyYW5kX2xvbmcoKSBy
ZXRyeSBiZWhhdmlvci4NCj4gDQo+IFllYWgsIGV4Y2VwdCB0aGF0IGRvZXNuJ3QgaGF2ZSBwcmVl
bXB0aW9uIGRpc2FibGVkLi4geW91IGRvLg0KPiANCg0KQWdyZWVkLiAgSSdsbCBjaGFuZ2UgdG8g
b25seSBkaXNhYmxlIHByZWVtcHRpb24gYXJvdW5kIG9uZSBTRUFNQ0FMTCAoZm9yIGVycm9yDQpw
cmludGluZyBDUFUgaWQpLg0KDQpCdXQgZG9pbmcgdGhpcywgaXQgbWFrZXMgbW9yZSBzZW5zZSB0
byBzcGxpdCB0aGlzIHdyYXBwZXIgZnVuY3Rpb24gb3V0IGFzIGENCnNlcGFyYXRlIHBhdGNoIGFu
ZCBwdXQgaXQgYWZ0ZXIgdGhlIHNrZWxldG9uIHBhdGNoIHNpbmNlIHRoaXMgd2F5IHdlIHJlcXVp
cmUgdGhlDQpjYWxsZXIgdG8gZ3VhcmFudGVlIGFsbCBvbmxpbmUgY3B1cyBtdXN0IGhhdmUgYmVl
biBpbiBWTVggb3BlcmF0aW9uIChTRUFNQ0FMTA0KcmVxdWlyZXMgQ1BVIG11c3QgYmUgaW4gVk1Y
IG9wZXJhdGlvbiksIHdoaWNoIGlzIHRoZSBhc3N1bXB0aW9uIHRoYXQNCnRkeF9lbmFibGUoKSBo
YXMgYW55d2F5Lg0KDQpIaSBLaXJpbGwvRGF2ZS9EYXZpZCwNCg0KUGxlYXNlIGxldCBtZSBrbm93
IGlmIHlvdSBoYXZlIGNvbW1lbnRzPw0KDQo+ID4gKwkgKi8NCj4gPiArCWRvIHsNCj4gPiArCQlz
cmV0ID0gX19zZWFtY2FsbChmbiwgcmN4LCByZHgsIHI4LCByOSwgb3V0KTsNCj4gPiArCX0gd2hp
bGUgKHNyZXQgPT0gVERYX1JORF9OT19FTlRST1BZICYmIC0tcmV0cnkpOw0KPiA+ICsNCj4gPiAg
CXB1dF9jcHUoKTsNCg0K
