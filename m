Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26CF6D78AF
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbjDEJoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbjDEJob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:44:31 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7D91FF6;
        Wed,  5 Apr 2023 02:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680687866; x=1712223866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/UFAniil4AoZnyrRIAyKaoddVcSuHe0iVK+hdts8SX8=;
  b=eqknoqo/5YhzKsh1dqR/Bo96+/N7GtxYFrfTwOBfHX2BlolemZxQ0jJP
   +jAaLXJMEKv1Lbl0b1OdVFN5Al7W7ABjngOE5pMEpEO1S6j/iSHjGtfdT
   OuQ+RyXBf9FKyU+gTKUqrldqnwkP1lrWhwqzgK2le4WiEl7fNJLfG71ND
   gGNs9rlbmHezp/fn5wqGvJ7m9ZN7B6N1CGa3hksI6xOS9XH9Uwykl95gn
   CHnEoRWXKpFBuPF97Jh6x3SM6Hm6m9Lif6w4ZQqYAEdPsR4CM5RHUKI+S
   yDprxgTAe3FbxR8gPFcCaQvX6OJEF5JI3n0GQ+WF5bbRr1imdXMPXMn6N
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="370234478"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="370234478"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 02:44:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="636834912"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="636834912"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 05 Apr 2023 02:44:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 02:44:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 02:44:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 02:44:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EudHXfWnJ0llVgYbBlb8L4iCUdnjZiFRdk+fiYYafBORiJ1bCaifJtij53p5/FViVbj3TbTKoE1rXFB9aYS6nEmpCrCgMJ+4jAc3yghIGwmpdaqDBDSY6VGnLQpzZPMrI8uBF2SIr0Kx9SpkJx5actySTEzplHZArl0dM7wJxxZ1dbyLrMjBnWdPHqUvTxH3/h2Dgi9iFlIpuzqOz1rFP6GX5Yt5eFVx8Lnw1tF/x7vTXfilbcg66ZOY7rNNzEcQ2qKKkXcuM4hfOmxGdHkm9m9b3RdQwyc/WPrHSTUjb2jF+VC4GbY1Mh21CtJi5WEE2JmMwjbVl/AeYa9l06PCHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UFAniil4AoZnyrRIAyKaoddVcSuHe0iVK+hdts8SX8=;
 b=jplQVDMIrlYAiI9AAKCTFgI9qkznACrwE0bTNBbizn0bZSL77OAPgrRf+g2n83BykZIa6g5Znjy6+4eN+WMMCZlJ2bVWKZ/ursHHIkQf5a4huNMs7gvAPqfFIVosKYp7mQtDGPXCPFEHdTOZjoMn/HHQO/a+VFwtaxXqwK/MOlIGhtsoGQchbMtt+P4jxGSYYbMDZXn5Xz0/lu+w3Yow6IcsDXdOjl99mpBixeM66sfW7dWYqgEk1LsgzQ1Hwf1o+nIQEFqbl/0jamj791hYaP0icl7D/sx76qdTAWMvwsg2ZGN/lccYZwBiG+ARphuufREvqUQXAC9zpLuCuchWsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO6PR11MB5650.namprd11.prod.outlook.com (2603:10b6:5:35a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 09:44:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 09:44:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Topic: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Index: AQHZZ1neAPY41R6lzkG8Mkf04T1Dpq8cd6WA
Date:   Wed, 5 Apr 2023 09:44:13 +0000
Message-ID: <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
In-Reply-To: <20230405005911.423699-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO6PR11MB5650:EE_
x-ms-office365-filtering-correlation-id: 01f57d5d-5f7b-4398-ae67-08db35ba50bb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ztqioJOOsYGx1KChrZeDSSnzUKIigaRzhPkT38cScnSvfEv/Y9ipY5goapqyMe9efxOpQGhXuIvQS5qflelWJoc9wT4erqCeEC+2un0Bd0sAS3pHpNNqI/tPn3mls86rtuPBi6lBZLDGyhAIuIlJkfndlxW/392STkDXKQJrj0sAF3pYmmnyIFH5ft8mavay94PYuTyylbjiHW/ZlAFJvAgUqpSuj0U5/USVcbHpR9x9AiCk+G6DrqnTaAMiKP4yDq1v4vfqG214LfkVaN+6DK6lqO2n05x6pA5tOE/Ae2eP3UKodhMTDXK9z15NBykD3wg3GKC7UsooEEPPA2prt925G/hQ8fbBD+/mR1CtFRFfV6hSHdxK+Hu+w9qemQUJUah97SgwwfdrtFrNY7ewMrpXR3s0cRXnSEMmAxlBeSJHvamejPfQY3GF7SLJ+aQOnfAG7BYCEfzz04E7oi6gOQ9MaPztOM1SO0+keXGcQzgdWdkxbDqwVavis0WnMfLOGjsj9TbPkhGUwpeY92eNsqi/jms5CbxEigkHIFeax5iGZZgJf8vHLm5U6W5Uh42xkFU9/kBLkncnrB7XJWpR3p1s3iM785+6d65d/eYpKIT/4Cj8lgfxp84CFstkbgjE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199021)(4326008)(38100700002)(36756003)(5660300002)(2906002)(38070700005)(66946007)(76116006)(66556008)(8676002)(122000001)(66446008)(66476007)(41300700001)(64756008)(8936002)(86362001)(82960400001)(91956017)(6486002)(83380400001)(2616005)(186003)(6512007)(110136005)(54906003)(26005)(6506007)(71200400001)(478600001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXV6aitTTW5YYWZXV29TTjRHa0htN1dWRG16eUV5TXcrN08vQ1JwaEpmUmwy?=
 =?utf-8?B?bmNEam1xNjI3VWw3LzhZVlllRU1MOW1rYThJam43QjRWNW9lZlhCSUpMa2s4?=
 =?utf-8?B?OWtQV3l1TGFOaktiQ3BRd3FLcnN5aERYemJkakpUR2tqR0c0dXRIbVBucGx0?=
 =?utf-8?B?YnVvWXhKSzJpcVVTWWd1ZFhzekI2T3h5bVVWZU5ENWR0VWdmbDVKS0s3S0lO?=
 =?utf-8?B?WHk4Q1A2RHhBREd5Ti9nUFoyS01JQzN0eHN3ZDRjcGJ4ZktmekpPeU9aSVBn?=
 =?utf-8?B?L0pmendQTU1kdG91bFpOY3NCT1JEcTM0eGVOalErb2ZraG56cEhqUk91ZnRS?=
 =?utf-8?B?NlFwTlBmWDByRVlHVTlMSHg3U2pjMFZOK3M2elZ6WnZWR3hhTGg0Q1VObERo?=
 =?utf-8?B?ZGdLNi8wclQ1blA0M011STNRZSt3L2owVGpxME1pMXZ2ZGl0V3BTVDgrTTRn?=
 =?utf-8?B?WTBRdEdlT2VoRFRManFURVJIazdVMFU2RWpBREpucFBHQ0V6SjMzcVRYbnRQ?=
 =?utf-8?B?VkErT2pTL3RrUTBFZWUrQ0luTXVncEJLRUdjWVpyWjBybjQ0UGVkeS9pTHRp?=
 =?utf-8?B?QmxUMzluN3VZSHdqbXNEekJ0N1VYT2FVWEdYRU5uSkQ0Y3R2c21JOHY1cWJO?=
 =?utf-8?B?L2pidkdEVy82Mi9pU003czRhWVpMaTR2MGVVYTBQTWxLbDlUQVRJaGM3SENS?=
 =?utf-8?B?RlMxWWpmcC82aEdIRmdKZ2FBcjYxc1RISjhEQW5tZVhGRmFEMlRMT08yU0hy?=
 =?utf-8?B?TDhaT0ZYUFZud2RybFJTOXhqcXlkOSt5WjRqZkxMdUFNMGtyZms1bjFUKy8y?=
 =?utf-8?B?YnMvNkt1bmpvY2RnTSsvUGxsVHFWdFNIMXBLWmJwZDJYbWxab0h2TlJUSmtH?=
 =?utf-8?B?bndUQzVHUWZ5cDhMUDBFZlNJbTV5b3lYQW5ZU0trMjNCSlhLbHBHWFhER2l6?=
 =?utf-8?B?d1FZT3RsZ3I5ejMyWmI4dW5KZ1NBZmIwM3FCcUI3RERuamY3cHRuQklyMWF3?=
 =?utf-8?B?L3d1aDRUcXFhWkRUZTk4cXcrVzk1YXVzWWJnMVBybThuKzM2Szk3cFA4L0I1?=
 =?utf-8?B?U1hRM2FsZ09USmFIaGxpeHlUakRUUnhEZU1IYllJNWZ4ZkMyMGVQTzZUdCtH?=
 =?utf-8?B?dytrcjZyb243Tm9DUHdmUWlrUVVHazByd0k0S3gwRDVsMUF4Q2NrQ3hsdktU?=
 =?utf-8?B?cEd2V096TkV5MGhEaVRadUNlbnVZbGdtWldEOEJFNDBJbzRyUnd3TjVIZ3Y2?=
 =?utf-8?B?S0lsczJBM2IybjkvdnVLL0JrVlEvQnJrdmJpci95S3lLS2lsNS9GdXg4NHUv?=
 =?utf-8?B?L1JqZWMzVXFNNG5ET01qRFZYVVYwZytDalRTa1BOenozTE5LOWVIajFGNVAv?=
 =?utf-8?B?aWNneTRjcG5RRjE5VDR2OGJzUXdpdkFxL01FTFcxWXArKzNIdkJKVjBMeDB4?=
 =?utf-8?B?SE5KclgwSG9pUDN0bkxJYWZQeHhDZlAxQ0lZT00wRytydDNQVFhhMUZjdmRO?=
 =?utf-8?B?RVpLZHVQRmdaRHJkb2drMmZJQzZURzhyTU1jazM1cDlBZHdtdHk4S21OT3Jq?=
 =?utf-8?B?NEFTWWhVVTdURS9qcVBNcW42ZFgwY1k4QnV5VFFpY2NGcWxsMndUWnJyL3E1?=
 =?utf-8?B?bzlrS1p4d25qdHd1OXk4d2pXOU9qTXZnMmtxTVlrTmUzN2pPOVdLTEN5S0Q5?=
 =?utf-8?B?QmJJc2xLaCtzQVIzMTZmd2hlNXNxK2FDYjlMaXN2ZzFWUlYxRTVZQjN2c2ZC?=
 =?utf-8?B?YnJrSXFoMHl0U1Fkc2twLzdGeVE3RG9xTzRFalQwTHJibmJveUxUakFEdUp1?=
 =?utf-8?B?L3B0d1FsSHBJWUxDelpXbU0rdGQxUlBmdlZnQk5PVlNwTUl5TldjM3NlWU9T?=
 =?utf-8?B?VXlnT051ZUhiMjg3OFo0TVhpb1o1cGsvQUxpejdENk1NeTE3OHd1UGl0b0Zm?=
 =?utf-8?B?UVY4OHEvTHVYTDlaV2R3RHJ5eEhSOVVwYmlFSUVpVTltd2ZFNWlHdllObnhK?=
 =?utf-8?B?d3B6cHFCNE9jR291V2kvTkV3dXMrbmk3R2p6YkpEd2g3dnlkSldtYm9WQUVN?=
 =?utf-8?B?dVlxSkZYL3Y4OFhmejNjK25hNnlETHRsVWdlZVRXRzcxdm9jeHo2K0hYc2dz?=
 =?utf-8?Q?yNAowZTZZL3BR5l2Hxm+7smn4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <612D6C8F94B0E3499B2C16101AC8CF7E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f57d5d-5f7b-4398-ae67-08db35ba50bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:44:13.7226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nOxRHuxFkkjJM3TveWKHduAySwr0OexqyBSdgFBh2a70u3bxGhCVbHwIqzQDLgELgRtiy8zISwkzaeOdBdzu2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5650
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

T24gVHVlLCAyMDIzLTA0LTA0IGF0IDE3OjU5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAqKiogV0FSTklORyAqKiogQUJJIGJyZWFrYWdlLg0KPiANCj4gU3RvcCBhZGp1c3Rp
bmcgdGhlIGd1ZXN0J3MgQ1BVSUQgaW5mbyBmb3IgdGhlIGFsbG93ZWQgWEZSTSAoYS5rLmEuIFhD
UjApDQo+IGZvciBTR1ggZW5jbGF2ZXMuICBQYXN0IG1lIGRpZG4ndCB1bmRlcnN0YW5kIHRoZSBy
b2xlcyBhbmQgcmVzcG9uc2liaWxpdGllcw0KPiBiZXR3ZWVuIHVzZXJzcGFjZSBhbmQgS1ZNIHdp
dGggcmVzcGVjdCB0byBDUFVJRCBsZWFmcywgaS5lLiBJIHRob3VnaHQgSSB3YXMNCj4gYmVpbmcg
aGVscGZ1bCBieSBoYXZpbmcgS1ZNIGFkanVzdCB0aGUgZW50cmllcy4NCg0KQWN0dWFsbHkgSSBh
bSBub3QgY2xlYXIgYWJvdXQgdGhpcyB0b3BpYy4NCg0KU28gdGhlIHJ1bGUgaXMgS1ZNIHNob3Vs
ZCBuZXZlciBhZGp1c3QgQ1BVSUQgZW50cmllcyBwYXNzZWQgZnJvbSB1c2Vyc3BhY2U/DQoNCldo
YXQgaWYgdGhlIHVzZXJzcGFjZSBwYXNzZWQgdGhlIGluY29ycmVjdCBDUFVJRCBlbnRyaWVzPyAg
U2hvdWxkIEtWTSBzYW5pdGl6ZQ0KdGhvc2UgQ1BVSUQgZW50cmllcyB0byBlbnN1cmUgdGhlcmUn
cyBubyBpbnNhbmUgY29uZmlndXJhdGlvbj8gIE15IGNvbmNlcm4gaXMgaWYNCndlIGFsbG93IGd1
ZXN0IHRvIGJlIGNyZWF0ZWQgd2l0aCBpbnNhbmUgQ1BVSUQgY29uZmlndXJhdGlvbnMsIHRoZSBn
dWVzdCBjYW4gYmUNCmNvbmZ1c2VkIGFuZCBiZWhhdmlvdXIgdW5leHBlY3RlZGx5Lg0KDQo+IA0K
PiBUaGlzIGlzIGNsZWFybHkgYW4gQUJJIGJyZWFrYWdlLCBidXQgUUVNVSAodHJpZXMgdG8pIGRv
IHRoZSByaWdodCB0aGluZywNCj4gYW5kIEFGQUlLIG5vIG90aGVyIFZNTXMgc3VwcG9ydCBTR1gg
KHlldCksIHNvIEknbSBob3Bpbmcgd2UgY2FuIGV4Y2lzZSB0aGUNCj4gdWdseSBiZWZvcmUgdXNl
cnNwYWNlIHN0YXJ0cyBkZXBlbmRpbmcgb24gdGhlIGJhZCBiZWhhdmlvci4NCg0KSSB3b3VsZG4n
dCB3b3JyeSBhYm91dCB1c2Vyc3BhY2UgYmVpbmcgYnJva2VuLCBiZWNhdXNlLCBJSVVDLCBzdWNo
IGJyb2tlbiBjYW4NCm9ubHkgaGFwcGVuIHdoZW4gdXNlcnNwYWNlIGRvZXNuJ3QgZG8gdGhlIHJp
Z2h0IHRoaW5nIChpLmUuIGl0IHNldHMgU0dYIENQVUlEDQoweDEyLDB4MSB0byBoYXZlIG1vcmUg
Yml0cyB0aGFuIHRoZSBYQ1IwKS4NCg0KPiANCj4gQ29tcGlsZSB0ZXN0ZWQgb25seSAoZG9uJ3Qg
aGF2ZSBhbiBTR1ggc3lzdGVtIHRoZXNlIGRheXMpLg0KPiANCj4gTm90ZSwgUUVNVSBjb21taXQg
MzAxZTkwNjc1YyAoInRhcmdldC9pMzg2OiBFbmFibGUgc3VwcG9ydCBmb3IgWFNBVkVTDQo+IGJh
c2VkIGZlYXR1cmVzIikgY29tcGxldGVseSBicm9rZSBTR1ggYnkgdXNpbmcgYWxsb3dlZCBYU1Mg
aW5zdGVhZCBvZg0KPiBYQ1IwLCBhbmQgbm8gb25lIGhhcyBjb21wbGFpbmVkLiAgVGhhdCBnaXZl
cyBtZSBob3BlIHRoYXQgdGhpcyBvbmUgd2lsbA0KPiBnbyB0aHJvdWdoIGFzIHdlbGwuDQo+IA0K
PiBJIGJlbGl2ZSB0aGUgUUVNVSBmaXggaXMgYmVsb3cuICBJJ2xsIHBvc3QgYSBwYXRjaCBhdCBz
b21lIHBvaW50IHVubGVzcw0KPiBzb21lb25lIHdhbnRzIHRvIGRvIHRoZSBkaXJ0eSB3b3JrIGFu
ZCBjbGFpbSB0aGUgcGF0Y2ggYXMgdGhlaXIgb3duLg0KPiANCj4gZGlmZiAtLWdpdCBhL3Rhcmdl
dC9pMzg2L2NwdS5jIGIvdGFyZ2V0L2kzODYvY3B1LmMNCj4gaW5kZXggNjU3NjI4N2U1Yi4uZjA4
M2ZmNDMzNSAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2kzODYvY3B1LmMNCj4gKysrIGIvdGFyZ2V0
L2kzODYvY3B1LmMNCj4gQEAgLTU3MTgsOCArNTcxOCw4IEBAIHZvaWQgY3B1X3g4Nl9jcHVpZChD
UFVYODZTdGF0ZSAqZW52LCB1aW50MzJfdCBpbmRleCwgdWludDMyX3QgY291bnQsDQo+ICAgICAg
ICAgIH0gZWxzZSB7DQo+ICAgICAgICAgICAgICAqZWF4ICY9IGVudi0+ZmVhdHVyZXNbRkVBVF9T
R1hfMTJfMV9FQVhdOw0KPiAgICAgICAgICAgICAgKmVieCAmPSAwOyAvKiBlYnggcmVzZXJ2ZSAq
Lw0KPiAtICAgICAgICAgICAgKmVjeCAmPSBlbnYtPmZlYXR1cmVzW0ZFQVRfWFNBVkVfWFNTX0xP
XTsNCj4gLSAgICAgICAgICAgICplZHggJj0gZW52LT5mZWF0dXJlc1tGRUFUX1hTQVZFX1hTU19I
SV07DQo+ICsgICAgICAgICAgICAqZWN4ICY9IGVudi0+ZmVhdHVyZXNbRkVBVF9YU0FWRV9YQ1Iw
X0xPXTsNCj4gKyAgICAgICAgICAgICplZHggJj0gZW52LT5mZWF0dXJlc1tGRUFUX1hTQVZFX1hD
UjBfSEldOw0KPiAgDQo+ICAgICAgICAgICAgICAvKiBGUCBhbmQgU1NFIGFyZSBhbHdheXMgYWxs
b3dlZCByZWdhcmRsZXNzIG9mIFhTQVZFL1hDUjAuICovDQo+ICAgICAgICAgICAgICAqZWN4IHw9
IFhTVEFURV9GUF9NQVNLIHwgWFNUQVRFX1NTRV9NQVNLOw0KPiANCj4gU2VhbiBDaHJpc3RvcGhl
cnNvbiAoMyk6DQo+ICAgS1ZNOiBWTVg6IERvbid0IHJlbHkgX29ubHlfIG9uIENQVUlEIHRvIGVu
Zm9yY2UgWENSMCByZXN0cmljdGlvbnMgZm9yDQo+ICAgICBFQ1JFQVRFDQo+ICAgS1ZNOiB4ODY6
IERvbid0IGFkanVzdCBndWVzdCdzIENQVUlELjB4MTIuMSAoYWxsb3dlZCBTR1ggZW5jbGF2ZSBY
RlJNKQ0KPiAgIEtWTTogeDg2OiBPcGVuIGNvZGUgc3VwcG9ydGVkIFhDUjAgY2FsY3VsYXRpb24g
aW4NCj4gICAgIGt2bV92Y3B1X2FmdGVyX3NldF9jcHVpZCgpDQo+IA0KPiAgYXJjaC94ODYva3Zt
L2NwdWlkLmMgICB8IDQzICsrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQ0KPiAgYXJjaC94ODYva3ZtL3ZteC9zZ3guYyB8ICAzICsrLQ0KPiAgMiBmaWxlcyBjaGFuZ2Vk
LCAxMiBpbnNlcnRpb25zKCspLCAzNCBkZWxldGlvbnMoLSkNCj4gDQo+IA0KPiBiYXNlLWNvbW1p
dDogMjdkNjg0NWQyNThiNjdmNGViM2RlYmUwNjJiN2RhY2M2N2UwYzM5Mw0KPiAtLSANCj4gMi40
MC4wLjM0OC5nZjkzOGIwOTM2Ni1nb29nDQo+IA0KDQo=
