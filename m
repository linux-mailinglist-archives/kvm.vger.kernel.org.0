Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65BA4769A7
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 06:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhLPFgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 00:36:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:21724 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhLPFgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 00:36:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639632981; x=1671168981;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=CIowYThlfsso2aiUKEy4pdVEhYcJJ8LgYHHlA6Y+HLs=;
  b=dGWKg4R2825BwcHXw3YJTaK0PHbqNTW0+V33zOj5/GerFG0xjzLcrlsE
   HcDVmDkKe+lLxjN53wPgq4bovvWdWt/x6xC4ofvggtNOLmRtpKyfhZD85
   tOcFo5xQIMqh3DxDnPmMQ1gySSF0ZDpN6y/4Lnu5hh7oH+epyvRR1aJcV
   NU9BpgMGRk9uHPTDuk8os4y/qelVRDAw1zf4wvMNuUbX+gYduDljpYrio
   QdsxXpB3iXEzV2fWwmfTbvDQ2GxhG3liXemktISdYpqcYpINJROV4sPOw
   5NxkQ55z071hCfa0GUqVyTqsir5e3mRQDWXUnxoNpxwWPU+bXBF4nuTM8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239219552"
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="239219552"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 21:36:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="615008450"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 15 Dec 2021 21:36:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 21:36:19 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 21:36:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 21:36:18 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 21:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTvFTfPnVsDCiObRUg9kQxubG/t/xFm6/DvMYQOeOWspH8EeWtFUHxxtqWIWDnG2TvrF3UEuAY1DCqddAmeUky16WEYu3M5pFp0os6RTS5doK/XpxJr/jzd/z1eO6EDfL+lPLNzWMwQ54Ufo4mWuWAOYztdpZzr2FihjrXZsWEMwDhzH2YelfnUfzvAONrZJB6/EqMqDeooVtMGO7u/MYztaVdEliCMgf8zL8/v3DvgtcmXYXNdsc5n16S6wxCsh2dTN9pmH7gCNMriaDX7avb7AtAp8vU2s1b8mG81TCdlY4HoUmJQxbxqWYV4WWk//BKXKq74cEPORlsPaa1p2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIowYThlfsso2aiUKEy4pdVEhYcJJ8LgYHHlA6Y+HLs=;
 b=ioTW46K7LdE1X72eS3N1ERuhR1Iv9L1fMbUxpJ5fZm/mw0LfGDwrEpopcL3iy8D8q0hgMOBAaiwFL0tMNYyxAKiH43idU/bZjR8Dgx5OWci7ixMGt+CYUzdWOzoHZOsgl6mPbhqCSTUtkZoV4IrI1fjUEJY/ZxIADUusSP2eK3qt88Tn40j39kS2wAaXcQ0ozFu7d6CbPwEbiP2LFAddKpaMgILhKXqWmuiQnS3wuuyQ04vtI5I1pDcqP1bxuBHE1Q30iSMrkK/hYX9Uh7w+IKzW2gxuIgWmvdNQTkjZOxmYAofvLwgqk2bk3n8/xtlGNb+uJfjGDeqMzqSUPpQ7Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3652.namprd11.prod.outlook.com (2603:10b6:408:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Thu, 16 Dec
 2021 05:36:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 05:36:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgAADz4CAAO8l0IAAA8PQ
Date:   Thu, 16 Dec 2021 05:36:08 +0000
Message-ID: <BN9PR11MB5276F8C1F89911D4E04F8A9C8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 282fe5c0-ae3d-4966-e622-08d9c055f648
x-ms-traffictypediagnostic: BN8PR11MB3652:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB36520CEB81BE6D48EB12ACD88C779@BN8PR11MB3652.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5YDKtozrEe/kS4ih6GfO+xePDRw2zF29cTMeVbZeLlshiDaA8SGTcvsQSvwbt/cXOH8dAIa83d7ehULqt3NjKRqWeMpLxQqkUiFBq+5UbMXRLZezgHHwUEXyFBB/Zh4K3KCaVjnS35v54jVvKgBJPkJWfsC54soRZ3GUagXar0IoTZFRuVBi0FyQbXN+6TjnGbUZxhBl18qvEshLjVFkr2ZvKFkIYMmxNtliscBTgk3jNlss+GkeoAsEGqqYr2cxw1oLrQOE7hw79xoqS3eRFZnIKsXviRbEa3kEz1P3DL42arixsjYslhdRpMwh4VSbuuG2tvJ95C54GKi/EJo4t0Lxr8QVtRsJOaVH//3XShqg4/4Hh+roOTegrFed3MWnoVRir6gQOG53iZ9+xMZGq2dlWd4kUqFsSLLC1cOVm6ZO160jFfvS/oTFlZidXb9mx6KmaRRzTAUYhQDjzfXVwNTWzJ4XpPoabbFdxhIV7opDyKjMDM9L2HsT+6vUWliCVN2SobLNO7zYtga7DjWGsFrs6LcMbZHK8yzdO78nQzDbJVJIdcRt5A096MPKmcg6gcoUdZUl622m+FGb32YC8wbutwn9IjcvYtX9Tfw2cIYwRCXEJL0Q/n4N5O0wS+xhWmyuVAdrwCOkpNi6EdPHn6ZEQWK83ua8xaQsxl0u1pm0jZGUQocW4BBZPsnIyfHZ25usmJP1qAsElSH0QhxZDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(110136005)(38070700005)(26005)(38100700002)(54906003)(66946007)(9686003)(55016003)(5660300002)(508600001)(66476007)(186003)(86362001)(66446008)(64756008)(52536014)(6506007)(8676002)(66556008)(33656002)(82960400001)(4326008)(71200400001)(7696005)(76116006)(8936002)(122000001)(2906002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXFvMm5VUE1KZjhNQVpHcHJuT09VdWJjWDc2bjBpWHY5ZmlPWDRnTUttSWRK?=
 =?utf-8?B?bDdRUFgzNEZ0SjV2UVFBajhKTDVLbWNqaGV3NXZBQmQvcHBENTIraFV6T20y?=
 =?utf-8?B?S3cyQnJ5SVhLZklQWmc0NlZzT2hSd1pGUjRodUJxdlVOLzRjQnc2eDRsUkRt?=
 =?utf-8?B?NzlKTGdiM1c3ci8vK2pHYjFSZVBjV1dSNFVDd2Fia3U1YnNvNHlYZlVlcm1O?=
 =?utf-8?B?Q1poQlNPSkhTSDFrdmd3ZHZYYU1lMTVvV3lpa2k2dVdxTTVwK2huOENpdThz?=
 =?utf-8?B?aEY5YWlTc1ZMRUp4SnBxcWliWm1xdXN1MjBSaWQwZi9UUm5TWFFwV0ttcHZE?=
 =?utf-8?B?S25CNUJYdXNtQTAzM2FEYnc4S29OSTBjUUxza2QrYldVZmZzVE40dXlWZ1Jx?=
 =?utf-8?B?T2FLT2ZxM25kb3crZXpnZjVEcnBJMXlVMW15TjlYc3VrQTBHQnJmK1JQcDFB?=
 =?utf-8?B?YUZBampUcTQ5NXFmZFJSTWFLbjFjN1RlOXhQR2ZtL0d4bzN1UUlhaVRYZjFC?=
 =?utf-8?B?clRNZXl6c0JhVXE4ZklVeW9zSSszYkFiMjUxMlVzRFdmSFBNOHJZL3RaYXpL?=
 =?utf-8?B?TmtEK2xMMjM3RGRnTVZBeFpsOEZ4SldpcTJ1TGV3a3QxeCtnU2txZ1hmREpm?=
 =?utf-8?B?VHhxNUN4ZjBQbTdHZ2RJTlJ5azRxa3hDMStRa0REb0UwTWlvOG5udS9OYVVP?=
 =?utf-8?B?SG5lRXE1NjhsNkYwamhMdWV1Y0dlbkZ5YlZycmtFam5ZVGpGdWIrNlc3ZWtv?=
 =?utf-8?B?dDBERXhyTUJBUGx3d2I2SUNpd1J0T1cvK05SSi9SQnRPdS85LzhnSk55dnoy?=
 =?utf-8?B?UE4xcnhyditLaFhrcCtQcVlrMEhwU1lZOFZjOHhQdGFoZjBNZVNseENQUDVC?=
 =?utf-8?B?ZEJjbDZ3ZmJsQnVyakwrOFQ3K3NBMTU4L3RqK1R5WVZvajRTc2s3alp5Zitt?=
 =?utf-8?B?SGMwN1JmOEsyZ1cxdmRFSXZxclA3WjJqQ1Q0SldxV3h4UzFtQS9MMmNsdmpt?=
 =?utf-8?B?UkFxRUxza0lYaURBMVExR3pwODQ1MUxUaUlOQ29sUEZFbG1rdW1BRGp6S0hy?=
 =?utf-8?B?NW56cWM3NjFYc1ZaQ1ZBTzJSQ0tia3hsTG1laGNMbXhtbUlNQU1KMjdDbDVs?=
 =?utf-8?B?ZmxXL282c3JvQ3VIZm5sMHk1bzNraEVMTEM1L0JjSFJ0YS9SeHZra1ZzckhM?=
 =?utf-8?B?MERNbmo5UG9PZW9USk1rdDl5SG15VHpzUWw5VVJiRTNUR1RTM3pSamswcnZS?=
 =?utf-8?B?RGYzQk5sNmdYelNJajlncVZzUHdyYVVnb29vdk1rR0UwRk9kNCsrUVlTT3Nz?=
 =?utf-8?B?bXVSbGpMNVF3cGJwejlvbU1JeFRhOE5FbUtxNFI5aGp4d05jTTVKTDRtSGpk?=
 =?utf-8?B?M0k1cGhHc2xoMlZUbmVIbU44QlRSTERoZ0pKekVCOEpaUjZNdmUrcWZ1TmNm?=
 =?utf-8?B?ZlAzVUNLUVBQMGU1M1MrbUNzUjBKaEhidW5GTThQWFVxRzVKc010SEVKd3gx?=
 =?utf-8?B?eEgzS1h6UnBwTDh1bDNwOW9rTFFtWTQzVlM2NlNZcGU4SUZhUjJaQi83WDNQ?=
 =?utf-8?B?WW1WM2M2L3JiczBBTzhUbWtDYnk5K3p3SklLaWIyREVrZlFNMEF3Ym9TWS9T?=
 =?utf-8?B?T05oeTBlY1pxZjJ4bVdheCtzdWNJQVk2aHlmd3pvdWxHNEw4YjZUK2tQVHR4?=
 =?utf-8?B?MjRtbVdaWkRwZzhLSVErSHE3blJnQmI5eVV5dnZyZHpOekdNU3ZMT2VzdnVB?=
 =?utf-8?B?M3dvTWh4VUVNUHEvdWR2UkVZV2NIaHduMUxjSUpSamJkOEQ2YzVFbTJ0OHpY?=
 =?utf-8?B?TzlkYnp2OFlaTEdxKyt6MmxKMWNKMlhVM3krVnNmQ25NYzZaUHB6R2wyTG13?=
 =?utf-8?B?M3lDV0RYSkJrTGg4dG9zSlpBTlhFZ2t4YUFXNTNubEhpalMvRzAzMitmMVNl?=
 =?utf-8?B?T3oyUm1lZllpUHRvMnFXcStJdVYzTVN2RGFSbi8yOXRQVnNHaGhlU2ZYcW0v?=
 =?utf-8?B?TFQvMW5LcTg2cTB0RUhoc1h6VFJ0NW1BeG5pTEV5aHErYTVEbmVFa09LWmp6?=
 =?utf-8?B?Z05wWjE4QUhONTFlNTB0TE5neksxd0pOK0tmR2dhVFZOREFTM3h1MFVwVGtO?=
 =?utf-8?B?M3d6azlaL2ltaUxYRHRuWU9rSmNjVU16cDNFVStXMTA2R0F3RFFnM2hWQ3Zu?=
 =?utf-8?Q?AOTVfi+8XNmmyBHD3fQbBSY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282fe5c0-ae3d-4966-e622-08d9c055f648
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 05:36:08.4221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fuiZ00KTjG+aDia1/pCVXjcJrnnR42R0ADPb8Vl2vZI6VWLQGhrJ3KbzWHnXqzTMWQ7lMNvxwLEvDOgqzfvpAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3652
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgMTYsIDIwMjEg
OTowMCBBTQ0KPiA+DQo+ID4gT2ZmLWxpc3QsIFRob21hcyBtZW50aW9uZWQgZG9pbmcgaXQgZXZl
biBhdCB2Q1BVIGNyZWF0aW9uIGFzIGxvbmcgYXMgdGhlDQo+ID4gcHJjdGwgaGFzIGJlZW4gY2Fs
bGVkLiAgVGhhdCBpcyBhbHNvIG9rYXkgYW5kIGV2ZW4gc2ltcGxlci4NCj4gDQo+IE1ha2Ugc2Vu
c2UuIEl0IGFsc28gYXZvaWRzIHRoZSAjR1AgdGhpbmcgaW4gdGhlIGVtdWxhdGlvbiBwYXRoIGlm
IGp1c3QgZHVlDQo+IHRvIHJlYWxsb2NhdGlvbiBlcnJvci4NCj4gDQo+IFdlJ2xsIGZvbGxvdyB0
aGlzIGRpcmVjdGlvbiB0byBkbyBhIHF1aWNrIHVwZGF0ZS90ZXN0Lg0KPiANCg0KQWZ0ZXIgc29t
ZSBzdHVkeSB0aGVyZSBhcmUgdGhyZWUgb3BlbnMgd2hpY2ggd2UnZCBsaWtlIHRvIHN5bmMgaGVy
ZS4gT25jZQ0KdGhleSBhcmUgY2xvc2VkIHdlJ2xsIHNlbmQgb3V0IGEgbmV3IHZlcnNpb24gdmVy
eSBzb29uIChob3BlZnVsbHkgdG9tb3Jyb3cpLg0KDQoxKSBIYXZlIGEgZnVsbCBleHBhbmRlZCBi
dWZmZXIgYXQgdkNQVSBjcmVhdGlvbg0KDQpUaGVyZSBhcmUgdHdvIG9wdGlvbnMuDQoNCk9uZSBp
cyB0byBkaXJlY3RseSBhbGxvY2F0ZSBhIGJpZy1lbm91Z2ggYnVmZmVyIHVwb24gZ3Vlc3RfZnB1
OjpwZXJtIGluDQpmcHVfYWxsb2NfZ3Vlc3RfZnBzdGF0ZSgpLiBUaGVyZSBpcyBubyByZWFsbG9j
YXRpb24gcGVyLXNlIHRodXMgbW9zdCBjaGFuZ2VzDQppbiB0aGlzIHNlcmllcyBhcmUgbm90IHJl
cXVpcmVkLg0KDQpUaGUgb3RoZXIgaXMgdG8ga2VlcCB0aGUgcmVhbGxvY2F0aW9uIGNvbmNlcHQg
KHRodXMgYWxsIHByZXZpb3VzIHBhdGNoZXMgYXJlDQprZXB0KSBhbmQgc3RpbGwgY2FsbCBhIHdy
YXBwZXIgYXJvdW5kIF9feGZkX2VuYWJsZV9mZWF0dXJlKCkgZXZlbiBhdCB2Q1BVDQpjcmVhdGlv
biAoZS5nLiByaWdodCBhZnRlciBmcHVfaW5pdF9ndWVzdF9wZXJtaXNzaW9ucygpKS4gVGhpcyBt
YXRjaGVzIHRoZQ0KZnB1IGNvcmUgYXNzdW1wdGlvbiB0aGF0IGZwc3RhdGUgZm9yIHhmZCBmZWF0
dXJlcyBhcmUgZHluYW1pY2FsbHkgYWxsb2NhdGVkLA0KdGhvdWdoIHRoZSBhY3R1YWwgY2FsbGlu
ZyBwb2ludCBtYXkgbm90IGJlIGR5bmFtaWMuIFRoaXMgYWxzbyBhbGxvd3MgdXMNCnRvIGV4cGxv
aXQgZG9pbmcgZXhwYW5zaW9uIGluIEtWTV9TRVRfQ1BVSUQyIChzZWUgbmV4dCkuDQoNCjIpIERv
IGV4cGFuc2lvbiBhdCB2Q1BVIGNyZWF0aW9uIG9yIEtWTV8gU0VUX0NQVUlEMj8NCg0KSWYgdGhl
IHJlYWxsb2NhdGlvbiBjb25jZXB0IGlzIHN0aWxsIGtlcHQsIHRoZW4gd2UgZmVlbCBkb2luZyBl
eHBhbnNpb24gaW4NCktWTV9TRVRfQ1BVSUQyIG1ha2VzIHNsaWdodGx5IG1vcmUgc2Vuc2UuIFRo
ZXJlIGlzIG5vIGZ1bmN0aW9uYWwgDQpkaWZmZXJlbmNlIGJldHdlZW4gdHdvIG9wdGlvbnMgc2lu
Y2UgdGhlIGd1ZXN0IGlzIG5vdCBydW5uaW5nIGF0IHRoaXMgDQpwb2ludC4gQW5kIGluIGdlbmVy
YWwgUWVtdSBzaG91bGQgc2V0IHByY3RsIGFjY29yZGluZyB0byB0aGUgY3B1aWQgYml0cy4gDQpC
dXQgc2luY2UgYW55d2F5IHdlIHN0aWxsIG5lZWQgdG8gY2hlY2sgZ3Vlc3QgY3B1aWQgYWdhaW5z
dCBndWVzdCBwZXJtIGluIA0KS1ZNX1NFVF9DUFVJRDIsIGl0IHJlYWRzIGNsZWFyZXIgdG8gZXhw
YW5kIHRoZSBidWZmZXIgb25seSBhZnRlciB0aGlzIA0KY2hlY2sgaXMgcGFzc2VkLg0KDQpJZiB0
aGlzIGFwcHJvYWNoIGlzIGFncmVlZCwgdGhlbiB3ZSBtYXkgcmVwbGFjZSB0aGUgaGVscGVyIGZ1
bmN0aW9ucyBpbg0KdGhpcyBwYXRjaCB3aXRoIGEgbmV3IG9uZToNCg0KLyoNCiAqIGZwdV91cGRh
dGVfZ3Vlc3RfcGVybV9mZWF0dXJlcyAtIEVuYWJsZSB4ZmVhdHVyZXMgYWNjb3JkaW5nIHRvIGd1
ZXN0IHBlcm0NCiAqIEBndWVzdF9mcHU6CQlQb2ludGVyIHRvIHRoZSBndWVzdCBGUFUgY29udGFp
bmVyDQogKg0KICogRW5hYmxlIGFsbCBkeW5hbWljIHhmZWF0dXJlcyBhY2NvcmRpbmcgdG8gZ3Vl
c3QgcGVybS4gSW52b2tlZCBpZiB0aGUNCiAqIGNhbGxlciB3YW50cyB0byBjb25zZXJ2YXRpdmVs
eSBleHBhbmQgZnBzdGF0ZSBidWZmZXIgaW5zdGVhZCBvZiB3YWl0aW5nDQogKiB1bnRpbCBhIGdp
dmVuIGZlYXR1cmUgaXMgYWNjZXNzZWQuDQogKg0KICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MsIGVy
cm9yIGNvZGUgb3RoZXJ3aXNlDQogKi8NCitpbnQgZnB1X3VwZGF0ZV9ndWVzdF9wZXJtX2ZlYXR1
cmVzKHN0cnVjdCBmcHVfZ3Vlc3QgKmd1ZXN0X2ZwdSkNCit7DQorCXU2NCBleHBhbmQ7DQorDQor
CWxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZW5hYmxlZCgpOw0KKw0KKwlpZiAoIUlTX0VOQUJM
RUQoQ09ORklHX1g4Nl82NCkpDQorCQlyZXR1cm4gMDsNCisNCisJZXhwYW5kID0gZ3Vlc3RfZnB1
LT5wZXJtICYgfmd1ZXN0X2ZwdS0+eGZlYXR1cmVzOw0KKwlpZiAoIWV4cGFuZCkNCisJCXJldHVy
biAwOw0KKw0KKwlyZXR1cm4gX194ZmRfZW5hYmxlX2ZlYXR1cmUoZXhwYW5kLCBndWVzdF9mcHUp
Ow0KK30NCitFWFBPUlRfU1lNQk9MX0dQTChmcHVfdXBkYXRlX2d1ZXN0X2ZlYXR1cmVzKTsNCg0K
MykgQWx3YXlzIGRpc2FibGUgaW50ZXJjZXB0aW9uIG9mIGRpc2FibGUgYWZ0ZXIgMXN0IGludGVy
Y2VwdGlvbj8NCg0KT25jZSB3ZSBjaG9vc2UgdG8gaGF2ZSBhIGZ1bGwgZXhwYW5kZWQgYnVmZmVy
IGJlZm9yZSBndWVzdCBydW5zLCB0aGUNCnBvaW50IG9mIGludGVyY2VwdGluZyBXUk1TUihJQTMy
X1hGRCkgYmVjb21lcyBsZXNzIG9idmlvdXMgc2luY2UNCm5vIGR5bmFtaWMgcmVhbGxvY2F0aW9u
IGlzIHJlcXVpcmVkLg0KDQpPbmUgb3B0aW9uIGlzIHRvIGFsd2F5cyBkaXNhYmxlIFdSTVNSIGlu
dGVyY2VwdGlvbiBvbmNlIA0KS1ZNX1NFVF9DUFVJRDIgc3VjY2VlZHMsIHdpdGggdGhlIGNvc3Qg
b2Ygb25lIFJETVNSIHBlciB2bS1leGl0LiANCkJ1dCBkb2luZyBzbyBhZmZlY3RzIGxlZ2FjeSBP
UyB3aGljaCBldmVuIGhhcyBubyBYRkQgbG9naWMgYXQgYWxsLg0KDQpUaGUgb3RoZXIgb3B0aW9u
IGlzIHRvIGNvbnRpbnVlIHRoZSBjdXJyZW50IHBvbGljeSBpLmUuIGRpc2FibGUgd3JpdGUgDQpl
bXVsYXRpb24gb25seSBhZnRlciB0aGUgMXN0IGludGVyY2VwdGlvbiBvZiBzZXR0aW5nIFhGRCB0
byBhIG5vbi16ZXJvIA0KdmFsdWUuIFRoZW4gdGhlIFJETVNSIGNvc3QgaXMgYWRkZWQgb25seSBm
b3IgZ3Vlc3Qgd2hpY2ggc3VwcG9ydHMgWEZELg0KDQpJbiBlaXRoZXIgY2FzZSB3ZSBuZWVkIGFu
b3RoZXIgaGVscGVyIHRvIHVwZGF0ZSBndWVzdF9mcHUtPmZwc3RhdGUtPnhmZA0KYXMgcmVxdWly
ZWQgaW4gdGhlIHJlc3RvcmUgcGF0aC4gRm9yIHRoZSAybmQgb3B0aW9uIHdlIGZ1cnRoZXIgd2Fu
dA0KdG8gdXBkYXRlIE1TUiBpZiBndWVzdF9mcHUgaXMgY3VycmVudGx5IGluIHVzZToNCg0KK3Zv
aWQgeGZkX3VwZGF0ZV9ndWVzdF94ZmQoc3RydWN0IGZwdV9ndWVzdCAqZ3Vlc3RfZnB1LCB1NjQg
eGZkKQ0KK3sNCisJZnByZWdzX2xvY2soKTsNCisJZ3Vlc3RfZnB1LT5mcHN0YWUtPnhmZCA9IHhm
ZDsNCisJaWYgKGd1ZXN0X2ZwdS0+ZnBzdGF0ZS0+aW5fdXNlKQ0KKwkJeGZkX3VwZGF0ZV9zdGF0
ZShndWVzdF9mcHUtPmZwc3RhdGUpOw0KKwlmcHJlZ3NfdW5sb2NrKCk7DQorfQ0KDQpUaG91Z2h0
cz8NCi0tDQpwLnMuIGN1cnJlbnRseSB3ZSdyZSB3b3JraW5nIG9uIGEgcXVpY2sgcHJvdG90eXBl
IGJhc2VkIG9uOg0KICAtIEV4cGFuZCBidWZmZXIgaW4gS1ZNX1NFVF9DUFVJRDINCiAgLSBEaXNh
YmxlIHdyaXRlIGVtdWxhdGlvbiBhZnRlciBmaXJzdCBpbnRlcmNlcHRpb24NCnRvIGNoZWNrIGFu
eSBvdmVyc2lnaHQuIA0KDQpUaGFua3MNCktldmluDQo=
