Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8530979AB56
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 22:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbjIKUrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbjIKMHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:07:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA791F2;
        Mon, 11 Sep 2023 05:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694434062; x=1725970062;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iZN7VkpZPruALT6G5lhKViAco7flR704sgewnF2EG3w=;
  b=XB2QJIYJa7Ra31QFjKtDPw1mtiJzG71swbPRW/zj19dpCslgtI0VqspN
   ZGrLo17G2zC7UuJzkMQdVFDz8+ZuVnvY9lTq+okEUIjXWCSnvkIpSq9sF
   WrAj2zWx6g2vUiSfBqU2PmKrSlQtBgu9duZE1RZw0Q2jUQCiwQeAWGP4Q
   V6XaAgqO2ktZ595FKCc87Ai7uWt1Ed36DS4Ow/uuzJiGYmHYjsL/tdyCt
   85BwD9/wp4g7zhPlg+nXNZPXSNC8x5HmFLk7Njv7YwzH9eIzs1uGEyVto
   3etkzUguwEi2y9UpHUiOlglQD3l9xtb3IpR/DfMczd5Q7fq93eKS3UExe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="444479824"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="444479824"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 05:07:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="719969240"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="719969240"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 05:07:41 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 05:07:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 05:07:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 05:07:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1n6h8jQCICV3TanFGemhgokz9+iBf/Oe6SPHLHz2Z8u0pu1O/sBtPUJP2a++8iSZyS0lP3bJowAbMXdBD1axQSEDszV23ImcqMvM+tVGeNND/I5iy+LEEFi6Tr2p8Aro38rzpdFFvxGK+/YHE9r04gv21zb0bCZQ/ni70ZQFGXhTr0qEnehRDtNiO9oVKoWrXl3btbx9Hhh2FLAq2K48c0oS2xa+cTJWD/1vgJkblZMal0nDvVCajwbZAeor/eXNSvysLmDUnRY0agCF8LjAk9zdXY4k7SQj4OoNKCljNoevoSRhq3533QFx//zCW/fQU2Q63DWnZafx5rz2wrjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZN7VkpZPruALT6G5lhKViAco7flR704sgewnF2EG3w=;
 b=Gp7trQ/WP8SgYdPMKSm+9F0O42FLWlYp3N6JaK797xkZfxlfF8PnJf9I5j0Pa9Tvw6KyNXSnjbLhsXGeibKoOx82BxVk9N01NSTbuvZkhSq4fyIy66ZbSOpoKNHQ6WI4lw61ue2MskhaDme+cDvUqeG68oSBpgbyBOL7ZBuZpOdts132nHPhye8UwwkxzgvfZE3mhIIuJRdOCouRpi3R37u6GICa0bUxKC/fHruvFwcbyOS2kLi4ZDBNeICFVFw74DaICAcDg0jtqUzeQ72v7MCMZJ9dk+vP1oE/ocEQWViooYMonVZw70hnbt36LEJCyYr1sB3gmGznjh9WXKDaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5948.namprd11.prod.outlook.com (2603:10b6:806:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.35; Mon, 11 Sep
 2023 12:07:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 12:07:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
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
Thread-Index: AQHZ101De3tVNeYkQ0yO53WAEnLA0rARNU0AgARtMAA=
Date:   Mon, 11 Sep 2023 12:07:37 +0000
Message-ID: <45ef20780a998ed5900fce8c69b5130c2cf72400.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
         <2f30d181-0747-cd7d-be6a-f19dcd1674f6@intel.com>
In-Reply-To: <2f30d181-0747-cd7d-be6a-f19dcd1674f6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5948:EE_
x-ms-office365-filtering-correlation-id: f164568f-9013-4f21-1de5-08dbb2bfb0b7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jMb3N8jWphPFvwLR0B124vLu5cKWjzg5PSMATOIerm25ylkAU0S5VPfnnOHbRrvAngzaViIWtQdTtXBu2ZVOc7GaXzh2Hy6k02hR4RvqdhunA7xjf0WqQ3uF+PbJohefCU8zkUmfIjLwwQesGrN7Xg/3IIcqLjwZMD13UnRgR7SVdzKh489VqV4IM5rD3kawl/MZ3XH2l+Eb+y/10Xru+TG6mainYp6hlSNtV1UWj0rpl23WSC4tg3pncS2FaN/zOnHORs23xo7yRcj2iLcfj3JvI7FBz4/osKT+KrUq712GQ+pwGriEIIG3X8U8yW5iQj1Ja49279hvwWdp2GhxUKQX/iN+mWo9FSH4XcyjmadT4/Ph2GipfTq2TFE1TbR5AT8KLmWxM/EAfRqTWEuPAh4CiozOXBxfiw3t1kpyZikExeJ9lHS9TMvraTckko4nsQpScoqMuqxdCLcgSsJgiECGjIdyN90vCinJbZATkk7at6JlZvP/ZG0JjpyWvsOJ19FmIFdJo4OiObfPTlZNGXAQnhJtJpPpaAv+FWYixYbrGA21F60cxQ/ppS/bjwa9SJM7SEdHrQJOn+znw21YUXVCSqZ57Add+r5cGjLejFOoXw1n06lZcFeL9wmAysL1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199024)(1800799009)(186009)(66446008)(4326008)(54906003)(64756008)(478600001)(316002)(66476007)(76116006)(8676002)(66556008)(110136005)(91956017)(66946007)(5660300002)(41300700001)(8936002)(7416002)(2906002)(122000001)(83380400001)(38070700005)(82960400001)(38100700002)(26005)(2616005)(86362001)(71200400001)(36756003)(53546011)(6512007)(6506007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGlHbENtZFRLMUhYR0YvSFVKcGJsdzByNElNL2dKaVRGMXlBcGZBTkh5WVdE?=
 =?utf-8?B?b1ZHaTNpSzQ5M2s2cW1aTEp4M3FIdTNsOWY4a25jVFZSRjVSVXhNMEYrLzh5?=
 =?utf-8?B?c0JVVEZZbjU5b3lHTURVVjZJUklJYmRWNFBPNlpaOHJTZlo5RW1pcnc3M0hR?=
 =?utf-8?B?VUFFWjlIcFB3V2xwcGVNKzJFTDVMdlA1aFl4R1F4WmZYcjB4ZmZwZEJHazhE?=
 =?utf-8?B?K3RvaGNTaGVFS3doOERRb3A0NzZuWk4vOFhqRE9wUHVBbE9UbTA5djNpcG5O?=
 =?utf-8?B?YTJjLzFKbFg2WmM0WDRTZWV6RUlvTzhrL2E3TWlWMnRZRVVUbnhZd2NZNVNL?=
 =?utf-8?B?RE15OGlDZGpBc2RnbnRnemVpc0txdFVqYWRHSEFYTVdyRXhaSStUcCtYSnRi?=
 =?utf-8?B?SUg0cWN6RWgwWjJWb1hTTThQZHZqLzRXN0g3SEl2SFphNU5wQW5GZ1QzOGl1?=
 =?utf-8?B?Vm56RDFUUVNKVGZnZ2xCaUpJMXpiRGU4SXRCRGFCYmNjckN1VXhjOUdXMk9J?=
 =?utf-8?B?Y25PSmxuVHRwQVRKVzN3K0h2RVlNY29MOW9aSENWVnArN013b0NHc2wyQ1I3?=
 =?utf-8?B?MHlodEFCV05HMWFjdWROeDkzN01ybU81ZDdWQ0lyMStjbGNIVzVXQzB1YXMr?=
 =?utf-8?B?TTZsR0lxeW54K0Y3a1JFWlNEaVJ2Mkg2cmJNV0RkLzQzNTVnMTM0L252RU1a?=
 =?utf-8?B?NjQ5MUlITnlaWU43NjFtSGVicG9PVG9oY0gwd21UWE1jbFlFa0ZBdE9tVHhw?=
 =?utf-8?B?RzdGZTJXaW03cDB4RS85SVFtempZcHhLRklJRGtMeTVPeHVJM0ZSa21pVkZx?=
 =?utf-8?B?U1NEbWl6dktPQkRlNDJXNkpVclQ5S0NINjN2THlud2FpREhrcjhnNGVndlMw?=
 =?utf-8?B?b3ZqM0M3Uk1OeVB6bS9WK3ZwT0dyTWV4M1UzWmFIaG9XajhIVEFsYW1aMUxa?=
 =?utf-8?B?TktoYmR2UTV0V1VCbEFQZUlrRXczMGV2YjU2Yzl0dVpEV1BCY29VT254VTlF?=
 =?utf-8?B?bVZxU2JKaGVodWd4OU01ME84eklIRE4xQmplQ01UUVdhbmhEbXRxK25nSTc3?=
 =?utf-8?B?a3BST1UvQUlZbFhHSHNwMUY5QmNKRWk2eXhMQXljMWFxQ0E2SXAwbnh4TTJp?=
 =?utf-8?B?UW1BNld6cHpGTTh2eFR2MDZLRUJVSWhUeGowRWs3UGNSWUlaTXB2dFpwY240?=
 =?utf-8?B?b1ZZZUlJempMSjNGQkplYlhINmRvTzZVWlJ5SGRld29sTWNyM3N0UmFlL1Na?=
 =?utf-8?B?emYvYlkyQXp5aTRxQ0pJbjI1TDhBM2VkdjhUTXpTVHQvbmdDTTVXaVVhazk0?=
 =?utf-8?B?QmphVmh1QUp3TGZFMURSSVZ6eXRFMFpqOWxIa2hVNGZyRjRMVXlIZml2MzRG?=
 =?utf-8?B?QnRpZWdIamRrT0c0QkJRa051eFhhY1BNODhWTEpJVk5uMlZZMUhmT3FnajlM?=
 =?utf-8?B?R2pCM2QzdDJGaWQzU2FYMUY3aXpscVVKMS9xRnlXYnkxSVlEMDZrWjlldDBB?=
 =?utf-8?B?TEFSOTNJOWZCQ2tvY201ZnJDUjA0b2VUbExub2Y0Q0ZQOGRwZkZ3Y0lySGgr?=
 =?utf-8?B?dlJNbG9MMGpJSHlHN2Z0NjhCOUowVHhWV0JtVGRmYXVsc0RQUVAzbDNJTE1R?=
 =?utf-8?B?RHk4d2VCTmpOMEpzejNaLzJGc0tQemtaQWdpTDF6RjN1cUl5WEtnZXIzempk?=
 =?utf-8?B?UGRHV3luWVFFMUN5ZTJZV2p6dDliUjZ6dUE4NFBoS1czUHhPTnpGdlVmRlQr?=
 =?utf-8?B?SmxzNSt1UlI1STBIam8rZmtsTTNFZTF4UFlITUJzYmpKdzZrdjNaU1pNWlZv?=
 =?utf-8?B?VGs1dXJkQ0JldnBEVG1zOUZuNElTNnViWUtFeDZUcW9iWmY4Z0tEb2Q5QVVT?=
 =?utf-8?B?YlRFeTUvbk1HRzA5M2h1Y1YvVkRBcFNKVlYwMTVaajJFbFlJck9TU0hPd2ho?=
 =?utf-8?B?aDh5Qm54UHVuNit6Tkx1ZXRDbTVMTXNmQUx3Wmx6SCsxNFp2S1liZ0s2eWFT?=
 =?utf-8?B?QTlnRUNQNis1WWh1R3NjRkE0clBLbCtmLzhrN3BDdjR3ZlBBMzVWcFBWQTc3?=
 =?utf-8?B?dHk3OWVmbW9zWlBsUFNrd01qTlAzcFBXU3ZoaUMxZWszQ0R4ZmJ4cWh6UGVl?=
 =?utf-8?Q?pEHhgeoP2io23nzra1fH28OBb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3537AA8F533D0748A977AA054BE3CAC8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f164568f-9013-4f21-1de5-08dbb2bfb0b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 12:07:37.6104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8owhSPDPk7loVBTg0wjcEpf5awZ4Nv98BwZ9mTnVD0NCrW3PEjspgYCRbqnCIM+ztfQOeJwlm5++jzOhudotiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5948
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTA4IGF0IDA5OjMxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOC8yNS8yMyAwNToxNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ICsjZGVmaW5lIFNFQU1DQUxM
X1BSRVJSKF9fc2VhbWNhbGxfZnVuYywgX19mbiwgX19hcmdzLCBfX3NlYW1jYWxsX2Vycl9mdW5j
KQlcDQo+ID4gKyh7CQkJCQkJCQkJCVwNCj4gPiArCXU2NCBfX19zcmV0ID0gX19TRUFNQ0FMTF9Q
UkVSUihfX3NlYW1jYWxsX2Z1bmMsIF9fZm4sIF9fYXJncywJCVwNCj4gPiArCQkJX19zZWFtY2Fs
bF9lcnJfZnVuYywgcHJfZXJyKTsJCQkJXA0KPiA+ICsJaW50IF9fX3JldDsJCQkJCQkJCVwNCj4g
PiArCQkJCQkJCQkJCVwNCj4gPiArCXN3aXRjaCAoX19fc3JldCkgewkJCQkJCQlcDQo+ID4gKwlj
YXNlIFREWF9TVUNDRVNTOgkJCQkJCQlcDQo+ID4gKwkJX19fcmV0ID0gMDsJCQkJCQkJXA0KPiA+
ICsJCWJyZWFrOwkJCQkJCQkJXA0KPiA+ICsJY2FzZSBURFhfU0VBTUNBTExfVk1GQUlMSU5WQUxJ
RDoJCQkJCVwNCj4gPiArCQlwcl9lcnIoIlNFQU1DQUxMIGZhaWxlZDogVERYIG1vZHVsZSBub3Qg
bG9hZGVkLlxuIik7CQlcDQo+ID4gKwkJX19fcmV0ID0gLUVOT0RFVjsJCQkJCQlcDQo+ID4gKwkJ
YnJlYWs7CQkJCQkJCQlcDQo+ID4gKwljYXNlIFREWF9TRUFNQ0FMTF9HUDoJCQkJCQkJXA0KPiA+
ICsJCXByX2VycigiU0VBTUNBTEwgZmFpbGVkOiBURFggZGlzYWJsZWQgYnkgQklPUy5cbiIpOwkJ
XA0KPiA+ICsJCV9fX3JldCA9IC1FT1BOT1RTVVBQOwkJCQkJCVwNCj4gPiArCQlicmVhazsJCQkJ
CQkJCVwNCj4gPiArCWNhc2UgVERYX1NFQU1DQUxMX1VEOgkJCQkJCQlcDQo+ID4gKwkJcHJfZXJy
KCJTRUFNQ0FMTCBmYWlsZWQ6IENQVSBub3QgaW4gVk1YIG9wZXJhdGlvbi5cbiIpOwkJXA0KPiA+
ICsJCV9fX3JldCA9IC1FQUNDRVM7CQkJCQkJXA0KPiA+ICsJCWJyZWFrOwkJCQkJCQkJXA0KPiA+
ICsJZGVmYXVsdDoJCQkJCQkJCVwNCj4gPiArCQlfX19yZXQgPSAtRUlPOwkJCQkJCQlcDQo+ID4g
Kwl9CQkJCQkJCQkJXA0KPiA+ICsJX19fcmV0OwkJCQkJCQkJCVwNCj4gPiArfSkNCj4gDQo+IEkg
aGF2ZSBubyBjbHVlIHdoZXJlIGFsbCBvZiB0aGlzIGNhbWUgZnJvbSBvciB3aHkgaXQgaXMgbmVj
ZXNzYXJ5IG9yIHdoeQ0KPiBpdCBoYXMgdG8gYmUgbWFjcm9zLiAgSSdtIGp1c3QgdXR0ZXJseSBj
b25mdXNlZC4NCj4gDQo+IEkgd2FzIHJlYWxseSBob3BpbmcgdG8gYmUgYWJsZSB0byBydW4gdGhy
b3VnaCB0aGlzIHNldCBhbmQgZ2V0IGl0IHJlYWR5DQo+IHRvIGJlIG1lcmdlZC4gIEJ1dCBpdCBz
ZWVtcyB0byBzdGlsbCBiZSBzZWVpbmcgYSAqTE9UKiBvZiBjaGFuZ2UuDQo+IFNob3VsZCBJIHdh
aXQgYW5vdGhlciBmZXcgd2Vla3MgZm9yIHRoaXMgdG8gc2V0dGxlIGRvd24gYWdhaW4/DQoNClRo
b3NlIGNoYW5nZXMgYXJlIGR1ZSB0byBTRUFNQ0FMTCBBUEkgY2hhbmdlIGZyb20gdGhlIFREQ0FM
TC9WTUNBTEwvU0VBTUNBTEwNCmFzc2VtYmx5IGNoYW5nZSBwYXRjaHNldC4gIEknbGwgd29yayBp
bnRlcm5hbGx5IHRvIG1ha2UgdGhpcyBzdGFibGUgYXNhcCAoSQ0KdHJpZWQgYmVmb3JlIGJ1dCB3
YXMgc3VnZ2VzdGVkIHRvIHNlbnQgb3V0IHRvIGNvbW11bml0eSBmb3IgZmVlZGJhY2spLg0KDQpB
bHNvIEkgd291bGQgYXBwcmVjaWF0ZSBpZiB5b3UgY291bGQgdGFrZSBhIGxvb2sgYXQgcGF0Y2gg
MTgvMTkgKHdoaWNoIGFyZQ0Kc2VwYXJhdGVkIHNtYWxsIHBhdGNoZXMgZm9yIGJldHRlciByZXZp
ZXcpIGFuZCBwYXRjaCAyMCAocmVzZXQgUEFNVCBpbiBrZXhlYykuDQoNClRoYW5rcyBpbiBhZHZh
bmNlIQ0K
