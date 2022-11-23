Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCEA635CB3
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 13:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbiKWMW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 07:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbiKWMWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 07:22:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8DC43AFF;
        Wed, 23 Nov 2022 04:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669206129; x=1700742129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4lrbxiLCZooap6gQIAq64oqgKH+lNMh2myShX3KEjQ8=;
  b=nWcspZCdR//4BiE3NCdDVJ0jsTn2N4bdIuT5av7GHVAtz9IvVoESZ9MZ
   09I8nJYtBxOVW9TLW09PGd+ByHwMITtwAThDF8qOrcXwRJWq6IWr8AQGA
   SXUsz+vnOXewZx+BegTpTO8xMlVGrnQAtX0JrDquSRvDjdz1DsAmGIIeB
   96c52omP/OqMedeMvZUXTBTfnXE1aICiH/P1b6Oxaa9VDtP0eTppCrV5J
   qZMHfKQ+Ks3pEbDo9v+1Ai24GJoAIXlcO+HU3x8XhOFJLMhw4G/2wbxVD
   LL6wxeQ5czzBvvnEyMNP4Pw0DHmDMM5uT+G+ilut/3Sr2Jfaooi7WUbPf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="311684628"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="311684628"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 04:22:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="672860753"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="672860753"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 23 Nov 2022 04:22:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 04:22:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 04:22:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 04:22:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeeaxrxD4l90D+AkpccAgTVsrhyGlGdp97o+tqfYsm26fzT01GGt0+QfP0DzATYxlucB5VjnHWF2pQ9/o7kedhF8zxGDy7dLPLmNBx+ZqZVcud6ClUXmEUL5A6y1kna830N8ETie3NNuFxPWQtp6jBZS6UyMa1beJwKKnaaWpFXhLvkMMyM0uo7vhC9VTVYGDFS2xB9jnINiD3OZWkBNIdId1JBjCu825GFwRZn/6taty3WuYqPO6OdU6Jcp1UzczPUzEg1y4KjwtSSyfMKAlKh71AzjsqjUBxfQi236yjBkcXNJghHFFWi3ewxUkuXmQfHBcx5nd09IOaPHMglZbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lrbxiLCZooap6gQIAq64oqgKH+lNMh2myShX3KEjQ8=;
 b=K4745SPEXAIOdMgYnQgO3zH3MGnEKjF0IBtiVfy7ylVx9+HrEzh9GKWu/0guCX3va1qa/kjFCYxLg4UlOAkiEJEfMbSub7tOnF9JpV6VHNjTmWylCj5GFzliAFk3TahzL9qPd4pS3TO94m9gBu1FQdWacKmyKuteOCuuN1EIctGPpME9I6NMjEQNBEKcuDJJz61B3enwqrkdvDMafw3mn8zDIW1CbcCBQbQtGMpYedkU8U1/WxYyOM4U6/ATi6qExqvWUbh4Z0KS+FeqcCIEYsFuVR00wLOtFN+B0ygKChr7SwSaSJI6ZdpO8Z0kBbqvQTeSyrEwbXznIG72AwPzcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6775.namprd11.prod.outlook.com (2603:10b6:806:264::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Wed, 23 Nov
 2022 12:22:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 12:22:02 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Topic: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Index: AQHY/T29USV2IuUHCEyPQthCEbaZH65Kp9QAgAAYugCAAFUUgIAASuaAgABKsYCAALEsAIAAFX4A
Date:   Wed, 23 Nov 2022 12:22:02 +0000
Message-ID: <d7de815709ec96fc3240496c4ba90e07bc72d059.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
         <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net> <87edtvgu1l.ffs@tglx>
         <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com> <87mt8ig3ja.ffs@tglx>
         <246a4eaac29855c522bd26627b03418cb7ead66f.camel@intel.com>
         <87bkoyexsv.ffs@tglx>
In-Reply-To: <87bkoyexsv.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6775:EE_
x-ms-office365-filtering-correlation-id: 7bb248ac-7c72-473c-33b8-08dacd4d53bc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xhkVeEXdzUHyjTAWtECK+bJK2uub2PnMfw99ZHkYwmJvkZGS9KehJUBh+SntABHCQDR9Neqp/g0P2fK1I/cusoCjSjvmw/bpmRVMOiz68XA3bb3VN2BTQ9QiDBUiTyYgKuhg8Wm95EODXYdcNI0mRvfr0ES34e92uTykSghNow0n35zZunByjyfqIwZuHo9hHB2I/lIi24ZI6HJ+DAgDwF2MocWbRWuwIhLz4KmstyUCdeJfrSAhU3k+WEWdrLtC5WmT48h+agrdefonJx0HQyMuaK29LDAIF8OtByXLjVafcYV9k8mLr3qViSgBDy8VidZcE5GqYMVEFwXZ3J8BZDwqbtG5o45GYNuWPJ0limpiP36GDhrnJNkFtSQPdyYv003u6rmTRA1KR5s6D6UnWtsbrruD0Fj2wgW+EkJ7rGWgah4DH/5VM8ljvgLOKsb4Xpu7UqaiWlB1dTCIgVfPVmxZGys/Jts5PvY7nukD11ZRC9TNMEE3rc5sgP//me+j369w5ccJs3ORK/5KkPVch/LEXMGDf5QukGNvZGlLoOmi2YDASlP7yjsqvy7NmGR1AT5+M59Sdvu0dqXf6XJHD8bX5051AxyRM9ppfK+FrgE4hYMX/85fXdsgGu0FDKBeVCKucRFv1KCjZ9+1Bpm8Z4MCVflF2B1K4Sd4stHSO22bmxHqcvDGVQmEcr/RUmlM3yYabRdSbZDSdn2APL2Nfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(91956017)(66946007)(478600001)(7416002)(5660300002)(66446008)(83380400001)(66556008)(2616005)(110136005)(26005)(8676002)(6512007)(64756008)(66476007)(54906003)(6636002)(4326008)(6506007)(316002)(8936002)(38070700005)(41300700001)(186003)(122000001)(36756003)(76116006)(38100700002)(82960400001)(2906002)(4001150100001)(86362001)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vm5QWlpYYk9tNzFBbm1aeWM3MWZnOElKNzRoMlNENVkzT3g5Tjk5NmlGTjF4?=
 =?utf-8?B?M2gzbkVHOENaZ0RqU1pZM3VnMXE2dXdtQWhZelk2SEp2WTdQZ3R6eExWUXNo?=
 =?utf-8?B?VE9uUGg3Qk5WWVEzVnNWM3loSzdSWmM3K3A1Z2RLTEYzTzhXQXNoK1RNWVZG?=
 =?utf-8?B?dWtuV0RqclE0a0ZHQlVLUTIvdk9sNVZhREZJRVc3emc5L2NVakZ0eFU4YXdI?=
 =?utf-8?B?MVRNUmVDV1V1enptNU5leWxvaGFSKzRVTW1nSk83RW1ZZ2t3L2FnL2Rjb2NG?=
 =?utf-8?B?SWtDbUJDYkhvdmtuTyt1Y1FZMUR3Q0YrUWRqZFFZcTFUSjhWQ0orVmxwVDlN?=
 =?utf-8?B?ZGNtMDl6UmRkSG9WNGI0VC9uemViRGNBWlIyczRYSTdNamQxRUhaYkhKTk9Z?=
 =?utf-8?B?WHBRYmc4UTE4ZGRUdEUzNEtJSm5Ib3lGK2x2S2tyZ0FhL1FSSWZlMWw2Vis4?=
 =?utf-8?B?ZittSTJPZ0QxUjFBbkZ6cjUzQzA3REswbFAvajVzL3JmdmRoM3lkZ0Y3TW9H?=
 =?utf-8?B?eVpHMld2SVVVbGk2a1lwVVdjSFBRcUFXbW1ad1NjQkQrTWlobmdtQjlkY0dq?=
 =?utf-8?B?TjhlQWtwVlFOMjQzM0NqVVNFSFFaKy9scXNOUWtwTHF0MkhUUXhMaGlKQ2dC?=
 =?utf-8?B?Z0NyZ2FiSUY4dTlVVjJKaDJDT3ZXcDM3NjRhUFl6VzIzUWFSS2JvWGkvUDBa?=
 =?utf-8?B?alNoZTR0eVBJQ2xvZjMxVGxKVnc1a0RxUDJTb1dvVzhWUWw0blEvVnh4U2N1?=
 =?utf-8?B?OXpRVlBUWGo2L09UUTNUMVlVUURsQkRIcGNVQWduUmlNUURjUVptdzB2Q0pl?=
 =?utf-8?B?QVBPaHIxYUNibmZ3QTBHL3ZxbGtYUis0ODVSSTc5dGxtNFJwcTBVMFlzZ0Jt?=
 =?utf-8?B?SjJVUUdvb3VGZmtCRUx0MGVIc2xYVm50R2hPSTBIUks0ZEhiOUcvT1RqY2Ju?=
 =?utf-8?B?VmU4a3RCQjhrSjBhSks1VEJ4YnVIRjc0d0RwTThhV3dmSkVVcW9IaHRKYk10?=
 =?utf-8?B?TXVRZGNQMlhETGR2OU10TFh5SGZvSU9DMy9iNXhIdlZ6WTZ0ZlNFaCtnSkVu?=
 =?utf-8?B?SWE4SE9VNUtGblZWaFdjalkzbm50V2dlSmwxd2ZnQmxxcDJIcThHbGhDVWk4?=
 =?utf-8?B?bm1sc0cxUEJJVjkyRDRYTnZ5MW9UTWdPdEFzWXBkMmFTcHBiVGhVaVlrWFQv?=
 =?utf-8?B?dGZDOTZoYXZnaGl0UnFDZmFMQ1hBWGNHWFQ2ZFJzK1N1aXZsa3AvQUE0bmhj?=
 =?utf-8?B?QXVYRm85UzRSTTcxeVFhZUtPcC9PZ3lQSkpCRU5DYjRvcVNZSFk2aUtXSGZU?=
 =?utf-8?B?SDdjT3N3S0JRRjFQOGtiVXY3NGZoOTdUaVRtaDFIRnJDT3hQNlF0eG5XbDlR?=
 =?utf-8?B?VkRaTUxSU1ptbms3eDBpUXErV05lSFM4eHhSSXUyUTIyc1NMZGlMZURGWjdI?=
 =?utf-8?B?OFBmam84ZW51RDRBRTk3SHNFRHh6UXJRN0cvMS9qbEpTMlNxUkZWNjlRTmRC?=
 =?utf-8?B?TXNjd2x6UXNpUkIvOG1KOWdLaVlrODJ5d0VtaFpaTTIwRWF3KyttbjdmR3d4?=
 =?utf-8?B?ZHJNUjhIYTFSL3U1WEdzcEpNb0c3RzJHWXZXODJrRHA1S3NJVWxsYmZKODZ1?=
 =?utf-8?B?QS9UR0tjSG1yMWFnMy8yNUxTR0R2UjJFSHV2WXNRL3Nid2dlMXNjdHZqR2R2?=
 =?utf-8?B?N2JZR0hNUU9DSmdrUTRrQjlxNUVjM25UOCsxMHNzNHJPRlpScXBtVTNlWWNZ?=
 =?utf-8?B?dmd4VkI2M2tjbUJOU0ZDdGxKdFRlSVlWU2JoanBPeG5MOGlHdVBpb2t4S1kx?=
 =?utf-8?B?WUQ4bTFWVmVhSUIrNkxzQkpzUHYyVDdnTllkdkhYMzNKNFdpZkZ6ank5Vzdh?=
 =?utf-8?B?WG5SaHVRRXc3VXJ0MDNxM2NjR3FTQXVrc2EraUZ2NlhOZ0kzdVBMY2hPMjNz?=
 =?utf-8?B?QkxjUkVkeGdyenBDMHdlTVY5WmNZaTFFcjY5RGdGT2RaWXVhdDV2dUc5SUlv?=
 =?utf-8?B?R3RkSlhOeXRRMFBDZjBySWlNVzNFcnVTWjErM3hkT3g5RXozTlA0c2lzdjd3?=
 =?utf-8?B?QVN5UnFmRGM0VGkzRzZPTmxIcjlOaFVEUlQ3ZHJJakxKUTJkNFhEK25YTUkw?=
 =?utf-8?B?Q09LQzNNWmZNREl6bUx0bk9rZHpDZlVkSENXK1M1QzFhOTU0a21kYmtSV09O?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6E6E4F0A10E1A46B944F0D2A8472F53@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb248ac-7c72-473c-33b8-08dacd4d53bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 12:22:02.7209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Noes03pRVvjQ2xAWQfIqTDzAalfJ8VrJrUVUzj8uqKmkDuvgAlRtoOdtPYxehha4ZJzFTbet0RPvivFUIfwOUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6775
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDEyOjA1ICswMTAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
DQo+IEthaSENCj4gDQo+IE9uIFdlZCwgTm92IDIzIDIwMjIgYXQgMDA6MzAsIEthaSBIdWFuZyB3
cm90ZToNCj4gPiBPbiBUdWUsIDIwMjItMTEtMjIgYXQgMjE6MDMgKzAxMDAsIFRob21hcyBHbGVp
eG5lciB3cm90ZToNCj4gPiA+IENsZWFybHkgdGhhdCdzIG5vd2hlcmUgc3BlbGxlZCBvdXQgaW4g
dGhlIGRvY3VtZW50YXRpb24sIGJ1dCBJIGRvbid0DQo+ID4gPiBidXkgdGhlICdhcmNoaXRlY3R1
cmFseSByZXF1aXJlZCcgYXJndW1lbnQgbm90IGF0IGFsbC4gSXQncyBhbg0KPiA+ID4gaW1wbGVt
ZW50YXRpb24gZGV0YWlsIG9mIHRoZSBURFggbW9kdWxlLg0KPiA+IA0KPiA+IEkgYWdyZWUgb24g
aGFyZHdhcmUgbGV2ZWwgdGhlcmUgc2hvdWxkbid0IGJlIHN1Y2ggcmVxdWlyZW1lbnQgKG5vdCAx
MDAlIHN1cmUNCj4gPiB0aG91Z2gpLCBidXQgSSBndWVzcyBmcm9tIGtlcm5lbCdzIHBlcnNwZWN0
aXZlLCAidGhlIGltcGxlbWVudGF0aW9uIGRldGFpbCBvZg0KPiA+IHRoZSBURFggbW9kdWxlIiBp
cyBzb3J0IG9mICJhcmNoaXRlY3R1cmFsIHJlcXVpcmVtZW50Ig0KPiANCj4gU3VyZSwgYnV0IHRo
ZW4gaXQgbmVlZHMgdG8gYmUgY2xlYXJseSBkb2N1bWVudGVkIHNvLg0KPiANCj4gPiAtLSBhdCBs
ZWFzdCBJbnRlbCBhcmNoIGd1eXMgdGhpbmsgc28gSSBndWVzcy4NCj4gDQo+IEludGVsICJhcmNo
IiBndXlzPyBZb3UgbWlnaHQgbG9vayB1cCB0aGUgbWVhbmluZ3Mgb2YgImFyY2giIGluIGENCj4g
ZGljdGlvbmFyeS4gTEtNTCBpcyBub3QgdHdhdHRlci4NCj4gDQo+ID4gPiBUZWNobmljYWxseSB0
aGVyZSBpcyBJTU8gWkVSTyByZXF1aXJlbWVudCB0byBkbyBzby4NCj4gPiA+IA0KPiA+ID4gwqAx
KSBUaGUgVERYIG1vZHVsZSBpcyBnbG9iYWwNCj4gPiA+IA0KPiA+ID4gwqAyKSBTZWFtLXJvb3Qg
YW5kIFNlYW0tbm9uLXJvb3Qgb3BlcmF0aW9uIGFyZSBzdHJpY3RseSBhIExQIHByb3BlcnR5Lg0K
PiA+ID4gDQo+ID4gPiDCoMKgwqAgVGhlIG9ubHkgYXJjaGl0ZWN0dXJhbCBwcmVyZXF1aXNpdGUg
Zm9yIHVzaW5nIFNlYW0gb24gYSBMUCBpcyB0aGF0DQo+ID4gPiDCoMKgwqAgb2J2aW91c2x5IHRo
ZSBlbmNyeXB0aW9uL2RlY3J5cHRpb24gbWVjaGFuaWNzIGhhdmUgYmVlbiBpbml0aWFsaXplZA0K
PiA+ID4gwqDCoMKgIG9uIHRoZSBwYWNrYWdlIHRvIHdoaWNoIHRoZSBMUCBiZWxvbmdzLg0KPiA+
ID4gDQo+ID4gPiBJIGNhbiBzZWUgd2h5IGl0IG1pZ2h0IGJlIGNvbXBsaWNhdGVkIHRvIGFkZC9y
ZW1vdmUgYW4gTFAgYWZ0ZXINCj4gPiA+IGluaXRpYWxpemF0aW9uIGZhY3QsIGJ1dCB0ZWNobmlj
YWxseSBpdCBzaG91bGQgYmUgcG9zc2libGUuDQo+ID4gDQo+ID4gImtlcm5lbCBzb2Z0IG9mZmxp
bmUiIGFjdHVhbGx5IGlzbid0IGFuIGlzc3VlLiAgV2UgY2FuIGJyaW5nIGRvd24gYSBsb2dpY2Fs
IGNwdQ0KPiA+IGFmdGVyIGl0IGdldHMgaW5pdGlhbGl6ZWQgYW5kIHRoZW4gYnJpbmcgaXQgdXAg
YWdhaW4uDQo+IA0KPiBUaGF0J3MgdGhlIHdob2xlIHBvaW50IHdoZXJlIHRoaXMgZGlzY3Vzc2lv
biBzdGFydGVkOiBfQUZURVJfIGl0IGdldHMNCj4gaW5pdGlhbGl6ZWQuDQo+IA0KPiBXaGljaCBt
ZWFucyB0aGF0LCBlLmcuIGFkZGluZyAibm9zbXQiIHRvIHRoZSBrZXJuZWwgY29tbWFuZCBsaW5l
IHdpbGwNCj4gbWFrZSBURFggZmFpbCBoYXJkIGJlY2F1c2UgYXQgdGhlIHBvaW50IHdoZXJlIFRE
WCBpcyBpbml0aWFsaXplZCB0aGUNCj4gaHlwZXJ0aHJlYWRzIGFyZSBub3QgJ3NvZnQnIG9ubGlu
ZSBhbmQgY2Fubm90IHJlc3BvbmQgdG8gYW55dGhpbmcsIGJ1dA0KPiB0aGUgQklPUyBhbHJlYWR5
IGFjY291bnRlZCB0aGVtLg0KPiANCj4gVGhpcyBpcyBqdXN0IHdyb25nIGFzIHdlIGFsbCBrbm93
IHRoYXQgIm5vc210IiBpcyBzYWRseSBvbmUgb2YgdGhlDQo+IG9idmlvdXMgY291bnRlciBtZWFz
dXJlcyBmb3IgdGhlIG5ldmVyIGVuZGluZyBmbG9vZCBvZiBzcGVjdWxhdGlvbg0KPiBpc3N1ZXMu
DQoNCkFncmVlLiAgQXMgc2FpZCBpbiBteSBvdGhlciByZXBsaWVzLCBJJ2xsIGZvbGxvdyB1cCB3
aXRoIFREWCBtb2R1bGUgZ3V5cyBvbg0KdGhpcy4NCg0KPiANCj4gPiBPbmx5IGFkZC9yZW1vdmFs
IG9mIHBoeXNpY2FsIGNwdSB3aWxsIGNhdXNlIHByb2JsZW06wqANCj4gDQo+IFlvdSB3aXNoLiAN
Cj4gDQo+ID4gVERYIE1DSEVDSyB2ZXJpZmllcyBhbGwgYm9vdC10aW1lIHByZXNlbnQgY3B1cyB0
byBtYWtlIHN1cmUgdGhleSBhcmUgVERYLQ0KPiA+IGNvbXBhdGlibGUgYmVmb3JlIGl0IGVuYWJs
ZXMgVERYIGluIGhhcmR3YXJlLiAgTUNIRUNLIGNhbm5vdCBydW4gb24gaG90LWFkZGVkDQo+ID4g
Q1BVLCBzbyBURFggY2Fubm90IHN1cHBvcnQgcGh5c2ljYWwgQ1BVIGhvdHBsdWcuDQo+IA0KPiBU
RFggY2FuIHJpZ2h0ZnVsbHkgaW1wb3NlIHRoZSBsaW1pdGF0aW9uIHRoYXQgaXQgb25seSBleGVj
dXRlcyBvbiBDUFVzLA0KPiB3aGljaCBhcmUga25vd24gYXQgYm9vdC9pbml0aWFsaXphdGlvbiB0
aW1lLCBhbmQgb25seSB1dGlsaXplcyAia25vd24iDQo+IG1lbW9yeS4gVGhhdCdzIGl0LCBidXQg
dGhhdCBkb2VzIG5vdCBlbmZvcmNlIHRvIHByZXZlbnQgcGh5c2ljYWwgaG90cGx1Zw0KPiBpbiBn
ZW5lcmFsLg0KDQpBZGRpbmcgcGh5c2ljYWwgQ1BVcyBzaG91bGQgaGF2ZSBubyBwcm9ibGVtIEkg
Z3Vlc3MsIHRoZXkganVzdCBjYW5ub3QgcnVuIFREWC4gDQpURFggYXJjaGl0ZWN0dXJlIGRvZXNu
J3QgZXhwZWN0IHRoZXkgY2FuIHJ1biBURFggY29kZSBhbnl3YXkuDQoNCkJ1dCB3b3VsZCBwaHlz
aWNhbCByZW1vdmFsIG9mIGJvb3QtdGltZSBwcmVzZW50IENQVSBjYXVzZSBwcm9ibGVtPyBURFgg
TUNIRUNLDQpjaGVja3MvcmVjb3JkcyBib290LXRpbWUgcHJlc2VudCBDUFVzLiAgSWYgYSBDUFUg
aXMgcmVtb3ZlZCBhbmQgdGhlbiBhIG5ldyBvbmUNCmlzIGFkZGVkLCB0aGVuIFREWCBzdGlsbCB0
cmVhdHMgaXQgaXMgVERYLWNvbXBhdGlibGUsIGJ1dCBpdCBtYXkgYWN0dWFsbHkgbm90Lg0KDQpT
byBpZiB0aGlzIGhhcHBlbnMsIGZyb20gZnVuY3Rpb25hbGl0eSdzIHBvaW50IG9mIHZpZXcsIGl0
IGNhbiBicmVhay4gIEkgdGhpbmsNClREWCBzdGlsbCB3YW50cyB0byBndWFyYW50ZWUgVERYIGNv
ZGUgY2FuIHdvcmsgY29ycmVjdGx5IG9uICJURFggcmVjb3JkZWQiIENQVXMuDQoNCkFsc28sIEkg
YW0gbm90IHN1cmUgd2hldGhlciB0aGVyZSdzIGFueSBzZWN1cml0eSBpc3N1ZSBpZiBhIG1hbGlj
aW91cyBrZXJuZWwNCnRyaWVzIHRvIHJ1biBURFggY29kZSBvbiBzdWNoIHJlbW92ZWQtdGhlbi1h
ZGRlZCBDUFUuDQoNClRoaXMgc2VlbXMgYSBURFggYXJjaGl0ZWN0dXJlIHByb2JsZW0gcmF0aGVy
IHRoYW4ga2VybmVsIHBvbGljeSBpc3N1ZS4NCg0KPiANCj4gPiBXZSB0cmllZCB0byBnZXQgaXQg
Y2xhcmlmaWVkIGluIHRoZSBzcGVjaWZpY2F0aW9uLCBhbmQgYmVsb3cgaXMgd2hhdCBURFgvbW9k
dWxlDQo+ID4gYXJjaCBndXlzIGFncmVlZCB0byBwdXQgdG8gdGhlIFREWCBtb2R1bGUgc3BlYyAo
anVzdCBjaGVja2VkIGl0J3Mgbm90IGluIGxhdGVzdA0KPiA+IHB1YmxpYyBzcGVjIHlldCwgYnV0
IHRoZXkgc2FpZCBpdCB3aWxsIGJlIGluIG5leHQgcmVsZWFzZSk6DQo+ID4gDQo+ID4gIg0KPiA+
IDQuMS4zLjIuICBDUFUgQ29uZmlndXJhdGlvbg0KPiA+IA0KPiA+IER1cmluZyBwbGF0Zm9ybSBi
b290LCBNQ0hFQ0sgdmVyaWZpZXMgYWxsIGxvZ2ljYWwgQ1BVcyB0byBlbnN1cmUgdGhleQ0KPiA+
IG1lZXQgVERY4oCZcw0KPiANCj4gVGhhdCBNQ0hFQ0sgZmFsbHMgaW50byB0aGUgY2F0ZWdvcnkg
b2Ygc2VjdXJpdHkgdm9vZG9vLg0KPiANCj4gSXQgbmVlZHMgdG8gdmVyaWZ5IF9BTExfIGxvZ2lj
YWwgQ1BVcyB0byBlbnN1cmUgdGhhdCBJbnRlbCBkaWQgbm90IHB1dA0KPiBkaWZmZXJlbnQgbW9k
ZWxzIGFuZCBzdGVwcGluZ3MgaW50byBhIHBhY2thZ2Ugb3Igd2hhdD8NCg0KSSBhbSBndWVzc2lu
ZyBzby4NCg0KPiANCj4gPiBzZWN1cml0eSBhbmQgY2VydGFpbiBmdW5jdGlvbmFsaXR5IHJlcXVp
cmVtZW50cywgYW5kIE1DSEVDSyBwYXNzZXMgdGhlIGZvbGxvd2luZw0KPiA+IENQVSBjb25maWd1
cmF0aW9uIGluZm9ybWF0aW9uIHRvIHRoZSBOUC1TRUFNTERSLCBQLVNFQU1MRFIgYW5kIHRoZSBU
RFggTW9kdWxlOg0KPiA+IA0KPiA+IMK3ICAgICAgICAgVG90YWwgbnVtYmVyIG9mIGxvZ2ljYWwg
cHJvY2Vzc29ycyBpbiB0aGUgcGxhdGZvcm0uDQo+IA0KPiBZb3Ugc3VyZWx5IG5lZWQgTUNIRUNL
IGZvciB0aGlzDQo+IA0KPiA+IMK3ICAgICAgICAgVG90YWwgbnVtYmVyIG9mIGluc3RhbGxlZCBw
YWNrYWdlcyBpbiB0aGUgcGxhdGZvcm0uDQo+IA0KPiBhbmQgZm9yIHRoaXMuLi4NCj4gDQo+ID4g
wrcgICAgICAgICBBIHRhYmxlIG9mIHBlci1wYWNrYWdlIENQVSBmYW1pbHksIG1vZGVsIGFuZCBz
dGVwcGluZyBldGMuDQo+ID4gaWRlbnRpZmljYXRpb24sIGFzIGVudW1lcmF0ZWQgYnkgQ1BVSUQo
MSkuRUFYLg0KPiA+IFRoZSBhYm92ZSBpbmZvcm1hdGlvbiBpcyBzdGF0aWMgYW5kIGRvZXMgbm90
IGNoYW5nZSBhZnRlciBwbGF0Zm9ybSBib290IGFuZA0KPiA+IE1DSEVDSyBydW4uDQo+ID4gDQo+
ID4gTm90ZTogICAgIFREWCBkb2VzbuKAmXQgc3VwcG9ydCBhZGRpbmcgb3IgcmVtb3ZpbmcgQ1BV
cyBmcm9tIFREWCBzZWN1cml0eQ0KPiA+IHBlcmltZXRlciwgYXMgY2hlY2tlZCBteSBNQ0hFQ0su
DQo+IA0KPiBNb3JlIHNlY3VyaXR5IHZvb2Rvby4gVGhlIFREWCBzZWN1cml0eSBwZXJpbWV0ZXIg
aGFzIG5vdGhpbmcgdG8gZG8gd2l0aA0KPiBhZGRpbmcgb3IgcmVtb3ZpbmcgQ1BVcyBvbiBhIHN5
c3RlbS4gSWYgdGhhdCdkIGJlIHRydWUgdGhlbiBURFggaXMgYQ0KPiBjb21wbGV0ZSBmYWlsLg0K
DQpObyBhcmd1bWVudCBoZXJlLg0KDQo+ID4gQklPUyBzaG91bGQgcHJldmVudCBDUFVzIGZyb20g
YmVpbmcgaG90LWFkZGVkIG9yIGhvdC1yZW1vdmVkIGFmdGVyDQo+ID4gcGxhdGZvcm0gYm9vdHMu
DQo+IA0KPiBJZiB0aGUgQklPUyBkb2VzIG5vdCBwcmV2ZW50IGl0LCB0aGVuIFREWCBhbmQgdGhl
IFNlYW0gbW9kdWxlIHdpbGwgbm90DQo+IGV2ZW4gbm90aWNlIHVubGVzcyB0aGUgT1MgdHJpZXMg
dG8gaW52b2tlIHNlYW1jYWxsKCkgb24gYSBuZXdseSBwbHVnZ2VkDQo+IENQVS4NCj4gDQo+IEEg
bmV3bHkgYWRkZWQgQ1BVIGFuZCBuZXdseSBhZGRlZCBtZW1vcnkgc2hvdWxkIG5vdCBoYXZlIGFu
eSBpbXBhY3Qgb24NCj4gdGhlIFREWCBpbnRlZ3JpdHkgb2YgdGhlIGFscmVhZHkgcnVubmluZyBz
eXN0ZW0uIElmIHRoZXkgaGF2ZSB0aGVuDQo+IGFnYWluLCBURFggaXMgYnJva2VuIGJ5IGRlc2ln
bi4NCg0KTm8gYXJndW1lbnQgaGVyZSBlaXRoZXIuDQoNCj4gDQo+ID4gVGhlIFREWCBtb2R1bGUg
cGVyZm9ybXMgYWRkaXRpb25hbCBjaGVja3Mgb2YgdGhlIENQVeKAmXMgY29uZmlndXJhdGlvbiBh
bmQNCj4gPiBzdXBwb3J0ZWQgZmVhdHVyZXMsIGJ5IHJlYWRpbmcgTVNScyBhbmQgQ1BVSUQgaW5m
b3JtYXRpb24gYXMgZGVzY3JpYmVkIGluIHRoZQ0KPiA+IGZvbGxvd2luZyBzZWN0aW9ucy4NCj4g
DQo+IHRvIGVuc3VyZSB0aGF0IHRoZSBNQ0hFQ0sgZ2VuZXJhdGVkIHRhYmxlIGlzIHN0aWxsIHZh
bGlkIGF0IHRoZSBwb2ludA0KPiB3aGVyZSBURFggaXMgaW5pdGlhbGl6ZWQ/IA0KDQpJIHRoaW5r
IGl0IGlzIHRyeWluZyB0byBzYXk6DQoNCk1DSEVDSyBkb2Vzbid0IGRvIGFsbCB0aGUgdmVyaWZp
Y2F0aW9ucy4gU29tZSB2ZXJmaWNhdGlvbnMgYXJlIGRlZmVycmVkIHRvIHRoZQ0KVERYIG1vZHVs
ZSB0byBjaGVjayB3aGVuIGl0IGdldHMgaW5pdGlhbGl6ZWQuDQoNCj4gDQo+IFRoYXQgc2FpZCwg
dGhpcyBkb2N1bWVudGF0aW9uIGlzIGF0IGxlYXN0IGJldHRlciB0aGFuIHRoZSBleGlzdGluZyB2
b2lkLA0KPiBidXQgdGhhdCBkb2VzIG5vdCBtYWtlIGl0IHRlY2huaWNhbGx5IGNvcnJlY3QuDQo+
IA0KPiBUaGFua3MsDQo+IA0KPiAgICAgICAgIHRnbHgNCg0K
