Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E542045A
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 00:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhJCWiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 18:38:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:37232 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhJCWiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 18:38:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="222691580"
X-IronPort-AV: E=Sophos;i="5.85,344,1624345200"; 
   d="scan'208";a="222691580"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2021 15:36:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,344,1624345200"; 
   d="scan'208";a="566666029"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 03 Oct 2021 15:36:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 3 Oct 2021 15:36:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sun, 3 Oct 2021 15:36:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 3 Oct 2021 15:36:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJ+zbtU+e0MYzGo2yEdkNiECJOexn8TwxS3Gi2rbNa3ANfSzkwFC/2LaNxC7uAo329WiwGocLuqc9FIcywixXMYdmASvq0X1v3pRnJBzzo/cDlrfmQhEBbulUqYdfXSRqfhTt5+0LzFoImKd5yXJ7mh/swgmaBZViFF9s5KYgXT+1TugC1oQkYSk1dTGoTbGHZL7M7pgVgoM2NiylxyRPqKbOWvxBcCdgZ7tEQNHlSxzWuw40X2OXaJ3moJ8xx7dA27XokAuvHZXgGd40kNxG4odSys3sBO1PNRi5RBUJtudjbmNUOC+ArFnRLO4KACePNg/yDnPfNicdDUtLichDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+F+I0l7KSALm7ERgw22dfAA7Yqe5+16rE0PvICMxmbw=;
 b=ZT6C85H5OHCHA1DtE9JSYaoPC0+PeWW+6+/emMrwxGsI4AEPz/NQuGCZwgKWuZ5O151qvVcoybHrwlA1Z1iLu0Cjwckt4G9W3E9r5VIWViKkffCZis1iw93mKKX+QUTjtWksHvroN3uz5/6imzdSTWXxXETBEXBRoKYDDbthuzF6tt9Q4FcIoob5HolKVmI3lXh9MkimSKGJNHwV3EmwOwi7dGrqMWGasGDOZsrdAJjhW45Xx+NFkJJLh0kQ+YJQBUWU59A0ZBXztjh5Lt+M+kePmXFiaAHucy2VWcXLdQXz0QHDtUxFmHnFulUonZZMsCoZLpKxlV0W+sgfAEmHPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+F+I0l7KSALm7ERgw22dfAA7Yqe5+16rE0PvICMxmbw=;
 b=pt9DQlXotEwcM7cgxgOC0NTJU7qeVAjFeTiO8TN0g4aH9Y1O1k63lDXpyyzJkzr16Yo0/+a1qFn254i3PH5RBnDr626YpbBdE2K277LKM1gMsdmO2wAmt9BrpRtRO52LWNu7vg6teVYp6xRo9gtKdB+JyLbM6yhV5yui8J2cmcI=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5159.namprd11.prod.outlook.com (2603:10b6:510:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Sun, 3 Oct
 2021 22:36:13 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 22:36:13 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "bp@suse.de" <bp@suse.de>, "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 06/28] x86/fpu/xstate: Add new variables to indicate
 dynamic XSTATE buffer size
Thread-Topic: [PATCH v10 06/28] x86/fpu/xstate: Add new variables to indicate
 dynamic XSTATE buffer size
Thread-Index: AQHXmcp0qXPZupfBGU2/j7zlepMzcau+XfOAgAO8mAA=
Date:   Sun, 3 Oct 2021 22:36:13 +0000
Message-ID: <40B953C4-25C8-43F5-BF3D-33FA695FD7B2@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-7-chang.seok.bae@intel.com> <878rzc6fbs.ffs@tglx>
In-Reply-To: <878rzc6fbs.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d1af287-b28d-4b8f-3078-08d986be3487
x-ms-traffictypediagnostic: PH0PR11MB5159:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5159977FB37FA3A402899441D8AD9@PH0PR11MB5159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: on1utlVBHHi/ruhcHNHGQt8EMZZHPVyTRduKDY3CiwT5UnL7nqRIL9lmf36NVFYiKzx7Z/bIviG3gBXFvbbeq478DdaaRXpf+Dl2tMR81jBvIsSK32PSxbsmzKg1T/J/eeAuBf/ma+J2HbDjjAXltE9UlnmeAvDiyW/oB5JhCb/7hVLQskMHP1KAr7SmPlAzB7DJAEqMMHEBgC0Iok7fGnxZpkktRf8IdlkoyHNH5z0SBByFKvw78Bsb+Ff8BkIsZANpSYK+A2sMEtkJF+dIaNfXT0aN36lGEraQAQCc//GdjJe7T/FkC9YsAjfTZiQhiTidXCie91TEAwwKB5w6l5XEo/plBtkss5G3+7AGllenZGbtDOqI3pysYM8QOaBFxzN3YVMRwSu3qbvCjx0D5VJRlMQAcrED1vUu7qlebuMYlsvlOhU1XDwlmCugdL85MY3qzKKCpUnRlWskhBiA2HU7w+ph8pd2GIDoIP6N7Dg3DyvBCFZJAFZc4gmI3SHvwQyT4g3EM1ZbLAUb0G/IFgTel9pziCQBUpAGI8aNhOzvaj8h0vvvwxYJn+aGczRRyzTfy+MfGcQo4GIcR995vfhUlvWLO1szsduBxcIEg5pQh2TFBR5HATgs6hzzELoXXSE0TzDJh5huLPukx+2xLdGicLFe62iiaHkozgbMSTGgaYLgWefuI5ZIa19KVurUUuBnH75URJn6cmFeLV3IxDfv4vuIAvabLeBLOpyZ9h2t+4WyTC1pTCYl4A/UwjSqCCO2YA9nCL88rg/oNZlc+YyEFTpaCCK+2LYD1RXau5yfgtJEN4ff8uwUkYM75RNJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(316002)(54906003)(38100700002)(66476007)(66556008)(64756008)(6512007)(5660300002)(33656002)(66446008)(36756003)(8676002)(53546011)(6506007)(122000001)(66946007)(6916009)(4326008)(86362001)(71200400001)(186003)(83380400001)(76116006)(2616005)(38070700005)(966005)(2906002)(508600001)(26005)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWh1ZHhCVG5hdnhPMzZoZ2VGa2RlZ3hQakF2aEVJMVpEUTBQbGVsQmloRG1a?=
 =?utf-8?B?ZlFuU3NZcEZKM3hSdXp5MklJUlhDdUUxZGEvWTlJK2VjNmVBMnBGZGRVSmN2?=
 =?utf-8?B?djRNeGNOazU1OGJaR2FnMWo0SGRZamJ0d1M4RFhxRitmUGVoWTRGYkpKa1hr?=
 =?utf-8?B?SUQ0eUw3QlZSOStZU2pETVJBdERtYmFYY0dFQWxHZW1JTlpaVzlMVFlwK2xS?=
 =?utf-8?B?WlQraEhUSGNiNVJvR01SWjN2Tkljb0haZHpkcFdua0dOeWhHdXN3N0lGTnNJ?=
 =?utf-8?B?SGloRXE5ajh0bWRsM2FQbGFhQWlDRnlJR0VGdDFyN1V5UzFqbFVpbU10aEY4?=
 =?utf-8?B?a3BveXhOdi8rdkg3b3NyL2FQNW43UWhJRUExbFBER2psTy9qWHhMemt3MWpY?=
 =?utf-8?B?SHE4U3l4dWQ0RjFqTzNydW96NUFLbXRFN1hpNXV3aW42TVAyeGN3OHVaTndl?=
 =?utf-8?B?R2U2M3duWitnUnplTHRkWTl6aHZJaFY1K3NMdkdjWVN6VmRkZ0Z2UDQvZDNB?=
 =?utf-8?B?bWVOL2ZzR0FyczdYdG5NY3AySEoyZ0g1dTFhME9pMGdUR25jaG9MRSsvcXpR?=
 =?utf-8?B?R3dIb3Fod0kxejJ4YWUwNFFJQ1dnNmRXVW5xOXg2d3hUUkRMQmZXekdQREZ4?=
 =?utf-8?B?Zk05aDZCQ0xwSnE2emt6cXJtMUNWZE5UUk5CYWdMMmluUkRobTRTcE9TbWVs?=
 =?utf-8?B?aWlFSy9JUWV2NGY3NnMxa0ltblFUTjZoNHNmZHptL280ODI0Y04rVGNVRDZQ?=
 =?utf-8?B?VjR2aGd1SDlKeWVCZ0FBa3dSTXd4WndYWTd3SXRneUZIQ3I5bHFPVmVJTVlL?=
 =?utf-8?B?ajV1dFRmaE1zTTNrQnVGTU83Z3QrS2JHcFdEbEh3RWxzV2U2VjZ1NWFMVGhv?=
 =?utf-8?B?bmNDMDdKUFBNOU5OLy81N2E1TXdDOTNqM2RoQ0FCMjhTdGhQM1N0NVpnWTRv?=
 =?utf-8?B?VU1DWkdVVUcyT2J0TlRoMEhXQVJTS2xCZ0FpRC94ZS8vUGdKY2ZuRGpDeGJU?=
 =?utf-8?B?N3hERi9ueWtCMUdCZ2pJRFRBbVZiR0xIem56YUxyRHc0emIweXpPc2lyS3pv?=
 =?utf-8?B?ZmFmdE5Xd28zM2lsNlZKeWxQcXZwL2dnNkY1NXNCNUNKMkQ1TG9NUW1Pd0Jz?=
 =?utf-8?B?eFppb0xyekhXcFVleXR2aWtJY1ZuMUMzSVJKR3BzTjVBUzdxdUtPMGpUY3RP?=
 =?utf-8?B?OWhHSUJQTm1iZnkzUFZRbWtrKzhSMUVMbjV1NS9lU2N2Q0Q3cEo1MkFvdUNl?=
 =?utf-8?B?TE9DRTg2ZHAwQzkxdW9MSEJLVzRUbHFqQmQrdCtocG1XWXUrOGZCcnJQN2Zu?=
 =?utf-8?B?bjkyUFVtV0tINFJqU21jeWlQb04ySXVVMFVSL1N6am1LZFV0OVkvMFlKdzgy?=
 =?utf-8?B?UFVlNE5QcTA5TGZjd0lsVEdqanpadnJjU1B5R0QzMzRudWdXODVFZGYzdGlH?=
 =?utf-8?B?cjRMQnBaMy94WHU1aWhJSU4xL3BSQW5XVFNDL1dDZjQ1bTROUHRNK1JqQndl?=
 =?utf-8?B?M1JlWmJxbHN0YS9uM0k4bEYyaFRKaDkzV1pRWmdkUVE2aUN6YUo3YVZhNVJr?=
 =?utf-8?B?eVF6RUk4c2xsZW81UFIyMkpXQ3ByZDlzRXkxeVN3L3pPcXZaL09peDdpNGFy?=
 =?utf-8?B?TjQwOU0zWjdhbG41QWp0OWVaeEpyTC9IL1p6b3pCOTdQNkRRMzMvSTNHSTF0?=
 =?utf-8?B?RklqVlREdHFtZWljckhGeEM3d1NyekdKRUs1YkJGeUVXZkZmODZkRCtVWnJI?=
 =?utf-8?Q?LCuhAv5Fpq3opOeEEQJPsuaXsKCaM13H6vz+8ZX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D27BF7F210B8F4D905A2DBEA64AA426@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d1af287-b28d-4b8f-3078-08d986be3487
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 22:36:13.1624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jwWh5ma3va8cHd9RbQii79t/+4umVC+C4Thtv8GOOWk3AZWcbpb90oXsOwWP6J88aEzAMh1cOH2g1pljs0FllZbr+DvsrLjfAXGPpXqkIiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDEsIDIwMjEsIGF0IDA2OjMyLCBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25p
eC5kZT4gd3JvdGU6DQo+IE9uIFdlZCwgQXVnIDI1IDIwMjEgYXQgMDg6NTMsIENoYW5nIFMuIEJh
ZSB3cm90ZToNCj4+ICsvKioNCj4+ICsgKiBzdHJ1Y3QgZnB1X3hzdGF0ZV9idWZmZXJfY29uZmln
IC0geHN0YXRlIGJ1ZmZlciBjb25maWd1cmF0aW9uDQo+PiArICogQG1heF9zaXplOgkJCVRoZSBD
UFVJRC1lbnVtZXJhdGVkIGFsbC1mZWF0dXJlICJtYXhpbXVtIiBzaXplDQo+PiArICoJCQkJZm9y
IHhzdGF0ZSBwZXItdGFzayBidWZmZXIuDQo+PiArICogQG1pbl9zaXplOgkJCVRoZSBzaXplIHRv
IGZpdCBpbnRvIHRoZSBzdGF0aWNhbGx5LWFsbG9jYXRlZA0KPj4gKyAqCQkJCWJ1ZmZlci4gV2l0
aCBkeW5hbWljIHN0YXRlcywgdGhpcyBidWZmZXIgbm8gbG9uZ2VyDQo+PiArICoJCQkJY29udGFp
bnMgYWxsIHRoZSBlbmFibGVkIHN0YXRlIGNvbXBvbmVudHMuDQo+PiArICogQHVzZXJfc2l6ZToJ
CQlUaGUgc2l6ZSBvZiB1c2VyLXNwYWNlIGJ1ZmZlciBmb3Igc2lnbmFsIGFuZA0KPj4gKyAqCQkJ
CXB0cmFjZSBmcmFtZXMsIGluIHRoZSBub24tY29tcGFjdGVkIGZvcm1hdC4NCj4+ICsgKi8NCj4g
DQo+PiB2b2lkIGZwc3RhdGVfaW5pdChzdHJ1Y3QgZnB1ICpmcHUpDQo+PiB7DQo+PiAJdW5pb24g
ZnByZWdzX3N0YXRlICpzdGF0ZTsNCj4+ICsJdW5zaWduZWQgaW50IHNpemU7DQo+PiArCXU2NCBt
YXNrOw0KPj4gDQo+PiAtCWlmIChsaWtlbHkoZnB1KSkNCj4+ICsJaWYgKGxpa2VseShmcHUpKSB7
DQo+PiAJCXN0YXRlID0gJmZwdS0+c3RhdGU7DQo+PiAtCWVsc2UNCj4+ICsJCS8qIFRoZSBkeW5h
bWljIHVzZXIgc3RhdGVzIGFyZSBub3QgcHJlcGFyZWQgeWV0LiAqLw0KPj4gKwkJbWFzayA9IHhm
ZWF0dXJlc19tYXNrX2FsbCAmIH54ZmVhdHVyZXNfbWFza191c2VyX2R5bmFtaWM7DQo+IA0KPiBU
aGUgcGF0Y2ggb3JkZXJpbmcgaXMgcmVhbGx5IG9kZC4gV2h5IGFyZW4ndCB5b3UgYWRkaW5nDQo+
IA0KPiAgICAgZnB1LT5zdGF0ZV9tYXNrDQo+IGFuZA0KPiAgICAgZnB1LT5zdGF0ZV9zaXplDQo+
IA0KPiBmaXJzdCBhbmQgaW5pdGlhbGl6ZSBzdGF0ZV9tYXNrIGFuZCBzdGF0ZV9zaXplIHRvIHRo
ZSBmaXhlZCBtb2RlIGFuZA0KPiB0aGVuIGFkZCB0aGUgZHluYW1pYyBzaXppbmcgb24gdG9wPw0K
DQpJIG9uY2UgY29uc2lkZXJlZCB0aGUgbmVlZCBvZiByZWZlcmVuY2luZyBmcHUtPnN0YXRlX3Np
emUgaXMgbm90IHRoYXQgbXVjaC4gQXQNCnJ1bnRpbWUsIHRoZSBidWZmZXIgcmUtYWxsb2NhdGlv
biBuZWVkcyB0byBjYWxjdWxhdGUgaXQuIFRoZW4gZnBzdGF0ZV9pbml0KCkNCmFuZCB0aGUgYmVs
b3cgYXJlIHRoZSBvbmVzIHRoYXQgcmVmZXJlbmNlIHRoZSBzaXplLg0KDQpNYXliZSBJIHdhcyB0
b28gY29uc2VydmF0aXZlIGluIGFkZGluZyB0aGlzLiBJ4oCZbSBnb2luZyB0byBmb2xsb3cgeW91
cg0Kc3VnZ2VzdGlvbiBpbiBhIG5ldyBwYXRjaC4NCg0KPj4gCS8qDQo+PiAJICogSWYgdGhlIHRh
cmdldCBGUFUgc3RhdGUgaXMgbm90IHJlc2lkZW50IGluIHRoZSBDUFUgcmVnaXN0ZXJzLCBqdXN0
DQo+PiAJICogbWVtY3B5KCkgZnJvbSBjdXJyZW50LCBlbHNlIHNhdmUgQ1BVIHN0YXRlIGRpcmVj
dGx5IHRvIHRoZSB0YXJnZXQuDQo+PiArCSAqDQo+PiArCSAqIEtWTSBkb2VzIG5vdCBzdXBwb3J0
IGR5bmFtaWMgdXNlciBzdGF0ZXMgeWV0LiBBc3N1bWUgdGhlIGJ1ZmZlcg0KPj4gKwkgKiBhbHdh
eXMgaGFzIHRoZSBtaW5pbXVtIHNpemUuDQo+PiAJICovDQo+PiAJaWYgKHRlc3RfdGhyZWFkX2Zs
YWcoVElGX05FRURfRlBVX0xPQUQpKQ0KPj4gCQltZW1jcHkoJmZwdS0+c3RhdGUsICZjdXJyZW50
LT50aHJlYWQuZnB1LnN0YXRlLA0KPj4gLQkJICAgICAgIGZwdV9rZXJuZWxfeHN0YXRlX3NpemUp
Ow0KPj4gKwkJICAgICAgIGZwdV9idWZfY2ZnLm1pbl9zaXplKTsNCj4gDQo+IFdoaWNoIGNvbXBs
ZXRlbHkgYXZvaWRzIHRoZSBleHBvcnQgb2YgZnB1X2J1Zl9jZmcgZm9yIEtWTSBiZWNhdXNlIHRo
ZQ0KPiBpbmZvcm1hdGlvbiBpcyBqdXN0IGF2YWlsYWJsZSB2aWEgc3RydWMgZnB1LiBBcyBhIGJv
bnVzIHRoZSBleHBvcnQgb2YNCj4gZnB1X2tlcm5lbF94c3RhdGVfc2l6ZSBjYW4gYmUgcmVtb3Zl
ZCBhcyB3ZWxsLg0KPiANCj4gSG1tPw0KDQpZZXMsIGl0IGlzLiBCdXQgSSBzdXNwZWN0IGl0IG5l
ZWRzIHRvIHJlZmVyZW5jZSBzaXplIHZhbHVlcy4gS1ZN4oCZcyBmcHUgZGF0YQ0KY2FuIGJlIGFs
bG9jYXRlZCB3aXRoIHRoZSBtaW4gc2l6ZSwgaW5zdGVhZCBvZiBzaXplb2Yoc3RydWN0IGZwdSku
IEtWTSBjb2RlDQptaWdodCB3YW50IHRvIGtub3cgdGhlIG1heCB0byBzdXBwb3J0IGR5bmFtaWMg
ZmVhdHVyZXMsIGFzIHNpbWlsYXIgdG8gWzFdIG9yDQpzby4NCg0KVGhhbmtzLA0KQ2hhbmcNCg0K
WzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIxMDIwNzE1NDI1Ni41Mjg1MC00LWpp
bmcyLmxpdUBsaW51eC5pbnRlbC5jb20vDQoNCg==
