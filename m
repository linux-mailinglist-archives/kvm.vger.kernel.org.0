Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB77A4945
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241891AbjIRMJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241982AbjIRMI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:08:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D973A0;
        Mon, 18 Sep 2023 05:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695038932; x=1726574932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WilOHYSz3usc72rm+4oj9/zRTpChVT/KlNHmL0PdHe4=;
  b=KyKpGKN1tC+G1V52M+Bu24+LF7qPQ3ldwhmG4FOZmQTmv/nLqQUjr/U9
   Rk+PYKuh+N6sNUoj9XgSeqULQ8WSe1voQxMtU5HM7Nhz7lBBD+3757VUb
   oz8gypY+D/QgT7fDS68YMrjHX+cux3azGJiAu9yubOPLFq+PzN09aMDz7
   ZUbtcYVHDbKQg4k6rPc1Xh1+3hNGpPaxpgvqdaiLFjFeTI/qLjinCkoPa
   LsOdmvCGDT6MYFBdxs3Bx7IrwJ3dwHBThnnNqDoYheCdpvKIk7sa4zXrn
   RY+zR1Y3w0hn0/fx8ZpprqVmXEneBT6oov+aN0y4H3//1/Nwom/RduFL4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="364679963"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="364679963"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 05:08:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="1076561154"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="1076561154"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Sep 2023 05:08:51 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 18 Sep 2023 05:08:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 18 Sep 2023 05:08:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 18 Sep 2023 05:08:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAcTs+eA7Uew9o7YdbNxYQTEXAseyLJZHLT2bcgAoUmLJCFlsKNZCW1+bEeLEiY8ViTXjYrGjBiRE9sOI+F8HM/Z1mAP3XXrzYHZhPxo0+MqTCuxj6tGsB1OdZXwYwQPVQuF5Q77kmXEq9+VTq0wuUCAsK8mC1eaIKNknuRSoUObUY6+mznaEn9nZHBX6GVzDbup3T6BWfHBmKPchX+Zi6cXQiOk2LoRh5JPUJVyycYDPVWFJSisN6uH5Eqo0H+wh8i4U/6aIJMGhZLqvoJe559ErAt9YrCqNWsbgc1v1cRI6GwqxbSdSeZB1QcSeRwCbAn6n4KPqI/iy0Ie7NmihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WilOHYSz3usc72rm+4oj9/zRTpChVT/KlNHmL0PdHe4=;
 b=mJJTlhnLy0KxJjB5gMh4Vkl+He6hEOqVLHRBl41ZWS73byKyB9++VkJeID+OcjnO+YJfCq/42YxRc5qcRf1ry5Ns9nGEG1bmrRb7tzZ3vcNu8ktOw07yeJV97hOYELMMh6aDVcKrEZcQhuSzH2BcV5BhLUAnpqzqgUHarFajO87DQ3512k5Mlic686RP+YQIjSMnTfBm5cqeEZQaL8eG2ZCtZ+MrDrRrP+mKVvehft7zEJJqpHVflNA+ZZwRP2SZeirVxEHDL61P4rHo3onxz3Y5w1MKFtGY4uQhU19vjcSsycLh60icv7ppGKpgx2wFPGrSp5gg5Tu7NNKFd0QdCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5507.namprd11.prod.outlook.com (2603:10b6:610:d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Mon, 18 Sep
 2023 12:08:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236%4]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 12:08:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHZ101KAStwdrBYX0OEVR8WxQ4LtLAcSamAgAAB1ACABFeigA==
Date:   Mon, 18 Sep 2023 12:08:44 +0000
Message-ID: <b6b5f6f06ccdbbef900cfe7db87f490aac3e77a4.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
         <fb70d8c29ebc91dc63e524a5d5cdf1f64cdbec73.camel@intel.com>
         <52e9ae7e-2e08-5341-99f7-b68eb62974df@intel.com>
In-Reply-To: <52e9ae7e-2e08-5341-99f7-b68eb62974df@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5507:EE_
x-ms-office365-filtering-correlation-id: 5367e6bc-8e87-4faf-1956-08dbb840017d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vPQxxX1OjgsTsnbvZ+kG21kN5G6TBisL0Xb/Q5rukRk3VEetJUgSxDWwiNDDHSKubb6+KtYo5oatnkW8ukzUEQUc9mhjIXAilpv8dHuAv8bdvMlaCcxtnUQBPIX00hFv7eth5Uwcz2AgGM8r/7B8qN3o9a4rxt38fohmpcXEJuxtaP3hL1uELx7RLd6TGjro/+NXev8aKv8bdjAf8l5UVkNeJfZRhR8bGKeAMSG95vwzbI1sOK2ySAGZLtrcZju6ECgjzoDRcs4tSXv4F01wrlifNOKGwW2BZCjymQyMKt5I7AOKqcgZDHJXSmpSMtuAziV6B7Z0FMmdchK0X8tGDtsYE3u54xV9AJrrqOj1EEGWlBbULWzIfNrbYT59t0aMkJua4ky28kzlSyJWKUqVGeLJ3o1Pr/Th5jTboYoNk7md4w52A4mrvNIthD72I+cMJ4gQrwMnZg6FNNCHl9kwif+wRkz+X2LrWZjnL1bLGKwUEyJLfkAgeYENxfvVI1istxQLfQ5B3/BnL2Du2+dsIcB0QJga0oqy+EqI0Nr3rWa2r3n8KhsNrVmZEfnVoOR9ic2pNfQ4LqtxpBFJAbJ+Oso3dJ/KzkBPuAF5UsHWDokynxWSvR/qwFFedZ0VAv3D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199024)(186009)(1800799009)(2906002)(41300700001)(8936002)(8676002)(478600001)(64756008)(54906003)(110136005)(66946007)(4326008)(66446008)(91956017)(66476007)(76116006)(66556008)(7416002)(316002)(6636002)(71200400001)(66899024)(6486002)(6506007)(6512007)(36756003)(5660300002)(86362001)(82960400001)(2616005)(26005)(53546011)(38070700005)(38100700002)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVBLTU95SlVmTXN3TC9RVmZnbTFNK1ovczhjQjZzTTh0M0JzMXdoMzAvdlBw?=
 =?utf-8?B?UnVoNldwOUJJaU10MWhrMFVsN0N1RGNoRVdrODEwN090VUV2cTFlRW1KbzNk?=
 =?utf-8?B?eWwvZWs5ZDNMVGtwL2tyMmRkcXNST0ttaFdod2NuSWt0bW1ENy9kSGN1cUZs?=
 =?utf-8?B?UHo3UmZDSnpFbHZxbDBrWk9LQU0wUHFOdHV5SHcxU1MyWUNTVm54QjVWT1VM?=
 =?utf-8?B?a3JKSUxITGtsRmcrek5nUVVOZXZrRForS2srR0pzVFdML1RvVHBldGFwOThS?=
 =?utf-8?B?U1hHa09VL1ZrUEtmRFNzYXlMM2VuaGxuSHZUclc5MHQvZFVUaHc3bXVHUDFy?=
 =?utf-8?B?UHRlRkYwTmc3dHY3R3ZkTkFRMElmWDZTbE4raGcrQ2V2YlVqQU9iSU9kNEFq?=
 =?utf-8?B?eUVHZSs3clpxWFdlS1V5M0dGR0JSZkZMYWhPVVZZd0EyVzV5TkM5Y0RWeXhO?=
 =?utf-8?B?RjgyVXdPTlNMcWl6bktkNjVhL1N1ZHN0bmZKMzI5RG9iZlNzVmlHWC9od3dT?=
 =?utf-8?B?d3M5TFIzS1dhZnIvQ3JiYkxKTXh4MTlpNUJ5Qng1MjQ5eGFuSUJSY3E4R1Yv?=
 =?utf-8?B?eUw0dXRzc1N2cG90TmorNmhqbnZSTUJDeU9LM215TU0relZwekdtVlBITmg4?=
 =?utf-8?B?S2EzcGwzKzR0SDZFMHpDaW5lTTJqd2MyRnNJcHZRMG1XWnZ6cFd3UHRNNGdF?=
 =?utf-8?B?QWV5OHF4d1FqRmxzNXdZM05rTWpVcDNUN1k5NiszZm9IajJrNUJSU0ZRS2lv?=
 =?utf-8?B?WFEwU1JMV3FyZ1R4QVdjNURJQkplbG05a0EwVDlJdEdlYmZScU95UzhUOG9K?=
 =?utf-8?B?d1IrZEFjYkkzL0YyUHVCd2FTSXpoRStzb0ZIYmRhL2s3MWh0RkFXTDRwbjNQ?=
 =?utf-8?B?b2R0dVFEbVZLK2Ftd3ZCN0ZtV3hPLzZ2ZmdrSG1UTjVUMVRQOE5MQys2NlYv?=
 =?utf-8?B?U2VsNndzckpkN0hVN2JwWHAwVnJpOVNhZVF1ZURxL2kyRzBTMTB3MWNVck94?=
 =?utf-8?B?YVBIZ2xPeDlMaWVMS1pvWWh2MG02SUQ2KzBXbFZMUTN2SE5qb25xSEtCWFVH?=
 =?utf-8?B?RXVrdmh1QzdSV2pQL0hUNVZ5dGx1akxlbWI1Y3VyZFF3emQyeEpvSHFiQWNM?=
 =?utf-8?B?Ly92T0JrM1RMSmhLZE5EYTU1WFpMb3IzYVM1UE1hUGRad3RhdjJrWmVFa0s4?=
 =?utf-8?B?Myt4UnBWUFgxN1RVOXh4NW9KVUgxZTIvanM2U3UyRjlBS3lpdXZRZktHNzhu?=
 =?utf-8?B?MEQ0NXpoUFJ4cVZkZVBoSFNjdkc4SzZVTUs5NXBpK09objlOdmRoM0tGQmxB?=
 =?utf-8?B?UmJGVFkwUk5PMXAvNUxwbC9hd1hFK3BtMTdKMUVDdHBER3k3RWJPMDU1eGlQ?=
 =?utf-8?B?U2JZUElFd2NOMEVIQ1VqdnBxb0pVU2dKSGNKOUFXN2tJcFdrSllYNXZSOGpY?=
 =?utf-8?B?MDNRVDVSU0w3cnFqRU82RjJzMEZpU1JlQS84TWxnSFdlSW9sYWJwYmdxRGNO?=
 =?utf-8?B?TFFRdkhWY2xGdDk1MVBYOGRPZnRraUMvQjg4eHBTRmpiVXQwUThPYmdSbGNG?=
 =?utf-8?B?cnNkbTlRWFZGRXlLQUV2S2Nhbyt4VjIwSDlPYXZvaEttYVJKU0VMVWtKNzYw?=
 =?utf-8?B?QXFOVVYwa1l0R2RiN2FCTTVFSUxmb0xWL1ZwR0F2bk1vY29mWGJTYkVVb3Ro?=
 =?utf-8?B?dUVyYzhKMkVNS05ETi9GQ09MUXpoa0hyeEFyclNPeW9hZ1R2L1kwR2tIaTFx?=
 =?utf-8?B?K0IzNlRjallINENCMUloNElpa3lpdVZLdmE3SWo4ZDJMTXNVcXJFdmY3eG5k?=
 =?utf-8?B?ZjZwZ21hSnM5ZmlPTnh4Q054UlUvTncyaE9HY204bjBKYU1JWEQ5WHVHbmpz?=
 =?utf-8?B?Vk1oR0VpQ00yY1dhNEN0RTdraGE4VllEeG5mWE9rVlBjQlpKUFZ2NzdjaXFT?=
 =?utf-8?B?OXFKdnhodDF6cjV0a3U3T0xiZmF1eklTWG9zY0FBRVcrWHdrWmVERS9TZFlt?=
 =?utf-8?B?cDZjVnNMV3d2dHJxS2xSbTBrTWtMT2gzRHh0T1RRYmgyN00vc2IzQkhtME5H?=
 =?utf-8?B?ZjgwTnc1dmQwMzUvREcxbHNKc0duVU9ZVjBLTmdnWG9QSWpwVVpMOTZ3Y0dz?=
 =?utf-8?B?WlQvSi9nZnJPcVdpc1REVGxiYm54V21hMjI0c00xa0JiTld1aHpJNlJLZnRB?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A68725AA5D511144AA77B76B7369414E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5367e6bc-8e87-4faf-1956-08dbb840017d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2023 12:08:44.4838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKHDAxOBufKilRv0nUSzxJ+1LedDyxfJSzGJBOtOR4/ZWQ6fwO8sX2RAN6HBWCriG6T31GQrX6BQCZJOMxvAcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5507
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTE1IGF0IDEwOjUwIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8xNS8yMyAxMDo0MywgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gT24gU2F0LCAy
MDIzLTA4LTI2IGF0IDAwOjE0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiBUaGVyZSBh
cmUgdHdvIHByb2JsZW1zIGluIHRlcm1zIG9mIHVzaW5nIGtleGVjKCkgdG8gYm9vdCB0byBhIG5l
dyANCj4gPiA+IGtlcm5lbCB3aGVuIHRoZSBvbGQga2VybmVsIGhhcyBlbmFibGVkIFREWDogMSkg
UGFydCBvZiB0aGUgbWVtb3J5DQo+ID4gPiBwYWdlcyBhcmUgc3RpbGwgVERYIHByaXZhdGUgcGFn
ZXM7IDIpIFRoZXJlIG1pZ2h0IGJlIGRpcnR5DQo+ID4gPiBjYWNoZWxpbmVzIGFzc29jaWF0ZWQg
d2l0aCBURFggcHJpdmF0ZSBwYWdlcy4NCj4gPiBEb2VzIFREWCBzdXBwb3J0IGhpYmVybmF0ZT8N
Cj4gTm8uDQo+IA0KPiBUaGVyZSdzIGEgd2hvbGUgYnVuY2ggb2Ygdm9sYXRpbGUgc3RhdGUgdGhh
dCdzIGdlbmVyYXRlZCBpbnNpZGUgdGhlIENQVQ0KPiBhbmQgbmV2ZXIgbGVhdmVzIHRoZSBDUFUs
IGxpa2UgdGhlIGVwaGVtZXJhbCBrZXkgdGhhdCBwcm90ZWN0cyBURFgNCj4gbW9kdWxlIG1lbW9y
eS4NCj4gDQo+IFNHWCwgZm9yIGluc3RhbmNlLCBuZXZlciBldmVuIHN1cHBvcnRlZCBzdXNwZW5k
LCBJSVJDLiAgRW5jbGF2ZXMganVzdA0KPiBkaWUgYW5kIGhhdmUgdG8gYmUgcmVidWlsdC4NCg0K
UmlnaHQuICBBRkFJQ1QgVERYIGNhbm5vdCBzdXJ2aXZlIGZyb20gUzMgZWl0aGVyLiAgQWxsIFRE
WCBrZXlzIGdldCBsb3N0IHdoZW4NCnN5c3RlbSBlbnRlcnMgUzMuICBIb3dldmVyIEkgZG9uJ3Qg
dGhpbmsgVERYIGNhbiBiZSByZWJ1aWx0IGFmdGVyIHJlc3VtZSBsaWtlDQpTR1guICBMZXQgbWUg
Y29uZmlybSB3aXRoIFREWCBndXlzIG9uIHRoaXMuDQoNCkkgdGhpbmsgd2UgY2FuIHJlZ2lzdGVy
IHN5c2NvcmVfb3BzLT5zdXNwZW5kIGZvciBURFgsIGFuZCByZWZ1c2UgdG8gc3VzcGVuZCB3aGVu
DQpURFggaXMgZW5hYmxlZC4gIFRoaXMgY292ZXJzIGhpYmVybmF0ZSBjYXNlIHRvby4NCg0KSW4g
dGVybXMgb2YgaG93IHRvIGNoZWNrICJURFggaXMgZW5hYmxlZCIsIGlkZWFsbHkgaXQncyBiZXR0
ZXIgdG8gY2hlY2sgd2hldGhlcg0KVERYIG1vZHVsZSBpcyBhY3R1YWxseSBpbml0aWFsaXplZCwg
YnV0IHRoZSB3b3JzdCBjYXNlIGlzIHdlIGNhbiB1c2UNCnBsYXRmb3JtX3RkeF9lbmFibGVkKCku
IChJIG5lZWQgdG8gdGhpbmsgbW9yZSBvbiB0aGlzKQ0KDQpIaSBEYXZlLCBLaXJpbGwsIFJpY2ss
DQoNCklzIHRoaXMgc29sdXRpb24gb3ZlcmFsbCBhY2NlcHRhYmxlPyANCg==
