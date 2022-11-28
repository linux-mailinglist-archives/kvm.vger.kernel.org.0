Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA763B4EF
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiK1Wsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiK1Wsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:48:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F0229C8A;
        Mon, 28 Nov 2022 14:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669675715; x=1701211715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jRCDtU5vK3ra7U3e2Tkkcmnu6vMfQiBZAAolvBx9FZs=;
  b=F1cQG48XiCtkRGWOJClMeVSdCvuZXFVBOYGUVvwHnxxJZRQAbcn3Xten
   d0O9upU9hIYHQN6GAUXnJh3KvZ+ErrqYa5QmIERY/wscPBEdECz27YkOK
   Q4SAQYBm4lwGB7dqoaOzOhPcwWoAKkKQZz4L7w2ZNDZjviL4PJ9nT8/BK
   2Rb6MWIuFrjAOalJl7T0L6Qc91CYG5ojCXH+i/1ZsI+RH+HMXQIrPA398
   AAsXdY+GfokJqLOvWhMuQSiXfRjtaMeDiwpgQIxydCnCx2HZoc8AnzgaR
   JLZ9D5aiSnqfUg5xeUemazliS8kzVvzzUck3WwYnddVqysMjGb0Y0uy3n
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="312591546"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="312591546"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:48:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888610019"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="888610019"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 14:48:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:48:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:48:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crtQenqNlz154FWXjUHkVyoQZTYUibzv3Do1+10BIHisgyVhaEcE10Do2sz7/qI+OxklwSdPiEp7pBfBvn0xVctwK8ghXzOrkm22FxVAH6VOVmBs7L4jRdxEMEIEM6iK3FIV3u3hQojYaUHgXd7P2UqqeZAdwCv70ITmO3ZGvjjvFp719QE+mMvhuFzpyhQtYcYZiW4drOWP+A4BXgvPC8u9hZW6kZ7zXKJRjE+jU01/Xpkin7PT8Nzl4NcmrxE7WLstuZIGLVkbZC25kuWg2s4k8WIGtOqsbhPwUclk6pkMmMVoqkKVyDRaEB7Vi1FNssQbnRN3b0wOLhFvuIIHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRCDtU5vK3ra7U3e2Tkkcmnu6vMfQiBZAAolvBx9FZs=;
 b=Q57HeHmEYv6surxbWrQYTuNaVB3F5tYbNXjj/r2ytc6dmXUuGeT34NnVEnoNch39g9cKDDwrtALym3q5vkJLZaYphn//rCPCA1Awo35t5LXbJ72Md7o5DSfoCLb5A2mn33NkN6DAk42LTNQ/PmStxwAwfLvrWakCCbrI5wxY5s7vmNjrabPI7dXdn/aEYCyf7Ud8vHet0SXnX2sjJzjaTMAKaU3HfJbhjkZ/hB9Zt38PYiCdpjYLY+DO0Ivr9eDVbW9WZa/pcCFNRu8xHffe1dN5/ymS38LCq9PgTVDFwjKkdRmUSB+sVm/ci8rEuQS5gAvopKiJCCfHj6HEXuHRpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7135.namprd11.prod.outlook.com (2603:10b6:930:61::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 22:48:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 22:48:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHY/T3JgMaJHzs+pUuA6EdKq644U65NI28AgADW5wCABpsagIAAZxuA
Date:   Mon, 28 Nov 2022 22:48:24 +0000
Message-ID: <a68919357982a85252e13626b8d577642fee5beb.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
         <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
         <cceee7b0476437fb18f90a272e2852bdbb2636cc.camel@intel.com>
         <1e45748f-0de1-39aa-7e0f-7596ff813302@intel.com>
In-Reply-To: <1e45748f-0de1-39aa-7e0f-7596ff813302@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7135:EE_
x-ms-office365-filtering-correlation-id: d2e90213-724f-48d3-98f9-08dad192a82b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZsdYzzfUq/o/kiRBX8VbZ/Vn2c+5JzwXhT/7Mli6hU1SnUbfeNXGpltJbNNtJgAdCXZEDztyCOj33Q9wMyQDgWVTnFprythXRpP5t2cG9RqNu/N+MQE/zNPltYSjfUW4cIKq3BVwy0lpFfZqeWd9NRVN2QlH/nTgcTlQOFoYOrBSAD4W66pyc8bkeuTBzcFmMTKnIfk6IZyVsRlMwlOjknOF4uiL6rIpmReZ9EWPkWaaNjoKp9w863GEhG+ZlLPFUhP/X8R2Xoc2wBRq2BC0pVBPpyxpmtkeFm403gChcCMw1twqijPiX15RA8ct4VKicKawgy61Hp7TbUxpaKnUOGcAiZ9UcYt+/z6eZWlmvPmen3B+q2vY9BVS6IS8N4hxmDIwFC0XiNizy14XLQ0YYytcMZKP0eTzotPrL46+RtdYy9Mhiagna9QpIv9lwpszaEIzR7ri27HWMNgelT5HD9VyqvrdogqAy0u5YYLxFd6EcnKcy6tYbZ+WdtokWZ8QdyjJ8F0E7i6FZVc40Pc1xX0gS6+q1ipSiwOMx/jSHQ0PDKPjpeLo0/CUXExoF0qO9KEToiwJwCIqPbL2CQlY+t3ujrpmZ+lFpof2qvvYWdR//Ex6as9PexZ/vMy9lPlQ3rxaElqKXutuqS8fgGPmbhJDhfbCcXOcKqf778zHjyDmff7vfxtoixdPIDDNRybg7/JqKhIpwIZeIPvEh1TMKNgzrSE8pVe7hWCl9IeP0g0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199015)(7416002)(5660300002)(8936002)(54906003)(110136005)(316002)(26005)(6512007)(2616005)(41300700001)(186003)(66946007)(91956017)(66556008)(76116006)(8676002)(4326008)(64756008)(66476007)(66446008)(36756003)(122000001)(38070700005)(38100700002)(2906002)(82960400001)(4001150100001)(86362001)(83380400001)(6506007)(478600001)(6486002)(71200400001)(53546011)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzBUZGYzaGJrUDJmbWt5anpMTzhCTnRDc0gyY1ZKOGNFWmU1eUM2a2x0UERx?=
 =?utf-8?B?dGs4NGlxaG4rMnUxUnAzUFAwUEhmdEtaazlZMVFLRXBDRkFia2dGU3ByTXFz?=
 =?utf-8?B?N3hQTUE4SjFmV2grSEM2QUFJSWZNWnVWeEYwb21maHl6VXhCWEp1RlVtd1Vk?=
 =?utf-8?B?ZjZFVkx5ZUszV3RuUWVCMFgvME9rTDhnSU9VeHNIUnUzc3BmRDhwSW1FNEU3?=
 =?utf-8?B?UXhHeVBUTlBKRFhLSitIaHgrZTM5c3dPZzN2SzIwNEVRVmRyVlpBSFk5Vlda?=
 =?utf-8?B?ZGFud0l0UDh0bDEvY0FmMmpCc3dUV01kam9YV2lhY1U4MUFrTkVZOXVkSWdm?=
 =?utf-8?B?M0V4U1liNVRnenBOUHVROFBKbmFDVFJ5VlllRVE2MHV4cHVqSzdKWkVXcTUz?=
 =?utf-8?B?N2pmY1RsMWp4aldBL0NVY0U5dDU5UEJkVWdiem1jRUNyVmwzMTZkc04yNmpo?=
 =?utf-8?B?TjlsL2xBVE81RFRoVjRnTW5HbVhWR2lnbXRablc0RDBqMms3dHRUZzY4TjZQ?=
 =?utf-8?B?K3k2UHVqaGlUNmhpL3N1U3ZpcDl5Y0NpczlSYk1YdytYYzJ6WGxKdEVadEti?=
 =?utf-8?B?a092OUROWDNHMjdZbStBK3huUHBIcis4VThaUUtNVUFOUldSYjlJUythR2t2?=
 =?utf-8?B?SEtXUmJBVjJXSUo3dzk0MUlJSHBjWnBOUFROVG0zdmRmc2pHRTFaVm82clNE?=
 =?utf-8?B?d0xERFIvYlArR1lvWUNRK3FOMm1rdnd2SU56SGM1RmZ0RXQrSko3d1lYMnZ0?=
 =?utf-8?B?aVlQK2VWTXU3QkdWVUpCVEVHRTFudWNJL1NydDBSUnNxZHJMMisvTHdXQytW?=
 =?utf-8?B?SWxzUUtzZ0krNlRGZnZxb2pCWnVFTEJXcVUxNHBhQnRXZG1FbGlEaGFjWG1B?=
 =?utf-8?B?eG1QeW1KREpXQnNYVHBSVzV6ckJNd1ZDd1Zqeng3cVlLd01XVlhYSXZVeGt6?=
 =?utf-8?B?SDFpMHpjYlpPa1F2czJiQ01SSXJXOWhPWk1oSDRPcWhmbHJsdUVVeTBWaFNp?=
 =?utf-8?B?SGpoMkNtYVgvMnd1QVRIQjdWRFh1UDhxVWFRbDlRZTBLZWZBa2pKQXd2Q0lK?=
 =?utf-8?B?V3ZCTzB6S0hrcE9tdU1CbmdlMkhTYjZvRVB0MTBvbm9VclNVaGVVdHhYakVT?=
 =?utf-8?B?WGlCVzVLT01jZkpHM1NEU1dVTUtuSnhMTUhFSlE3QUVzdkFFT1VmMHM4WlFL?=
 =?utf-8?B?R2ZxSm1VSlhUV1psZ2UrbDUyQ2RhUDc5blI5OUp1OWRlMkQ0QkNnV3lRWCtu?=
 =?utf-8?B?RXZFVlA5cjBRd1pwZE9FV1lsU2pUYjZ1Sm9FcDIyY3dXVkplOVlsRmxXQjRI?=
 =?utf-8?B?c2hhUmtHaDJhU1A2NU1aQnB0TVpGdzNUbCt3NzEzUnZDbzBDSHBYRUszcEhS?=
 =?utf-8?B?NklDNmZKYUFJaUFlN1NWQW1ZSThHY0NUdnJxQXZtTE5yV3NMVVM0bHhXT3VV?=
 =?utf-8?B?TWp4R3o1T2xQWWJnV3IySU9Id0d1YVNEdDRVbCtrU2VBY0Y1QXlOYjVvaTAw?=
 =?utf-8?B?VW5ReEFsMXJBcVd6MDk0OEJRZFFVcHhEd0dKdGlyemhLME1VSTRjNzN3Nlkx?=
 =?utf-8?B?STRESVVnNyt3Nld3M3ZCcWQ1MFJuZFhsbHh3eUhNTHh6SktSeFVzK0lROGFs?=
 =?utf-8?B?MzhZbkRHRWNaSHVMTFNHb2k0c0tvVEZRaG0xUTBTMUhESDJSMHdHQ2dEWGoy?=
 =?utf-8?B?cjYrR0Z3MFU4ZTd4TDBXSVV1c0VYVzNtTXRvV3YvRGJXaGk5QUtrV3FiYllV?=
 =?utf-8?B?TGxxdEtPb2ExL04wU01hOCtUKy80YzJiVGZmYkVOZ0F6Z2poeC9YQ2xmR3hu?=
 =?utf-8?B?T0tTaUIrcDZ4ZUhqQVhEc3lJTG9ud3hQRDZtQnRLS0RqNElqV3Uyb0Q2RCtV?=
 =?utf-8?B?OUkrUmlmWVJGMjY5eUMvUW1mUVpJYlVEUVNyK1hqbERtVnM0UnJ4WnZmeXNz?=
 =?utf-8?B?emlwaFdlSnA2b21qUVZ2RnIrdUYxU2VFMEZlQThaM20zQnRuNzZwM2ZUWkQ4?=
 =?utf-8?B?RlNCUlNJbVVsajNPVEFrTGJxZ2NJbzRPc0MvVnBxZmErcGZRNFduUGtPSzNU?=
 =?utf-8?B?NmtZclNDV1JERS9kcG15TGZSKzVZWS9Ca3M1RXR3YXdDdnVxbDd3VTc1TTVj?=
 =?utf-8?B?SVhUMHNiamx2TWdsd2xobkhsL2YrbHhFKytXR2RDb00rTGxuNHI5WTdYV0Jw?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD7F5038D92BB74588F741BCEA35BC3D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e90213-724f-48d3-98f9-08dad192a82b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 22:48:24.2581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/YtiasIv1evuPH7eML9+UdY7Q2NoOjPTITyl5BWE+5vckE2HfiQKlyZQ8RGh+wN2mgaxaT5614YjmFPVpZpvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7135
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDA4OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjQvMjIgMDM6NDYsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIyLTEx
LTIzIGF0IDE0OjU3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+IE9uIDExLzIwLzIy
IDE2OjI2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IFVzZSBhbGxvY19jb250aWdfcGFnZXMo
KSBzaW5jZSBQQU1UIG11c3QgYmUgYSBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgYXJlYQ0KPiA+ID4g
PiBhbmQgaXQgbWF5IGJlIHBvdGVudGlhbGx5IGxhcmdlICh+MS8yNTZ0aCBvZiB0aGUgc2l6ZSBv
ZiB0aGUgZ2l2ZW4gVERNUikuDQo+ID4gPiA+IFRoZSBkb3duc2lkZSBpcyBhbGxvY19jb250aWdf
cGFnZXMoKSBtYXkgZmFpbCBhdCBydW50aW1lLiAgT25lIChiYWQpDQo+ID4gPiA+IG1pdGlnYXRp
b24gaXMgdG8gbGF1bmNoIGEgVEQgZ3Vlc3QgZWFybHkgZHVyaW5nIHN5c3RlbSBib290IHRvIGdl
dCB0aG9zZQ0KPiA+ID4gPiBQQU1UcyBhbGxvY2F0ZWQgYXQgZWFybHkgdGltZSwgYnV0IHRoZSBv
bmx5IHdheSB0byBmaXggaXMgdG8gYWRkIGEgYm9vdA0KPiA+ID4gPiBvcHRpb24gdG8gYWxsb2Nh
dGUgb3IgcmVzZXJ2ZSBQQU1UcyBkdXJpbmcga2VybmVsIGJvb3QuDQo+ID4gPiANCj4gPiA+IEZX
SVcsIHdlIGFsbCBhZ3JlZSB0aGF0IHRoaXMgaXMgYSBiYWQgcGVybWFuZW50IHdheSB0byBsZWF2
ZSB0aGluZ3MuDQo+ID4gPiBZb3UgY2FuIGNhbGwgbWUgb3V0IGhlcmUgYXMgcHJvcG9zaW5nIHRo
YXQgdGhpcyB3YXJ0IGJlIGxlZnQgaW4gcGxhY2UNCj4gPiA+IHdoaWxlIHRoaXMgc2VyaWVzIGlz
IG1lcmdlZCBhbmQgaXMgYSBkZXRhaWwgd2UgY2FuIHdvcmsgb24gYWZ0ZXJ3b3JkDQo+ID4gPiB3
aXRoIG5ldyBtb2R1bGUgcGFyYW1zLCBib290IG9wdGlvbnMsIEtjb25maWcgb3Igd2hhdGV2ZXIu
DQo+ID4gDQo+ID4gU29ycnkgZG8geW91IG1lYW4gdG8gY2FsbCBvdXQgaW4gdGhlIGNvdmVyIGxl
dHRlciwgb3IgaW4gdGhpcyBjaGFuZ2Vsb2c/DQo+IA0KPiBDb3ZlciBsZXR0ZXIgd291bGQgYmUg
YmVzdC4gIEJ1dCwgYSBub3RlIGluIHRoZSBjaGFuZ2Vsb2cgdGhhdCBpdCBpcw0KPiBpbXBlcmZl
Y3QgYW5kIHdpbGwgYmUgaW1wcm92ZWQgb24gbGF0ZXIgd291bGQgYWxzbyBiZSBuaWNlLg0KDQpU
aGFua3Mgd2lsbCBkbyBib3RoLg0KDQo+IA0KPiA+ID4gPiArICAgLyoNCj4gPiA+ID4gKyAgICAq
IEZhbGwgYmFjayB0byBhbGxvY2F0aW5nIHRoZSBURE1SJ3MgbWV0YWRhdGEgZnJvbSBub2RlIDAg
d2hlbg0KPiA+ID4gPiArICAgICogbm8gVERYIG1lbW9yeSBibG9jayBjYW4gYmUgZm91bmQuICBU
aGlzIHNob3VsZCBuZXZlciBoYXBwZW4NCj4gPiA+ID4gKyAgICAqIHNpbmNlIFRETVJzIG9yaWdp
bmF0ZSBmcm9tIFREWCBtZW1vcnkgYmxvY2tzLg0KPiA+ID4gPiArICAgICovDQo+ID4gPiA+ICsg
ICBXQVJOX09OX09OQ0UoMSk7DQo+ID4gPiANCj4gPiA+IFRoYXQncyBwcm9iYWJseSBiZXR0ZXIg
YSBwcl93YXJuKCkgb3Igc29tZXRoaW5nLiAgQSBiYWNrdHJhY2UgYW5kIGFsbA0KPiA+ID4gdGhh
dCBqYXp6IHNlZW1zIGEgYml0IG92ZXJseSBkcmFtYXRpYyBmb3IgdGhpcy4NCj4gPiANCj4gPiBI
b3cgYWJvdXQgYmVsb3c/DQo+ID4gDQo+ID4gcHJfd2FybigiVERNUiBbMHglbGx4LCAweCVsbHgp
OiB1bmFibGUgdG8gZmluZCBsb2NhbCBOVU1BIG5vZGUgZm9yIFBBTVQNCj4gPiBhbGxvY2F0aW9u
LCBmYWxsYmFjayB0byB1c2Ugbm9kZSAwLlxuIik7DQo+IA0KPiBJIGFjdHVhbGx5IHRyeSB0byBt
YWtlIHRoZXNlIHNvbWV3aGF0IG1pcnJvciB0aGUgY29kZS4gIEZvciBpbnN0YW5jZSwgaWYNCj4g
eW91IGFyZSBzZWFyY2hpbmcgdXNpbmcgKmp1c3QqIHRoZSBzdGFydCBURE1SIGFkZHJlc3MsIHRo
ZW4gdGhlIG1lc3NhZ2UNCj4gc2hvdWxkIG9ubHkgdGFsayBhYm91dCB0aGUgc3RhcnQgYWRkcmVz
cy4gIEFsc28sIGl0J3Mgbm90IHRyeWluZyB0byBmaW5kDQo+IGEgKm5vZGUqIHBlciBzZS4gIEl0
J3MgdHJ5aW5nIHRvIGZpbmQgYSAndG1iJy4gIFNvLCBpZiBzb21lb25lIHdhbnRlZCB0bw0KPiBk
ZWJ1ZyB0aGlzIHByb2JsZW0sIHRoZXkgd291bGQgYWN0dWFsbHkgd2FudCB0byBkdW1wIG91dCB0
aGUgdG1icy4NCj4gDQo+IEJ1dCwgYmFjayB0byB0aGUgbG9vcCB0aGF0IHRoaXMgbWVzc2FnZSBk
ZXNjcmliZXM6DQo+IA0KPiA+ICsJLyogRmluZCB0aGUgZmlyc3QgbWVtb3J5IHJlZ2lvbiBjb3Zl
cmVkIGJ5IHRoZSBURE1SICovDQo+ID4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHRtYiwgJnRkeF9t
ZW1saXN0LCBsaXN0KSB7DQo+ID4gKwkJaWYgKHRtYi0+ZW5kX3BmbiA+ICh0ZG1yX3N0YXJ0KHRk
bXIpID4+IFBBR0VfU0hJRlQpKQ0KPiA+ICsJCQlyZXR1cm4gdG1iLT5uaWQ7DQo+ID4gKwl9DQo+
IA0KPiBUaGF0IGxvb3AgaXMgZnVua3kuICBJdCdzIG5vdCBvYnZpb3VzIGF0ICphbGwqIHdoeSBp
dCBldmVuIHdvcmtzLg0KPiANCj4gMS4gQSAndG1iJyBkZXNjcmliZXMgInJlYWwiIG1lbW9yeS4g
IEl0IG5ldmVyIGNvdmVycyBob2xlcy4NCj4gMi4gVGhpcyBjb2RlIGlzIHRyeWluZyB0byBmaW5k
ICphKiAndG1iJyB0byBwbGFjZSBhIHN0cnVjdHVyZSBpbi4gIEl0DQo+ICAgIG5lZWRzIHJlYWwg
bWVtb3J5IHRvIHBsYWNlIHRoaXMsIG9mIGNvdXJzZS4NCj4gMy4gQSAndGRtcicgbWF5IGluY2x1
ZGUgaG9sZXMgYW5kIG1heSBub3QgaGF2ZSBhICd0bWInIGF0IGVpdGhlciBpdHMNCj4gICAgc3Rh
cnQgb3IgZW5kIGFkZHJlc3MNCj4gNC4gQSAndGRtcicgaXMgZXhwZWN0ZWQgdG8gY292ZXIgb25l
IG9yIG1vcmUgJ3RtYidzLiAgSWYgdGhlcmUgd2VyZSBubw0KPiAgICAndG1iJ3MsIHRoZW4gdGhl
IFRETVIgaXMgZ29pbmcgdG8gYmUgbWFya2VkIGFzIGFsbCByZXNlcnZlZCBhbmQgaXMNCj4gICAg
ZWZmZWN0aXZlbHkgYmVpbmcgd2FzdGVkLg0KPiA1LiBBICd0ZG1yJyBtYXkgY292ZXIgbW9yZSB0
aGFuIG9uZSBOVU1BIG5vZGUuICBJZiB0aGlzIGhhcHBlbnMsIGl0IGlzDQo+ICAgIG9rIHRvIGdl
dCBtZW1vcnkgZnJvbSBhbnkgb2YgdGhvc2Ugbm9kZXMgZm9yIHRoYXQgdGRtcidzIFBBTVQuDQoN
ClJpZ2h0Lg0KDQo+IA0KPiBJJ2QgaW5jbHVkZSB0aGlzIGNvbW1lbnQgb24gdGhlIGxvb3A6DQo+
IA0KPiAJQSBURE1SIG11c3QgY292ZXIgYXQgbGVhc3QgcGFydCBvZiBvbmUgVE1CLiAgVGhhdCBU
TUIgd2lsbCBlbmQNCj4gCWFmdGVyIHRoZSBURE1SIGJlZ2lucy4gIEJ1dCwgdGhhdCBUTUIgbWF5
IGhhdmUgc3RhcnRlZCBiZWZvcmUNCj4gCXRoZSBURE1SLiAgRmluZCB0aGUgbmV4dCAndG1iJyB0
aGF0IF9lbmRzXyBhZnRlciB0aGlzIFRETVINCj4gCWJlZ2lucy4gIElnbm9yZSAndG1iJyBzdGFy
dCBhZGRyZXNzZXMuICBUaGV5IGFyZSBpcnJlbGV2YW50Lg0KDQpUaGFua3MuICBXaWxsIGRvLg0K
DQpIb3dldmVyLCBJIGFtIG5vdCBzdXJlIEkgcXVpdGUgdW5kZXJzdGFuZCAidGhlIG5leHQgJ3Rt
YiciIHBhcnQ/DQoNCj4gDQo+IE1heWJlIGV2ZW4gYSBsaXR0bGUgQVNDSUkgZGlhZ3JhbSBhYm91
dCB0aGUgZGlmZmVyZW50IHRtYiBjb25maWd1cmF0aW9ucw0KPiB0aGF0IHRoaXMgY2FuIGZpbmQ6
DQo+IA0KPiA+IFRETVIxIHwgVERNUjIgfA0KPiAgICB8LS0tdG1iLS0tfAkJCQ0KPiAgICAgICAg
ICAgfHRtYnwNCj4gICAgICAgICAgIHwtLS0tLS10bWItLS0tLS0tfAkJPC0gY2FzZSAzKQ0KPiAg
ICB8LS0tLS0tdG1iLS0tLS0tLXwJCQk8LSBjYXNlIDQNCg0KVGhhbmtzIGZvciB0aGUgZGlhZ3Jh
bSENCg0KQnV0IElJVUMgaXQgc2VlbXMgdGhlIGFib3ZlIGNhc2UgMykgYW5kIDQpIGFyZSBhY3R1
YWxseSBub3QgcG9zc2libGUsIHNpbmNlIHdoZW4NCm9uZSBURE1SIGlzIGNyZWF0ZWQsIGl0J3Mg
ZW5kIGlzIGFsd2F5cyByb3VuZGVkIHVwIHRvIHRoZSBlbmQgb2YgVE1CIGl0IHRyaWVzIHRvDQpj
b3ZlciAodGhlIHJvdW5kZWQtdXAgZW5kIG1heSBjb3ZlciB0aGUgZW50aXJlIG9yIG9ubHkgcGFy
dGlhbCBvZiBvdGhlciBUTUJzLA0KdGhvdWdoKS4NCg0KCQkJMUcJCTJHDQoJVERNUjEJCXwJVERN
UjIJfA0KDQoJfC0tdG1iMS0tfCAgfC0tdG1iMi0tfCAgfC10bWIzLXwNCg0KCW5vZGUgMAkJICAg
ICB8ICBub2RlIDENCg0KPiANCj4gSSdkIGFsc28gaW5jbHVkZSB0aGlzIG9uIHRoZSBmdW5jdGlv
bjoNCj4gDQo+IC8qDQo+ICAqIExvY2F0ZSBhIE5VTUEgbm9kZSB3aGljaCBzaG91bGQgaG9sZCB0
aGUgYWxsb2NhdGlvbiBvZiB0aGUgQHRkbXINCj4gICogUEFNVC4gIFRoaXMgbm9kZSB3aWxsIGhh
dmUgc29tZSBtZW1vcnkgY292ZXJlZCBieSB0aGUgVERNUi4gIFRoZQ0KPiAgKiByZWxhdGl2ZSBh
bW91bnQgb2YgbWVtb3J5IGNvdmVyZWQgaXMgbm90IGNvbnNpZGVyZWQuDQo+ICAqLw0KPiANCj4g
DQoNClRoYW5rcy4gIFdpbGwgZG8uDQoNCg==
