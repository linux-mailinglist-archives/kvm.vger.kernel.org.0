Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9433E1B90
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 20:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbhHESny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 14:43:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:16626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhHESny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 14:43:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="214255313"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="214255313"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 11:43:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="501742971"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 05 Aug 2021 11:43:37 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 11:43:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 5 Aug 2021 11:43:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 5 Aug 2021 11:43:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXa1fHXaALM0ES6IBAfioTIq5URvU2f2wekA1sgt6d7qhaI9hxP7pqlybTtEhoBxPmciVPiDs10m/jjwY8wef15VOcyItwEjnhJtwzC5jSJNbw+BqzH/0KUaief9MEX6dtYvFlL0JAUExBRy0EgfmPVItJK4qu35cUC3Rw79OWaiBO/CjxDC6ppc4OvqfZbpL3t68nHwhcx5vNvOF5QCufR5jUVC6AL9WrN8nYzM6lZxHLbnLyULg5/9SXewwrTFZN6F2Cqi0yScfSgEYhPxhr+6CbMz+zkMCnaKMl0vpY6wVnrv8HrCNVsDT/BXHArtHO2Jh8Jva0Y45/c8wTh47g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRjTcizaN1EfS3l3PfRb3Ik75rXysjp79xmbDebJVb8=;
 b=KY+AHVI7J7SHq60YtsS/tXDCSkx/rIFzm5vmSD/0tfKQwcpMO4Qm3JEDVwQhaOtUXs4GWaXA9rmHdZjhEnyZrf9Pt7tIdKCsbl8HyVGHie8qyJtJbUD4DyvefkbBZ3Vp9HNRN8Ix9OrK2Jnl9b256A86nrTVG3LD22hh9avaLUe6gVf2cuwma5sKqfob74/fR95Ka8KHnpcVMVn8j3PsGrrX9tvEsXD6c3bxE6RuRkgDVEWEFWUWc+SWE5uNp+YfoHnMTg3CgY1Itt8HkVYx7LxJAE8bJCTMW9nVrAZNiknOOzNS+Jo8gx6QFFluMKQVuTUHsTBOyjupmBVbH/nO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRjTcizaN1EfS3l3PfRb3Ik75rXysjp79xmbDebJVb8=;
 b=Cb/HJZJ0XvTcLctXRleN4wjcWuKHtOOtg1My1OrHfyO5/UuLNaUh1vKrkMxfMe+y6h9CzHz8kd2glxqhjYTz0pb1V6w/THubZ7pAhKmh+GW40DrKPiRIHQriq7LHUZOWdcl0/3k4TxoVFMtNt0scIGonjcZTj76Aec1M5DLe06s=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA2PR11MB5196.namprd11.prod.outlook.com (2603:10b6:806:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 18:43:35 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 18:43:35 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "erdemaktas@google.com" <erdemaktas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ckuehl@redhat.com" <ckuehl@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Thread-Topic: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Thread-Index: AQHXb45iOjTe58868U2SNstYrdIG9qtk/1wAgABJSICAABDngIAACO4AgAASAAA=
Date:   Thu, 5 Aug 2021 18:43:35 +0000
Message-ID: <7231028edae70dfaeab304d6206d4426b9233f41.camel@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
         <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
         <20210805234424.d14386b79413845b990a18ac@intel.com>
         <YQwMkbBFUuNGnGFw@google.com>
         <78b802bbcf72a087bcf118340eae89f97024d09c.camel@intel.com>
         <YQwiPNRYHtnMA5AL@google.com>
In-Reply-To: <YQwiPNRYHtnMA5AL@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7878a76b-50a9-4577-aa49-08d95840ee9d
x-ms-traffictypediagnostic: SA2PR11MB5196:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5196AD2BA441392A17357CD6C9F29@SA2PR11MB5196.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JWC+wKEku5QJKiIG0zEvORxAjEl5lzzVCFxYEY8Hvbba4ZEGziGtLWgnN8jBR7mhNKTdf2H+V3ihfw+6AYQc24CFbdn+s7KYU2nJEfZt9Wg/POpvQiwjkvPMyVC22AEYfq10epXyMNtMYS3xaQC8uXn1winoVy+1RPfYGsEuG1rUvHFeHYH0vP+F7+f4z+koitGSPBLAs6iDGwJJdTFMhRGrohl9Vz2+HPjU2xd1tXliU0zb7Io1292Pzi41h1sFNXky73s55I0fcV7z03iyhpbj67PUI4Ps59a75fmP8eiPyCBkLh+tOWFzrrIT8xsn2qw8DSKG3sAlh7aWnk1LFbS0FZiOva76Bo65gH8aAhOjSRgJJCAsCSjdtrno5URAu40+VCYbOZrl8sLGP6Rb72mEAN1sJR+vZLLGERN0dTZUSi73ispUdcsGAXYDOfxEf3Eh73HwF2UYk9gvnWiWAMbgT1gtRQ5CkcxhP+0Vum1BSG8IS2rspd61daqxnx07lFiNBAdmB/SIIr6/uLOd7xhvNoYASZ/gxELcP5BkJ/T1cVdSUKtcOm0vqoDOFROBBnmkrwTB/Aa1nXQVMhbtu52B75BcVe8EJCNz6FmI7ewqTVjETo+fH3xAMl8CkARmPzQT0qeXy7f4FsR5CVgt6vmwIT5OjgmHgW89+xz8ZGFbxDAs1bAO1fDsw+ljnnOorOxXYkrcW1FCmQwOjMlSx4dvV+dkg8o2e1eEHZBpbtg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(508600001)(36756003)(316002)(38100700002)(122000001)(38070700005)(66446008)(8936002)(66476007)(76116006)(66946007)(64756008)(26005)(91956017)(4326008)(66556008)(6512007)(6506007)(83380400001)(5660300002)(186003)(6916009)(7416002)(2906002)(2616005)(8676002)(71200400001)(86362001)(6486002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MCs2WUpHUkR2c050SnV6YThVOVRncUFzcjYxNWU1SEZUVmx2a0tGczBnb3Ft?=
 =?utf-8?B?RHVMKzNmeXptZnFYcUpXeWVIM1NnQTUzZGE0SnYyYkFqYmM5eCs3OU5rOGNu?=
 =?utf-8?B?cnEwcXNOQUlKUEpybW93YndBMFkvK2NTR3hGTzkxY3N4Nm1ROG5PYkNXamcx?=
 =?utf-8?B?eTFTQmZYdFpCbUhBazdGeVdmRVFoMkxnZ01CMEVLWG92QWc2R3FqWHVsRmFv?=
 =?utf-8?B?dlE0blhRcS9GeGxodDlLaG16NGpXa1Q5cVpXV2g4L1REMnNXdUpKeE4xUkpM?=
 =?utf-8?B?RDBIWVU3R09sUityMFYrY3oreTVUaEdhd2tpNi9kbUpiN3o5MlZZSHc3aXVj?=
 =?utf-8?B?TDFtMFUwZGc4WXhlQVVaSGdRbjEyejl4WFJCV1dMc2JCaDIyU2FiU25peHlJ?=
 =?utf-8?B?Rnh6aWtIWmdFMVBjeUVJL0lHOEVPZ2lZSnNJL1hOK3IvV2NNeFdjTWx1eW1E?=
 =?utf-8?B?RnIvbE51N0RFV1VkTEYzV1hUdzdBSUNvejNTNmhaOU1PZTI1QkJ0dlJObkJ2?=
 =?utf-8?B?ZlFGdGJYakthNXUxeWY4dGtvbWRjNVhrWVFLL0cxTnYreUUwNk1LekR1YmNE?=
 =?utf-8?B?eDRNNlJmb2tVUVMveFZHeHc0UmMycHJoUjFwOHVMMkgyNDZtSmN2akFFZFF4?=
 =?utf-8?B?RWYxUmFlazVWdU81Q016dkdEL3JCUjdzdWNPMUNxVGxsT3BCU0lsWTYzQW9u?=
 =?utf-8?B?dTQ1ejVSbTFwMThkMHd3U2N6aFo1VnU5QWZQYm1kWVhqRkZXOEtXR1Q1cG1D?=
 =?utf-8?B?L2JVaU9tV0lnbjVoQ3I1OFlNZU9scU9FNGVkM2ZnMXQrTzRFaklNVG9YZ3ds?=
 =?utf-8?B?RzMxZkRRaFFJOHFKd2c2WnlOQTQzcndzMTJSSUUxanlsRzdQZ2RxbmZKQW1r?=
 =?utf-8?B?OHFvekJyN3QwY3ozYTlTc2JwZGVHZXZ0UFBheDQyQ09rempJSzN6b1dreW93?=
 =?utf-8?B?aUczWVVxcExDeVk2VmdjNmhIU3NSclQ3YVRsYjlxWnlWaU9COElLMzJZRm9o?=
 =?utf-8?B?Rll4V05tWDVhY1Z4V0xDM3BnMTBJRDRmYUozT2F5dG16OE8zMXA4eWJLdE5r?=
 =?utf-8?B?SG5VS0czNzFIVTl3dGZoUXcvZFJQaU1FMjdlcFlDT28yYjJOSEhhQnhRTTJk?=
 =?utf-8?B?RmIrQjI3RmNteEU1VmJkb0xFTUsvMEh2eUlNN1JPSSthS0QxRmpZbkxmNHlR?=
 =?utf-8?B?MUhaSWx4dEliQncxS2hSVlU0SkZZbGZFK0oxSTRhTTRhbWlGQkV5SXkzTWNp?=
 =?utf-8?B?V2lXSndhUmVaM0tqSW1hWkpBS2ZXZGJXQUJvSjNSRGVjOU41YkhYUW9wNkxG?=
 =?utf-8?B?RldVUElId3NYWTZidkJNU2Z4RHFIZ2lCWEVobnBlQnJBeE54ekpmcnRGWXR0?=
 =?utf-8?B?cGlud0Rvblh2bTZyRHYzN0R6K2d1S1VlY2NhWjBlRzM4Z0lkTWlZUmZsd2Nh?=
 =?utf-8?B?TGJpeHFuVmpjRVk5MVBuOHFWOW1sakUwZ1ZRSTA4MDl1Q041VHBWV1orbTlI?=
 =?utf-8?B?VkpibldSWW41aE92SlNjbUtDdGcwdGsvTTRlOXpPRTVWdGxrdDRHSXNPNk9W?=
 =?utf-8?B?cTNyTEhWUEpvdTN4WUhpc2FzcmlHUW4zVXVsTWFCTlFhMTNkckZja0VKajRu?=
 =?utf-8?B?TTh2dVhPN0U5YUJ3c3JETExOMlN2N3ZqQXIrQ0RmOG5JMCs3ZG55UmFWM3c2?=
 =?utf-8?B?SmhMRE1MV1p1TTlTSTBhYnZSdktZSzJoWjZBM0w2NFVwYUJ6VXRPWW0rSGVw?=
 =?utf-8?B?YXJMZlNReVg5L2NlOHJzOXBjaEVjcXlNc1BNQjhDdGZPWmVPUXFqeksyWUlq?=
 =?utf-8?B?b0pCM3FNZ2lMQjloeFdHUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40FD1938E39A224EB8566840D08473ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7878a76b-50a9-4577-aa49-08d95840ee9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 18:43:35.2458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbB4uq7/jXhCfgoyBr5RcFZR6JdDiFIsnbur9HvtLMQPb+wvUOtDzesVjo7f6rI9dViK5HixvTAArW0j2vU/rnm/y80VbRQrBS/dviKphok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTA4LTA1IGF0IDE3OjM5ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAwNSwgMjAyMSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+
ID4gT24gVGh1LCAyMDIxLTA4LTA1IGF0IDE2OjA2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiA+ID4gT24gVGh1LCBBdWcgMDUsIDIwMjEsIEthaSBIdWFuZyB3cm90ZToNCj4g
PiA+ID4gQW5kIHJlbW92aW5nICdnZm5fc3RvbGVuX2JpdHMnIGluICdzdHJ1Y3Qga3ZtX21tdV9w
YWdlJyBjb3VsZA0KPiA+ID4gPiBhbHNvIHNhdmUNCj4gPiA+ID4gc29tZSBtZW1vcnkuDQo+ID4g
PiANCj4gPiA+IEJ1dCBJIGRvIGxpa2Ugc2F2aW5nIG1lbW9yeS4uLiAgT25lIHBvdGVudGlhbGx5
IGJhZCBpZGVhIHdvdWxkIGJlDQo+ID4gPiB0bw0KPiA+ID4gdW5pb25pemUgZ2ZuIGFuZCBzdG9s
ZW4gYml0cyBieSBzaGlmdGluZyB0aGUgc3RvbGVuIGJpdHMgYWZ0ZXINCj4gPiA+IHRoZXkncmUN
Cj4gPiA+IGV4dHJhY3RlZCBmcm9tIHRoZSBncGEsIGUuZy4NCj4gPiA+IA0KPiA+ID4gCXVuaW9u
IHsNCj4gPiA+IAkJZ2ZuX3QgZ2ZuX2FuZF9zdG9sZW47DQo+ID4gPiAJCXN0cnVjdCB7DQo+ID4g
PiAJCQlnZm5fdCBnZm46NTI7DQo+ID4gPiAJCQlnZm5fdCBzdG9sZW46MTI7DQo+ID4gPiAJCX0N
Cj4gPiA+IAl9Ow0KPiA+ID4gDQo+ID4gPiB0aGUgZG93bnNpZGVzIGJlaW5nIHRoYXQgYWNjZXNz
aW5nIGp1c3QgdGhlIGdmbiB3b3VsZCByZXF1aXJlIGFuDQo+ID4gPiBhZGRpdGlvbmFsDQo+ID4g
PiBtYXNraW5nIG9wZXJhdGlvbiwgYW5kIHRoZSBzdG9sZW4gYml0cyB3b3VsZG4ndCBhbGlnbiB3
aXRoDQo+ID4gPiByZWFsaXR5Lg0KPiA+IA0KPiA+IEl0IGRlZmluaXRlbHkgc2VlbXMgbGlrZSB0
aGUgc3AgY291bGQgYmUgcGFja2VkIG1vcmUgZWZmaWNpZW50bHkuDQo+IA0KPiBZZWFoLCBpbiBn
ZW5lcmFsIGl0IGNvdWxkIGJlIG9wdGltaXplZC4gIEJ1dCBmb3IgVERQL2RpcmVjdCBNTVVzLCB3
ZQ0KPiBkb24ndCBjYXJlDQo+IHRoYWFhdCBtdWNoIGJlY2F1c2UgdGhlcmUgYXJlIHJlbGF0aXZl
bHkgZmV3IHNoYWRvdyBwYWdlcywgdmVyc3VzDQo+IGluZGlyZWN0IE1NVXMNCj4gd2l0aCB0aG91
c2FuZHMgb3IgdGVucyBvZiB0aG91c2FuZHMgb2Ygc2hhZG93IHBhZ2VzLiAgT2YgY291cnNlLA0K
PiBpbmRpcmVjdCBNTVVzDQo+IGFyZSBhbHNvIHRoZSBtb3N0IGdsdXR0b25vdXMgZHVlIHRvIHRo
ZSB1bnN5bmNfY2hpbGRfYml0bWFwLCBnZm5zLA0KPiB3cml0ZSBmbG9vZGluZw0KPiBjb3VudCwg
ZXRjLi4uDQo+IA0KPiBJZiB3ZSByZWFsbHkgd2FudCB0byByZWR1Y2UgdGhlIG1lbW9yeSBmb290
cHJpbnQgZm9yIHRoZSBjb21tb24gY2FzZQ0KPiAoVERQIE1NVSksDQo+IHRoZSBjcnVkIHRoYXQn
cyB1c2VkIG9ubHkgYnkgaW5kaXJlY3Qgc2hhZG93IHBhZ2VzIGNvdWxkIGJlIHNob3ZlZA0KPiBp
bnRvIGENCj4gZGlmZmVyZW50IHN0cnVjdCBieSBhYnVzaW5nIHRoZSBzdHJ1Y3QgbGF5b3V0IGFu
ZCBhbmQgd3JhcHBpbmcNCj4gYWNjZXNzZXMgdG8gdGhlDQo+IGluZGlyZWN0LW9ubHkgZmllbGRz
IHdpdGggY2FzdHMvY29udGFpbmVyX29mIGFuZCBoZWxwZXJzLCBlLmcuDQo+IA0KV293LCBkaWRu
J3QgcmVhbGl6ZSBjbGFzc2ljIE1NVSB3YXMgdGhhdCByZWxlZ2F0ZWQgYWxyZWFkeS4gTW9zdGx5
IGFuDQpvbmxvb2tlciBoZXJlLCBidXQgZG9lcyBURFggYWN0dWFsbHkgbmVlZCBjbGFzc2ljIE1N
VSBzdXBwb3J0PyBOaWNlIHRvDQpoYXZlPw0KDQo+IHN0cnVjdCBrdm1fbW11X2luZGlyZWN0X3Bh
Z2Ugew0KPiAJc3RydWN0IGt2bV9tbXVfcGFnZSB0aGlzOw0KPiANCj4gCWdmbl90ICpnZm5zOw0K
PiAJdW5zaWduZWQgaW50IHVuc3luY19jaGlsZHJlbjsNCj4gCURFQ0xBUkVfQklUTUFQKHVuc3lu
Y19jaGlsZF9iaXRtYXAsIDUxMik7DQo+IA0KPiAjaWZkZWYgQ09ORklHX1g4Nl8zMg0KPiAJLyoN
Cj4gCSAqIFVzZWQgb3V0IG9mIHRoZSBtbXUtbG9jayB0byBhdm9pZCByZWFkaW5nIHNwdGUgdmFs
dWVzIHdoaWxlDQo+IGFuDQo+IAkgKiB1cGRhdGUgaXMgaW4gcHJvZ3Jlc3M7IHNlZSB0aGUgY29t
bWVudHMgaW4NCj4gX19nZXRfc3B0ZV9sb2NrbGVzcygpLg0KPiAJICovDQo+IAlpbnQgY2xlYXJf
c3B0ZV9jb3VudDsNCj4gI2VuZGlmDQo+IA0KPiAJLyogTnVtYmVyIG9mIHdyaXRlcyBzaW5jZSB0
aGUgbGFzdCB0aW1lIHRyYXZlcnNhbCB2aXNpdGVkIHRoaXMNCj4gcGFnZS4gICovDQo+IAlhdG9t
aWNfdCB3cml0ZV9mbG9vZGluZ19jb3VudDsNCj4gfQ0KPiANCj4gDQo+ID4gT25lIG90aGVyIGlk
ZWEgaXMgdGhlIHN0b2xlbiBiaXRzIGNvdWxkIGp1c3QgYmUgcmVjb3ZlcmVkIGZyb20gdGhlDQo+
ID4gcm9sZQ0KPiA+IGJpdHMgd2l0aCBhIGhlbHBlciwgbGlrZSBob3cgdGhlIHBhZ2UgZmF1bHQg
ZXJyb3IgY29kZSBzdG9sZW4gYml0cw0KPiA+IGVuY29kaW5nIHZlcnNpb24gb2YgdGhpcyB3b3Jr
cy4NCj4gDQo+IEFzIGluLCBhIGdlbmVyaWMgInN0b2xlbl9nZm5fYml0cyIgaW4gdGhlIHJvbGUg
aW5zdGVhZCBvZiBhIHBlci0NCj4gZmVhdHVyZSByb2xlIGJpdD8NCj4gVGhhdCB3b3VsZCBhdm9p
ZCB0aGUgcHJvYmxlbSBvZiBwZXItZmVhdHVyZSByb2xlIGJpdHMgbGVhZGluZyB0byBhDQo+IHBp
bGUgb2YNCj4gbWFyc2hhbGxpbmcgY29kZSwgYW5kIHdvdWxkbid0IHN1ZmZlciB0aGUgbWFza2lu
ZyBjb3N0IHdoZW4gYWNjZXNzaW5nDQo+IC0+Z2ZuLA0KPiB0aG91Z2ggSSdtIG5vdCBzdXJlIHRo
YXQgbWF0dGVycyBtdWNoLg0KV2VsbCBJIHdhcyB0aGlua2luZyBtdWx0aXBsZSB0eXBlcyBvZiBh
bGlhc2VzLCBsaWtlIHRoZSBwZiBlcnIgY29kZQ0Kc3R1ZmYgd29ya3MsIGxpa2UgdGhpczoNCg0K
Z2ZuX3Qgc3RvbGVuX2JpdHMoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpz
cCkNCnsNCglnZm5fdCBzdG9sZW4gPSAwOw0KDQoJaWYgKHNwLT5yb2xlLnNoYXJlZCkNCgkJc3Rv
bGVuIHw9IGt2bS0+YXJjaC5nZm5fc2hhcmVkX21hc2s7DQoJaWYgKHNwLT5yb2xlLm90aGVyX2Fs
aWFzKQ0KCQlzdG9sZW4gfD0ga3ZtLT5hcmNoLmdmbl9vdGhlcl9tYXNrOw0KDQoJcmV0dXJuIHN0
b2xlbjsNCn0NCg0KQnV0IHllYSwgdGhlcmUgcmVhbGx5IG9ubHkgbmVlZHMgdG8gYmUgb25lLiBT
dGlsbCBiaXQgc2hpZnRpbmcgc2VlbXMNCmJldHRlci4NCg0KPiANCj4gPiBJZiB0aGUgc3RvbGVu
IGJpdHMgYXJlIG5vdCBmZWQgaW50byB0aGUgaGFzaCBjYWxjdWxhdGlvbiB0aG91Z2ggaXQNCj4g
PiB3b3VsZCBjaGFuZ2UgdGhlIGJlaGF2aW9yIGEgYml0LiBOb3Qgc3VyZSBpZiBmb3IgYmV0dGVy
IG9yIHdvcnNlLg0KPiA+IEFsc28NCj4gPiB0aGUgY2FsY3VsYXRpb24gb2YgaGFzaCBjb2xsaXNp
b25zIHdvdWxkIG5lZWQgdG8gYmUgYXdhcmUuDQo+IA0KPiBUaGUgcm9sZSBpcyBhbHJlYWR5IGZh
Y3RvcmVkIGludG8gdGhlIGNvbGxpc2lvbiBsb2dpYy4NCkkgbWVhbiBob3cgYWxpYXNlcyBvZiB0
aGUgc2FtZSBnZm4gZG9uJ3QgbmVjZXNzYXJpbHkgY29sbGlkZSBhbmQgdGhlDQpjb2xsaXNpb25z
IGNvdW50ZXIgaXMgb25seSBpbmNyZW1lbnRlZCBpZiB0aGUgZ2ZuL3N0b2xlbiBtYXRjaGVzLCBi
dXQNCm5vdCBpZiB0aGUgcm9sZSBpcyBkaWZmZXJlbnQuDQoNCj4gDQo+ID4gRldJVywgSSBraW5k
IG9mIGxpa2Ugc29tZXRoaW5nIGxpa2UgU2VhbidzIHByb3Bvc2FsLiBJdCdzIGEgYml0DQo+ID4g
Y29udm9sdXRlZCwgYnV0IHRoZXJlIGFyZSBtb3JlIHVudXNlZCBiaXRzIGluIHRoZSBnZm4gdGhh
biB0aGUNCj4gPiByb2xlLg0KPiANCj4gQW5kIHRpZ2h0bHkgYm91bmQsIGkuZS4gdGhlcmUgY2Fu
J3QgYmUgbW9yZSB0aGFuIGdmbl90IGdmbitnZm5fc3RvbGVuDQo+IGJpdHMuDQo+IA0KPiA+IEFs
c28gdGhleSBhcmUgYSBsaXR0bGUgbW9yZSByZWxhdGVkLg0KPiANCj4gDQo=
