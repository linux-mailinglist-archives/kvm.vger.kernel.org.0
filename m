Return-Path: <kvm+bounces-5227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 058C081E13B
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3153F1C2109D
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6232C524D7;
	Mon, 25 Dec 2023 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KeW3d2FB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FB71DFDD;
	Mon, 25 Dec 2023 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWzzcobyGz9Hl0CJR/rKsPU/P3A6tJXjR3tPV6182Qvd30EAFIGJlTqBf0i1v9Ku4nURiLxeNKxfhj1Z/PE1GHxHy/5xf6Nr6w2W2JIzYsdUxwa9X/1EnUxmMFoU3qwEx8o8qE67LoGKU7jDt7i6v71AnWA4Fts1PUxHNDFF3+UrTDowMPTzCog53Ps7p4R+U82Dltvv2sLHZRv3ooNzylWbPiL0bicdPU6v5EvFHlzBseUC1f7x/aK3IpdwbEdyUVpZLrYxxReTxvoz5RuIqhjTpbMutdfvFPoe32/1Ier/IhillCBiRq+E+g5ugLUfNjCzXDH3ImOn1VvGEmxx/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olOTm51agiHfi5zncPsMYaEmgeiDRzkdf4dw5bGS5cU=;
 b=nwPHwsuoPhmfG90rl/53Pkf+3IXTPvCkhmqZO99BTsnUrNCZZ6Y7Gc9jdCwp6Mu+GwhJ3NVnwzlv+5ID1OwsoTiVOkeA4yLQr4rS/7n5w03S/k5NhowjPhROzf10dXnYwgyr8u8xrBe4OGQ0Xtauza+g2KiI5SLQOegNixIBysC/TUFOBs9bIg/+ubCXQPSiy7A4py+rp8pw3f51a0GXBr1jJlIspSo4GpBx1qEdFiX04+0eom97Xu+Ot+StzJWTO7h27E+/9xym9XYireslV2gh1snzUfmSiKEsFTqpECE63F4UegIMrkOr6v8keOr/39HSvPY4l+GmMEPkjCvtyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olOTm51agiHfi5zncPsMYaEmgeiDRzkdf4dw5bGS5cU=;
 b=KeW3d2FBuIQdTufkieq+uvofVHbQzXFLmQrCJCS8UybuDqmjtXItlrxdVFQJ0nk9XFsSMMQAm/zZDxc7X/kp4FJ47Gtwov9IW11iyq3riBQvRq+u9a4l9f4w9lp3Rgqep6+JDo9mMOb3/p7hOzvwwZjKNEq7u9KbUU6iCra9qOrfiB+Z5fkI8m6RoLaeJJessrkxmbyyKeiRYTVXTJDeM9+x6RmRJrmf/zROA44efVP8KnH1zMXeilkjLchNe2BvBBFbcFEwTQAfnmtAY3ka7gGwyhcuFJmjjB+PXUsk90edHalXoi+q9U3ASVlOftaEWNoubw1iTIK7yeP6GQYW1w==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DS7PR12MB5957.namprd12.prod.outlook.com (2603:10b6:8:7c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Mon, 25 Dec
 2023 15:05:29 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.026; Mon, 25 Dec 2023
 15:05:28 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v4 00/15] vdpa/mlx5: Add support for resumable vqs
Thread-Topic: [PATCH vhost v4 00/15] vdpa/mlx5: Add support for resumable vqs
Thread-Index: AQHaMqZ8XSjDBtEr/kCUoCZbH+l2p7C6G3QAgAAG1YA=
Date: Mon, 25 Dec 2023 15:05:28 +0000
Message-ID: <4abd7d516a9e82ebf41b1ea98475341844186568.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231225094040-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231225094040-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DS7PR12MB5957:EE_
x-ms-office365-filtering-correlation-id: ac1e066b-5d50-4c40-af9f-08dc055aee7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ULpeqEilNs8pEjGaGiwzGtYyBPtXebTC4yNYdMoxaTomIiF1P4/yXcMXRnYQgGkaL4dqwYDY9+YVRdoYZmgGYxB8danWalD4z8Rdlh+z+qVFiOWgnTdFbD2lS+NmB6vZOdAwvlKA1UljwU4SxjTK4flUaoaIH9Rdz4Qryom28xPGV+JfHfuR0hJ54idUqiO5idso3UfHDR50XSrYS05+DQAUM1cXIY5/Hjqbd7U3nVbinlOlAJfkd3k8Kmy1VscxN6B9gseYwGqTqLMUA9Urajc0NtkcU/00pUkRSZAP7XJYjDR3jGJqhVgPmoOy+syPRv3Cch3RH2rEcRWave/fzvpCZQ/3EEcDowXl9pQKQnG96ctSXcYbPG5quWy8Dq4Z4i88LDwq1pI2xMpQDDaA0k3dldGR3Y3E38ZP+159Sk0U0uflS6ltMTweVlQGetULzqoJhmhv0KlXRrhVPv7+NJk0W2lhVkXhexWoWGqBNdjl5Uha48MhmN7u1txIj1K0EecaL35VLu9MvP1J09oEN2gU+ycmtSwG/JVitxfIYPmIQNdhYv25uBXLYcmIHNw3Qmr3B0fCsCUGv1wvRutdJS1al/CgQwvVpduapnONbWQiWc/OGfRMvxurpWs73gjb
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(71200400001)(6506007)(6512007)(478600001)(6486002)(38100700002)(2616005)(122000001)(83380400001)(41300700001)(4326008)(5660300002)(316002)(54906003)(6916009)(91956017)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006)(8676002)(8936002)(2906002)(4001150100001)(38070700009)(36756003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzlxbDlqYUk4VkxrR0tiUVVxQXpqcG9YdHczZmZwOTNQZ1RFdVIvamIvWjRS?=
 =?utf-8?B?Y2xVVE4rYmNkV1k1Uk1lNUkyaHpFbzNrQVdQbkh5eG5MdHlsQ0FUWXRGTUlI?=
 =?utf-8?B?U3ZtQzRWNUVUbUxrMno4VmFZTlpjYXgvZ09DMUZkY01TNTM3eEd6NHBRei81?=
 =?utf-8?B?Rnd6aGp0czZvTmdrR0pTa2lSOUhTY29uckU4OUd1bnpBM1piVlU5U3ZWVDRx?=
 =?utf-8?B?Y3NVNG9lUHg4U2xxYnV5RkErd0Z4S1kweTlOcjB4WDYxdENOVDltR2hqSlRv?=
 =?utf-8?B?cXozc25oM3RSOWhpQVFzbUZ5cUJWaWsva09kQmxLRi90WTgrbythQWlVdTc3?=
 =?utf-8?B?aHIyRG9ML1BWRXpTVFBRL0pqL2pNenk1WDFjVkFGQXdBZ1JLUENHUVgvNXZp?=
 =?utf-8?B?S3F2NUIvRGVJV0pGdDdxd3Y4a2ZPSTdJUHJpbU1pc29RcFF1ZDRwdE5TdTh2?=
 =?utf-8?B?c0hia2xicHVoemd3YUlIa29WVDJpUk9KYUZ3cUl5R0N1bE1xdjQvditzMWZ5?=
 =?utf-8?B?ZWZMUUdpNjJRektwMCtLSTduSURMRHhSTUVzRE5QeGFvRUgrbUw1S283ckZs?=
 =?utf-8?B?R1Z3a1lMRGRBMUgxUkVMQndiYXdDS0lheUpZcXdxV25CbDBVY254TGpKUk1q?=
 =?utf-8?B?VDRUbUhPK1FoMm5yK3JETUQzVW9KNFZtOHhGMStTbDlZTnlrVytkNGtta2s5?=
 =?utf-8?B?aXBmNDlvQk1nWmp0S1hxejV4MW84a2JJamFmL2NBbWovR1BQTHFObmVONVV1?=
 =?utf-8?B?aTRRcnNhM2lEeWpSVlM4cHVyb3k3THBnYXJIbUt2Q3NPbUI0N3ZRREZVSFI2?=
 =?utf-8?B?NlM0Rmp1U05DZEFQQmJ4dDR6UEx6ZzI1MEVYVWZoUkVMMDAvM2VpYlFsSlZl?=
 =?utf-8?B?ZE0vMU5MS3pjd1NPS2FEeEcrMVlkNktzNmdXWkhtS2syOHE0cThEeURYTlRZ?=
 =?utf-8?B?NDAydEt1L3RGU1dkYkRjVWZkWWdSTVptQVdYbWtFbHpKWlB6TjFqdWYrcW81?=
 =?utf-8?B?di9SbUQ2WEpaOGd4dFN6YUxzbkQ3S2hXWkRsK1NLK042MEJpL2NqUWpoWlA3?=
 =?utf-8?B?amtzbTRwSWE3SWRLeU5OalNic2N4Q2FWR3JnSjZnNFFQN0hHcE9jQ3VtcFNW?=
 =?utf-8?B?UU14dVpSVmsrQk5XWUpNZFNlNTVLZGZncldWV2thY1VibjlsWFFYSDMrRHR2?=
 =?utf-8?B?dlVObDJyMTV0aXpkNG02bDRDVitmRVRSbHpMSitvaXFCZEJCeUVDeG5RTno0?=
 =?utf-8?B?OHNXV2pSaXl1NTN0RVBaRXQ5aDRHei84TG1IRE84ZWpRTXFLVFM2REVxVkky?=
 =?utf-8?B?cktYaVhyWkViWUptcG1MTjZneXRRcTR0MmVnQXFrNkQ2MDRQcDZ1ZnpFVG0y?=
 =?utf-8?B?L1B0a2JtblArNEtEbVo4ejNjb2NHaHFXanMyNEdiMjMyc0FNSjJmd0NMMXNx?=
 =?utf-8?B?ZkVzZE45bkhJdWFxODNHeVR1RTN5emNIUER1TzJKYTVCdWRieUpxUldPTU9C?=
 =?utf-8?B?K3dqbWFtKzRDd2xZN0tkTk5YV0hValpDSlVQakVkTHRubGN6YWpFWHU1MGtr?=
 =?utf-8?B?bDlMcVZIdStBbzFUd3lsSGs0a2Y3YmJEd0xTSWg5ZW9sOTU3ZWM2UkpkQzdX?=
 =?utf-8?B?ZlNNcTBSempseTZuanJZeHBDY0xlU0xDRndmbnVGR21aVm1uVy9yRzc5WlJJ?=
 =?utf-8?B?MGZBbWFQVFJIQnFpUklOeDVkeGJZMTQwVGJiWnJlNThjMW5aN3dJU1ZFUysy?=
 =?utf-8?B?K2cyR0xuNkdpRGplSnpGOU1FMXA4djdGR25oOFJtdWEyUkVtdXdCOXFIV3JX?=
 =?utf-8?B?K1pZbTMxd203cUtFd2lhNWdNNTB5dFdKYUJKNG5pZUtTNk1NVVVjNGswQnFD?=
 =?utf-8?B?a0psaWkwMjBwWkxKOHlZRmlBdFBGditOTjUyTEtNZm9LbjNRMmEzNENKS1FI?=
 =?utf-8?B?SE9qUFE0YS9mZlRxMS83TGw4OVhycXBXemtmYmliRnJHdDZPem5tZmZ3R3lT?=
 =?utf-8?B?eDN2ZnpLQzRxS1NuWmIxeHFxR0h6WWlXektaMm5rTnc2VitDR3hDbmRtRENP?=
 =?utf-8?B?Zk1SMFlBdVlod1NkbXZJaHN6M0lML0xIamZHNVBBcWx4NnNjS3lUOVd4d0p3?=
 =?utf-8?B?ZnZXYUlneE04Y09rZ2ExQXN1Zkk3NFhPeHFuVTlPZ29IUzBDa2ZSQVJ3Y25h?=
 =?utf-8?Q?0aglFbA1jdEPKv1gjFysA8ifCieFGMKFpmSIj4NW98uk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B4F0A985AD53E44AA4913E7D9CE49B9@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1e066b-5d50-4c40-af9f-08dc055aee7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2023 15:05:28.6056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyTPMonG5eMRzqVocMzbfGtnA86VOKpGiTD7YVzvoCCZFV6dUzWVY0jW6Wid6AxL1xJxmbNNfKqwc99PQf5mpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5957

T24gTW9uLCAyMDIzLTEyLTI1IGF0IDA5OjQxIC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIFR1ZSwgRGVjIDE5LCAyMDIzIGF0IDA4OjA4OjQzUE0gKzAyMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IEFkZCBzdXBwb3J0IGZvciByZXN1bWFibGUgdnFzIGluIHRoZSBt
bHg1X3ZkcGEgZHJpdmVyLiBUaGlzIGlzIGENCj4gPiBmaXJtd2FyZSBmZWF0dXJlIHRoYXQgY2Fu
IGJlIHVzZWQgZm9yIHRoZSBmb2xsb3dpbmcgYmVuZWZpdHM6DQo+ID4gLSBGdWxsIGRldmljZSAu
c3VzcGVuZC8ucmVzdW1lLg0KPiA+IC0gLnNldF9tYXAgZG9lc24ndCBuZWVkIHRvIGRlc3Ryb3kg
YW5kIGNyZWF0ZSBuZXcgdnFzIGFueW1vcmUganVzdCB0bw0KPiA+ICAgdXBkYXRlIHRoZSBtYXAu
IFdoZW4gcmVzdW1hYmxlIHZxcyBhcmUgc3VwcG9ydGVkIGl0IGlzIGVub3VnaCB0bw0KPiA+ICAg
c3VzcGVuZCB0aGUgdnFzLCBzZXQgdGhlIG5ldyBtYXBzLCBhbmQgdGhlbiByZXN1bWUgdGhlIHZx
cy4NCj4gPiANCj4gPiBUaGUgZmlyc3QgcGF0Y2ggZXhwb3NlcyByZWxldmFudCBiaXRzIGZvciB0
aGUgZmVhdHVyZSBpbiBtbHg1X2lmYy5oLg0KPiA+IFRoYXQgbWVhbnMgaXQgbmVlZHMgdG8gYmUg
YXBwbGllZCB0byB0aGUgbWx4NS12aG9zdCB0cmVlIFswXSBmaXJzdC4gT25jZQ0KPiA+IGFwcGxp
ZWQgdGhlcmUsIHRoZSBjaGFuZ2UgaGFzIHRvIGJlIHB1bGxlZCBmcm9tIG1seDUtdmhvc3QgaW50
byB0aGUNCj4gPiB2aG9zdCB0cmVlIGFuZCBvbmx5IHRoZW4gdGhlIHJlbWFpbmluZyBwYXRjaGVz
IGNhbiBiZSBhcHBsaWVkLiBTYW1lIGZsb3cNCj4gPiBhcyB0aGUgdnEgZGVzY3JpcHRvciBtYXBw
aW5ncyBwYXRjaHNldCBbMV0uDQo+ID4gDQo+ID4gVGhlIHNlY29uZCBwYXJ0IGltcGxlbWVudHMg
dGhlIHZkcGEgYmFja2VuZCBmZWF0dXJlIHN1cHBvcnQgdG8gYWxsb3cNCj4gPiB2cSBzdGF0ZSBh
bmQgYWRkcmVzcyBjaGFuZ2VzIHdoZW4gdGhlIGRldmljZSBpcyBpbiBEUklWRVJfT0sgc3RhdGUg
YW5kDQo+ID4gc3VzcGVuZGVkLg0KPiA+IA0KPiA+IFRoZSB0aGlyZCBwYXJ0IGFkZHMgc3VwcG9y
dCBmb3Igc2VsZXRpdmVseSBtb2RpZnlpbmcgdnEgcGFyYW1ldGVycy4gVGhpcw0KPiA+IGlzIG5l
ZWRlZCB0byBiZSBhYmxlIHRvIHVzZSByZXN1bWFibGUgdnFzLg0KPiA+IA0KPiA+IFRoZW4gdGhl
IGFjdHVhbCBzdXBwb3J0IGZvciByZXN1bWFibGUgdnFzIGlzIGFkZGVkLg0KPiA+IA0KPiA+IFRo
ZSBsYXN0IHBhcnQgb2YgdGhlIHNlcmllcyBpbnRyb2R1Y2VzIHJlZmVyZW5jZSBjb3VudGluZyBm
b3IgbXJzIHdoaWNoDQo+ID4gaXMgbmVjZXNzYXJ5IHRvIGF2b2lkIGZyZWVpbmcgbWtleXMgdG9v
IGVhcmx5IG9yIGxlYWtpbmcgdGhlbS4NCj4gDQo+IA0KPiBJIGxvc3QgdHJhY2suIEFyZSB5b3Ug
Z29pbmcgdG8gc2VuZCB2NSBvciBub3Q/DQo+IA0KSSB3YXMgd2FpdGluZyBmb3IgeW91ciBhbnN3
ZXIgaWYgSSBzaG91bGQgc2VuZCBpdCBvciBub3QuIEkgc3VwcG9zZSB0aGlzIG1lYW5zDQp5ZXMu
IEkgd2lsbCBzZW5kIGl0IGluIGEgZmV3IG1pbnV0ZXMuDQoNCj4gPiAqIENoYW5nZXMgaW4gdjQ6
DQo+ID4gLSBBZGRlZCB2ZHBhIGJhY2tlbmQgZmVhdHVyZSBzdXBwb3J0IGZvciBjaGFuZ2luZyB2
cSBwcm9wZXJ0aWVzIGluDQo+ID4gICBEUklWRVJfT0sgd2hlbiBkZXZpY2UgaXMgc3VzcGVuZGVk
LiBBZGRlZCBzdXBwb3J0IGluIHRoZSBkcml2ZXIgYXMNCj4gPiAgIHdlbGwuDQo+ID4gLSBEcm9w
cGVkIEFja2VkLWJ5IGZvciB0aGUgcGF0Y2hlcyB0aGF0IGhhZCB0aGUgdGFnIG1pc3Rha2VubHkN
Cj4gPiAgIGFkZGVkLg0KPiA+IA0KPiA+ICogQ2hhbmdlcyBpbiB2MzoNCj4gPiAtIEZhdWx0eSB2
ZXJzaW9uLiBQbGVhc2UgaWdub3JlLg0KPiA+IA0KPiA+ICogQ2hhbmdlcyBpbiB2MjoNCj4gPiAt
IEFkZGVkIG1yIHJlZmNvdW50aW5nIHBhdGNoZXMuDQo+ID4gLSBEZWxldGVkIHVubmVjZXNzYXJ5
IHBhdGNoOiAidmRwYS9tbHg1OiBTcGxpdCBmdW5jdGlvbiBpbnRvIGxvY2tlZCBhbmQNCj4gPiAg
IHVubG9ja2VkIHZhcmlhbnRzIg0KPiA+IC0gU21hbGwgcHJpbnQgaW1wcm92ZW1lbnQgaW4gIklu
dHJvZHVjZSBwZXIgdnEgYW5kIGRldmljZSByZXN1bWUiDQo+ID4gICBwYXRjaC4NCj4gPiAtIFBh
dGNoIDEvNyBoYXMgYmVlbiBhcHBsaWVkIHRvIG1seDUtdmhvc3QgYnJhbmNoLg0KPiA+IA0KPiA+
IA0KPiA+IERyYWdvcyBUYXR1bGVhICgxNSk6DQo+ID4gICB2ZHBhOiBBZGQgVkhPU1RfQkFDS0VO
RF9GX0NIQU5HRUFCTEVfVlFfQUREUl9JTl9TVVNQRU5EIGZsYWcNCj4gPiAgIHZkcGE6IEFkZCBW
SE9TVF9CQUNLRU5EX0ZfQ0hBTkdFQUJMRV9WUV9TVEFURV9JTl9TVVNQRU5EIGZsYWcNCj4gPiAg
IHZkcGE6IEFjY2VwdCBWSE9TVF9CQUNLRU5EX0ZfQ0hBTkdFQUJMRV9WUV9BRERSX0lOX1NVU1BF
TkQgYmFja2VuZA0KPiA+ICAgICBmZWF0dXJlDQo+ID4gICB2ZHBhOiBBY2NlcHQgVkhPU1RfQkFD
S0VORF9GX0NIQU5HRUFCTEVfVlFfU1RBVEVfSU5fU1VTUEVORCBiYWNrZW5kDQo+ID4gICAgIGZl
YXR1cmUNCj4gPiAgIHZkcGE6IFRyYWNrIGRldmljZSBzdXNwZW5kZWQgc3RhdGUNCj4gPiAgIHZk
cGE6IEJsb2NrIHZxIGFkZHJlc3MgY2hhbmdlIGluIERSSVZFUl9PSyB1bmxlc3MgZGV2aWNlIHN1
cHBvcnRzIGl0DQo+ID4gICB2ZHBhOiBCbG9jayB2cSBzdGF0ZSBjaGFuZ2UgaW4gRFJJVkVSX09L
IHVubGVzcyBkZXZpY2Ugc3VwcG9ydHMgaXQNCj4gPiAgIHZkcGEvbWx4NTogRXhwb3NlIHJlc3Vt
YWJsZSB2cSBjYXBhYmlsaXR5DQo+ID4gICB2ZHBhL21seDU6IEFsbG93IG1vZGlmeWluZyBtdWx0
aXBsZSB2cSBmaWVsZHMgaW4gb25lIG1vZGlmeSBjb21tYW5kDQo+ID4gICB2ZHBhL21seDU6IElu
dHJvZHVjZSBwZXIgdnEgYW5kIGRldmljZSByZXN1bWUNCj4gPiAgIHZkcGEvbWx4NTogTWFyayB2
cSBhZGRycyBmb3IgbW9kaWZpY2F0aW9uIGluIGh3IHZxDQo+ID4gICB2ZHBhL21seDU6IE1hcmsg
dnEgc3RhdGUgZm9yIG1vZGlmaWNhdGlvbiBpbiBodyB2cQ0KPiA+ICAgdmRwYS9tbHg1OiBVc2Ug
dnEgc3VzcGVuZC9yZXN1bWUgZHVyaW5nIC5zZXRfbWFwDQo+ID4gICB2ZHBhL21seDU6IEludHJv
ZHVjZSByZWZlcmVuY2UgY291bnRpbmcgdG8gbXJzDQo+ID4gICB2ZHBhL21seDU6IEFkZCBta2V5
IGxlYWsgZGV0ZWN0aW9uDQo+ID4gDQo+ID4gIGRyaXZlcnMvdmRwYS9tbHg1L2NvcmUvbWx4NV92
ZHBhLmggfCAgMTAgKy0NCj4gPiAgZHJpdmVycy92ZHBhL21seDUvY29yZS9tci5jICAgICAgICB8
ICA2OSArKysrKysrLS0NCj4gPiAgZHJpdmVycy92ZHBhL21seDUvbmV0L21seDVfdm5ldC5jICB8
IDIxOCArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQ0KPiA+ICBkcml2ZXJzL3Zob3N0L3Zk
cGEuYyAgICAgICAgICAgICAgIHwgIDUxICsrKysrKy0NCj4gPiAgaW5jbHVkZS9saW51eC9tbHg1
L21seDVfaWZjLmggICAgICB8ICAgMyArLQ0KPiA+ICBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9p
ZmNfdmRwYS5oIHwgICA0ICsNCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L3Zob3N0X3R5cGVzLmgg
ICB8ICAgOCArKw0KPiA+ICA3IGZpbGVzIGNoYW5nZWQsIDMyMiBpbnNlcnRpb25zKCspLCA0MSBk
ZWxldGlvbnMoLSkNCj4gPiANCj4gPiAtLSANCj4gPiAyLjQzLjANCj4gDQoNCg==

