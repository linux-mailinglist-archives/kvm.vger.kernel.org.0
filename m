Return-Path: <kvm+bounces-5137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A1D81C88C
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 11:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13CEE1C22234
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5853C168B6;
	Fri, 22 Dec 2023 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BQMWAaD/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D48156C4;
	Fri, 22 Dec 2023 10:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/AIMpTYZLmP3h8emLpzsUx0RpFCV6mNneVEYeqGuAXU20BWDKngdS1vyv0wahLE8P7lbz/ivPtVF5htOCHCO6RYvo4D5wrugfbLp5+u3wZnGFbOm0jy4lPjXtqEgewbo0DazIi43g4GDfbf0ZKyi8Y72wu2X2q7x29zKhaa9oZhwHCZ7wVc+f8MERg3fNnai/NJP8s/VuvdHzS4N/SIGyXmAeXfqywQ9oq6pZczfVXQk3Ai3PWkD7v54TwrIbQyH8QMuTfPdNKhQBrN9YDTcxLM1ErgVamB6v8YFPcr098i+jn8sEa08VQZMPaiz7AtlR9CtB+KS2Y4CAyjA72Qxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WtLSYfsqPKr1A6/3E13hymlTqkqcqf+qXuh/3dzPeg=;
 b=jq8hQUsrkSlWCw7LbAGzbsToL6lJHUwOUtkX0wG1KaYndePaUvzlszpfjaeyXMHK87Zv85qvuX6DLUsCPtz/fjj1/TM+pJzjnOkIgiRB1tHnsUrrCmA3yr9XycBda9BWE0u9CVyrkezS0r1SlUzS8dOJ4Zl/K4F44nKC6gzZoQhlRjCn/yXJSxMNRqThfOY9GwGhkKbZtaiyToXsG8/Y8//ndma0WLhx8s1nkjd84NTkW8XiMaO3jSRRMMNqVPtSEwLtKC5ORcm22CD6znOzn9mkBFrSoS6YngZKbb9CvAEq1c9KpvMIvmPihZUvPMcsO9LaWJ21RNySVr6h2ve8dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WtLSYfsqPKr1A6/3E13hymlTqkqcqf+qXuh/3dzPeg=;
 b=BQMWAaD/vs27ls7mUWohGrv2ozc+j25/HwufkC25ZibutLa2m0Znu8gpM+6ZHzEJ/T/RH9G4kihBl5UAF2LUaoZTlEi0Rq4yu/ER6d7xk8woIeq6ywQXeOgvti48LOCz+pDfFS3ntFKYh2igpsMxrtVGYyPMJQLSr0nrT67xvgh5T0Z6rymri02S68MTQ5o2SO06MoSTnOKDqimW2dkxHS8/rKldiWxM5rI9XrtzVbL4ZkYXRWrDQhzevWoXl1Q57ZJhTjIReX8hoiZnqkrkJttvnLGWo5yV0VQTuY5LVIWuvkYhhF+THQTSn7htNou/UD6h7cLxzTWKvf9OUO4hGQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by SJ0PR12MB8090.namprd12.prod.outlook.com (2603:10b6:a03:4ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Fri, 22 Dec
 2023 10:51:13 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.019; Fri, 22 Dec 2023
 10:51:13 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Topic: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Index:
 AQHaMqaBunnLiYiUz0i03/j7bu1zQ7CxiQYAgAAFTwCAAJ4xgIAA0diAgABf+YCAAES4AIAABHKAgAAp1ICAAATiAIAAA0UAgAEjDACAACe4gA==
Date: Fri, 22 Dec 2023 10:51:13 +0000
Message-ID: <a67c3ee375b1ae4aac5cc39539e1a25e23bf4f07.camel@nvidia.com>
References:
 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
	 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
	 <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com>
	 <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
	 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
	 <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
	 <CAJaqyWeUHiZXMFkNBpinCsJAXojtPkGz+SjzUNDPx5W=qqON1w@mail.gmail.com>
	 <c03eb2bb3ad76e28be2bb9b9e4dee4c3bc062ea7.camel@nvidia.com>
	 <CAJaqyWevZX5TKpaLiJwu2nD7PHFsHg+TEZ=iPdWvrH4jyPV+cA@mail.gmail.com>
	 <17abeefd02c843cddf64efbeadde49ad15c365a1.camel@nvidia.com>
	 <20231222032713-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231222032713-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|SJ0PR12MB8090:EE_
x-ms-office365-filtering-correlation-id: 2658ff02-b546-477e-12f0-08dc02dbea4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 8DR6Bbk+uxuuxG+xr8FG5JjK47C7zEa2rqCRV8BYDG2gPZXTo/0McHJhiT2k1Pz82JwvWQ8W9HkZMwO/HbOj96xsYVvHl9I+kOuYd4J/gK4gJ02kVefaYopPxA6AsUdD5rKZWJuMQ1Z4654DnoATGpe/Ny9P6AYXcexUjShU0gVP8u144FTQuXCiZtRzfQvigqoJ3JzHFT4+eok+ZosB45Xc1Pc8SNsx5UGFY8+tgPXuHNqkE4ksSBQ9mYkDn0W/whQOdLMRW0+T+Ho1C3vQ+1x0NxDvBv2TqdGtoQuULl0JaSWnFqX7LAuSDX+evvMskzU2KywzpuJJwJXzrRiAglucZF2LuQ9YY07FpQjxq0SJpJ56avsecnhUdOSdKGDpRanAHijawvjhiR81r947HR4nWJPT2MOTKisyZuKb/OOYU7rIoeoVK4M2yj1qLdZaXIdTmOJ2zj3zLukEaaHLI/SU+cYlvL5fyRmCZomzwKjf4HB1S3Tl6e0oAH//H0Loix7ozqCMkWV5LuRz9Q4cQs1Ode0runNpYVF0pfMVkv8t3CMBJdzvVA8HdC8p7aQ/HphfGnge3maFCZOLsS/jCvx7HNV+V52yE5vFrdNi7LRHcg9uBHxKJdSdOYWieLqh
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(396003)(376002)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6506007)(6512007)(5660300002)(478600001)(71200400001)(6486002)(83380400001)(2616005)(54906003)(316002)(6916009)(64756008)(91956017)(66476007)(66946007)(66556008)(66446008)(76116006)(8676002)(8936002)(122000001)(4326008)(38070700009)(41300700001)(2906002)(86362001)(36756003)(38100700002)(4001150100001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YUNXclhhZ0g2b2JHSk9QM3M5cTAyYXI4WGJGaXY1NXBwNzVjckdmeWs3cHY0?=
 =?utf-8?B?eHZzbXFjaFdkekJibk0wSnloVmdwNUJlUHFGS2lqT3Qrd1h1TmxneEVrU1hz?=
 =?utf-8?B?MXA1dFBGMFFlQW42bVJNeC9ZcnpQUHVQdDlSTGVSTEd0NzRpMmRqVFZOUXdo?=
 =?utf-8?B?azEzYTR1S3dGUHVmYlBObmxCOU56dmZvbUlUdDBvQnV5U0ZmSzhiMUlHN1VI?=
 =?utf-8?B?MmJuR3ZHU1RsZkFtbXVOUUUzRlYwVkI0R29lRmNJbFVLN0hKZFlmWmFKeHVH?=
 =?utf-8?B?clNYcXZjZFErTDBaM0VSL1RPUGxNS0d3b0lhUnFTbG01cGcrV09FcngrVTlx?=
 =?utf-8?B?QkU2dS9FNE0vQkVkaWpCVnpBYlI5T0U1MXoycmxyZ29qbHIvMkdjaHVmblF6?=
 =?utf-8?B?aVdUSTF1MHpxT2lQYTYwVjZqUDM5S1dla2dReUNYL3ZvUFhCV0Q0U3gxYWow?=
 =?utf-8?B?N3EwWkYySSs5bk00ckJTOGpxelJnR2F5SFRMWW85cThFZ3RVbGhlWm5OdFdT?=
 =?utf-8?B?TU5jZUVnVFp6NktrWmkwNjYrbWhheFg1eHRUaXdvSitzckcxWmdab1RSZjJU?=
 =?utf-8?B?Z29kUWZKdkVIeVkrVlY2eUo2UXorS3htUU9FdjFDL1VxVkRzMG42SzFuVURj?=
 =?utf-8?B?a3Ywa2JkSUdJUnpMcjZHQVFSQ2tGc0NLa2ZaK25JMFZsVUVkS292RnlaQU9l?=
 =?utf-8?B?aVJ1SFFtMVdRMW9nSDJySmJPdFYzdzAzUVRERXVXTWZocm1OQnJiWXJsS05T?=
 =?utf-8?B?cDhEUDNRdkg5SlZUWi85Qm9hOEZvZlhwbjJWVVF6aTJYY0RFVjlJMWlwd3Z1?=
 =?utf-8?B?VFZ0SlMrTkJFalh4bko2aU5yQzd0OE1TS0Z2WjNmbVd2dVVnc1U3UmJ3UVpR?=
 =?utf-8?B?Q1NqV3UxWUYrbXo2cU9sc1BpTHZNa1BxK1k0VTZjUDNDSmdLMHAvZGFMQlk5?=
 =?utf-8?B?am9hR1pyS3F0L3VTSXlGU1VjU1JvaWpXR2NDY1h1Q0hPSWx6ZnoyRG9yS0Zj?=
 =?utf-8?B?K1RPSFk3VXZiMVRrdEQvc29NTkRKL2FFaUhvVkx4OWI5WjFhUFBvRW1ZREZu?=
 =?utf-8?B?WVNlZXpBTDFjbGVEcVAwWmpWQ3RwdU9GK3pxYkd6Z1VQQmtyOFQzclJiMTVo?=
 =?utf-8?B?MmJCYmFTTW5xNVg0QmU2TktNVk9tN0NIdWtuNFBWS2pxS0NWVi9wUlIySDFD?=
 =?utf-8?B?dUxURStpZ0VvcjVJV1MzNFVFMGw2blhKWjlud09VLytXTFRibmN2bEtJMU1Y?=
 =?utf-8?B?RW50UjFQckdMREtTbXJObGdPbllvU0doamZUKytTaWovVy9mM1BpWFVjTjdW?=
 =?utf-8?B?MU4xTWJGWjA3ZWoxRVFyaUZkei9COWsrWitCVW4rMlJHMnl3NWJaME5CRkxj?=
 =?utf-8?B?cGF3N2JXd3RzVW1kMVBCQ29leUJUanRCdUV4WWg3MjdpeEFKU2hNMHZmTkxo?=
 =?utf-8?B?dzVGN2M4VHhQUmZMald6VGtWWDIwMnlYRkR4ZmFHNmNiTFBkbDdsdmVZUGJ6?=
 =?utf-8?B?ejB2VG4zdFNvNW43c3dKcjAzWUNGM1lmbG0wTGdjZFFCeGZGSWcvak8yVlNq?=
 =?utf-8?B?TmF2bGdGREZyK2JWbHc2d25odGdFMUk2RXd2S0NsSzdSRGp5OFg1K2p0ZzF6?=
 =?utf-8?B?QUdLck9UR1BlRmhldFFBVWRObzVITitnRzRySS9Da0F1OEp2Q2c0VWJ6eVgr?=
 =?utf-8?B?UU9WdFhJSGk4K0p3bmZmSDJTUlovOW9jUjhMU1FTdmhXZ3VzM084Mlg1SjBa?=
 =?utf-8?B?L1FlVzNDQk1DWHI5LzBBQ1FkQ0JkMUlWM1pLZUFIclhQS1pxOGY1cnJtMkhF?=
 =?utf-8?B?L1NYTlQ4T0JnWGd0NUluOVJjbnZ4ZStNWk11OXAyell5OGxDMFJHV0t6eW9C?=
 =?utf-8?B?NWFicHczRmQ4Q1NhSTRBeEc5REw3M2JqVjRqZFB1OWpqNFJCc2xEa3N4WEhw?=
 =?utf-8?B?SFdJYWxzcWZScVBQVXNCREVEclFFSU5ZY1drSjRqRnFxZTliNE52SERNN25L?=
 =?utf-8?B?T1dhYWZWYnRTaHlwbnFUV3NHcHA5WkJDZkVFSXEwMzNUZUdHcjNIWkU2U3VS?=
 =?utf-8?B?RlZKR0pacit4TDJBNDltTzkzUFN2OXlFZkFZNlRPbXErMjVhLzdXMWE4bVli?=
 =?utf-8?B?VXA1UTd2Uk9NS1dxeW9TR3BIUjRKeGdHUkQ2RUhBWG55dUhYM0EzbkVyTC9K?=
 =?utf-8?Q?HERuabY0WWUG3w38FdKId1cDABdVZaT3X1keR9naxvVv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFE28502CB9B704BABF255A5A170C879@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2658ff02-b546-477e-12f0-08dc02dbea4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2023 10:51:13.1562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /nCfo33TbbGOci0doQmKpuLIYoELHwgw+n0JV69o/tE8QJTvPpQ+OAn2iO8FNanTWZDkuMtOTQM0QaSzLL5mxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8090

T24gRnJpLCAyMDIzLTEyLTIyIGF0IDAzOjI5IC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIFRodSwgRGVjIDIxLCAyMDIzIGF0IDAzOjA3OjIyUE0gKzAwMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+ID4gPiA+IEluIHRoYXQgY2FzZSB5b3UncmUgcmlnaHQsIHdlIGRv
bid0IG5lZWQgZmVhdHVyZSBmbGFncy4gQnV0IEkgdGhpbmsgaXQNCj4gPiA+ID4gPiB3b3VsZCBi
ZSBncmVhdCB0byBhbHNvIG1vdmUgdGhlIGVycm9yIHJldHVybiBpbiBjYXNlIHVzZXJzcGFjZSB0
cmllcw0KPiA+ID4gPiA+IHRvIG1vZGlmeSB2cSBwYXJhbWV0ZXJzIG91dCBvZiBzdXNwZW5kIHN0
YXRlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiBPbiB0aGUgZHJpdmVyIHNpZGUgb3Igb24gdGhlIGNv
cmUgc2lkZT8NCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IENvcmUgc2lkZS4NCj4gPiA+IA0KPiA+
IENoZWNraW5nIG15IHVuZGVyc3RhbmRpbmc6wqBpbnN0ZWFkIG9mIHRoZSBmZWF0dXJlIGZsYWdz
IHRoZXJlIHdvdWxkIGJlIGEgY2hlY2sNCj4gPiAoZm9yIC5zZXRfdnFfYWRkciBhbmQgLnNldF92
cV9zdGF0ZSkgdG8gcmV0dXJuIGFuIGVycm9yIGlmIHRoZXkgYXJlIGNhbGxlZCB1bmRlcg0KPiA+
IERSSVZFUl9PSyBhbmQgbm90IHN1c3BlbmRlZCBzdGF0ZT8NCj4gDQo+IFllYSB0aGlzIGxvb2tz
IG11Y2ggc2FuZXIsIGlmIHdlIHN0YXJ0IGFkZGluZyBmZWF0dXJlIGZsYWdzIGZvcg0KPiBlYWNo
IE9QRVJBVElPTl9YX0xFR0FMX0lOX1NUQVRFX1kgdGhlbiB3ZSB3aWxsIGVuZCB1cCB3aXRoIE5e
Mg0KPiBmZWF0dXJlIGJpdHMgd2hpY2ggaXMgbm90IHJlYXNvbmFibGUuDQo+IA0KQWNrLiBJcyB0
aGUgdjIgZW5vdWdoIG9yIHNob3VsZCBJIHJlc3BpbiBhIHY1IHdpdGggdGhlIHVwZGF0ZWQgQWNr
ZWQtYnkgdGFncz8NCg0KSSB3aWxsIHByZXBhcmUgdGhlIGNvcmUgcGFydCBhcyBhIGRpZmZlcmVu
dCBzZXJpZXMgd2l0aG91dCB0aGUgZmxhZ3MuDQoNClRoYW5rcywNCkRyYWdvcw0K

