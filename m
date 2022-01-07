Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD84873D8
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiAGIEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:04:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:40757 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345336AbiAGIEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 03:04:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641542641; x=1673078641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JANxAu3mIkVr2q7CwwRAkispUBoaz/bMbPms6dEq8gE=;
  b=avqPs+r2S6ML7YYS+UkkEbYx4KXmNnm9OniX/RV9zrPnF39xMBGy3F1G
   S2cvm8ciXjkWuWDhyQJI2RtD2CTV995iiVj0lKTxyrHbLDsASyxmGqN/p
   jZoT3yod1U536lJOmfejSb58kmoqGlZFPg4DzJjt5pBBvpMVrGIfDsY+H
   oG/vKxwlUJM9j9WHF2hJAGP3lSmbDlbPF2LtsL1fgcMTcoDbfJEAf/fkc
   xRe2Ojs/WQoX+I2c3PWprvcKSmHihD8yCOYFOSWqDMvZcFzSrtfKl1z5x
   b7LSvbofKIJHQaI7vcR8XOn5hEXMQ4GWBGATOj6+RPFQvu8xmqvJzAFtU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="242622581"
X-IronPort-AV: E=Sophos;i="5.88,269,1635231600"; 
   d="scan'208";a="242622581"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 00:04:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,269,1635231600"; 
   d="scan'208";a="489216580"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 07 Jan 2022 00:03:59 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 00:03:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 7 Jan 2022 00:03:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 7 Jan 2022 00:03:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2JXCkKtNt/KWuyoOgGCsgy8mws7qUCILMxJGE5UG3xZWDRshD8ws8K1sq17Fjab0yP/8BlG8t/gNNm8bHqeCzwBPM2UpkNN9dYKU4ew3etcwyj/M3id1gWHp1nEmIY4DEfk9DxUlUiM+EK5L+v7iI4vpgsrY8GXCRHixjKQ6zeoHcPPvjBTumZKjRqRPheXEDkPDwsjLwjbZ/vC7dvpcW7jDzNNhKzKuf1KQVCjzJ9pV6MznaySqoPdD9V9QEZAfceJe+nf8GH1OkJWviWzm2JBqNwrU3AlQkAEUYoC6fX12NZDwx7SRiPCzQxkWhjyA9SGQgYb2LL8TgA4N4dxRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JANxAu3mIkVr2q7CwwRAkispUBoaz/bMbPms6dEq8gE=;
 b=cuN0r+7Yrb6hMVmrYNeY5izRWoEGjCGWJ2tFeDzRNOPhkOtsjlFI4uLt2UjTIvK0AI2HkAbFwElhUB1IjbwRM3dpxrgCuPL28jdjYv4MDbF2E5hs2rrnJCTgN93v0qQO1Yyy6C8Wg8G7nu2dL+QuVdLUzhudgjK/G4IR/+m3RUFQH1oLvrrodbMh8QaTUj2cz1zDhpbpewBNx2h/KwZHp0qnckinqRIxGA1wsYps8+/8A/Ov4ebkRO0XvOS7CTrsHKPEnI6Tob/TkiHWU6b0beO5yigpLJ57sEV/dVfaaGc6ZDZ7nXOilwnjRMeRWqEsBzYB3HjBLQBluRkCqrw9RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1748.namprd11.prod.outlook.com (2603:10b6:404:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 08:03:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.010; Fri, 7 Jan 2022
 08:03:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKxXTBHg
Date:   Fri, 7 Jan 2022 08:03:57 +0000
Message-ID: <BN9PR11MB52769D49A29D1CD7A0C87C888C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
In-Reply-To: <163909282574.728533.7460416142511440919.stgit@omen>
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
x-ms-office365-filtering-correlation-id: 8c37f8b2-ccdf-4e21-6474-08d9d1b441e7
x-ms-traffictypediagnostic: BN6PR11MB1748:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1748DD36D51144221BBE221E8C4D9@BN6PR11MB1748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hEAlGmGdyNRASYN1+qrPGePpaWgi40LTJA4OjhkKQUcFaEWqe7PC5T8/CFRYfehBckCUHgYIQMaUIm/MGASl9xlL7pABZtv5VKw0zkKlISpqKiV3e37E8LyO8rj2ggbVOv9tmQoU8SKd3qRvampCLQr9a+llaNw5HlxJmdCwrYFSCzU51CEG9NrnIQaRByKgVdqoLc12sjDYaAS+UDC3X1FHFuy/Ge8SaDdW9QYAvPz4yhPOu/C8IEl0CYvr0oBFcVx1EjqPLgqrXCWHJlQChe8xjUnXOBv0sU+ORgdX0jF2M+EkAgFmvxmco58gzQAjdaP8atGjVOy9A8P9FNI28o5JQj/7N1d6r7PbUPozTM5gL5himgKN0Q6E4ATLDLfDCcD1uSqOVhXc3drb7vVgR2aIpH10tfWKi2QU4XYBrGambilAxMSn1Jl1n++mOZ7VxQhzi8CXPqgoez5O+mtfdKYeSkPDK4K4bjkDbyncpqOxWDkmWKUwmlDMJVpsIpwM292KI9Q3ceayOw5ADCd5vxbmYme74N4dtukGxmvv5HGYiUmxQKQPsuXc1BBjPRjJNlhUAr9KaBpPCEVmG+DuowS4aQofxYWpeOCc80QR0n/uDlQ2jv2Q5jht149TgVkirPGwTVv2n4wWJXn2cq1g8XAXCoqkxaKzfFVO/iNiQcKUsnKDFH3rS9imUUSkt2NQP+xAcsz10WhBaaO7guluuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(6506007)(5660300002)(33656002)(6916009)(122000001)(9686003)(2906002)(82960400001)(71200400001)(83380400001)(508600001)(66556008)(66476007)(26005)(64756008)(66946007)(66446008)(8676002)(8936002)(4326008)(38100700002)(38070700005)(186003)(316002)(55016003)(7696005)(86362001)(76116006)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azNVNmZIVGU0TjFGaXhIVjE5TnBXS0FvRFAzeHUrdzBCM0txYW1WOGxtdk93?=
 =?utf-8?B?aUo1RXBwVFd3TXhKVU8xWmpuOG1PNERRRGNjS1NEdjM2YmhzOGllQ1hScFkx?=
 =?utf-8?B?Yi9QL2VXUGVSSDhLS0Zjeit3K1RyQ2dySHlwK1pPSDRQYmhTVk9aYkJ4Y1pu?=
 =?utf-8?B?TU1FTk9CUkRIcEFYSC9yamEzb3ZOZHMvZ0tiUnU0RHU4em5iS1BqSnBwbEda?=
 =?utf-8?B?czBsT3Bwd0lodTRkeGdKaXVuUGpFZ3F1WE91VlR1WEVoeC95bk9iMHRZNklB?=
 =?utf-8?B?RkdJbGhWYllMZjZSbGhRWndpSllNd2FUSkQ1NEw0TGFOME9WRndwaS83K3ZN?=
 =?utf-8?B?bVpxZEZ1K2V2OEEzTVAxR00vaEtTczJmcFBHblVzb0pHaUluNmtVaEtiM3Mw?=
 =?utf-8?B?VVZ6OVkrV1ZJUFFzNjMxM2VvSTRCOTQxNXhJUTFJZTQrKzlFNDNUek9ML29t?=
 =?utf-8?B?QlVkRk1ubWprbHZoaTNaWFpYMklFSElkTXRJUmdwTEdpaXh4c3Q2S29oVGw3?=
 =?utf-8?B?K2pMbUIxZWVZUlQyRytOM1BiRWtkWGF1MEEvTGxMN3NNYWJ6YWFTQkpPbUVB?=
 =?utf-8?B?TVEyNVhpTFRYRVZSV1BNSkUxNUQ1NWJXNERveFkxd2xQOXd2MDRqTlY5OFF2?=
 =?utf-8?B?NnJLV3pzOTRKUVdMS0kvSnlVUGUwYnpXNFN2ZFBFaXpvY1JuUm1WcU5ZZ29i?=
 =?utf-8?B?V3lPcWFMb2xmanBSeHBNMk1BdkVpelVGQlNuR3g5bmcyU1R0ZzdtQUtPMHRL?=
 =?utf-8?B?aS9IUjZVaGJOanM1RTJsb1lTLzljb0xoeVA2VW9nRzFpWnFNS0hjQWk5Q0JR?=
 =?utf-8?B?QW5BWmVTMFNKdXRDcWo3NXdWS0RqbHJtMG41WHNxY0ZtV08rK3lBN3JneTF1?=
 =?utf-8?B?WUdMVndyMWlFVVpUQ0lqa2FmVFRyTkN1QzNIaGlkQmJxaFVRam5DcVhreG5k?=
 =?utf-8?B?OExUNGx6d0lxRkpUbm1IVit2OFNZZ285YUJsbHM1MzZqYng3WDhRWk03THUz?=
 =?utf-8?B?V0xxTlNveUhsQXFNUVc3RUsrVlFHNXdDdVJqWU9qQURTN2VQOU54OTI1NmR2?=
 =?utf-8?B?YXVJN3Q4bDc4eHc5SFpBUVhtcnZkdUYvL2xvQ0pWLzRlSUxzMXF3RFkyYmhI?=
 =?utf-8?B?Q3ZMZzhoYUFoR0RFNkhCcmZSUEhrRXpVUVRRdEpNRTFXRHBvZ3F6RW9meTZr?=
 =?utf-8?B?SjVBN1B3b3NjdE4yNWYzSDY5c3VYSmJpZnNjRktWNzJpUW9tUTkvNUpHdVZj?=
 =?utf-8?B?U1JPQjFCalRXUjUrZGhmZ3BwdDRzZzRYNy9PdXdINThiOHVTWS9UYTRDS1hS?=
 =?utf-8?B?Q0RxdUU3UHVBS2hJNHBENHdvU2JCR1dhTzU4bVUzMHRoSjBMVGIwcjFlQU0v?=
 =?utf-8?B?aW4vZEhHSzJ0VWE4WDZNaEt0NmZodEsxV2dVUk5LUHU4S0lkY0pZQUtqNmpv?=
 =?utf-8?B?bEVtSk5LbXFCK3NRZzdVM2xSR1VwTWJwUm45eWczUnpZVDFVYWVTb1R4NVlV?=
 =?utf-8?B?Ump5eTA3blVaNjNEVXgwZnY2SlpSd3g4TXFoUWw0UkNoSllvMmFZYkxsZEQ5?=
 =?utf-8?B?MWFpNmRZSUhPSDBjM3IyMFE3YjZUM1Fuek9kNlhzM3VnNXlNOVBqY3Y2QVUx?=
 =?utf-8?B?RHF6UUJLRjJMN1dtdW4zOHM5MzAwYzZJUTZTZWVIL1ZmY1o3OFBsbVRUVnlR?=
 =?utf-8?B?d3ZTakVCL29XekFTNW0xNDA5VjE0SjV1TW9VSDRwQ0VwMnI2MFBZYXlBS082?=
 =?utf-8?B?OCt4OWJsR0xGcWRRaVEyZkM2S01CTWg4VVgvNkxaVEFEbWFmcjdRcGVuTkxX?=
 =?utf-8?B?YXF3RFJsVDVuS1B2VEY3V0JjdjdkLyt6MXFFOVZkd3VGSy95aFFnSDN1aHkz?=
 =?utf-8?B?bnhOVXVwd1hVUTczNVVvM2NsOHl0SjBweHVaVk16STI4a3ZjcWNpdk90b2ZJ?=
 =?utf-8?B?cGVGbVM5MkJJdkRJV1FFYXRsQWd2UTROWVVkdHpqa3ZaRktmL2Q0ZGVzaEJU?=
 =?utf-8?B?bEh1R1M1aE90UHVoUDgrVjgzUVNibFJ0RTRsbzVGZmdab1NSMFV3eVE4Q2dv?=
 =?utf-8?B?TWFsWXhQMGJpTTFuNkFXeTdML2ozeG1OMkNONFJwZFBDeXdyZ3BDRVJ3R25w?=
 =?utf-8?B?dDFmSDZYOUVuTzhWc2VDVXRCYmtWMC9haFRzMWxBdFY1UjVrVlhtMlhnK0M2?=
 =?utf-8?Q?ipCZ3Ihhh7Vmg4kO9nr6SKo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c37f8b2-ccdf-4e21-6474-08d9d1b441e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 08:03:57.8592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FUBGW2bFuekCwjDgMfaV1vPLlbMwAMoy5uUEPILXzxZvQQivGhBowIEah9EhgpQGi8QJIcRreJ9k2FuIBHZzRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1748
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIEFsZXgsDQoNClRoYW5rcyBmb3IgY2xlYW5pbmcgdXAgdGhpcyBwYXJ0LCB3aGljaCBpcyB2
ZXJ5IGhlbHBmdWwhIA0KDQo+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgRGVjZW1iZXIgMTAsIDIwMjEgNzozNCBBTQ0K
PiANCj4gKyAqDQo+ICsgKiAgIFRoZSBkZXZpY2Vfc3RhdGUgZmllbGQgZGVmaW5lcyB0aGUgZm9s
bG93aW5nIGJpdGZpZWxkIHVzZToNCj4gKyAqDQo+ICsgKiAgICAgLSBCaXQgMCAoUlVOTklORykg
W1JFUVVJUkVEXToNCj4gKyAqICAgICAgICAtIFNldHRpbmcgdGhpcyBiaXQgaW5kaWNhdGVzIHRo
ZSBkZXZpY2UgaXMgZnVsbHkgb3BlcmF0aW9uYWwsIHRoZQ0KPiArICogICAgICAgICAgZGV2aWNl
IG1heSBnZW5lcmF0ZSBpbnRlcnJ1cHRzLCBETUEsIHJlc3BvbmQgdG8gTU1JTywgYWxsIHZmaW8N
Cj4gKyAqICAgICAgICAgIGRldmljZSByZWdpb25zIGFyZSBmdW5jdGlvbmFsLCBhbmQgdGhlIGRl
dmljZSBtYXkgYWR2YW5jZSBpdHMNCj4gKyAqICAgICAgICAgIGludGVybmFsIHN0YXRlLiAgVGhl
IGRlZmF1bHQgZGV2aWNlX3N0YXRlIG11c3QgaW5kaWNhdGUgdGhlIGRldmljZQ0KPiArICogICAg
ICAgICAgaW4gZXhjbHVzaXZlbHkgdGhlIFJVTk5JTkcgc3RhdGUsIHdpdGggbm8gb3RoZXIgYml0
cyBpbiB0aGlzIGZpZWxkDQo+ICsgKiAgICAgICAgICBzZXQuDQo+ICsgKiAgICAgICAgLSBDbGVh
cmluZyB0aGlzIGJpdCAoaWUuICFSVU5OSU5HKSBtdXN0IHN0b3AgdGhlIG9wZXJhdGlvbiBvZiB0
aGUNCj4gKyAqICAgICAgICAgIGRldmljZS4gIFRoZSBkZXZpY2UgbXVzdCBub3QgZ2VuZXJhdGUg
aW50ZXJydXB0cywgRE1BLCBvciBhZHZhbmNlDQo+ICsgKiAgICAgICAgICBpdHMgaW50ZXJuYWwg
c3RhdGUuIA0KDQpJJ20gY3VyaW91cyBhYm91dCB3aGF0IGl0IG1lYW5zIGZvciB0aGUgbWVkaWF0
ZWQgZGV2aWNlLiBJIHN1cHBvc2UgdGhpcyANCidtdXN0IG5vdCcgY2xhdXNlIGlzIGZyb20gdXNl
ciBwLm8udiBpLmUuIG5vIGV2ZW50IGRlbGl2ZXJlZCB0byB0aGUgdXNlciwgDQpubyBETUEgdG8g
dXNlciBtZW1vcnkgYW5kIG5vIHVzZXIgdmlzaWJsZSBjaGFuZ2Ugb24gbWRldiBzdGF0ZS4gUGh5
c2ljYWxseSANCnRoZSBkZXZpY2UgcmVzb3VyY2UgYmFja2luZyB0aGUgbWRldiBtYXkgc3RpbGwg
Z2VuZXJhdGUgaW50ZXJydXB0L0RNQSANCnRvIHRoZSBob3N0IGFjY29yZGluZyB0byB0aGUgbWVk
aWF0aW9uIHBvbGljeS4NCg0KSXMgdGhpcyB1bmRlcnN0YW5kaW5nIGNvcnJlY3Q/DQoNCj4gKyog
ICAgICAgICAgIFRoZSB1c2VyIHNob3VsZCB0YWtlIHN0ZXBzIHRvIHJlc3RyaWN0IGFjY2Vzcw0K
PiArICogICAgICAgICAgdG8gdmZpbyBkZXZpY2UgcmVnaW9ucyBvdGhlciB0aGFuIHRoZSBtaWdy
YXRpb24gcmVnaW9uIHdoaWxlIHRoZQ0KPiArICogICAgICAgICAgZGV2aWNlIGlzICFSVU5OSU5H
IG9yIHJpc2sgY29ycnVwdGlvbiBvZiB0aGUgZGV2aWNlIG1pZ3JhdGlvbiBkYXRhDQo+ICsgKiAg
ICAgICAgICBzdHJlYW0uICBUaGUgZGV2aWNlIGFuZCBrZXJuZWwgbWlncmF0aW9uIGRyaXZlciBt
dXN0IGFjY2VwdCBhbmQNCj4gKyAqICAgICAgICAgIHJlc3BvbmQgdG8gaW50ZXJhY3Rpb24gdG8g
c3VwcG9ydCBleHRlcm5hbCBzdWJzeXN0ZW1zIGluIHRoZQ0KPiArICogICAgICAgICAgIVJVTk5J
Tkcgc3RhdGUsIGZvciBleGFtcGxlIFBDSSBNU0ktWCBhbmQgUENJIGNvbmZpZyBzcGFjZS4NCg0K
YW5kIGFsc28gcmVzcG9uZCB0byBtbWlvIGFjY2VzcyBpZiBzb21lIHN0YXRlIGlzIHNhdmVkIHZp
YSByZWFkaW5nIG1taW8/DQoNCj4gKyAqICAgICAgICAgIEZhaWx1cmUgYnkgdGhlIHVzZXIgdG8g
cmVzdHJpY3QgZGV2aWNlIGFjY2VzcyB3aGlsZSAhUlVOTklORyBtdXN0DQo+ICsgKiAgICAgICAg
ICBub3QgcmVzdWx0IGluIGVycm9yIGNvbmRpdGlvbnMgb3V0c2lkZSB0aGUgdXNlciBjb250ZXh0
IChleC4NCj4gKyAqICAgICAgICAgIGhvc3Qgc3lzdGVtIGZhdWx0cykuDQo+ICsgKiAgICAgLSBC
aXQgMSAoU0FWSU5HKSBbUkVRVUlSRURdOg0KPiArICogICAgICAgIC0gU2V0dGluZyB0aGlzIGJp
dCBlbmFibGVzIGFuZCBpbml0aWFsaXplcyB0aGUgbWlncmF0aW9uIHJlZ2lvbiBkYXRhDQo+ICsg
KiAgICAgICAgICB3aW5kb3cgYW5kIGFzc29jaWF0ZWQgZmllbGRzIHdpdGhpbiB2ZmlvX2Rldmlj
ZV9taWdyYXRpb25faW5mbyBmb3INCj4gKyAqICAgICAgICAgIGNhcHR1cmluZyB0aGUgbWlncmF0
aW9uIGRhdGEgc3RyZWFtIGZvciB0aGUgZGV2aWNlLiAgVGhlIG1pZ3JhdGlvbg0KPiArICogICAg
ICAgICAgZHJpdmVyIG1heSBwZXJmb3JtIGFjdGlvbnMgc3VjaCBhcyBlbmFibGluZyBkaXJ0eSBs
b2dnaW5nIG9mIGRldmljZQ0KPiArICogICAgICAgICAgc3RhdGUgd2l0aCB0aGlzIGJpdC4gIFRo
ZSBTQVZJTkcgYml0IGlzIG11dHVhbGx5IGV4Y2x1c2l2ZSB3aXRoIHRoZQ0KPiArICogICAgICAg
ICAgUkVTVU1JTkcgYml0IGRlZmluZWQgYmVsb3cuDQo+ICsgKiAgICAgICAgLSBDbGVhcmluZyB0
aGlzIGJpdCAoaWUuICFTQVZJTkcpIGRlLWluaXRpYWxpemVzIHRoZSBtaWdyYXRpb24gcmVnaW9u
DQo+ICsgKiAgICAgICAgICBkYXRhIHdpbmRvdyBhbmQgaW5kaWNhdGVzIHRoZSBjb21wbGV0aW9u
IG9yIHRlcm1pbmF0aW9uIG9mIHRoZQ0KPiArICogICAgICAgICAgbWlncmF0aW9uIGRhdGEgc3Ry
ZWFtIGZvciB0aGUgZGV2aWNlLg0KPiArICogICAgIC0gQml0IDIgKFJFU1VNSU5HKSBbUkVRVUlS
RURdOg0KPiArICogICAgICAgIC0gU2V0dGluZyB0aGlzIGJpdCBlbmFibGVzIGFuZCBpbml0aWFs
aXplcyB0aGUgbWlncmF0aW9uIHJlZ2lvbiBkYXRhDQo+ICsgKiAgICAgICAgICB3aW5kb3cgYW5k
IGFzc29jaWF0ZWQgZmllbGRzIHdpdGhpbiB2ZmlvX2RldmljZV9taWdyYXRpb25faW5mbyBmb3IN
Cj4gKyAqICAgICAgICAgIHJlc3RvcmluZyB0aGUgZGV2aWNlIGZyb20gYSBtaWdyYXRpb24gZGF0
YSBzdHJlYW0gY2FwdHVyZWQgZnJvbSBhDQo+ICsgKiAgICAgICAgICBTQVZJTkcgc2Vzc2lvbiB3
aXRoIGEgY29tcGF0aWJsZSBkZXZpY2UuICBUaGUgbWlncmF0aW9uIGRyaXZlciBtYXkNCj4gKyAq
ICAgICAgICAgIHBlcmZvcm0gaW50ZXJuYWwgZGV2aWNlIHJlc2V0cyBhcyBuZWNlc3NhcnkgdG8g
cmVpbml0aWFsaXplIHRoZQ0KPiArICogICAgICAgICAgaW50ZXJuYWwgZGV2aWNlIHN0YXRlIGZv
ciB0aGUgaW5jb21pbmcgbWlncmF0aW9uIGRhdGEuDQo+ICsgKiAgICAgICAgLSBDbGVhcmluZyB0
aGlzIGJpdCAoaWUuICFSRVNVTUlORykgZGUtaW5pdGlhbGl6ZXMgdGhlIG1pZ3JhdGlvbg0KPiAr
ICogICAgICAgICAgcmVnaW9uIGRhdGEgd2luZG93IGFuZCBpbmRpY2F0ZXMgdGhlIGVuZCBvZiBh
IHJlc3VtaW5nIHNlc3Npb24gZm9yDQo+ICsgKiAgICAgICAgICB0aGUgZGV2aWNlLiAgVGhlIGtl
cm5lbCBtaWdyYXRpb24gZHJpdmVyIHNob3VsZCBjb21wbGV0ZSB0aGUNCj4gKyAqICAgICAgICAg
IGluY29ycG9yYXRpb24gb2YgZGF0YSB3cml0dGVuIHRvIHRoZSBtaWdyYXRpb24gZGF0YSB3aW5k
b3cgaW50byB0aGUNCj4gKyAqICAgICAgICAgIGRldmljZSBpbnRlcm5hbCBzdGF0ZSBhbmQgcGVy
Zm9ybSBmaW5hbCB2YWxpZGl0eSBhbmQgY29uc2lzdGVuY3kNCj4gKyAqICAgICAgICAgIGNoZWNr
aW5nIG9mIHRoZSBuZXcgZGV2aWNlIHN0YXRlLiAgSWYgdGhlIHVzZXIgcHJvdmlkZWQgZGF0YSBp
cw0KPiArICogICAgICAgICAgZm91bmQgdG8gYmUgaW5jb21wbGV0ZSwgaW5jb25zaXN0ZW50LCBv
ciBvdGhlcndpc2UgaW52YWxpZCwgdGhlDQo+ICsgKiAgICAgICAgICBtaWdyYXRpb24gZHJpdmVy
IG11c3QgaW5kaWNhdGUgYSB3cml0ZSgyKSBlcnJvciBhbmQgZm9sbG93IHRoZQ0KPiArICogICAg
ICAgICAgcHJldmlvdXNseSBkZXNjcmliZWQgcHJvdG9jb2wgdG8gcmV0dXJuIGVpdGhlciB0aGUg
cHJldmlvdXMgc3RhdGUNCj4gKyAqICAgICAgICAgIG9yIGFuIGVycm9yIHN0YXRlLg0KPiArICog
ICAgIC0gQml0IDMgKE5ETUEpIFtPUFRJT05BTF06DQo+ICsgKiAgICAgICAgVGhlIE5ETUEgb3Ig
Ik5vIERNQSIgc3RhdGUgaXMgaW50ZW5kZWQgdG8gYmUgYSBxdWllc2NlbnQgc3RhdGUgZm9yDQo+
ICsgKiAgICAgICAgdGhlIGRldmljZSBmb3IgdGhlIHB1cnBvc2VzIG9mIG1hbmFnaW5nIG11bHRp
cGxlIGRldmljZXMgd2l0aGluIGENCj4gKyAqICAgICAgICB1c2VyIGNvbnRleHQgd2hlcmUgcGVl
ci10by1wZWVyIERNQSBiZXR3ZWVuIGRldmljZXMgbWF5IGJlIGFjdGl2ZS4NCg0KQXMgZGlzY3Vz
c2VkIHdpdGggSmFzb24gaW4gYW5vdGhlciB0aHJlYWQsIHRoaXMgaXMgYWxzbyByZXF1aXJlZCBm
b3IgdlBSSQ0Kd2hlbiBzdG9wcGluZyBETUEgaW52b2x2ZXMgY29tcGxldGluZyAoaW5zdGVhZCBv
ZiBwcmVlbXB0aW5nKSBpbi1mbHkNCnJlcXVlc3RzIHRoZW4gYW55IHZQUkkgZm9yIHRob3NlIHJl
cXVlc3RzIG11c3QgYmUgY29tcGxldGVkIHdoZW4gdmNwdSANCmlzIHJ1bm5pbmcuIFRoaXMgY2Fu
bm90IGJlIGRvbmUgaW4gIVJVTk5JTkcgd2hpY2ggaXMgdHlwaWNhbGx5IHRyYW5zaXRpb25lZCAN
CnRvIGFmdGVyIHN0b3BwaW5nIHZjcHUuDQoNCkl0IGlzIGFsc28gdXNlZnVsIHdoZW4gdGhlIHRp
bWUgb2Ygc3RvcHBpbmcgZGV2aWNlIERNQSBpcyB1bmJvdW5kIChldmVuDQp3aXRob3V0IHZQUkkp
LiBIYXZpbmcgYSBmYWlsdXJlIHBhdGggd2hlbiB2Y3B1IGlzIHJ1bm5pbmcgYXZvaWRzIGJyZWFr
aW5nIA0KU0xBIChpZiBvbmx5IGNhcHR1cmluZyBpdCBhZnRlciBzdG9wcGluZyB2Y3B1KS4gVGhp
cyBmdXJ0aGVyIHJlcXVpcmVzIGNlcnRhaW4NCmludGVyZmFjZSBmb3IgdGhlIHVzZXIgdG8gc3Bl
Y2lmeSBhIHRpbWVvdXQgdmFsdWUgZm9yIGVudGVyaW5nIE5ETUEsIHRob3VnaA0KdW5jbGVhciB0
byBtZSB3aGF0IGl0IHdpbGwgYmUgbm93Lg0KDQo+ICsgKiAgICAgICAgU3VwcG9ydCBmb3IgdGhl
IE5ETUEgYml0IGlzIGluZGljYXRlZCB0aHJvdWdoIHRoZSBwcmVzZW5jZSBvZiB0aGUNCj4gKyAq
ICAgICAgICBWRklPX1JFR0lPTl9JTkZPX0NBUF9NSUdfTkRNQSBjYXBhYmlsaXR5IGFzIHJlcG9y
dGVkIGJ5DQo+ICsgKiAgICAgICAgVkZJT19ERVZJQ0VfR0VUX1JFR0lPTl9JTkZPIGZvciB0aGUg
YXNzb2NpYXRlZCBkZXZpY2UgbWlncmF0aW9uDQo+ICsgKiAgICAgICAgcmVnaW9uLg0KPiArICog
ICAgICAgIC0gU2V0dGluZyB0aGlzIGJpdCBtdXN0IHByZXZlbnQgdGhlIGRldmljZSBmcm9tIGlu
aXRpYXRpbmcgYW55DQo+ICsgKiAgICAgICAgICBuZXcgRE1BIG9yIGludGVycnVwdCB0cmFuc2Fj
dGlvbnMuICBUaGUgbWlncmF0aW9uIGRyaXZlciBtdXN0DQoNCldoeSBhbHNvIGRpc2FibGluZyBp
bnRlcnJ1cHQ/IHZjcHUgaXMgc3RpbGwgcnVubmluZyBhdCB0aGlzIHBvaW50IHRodXMgaW50ZXJy
dXB0DQpjb3VsZCBiZSB0cmlnZ2VyZWQgZm9yIG1hbnkgcmVhc29ucyBvdGhlciB0aGFuIERNQS4u
Lg0KDQo+ICsgKiAgICAgICAgICBjb21wbGV0ZSBhbnkgc3VjaCBvdXRzdGFuZGluZyBvcGVyYXRp
b25zIHByaW9yIHRvIGNvbXBsZXRpbmcNCj4gKyAqICAgICAgICAgIHRoZSB0cmFuc2l0aW9uIHRv
IHRoZSBORE1BIHN0YXRlLiAgVGhlIE5ETUEgZGV2aWNlX3N0YXRlDQo+ICsgKiAgICAgICAgICBl
c3NlbnRpYWxseSByZXByZXNlbnRzIGEgc3ViLXNldCBvZiB0aGUgIVJVTk5JTkcgc3RhdGUgZm9y
IHRoZQ0KPiArICogICAgICAgICAgcHVycG9zZSBvZiBxdWllc2NpbmcgdGhlIGRldmljZSwgdGhl
cmVmb3JlIHRoZSBORE1BIGRldmljZV9zdGF0ZQ0KPiArICogICAgICAgICAgYml0IGlzIHN1cGVy
Zmx1b3VzIGluIGNvbWJpbmF0aW9ucyBpbmNsdWRpbmcgIVJVTk5JTkcuDQoNCidzdXBlcmZsdW91
cycgbWVhbnMgZG9pbmcgc28gd2lsbCBnZXQgYSBmYWlsdXJlLCBvciBqdXN0IG5vdCByZWNvbW1l
bmRlZD8NCg0KPiArICogICAgICAgIC0gQ2xlYXJpbmcgdGhpcyBiaXQgKGllLiAhTkRNQSkgbmVn
YXRlcyB0aGUgZGV2aWNlIG9wZXJhdGlvbmFsDQo+ICsgKiAgICAgICAgICByZXN0cmljdGlvbnMg
cmVxdWlyZWQgYnkgdGhlIE5ETUEgc3RhdGUuDQo+ICsgKiAgICAgLSBCaXRzIFszMTo0XToNCj4g
KyAqICAgICAgICBSZXNlcnZlZCBmb3IgZnV0dXJlIHVzZSwgdXNlcnMgc2hvdWxkIHVzZSByZWFk
LW1vZGlmeS13cml0ZQ0KPiArICogICAgICAgIG9wZXJhdGlvbnMgdG8gdGhlIGRldmljZV9zdGF0
ZSBmaWVsZCBmb3IgbWFuaXB1bGF0aW9uIG9mIHRoZSBhYm92ZQ0KPiArICogICAgICAgIGRlZmlu
ZWQgYml0cyBmb3Igb3B0aW1hbCBjb21wYXRpYmlsaXR5Lg0KPiArICoNCg0KVGhhbmtzDQpLZXZp
bg0K
