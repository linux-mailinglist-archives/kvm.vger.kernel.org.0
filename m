Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EEB6D85A6
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjDESGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbjDESG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:06:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B69E6584
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 11:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680717953; x=1712253953;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6/0BQ9mAYYiaAqmRYr4dMJeSD3EJAkntxjnhjtG24YY=;
  b=il87eLxyBiWcq7uasFWoooeJ9yA+lk4xqDxQ+iI9vTiRbNRZ7KNjvRY0
   VRdsY/BpYDyBwm3ZcfJefoq7kLVHer7ZTPteNk8aCRL7fFh0sW/LkaRaJ
   8t0VgpoNTV/er5nG5rIz+jrT8sAV1wO8rvANAtlH4Z80d6F95r+7eYxHt
   51f8N+Vfe2K2u7V42xTuEFg+2VYSa9WISmwLJfMPhkLxXL7EtFgUm5ey7
   1+irnin3Kyg920Yz2NGKy2sh2PvPKlwddriByycz2Bw5pfjM/PEgboQ8Z
   kiQ1K+o9z5s1Ns0I09LRWz1VIvgLDvc/hyuitLyDSYktiC3SkpTjWce1p
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="342540872"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="342540872"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 11:04:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="861067398"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="861067398"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 05 Apr 2023 11:04:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 11:04:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 11:04:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 11:04:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 11:04:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kP4vz28+Ym5dLc+kfhBFvpKN1w7RJeMkiwMclDCQB/Cw16WH/jyri4RRrzOuvg4ByzVF/L22VwZ+we1hHAb6aiP8To+Dk3v67t6id0XV3ANyHUyjl6JZIrkrUfFZOn/udfthpaQl6Xz8asbMMKhySjeg+OLHjVBdguHC1lzwKfjA9LACkGYKDVX+23atPL7hFquGnkdTe9WwaxRM3iKO5hoXgj8ULNNdE/okUf7D2XV7VmvNa6AW6Lozt7vQ7k1J6+e+5psOalP3djZAWX5olN4A2vJ/1QDpbm+OB2i3wuR25y05kUVSETSewQirDR8zKLoK2ANw1FBV/NQbDW0twg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/0BQ9mAYYiaAqmRYr4dMJeSD3EJAkntxjnhjtG24YY=;
 b=nXTAD482sO2aTsmkHRXiDc3FnXgJOELBvpDK++E8hwFANhjT4TWjl4UWwr4uPgaAHZ0qihW8738RtmiDj1Q3vSWkVpIAvVw5xHe9YGjAAlyoEpQOJ7lXQoIKcdiziyb5Uk0ejtLKFDprq5XvGNVJYc4WifQAXo0+t5axOpPRauwtgBNQVF6dHIxTf2UZQ/UYpXO0XfLYIwQMMsJ/u4ODtL8JtCedje8aG1lLrtCGzXpW/IprvTfITqm7chmYHkM8TK2ZxdlXChVVLLFDNL/B83CGGe8xTiVxA/6See3Tba1U9h7lbkr93Je+x1+99vEMEakm9sGd3zeZZpwn4cH6Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MW5PR11MB5786.namprd11.prod.outlook.com (2603:10b6:303:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Wed, 5 Apr
 2023 18:03:56 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 18:03:55 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: RE: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Topic: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Index: AdlnGoO7DMFQx8JhSoqsl2dQLdydDAAn9S+AAAre6EA=
Date:   Wed, 5 Apr 2023 18:03:55 +0000
Message-ID: <SA1PR11MB673431B687B392B142129E72A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <CABgObfaJwgBKkSfp=GP437jEKTP=_eCktdiKcujeSOgwv9dbiQ@mail.gmail.com>
In-Reply-To: <CABgObfaJwgBKkSfp=GP437jEKTP=_eCktdiKcujeSOgwv9dbiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MW5PR11MB5786:EE_
x-ms-office365-filtering-correlation-id: 4c799b87-e805-467f-939d-08db36001f27
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y6B9ThEC535SeSSk3Cr4Z6Oif35Pqg2uGWDOJrEg2opbcQN5DaRVFJGTDCroGpWR9uNBd+gTMRfIDOr78uvvodNifajbHESAiAOqAp1rFux8AOp5UBkMLKxghHLgcRWM9i7oupFv6cDTqyF14D+CqhPyEUIvSU/mQPHcjEf7Qj76hlMF3p3UgUSHaEUGTB4XFbCYQMIeA7HNpU0CfBt2bvPymjkgonkFzeNy+P9d0e8OxpQLO2nYrx0sw8AyVflrSQRLZ55WKg6z6rLIsfCtfUwDNQJrAtKgE8/bx0tRzU5Y1NH5jcsuil9r/pYjogWZpQSWYaO5TemvLOXWGj+uNvlOYMtRFAea7ExLiYqCoRj7p8q5PO5oHqzwlDLV98u+iYQegiCQV3iKzAiY2KO40m+vm8DRjOd/q8WDXCoUucBHVhvvF+R1VrHOsaEr9d2uon1AxymqeZTrLKw+LH9YlNX6SSd/7lyQQ3MXkzPGOf5vJk0SwdiP1BgClIj3Li2rAwBJsxXU6tOlUXnwBxPtE7ZjoTYs/F1OR6EJdMrw/OA6rY3EvsZJlMo0EiZPD2lkQ817K4Cmtv1TOzyPfOlQPZLkflM5lLXiKHgeOsgjVi7qEJe/5C9AQwoL13fmTPQz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(71200400001)(86362001)(7696005)(186003)(33656002)(9686003)(6506007)(26005)(53546011)(6916009)(55016003)(8676002)(478600001)(52536014)(66476007)(316002)(66556008)(4326008)(76116006)(64756008)(2906002)(38100700002)(5660300002)(66446008)(122000001)(66946007)(41300700001)(107886003)(82960400001)(8936002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHo4Q080TnFyQWFPZER3RHlncnJmS21qUmRTOUc2ekxiVG9xL3RDVGo1K05q?=
 =?utf-8?B?MTg3UDdJZFRoaVZ3WWNUeDJka0dZdURSUkg2TGhJdXIxLzc4amloaDZ5Njcy?=
 =?utf-8?B?VmRJQUhmNzlHN3hOVGNISXFmN1VBQlhMM0hRUHEwb2Y4YjN6cGlsVEpJR0V3?=
 =?utf-8?B?ZjZYTTBGZFB4a3l2YTFRUzdDY2M1SnpHMDRqSUdpMUV5MTBEcDZEZ3FnNnlq?=
 =?utf-8?B?YUlScG5MK1ZxaEIreVFDVmZMS1c0UGJFOUJOc0tFL0gyQXR2NUNhdVczZTNP?=
 =?utf-8?B?MXJOM0pzT1NCMXlSRlBrUzEzeFdEeVJ5aGVQNDgvdkUrdThUK1RFMjN3YTBJ?=
 =?utf-8?B?R3hPZ2kxRStvSnFISXlTT1ZkM1pRSDRRNUovK3hUeG1SM1R5d2FIdWk4MVl3?=
 =?utf-8?B?NFVJVVd1bHUxRGxsWTlJQzRQVEVLeTZwVkF4ZFZHZ1FxYXU3SHNWKzZCTUpp?=
 =?utf-8?B?cWVKcmpqQSt6N0ZSUVBzc2NlamxlNDFIMU9nWHI1SVBvejY0U2ZnSzk5cmZC?=
 =?utf-8?B?a1lrYkNnNnk3WXYxaWdGdzlTeUdGc3paT25Dam1saE9LODAza0RNbjlSUklV?=
 =?utf-8?B?OTNRZ0MzbUJic1FGQ0pWM3h3YmxpMVZFdHV2VmhReHBSWDF0MmxSRUd2Myt4?=
 =?utf-8?B?SDlWOEJlcU9yZGVtNVdqaDhaQXp6NlNOZFh3aFBaeE11TXVab3ZaQ3grUTNt?=
 =?utf-8?B?ckNLRkZ0bmlyY3BNUnpYOGFUaEtqOXNpSk9haTd3MHBSdEo4YkxPdFJRVVpi?=
 =?utf-8?B?KzB0Y0dDQW5Zb3ZlN1ZtNmZUK1c1dkpDMWQ1eXBSSUxmU2JqaWZSMTZ0UnJ5?=
 =?utf-8?B?cUtVU01yNVA4a2ExZHhOVXU1MXhZWnpoMFdLclFicGVobXRDRFZyOEhpZzNq?=
 =?utf-8?B?NGJDZW4xRlordnA4RFJQcHVYL0hGSU1qZjNuRmE0MHpoN2tLUVVRYjZidGJG?=
 =?utf-8?B?N3NhVHFaakhJaFBWRUFSL3ZRZW1YMHNpeUc1REdQdW1qNzdyLzBJR3BZWGZw?=
 =?utf-8?B?MFZzUXpzVE5aWVRFRTRVeDdJYkpMY1N3THprQWhFcWxERjNpNUxNeDMyVkd4?=
 =?utf-8?B?Zm1LREU1enJRbi9keHpnVngwYXpxMHFoSDBVUWlOTTlORm5rVVVUNmJuanJt?=
 =?utf-8?B?VzRFdDdycE1TVHhMa3ArR20vVERnejk2SG1pVWlDQWlPbHNNT0V5QzVTaFBZ?=
 =?utf-8?B?L2ljcWJiOGRKalVYcmliR3lObndnaVhmUW50K1paVFVTK3o5SmlsaWJKQzlH?=
 =?utf-8?B?SG5xOVY4TG1xTlBGUnlGVURKbUh0c1AyK3EvekpJV0VmSG55aEg0YVFydk1Y?=
 =?utf-8?B?MUdPQXRvU0VwVE9CTi8vU2pGeUFzai80QnluelloNk5ORFgzcVJ2eDAvem14?=
 =?utf-8?B?OEZmUlFteTBsdm5zNXlLQ1RPaEc3djlQcDdaTVJUWDVxTWJyM0tMV2M0Nisz?=
 =?utf-8?B?NDIrMmRIdE1nK0NRVHZ2czUvd1FUTjB1bWJ1SzZJVnpreEtTZ3hNbG9wVUkv?=
 =?utf-8?B?RHA5c2Y0ZVI4WFZoOEJOcUxqR1hURGVvenp2VzNGSWtSSGZZNFc1bVZvcDRK?=
 =?utf-8?B?d1NtaUdCZHNuclUvWnNnajdOMkQrckp2L0cydS8rL3NOOFVYZDFaUys2SzBF?=
 =?utf-8?B?akZGSWU5dkFWaDBjVndUc3lDNS92YlR2L2l4OFRFbnduNjQwSWZxQ2xWZ0tI?=
 =?utf-8?B?a2twQVY1YVZlMStiUWtZczlKSUtBWmtEQVhFbmFMWndOd1ZqTkJGZ21rY3c0?=
 =?utf-8?B?UFdsZVZjdUJadm9NVjN1ekZ0RWNXRTRFZnkwTStNQ1BSd1ArZXNJWVBjVDBa?=
 =?utf-8?B?VWFrektwRzJUZ2UyMFFHbGh0Q0hnOENLWk5HcnhHb1ZFYXBzU1ZGKzVKNVl2?=
 =?utf-8?B?Mzg0RmZ3WXlsZlNVVVg3aTVuSHRsK09TU3g4MHBmQThudEk2UUpzQVBEMzlM?=
 =?utf-8?B?SGNlSEJzQW13YUhXTjNMYU5kRlBNbno1NWtxN1c0SkFIalZFN0N3bENWYVRU?=
 =?utf-8?B?SW9NaXR5c1FuTmI0aFZnSE8vOE5GY0pubzRIVHV5TFZNZkVRaVBUSWRpa0lE?=
 =?utf-8?B?UmxjUWlFUTJ2V2JHT0o5VmxjR3crWkdsU1ZUd2xldmFQUjRJYythdCt0M0M2?=
 =?utf-8?Q?T0sg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c799b87-e805-467f-939d-08db36001f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 18:03:55.3065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wJ34OuB4QLkQGkHSB9iFhACO7AqW87uMvJ+roP+mGU2R3XOJrsrIrxh1JQLX6ale0V1kjKtv8P/++gSY2Y6Mow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5786
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBXZWQsIEFwciA1LCAyMDIzIGF0IDExOjM04oCvQU0gTGksIFhpbjMgPHhpbjMubGlAaW50
ZWwuY29tPiB3cm90ZToNCj4gPiBUaGUgcXVlc3Rpb24gaXMsIG11c3QgS1ZNIGluamVjdCBhIGhh
cmR3YXJlIGV4Y2VwdGlvbiBmcm9tIHRoZSBJRFQNCj4gPiB2ZWN0b3JpbmcgaW5mb3JtYXRpb24g
ZmllbGQ/IElzIHRoZXJlIGFueSBjb3JyZWN0bmVzcyBpc3N1ZSBpZiBLVk0gZG9lcyBub3Q/DQo+
IA0KPiBGYXVsdCBleGNlcHRpb25zIHByb2JhYmx5IGNhbiBiZSBoYW5kbGVkIGFzIHlvdSBzYXks
IGJ1dCB0cmFwcyBkZWZpbml0ZWx5IGhhdmUgdG8NCj4gYmUgcmVpbmplY3RlZC4gRm9yIGV4YW1w
bGUsIG5vdCByZWluamVjdGluZyBhIHNpbmdsZXN0ZXAgI0RCIHdvdWxkIGNhdXNlIHRoZQ0KPiBn
dWVzdCB0byBtaXNzIHRoZSBleGNlcHRpb24gZm9yIHRoYXQgaW5zdHJ1Y3Rpb24uDQoNCkdvb2Qg
cG9pbnQsIHdlIG5lZWQgdG8gaW5qZWN0ICNEQiBvdGhlcndpc2UgaXQncyBsb3N0Lg0KDQo+ID4g
SWYgbm8gY29ycmVjdG5lc3MgaXNzdWUsIGl0J3MgYmV0dGVyIHRvIG5vdCBkbyBpdCwgYmVjYXVz
ZSB0aGUNCj4gPiBpbmplY3RlZCBldmVudCBmcm9tIElEVCB2ZWN0b3JpbmcgY291bGQgdHJpZ2dl
ciBhbm90aGVyIGV4Y2VwdGlvbiwNCj4gPiBpLmUuLCBhIG5lc3RlZCBleGNlcHRpb24sIGFuZCBh
ZnRlciB0aGUgbmVzdGVkIGV4Y2VwdGlvbiBpcyBoYW5kbGVkLA0KPiA+IHRoZSBDUFUgcmVzdW1l
cyB0byByZS10cmlnZ2VyIHRoZSBvcmlnaW5hbCBldmVudCwgd2hpY2ggbWFrZXMgbm90IG11Y2gg
c2Vuc2UNCj4gdG8gaW5qZWN0IGl0Lg0KPiANCj4gKExldCdzIHVzZSAic2Vjb25kIiBleGNlcHRp
b24gaW5zdGVhZCBvZiAibmVzdGVkIiBleGNlcHRpb24pLg0KPiANCj4gVGhlIENQVSBkb2Vzbid0
IHJlLXRyaWdnZXIgdGhlIG9yaWdpbmFsIGV2ZW50IHVubGVzcyB0aGUgc2Vjb25kIGV4Y2VwdGlv
biBjYXVzZXMNCj4gYSB2bWV4aXQgYW5kIHRoZSBoeXBlcnZpc29yIG1vdmVzIHRoZSBJRFQtdmVj
dG9yZWQgZXZlbnQgZmllbGRzIHRvIHRoZSBldmVudA0KPiBpbmplY3Rpb24gZmllbGRzLiBJbiB0
aGlzIGNhc2UsIHRoZSBmaXJzdCBleGNlcHRpb24gd2Fzbid0IGluamVjdGVkIGF0IGFsbC4NCj4g
DQo+IElmIHRoZSBzZWNvbmQgZXhjZXB0aW9uIGRvZXMgbm90IGNhdXNlIGEgdm1leGl0LCBpdCBp
cyBoYW5kbGVkIGFzIHVzdWFsIGJ5IHRoZQ0KPiBwcm9jZXNzb3IgKGJ5IGNoZWNraW5nIGlmIHRo
ZSB0d28gZXhjZXB0aW9ucyBhcmUgYmVuaWduLCBjb250cmlidXRvcnkgb3IgcGFnZQ0KPiBmYXVs
dHMpLiBUaGUgYmVoYXZpb3IgaXMgdGhlIHNhbWUgZXZlbiBpZiB0aGUgZmlyc3QgZXhjZXB0aW9u
IGNvbWVzIGZyb20gVk1YDQo+IGV2ZW50IGluamVjdGlvbi4NCg0KVGhlIGNhc2UgSSB3YXMgdGhp
bmtpbmcgaXMsIGJvdGggdGhlIGZpcnN0IGFuZCB0aGUgc2Vjb25kIGV4Y2VwdGlvbiBkb24ndCBj
YXVzZQ0KYW55IFZNIGV4aXQsIGhvd2V2ZXIgdGhlIGZpcnN0IGV4Y2VwdGlvbiB0cmlnZ2VyZWQg
YW4gRVBUIHZpb2xhdGlvbi4gTGF0ZXINCktWTSBpbmplY3RzIHRoZSBmaXJzdCBleGNlcHRpb24g
YW5kIGRlbGl2ZXJpbmcgb2YgdGhlIGZpcnN0IGV4Y2VwdGlvbiBieSB0aGUNCkNQVSB0cmlnZ2Vy
cyB0aGUgc2Vjb25kIGV4Y2VwdGlvbiwgdGhlbiB0aGUgaW5mb3JtYXRpb24gYWJvdXQgdGhlIGZp
cnN0DQpLVk0taW5qZWN0ZWQgZXhjZXB0aW9uIGlzIGxvc3QsIGFuZCBpdCBjYW4gYmUgcmUtZ2Vu
ZXJhdGVkIG9uY2UgdGhlIHNlY29uZA0KZXhjZXB0aW9uIGlzIGNvcnJlY3RseSBoYW5kbGVkLg0K
DQogIFhpbg0KPiANCj4gUGFvbG8NCj4gDQo+ID4gSW4gYWRkaXRpb24sIHRoZSBiZW5lZml0cyBv
ZiBub3QgZG9pbmcgc28gYXJlOg0KPiA+IDEpIExlc3MgY29kZS4NCj4gPiAyKSBGYXN0ZXIgZXhl
Y3V0aW9uLiBDYWxsaW5nDQo+IGt2bV9yZXF1ZXVlX2V4Y2VwdGlvbl9lKCkva3ZtX3JlcXVldWVf
ZXhjZXB0aW9uKCkNCj4gPiAgICBjb25zdW1lcyBhIGZldyBodW5kcmVkIGN5Y2xlcyBhdCBsZWFz
dCwgYWx0aG91Z2ggaXQncyBhIHJhcmUgY2FzZSB3aXRoIEVQVCwNCj4gPiAgICBidXQgYSBsb3Qg
d2l0aCBzaGFkb3cgKHdobyBjYXJlcz8pLiBBbmQgdm14X2luamVjdF9leGNlcHRpb24oKSBhbHNv
IGhhcyBhDQo+ID4gICAgY29zdC4NCj4gPiAzKSBBbiBJRFQgdmVjdG9yaW5nIGNvdWxkIHRyaWdn
ZXIgbW9yZSB0aGFuIG9uZSBWTSBleGl0LCBlLmcuLCB0aGUgZmlyc3QgaXMgYW4NCj4gPiAgICBF
UFQgdmlvbGF0aW9uLCBhbmQgdGhlIHNlY29uZCBhIFBNTCBmdWxsLCBLVk0gbmVlZHMgdG8gcmVp
bmplY3QgaXQgdHdpY2UNCj4gPiAgICAoZXh0cmVtZWx5IHJhcmUpLg0KPiA+DQo+ID4gVGhhbmtz
IQ0KPiA+ICAgWGluDQo+ID4NCg0K
