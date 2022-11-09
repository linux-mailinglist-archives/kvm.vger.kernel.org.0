Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EA9622BD5
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 13:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKIMqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 07:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiKIMqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 07:46:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D92D1C9;
        Wed,  9 Nov 2022 04:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667997975; x=1699533975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DNkrF3nPbup25jiU6KCUuTEsqNkB+iZwfVJlfM1JnsU=;
  b=jN0kskgJEEa0Sz8foJwCXG4ZP1BRfT0GhuZyYw3ZUWw0HQt7lw/IX/I+
   SLm1EHsA6rv5QSmquz3lYhzjl1aY+5l0ks3eJp9EcwCreM93zQ0zeRky/
   Gur10SUltOOpt+nPhiPfEFgrEnhSCkiyggKaaA+9v7FqRX4HJ0dLf7s6X
   Awop44fIYRAqHARVMtbSgdr5gWGa0ox6g+4wJWANs/d7urWGdmQlM96SJ
   tTetR1coHU/QbC5H8Sb5MCNVoH+ugcbT3H7lgVKi6b7CsOHnWiiWVaSMi
   Wok6bgzPyTnBDWnzWwPr67VIahJaBSw+urD5gs0QsVvubxdTXofRdH0HX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="312127814"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="312127814"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 04:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="742383982"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="742383982"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 09 Nov 2022 04:46:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 04:46:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 04:46:13 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 04:46:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6+XCzBzmJ3uDu/s1NJzRUECtmioI9PFgAWw3nVBV3YXs0uK5GpYq/1SBi2DKO+MDpA2qkuJXD48mkEtuTGQVc/D8Nhn+VbajUcj4SWmXElkhYzptQD7RM4lKZYy7K8FIB1+qqV0Xl3z4z/6Un57NnzLKRkV6j5ldaIkgB9t2Fs5GTy+/e9CLaAIUgz7eGIzJXpOM5yKO7JZ6VkrBcoRWrzhVDCnBAWCGM5IYMyL7qcB+qjZmHjt+fODTeu+nZQ5ZbWS2HEEP7x3tBs3oWtCF6Sz9MO+OkWuqVL2XfXHMdfmki2OqJayIxA0XTgWjLlwuME9+eQsfuQpD/yE9sYSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNkrF3nPbup25jiU6KCUuTEsqNkB+iZwfVJlfM1JnsU=;
 b=HVK3cBptLbsTkOHrza1CJxuA8uUNW3Xc1kHOYnK709AHAQR2YWQN0wLbXlgzQeyoedxFot1odxMJuWNSsxI18gATz4YUw9ZJqcvBbbHVfIVq5GixQ5HzhWrK5z0Pvba7RcLpq3UBPx2Y1cypHCOuj/8ygnkOBe4Eb68+vwan3QkXIul/nWLXK9Pse8rzm2UMPC+S151iNycZpOnGK6nRvemLHkJwEvjnwSZzx5sp0YlAcYDzOJL4yvikpXfUNrbHtx95yg0dGWOOys/8CskufTMmgejP7A1OG4kLBQNI00DY6fLNJk72uv1CuZus00YwaTE5+Jri3bVqzTUUPGcWzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6711.namprd11.prod.outlook.com (2603:10b6:806:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 12:46:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Wed, 9 Nov 2022
 12:46:11 +0000
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
Subject: Re: [PATCH v10 036/108] KVM: TDX: Enable mmio spte caching always for
 TDX
Thread-Topic: [PATCH v10 036/108] KVM: TDX: Enable mmio spte caching always
 for TDX
Thread-Index: AQHY7ChuBthSf8B20Eq0yiIImvqBi642misA
Date:   Wed, 9 Nov 2022 12:46:11 +0000
Message-ID: <11ccff55a5fbb52d59c36c3dbb88c8d8d937b60e.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <820bac8ce45b92d643630084096dcd7e71038a58.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <820bac8ce45b92d643630084096dcd7e71038a58.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6711:EE_
x-ms-office365-filtering-correlation-id: bbe72ed4-023b-4499-22ef-08dac2506161
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U4DX5TXIOunzAHARrVfw46D2ECNPCduoIo7DqdY874FHBNeiCup/dYAwoXUfUQSm/65elLkwbaLJkNrB/q3pO6440f5GsBYb6EEUvD/jNwv0OubUwgz8fw9CPqIjP2dZUIPPyneqw1Lj/zhBWmPlBS7vy4RsIwreDrtNrrOvas0FxOao20X2PwvchgxID3z+rmCI6DvfVW6CfvfnfEMxkEEY4qL0V8j71RwBncm6xvLpJqOMtRNIPzMgIsIS3tDvA4FWEarrd16XlcmYOeb6q5y7Fp12hQAwYq4T4arcglEwKAX04wECb9IxUwUDqsXDQHxtHnIvTH7duM179PP3md04J8LO/U4Talyvt/sg9TJtiQaL3Uj4Mb96TOQKCov/74tn2u9ed7Wt+I/GTUSa/Yk0hrW2jGOvwS1hMsmLbq8JXDnQPNPhgpQhlf0fLMGnNH4U/ZYVldCOaS2uV1QYinLCt2z2wMJtck7tgO8LZXYp8KM0IbIFfeaQwUNMcgA7TGrx4rTaz8rp6nvfOpeqgjQviXtA3Kcdz84kbq4/0SeiYlo9irgwzTaKwmy5GPGupM5cx3xL5UD4m8BQK+QERZGLTPePitHP6x1bq+C/WApF77QH9MKnY5167Jh2oSTguzNb50O2x0ghIKnhg6IlqeqrYfHaZpUiSPSpLHR3sekfd6+9sl1V/7tpoYQFC8LPUXZxaIVplI/RPcOhS23ISSjlm+abNzbmH8ZZRpHxbpwoN52oDUImRxMi9t/ntn/at/8RvSr9E4bPB6C72lHF85LbhTzwlwodWXUkLbpRs+g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(36756003)(38070700005)(86362001)(82960400001)(26005)(5660300002)(2906002)(4001150100001)(6506007)(186003)(38100700002)(6512007)(83380400001)(122000001)(2616005)(76116006)(66946007)(6636002)(64756008)(66556008)(478600001)(966005)(66446008)(8936002)(91956017)(66476007)(54906003)(110136005)(316002)(8676002)(4326008)(71200400001)(6486002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2JxZUlSeXFqbkh4cC83d1ZuSkp2QnJvKyttRG1RK2pVdzlIeVBTc0xqbDBx?=
 =?utf-8?B?amEzdUJGbktXcjZKaExkUDRnWVlQMWpFR2Nkam0yNkl6ejNPRzIvSFpWcU93?=
 =?utf-8?B?ZVVsOEYvOG1zMnhhcWNDZzFmZndrd3F5WUxOUVZsenVqN1c4b29hbGlZT0NM?=
 =?utf-8?B?dmRYTHQxMjc0S25tWW5YUktiK1ZLRWUxMkRMWUtCd2QxUkE5eisycmRyUFRW?=
 =?utf-8?B?ZGFMK3pyTnpyYnBpZHpNVkd3c2FsSUNUajV0eVhCT01NMVJZdExVRG4wbVlQ?=
 =?utf-8?B?SDZSTlkzYWVWYU9xSC94NHVWcHBqM3NHeDdZTkQybm1DcjhndXoyMi96K09D?=
 =?utf-8?B?SjBONnY3OTNnZVJaOVh3Q1Z5bEJ0YmxKRjd5S1RGdk44dk5mTEpkZXlLY2R1?=
 =?utf-8?B?WmhVTUVNYWNCQzlPSXlGalBvT09Kb2pJaXRiQW1PeDdpSDk2NWszNzhEbVQz?=
 =?utf-8?B?R2kvQnJvWW02MzJFeXNlMmpSSWVrOG5qVkJDN0ZUM0JFekJvZEE3cXBYWjVo?=
 =?utf-8?B?UDQxL3JGaWJUNTJpTTFENnBSZExrZVd4RHNYa1U0SEZmaHRFVHY1NEh4SUkw?=
 =?utf-8?B?ZzFWQklySDVRb05WMDdMUU9IK1hSR2pDOHdCdXlheGVYc2JOc2w0bFRZcUxN?=
 =?utf-8?B?Y2lFNU1IMWN0amlmTzd6NmtpVlpZWUpISTdtcTlWWGg4NVFaeUQyN1I1c0VK?=
 =?utf-8?B?WUNZK3ozMitCM3E4ZkxiL1l3UlptZHg4YnQxZmpDYURDMlpJVjRYcXBPUkFs?=
 =?utf-8?B?RmRXVjZGV3RNQVIwMW15Sk1PMWVzMndJYXdJMHJoSGhQU2pXR25LZ1FoQWZ6?=
 =?utf-8?B?blkzUklsTVpjNWxQZHZWc1hvUWdiK0Y2b2dFS09rVzZKZ3ZzL01TYTh0cVRS?=
 =?utf-8?B?bFd1dzErRWhyemxYL2Zla2ZkazFjZzB4VHdXSmJtUngxTWw3WkNKMUlJNkdO?=
 =?utf-8?B?NVRsb2o2emdlWUtzQVF0ajB3dXhPd2t6WGQ1dk5QekYrZ1lVdnowN3FaMjJa?=
 =?utf-8?B?d2Z1NU9jQ1c4ci9XUnN0SkExTFRYaXF1ckVVK1NiMjkzdEpkSWhvODhJY21k?=
 =?utf-8?B?RkhHT0diSW5zVWxXUkZaQlJxUXp3cW51Vkc1THdWQVRPOG84STN6WlJaMURT?=
 =?utf-8?B?L05MSkxpY1FuTlB6QUd4ZkVrT2ZQNXcrMG5zd2Z4VmJIZWRwbHdlZVB2aUJE?=
 =?utf-8?B?ak1vVW9vZXVVTERPNWtmVExDSHlZcG82dndQU2w2Y0dFYm5ldUgrcHBSRUtr?=
 =?utf-8?B?TUN2aTNVL0YyVGVpUStSS2F6czk0eTZ1NDY3djNuVjlmRG1lM1hBd1l2dSs3?=
 =?utf-8?B?aTFNQmppUHRTZlhRNlFyeXBhajRldVhrQ1pzRmluL015TzRsQkFDZHdic1p1?=
 =?utf-8?B?aEU5QmFOdlYvdElGODJ0RHBHc3JkM2EvVDR4SnR6L3pHdTFyNUtpV1g2TFll?=
 =?utf-8?B?RVF3VzEySzRWVHBpTjhHWmFiU0lkTDQ3ekY1L1BqVEJUUVRxOUQvODZIZWNi?=
 =?utf-8?B?ZTdGS1BEQUdmOHNtUU83NHdJMHVCakhZOVAzVjBRYitrOGRhMi8za2VvVnlu?=
 =?utf-8?B?UHNueVc2WldRTnZvS0RMMHRJb2FGb2dPTVJIT1lrTmw2RXM2bTdzUHA0bGd0?=
 =?utf-8?B?cWhLL1Q1WDdOUUtJRTI3b2ZaTEFxOE9HQS9GMW1zY2ZkRDhUNkdzWmt1bTRu?=
 =?utf-8?B?WDRDemVDNS9vT3dOUG84a2JZTlM1NnFUSTBwYVdocHU4QmlSUnVtUENWdDZD?=
 =?utf-8?B?Q2syWnVWVXVzVlYrRzZFR0xzZXhMYU9yM3lNZ0RrUVM3RzlSK1g3Mm5VbnFl?=
 =?utf-8?B?TTV6S3ZhU0d1TmNrUFNsOXJGT3BNTG5OWEs4QjQwRkJGK3ZLSk1IdnFSRGhP?=
 =?utf-8?B?KzBERWhBZlhGYmtmM25wMHpkekhmR0hPRjJQT2JUdWFnZ2dneHFtTlEzOXp3?=
 =?utf-8?B?Z25vRFYrUUVqVmVlMSs3NXRJbCtGdVV1RU1BVlJSTGNlMmdxT29zRTlac0ky?=
 =?utf-8?B?ODR2R1M5eHVTQUxhZXM1Ym9sWWd0QTRuRlZHMmFlbHcyM2g2WURyeG1oY0tZ?=
 =?utf-8?B?MmVmWTR6OG5uZllkdUdQN0hXaVo3TWJFQmdZZFZPMzdPeGdjMnN5ckM3ZzRt?=
 =?utf-8?B?WkhhZVFEQS8rNGI4Y3FjelBvNGFTM1Y0Y0dJNGl1VkpyeTJaMGtEdENvSE5F?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EBBDA4D5735D441881835A7B2A5C36E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe72ed4-023b-4499-22ef-08dac2506161
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 12:46:11.2649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wqrW292xw/9L/SNBE/eAPXgduWl1CDtzVq0H6sp3TC+qymeFuSdN2yfFI3toafVTLeuY/2086MYrAYCcDTcUBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6711
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

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggbmVlZHMgdG8gc2V0IHNoYXJlZCBzcHRlIGZvciBNTUlPIEdGTiB0byAh
U1VQUFJFU19WRV9CSVQgfCAhUldYIHNvIHRoYXQNCj4gZ3Vlc3QgVEQgY2FuIGdldCAjVkUgYW5k
IHRoZW4gaXNzdWUgVERHLlZQLlZNQ0FMTDxNTUlPPi4gIEVuYWJsZSBtbWlvDQo+IGNhY2hpbmcg
YWx3YXlzIGZvciBURFggaXJyZWxldmFudCB0aGUgbW9kdWxlIHBhcmFtZXRlciBlbmFibGVfbW1p
b19jYWNoaW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1Lnlh
bWFoYXRhQGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jICAgICB8
IDMgKystDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3NwdGUuaCAgICB8IDIgKy0NCj4gIGFyY2gveDg2
L2t2bS9tbXUvdGRwX21tdS5jIHwgNyArKysrKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDEwIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gaW5kZXggMGQzZmEyOWNj
Y2NjLi45MDk4Zjc3Y2RhYTQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMN
Cj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtMzIyOSw3ICszMjI5LDggQEAg
c3RhdGljIGludCBoYW5kbGVfYWJub3JtYWxfcGZuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3Ry
dWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXUNCj4gIAkJICogYW5kIG9ubHkgaWYgTDEncyBNQVhQSFlB
RERSIGlzIGluYWNjdXJhdGUgd2l0aCByZXNwZWN0IHRvDQo+ICAJCSAqIHRoZSBoYXJkd2FyZSdz
KS4NCj4gIAkJICovDQo+IC0JCWlmICh1bmxpa2VseSghZW5hYmxlX21taW9fY2FjaGluZykgfHwN
Cj4gKwkJaWYgKHVubGlrZWx5KCFlbmFibGVfbW1pb19jYWNoaW5nICYmDQo+ICsJCQkgICAgICFr
dm1fZ2ZuX3NoYXJlZF9tYXNrKHZjcHUtPmt2bSkpIHx8DQo+ICAJCSAgICB1bmxpa2VseShmYXVs
dC0+Z2ZuID4ga3ZtX21tdV9tYXhfZ2ZuKCkpKQ0KPiAgCQkJcmV0dXJuIFJFVF9QRl9FTVVMQVRF
Ow0KPiAgCX0NCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oIGIvYXJjaC94
ODYva3ZtL21tdS9zcHRlLmgNCj4gaW5kZXggODJmMGQ1YzA4Yjc3Li5mZWNmZGNiNWYzMjEgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS9tbXUvc3B0ZS5oDQo+IEBAIC0yNDQsNyArMjQ0LDcgQEAgZXh0ZXJuIHU2NCBfX3JlYWRfbW9z
dGx5IHNoYWRvd19ub25wcmVzZW50X29yX3JzdmRfbG93ZXJfZ2ZuX21hc2s7DQo+ICBzdGF0aWMg
aW5saW5lIGJvb2wgaXNfbW1pb19zcHRlKHN0cnVjdCBrdm0gKmt2bSwgdTY0IHNwdGUpDQo+ICB7
DQo+ICAJcmV0dXJuIChzcHRlICYgc2hhZG93X21taW9fbWFzaykgPT0ga3ZtLT5hcmNoLnNoYWRv
d19tbWlvX3ZhbHVlICYmDQo+IC0JICAgICAgIGxpa2VseShlbmFibGVfbW1pb19jYWNoaW5nKTsN
Cj4gKwkgICAgICAgbGlrZWx5KGVuYWJsZV9tbWlvX2NhY2hpbmcgfHwga3ZtX2dmbl9zaGFyZWRf
bWFzayhrdm0pKTsNCj4gIH0NCg0KDQpTZWFuIHN1Z2dlc3RlZCB3ZSBjYW4gY2hhbmdlIHRvIHRy
ZWF0ICJtbWlvX3ZhbHVlID09IDAiIGFsc28gYXMgTU1JTyBjYWNoaW5nDQpiZWluZyBlbmFibGVk
Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzI0NGY2MTlhNGU3YTFjNzA3OTgzMGQx
MjM3OTg3MmExMTFkYTQxOGQuY2FtZWxAaW50ZWwuY29tLw0KIA0KDQo+ICANCj4gIHN0YXRpYyBp
bmxpbmUgYm9vbCBpc19zaGFkb3dfcHJlc2VudF9wdGUodTY0IHB0ZSkNCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMN
Cj4gaW5kZXggZTA3ZjE0MzUxZDE0Li4zMzI1NjMzYjFjYjUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
eDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5j
DQo+IEBAIC0xODc1LDYgKzE4NzUsMTMgQEAgaW50IGt2bV90ZHBfbW11X2dldF93YWxrKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgdTY0IGFkZHIsIHU2NCAqc3B0ZXMsDQo+ICANCj4gIAkqcm9vdF9s
ZXZlbCA9IHZjcHUtPmFyY2gubW11LT5yb290X3JvbGUubGV2ZWw7DQo+ICANCj4gKwkvKg0KPiAr
CSAqIG1taW8gcGFnZSBmYXVsdCBpc24ndCBzdXBwb3J0ZWQgZm9yIHByb3RlY3RlZCBndWVzdCBi
ZWNhdXNlDQo+ICsJICogaW5zdHJ1Y3Rpb25zIGluIHByb3RlY3RlZCBndWVzdCBtZW1vcnkgY2Fu
J3QgYmUgcGFyc2VkIGJ5IFZNTS4NCj4gKwkgKi8NCj4gKwlpZiAoV0FSTl9PTl9PTkNFKGt2bV9n
Zm5fc2hhcmVkX21hc2sodmNwdS0+a3ZtKSkpDQo+ICsJCXJldHVybiBsZWFmOw0KPiArDQoNCkl0
J3Mgd2VpcmQgdG8gcHV0IHRoaXMgaGVyZS4NCg0KSSB0aGluayB0aGUgbG9naWMgaXMsIGZvciBU
RFggZ3Vlc3QgKG9yIHNpbWlsYXIgcHJvdGVjdGVkIGd1ZXN0cyksDQpoYW5kbGVfbW1pb19wYWdl
X2ZhdWx0KCkgc2hvdWxkIG5vdCBiZSByZWFjaGVkIGF0IGFsbC4gIFNvIEkgdGhpbmsgd2UgY2Fu
IGp1c3QNCmFkZCBhIFdBUk4oKSBhZ2FpbnN0IGt2bV9nZm5fc2hhcmVkX21hc2soKSwgb3IgaXNf
dGR4X3ZtKCkgYXQgdGhlIHZlcnkgYmVnaW5uaW5nDQpvZiBoYW5kbGVfbW1pb19wYWdlX2ZhdWx0
KCk/DQoNCj4gIAl0ZHBfbW11X2Zvcl9lYWNoX3B0ZShpdGVyLCBtbXUsIGdmbiwgZ2ZuICsgMSkg
ew0KPiAgCQlsZWFmID0gaXRlci5sZXZlbDsNCj4gIAkJc3B0ZXNbbGVhZl0gPSBpdGVyLm9sZF9z
cHRlOw0KDQo=
