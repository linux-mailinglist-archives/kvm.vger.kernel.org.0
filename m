Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD7C6E09D2
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 11:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDMJNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 05:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDMJNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 05:13:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF12F10EC
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 02:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681377198; x=1712913198;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zdw7ts1S1i6y51C54E+3UhwAZNnj2MJ3gsVG1DgFb8Q=;
  b=myMmV8gWohy6wIoIqvKJVftEUYMTBpEYFXoFir50tG3QL6ReYyU28vFu
   umQTZ0nBt8m0aWm7HWOIFpX0gTuTBZ4DAg6RAItqV1DxfiBzF2ptH0+Ji
   A6t0IvnLHzbiaz/jQ5p9g2W8rtGnwkl7nhbh4SwyMJWhl+8sg4tewTjen
   qMyZMWxreYTWLSJgGYWDOK8o/2V0Dz9XWkvNot3D7NtAxEPR0ZnnEd1Ko
   2hc4SK8Iez8Z/Xa8POm5rmOyAIeEk5tKDdAYlLx4u+7pXe2pxeDNfrlb7
   aQgV11iVmadhx/zBOs8HD6oUh15NSSY6KKxEjD/0FpOf2eD6vgVUmErQ0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="346815493"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="346815493"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 02:13:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="689256379"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="689256379"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 13 Apr 2023 02:13:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 02:13:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 02:13:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 02:13:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZyPs/eSZjOoKk8evEEDUg87oDD2s/Ih5ZLfFuhz4ScDth8QRTCZs3cDpQnswIwul7u7hGUIMsDUwxIxt92G23BNFkTNo3M8LuoJDXlg21V/szfDluoZ7jFV2ewdsmSTGJ0+duoGG7KQGhhL73Q5vJbS6NJoqazW/ls6A8tU2LZXzjq8/S3jtME1lwTe+kMtgN0ehtRHU9qCiYijYWE1dVDX6URe8R55QQgVryiAikCmJRSQkdVVivN09NI6bl/HqB4xjDLYo73Pu0VT3mdBUbMJMcLFWoGw4lckgNX2yhWaf4sMBbyRp/mTaShAVvUMzr0WMiqfk+wpti5CEw/UUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdw7ts1S1i6y51C54E+3UhwAZNnj2MJ3gsVG1DgFb8Q=;
 b=es/0+dFSxvkzyNFHNq/iZudY04MkLYoVKYO9Yhwtty5OINQkqHX6vr6g5im+ZjKG/Jxl++YTT5+bfzqi3NrvavPMmvfqdzv4U4sMXhLwgTmFHwyZv5EqhPz2D1BedwmPhQlt8I9OGF2KqgSHO1qjc0lUf7UsifCw+sMb5QvdDO+qcbd5YTRzZv45zZwDNzEim0ylQnwIE/ZT14J5zefDrdHd+qdLUc4OahSvpTIqZ1gO/bMYnphwLEIzFPQsvmdvQWRWqbgXAdpOzJXAUUut0y3WrlvtPhQNO4WUYzkxvMAoykqPX5KuiMC58qTNB4RlLuLOmv/VO+SINPRN2eSK6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8092.namprd11.prod.outlook.com (2603:10b6:8:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 09:13:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Thu, 13 Apr 2023
 09:13:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: RE: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWA=
Date:   Thu, 13 Apr 2023 09:13:14 +0000
Message-ID: <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
In-Reply-To: <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8092:EE_
x-ms-office365-filtering-correlation-id: eb016cf0-8407-4f18-d8bf-08db3bff4fdd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: laUJ5acFQ3TC0B+39crdYQVtztmVS2zZwa/P57VwUqUNWa9LoVTruBKx/qoYGWG0f3qQ4O2nkHguBdjrwRIshu3x1EQ8UIvRS3qGsetknRe6DRwjwKGX1SaeO3d2LnQ0WDFzdeoUwiugZY5IaXSt0QIp8Ay0ZmxiTmo34bpIXT4QnajRpLvUBhAzGoyk3IKftmBBRyJtQlH4NWzKAAaAbYR6LFOl1f/EwpiWP50W1nZ28x9PQyVKyGFDEXYvOCod+VxIdli07PRRu9ro97A2TnSYbtMBjjGbZpSXVmKIepAQMCeOuyMp54dtr+UZxlhbnFvdV/8apToQLnkNpOtuh1sI9UxSFWsosdLqrht3niIbWgUr6QvrLtgb5xhykhF4IinCgvmsDPO7iL9SXom98cb9VRWnFcOMOoCOeWdgGm3lBYBXzyEygW0MUWOAK7jidJ8kyG/USWawjtufkeO1mvJoxWH3Le/1wA6hmzumweBqQtId0fRX75WnARellS2Sazi90mPij/nCF4UJYiC2MQuYYRhUID9k8wreIzaILxmXCNLf+lKE85cfMl6lG7vELRGaSqnQnnZyfuf9D1e/NSe7ra5qhsztGl5Yg+zOa5U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(71200400001)(7696005)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(76116006)(110136005)(2906002)(38070700005)(86362001)(122000001)(41300700001)(82960400001)(33656002)(5660300002)(52536014)(8676002)(8936002)(316002)(38100700002)(478600001)(55016003)(54906003)(53546011)(9686003)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVk1N3B5ZEVpQm9ZSnZSV2lUeDYrWVJnMnZRZXNOU2F2SnBuTm9MaUd0OU5q?=
 =?utf-8?B?UkNaZTIyMzAxUS9EZldPNTFkbDRjT2NGeXVyWHVCUFh3M0dZYVJGeWlDRHpz?=
 =?utf-8?B?ejBtMy9kT1FONk5GQW9RbWFSZnY4ZmwvTDNVUHFYU2Vkcm5naGEvcG5Hc29E?=
 =?utf-8?B?NGZtc3doWXlCQXJ4eGMzTngwMWk0Wi9XZFlvTlJYMEdlRlljM2VSMWhYMlRB?=
 =?utf-8?B?dzNIcGlDMTYwZXVGRGovUjlaT21tZVk4d1ZDNHAwTjliZEJSMlhrczhJSGdC?=
 =?utf-8?B?T1NYajJEMUlmelozNWk4eTlYbytrenBlTkNCRGtGUm9tdllwa2dDbGRSN2xZ?=
 =?utf-8?B?Q3liR29XZXM1QTRlckc2eWsreTZMUUFJaUdTVjJ0YXlobWNKaGlkVUFlUXIy?=
 =?utf-8?B?K2tsT1VkQ3JCRzg5SDB6djBTbDQraU1adU4xc0k0RUNadzl0U200QTUxY1U3?=
 =?utf-8?B?ZFhxaFB4V1p3bmtnZ3ZGc3hhUEV6dXJuS2t1WjJ0VlhNYjgwYzFtNUFSaUhI?=
 =?utf-8?B?Y2sxRnhWVjNMdGtVeXZwVGdkYVJaVXpGaytMQ0lOaFFYaEdVdS91cE91b1Mz?=
 =?utf-8?B?KyszcVMrcUhCbnNsMDdPZDdOOHJLeEo1L3pyUWRRZnljclFmK2tlOFVNbmdX?=
 =?utf-8?B?K0tZZGQwODl3SksxOHVBODB3S3VHNkR0d3RaSmIwcWUzMTBZUGt1MUIwaHV4?=
 =?utf-8?B?TllzTVB2WHFJNmxoSTVDV3V6ZjFmS3U3aVpsOUhrbjExUzNHTWpzKy8xSjV1?=
 =?utf-8?B?TER6VEV0OS9BcnJUcVp6M3o2VURyRU1HVWJuVmsxSUU0K09CbGNTNGh1SE9C?=
 =?utf-8?B?VkhZZ2l4WkREKzhEaGNxNDU1eXp6QmlmQjd6VjNjWWlLT0d1eklBZlh2TGYv?=
 =?utf-8?B?UStBeUk0RGE3ZE5hUllVc001bGgzcnU2UXlzbm1iWVZ4NTh1NGZZdmlUUDVP?=
 =?utf-8?B?V3orM1BuS2VKUzFSeXBEaTB3dFRJUnJXNVM3Tm0rZUJrcE9SWUJ0RGtSQlhC?=
 =?utf-8?B?Zkk4SlBoSmwyNWhoT2xROGdzM25DVjJXMTlRc21EVDVxdE1Ua3VnMWJhc1Yx?=
 =?utf-8?B?ZlBCQlA3c3FtN2JtdE9mdmdoeVgrUmxENytXMlVnOXVXWU04YXArY1JFZWpt?=
 =?utf-8?B?OUt3Ui8xTFNkTm5xbHNVVTE3ZnBneVoxT2FIWUdNQ0xUUWc2bXRhUUtiVTZo?=
 =?utf-8?B?TEVyZ1hHampnQ0pFK2ltMzdPQXZZcTJYV0lQODZmRmk0Q1B4azJVNDhXWVNu?=
 =?utf-8?B?d1FSZ3laQ29FY3VxVXJxMVd5cUhJcUNBakE3bGVTc21hY0o0VHhacFBPRFVU?=
 =?utf-8?B?TWhsTWZscGFhYzBUTUZKM252dEVBeFZjZUJvWW1PeDFZMmFVdVVmZDduZmw5?=
 =?utf-8?B?MW9TMWQyejdscjJnQXZhRTNVSndGd2dPMlpkeFNicnhrRVYydHZLSndDWUlw?=
 =?utf-8?B?eWw3cDdLSE1JOGtnQjkxWEZnSWFmQ05Od2ZUQzJtSTRXZnAza2x0Z2dmWTN6?=
 =?utf-8?B?eGdVNXhDeHJXeERpeUw1M1VpNnZGeHBRMm9DVkVJaHRNN05lZWQyK0VMc0hW?=
 =?utf-8?B?eGhUN3ZOVW9ZbFBTZlg3WG9ldlM0cTd1MWgrM0FRdFpWZk1sQzFMYWFWUVBn?=
 =?utf-8?B?S3NwTEQrdWtQbEorQThiVzJSKzUzWHZWV3dHdXo4MWY1aC9GU3NnWWt2Z1hs?=
 =?utf-8?B?Wnh3OWRGenBTUHBjam0yeGpmeDRwQ3BFc1d5ZkZJbGx3Tkkrd0JiK1hUTnNa?=
 =?utf-8?B?VkJ5ejNyTDhtdUZBWHBzVFFHdDBsVWtLTzI2VngyeWx4SStybUo2YjlidVFv?=
 =?utf-8?B?L25iVUxmSkdweC9jZVhkQlNDOFVjOWFMaDZYckxaVFJkeUZiNkVtSVVZRWlL?=
 =?utf-8?B?VFBuL0F5T1JKWmZQRTN3QngvTDRjL3lkS3pIRDBuQURBRlVqVnRJRmRLVWVx?=
 =?utf-8?B?a0srOXh4YTRHVGpJMU9Kell4cWszWE1BQVI1QldsZjV0R21FdDkwN01QczN1?=
 =?utf-8?B?NVBGME92ZWtreFh3M3Mvc2FJRm1jT3c3VkJwYmZBN2xZK2Q4YTBYYUdLSHk0?=
 =?utf-8?B?RGdjMzg3bVRCNldBeXhHMXVoekNzVTJPc3RzZGhSUmF3Z3kwTlZxSXRKOGZl?=
 =?utf-8?Q?vGWWoAKjUwDZH1AkYHnFJtqp7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb016cf0-8407-4f18-d8bf-08db3bff4fdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 09:13:14.5596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ukZG+ZpJqKSVRiCjeMCk34zg05Cd/PRsFqeHyr0wEri6Byu17iQCPi79R1vHLv7C+f/kqCqt0EsVghtXP5V9gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8092
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiA0LzEzLzIwMjMgMTA6MjcgQU0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVGh1LCAy
MDIzLTA0LTEzIGF0IDA5OjM2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4+IE9uIDQvMTIv
MjAyMyA3OjU4IFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+Pg0KPiAuLi4NCj4gPj4+PiArCXJv
b3RfZ2ZuID0gKHJvb3RfcGdkICYgX19QVF9CQVNFX0FERFJfTUFTSykgPj4gUEFHRV9TSElGVDsN
Cj4gPj4+IE9yLCBzaG91bGQgd2UgZXhwbGljaXRseSBtYXNrIHZjcHUtPmFyY2guY3IzX2N0cmxf
Yml0cz8gIEluIHRoaXMNCj4gPj4+IHdheSwgYmVsb3cNCj4gPj4+IG1tdV9jaGVja19yb290KCkg
bWF5IHBvdGVudGlhbGx5IGNhdGNoIG90aGVyIGludmFsaWQgYml0cywgYnV0IGluDQo+ID4+PiBw
cmFjdGljZSB0aGVyZSBzaG91bGQgYmUgbm8gZGlmZmVyZW5jZSBJIGd1ZXNzLg0KPiA+PiBJbiBw
cmV2aW91cyB2ZXJzaW9uLCB2Y3B1LT5hcmNoLmNyM19jdHJsX2JpdHMgd2FzIHVzZWQgYXMgdGhl
IG1hc2suDQo+ID4+DQo+ID4+IEhvd2V2ZXIsIFNlYW4gcG9pbnRlZCBvdXQgdGhhdCB0aGUgcmV0
dXJuIHZhbHVlIG9mDQo+ID4+IG1tdS0+Z2V0X2d1ZXN0X3BnZCh2Y3B1KSBjb3VsZCBiZQ0KPiA+
PiBFUFRQIGZvciBuZXN0ZWQgY2FzZSwgc28gaXQgaXMgbm90IHJhdGlvbmFsIHRvIG1hc2sgdG8g
Q1IzIGJpdChzKSBmcm9tIEVQVFAuDQo+ID4gWWVzLCBhbHRob3VnaCBFUFRQJ3MgaGlnaCBiaXRz
IGRvbid0IGNvbnRhaW4gYW55IGNvbnRyb2wgYml0cy4NCj4gPg0KPiA+IEJ1dCBwZXJoYXBzIHdl
IHdhbnQgdG8gbWFrZSBpdCBmdXR1cmUtcHJvb2YgaW4gY2FzZSBzb21lIG1vcmUgY29udHJvbA0K
PiA+IGJpdHMgYXJlIGFkZGVkIHRvIEVQVFAgdG9vLg0KPiA+DQo+ID4+IFNpbmNlIHRoZSBndWVz
dCBwZ2QgaGFzIGJlZW4gY2hlY2sgZm9yIHZhbGFkaXR5LCBmb3IgYm90aCBDUjMgYW5kDQo+ID4+
IEVQVFAsIGl0IGlzIHNhZmUgdG8gbWFzayBvZmYgbm9uLWFkZHJlc3MgYml0cyB0byBnZXQgR0ZO
Lg0KPiA+Pg0KPiA+PiBNYXliZSBJIHNob3VsZCBhZGQgdGhpcyBDUjMgVlMuIEVQVFAgcGFydCB0
byB0aGUgY2hhbmdlbG9nIHRvIG1ha2UgaXQNCj4gPj4gbW9yZSB1bmRlcnRhbmRhYmxlLg0KPiA+
IFRoaXMgaXNuJ3QgbmVjZXNzYXJ5LCBhbmQgY2FuL3Nob3VsZCBiZSBkb25lIGluIGNvbW1lbnRz
IGlmIG5lZWRlZC4NCj4gPg0KPiA+IEJ1dCBJTUhPIHlvdSBtYXkgd2FudCB0byBhZGQgbW9yZSBt
YXRlcmlhbCB0byBleHBsYWluIGhvdyBuZXN0ZWQgY2FzZXMNCj4gPiBhcmUgaGFuZGxlZC4NCj4g
DQo+IERvIHlvdSBtZWFuIGFib3V0IENSMyBvciBvdGhlcnM/DQo+IA0KDQpUaGlzIHBhdGNoIGlz
IGFib3V0IENSMywgc28gQ1IzLg0K
