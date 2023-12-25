Return-Path: <kvm+bounces-5224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 435C681E0FE
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDE3728243C
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E05524BD;
	Mon, 25 Dec 2023 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C+QbeBWu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E74F51C5A;
	Mon, 25 Dec 2023 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofnrYMjhkvt4wcil63k0FKypXM6ShipCpGfcNSNZTGsOrdwxyi+4v0nbWlHzABos6AoY+LeOJ+qpGadlxOviWISWWL1O46rnNPOKuZiMzPIq8z+g9DyD4dA++9my/ySNMYyr5h77q0cmL2dnhlwfZru93cdwAA9KM2hO+mcQEmwsXWotBh0FyCZWiSPNmm01l5eNbczhKvY1ET/KfBXedkCovYJiAlz3GAZdwTB9ZioisgJu6s0zuqDhwLkOiX5yl6QPgLFkiUWRi48vmdji2TKj4PSuHWkBxgCkkFtWOhFifgVg6Pn9OefsHKzDnq4zjcOHNad3qau9Tnd+SIGCXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8//BsU8IR3/RnjMZY427Q2bSKIoLZ5DwooBqWrIwQCM=;
 b=TUE9M34gA19g/Wk6i8TcKFhg0edmVWdgakio2gvj+qCX3cMiQFB3rzhrUfHnThed6jQCFmjNRO90KLKxN5hAa9mhRl8ETu4gr9wiRD7OtjTd9TTojFVbdAgDGXZcjUdEp5RbjhqkopvqeIJjuSG/x5r2PsUZ3+uz1EMZI/HlfX6WDDJzooQjwBYK634RaZtR+sZMYVzwQ1d0BOuZ/IppDLBKvUsZ3tcCVr0BhmPEhuMbauMS7bOsY3cZht+94SIga5fhxZp7S6HMnvh0wx6lZtv2hqywh3/ILfpKV/7N2MmlUqfD5Fowro9z3t4miKWsF9e1X69p/kvHQVCo0S9eYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8//BsU8IR3/RnjMZY427Q2bSKIoLZ5DwooBqWrIwQCM=;
 b=C+QbeBWuq1ssbbrL7lxLZzqr1Ux6P9AbzpT9nseg8P3m7+6wZuMmCErJcEI/9Dfcnqa0FZhqe923NKMEScK4Vy2P+t1Eb7Z29OlmRwOh257ZgXl1MtSMmQ+VNT5cJXmewl7drwPanGrpv+Zhd/B9LzJ4ve96pq7FpSn0nFSdjK3VOH1J5eJ6R/PvxklteSMb8y/GDcl/1AIhPqg6oRHS2gfwg1X452ZNloioSM/3wwIJpr6x3XuUv5YPQC79Lj8ZJajDdVewN3OxQd4tr2JVmlfDxPFnesEpYXS8yPVSlxHrhgx9Zygg7ASv0KFaAcJRGltQ2Or2tTqRSXF9t9ajcQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DM4PR12MB7526.namprd12.prod.outlook.com (2603:10b6:8:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 13:45:51 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.026; Mon, 25 Dec 2023
 13:45:51 +0000
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
 AQHaMqaBunnLiYiUz0i03/j7bu1zQ7CxiQYAgAAFTwCAAJ4xgIAA0diAgABf+YCAAES4AIAABHKAgAAp1ICAAATiAIAAA0UAgAEjDACAACe4gIAE58oA
Date: Mon, 25 Dec 2023 13:45:51 +0000
Message-ID: <6c1167a4cfa54345cb8307848155b7482ead5475.camel@nvidia.com>
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
	 <a67c3ee375b1ae4aac5cc39539e1a25e23bf4f07.camel@nvidia.com>
In-Reply-To: <a67c3ee375b1ae4aac5cc39539e1a25e23bf4f07.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DM4PR12MB7526:EE_
x-ms-office365-filtering-correlation-id: f61eddd5-045b-4130-00e9-08dc054fcf53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xhgYH4Bb1Xe0QS2R36jbhKBF81OutVZqIysV6brRNw8hKVCC6tWteDj6I8vubZHyeDeBSHE1HyOL8mzOgnMUAVt5odGZ0jsylmcPRZpF+gLJ4TAdVnM7ulQuGJ6SPiIipScIYkYUZLw+qT6QUQ/isRoax8PSLcqmhAZ6SCtgNtCv9ojWDhsaVOpIiJP8EM2Ct5t3Wmf30TBhDI/eMW1bzHrSEjcnzigSygGmkp2p8ACQE6GiGUYTt9xzX7MuwscwXpLFxVA9JwssFp2Ujtvt26N6+uEcZfMtIB88ICSugu3uq2BJ75TAs1nI/2BfKkxAVO/zW42azaiDjgCruM/6BcJ9CLEu4JaLLjmYZbTWw17UGPOGjb2Q2ua8km2YACsQBTb4c9Z/vrpkOqg61Q9uiEMV5QBK+XXKaInjhkj2K+Jqhc/XpdICMi3WgX8QK/FNFbea9UulhDSvFgcLoPjAJIP1M2Z+DhkYnJS3cR6oKGugXkw0AUMxTh3hzOptjU/St5HNuBCecu0ncOUxwrE1Pht1vyVTxjuMN9rpoVZA+BJ9goe+HDnfemKZbCo2P8b4nD/m+LgiDSgcSFWmgVYRhSxg4ibSNRYYvsID5YQ1UNbhojwiRMRXTpkfzljRfvgxiBJLTor3CQpcAx/auSQXID+CsKpUDsuPh02rJn6fcfg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(346002)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(38070700009)(41300700001)(86362001)(36756003)(2616005)(71200400001)(83380400001)(122000001)(38100700002)(478600001)(6916009)(316002)(966005)(64756008)(66446008)(76116006)(66476007)(66946007)(66556008)(6512007)(6506007)(91956017)(54906003)(8676002)(8936002)(5660300002)(4326008)(4001150100001)(2906002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eWVoRGFYSERWYVdSb2ZaSnA2OHdYRHhGeVJxNkRqeWdRVE1lSlVaemp6TFNO?=
 =?utf-8?B?VUErdDRLU1IyS0RYSll4MjJ6U3BBdmJza1lJZnhzMnM3a3lZT0FHU29xS2lm?=
 =?utf-8?B?OEV4ZzE2b2pIMVAwQmtjcXZZZXZzbUVVbWtZaU5Rakh4THk4K2ZNY0IreGZa?=
 =?utf-8?B?RHQ1WXNkOG0rU3dkdFJzcjNxalpUQ3RaY1RPUkJaaTQ5NDcxbEQ5RFg5akhQ?=
 =?utf-8?B?VCtISXpoTHZDWDNhekhCb0UvYnBvMXZQSUYvdnMvMXhINFJzdmJqWC9wQlMr?=
 =?utf-8?B?QXorVHRyRmNMZERXaHlZMXM3bk0yejZINUhaYUwvbU5LNVM1eDhsSlRDd0Vw?=
 =?utf-8?B?dktHZDVJOTdCQWhQTHUzdUJ6K1UrTE1ZY3ZpTzkrLzFGRlZCeXZ5Y1NHWHNq?=
 =?utf-8?B?NlRiNk1KcjgySExqQ3pxNjF1eEFNZ28xZ3pIdi9KL0RoMFhqQ1ZjcFlWMzkw?=
 =?utf-8?B?bHJqbTYrZVFvQ2RBM1JRbXlpc0FsUElkK1BQZk1pbDU4bHl2ZWxvSTZYZFNl?=
 =?utf-8?B?OENEdE5pUzIxbCtxTjJWeHFDUlVrT3FtTnYycS8vWHJnclMxd3hBcXJXNmhK?=
 =?utf-8?B?dUpGUlNxYzY4ZXlSUHVoM3MrUnNjNDhROSt4Q2crWkFsODgzT0Y2WFdyWnkw?=
 =?utf-8?B?U3RKS3BmTVlwYzNDVytWWExrbDEwTVpMUDFkZEtDNTg4RVZUS2VPSnBVMWx2?=
 =?utf-8?B?ZWRoNmVYWmhkOVZZTmVNZkpvVERhQ0hFNzNQUEgzb2ZkNy9SMmFCMWUyY2tM?=
 =?utf-8?B?NWhaRWZwWS9wNTljeFJDbm5jcmp6MzhLZHRwTUdKSFhITFg3bVBGenpOSkNV?=
 =?utf-8?B?ZHkyOVNmOXNJbEVRamZpMWMwcTM4c0hreU91Y0N0VkJFQ3dsL3hteWh3TXd3?=
 =?utf-8?B?ZkhneTNGYnR5SWQvdDFRQ0RsOUZ1TzB5Q1JZaGFoUXpRZk9oWjNxUXRBRnc2?=
 =?utf-8?B?UnFpQ1pXM1dkQVBVWnJ3dmozUENtT2M0a01uRm1UZlRyZGRsR0ZLVmhKbDZK?=
 =?utf-8?B?MlhaSUlTZ2NCSU9pejJFSUJYY09yQWlPakpXbE5oVHBHdzFTOVpmVHArRy9n?=
 =?utf-8?B?NHFZVUV3bWVJT3R1SzBLOGt5a2xYL2trSUJvQnh0WW9HS0srUDVRWXUyMUNS?=
 =?utf-8?B?dDdMazhaSlRYQUFVZFYzVTc5djk2MjU3SXZoUC9zSTZ4S0gxVUd2N1hQclJB?=
 =?utf-8?B?dGV2Ym4yUXZJRWQwcFRpUUpRcForb2JxS1lVZXFNVWxRd2JqS2lZYUhJNmNJ?=
 =?utf-8?B?MlcvYjVRamNHdUJVWVVHUncxVUZISjFhd0xYdmZWVURzV2dsdnpCd2pzdXQy?=
 =?utf-8?B?RXdSMCtuUnNIT3FhRDh0Mmdoc1lvbHdvajVtNTlya3E5MXBPYkZNdlU1SzJY?=
 =?utf-8?B?YTZmeTAyTEhOd1hoNlRiQ3VJSzIvK2pCb0NqbXZaWHNGbDJzUmlRMm1wY0Z0?=
 =?utf-8?B?NDB3ejZxWHNZSGQ4ZitoNUVPNVV0eWx2WW8vTFhzM3VsaHQ4M2NHNEIzeXRV?=
 =?utf-8?B?SFpoQldpWXlPYjFVS2p5ekcrbTh5QWtDR1Q0cEljS1V6QUl1aWxEWDRBRWRV?=
 =?utf-8?B?K1QvMkZHTFJlWXFrVTFjdHhjQiszUXl6S2EvR04rLzRLamIzM21SMW5TUWh4?=
 =?utf-8?B?dGdZTFNlSDh4NE5pNGV0Ump3aUdxRTlQOVQvUWEvSmM1SVhqNFM2VTZwb21j?=
 =?utf-8?B?Z0NyNDl3b0NFSlQwSStlZXdzS0FtZldCT0IzR3NkRlR2dzl4aHlqNHo3dE9m?=
 =?utf-8?B?YW1CTHoyVk12bnF0RGFQL0k1cFZ2cFMyT05tU3Awd2FaZnRWVkx1cm5oZDR1?=
 =?utf-8?B?dFVMbjZiYWhPQjdxbUVpZjhLSWd2Yk1wdVlkV0VVeXBzQ0wrQUZNbXVGVHZh?=
 =?utf-8?B?d1lZRG0rSlJIT0pNTnhTZzU2WU5waWtQWkNONFBzRkdnNCs0WUpRM1R4RTR3?=
 =?utf-8?B?S2VndnU2eSttRFNJSGp3Tzh6ejNML1NzTHRnWUtZU3JYdzhlVWVHU01oV0lK?=
 =?utf-8?B?dy9lM25yRXZ6YjdiU2tYTEdvOGFKNkR5MkZsbjk5cnZxMWhxYkZOeWUrc1N3?=
 =?utf-8?B?bkJFczFmNHJVNThrem9TSm01WTdYd1BCeXNwNkZSSjhmZ21YQmtjL3ltWk5x?=
 =?utf-8?B?ei9EcCt1bnNNdnZRYUdRVVh0cWxIU1dnaktXYTN5RFpDUFZKMzVtTlh6VkRP?=
 =?utf-8?Q?SYHf6hRMOqSk/OFKJ76Mig8ROonNj8Pf7avSsSyTaOir?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2446533B1B1F3F4DBECD100E2439B013@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f61eddd5-045b-4130-00e9-08dc054fcf53
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2023 13:45:51.8411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0Ptt4vHzErNXmo1Obl9OC6ZZvNNIcwLEoiYCXYPitRocp1RdKUzHONCdwkmKKfG5qXV2UvYOImdbPDtJfXJmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7526

T24gRnJpLCAyMDIzLTEyLTIyIGF0IDExOjUxICswMTAwLCBEcmFnb3MgVGF0dWxlYSB3cm90ZToN
Cj4gT24gRnJpLCAyMDIzLTEyLTIyIGF0IDAzOjI5IC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4g
d3JvdGU6DQo+ID4gT24gVGh1LCBEZWMgMjEsIDIwMjMgYXQgMDM6MDc6MjJQTSArMDAwMCwgRHJh
Z29zIFRhdHVsZWEgd3JvdGU6DQo+ID4gPiA+ID4gPiBJbiB0aGF0IGNhc2UgeW91J3JlIHJpZ2h0
LCB3ZSBkb24ndCBuZWVkIGZlYXR1cmUgZmxhZ3MuIEJ1dCBJIHRoaW5rIGl0DQo+ID4gPiA+ID4g
PiB3b3VsZCBiZSBncmVhdCB0byBhbHNvIG1vdmUgdGhlIGVycm9yIHJldHVybiBpbiBjYXNlIHVz
ZXJzcGFjZSB0cmllcw0KPiA+ID4gPiA+ID4gdG8gbW9kaWZ5IHZxIHBhcmFtZXRlcnMgb3V0IG9m
IHN1c3BlbmQgc3RhdGUuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiBPbiB0aGUgZHJpdmVyIHNp
ZGUgb3Igb24gdGhlIGNvcmUgc2lkZT8NCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IENv
cmUgc2lkZS4NCj4gPiA+ID4gDQo+ID4gPiBDaGVja2luZyBteSB1bmRlcnN0YW5kaW5nOsKgaW5z
dGVhZCBvZiB0aGUgZmVhdHVyZSBmbGFncyB0aGVyZSB3b3VsZCBiZSBhIGNoZWNrDQo+ID4gPiAo
Zm9yIC5zZXRfdnFfYWRkciBhbmQgLnNldF92cV9zdGF0ZSkgdG8gcmV0dXJuIGFuIGVycm9yIGlm
IHRoZXkgYXJlIGNhbGxlZCB1bmRlcg0KPiA+ID4gRFJJVkVSX09LIGFuZCBub3Qgc3VzcGVuZGVk
IHN0YXRlPw0KPiA+IA0KPiA+IFllYSB0aGlzIGxvb2tzIG11Y2ggc2FuZXIsIGlmIHdlIHN0YXJ0
IGFkZGluZyBmZWF0dXJlIGZsYWdzIGZvcg0KPiA+IGVhY2ggT1BFUkFUSU9OX1hfTEVHQUxfSU5f
U1RBVEVfWSB0aGVuIHdlIHdpbGwgZW5kIHVwIHdpdGggTl4yDQo+ID4gZmVhdHVyZSBiaXRzIHdo
aWNoIGlzIG5vdCByZWFzb25hYmxlLg0KPiA+IA0KPiBBY2suIElzIHRoZSB2MiBlbm91Z2ggb3Ig
c2hvdWxkIEkgcmVzcGluIGEgdjUgd2l0aCB0aGUgdXBkYXRlZCBBY2tlZC1ieSB0YWdzPw0KPiAN
Cj4gSSB3aWxsIHByZXBhcmUgdGhlIGNvcmUgcGFydCBhcyBhIGRpZmZlcmVudCBzZXJpZXMgd2l0
aG91dCB0aGUgZmxhZ3MuDQo+IA0KQ29yZSBwYXJ0IHNlbnQ6DQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy92aXJ0dWFsaXphdGlvbi8yMDIzMTIyNTEzNDIxMC4xNTE1NDAtMS1kdGF0dWxlYUBudmlk
aWEuY29tL1QvI3QNCg0KSSBhbHNvIGhhdmUgYSB2MiByZXNwaW4gd2l0aCBleHRyYSBBY2tlZC1i
eSB0YWdzIGlmIG5lY2Vzc2FyeSBhcyBhIHY1LiBKdXN0IGxldA0KbWUga25vdyBpZiBpdCBpcyBu
ZWVkZWQuDQoNClRoYW5rcywNCkRyYWdvcw0K

