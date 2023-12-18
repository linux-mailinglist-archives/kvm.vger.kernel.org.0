Return-Path: <kvm+bounces-4723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 702DA817181
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80E051C24230
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 13:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B2C1D148;
	Mon, 18 Dec 2023 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="le0xCgzD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81B9101D4;
	Mon, 18 Dec 2023 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTQ+LZ9lqgqSknY+1bnJaI6jMtY5LLbAwXnfkFTegoA0afl5vIKI3PvRupGSk41Vr4cHvDPnQDEZv9rqQBphgSeQybjB5e+L3ypfbXcOhAdRtXObzjWUf+32JEEBQ8E1Mtb5KgRyJmfLwx39yyr7YnRN0jFH9KlGqlA18R86GEHXlbjwOBvc2b2ieih1iE3P2cuQtcGtJO4S0JoAZV4uCO29iOW5n9tlTtA5yTBm9nXSzFaDBb+vrkFKBUetwaZJD80Ajoq6gyOt1pB1SC+qW8Ayoxf6sDqmnXPC7U2fiOvNYftZveCezlMEIWymnmDQgNQcv/rS9fZBnEXu6kMCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtveIy61O3UtzPKcGUaPoJU8wbBvfG60Svxtr+gmjoQ=;
 b=dwIx6Ks65bAO0EvHqL7XyvQTOkiR9YjMayS+5cgb1wgp2YM+wurlkV0f4EroGDQf6DyCwkh/35ET3oYc6yuy9tz8iz+nPfTMu3wuk7m4rZbn45DyITiHFhe4ztwqSEX+P5NRaQB8n0mYIRjKs9V1/K0aPjb/cafMJaCkXKkbUFhF3n177n/k2/tlJ8NRydWaperOtcGzSJiQDdDrcyUNaB8QjCY1i0temhYYkDm0C9X9hvN+0+m1gwZqvvBbcvQoy7LOT8ThNbgo1tgG8Eu1cG4dqaiCUYjWh/YIF+VaML7XpFjLKuPXluPvEeU30vIwemxX9ygq05zg2u/eVfXAuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtveIy61O3UtzPKcGUaPoJU8wbBvfG60Svxtr+gmjoQ=;
 b=le0xCgzDn9RrOR1pVpMJSM727yOD0eU4ORq9oLYzTu/NZORBLVwIs08PWX2/b4PTQXuTWc8NE+CCJJUdeXnN7oRUYBwPPZfBfyaH13uHXO/1aNKTFGWd3XbnshiojdzGqJzXEvVEkCVF9PesKsbLL6T/7y/cfTAfT3CXlOk6P0lGzKbZl9GMXSvgA73hcvvDp8wwUH2BolUXLzsVIpAyUsUKFDtDNNCv+vnYfo+bQDflwF0MwvchJMlJP38+Z6zKLmxRU3LXG5+O2t7NEHiiG64JVnQiU7prdxVwRoYGqjvUWC/YjMIzbkuYmnAnrQZcceo978ldVlDSqKs/n/XQ3Q==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by SJ2PR12MB8954.namprd12.prod.outlook.com (2603:10b6:a03:541::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 13:58:22 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.034; Mon, 18 Dec 2023
 13:58:22 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "eperezma@redhat.com" <eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Thread-Topic: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification
 in hw vq
Thread-Index:
 AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgABJawCAAnvhAIAAAZuAgAAjJQCAACyCAIABLv6AgAAbWwCAAD6HgIABHtoAgAMXogCAAAnpAIAAFKuAgAAfSYA=
Date: Mon, 18 Dec 2023 13:58:22 +0000
Message-ID: <8fc4e1f156b075ec3f4c65acc1e10439f767bf81.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
	 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
	 <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
	 <20231214084526-mutt-send-email-mst@kernel.org>
	 <9a6465a3d6c8fde63643fbbdde60d5dd84b921d4.camel@nvidia.com>
	 <CAJaqyWfF9eVehQ+wutMDdwYToMq=G1+War_7wANmnyuONj=18g@mail.gmail.com>
	 <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com>
	 <0bfb42ee1248b82eaedd88bdc9e97e83919f2405.camel@nvidia.com>
	 <CAJaqyWdv5xAXp2jiAj=z+3+Bu+6=sXiE0HtOZrMSSZmvVsHeJw@mail.gmail.com>
	 <161c7e63d9c7f64afc959b1ea4a068ee2ddafa6c.camel@nvidia.com>
	 <CAJaqyWf=ZtoSDGdhYrJdXMQuFvahzF5FtWkdShBmTGaewvQLrw@mail.gmail.com>
	 <7c267819eb52f933251c118ba2d1ceb75043c5b2.camel@nvidia.com>
	 <CAJaqyWccZJFdfww-_vmj4kJvJkWKFt_VBWmujfVTsFxHohkiZg@mail.gmail.com>
In-Reply-To:
 <CAJaqyWccZJFdfww-_vmj4kJvJkWKFt_VBWmujfVTsFxHohkiZg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|SJ2PR12MB8954:EE_
x-ms-office365-filtering-correlation-id: 773d50af-9e95-4e98-c401-08dbffd165e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 BcMyfSZkIvnvJcmnrR1apoMVPtFmENYr50Pb+hYvHMgFksk1JEJDUg6PVpMRZ83f8Q0lEP/DEcM3AdvIq+yONDD7VcF12/BkYIfprba2my1BPWHR5VIHWOa+c56OA2WPnWWjzaQIChMFZgoq/sSOl+TlXnZdFRJqTFRP4k9h44szvaxjIED5P8B7wyDegtS1yWR8H8jeN4MU6CecfTnFja3S7xuD6ZwDwQkHyB7MiTwfpGpO3hcZudqrbB42kuGYe4m1aTuYHt1Z2FTdGyhok5bcKAlym160P2h6aIOwV+pCRBGvgbUJmHuYUkgtgxqVi1UrMlXlismtkeV4IZ9/tgq2bcTCfdVk08Rhqr0rE3wrEtyj8tO9UO2cKHHkHc4FQuGX//lGIYQJPoAIW0CQUWVxRhOrCaso/fn5JlgAcgJXBL+7YllIVWeoI3XyhrbDf4mqb65tmjcgXED4dlKMFl5bp0Z6X2uqMP6lU6Ppw/wZNqggAGeyWT93GX2fvq+UzNd3bn1xWEwAygesUvOVwf9/KeOwXgG3oqpAsZTqG/KSuUTL1QwiqX7mWULZZY3GV9558GXWKpRx790gCtqg39rolQrFVr8tBnmcPya/14wfdXSSooOjnRd8MaIOqz74/JAtKRjSHsTtdFyIe5oOQp9zroCS//ie6aALTji5I/Q=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(39860400002)(376002)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(38070700009)(76116006)(91956017)(86362001)(36756003)(38100700002)(122000001)(83380400001)(66574015)(53546011)(2616005)(71200400001)(478600001)(966005)(6486002)(2906002)(4001150100001)(64756008)(54906003)(66556008)(66446008)(66476007)(6916009)(6512007)(6506007)(316002)(4326008)(5660300002)(8936002)(8676002)(66946007)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bnAzOHBYY0NRWXVqSzlZQTZTMDF1WCtOQ2NYeWlmbkxtcGZDZTZZVEtERmxq?=
 =?utf-8?B?M296WU1QKzZqSWhiUDU0cWF1UmI3RDg5RVZqa2xIMFFnYjlGRjZmaDQ0eE5l?=
 =?utf-8?B?QXJxRmdodWxCaTJWZWNQajdkeDB1bTA4dTVKMXZYUSt2T1Q3ZW9WRU9rVkU4?=
 =?utf-8?B?b09QdHJjb1V6V25WNVlOaE5tVWh6N3RMQWdpK2Rva3Fic0tGSnA2U01UeUM2?=
 =?utf-8?B?eUY1a290NEhCaTU4RE9pQzd6K3ZLNENRckF1YWYrdFBONzcrc2tKencrNXoz?=
 =?utf-8?B?N1ZXbzQxTU44Y1I1bktFbWU3Z2RNbml5eDdOUGJCYWVSZTkzYk5nekd4RFRP?=
 =?utf-8?B?Ym85SFhKdVJNaE01a0EzSndJblh2ZldxNDBtWUJSNy92V3Jvay9VeXh3Tmdy?=
 =?utf-8?B?dC9QekVnVGxmeUlhSlJCTHAyTEFscTB6WXJtaXBGZjdBb29KeFg1MkNLMTRw?=
 =?utf-8?B?dkdhL0lQdWV3azc0RW40SGh0WU41S2N4ZUhqaE9kWTB5S2hXd2dqUmxlV3NI?=
 =?utf-8?B?U1o3b3BTM0VEQ21oUDJtYU9KTzV5RE50MXJBOHdTcnY5U2ZiNkxGeVg2eUky?=
 =?utf-8?B?UVkvSzJ2Umk2djlUbGl1UDhVZ0ViMDVkZDAzMnZ5RDFqQkRaSGdOWTlYK2dr?=
 =?utf-8?B?ZVo3QU1MZWdITlAwc1ZvUVdwUzdRQnR6YUZBMHNrc1R3Y0VVNGp1akdwUTc3?=
 =?utf-8?B?bkRnbi84cVBmbmZIQm92L25NNGMwbXdhWmlUOWtwOHBUd0NIcmZNd2pHTjda?=
 =?utf-8?B?VXdCcXFCRTl6WmNSZzREc0dZSmNEOCtTTlIxZkdqWFF2SzI5UFVmT0N6Y24w?=
 =?utf-8?B?VWNOai9MWFdjVXRkU0hmNy9mTzlCUEFsR0RLT09adFJnZkJRTHowL0c2ZHBN?=
 =?utf-8?B?OXhUbXV5Rng2WU84NkRHOHZyVXdRVkRLMTJSQU4zSHV5WTZkMXBpczFpQVRM?=
 =?utf-8?B?Rm95enFmL3B5NVBqYjlrSVpMUEZQRzFjMHVlZndjY0pqamVtNENUc0tFSE00?=
 =?utf-8?B?UVAxN3NjZWt5VlZkazdSNlZRU0dyZmZnTjRxS1RlK3NBSmt6V2FUWHZBU3A5?=
 =?utf-8?B?QUU1WXg3NnlSTEs4S2hMcXJBYmJ6bll0SjNsY0l1cnQ2V1RmL0FFcWk1YjZ3?=
 =?utf-8?B?Smxzd2htbGpORHlYVVdQM1N2empJQ0JZVmV5K2FSdmZQa3pzTXFEUGpHNnRZ?=
 =?utf-8?B?M29JTUdqeCtlay9za3hKZmIwWUh4YmVvZzBwY3Y5VzlzMFRBQjl2LzBQNFM2?=
 =?utf-8?B?M29lTjBmT0k5ZnpZTlNtbXZRTjZza1AyWVRGOThRVHAyQm9RLzdON3VGV1cz?=
 =?utf-8?B?VTBQU3JoZ0trQ05rYS9BOTh5TUNCMlg3Vkw4OExLbHp4RmhUQndYLzVJUmZq?=
 =?utf-8?B?OUo1K2pRZ1RyMGZDVmlaTi91a1Zya1prRGdac1ZvVElKS01pNWFScjAyTmg1?=
 =?utf-8?B?Y1hVNFRwa1Z6UVVmdGc3amNLR0lScGU2U3h0N2k0VG1wRmRNbFV6cDF0RUxH?=
 =?utf-8?B?SmpTT1EyTlNDU2xiV2xHaEF4eHNYNkN4ZzM4YVhkRUVVdzZKMGloZnlxeHcx?=
 =?utf-8?B?Y0VYaVJnam1SRVRaUURaUmNldUc0cEhtUDJZMlhEQzNjZUVFd2lGSEw0RklG?=
 =?utf-8?B?VG9wK05QMUVDeDF1QThsNFFUa25LanJVYS9vQnQreGgweUM5WWVDb1h3Q0Rs?=
 =?utf-8?B?dU1lVzJkbzA3U1U2Smo3Nmo3TURYalAxcTB0dDVhTlRENlg1WG9XTnpuUUsv?=
 =?utf-8?B?Nno3TzloTUQ4ZmRyR2VMQ2xUZzVQeUhJeDdHeUlhSEJkTjh4M0JlYndoUGJz?=
 =?utf-8?B?S0J1VEJOTDhrZWV4dHZIWjVVR1BmM1pSVm1TZFljRUc3aGw5KzA4UEdNaUNu?=
 =?utf-8?B?SFJxR2ZWWXVQd2FheEI5SDRFV3RGVlBVaU9ZajVldWZFa2pxVEFETDlRSWx1?=
 =?utf-8?B?VUttTlNlZEZMRXd6SXh3cy9aN2VkMjlxZ25YMGwvMFZpWVpaNVAxSGp4cE9E?=
 =?utf-8?B?OGkyT0RlOHlabEdXYUNzYW4vQ3E1UHZscGlnR3g2clZjTVhFa295N1YveXVL?=
 =?utf-8?B?RGpzSVoyWmc5VTEvUk4xVlpYd2JFTHIzVXJoQVZRcy8yZEVRbEU0R0tjUFJZ?=
 =?utf-8?B?UUYvNW5LT2g0eDNFVHZibmttekNlelVwdHJmZGVEaGI2NUg3Yll1RExWL3d6?=
 =?utf-8?Q?iZag2rxds4xn9kfKFFalI9IDuxWHSyXXP8EgLMBojL3T?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D8D871C7F6B204B8EB3DB6AE90D912A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 773d50af-9e95-4e98-c401-08dbffd165e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2023 13:58:22.5503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: drJDwr0UulVq23HNx9Q+Z1qOWfeVUE8GiG8VXnKEfi8YkMANoKJp9bXwsT8EmNCwV1pqEsUPCd5Em9C7/l4MXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8954

T24gTW9uLCAyMDIzLTEyLTE4IGF0IDEzOjA2ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gTW9uLCBEZWMgMTgsIDIwMjMgYXQgMTE6NTLigK9BTSBEcmFnb3MgVGF0dWxl
YSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAyMDIzLTEy
LTE4IGF0IDExOjE2ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3cm90ZToNCj4gPiA+IE9u
IFNhdCwgRGVjIDE2LCAyMDIzIGF0IDEyOjAz4oCvUE0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gT24gRnJpLCAyMDIzLTEyLTE1
IGF0IDE4OjU2ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3cm90ZToNCj4gPiA+ID4gPiBP
biBGcmksIERlYyAxNSwgMjAyMyBhdCAzOjEz4oCvUE0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPbiBGcmksIDIw
MjMtMTItMTUgYXQgMTI6MzUgKzAwMDAsIERyYWdvcyBUYXR1bGVhIHdyb3RlOg0KPiA+ID4gPiA+
ID4gPiBPbiBUaHUsIDIwMjMtMTItMTQgYXQgMTk6MzAgKzAxMDAsIEV1Z2VuaW8gUGVyZXogTWFy
dGluIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+IE9uIFRodSwgRGVjIDE0LCAyMDIzIGF0IDQ6NTHi
gK9QTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPiA+
ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+IE9uIFRodSwgMjAyMy0xMi0xNCBhdCAwODo0
NSAtMDUwMCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiBP
biBUaHUsIERlYyAxNCwgMjAyMyBhdCAwMTozOTo1NVBNICswMDAwLCBEcmFnb3MgVGF0dWxlYSB3
cm90ZToNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiBPbiBUdWUsIDIwMjMtMTItMTIgYXQgMTU6NDQg
LTA4MDAsIFNpLVdlaSBMaXUgd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+ID4gPiA+ID4gPiA+IE9uIDEyLzEyLzIwMjMgMTE6MjEgQU0sIEV1Z2VuaW8gUGVyZXog
TWFydGluIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBPbiBUdWUsIERlYyA1LCAy
MDIzIGF0IDExOjQ24oCvQU0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+IHdy
b3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IEFkZHJlc3NlcyBnZXQgc2V0IGJ5IC5z
ZXRfdnFfYWRkcmVzcy4gaHcgdnEgYWRkcmVzc2VzIHdpbGwgYmUgdXBkYXRlZCBvbg0KPiA+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gPiA+IG5leHQgbW9kaWZ5X3ZpcnRxdWV1ZS4NCj4gPiA+ID4gPiA+
ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4NCj4gPiA+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gPiBSZXZpZXdlZC1ieTogR2FsIFByZXNzbWFuIDxnYWxAbnZpZGlhLmNvbT4N
Cj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBBY2tlZC1ieTogRXVnZW5pbyBQw6lyZXogPGVw
ZXJlem1hQHJlZGhhdC5jb20+DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IEknbSBraW5kIG9m
IG9rIHdpdGggdGhpcyBwYXRjaCBhbmQgdGhlIG5leHQgb25lIGFib3V0IHN0YXRlLCBidXQgSQ0K
PiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBkaWRuJ3QgYWNrIHRoZW0gaW4gdGhlIHByZXZpb3Vz
IHNlcmllcy4NCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+
ID4gPiA+IE15IG1haW4gY29uY2VybiBpcyB0aGF0IGl0IGlzIG5vdCB2YWxpZCB0byBjaGFuZ2Ug
dGhlIHZxIGFkZHJlc3MgYWZ0ZXINCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gRFJJVkVSX09L
IGluIFZpcnRJTywgd2hpY2ggdkRQQSBmb2xsb3dzLiBPbmx5IG1lbW9yeSBtYXBzIGFyZSBvayB0
bw0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBjaGFuZ2UgYXQgdGhpcyBtb21lbnQuIEknbSBu
b3Qgc3VyZSBhYm91dCB2cSBzdGF0ZSBpbiB2RFBBLCBidXQgdmhvc3QNCj4gPiA+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gZm9yYmlkcyBjaGFuZ2luZyBpdCB3aXRoIGFuIGFjdGl2ZSBiYWNrZW5kLg0K
PiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gU3Vz
cGVuZCBpcyBub3QgZGVmaW5lZCBpbiBWaXJ0SU8gYXQgdGhpcyBtb21lbnQgdGhvdWdoLCBzbyBt
YXliZSBpdCBpcw0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBvayB0byBkZWNpZGUgdGhhdCBh
bGwgb2YgdGhlc2UgcGFyYW1ldGVycyBtYXkgY2hhbmdlIGR1cmluZyBzdXNwZW5kLg0KPiA+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gPiBNYXliZSB0aGUgYmVzdCB0aGluZyBpcyB0byBwcm90ZWN0IHRo
aXMgd2l0aCBhIHZEUEEgZmVhdHVyZSBmbGFnLg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gSSB0
aGluayBwcm90ZWN0IHdpdGggdkRQQSBmZWF0dXJlIGZsYWcgY291bGQgd29yaywgd2hpbGUgb24g
dGhlIG90aGVyDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBoYW5kIHZEUEEgbWVhbnMgdmVuZG9y
IHNwZWNpZmljIG9wdGltaXphdGlvbiBpcyBwb3NzaWJsZSBhcm91bmQgc3VzcGVuZA0KPiA+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gYW5kIHJlc3VtZSAoaW4gY2FzZSBpdCBoZWxwcyBwZXJmb3JtYW5j
ZSksIHdoaWNoIGRvZXNuJ3QgaGF2ZSB0byBiZQ0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gYmFj
a2VkIGJ5IHZpcnRpbyBzcGVjLiBTYW1lIGFwcGxpZXMgdG8gdmhvc3QgdXNlciBiYWNrZW5kIGZl
YXR1cmVzLA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gdmFyaWF0aW9ucyB0aGVyZSB3ZXJlIG5v
dCBiYWNrZWQgYnkgc3BlYyBlaXRoZXIuIE9mIGNvdXJzZSwgd2Ugc2hvdWxkDQo+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gPiB0cnkgYmVzdCB0byBtYWtlIHRoZSBkZWZhdWx0IGJlaGF2aW9yIGJhY2t3
YXJkIGNvbXBhdGlibGUgd2l0aA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gdmlydGlvLWJhc2Vk
IGJhY2tlbmQsIGJ1dCB0aGF0IGNpcmNsZXMgYmFjayB0byBubyBzdXNwZW5kIGRlZmluaXRpb24g
aW4NCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IHRoZSBjdXJyZW50IHZpcnRpbyBzcGVjLCBmb3Ig
d2hpY2ggSSBob3BlIHdlIGRvbid0IGNlYXNlIGRldmVsb3BtZW50IG9uDQo+ID4gPiA+ID4gPiA+
ID4gPiA+ID4gPiB2RFBBIGluZGVmaW5pdGVseS4gQWZ0ZXIgYWxsLCB0aGUgdmlydGlvIGJhc2Vk
IHZkYXAgYmFja2VuZCBjYW4gd2VsbA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gZGVmaW5lIGl0
cyBvd24gZmVhdHVyZSBmbGFnIHRvIGRlc2NyaWJlIChtaW5vciBkaWZmZXJlbmNlIGluKSB0aGUN
Cj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IHN1c3BlbmQgYmVoYXZpb3IgYmFzZWQgb24gdGhlIGxh
dGVyIHNwZWMgb25jZSBpdCBpcyBmb3JtZWQgaW4gZnV0dXJlLg0KPiA+ID4gPiA+ID4gPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gU28gd2hhdCBpcyB0aGUgd2F5IGZvcndhcmQg
aGVyZT8gRnJvbSB3aGF0IEkgdW5kZXJzdGFuZCB0aGUgb3B0aW9ucyBhcmU6DQo+ID4gPiA+ID4g
PiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gMSkgQWRkIGEgdmRwYSBmZWF0dXJl
IGZsYWcgZm9yIGNoYW5naW5nIGRldmljZSBwcm9wZXJ0aWVzIHdoaWxlIHN1c3BlbmRlZC4NCj4g
PiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiAyKSBEcm9wIHRoZXNl
IDIgcGF0Y2hlcyBmcm9tIHRoZSBzZXJpZXMgZm9yIG5vdy4gTm90IHN1cmUgaWYgdGhpcyBtYWtl
cyBzZW5zZSBhcw0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+IHRoaXMuIEJ1dCB0aGVuIFNpLVdlaSdz
IHFlbXUgZGV2aWNlIHN1c3BlbmQvcmVzdW1lIHBvYyBbMF0gdGhhdCBleGVyY2lzZXMgdGhpcw0K
PiA+ID4gPiA+ID4gPiA+ID4gPiA+IGNvZGUgd29uJ3Qgd29yayBhbnltb3JlLiBUaGlzIG1lYW5z
IHRoZSBzZXJpZXMgd291bGQgYmUgbGVzcyB3ZWxsIHRlc3RlZC4NCj4gPiA+ID4gPiA+ID4gPiA+
ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiBBcmUgdGhlcmUgb3RoZXIgcG9zc2libGUgb3B0
aW9ucz8gV2hhdCBkbyB5b3UgdGhpbms/DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiA+ID4gPiA+ID4gWzBdIGh0dHBzOi8vZ2l0aHViLmNvbS9zaXdsaXUta2VybmVsL3FlbXUv
dHJlZS9zdnEtcmVzdW1lLXdpcA0KPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4g
PiA+ID4gSSBhbSBmaW5lIHdpdGggZWl0aGVyIG9mIHRoZXNlLg0KPiA+ID4gPiA+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+ID4gPiA+IEhvdyBhYm91dCBhbGxvd2luZyB0aGUgY2hhbmdlIG9ubHkg
dW5kZXIgdGhlIGZvbGxvd2luZyBjb25kaXRpb25zOg0KPiA+ID4gPiA+ID4gPiA+ID4gICB2aG9z
dF92ZHBhX2Nhbl9zdXNwZW5kICYmIHZob3N0X3ZkcGFfY2FuX3Jlc3VtZSAmJg0KPiA+ID4gPiA+
ID4gPiA+ID4gVkhPU1RfQkFDS0VORF9GX0VOQUJMRV9BRlRFUl9EUklWRVJfT0sgaXMgc2V0DQo+
ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+ID8NCj4gPiA+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+ID4gPiBJIHRoaW5rIHRoZSBiZXN0IG9wdGlvbiBieSBmYXIgaXMgMSwgYXMg
dGhlcmUgaXMgbm8gaGludCBpbiB0aGUNCj4gPiA+ID4gPiA+ID4gPiBjb21iaW5hdGlvbiBvZiB0
aGVzZSAzIGluZGljYXRpbmcgdGhhdCB5b3UgY2FuIGNoYW5nZSBkZXZpY2UNCj4gPiA+ID4gPiA+
ID4gPiBwcm9wZXJ0aWVzIGluIHRoZSBzdXNwZW5kZWQgc3RhdGUuDQo+ID4gPiA+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiA+IFN1cmUuIFdpbGwgcmVzcGluIGEgdjMgd2l0aG91dCB0aGVzZSB0d28g
cGF0Y2hlcy4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IEFub3RoZXIgc2VyaWVzIGNh
biBpbXBsZW1lbnQgb3B0aW9uIDIgYW5kIGFkZCB0aGVzZSAyIHBhdGNoZXMgb24gdG9wLg0KPiA+
ID4gPiA+ID4gSG1tLi4uSSBtaXN1bmRlcnN0b29kIHlvdXIgc3RhdGVtZW50IGFuZCBzZW50IGEg
ZXJyb25ldXMgdjMuIFlvdSBzYWlkIHRoYXQNCj4gPiA+ID4gPiA+IGhhdmluZyBhIGZlYXR1cmUg
ZmxhZyBpcyB0aGUgYmVzdCBvcHRpb24uDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFdpbGwg
YWRkIGEgZmVhdHVyZSBmbGFnIGluIHY0OiBpcyB0aGlzIHNpbWlsYXIgdG8gdGhlDQo+ID4gPiA+
ID4gPiBWSE9TVF9CQUNLRU5EX0ZfRU5BQkxFX0FGVEVSX0RSSVZFUl9PSyBmbGFnPw0KPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gUmlnaHQsIGl0IHNob3VsZCBiZSBlYXN5IHRv
IHJldHVybiBpdCBmcm9tIC5nZXRfYmFja2VuZF9mZWF0dXJlcyBvcCBpZg0KPiA+ID4gPiA+IHRo
ZSBGVyByZXR1cm5zIHRoYXQgY2FwYWJpbGl0eSwgaXNuJ3QgaXQ/DQo+ID4gPiA+ID4gDQo+ID4g
PiA+IFllcywgdGhhdCdzIGVhc3kuIEJ1dCBJIHdvbmRlciBpZiB3ZSBuZWVkIG9uZSBmZWF0dXJl
IGJpdCBmb3IgZWFjaCB0eXBlIG9mDQo+ID4gPiA+IGNoYW5nZToNCj4gPiA+ID4gLSBWSE9TVF9C
QUNLRU5EX0ZfQ0hBTkdFQUJMRV9WUV9BRERSX0lOX1NVU1BFTkQNCj4gPiA+ID4gLSBWSE9TVF9C
QUNLRU5EX0ZfQ0hBTkdFQUJMRV9WUV9TVEFURV9JTl9TVVNQRU5EDQo+ID4gPiA+IA0KPiA+ID4g
DQo+ID4gPiBJJ2Qgc2F5IHllcy4gQWx0aG91Z2ggd2UgY291bGQgY29uZmlndXJlIFNWUSBpbml0
aWFsIHN0YXRlIGluIHVzZXJsYW5kDQo+ID4gPiBhcyBkaWZmZXJlbnQgdGhhbiAwIGZvciB0aGlz
IGZpcnN0IHN0ZXAsIGl0IHdvdWxkIGJlIG5lZWRlZCBpbiB0aGUNCj4gPiA+IGxvbmcgdGVybS4N
Cj4gPiA+IA0KPiA+ID4gPiBPciB3b3VsZCBhIGJpZyBvbmUgVkhPU1RfQkFDS0VORF9GX0NBTl9S
RUNPTkZJR19WUV9JTl9TVVNQRU5EIHN1ZmZpY2U/DQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gPiBJ
J2Qgc2F5ICJyZWNvbmZpZyB2cSIgaXMgbm90IHZhbGlkIGFzIG1seCBkcml2ZXIgZG9lc24ndCBh
bGxvdw0KPiA+ID4gY2hhbmdpbmcgcXVldWUgc2l6ZXMsIGZvciBleGFtcGxlLCBpc24ndCBpdD8N
Cj4gPiA+IA0KPiA+IE1vZGlmeWluZyB0aGUgcXVldWUgc2l6ZSBmb3IgYSB2cSBpcyBpbmRlZWQg
bm90IHN1cHBvcnRlZCBieSB0aGUgbWx4IGRldmljZS4NCj4gPiANCj4gPiA+IFRvIGRlZmluZSB0
aGF0IGl0IGlzDQo+ID4gPiB2YWxpZCB0byBjaGFuZ2UgImFsbCBwYXJhbWV0ZXJzIiBzZWVtcyB2
ZXJ5IGNvbmZpZGVudC4NCj4gPiA+IA0KPiA+IEFjaw0KPiA+IA0KPiA+ID4gPiBUbyBtZSBoYXZp
bmcgaW5kaXZpZHVhbCBmZWF0dXJlIGJpdHMgbWFrZXMgc2Vuc2UuIEJ1dCBpdCBjb3VsZCBhbHNv
IHRha2VzIHRvbw0KPiA+ID4gPiBtYW55IGJpdHMgaWYgbW9yZSBjaGFuZ2VzIGFyZSByZXF1aXJl
ZC4NCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IFllcywgdGhhdCdzIGEgZ29vZCBwb2ludC4gTWF5
YmUgaXQgaXMgdmFsaWQgdG8gZGVmaW5lIGEgc3Vic2V0IG9mDQo+ID4gPiBmZWF0dXJlcyB0aGF0
IGNhbiBiZSBjaGFuZ2VkLiwgYnV0IEkgdGhpbmsgaXQgaXMgd2F5IGNsZWFyZXIgdG8ganVzdA0K
PiA+ID4gY2hlY2sgZm9yIGluZGl2aWR1YWwgZmVhdHVyZSBiaXRzLg0KPiA+ID4gDQo+ID4gSSB3
aWxsIHByZXBhcmUgZXh0cmEgcGF0Y2hlcyB3aXRoIHRoZSAyIGZlYXR1cmUgYml0cyBhcHByb2Fj
aC4NCj4gPiANCj4gPiBJcyBpdCBuZWNlc3NhcnkgdG8gYWRkIGNoZWNrcyBpbiB0aGUgdmRwYSBj
b3JlIHRoYXQgYmxvY2sgY2hhbmdpbmcgdGhlc2UNCj4gPiBwcm9wZXJ0aWVzIGlmIHRoZSBzdGF0
ZSBpcyBkcml2ZXIgb2sgYW5kIHRoZSBkZXZpY2UgZG9lc24ndCBzdXBwb3J0IHRoZSBmZWF0dXJl
Pw0KPiA+IA0KPiANCj4gWWVzLCBJIHRoaW5rIGl0IGlzIGJldHRlciB0byBwcm90ZWN0IGZvciBj
aGFuZ2VzIGluIHZkcGEgY29yZS4NCj4gDQpIbW1tLi4uIHRoZXJlIGlzIG5vIHN1c3BlbmRlZCBz
dGF0ZSBhdmFpbGFibGUuIEkgd291bGQgb25seSBhZGQgY2hlY2tzIGZvciB0aGUNCkRSSVZFUl9P
SyBzdGF0ZSBvZiB0aGUgZGV2aWNlIGJlY2F1c2UgYWRkaW5nIGEgaXNfc3VzcGVuZGVkIHN0YXRl
L29wIHNlZW1zIG91dA0Kb2Ygc2NvcGUgZm9yIHRoaXMgc2VyaWVzLiBBbnkgdGhvdWdodHM/DQoN
Cg==

