Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF53624115
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 12:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKJLLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 06:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKJLLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 06:11:07 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB046DCD6;
        Thu, 10 Nov 2022 03:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668078666; x=1699614666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cEA71E4eVq4EFnv0BT1sQ960ToWPZfny/BIL5rkCLa8=;
  b=lUansytsWMQouRQadOL6dsKbAMQHk0PHAX07MmAnVC6wO6OWA1KgLryR
   uTYW7JtVUzWIlonuowEMVS1H5al1v5GYjk2Mnpzsncfj6C/OEf4YJXq+0
   NH7O7sZN6wfOdBvzGJ6ygdBVz7nPGyJoxuSA3qXpEsMOIl4sW9dyMzgl8
   NH6c/4oz/+1rKmkqL5dHDcrz5tk7kxJa6nyP+nqgTHEvpejihBRG1l/jn
   vLE3P2hPXG28euOjh9i4OqIQ75iqrPGqb3b2bMlHH+YTiM4S1u19dRGFn
   yHu8I0Bon+sMn81egr7Pf6yF/13GIw12taoxbI8sCmH4QqdNAnlVMQ6hK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="298780290"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="298780290"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 03:11:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="779736442"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="779736442"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2022 03:11:05 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 03:11:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 03:11:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 03:11:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBCiHGPOh1KV/BFMHZ+zW5Rb0yFqHPvovVwi7myLgw6xMAX8juvYhu0zR5lwoSifoG3w0Tn7RTv8XJKqDRfpX5GUmlk41BkWxu0dkLaOToeiE4mEZ5vgWlbXk7lWNefF4OEwpmgKXnTF2ldj7zH2JJyMcz9JYkV/3xahrJ4oHSody1JhBCU4BDhyw0LqfJvOHCazo2VZkQK3p/0tJwHAUncg8WUHJoTk58ERBdQSLuTAFmE4a1wmbdOVvNKxPmSjsXBU+YksLxxHR9ImRvqll+NYEZ+xi0rSP46sMxd6TyAbGCnqf5MPK+CtZ2XUGyf/ws0tieDImf0p7O2TlEVsaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEA71E4eVq4EFnv0BT1sQ960ToWPZfny/BIL5rkCLa8=;
 b=VsmGeEWl+LknuWT7SOItFU1f3Hydr+qP4PDvfc+Zyjc6j5p7sqMv/+9oSXTYH1nuWWZ0XJSCxEz1QoG7zn/xPTgfoI7dTZJk6AwTnJS23fTMSVxhi6X51zCQfOMB9E4EOBxcfdzKvmXp0yxZH1EfEx3I1vxiHE0j3y3w8RR/1JkMyTzh38GTJGdvl6uIBe/pSzOD3vlsV9MoZ7T7Otcktb/TD7Bkm2ugjkkMQgWt3VRqTGbkLF21HYgjEmdlA+riz1ovyTBtcHA9IcCBEgQkm43ncIF7BIxAiSAPeOlSIb/TR6G1UHIy9Pz/QJjadI0jMuDZ547IPZ2IIYdH5ieBKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6843.namprd11.prod.outlook.com (2603:10b6:930:60::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 11:11:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 11:11:02 +0000
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
Subject: Re: [PATCH v10 014/108] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Thread-Topic: [PATCH v10 014/108] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Thread-Index: AQHY7ChM+pAVHY3eZE+51mfkJ7bDAa44EeqA
Date:   Thu, 10 Nov 2022 11:11:02 +0000
Message-ID: <75e7ddef4cde0a5154bbd6832977f67208ebcb1c.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <75ac959fddbfd057d3ae8ad73e91708a2da60965.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <75ac959fddbfd057d3ae8ad73e91708a2da60965.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB6843:EE_
x-ms-office365-filtering-correlation-id: 810b6d06-e741-4257-82d5-08dac30c4125
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5p+NLBx4w4KVPpct6OaEnBwkEasI8GjNtlnhgUxrzMejr+n1LnZorfgY3tzILs+keBZS/emuvqKUg9RGxLQbCkYWvxS9KsGLQ8DTrR7o5cioHpvz/fAP5jI0Lph+BJ55U6PXZgXVFnIE5Y/RuLtCO6Og0Ycg42h13ITX63d22VooHpsnvoGsy5iU4K0ZMZ49+stYfmz+BgQ8uK6yeXt3Bu6k5NcPOCkI2pgk0pnA57OULU2oK4XMHdzvFtb2/g4vOtxgdsA8ugeGaG5Nsmq3F0d78Ehc09UNBDEfhgapcZJb4dqaSB1ccdw/laXW5KFBsqKP5MOFMdJJoxNDs4JRLLWweemJ/LZBy/pWNNU4BmwNPsKvHy13WhBK9gLGL8sI8CEjcoDzHT+zyHuRXZP5KpoMe4vm/PcKWGEaH42HQuk4gRfCCNbm0owbKLSIR8K3UwzrkCK75W/WgDpMscCRX6Zr9FPKH9Vrve1TVzXW++Ez//Nc+JfYxsXHASs3zbqujeCsIFyszAulrxDy/Bt3ndtO5JBuoyVomzF6fuetq9Oisl/nirjA2m78ifHGih3UYfGvshT0db1OVXQVLDQw5JNt/IGllK3vA+/zjyKXLw7Jwdg5ZnHxR6Qa+WClPQop+B0l1STWv2tpgaq7wJxWfzO5P20RY63hJjH8dJmI8iddP+OTMn8flRA+pF4xJereoAuP1LoUpWxuqcWCfMCBpmRw/TLPOkdEeqTJDcYCPE4IPAVB3GgNM1mxdlq1gBjztJXh16KBpLyVEnqj28YN0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(54906003)(6636002)(110136005)(6506007)(316002)(38100700002)(2906002)(4001150100001)(2616005)(8936002)(5660300002)(186003)(64756008)(8676002)(66446008)(4326008)(66476007)(66946007)(91956017)(76116006)(66556008)(36756003)(83380400001)(26005)(6512007)(38070700005)(41300700001)(71200400001)(478600001)(122000001)(6486002)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1pQZFBXdEsxM0llT0hEelUvN1pXQS9YVnN1QXlUaVBpQ1RSQzlyb0w5eDFa?=
 =?utf-8?B?OENzQ3hza0xCN29hNnM3clhmcUlxSDdoR2w2WVJFSlAzUTBLVzZYMjZRUGFJ?=
 =?utf-8?B?ZnQ0a2Y0RkU5c1A0clNTL2FmSjJXU3pJd2JHVEo0eDc1aUdHaFE0WS8rKzVJ?=
 =?utf-8?B?SkF2Y1QydTJ6RXBoSjJTNS9DRnc5dFM5TmoyM3paR3BqV09oNzd1MnlaVHM3?=
 =?utf-8?B?MkZXeVNvV1pheG1XcnNDaStFVjRaeE4rSFVFdjJCTHlhREcvVnhMVkdGWFRW?=
 =?utf-8?B?OHV5RHFsSVVPUER3aTdrZXo3aW5pUVROc21BVWlZaUlKTGlwU1VXejRTYnJr?=
 =?utf-8?B?VjdRajdkSTVtR0ZRa1BBVUZtU2tUcko5YXh6cjNmSzJEeGFSUkpUS2I4Y1N1?=
 =?utf-8?B?N0kweDdvcmdXNXloQ0pTK2wxRW1JMURSMUxSblViQW9HV3RlTGRubG5GSmQy?=
 =?utf-8?B?Nm55OXVaMVdPVWZhcTdFUHlpamhCWS8zZEw2VE42ZmlTa2pIcjh2MGRDQVhn?=
 =?utf-8?B?YmlRYXhjdEhySlVmNEY3WnN3N1pFMkt3WjFUQnJKRVV2ak54cnZhZytqNUs2?=
 =?utf-8?B?U3pFNXJKNHBFejJwMDFDTHJEaHRaYmRqZWYrL01JNnc4NzFRVVZaNlZlbUZk?=
 =?utf-8?B?SW1RRmtxWmhPb0N5M2VvOCtjcUovL1ZneEloTmthZE12Mk1EaEcrMEhmOGhu?=
 =?utf-8?B?ZHNPMDRqQm1XOXZab2x4R3gyN21RamxsU1BqMWxjNGluSURXWldRVlZMNGJ5?=
 =?utf-8?B?QU9TcmhhbGNoUmt4Y2MyQXZZdy9rWldHcnlSbVVLdmV6aGRwTkVEVTgvdW4v?=
 =?utf-8?B?NDl5RjlNR21OdzFURDN2bkZ1M0hGdDZWUjd4eHpaamhQZGZZNHJYdFRqdCtY?=
 =?utf-8?B?blFCa29xTU5hZys3UDBNdUlNYXJrODVML2pqdUZJNWpVdE9CTWZUcEFOcTZF?=
 =?utf-8?B?VTM3QkhyRzZMT0NWdnFKK0pnSmVvZExoSXlWdlo2UVVTRFRJMElnalBZU2pm?=
 =?utf-8?B?WW4yTmNiMGtkQ1dXMzZySjFMSGd4em4wQU1BekxpOUZuNFE1L0lYN01ORUcr?=
 =?utf-8?B?TDBDM0wrY1Y1MnAwb0V0VVA1cnY3blVPRFNXUkprWXdveVNTSGl5dDBJZ1pk?=
 =?utf-8?B?V3RKSnZuL09IV1pCUi9YTk5vNnZUQVJxeUwzWHR1SXVyUWlRb3dSSkRzb1Rx?=
 =?utf-8?B?c051cnBQcDF0cUt2ajlJTitoV2NDL09lMVhEbnNhWnN3eFRFOStia0J0RWY4?=
 =?utf-8?B?VXJCekVuYkJtd3d6dFpTYXNEcnJBUlFuNFFTalpuMXZIVDBFelExWURTV2o1?=
 =?utf-8?B?TjkzQUtRSHdLQjdHc2tHanFXSWtnU3dMVFh4cnRmMUZJTlU1QkUrU1NiSDlO?=
 =?utf-8?B?b0lnN3dRU1lhdExJS0ZKOE9OMWxlOFpKL2Z4RXpwZ3MzSG5TZzBHZGdSbEgr?=
 =?utf-8?B?VFVQT2dwTDFuR2wySEtjVVFMVFVCcDJRYzRBUEY1Y2lZckppcmFtNTdNMStW?=
 =?utf-8?B?Yzc2b3ZtVjc1enVMelJKeWdOZ2NxNHBHbnJ5VFMxZ0dONEp4QjVONDF5WWha?=
 =?utf-8?B?Z0g2cWYrUnBjV296ak5OOUNUU2JyYU9XSjkrQ2VJd05rRm5pbnRtRUNzc1hY?=
 =?utf-8?B?cmYyOG1IcVNxbk1LWE1RRDVHcll5RFp3SVhiODltMDJzY3k2Qk80eXRJcGYz?=
 =?utf-8?B?RHZReS9VL3FSWU5OYzcxL2FEK3pQSFI5L1FhakJ3WlRFMFJ0RGM3ZDRJandO?=
 =?utf-8?B?Q2xJQXpEYlpRa29aYjBydk00a2ppMWREb0RJUmFQSjdiN2NjNlhqU0dnZG1T?=
 =?utf-8?B?ZUNwNkFUbm9jWVpSTCtRRDlxQm9Zc0xRSUp6TmltMW84ZmViWXVlcnpmRWVw?=
 =?utf-8?B?RmQ2c2FjZTByNWhrV1VNbXRWN2FoZW14bUtaSkhjcWNYTWN2SDd6YzNLS1lL?=
 =?utf-8?B?SU9HMTZGb29Yc1pXUDJVWm14TnFsUVdDN2hTNWlGRmJ6VHFaSk85dms5WDNN?=
 =?utf-8?B?aDlPQkxhNFhoMVR2MmpUK3hjd3Q3M29EWjdJeUVJZFhlb2w3Z1ZjYkM4WURV?=
 =?utf-8?B?YkpZdFlFckRDSks0OTd5ZzYwK01zUXoway9NOHpQd3ZON3hmc3FKRG9YYXNG?=
 =?utf-8?B?Uk56ZXY5NlIzOFpPNXgzQjc5RnBEZCtiaHF6WkpKclN5V0RqNXhKTUZpbFV5?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66FA5BDFACE8CF4C8077AA19DEC7C2DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 810b6d06-e741-4257-82d5-08dac30c4125
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 11:11:02.6035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JX7unoNbMzMWX6QxDk0n7aYjV8gb+WVjSX8VDYqxB1+sAROetMdEchcF2TTf0dQD+XLr3H/WpoS8M+At4ZMHkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6843
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
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBTdHViIGluIGt2bV90ZHgsIHZjcHVfdGR4LCBhbmQgdGhl
aXIgdmFyaW91cyBhY2Nlc3NvcnMuICBURFggZGVmaW5lcw0KPiBTRUFNQ0FMTCBBUElzIHRvIGFj
Y2VzcyBURFggY29udHJvbCBzdHJ1Y3R1cmVzIGNvcnJlc3BvbmRpbmcgdG8gdGhlIFZNWA0KPiBW
TUNTLiAgSW50cm9kdWNlIGhlbHBlciBhY2Nlc3NvcnMgdG8gaGlkZSBpdHMgU0VBTUNBTEwgQUJJ
IGRldGFpbHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
LmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1h
aGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92
bXgvdGR4LmggfCAxMTggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAxMTYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5oIGIvYXJjaC94ODYva3ZtL3Zt
eC90ZHguaA0KPiBpbmRleCA0NzMwMTMyNjViZDguLjk4OTk5YmYzZjE4OCAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5o
DQo+IEBAIC0zLDE0ICszLDI3IEBADQo+ICAjZGVmaW5lIF9fS1ZNX1g4Nl9URFhfSA0KPiAgDQo+
ICAjaWZkZWYgQ09ORklHX0lOVEVMX1REWF9IT1NUDQo+ICsNCj4gKyNpbmNsdWRlICJ0ZHhfb3Bz
LmgiDQo+ICsNCj4gK3N0cnVjdCB0ZHhfdGRfcGFnZSB7DQo+ICsJdW5zaWduZWQgbG9uZyB2YTsN
Cj4gKwlocGFfdCBwYTsNCj4gKwlib29sIGFkZGVkOw0KPiArfTsNCj4gKw0KPiAgc3RydWN0IGt2
bV90ZHggew0KPiAgCXN0cnVjdCBrdm0ga3ZtOw0KPiAtCS8qIFREWCBzcGVjaWZpYyBtZW1iZXJz
IGZvbGxvdy4gKi8NCj4gKw0KPiArCXN0cnVjdCB0ZHhfdGRfcGFnZSB0ZHI7DQo+ICsJc3RydWN0
IHRkeF90ZF9wYWdlICp0ZGNzOw0KPiAgfTsNCj4gIA0KPiAgc3RydWN0IHZjcHVfdGR4IHsNCj4g
IAlzdHJ1Y3Qga3ZtX3ZjcHUJdmNwdTsNCj4gLQkvKiBURFggc3BlY2lmaWMgbWVtYmVycyBmb2xs
b3cuICovDQo+ICsNCj4gKwlzdHJ1Y3QgdGR4X3RkX3BhZ2UgdGR2cHI7DQo+ICsJc3RydWN0IHRk
eF90ZF9wYWdlICp0ZHZweDsNCj4gIH07DQoNCkFzIHJlcGxpZWQgdG8gdGhlIHBhdGNoICJLVk06
IFREWDogY3JlYXRlL2Rlc3Ryb3kgVk0gc3RydWN0dXJlIiwgSSB0aGluayBpdCdzDQpiZXR0ZXIg
dG8gaW50cm9kdWNlIHRoaXMgcGFydCB0b2dldGhlciB3aXRoIHRoYXQgcGF0Y2ggdG8gbWFrZSBy
ZXZpZXdlciBlYXNpZXIuDQoNCklmIEkgYW0gbm90IHNlZWluZyBtaXN0YWtlbmx5LCB0aGUgImFj
Y2Vzc29ycyIgYmVsb3cgYXJlIG5vdCB1c2VkIGluIHRoYXQgcGF0Y2gsDQpzbyB0aGV5IGNhbiBi
ZSBkb25lIGluIGEgbGF0ZXIgcGF0Y2ggd2hlbiBuZWVkZWQuDQoNCj4gIA0KPiAgc3RhdGljIGlu
bGluZSBib29sIGlzX3RkKHN0cnVjdCBrdm0gKmt2bSkNCj4gQEAgLTMyLDYgKzQ1LDEwNyBAQCBz
dGF0aWMgaW5saW5lIHN0cnVjdCB2Y3B1X3RkeCAqdG9fdGR4KHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkNCj4gIHsNCj4gIAlyZXR1cm4gY29udGFpbmVyX29mKHZjcHUsIHN0cnVjdCB2Y3B1X3RkeCwg
dmNwdSk7DQo+ICB9DQo+ICsNCj4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdm9pZCB0ZHZwc192
bWNzX2NoZWNrKHUzMiBmaWVsZCwgdTggYml0cykNCj4gK3sNCj4gKyNkZWZpbmUgVk1DU19FTkNf
QUNDRVNTX1RZUEVfTUFTSwkweDFVTA0KPiArI2RlZmluZSBWTUNTX0VOQ19BQ0NFU1NfVFlQRV9G
VUxMCTB4MFVMDQo+ICsjZGVmaW5lIFZNQ1NfRU5DX0FDQ0VTU19UWVBFX0hJR0gJMHgxVUwNCj4g
KyNkZWZpbmUgVk1DU19FTkNfQUNDRVNTX1RZUEUoZmllbGQpCSgoZmllbGQpICYgVk1DU19FTkNf
QUNDRVNTX1RZUEVfTUFTSykNCj4gKw0KPiArCS8qIFREWCBpcyA2NGJpdCBvbmx5LiAgSElHSCBm
aWVsZCBpc24ndCBzdXBwb3J0ZWQuICovDQo+ICsJQlVJTERfQlVHX09OX01TRyhfX2J1aWx0aW5f
Y29uc3RhbnRfcChmaWVsZCkgJiYNCj4gKwkJCSBWTUNTX0VOQ19BQ0NFU1NfVFlQRShmaWVsZCkg
PT0gVk1DU19FTkNfQUNDRVNTX1RZUEVfSElHSCwNCj4gKwkJCSAiUmVhZC9Xcml0ZSB0byBURCBW
TUNTICpfSElHSCBmaWVsZHMgbm90IHN1cHBvcnRlZCIpOw0KPiArDQo+ICsJQlVJTERfQlVHX09O
KGJpdHMgIT0gMTYgJiYgYml0cyAhPSAzMiAmJiBiaXRzICE9IDY0KTsNCj4gKw0KPiArI2RlZmlu
ZSBWTUNTX0VOQ19XSURUSF9NQVNLCUdFTk1BU0soMTQsIDEzKQ0KPiArI2RlZmluZSBWTUNTX0VO
Q19XSURUSF8xNkJJVAkoMFVMIDw8IDEzKQ0KPiArI2RlZmluZSBWTUNTX0VOQ19XSURUSF82NEJJ
VAkoMVVMIDw8IDEzKQ0KPiArI2RlZmluZSBWTUNTX0VOQ19XSURUSF8zMkJJVAkoMlVMIDw8IDEz
KQ0KPiArI2RlZmluZSBWTUNTX0VOQ19XSURUSF9OQVRVUkFMCSgzVUwgPDwgMTMpDQo+ICsjZGVm
aW5lIFZNQ1NfRU5DX1dJRFRIKGZpZWxkKQkoKGZpZWxkKSAmIFZNQ1NfRU5DX1dJRFRIX01BU0sp
DQo+ICsNCj4gKwkvKiBURFggaXMgNjRiaXQgb25seS4gIGkuZS4gbmF0dXJhbCB3aWR0aCA9IDY0
Yml0LiAqLw0KPiArCUJVSUxEX0JVR19PTl9NU0coYml0cyAhPSA2NCAmJiBfX2J1aWx0aW5fY29u
c3RhbnRfcChmaWVsZCkgJiYNCj4gKwkJCSAoVk1DU19FTkNfV0lEVEgoZmllbGQpID09IFZNQ1Nf
RU5DX1dJRFRIXzY0QklUIHx8DQo+ICsJCQkgIFZNQ1NfRU5DX1dJRFRIKGZpZWxkKSA9PSBWTUNT
X0VOQ19XSURUSF9OQVRVUkFMKSwNCj4gKwkJCSAiSW52YWxpZCBURCBWTUNTIGFjY2VzcyBmb3Ig
NjQtYml0IGZpZWxkIik7DQo+ICsJQlVJTERfQlVHX09OX01TRyhiaXRzICE9IDMyICYmIF9fYnVp
bHRpbl9jb25zdGFudF9wKGZpZWxkKSAmJg0KPiArCQkJIFZNQ1NfRU5DX1dJRFRIKGZpZWxkKSA9
PSBWTUNTX0VOQ19XSURUSF8zMkJJVCwNCj4gKwkJCSAiSW52YWxpZCBURCBWTUNTIGFjY2VzcyBm
b3IgMzItYml0IGZpZWxkIik7DQo+ICsJQlVJTERfQlVHX09OX01TRyhiaXRzICE9IDE2ICYmIF9f
YnVpbHRpbl9jb25zdGFudF9wKGZpZWxkKSAmJg0KPiArCQkJIFZNQ1NfRU5DX1dJRFRIKGZpZWxk
KSA9PSBWTUNTX0VOQ19XSURUSF8xNkJJVCwNCj4gKwkJCSAiSW52YWxpZCBURCBWTUNTIGFjY2Vz
cyBmb3IgMTYtYml0IGZpZWxkIik7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBfX2Fsd2F5c19pbmxp
bmUgdm9pZCB0ZHZwc19zdGF0ZV9ub25fYXJjaF9jaGVjayh1NjQgZmllbGQsIHU4IGJpdHMpIHt9
DQo+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgdGR2cHNfbWFuYWdlbWVudF9jaGVjayh1
NjQgZmllbGQsIHU4IGJpdHMpIHt9DQo+ICsNCj4gKyNkZWZpbmUgVERYX0JVSUxEX1REVlBTX0FD
Q0VTU09SUyhiaXRzLCB1Y2xhc3MsIGxjbGFzcykJCQkJXA0KPiArc3RhdGljIF9fYWx3YXlzX2lu
bGluZSB1IyNiaXRzIHRkXyMjbGNsYXNzIyNfcmVhZCMjYml0cyhzdHJ1Y3QgdmNwdV90ZHggKnRk
eCwJXA0KPiArCQkJCQkJCXUzMiBmaWVsZCkJCVwNCj4gK3sJCQkJCQkJCQkJXA0KPiArCXN0cnVj
dCB0ZHhfbW9kdWxlX291dHB1dCBvdXQ7CQkJCQkJXA0KPiArCXU2NCBlcnI7CQkJCQkJCQlcDQo+
ICsJCQkJCQkJCQkJXA0KPiArCXRkdnBzXyMjbGNsYXNzIyNfY2hlY2soZmllbGQsIGJpdHMpOwkJ
CQkJXA0KPiArCWVyciA9IHRkaF92cF9yZCh0ZHgtPnRkdnByLnBhLCBURFZQU18jI3VjbGFzcyhm
aWVsZCksICZvdXQpOwkJXA0KPiArCWlmICh1bmxpa2VseShlcnIpKSB7CQkJCQkJCVwNCj4gKwkJ
cHJfZXJyKCJUREhfVlBfUkRbIiN1Y2xhc3MiLjB4JXhdIGZhaWxlZDogMHglbGx4XG4iLAkJXA0K
PiArCQkgICAgICAgZmllbGQsIGVycik7CQkJCQkJXA0KPiArCQlyZXR1cm4gMDsJCQkJCQkJXA0K
PiArCX0JCQkJCQkJCQlcDQo+ICsJcmV0dXJuICh1IyNiaXRzKW91dC5yODsJCQkJCQkJXA0KPiAr
fQkJCQkJCQkJCQlcDQo+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgdGRfIyNsY2xhc3Mj
I193cml0ZSMjYml0cyhzdHJ1Y3QgdmNwdV90ZHggKnRkeCwJXA0KPiArCQkJCQkJICAgICAgdTMy
IGZpZWxkLCB1IyNiaXRzIHZhbCkJXA0KPiArewkJCQkJCQkJCQlcDQo+ICsJc3RydWN0IHRkeF9t
b2R1bGVfb3V0cHV0IG91dDsJCQkJCQlcDQo+ICsJdTY0IGVycjsJCQkJCQkJCVwNCj4gKwkJCQkJ
CQkJCQlcDQo+ICsJdGR2cHNfIyNsY2xhc3MjI19jaGVjayhmaWVsZCwgYml0cyk7CQkJCQlcDQo+
ICsJZXJyID0gdGRoX3ZwX3dyKHRkeC0+dGR2cHIucGEsIFREVlBTXyMjdWNsYXNzKGZpZWxkKSwg
dmFsLAkJXA0KPiArCQkgICAgICBHRU5NQVNLX1VMTChiaXRzIC0gMSwgMCksICZvdXQpOwkJCQlc
DQo+ICsJaWYgKHVubGlrZWx5KGVycikpCQkJCQkJCVwNCj4gKwkJcHJfZXJyKCJUREhfVlBfV1Jb
IiN1Y2xhc3MiLjB4JXhdID0gMHglbGx4IGZhaWxlZDogMHglbGx4XG4iLAlcDQo+ICsJCSAgICAg
ICBmaWVsZCwgKHU2NCl2YWwsIGVycik7CQkJCQlcDQo+ICt9CQkJCQkJCQkJCVwNCj4gK3N0YXRp
YyBfX2Fsd2F5c19pbmxpbmUgdm9pZCB0ZF8jI2xjbGFzcyMjX3NldGJpdCMjYml0cyhzdHJ1Y3Qg
dmNwdV90ZHggKnRkeCwJXA0KPiArCQkJCQkJICAgICAgIHUzMiBmaWVsZCwgdTY0IGJpdCkJXA0K
PiArewkJCQkJCQkJCQlcDQo+ICsJc3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0IG91dDsJCQkJCQlc
DQo+ICsJdTY0IGVycjsJCQkJCQkJCVwNCj4gKwkJCQkJCQkJCQlcDQo+ICsJdGR2cHNfIyNsY2xh
c3MjI19jaGVjayhmaWVsZCwgYml0cyk7CQkJCQlcDQo+ICsJZXJyID0gdGRoX3ZwX3dyKHRkeC0+
dGR2cHIucGEsIFREVlBTXyMjdWNsYXNzKGZpZWxkKSwgYml0LCBiaXQsCQlcDQo+ICsJCQkmb3V0
KTsJCQkJCQkJXA0KPiArCWlmICh1bmxpa2VseShlcnIpKQkJCQkJCQlcDQo+ICsJCXByX2Vycigi
VERIX1ZQX1dSWyIjdWNsYXNzIi4weCV4XSB8PSAweCVsbHggZmFpbGVkOiAweCVsbHhcbiIsCVwN
Cj4gKwkJICAgICAgIGZpZWxkLCBiaXQsIGVycik7CQkJCQlcDQo+ICt9CQkJCQkJCQkJCVwNCj4g
K3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdm9pZCB0ZF8jI2xjbGFzcyMjX2NsZWFyYml0IyNiaXRz
KHN0cnVjdCB2Y3B1X3RkeCAqdGR4LAlcDQo+ICsJCQkJCQkJIHUzMiBmaWVsZCwgdTY0IGJpdCkJ
XA0KPiArewkJCQkJCQkJCQlcDQo+ICsJc3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0IG91dDsJCQkJ
CQlcDQo+ICsJdTY0IGVycjsJCQkJCQkJCVwNCj4gKwkJCQkJCQkJCQlcDQo+ICsJdGR2cHNfIyNs
Y2xhc3MjI19jaGVjayhmaWVsZCwgYml0cyk7CQkJCQlcDQo+ICsJZXJyID0gdGRoX3ZwX3dyKHRk
eC0+dGR2cHIucGEsIFREVlBTXyMjdWNsYXNzKGZpZWxkKSwgMCwgYml0LAkJXA0KPiArCQkJJm91
dCk7CQkJCQkJCVwNCj4gKwlpZiAodW5saWtlbHkoZXJyKSkJCQkJCQkJXA0KPiArCQlwcl9lcnIo
IlRESF9WUF9XUlsiI3VjbGFzcyIuMHgleF0gJj0gfjB4JWxseCBmYWlsZWQ6IDB4JWxseFxuIiwJ
XA0KPiArCQkgICAgICAgZmllbGQsIGJpdCwgIGVycik7CQkJCQlcDQo+ICt9DQo+ICsNCj4gK1RE
WF9CVUlMRF9URFZQU19BQ0NFU1NPUlMoMTYsIFZNQ1MsIHZtY3MpOw0KPiArVERYX0JVSUxEX1RE
VlBTX0FDQ0VTU09SUygzMiwgVk1DUywgdm1jcyk7DQo+ICtURFhfQlVJTERfVERWUFNfQUNDRVNT
T1JTKDY0LCBWTUNTLCB2bWNzKTsNCj4gKw0KPiArVERYX0JVSUxEX1REVlBTX0FDQ0VTU09SUyg2
NCwgU1RBVEVfTk9OX0FSQ0gsIHN0YXRlX25vbl9hcmNoKTsNCj4gK1REWF9CVUlMRF9URFZQU19B
Q0NFU1NPUlMoOCwgTUFOQUdFTUVOVCwgbWFuYWdlbWVudCk7DQo+ICsNCj4gDQoNCg==
