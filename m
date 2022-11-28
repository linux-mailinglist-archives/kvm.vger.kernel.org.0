Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE6A63A133
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 07:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiK1G2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 01:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiK1G2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 01:28:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D71113D47
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 22:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669616899; x=1701152899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TZXrdohWLB8C2Zodu2Udpu7N2J/oNGsNYJdIAW8M2L0=;
  b=SWeQWGsfUWgg4N37OFYIs9t9THxWvIdUHBgS0iP1XufvNQyBlH2z9S20
   pBWDYbCP0+QNTghw0LaqLNjPc8tEgM229YNNEZ4KEFS9u12mqU4L2z21I
   crJAEru+ExrwE55a0m6+3zh9ohaobnpoK8BGLb6WBlgFQZZqBqXU1N0uj
   djgils4sOY5pEZMZF1uV8Qukus4n/FXVumm+dGKg4zXmx8cDUQbvYT7F2
   XjbdTgKjBsGHQfgfX5WHcO+IO8jGVjnNi+sNTY2+f86PVSQ02+oPraPtW
   bJLroJNTC/DpOJSj55xM9EB8Of417M/X7npJATo+S0Ce1qDpnPa9jQ11C
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="298112245"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="298112245"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 22:28:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="732014272"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="732014272"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Nov 2022 22:28:18 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 27 Nov 2022 22:28:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 27 Nov 2022 22:28:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 27 Nov 2022 22:28:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hb1cr7AN0Xb5Vk+g0A2M0yVDxdXJuPStMz9/Fx5BSPNiSDQrmFB+vH73MpqZ/gMq7eioI8sZtkxXrOdzN8Fmh4on7JRuayAJmk2mxGocADlUIWJWIAdSuu0ELAemdCzjzObUPbDxCsM+Jmf/++e/XcYj2pKaGGQr+Te0hykN00YYIISsfq+df7SQF7GJlNTSHYjeH9612VaZWzquvoJlV34Ww/6AOeJVFIDLFHpCc6VQTyEvOzqaUI8DajRfn8wD857lssyn423g/NaCIw3yuR7/LzgkU8uiEIFaKti9p/jreLZuffmDSj6VabDsJ7AsOBLzsFpNKYrc31r5XFV5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZXrdohWLB8C2Zodu2Udpu7N2J/oNGsNYJdIAW8M2L0=;
 b=AjywqZ6UCRTDLXdFCO7cMzmb7uGefSclbH+8Smj26GL//nvPpTmp8fV8CEHV1cWXH2idlmL8PO2IbgjkU/0rbsB+/En9veVxQLzbI0Kfjnzu5/huTS3onH4J43wQ0hC2DDCI4E4rRd5Ww9Jdzrhhr8FMIYEJtZ2daOGC4OonySLdkS2XTEJqz7OpnMJ5uTit5glsHmiGg59CUg0K5Y0/VXV42xT+KO5ChFezfJ6H+5be7PSvsEv2ng3FRpIBinLixYb2shtRsDwwP1qAaFwSj7OMtOTY84Kyqww6C/O9ylcuFWDliq54VxfZ4Bch4L0okyCyfM8SbHGL8GwzEXnkxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6682.namprd11.prod.outlook.com (2603:10b6:510:1c5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 06:28:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 06:28:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Thread-Topic: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Thread-Index: AQHY/0JMhkbhTD2JSU2Keq3HK6Y9aa5No5aQgAAoaACAAV0bAIAAMtSAgASJ1XA=
Date:   Mon, 28 Nov 2022 06:28:15 +0000
Message-ID: <BN9PR11MB527629460DB4436B2ECBAFD08C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
 <BN9PR11MB5276413337536E76B2B0DA0E8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <39bcd0d8-17c1-79d0-ed9e-123dacbd4b63@intel.com>
 <20221125060442.GV30028@zhen-hp.sh.intel.com>
 <9319ead4-e67f-a566-df12-10b146901c98@intel.com>
In-Reply-To: <9319ead4-e67f-a566-df12-10b146901c98@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6682:EE_
x-ms-office365-filtering-correlation-id: 07e669d2-a9ec-4388-3ca2-08dad109bb3a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uc4sWmYGN17I7hmKXVMu2eXJu0J6QhtXu7jbU8UBuYi9/4S8CoEWkccUkt81nD4zu76WLOHsNCebt2F/6LUUqbj7QjUx5royHe5BpyqP8/xzY4/vJHzaToIAJ2gt4SnU0wvxrUW0KQMDGHXn1WrgtDOmjsMAWbn39ztcClIqhU9vTp/hTz2UtTXLqOJmGbGHRIh/98Kqxfspj73w/IOED4FLYOARPf8EgqxgidaOhIagGCqhDWCJZhLUqV2i1XwgvARpu4mVACngrYccSGzWeYJRAAVp/8543Pdq4h9AtBGkeGvUUiwgwEDF89u1ANlI4AstmMMzzSy22VOF6LH78O7B99aaxZHO5UP4zb6PVbfngrrVIwykrsiTi8AHX/8zb46BJg2sZbeEXPy2pH9Q3/NEkctiOT4XkOpRSBW9hwFIYLrBA7C/VDPssKK1XHaPINAnoIXrLvtOcTLP+tuhcOdE59z//PrcvA/ag2C+Gg4lZcR1Xmq5agmrcO4wVzMhrj72/TX8j12epHX7bdpmphPVfziZTC19oWPAqY3LEv8QeDuyKIIZ4MWXUQY7f7z5nvbLBL+JLXZdCrT9wJ5Vf/fl4qkUdZZuH577l6YN4bH4gwlyb/27RlA23LjNXJ3xczQRYq8rxxAbsNS8a0xatGQt9qESEu/4Ya3I1EaBslsBR1o+995nrnIKKUUxKBXTC+XW8qLetfmzVu2s5+eWqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199015)(122000001)(52536014)(4744005)(8936002)(2906002)(33656002)(55016003)(86362001)(38070700005)(316002)(186003)(478600001)(38100700002)(82960400001)(5660300002)(66556008)(76116006)(66946007)(54906003)(41300700001)(4326008)(7696005)(83380400001)(9686003)(64756008)(110136005)(26005)(6506007)(8676002)(66476007)(66446008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZS9oYnJtanZpOFRoSmtGRnJONjU0cHlJS0FXOHJRVlpOT254Vk0ycko3RTVk?=
 =?utf-8?B?aVlUR3NsRFQ1NVBOUGV0Q2NTRDlFL3FlelVXQmdxbWs1V0wvc2FqOTZhT2xX?=
 =?utf-8?B?VmpOclRPMzl6cUZ5N0xsN2pSWVlTTnQ5L0JSbmNMYlp5WUd5Z0J0WXMvZy9G?=
 =?utf-8?B?dHlTUC94SUhOb3lFeUVOQmhPdVpoSlFCNzhtL1JtMXJxNnBJa0MwWk1vajJl?=
 =?utf-8?B?TEtyUFQvVWFnTXlmNnRkVS9BSzZHejliS3FaN1F6TW1pbnFLakNsbk9CUmFC?=
 =?utf-8?B?Qjk0YjdyWERaWGV6UmFVOHJsVHZDd3RPbDdrZTZ0NnN4Tjg4SzNwbm1TVVl6?=
 =?utf-8?B?bWE2OVJMSWo4Ry9wRkliQ0lmTlJuVFIxRnpuKzJzMkIyMUh5TmhTcDhIYXZq?=
 =?utf-8?B?aFI2OTFVMWVLWFFJd0hJaGtENkp2QWJQLytQVlR4MTFOTlYwR2tjekYzV1hU?=
 =?utf-8?B?N3duNlBKRVUrSDZzckpLWmh3T3NtQ1NyN2xXZHdUNTZjZFlEL2p6ZHFlenRO?=
 =?utf-8?B?NUV5Vit3dTl4UE52S0pkbHNtMHgyd2htVU9CMjBOWHpZNzFlSEJzNG1CT09h?=
 =?utf-8?B?S1FaRlpOTGdHZDE0aDBaRDlFYjZmSmJ0UHIza0ltU0dVNVlOUjlOeUhyZVlp?=
 =?utf-8?B?d2k1OGVSUlhOc3NkZkozMDBBbktVZDU4TlZMeTRaUkM0b1FRRVNBUDQzY0tj?=
 =?utf-8?B?T052S04vQ1c3eGt5d0JIWmwvV2lQWThUSnYzZnlLL3lRUk56d0FZcXpUbkQv?=
 =?utf-8?B?K2wvZWo1Z3cvQjl4OGFRK0VsejNLbms2K2NXMHA2TmdkdXlzN2Z2M0R0UDhj?=
 =?utf-8?B?YkN0cEx5eG1xdDNoR1RxQTRzZlpjN1paWHQ1RHlUMnUrSEhBaXZxZVQwN25M?=
 =?utf-8?B?RlZqNnpxUDVpS3lSMHAyQTJnbGJWcVNlU1Y0TUwveFBkMHU4RUdsM0pYRnpH?=
 =?utf-8?B?Q3pJcjVrWGQrQWhuWEcrR3YyeWdnZVA0S3VOcklOWXhIMTBTMjB2cXJPbXVJ?=
 =?utf-8?B?NnVmZXI2Tjd1YjFVcVJyWDFrR2dHOENQVzBBYkk2MXY1Q1RLRTExSFZqbGdj?=
 =?utf-8?B?UFhobmJ2UTVybkRnWmd4Y1A0L0lkeFhtMzZSMjBUQ3EvWXJpeG03UjZ1ZUdD?=
 =?utf-8?B?YWxpamxFSTcwSGVCOC9nVjBpaEhXZFJQRkJFQjEyd21KTXVCK1dLaDFmcVJE?=
 =?utf-8?B?Y0RWZjlRZ3luNjEveGpSSlRGQ2gzL2dMb3kvbDhiNldZeWtEdGxvWmhiVm9v?=
 =?utf-8?B?TitSeDBJcm1TQ1VZYVIyK0VOWmkwQUYydGNKYTc1VVN6cy9SNUt6YmtZN3FM?=
 =?utf-8?B?amlna21GNnd2Ky9FaXNEY0g1ZTRZK1dvQjZPUHhNMHQyRTNMcU1aWFNjTGV0?=
 =?utf-8?B?NWsvd3VpdHJSb3ZqWE1vOWtOZWVGeUEwc1E1S0ZpUnAwUGs3SnNQUU5jalll?=
 =?utf-8?B?U3FTU1pKRGxmLy9IdUVxRHJDdmJNa2h2bEttTFgxa241dDlndW04UWFUMXJk?=
 =?utf-8?B?M0tqZXl5WFBJRS8vUWk1QjMzR1B3YnhZcXhKekpiYzh1SUNDeUROMHhiMVQx?=
 =?utf-8?B?aE53Z2Z1K0ZmR1lEWHI5QjBQUThtdzlVZ093eS8yYWVnNzFzbzJHb2FWRXFE?=
 =?utf-8?B?U1lyUzYvbGRJWXpjejczak9YZU55V1FORzU3VzRNNERTVlVMQXZ2SGxmVDF3?=
 =?utf-8?B?akF1RHY0QlVqTDZKWk9mOEowZUtNODlZQS9ybFZuVGRBYnFrQkFGSWVyMncx?=
 =?utf-8?B?eG5KZ2dkVDdiRXhhTXlrYWowU1RGNkd1NnJ0S2I5RmtDUXllQVFEWkZaRkJ3?=
 =?utf-8?B?SFhtYWVxNjcvbmtKOW1hcFVGdllFOUJlbVEzcTRCclpoL1h6UnRMTXF3VWdJ?=
 =?utf-8?B?QVhlRFNQNDRsSlB0ZFJSdDZ3dlROQTFPNEdaRDQySXNrU09xV25iWGtuNzFB?=
 =?utf-8?B?SDJ0TVRGd0E1YWlndXF0dFNBQmwvU3Y4cGFDQW9kazZJd0lvQit4VDBCS3ZW?=
 =?utf-8?B?RHJ1Y0pDa1dpdTduN1BXWWI4eVpUVjdKK1VVY3YxNm9LcTBmNC95K1l2ZjlS?=
 =?utf-8?B?VzBCUjBvQUNmenNKUG5VcWE2UGM0U2x0U0hRSzN2a3J4b0orT1BQanA5cStM?=
 =?utf-8?Q?ZJUNe7DK8wCYjfAWsZB4m7srh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e669d2-a9ec-4388-3ca2-08dad109bb3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 06:28:15.1788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I7GzoGDzuCmpAvTA2BC7BEWsZpL5020BzPWpi5kQ205wVP9zuRrxOaasEeHcw1LYJaRCO1tZdmRI0dbESvQ7RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6682
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBO
b3ZlbWJlciAyNSwgMjAyMiA1OjA3IFBNDQo+ID4NCj4gPiBDdXJyZW50IGd2dCBpbnRlcm5hbCBj
YWNoZSBpcyBoYW5kbGVkIHdpdGggLm9wZW5fZGV2aWNlKCkNCj4gYW5kIC5jbG9zZV9kZXZpY2Uo
KSBwYWlyLA0KPiA+IHNvIHRob3NlIGludGVybmFsIGNhY2hlIGlzIG5vdyByZS1pbml0aWFsaXpl
ZCBmb3IgZWFjaCBkZXZpY2Ugc2Vzc2lvbiwgaG93IGlzDQo+IHRoYXQNCj4gPiBoYW5kbGVkIGZv
ciBpb21tdWZkPyBMb29rcyB0aGF0J3MgbWlzc2VkIGluIHRoaXMgcGF0Y2guLg0KPiANCj4geW91
IGFyZSByaWdodC4gSSBub3RpY2VkIGJlbG93IHR3byBoZWxwZXJzIGFyZSB1c2VkIHRvIGRlc3Ry
b3kuIEhvd2V2ZXIsDQo+IHRoZSBjb2RlIHNlZW1zIHRvIGJlIG1vcmUgY2xlYXIgdGhlIGludGVy
bmFsIGNhY2hlLiBTbyBzZWVtcyBubyBuZWVkIHRvDQo+IHJlLWluaXRpYWxpemUuIEknbSBubyBl
eHBlcnQgaGVyZS4gOikNCj4gDQo+IGd2dF9jYWNoZV9kZXN0cm95KCkNCj4ga3ZtZ3RfcHJvdGVj
dF90YWJsZV9kZXN0cm95KCkNCj4gDQoNCkl0J3MgY29tbW9uIHByYWN0aWNlIHRvIGhhdmUgaW5p
dCBpbiB0aGUgcHJvYmUgcGF0aCBhbmQgdGhlbiBkbyB0aGUNCmhvdXNla2VlcGluZyBpbiB0aGUg
Y2xvc2UgcGF0aC4NCg0KUmUtaW5pdCBpbiBldmVyeSBvcGVuIGlzIHVubmVjZXNzYXJ5Lg0K
