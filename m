Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB6463B5B6
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 00:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiK1XPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 18:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK1XPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 18:15:02 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358722F022;
        Mon, 28 Nov 2022 15:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669677302; x=1701213302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rUR/OBm0nl4+h59zoiHD2IZoqjGziV8vlMWbyFBnE+U=;
  b=MB0Dh8zS5037IQ5Ixh64UrNY58YBcx3W0OBZG5CjzNzSudu8qDCqaUC9
   GOr0y0X231sCGoMEradtnVMcuPuMMd3suBXmeUlSLCopNYLgsrXWdYHvd
   z7DCwhaN9uzyoV8Ytepj9kqIuwapMOK34iqymhC6ZkWul5Vei94y+nCC2
   LS9m3vEUCr5YEEN4a7LsKORVwsurqRUEJJmzqVnVSw1AFaYt6UzX+Zls1
   UMyQJWWhNX5etFJz+bfHulAshQ1TlEsK5YZFi2QhRy9KfKerSFC4BH0nT
   zeFuldAKWzYO65GETyp/GRfLNSyxRWzKvFJHO5K+JA3hrz5wlKUros4GJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379231044"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379231044"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:15:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732331623"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732331623"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2022 15:15:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:14:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:14:59 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:14:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y41SrJt9DiZLLufNtMYHwR5qO8EE0gNk2EqxE3ngSlgb59SeUIvONNj8Mhyfi9n+xAdiCWoaA/FAn1TXdtoDzk+zLq3ikG976PO+HfFPx50Y0i0sK5jjGwxyXwF8B2k9rrUp0hOTaaTmLokWo/46Mfgg4BLBW/ZjMBXjrarzumtFRctQjBACEWRSWqvIgaq+7gY8tPLg9LGnFezIrrpwIU+G2I/vaLD71J8QNiNX4rbBnTmas+8DqzVXqi/+UzaXlrxe1dt7I2R8JnecByzvlpEiWHlDEz3rZkmK05qWThRLMU5z1ez6JWkOg/cxRJBvaYNOPgQWXjSk42D5XOOZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUR/OBm0nl4+h59zoiHD2IZoqjGziV8vlMWbyFBnE+U=;
 b=Le2GFJx7x9O04PuggJ9ZKF7OSA5IpfWcMdUuOOxrbvyrmXPgSjcVVARIo6C/OxsfXS+1j89F1PSFF4GpVmzYgI5TNEix7BOUbFuk0J7aC+VTwiDb4f89rRdkPmNwDGkwpHq78eFXVTI6ft0rTKqDGDAbG887uJX4hwXp3MZEQlD7M/hFFszEdIUrqezaCrLRiixJJp6GkSZhT3tS22P5+mel33hUwpPGkNhwSEhqjEEwbfqur+KMO9i3RiA9tjkpZHiYGdx/x+1T/4CaN75bIWs5IyaGabr+a2W/Uif5IgxjgxTIcBeMmqc6ZlHf018GBfxbe7WoWGIJ59fuNiTHrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5247.namprd11.prod.outlook.com (2603:10b6:5:38a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:14:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 23:14:56 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHY/T3JgMaJHzs+pUuA6EdKq644U65NI28AgADW5wCABpsagIAAZxuAgAACOwCAAAUygA==
Date:   Mon, 28 Nov 2022 23:14:56 +0000
Message-ID: <2b370efc0bc7803bd5aaacde30fd80ce59606646.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
         <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
         <cceee7b0476437fb18f90a272e2852bdbb2636cc.camel@intel.com>
         <1e45748f-0de1-39aa-7e0f-7596ff813302@intel.com>
         <a68919357982a85252e13626b8d577642fee5beb.camel@intel.com>
         <44e28b2e-833d-4ad3-542d-b2fae41dbf97@intel.com>
In-Reply-To: <44e28b2e-833d-4ad3-542d-b2fae41dbf97@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5247:EE_
x-ms-office365-filtering-correlation-id: c2f452dc-811c-460b-9f86-08dad1965d21
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4l4keqJpEJV+CaJ8mVf2/vHF43CQFtTAq3pYhTBjkEszef/zXjOlQDY1Keje3eBuAHzjmoqFmT3yu0Ww6c5f6TEw/lsv5DgVaMEO7qI8npKcxiYdxjxOIKMbZ0g6y2jkxlE24Hfv0YnkKAc2C7NsKn2jPk2zp0860hcHmGncrKaV+czOhwefUOzsevXkytFnFXeautfqlk7fDDKiV+SA/njEWW90ErY30UyN5rw2lch51C4E1M/fwZ5Le6iFZ9Sd+l228eM0YQ92tCeCHLsOc9dITMqpEBZIeUGee75ZruOwFcXmJw/70XRReQOZ2aXZwLD+ajNDctx+LtU0qyzH1u40bV2Kx/5BKcfB+Wg7oEBDfXKniF3mReDnzopH8NZh6CKseinp7Cd8CkUx2n430LFvgUb9AVGU4kWliT0fVgOHuAmzPhCZ3FqjR2/pdIHfZ7LELeCZYmbk+0uFhXFtmoSAU2rEDuM5xRlNx6yX2QGW+laCIswYzV0ROyjaw2t/nT+eUD+z6ra0wH0XDXNipD/o8aNKmmmTce9yh03oOQuB4wpHURn3Nf9RcbebUyV/wWhd/ZHhE8IIf4Mtr4cAMrJl0hYr/q9ssSsZhyvjNJESHP173rDC/s6rUWZrnB3zGoWCNTD8xhav9eocSOE5o4GNz6asMbZKHffWSDSaqqZ6C4zz9WykEXV5vpwTayi3Olcice8nA68zM3SpbHix3nf9DJiARKuxw84QuB021ls=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199015)(2906002)(122000001)(82960400001)(4001150100001)(41300700001)(7416002)(38070700005)(86362001)(83380400001)(66476007)(76116006)(66556008)(110136005)(66446008)(91956017)(64756008)(54906003)(8676002)(2616005)(316002)(6486002)(66946007)(36756003)(478600001)(38100700002)(71200400001)(4326008)(8936002)(5660300002)(26005)(186003)(6512007)(6506007)(53546011)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1NpU3UrZ1pYT2g0VkZ2V3ZaZFVnS0c4dFFWa0xaVFprYnJYRnQ3YXBKRGdG?=
 =?utf-8?B?ajdkTDEzUXpUWmY2emtIdHdDTjFodk0zRFNMYnVsMVQ4TExHbGkzdUlRNHJD?=
 =?utf-8?B?MitvamVLZERmazRHOUoyQm41WGZkOW5xSDBYbVQwVmo5MUZlT3VYVHFtNGhH?=
 =?utf-8?B?cEd1SkRrVm12Wkc3Wnpvb3pzSUlxWmJSTkl4cGRxQzB0NUVkdXJnVGs4S3Bt?=
 =?utf-8?B?NklndEVRNTlvaE1VZjNWZFhoL0FaY1Z6d0pLVDAxS3dnTnpHeXRDbDZkRytX?=
 =?utf-8?B?a2c4Q2VHOTJRYStsYUxPQnp6UU54L2N5RjdPbXhVYUtuTnJjSVBvZHBvTjdQ?=
 =?utf-8?B?b20xakZ2Z0c1NHRWaDdUNVhMdmtaa2M1SktJSWI5NWFZQlRqZ2tqRmtSdGdp?=
 =?utf-8?B?cVp0eEhLSGxURm1wcE5YWHJhTXhJMDJqMlVpMHV0QzNwNXVxTnBZOXY1bVpJ?=
 =?utf-8?B?QTg3YXVyS1pvQkt3OEhQLzcrd0xsUDY1SGpocm4rS3FDMnBpTEF2VUovVk1J?=
 =?utf-8?B?QzRja3JwUG5FVTgvMHcwUHVGNnlQcmhoR0pNcE1aZmswL1NOTDNvaGhmajlS?=
 =?utf-8?B?OFRWbVFZb0RxZTQ2U3NyWjBBYkdzQURGa2lYOGxBckc3T05BSW1Ia2VHSnhh?=
 =?utf-8?B?SnJVRDRUdkgzRlZ0aU9ESzFLSitpNmpGN1E0TTVsK0lkZjdoVkFkRXhnZzhM?=
 =?utf-8?B?cW1lYWJHYzUzMlMwWjBaS1EwT0xBZ2JwOHJlT3ZNZjZVSHNkMkpqQjhGTmRT?=
 =?utf-8?B?Y0ZZOXlxYnRwOFlGQmw2c2F3NXhmdlU5YVBkV2tldkNMWVBEK3VLTnJ5ZkZC?=
 =?utf-8?B?dmNsTkxTNmVYYklseWZrSlN5ZC9GQnJBQ3N6RCt5SVBLeXNsRTIwaUdlbnhG?=
 =?utf-8?B?Z3ZzZVI2Y1plNWNEcjJMTkRzUjlSeVBSQWhvMzdnUVFpUFdCVmY2TTNJajBr?=
 =?utf-8?B?Ym93N2JoWUhuWUVwTHBBOUdmTTMzVVJhRXVkN1dtTWtSOVZuS2dtamxwWVhu?=
 =?utf-8?B?bHdhTlN5WSt2aTRXMDJOdTRVYWovbHJ5Mkg2ZEMreFpNcGo3NDJrNS95V0c0?=
 =?utf-8?B?OWs0UWFhbmpRQzdVcm1GczIvOWF1K0JmV1pVUW9TcnB4Y1VjZU9hMjZjbGNx?=
 =?utf-8?B?OW9HRjJYSStEaHJLYmVNYnpwMUo2M3NTT2dSSWpQZkVqQTV2cC9oYmRONjJa?=
 =?utf-8?B?TmZjNWwzMkI2STAydDllQ2kwdGJ2eEIxRnIwYTNlVkp4QlJ4T3ozTnBYQW5V?=
 =?utf-8?B?WFRDRWllZmNhbE9RWU1oL25Gbk5pVXpROHBGdjY2NnlsRTF3aExEdTRVdFVX?=
 =?utf-8?B?UUh1YjVFZ2MzeE9rV2dXTDNmVmZzYnhWYkJuY0xad3IvUFFSY1YvSzVYUC9M?=
 =?utf-8?B?dXlmS0trUXk5dUdlWDNsb3ZLOXRiekhaLzB1ejB3cWdhWHhlSFNtdmhocGx2?=
 =?utf-8?B?SzR4UDM4OXo4ZExtVktBWEwrUFVNSTFRVnFqbG9XYVRRd0tveWFvOXRmWEk2?=
 =?utf-8?B?RjJZemI2cElCN3ZXWXJPWDJvanBJNFpzZ2JuOXY4dWN6S2xlYUVYTXRPVXRN?=
 =?utf-8?B?MWI2NG5jWFllVVcwdmRUaDcvalE5M1J1VjR3OTZpTklmR1RBYitYMjJsTGRy?=
 =?utf-8?B?cm9zOXFpRlJ5WWlFK0U2Q29MSzFxTHl5VFRhR2p1cWlCUytCOEQyZnJweEpS?=
 =?utf-8?B?ZmpTNGlHdVZvdVA0Qy9tUzFRUStYRElhc1h6aTk3NlBGNmlFdnNWOE9iZUor?=
 =?utf-8?B?eW1yWG5tZ0RtK0dqdnVDbDVTb2VuTkVCdS80Mi9PS3FsUXRZZ2xNa2tWVDVZ?=
 =?utf-8?B?ZmZyTU5sR1pZbG9uVlJPeGFjT3hyL3owZ2JZQy9KSkRYZmNIUjFnbzhUdWdP?=
 =?utf-8?B?bVR1RFZablZMRjhObGZJcVVEVnhQNDl0aHpJNWdsaUxLckpYU1o2cFIrYXBP?=
 =?utf-8?B?VG5qR0h0b0tZdGwzV1huSElHTnFNanM1Qmt6SWMrVVRQTXpySVhqTHUxWUhp?=
 =?utf-8?B?cmxuZlhqK1hnZHA3V1pONTFKRFM2cnZIcmZsR2c5L2ZSTWloZGs5cDhPbGxn?=
 =?utf-8?B?Q0ppalEwMzJ5SEtuVmJPdlRRSzdsQk1pbWVmbWZTR2huMjNaaHQ3T1BZcUVS?=
 =?utf-8?B?MkdjcWtJK0p1ZVJjRzNNQitzNXR6VmRESStwZEhvRW5qMnJrZ3NGTktMb3Rt?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1053A9E122555640998A2CC2C8C308B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f452dc-811c-460b-9f86-08dad1965d21
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 23:14:56.3818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DeskwLaxaFout0xGWOz11773Ecefc+E6kPNJYJxRrkdVvhqEtw1OtcjYTxllgrojLpmhnLYDg5oJZCkZz1ewjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5247
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDE0OjU2IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzI4LzIyIDE0OjQ4LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gTWF5YmUgZXZlbiBh
IGxpdHRsZSBBU0NJSSBkaWFncmFtIGFib3V0IHRoZSBkaWZmZXJlbnQgdG1iIGNvbmZpZ3VyYXRp
b25zDQo+ID4gPiB0aGF0IHRoaXMgY2FuIGZpbmQ6DQo+ID4gPiANCj4gPiA+ID4gVERNUjEgfCBU
RE1SMiB8DQo+ID4gPiAgICB8LS0tdG1iLS0tfA0KPiA+ID4gICAgICAgICAgIHx0bWJ8DQo+ID4g
PiAgICAgICAgICAgfC0tLS0tLXRtYi0tLS0tLS18ICAgICAgICAgIDwtIGNhc2UgMykNCj4gPiA+
ICAgIHwtLS0tLS10bWItLS0tLS0tfCAgICAgICAgICAgICAgICAgPC0gY2FzZSA0DQo+ID4gVGhh
bmtzIGZvciB0aGUgZGlhZ3JhbSENCj4gPiANCj4gPiBCdXQgSUlVQyBpdCBzZWVtcyB0aGUgYWJv
dmUgY2FzZSAzKSBhbmQgNCkgYXJlIGFjdHVhbGx5IG5vdCBwb3NzaWJsZSwgc2luY2Ugd2hlbg0K
PiA+IG9uZSBURE1SIGlzIGNyZWF0ZWQsIGl0J3MgZW5kIGlzIGFsd2F5cyByb3VuZGVkIHVwIHRv
IHRoZSBlbmQgb2YgVE1CIGl0IHRyaWVzIHRvDQo+ID4gY292ZXIgKHRoZSByb3VuZGVkLXVwIGVu
ZCBtYXkgY292ZXIgdGhlIGVudGlyZSBvciBvbmx5IHBhcnRpYWwgb2Ygb3RoZXIgVE1CcywNCj4g
PiB0aG91Z2gpLg0KPiANCj4gT0ssIGJ1dCBhdCB0aGUgc2FtZSB0aW1lLCB3ZSBzaG91bGRuJ3Qg
KlNUUklDVExZKiBzcGVjaWFsaXplIGV2ZXJ5DQo+IHNpbmdsZSBsaXR0bGUgY2h1bmsgb2YgdGhp
cyBjb2RlIHRvIGJlIGF3YXJlIG9mIGV2ZXJ5IG90aGVyIHRpbnkgbGl0dGxlDQo+IGltcGxlbWVu
dGF0aW9uIGRldGFpbC4NCj4gDQo+IExldCdzIHNheSB0b21vcnJvdydzIGNvZGUgaGFzIGxvdHMg
b2YgVERNUnMgbGVmdCwgYnV0IGZpbGxzIHVwIG9uZQ0KPiBURE1SJ3MgcmVzZXJ2ZWQgYXJlYXMg
YW5kIGhhcyB0byAic3BsaXQiIGl0LiAgV2FudCB0byBiZXQgb24gd2hldGhlciB0aGUNCj4gcGVy
c29uIHRoYXQgYWRkcyB0aGF0IHBhdGNoIHdpbGwgYmUgYWJsZSB0byBmaW5kIHRoaXMgY29kZSBh
bmQgZml4IGl0IHVwPw0KDQpZZWFoIGdvb2QgcG9pbnQuDQoNCj4gDQo+IE9yLCBzYXkgdGhhdCB0
aGUgVERNUiBjcmVhdGlvbiBhbGdvcml0aG0gY2hhbmdlcyBhbmQgdGhleSdyZSBub3QgZG9uZSBp
bg0KPiBvcmRlciBvZiBhc2NlbmRpbmcgcGh5c2ljYWwgYWRkcmVzcy4NCj4gDQo+IFRoaXMgY29k
ZSBhY3R1YWxseSBnZXRzIGVhc2llciBhbmQgbW9yZSBvYnZpb3VzIGlmIHlvdSBpZ25vcmUgdGhl
IG90aGVyDQo+IGRldGFpbHMuDQoNCkFncmVlZC4gIFRoYW5rcy4NCg0KDQo=
