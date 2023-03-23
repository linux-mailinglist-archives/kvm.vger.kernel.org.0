Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76336C73EE
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 00:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCWXQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 19:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCWXQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 19:16:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391E219101
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 16:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679613408; x=1711149408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4jVoZkhnI6K33gmN0nfZVjxY0pk6pQ91NOl+2klmv9k=;
  b=TEvTmPRGq/YgrmM0QCZo1hlPkRGvlD5xLnWt7W6n0DGuulIEu//5YxpH
   IwjewKKuAFjeHKaZV+Vk3nOz4Rb802I/oOTjXf7tMNtSvMQ2FGpfdtW6n
   Jr8ekveqIvFCoJ/id3IlgQUqyjvB6vwM7TsZsttdwvGtY54M55P3lrgDZ
   UXx7suWlWo324MT8Dt+yM9IIaZVlnRYsEfKnbrtPZBmeh6rTJ9OMPNGCJ
   qBj0H3kQOjfmLaGmbjqfQFTGm4fffgFOTp54eyxAltMfLwdkNa2E88HVB
   IYflqIOLK11HMxVuLv/IwnLXaXhoF52i4q7ec5NF1mkSJHVF3clwN3THB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="402231624"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="402231624"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 16:16:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="715010815"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="715010815"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 23 Mar 2023 16:16:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 16:16:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 16:16:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 16:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jf73tn97rQr/D/n2kQrJl+9pSvITKy08vTfRE+ZWgB35+oWKGX67wW8wZIp6pFIaKn0jU3W+hcw466D7czGFl7Ol6XGzddCyDAGetekBfECChVhvQDJY2p8zLg9cIl4nQUMfeCYsK46+/MUq6WIdGPPfrU8wj/2uOQ/V1dYW2rZtJIXZuJaHHdQKcoIE9ONgAtEo/A8ggxPtUx3gIF6cGY02G3IhVnQdmB3Mq5JDiqEuMDZ8hfUEuU7pycrHv/YFSjeQnPFEJ+Fn2njt6uRFSCF1mDTzm/OWq4SJmIsCi8d55m7gDr96r/7XQuG5/42e4GdWBBlJ6UKn/ABIzyHH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jVoZkhnI6K33gmN0nfZVjxY0pk6pQ91NOl+2klmv9k=;
 b=F9yvlJ1l1dHCH6hgtWkeFaiAesqW5ky737TKYeeUQHgSRQZ78cAmbbwO3WP1bNPpjWXmO4pTr4v4fnkWqCKlp7eB2kKDrakuTR85uPGgYQDkc5BcpOt1+Eua7diFxtu0HEfxNmlb4Pbe/5L/yfsoQE9fAsC/RmLxWEr1Ra8U8yUMO3nUEgz0U+qrii00V0oFh0e+qd5N1rTu5NUt3ze+prZXCbL0aZJKI+vNKkOe9m1nf3OYYNLMWmGT6J2iAU7qNApjmzk6jMO7icsw9ubVyM0d1X3dJsTTgBLzwEFZWjkMw2v7KNov1UYM1oFpkHfBFw+XsfkK1oiFwI2SkkA2lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4696.namprd11.prod.outlook.com (2603:10b6:208:26d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 23:16:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 23:16:43 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Li, Rongqing" <lirongqing@baidu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if
 not itlb_multihit
Thread-Index: AQHZXVe7DWMC2Kv4vESzd+zUkOLJcq8IaoSAgACJhgCAAAJHgIAACgsA
Date:   Thu, 23 Mar 2023 23:16:43 +0000
Message-ID: <80be4df29c758d22299a3548a758462a31f81164.camel@intel.com>
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
         <ZBxf+ewCimtHY2XO@google.com>
         <48616deee4861976f7960f60caf59cbe37a85f1e.camel@intel.com>
         <ZBzU6pa7eOgVf0Kf@google.com>
In-Reply-To: <ZBzU6pa7eOgVf0Kf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4696:EE_
x-ms-office365-filtering-correlation-id: 2a9ab896-a032-409e-1f03-08db2bf4aa3c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tGcO24xsqkbonxt6K9/+C2rKDTUpzvHsoqm+5EDS7fkNWqzp0M5XagqYmW61fBilu9DLoTSoYsiftekqbYUlZnaw2UuFUHsxv9SYp84/drGMpBkM3SL+pd5F+UDEo2XXtfPNrd4DprGhWNRlMQCldIRehwdOIZ1YvHVs6DAuCaHz2m/JiigJf5cLTYddtIu/PAGQy7D4VdS+Wm/m3vR9eQE2iZFErdp18nVuOtd62ueJr3cD56a6M4GMNOewqy06yjPhScXRH5xwH6jUBuTwJrEfz07razENNbOikfwTqm+jxRgk7pUN0UFf+ktcUc8srW2XwKOzix8RFT9FCGfH5/IkDoI3DIPUcMM9rMXW7/C1P6gk5Lbo0y5R1qs8OWwtHynLR3lUPd/gV2N9/gSCJvsdWnwRFEZOSWYlIWDfle9eNAtVXojmbMgewADpaeLsPwQCZlQgRyUStDXu7ZjTVGOBJASZRZ636IMs6NaMfo/WxnszEB0dPfWOcXR5Uz9uoJ/C5iYnpbdQ6RlU7DMhH5zUOvWUFWMe7sxjX4zz1Y7CTlW00uaQgRMaCzHPZvYctvUhZurqjzeq4gnkbK2xzL5tN9T0QLH8EP7Zik9x98wz3tlJNHERfQIVCEWRJ8FQQWiZsG8nSv9FMtsPgt8kUVW27ZPStZK6JETmo44PRilSlsp367zMNtGwiAsQ0jioLJa4qakQk2V17IURaXNlYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199018)(8676002)(4744005)(5660300002)(316002)(76116006)(66476007)(8936002)(478600001)(66446008)(66556008)(64756008)(91956017)(66946007)(54906003)(2906002)(6486002)(71200400001)(4326008)(41300700001)(6916009)(6512007)(26005)(6506007)(36756003)(186003)(2616005)(82960400001)(38100700002)(122000001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0dqQ0s3aFpVU0FPbkhVbWZ6WG1ndnFobGxsdDV1ajlEU0xHYUx1UVg5bVQx?=
 =?utf-8?B?QVpwcThqdlhWWWwzK0h4cC9hS1k0TkFLY0RGeElONlNUTW90UkZLRXlQQTVz?=
 =?utf-8?B?WG4zdEpOK1lBVi9SV0o5TFo2bE9uaEtLZWZuYUNmcHdhOU5TY3RFVGxKS0hC?=
 =?utf-8?B?MHA0aGVnSXZ6SVNmVE1HbWc2dWNvQzlwQTBXWGFqQTIrTEJDNDMvd0lKcTBy?=
 =?utf-8?B?aktKWXRIbG80bU1OZzBEQjZvd0NwaG9IN3k4L3pSVmVGaVZJN1o0NTEyQTZp?=
 =?utf-8?B?QU03cC9BUEE4Y0lSZU9IS0NrZnhEOUp6Wno0dVNiQml1ZXNwTExzYnpWN09K?=
 =?utf-8?B?THV1ZDIvUWVLR3NhMmtHaGVicHM5RmJQMWw5RUV4Wm90UkhGTGJ3Q3pWY3ZB?=
 =?utf-8?B?WmxlUU1DWjBncCt5eEhCK0pHdC9wNTgrMmNFN2F0djExWUxvTjdBaHFBeDAz?=
 =?utf-8?B?elFDVkprVkQwa3d4ZFVMelAvMG1HNFBzRi8zRzczWU05TUkweDZVRlJubk4y?=
 =?utf-8?B?eUs0Q1R4NTA0bkd2YXpFeWp1NGJYSGtDNndsakkwUHYxVDI1QlppT1NBVE52?=
 =?utf-8?B?MHVlaldxYjRPS0ZISWRBWXBDc1RVK2xVS1dKYklhQWNMN2QzYWVpU3dHaXBE?=
 =?utf-8?B?TlU3THpZZDI5aU91M2FhQjNPMndVajZnYUVCdENBSFZJQitUbTF2ZFZ0aHdC?=
 =?utf-8?B?N1ZxTzhubDBja2RnalZxUlU0dlZwS2dURU5MRE9Md0hKR3U1YUtnbDFFZ2tQ?=
 =?utf-8?B?cmR6VjRMOGRPSGdmY0hwY2RNNHVLTGhxVTE1TDB0cStZU2FndWR0WW1qaTFp?=
 =?utf-8?B?bkNSQlpPdUIrY0gyZ0VHU2dTV0tpaGFZQnhLNkFZYUdlWlVHNkV4NXZBYWxh?=
 =?utf-8?B?UXludnB4VnVDL2dzNkFPM3cvT2xSUHNWNUprOGJpRHZBQ2RoaVY0Q25WdkdH?=
 =?utf-8?B?QVhYN0QvTUpsR2lHZlhaVGlSU21RMHFvMUdCcEFsUGxoNTMyWlZsMzdLSXJi?=
 =?utf-8?B?Ykw5d29POElFZ0hvVHErWnp4NTFtb2ZoeUhwajlBTmY4QlBWWU1TQ0U4ZXc5?=
 =?utf-8?B?YTJCZWY4OEtBM0xtRm5hOTRJZllublZhK1N6eUIyakZJL1MveW4yV2J6eVdl?=
 =?utf-8?B?SW9Mbk1aR3psQlpRbEpCd0J4a3pYbmx2ZGlTL05MNjNqbmFSRzR1bDkyTVFk?=
 =?utf-8?B?cCt0blJybWhJU3pRbkhCbmV5bndNVlc1eGhLNDVjMThDRlAwbUtzekE5djln?=
 =?utf-8?B?WHR1YmZpM1h5MGRWZ2xNbiszRU5SWVk3djRkN1RxL1E3TzUvRysvenZGQUVF?=
 =?utf-8?B?VEFnRVJ6a0xSdDFxK0wvOXVVZVlHYVZpTklUdm1ld2FtV2xNNDd5SHg1Mnh2?=
 =?utf-8?B?b2lCWUdidUFJQmtORUFmdjA1S1k1ajFabFhpaCs1N1VFNFY2NEM4TDE0VFpl?=
 =?utf-8?B?Vi8yTWhjZHFQUmdpM3AzcGVpd1UwVXFlcFVqMWovZ1EyQmozQnhkSGwvejVh?=
 =?utf-8?B?WGltOW5MTlgzRlpDQUdWaGplL3lDWU45YjJRV0NZWWgzcEc0U3FiYlNaREpB?=
 =?utf-8?B?ai9CRmJtNHBMa0xDL0I0TFVqcjc0N01sdTFnR080L3pPREdKamdtcnpqWGM0?=
 =?utf-8?B?L2xVc25VUGNZUmFUTFFVSWd1eTFabXhnTE5lSEFtaXJkOE9hOGFTNUlrdk5v?=
 =?utf-8?B?NWkyVUJMWUVIbW1iT29BR1NCc2lsYXhQMFVDekF5S0IxaktZQmRWOW00OGUr?=
 =?utf-8?B?Zk1haUpQSE95V25XSDFqaWptQXg4aE01b2ovblJ3cUpEWE9Tbi93RGhzMkRY?=
 =?utf-8?B?NmNLTng4QVlTU084TkRXcE5XaG9rellqdE9KeEh6dEI3bEw4dUdDN2w4L2Er?=
 =?utf-8?B?dHErR0VZc3gxeG9RQ1RneFIwdEhVK05ORzVLa3VQcjg1OVcwQkZ1WFhOR0Nq?=
 =?utf-8?B?blJsL3NmeU52ZG96VVBtbDRvRS85elRsZ1RyYkhBL29LQkN2T25SYUlJUWhp?=
 =?utf-8?B?L0p4dU94Y0JTZnhYZlgyeUt4UElVam41RlZtMEJVQ2hHWEJDNzRqWFVJK25a?=
 =?utf-8?B?RVowQ2tpUHlmU3RVc1pJTHpibkRDU3Z6V01UbmJIbHpkYkg1THk0TXlOd3ls?=
 =?utf-8?B?YWFEYk80NVBmRkV6UEZWN1V1TVRzdGZkOE1DZE1MV1g1d2ZTVmRERHc1aHVD?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6417EDFE50DBE843A71745CA9AAF4F81@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9ab896-a032-409e-1f03-08db2bf4aa3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 23:16:43.0982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuRpVmucvedsuqNWGMW+pXRMZ990ow+oYAw2ahUINUWKdaC66in7NridNObIkkYGcnyZxwe+kX6Jl5miwTUo1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTIzIGF0IDE1OjQwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1hciAyMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDMtMjMgYXQgMDc6MjAgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBPbiBUaHUsIE1hciAyMywgMjAyMywgbGlyb25ncWluZ0BiYWlkdS5jb20gd3JvdGU6
DQo+ID4gPiA+IEZyb206IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiA+
ID4gDQo+ID4gPiA+IGlmIENQVSBoYXMgbm90IFg4Nl9CVUdfSVRMQl9NVUxUSUhJVCBidWcsIGt2
bS1ueC1scGFnZS1yZSBrdGhyZWFkDQo+ID4gPiA+IGlzIG5vdCBuZWVkZWQgdG8gY3JlYXRlDQo+
ID4gPiANCj4gPiA+IFVubGVzcyB1c2Vyc3BhY2UgZm9yY2VzIHRoZSBtaXRpZ2F0aW9uIHRvIGJl
IGVuYWJsZWQsIHdoaWNoIGNhbiBiZSBkb25lIHdoaWxlIEtWTQ0KPiA+ID4gaXMgcnVubmluZy4g
w6/Cv8K9DQo+ID4gPiANCj4gPiANCj4gPiBXb25kZXJpbmcgd2h5IGRvZXMgdXNlcnNwYWNlIHdh
bnQgdG8gZm9yY2UgdGhlIG1pdGlnYXRpb24gdG8gYmUgZW5hYmxlZCBpZiBDUFUNCj4gPiBkb2Vz
bid0IGhhdmUgc3VjaCBidWc/DQo+IA0KPiBJdCdzIGRlZmluaXRlbHkgdXNlZnVsIGZvciB0ZXN0
aW5nLCBidXQgdGhlIHJlYWwgbW90aXZhdGlvbiBpcyBzbyB0aGF0IHRoZQ0KPiBtaXRnYXRpb24g
Y2FuIGJlIGVuYWJsZWQgd2l0aG91dCBhIGtlcm5lbCByZWJvb3QgKG9yIHJlbG9hZGluZyBLVk0p
LCBpLmUuIHdpdGhvdXQNCj4gaGF2aW5nIHRvIGRyYWluIFZNcyBvZmYgdGhlIGhvc3QsIGlmIGl0
IHR1cm5zIG91dCB0aGF0IHRoZSBob3N0IENQVSBhY3R1YWxseSBpcw0KPiB2dWxuZXJhYmxlLiAg
SS5lLiB0byBndWFyZCBhZ2FpbnN0ICJOb3BlLCBub3QgdnVsbmVyYWJsZSEgIE9oLCB3YWl0LCBq
dXN0IGtpZGRpbmchIi4NCg0KTmV2ZXIgdGhvdWdodCBhYm91dCB0aGlzIGNhc2UuICBUaGFua3Mh
DQoNCg==
