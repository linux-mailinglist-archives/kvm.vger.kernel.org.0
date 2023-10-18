Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09A27CD479
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 08:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344496AbjJRG13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 02:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjJRG12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 02:27:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2AA9D;
        Tue, 17 Oct 2023 23:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697610446; x=1729146446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DOBRILGZz4Fq6ilwON1PUAUVLLoJoSPI/8evQjoUz9w=;
  b=ecb+SuB4YIM0E1R41EKSmgvMMTTXbrBNixCBL/qn1gcv+Cys5cYY6HNg
   RxUqHYnjK7whxqESofiET9X1ZQnn9URkdbafofOyG+r6bxRTeJd2K2DOr
   I1Hrun6xfkPusG3FXb61ebK0C0mXZf8BBNjaMx+SMwY6OJLp2TBKlwZzm
   SFNkMDrIPo5vDl/ibW+NzI/MfD17cg57e9wtBIOflIR7ZovgudnnesTu5
   fRlSqZCx88W3dTEYevYxEatq5OWu+1P2ZUI+n1B2V9YQgHuLAaU3hz1Ah
   xsY4Z3vpAq5e4qzYWrt9/t0R3kN9520WQ/tl0hL/Nfw2Ab4f6VAqh+Cyk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="450170485"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="450170485"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 23:27:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="900205167"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="900205167"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Oct 2023 23:25:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 17 Oct 2023 23:27:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 17 Oct 2023 23:27:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 17 Oct 2023 23:27:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6GvkP4UT7lT5gfdOxCgIBMFDiGp2F0rf/m4oAfBBouyeItwDbbk+szeu3Hige3vr/O2IMMb1UadCTUUZoAqFcJ8BM01jy6X5QXE1E4NjUj7OyVzFPTEoxswQkoX6mh/aTUJ2b4gvGUXl1Xc9ZNhHyi3WAzcHluXuG2UWNeQLS8MkVPURA0VpOJT+1iClf6ZmrM2kA3boObdjUBPu7wM/YvgSAui1KJQgU5NQ8wiUh+rO51ZI5PYaXt6b/GjGmc0f8lrXBWJrPu/QUNzX6X3wo2rBIhCmFMgzE/c+SXX3zts1EdGDAP6voaiDh9Av1LaR07JruAIyQCwV6SzE3kyNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOBRILGZz4Fq6ilwON1PUAUVLLoJoSPI/8evQjoUz9w=;
 b=CbGBLxppQoULaklk+tjCv4Ze7Z5EuNqYVnTkQRljZk59Ue7GbECtrtYu1/C0/AyYjWDz/CIhwsRCnKRh4/IM6XdArE1G/gbOegpMkrnoa+2zImvfS7MoDxo8pfubecooTZ8SmxdK8HXP7sDXE1MlJGcJOKHBhhpCM4hYt17QP8CxZl3KUr09/aY4TkGkCsK2NPurHkcKFN2bYaUO0cZ9NR+KEhWYGaE6iR0NcY0rGyHNg6OV894lxqSGnKcNa7m3vfCjFYy/zyvQKM8I2ObOsUW899wetTE+PLJLxefUmv52xUUS+qfa4dVsHFsEhSZ6VQyDZGndqf2HnP9/1kp8BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 06:27:16 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::bf64:748c:62e9:852e]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::bf64:748c:62e9:852e%7]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 06:27:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Topic: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Index: AQHaAN//+iiEoA3qq06EP8adX/VyubBN/H4AgAEaAoA=
Date:   Wed, 18 Oct 2023 06:27:14 +0000
Message-ID: <537ad4d3ed653f722c811de86f12d0248136b1dc.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
         <28569cea-4291-4d2c-9662-da19a6f53308@linux.intel.com>
In-Reply-To: <28569cea-4291-4d2c-9662-da19a6f53308@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|SA0PR11MB4525:EE_
x-ms-office365-filtering-correlation-id: 5bea19f1-7bff-4faf-dc16-08dbcfa34573
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C4XBgzEGpM9XQzyxCs1gGxzFdZ4jbCKbO4ZHerwX8Uof0rfQRi1KEKcivuXjAJr3Whp18YP4zBNNDHVwhoVsW4zUCQ51WuyuQCp+AEwfCQSdjWvRQS3eoLsZ6278J6IbjLr3IuXG10zXbv6JkbNAjU4h9cTFEaEHw7Vq2VEX1di58tbJsA08zjAaysOfebEBJuj163DnpnReBi4hSaJO5Zn/XO3QWQR7u1PL5ddnhFGrEsHQdS8ZlmwJI66rle++7ueg0EZV+pEoevYwx6/SykCQrva7r+Yq+S9b5cBEG5p+EvpRA8hgGVSuIujmKSeQvDag9G0qON81plTJCTpDaeNnK49u8vAxAoviiuSKPT+4qkhQtEsLh8cfq6IH72bm5j31AGMQZfNfpGuAiodMDNvXEybaNmMSqDqS3jt+OJYsOjyyQmZaZ9aQGFq94KfSw2OtFXg4fNjD0O2rJ9AHiX6dXd2g745GaoN+dzPB2JeowW/aORzcZUp369wgBA1wEgqWz0xOcgPbfYsQZ08n5Xa8V/3a+g6uYI6zH03RfYyGA4l5i6zvj5BwxhcwcWL+UzcnxpMxkC5FKeZVteMcpcF97z+m8yd7kuuskiaq5Q9ZW7K7c+MVJgpL/KTC5xFo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(366004)(346002)(376002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(6506007)(71200400001)(5660300002)(2906002)(26005)(2616005)(122000001)(38100700002)(82960400001)(86362001)(38070700005)(6512007)(7416002)(66476007)(316002)(478600001)(36756003)(6486002)(66446008)(41300700001)(66556008)(91956017)(110136005)(54906003)(76116006)(64756008)(66946007)(8676002)(8936002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3QxV0hWVGp1WFcxS0R2RTZKS1ZOVmFSVHV0TEtCSFlpRXcyazVHWTBSOFkv?=
 =?utf-8?B?WDNzUWlEMExkZWRLbzh2d0hidmV0UFQ2UTBhLzh6L25kS0kzYm9yZXFuYzFY?=
 =?utf-8?B?ZGE1WWNka0lUd3dFZ2NCeVR5UGtRRURZMWdoYnMyRE9IaDA3RHNWSDhCTHRM?=
 =?utf-8?B?T2Y0VjZpSnVYU2tzeHp0bm5uZjJnZEdyeXRvRmJrR0ltbnZ0cHVzTStQNXBW?=
 =?utf-8?B?UVh5U290WnphZFE5ckIxRHU4VUJvWXBIc2hTa2ZDb0cxZVdibGlXZzgydHpP?=
 =?utf-8?B?N2dJbE5PNmQ1RWpzQnNXdHArTDdqdDIzbW5VaG5TU0lxdnIvc21WaSttTW5S?=
 =?utf-8?B?MkY1SXBObEtRNmNEYTVudDZreVlEc2cvN296MHY2c2ZERmFwZmg1UkRBR3d3?=
 =?utf-8?B?NnhyN0tBL2o2eXI5ODVwWWtzS1dKc0RBVTNEYU9ZT1ZFUkx1V09Dcms4ZklV?=
 =?utf-8?B?ZENZSUZNOHdWQmpUM1J0b1RQWkRLb2ppcjdFdXpPSmMvbjIwSmxweVRjWjdi?=
 =?utf-8?B?UyszMTMxTmxyYUZFUUVTZVd2SnJBbUlGaysvWHVhV1lZY2FyR0JWcVFlVkUw?=
 =?utf-8?B?dWFldWN1KzRQUHdNV2tnQ01TaHhpcUJ0cGcxSmtqcmRJZGxnR2xqMjFwZFQ3?=
 =?utf-8?B?aUlzcThqZERJVmV0WmV6Vy9lOG5pOWdYcVBUelpuenZVTW9XYXJEZVdzYXBI?=
 =?utf-8?B?YUIvaEY2dFhyeXN5V0MrRzB4TWhjUjZ3eHYvUERKOEVFZHVZY2tLMFozamxU?=
 =?utf-8?B?VkhONFRsenFlK2QybGlWWTJ1UlhnWUJQc2RXZWhQV1VFd0RhVVBtdW5tc1Q4?=
 =?utf-8?B?Z2MzN0tpWHRjUWN6UTVvRVJVKzQ3QUZvM2piNWtGS0Z4c25lbkkrekc1MDIz?=
 =?utf-8?B?RytvaEJGMzI4WDlxL3pvVjlyaWF3dFRKb0VsYVdFVHpLUWFhYkRIT0Z0QnlN?=
 =?utf-8?B?cHRvL2UyaE55REo2VUxFQ2xhdlB6K0Q0bTUwazQrN0llSHV3SkVuNlF0TVVP?=
 =?utf-8?B?QjhYZm8xQ3dHblRjaWllb0VYYmJJZ1ZsRWc4MmdQMExqQUJENUw1cmQ1NTBh?=
 =?utf-8?B?THNQOGRnRCt3S3c0dEtkdzlZWnZtZXIxK2hWcHBPaFJHVHhHL0p3Wm9QNmlS?=
 =?utf-8?B?QTZYVU5KaGIrNGY2d1cxVEtXWi95bUVDQkVFMmoxWk9xZW1UekJORXNjWXpy?=
 =?utf-8?B?ZXRnVXp0T1kxOGRxV3FYSnNzeGhkeHB2bStGblA0ci94WHdPSWg3TG9weDBm?=
 =?utf-8?B?aERUUHZ3VE02ODBUdzNzeTRIb21ib0tHYjJHNHl0T1VNWFpoZTJtbXVxM2RP?=
 =?utf-8?B?S2RJU21HWk50b0lJWVd0SFZwSGUrRzJhSFBVOWxlZ2s4YjQ4L0lZWjk5NHdI?=
 =?utf-8?B?VFN2Nk16MVRTUXlLb0hOWGEyUzdudDZjRXJlNmlzdDd6alJ6N2RPdnFRbnhN?=
 =?utf-8?B?bU91N2x6Ti8rV3BvaVk3UHhnZ0RCaWdGVURKSURuUHhoalNYSUpCcFh0NUVv?=
 =?utf-8?B?K3pxTWxwalo1NzN5NVBjTXJoa0tOaHZUbVBHckN4QVR1a0R1V2pGOStVOGNi?=
 =?utf-8?B?dVNGVUlPcEs2Q21CWnFkeHdTQTcrL2h5RGhNK3JoZGpJNmVBbSs4bStKai9M?=
 =?utf-8?B?b2doSTRINFhuL0dCQnQwZG5GZHVNNFZMbDE0SUh3ZThKUytLN2RvWXZhQngr?=
 =?utf-8?B?OEVSdEp6bGs0dVdLN3BZQ1MrZFhDTzhFMVNVOVd2bWhrZTNOTzRQY0tEdHRQ?=
 =?utf-8?B?ZkhnVWtCMU1nTjdQUXhZd3gwV0JESWtPd25Ka0dQQ0g5SjMweSs0K2FxSHZ0?=
 =?utf-8?B?eHU0dHVha3AxN1lmTDgyRDMraDBKNzJFTklCdHZDcXp4eDBjWU93K3NSSFRC?=
 =?utf-8?B?aEswNzBiYnQvNGtnU2V5OEkrUHM3T1Y1ZTB2Uld6OVFENUxhVzJVNkhkVDk0?=
 =?utf-8?B?aDJqNTUwdXE3WS95Y1pRRUl2K0VESG8ydHRycHlzKzArem94M1Q4VFR5bEhk?=
 =?utf-8?B?UTVnQ2Z2bUFGRmdNU1dpb0hDdTBQa1V2TGJZTXZSd0JMWjAvSXhBRURjaFdF?=
 =?utf-8?B?K29yTkxNK1YrYUdBMnlLUk94Q1pOd21SdmFtYUIwbUxnY2VEbU9aVjU3N2lT?=
 =?utf-8?B?LzRmWGRBWlBrZ0NMUis5L084TjhudzVDT3BTUE11Um9CeVNIbjJlMTBhVFhr?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D90F2595422F9542BCE7075F9D04502C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bea19f1-7bff-4faf-dc16-08dbcfa34573
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 06:27:15.4735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIwC47RU6Xi19wF6Na80LoZc0gCT4BV6IVkjEla+wfE/yhuINaY0MaBOfMhdaex263cp6pBhhGYL00RhZhYTUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gIA0KPiA+ICt0eXBlZGVmIHZvaWQgKCpzY19lcnJfZnVuY190KSh1NjQgZm4sIHU2NCBl
cnIsIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpOw0KPiA+ICsNCj4gPiArc3RhdGljIGlu
bGluZSB2b2lkIHNlYW1jYWxsX2Vycih1NjQgZm4sIHU2NCBlcnIsIHN0cnVjdCB0ZHhfbW9kdWxl
X2FyZ3MgKmFyZ3MpDQo+ID4gK3sNCj4gPiArCXByX2VycigiU0VBTUNBTEwgKDB4JWxseCkgZmFp
bGVkOiAweCVsbHhcbiIsIGZuLCBlcnIpOw0KPiA+ICt9DQo+ID4gKw0KPiANCj4gV2h5IHBhc3Mg
YXJncyBoZXJlPw0KDQpJdCBuZWVkcyB0byBiZSBzY19lcnJfZnVuY190IHNvIHRoYXQgaXQgY2Fu
IGJlIHVzZWQgYnkgdGhlIGNvbW1vbiBjb2RlDQpzY19yZXRyeV9wcmVycigpIGJlbG93Lg0KDQo+
IA0KPiA+ICtzdGF0aWMgaW5saW5lIHZvaWQgc2VhbWNhbGxfZXJyX3JldCh1NjQgZm4sIHU2NCBl
cnIsDQo+ID4gKwkJCQkgICAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncykNCj4gPiArew0K
PiA+ICsJc2VhbWNhbGxfZXJyKGZuLCBlcnIsIGFyZ3MpOw0KPiA+ICsJcHJfZXJyKCJSQ1ggMHgl
bGx4IFJEWCAweCVsbHggUjggMHglbGx4IFI5IDB4JWxseCBSMTAgMHglbGx4IFIxMSAweCVsbHhc
biIsDQo+ID4gKwkJCWFyZ3MtPnJjeCwgYXJncy0+cmR4LCBhcmdzLT5yOCwgYXJncy0+cjksDQo+
ID4gKwkJCWFyZ3MtPnIxMCwgYXJncy0+cjExKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGlj
IGlubGluZSB2b2lkIHNlYW1jYWxsX2Vycl9zYXZlZF9yZXQodTY0IGZuLCB1NjQgZXJyLA0KPiA+
ICsJCQkJCSAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncykNCj4gPiArew0KPiA+ICsJc2Vh
bWNhbGxfZXJyX3JldChmbiwgZXJyLCBhcmdzKTsNCj4gPiArCXByX2VycigiUkJYIDB4JWxseCBS
REkgMHglbGx4IFJTSSAweCVsbHggUjEyIDB4JWxseCBSMTMgMHglbGx4IFIxNCAweCVsbHggUjE1
IDB4JWxseFxuIiwNCj4gPiArCQkJYXJncy0+cmJ4LCBhcmdzLT5yZGksIGFyZ3MtPnJzaSwgYXJn
cy0+cjEyLA0KPiA+ICsJCQlhcmdzLT5yMTMsIGFyZ3MtPnIxNCwgYXJncy0+cjE1KTsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSBpbnQgc2NfcmV0cnlfcHJlcnIoc2NfZnVuY190
IGZ1bmMsIHNjX2Vycl9mdW5jX3QgZXJyX2Z1bmMsDQo+ID4gKwkJCQkgdTY0IGZuLCBzdHJ1Y3Qg
dGR4X21vZHVsZV9hcmdzICphcmdzKQ0KPiA+ICt7DQo+ID4gKwl1NjQgc3JldCA9IHNjX3JldHJ5
KGZ1bmMsIGZuLCBhcmdzKTsNCj4gPiArDQo+ID4gKwlpZiAoc3JldCA9PSBURFhfU1VDQ0VTUykN
Cj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4gKwlpZiAoc3JldCA9PSBURFhfU0VBTUNBTExf
Vk1GQUlMSU5WQUxJRCkNCj4gPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKwlpZiAo
c3JldCA9PSBURFhfU0VBTUNBTExfR1ApDQo+ID4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+
ICsNCj4gPiArCWlmIChzcmV0ID09IFREWF9TRUFNQ0FMTF9VRCkNCj4gPiArCQlyZXR1cm4gLUVB
Q0NFUzsNCj4gPiArDQo+ID4gKwllcnJfZnVuYyhmbiwgc3JldCwgYXJncyk7DQo+ID4gKwlyZXR1
cm4gLUVJTzsNCj4gPiArfQ0KPiA+ICsNCj4gPiArI2RlZmluZSBzZWFtY2FsbF9wcmVycihfX2Zu
LCBfX2FyZ3MpCQkJCQkJXA0KPiA+ICsJc2NfcmV0cnlfcHJlcnIoX19zZWFtY2FsbCwgc2VhbWNh
bGxfZXJyLCAoX19mbiksIChfX2FyZ3MpKQ0KPiA+ICsNCj4gPiArI2RlZmluZSBzZWFtY2FsbF9w
cmVycl9yZXQoX19mbiwgX19hcmdzKQkJCQkJXA0KPiA+ICsJc2NfcmV0cnlfcHJlcnIoX19zZWFt
Y2FsbF9yZXQsIHNlYW1jYWxsX2Vycl9yZXQsIChfX2ZuKSwgKF9fYXJncykpDQo+ID4gKw0KPiA+
ICBzdGF0aWMgaW50IF9faW5pdCByZWNvcmRfa2V5aWRfcGFydGl0aW9uaW5nKHUzMiAqdGR4X2tl
eWlkX3N0YXJ0LA0KPiA+ICAJCQkJCSAgICB1MzIgKm5yX3RkeF9rZXlpZHMpDQo+ID4gIHsNCj4g
DQoNCg==
