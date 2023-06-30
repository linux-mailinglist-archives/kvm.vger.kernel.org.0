Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5C97438A3
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjF3Jsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjF3Jsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:48:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155C6E57;
        Fri, 30 Jun 2023 02:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688118514; x=1719654514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KFIw+YnxxoYtk9fIgDr9AXU44DB6IXeN/jWq0uWgTFI=;
  b=m1qyKkz24/NUZFfxnKV5JgrKZi/xRkXFJwD6u04e2Qt7fjoCAlsTErQ+
   e+RFtzNgnoZRcXvMYXnOZEUutf7O/8B1ieclDMlQWR4Jg1nCfWgRXL6A8
   LPUmh+9U2iZvZw7bYL5glOnaJ/4VA3xuFKUWrEc1ALxJW3gSsySWRYIz2
   enaG7ppVGAt8x/JjHNuNWfW+1bG/30DsCmIIuBAZT3k3i2JzZWPEicbxq
   W/ZOqLHRo+o0rNV4jdXHib/Rp1nxqmM0TIwRjP4ot8SDas7GNNTOvbmVy
   a79IFB1wQvA1FPT0nOenmqzWWZ66oDLoPhdmphSnoCn5pAa65RfFcO/B2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="448735483"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="448735483"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:48:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="964325780"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="964325780"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2023 02:48:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 02:48:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 02:48:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 02:48:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIniB35hLrRvJGC2UZQQxjYxP5Ge1raK+4yV65WJTFa2COvw6d3dFa+K1kN8Mrdt1lxwP9Ks0MW8DCLQEnE1h8oez7IrXCbBW5g9NOmRaTTeBGiBkEGKvYzg4xsNwX+WVDH/gMxUZRvW6dCSBYoxv8OrgMkXhCP+jFZC3RBJ3XP/h+d79tOTIYiLGHLX7Gh27fojcEAEpA9MQ+FiZa33IJiA8w4/2q6gAV9APvRafbNHwOwMLRGXQBg6GYOhoTQ0xJMCm/JOzZyHhSN19m4BBlJnbN8m5w4LIc4xegkcSgH9PF8J3dM9erMDwDNXweCMtwPpO1pigC4zoAtgqTvGKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFIw+YnxxoYtk9fIgDr9AXU44DB6IXeN/jWq0uWgTFI=;
 b=hW8KtxhFLGFyHTBwaJQ1jEpIkRhKXXg7uxKI0uTR03Z6lx6dsjeGIJNsnm0jv5piJkwf5Gbmp2bF5C+SmzQGnw5FvNvNEH5BgQkgZ6rx8iIvbHgiw+ogYW0Wmh6CJ8UmZPZHAB1HUNMGhBKeEAJmCqBK2RFzBuxQcPl80xcpX0R9jn9Cn3HillXnIa73ikPcTJylMHQtQxpVOaJrQmeDnjpXYJndaeOnvgUkfFgHtGXfIMRbswv6BdiEfkcP3pAy8XyPOPMmmBwpqLzYBn2g9/DACRpSgjrAMZb5YofG0+YDaJwdqxTxrY/lmzzyEiPBKpeBxEdJ1bomsIQiOYQeWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.15; Fri, 30 Jun
 2023 09:48:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 09:48:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gMa2AgAC3Y4CAAjAEgIAABoCA
Date:   Fri, 30 Jun 2023 09:48:23 +0000
Message-ID: <0a51e92e4be15e0c59cd41491f246fed5a1e3615.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628130419.GC2438817@hirez.programming.kicks-ass.net>
         <20322f0432e418eaacfe397aa9363f94ada0b902.camel@intel.com>
         <20230630092503.GC2533791@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630092503.GC2533791@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5029:EE_
x-ms-office365-filtering-correlation-id: 953164ce-d3c7-4a44-b046-08db794f24e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gad2w8Mx1OidipWOLanqjwuTRStqKemLhVqBsQwHyiR5kPj/mdRoZZNaO9Q0tYdaNb6p40mWzMSOl13URP7eczHnAknSUVWXLO+rh0VAz4h6nuBHQBonQa7DrjxWIQsCv4HT1yWOtV+lBcq1gcCEiDF9Jyxo1e1VMFj+RWmd5JQe6MlNIiakCp9Zct7xEPHMwYhI9JasC29lN+TQrYL4VPPEj2fblZkvH4ZnTRLZps1GF7/q/BHeZ4fIdBoNtNgQOfmH2jJJJMcYM6L6YBCXQ8qlXloQmgD9fxZRqYR7mRNvzvc7CecGys4mVH7ms1tX0orWKTPrfV6R8odOUsmnUZpu21yNW0btttWne/gw1vPFhXJWpWyD8wMT5UJ040HveBNGof33c8PU8ttoZsMj5c/PBSnuQMiHhhN7i3HZeOeZqm6ca+MuoEWXQdA9Zs3uyQew/n+0zrb6ityYpOzkXEWZJDWUTKm1r6wDu/98XZifCF5Ky8sxjTWUYVELnZnaziyB+o4yI/ObdrFkNeDvK0EbT3GOaQSz6ictIoHzzNx3NdGmWCmh4mEpj1gdLAwqG0hoJe9dSGDkSLAJguI66gxKoAmMHNbEjGFg49uEvKNFAKqXPBpZl17ts0Cr9Ael
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199021)(5660300002)(54906003)(478600001)(8936002)(41300700001)(8676002)(316002)(6486002)(26005)(186003)(6512007)(6506007)(7416002)(66446008)(66476007)(66556008)(66946007)(64756008)(6916009)(91956017)(76116006)(4326008)(71200400001)(86362001)(83380400001)(2616005)(2906002)(82960400001)(122000001)(38100700002)(36756003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVE3OWFLQjFudEhWTEdqMU5CZVZidVFEazY5Zmw2cTFBcFM0azhwL0pZNCtB?=
 =?utf-8?B?d1ZhejAwMUE0eVVOcmNxNE5VVVdPNzR1RXhBMzdLQ0FaeStOZWR1S2dJUmNj?=
 =?utf-8?B?VHY3aUxPeFZYdGJHNzBRSlZFQ3gzd2FpSW0wL0VldU54WGFRWkEvSmFYc0xI?=
 =?utf-8?B?d1JORTBCUnVFakJmdldXWHhSRncxbkdaeUZUQ1NBMUE0UURIRlZxc09VNUR5?=
 =?utf-8?B?bm4wTXcrNkJ4T1kwRUthLzFoOXNOdUhjbTRIcUhRRlBlTnRjQW5zckowd0h1?=
 =?utf-8?B?VzBKVUFFam9ldHZtRTFWZmRITHpaWWM2NlhYZ0FQN083S3hKYXlrWGxWME9o?=
 =?utf-8?B?T1FQMmZONUttWjRXVko0UjJXOUhHNjQ1RW52Z0N0dFA0WU9lZHl2N2JJSW5O?=
 =?utf-8?B?UFhpOExBdXJVcjFFbXBwd3FQeFh3U0VXSVlobWlaZUtTYzNnbWNzMEh6SzRs?=
 =?utf-8?B?clNFMVhUR1JxU0F2Q0p4NXhCQmxhdmxLQU1MVmFTYzQ4bkVVYUJoMUw4bi82?=
 =?utf-8?B?YllnbmVtVTFaSTQ5MUNzVUQwUFhKdE5kNmVPOFVoOE5OT3cvRmlmZGRENk9l?=
 =?utf-8?B?MTZBZDlDR0k0cjk5VDZKWXFmbFpsNVpleUsxZ1VOYVB3YzJ1QVNocEM1MmRj?=
 =?utf-8?B?aVZQL05JS25Bbk1XVTBLRmtzYmQzbWRRZFA2bkE2OGpacWhRN3J3TkMxcWpp?=
 =?utf-8?B?K1pvZGJsZXdKVXJDdjIwcXYzLzhWUmw1dDk0WG4wY01xNDUrK05kVmV2TW9a?=
 =?utf-8?B?RWVhZzlPUWFOQm95eG44V2UyVEhlcVVvdFRwa3pIQVBhRTRyLzhBUCtpK29P?=
 =?utf-8?B?dy80UHFaZnJVMjlDTFpkUTBhbVpRbDkwMytyd1dwNGFKak81UlNoWWtGcVgv?=
 =?utf-8?B?dWhOaWFSOW9jV0lnWVlpVG80VytpYmR3ckdyVVBYL3IvUmp1dm1UcHFWMzVE?=
 =?utf-8?B?aVpUQkE4ZDAycjNsc3pzUWFEcGtKS3Q3R3JOb2hUU1hXM21nY2xveDd1V2tu?=
 =?utf-8?B?TUJQQmxUM2dlcndLSVYxeGp3Z1NuRTErV0VEM2VsUUU4emhGN3g3ejBvTytw?=
 =?utf-8?B?WGphYWl1Y1lMdnd2T3FKZE9vUitjTDg4bE85dVplZUhMaFRuVURVQnhybk9M?=
 =?utf-8?B?OHdKQ3V2THR4KzVKKzc1S3VRdEdPWWN3SVA3dHZpdWcxUXhKZEdCNmJld1RK?=
 =?utf-8?B?dVdZUU02Wk94M2Q3WVhoMjNKUmllM3FkTjRLNTI5NVBVY2wzQnJKd2ZoMmx6?=
 =?utf-8?B?Lzd5Wm9BMVJZU3pEUW1iWnlGRm56clM1c1NDRHBZazUyMHZmbXd3dHdvK3lx?=
 =?utf-8?B?MHdsUStlMHYzOU1DaS9VOC9qQjNTK2RObllXcy9tbEsvT3QzaTkrd2xEVzdF?=
 =?utf-8?B?QUVHaFNXanBMWWdEcUxqeXBLZG81MDgrYXdEVERJOSttK3h3SU9id3VGWFZJ?=
 =?utf-8?B?RUdnUHJMeGwyR2VtbHdhdGpOekJ1L0lkc2plV2t0Nk4yZUtRMnJseGlVV1NR?=
 =?utf-8?B?QUVYZ0VscnBRRWtzZXczbmpOZVpIREIxVURCVDlQaVNMOHQyRUpvSFN3b3My?=
 =?utf-8?B?RGFqa3d0OTBmbTBadUZHeVBncDU3dHh4di9CYllkTkZ2UWpkZHovV3ZyU2ZL?=
 =?utf-8?B?aXJhK0JlWVAzNkFTV285aUhHSGVRWk0zNTRwRG8yeU5nTTYyWEJ2bWkvdDNE?=
 =?utf-8?B?bHk1VG9QWmVPN2FsanZzSWlhQmYrWmo2Q0pNN1lGZXJpUUt0ZlVWVjJGUFlW?=
 =?utf-8?B?SnVqN1hYYzEwM3FEcU9qQVB2cmwwbGlzTFZDcC9USEpwQ3ZKd2R3UVJ2ZnF0?=
 =?utf-8?B?czZFRWhxUWp3NEl6Q1FkMXdmQnYzRFlQck8vbysxOHptdGxFRmhHK0hBZmRC?=
 =?utf-8?B?WjE3cWdZdmovM1hYTUNBOHVqaTl4RVgzdFROWlNsV20ramNjbzFocytuL0I5?=
 =?utf-8?B?YTRKUHlYU2VwcXJ0eWVDa0p6OE50WmZOVkZOU0hUeDlNZmk3NWR3K2tZQWFm?=
 =?utf-8?B?SUNvZ3p6bGcvMzluMmVUcWNvN1J0R1U4cHRNTW5BUVR5dkxtT0QxTVhMOHBt?=
 =?utf-8?B?M0FuTmtidWJadEVoRnkxVkF0TktTbVdDc3ZmYmtFZEJMQ3ExQzNEOEM3RmE2?=
 =?utf-8?Q?CHHIW4xy6FdiuKuUQsqEwpepv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <617572B92D127C45AC77AD411E9B5919@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953164ce-d3c7-4a44-b046-08db794f24e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 09:48:23.0793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FIBGhpozQI4hZXRCSFSodY35NZFKPmthtVU6TDC2S8XWC2h8T33v/DRM0ErMWHg7f5wgo+cBGQRQ9P4xJLWa8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDExOjI1ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMjksIDIwMjMgYXQgMTI6MDA6NDRBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gVGhlIHNwZWMgc2F5cyBpdCBkb2Vzbid0IGhhdmUgYSBsYXRlbmN5IHJl
cXVpcmVtZW50LCBzbyB0aGVvcmV0aWNhbGx5IGl0IGNvdWxkDQo+ID4gYmUgbG9uZy4gIFNFQU1D
QUxMIGlzIGEgVk1FWElUIHNvIGl0IHdvdWxkIGF0IGxlYXN0IGNvc3QgdGhvdXNhbmRzIG9mIGN5
Y2xlcy4NCj4gDQo+IDotKA0KPiANCj4gPiBJZiByYXdfc3BpbmxvY2sgaXNuJ3QgZGVzaXJlZCwg
SSB0aGluayBJIGNhbiBpbnRyb2R1Y2UgYW5vdGhlciBmdW5jdGlvbiB0byBkbw0KPiA+IHRoaXMg
YW5kIGxldCB0aGUgY2FsbGVyIHRvIGNhbGwgaXQgYmVmb3JlIGNhbGxpbmcgdGR4X2NwdV9lbmFi
bGUoKS4gIEUuZy4sIHdlDQo+ID4gY2FuIGhhdmUgYmVsb3cgZnVuY3Rpb25zOg0KPiA+IA0KPiA+
IDEpIHRkeF9nbG9iYWxfaW5pdCgpCS0+IFRESF9TWVNfSU5JVA0KPiA+IDIpIHRkeF9jcHVfaW5p
dCgpCS0+IFRESF9TWVNfTFBfSU5JVA0KPiA+IDMpIHRkeF9lbmFibGUoKQkJLT4gYWN0dWFsIG1v
ZHVsZSBpbml0aWFsaXphdGlvbg0KPiA+IA0KPiA+IEhvdyBkb2VzIHRoaXMgc291bmQ/DQo+IA0K
PiBBaCwgd2FpdCwgSSBoYWRuJ3QgaGFkIGVub3VnaCB3YWtlLXVwIGp1aWNlLCBpdCdzIHRkeF9n
bG9iYWxfaW5pdCgpIHRoYXQNCj4gZGlkIHRoZSByYXdfc3BpbmxvY2tfdCwgYnV0IHRoYXQgaXNu
J3QgdGhlIElQSSB0aGluZy4NCj4gDQo+IFRoZW4gcGVyaGFwcyBqdXN0IHVzZSBhIG11dGV4IHRv
IHNlcmlhbGl6ZSB0aGluZ3M/DQo+IA0KDQpJbiB0aGUgY3VycmVudCBjb2RlIHllcyBUREhfU1lT
X0lOSVQgaXMgcHJvdGVjdGVkIGJ5IHJhd19zcGlubG9ja190LCBiZWNhdXNlIGl0DQppcyBkb25l
IGluIHRkeF9jcHVfZW5hYmxlKCkuICBJIHRob3VnaHQgdGhpcyBtYWtlcyB0aGUgY2FsbGVyIChL
Vk0pJ3MgbGlmZQ0KZWFzaWVyIGFzIGl0IGRvZXNuJ3QgaGF2ZSB0byBjYWxsIGFuIGFkZGl0aW9u
YWwgdGR4X2dsb2JhbF9pbml0KCkuDQoNCklmIHdlIHB1dCBUREhfU1lTX0lOSVQgdG8gYW4gYWRk
aXRpb25hbCB0ZHhfZ2xvYmFsX2luaXQoKSwgdGhlbiB3ZSBhcmUNCmVzc2VudGlhbGx5IGFza2lu
ZyB0aGUgY2FsbGVyIHRvIGd1YXJhbnRlZSBpdCBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgY2FsbGlu
ZyBhbnkNCnRkeF9jcHVfZW5hYmxlKCkgKG9yIHRkeF9jcHVfaW5pdCgpIGZvciBiZXR0ZXIgbmFt
aW5nKS4gIEJ1dCBpbiB0aGlzIGNhc2Ugd2UNCmRvbid0IG5lZWQgdGhlIHJhd19zcGlubG9jayBh
bnltb3JlIGJlY2F1c2UgaXQncyBjYWxsZXIncyByZXNwb25zaWJpbGl0eSBub3cuDQoNClRoZXkg
Ym90aCBhcmUgbm90IHByb3RlY3RlZCBieSB0aGUgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBt
dXRleCwgb25seQ0KdGR4X2VuYWJsZSgpIGlzLiAgVGhlIGNhbGxlciAoS1ZNKSBpcyBzdXBwb3Nl
ZCB0byBjYWxsIHRkeF9jcHVfZW5hYmxlKCkgZm9yIGFsbA0Kb25saW5lIGNwdXMgdmlhIElQSSBm
dW5jdGlvbiBjYWxsIGJlZm9yZSBjYWxsaW5nIHRkeF9lbmFibGUoKS4NCg0KU28gaWYgdXNpbmcg
cmF3X3NwaW5sb2NrX3QgYXJvdW5kIFRESF9TWVNfSU5JVCBpcyBhIGNvbmNlcm4sIHRoZW4gd2Ug
Y2FuIGdvIHdpdGgNCnRoZSBkZWRpY2F0ZWQgdGR4X2dsb2JhbF9pbml0KCkgZnVuY3Rpb24gb3B0
aW9uLg0KDQpIb3BlIEkndmUgZXhwbGFpbmVkIHRoaXMgY2xlYXJseS4NCg0KDQoNCg0KDQo=
