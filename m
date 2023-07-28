Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B797D76692C
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 11:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbjG1JnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 05:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbjG1JnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 05:43:08 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B827B2685;
        Fri, 28 Jul 2023 02:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690537387; x=1722073387;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/hSZj5UJ9fmPHQH5sTacYtOU95Pccwyf4jJ2HLbHY/k=;
  b=EjPL4hf8mSW5GZ5OXRKKhSWLxmDhC0yheX92oqXJMnVRnZdZxAgla7wu
   dU5UC45tEeymrjhuzEzEXnxdD+Qg3NWVvJQ6fVdnfmi9feO0ZGrMDvBUX
   MOD5DihiMgJSJTGV4EFhsiigPJhLfI9QYuv7eB1Xk+5L/l50yCbClfmt8
   MCG1o6iGCcaSBMxyLIxR+53mdsyX67HMJ+mmAmqOlpzwy+Rw/2L96CIBe
   Fjoj2ktxkUBiFIoenzRaDSukkKafaIiBHctGXq+Kipf5QBZuAo2hutv8+
   wg25mH4AsNMj51FLVm5C/NaEbxdCzvmRpUIwUecwVfZ31XnJXLy0OVkh8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="353460827"
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="353460827"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2023 02:43:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="1058079930"
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="1058079930"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2023 02:43:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 02:43:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 28 Jul 2023 02:43:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 28 Jul 2023 02:43:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNBywQlnutw+Biz7OcZsQKg0vnkBHFR+izzk6HLheEcT0F3DzEcl4mi3xleu697L69Q5eV8e+48+vRx34uDXbZUO2RQXLf4KmYopH2cQdhQSyh/+BXPrQrwWGwjwpF5pB7lejettW83fpKfOvH2p46eUO92nomlze4vdAsIKfjQ/ZDbRl/bNELcaRRWXtEdhb4Pto1FD10ttZY0sWtIk8HM/YDDuwlPGSF6biYgUl0frSoPpYx9+zCD9c613vsWdWi4VUxdo/dpQ5SoFMNgqQkw8PmueQYRdD79tkGJQnFCZuUJnoaszuZluXZeFHHI02nXz8zjbJCVoGo7RqtzFcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hSZj5UJ9fmPHQH5sTacYtOU95Pccwyf4jJ2HLbHY/k=;
 b=NFo3tGu8gsTgvRtAYU1iRiCVk9Sh4/5sPbERCeEPDfx6Wmsrn8myLgyVhctAKF8bDqQF9tiaQvXVYVxI6PwYpJJ5Yg2Byxfta94crI+6H5SUuXcf0Co+lwALVpenibishtXJ1VgLYXby3/PB/i0f85rQ1nL3i/YUe9vgvVT4mFvRLd4pv6Onm/gNhPAgwOj/oqzoPXw/B97dikIfFUU4BNg26Jr6lZCp8vg6VJZF0izNYXPRgA5XCNXu5ZfmbQQgC9n+Q+7xmkbKkZvGMjCMj3w5YT73ZaRfCwrccCbP2SoJwNCV6qBHV+Ub00/bZKM1s7bWOD4MidYqCiUziDnILQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5036.namprd11.prod.outlook.com (2603:10b6:806:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 09:43:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 09:43:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Xu, Yilun" <yilun.xu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 10/19] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
Thread-Topic: [PATCH v4 10/19] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
Thread-Index: AQHZvBCsrzEF+eEEUEalrkxHjypjVa/O7eWAgAAJxYA=
Date:   Fri, 28 Jul 2023 09:43:04 +0000
Message-ID: <2c027d5d666eca7d5b4ba31208e72ad6ddb7223c.camel@intel.com>
References: <20230721201859.2307736-1-seanjc@google.com>
         <20230721201859.2307736-11-seanjc@google.com>
         <ZMOFc+RfSuc5I+XB@yilunxu-OptiPlex-7050>
In-Reply-To: <ZMOFc+RfSuc5I+XB@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5036:EE_
x-ms-office365-filtering-correlation-id: 4b762cbd-5ddc-47aa-a4af-08db8f4f0a55
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zKt50vmnrlNOiyCDlgF1mNNVbWa25q/JwVLhMKYStI3ICkp23vlU/hMc+I3HmzeKaIpZVDIFUDtOw+TAb3yl1yPV1PcAhWVIEy9oylhP038zQnp8OqXCMxDvJ12bZoEDX4UpJGV2P2nEuqVgOqboAqWWXQGN2L0CAlw/vejOoVoBUoAeq2NGr3j0WP+i3a9KwWuh76WC6Z+yBUN0mf7BbEzve29Z6V43HonVdkjkxZaWZDUOV+afjf/hiyVwCZgmZk14vewjtMj7q+mzP8ye3c4LD78AAMjljnDuGqAJGtEHkdYzhGGW27ZMA0MF5cJ3uLG3epG9h57Dt2Z4fUFnig1aqiezE7L51dl8COGPfmfvMVodQvC8Rt69NpDX8k0OQWjkXeaUzY/ZFarVQ+9gL++Suyjg2BIPnxhdE5J7J19LPLpKh9K09vBwWPFdDGgW490Y1pvd8W4pdanVkSN2lsQo4nH2DDBifNkROyOtQVRV/cF3nCp8jypeeV4V4t83hovaTiOFTyGHfOFnj94NLy9gLLnDQodcTdSrU7Pk59n5/sZJbBnmlFRDVJwoKWCfR6CnNxA81iz9LKso0AurTq3Ejlun1xNYt/M2lDkatDw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(91956017)(478600001)(54906003)(110136005)(6486002)(6512007)(53546011)(83380400001)(36756003)(38070700005)(86362001)(66446008)(2906002)(66556008)(2616005)(186003)(66476007)(6506007)(71200400001)(26005)(64756008)(66946007)(122000001)(38100700002)(76116006)(82960400001)(316002)(8936002)(4326008)(5660300002)(41300700001)(7416002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dyt0Q1EyT0hFYVZlcEdBWTNTRVgwNXpyZGdkcG9LWlBHMHJFSU1LQ09rUlpP?=
 =?utf-8?B?NUhzdGVseWdjUmlzWWNTRUJkbTNnSFY0TCtZVlpENVQ0K0s1NFBUeU5wWXU2?=
 =?utf-8?B?WVY5N2JLanBGVGx3andGeTRCRFQwMkFYdTJ2RmYwWTMxZHg5ekJVa0FJMVo4?=
 =?utf-8?B?TDBrZXJid1NYSGNlRHJIaC9OcmtraWxnWk8yL2lEbTRWSlFvNENYS3NvRHEz?=
 =?utf-8?B?c3RiN0R3T3lXV1U0YUlzUXdHL2FSa1E5MXQ2RE90cnBMdEt4OTBqZUY4bU9Q?=
 =?utf-8?B?VCtGRXAyN2VRNDdCNHFiU1VtOTY4bEV0ZCt3R3dEYlpFdEZBYUQ1WGlHOGU4?=
 =?utf-8?B?TFRnVzRVMmNPMVJYMys3dm9RdksvVUlOc1U4NjBJVEIvMzVlU205WEhrMnRU?=
 =?utf-8?B?ZFZpMGNTWlJaMkNvd0d4U0lsYkw3TXBIdDFEclFhZkJ3bVd2cmIyOUVrdXZB?=
 =?utf-8?B?bURldUJRNXozcmdHYWp2VXpZeDRIaW81REpHRlVXVFpoNk9zVVYxK1J5VndP?=
 =?utf-8?B?Tk01TjRXWTlPa0x1eUdwM1ZFZVRtRHhjeFNRcjdhUnBCc3dpb1huT2JSRlRs?=
 =?utf-8?B?a3dHSDZaanZZcHM4R1JGUUpySUxVL2RlVzJCQkZLU1VzcEtMOGJZZ3pkc0dk?=
 =?utf-8?B?Um0rZWMyT2MwaHIrSkJuaU96ZGtIbTRyZ3ErdXo3TWQ4blgwYnNrZXV0WVM4?=
 =?utf-8?B?Znp0YzhsMXRqYnVCRC9QRElBU1E2REJYcWlQRVMvcll6K3VJbEhIaDRiRDd0?=
 =?utf-8?B?cHUraFVONjAvTlhOdTBWOFBwQ2ZKQUdBOHBWQlZIMzZNbWFPWUxiVzVwcll5?=
 =?utf-8?B?Y2NFWXFmM29rZkVpR2crbUtBbWw1VzRSTWliekFUa2pyQzJ1TGdlRWNVVjhQ?=
 =?utf-8?B?TkUrZVduTG9QMGswZE9CSWRtVS9OcUJseWNQOHkwWVp3V2I0TFNJYVRqdjJH?=
 =?utf-8?B?Wm9hdmNiSUJFZ21GZy9PSGlGYStScUhFdzRZSzBZaXFGMmRJY0Q3SUU1dUZm?=
 =?utf-8?B?OXllVENmSE9HeEJuTFNXWVBuZnU3RXdmNWtOaVRadG5ncDBrd0ZwMWZVNUxS?=
 =?utf-8?B?V21BODhHTFFvTDdacDlkanZsbTQ2UDZZWlMwUitheGcyYzRDQzIrMWVBc2Z4?=
 =?utf-8?B?dUF4YmJQQVZFV3lOSDYzWk8xYXNpem90Z3ZPcG9xTlRla3hFNlIrM3FWLzRu?=
 =?utf-8?B?THZIOEF2Y1RkQUtaRGVIY2gyQmpLQ0hmMEh4dkFGdHR4QStvbUI2bjZhaFN1?=
 =?utf-8?B?S3EvbHR6bHFqbHdyRStweFRPMFFmZnU4L1VEWnc2aTM3aGJGaDFQZFFkbTN0?=
 =?utf-8?B?V3NBK0pmNUlJYWVVa0RobUxJQUdQK1gxM1ROT2p5NUkvd3I1d0gyVUk0T08r?=
 =?utf-8?B?ek5aNWlJZ3lZZTVLWjljRFRKelZ2OE0vdVhuZjFpdVMwN212ZkFyZTRaQ01p?=
 =?utf-8?B?NEhwVXVDNjZBcHNRcFdLdUtNcUp4QjIyQVNPbWVod3UzRFRVMXNTMTYrQUR5?=
 =?utf-8?B?NG0rViszYkFoMlpLNFU0OTgyMXU2WDA2dkZUOVQyUCtmdUZib0d5UDh6K25E?=
 =?utf-8?B?VklEZUppTUg5MllEc25peVFHS05tWGs5MS9QbEZTVDVaOUV6eXBicnBaL0xM?=
 =?utf-8?B?bUZSNHhuNnZWRnQxTDVKZkJyVjJSbC9SWHg3U0EyVXcvMkpCcVBwWUF1dVky?=
 =?utf-8?B?dkZCa21ZUk1vU2MyVmt2WW1yayt0dVUvdE12ZkN2T2ZhNnZkdnpSRk94OEZz?=
 =?utf-8?B?T1BwV2dQYi9hZUpTQTRQQTd1R2poWWVJUDNtbGk2RS9XeHJCMERzK0gzaktN?=
 =?utf-8?B?QmlpbVFueGRVZnYrN25TNnYzQjJ1UU9HcGVCcVRhSkJxd2pUcUY0ZUFOZ3ZU?=
 =?utf-8?B?ZU1GcTd5c3Nxa1lkdW1ENXRlMCt3YmRlWXgxMDdhNE83SmFlNGdOYjdQQld1?=
 =?utf-8?B?VC9WUmFTLy9scmlFakpJejdocW10QzZkU1EreHRjZTZPVkdIa0p4K2p4NFBp?=
 =?utf-8?B?TkdJNmZFZEhZOWJNTmloV3NrWm9lU2ZEQVJHdGQ5aDJJbEpKblUwRmRuUXlt?=
 =?utf-8?B?aHpyNStZVERUSm51djBIZ3c3NjlUOXBhMTFwVmVhUXNVbkdndHBFZ1Bqbm9t?=
 =?utf-8?Q?57cT9I2ZACcT1jYBgBesdSwA+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69E17135A6CC9D4D8567B0C44E596F11@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b762cbd-5ddc-47aa-a4af-08db8f4f0a55
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 09:43:04.1367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ozCOad7s/pQ1/Y9m8GKHVzbwSUsVPAdJB33mcetxEi3rqMEkQGhZhY16OUHqBodDsTvegIme2OjoZkfFzrswYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5036
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA3LTI4IGF0IDE3OjA4ICswODAwLCBYdSwgWWlsdW4gd3JvdGU6DQo+IE9u
IDIwMjMtMDctMjEgYXQgMTM6MTg6NTAgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gTm93IHRoYXQgVk1YIGlzIGRpc2FibGVkIGluIGVtZXJnZW5jaWVzIHZpYSB0aGUgdmly
dCBjYWxsYmFja3MsIG1vdmUgdGhlDQo+ID4gVk1YT0ZGIGhlbHBlcnMgaW50byBLVk0sIHRoZSBv
bmx5IHJlbWFpbmluZyB1c2VyLg0KPiANCj4gTm90IHN1cmUgaWYgaXQncyB0b28gZWFybHkgdG8g
bWVudGlvbi4NCj4gDQo+IEludGVsIFREWCBDb25uZWN0IGNvdWxkIGJlIGEgZnV0dXJlIHVzZXIs
IGl0IGlzIHRoZSBURFggZXh0ZW5zaW9uIGZvcg0KPiBkZXZpY2Ugc2VjdXJpdHkuIA0KPiANCj4g
VERYIHVzZXMgU0VBTUNBTEwgdG8gaW50ZXJhY3Qgd2l0aCBURFggTW9kdWxlLCBhbmQgU0VBTUNB
TEwgZXhlY3V0aW9uDQo+IHJlcXVpcmVzIFZNWE9OLiBUaGlzIGlzIGFsc28gdHJ1ZSBmb3IgVERY
IENvbm5lY3QuIEJ1dCBURFggQ29ubmVjdA0KPiBjb3ZlcnMgbW9yZSBjb250cm9scyBvdXQgb2Yg
S1ZNIHNjb3BlLCBsaWtlIFBDSSBJREUsIFNQRE0sIElPTU1VLg0KPiBJT1csIG90aGVyIGRyaXZl
ciBtb2R1bGVzIG1heSB1c2UgU0VBTUNBTExzIGFuZCBpbiB0dXJuIHVzZSBWTVhPTi9PRkYNCj4g
Zm9yIFREWCBDb25uZWN0Lg0KPiANCj4gSSdtIHdvbmRlcmluZyBpZiB0aGVuIHdlIHNob3VsZCBh
Z2FpbiBtb3ZlIFZNWE9OL09GRiBoZWxwZXJzIGJhY2sgdG8NCj4gdmlydGV4dC5oDQo+IA0KPiBP
ciwgY291bGQgd2UganVzdCBrZWVwIHZteG9mZiB1bmNoYW5nZWQgbm93Pw0KPiANCg0KSSdkIHNh
eSB3ZSBzaG91bGQganVzdCBwcm9jZWVkIHdpdGggU2VhbidzIHRoaXMgcGF0Y2guICBNb3Zpbmcg
Vk1YT04vVk1YT0ZGIG91dA0KZnJvbSBLVk0gbmVlZHMgYWRkaXRpb25hbCB0aGluZ3MgYmVzaWRl
cyBrZWVwaW5nIHRoZSBiYXNpYyB2bXhvbigpL3ZteG9mZigpDQpmdW5jdGlvbnMgYXQgY29yZS14
ODYgaW4gb3JkZXIgdG8gaGFuZGxlIG11bHRpcGxlIGNhbGxlcnMgZnJvbSBtdWx0aXBsZSBrZXJu
ZWwNCmNvbXBvbmVudHMuICBBbmQgdm14b24oKS92bXhvZmYoKSBhcmVuJ3QgbmVjZXNzYXJ5IHRv
IGJlIGluIHZpcnRleHQuaCBlaXRoZXIsDQpkZXBlbmRpbmcgb24gdGhlIGltcGxlbWVudGF0aW9u
LiAgTGV0J3MgaGFuZGxlIHRoYXQgd2hlbiB3ZSBuZWVkIHRoYXQgaW4gdGhlDQpmdXR1cmUuDQo=
