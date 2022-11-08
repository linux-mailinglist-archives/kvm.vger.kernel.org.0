Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A7620619
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 02:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiKHBdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 20:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiKHBcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 20:32:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3212EF1D;
        Mon,  7 Nov 2022 17:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667871046; x=1699407046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V3LFr5Pqoefb0O18Yo+JyZGkG6IK2rP5fQibMKQafhI=;
  b=n5SAApUmFCtqZ60Nsg/ArREBu1WpZCOCtQqQdfIrTmpI3sT7u1TYnTlk
   AmlAzFjzXBlf88ge5wbBzBy7wLhmK69V1BkgwDHX4kmxH8qRK+w1TkZOA
   Fbq4fINz2Ka8vQsWAv4iOuvyzUa8G1clf6b+hlFFV7X8xwjDkrroJsSwG
   IbOAZ5sr4Ho+ik1jujOG1w8S6O+0e3xjtBEN7VSozOIfGMqBNgLI/Uzht
   pdXHSEi/ICek3SRo5QSGIdGe09fOlUKmI1vj/ujYCcRnmazgDzJomS0l8
   7CjyMzSBXlUhKaPXh0SHeIqtO5q8ijzuMz++timdieqncSQzSr00mHA4h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311724366"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311724366"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 17:29:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="778721727"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="778721727"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 07 Nov 2022 17:29:53 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:29:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 17:29:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 17:29:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgXco+Df45IXqwhUWgPxq/BT74nZdLg6iIb5+qmT5ict59D7ZzXsA+Cuh3BUIRzfOO7Ru7QovA0r2syatAPTNJBTh3zJV39/UKJJ8HN+Se4Pw1kNdchndGHWX1lH50I2nCJWzEgz/z7lcRm2A9u2q5x65Q72B8kafsdPBzVSq1Av350mWIezYzm5RrG4kmcyOmW4FOTn3f6y/d8WXcYqaV4tS/oV9nNk8G3bH32ae0BVLB0mUSbih09laJ+hZrlf652GqILpiiZJVLkDnJL7huXxHINkIpHvU6FBG4w0uHCxuKPtLGymMxS4QmraXLBnUlTyeJL1oga7uhN1MDh76w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3LFr5Pqoefb0O18Yo+JyZGkG6IK2rP5fQibMKQafhI=;
 b=IPfB2NLNuqbFP6bdVdPEF/isfyF42fv8Jhip/Omd2Ix5nwU3FY78Aztv1IZCTzrTRmj+Q0jwg6I+g1BnqeXzLcpyDgd5JS4uqC7iyycWUnA49Np/MBazKbli/nwS/cwp2QJMFbjMsdm0KhN4An8hEyab+VRQI33e+O0zDtVT004quX94Xp4KMxkG/Lwb8/Ye+fJUs3j9J066rwvAdlIZlAqFi0oO3RrDX1R4C9CUYfbCw0ogfTVVgk4qhcSf2HFyXykp6qZ0ghZmJkPyYVWtkzvsGPOeDiBC4uxUx11Twt6alRbbD/5bxU6v8SqolwSCRpzVUR8KqiKLlWUEky/kdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5245.namprd11.prod.outlook.com (2603:10b6:5:388::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 01:29:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 01:29:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHY7ChDw1zmpi/iYkCerKDnhZwIwK40StmA
Date:   Tue, 8 Nov 2022 01:29:46 +0000
Message-ID: <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5245:EE_
x-ms-office365-filtering-correlation-id: bd04344b-61db-425b-3d19-08dac128b8bf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I5A2Qt2lcx6tK5MH1XHgKUowMjPE5z5oWF46x9Qs3htXzNY7bdD36gF7effX/vs/WJQDBfdoDSN9J/NVQx8tiJagVcVxMPYvTqiwTiWaC3n3ecPtIcbbOYapmqkR/t5qtn/g6HPvLQrRIGt1obXHym/Okyk6KXfLynFNtsij0duF8dsPndslMZjqBzYOuCwFcLNAwZU4zSAkTuDtJS94Yvizra8d+Sld0Wzr7LarC2zTvJi+/2eG27+DbYmzhWXkJyVfjYq/DnuQMdyskovqoyz8yX46gUM5warCi/G35y9ZFVD7HUFOcVp2PL1HiibVlopGzL3+Ilz+4aNY4MKCQW2nUV1iEyu1lJzzFzEk2SKjNAUB1qD5D8+Wc2W3IacUj+kS2QsIjJqDAlPXZVdLKmqn7fJ84InE5b1nVBqw0tKsnlmvbYgH4XZPQue9j1nB7T4VrQB0lN1AwkO9XLhEKQh5dsraNIh7GEjGlSlrke/dkZFBEcR1/jYH4YTgHtjrnrsx7qAYhPqUal3xdvtPA6/z3HgePQfeDZWSDwgcTZ2M/HfQRAN0BRBMTWs5wS9LPs82n8NEN1N3WiMUSVWj7NXTtOuMAKIdtjGXCzAeORLUH+ke/qvojvtZe3pfXUfeJWBnfdghm7Jv9T1PVYFsvJXOF8iwljV7mHlM6r6kmJifBx6yzv5uWGH9vA030Z4DMM+oGXYlQRf+aBshkyOaoCRgG6hxcyMcuACp8ejqjeOm+rZN3NaDmO57WgVh57H2Ls8AuYA9WWEab+VW9EEp0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199015)(6486002)(71200400001)(478600001)(76116006)(91956017)(6636002)(54906003)(110136005)(6506007)(316002)(26005)(66946007)(8676002)(4326008)(66556008)(66446008)(86362001)(64756008)(66476007)(38100700002)(122000001)(83380400001)(6512007)(41300700001)(38070700005)(2906002)(82960400001)(36756003)(2616005)(5660300002)(8936002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0lLc05vNFVpbjRqb2JwU25leCtkTkN4UzhVZVUweGI4YzhpTnJCaWRkb3ZG?=
 =?utf-8?B?aGlsdlNCOTBqWXFCTnpYU0w4YTFScmlSZjJ3N1Z4a0grTXA1WExRTU04ZjNO?=
 =?utf-8?B?MGxPWGc4VFFNM2lZVEJ6QVFXSjMyc2EzMGFzVHVHaGhmWG5mUUUrcGVUclZy?=
 =?utf-8?B?UTBpZnFoaDd6RVB3YmQ5WmhuZjZUaWFhWHpmWFNMU0k3dzg3Rk10eVl2V0dS?=
 =?utf-8?B?aXY3U0JLbjB3SVcyTE1KeWFSSzhJM2NVZE8xeWpocWNwVWhRTWdlelFCcjJK?=
 =?utf-8?B?NEJ1SWNseXlUdWVtVGU1amo4MG5pVGFUNnQvMHZhcWo4NGp0SGM3dXJtS3kv?=
 =?utf-8?B?QUFRN0xzb0dxWm94eE45NUZBeFQxQ01FcjU4NDN6a28zR0hFbzNZMWxScHdS?=
 =?utf-8?B?ZmtQRjhJNHprdnBRRjB4MVhGUWNHUk9YclYzeXdHNnhmVGdSeS9vWUFOTkdJ?=
 =?utf-8?B?NGI3Q1FZQVFTS3B0V0JKU012dkpiUUxMd1UrNDZqbWxHdGdTSkY5ZEtwSXVk?=
 =?utf-8?B?UU9YRUtTYUE5OVBHNkh3VXRHS2lUSlRuaWRUS3JkdmZwRG9VUGdGNGlOVWZ0?=
 =?utf-8?B?T3Bhd2VQa2g4dkhady9ibUJLMThRTkY1UzIyeUUrUHZPYWJLakdEY2ROVEdN?=
 =?utf-8?B?Q3lMbm9xRVMrR2xlUE13dEkvU1VjenZqL0ZERmx5ZTZoR3ROTjQ1czJJTjl2?=
 =?utf-8?B?WW1IclVrK2tIdW82YmljcTY5L08zSWhGUjg2S3hkK1NKR0xUTjkzejZHOHBl?=
 =?utf-8?B?TEo4TW43VTlEdGRmdi9ZZ0VjQzlCY05tL0pLTklGcWc2YzcwZ3FuQkpZelpw?=
 =?utf-8?B?bGhvZ3R5SkJ4aXl0LzhxNHNvUzNaRXhHREJ5UzRFTFF2c0pEU1F6MEZDNGo5?=
 =?utf-8?B?MnRFTnY4bnlQRFFuTU1LcDhkOURodDlYTUJPVmlSYlNWVlN2WUZGcFZuUDhN?=
 =?utf-8?B?LzI5Zk16Yno4dFluWHVDMkZ0TFYwcXhVWkFPRU04RHlCYURNVmExejVyWW5p?=
 =?utf-8?B?dGJCL1JDU0sxRDYxc2ZLNCtVL294UDUvZ1ArUEhHZWJlK2JTb293VDhxdUNS?=
 =?utf-8?B?aU1kTUFuY3pYK3ZtejhsMkZnQVdUUnZ2V1I3UkRsSyt2Tm1nTEtZUldjZHV5?=
 =?utf-8?B?SkVPdGFySDhTWE9tQ2xWQ0NWZFByZldwRnNEM0tnQXI0NHREYVJQN2poWi83?=
 =?utf-8?B?NTZJczFNc0J4bjRsdm05ZnJxZzdzM0wrZnpQZE1qaFhnb0hLOWtxMkpyRVZj?=
 =?utf-8?B?SVcwZlgwUVY1ODloUnpOOGFLM0FHOVhYT05OcUVKNlhUNWk1czVUNm1GRU1I?=
 =?utf-8?B?d0g0eHRIRTN2bHdlOStxRGNzekllelVSbk8zaVZwQjV6OE9iakNQUk9kT0FP?=
 =?utf-8?B?R05QY2xDYkdiT1AwcjZLOW9YZHp5NXdtMGtKbmpVNUlrRUNwZk1NNXdlMlRZ?=
 =?utf-8?B?ejhiVDJZcTZRL0ZPM0FaeDJRWmgrdkswcUhWay8wRTNzVEVUWnRWUjdTdWpz?=
 =?utf-8?B?anNKM3R5VjhOUEp6K1BkQ0JPb0J3bmZ4allJK2RHL0J1TjBCWGFCd2RKeE0r?=
 =?utf-8?B?bkpRak9nNmI1VDBQUmVhbkdjdnVmL3VGbTI3NlB6cnhwaXpERnEvaStwQ2tl?=
 =?utf-8?B?dWxMMGNZa1ZjS0JTNDdQRjNiVlg5MGFTNTlQYUdIelhXcXhaN20rTURHaEhN?=
 =?utf-8?B?U1UyN2RPVHR4cVNJOFRpODh4cnFxWjBVS1o3QmQ5WW9BZ1haSjFTOUVvLzZa?=
 =?utf-8?B?NkNZc091YXRiVnpHMUFJSENka2Zyb2FNMGdpUmh5WTJWMzhkYms1SmlnUDY4?=
 =?utf-8?B?TEFWajRXcGI5d2FYOEloYzhIbG9kMWRBUGdPWHJEWnh1Tyt4c2RWTFdBT09N?=
 =?utf-8?B?MzFRYW5hc3hkaXRSK0djSkFRQlFLS2ZXbG1FbkswOVE1Qloxc1lra1A1ZEs4?=
 =?utf-8?B?dUxrUXJjRXVPZmZKcDJ1QVBTZ08ySG5YVDQwd3dLSlVjOWgxRENjZFlQUXUy?=
 =?utf-8?B?Sy8reHZUaVBOazl6ZHVsbkRuZjQ2SkhrQVlCR2QxcHdZdjB0UDN3cG85UlBs?=
 =?utf-8?B?d1d4eEh2azFIakxGYXJreUFEd3ZCVmRxbUJITitiV0h4V1R4Z3lCM05jWm1Z?=
 =?utf-8?B?TlNjZE0rVVhBc0ErSXpJVWY3b0xqOVJXRVkwQlBDRjl1WEx3SGtaTjdsbHRx?=
 =?utf-8?B?a2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <597712C04A8CDC4594C98C837E88A7C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd04344b-61db-425b-3d19-08dac128b8bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 01:29:46.8583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06M2O+URwGlDhHLtK7Kv5CYoGRdGJzoYceevjwfNoKZg0xvHiMR2wIFMD7j1bOPQl24sc4zaco7PvJGi2G6YFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5245
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

DQo+ICsNCj4gKyNkZWZpbmUgVERYX01BWF9OUl9DUFVJRF9DT05GSUdTCQkJCQlcDQo+ICsJKChz
aXplb2Yoc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QpIC0JCQkJXA0KPiArCQlvZmZzZXRvZihzdHJ1
Y3QgdGRzeXNpbmZvX3N0cnVjdCwgY3B1aWRfY29uZmlncykpCVwNCj4gKwkJLyBzaXplb2Yoc3Ry
dWN0IHRkeF9jcHVpZF9jb25maWcpKQ0KPiArDQo+ICtzdHJ1Y3QgdGR4X2NhcGFiaWxpdGllcyB7
DQo+ICsJdTggdGRjc19ucl9wYWdlczsNCj4gKwl1OCB0ZHZweF9ucl9wYWdlczsNCj4gKw0KPiAr
CXU2NCBhdHRyc19maXhlZDA7DQo+ICsJdTY0IGF0dHJzX2ZpeGVkMTsNCj4gKwl1NjQgeGZhbV9m
aXhlZDA7DQo+ICsJdTY0IHhmYW1fZml4ZWQxOw0KPiArDQo+ICsJdTMyIG5yX2NwdWlkX2NvbmZp
Z3M7DQo+ICsJc3RydWN0IHRkeF9jcHVpZF9jb25maWcgY3B1aWRfY29uZmlnc1tURFhfTUFYX05S
X0NQVUlEX0NPTkZJR1NdOw0KPiArfTsNCj4gKw0KPiArLyogQ2FwYWJpbGl0aWVzIG9mIEtWTSAr
IHRoZSBURFggbW9kdWxlLiAqLw0KPiArc3RhdGljIHN0cnVjdCB0ZHhfY2FwYWJpbGl0aWVzIHRk
eF9jYXBzOw0KDQpJIHRoaW5rIHlvdSBjYW4gaW50cm9kdWNlIHRoaXMgdGR4X2NhcGFiaWxpdGll
cyBpbiBhbm90aGVyIHBhdGNoLg0KDQpBcyBjbGFpbWVkIHRoaXMgcGF0Y2ggY2FuIGp1c3QgZm9j
dXMgb24gaW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxlLiAgV2hldGhlcg0KeW91IG5lZWQgdGhp
cyB0ZHhfY2FwYWJpbGl0aWVzIG9yIHRkeF9zeXNpbmZvIGlzIGVub3VnaCBjYW4gYmUgZG9uZSBp
biB0aGUgcGF0Y2gNCndoZW4gdGhleSBhcmUgcmVhbGx5IG5lZWRlZC4gIEl0IG1ha2VzIHJldmll
dyBlYXNpZXIgb3RoZXJ3aXNlIHBlb3BsZSB3b24ndCBiZQ0KYWJsZSB0byB0ZWxsIHdoeSB0ZHhf
Y2FwYWJpbGl0aWVzIGlzIG5lZWRlZCBoZXJlLg0KDQo+ICsNCj4gK3N0YXRpYyBpbnQgX19pbml0
IHRkeF9tb2R1bGVfc2V0dXAodm9pZCkNCj4gK3sNCj4gKwljb25zdCBzdHJ1Y3QgdGRzeXNpbmZv
X3N0cnVjdCAqdGRzeXNpbmZvOw0KPiArCWludCByZXQgPSAwOw0KPiArDQo+ICsJQlVJTERfQlVH
X09OKHNpemVvZigqdGRzeXNpbmZvKSAhPSAxMDI0KTsNCj4gKwlCVUlMRF9CVUdfT04oVERYX01B
WF9OUl9DUFVJRF9DT05GSUdTICE9IDM3KTsNCj4gKw0KPiArCXJldCA9IHRkeF9lbmFibGUoKTsN
Cj4gKwlpZiAocmV0KSB7DQo+ICsJCXByX2luZm8oIkZhaWxlZCB0byBpbml0aWFsaXplIFREWCBt
b2R1bGUuXG4iKTsNCj4gKwkJcmV0dXJuIHJldDsNCj4gKwl9DQo+ICsNCj4gKwl0ZHN5c2luZm8g
PSB0ZHhfZ2V0X3N5c2luZm8oKTsNCj4gKwlpZiAodGRzeXNpbmZvLT5udW1fY3B1aWRfY29uZmln
ID4gVERYX01BWF9OUl9DUFVJRF9DT05GSUdTKQ0KPiArCQlyZXR1cm4gLUVJTzsNCj4gKw0KPiAr
CXRkeF9jYXBzID0gKHN0cnVjdCB0ZHhfY2FwYWJpbGl0aWVzKSB7DQo+ICsJCS50ZGNzX25yX3Bh
Z2VzID0gdGRzeXNpbmZvLT50ZGNzX2Jhc2Vfc2l6ZSAvIFBBR0VfU0laRSwNCj4gKwkJLyoNCj4g
KwkJICogVERWUFMgPSBURFZQUig0SyBwYWdlKSArIFREVlBYKG11bHRpcGxlIDRLIHBhZ2VzKS4N
Cj4gKwkJICogLTEgZm9yIFREVlBSLg0KPiArCQkgKi8NCj4gKwkJLnRkdnB4X25yX3BhZ2VzID0g
dGRzeXNpbmZvLT50ZHZwc19iYXNlX3NpemUgLyBQQUdFX1NJWkUgLSAxLA0KPiArCQkuYXR0cnNf
Zml4ZWQwID0gdGRzeXNpbmZvLT5hdHRyaWJ1dGVzX2ZpeGVkMCwNCj4gKwkJLmF0dHJzX2ZpeGVk
MSA9IHRkc3lzaW5mby0+YXR0cmlidXRlc19maXhlZDEsDQo+ICsJCS54ZmFtX2ZpeGVkMCA9CXRk
c3lzaW5mby0+eGZhbV9maXhlZDAsDQo+ICsJCS54ZmFtX2ZpeGVkMSA9IHRkc3lzaW5mby0+eGZh
bV9maXhlZDEsDQo+ICsJCS5ucl9jcHVpZF9jb25maWdzID0gdGRzeXNpbmZvLT5udW1fY3B1aWRf
Y29uZmlnLA0KPiArCX07DQo+ICsJaWYgKCFtZW1jcHkodGR4X2NhcHMuY3B1aWRfY29uZmlncywg
dGRzeXNpbmZvLT5jcHVpZF9jb25maWdzLA0KPiArCQkJdGRzeXNpbmZvLT5udW1fY3B1aWRfY29u
ZmlnICoNCj4gKwkJCXNpemVvZihzdHJ1Y3QgdGR4X2NwdWlkX2NvbmZpZykpKQ0KPiArCQlyZXR1
cm4gLUVJTzsNCj4gKw0KPiArCXByX2luZm8oImt2bTogVERYIGlzIHN1cHBvcnRlZC4geDg2IHBo
eXMgYml0cyAlZFxuIiwNCj4gKwkJYm9vdF9jcHVfZGF0YS54ODZfcGh5c19iaXRzKTsNCg0KV2hh
dCcncyB0aGUgYmVuZWZpdCBvZiBwcmludCBvdXQgeDg2X3BoeXNfYml0cz8gIExvb2tzIGEgbGl0
dGxlIGJpdCB3ZWlyZCBoZXJlLg0KDQpURFggaG9zdCBjb2RlIHdpbGwgcHJpbnQgb3V0IFREWCBw
cml2YXRlIEtleUlEIHJhbmdlLiAgSSB0aGluayB0aGF0IGlzIHVzZWZ1bA0KZW5vdWdoPw0KDQo+
ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiAraW50IF9faW5pdCB0ZHhfaGFyZHdhcmVf
c2V0dXAoc3RydWN0IGt2bV94ODZfb3BzICp4ODZfb3BzKQ0KPiArew0KPiArCWludCByOw0KPiAr
DQo+ICsJaWYgKCFlbmFibGVfZXB0KSB7DQo+ICsJCXByX3dhcm4oIkNhbm5vdCBlbmFibGUgVERY
IHdpdGggRVBUIGRpc2FibGVkXG4iKTsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJfQ0KPiAr
DQo+ICsJLyogTU9WRElSNjRCIGluc3RydWN0aW9uIGlzIG5lZWRlZC4gKi8NCj4gKwlpZiAoIXN0
YXRpY19jcHVfaGFzKFg4Nl9GRUFUVVJFX01PVkRJUjY0QikpIHsNCj4gKwkJcHJfd2FybigiQ2Fu
bm90IGVuYWJsZSBURFggd2l0aCBNT1ZESVI2NEIgc3VwcG9ydGVkICIpOw0KCQkJCQkgICBeDQoJ
CQkJCSAgIHdpdGhvdXQNCj4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ICsJfQ0KDQpJIHRoaW5rIHlv
dSBzaG91bGQgZXhwbGFpbiB3aHkgTU9WRElSNjRCIGlzIHJlcXVpcmVkLCBvdGhlcndpc2UgdGhp
cyBqdXN0IGNvbWVzDQpvdXQgb2YgYmx1ZS4NCg0KQnR3LCBpcyB0aGlzIGFic29sdXRlbHkgcmVx
dWlyZWQ/ICBURFggYWxzbyBzdXBwb3J0cyBMaS1tb2RlLCB3aGljaCBkb2Vzbid0IGhhdmUNCmlu
dGVncml0eSBjaGVjay4gIFNvIHRoZW9yZXRpY2FsbHkgd2l0aCBMaS1tb2RlLCBub3JtYWwgemVy
b2luZyBpcyBhbHNvIE9LIGJ1dA0KZG9lc24ndCBuZWVkIHRvIHVzZSBNT1ZESVI2NEIuDQoNClRo
YXQgYmVpbmcgc2FpZCwgZG8gd2UgaGF2ZSBhIHdheSB0byB0ZWxsIHdoZXRoZXIgVERYIHdvcmtz
IGluIENpIG9yIExpIG1vZGU/DQoNCg0KDQo=
