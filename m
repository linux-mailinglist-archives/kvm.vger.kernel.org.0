Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841CB5F16E4
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiI3X7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiI3X7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:59:13 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712D318C007
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664582350; x=1696118350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G5p9qNRooUAHIkEZ0xPt+e4ymF6sE22zkkzG8HHL4Gw=;
  b=ZnmOApM2gKY/Aenh/YHQEGXkQ9o77k2bUfIkKvA1fvGs03ORwZX8yf1z
   SRgNdaXx7hwT/dBcew0C0pweScooNynPwoO1L196kzND26D8Amq7tPIQ3
   CIu4t3csnNkikBwlIh774/s4pcPvKP34xqZPOnvZRsVHF40X1YdzV3xSk
   rQ3xKEqNYq5XvPS8qQXNjY8FDqaWYZnAZJ4aCzBlckpjkzU16Sl72I4By
   8WEIVa9U+rMRUtntyCVoHQCF8i5zeFE7Y1T1/vyxUtdoUrMu1WQyrh99l
   3Ksnp8jiYSZ2LwGzBY1V8Kvo1DKK/4Ao6AvH/wT79f66KDqfFPesKrkoQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289474094"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="289474094"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 16:59:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="656126029"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="656126029"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 30 Sep 2022 16:59:09 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 16:59:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 16:59:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 16:59:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 16:59:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjffMI5vnTFF7DBTn2auKdlq4jqwGcru6VijHK9/Ir+ZKkzJmkmVCysSwpHBGBzC4HeZZj1XB9vL9ta2VEFZDYXa0XTiMUQnqZIAXHO6h8NZsR1dWpYK8U77sdGrK7tvhDKBC2tpOIzXc15wSzqrc8LNx3Q+pQ70I/9qcFLxSQmOoS69AV/HrwSaYs4jWZwo+UZ9qARcxOrRVAzt7bWz+G8oQ4bkxyy6o1PK50d6mpCkmz7+HRDyDBojMkQTFAN6/W6EDt4WLzspQCr9XWxgIgeh0rPySTS1LdD6WXaxrGsDIoj/szS+9MqPjAaxGZZvzCcZvKh2TQMP6PniRXmS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5p9qNRooUAHIkEZ0xPt+e4ymF6sE22zkkzG8HHL4Gw=;
 b=aA8kDMrq9u3sCzvEDu0FBRFAWNamqszGQzr2WOoHtRpBAovUl9R8ls3uqhuSodlt39NWPy67RTipVPY2iUWMfw9kloAm9FHVzGZtGR8WarOK/hAQ6oOMpz9k/gWWFfQ1+fnGokQXUZKvhB+DzDWog6sfn+PsjyWtomcerHyOpZWXKcBYiCMWbqzB92m7rEf3+X2OBNhozw+CZ/ltu6RVWk80FBd2Xf/1vxGWSfLOadpyDT1EtOBSWlQ1+aDTgfNDIbWQ3EjqlKeIl8tKmWE2Aw8GSsBYl4noy9IxxoBfVSpLtXMO3AG48h+e4dmD+EvlsyfjUOkFOJg2nj1+uNM3xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by PH8PR11MB7048.namprd11.prod.outlook.com (2603:10b6:510:214::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Fri, 30 Sep
 2022 23:59:05 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5%3]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 23:59:05 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Topic: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Index: AQHY1FYuEs8BAKsu5UCBOzB/nmNIY634etfwgAAg0oCAAAmBoA==
Date:   Fri, 30 Sep 2022 23:59:05 +0000
Message-ID: <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
In-Reply-To: <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|PH8PR11MB7048:EE_
x-ms-office365-filtering-correlation-id: 380fd16f-23a6-4ef1-4a35-08daa33fc18f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7+Dvt3x4ynDJ52vRp+socaOinDEwtPYbZKQ3soa1nDqBNBEj5CiTYT/lVh7q09m2UuY0DneD3ZUdodGHMwR+lp/yic4Jxg65tZpMjDcuUtoF8FTMwWo+JZ535lDp7pKpHSFHA55CxQlfK4+oBbsgHxxMNiz0Jsefd0CQ9Dedz5GroS3RcmIwWLsEsydjEk6q069oHKwWZHXbv8ZI1cDkqfbkYLGBATqK/NlYdUUu/FQv7Tq6R17D1AAjLwH5JxlbJuJy+9Amnm5184HMBUJsp9N1QjQe3J+SPuM6ijFc+Hv++mHobfiUzxjW55AKMGiT3ktkbB+skVXiJ5vj1f7YWjNkwLELtfG2TqeerR1jr+amgivfAy/MnKtfwK7cUSSBRFkeYHs+RfYpyt+NgQIUBt1iK4Kce/ESQHL457as7LX6nD/uzXk9SMm+caoaPY6Rh7HfPwxgIzZJnjMahNH9Gp5kq+j3x+2c86c1xeGVcbHVTAlUDkcqoqzbtWWO1ZSzbkBfIrQql5VRkMwMrLt/27WemlMKA99f/7DezYaERGxwheDR1JTrG0ERimNwduu1Oac/mGXgC4wNrlVKAnzuzjlG9KZEbCJBGzA6zIvlE8J49XRChsMMRMfAwyzOBu7c9WYRrdAYLaWLqIznMjIM3Qkeec3HT8PeSwXpPbg7FZbd6/NU3iB9xOtvq5FgrxZCHDmdQiODuBdGhp8wQfV1bMg3OX0WTMyZGTO3fhveGITGE/tzThbU+PUHFRUrDC6I2guYNa/HrhhbcrCljg2/pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(8936002)(33656002)(52536014)(2906002)(41300700001)(8676002)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(6916009)(316002)(55016003)(38070700005)(86362001)(38100700002)(9686003)(122000001)(186003)(82960400001)(5660300002)(54906003)(4326008)(6506007)(7696005)(26005)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajBCOThHc05FY0NhS3ZYSHhwSFFqdUZUK2hRMVdFdk1rNkJUTzMrRkNoUXBo?=
 =?utf-8?B?MGRXd1cwN2s5bk9RL2gyenpVbjE3MnVWeFFyZ0ZsYWo2VlduczR4czR5S0wv?=
 =?utf-8?B?YVJ3SVgydDBzOXBPWHZrakFlY01LQVZjVGRmcjRQQXlvdkVPZVFBRDVtYlBQ?=
 =?utf-8?B?cGE4Tnk0eTFTbDc2bENjWjd6TzBITW5wWHdLLzJjQWVtNWxpRVZOaVVSZlN2?=
 =?utf-8?B?M2JwSjFFN2g2QjFRdUlMK0NsNFloTGZHMmN3MlhjZkxXWjBJK0FTM2IveWk2?=
 =?utf-8?B?Y3JQT2JxRUpwbW5yUXVGcDhqYXV0RmpQN3ZJYk9COTBYU1lyN1UrZ0p3VExP?=
 =?utf-8?B?L0tjNDVCa1lucDduSmMveUprUkVoZHJ1UTJqQ250S1crczEzYWFrdERrS20x?=
 =?utf-8?B?bEdhN0ZmYWtKbVpVWm0wb1J3c1VGdEpHV256a1dMR05MUW1EZGIwMmtES2FM?=
 =?utf-8?B?b053aU0xbkQwbDFiNXZQeGZoa2V3QlVlaXBpeXlEWkhiVXlTcXUxNkFyS0dE?=
 =?utf-8?B?UWFCUzB5enk3MFl6WVZ1bUFZUHNVSW9ETmhNNGlJZ2NJU2V5eHdEdUdkYkQ1?=
 =?utf-8?B?R1czV1VaMjFoRVdENjE2TkFzTEJnRmhZODlDTDMrYzllekVZZXBsdTZhU1pk?=
 =?utf-8?B?RXJJUnBOM2cya1FWRmNLaS82WWJqUXNwa3pOT3JHdXJqNG5pbU1OYnBZUGJr?=
 =?utf-8?B?eWVDVVhoZWY4VExUb0dLMFpLY2pPL2t6YStyRHdhT3RRMm9Tbm5kdUgxcGtJ?=
 =?utf-8?B?aXppQ2t2MEdldmtRTFIwb3hZWHhGSUs1MVhpNytIQXJhNGpXcnZ1S1VzdTds?=
 =?utf-8?B?SzJaMGJFQjVKU3ZWYm5RVzdoQStESXNiWElpWXhsWnRWMGtLUXE1cys0Qk1T?=
 =?utf-8?B?b3FiUU5SOTRGMldTUFJycTRYTUlaTDNndTQrQWlGVmVLS3JSRG5ESHh2NHl4?=
 =?utf-8?B?RDF5N2J2V1lKOUZmT2l1ZTNaelpPVkhkbDVTYXJud2ZpUmlUSFM2cUVDcnhR?=
 =?utf-8?B?ZzJwN0c1RFlSL3FidldVZGNkKy9jdDBSMEIxRWZtWC9DL0RxakNxOWFJbzE5?=
 =?utf-8?B?VnJubVBmaVYwTDdIWDFJWjNERVJqSVBqMkc5bFduZlk1U3pqWlpLSUZtaGdl?=
 =?utf-8?B?bkVRZm9kUG9mOE9tUnpZZHBqT1NWeHB5RXpUd3pNWDRqcVdCekdmcDJvTmpk?=
 =?utf-8?B?bStXTkFrbEpTSnJYNFJZOWRiK2ErM2NRSFE0S0dKbXRFWkkwV1NrQ3hCYk1D?=
 =?utf-8?B?TkNqQmRpbGNHOWdOUlFDN0JpWjJad012SWVMbjcycVlhMXc2bVJEdFJHUE50?=
 =?utf-8?B?bmZPY1JVYWxzN09IbkxYQWdnaFkyRjE0M2l4Kys4ZWcxWlNUNFZiOGtJY2Zm?=
 =?utf-8?B?M3JQWGgyamNNQU9rUFRRdkIwSkNZcVlqUWdHaGJQb05odGZMYXQyNk1GR2Ew?=
 =?utf-8?B?TEdxTHBJTE1vT05VQ2lzem00QWprRC82NmpKQ2NOaWFuZDNmc2JIN0ZkTDFF?=
 =?utf-8?B?OEYzcGFpWXcxQk16UUpEeFZUYXV2R1Fla3daKzRxck5xOVlub2VFL1R5eUpi?=
 =?utf-8?B?Nll1NGFJWUtXS1plSWtSTFlxbUsxNTJIWFlleW9Nc3lqQ0UzTWNzdmFFVGFB?=
 =?utf-8?B?dERBL0s2UTZ6NVArOE8yTmZEOXNneW0yTHVlV3JHSTNXWkd3QTlxV0E0d3lw?=
 =?utf-8?B?V3RrMjhPZkl1Ynk2ZEtyY0ZVSy9NWUJpV1kwWXh4amZ0SFUrZ0NiWEhQZGRO?=
 =?utf-8?B?My94L2taVyt4bjhObGRQOGdDTk0zb2JSNXNydzFKRmpSMGM5VVEyT0ppbDF3?=
 =?utf-8?B?NllFSnhXYW5uWitjSEhKWXB0VnBQVFE1eUpJcHJhMGR0cXhUU29iTWN5TVpl?=
 =?utf-8?B?ZWx6Y0dZSkNpWnpRdXZ4WFhNK0ZFMjVGZG5OWU9zL0NKTEJJeVJ3amc4YnY0?=
 =?utf-8?B?bHNZZDVETlU2TlJIMjJRK2VReVFZVVRFaGJabGkrZ21nNXVocU1zdUlJbzRL?=
 =?utf-8?B?alljaTBGYW1RMlhIMWRjdVZwaU1qNldsdlFoZGpiZWFtSStzSDFpeXdxTC9E?=
 =?utf-8?B?U0xkZVgxdFlabXg4UkZVMFdZQW5CVjJhNElUbEJTcjRkTXVTV3NJUjZjaHly?=
 =?utf-8?Q?40IOhJl497SsAcz1t1Ab9wBUb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 380fd16f-23a6-4ef1-4a35-08daa33fc18f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 23:59:05.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+eCPehPS2ZvsdZpMpcbH49j9F5aYr4ETPzNHM50PYeGwrMbKWjVL+5JiQURVYDHvf7kOgsvh2ZXAERS03Y0dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7048
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSmltOg0KDQo+ID4gPiBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRCBzaG91bGQgb25seSBlbnVt
ZXJhdGUgZmVhdHVyZXMgdGhhdCBLVk0NCj4gPiA+IGFjdHVhbGx5IHN1cHBvcnRzLiBDUFVJRC44
MDAwMDAwNkg6RURYWzE3OjE2XSBhcmUgcmVzZXJ2ZWQgYml0cyBhbmQNCj4gPiA+IHNob3VsZCBi
ZSBtYXNrZWQgb2ZmLg0KPiA+ID4NCj4gPiA+IEZpeGVzOiA0M2QwNWRlMmJlZTcgKCJLVk06IHBh
c3MgdGhyb3VnaCBDUFVJRCgweDgwMDAwMDA2KSIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBKaW0g
TWF0dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gveDg2
L2t2bS9jcHVpZC5jIHwgMSArDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
DQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9jcHVpZC5jIGIvYXJjaC94
ODYva3ZtL2NwdWlkLmMgaW5kZXgNCj4gPiA+IGVhNGUyMTNiY2JmYi4uOTBmOWMyOTU4MjVkIDEw
MDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gPiA+ICsrKyBiL2FyY2gv
eDg2L2t2bS9jcHVpZC5jDQo+ID4gPiBAQCAtMTEyNSw2ICsxMTI1LDcgQEAgc3RhdGljIGlubGlu
ZSBpbnQgX19kb19jcHVpZF9mdW5jKHN0cnVjdA0KPiA+ID4ga3ZtX2NwdWlkX2FycmF5ICphcnJh
eSwgdTMyIGZ1bmN0aW9uKQ0KPiA+ID4gICAgICAgICAgICAgICBicmVhazsNCj4gPiA+ICAgICAg
IGNhc2UgMHg4MDAwMDAwNjoNCj4gPiA+ICAgICAgICAgICAgICAgLyogTDIgY2FjaGUgYW5kIFRM
QjogcGFzcyB0aHJvdWdoIGhvc3QgaW5mby4gKi8NCj4gPiA+ICsgICAgICAgICAgICAgZW50cnkt
PmVkeCAmPSB+R0VOTUFTSygxNywgMTYpOw0KPiA+DQo+ID4gU0RNIG9mIEludGVsIENQVSBzYXlz
IHRoZSBlZHggaXMgcmVzZXJ2ZWQ9MC4gIEkgbXVzdCBtaXNzIHNvbWV0aGluZy4NCj4gDQo+IFRo
aXMgaXMgYW4gQU1EIGRlZmluZWQgbGVhZi4gVGhlcmVmb3JlLCB0aGUgQVBNIGlzIGF1dGhvcml0
YXRpdmUuDQoNCkluIHRoaXMgY2FzZSwgZ2l2ZW4gdGhpcyBpcyB0aGUgY29tbW9uIHBsYWNlLCAg
aWYgd2UgZG9uJ3Qgd2FudCB0byBkbyBjb25kaXRpb25hbGx5IGZvciBkaWZmZXJlbnQgWDg2IGFy
Y2hpdGVjdHVyZSAobWF5IGJlIG5vdCBuZWNlc3NhcnkpLCBjYW4geW91IHB1dCBjb21tZW50cyB0
byBjbGFyaWZ5Pw0KVGhpcyB3YXksIHJlYWRlcnMgd29uJ3QgYmUgY29uZnVzZWQuDQoNCg0KPiAN
Cj4gPiBCVFcsIGZvciB0aG9zZSByZXNlcnZlZCBiaXRzLCB0aGVpciBtZWFuaW5nIGlzIG5vdCBk
ZWZpbmVkLCBhbmQgdGhlIFZNTQ0KPiBzaG91bGQgbm90IGRlcGVuZCBvbiB0aGVtIElNTy4NCj4g
PiBXaGF0IGlzIHRoZSBwcm9ibGVtIGlmIGh5cGVydmlzb3IgcmV0dXJucyBub25lLXplcm8gdmFs
dWU/DQo+IA0KPiBUaGUgcHJvYmxlbSBhcmlzZXMgaWYvd2hlbiB0aGUgYml0cyBiZWNvbWUgZGVm
aW5lZCBpbiB0aGUgZnV0dXJlLCBhbmQgdGhlDQo+IGZ1bmN0aW9uYWxpdHkgaXMgbm90IHRyaXZp
YWxseSB2aXJ0dWFsaXplZC4NCg0KQXNzdW1lIHRoZSBoYXJkd2FyZSBkZWZpbmVzIHRoZSBiaXQg
b25lIGRheSBpbiBmdXR1cmUsIGlmIHdlIGFyZSB1c2luZyBvbGQgVk1NLCB0aGUgVk1NIHdpbGwg
dmlldyB0aGUgaGFyZHdhcmUgYXMgaWYgdGhlIGZlYXR1cmUgZG9lc24ndCBleGlzdCwgc2luY2Ug
Vk1NIGRvZXMgbm90IGtub3cgdGhlIGZlYXR1cmUgYW5kIHZpZXcgdGhlIGJpdCBhcyByZXNlcnZl
ZC4gVGhpcyBjYXNlIHNob3VsZCB3b3JrLg0KDQpJZiB3ZSBydW4gd2l0aCB0aGUgZnV0dXJlIFZN
TSwgd2hpY2ggcmVjb2duaXplcyBhbmQgaGFuZGxlcyB0aGUgYml0L2ZlYXR1cmUuIFRoZSBWTU0g
Y291bGQgdmlldyB0aGUgaGFyZHdhcmUgZmVhdHVyZSB0byBiZSBkaXNhYmxlZCAvIG5vdCBleGlz
dGVkIChpZiAiMSIgaXMgdXNlZCB0byBlbmFibGUgb3Igc3RhbmQgZm9yICJoYXZpbmcgdGhlIGNh
cGFiaWxpdHkiKSwgb3IgdmlldyB0aGUgaGFyZHdhcmUgZmVhdHVyZSBhcyBlbmFibGVkLyBleGlz
dGVkIChpZiAiMCIgaXMgdXNlZCB0byBlbmFibGUgb3Igc3RhbmQgZm9yICJoYXZpbmcgdGhlIGNh
cGFiaWxpdHkiKS4gIA0KDQpJbiB0aGlzIGNhc2UsIHdoZXRoZXIgd2UgaGF2ZSB0aGlzIHBhdGNo
IGRvZXNu4oCZdCBnaXZlIHVzIGRlZmluaXRlIGFuc3dlci4gQW0gSSByaWdodD8NCg0KDQpUaGFu
a3MsIEVkZGllDQoNCg==
