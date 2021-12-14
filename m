Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0DF473DD0
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 08:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhLNHyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 02:54:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:52152 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231506AbhLNHyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 02:54:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639468450; x=1671004450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6sjxKmtHaXGgDERqRQKtZURwP5THqs6IiCbGVH1592w=;
  b=Mk6MGJapsaer3i/gwbeh9LGMguOTDozQzKztZtZKpluqUkwbx1mMdVPj
   BAvqX+6ICnr9d1V8lDHHQM61UbjLsv1DrvI/CRGHqKGd/a6/8Cgfp9QF+
   EkwpQ5lEga0G9CjaZGkZmX1ALVcUoBVqq5hpJ7rNFsqVo0sysLTewxUQB
   R5Tpj+OrKe0zVe+iR0v8gW59tiKMB8b0uHLIuOAnCk3ue3o2s+XSb6r8R
   WvisiBoeHZfRinPokXHZiuLd88Vv/dxlfozfXI/3gh6fSzgc3H1PRFv6s
   i0s4QnJDAZPp0lDxNFc2i8uSaltJJiLJj+eN7GkPnYnymB7jEPkTy+7K2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="237658585"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="237658585"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 23:54:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="567052538"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 13 Dec 2021 23:54:10 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:54:10 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 23:54:10 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 23:54:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1gestMRst063/J+i80M/IzFmM4nYzwjHlSLKOiQM/mh0AJVj3xgdcVy5UKrvwSJJRFulBKs/24RXuuzuJsePtsp08CX0apMmnS9wMwUJZmSkDncr6Izlx6ALyAzIcK/SAAPutEkZaaahybDxnPwonLHVFAE6BENSZpyjaJSg5cqyNZ+s46Ctm5h84X725VfKf3wkngCUXERQI2MsmB3AWae+4eZK88EyN68lxulE9YN7ncBhF0KhvkGu5f8gEx1didkm8q+q97oFNVcIMTMYA/lLxkbPDjN8kKcgrLwtgeMBIiR0tyHsdn51fGwJ2JD07N93lypr++PagjJGIXnuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sjxKmtHaXGgDERqRQKtZURwP5THqs6IiCbGVH1592w=;
 b=XrPxMSFfW1+6vgu+CbQTYbz09253RTi3gkGu77GXt3IqGU5jRs7BlThEciOvBasgLK5/L7oKwx4BUW39g5skYau8FnJ+wBXDxDg3BAy1If/7nLdMCb5TXo1ZXqJO7AqrLvCEgI0EguANxrimrpjkF02sRBup9R+dGM1CYCD0Q1W+sevV6i6smzT2rcLrijcsoOj49JPrOO97kDYeuEklZCW0YnPv1HF9L8uE+vabNgGptuk7n/PghsdBqrMNFT3dW7C/xiCYtojSD8JklpNvx4SDVxTVtDk3enkryxBWn/9JLirKhuZ5VQV0lYJvjsZeuKU2GmJBZlEuX0IgErdN/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sjxKmtHaXGgDERqRQKtZURwP5THqs6IiCbGVH1592w=;
 b=dIQz5ZgiiN2Ea+bkKpWuRp99or8e3g/GXuDhY/KOFirnPI7Ocv2Ydz/q4xkanK6pJ4tcUgc4NPiKvMmi3aofZ+THyVpmViD7Q8fRpzUlo4zf50vKiMZq+1mAGKgRzUnmLcVv9exoWtP4P+24BYETw2uAoTcFClSG2tiOb2zW8V8=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1572.namprd11.prod.outlook.com (2603:10b6:405:e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Tue, 14 Dec
 2021 07:54:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 07:54:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
Thread-Topic: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
Thread-Index: AQHX8JVdumtpU16HQ0KEkuhbSomwoawxjRoAgAANkoA=
Date:   Tue, 14 Dec 2021 07:54:05 +0000
Message-ID: <BN9PR11MB52768A8341C2E6EBAF3423F58C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <12b5a1e8-89ae-1c56-9568-d774a5016548@linux.intel.com>
In-Reply-To: <12b5a1e8-89ae-1c56-9568-d774a5016548@linux.intel.com>
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
x-ms-office365-filtering-correlation-id: 7c9cb844-c0e4-4af6-db6c-08d9bed6e700
x-ms-traffictypediagnostic: BN6PR11MB1572:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB157230408B2CEEAA304529BD8C759@BN6PR11MB1572.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lq2HtJFnK8s7vm8ndBLHNsB3OZsRtWVTigWaIMRPhYdspW2R3xgIP+pqS3za+PcYvEjFHSXPXk1rgUrqFqgOaFRyer3j9mmqQCHxjyLrRGypT7kLeICFR+3ei+1ITYRX4iaAjTAYbI/pxZOTqShK1xvzvu2z2MQArm/uwDdHRKN9mimRd6XughO2f15R+Yos8iY4seAykGuNp1/xmPjcLNWN5I7s85TSmnI+fg3RjqSIUY7+rgFXmskf+P5/X30SKw8ccmwS09obwVwfxaYfyiOmZw3otPJcbd7p0OQXJzy6yWBp3Li7CpRKF/3WnQKfMIlVoYn9Cpf9ib+Q+2RGiZhababZrEC51jZeUfugFEzMX3DXm2imS7VHS+PkVO1u2gJVPZqqslYahPPf3VgozZon3tOe0VRqZfP7ZLrgh9+mP4HXqGHX5RLdOneDMgjJi/Wsv9LqfsiabPXoVuL/inUvzAaHhIK8hesjvh8yeihlh9sogugckOhidTMRU6H73A7t5nSBUK7Huc9DxWbP7LayBPaMIstVF93HwXoGnmpPOLY0IdJsyxaxXewe+Ch7sKibHFyXenUa0wiR97yyS/FKc0R7Zn/NjHPqVBqg5aJ3bHFcl48DGSKr05YHSvR+C5a+uM5vywklSdEagOzX/rsD5pTNy1E9DwfP9j7BId6Of76TAdH9DFoH6PuHTqGXiR5NI+CwL+NRkm9738Sq6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(86362001)(38100700002)(2906002)(71200400001)(7696005)(64756008)(66946007)(38070700005)(83380400001)(66476007)(186003)(76116006)(66556008)(8936002)(26005)(5660300002)(66446008)(33656002)(110136005)(82960400001)(508600001)(54906003)(9686003)(8676002)(316002)(55016003)(4326008)(52536014)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlYzTFVHOVZaMDhKU1VYSWdncjgvR2ViWTJPUkthVWx0emJURzdBcXFtQTJk?=
 =?utf-8?B?TTEwbStncUcvU0ZkVDJNM0toWUxUcjlsTEpYWllxWFZ2NTByWjI3TDc3NG03?=
 =?utf-8?B?QmdwTHovNWpZRWRwdGcvcjR2VjdoSWVIQkRWYlF4Qi9DWTJuZ0UzN3VRRHFr?=
 =?utf-8?B?VksweHFGQ1RhVml4dU9wUlNteGpSc3loSlVHenBKeFRycGVVT1RwRGdUOUZW?=
 =?utf-8?B?UjAvSkJaUEdTQjNJVHpxaGFjazZRbkRzK3BXZ3BjSXZmNlZmSGpHMkc4RlB1?=
 =?utf-8?B?MjZFMUcydVZxSit0T3VoU0o0alZMbjJsMmVIb3hOQzBIb1ZWek11RmJROVA1?=
 =?utf-8?B?K0w2VEttcGx0NktscnJmZWtUNk05LzdXd3VIVmdXQnBCYU54d1crdm9Hcml1?=
 =?utf-8?B?V0pCT3NJT3dZdHlKRnhZSzRHNjA0QmsvVHBhQTViendnSmN1a0Ftc0l2NUpE?=
 =?utf-8?B?d0c0UVIyTktBNEJPSjVXVUdjM2lXL3pKeGFzZzdHVWdzSjRNb1NRS05kWTRh?=
 =?utf-8?B?U3Q5d1NOTXlZa01zc2xucHBUbWNYNUlyMFdVYWtqYmgxVktGc1dRWkEvMndm?=
 =?utf-8?B?bHRCWFBQbzhqQ0ZMVjY0d2QzNytmdFhwUlZQd0V2T3BGOGNSTnZNdExNVWVT?=
 =?utf-8?B?MHFGQjFCbExuMlZCZmF2NE1aZ2lIblF6Z0hVRFN5ZGlybVYrdkJGNmc1Sy83?=
 =?utf-8?B?U2RXWCswR3NaZFVDTUlPUC9lL2RVZlM2c2QrS20zd1RYbFE3Q2RPZ1dUQVZL?=
 =?utf-8?B?cTRDdHZQOVpCZUtmcGRNQVFEdXFaSDFjbnlUbXFOdHovcXJZclN4WERrb3VZ?=
 =?utf-8?B?WXVpQmxxTXVGZ1kvZUJqVWlrSytHdXpqRmkyVUpZMHllMXJYNURicm5LQ2pJ?=
 =?utf-8?B?aGlFb1V4QXZHSUV2UkFRQzlza29RQ0JMdHo1REZaWHZ2R2VDVnY1d2cvY1Jy?=
 =?utf-8?B?NFp1R0dxSVRmUTNVdjhjMUVKSHJnRDZ4V09DanlNR2FlbDBVU3FER2FKQVZV?=
 =?utf-8?B?RkJyQjJTT3V0RVJPMVpNOURTclo2b3I5WjIyYzhQTitUdGpFR1VTa2NlOG5o?=
 =?utf-8?B?U0N1OU84ZWpHZmw0d0dSSHBIb25rY3RVeHhYQ3ZVbFpaOURadWFWNWM0ME04?=
 =?utf-8?B?WERPWE5jRE1aUkgvOENRZkd4NjhnVURLdFY1MVBJYzZuaExhaU1SbnhRejhX?=
 =?utf-8?B?QVdIOWFlNTMxMnJCRVRBbjZFOWlyRytFNHpBaUR0N1BNOVROYVhOV0JDZjJa?=
 =?utf-8?B?U09TdG9VOFJraHUveDYrbGMwZU85TmtIM2pPTURjMjhSUWtYaEhWUDZMeGNx?=
 =?utf-8?B?ZjI3QlM1eXJieVdrN3gyWnI1QVZIQTFCbWt5UncvYnNJSHJBTm9abmE4VEFq?=
 =?utf-8?B?Y3ZSVmYxc2N5UTh5MXFUcWVERjVRRnpoZjlQTjNDQ0ErQkIrbU5ZaHByWjdZ?=
 =?utf-8?B?V3ZFaE9Jd1ZnSDFlRkVDb1k0aUE2TEFKZUNFWU5LWTkvT0hWNndOakZWZHFC?=
 =?utf-8?B?Y0FTWHJ1QWExTVB4bHZ6OFdpbUFXRUhDb2NlUEluYUU4NWtCMjg0M2xCa2xa?=
 =?utf-8?B?RldqTUxuWEJUVUZqeUJyaW10WEN5Q2JuQUxleWs5Wm1mSDJmMktmSnNQK0dK?=
 =?utf-8?B?QkRKTndTWmR6Q0lIWEtLRkg2SlBLdjdzdlY0a0F2Zjg5MEgrOVFoekZHVW9W?=
 =?utf-8?B?aHNCUHJIWEhOa1FDNjl0bURzS0hURWh4bDBKZngyV1QyMXlqSUlWQk5GalRu?=
 =?utf-8?B?WGtrdVBQQXRzOEw5ZXRIYlN5VzRxSzJmNE1OaUJDaE8yTkhGcllJN0xFUTFa?=
 =?utf-8?B?TTNncHZvcU9zNDlUdHFPMVN5R2NBaDZBT0YwbXhETUNySzNxRjdDUVJBM2Np?=
 =?utf-8?B?akx0SWpQUHN4V2t2RVpSMmRsbkFOU1o0VlhGUEZjLzcwNVc4Vm1VV2lmeFFt?=
 =?utf-8?B?K1Z5OVNhdDdFVXdqYlA3WmYxM2JSV1Uvd3duWHlwTCtIdlYxWG9WZkx3bSto?=
 =?utf-8?B?TGNYNzVadE1WYk9HbmU3SUNVOVJqc3dRNEdyT215ZTdvT3I2WmdiREpHVUFx?=
 =?utf-8?B?ZFl2U1kxaVJaSHRiWXp5NzhnSEc0ME1YY1RXbk9UcUI4Y0xuamZnSnI3YUtX?=
 =?utf-8?B?a0k2M01BN2xxbzE3bU52SFV4THBRSWlvWEtJVTRqK1FzLzBJeEVRMU13UDdh?=
 =?utf-8?Q?HX3+X+44EgrNY/kdbe3Cfpo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9cb844-c0e4-4af6-db6c-08d9bed6e700
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 07:54:05.6074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HumckPUR8T6y0eiEYT89F5SlD0Lej/5pJqsZzbeSKnyDvttP+bRj8dC49KQWkMOMCVi1dufBM6JiMs6/iK4yAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1572
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIEppbmcyIDxqaW5nMi5saXVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBU
dWVzZGF5LCBEZWNlbWJlciAxNCwgMjAyMSAyOjUyIFBNDQo+IA0KPiBPbiAxMi8xNC8yMDIxIDEw
OjUwIEFNLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6DQo+ID4gICAgICAgSWYgTVNSIHdyaXRlIGVt
dWxhdGlvbiBpcyBkaXNhYmxlZCBiZWNhdXNlIHRoZSBidWZmZXIgc2l6ZSBpcw0KPiA+ICAgICAg
IHN1ZmZpY2llbnQgZm9yIGFsbCB1c2UgY2FzZXMsIGkuZS46DQo+ID4NCj4gPiAgICAgICAJCWd1
ZXN0X2ZwdTo6eGZlYXR1cmVzID09IGd1ZXN0X2ZwdTo6cGVybQ0KPiA+DQo+IFRoZSBidWZmZXIg
c2l6ZSBjYW4gYmUgc3VmZmljaWVudCBvbmNlIG9uZSBvZiB0aGUgZmVhdHVyZXMgaXMgcmVxdWVz
dGVkDQo+IHNpbmNlDQo+IGtlcm5lbCBmcHUgcmVhbGxvYyBmdWxsIHNpemUgKHBlcm1pdHRlZCku
IEFuZCBJIHRoaW5rIHdlIGRvbid0IHdhbnQgdG8NCj4gZGlzYWJsZQ0KPiBpbnRlcmNlcHRpb24g
dW50aWwgYWxsIHRoZSBmZWF0dXJlcyBhcmUgZGV0ZWN0ZWQgZS5nLiwgb25lIGJ5IG9uZS4NCj4g
DQo+IFRodXMgaXQgY2FuIGJlIGd1ZXN0X2ZwdTo6eGZlYXR1cmVzICE9IGd1ZXN0X2ZwdTo6cGVy
bS4NCj4gDQoNClRoZXJlIGFyZSB0d28gb3B0aW9ucyB0byBoYW5kbGUgbXVsdGlwbGUgeGZkIGZl
YXR1cmVzLg0KDQphKSBhIGNvbnNlcnZhdGl2ZSBhcHByb2FjaCBhcyBUaG9tYXMgc3VnZ2VzdGVk
LCBpLmUuIGRvbid0IGRpc2FibGUgZW11bGF0aW9uDQogICB1bnRpbCBhbGwgdGhlIGZlYXR1cmVz
IGluIGd1ZXN0X2ZwdTo6cGVybSBhcmUgcmVxdWVzdGVkIGJ5IHRoZSBndWVzdC4gVGhpcw0KICAg
ZGVmaW5pdGVseSBoYXMgcG9vciBwZXJmb3JtYW5jZSBpZiB0aGUgZ3Vlc3Qgb25seSB3YW50cyB0
byB1c2UgYSBzdWJzZXQgb2YNCiAgIHBlcm0gZmVhdHVyZXMuIEJ1dCBmdW5jdGlvbmFsbHkgcC5v
LnYgaXQganVzdCB3b3Jrcy4NCg0KICAgR2l2ZW4gd2Ugb25seSBoYXZlIG9uZSB4ZmVhdHVyZSB0
b2RheSwgbGV0J3MganVzdCB1c2UgdGhpcyBzaW1wbGUgY2hlY2sgd2hpY2gNCiAgIGhhcyBaRVJP
IG5lZ2F0aXZlIGltcGFjdC4NCg0KYikgYW4gb3B0aW1pemVkIGFwcHJvYWNoIGJ5IGR5bmFtaWNh
bGx5IGVuYWJsaW5nL2Rpc2FibGluZyBlbXVsYXRpb24uIGUuZy4NCiAgIHdlIGNhbiBkaXNhYmxl
IGVtdWxhdGlvbiBhZnRlciB0aGUgMXN0IHhmZCBmZWF0dXJlIGlzIGVuYWJsZWQgYW5kIHRoZW4g
DQogICByZWVuYWJsZSBpdCBpbiAjTk0gdm1leGl0IGhhbmRsZXIgd2hlbiBYRkRfRVJSIGluY2x1
ZGVzIGEgYml0IHdoaWNoIGlzIA0KICAgbm90IGluIGd1ZXN0X2ZwdTo6eGZlYXR1cmVzLCBzb3J0
IG9mIGxpa2U6DQoNCgktLXhmZCB0cmFwcGVkLCBwZXJtIGhhcyB0d28geGZkIGZlYXR1cmVzLS0N
CgkoRykgYWNjZXNzIHhmZF9mZWF0dXJlMTsNCgkoSCkgdHJhcCAjTk0gKFhGRF9FUlIgPSB4ZmRf
ZmVhdHVyZTEpIGFuZCBpbmplY3QgI05NOw0KCShHKSBXUk1TUihJQTMyX1hGRCwgKC0xVUxMKSAm
IH54ZmRfZmVhdHVyZTEpOw0KCShIKSByZWFsbG9jYXRlIGZwc3RhdGUgYW5kIGRpc2FibGUgd3Jp
dGUgZW11bGF0aW9uIGZvciBYRkQ7DQoNCgktLXhmZCBwYXNzZWQgdGhyb3VnaC0tDQoJKEcpIGRv
IHNvbWV0aGluZy4uLg0KCShHKSBhY2Nlc3MgeGZkX2ZlYXR1cmUyOw0KCShIKSB0cmFwICNOTSAo
WEZEX0VSUiA9IHhmZF9mZWF0dXJlMiksIGVuYWJsZSBlbXVsYXRpb24sIGluamVjdCAjTk07DQoN
CgktLXhmZCB0cmFwcGVkLS0NCgkoRykgV1JNU1IoSUEzMl9YRkQsICgtMVVMTCkgJiB+KHhmZF9m
ZWF0dXJlMSB8IHhmZF9mZWF0dXJlMikpOw0KCShIKSByZWFsbG9jYXRlIGZwc3RhdGUgYW5kIGRp
c2FibGUgd3JpdGUgZW11bGF0aW9uIGZvciBYRkQ7DQoNCgktLXhmZCBwYXNzZWQgdGhyb3VnaC0t
DQoJKEcpIGRvIHNvbWV0aGluZy4uLg0KDQpUaGFua3MNCktldmluDQo=
