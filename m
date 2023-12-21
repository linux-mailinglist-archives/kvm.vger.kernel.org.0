Return-Path: <kvm+bounces-5073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D6681B9AE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB0C92824B1
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 14:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA041EB46;
	Thu, 21 Dec 2023 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eYvGB64+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F5A5C;
	Thu, 21 Dec 2023 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRlBqYnD+X6vC7Mp3/HIP6M7LnlQxYZHh0DyRGHpmHPRQRbS95PXSCFwbFUnwN5Rk13QtpREgZBUCzZsxT6U/+lbw1MHosOM9oKeDkeWn8ske0fWuSFrUGtS6Uhifyctz+LlsKn2jZPcy4D8x/uX6Iy75XkWg56+tjdW9aJgz69zDWOGpdyBljEvLoFwhWZ7+KoUDtHm11ehn29sc+NmRIl0ZgSFisuiyLYyfJy5Vjczpm/pZ3VaIREpR+LHg+XmKVLM1gf7wN8mmPyoF1pQTnEm/p/5PT0cIQRddzFOQfNL1GUbKD+2+zMmVNprBfMCwm0RRkfBSfL4nqAkovpuCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRs1Ifi2FbFlgB6hCmnlBd1pZoFaJkjo276afkOolvA=;
 b=Hsu3oerHn6Qk2CJn483NSrBrVpV9CjLqkiIPA0hu24Fn8j/USZmf7tjtChRVI7HQpu2fMgfwkH5SQ/mtPRTvp0O/6FWfF+8O2Dkn7tgCJm9Z+oKLrTVIE2UW8dC0ucfNOTSI/ku7It2boLw/aWC5sun9+ccDXLCwUYoENWyYPwN5pbDlpeqaCGVgXE1DajmGBhB+WApSNxSfox3C+QICl1lFSnfmFuNb3qpcRD0yxpfSEGBScPRuWux0h9jbosV7V+GJiyjgXMgaZSVNszBEqC4l6rhseuLRiJIMnO4q28+oCtmAVzK681LcNmN43xPzpCcv13TMRLE2M+5/decKLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRs1Ifi2FbFlgB6hCmnlBd1pZoFaJkjo276afkOolvA=;
 b=eYvGB64+pTnRUJPnctudrlImvHcmeOz6aqIkn0Y9IuCzaB13hz3L3YyiHBBK5F90CUD3od3KlPv3DQkf4bvqQPNiWseVlUWV98ihJsjhcLyXz4jNMzb8UMSCRCgPgGbr4XiKVOXiqx1UmqUhMSHu0k1VRm8sxwVzktSwJIhzkqHAUgHqE4fvnzAo3U3PCbncnKrFCg29+rAZ9C9SJIUB9KSqy+3IwT7jF3len+izED+sDJPU7BwFjHl8KUSak+COwBV6PrAGlgqiCCDh0lnyK4xwYhEbruFKA51nlUbXnv6iGjRhwtiKPG7Mo9UJgT3RD8KijhBOuoI4lxvCHG9h5A==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by SN7PR12MB8028.namprd12.prod.outlook.com (2603:10b6:806:341::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Thu, 21 Dec
 2023 14:38:10 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 14:38:10 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "eperezma@redhat.com" <eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "mst@redhat.com" <mst@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Topic: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Index:
 AQHaMqaBunnLiYiUz0i03/j7bu1zQ7CxiQYAgAAFTwCAAJ4xgIAA0diAgABf+YCAAES4AIAABHKAgAAp1IA=
Date: Thu, 21 Dec 2023 14:38:09 +0000
Message-ID: <c03eb2bb3ad76e28be2bb9b9e4dee4c3bc062ea7.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231219180858.120898-3-dtatulea@nvidia.com>
	 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
	 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
	 <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com>
	 <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
	 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
	 <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
	 <CAJaqyWeUHiZXMFkNBpinCsJAXojtPkGz+SjzUNDPx5W=qqON1w@mail.gmail.com>
In-Reply-To:
 <CAJaqyWeUHiZXMFkNBpinCsJAXojtPkGz+SjzUNDPx5W=qqON1w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|SN7PR12MB8028:EE_
x-ms-office365-filtering-correlation-id: 41435000-b7cb-4ed2-e6fe-08dc0232741d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 t1nBGhn8iy4NTaGZ/hELSEHmnqS9HzUySLOK9zwh1nioXCJJo2QDzgsGVbYir5m0u+SycOPEdp1PgPwLa4U63A5IJPsEsArsd+lP6n8xnAiMFpEPG2kZK1Pd7Zt16I1Q/EHFyvSxoNIQCB+X5FREfccVdqUf5KkNXB7CJWMSNd9+tvYS/8e3iMCMA25CV+hkFWuClGVJY4RgLkwIaL3y1vavVLyPYtjZiOQSyfLnp0JmTWkVAy8ozNnouCWxTmPcn80nx0ILLOdi6BFVcu1hRP6OhVv8n5HwOugDKIdcfc0APYveg8XN6VvJDFSmXiwj0Nf0x0MajAYDgGEPxFnW8QkTkSJKkb9IT2pRjGRFoBK4LjEHFRumh1L4d5Kps75EzktYrj1aOWN7vtZx104mvoGH3KgjIyRFHn4mgCT0XFkPjLjYgNJTe9b7uYpcHslyZtxuA4oE4NLO7h8K/3I5vp6sq7xLizgcFCoyIQzRGTGlkRb7staL3Q30SJgnqvbyhoiqbD2KDrLnhPrChuYeS5H10/lAExG80+BAzbQzAZ7jLd0wxz8bwbyLZzlDdKfoAPnOLQJvihq9qgeaAEVQ38C6fhdsBf+SroEniNXJ0OiRhDwO9UyfXmndM5tC3etn
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(366004)(376002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(36756003)(122000001)(38100700002)(2906002)(5660300002)(4001150100001)(38070700009)(83380400001)(6506007)(2616005)(53546011)(6512007)(71200400001)(66946007)(66899024)(8676002)(66556008)(6486002)(478600001)(76116006)(91956017)(6916009)(54906003)(66446008)(64756008)(8936002)(4326008)(86362001)(41300700001)(316002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OXlJMXVZU0t1eHRob3R0TThscWY4UDdtVG5xSksxSnpsNUYzTkVJMW1ueVRZ?=
 =?utf-8?B?VkF2ZUhMQitYWlNOZ1lBc1FTWVQ4UkEwa0pCUGQ5U2hzSFNhdVhzRjB1WEpk?=
 =?utf-8?B?dFhmZHpNcHErcE1mM09EZkI0YjBKOENLOGdlZVZySnZBSFl0dzhUYURlY0hv?=
 =?utf-8?B?MU5ubVR1czdwTGNZaE0vNTZnWmk1L2tERGFYcGl1WGI2eWVPMmlUdlBaVERm?=
 =?utf-8?B?Y3czaDB0T3JadHJaRVZHUDhDZFZrQy96ZEpDaWQ1bkU4OEtXVzFmZ2JwUFFm?=
 =?utf-8?B?aWJBRlhQSTVXdDJOcnhaWVRLVmlRMlZqbWcxOEU1YTFFdGFvNE9yNDZIZHVZ?=
 =?utf-8?B?SUl4ZlRFTmFTbDVMZHdzM1lzRndEajBxTlRqWGU3cDA3ZG1ocnBsWmYwbWo5?=
 =?utf-8?B?VHhUbExFbmxoelhJKzR6ZUw4cXZ6WVhmZ3lKUEs2OHhxa21UTmVLYmQwd2ZV?=
 =?utf-8?B?Q2ZRTHA3ME91MU12WnBrazQvS1dWU1pWcGJTTzZQNkxlNUZvSW50RlJDWStS?=
 =?utf-8?B?QmYrcGdXZjdNemlGbEJEMFl1dUxQYWRkekMrV1RyT1FrbjFJVE8wdDRxM3Zy?=
 =?utf-8?B?NlFpWXhNcGk1UW4yS2djWlZDeDBKV0NqRXdjREtVUEFZbE9QNGtWeFk0eGNy?=
 =?utf-8?B?azRsOFg0SmFBSXIvTHFDSzBjdmN5Rk16d2lITUF2eVh6QXFmVDNsVlVGdGhE?=
 =?utf-8?B?UENZdndyZWlSd01zYzNna0pYeE5JUnN0MTlPelpqaDk4OEtVOWJSL3dKWXJS?=
 =?utf-8?B?WnBsTWlBNVl2UHN2QmFsTEw5Kzh5VldGa05ucEFBaWd4aGhveXVyTktOdVNG?=
 =?utf-8?B?RnQySjZ3dWpOcDk3dFFBRmlBYkNkdE94alNjUm1xaVplZ2xjVjYvMjFzRjYy?=
 =?utf-8?B?T2lzZkNGOTBuc0lXSFQrYkt1dnhPMEFkMzVaY29uUEUyR0JLWVVncEQzS1dw?=
 =?utf-8?B?M2lJR2dSczJEYXVUWDBwdjNrVDUybmZEZUdHSVNidUdzOWc3OGdBd2tyTllt?=
 =?utf-8?B?R05DU01SWTNwSElTRGwzTm5YZm54dzNqMUhqZit6clEyMll0VVpkSStzcnlE?=
 =?utf-8?B?bFBnSjdnQlpxMW1XV1RtUnJpNHdrbnVGczdDOERkK0t6Z2RiQmxaZEV6TUUx?=
 =?utf-8?B?TSswRVVIcGhqa2g3aUpFayt0anpuOXFxYmI4QnovOHdBQWJKOW9YdFljczly?=
 =?utf-8?B?N1dwV2YyZklsSnd1QmJwQnBjSGlWVGtRQ1RkeEplS2xwRTJGRmgxVEpiVlMr?=
 =?utf-8?B?cFdwSWxrNkhIMUhEdmUxTkZ1dFE5am9ITDZUeG9BdTJRbTNQT2VLN1ErQ1dS?=
 =?utf-8?B?aU9QenRLYk1seGo0cjVRYVQ5ZnB3cEl5SlBNQzRjVVRoNUdtSVlOSUF3OC9F?=
 =?utf-8?B?azNya20rWVhQS0NqRktzbFZoTjdEdElzbHpqYTVwaHUveGpCY3NEREtsMW1h?=
 =?utf-8?B?cW95WlZRMTI2UEZUcy9OdWZwYzM1NmIrcW8xRmN0d2JwZVpRNDFmRkk4U0FG?=
 =?utf-8?B?am9tUkJwcFpUMG9nWXB5WTFHV2RsVWFLLy92M3QvSXFRaTBKTGFObHpzNTZ4?=
 =?utf-8?B?NTUreGR3ZkJsV3dYUnZ5YTNrMzhUTWdSVC8rSkRrUGZpTEF5R2loUm9NcXBD?=
 =?utf-8?B?MURqY0N1aUhINDFhYmxhWW1ROG5oOTF6MUdxK1pwQSszcVAwdTdjOUhMa0Fv?=
 =?utf-8?B?Nmlla3BLZlZ6YjlPY0pvSTdzSkRGa1Q2NnNkMGlVeFk4RGQwZmNiUkowblMx?=
 =?utf-8?B?aVRrTU1tVDllbGRiM3UvRHR6cmNuSUM2L1A0eTM5S2dwWFVsTXl5b290bFNS?=
 =?utf-8?B?YUpKRWU2N3RXWEs5NElnUDVlWmg1ZXFoVnBJN3dwOHN4bk10OUkyN2ZmNUNS?=
 =?utf-8?B?T2hMenhsQ2pteFhhRHJNclBRbnFzS3ltQzVhT2NUMXRheHJmZUUvNWluUStu?=
 =?utf-8?B?RjZVV05BTG1FaVd6T1RxR1dIOFp3WC8wUjJYcjhidmhIWVQwSERWeDJGem1Z?=
 =?utf-8?B?bExNaEI0MTBsL0FvYTZNRmVOTTdOb0psVkl5RXZObzlHMm9wYlN6bjFNazZX?=
 =?utf-8?B?WGlaMEJuZzBqYmhWc3VvazROTmc3Z09tZXdMMnlYT0JVYnZNbkZDNlVSUkp3?=
 =?utf-8?B?K3pqbW1IRk8xSnZDRkFtcUlzcjR4bmNxS1YzOVgrd1QrNWdIakZWd0poSjRR?=
 =?utf-8?Q?BHNuT5cLSfrvPeJ3lVp7VVejHGik8QxErYUSbWxgrK/B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <887A0587E5A2C54F8E9CD33B6492074D@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 41435000-b7cb-4ed2-e6fe-08dc0232741d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 14:38:09.9184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uc7dGZTT1GSLF5fkkRrtw9u84PxMXEyIpDbqx7NjT51cUI8NXmNuEb2RgLYWjVWS64JjLivwuohWHp0wJz0fQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8028

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDEzOjA4ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gVGh1LCBEZWMgMjEsIDIwMjMgYXQgMTI6NTLigK9QTSBEcmFnb3MgVGF0dWxl
YSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gVGh1LCAyMDIzLTEy
LTIxIGF0IDA4OjQ2ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3cm90ZToNCj4gPiA+IE9u
IFRodSwgRGVjIDIxLCAyMDIzIGF0IDM6MDPigK9BTSBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRo
YXQuY29tPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IE9uIFdlZCwgRGVjIDIwLCAyMDIzIGF0
IDk6MzLigK9QTSBFdWdlbmlvIFBlcmV6IE1hcnRpbg0KPiA+ID4gPiA8ZXBlcmV6bWFAcmVkaGF0
LmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gT24gV2VkLCBEZWMgMjAsIDIwMjMg
YXQgNTowNuKAr0FNIEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPbiBXZWQsIERlYyAyMCwgMjAyMyBhdCAxMTo0NuKAr0FN
IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+ID4gT24gV2VkLCBEZWMgMjAsIDIwMjMgYXQgMjowOeKAr0FNIERyYWdvcyBU
YXR1bGVhIDxkdGF0dWxlYUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+ID4gPiBUaGUgdmlydGlvIHNwZWMgZG9lc24ndCBhbGxvdyBjaGFuZ2luZyB2aXJ0
cXVldWUgYWRkcmVzc2VzIGFmdGVyDQo+ID4gPiA+ID4gPiA+ID4gRFJJVkVSX09LLiBTb21lIGRl
dmljZXMgZG8gc3VwcG9ydCB0aGlzIG9wZXJhdGlvbiB3aGVuIHRoZSBkZXZpY2UgaXMNCj4gPiA+
ID4gPiA+ID4gPiBzdXNwZW5kZWQuIFRoZSBWSE9TVF9CQUNLRU5EX0ZfQ0hBTkdFQUJMRV9WUV9B
RERSX0lOX1NVU1BFTkQgZmxhZw0KPiA+ID4gPiA+ID4gPiA+IGFkdmVydGlzZXMgdGhpcyBzdXBw
b3J0IGFzIGEgYmFja2VuZCBmZWF0dXJlcy4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+
IFRoZXJlJ3MgYW4gb25nb2luZyBlZmZvcnQgaW4gdmlydGlvIHNwZWMgdG8gaW50cm9kdWNlIHRo
ZSBzdXNwZW5kIHN0YXRlLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gU28gSSB3b25k
ZXIgaWYgaXQncyBiZXR0ZXIgdG8ganVzdCBhbGxvdyBzdWNoIGJlaGF2aW91cj8NCj4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gQWN0dWFsbHkgSSBtZWFuLCBhbGxvdyBkcml2ZXJzIHRvIG1vZGlm
eSB0aGUgcGFyYW1ldGVycyBkdXJpbmcgc3VzcGVuZA0KPiA+ID4gPiA+ID4gd2l0aG91dCBhIG5l
dyBmZWF0dXJlLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhhdCB3b3Vs
ZCBiZSBpZGVhbCwgYnV0IGhvdyBkbyB1c2VybGFuZCBjaGVja3MgaWYgaXQgY2FuIHN1c3BlbmQg
Kw0KPiA+ID4gPiA+IGNoYW5nZSBwcm9wZXJ0aWVzICsgcmVzdW1lPw0KPiA+ID4gPiANCj4gPiA+
ID4gQXMgZGlzY3Vzc2VkLCBpdCBsb29rcyB0byBtZSB0aGUgb25seSBkZXZpY2UgdGhhdCBzdXBw
b3J0cyBzdXNwZW5kIGlzDQo+ID4gPiA+IHNpbXVsYXRvciBhbmQgaXQgc3VwcG9ydHMgY2hhbmdl
IHByb3BlcnRpZXMuDQo+ID4gPiA+IA0KPiA+ID4gPiBFLmc6DQo+ID4gPiA+IA0KPiA+ID4gPiBz
dGF0aWMgaW50IHZkcGFzaW1fc2V0X3ZxX2FkZHJlc3Moc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBh
LCB1MTYgaWR4LA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTY0
IGRlc2NfYXJlYSwgdTY0IGRyaXZlcl9hcmVhLA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdTY0IGRldmljZV9hcmVhKQ0KPiA+ID4gPiB7DQo+ID4gPiA+ICAgICAg
ICAgc3RydWN0IHZkcGFzaW0gKnZkcGFzaW0gPSB2ZHBhX3RvX3NpbSh2ZHBhKTsNCj4gPiA+ID4g
ICAgICAgICBzdHJ1Y3QgdmRwYXNpbV92aXJ0cXVldWUgKnZxID0gJnZkcGFzaW0tPnZxc1tpZHhd
Ow0KPiA+ID4gPiANCj4gPiA+ID4gICAgICAgICB2cS0+ZGVzY19hZGRyID0gZGVzY19hcmVhOw0K
PiA+ID4gPiAgICAgICAgIHZxLT5kcml2ZXJfYWRkciA9IGRyaXZlcl9hcmVhOw0KPiA+ID4gPiAg
ICAgICAgIHZxLT5kZXZpY2VfYWRkciA9IGRldmljZV9hcmVhOw0KPiA+ID4gPiANCj4gPiA+ID4g
ICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gfQ0KPiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gU28g
aW4gdGhlIGN1cnJlbnQga2VybmVsIG1hc3RlciBpdCBpcyB2YWxpZCB0byBzZXQgYSBkaWZmZXJl
bnQgdnENCj4gPiA+IGFkZHJlc3Mgd2hpbGUgdGhlIGRldmljZSBpcyBzdXNwZW5kZWQgaW4gdmRw
YV9zaW0uIEJ1dCBpdCBpcyBub3QgdmFsaWQNCj4gPiA+IGluIG1seDUsIGFzIHRoZSBGVyB3aWxs
IG5vdCBiZSB1cGRhdGVkIGluIHJlc3VtZSAoRHJhZ29zLCBwbGVhc2UNCj4gPiA+IGNvcnJlY3Qg
bWUgaWYgSSdtIHdyb25nKS4gQm90aCBvZiB0aGVtIHJldHVybiBzdWNjZXNzLg0KPiA+ID4gDQo+
ID4gSW4gdGhlIGN1cnJlbnQgc3RhdGUsIHRoZXJlIGlzIG5vIHJlc3VtZS4gSFcgVmlydHF1ZXVl
cyB3aWxsIGp1c3QgZ2V0IHJlLWNyZWF0ZWQNCj4gPiB3aXRoIHRoZSBuZXcgYWRkcmVzcy4NCj4g
PiANCj4gDQo+IE9oLCB0aGVuIGFsbCBvZiB0aGlzIGlzIGVmZmVjdGl2ZWx5IHRyYW5zcGFyZW50
IHRvIHRoZSB1c2Vyc3BhY2UNCj4gZXhjZXB0IGZvciB0aGUgdGltZSBpdCB0YWtlcz8NCj4gDQpO
b3QgcXVpdGU6IG1seDVfdmRwYV9zZXRfdnFfYWRkcmVzcyB3aWxsIHNhdmUgdGhlIHZxIGFkZHJl
c3Mgb25seSBvbiB0aGUgU1cgdnENCnJlcHJlc2VudGF0aW9uLiBPbmx5IGxhdGVyIHdpbGwgaXQg
d2lsbCBjYWxsIGludG8gdGhlIEZXIHRvIHVwZGF0ZSB0aGUgRlcuIExhdGVyDQptZWFuczoNCi0g
T24gRFJJVkVSX09LIHN0YXRlLCB3aGVuIHRoZSBWUXMgZ2V0IGNyZWF0ZWQuDQotIE9uIC5zZXRf
bWFwIHdoZW4gdGhlIFZRcyBnZXQgcmUtY3JlYXRlZCAoYmVmb3JlIHRoaXMgc2VyaWVzKSAvIHVw
ZGF0ZWQgKGFmdGVyDQp0aGlzIHNlcmllcykNCi0gT24gLnJlc3VtZSAoYWZ0ZXIgdGhpcyBzZXJp
ZXMpLg0KDQpTbyBpZiB0aGUgLnNldF92cV9hZGRyZXNzIGlzIGNhbGxlZCB3aGVuIHRoZSBWUSBp
cyBpbiBEUklWRVJfT0sgYnV0IG5vdA0Kc3VzcGVuZGVkIHRob3NlIGFkZHJlc3NlcyB3aWxsIGJl
IHNldCBsYXRlciBmb3IgbGF0ZXIuDQoNCj4gSW4gdGhhdCBjYXNlIHlvdSdyZSByaWdodCwgd2Ug
ZG9uJ3QgbmVlZCBmZWF0dXJlIGZsYWdzLiBCdXQgSSB0aGluayBpdA0KPiB3b3VsZCBiZSBncmVh
dCB0byBhbHNvIG1vdmUgdGhlIGVycm9yIHJldHVybiBpbiBjYXNlIHVzZXJzcGFjZSB0cmllcw0K
PiB0byBtb2RpZnkgdnEgcGFyYW1ldGVycyBvdXQgb2Ygc3VzcGVuZCBzdGF0ZS4NCj4gDQpPbiB0
aGUgZHJpdmVyIHNpZGUgb3Igb24gdGhlIGNvcmUgc2lkZT8NCg0KVGhhbmtzDQo+IFRoYW5rcyEN
Cj4gDQo+IA0KPiA+ID4gSG93IGNhbiB3ZSBrbm93IGluIHRoZSBkZXN0aW5hdGlvbiBRRU1VIGlm
IGl0IGlzIHZhbGlkIHRvIHN1c3BlbmQgJg0KPiA+ID4gc2V0IGFkZHJlc3M/IFNob3VsZCB3ZSBo
YW5kbGUgdGhpcyBhcyBhIGJ1Z2ZpeCBhbmQgYmFja3BvcnQgdGhlDQo+ID4gPiBjaGFuZ2U/DQo+
ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBUaGUgb25seSB3YXkgdGhhdCBjb21lcyB0byBt
eSBtaW5kIGlzIHRvIG1ha2Ugc3VyZSBhbGwgcGFyZW50cyByZXR1cm4NCj4gPiA+ID4gPiBlcnJv
ciBpZiB1c2VybGFuZCB0cmllcyB0byBkbyBpdCwgYW5kIHRoZW4gZmFsbGJhY2sgaW4gdXNlcmxh
bmQuDQo+ID4gPiA+IA0KPiA+ID4gPiBZZXMuDQo+ID4gPiA+IA0KPiA+ID4gPiA+IEknbQ0KPiA+
ID4gPiA+IG9rIHdpdGggdGhhdCwgYnV0IEknbSBub3Qgc3VyZSBpZiB0aGUgY3VycmVudCBtYXN0
ZXIgJiBwcmV2aW91cyBrZXJuZWwNCj4gPiA+ID4gPiBoYXMgYSBjb2hlcmVudCBiZWhhdmlvci4g
RG8gdGhleSByZXR1cm4gZXJyb3I/IE9yIHJldHVybiBzdWNjZXNzDQo+ID4gPiA+ID4gd2l0aG91
dCBjaGFuZ2luZyBhZGRyZXNzIC8gdnEgc3RhdGU/DQo+ID4gPiA+IA0KPiA+ID4gPiBXZSBwcm9i
YWJseSBkb24ndCBuZWVkIHRvIHdvcnJ5IHRvbyBtdWNoIGhlcmUsIGFzIGUuZyBzZXRfdnFfYWRk
cmVzcw0KPiA+ID4gPiBjb3VsZCBmYWlsIGV2ZW4gd2l0aG91dCBzdXNwZW5kIChqdXN0IGF0IHVB
UEkgbGV2ZWwpLg0KPiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gSSBkb24ndCBnZXQgdGhpcywgc29y
cnkuIEkgcmVwaHJhc2VkIG15IHBvaW50IHdpdGggYW4gZXhhbXBsZSBlYXJsaWVyDQo+ID4gPiBp
biB0aGUgbWFpbC4NCj4gPiA+IA0KPiA+IA0KPiANCg0K

