Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819DD474564
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhLNOl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:41:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:48217 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhLNOly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 09:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639492914; x=1671028914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jL/IUDRxOtRx/uk3ggiimChryhHbP6FKJ1B/81jycpA=;
  b=ERPh1olO083c+HEslZPbCPpDAbMZ3FHAmWwM6dEcNXUS+N3jX7DftTIx
   aS0cglK7pl6mv3PI8Mks2FEFRzZeeutIAlgwGk6VE2Ek5LufvBBgSbrbi
   CJkKuahjvVvpIM0S7wXDGwMFlm762GBuMK41jfjK3PcKkWF07ywEte8BD
   elMIRxIk/WdDDpXGN1NdwP5GSsD+7pnf64i4tRBvj2F69OXayEuQYBdO/
   Y/dxydd+g0rq+GsFm2av1GLp50EDmdJ+Uh7A1E+2G0Mu7UQaeF/KlS5D0
   hvT1ODofyBOS9ERxXZduB/hO9nMZPx3mmxEqAJkjHXeYIC0roOfQIF2KJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="238801188"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="238801188"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 06:41:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="661401099"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 14 Dec 2021 06:41:53 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 06:41:53 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 06:41:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 14 Dec 2021 06:41:52 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 14 Dec 2021 06:41:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hq1Ma8tfM62G2Uzx8aNWF0YFUC4rz/uLULhdGscWJ9IUJzJQ+OcdXjUrTnb8Uv47m+NuP1Gh+pLuZozvo8qjCRIvVVyT3GqTATXAUEqkmyTXuGzWODBDWNaMKNLPmyVP2xRYfqNzhed5XkMIlDH924guWkfvA2x7UmQuxw+dbyk4YNO8IJyqGj+SlP2uPfiOH3xB+0LGfHLW1m+jr4Q620L7hjtysIUtkW+ruxVHL0PfxSzhUcPXw1iumygIZwsOR4O21MBPU99fd7LBR8LL++0VM1exaYaWXiFTbD2HZV1PVrksLFTs+7Z6QEa72+4oh5os7G3n8B5GDJumyRSsAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jL/IUDRxOtRx/uk3ggiimChryhHbP6FKJ1B/81jycpA=;
 b=e/4gmeeeYBMM8DnNGRzF46gaelSuj5ZqkYN5F44JVTXX+F7YvHOul0u74hFAaposAweMyx1PyxmuS5X8eGCdw8mhZlrKC+rXNRlE1lt5Pa2QYv689FwwkXBlzOILRoJmTaYGMh4YdLt9MY6izWVghVFwS92PgKc/f1CQHgiVk9UCNXd5bLfqpChQmzK7emnSljHbkau7e2l+QoD2XbIh/Vw7QhziGteAgYOf2qBQCbXs5zLuomwrzbvjic441qeEhjscdVm94pf9KbxK7v+8Oa2SJKtOMZUBjrPtoo9mhJOiLbHYhOPxS1MGbti3VVqTXJPPAd8yHXqWxDaxSN9qXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL/IUDRxOtRx/uk3ggiimChryhHbP6FKJ1B/81jycpA=;
 b=BxE2eueWKBN/KyPhrfwyl1Fbf9K7dxSMxBeFg3YdZ1zMnH07zCcfGWR16j9RDOqF2SmgptofM/MB43Dm5aCLnx2jJM1N3k/HF8hr2/awQreReVaPWPboFWxbDGSuGbXXK7Js4kT0fJdg/tP0bfINQS5tr8bHiYCt/4ah/U4gGCo=
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by MWHPR11MB1453.namprd11.prod.outlook.com (2603:10b6:301:c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 14:41:46 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::9dd3:f8f0:48a8:1506]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::9dd3:f8f0:48a8:1506%12]) with mapi id 15.20.4778.018; Tue, 14 Dec
 2021 14:41:46 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>
Subject: RE: [PATCH 09/19] kvm: x86: Prepare reallocation check
Thread-Topic: [PATCH 09/19] kvm: x86: Prepare reallocation check
Thread-Index: AQHX63yAPk/dUCWBwkiolv7SwM9W3awwLT2AgAFuEgCAADT1AIAASDcQ
Date:   Tue, 14 Dec 2021 14:41:46 +0000
Message-ID: <MWHPR11MB12453B3CE026CE7087C29E3FA9759@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-10-yang.zhong@intel.com>
 <fc113a81-b5b8-aaae-5799-c6d49b77b2b4@redhat.com>
 <BN9PR11MB5276416CED5892C20F56EB888C759@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d513db49-bb94-becf-be7e-f26dceb3e1bf@redhat.com>
In-Reply-To: <d513db49-bb94-becf-be7e-f26dceb3e1bf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eada8e3b-3fc7-44f1-d535-08d9bf0fda94
x-ms-traffictypediagnostic: MWHPR11MB1453:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB14538C93829D417A91D06BBEA9759@MWHPR11MB1453.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QaFZ63jroo4aDPCZyyvjf+kK4vfPEwuVonj/5p9BVB7Aas50fLXzQsfSGwiL5TGImVTnAozihgdU2n4nz7aWkzLKZy95TMWunQ+COlCM7iRZOW39cAmCKSJ+AjqEDxSLa9KUYKbYkwnzkQtbAgflt7SyzonwJaPegvmgCSvjR1u24E+MLoHY5OXbXcF0xn5T6FgbkLgs4z035WFbMLajOVmVF8Li6LlpEUfBTEEd0LSkaqM37Aub5sTRQ+f2Lk258rTqtyGGpYPCab49haAenLe4BTwhch0s9ALGjX36XM+GlhIAnQy30dPZBhtvTm0efEku1RzC2F9hm5nrH7EOl1IxhkC5E8eiJURc9KBK/T9T6H8UGxund4175mgu4bn7VA+WAwZfg/iL5GoWBSh6Nv5yu/UOz2q8idqWjmw/7cmT8E6jmPIONuNiZw3LVcvdqt4cJixflSnKkovF7Icm9cYgZd2MXNoCUrCoKQjor/nY8em+9mzcdCzRpb27frdfixWfJjSuzUqT3yx+n73jLJ5Y7+5bg4dv4hYFbpjT7+/GaVPdtV4ItDi42oMEvw4ArUMD6Sv+P9LlO1H22aD0w6vkZ9MPCkZSUkDdGf7TIUrzFE4a+kDbnvOmymlJbm+4B4UroG3+nt/6az+SUkAws4ko0UBKvivLdIXZyG5CatxtP15bHmpz2b6r5T6DBcxVVldFhgvw/qBjLnfaH5Igd4SN6k8jv6psX0O7eGC+4y+C+TAW9VcoaK7mo3+xn5//
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(4326008)(26005)(82960400001)(8676002)(55016003)(66446008)(921005)(316002)(86362001)(64756008)(66556008)(122000001)(54906003)(38100700002)(186003)(71200400001)(7416002)(8936002)(508600001)(5660300002)(6506007)(53546011)(76116006)(38070700005)(66946007)(7696005)(33656002)(52536014)(83380400001)(2906002)(9686003)(66476007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTIxeHgycGpsdTBBWW1pZDlFRVRSb0ZqRjR0MzNiS0FaV2lTNUF4WVdFYVFO?=
 =?utf-8?B?bURCL1Y3anY3WlZPMjQvdDVocDZ6a0FDdVVKdE9BL0pwRWE4NUlhNm9NSmtT?=
 =?utf-8?B?SEYvQWZEZUVnK0o4VGJPQkZsTGkyNHdUTEhVdkNFTW5xYjZDZkxtRjUwSUc1?=
 =?utf-8?B?SVNXekt2WVlSVUJ1RkpHeUJWVXNoWFJHMGZvVkMrK1o5ZENRUlhBRjkrTEtY?=
 =?utf-8?B?ZjkvMEJFZ2I3RjQvcHkvZzNCK0o1Ty90d2V2KzhwUG1jd3Q4ZjRCOWVFU3lD?=
 =?utf-8?B?YnhLcVFQV0hmei9nY1RVYmYyS0w0enA0eGpsdTJRRGRxaUU5a3FTQVJybUM2?=
 =?utf-8?B?Y1loME5CRlZIa0FxQUFvQkFqM0tTUG9nV0hMVmdWZTFrMWdJWU1CaERKeUpo?=
 =?utf-8?B?dUZlL1UrNCt3b0VoTUxjOVBZcG5CcUlWeExzUk5oVkdBRTBwRk9mOGhrWTRF?=
 =?utf-8?B?bFNSNU5ZL3g5QlUzNGZSZUZHM1NDbm5VSVZCNXJkR3cwaEFoKytmWG9hczYy?=
 =?utf-8?B?UTdjSU5LVE1mSi9FNHM3cXgxOHZrNDV1YllQdGkxU1puY1VFZk5PNUUrREJV?=
 =?utf-8?B?N21yZmJYWkdHWkxKcDE0d0s5bmlSeEJjSTRMZWVsRWZlOWE3NERMNWloTHU5?=
 =?utf-8?B?b0hUbnRZdW9jNlYwb2FjdkZ0SnJ6c0k4U2dKMERXZGJsYWFac1pnK0hWMmlT?=
 =?utf-8?B?NGtUVU5TUkNLWnpyd0I5UG9hSzV5Z3FFVDN5amRtZkQ2b01heVBTSFZyZjRl?=
 =?utf-8?B?TVNsZjVGN2txK1NYd0ZaMmliejc2cXFRVjRWSUlMeEM3Z1A4ZlFCaHhoeENh?=
 =?utf-8?B?dnBVZzZNZGVpQ3oxNzNXMFQwaUlhVitlblhUaWhHQ0tBTWZ5aHE5aEl0SkpZ?=
 =?utf-8?B?Z3pPemNSaWlQeEpFRytsdDVUclQ3cTcrYXZFRm92MWs1WTNwN1IyVURpOG1n?=
 =?utf-8?B?ZGFVVXBNWHgvdWtGRUVZUjU0ZTlYaXVwblBFOTB4WFRTMXhwR05zMFVCalpx?=
 =?utf-8?B?MzJsQ012bkVTMlhMdHNYVVUveEJ4a1owUE9SSjFtVjFGUTBBaTRUdFc3elQ5?=
 =?utf-8?B?VCtlWThFUkRGaktNZTdMelJGdE9HSUF5aWdKeWs0S0sxemZzTzM5YkNtUitx?=
 =?utf-8?B?elRNdUsrTVJXOXhIK1hYOGZvU3FQb3NiV2Z5RXNGWTFwTHpKL1ByRktyU3Vt?=
 =?utf-8?B?dFczc3czaHNRdWdRTVRCWG02TUVjQTUrVzZCbTlTOE51bHdQdDZjd05ZaFZE?=
 =?utf-8?B?ZEI4QnQ3RDQrNTJUN3dCdndHT1dDOG9VQ2JRdTdOeGFHbU9uRVlmSG1SRWlr?=
 =?utf-8?B?SjN4MUQ4bWpQcFA1eTArbDF5eUFYSU44em9kb0tlQjRwVzlSM0FrNDRnSzZG?=
 =?utf-8?B?TktIWmFCd2ZkUTZ5VFI0SHlRMW5XSzJ5SkU2Mnd2OFVxQ2xXV1pQaXJWSjha?=
 =?utf-8?B?dnZJT2RuUkRmQ09hdTZkSUpPc3gxNXJiZWJyVjB6bW9DY092bitBSG9yd21J?=
 =?utf-8?B?TlJpMGZ0VVY0SnpIdDQ5RlBDTVRXK0NaY3hybm1QcFFNWWxiYzlueTloRk1D?=
 =?utf-8?B?VHZnQ2ZIN1IwZDFFbXdNelVIa2xkVkJuK0l5UjNZcVpHZUpBdjl1UGhzQTRp?=
 =?utf-8?B?bm56SmlWT1YwVVkyR0Z3cVU0dFVJTDhFbDVGeWs0YXorWDNMcmU4TEgyazRX?=
 =?utf-8?B?WjVMckp3ZDZnNWc3Ym9MR2ZlbXFSQTAxdTRMQWpLOVNlRVdNVDFEWmJONklF?=
 =?utf-8?B?a1BOOGkzZklaSXNKQWtkaWphemEvVmdzUVJsL3d2K2pnT0taL2E0d2FuWi9k?=
 =?utf-8?B?aVhvY2NBYm1iWE9nZVVsQ2E1MDBUWEJ4a0VXRnpzVGJ6eFRRemFySXAvNjll?=
 =?utf-8?B?MElIT3VnWWxYVStLUkJXTXBNejZXZjhqbXdQU2tqemRBVHNpLzkvZldjTjV2?=
 =?utf-8?B?cW9sTXB0UFlxb0hUeVFJeXdRYWxJU1RnMHg3MW5UbHU0R0FBRklBQXl0U2pr?=
 =?utf-8?B?UlRhK3d4OEZKc1JmYXJHbmVLcXNjWGNsVTFjY01Ta3F6OWpFTElER2lWak5X?=
 =?utf-8?B?RkdPSjYvOU9KQkRJYkxyUnJkU1BaaGNOZ3p1aFhWVURvMjZkZ1pLWDJEdzRk?=
 =?utf-8?B?c1JQQzJJRVVDTVl4SWZ5K1RBSW1ZQVdYYXBwVDZkZU16dWNVR0xwQmNSWEVZ?=
 =?utf-8?Q?6uimU3P3mxHx4tOdjyDz3eg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eada8e3b-3fc7-44f1-d535-08d9bf0fda94
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 14:41:46.0818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r+MkgeUJBoVTHCj8xyweLdW4+3Gv8IeGq0oBFa95u2I5UGvXC7pODOAgG3dz6sN7HE16GRxvvv8ziSLFSj1PTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1453
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiAxMi8xNC8yMDIxIDY6MTYgUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IA0KPiBPbiAx
Mi8xNC8yMSAwODowNiwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IC0gaWYgKGR5bmFtaWNfZW5h
YmxlZCAmIH5ndWVzdF9mcHUtPnVzZXJfcGVybSkgIT0gMCwgdGhlbiB0aGlzIGlzIGENCj4gPj4g
dXNlcnNwYWNlIGVycm9yIGFuZCB5b3UgY2FuICNHUCB0aGUgZ3Vlc3Qgd2l0aG91dCBhbnkgaXNz
dWUuDQo+ID4+IFVzZXJzcGFjZSBpcyBidWdneQ0KPiA+DQo+ID4gSXMgaXQgYSBnZW5lcmFsIGd1
aWRlbGluZSB0aGF0IGFuIGVycm9yIGNhdXNlZCBieSBlbXVsYXRpb24gaXRzZWxmIChlLmcuDQo+
ID4gZHVlIHRvIG5vIG1lbW9yeSkgY2FuIGJlIHJlZmxlY3RlZCBpbnRvIHRoZSBndWVzdCBhcyAj
R1AsIGV2ZW4gd2hlbg0KPiA+IGZyb20gZ3Vlc3QgcC5vLnYgdGhlcmUgaXMgbm90aGluZyB3cm9u
ZyB3aXRoIGl0cyBzZXR0aW5nPw0KPiANCj4gTm8gbWVtb3J5IGlzIGEgdHJpY2t5IG9uZSwgaWYg
cG9zc2libGUgaXQgc2hvdWxkIHByb3BhZ2F0ZSAtRU5PTUVNIHVwIHRvDQo+IEtWTV9SVU4gb3Ig
S1ZNX1NFVF9NU1IuICBCdXQgaXQncyBiYXNpY2FsbHkgYW4gaW1wb3NzaWJsZSBjYXNlIGFueXdh
eSwNCj4gYmVjYXVzZSBldmVuIHdpdGggOEsgVElMRURBVEEgd2UncmUgd2l0aGluIHRoZSBsaW1p
dCBvZg0KPiBQQUdFX0FMTE9DX0NPU1RMWV9PUkRFUi4NCj4gDQo+IFNvLCBzaW5jZSBpdCdzIG5v
dCBlYXN5IHRvIGRvIGl0IHJpZ2h0IG5vdywgd2UgY2FuIGxvb2sgYXQgaXQgbGF0ZXIuDQoNCkZv
ciB0aGUgd2F5IGhhbmRsaW5nIHhjcjAgYW5kIHhmZCBpb2N0bCBmYWlsdXJlLCB4Y3IwIGFuZCB4
ZmQgaGF2ZSANCmRpZmZlcmVudCBoYW5kbGluZ3MuIEN1cnJlbnQgS1ZNX1NFVF9YQ1JTIHJldHVy
bnMgLUVJTlZBTCB0byANCnVzZXJzcGFjZS4gS1ZNX1NFVF9NU1IgaXMgYWx3YXlzIGFsbG93ZWQg
YXMgdGhlIGRpc2N1c3Npb24gaW4gDQphbm90aGVyIHRocmVhZC4NCg0KU28gSSdtIHRoaW5raW5n
IGlmIHJlYWxsb2NhdGlvbiBmYWlsdXJlIGluIEtWTV9TRVRfWENSUyBhbmQgDQpLVk1fU0VUX01T
UiAobWF5IGR1ZSB0byBOT01FTSBvciBFUEVSTSBvciBFTk9UU1VQUCksIA0Kd2hhdCBpcyB0aGUg
d2F5IHdlIHdvdWxkIGxpa2UgdG8gY2hvb3NlPw0KDQpUaGFua3MsDQpKaW5nDQogDQo+IFBhb2xv
DQo=
