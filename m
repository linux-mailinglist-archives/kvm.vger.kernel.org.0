Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4437408F7
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 05:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjF1DeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 23:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjF1DeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 23:34:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5F02D74;
        Tue, 27 Jun 2023 20:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687923249; x=1719459249;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f71Rj/bBh2es7YvYn5pr8tyZdTuxpH9ksoz8BlHm29Q=;
  b=dEtQ/FlE5QHr3yMFahz7YUGsCJbvLOPE5D5vBJ33wrbc8N3cdrL7orXH
   087kgSXLH3s7CbfUI15SR5uRR35QQAv8vY0nPwNLu93mITsUFMOOOFkKG
   RSjFufZfpXFaSS+dFcw1o6MLKVciWnf3XC3sOLHp+fsgvI61wDVCN9HMB
   sHtcNMuU8WXeGXgY2pZ09l44eNmFHuJfloZgCVg/T5aaEqGJxQf/O7EkJ
   bb4/ewHS3zaD3IidFEWz59njHkPRZodnrimJxJVsoaohDyat7HKSyVKPl
   2ZH0iJpTTttlTYt0y4gYlBghV7FvilRPB5AchnTPQPkxgfxaBxKuTM96I
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="427745311"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="427745311"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 20:34:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="840914720"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="840914720"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 27 Jun 2023 20:34:09 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 20:34:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 20:34:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 20:34:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgfAUwGa2ACy4iFNK+3yIsN3qpUgglE/37zzduoqfFnKe2PvJVr2Iv371mB6EMkOiZ3My+Xnay7EWyGWQ1Zc0iBqB9dLWD+bRjKFPX/t168PxUpplFIQBNYK+7kEN9z/3N1LBdnic2+xtAP282dPCUlEWIdANAVEM4QoaSHCD41dgr3Z8X54d0WifmoGNzm8/MaRTPsGJwNRATwqnf8Lr7cAakerv1nwa1EynM5EQlelZ+MxgUqZkd8f9g8qwiuPS4NOZEv5d9/3XT1QGinmUe7ksj5n2bJmFZ+imqbbKDo931stNvAxmW4udN/ucoY/cNrNK37HaRZKuqwDKfma2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f71Rj/bBh2es7YvYn5pr8tyZdTuxpH9ksoz8BlHm29Q=;
 b=ael523WhcmxHtAkhOo9qx6clAgI/jFKCKjMnpKrj0CNHc2gYi84y0SBlqrDQ6Qe9wDvinH6uy/B5HTbES46ycGLYR5XNZXGRN4PRdssXjt4+pMUI+iORSTynVgfj10fnRg9bFfpVTMNdw+iSB/YMXW7wHs7/2yjf6lTMCP565SalET5EqLl2TAV/i6irjd1X5EarPQp+q6stMyOy9RTXI8hglSMDSbnHfQYLbtFQxUwpbBTLzDdqQlCmRMm1eHmYFYTk/OGgEbv7TLjHDK8TFWm8kvm97ojySx90huVEaohOTy9qFCee86JzPubp6leyFXhvD8/xlumPIjmYvctQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 28 Jun
 2023 03:34:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 03:34:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZqDWtRkTpkzZfa0qfwqSEOzdd8q+fi4yAgAAGzYA=
Date:   Wed, 28 Jun 2023 03:34:05 +0000
Message-ID: <7c4b54cbbb887a3b7e468819a2cf11f7434674cc.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
         <ZJukd/bnkffgsQzT@chao-email>
In-Reply-To: <ZJukd/bnkffgsQzT@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6059:EE_
x-ms-office365-filtering-correlation-id: b772dfa9-2a44-4abf-0a03-08db77888677
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q33Rv5LdS8CPvKgX3TM7yYm+oblmlppUgoNfN9pE0jvcrynLStL20FZG0X+csavq8lFRDk2C+AmrDPaxHRSiaV8Xr70smtTVPBozwfH9KvaWrBzai9eMYMjJLZfXmLKlxx9oxTKNv2AX4eNUEyOHTAu4ubhG1bz8kA9Ocg/RdycCGMV5tyjygcrv1p7CNdn3ogcKNIvA2NUPsdXFZuJest8UYTeeNxYqzGVBQCr53KDxW2r5a88oeZCTQaDaKn3Z/x4vIiCiw73YiDfBkd5jlBHTQA4w7BwweuI/tSWcyYkLu/0LvzkFz24lcUC6g+6hIuCjepLK2Fx3/HrgD9WL3P2tdoVH+ZSGDwS5NB+ivIDwG8UcbeApG1ah6c61sYarvrYTJZvHyNck6fhmisorckDBG0OGn4GpX1ZvpEjeHXUWqnBHCw4vEOwXPyCe6JD0RP1E5YAzsTlTJPOQdsE281ZT+GC+3C9cf6XnmBOoVmLByctO++qA8kKlmb7pXA3dDXu/FqZSzX+2gackCPWS1wizyL3BbTJQuAfR60GNu5tj7GrQXZyKiIfNpgWDUJ/PEftmzYzalPCzbJav0+XPegJ5VZVKxYLVl9i5oQBkTD0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199021)(36756003)(6506007)(6862004)(122000001)(76116006)(66476007)(5660300002)(86362001)(7416002)(316002)(64756008)(4326008)(66446008)(38070700005)(66556008)(41300700001)(8936002)(38100700002)(6636002)(66946007)(82960400001)(8676002)(91956017)(6486002)(6512007)(2906002)(186003)(26005)(71200400001)(478600001)(83380400001)(37006003)(2616005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmtOU0Roak00NXhTQ24xRXg1TFNTTUMyNkFFb2RidGtuVEtwRGo2eFRRdno1?=
 =?utf-8?B?TEpucmlpNEhnT09HZmxJU2VDdHlUQ0dMK29PeFYrVzU3OW9SUkF1K3ZVVmhI?=
 =?utf-8?B?RTdrSUlHWUdlUURzWS9xSE00Y2F2bGl3T0c2ck1VcjBteVpodXNkMFltaVpY?=
 =?utf-8?B?bGM5MDJBWms5VzZSV25PMit3bWIrem1kM09va0t1VTRNaS9wUmkxNGdHcjh2?=
 =?utf-8?B?Z3hiUGZqMGEzdHcvZjdZVEFxc3llOG5jSk13TWZxSk9DOUJlMTIwa1hZdkNu?=
 =?utf-8?B?TnhyUTROQ1c0YUNERktZZkFma3F3M3NrVFViRGlVUFcrU0Z0RTZEanZVV2dL?=
 =?utf-8?B?ZE05Y3p4SVNhczJBUTZUeC90MVNITkV2QVFkWmxJV3pDUXhkeWVXSHA1MnhK?=
 =?utf-8?B?eCs0YXBwL2VmYXV0TXZPV014Y0U1Q1o3Y05xRWNjVkp6V1cvcEpwL2pZQUl6?=
 =?utf-8?B?N2RDMVoveDdxUjBQSEw5MVA0Z1p3aEljWW9iMmg0N1NOa2JwWUFuZm0xVDBa?=
 =?utf-8?B?MU5DZC9BZTNnNWJZL0FKUlA2bHZqMGtMMnJ2MWNpUzRHTHRIUVIyTHpIdEto?=
 =?utf-8?B?WGFwcE9GMm1CVjJGbm5SeVMrYXFiTUJSN1p4ci96cndCWHo5a3ZqcmJZbWZG?=
 =?utf-8?B?SmlRdlZoRWlkbWdaWXNzd3VzYzFLUW83bkJnZllTTFZHeVR0SlpCNHNrc0JS?=
 =?utf-8?B?a0Nmb1lzdm9WWlNyc01QYk81cW9VcjROMjd0UlQ4VUhLcnMvR0tYTWVuWE96?=
 =?utf-8?B?aDZScHd4M0dSQUplSWxkaXNSL0dGSXlVaklpbWNZNndhait3R20wR2RBQXJk?=
 =?utf-8?B?MUlzNWxPaGFJbEV3eStHMEhWMUIvbzVsSDBBVXNHNy9Qa3NUNWI0UTFtdXVz?=
 =?utf-8?B?VHFsaVhDaERzUytaaHp3M3pTVHpzSzFtb2p4Nk54QVR4dUYwak5MU3FuYVIz?=
 =?utf-8?B?YWRrbmRtb1ZPZXVBVEU1bXgvWmZWWndYa21aZzYycG1NN01UV1JvVXVLTGF2?=
 =?utf-8?B?Nno5dXN6M1NwbnFvS3JnV3dFQXZwSDhFanB0MSt1aWM1NkFCcDU5N3RoZWVC?=
 =?utf-8?B?bFliNk1QVGVCYjRLMUIyaEx1K3UrbE4xNGFzaDVEZFptWkdVbHdpalBFblRJ?=
 =?utf-8?B?RDdKZFhWLzZZa0FLNDZlcVlYY0kzc0lIVDRxS1NRdkduNVN4eXZ6dFJpQ21C?=
 =?utf-8?B?bitwMnBKdkZUZk81Z25hMWNFSkIyR081aU9yNWhsaFRBUnE0d3FKQm1ZeDAr?=
 =?utf-8?B?anFKTFY0VmZCNXcvVzVCMjZ2bGFOWU42eEpHMGUybFdHQkl2eVl3Z21vQ0Q2?=
 =?utf-8?B?RkVEZ2F4ZlRhZFFuY0I5TytYR3ZuTUE4bWtkNGVCRXpZZzNQR1dUOVpnNUFq?=
 =?utf-8?B?dm9uMDV5QytsOVV0TXMwS0RPYW1VeDVEOVcxczRTaFQ5QkpuTlFZQ05Kanhv?=
 =?utf-8?B?dGNvb2pzK3g0QklOcCtBUURLSEpUVTZOUFRmeFRWTDZuUEJYa1NDRWdZL1Nh?=
 =?utf-8?B?L0kvcmRFRTRIRXU0bzJId2tCNFZRYlk5Q1FIOVBtTHl1RnljM2FYcm1ZRGtL?=
 =?utf-8?B?aitqWndBTTk2ZlJBejVFL0JxeTZxMUNBZGhoN0FybUppMFNXdlJObnlyK0VG?=
 =?utf-8?B?c1JRZ0tjK2VjdHNFdVlrNmVwdFovdk0vYm51V00yY3Q4d0JZdTRpdGlvK1VT?=
 =?utf-8?B?NkMyT1B4QkwrWDZqNFBNbWRtakZiT3pVUkhjYXQ5UjUwaS94V09wWkZNT2FN?=
 =?utf-8?B?bWZtelBTSDZodDdoeXUzSURmTllCTnFQNmhxSGtBSnhJL1JHU1UyMGE5RUti?=
 =?utf-8?B?Z3VoRmdheXU2UjdVYzFhb2gzVWVERnk2L3NtcVh0cXd2elpHU2tad2FIV0k4?=
 =?utf-8?B?YkJ0N3JxZkpTTDV1U256Y0ZZaGo0aU1WUEJvNWVWcjdHS3U4dkNFWmNyRi8v?=
 =?utf-8?B?TFg1UGJNa2I0Ry9XNXh2eUo5SSthb3I4S1R3TU0zTEhPQ2lTYkRTK1VyM0Nq?=
 =?utf-8?B?cGZ6SWl0Y1ZqYWp0a3dWN1NjYk9WakZNTVBGWmhIWFo5WnArcGdIWkUvRzdm?=
 =?utf-8?B?RFh2OFZRUSs5d1ZoV0xUYnhPaUIyTmRZMzJGejNLRytBankxZzJiRkpqMitJ?=
 =?utf-8?B?YjZIWDRuaCtGQU03VmVBS3RmMjh5dUg0enl6RExOOHFHUHFaSHp0S1RYUWZJ?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84CF77D04A879F488814ED06E3C98927@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b772dfa9-2a44-4abf-0a03-08db77888677
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 03:34:05.7917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4tGjMKX3JO0ZIRhXeortR6Gq+nwfvhpPJ4tlEeT2i3TsEvZh4KlHM2rW8VX0nzGdZ/K1lpFFxAGmn9fBi9gh1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6059
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDExOjA5ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAr
LyoNCj4gPiArICogV3JhcHBlciBvZiBfX3NlYW1jYWxsKCkgdG8gY29udmVydCBTRUFNQ0FMTCBs
ZWFmIGZ1bmN0aW9uIGVycm9yIGNvZGUNCj4gPiArICogdG8ga2VybmVsIGVycm9yIGNvZGUuICBA
c2VhbWNhbGxfcmV0IGFuZCBAb3V0IGNvbnRhaW4gdGhlIFNFQU1DQUxMDQo+ID4gKyAqIGxlYWYg
ZnVuY3Rpb24gcmV0dXJuIGNvZGUgYW5kIHRoZSBhZGRpdGlvbmFsIG91dHB1dCByZXNwZWN0aXZl
bHkgaWYNCj4gPiArICogbm90IE5VTEwuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IF9fYWx3
YXlzX3VudXNlZCBzZWFtY2FsbCh1NjQgZm4sIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0
DQo+ID4gcjksDQo+ID4gKwkJCQkgICAgdTY0ICpzZWFtY2FsbF9yZXQsDQo+ID4gKwkJCQkgICAg
c3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0ICpvdXQpDQo+ID4gK3sNCj4gPiArCXU2NCBzcmV0Ow0K
PiA+ICsJaW50IGNwdTsNCj4gPiArDQo+ID4gKwkvKiBOZWVkIGEgc3RhYmxlIENQVSBpZCBmb3Ig
cHJpbnRpbmcgZXJyb3IgbWVzc2FnZSAqLw0KPiA+ICsJY3B1ID0gZ2V0X2NwdSgpOw0KPiA+ICsJ
c3JldCA9IF9fc2VhbWNhbGwoZm4sIHJjeCwgcmR4LCByOCwgcjksIG91dCk7DQo+ID4gKwlwdXRf
Y3B1KCk7DQo+ID4gKw0KPiA+ICsJLyogU2F2ZSBTRUFNQ0FMTCByZXR1cm4gY29kZSBpZiB0aGUg
Y2FsbGVyIHdhbnRzIGl0ICovDQo+ID4gKwlpZiAoc2VhbWNhbGxfcmV0KQ0KPiA+ICsJCSpzZWFt
Y2FsbF9yZXQgPSBzcmV0Ow0KPiANCj4gSGkgS2FpLA0KPiANCj4gQWxsIGNhbGxlcnMgaW4gdGhp
cyBzZXJpZXMgcGFzcyBOVUxMIGZvciBzZWFtY2FsbF9yZXQuIEkgYW0gbm8gc3VyZSBpZg0KPiB5
b3Uga2VlcCBpdCBpbnRlbnRpb25hbGx5Lg0KDQpJbiB0aGlzIHNlcmllcyBhbGwgdGhlIGNhbGxl
cnMgZG9lc24ndCBuZWVkIHNlYW1jYWxsX3JldC4NCg0KPiANCj4gPiArDQo+ID4gKwlzd2l0Y2gg
KHNyZXQpIHsNCj4gPiArCWNhc2UgMDoNCj4gPiArCQkvKiBTRUFNQ0FMTCB3YXMgc3VjY2Vzc2Z1
bCAqLw0KPiANCj4gTml0OiBpZiB5b3UgYWRkDQo+IA0KPiAjZGVmaW5lIFREWF9TVUNDRVNTCTAN
Cj4gDQo+IGFuZCBkbw0KPiANCj4gCWNhc2UgVERYX1NVQ0NFU1M6DQo+IAkJcmV0dXJuIDA7DQo+
IA0KPiB0aGVuIHRoZSBjb2RlIGJlY29tZXMgc2VsZi1leHBsYW5hdG9yeS4gaS5lLiwgeW91IGNh
biBkcm9wIHRoZSBjb21tZW50Lg0KDQpJZiB1c2luZyB0aGlzLCBJIGVuZGVkIHVwIHdpdGggYmVs
b3c6DQoNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS90ZHguaA0KQEAgLTIzLDYgKzIzLDggQEANCiAjZGVmaW5lIFREWF9TRUFNQ0FM
TF9HUCAgICAgICAgICAgICAgICAgICAgICAgIChURFhfU1dfRVJST1IgfCBYODZfVFJBUF9HUCkN
CiAjZGVmaW5lIFREWF9TRUFNQ0FMTF9VRCAgICAgICAgICAgICAgICAgICAgICAgIChURFhfU1df
RVJST1IgfCBYODZfVFJBUF9VRCkNCiANCisjZGVmaW5lIFREWF9TVUNDRVNTICAgICAgICAgICAw
DQorDQoNCkhpIEtpcmlsbC9EYXZlL0RhdmlkLA0KDQpBcmUgeW91IGhhcHB5IHdpdGggdGhpcz8N
Cg==
