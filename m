Return-Path: <kvm+bounces-4922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF597819F61
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75090282CC3
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 12:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127162D63E;
	Wed, 20 Dec 2023 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MlWZwVoi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E62D2D612;
	Wed, 20 Dec 2023 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R18BsxSb5vOBjeEcYGHoFtNZksqnm1+vFnUOyYvaUyVxFjHryLY/bJoImgkhF5/98jHLrGOG9tFtceZTdc8KWqb7SJ85zNlUT70KwcDjWhQgf7kOI9FfT/+7nYqkpSLOVL4gCeVGS2THNaCAszLlpC87pVQPaiFLoHbkTfp1FL/f3LWsFFEwmGcjdXI3p7NVa5hxUMfl44syYONOb/uOlSpetsrLiq2KUvO6FHrkD4tBZinerxN8Gy4rkl5DnqWoVB7Nqb/cZspzk+UntUzQW0McMhKCBIU37OEN+KuEx2+QH2ufc69e3+NesXd0W1FyGc+Do3HGnPugFmpqkX7nYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3vmONUSiLeP+Joy41Yq1ryzqssBlgjdNl9FfS3nU6I=;
 b=FD2h34oiPp3M/qcBiC7TwVCwV3OS2INLlEhO35MbYWs1ThH/ttOi3TxZc0SXh1APkw6AauQLBt1NmHlMD5xpw4En8DIF3CMoK0DkTLOrxNpWvhKwhXMJMrAIfJnj4V4vMtfzV/GwLI70joBQDn1uJiij6vzUUtBbYJwCZH4rV8ByMB5mlE6l1hL0+6p6BBQL1Tb73MJq6Lg1SukEtiihWv+Kl+n7Ne+rB3Xla1gPqn4DhPiErgvW1FKasBJ3uzdtJu+PGEtPzb948Wmla3YkCM0wa5FSibN9lHtWLQSb1WZFUvk1pOunqGRNkrT7oKqQvMauQeCVbBXbk4//rXydJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3vmONUSiLeP+Joy41Yq1ryzqssBlgjdNl9FfS3nU6I=;
 b=MlWZwVoifp+18It35E7e2pvuQjb5y47ktBYTXFRucsoF8JE/EEI9T7lR9h0/g0GRLB/J16TZyCY4XZH5zzWLaSA0/wHaWXPt87XwN0QgFuM2nVagwJm2MHugOxbdTnijZcXb8WFq10yWSAlBuWzOZI3Dq19m4CBbyD/V1u5cdeN4qd2sR/fO0StN+C4uY6Bggv4wz2eeZz6NokK2SKfJbS/aF2M90jNd1TJrRyjOMVu9jQ0Fdf3DBbuKb32T+q4m+RbB7OXbgwW13oRR6RhoQVk6Mv5YNPn5wMADMg1kMW4ECEQgqN6K9tXDYQLoAQO/529OCThk88zTzVvsYiIOSQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH7PR12MB7233.namprd12.prod.outlook.com (2603:10b6:510:204::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 12:55:38 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.016; Wed, 20 Dec 2023
 12:55:38 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "jasowang@redhat.com" <jasowang@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v4 06/15] vdpa: Track device suspended state
Thread-Topic: [PATCH vhost v4 06/15] vdpa: Track device suspended state
Thread-Index: AQHaMqaJZWbyVmSIr0+0TyiJd4XKALCxiQqAgACZTwA=
Date: Wed, 20 Dec 2023 12:55:37 +0000
Message-ID: <65064744954829b844d8a7b23bb09792cb6c2760.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231219180858.120898-7-dtatulea@nvidia.com>
	 <CACGkMEs_kf2y9Khr==zY3RRHffaPRwS51XK33Lgv1eeanQdRpg@mail.gmail.com>
In-Reply-To:
 <CACGkMEs_kf2y9Khr==zY3RRHffaPRwS51XK33Lgv1eeanQdRpg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH7PR12MB7233:EE_
x-ms-office365-filtering-correlation-id: 05515673-e20d-49c6-f8bf-08dc015af6e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Y/i7/yQsVU7Yf/VUUuGAownJzZHKB8JB1KGzQr9ZRXZ+iVmjFsk/9Y0+vCSOc8G3z/Kace3tAyDsZBbSUjNAoH4GtAnF6X2e4jAMHFCR48jRwHcCksa1FKwVnI6E7YRbJ+RJ6oqWhgH4wuqn7UWLC3/tcF4+bX2vxLDoy8lLXW0BZJa0NEbiAWN11XtmzJP5ypBQO2MQAnui3VXHQT8xMd8sVeEReAvXmKHsIiAZs2EjH8Qh3fSSNxfhHaVfuZzlPFfRNk47vVOjzfj4umC1PEPQf0JwGxXwJiAxQHGy0aobXWlpk/VRW5s4HyUPSq1nVUgp1O5Jm+3Zi4TfXMiwe3q3xB3Gfxo5uuFmnlFAAX7kxwya/6uI5X2MUuCJ8yI8o4HiU5njD64J3m/27texInpZX5x7xhtlkUJp7JsBMG3Ss9Qm/hjyjmIDQhVB1GZJXqNV9UvE7h1uPotrbOE+70MrhXjtyvjqK9Q7GFDmhJck8Ui/tbwAS0b4QwaW513wQbOnjK2KYZ2qi01GTMwfkDgEHhEEei1r1oTXWH6urz5ZBEbD8LKTJ7uuYKZFsal8tRD75pRu3L6k7yk3RYdmonSJwk4uN3HtLX/Q0WGxRuonFBQQg1e3bWg8MjP1nyxh
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(366004)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(4326008)(8936002)(8676002)(5660300002)(15650500001)(2906002)(4001150100001)(91956017)(316002)(6506007)(6512007)(478600001)(66446008)(66476007)(6916009)(64756008)(54906003)(76116006)(66556008)(66946007)(6486002)(41300700001)(38100700002)(53546011)(122000001)(86362001)(36756003)(38070700009)(71200400001)(66574015)(83380400001)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VFZJR1VGMlFSUzRkVDBTSTVUMFprWldGNlZiMm9RUU5ocEF2bFZscVg4OUhP?=
 =?utf-8?B?Z1grc25lZ2h4dTJpNFB3SGlId0duTU5xZjArMEdTVGZDSGk0NFJsaWZycmp1?=
 =?utf-8?B?RkNWTFRXcXdGV3BwdkQxS1hMWUp0SXk4MW50VVBjVmtjeDVka212WWw3bHJN?=
 =?utf-8?B?N3dlYW1qdmVmdG5qdWhsTG9iZEtmdjRNdzd6eTY1L1NEMTI2V1BrSld4Q2dh?=
 =?utf-8?B?R2orZldhVVJsVzNVWmd4RWNSaG5veStzOHhmNHZTaFZqSjFDQUVkSk85SkQv?=
 =?utf-8?B?dDVEblk1RWxPTDR0Wm9wbVoyemlMY2JBS05OZ2xrZ0ZvQXFYbVpMR21qSWxQ?=
 =?utf-8?B?VFptTmVPUnZOR0FFZzdtK1RUbGEvajl6dDdQaEdGbmFTOStFdnBKOFdDdDdt?=
 =?utf-8?B?NUVGUStCRVZoQW5DaXNoRnVyMEJWaTVDNzkzR0F6RW9NSlA5VHNybzVmNHdC?=
 =?utf-8?B?SXVYZ2NGTklSWXBmcUdNSVQ1YW5qSXFyUVBraGdPb2NTaGF6alZ0ZXZEdENu?=
 =?utf-8?B?aTEyMVNzcFp2YW0rOFJpVEV0bTgyZEpDMHhzczZlTmxELzAxdENKOU1kSXhT?=
 =?utf-8?B?cWE2VEowWXpia2JLUjcrMXRlTUh3K1BEdTA0UDRjM25jYVNtcUdhZ2c4QzVX?=
 =?utf-8?B?cHRMYTVUWjRKemNqU04vK29sVjdYQWZWWkRQeHBseTd5MmtPWFRZNk1rL29t?=
 =?utf-8?B?OFZRSVFuYU94UDkrV21GamdHRmRYUU41NGlJcjlLRkhDdTJaUlgzaFAyQ2RM?=
 =?utf-8?B?VVp5SDJ6ejgvUzhkUGZQdEF5Zlp6SnE4ZDQyYkdTbWVlZStQMUNGNng2cXd3?=
 =?utf-8?B?NVJIbTZGSlcvSG1nRGNPQU9tUTBCOFkvaTF2TGdqQnN0b2UxQVh6bFdIOTFp?=
 =?utf-8?B?RDBSQW44QUF1VFQ4NDBUcU8xckdldDlEWHljcVlZUHpMSUJ4cUxsc0RTcnlx?=
 =?utf-8?B?RjdyMUV0aXh4YjhYUDA5UGNnS1NuZmFIRG5tM3A3bHJ1Vk15SXZkSDlkb1pm?=
 =?utf-8?B?bUFIVnM1M2RRc2pBOU9JZm9PNFVWZWpiOVJxQUVaQ0FWbVVmWFhrNnNPTWYw?=
 =?utf-8?B?NFNDSVA5TDhWZWhWWlIzQnp4dGJZeUZndWJ1MEp3MnFkeGZlNXZ4akpwQ0pZ?=
 =?utf-8?B?YzJNLzhlM25HQWdhMjBUdEdMbHpSNGNBRCtZK2o0ODkzbWd6UktYYmxDQTNN?=
 =?utf-8?B?SVNyWTVKNmkybWs3OWxmamdaYkw1RDJHQm1qbkRQMjV6V0QvMjV5R0psUFJH?=
 =?utf-8?B?RU12bjFOb0tvbUdwOVA3RjFPWmZUMUdna2RhN3gxMCtWY3loc3NlVWdENEM2?=
 =?utf-8?B?cVVTK2Y3VjJGTm1SS3c3RkxwSm5Tc1kzSUtoVzFnYkJLYVp4NVZzNDNUZllD?=
 =?utf-8?B?bTQycWxsazhvZ2pnd0E3UmlBUWtlZlorSVJoalNrWGVlVDhXaUNlUXdPdHdL?=
 =?utf-8?B?TUh5eStQMGVqUnE3OCsyWE5wSFVVZDlxcjIzajVEL0hVcUFON3ZTbG0zYnEw?=
 =?utf-8?B?WStZZXRBT29IaE9zeTd5ZE5vR0JaQkJkVDlXYnExVkNFL2NwdXVTWW1sYnF5?=
 =?utf-8?B?M0xrdlhKMmErTE1welE3YS9vcWJYUHFDTHdHRGtmOVhDaUxoamR2RlhOME1q?=
 =?utf-8?B?U2pTMUZrSzFIakVQZmdzYUx4UUQrWFVDUG1JWGI3a2VUamdlTkFvWVZWYVdU?=
 =?utf-8?B?dGFQWkFZOHdKNjNwajJEalk1TTIvc3pqMTRyVmZJcnhobWQ2TFZJcy9lU3JO?=
 =?utf-8?B?NXNCK3JOSW42UFM4NG1MeFM1VTJpQ2xaT2RSaXNNY21qMkRMd2kxbkR3bHhI?=
 =?utf-8?B?azV0aGRUZUkwZUcxWFMram9mUjY4SXY5R2lvZjZJUS9JS2JlcE1meVVvaVdn?=
 =?utf-8?B?dmlDRnJEU2lBZk1MS1oyejBkVE1jQTRNUVZuMHB6UjhSSSs3bHlSV0NVTzFu?=
 =?utf-8?B?SFhzTktld2JuWURWNnJuS1BFV0ZyQWoxY013ZktwRXFXTUM1M0owSTIwUGkr?=
 =?utf-8?B?Z3hYaXZTY05QYkh4eFpDRG1WNGR4SzZLTzJnRTIrTk55R0FzTExJeUt3Qk1S?=
 =?utf-8?B?L2tqSllZdXduaFFlY21ZYUxYMzQrcDVteisvZ3hsVTUwemZ5RjFUbmdoSlJq?=
 =?utf-8?B?ZmphNDA0VWt0Q0J6Nktac2duNUxhRDJlWngzbkRGNmJYVnlMeVV6dGFjUXVE?=
 =?utf-8?Q?DGJWCX4ZC0VpBtRVLfE3UdB4uh83H81/tKFMqPXO14ka?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAEE631A122C1E4D969C8370B25D00BD@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 05515673-e20d-49c6-f8bf-08dc015af6e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2023 12:55:38.0216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o26ZENfo79F0CQWwVi4ljw/ux04RJdDjeVk65/MiGSUtPVvZ8h575aY3ap1Dz3qIM2lhDtLc0huLMjnq8L/1ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7233

T24gV2VkLCAyMDIzLTEyLTIwIGF0IDExOjQ2ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPiBP
biBXZWQsIERlYyAyMCwgMjAyMyBhdCAyOjA54oCvQU0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFNldCB2ZHBhIGRldmljZSBzdXNwZW5kZWQg
c3RhdGUgb24gc3VjY2Vzc2Z1bCBzdXNwZW5kLiBDbGVhciBpdCBvbg0KPiA+IHN1Y2Nlc3NmdWwg
cmVzdW1lIGFuZCByZXNldC4NCj4gPiANCj4gPiBUaGUgc3RhdGUgd2lsbCBiZSBsb2NrZWQgYnkg
dGhlIHZob3N0X3ZkcGEgbXV0ZXguIFRoZSBtdXRleCBpcyB0YWtlbg0KPiA+IGR1cmluZyBzdXNw
ZW5kLCByZXN1bWUgYW5kIHJlc2V0IGluIHZob3N0X3ZkcGFfdW5sb2NrZWRfaW9jdGwuIFRoZQ0K
PiA+IGV4Y2VwdGlvbiBpcyB2aG9zdF92ZHBhX29wZW4gd2hpY2ggZG9lcyBhIGRldmljZSByZXNl
dCBidXQgdGhhdCBzaG91bGQNCj4gPiBiZSBzYWZlIGJlY2F1c2UgaXQgY2FuIG9ubHkgaGFwcGVu
IGJlZm9yZSB0aGUgb3RoZXIgb3BzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IERyYWdvcyBU
YXR1bGVhIDxkdGF0dWxlYUBudmlkaWEuY29tPg0KPiA+IFN1Z2dlc3RlZC1ieTogRXVnZW5pbyBQ
w6lyZXogPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmhvc3Qv
dmRwYS5jIHwgMTcgKysrKysrKysrKysrKysrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDE1IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVycy92aG9zdC92ZHBhLmMNCj4gPiBpbmRleCBiNGU4ZGRm
ODY0ODUuLjAwYjRmYThlODlmMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Zob3N0L3ZkcGEu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4gQEAgLTU5LDYgKzU5LDcgQEAg
c3RydWN0IHZob3N0X3ZkcGEgew0KPiA+ICAgICAgICAgaW50IGluX2JhdGNoOw0KPiA+ICAgICAg
ICAgc3RydWN0IHZkcGFfaW92YV9yYW5nZSByYW5nZTsNCj4gPiAgICAgICAgIHUzMiBiYXRjaF9h
c2lkOw0KPiA+ICsgICAgICAgYm9vbCBzdXNwZW5kZWQ7DQo+IA0KPiBBbnkgcmVhc29uIHdoeSB3
ZSBkb24ndCBkbyBpdCBpbiB0aGUgY29yZSB2RFBBIGRldmljZSBidXQgaGVyZT8NCj4gDQpOb3Qg
cmVhbGx5LiBJIHdhbnRlZCB0byBiZSBzYWZlIGFuZCBub3QgZXhwb3NlIGl0IGluIGEgaGVhZGVy
IGR1ZSB0byBsb2NraW5nLg0KDQpUaGFua3MsDQpEcmFnb3MNCg==

