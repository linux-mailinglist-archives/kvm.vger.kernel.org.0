Return-Path: <kvm+bounces-5076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 812A481BA31
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389BE28C930
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39954B15B;
	Thu, 21 Dec 2023 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A1F8CY5i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513133609D;
	Thu, 21 Dec 2023 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9T+EhPq8lD95w9HNEY/jOCIlWtrGEv2t6h33FuAu/DKwaciCjKU2H3DWvMGeFIlTvDhYbv2yRLZEruL/GJBuZQ11oXJiBr5BleFUkbKWZVOVsxDBvZIMk5ALGsJDsNsMt3vgjyiYx9WRUDpwuGvySnAzvVrYxzirqgHqLyAzWBxXtlKYwnqd3hVUDDe7mkr4RqxWawvuhOL/8mV5Hf9Sef11foQ9/R3Sho3CfM472z3vWQuimZZOlfFp8q/ectvtreFQ1J3lWWjZetg2mBgkRdH1ncL+sA9V7Vi0t633DRIyZvNnmNuEiw4N3MAD1iInud0DJ1sgtGBNO+9dFJUzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4M0Kab1D7bXCUfcLmU0YoQjgjyZLxOMBJg1cy5UpDhc=;
 b=FRhC4ol0svFsnNOqtQ17EMjNUPmXP0lYftxnuRT0af3M5v0OzU3rWKv011j1eah92aaSOrCrK805iqJZBh5x/c/lG0B9exApNwyFDi2/HqPuSgG0ejsBDszQlvKxPLVi3+Bz1ZN2DrbV4itI21KmB7+vxmo7GbHHiicJUs2R3yPJl0tp9v520LZG04PCs5rV8mj5N+dwxdwNiSSq8XqP1XKQ3PNgOV6NCgWSbnSAiJqr7uoSh+FLJaHeXDRikla/JsKrOYmBdmAycQz/6NsMlX/embW0TD/AInfe2QGxQg3LpZOsFVsOftM1dNwYzXyTyJVLafclBHy/wa/+LvLCAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4M0Kab1D7bXCUfcLmU0YoQjgjyZLxOMBJg1cy5UpDhc=;
 b=A1F8CY5iOFvPQj6pENBWJDBYtusCymdjQVZcppo4f1axAOA35UwMzKJAKKOpsJ1atDVh0Q0rl2UwNA8rApR9Ci1LLZ31Rbxu986HkyQEJQLeWeCAs6GYeeaecZ4u+rIcQr5X1mQwjKg9Q5Yz5sMnI8KQElk5S7a6ha/GNZD6qEA9L4kQdTAVpy6ofh8tuQNPhlw/l63F1T/RALGzcaFxbtWCmB1Wn3OTfRGhPb/I+l8Tei3PDk53zKm3fHV7rXnlTzIbHVyZiSC7Pqa33NoaAfCtjOwQKtWOxBfyorfXpVCBNQPZa2eBuz1TJreGT3238Euj2H9G/081HV0ZaTq/2Q==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DM4PR12MB6424.namprd12.prod.outlook.com (2603:10b6:8:be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Thu, 21 Dec
 2023 15:07:22 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 15:07:22 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "eperezma@redhat.com" <eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, "mst@redhat.com" <mst@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Topic: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Index:
 AQHaMqaBunnLiYiUz0i03/j7bu1zQ7CxiQYAgAAFTwCAAJ4xgIAA0diAgABf+YCAAES4AIAABHKAgAAp1ICAAATiAIAAA0UA
Date: Thu, 21 Dec 2023 15:07:22 +0000
Message-ID: <17abeefd02c843cddf64efbeadde49ad15c365a1.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231219180858.120898-3-dtatulea@nvidia.com>
	 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
	 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
	 <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com>
	 <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
	 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
	 <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
	 <CAJaqyWeUHiZXMFkNBpinCsJAXojtPkGz+SjzUNDPx5W=qqON1w@mail.gmail.com>
	 <c03eb2bb3ad76e28be2bb9b9e4dee4c3bc062ea7.camel@nvidia.com>
	 <CAJaqyWevZX5TKpaLiJwu2nD7PHFsHg+TEZ=iPdWvrH4jyPV+cA@mail.gmail.com>
In-Reply-To:
 <CAJaqyWevZX5TKpaLiJwu2nD7PHFsHg+TEZ=iPdWvrH4jyPV+cA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DM4PR12MB6424:EE_
x-ms-office365-filtering-correlation-id: 56545f38-1cb4-45fa-dafc-08dc02368881
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 o4UyQvrhhbaBw5yNVRS4bv0E+35xTLLEGPSLNTIj7wbr4y3VAJKyEdfY1PFrLv9R+x4RhkvGuMTOPdcxJ1FLFGpuCdo5HAvd0HwdznHdI96L63X4XKl9JDSBdk1796TQAeeEpwJaybAMuHS/ewPxFBe9X66bXYil18s381EQdX8PXV2X8rMQng14tx3YAmjuxAg+A82JhZ07LaiW5q3IwPInXB2odtdAYNeuE5SLX3OPQn5PVpiU4bcD9PeGJKmJIrF3+k0SgQSExwgfCFBxBCOWdJLcm/KDd1YCQRiH2zmvH7i7lQ6DCIRygb8RE/aQswEoxsz/61GNLw1wWq3Zsctzq5vvyL7wF2OwgypIxG4xOm2wnviKCXPEjB340qfdn6Gpek5OMshaVxjZ3omsXH0qncv1c14OkU8bKP7yoQbPsQP4BmFNVmn3Xx9jCOMT/pcr/TFma6sZsZbMHBieSKpF68QSHtm1gPvGH0D69gscxSCofxXdR7L4h+y4FauYpEn6gc7d9BXJMvSLOZwlXcz2g33MPATV7hHj8yVNZNRGDlm8bUNrddsq9GHbajcEQol7qKcEl06HNvNb+TDC6BrxFxKGXeJ6VxR8fljJXGQXHoyNzMgVDtai7Hd8vxOE
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(366004)(376002)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(38070700009)(36756003)(86362001)(66899024)(478600001)(76116006)(6512007)(6506007)(53546011)(91956017)(6486002)(41300700001)(71200400001)(2616005)(38100700002)(83380400001)(4001150100001)(2906002)(316002)(8936002)(66556008)(66946007)(5660300002)(4326008)(66476007)(8676002)(122000001)(66446008)(64756008)(6916009)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YTN0WFJCcTdHSlphbFBmaXVCNmFjeWJEclF4S2tJcWYweHU3Q0pveWpQdSt2?=
 =?utf-8?B?OHArQkpoWEtlTDNvQm5RMDFnNDJrOThBWUNhVWIyNTRHckp0MXd4QmhyTHNn?=
 =?utf-8?B?ekhUbjF0a1dYNzd1elBsTVZrY3V2U0MzY0JRcEd4dkFWeXFqUEVCZ0pJcWxZ?=
 =?utf-8?B?Qlp2ZnhQbFVNZDNBb0VOL3VNVDlnQ2NVMXVsemdhYTNOcWt6N0NvTXJCbi9j?=
 =?utf-8?B?WXR1ei9lbkd4bUxvbzE4TVliaHFZWlhxMWc0MTRheUN1bGNQZThYVERPdHps?=
 =?utf-8?B?NVloVFZvWWwwdXd4cVJkNEZSNjVTQ2FuaUJNSnIxRVRyaUZHa0UxUVNMVThP?=
 =?utf-8?B?QU9JNDkvQ2ZWMWk4QWQwZXFvTk5PbVBnbWlnc3Y5YnNIZmt3WUpRZVFqcjRY?=
 =?utf-8?B?RXpDaEhtaUZRNUozakY3V3lKVmxMc1h2VlZrSE9MQUtXendxZmszRG1FSzJ4?=
 =?utf-8?B?MVFMS2hiemg0S2NvZ2p5cFlzYklReEZtSURra1I3ODdFNW5uWUFVQVFpazhS?=
 =?utf-8?B?RFJYUmVJZ1BaaEViNHNCZHhTT2F6eHJXY0FPallxK2MrMTBldHZnVS9RSGtB?=
 =?utf-8?B?cTQ0blF6cjRmV25yNzcvU2dUSE1PSDJGL0JkTGc2eXRaTjVHbUtxSEtISVhV?=
 =?utf-8?B?ZDU2TldnVGRCQWZEUzVBYVNTN0NRaG9kL25mbnh4TS9hTkRoUmV1SmJ1aUFn?=
 =?utf-8?B?WHZCVlIxVk5oLytYQnZ1THdhdXJmZU1sb2FINkFMeEVZNWJ6TWQ1VW5Yekxk?=
 =?utf-8?B?ZGRuZW1PS2RZUVpOb3pacFRtNWZENENQMFUvd0hqV0J6d2daVHRpakRxRG1O?=
 =?utf-8?B?WFBZaXVYem1GMGJucmpERmRrczBtSzc1MzgySXdpNE5UVEtXWk82RVBUWURH?=
 =?utf-8?B?NlY5Y3RsSFpIdFVVdzVSME9qcGxRR013dE1rUHVUY3g1S2NKOFpLQnFrZk1w?=
 =?utf-8?B?ZVpDZXExbnpLY1hNZ1Vhd1RibitCRHBsZ2ljUjBKb0dVWW5TZW1NS2xra3VN?=
 =?utf-8?B?cERVYjlTbTJFbS8wVzlFT0JoL3VPMDZQaVVnYWxMY210bEkyQVFvMUlnZmx3?=
 =?utf-8?B?WmlrWWtMc3E1Y1V1UldyUURhTmlJZWZ4eVRTUUEycGNrazkvazF4alByZkFy?=
 =?utf-8?B?OFZraWdxTitIY0Q2TlZxT3JDVXZsZzhaODhURTVSeUNoYUxOQ2NneDNnekFv?=
 =?utf-8?B?b0hwWEgweHZ4QXZ5VEVra3VWTGQxdWFjQi8rUHdjWng4Nml0WkRSdkF6S0h0?=
 =?utf-8?B?K2ticGtSQ01BakFLWE94TzlYc25wVVNoTEg2Q3BBdlZOQXFMWEIwU0JQcnk0?=
 =?utf-8?B?aktMeGN6dE1aaHpaeEdoTmhFMjJjelZMQmhtak1OUXRwaHpmY0kweEI2ajVE?=
 =?utf-8?B?eWdHYTlLb2dmQzhuSVUwN3NubnkvcDhuT2xKY0dncmpUMFI5aFFxQ3BPbk5h?=
 =?utf-8?B?WFhQOWROd0oyZ2tHNUxNZXVJWWJiMGtMMTNrM2ZrQU93VmxWUmNIUGdPQmZB?=
 =?utf-8?B?Ny9Oa0l2eDFBSllCRkJoaklyVis0bUpiaDExbGpOOUM1a1JhTXIyV3F4UnFT?=
 =?utf-8?B?Y1pDNDZ6Rms2WStUNHk4N05oN1QvanhFWFJGMnZLcmNTNTJGbkhEdVkxcUo4?=
 =?utf-8?B?V1ZtaGtQbzIzclZwSHAveWJOdWJ6N1B2ZVFINnh3UVlkMlh5K0FCUmpmNFd4?=
 =?utf-8?B?bnNxTTd4WWFMenRHY3o0RHBaL3Y1aFo4NThmOVFGSG10TDRicnZTNXN6dkdX?=
 =?utf-8?B?dWhFakVoWGlsbzhkdEdML1JldWlNYXpvV1JRNkpoRHBPdlRHNkp3OFJjUzFE?=
 =?utf-8?B?Njg5Ym8xRHI2c3RXcUhJdkIxSzFobHFFODF3Q3dpT1U5QThIa2ZhMkxZdFVo?=
 =?utf-8?B?a2dKcGY0MnpmRmE5bzJMVFdzTEtPcG5PdnVLNHJsbkpVRDFpY09TWEowUzRm?=
 =?utf-8?B?bWZ2YUNMUmp2UVZOY0s4RThFeFNqSWlseGxhZjdFSHRkT0JINDdOZkp6UzFw?=
 =?utf-8?B?VVF3NllOZ3ZCbU1TWnZnVEFSQXZJQTNGdkEzMVNjVklNQnFmVTg0ankvZ0Y4?=
 =?utf-8?B?SEh6T0UyUzg2K2U4VkprMXdXY1FnbnN2MG1pNTlNVlIvSTFCaG1GbWw3RVF0?=
 =?utf-8?B?ZmxPMHlSQVJXanpVbWJNckltQzFYVjcwSzhZVGhsNDJvZXZvUGU2b3RzcjVU?=
 =?utf-8?Q?p9LDiyk2dln5AE67dSJxFwB9YuLDgl68Iu7gpG9Fm6dk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3342ABDC395F5E43A700E7B6D0C8EFFC@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 56545f38-1cb4-45fa-dafc-08dc02368881
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 15:07:22.1198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o4XDcjI4wFXKo5BP3dAdPlFWnqdgIVgdVzzcY6NnoV5EKBcCisWzV88vhu5yGyCVESKNpO5F1THz+ltO5w/LEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6424

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDE1OjU1ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gVGh1LCBEZWMgMjEsIDIwMjMgYXQgMzozOOKAr1BNIERyYWdvcyBUYXR1bGVh
IDxkdGF0dWxlYUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUaHUsIDIwMjMtMTIt
MjEgYXQgMTM6MDggKzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFydGluIHdyb3RlOg0KPiA+ID4gT24g
VGh1LCBEZWMgMjEsIDIwMjMgYXQgMTI6NTLigK9QTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFA
bnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBUaHUsIDIwMjMtMTItMjEg
YXQgMDg6NDYgKzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFydGluIHdyb3RlOg0KPiA+ID4gPiA+IE9u
IFRodSwgRGVjIDIxLCAyMDIzIGF0IDM6MDPigK9BTSBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRo
YXQuY29tPiB3cm90ZToNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gT24gV2VkLCBEZWMgMjAs
IDIwMjMgYXQgOTozMuKAr1BNIEV1Z2VuaW8gUGVyZXogTWFydGluDQo+ID4gPiA+ID4gPiA8ZXBl
cmV6bWFAcmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBP
biBXZWQsIERlYyAyMCwgMjAyMyBhdCA1OjA24oCvQU0gSmFzb24gV2FuZyA8amFzb3dhbmdAcmVk
aGF0LmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gT24gV2Vk
LCBEZWMgMjAsIDIwMjMgYXQgMTE6NDbigK9BTSBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQu
Y29tPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+ID4gT24gV2Vk
LCBEZWMgMjAsIDIwMjMgYXQgMjowOeKAr0FNIERyYWdvcyBUYXR1bGVhIDxkdGF0dWxlYUBudmlk
aWEuY29tPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+
IFRoZSB2aXJ0aW8gc3BlYyBkb2Vzbid0IGFsbG93IGNoYW5naW5nIHZpcnRxdWV1ZSBhZGRyZXNz
ZXMgYWZ0ZXINCj4gPiA+ID4gPiA+ID4gPiA+ID4gRFJJVkVSX09LLiBTb21lIGRldmljZXMgZG8g
c3VwcG9ydCB0aGlzIG9wZXJhdGlvbiB3aGVuIHRoZSBkZXZpY2UgaXMNCj4gPiA+ID4gPiA+ID4g
PiA+ID4gc3VzcGVuZGVkLiBUaGUgVkhPU1RfQkFDS0VORF9GX0NIQU5HRUFCTEVfVlFfQUREUl9J
Tl9TVVNQRU5EIGZsYWcNCj4gPiA+ID4gPiA+ID4gPiA+ID4gYWR2ZXJ0aXNlcyB0aGlzIHN1cHBv
cnQgYXMgYSBiYWNrZW5kIGZlYXR1cmVzLg0KPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiA+ID4gPiBUaGVyZSdzIGFuIG9uZ29pbmcgZWZmb3J0IGluIHZpcnRpbyBzcGVjIHRvIGludHJv
ZHVjZSB0aGUgc3VzcGVuZCBzdGF0ZS4NCj4gPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4g
PiA+ID4gU28gSSB3b25kZXIgaWYgaXQncyBiZXR0ZXIgdG8ganVzdCBhbGxvdyBzdWNoIGJlaGF2
aW91cj8NCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBBY3R1YWxseSBJIG1lYW4s
IGFsbG93IGRyaXZlcnMgdG8gbW9kaWZ5IHRoZSBwYXJhbWV0ZXJzIGR1cmluZyBzdXNwZW5kDQo+
ID4gPiA+ID4gPiA+ID4gd2l0aG91dCBhIG5ldyBmZWF0dXJlLg0KPiA+ID4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gVGhhdCB3b3VsZCBiZSBpZGVhbCwgYnV0IGhv
dyBkbyB1c2VybGFuZCBjaGVja3MgaWYgaXQgY2FuIHN1c3BlbmQgKw0KPiA+ID4gPiA+ID4gPiBj
aGFuZ2UgcHJvcGVydGllcyArIHJlc3VtZT8NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gQXMg
ZGlzY3Vzc2VkLCBpdCBsb29rcyB0byBtZSB0aGUgb25seSBkZXZpY2UgdGhhdCBzdXBwb3J0cyBz
dXNwZW5kIGlzDQo+ID4gPiA+ID4gPiBzaW11bGF0b3IgYW5kIGl0IHN1cHBvcnRzIGNoYW5nZSBw
cm9wZXJ0aWVzLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBFLmc6DQo+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+IHN0YXRpYyBpbnQgdmRwYXNpbV9zZXRfdnFfYWRkcmVzcyhzdHJ1Y3QgdmRw
YV9kZXZpY2UgKnZkcGEsIHUxNiBpZHgsDQo+ID4gPiA+ID4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdTY0IGRlc2NfYXJlYSwgdTY0IGRyaXZlcl9hcmVhLA0KPiA+ID4gPiA+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU2NCBkZXZpY2VfYXJlYSkNCj4g
PiA+ID4gPiA+IHsNCj4gPiA+ID4gPiA+ICAgICAgICAgc3RydWN0IHZkcGFzaW0gKnZkcGFzaW0g
PSB2ZHBhX3RvX3NpbSh2ZHBhKTsNCj4gPiA+ID4gPiA+ICAgICAgICAgc3RydWN0IHZkcGFzaW1f
dmlydHF1ZXVlICp2cSA9ICZ2ZHBhc2ltLT52cXNbaWR4XTsNCj4gPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gICAgICAgICB2cS0+ZGVzY19hZGRyID0gZGVzY19hcmVhOw0KPiA+ID4gPiA+ID4gICAg
ICAgICB2cS0+ZHJpdmVyX2FkZHIgPSBkcml2ZXJfYXJlYTsNCj4gPiA+ID4gPiA+ICAgICAgICAg
dnEtPmRldmljZV9hZGRyID0gZGV2aWNlX2FyZWE7DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+
ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gPiA+ID4gPiB9DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBTbyBpbiB0aGUgY3VycmVudCBrZXJuZWwgbWFzdGVyIGl0IGlzIHZhbGlk
IHRvIHNldCBhIGRpZmZlcmVudCB2cQ0KPiA+ID4gPiA+IGFkZHJlc3Mgd2hpbGUgdGhlIGRldmlj
ZSBpcyBzdXNwZW5kZWQgaW4gdmRwYV9zaW0uIEJ1dCBpdCBpcyBub3QgdmFsaWQNCj4gPiA+ID4g
PiBpbiBtbHg1LCBhcyB0aGUgRlcgd2lsbCBub3QgYmUgdXBkYXRlZCBpbiByZXN1bWUgKERyYWdv
cywgcGxlYXNlDQo+ID4gPiA+ID4gY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcpLiBCb3RoIG9mIHRo
ZW0gcmV0dXJuIHN1Y2Nlc3MuDQo+ID4gPiA+ID4gDQo+ID4gPiA+IEluIHRoZSBjdXJyZW50IHN0
YXRlLCB0aGVyZSBpcyBubyByZXN1bWUuIEhXIFZpcnRxdWV1ZXMgd2lsbCBqdXN0IGdldCByZS1j
cmVhdGVkDQo+ID4gPiA+IHdpdGggdGhlIG5ldyBhZGRyZXNzLg0KPiA+ID4gPiANCj4gPiA+IA0K
PiA+ID4gT2gsIHRoZW4gYWxsIG9mIHRoaXMgaXMgZWZmZWN0aXZlbHkgdHJhbnNwYXJlbnQgdG8g
dGhlIHVzZXJzcGFjZQ0KPiA+ID4gZXhjZXB0IGZvciB0aGUgdGltZSBpdCB0YWtlcz8NCj4gPiA+
IA0KPiA+IE5vdCBxdWl0ZTogbWx4NV92ZHBhX3NldF92cV9hZGRyZXNzIHdpbGwgc2F2ZSB0aGUg
dnEgYWRkcmVzcyBvbmx5IG9uIHRoZSBTVyB2cQ0KPiA+IHJlcHJlc2VudGF0aW9uLiBPbmx5IGxh
dGVyIHdpbGwgaXQgd2lsbCBjYWxsIGludG8gdGhlIEZXIHRvIHVwZGF0ZSB0aGUgRlcuIExhdGVy
DQo+ID4gbWVhbnM6DQo+ID4gLSBPbiBEUklWRVJfT0sgc3RhdGUsIHdoZW4gdGhlIFZRcyBnZXQg
Y3JlYXRlZC4NCj4gPiAtIE9uIC5zZXRfbWFwIHdoZW4gdGhlIFZRcyBnZXQgcmUtY3JlYXRlZCAo
YmVmb3JlIHRoaXMgc2VyaWVzKSAvIHVwZGF0ZWQgKGFmdGVyDQo+ID4gdGhpcyBzZXJpZXMpDQo+
ID4gLSBPbiAucmVzdW1lIChhZnRlciB0aGlzIHNlcmllcykuDQo+ID4gDQo+ID4gU28gaWYgdGhl
IC5zZXRfdnFfYWRkcmVzcyBpcyBjYWxsZWQgd2hlbiB0aGUgVlEgaXMgaW4gRFJJVkVSX09LIGJ1
dCBub3QNCj4gPiBzdXNwZW5kZWQgdGhvc2UgYWRkcmVzc2VzIHdpbGwgYmUgc2V0IGxhdGVyIGZv
ciBsYXRlci4NCj4gPiANCj4gDQo+IE91Y2gsIHRoYXQgaXMgbW9yZSBpbiB0aGUgbGluZSBvZiBt
eSB0aG91Z2h0cyA6KC4NCj4gDQo+ID4gPiBJbiB0aGF0IGNhc2UgeW91J3JlIHJpZ2h0LCB3ZSBk
b24ndCBuZWVkIGZlYXR1cmUgZmxhZ3MuIEJ1dCBJIHRoaW5rIGl0DQo+ID4gPiB3b3VsZCBiZSBn
cmVhdCB0byBhbHNvIG1vdmUgdGhlIGVycm9yIHJldHVybiBpbiBjYXNlIHVzZXJzcGFjZSB0cmll
cw0KPiA+ID4gdG8gbW9kaWZ5IHZxIHBhcmFtZXRlcnMgb3V0IG9mIHN1c3BlbmQgc3RhdGUuDQo+
ID4gPiANCj4gPiBPbiB0aGUgZHJpdmVyIHNpZGUgb3Igb24gdGhlIGNvcmUgc2lkZT8NCj4gPiAN
Cj4gDQo+IENvcmUgc2lkZS4NCj4gDQpDaGVja2luZyBteSB1bmRlcnN0YW5kaW5nOsKgaW5zdGVh
ZCBvZiB0aGUgZmVhdHVyZSBmbGFncyB0aGVyZSB3b3VsZCBiZSBhIGNoZWNrDQooZm9yIC5zZXRf
dnFfYWRkciBhbmQgLnNldF92cV9zdGF0ZSkgdG8gcmV0dXJuIGFuIGVycm9yIGlmIHRoZXkgYXJl
IGNhbGxlZCB1bmRlcg0KRFJJVkVSX09LIGFuZCBub3Qgc3VzcGVuZGVkIHN0YXRlPw0KDQo+IEl0
IGRvZXMgbm90IGhhdmUgdG8gYmUgcGFydCBvZiB0aGlzIHNlcmllcywgSSBtZWFudCBpdCBjYW4g
YmUgcHJvcG9zZWQNCj4gaW4gYSBzZXBhcmF0ZSBzZXJpZXMgYW5kIGFwcGxpZWQgYmVmb3JlIHRo
ZSBwYXJlbnQgZHJpdmVyIG9uZS4NCj4gDQo+ID4gVGhhbmtzDQo+ID4gPiBUaGFua3MhDQo+ID4g
PiANCj4gPiA+IA0KPiA+ID4gPiA+IEhvdyBjYW4gd2Uga25vdyBpbiB0aGUgZGVzdGluYXRpb24g
UUVNVSBpZiBpdCBpcyB2YWxpZCB0byBzdXNwZW5kICYNCj4gPiA+ID4gPiBzZXQgYWRkcmVzcz8g
U2hvdWxkIHdlIGhhbmRsZSB0aGlzIGFzIGEgYnVnZml4IGFuZCBiYWNrcG9ydCB0aGUNCj4gPiA+
ID4gPiBjaGFuZ2U/DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBU
aGUgb25seSB3YXkgdGhhdCBjb21lcyB0byBteSBtaW5kIGlzIHRvIG1ha2Ugc3VyZSBhbGwgcGFy
ZW50cyByZXR1cm4NCj4gPiA+ID4gPiA+ID4gZXJyb3IgaWYgdXNlcmxhbmQgdHJpZXMgdG8gZG8g
aXQsIGFuZCB0aGVuIGZhbGxiYWNrIGluIHVzZXJsYW5kLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiBZZXMuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSSdtDQo+ID4gPiA+ID4gPiA+
IG9rIHdpdGggdGhhdCwgYnV0IEknbSBub3Qgc3VyZSBpZiB0aGUgY3VycmVudCBtYXN0ZXIgJiBw
cmV2aW91cyBrZXJuZWwNCj4gPiA+ID4gPiA+ID4gaGFzIGEgY29oZXJlbnQgYmVoYXZpb3IuIERv
IHRoZXkgcmV0dXJuIGVycm9yPyBPciByZXR1cm4gc3VjY2Vzcw0KPiA+ID4gPiA+ID4gPiB3aXRo
b3V0IGNoYW5naW5nIGFkZHJlc3MgLyB2cSBzdGF0ZT8NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+
ID4gV2UgcHJvYmFibHkgZG9uJ3QgbmVlZCB0byB3b3JyeSB0b28gbXVjaCBoZXJlLCBhcyBlLmcg
c2V0X3ZxX2FkZHJlc3MNCj4gPiA+ID4gPiA+IGNvdWxkIGZhaWwgZXZlbiB3aXRob3V0IHN1c3Bl
bmQgKGp1c3QgYXQgdUFQSSBsZXZlbCkuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiBJIGRvbid0IGdldCB0aGlzLCBzb3JyeS4gSSByZXBocmFzZWQgbXkgcG9pbnQgd2l0aCBh
biBleGFtcGxlIGVhcmxpZXINCj4gPiA+ID4gPiBpbiB0aGUgbWFpbC4NCj4gPiA+ID4gPiANCj4g
PiA+ID4gDQo+ID4gPiANCj4gPiANCj4gDQoNCg==

