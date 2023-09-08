Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDB579863C
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 13:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243075AbjIHLAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 07:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjIHLAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 07:00:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0661BF9;
        Fri,  8 Sep 2023 04:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694170836; x=1725706836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dlNm35x/Xwg9M0Pp5CLOxpARMW7c++5eGojgyzms/34=;
  b=BapX+UnGN03X6HKaLIHgSkeTM0Ju4u0zZdaGzx0vEaD0CNFdBhMuAtV6
   r6AYNmynWyHqoXcKYDr06c1/+ouRBTO6Oh6ZUc6nGttns/pkBwANpY1sy
   YG+gE4R5yiSAFGiscUCBtkS0yAPYrLq/aZSyRbe5pIP94hROm3Xp541Y8
   eJa7wn+gIeQzzHxbufV3NGdmF2NmsvlutzH4lawx1p+n09SfZiZ4nbERQ
   7eYuybB4n3DzfqpFUE8h50NPZy1wEgg7x7zc72U3dyBP0AIqqKcEPxi2j
   76SuNCcTsieb7DwW7368pn3qj9xhTNm1ADXXWm2gxDaSzwntooHLOMWYL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="375002187"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="375002187"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 04:00:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="777528799"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="777528799"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Sep 2023 04:00:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 8 Sep 2023 04:00:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 8 Sep 2023 04:00:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 8 Sep 2023 04:00:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaLAUvMHpt9kMe9ZuY8XHC7cGX+ie7hpSoMXR7T9SVvF+WpNPwQc1PsbxuqsQEoQCEbCgdJxtJlTTzCtj3qkwJ9Abb/UKep5MynkGcKC8iZ40afas9WWpF1xNh5D/LrCktprLh7TSLVCiNc5PDmoriCyzGP9oNsDU1cN/k2K3YKJxopE6Kd+bxnbC3YUOQ17pkhhoeDQW9v+/+6h6c6Sjh5onIQkXlMqa3T9JhtqFVVjr3TbjOukCVML55KuVHRHHHAlqPc4BPgfWJsi5XREajeUq4nCRddg7UuN+IzekV23GX9RXTYTVUgLGN239wJTkRQczDfs03E1RuilWJhBpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlNm35x/Xwg9M0Pp5CLOxpARMW7c++5eGojgyzms/34=;
 b=QvTjyOxBAGmoKHXhRPdi8RStxuufZSkbhBw5Vm7hsPQnUezxdyFhSSz9jSUQUaJeuqMjVsnOB00jsaPewe3HLrq2e0J661HInqyvU2Y2L1VZgPOix/qPgyw2+NcmkjxMCl0b1e2CsWQ0oILAsr1jrc9CLTQHAoiZRTlmT/5L/vR2eMzvrVYBwiAfskAmZdQU2o4fP8f+AH05wReaZemoGHN69lJROCCT/v8gYWcdfOt9Nop2KjR1xxl8wdnq6d360VljDHNMtM6iOz4qQqLiIuWS1c77GLchL+IRmvpmoSjx/LQCniFoVcsJ67csNz9k8fBBDmV1cD8qhB+WXWONEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7771.namprd11.prod.outlook.com (2603:10b6:610:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Fri, 8 Sep
 2023 11:00:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Fri, 8 Sep 2023
 11:00:21 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Subject: Re: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Topic: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Index: AQHZ101De3tVNeYkQ0yO53WAEnLA0rAPY8gAgAFta4CAAAFSgIAABi4A
Date:   Fri, 8 Sep 2023 11:00:21 +0000
Message-ID: <33169a3f272b631b497cd8fbf710236cdc3681d8.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
         <7523faad-23f0-2fcb-30e3-b0207d71e63f@suse.com>
         <4134057a145677de2779612920f3f903654c554f.camel@intel.com>
         <4dfb1174-cb9c-2405-6a8c-b0c6866a8fe1@suse.com>
In-Reply-To: <4dfb1174-cb9c-2405-6a8c-b0c6866a8fe1@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7771:EE_
x-ms-office365-filtering-correlation-id: afaf153b-d4b0-40fd-208e-08dbb05acbbe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zvXnYUt+uctHqQc8oQ8QBrNF6+zSgUSSlqmdEGDv5VFwer4eoOmJODGfvRfMWuJeBa2Rqo3EyrlND+LwSrnsubu7gg6SbzZ2L8fA5Mt2D8bonTnWFiuIZMOgYCpHQeezPGhD/vO32yLNQ0Y4Ry/grVzP/1NjSebIKw+0boEY6N2ZrMNjK8Ywn7FHTYXSQf6cUEsyFDjfUEHk8WOA1de4bpCG+/hiog1qw+kIKHZTJk6IiWVM3WBcQnEhOsLx9qsDaGhGfr2/npw2F5zlIQWO5VQlR+jF9LBHRLfnOhPqS3H7QrCJqnDYwSrgq4Ihk9mOzsXHoChPXm6bi7YXpm1NC0IgSFSAGfLpO8fMmP4KKH9vSeLGSoHC2RpQHvE2B2XZd44ct6f4gRh3eXGwZV4L0diAnYDc4JD5VRjD9ZSV6w2N0w0AEQbMKRQB4/dfOvRYwePJKXNQ2aYXvyW5sdvMvqDp0SQXiAcsYqpKjxxasP8D442sCpBbv2uuP3vIBICdha21BNrBrzycJWbWMYUDTVfDuVa+VfyrwQ87Tcnm6RBrEMu1kT3lG0XRLdAjlLChMEpzp2PEszABygmQfOCEjFA2kJonJe3MnwpIhf1ob7uSRwlNZw5QuTofrXU3OFWf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(376002)(346002)(366004)(1800799009)(186009)(451199024)(71200400001)(6486002)(6506007)(83380400001)(6512007)(2616005)(26005)(478600001)(2906002)(110136005)(7416002)(66556008)(66946007)(41300700001)(66476007)(54906003)(64756008)(66446008)(316002)(8936002)(91956017)(8676002)(4326008)(5660300002)(36756003)(86362001)(38070700005)(38100700002)(76116006)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3YwYlp2aVFWU0Q2aVJ2Wkh1aDRlbVc0L2IxZWtWOVdhSDdJN2lKUUNrNFFE?=
 =?utf-8?B?LzU3SFFoNUJ5ais3clI4NEJkWkhlbzF1YkZSb0tjc0xYaE84ZENTQUlVWFBD?=
 =?utf-8?B?NDlHSG4rWlVHbzM0ZnNSclhlZjB5bW5Hb2dETGxXUkFUeFRnOFlHZHVlR1Fn?=
 =?utf-8?B?V2pxSTNEMktBMUlLY2hFUy83WVMrN0hoQ0Z1azJEenNyaXVhWEFLZ2ZZdVpy?=
 =?utf-8?B?S0s2Wmgvc2dTL3BkbC9wRW9yTVVHVWhLMG8xR0ptV2d0eldGRDIyeEhwMUZo?=
 =?utf-8?B?N1BURjQ5Zkdqc243RktGVEZuQ0owWGxTc2dEQ2E4U0k1anRrd3hEbWVFdytx?=
 =?utf-8?B?eVAyMlRuSGVjaUJxOEM1cW9NQk82Y1JydlUwL2dWTmFZSWNVZ2V6b2NjVjE3?=
 =?utf-8?B?a24vZnpBZWtVMi9QTUV5RVZDcERMcmJ0L0xjUFBRQlArbGMycmwxWm9DZGU4?=
 =?utf-8?B?SlhVMHhzdTRUeHhpQnZwQ3JMK1lyZS90VEsrblpxWFA4YXpzdmxoRzNMOTJ6?=
 =?utf-8?B?VjV5NlJjQisvOEF6RUFqbkZPd1hUamJydVZKWnlyOWJFTE5WNFBYN3hjdjd5?=
 =?utf-8?B?MjBuQ1JablFWM0k3VmJnWjc0TmF6MUdKZSt4aVNvSHYyamhDYmNhd3UzUFQv?=
 =?utf-8?B?RXVwVnpDa2xtREhhNTdvK2EwVnNSa2YwK0tOcXg5NmVMaWxmUDVYT0l3RGNP?=
 =?utf-8?B?djZzT2FDME5WUHd4MlFRZ0krRmh6QmV1YVJBdXdadWlHOWxYR2hTY0o4QzJG?=
 =?utf-8?B?M2ZUTEZUeU1DSVJyVjNrWVRqWG8wOUxsR3ZZdm5QL3M5QXRmQVYxTy9mdjhW?=
 =?utf-8?B?M0JqanZmT0RLeFB2SkEvM3hPclBWNnNxb2pkR1E2UGxPM04vUUxma1QvM29x?=
 =?utf-8?B?OUJtVXJiSW9OQTJVbUVuWFI4Uk9iOEQzZU5YbU44Qjh0amp1bHFQN05yZS9S?=
 =?utf-8?B?OG1QcGljM3hVYy9ZVThKKzVnZ0puQU4yRFpiNmFzQjU0UWJzSElnRUdGWFlG?=
 =?utf-8?B?aUNDMnpkMjNyY3ZadnYwcTVpSjVpZmZScWRBSENiNVBtZ2laaDhOKzg4eDRW?=
 =?utf-8?B?ZDJGckNuRXJaNVNtMkRVRlNaVHhlYnJGUjRpMGFuK1lITzZRdlErU0ZkalR4?=
 =?utf-8?B?MkNBZVlWWldBTUtpWTlkaDc0VFBROEtPRldKSmVMTG5kZmt6Yk9jVllOV0d3?=
 =?utf-8?B?VnNSUXVWS0tnQTdyV3Z3MkZqaGVCSnY2a0ZvU1Z5bHZGSERtb3gwTDRaU3Zh?=
 =?utf-8?B?b3p3N09zSUFyRndhM3ROSFRjVVVOR2xtSU04MENKMDBEbGxZVHc5eC9CT1Bv?=
 =?utf-8?B?QlNZaUhzRlRGbWtUSkRyZ2NUNTBuUHlVRmZmQ2k5WGY3dG9Zc1Bod1FzRjJv?=
 =?utf-8?B?dVUwcEhjVDIrdlJCQlhSZGtZd1VZMytVTTFFNXRsNjBEOGQvek84UDNnd1Fp?=
 =?utf-8?B?dVdRd0Y0RkgzcmJXMzdza2hxZm5TTnZ1NnRPa1hyZ3RlVFJjcEFyZDVXVHlO?=
 =?utf-8?B?VDEzTitmS0JFWW4wM0JYY0N2ejJ4ajVObEJWT1R2cElnT3MyWTg3NUd5ZEJR?=
 =?utf-8?B?NEpVb2JHUkpxQUUrY2xsQzRoOVg0OWcxNnRvd3QwL0cvZmJWbUFWSzRMbm9o?=
 =?utf-8?B?V3Y1dk5aWE43c2hyZHJtMTNPMVc3L1l5OTR1VVcwNWp3U2p1TjQzeHhvY3pa?=
 =?utf-8?B?QWhEN2xaMW54UEZnVXFpdEtKZ3lJZ2hOd3F2VFFFbm1mODBUeWlVRnZKUVli?=
 =?utf-8?B?eFJoMDJMOEYwUEMxL0dKV0ltYUt5TWR3b0lTd1k3cHA0SVFhMjdneld0dkpq?=
 =?utf-8?B?Qmtsb2NNWkpWWk9nL2JqNEhxOXFlbytLV0ltYzZISHYyM2V2bitSU0daMlJX?=
 =?utf-8?B?Zy9YRkJicnJyR1FxbmNTSkZzaHVhUVg4dzVyYi9ydmdHNFpqc3hBRFlGYUlD?=
 =?utf-8?B?UjBaM3NtOHhLK2l1T3I0ZEYzK2VCc3Vob0VRWllrSk05TW5tS2oyMjJDRlN4?=
 =?utf-8?B?a2oveHlMMjU1YTBYcHg3dlo0MzZSaTRJZUV3Tmowems1MXh1VEhYVXhxbU1R?=
 =?utf-8?B?VyszQytrS3oyL3dBTUZGcldjTVUwYU9GdSt2ZUVYSU9uUStNS0d0RHR1d0pt?=
 =?utf-8?Q?9qXbtdvB2xMyg8Kxv/WiV1Sr0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F12BBA9EC0678340B879E00C19AE6B59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afaf153b-d4b0-40fd-208e-08dbb05acbbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2023 11:00:21.4832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7pNIpW9mFNzRVxaYG/xm4fAKxj/0ax0qRK4LKS6zu5c4UNPL4Qp6p6PYxAjml1NarP+y8PuOQZ4iW5pMdfqFig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7771
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTA4IGF0IDEzOjM4ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiA4LjA5LjIzINCzLiAxMzozMyDRhy4sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
DQo+ID4gPiA+ICsjZGVmaW5lIHNlYW1jYWxsX2VycihfX2ZuLCBfX2VyciwgX19hcmdzLCBfX3By
ZXJyX2Z1bmMpCQkJXA0KPiA+ID4gPiArCV9fcHJlcnJfZnVuYygiU0VBTUNBTEwgKDB4JWxseCkg
ZmFpbGVkOiAweCVsbHhcbiIsCQlcDQo+ID4gPiA+ICsJCQkoKHU2NClfX2ZuKSwgKCh1NjQpX19l
cnIpKQ0KPiA+ID4gPiArDQo+ID4gPiA+ICsjZGVmaW5lIFNFQU1DQUxMX1JFR1NfRk1UCQkJCQkJ
XA0KPiA+ID4gPiArCSJSQ1ggMHglbGx4IFJEWCAweCVsbHggUjggMHglbGx4IFI5IDB4JWxseCBS
MTAgMHglbGx4IFIxMSAweCVsbHhcbiINCj4gPiA+ID4gKw0KPiA+ID4gPiArI2RlZmluZSBzZWFt
Y2FsbF9lcnJfcmV0KF9fZm4sIF9fZXJyLCBfX2FyZ3MsIF9fcHJlcnJfZnVuYykJCVwNCj4gPiA+
ID4gKyh7CQkJCQkJCQkJXA0KPiA+ID4gPiArCXNlYW1jYWxsX2VycigoX19mbiksIChfX2Vyciks
IChfX2FyZ3MpLCBfX3ByZXJyX2Z1bmMpOwkJXA0KPiA+ID4gPiArCV9fcHJlcnJfZnVuYyhTRUFN
Q0FMTF9SRUdTX0ZNVCwJCQkJCVwNCj4gPiA+ID4gKwkJCShfX2FyZ3MpLT5yY3gsIChfX2FyZ3Mp
LT5yZHgsIChfX2FyZ3MpLT5yOCwJXA0KPiA+ID4gPiArCQkJKF9fYXJncyktPnI5LCAoX19hcmdz
KS0+cjEwLCAoX19hcmdzKS0+cjExKTsJXA0KPiA+ID4gPiArfSkNCj4gPiA+ID4gKw0KPiA+ID4g
PiArI2RlZmluZSBTRUFNQ0FMTF9FWFRSQV9SRUdTX0ZNVAlcDQo+ID4gPiA+ICsJIlJCWCAweCVs
bHggUkRJIDB4JWxseCBSU0kgMHglbGx4IFIxMiAweCVsbHggUjEzIDB4JWxseCBSMTQgMHglbGx4
IFIxNSAweCVsbHgiDQo+ID4gPiA+ICsNCj4gPiA+ID4gKyNkZWZpbmUgc2VhbWNhbGxfZXJyX3Nh
dmVkX3JldChfX2ZuLCBfX2VyciwgX19hcmdzLCBfX3ByZXJyX2Z1bmMpCVwNCj4gPiA+ID4gKyh7
CQkJCQkJCQkJXA0KPiA+ID4gPiArCXNlYW1jYWxsX2Vycl9yZXQoX19mbiwgX19lcnIsIF9fYXJn
cywgX19wcmVycl9mdW5jKTsJCVwNCj4gPiA+ID4gKwlfX3ByZXJyX2Z1bmMoU0VBTUNBTExfRVhU
UkFfUkVHU19GTVQsCQkJCVwNCj4gPiA+ID4gKwkJCShfX2FyZ3MpLT5yYngsIChfX2FyZ3MpLT5y
ZGksIChfX2FyZ3MpLT5yc2ksCVwNCj4gPiA+ID4gKwkJCShfX2FyZ3MpLT5yMTIsIChfX2FyZ3Mp
LT5yMTMsIChfX2FyZ3MpLT5yMTQsCVwNCj4gPiA+ID4gKwkJCShfX2FyZ3MpLT5yMTUpOwkJCQkJ
XA0KPiA+ID4gPiArfSkNCj4gPiA+ID4gKw0KPiA+ID4gPiArc3RhdGljIF9fYWx3YXlzX2lubGlu
ZSBib29sIHNlYW1jYWxsX2Vycl9pc19rZXJuZWxfZGVmaW5lZCh1NjQgZXJyKQ0KPiA+ID4gPiAr
ew0KPiA+ID4gPiArCS8qIEFsbCBrZXJuZWwgZGVmaW5lZCBTRUFNQ0FMTCBlcnJvciBjb2RlIGhh
dmUgVERYX1NXX0VSUk9SIHNldCAqLw0KPiA+ID4gPiArCXJldHVybiAoZXJyICYgVERYX1NXX0VS
Uk9SKSA9PSBURFhfU1dfRVJST1I7DQo+ID4gPiA+ICt9DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyNk
ZWZpbmUgX19TRUFNQ0FMTF9QUkVSUihfX3NlYW1jYWxsX2Z1bmMsIF9fZm4sIF9fYXJncywgX19z
ZWFtY2FsbF9lcnJfZnVuYywJXA0KPiA+ID4gPiArCQkJX19wcmVycl9mdW5jKQkJCQkJCVwNCj4g
PiA+ID4gKyh7CQkJCQkJCQkJCVwNCj4gPiA+ID4gKwl1NjQgX19fc3JldCA9IF9fc2VhbWNhbGxf
ZnVuYygoX19mbiksIChfX2FyZ3MpKTsJCQlcDQo+ID4gPiA+ICsJCQkJCQkJCQkJXA0KPiA+ID4g
PiArCS8qIEtlcm5lbCBkZWZpbmVkIGVycm9yIGNvZGUgaGFzIHNwZWNpYWwgbWVhbmluZywgbGVh
dmUgdG8gY2FsbGVyICovCVwNCj4gPiA+ID4gKwlpZiAoIXNlYW1jYWxsX2Vycl9pc19rZXJuZWxf
ZGVmaW5lZCgoX19fc3JldCkpICYmCQkJXA0KPiA+ID4gPiArCQkJX19fc3JldCAhPSBURFhfU1VD
Q0VTUykJCQkJCVwNCj4gPiA+ID4gKwkJX19zZWFtY2FsbF9lcnJfZnVuYygoX19mbiksIChfX19z
cmV0KSwgKF9fYXJncyksIF9fcHJlcnJfZnVuYyk7CVwNCj4gPiA+ID4gKwkJCQkJCQkJCQlcDQo+
ID4gPiA+ICsJX19fc3JldDsJCQkJCQkJCVwNCj4gPiA+ID4gK30pDQo+ID4gPiA+ICsNCj4gPiA+
ID4gKyNkZWZpbmUgU0VBTUNBTExfUFJFUlIoX19zZWFtY2FsbF9mdW5jLCBfX2ZuLCBfX2FyZ3Ms
IF9fc2VhbWNhbGxfZXJyX2Z1bmMpCVwNCj4gPiA+ID4gKyh7CQkJCQkJCQkJCVwNCj4gPiA+ID4g
Kwl1NjQgX19fc3JldCA9IF9fU0VBTUNBTExfUFJFUlIoX19zZWFtY2FsbF9mdW5jLCBfX2ZuLCBf
X2FyZ3MsCQlcDQo+ID4gPiA+ICsJCQlfX3NlYW1jYWxsX2Vycl9mdW5jLCBwcl9lcnIpOwkNCj4g
PiA+IA0KPiA+ID4gX19TRUFNQ0FMTF9QUkVSUiBzZWVtcyB0byBvbmx5IGV2ZXIgYmUgY2FsbGVk
IHdpdGggcHJfZXJyIGZvciBhcyB0aGUNCj4gPiA+IGVycm9yIGZ1bmN0aW9uLCBjYW4geW91IGp1
c3Qga2lsbCBvZmYgdGhhdCBhcmd1bWVudCBhbmQgYWx3YXlzIGNhbGwgcHJfZXJyLg0KPiA+IA0K
PiA+IFBsZWFzZSBzZWUgYmVsb3cuDQo+ID4gDQo+ID4gPiAJCQlcDQo+ID4gPiA+ICsJaW50IF9f
X3JldDsJCQkJCQkJCVwNCj4gPiA+ID4gKwkJCQkJCQkJCQlcDQo+ID4gPiA+ICsJc3dpdGNoIChf
X19zcmV0KSB7CQkJCQkJCVwNCj4gPiA+ID4gKwljYXNlIFREWF9TVUNDRVNTOgkJCQkJCQlcDQo+
ID4gPiA+ICsJCV9fX3JldCA9IDA7CQkJCQkJCVwNCj4gPiA+ID4gKwkJYnJlYWs7CQkJCQkJCQlc
DQo+ID4gPiA+ICsJY2FzZSBURFhfU0VBTUNBTExfVk1GQUlMSU5WQUxJRDoJCQkJCVwNCj4gPiA+
ID4gKwkJcHJfZXJyKCJTRUFNQ0FMTCBmYWlsZWQ6IFREWCBtb2R1bGUgbm90IGxvYWRlZC5cbiIp
OwkJXA0KPiA+ID4gPiArCQlfX19yZXQgPSAtRU5PREVWOwkJCQkJCVwNCj4gPiA+ID4gKwkJYnJl
YWs7CQkJCQkJCQlcDQo+ID4gPiA+ICsJY2FzZSBURFhfU0VBTUNBTExfR1A6CQkJCQkJCVwNCj4g
PiA+ID4gKwkJcHJfZXJyKCJTRUFNQ0FMTCBmYWlsZWQ6IFREWCBkaXNhYmxlZCBieSBCSU9TLlxu
Iik7CQlcDQo+ID4gPiA+ICsJCV9fX3JldCA9IC1FT1BOT1RTVVBQOwkJCQkJCVwNCj4gPiA+ID4g
KwkJYnJlYWs7CQkJCQkJCQlcDQo+ID4gPiA+ICsJY2FzZSBURFhfU0VBTUNBTExfVUQ6CQkJCQkJ
CVwNCj4gPiA+ID4gKwkJcHJfZXJyKCJTRUFNQ0FMTCBmYWlsZWQ6IENQVSBub3QgaW4gVk1YIG9w
ZXJhdGlvbi5cbiIpOwkJXA0KPiA+ID4gPiArCQlfX19yZXQgPSAtRUFDQ0VTOwkJCQkJCVwNCj4g
PiA+ID4gKwkJYnJlYWs7CQkJCQkJCQlcDQo+ID4gPiA+ICsJZGVmYXVsdDoJCQkJCQkJCVwNCj4g
PiA+ID4gKwkJX19fcmV0ID0gLUVJTzsJCQkJCQkJXA0KPiA+ID4gPiArCX0JCQkJCQkJCQlcDQo+
ID4gPiA+ICsJX19fcmV0OwkJCQkJCQkJCVwNCj4gPiA+ID4gK30pDQo+ID4gPiA+ICsNCj4gPiA+
ID4gKyNkZWZpbmUgc2VhbWNhbGxfcHJlcnIoX19mbiwgX19hcmdzKQkJCQkJCVwNCj4gPiA+ID4g
KwlTRUFNQ0FMTF9QUkVSUihzZWFtY2FsbCwgKF9fZm4pLCAoX19hcmdzKSwgc2VhbWNhbGxfZXJy
KQ0KPiA+ID4gPiArDQo+ID4gPiA+ICsjZGVmaW5lIHNlYW1jYWxsX3ByZXJyX3JldChfX2ZuLCBf
X2FyZ3MpCQkJCQlcDQo+ID4gPiA+ICsJU0VBTUNBTExfUFJFUlIoc2VhbWNhbGxfcmV0LCAoX19m
biksIChfX2FyZ3MpLCBzZWFtY2FsbF9lcnJfcmV0KQ0KPiA+ID4gPiArDQo+ID4gPiA+ICsjZGVm
aW5lIHNlYW1jYWxsX3ByZXJyX3NhdmVkX3JldChfX2ZuLCBfX2FyZ3MpCQkJCQlcDQo+ID4gPiA+
ICsJU0VBTUNBTExfUFJFUlIoc2VhbWNhbGxfc2F2ZWRfcmV0LCAoX19mbiksIChfX2FyZ3MpLAkJ
CVwNCj4gPiA+ID4gKwkJCXNlYW1jYWxsX2Vycl9zYXZlZF9yZXQpDQo+ID4gPiANCj4gPiA+IA0K
PiA+ID4gVGhlIGxldmVsIG9mIGluZGlyZWN0aW9uIHdoaWNoIHlvdSBhZGQgd2l0aCB0aG9zZSBz
ZWFtY2FsX2VyciogZnVuY3Rpb24NCj4gPiA+IGlzIGp1c3QgbWluZCBib2dnbGluZzoNCj4gPiA+
IA0KPiA+ID4gDQo+ID4gPiBTRUFNQ0FMTF9QUkVSUiAtPiBfX1NFQU1DQUxMX1BSRVJSIC0+IF9f
c2VhbWNhbGxfZXJyX2Z1bmMgLT4NCj4gPiA+IF9fcHJlcnJfZnVuYyBhbmQgYWxsIG9mIHRoaXMg
c28geW91IGNhbiBoYXZlIGEgc3RhbmRhcmRpemVkIHN0cmluZw0KPiA+ID4gcHJpbnRpbmcuIEkg
c2VlIG5vIHZhbHVlIGluIGhhdmluZyBfX1NFQU1DQUxMX1BSRVJSIGFzIGEgc2VwYXJhdGUgbWFj
cm8sDQo+ID4gPiBzaW1wbHkgaW5saW5lIGl0IGludG8gU0VBTUNBTExfUFJFUlIsIHJlcGxhY2Ug
dGhlIHByZXJyX2Z1bmMgYXJndW1lbnQNCj4gPiA+IHdpdGggYSBkaXJlY3QgY2FsbCB0byBwcl9l
cnIuDQo+ID4gDQo+ID4gVGhhbmtzIGZvciBjb21tZW50cyENCj4gPiANCj4gPiBJIHdhcyBob3Bp
bmcgX19TRUFNQ0FMTF9QUkVSUigpIGNhbiBiZSB1c2VkIGJ5IEtWTSBjb2RlIGJ1dCBJIGd1ZXNz
IEkgd2FzIG92ZXItDQo+ID4gdGhpbmtpbmcuIMKgSSBjYW4gcmVtb3ZlIF9fU0VBTUNBTExfUFJF
UlIoKSB1bmxlc3MgSXNha3UgdGhpbmtzIGl0IGlzIHVzZWZ1bCB0bw0KPiA+IEtWTS4NCj4gDQo+
IEJlIHRoYXQgYXMgaXQgbWF5LCBJIHRoaW5rIGl0IHdhcnJhbnRzIGF0IGxlYXN0IHNvbWUgbWVu
dGlvbmluZyBpbiB0aGUgDQo+IGNoYW5nZWxvZy4gQWx0ZXJuYXRpdmVseSBpbiB0aGUgZmlyc3Qg
aXRlcmF0aW9uIG9mIHRob3NlIHBhdGNoZXMgdGhpcyANCj4gY2FuIGJlIG9taXR0ZWQgYW5kIHRo
ZW4gaXQgY2FuIGJlIGludHJvZHVjZWQgYXQgdGhlIHRpbWUgdGhlIGZpcnN0IHVzZXJzIA0KPiBz
aG93cyB1cC4gSW4gYW55IGNhc2UsIGxldCdzIHdhaXQgZm9yIHRoZSBLVk0gcGVvcGxlIHRvIGNv
bW1lbnQuDQoNClllYWggYWdyZWVkLiAgSSBoYWQgYmVsb3cgaW4gdGhlIGNoYW5nZWxvZyBidXQg
cGVyaGFwcyBpdCdzIHRvbyB2YWd1ZToNCg0KIkF0IGxhc3QsIGZvciBub3cgaW1wbGVtZW50IHRo
b3NlIHdyYXBwZXJzIGluIHRkeC5jIGJ1dCB0aGV5IGNhbiBiZSBtb3ZlZA0KdG8gPGFzbS90ZHgu
aD4gd2hlbiBuZWVkZWQuICBUaGV5IGFyZSBpbXBsZW1lbnRlZCB3aXRoIGludGVudGlvbiB0byBi
ZQ0Kc2hhcmVkIGJ5IG90aGVyIGtlcm5lbCBjb21wb25lbnRzLiINCg==
