Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7207634BDC
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiKWA6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbiKWA6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:58:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E13C759B;
        Tue, 22 Nov 2022 16:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669165132; x=1700701132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pbhlLH/fHuq4ETL/akQ8QEeCxMWiyCqa76H1RRN91i8=;
  b=l/aNq2DDn5r2vnXsD3S86qAupQB1PzA2rXJ4LD5TGWgkCXgpI93DvgiX
   6FqrtjP0iFZ50mbnVPqRjX2vPgwUtP/LUr/GTzMC1VAjiczMltfeR/iK5
   KuMnYtmVXlNVCShLHIfa0IGu5KY7O0eLCWRjeUHr9+WGzQRweR2lRumMg
   moQ/QWxCpxv29S4ibj1O2Ng16AoBHohGclonB5uJNmJwRZRTGFBi8D8xG
   56Vr56iSlWoPXWwOOvhiVg1eswmqP3nnBHW1EzVwdFicwYVKko+57Pk6k
   25CD2GpEcHu65Wys/RLi348CJypdjV9MvazfW203gl3gCb3QBnHYTPneo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="294340424"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="294340424"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 16:58:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="705167767"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="705167767"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2022 16:58:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 16:58:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 16:58:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 16:58:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9kLeqCDeGzTsZCMK4+zvsMsTYQTZmHT3QfVT+vpcYdF4AzDtv9fSxqJaCi09uA75Qs26XM8lpG7Ar3RBmQbfUEy02CM20F8a3cccS+jCaXsXNH5/2kLMq9rMghSfqbDYHY+1SrxGg/0IMgEsKq9aKEF9exD9N1j/NS6fd2sa1mdr1Jk213z/tHz2Vq4aqPkcQ9hq1aa6q/4PFmQ8KW6Tf9I1Ik3XiNhvc0L/RRfotL09vszqyHP4rVGb/5FP48AGWnfobah+BwEeW8zDwV953+8/6AUCGJzc0cZF766ACKSdY60RjgvVarf941aZxRuIiUo9CgMuDSRD3YXpja/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbhlLH/fHuq4ETL/akQ8QEeCxMWiyCqa76H1RRN91i8=;
 b=AhYOBngjG0HZ1CWg9pLHCY21hKFoQBVmE1NvdYRdiYAk4Aqq5AHhdsEzWaw1+QLq//vSGA+Z95f85DLWxd/3ygy2RCjLofJccTNd7+ZpDy1H4qLMbFimpX7yOr5YUTsw2dp84Rj0lQEVYNqmzBROp5Yw6mhzHD2mlFWJrUAIpy0CD0oITz6VMrw8KT3eHck//GEWOl8+9IiwPivPqIBj8Kg9hsHSFRsQDbGKDci7KFWzwJ4TnSadxRY0o7Tg27cmqvi3HQ+8lJq/57Z92+zH+isU4KPFPbA1rGAUAx3+ocbH/6P5Bic6HVSAYoCIfprkho6RMsNXxoeMPIuc0m7W+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4630.namprd11.prod.outlook.com (2603:10b6:208:24e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 00:58:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 00:58:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
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
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Topic: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Index: AQHY/T2+AlEdwutNGkW7IAmyyjQDW65KqvAAgABkvgCAAELPgIAAAzIAgABdRgA=
Date:   Wed, 23 Nov 2022 00:58:40 +0000
Message-ID: <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
         <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
         <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
         <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
         <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
In-Reply-To: <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4630:EE_
x-ms-office365-filtering-correlation-id: 0ae315d7-b6b1-4156-39dc-08dacceddc7e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VLheYcbD33jDXnD08IfD9Ylbf5yQYgB9hnzHK/46uGBLhCJMQ+c0eEnW4guRn7JjOwexEmL3ADnC4BuASAliAMdnGfqBOg9Nm+lgtDwdceu4f3RTb+wFoNnkVAqnlXF36LjeJXl6J9rR+3+D8JkZajOJroDwAAavIl37dmlSrirRXA/nVXkq+bDmnYXlPTI1i6ciepiOlTgWxnA7WeE7i6Pw6MDWCbC+Sa8Sy3Q5tY2KohNH8VM+ml5LyvTBPM36c+jknSvChY162eMTm08J+9eFqo/8IVfG+cqDN/lGv03KUqCzSKTSqj2ytVOt3aTQ4ko3c5QYGNYxUetgaxOkiSCNNOxKGFhVueDRsW+JUttSzhT0D3TSqOUK4ZuyAmL1S6y0H5tkgPfu2N46n4V1hOMkp8xgpBLkS2rKEW7EhnHCVdNOucc50mhhJUe3RrooK2S9pYNsVoHRP6dfOYiVd6OtT9ldl2bQHKPsjAFHiaHQcp9iiGUe1+bh62h3cNJMnMaGjioaI/hokNv+8fdtJnArt4RSnrnvYsV5DY2F6D7HI4UxJjHOvxTU1mt34/tIB/Ua0y+frAWLkwd8LZuQHyOntc8FucBuSq7huWZWxLnVtr7KiR7Lhf1V/LX6TLtczoz2qOTNXMSArhpL+TsUocPBV0xhTHkquG8Q0Aj/KDRdl4CcoLk2T12lARjM0DkZ51/Al7a4cr+u6ttWIoZeF1b2JfSpeFVb7y2Sh+3Qg4M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(36756003)(86362001)(186003)(7416002)(5660300002)(4744005)(4001150100001)(2616005)(26005)(6512007)(2906002)(82960400001)(38100700002)(122000001)(91956017)(38070700005)(76116006)(966005)(6486002)(6506007)(71200400001)(66476007)(54906003)(66946007)(66556008)(41300700001)(316002)(8936002)(6636002)(478600001)(4326008)(66446008)(110136005)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmpYSk1NKzgrVnJacXBVN0RPSVJKUzZuVUx5MUhqcWhFcjdqZ3RxRG85N0M5?=
 =?utf-8?B?R2NVSVhFY2pkNkpWbW1EQVZWMXFDNFRXSzQxTWpJd0UreitwVy94U0dQd3ZU?=
 =?utf-8?B?YVk0MFRaMjF0S1V6dFV2VWkwb2FLdTZhWjgwUTlzUE9GRExjY3c5cmZqZWc3?=
 =?utf-8?B?V3crUHdwemczcjBueEpsZm80M0I3SnVvZ2V6dDBtVVp0LzBkemI3R01DSEl5?=
 =?utf-8?B?bkc0RzhZZXlibys3TTBXdlExaTd3T3Zad0NaWExQNWhYa3p6T3NOTHBSOTJ3?=
 =?utf-8?B?MHVsSllteTg1aUV0enhkeTVGNlZKSy9wTmRJVWxHcU5BUG1JMVBNbFB0cnRS?=
 =?utf-8?B?d0JnRE5vSVUzU2NMYzduM2pLN1B1akQ1NFF2Zk41SEhIVXM3eXl0ZG9pem5m?=
 =?utf-8?B?Qll3ejVUZ1lEeXROTVhXMVl6Zk53MjF6ZlkwYTFhdnlqNnVqQjh1U3EvNFJ0?=
 =?utf-8?B?RHRJOVBIOXk3OFN6Q0R6OUNBZXd2VXArb2I1czVJMG1DVEtKNVByeWhQV2lu?=
 =?utf-8?B?OFBMVnU4MWNmWkVBTU9KQmlsQ25FSG5uRnQxd0ExdHUycVkwUjJaV054eU1Q?=
 =?utf-8?B?M09EaERZNDMzZ0piYTZFM2dhL1pWaW5KdzdNdWlVVWk5OTh1Y2xLbHJGcnlJ?=
 =?utf-8?B?bjdxNEpsVWl6MVByc1l4eGgxS2x3MGJYL2ZSeFh3Zkp0TW1DVWtaSGdFSWNt?=
 =?utf-8?B?OEU1S1lPbVdBVjBjN1JhRzc1bitYdjFiNGViSWJTQ3VkaHVIbytZejhINVpl?=
 =?utf-8?B?UXdlQm5iVUMxYVRQNytqWFBRS1J1K2l5MW1RMTNFZFAxRWVScnhZWHBBZW1K?=
 =?utf-8?B?K1ZaQllhVHE5Qk1RcUYxUDBMTGp6TnNPeHoyb1NzV1Jzc3M4RVNqZG1BNjRN?=
 =?utf-8?B?U0hGa1Bhdm42VUZ2dVQ3b24vdlRQRVBLcjYwSVVyMVpiU0ZObjNpb2xtdzVC?=
 =?utf-8?B?OHNlY1RnM0d0VjRqZ25WRnVUbWVSVnkxb1V5K3hKcHB4dFByUENMaVhaL2FB?=
 =?utf-8?B?a2VsT2tCeXh0elQ3VnU3MGQzMUFEemJLV1VJbWRlZkFuWE1FSkdydDJkUHFQ?=
 =?utf-8?B?UzF0bEFablpxT2xzeHZxSTk3eDlNbW5RSlBxY21pd3hsSnlnR0tRSXRpZUk5?=
 =?utf-8?B?NkZxNW1oYklla3ZlazV2bUwrdjF2SFgwbHFmQ2d2L1NrUGl4R0orNHBvWklB?=
 =?utf-8?B?UmxIVkNUTzFlOHhiQU94dURDbmVYUTUzZjFmYXFPWjlsU2ErSXNHd1p0akFn?=
 =?utf-8?B?WnkrTXVTNWRXT2dRKzZCb3A3cTJ5WGR3LzNWbDU0UXN1THVGaVZYNFliUTZV?=
 =?utf-8?B?NGFqNDExcUUyVWVWU1RyQ3dBUXJOdnQ0MTlqclo5N0xvWHVzNkpXMWhVRFJG?=
 =?utf-8?B?Y0FQd1NtOXJsT0Z2TVUxNnk4QnRZTERyb29ld3Q3R3NoVVd6alV6dlNFeGMx?=
 =?utf-8?B?ZkZqNTQ2ZldUR3RHWFdqWndsbk9Qa3E1bTIwQVdhTjhEWEJMbjNRVWtVVkxO?=
 =?utf-8?B?d3lsWkhVQzE1Y2xZOUNGMndBNlFaMy8vbnRTaHdVS0pFcGtINkZqQWFkTjVI?=
 =?utf-8?B?TWRTdks5N21uNGQ5ZFBPQy94ZmhUOG44dUxRd3NuaGZwaXErbjBHcXczTVlT?=
 =?utf-8?B?Y2RORERDTm94N2g1T2t6aGFsNGViOGZ6WTNxU1V6ZmcwWm51OGZsdHAyTzQ4?=
 =?utf-8?B?UVJVQmdncEhSQjB2QytoVUwyaFpPZ003NTg4eTNIODNvejhqZWlDMEg2cksx?=
 =?utf-8?B?L1VXV3lWeDBwYW9XZGpMbExnRWVLd0YvUzVLMEMyZk5xWjhZcFBaT1NoL3lk?=
 =?utf-8?B?ZkpxU2VzZWM0RWVkQlo5L0xKN1lUWFd2T2dCQTc5Qm9HcVNNamJqay9GaE0x?=
 =?utf-8?B?QURlV3ZCSk1oOWhjeWJTM1JDUElWZWE3aFg0d1FLRG11V0hEVEhSRXN5RGlp?=
 =?utf-8?B?Y3U2bjJvQSt2MmI2K0YvUXBTajhVa3Ivc0tzQkdQT3hIZWkvaVk4VDhTMCtI?=
 =?utf-8?B?c1lwL2lXMFdGc1dhSDRmMmxQeTRoMmprVU05U3U5VzRVRGRjb2d4VFNIcE4r?=
 =?utf-8?B?OXV4eWJLRC9ySm5zRzNhUHFxcWtJMU1uV1BNRkNBd0JoczI5UlFLcXM2enk1?=
 =?utf-8?B?RURsZklyT0R1Y0NhNGxZTVNNQ3g1THEzZzRRRUNhRG5qaHhTL1RuTDAySWg4?=
 =?utf-8?B?MkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DA382CE86BCEF44A7C601E44F4A6267@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae315d7-b6b1-4156-39dc-08dacceddc7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 00:58:40.4765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H87ZbWy97LouOPrR42K2mjJQyoQfbjKgfvDUzpp3BC70i8nIoB9geTyLuFAoNIRKF/vqoWGlZyUPmKs+acitFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4630
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDExOjI0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiBJIHdhcyBleHBlY3RpbmcgVERYIHRvIG5vdCBnZXQgaW5pdGlhbGl6ZWQgdW50aWwgdGhlIGZp
cnN0IFREWCB1c2luZyBLVk0NCj4gPiBpbnN0YW5jZSBpcyBjcmVhdGVkLiBBbSBJIHdyb25nPw0K
PiANCj4gSSB3ZW50IGxvb2tpbmcgZm9yIGl0IGluIHRoaXMgc2VyaWVzIHRvIHByb3ZlIHlvdSB3
cm9uZy7CoCBJIGZhaWxlZC7CoCA6KQ0KPiANCj4gdGR4X2VuYWJsZSgpIGlzIGJ1cmllZCBpbiBo
ZXJlIHNvbWV3aGVyZToNCj4gDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9DQUFo
UjVERnJ3UCs1SzhNT3h6NVlLN2pZU2hoYUs0QSsyaDFQaTMxVV85K1orY3otMEFAbWFpbC5nbWFp
bC5jb20vVC8NCj4gDQo+IEkgZG9uJ3QgaGF2ZSB0aGUgcGF0aWVuY2UgdG8gZGlnIGl0IG91dCB0
b2RheSwgc28gSSBndWVzcyB3ZSdsbCBoYXZlIEthaQ0KPiB0ZWxsIHVzLg0KDQpJdCB3aWxsIGJl
IGRvbmUgd2hlbiBLVk0gbW9kdWxlIGlzIGxvYWRlZCwgYnV0IG5vdCB3aGVuIHRoZSBmaXJzdCBU
RFggZ3Vlc3QgaXMNCmNyZWF0ZWQuDQo=
