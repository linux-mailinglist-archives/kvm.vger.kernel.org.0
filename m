Return-Path: <kvm+bounces-4573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE45814A2F
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D32C61C24361
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF5130677;
	Fri, 15 Dec 2023 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ff4FoHiP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091803035A;
	Fri, 15 Dec 2023 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/XEIjFPzeW0Kp6ua+IpAQi5M3Oeqh6MhSJpN/DaBX+W/yDvX69JjUi43GeprmuStCdWcmzOfhsj8tbLT13omNynTaCoKU5iQ8+PYkh/cz+0bwEW31u9O1N5fNMD5/iPEICSKieujQjNx9iWHsn9tCqsTL1AJhAi7+mYtU4nOqkUXFkwfFVDh+Cln6A9hLaKUDnp2IDEhm4LKrLL7GC0gHMpxgsC70xypBRn1OZxLxzSaPUtkvUpXmOIduM4lAUAyRdgEo+LI0z+IsQ3qBd4HV6rsnN2LTo6j/F1EqA9wpU9lZ89QLVM/cHZgCZFYgf3SR8WKyYC5oPkrifHQGqIwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRwJySOZkKsyzc9Nc8jJKeQ8sBt8fUQZJ2L0eOn4Q+E=;
 b=ePvuGSKPOUGZV4Io2iHwYvi1GvkRyCYL8iV4qcTBzmOWysy+ATR77zZ3Hbu0LukY45KEXraCaoLYV/vn+vDGKh8FrT6zJokg38+8xKF9M0i2QUrfUzQbAlv3s1pjqSqGliBdVErLr9vYNFco4sCLHT1ihLhEuEzjDY3JDOnIhIUsoLudyn29lgZq+KkoNdtzAT6OHdr0y0chuUqP6+dsUZiKQoOqqE7mfgSlGDXXt8BgBQO75MWsRNeayzVx6Y/KSv0TmBKq4d+1fSgjyswV0LBwDyJzAczrp7NdEEOWIJZYNT/chbPBMdRt09HJQGmd25lhrxeJ/rpZDiy3fh8PtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRwJySOZkKsyzc9Nc8jJKeQ8sBt8fUQZJ2L0eOn4Q+E=;
 b=Ff4FoHiPw63JxrUfZomlIDfZPCp6W7CFuH2khHb45Fq5n61cFaNltvM+HOdB3u4FGto8aO8OvHK/MSpKxPDTliHunDOtyfvb0sSKCsrOwx6BL8F/ItyQXSmGNepRWM/7+gLtdImQgHygXJ4QUdfUPVt0sVXPWbA/c7nomW2771BpDdYKGP9wt6uq0//wT5qtwiyfGqgIaSiKzPiBxVYzKQ514J/eB4F905PsDt8pu2rQZcRfNeUMk3UIVvKOgY9FH7PswDwei4CMdsw1Cr57ylqTjGUHRwKlfick6jtha5bU0sswMts2566JJE1nKnsUHE1SZR+D+ONaBPp9cWEl6Q==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.32; Fri, 15 Dec
 2023 14:13:07 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 14:13:07 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "eperezma@redhat.com" <eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "mst@redhat.com" <mst@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Thread-Topic: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification
 in hw vq
Thread-Index:
 AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgABJawCAAnvhAIAAAZuAgAAjJQCAACyCAIABLv6AgAAbWwA=
Date: Fri, 15 Dec 2023 14:13:07 +0000
Message-ID: <0bfb42ee1248b82eaedd88bdc9e97e83919f2405.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
	 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
	 <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
	 <20231214084526-mutt-send-email-mst@kernel.org>
	 <9a6465a3d6c8fde63643fbbdde60d5dd84b921d4.camel@nvidia.com>
	 <CAJaqyWfF9eVehQ+wutMDdwYToMq=G1+War_7wANmnyuONj=18g@mail.gmail.com>
	 <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com>
In-Reply-To: <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|MN2PR12MB4270:EE_
x-ms-office365-filtering-correlation-id: ed6b282d-0392-487e-3d8a-08dbfd77f640
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 oV/xUcLUTtgU3lsQxQTEYcVjpKcQ5pVRKwSPJ4OQsUX2r7GFQyuvpNys0x4In79UpXOYcrirczGwPcNoECDCzNBgwjwzJUEn3t8lLTLF3oPY5gDsb9xTEXk3Ah8Yfyd1jDWnPFUDC2UbEq1MEAXuaXsrhADv7keLZ1spVCCgBkEuVUUauXA7395VpWQ29bvvTThK46Z2SIBiVkHHxUwhEx1wD/L3x7IkAB9YxfOAKzoAqFjFkLnv63nXwQKhx8kXQ91yNwLNsX0LciaT1tRYvnCif6+wmEeEBJ6s8sLeKk65PD5ya6+NlgafTgNQUw7yiStusOfTIngxC7wfYJ0pkQAdDYA2Crnl41rLoBr1P9YX6asUBb0sf/EI14xVCkSXemW2Sf6WTibmGZ3l6vvyz+1ihkov9pjgxyZtsfPF9FKBAQelBvzfxVlEWKAipXi6oAKVRYn88vDek6U/xkdTkhMPHbeE2ud+CbkWzzgw8aYc1GBIBvhLP9/vhN8zFaP5JIxWR5C2xm/eL3KKI6Gk3cRrtBkjSOJG2XN7XDOb2L6n4/Idr0C9VxXP5HYvzZszA/HZXpSSvWPNuljHCx4OjQFzIbdhNjAtsf6Wl4T2d3NU/FrKVrh3IbFaqVV4rFzljE3lhbc16DsEgPcsZ4CBALc3WpzetFZhtuasJvfg/cM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(122000001)(38100700002)(2616005)(83380400001)(71200400001)(66574015)(36756003)(86362001)(38070700009)(53546011)(6506007)(6512007)(478600001)(6916009)(316002)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(91956017)(76116006)(4001150100001)(2906002)(8936002)(4326008)(8676002)(5660300002)(41300700001)(966005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bTVGemdsd2NhUFdRb01aTi91M3J2WFFCZnB5djFQMExEcEFVYWJvaTZLc21l?=
 =?utf-8?B?THNCY0NtV1BIbjh5akdSeW1ZY0cxMGx1Um15bkhBTy9GNjFHaWxDUFlCUDQ5?=
 =?utf-8?B?Wnh1NjJQUFFjVUxSLzlNTkk1WDhrYlg2WjUvdUFSYWdpSWJwRGNEZzJRU21p?=
 =?utf-8?B?RU9lcTBSZERVRVhNRHVhMzNlQVV0TXZsQjBzOXpSQXdMZ1JPbkVOSlRNUGZn?=
 =?utf-8?B?aHUwVDBrblQ3Mjd1djlFOEJ0RnpGMHR4MHVtbGQxdjhucjFSM0FYOGZXb0xr?=
 =?utf-8?B?SWpaNE04TnNTUUlYQ1BuMVdjQWFCRVR4OU5IdXpXL29zcEhNTFBkUWFQdklI?=
 =?utf-8?B?Tk9zcjE5MVI4S0xhRnk1bTU3S0FYMmQ2VUlaN2F4RDNPbXRycGtlUmtZZmgr?=
 =?utf-8?B?cERtK0JwK0t0cWZBcGpvbEhmMVltQmdJdC9pTlhmYTB0ZDlBeDF2bS9kWjdB?=
 =?utf-8?B?MCtyQTVnYzZYMDZPT2FEN0RCZnNJNzM0bEQyU21pOUZHeGx5cjNJdzlzUlgz?=
 =?utf-8?B?UDA2b01WUHk3ckVxZFp0NXZrRnVJMHFDend6MmNjUWUwMy9aMnJDQi92bEho?=
 =?utf-8?B?NDdUcGptMDBDSWVEYVJPRkk0NTNuWnVzZllFSWd3aUNUNkhlaktTSHY5WldI?=
 =?utf-8?B?THNCMGR4bGJiUXk4SVhNSlJNTUJMWktYQTNJSEFmNURBdU8rTFpvNE1Sd25W?=
 =?utf-8?B?RGRWMFNDajNLa25WRndFUXdJUEdBZGpoRERDMTZlekZPNVhoc001SnF1Nkpx?=
 =?utf-8?B?NVZTR1JzWklYb01mWVZTYTRvR0pQR1VpQ1J6ZnVrSHJ5d2JLMGNLN3ZJeTN2?=
 =?utf-8?B?SDlpdWhrVG9QUG9MMVAzTDBqZ3cxcnlBQ0h2Ync0THhMVlZpS1IzSzQwcWdt?=
 =?utf-8?B?TDl0UzVSMmFscGIxRE9qeFlPYm9ULzRMOHkvZzlma3pDWkJZbUFlSTBxaGN3?=
 =?utf-8?B?N2lteDdzMkNwK3JYS0c0KzcxTU8zTjdCbm1vcWFLOFZhTVNDeTgwUmFPVWhS?=
 =?utf-8?B?bjYzMXc0YWczV1pvMlo2ZldVdlFDd3Q2OFFkY1R1ZENyaFBINDQ5OFhkcjEx?=
 =?utf-8?B?NWFza096ekZ1SEZJNW4rNTdOeGxVR0tvOTc5SG4xM3UwT1RBM0wrQ0tRN2ty?=
 =?utf-8?B?Y0pxZm4wL1cyN29CZC9tUjRRU3NuVkY5azNYd0Z3TTNYK04yT1VqRkdxeGtU?=
 =?utf-8?B?U0QzN21uQXN5RjU2Zk9kaVQzWEZHTnYrMlA1T3hwUVZBQnN5V2lSaEJDL1px?=
 =?utf-8?B?SWRjVlJ0Ry9UcFhPdFF3VGtST2gvckZWUVU1QS9MN0FHbTQ0T3NRcXdxUjcw?=
 =?utf-8?B?NXVUTGZOQ3owdzd0WXNYb2VDUUpEOGFoVWZDVmpUdUNlVHlLNE41R0pSc25k?=
 =?utf-8?B?TTZmaEJkSzhDZzgrc1RGYk1jWlhqZ1pTMDlma2lJK0lGM2w5eWhNQm5lM3ZG?=
 =?utf-8?B?dllLK1NhdXpPaGtoTEpKbG9Md09qQ1YyZUpMclpEMTI4Q1Z6M1N3akVFbFBx?=
 =?utf-8?B?ZkRFUnZNUWlBUlpDbGt5cnlNVHFQRzA3WWVJTUMreUo5TE8rVzM4L05rV0w0?=
 =?utf-8?B?UTBDUC9HNEhLcmdTdTFkUGprK1BZSld0SXI2anh5QjFKSVhReDlYVUhqREIx?=
 =?utf-8?B?RVp4NEdyWit1Z0l1aDlObnZJSmRQdldhV3BTWVpaZjJ3UGgxZWQ0Y000QkFq?=
 =?utf-8?B?TnF6TENxQyt2dXFQM3dZS01jSTMyODZucVhzVXZJbVRnUWpOeDB5N3lwYWIx?=
 =?utf-8?B?OGMyVEZrRFY3d1I3V2l2dUdiYUFrWk1pdXZEbGM2ejk2S2FpbUVzZHBuYm1s?=
 =?utf-8?B?bGFKVVpTZWVBa05zeEFEaUlwaTVTcUNvUEZRRkhubTlUMDBHM2ZsQWwwTmhZ?=
 =?utf-8?B?QmpSQmx6WWdvc1Q0dWJBclZTYk9FUkVRN1FIdXd5eFM2V1Z6OFBVdFptRElW?=
 =?utf-8?B?ZXZrZS9JdXhDNGdWNno2YThCcHFPaDRpdCtKNkJrcG02UG5xRWI0UlBoVGVM?=
 =?utf-8?B?UXZJTllPNWN6V1hWOHBZRDhkTi9JS000dTJtZDEvaFQvaEd3U1UvNFdiUDh1?=
 =?utf-8?B?YW9rbDRkeEJIOXJTZXpsL3hCWjlaOUkvMTZ6dEpCNkM0U29pQTYzOXdyazYx?=
 =?utf-8?B?RHZwMnBrNnVwa20xWUNiaTRVcS94dGV6am9NTjdQUGJ3R3FGRmxjM2RSQXhj?=
 =?utf-8?Q?HuY2MoNjRG1hlMfda++iHg5SefYqylENXwyv2t9dIkYv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75AB818A4B969E4190B21A072363C924@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6b282d-0392-487e-3d8a-08dbfd77f640
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 14:13:07.7018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AXpI4qLovmtotdCZJyubuqJrcLmSuC88XOmD5tDeRePsR+4tRroiZuefkPubC3JpTl23yEZcbJoZjXG2LGwOkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270

T24gRnJpLCAyMDIzLTEyLTE1IGF0IDEyOjM1ICswMDAwLCBEcmFnb3MgVGF0dWxlYSB3cm90ZToN
Cj4gT24gVGh1LCAyMDIzLTEyLTE0IGF0IDE5OjMwICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRp
biB3cm90ZToNCj4gPiBPbiBUaHUsIERlYyAxNCwgMjAyMyBhdCA0OjUx4oCvUE0gRHJhZ29zIFRh
dHVsZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiBUaHUs
IDIwMjMtMTItMTQgYXQgMDg6NDUgLTA1MDAsIE1pY2hhZWwgUy4gVHNpcmtpbiB3cm90ZToNCj4g
PiA+ID4gT24gVGh1LCBEZWMgMTQsIDIwMjMgYXQgMDE6Mzk6NTVQTSArMDAwMCwgRHJhZ29zIFRh
dHVsZWEgd3JvdGU6DQo+ID4gPiA+ID4gT24gVHVlLCAyMDIzLTEyLTEyIGF0IDE1OjQ0IC0wODAw
LCBTaS1XZWkgTGl1IHdyb3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPbiAxMi8xMi8y
MDIzIDExOjIxIEFNLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3cm90ZToNCj4gPiA+ID4gPiA+ID4g
T24gVHVlLCBEZWMgNSwgMjAyMyBhdCAxMTo0NuKAr0FNIERyYWdvcyBUYXR1bGVhIDxkdGF0dWxl
YUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiBBZGRyZXNzZXMgZ2V0IHNldCBi
eSAuc2V0X3ZxX2FkZHJlc3MuIGh3IHZxIGFkZHJlc3NlcyB3aWxsIGJlIHVwZGF0ZWQgb24NCj4g
PiA+ID4gPiA+ID4gPiBuZXh0IG1vZGlmeV92aXJ0cXVldWUuDQo+ID4gPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52
aWRpYS5jb20+DQo+ID4gPiA+ID4gPiA+ID4gUmV2aWV3ZWQtYnk6IEdhbCBQcmVzc21hbiA8Z2Fs
QG52aWRpYS5jb20+DQo+ID4gPiA+ID4gPiA+ID4gQWNrZWQtYnk6IEV1Z2VuaW8gUMOpcmV6IDxl
cGVyZXptYUByZWRoYXQuY29tPg0KPiA+ID4gPiA+ID4gPiBJJ20ga2luZCBvZiBvayB3aXRoIHRo
aXMgcGF0Y2ggYW5kIHRoZSBuZXh0IG9uZSBhYm91dCBzdGF0ZSwgYnV0IEkNCj4gPiA+ID4gPiA+
ID4gZGlkbid0IGFjayB0aGVtIGluIHRoZSBwcmV2aW91cyBzZXJpZXMuDQo+ID4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gPiBNeSBtYWluIGNvbmNlcm4gaXMgdGhhdCBpdCBpcyBub3QgdmFsaWQg
dG8gY2hhbmdlIHRoZSB2cSBhZGRyZXNzIGFmdGVyDQo+ID4gPiA+ID4gPiA+IERSSVZFUl9PSyBp
biBWaXJ0SU8sIHdoaWNoIHZEUEEgZm9sbG93cy4gT25seSBtZW1vcnkgbWFwcyBhcmUgb2sgdG8N
Cj4gPiA+ID4gPiA+ID4gY2hhbmdlIGF0IHRoaXMgbW9tZW50LiBJJ20gbm90IHN1cmUgYWJvdXQg
dnEgc3RhdGUgaW4gdkRQQSwgYnV0IHZob3N0DQo+ID4gPiA+ID4gPiA+IGZvcmJpZHMgY2hhbmdp
bmcgaXQgd2l0aCBhbiBhY3RpdmUgYmFja2VuZC4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiA+IFN1c3BlbmQgaXMgbm90IGRlZmluZWQgaW4gVmlydElPIGF0IHRoaXMgbW9tZW50IHRob3Vn
aCwgc28gbWF5YmUgaXQgaXMNCj4gPiA+ID4gPiA+ID4gb2sgdG8gZGVjaWRlIHRoYXQgYWxsIG9m
IHRoZXNlIHBhcmFtZXRlcnMgbWF5IGNoYW5nZSBkdXJpbmcgc3VzcGVuZC4NCj4gPiA+ID4gPiA+
ID4gTWF5YmUgdGhlIGJlc3QgdGhpbmcgaXMgdG8gcHJvdGVjdCB0aGlzIHdpdGggYSB2RFBBIGZl
YXR1cmUgZmxhZy4NCj4gPiA+ID4gPiA+IEkgdGhpbmsgcHJvdGVjdCB3aXRoIHZEUEEgZmVhdHVy
ZSBmbGFnIGNvdWxkIHdvcmssIHdoaWxlIG9uIHRoZSBvdGhlcg0KPiA+ID4gPiA+ID4gaGFuZCB2
RFBBIG1lYW5zIHZlbmRvciBzcGVjaWZpYyBvcHRpbWl6YXRpb24gaXMgcG9zc2libGUgYXJvdW5k
IHN1c3BlbmQNCj4gPiA+ID4gPiA+IGFuZCByZXN1bWUgKGluIGNhc2UgaXQgaGVscHMgcGVyZm9y
bWFuY2UpLCB3aGljaCBkb2Vzbid0IGhhdmUgdG8gYmUNCj4gPiA+ID4gPiA+IGJhY2tlZCBieSB2
aXJ0aW8gc3BlYy4gU2FtZSBhcHBsaWVzIHRvIHZob3N0IHVzZXIgYmFja2VuZCBmZWF0dXJlcywN
Cj4gPiA+ID4gPiA+IHZhcmlhdGlvbnMgdGhlcmUgd2VyZSBub3QgYmFja2VkIGJ5IHNwZWMgZWl0
aGVyLiBPZiBjb3Vyc2UsIHdlIHNob3VsZA0KPiA+ID4gPiA+ID4gdHJ5IGJlc3QgdG8gbWFrZSB0
aGUgZGVmYXVsdCBiZWhhdmlvciBiYWNrd2FyZCBjb21wYXRpYmxlIHdpdGgNCj4gPiA+ID4gPiA+
IHZpcnRpby1iYXNlZCBiYWNrZW5kLCBidXQgdGhhdCBjaXJjbGVzIGJhY2sgdG8gbm8gc3VzcGVu
ZCBkZWZpbml0aW9uIGluDQo+ID4gPiA+ID4gPiB0aGUgY3VycmVudCB2aXJ0aW8gc3BlYywgZm9y
IHdoaWNoIEkgaG9wZSB3ZSBkb24ndCBjZWFzZSBkZXZlbG9wbWVudCBvbg0KPiA+ID4gPiA+ID4g
dkRQQSBpbmRlZmluaXRlbHkuIEFmdGVyIGFsbCwgdGhlIHZpcnRpbyBiYXNlZCB2ZGFwIGJhY2tl
bmQgY2FuIHdlbGwNCj4gPiA+ID4gPiA+IGRlZmluZSBpdHMgb3duIGZlYXR1cmUgZmxhZyB0byBk
ZXNjcmliZSAobWlub3IgZGlmZmVyZW5jZSBpbikgdGhlDQo+ID4gPiA+ID4gPiBzdXNwZW5kIGJl
aGF2aW9yIGJhc2VkIG9uIHRoZSBsYXRlciBzcGVjIG9uY2UgaXQgaXMgZm9ybWVkIGluIGZ1dHVy
ZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNvIHdoYXQgaXMgdGhlIHdheSBmb3J3YXJkIGhl
cmU/IEZyb20gd2hhdCBJIHVuZGVyc3RhbmQgdGhlIG9wdGlvbnMgYXJlOg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IDEpIEFkZCBhIHZkcGEgZmVhdHVyZSBmbGFnIGZvciBjaGFuZ2luZyBkZXZpY2Ug
cHJvcGVydGllcyB3aGlsZSBzdXNwZW5kZWQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gMikgRHJv
cCB0aGVzZSAyIHBhdGNoZXMgZnJvbSB0aGUgc2VyaWVzIGZvciBub3cuIE5vdCBzdXJlIGlmIHRo
aXMgbWFrZXMgc2Vuc2UgYXMNCj4gPiA+ID4gPiB0aGlzLiBCdXQgdGhlbiBTaS1XZWkncyBxZW11
IGRldmljZSBzdXNwZW5kL3Jlc3VtZSBwb2MgWzBdIHRoYXQgZXhlcmNpc2VzIHRoaXMNCj4gPiA+
ID4gPiBjb2RlIHdvbid0IHdvcmsgYW55bW9yZS4gVGhpcyBtZWFucyB0aGUgc2VyaWVzIHdvdWxk
IGJlIGxlc3Mgd2VsbCB0ZXN0ZWQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQXJlIHRoZXJlIG90
aGVyIHBvc3NpYmxlIG9wdGlvbnM/IFdoYXQgZG8geW91IHRoaW5rPw0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IFswXSBodHRwczovL2dpdGh1Yi5jb20vc2l3bGl1LWtlcm5lbC9xZW11L3RyZWUvc3Zx
LXJlc3VtZS13aXANCj4gPiA+ID4gDQo+ID4gPiA+IEkgYW0gZmluZSB3aXRoIGVpdGhlciBvZiB0
aGVzZS4NCj4gPiA+ID4gDQo+ID4gPiBIb3cgYWJvdXQgYWxsb3dpbmcgdGhlIGNoYW5nZSBvbmx5
IHVuZGVyIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoNCj4gPiA+ICAgdmhvc3RfdmRwYV9jYW5f
c3VzcGVuZCAmJiB2aG9zdF92ZHBhX2Nhbl9yZXN1bWUgJiYNCj4gPiA+IFZIT1NUX0JBQ0tFTkRf
Rl9FTkFCTEVfQUZURVJfRFJJVkVSX09LIGlzIHNldA0KPiA+ID4gDQo+ID4gPiA/DQo+ID4gDQo+
ID4gSSB0aGluayB0aGUgYmVzdCBvcHRpb24gYnkgZmFyIGlzIDEsIGFzIHRoZXJlIGlzIG5vIGhp
bnQgaW4gdGhlDQo+ID4gY29tYmluYXRpb24gb2YgdGhlc2UgMyBpbmRpY2F0aW5nIHRoYXQgeW91
IGNhbiBjaGFuZ2UgZGV2aWNlDQo+ID4gcHJvcGVydGllcyBpbiB0aGUgc3VzcGVuZGVkIHN0YXRl
Lg0KPiA+IA0KPiBTdXJlLiBXaWxsIHJlc3BpbiBhIHYzIHdpdGhvdXQgdGhlc2UgdHdvIHBhdGNo
ZXMuDQo+IA0KPiBBbm90aGVyIHNlcmllcyBjYW4gaW1wbGVtZW50IG9wdGlvbiAyIGFuZCBhZGQg
dGhlc2UgMiBwYXRjaGVzIG9uIHRvcC4NCkhtbS4uLkkgbWlzdW5kZXJzdG9vZCB5b3VyIHN0YXRl
bWVudCBhbmQgc2VudCBhIGVycm9uZXVzIHYzLiBZb3Ugc2FpZCB0aGF0DQpoYXZpbmcgYSBmZWF0
dXJlIGZsYWcgaXMgdGhlIGJlc3Qgb3B0aW9uLg0KDQpXaWxsIGFkZCBhIGZlYXR1cmUgZmxhZyBp
biB2NDogaXMgdGhpcyBzaW1pbGFyIHRvIHRoZQ0KVkhPU1RfQkFDS0VORF9GX0VOQUJMRV9BRlRF
Ul9EUklWRVJfT0sgZmxhZz8NCg0KVGhhbmtzLA0KRHJhZ29zIA0KDQo+ID4gPiBUaGFua3MsDQo+
ID4gPiBEcmFnb3MNCj4gPiA+IA0KPiA+ID4gPiA+IFRoYW5rcywNCj4gPiA+ID4gPiBEcmFnb3MN
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFJlZ2FyZHMsDQo+ID4gPiA+ID4gPiAtU2l3ZWkNCj4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+IEphc29uLCB3aGF0IGRvIHlvdSB0aGluaz8NCj4gPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+IFRoYW5rcyENCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gLS0t
DQo+ID4gPiA+ID4gPiA+ID4gICBkcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMgIHwg
OSArKysrKysrKysNCj4gPiA+ID4gPiA+ID4gPiAgIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lm
Y192ZHBhLmggfCAxICsNCj4gPiA+ID4gPiA+ID4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5z
ZXJ0aW9ucygrKQ0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMgYi9kcml2ZXJzL3ZkcGEvbWx4NS9u
ZXQvbWx4NV92bmV0LmMNCj4gPiA+ID4gPiA+ID4gPiBpbmRleCBmOGYwODhjY2VkNTAuLjgwZTA2
NmRlMDg2NiAxMDA2NDQNCj4gPiA+ID4gPiA+ID4gPiAtLS0gYS9kcml2ZXJzL3ZkcGEvbWx4NS9u
ZXQvbWx4NV92bmV0LmMNCj4gPiA+ID4gPiA+ID4gPiArKysgYi9kcml2ZXJzL3ZkcGEvbWx4NS9u
ZXQvbWx4NV92bmV0LmMNCj4gPiA+ID4gPiA+ID4gPiBAQCAtMTIwOSw2ICsxMjA5LDcgQEAgc3Rh
dGljIGludCBtb2RpZnlfdmlydHF1ZXVlKHN0cnVjdCBtbHg1X3ZkcGFfbmV0ICpuZGV2LA0KPiA+
ID4gPiA+ID4gPiA+ICAgICAgICAgIGJvb2wgc3RhdGVfY2hhbmdlID0gZmFsc2U7DQo+ID4gPiA+
ID4gPiA+ID4gICAgICAgICAgdm9pZCAqb2JqX2NvbnRleHQ7DQo+ID4gPiA+ID4gPiA+ID4gICAg
ICAgICAgdm9pZCAqY21kX2hkcjsNCj4gPiA+ID4gPiA+ID4gPiArICAgICAgIHZvaWQgKnZxX2N0
eDsNCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICB2b2lkICppbjsNCj4gPiA+ID4gPiA+ID4gPiAg
ICAgICAgICBpbnQgZXJyOw0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IEBAIC0x
MjMwLDYgKzEyMzEsNyBAQCBzdGF0aWMgaW50IG1vZGlmeV92aXJ0cXVldWUoc3RydWN0IG1seDVf
dmRwYV9uZXQgKm5kZXYsDQo+ID4gPiA+ID4gPiA+ID4gICAgICAgICAgTUxYNV9TRVQoZ2VuZXJh
bF9vYmpfaW5fY21kX2hkciwgY21kX2hkciwgdWlkLCBuZGV2LT5tdmRldi5yZXMudWlkKTsNCj4g
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICBvYmpfY29udGV4dCA9IE1M
WDVfQUREUl9PRihtb2RpZnlfdmlydGlvX25ldF9xX2luLCBpbiwgb2JqX2NvbnRleHQpOw0KPiA+
ID4gPiA+ID4gPiA+ICsgICAgICAgdnFfY3R4ID0gTUxYNV9BRERSX09GKHZpcnRpb19uZXRfcV9v
YmplY3QsIG9ial9jb250ZXh0LCB2aXJ0aW9fcV9jb250ZXh0KTsNCj4gPiA+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICBpZiAobXZxLT5tb2RpZmllZF9maWVsZHMgJiBNTFg1
X1ZJUlRRX01PRElGWV9NQVNLX1NUQVRFKSB7DQo+ID4gPiA+ID4gPiA+ID4gICAgICAgICAgICAg
ICAgICBpZiAoIWlzX3ZhbGlkX3N0YXRlX2NoYW5nZShtdnEtPmZ3X3N0YXRlLCBzdGF0ZSwgaXNf
cmVzdW1hYmxlKG5kZXYpKSkgew0KPiA+ID4gPiA+ID4gPiA+IEBAIC0xMjQxLDYgKzEyNDMsMTIg
QEAgc3RhdGljIGludCBtb2RpZnlfdmlydHF1ZXVlKHN0cnVjdCBtbHg1X3ZkcGFfbmV0ICpuZGV2
LA0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgc3RhdGVfY2hhbmdlID0gdHJ1ZTsN
Cj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICB9DQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiA+ID4gKyAgICAgICBpZiAobXZxLT5tb2RpZmllZF9maWVsZHMgJiBNTFg1X1ZJUlRRX01PRElG
WV9NQVNLX1ZJUlRJT19RX0FERFJTKSB7DQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAg
IE1MWDVfU0VUNjQodmlydGlvX3EsIHZxX2N0eCwgZGVzY19hZGRyLCBtdnEtPmRlc2NfYWRkcik7
DQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIE1MWDVfU0VUNjQodmlydGlvX3EsIHZx
X2N0eCwgdXNlZF9hZGRyLCBtdnEtPmRldmljZV9hZGRyKTsNCj4gPiA+ID4gPiA+ID4gPiArICAg
ICAgICAgICAgICAgTUxYNV9TRVQ2NCh2aXJ0aW9fcSwgdnFfY3R4LCBhdmFpbGFibGVfYWRkciwg
bXZxLT5kcml2ZXJfYWRkcik7DQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICB9DQo+ID4gPiA+ID4g
PiA+ID4gKw0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgIE1MWDVfU0VUNjQodmlydGlvX25ldF9x
X29iamVjdCwgb2JqX2NvbnRleHQsIG1vZGlmeV9maWVsZF9zZWxlY3QsIG12cS0+bW9kaWZpZWRf
ZmllbGRzKTsNCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICBlcnIgPSBtbHg1X2NtZF9leGVjKG5k
ZXYtPm12ZGV2Lm1kZXYsIGluLCBpbmxlbiwgb3V0LCBzaXplb2Yob3V0KSk7DQo+ID4gPiA+ID4g
PiA+ID4gICAgICAgICAgaWYgKGVycikNCj4gPiA+ID4gPiA+ID4gPiBAQCAtMjIwMiw2ICsyMjEw
LDcgQEAgc3RhdGljIGludCBtbHg1X3ZkcGFfc2V0X3ZxX2FkZHJlc3Moc3RydWN0IHZkcGFfZGV2
aWNlICp2ZGV2LCB1MTYgaWR4LCB1NjQgZGVzY18NCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICBt
dnEtPmRlc2NfYWRkciA9IGRlc2NfYXJlYTsNCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICBtdnEt
PmRldmljZV9hZGRyID0gZGV2aWNlX2FyZWE7DQo+ID4gPiA+ID4gPiA+ID4gICAgICAgICAgbXZx
LT5kcml2ZXJfYWRkciA9IGRyaXZlcl9hcmVhOw0KPiA+ID4gPiA+ID4gPiA+ICsgICAgICAgbXZx
LT5tb2RpZmllZF9maWVsZHMgfD0gTUxYNV9WSVJUUV9NT0RJRllfTUFTS19WSVJUSU9fUV9BRERS
UzsNCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gPiA+ID4gPiAg
IH0NCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lm
Y192ZHBhLmgNCj4gPiA+ID4gPiA+ID4gPiBpbmRleCBiODZkNTFhODU1ZjYuLjk1OTRhYzQwNTc0
MCAxMDA2NDQNCj4gPiA+ID4gPiA+ID4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9p
ZmNfdmRwYS5oDQo+ID4gPiA+ID4gPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVf
aWZjX3ZkcGEuaA0KPiA+ID4gPiA+ID4gPiA+IEBAIC0xNDUsNiArMTQ1LDcgQEAgZW51bSB7DQo+
ID4gPiA+ID4gPiA+ID4gICAgICAgICAgTUxYNV9WSVJUUV9NT0RJRllfTUFTS19TVEFURSAgICAg
ICAgICAgICAgICAgICAgPSAodTY0KTEgPDwgMCwNCj4gPiA+ID4gPiA+ID4gPiAgICAgICAgICBN
TFg1X1ZJUlRRX01PRElGWV9NQVNLX0RJUlRZX0JJVE1BUF9QQVJBTVMgICAgICA9ICh1NjQpMSA8
PCAzLA0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfRElS
VFlfQklUTUFQX0RVTVBfRU5BQkxFID0gKHU2NCkxIDw8IDQsDQo+ID4gPiA+ID4gPiA+ID4gKyAg
ICAgICBNTFg1X1ZJUlRRX01PRElGWV9NQVNLX1ZJUlRJT19RX0FERFJTICAgICAgICAgICA9ICh1
NjQpMSA8PCA2LA0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01B
U0tfREVTQ19HUk9VUF9NS0VZICAgICAgICAgID0gKHU2NCkxIDw8IDE0LA0KPiA+ID4gPiA+ID4g
PiA+ICAgfTsNCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiAtLQ0KPiA+ID4gPiA+
ID4gPiA+IDIuNDIuMA0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
DQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gDQo+IA0KDQo=

