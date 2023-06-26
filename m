Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045F273EEA1
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 00:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjFZWX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 18:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjFZWX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 18:23:27 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8D8D9;
        Mon, 26 Jun 2023 15:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687818206; x=1719354206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CERNFy4dQr4JkA+k+Fh2I1w9b4CPHtpVIcL3CfUgoTQ=;
  b=KOesv9200Z85gQ0PgDrzskjrR7jAL14U0Fpa7v9XC3y1BSKKjPTrsPsI
   lC1qUjYlxLGyODmLy0IIlNym4exMJOrKhkkidoZZHCr69PAIDquUHwZFE
   WFPYkeZegRVha9ZYZ5/PJC8T0PdWi1Q4Ws8Yqn68I8CD62a5EFnb5b2pT
   XPC6MnFnS5M26FJtD7KT/1p+XeEha6+zb6nC9QFclQvF1lRd+WiyhQeeQ
   X9VjrzKmt5jfg8wrBRY2drjbyd/+suRBbyk+ONyzY/7Rjw/+cceQbGpdh
   7xles0RBSWrnpHRQTZq50joyPUdScfaXXScnyUcyjiIJPoTB9lzNuXw6s
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="358905131"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="358905131"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 15:23:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="840449255"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="840449255"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 26 Jun 2023 15:23:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 15:23:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 15:23:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 15:23:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpGWUEuG04Ts4ysCRG9JmHqT3acdUzjW6RmjQHuQCqf/S/i3Y3m141j/xMx7+b+adYiNCziX9gEwaolifJJxc1rHPHHZESUmTqpkX7aZFZMESa/OYls7aN6/G05xNAYKTgdxVF/sQC4chEsNBnszlwCQPjbSIjk91pISSmKSouLuFm3RX8L16VTKV6RYtjMy7opTgp1tSEoPqVN0k+ppJetccRqyNEyQgsjDpfMbkUrkL6qt8sypYBJiIRQCKOCSs7QFikP3sryYHVw8SDQm9CoCOtwDDbfw0O4tT9JvDXcO4LRS6zSiqAJVF9begSXjK8DSTX9xQhaPbfuPtToVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CERNFy4dQr4JkA+k+Fh2I1w9b4CPHtpVIcL3CfUgoTQ=;
 b=KsQNQAlUNYfMB9dQZAzqiJ7ck0eBrTZuK58GzVtUiTnIk54NEe+bHNLdAReULcO/S3dnHVsWiAJfUiF2VzgedeW8T3EmNNrmJNBPWls6Cz8/N56iw9pzxzIFFPXfmPAkGuvb19lBLLxSEvY8m/3y8GI/IkTrDRLyg7sKWp5S/xP/KaZKxHMLrabmiqR5IvuxL1Zm2aan7R/sVCc3RmlEoP66e117QRN2blzT8An0ksk/G8hOBbFlWIyFOLTv5Zt9r5sicqlosMH/s2zqLnAXcO9ahCZ8wtonHDYpxWNh/ZMUGUhAeNuUa5OXOS+cK10ZogB4wXkm66+fzldcp2dvgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6832.namprd11.prod.outlook.com (2603:10b6:510:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Mon, 26 Jun
 2023 22:23:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Mon, 26 Jun 2023
 22:23:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mizhang@google.com" <mizhang@google.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Xu, Yilun" <yilun.xu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Re: [PATCH v2 6/6] KVM: Documentation: Add the missing description
 for tdp_mmu_page into kvm_mmu_page
Thread-Topic: [PATCH v2 6/6] KVM: Documentation: Add the missing description
 for tdp_mmu_page into kvm_mmu_page
Thread-Index: AQHZqFrsNyI5JQXIqk+aMHvCyZxDpq+dqNyA
Date:   Mon, 26 Jun 2023 22:23:11 +0000
Message-ID: <24537a93ed91e19c71d73b7f5df7b31851d9271f.camel@intel.com>
References: <20230626182016.4127366-1-mizhang@google.com>
         <20230626182016.4127366-7-mizhang@google.com>
In-Reply-To: <20230626182016.4127366-7-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6832:EE_
x-ms-office365-filtering-correlation-id: a84fd9e1-82bc-4199-67be-08db7693ed57
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j+s7WQAnCXxoZ92F9TYEJmQLrK1YTJptP7+hkEevQL4TgSQ7hG/38026FmWBtX4F7nyX7kxU8Jt6W7a2PrErk0x2ZrABypEhfMc1gfIxl6UBJQ5975p7KgYkyWd/abs705s7R/nMKKOezGbJbkXZWin5OMVv7GiFJMSDGod4PJ4uFzBz7FQlAyK5EqGRhduxGdkfuAN7TL7PEAH4JYOAkogCKSOhEszAG4R6B3ifrlSU/m3mNgT88Nfd0uwBDsveTpWP/HSoONOLsLQqL/VNa86vTprP0HJo7+WA3fUfoMYrj16qcFZJ3pQ8Qo5T6Fbu3kLwWfcsbUyE7l995WuqrCSGu9jrQSlk3u8bQiITp6bWPE86wRolweSPqBcIwnD9ArQEZoV4LgDxv9mF+me0a/nq1HooCIALef5T5Ok7FnB9H0Cngaxj7AgxO98WIaT2tthW+F6+zBAEkYQD6DscCA5B+60TBY01GCSsSQer/jtWNlprsHycSqqz5yor32n8dAdil5k0socmlEGy4ui1PneVh3GvErfZTpMXo5BTYZ9oBbHoEa9LnxFASHdHYy9cvOSjZJOBrGG7vGA2Kj4PI/53BrfWydBHFOcw/NqpDyMVC1rf0X5TjSlHi6l89iTw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(66556008)(36756003)(6506007)(6486002)(2616005)(54906003)(110136005)(478600001)(83380400001)(66446008)(26005)(186003)(71200400001)(2906002)(5660300002)(7416002)(122000001)(316002)(64756008)(82960400001)(66946007)(76116006)(91956017)(38100700002)(8936002)(8676002)(41300700001)(86362001)(4326008)(66476007)(38070700005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2hRcjZBWUpXTnBnK1BQYXdkamhCaFdQY05rMDZ3UERudWovZko4Qjg0bTJk?=
 =?utf-8?B?ZzJRQmVSdnozSlFxbFJ3R1VHcEVSSUYycmVvdXRZZzc1RHN1YldGQWZVMEF5?=
 =?utf-8?B?cDZmTVFRbGVVa1F1N2NBWno3dmxGS3AvTTFKT1JtK2pzdEo1VTVvYTlUNFhu?=
 =?utf-8?B?YU50bGR6MTFzS01vRWpzWE9PNDErVTJwUG91OVcyNkgyV1dmeUMwYzNGSzBY?=
 =?utf-8?B?VVJnQmw4Wm14TGV1cXhiYXZ3bGduWHhwNC91cWlncmRvRHB4WUdVaFBweW5t?=
 =?utf-8?B?SXlHMkh6SUhTZExuUnpFK1lSWFl0OHJ1aEVOc2VVUUdZajAvUE8xSmxINjBB?=
 =?utf-8?B?bHBQYWhNSi85ZElORHA3UTdOZC9EYmNCMzJPNjQ3TE1XT1k1dC9jVTc1Tnhk?=
 =?utf-8?B?ZEY1WC8vNSt4c1RadFAxbVVLdWk4cGdqc05TUXVXNWphcFJTQUd5a3dtVlAx?=
 =?utf-8?B?WWMwZkNjZTJFc2Z1bWxrRGZMODU0WllKN3ZncmlLcll1SUV5NDQzNmtqdVh3?=
 =?utf-8?B?SENwL3RYQklmenp6ck52U0xjVk84QXYwNXgvYzZSV3o5QzhGMVJQVTlEU3Bk?=
 =?utf-8?B?aGxTaTF4ejhXSSs3anNFY3ZhNGo1RTVqOENkMVkySXV1UkZlUHczVVUzcTZB?=
 =?utf-8?B?bE5VeEo3Wkk5dE01OFNaREZNSUg0elJETTdhMUh2dTBWYUptM2Z0M3MxSkdt?=
 =?utf-8?B?dUtDejdZaE9mL3Z6L1ljY2kvKzIxQlVRTHJQelRvRmJvOUlSVmg3eXlPdzgz?=
 =?utf-8?B?bEpPNFRudUpsN2lZMkVCRS9WQVhPWGV6UmJJdDdtTUczWUhJT3hNeDR6bjNK?=
 =?utf-8?B?VE5la2k3Z0thbDB2Rnh0UmxWTS9qTTdRbmszbWJtWVVPSWprK0xMQ2NBcDFQ?=
 =?utf-8?B?V2FLQ1VFUFp6Vnd0UVovNTc2RG05Ni81VVRncmc1SFNOQ2pkY2RMZFZNWnl0?=
 =?utf-8?B?UFRXZG9hblNaQWhUOFBxMWpkbSt4SHVqSEhZSzZkRHpqQWw5UkwxUURyOVor?=
 =?utf-8?B?QVozSmxHNTlGM1h6VHpDMUR6RElIWGl3cjVFRzFCMmhmeEdUWHBPTyt1Y3BK?=
 =?utf-8?B?b1cwMTcrQktobFNhYVF0OU90YmJXU3hrQnJiUmlMSld0d3hJdldlN3pDN0g5?=
 =?utf-8?B?WXc2NGF6cHRIZHIyVCtRbzE5TUdMMDB4YU1kR0wrR2V6YkpibTJnNUJrYmpT?=
 =?utf-8?B?eXROZy9ZZnd0R1RBQURsMDZ5RGJwNHdDaVlxTURXZGtkV1J0T3dnNHdqNGps?=
 =?utf-8?B?MnFvZkNXeWNmVVBDb0M0S21FdmtFZVdadmVOTHlIOTFIZzFVWHZoYlhvM1dE?=
 =?utf-8?B?Qld0OTVsRlMvNmN6TEs3N2JZU2RSa0FpOWZ2QUY0akJWbUNCTmNIdnhFNi9w?=
 =?utf-8?B?Nys3aDBicHpacHRDWUF5dWJjT2lqUmhLMC94K1JCWDhjcWJwdkpzTTNSQTl6?=
 =?utf-8?B?R3FwbXJEdkQ0UnNGSE5WcTVJM0xRdVNjb29MYUNQRm5KbHVCVVFwUjhTUGVr?=
 =?utf-8?B?dXhCS2UyNVZ3bzBrRjN5emlvZzZFUVNkNE9qY2l1dUg1NkgwSTUvcGdhT1lE?=
 =?utf-8?B?YXZDU1lNdFVPcnBXaFNTbVh1QmRKNHRDekFab1ViWmdEVGJCQlVVdmJxczBE?=
 =?utf-8?B?djlBRE1va2gzb09SMlduazZyOFlGa1ZzOWkrdGFWMVFaWS9iYVdwb0luODcw?=
 =?utf-8?B?ME54ZlVTZDh1bEVPWEU1MnJXendxWnZRc2xRV0hNKzQrL0xaY0lzbTcvc0d1?=
 =?utf-8?B?bzk0clV3d0pDbGJNbUE1STgwam1zMWdBdW5yb0lvdXR6bHRqQzZoQ2ZKbjUw?=
 =?utf-8?B?dmhyeHhPY29SampLbGhGOHdaRU9OMVcvUEdtSk0xbUpBZHJleFBROTJwdUdn?=
 =?utf-8?B?NmVZSUx5SFF4ajJvK3J1V0Z6clpDcW5MTDhybE8wckZpYVRtYjM0UGJVckxq?=
 =?utf-8?B?cTRaejMrY0JMNXBFU1MxVkJEeWMxbVNZOEt3NVVvcUhTWTBiNTVxdjNrbXJQ?=
 =?utf-8?B?OXpULzhaWVRmOE9VQkJuS00wLzZ5VFV4c1VnU2tGSVBLa1BFSVZQbisrNFBj?=
 =?utf-8?B?WTlFdDNoWWRla01IVHZVNlpSNGpTZklabkJpdDhlcDRNNDV4SEU2ZjdRUnFP?=
 =?utf-8?Q?KBBq7nQS3AU7KUgLJeSGU+laT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <584CDFB03F17AC41B1C64CD6693B0B11@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84fd9e1-82bc-4199-67be-08db7693ed57
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 22:23:11.6864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UQ7Op4QeYsY8bSA6FZ9s1jugjKXUnJCoIbedHkHk7aopbQi0MHiYHF5OwBQ4ZGs39ycpXO/aJpLxdWDeGv5FPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6832
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTI2IGF0IDE4OjIwICswMDAwLCBNaW5nd2VpIFpoYW5nIHdyb3RlOg0K
PiBBZGQgdGhlIGRlc2NyaXB0aW9uIGZvciB0ZHBfbW11X3BhZ2UgaW50byBrdm1fbW11X3BhZ2Ug
ZGVzY3JpcHRpb24uDQo+IHRkcF9tbXVfcGFnZSBpcyBhIGZpZWxkIHRvIGRpZmZlcmVudGlhdGUg
c2hhZG93IHBhZ2VzIGZyb20gVERQIE1NVSBhbmQNCj4gbm9uLVREUCBNTVUuIFdoZW4gVERQIE1N
VSBpcyBlbmFibGVkLCBzcC0+dGRwX21tdV9wYWdlPTEgaW5kaWNhdGVzIGEgc2hhZG93DQo+IHBh
Z2UgZm9yIEwxLCB3aGlsZSBzcC0+dGRwX21tdV9wYWdlPTAgaW5kaWNhdGVzIGEgc2hhZG93IHBh
Z2UgZm9yIGFuIEwyLg0KPiBXaGVuIFREUCBNTVUgaXMgZGlzYWJsZWQsIHNwLT50ZHBfbW11X3Bh
Z2UgaXMgYWx3YXlzIDAuIFNvIHVwZGF0ZSB0aGUgZG9jDQo+IHRvIHJlZmxlY3QgdGhlIGluZm9y
bWF0aW9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWluZ3dlaSBaaGFuZyA8bWl6aGFuZ0Bnb29n
bGUuY29tPg0KPiAtLS0NCj4gIERvY3VtZW50YXRpb24vdmlydC9rdm0veDg2L21tdS5yc3QgfCAy
ICsrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJzdCBiL0RvY3VtZW50YXRpb24vdmly
dC9rdm0veDg2L21tdS5yc3QNCj4gaW5kZXggY2M0YmQxOTBjOTNkLi42NzhkYzAyNjBhNTQgMTAw
NjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0veDg2L21tdS5yc3QNCj4gKysrIGIv
RG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJzdA0KPiBAQCAtMjc4LDYgKzI3OCw4IEBA
IFNoYWRvdyBwYWdlcyBjb250YWluIHRoZSBmb2xsb3dpbmcgaW5mb3JtYXRpb246DQo+ICAgICAg
c2luY2UgdGhlIGxhc3QgdGltZSB0aGUgcGFnZSB0YWJsZSB3YXMgYWN0dWFsbHkgdXNlZDsgaWYg
ZW11bGF0aW9uDQo+ICAgICAgaXMgdHJpZ2dlcmVkIHRvbyBmcmVxdWVudGx5IG9uIHRoaXMgcGFn
ZSwgS1ZNIHdpbGwgdW5tYXAgdGhlIHBhZ2UNCj4gICAgICB0byBhdm9pZCBlbXVsYXRpb24gaW4g
dGhlIGZ1dHVyZS4NCj4gKyAgdGRwX21tdV9wYWdlOg0KPiArICAgIElzIDEgaWYgdGhlIHNoYWRv
dyBwYWdlIGlzIGEgVERQIE1NVSBwYWdlLg0KPiAgDQo+ICBSZXZlcnNlIG1hcA0KPiAgPT09PT09
PT09PT0NCj4gLS0gDQo+IDIuNDEuMC4xNjIuZ2ZhZmRkYjBhZjktZ29vZw0KPiANCg0KUmV2aWV3
ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==
