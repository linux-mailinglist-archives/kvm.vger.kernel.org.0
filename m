Return-Path: <kvm+bounces-4561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC7781482C
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 13:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD1DCB22689
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 12:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BC92C68D;
	Fri, 15 Dec 2023 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VJHQxraP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11538199D7;
	Fri, 15 Dec 2023 12:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw5TA6nI0wE8CtYSC9I/VLJIaLmLSysN4LjpVdPm74RJXj0cefwvUWK61nHB+Zd5IOAaTnxQiKKrZz3pyRhZ+0tXMnJ3ZtVHCD+Iwg1IoX8ibP1RS5xDtL4N+fhX/J1TR4wP26gwOqWthfn7JMnvKQzA1P434zc7jODRUVKJE9GYu5anoVDgnwakyFrsinN0N6NuO9YY+IDtmLJYECb0NcGl7UDGrMavjj5Fn1Rd8C3Ut/d6rcwin4piYHBAM/8OODS5OR33h3v+zxKfqIsnE8zeaL1liQWZ3j7Pch01odM5FS8TI2jVI3iMFKusybxN9TWIaJ3eKERCnOlQdOWcrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsl1qwIJfhoOQDoDFM7YmF9goLPZ7+hJcUndjXp5rbA=;
 b=JXtXIG3NGkJkXQF/pNisd9oDKu+Xko98fJzJpcgHvZQgBieeyRcodJZBDVNUe3gVJ5rkVZRuxalv3XAkuw6TgKSISR4Kz0PPcr9GmWGyBkliys6X1IMmCVDgrsZPoAry0hcW/iRdY1PL8U51wk/gNHpJzjIsW20OAIRCUR1IxreEqb7y7hsd2akDjKMRbF3KqfBycjQA07pgjFqOVOxv9hoCLA8V2iLyQYz4rAUIj5XL3p/am0mm2h9/d1ahNPJJK+5ZgtU75w1RknAoLsKrM4Bl0aWQEk5tTYjoHTCKS1YvLtpKqDgdt0tL+ef4AcSNDTXhCQVfTXk3BGe8swMbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsl1qwIJfhoOQDoDFM7YmF9goLPZ7+hJcUndjXp5rbA=;
 b=VJHQxraPWb12jOo4g0BARKltly3evhKGljmEC/pJFxZNjxu2inaobQruZRUXd13O5jbL9J69uahuBvmwMzOTGKB0D8leOyAtaqj84YqNkRqnc3qeq+mTqspa6us1lC0fV0R2cW8xi5o4ZeFSMzFbeNcOwbTz3mHwEGHB3QfXl5JxwK7BmyGVk7ELJ6QvP4FzhCzt/NmiNRxpRXATNNRV1vt814P3F/eqB5LFAmxBkLFB+blrvfo37nIziAi85x2ABwrWrX9Hzw1B0MmYZln9l51nE3ma/U/LePWBpBDVHISXru1a46KZu+3lN960UkWA3NVXnszaiJ3ljwnCWOU/sQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH7PR12MB9254.namprd12.prod.outlook.com (2603:10b6:510:308::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 12:35:12 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 12:35:12 +0000
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
 AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgABJawCAAnvhAIAAAZuAgAAjJQCAACyCAIABLv6A
Date: Fri, 15 Dec 2023 12:35:11 +0000
Message-ID: <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
	 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
	 <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
	 <20231214084526-mutt-send-email-mst@kernel.org>
	 <9a6465a3d6c8fde63643fbbdde60d5dd84b921d4.camel@nvidia.com>
	 <CAJaqyWfF9eVehQ+wutMDdwYToMq=G1+War_7wANmnyuONj=18g@mail.gmail.com>
In-Reply-To:
 <CAJaqyWfF9eVehQ+wutMDdwYToMq=G1+War_7wANmnyuONj=18g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH7PR12MB9254:EE_
x-ms-office365-filtering-correlation-id: fff01094-c7e5-4b1e-6054-08dbfd6a47f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KUO9nUImzyU4cIt6/rCj/ssimPTngCyIPzZ603mHrTb90rwL4oG/EP6/6pmZJOEOyW0iKjHphka9j1NgSGmngl67nw8KCMz12ju+aywFNefypKIlnupuOhhn3Za852CzhvE9fjgQyxDK3azJ+JhjvXMVTj6Nnu3dkj7lomlCNRFU45Z93Bk0NXU8H+JRgOrE8tHzXedv/S1WvLSzelaSFrLpSo7wLxi7TidefZGeRri55ykQL2M8UM2W0HxuLnlcrRAippDrlW8bzIxhcfZGiVj6eV2Wa6UUWakiW9Xj9h4NCWDzLPWFEtfDGzUfkikqODo4W8/t1Fw2qR7TX35y3Vk6ChfeFC2NTz46Ram5ot6HZUWTQn39Jjrhddy7pFdA+lgK+DGsLSEIEWtb5Iu36v+I90PVRghZWfzJINyRbttf6VezrVxf+o4MGyN9B/ZN6zpbBtgOAW177aVYmwhOlGuJ6gO9c2yypYj0FHdbuiHgASTLICO5h66fR+ARdWQOQJ8KXWW9Uk/qavLCLAyrt32/qKvQUzT2vbJUP7iRn0VI2Mb/T3A8Bb/4xc8TjILBhKeasv08FpVgXcFSBdnqEb6HTNIGGR8iHPfz7UV7gNmuN/W6c51QvlIdpjJsvqok55mAarIqJzfs4c0ZKWtLnkxJBeXl30v/X+hEQ33WBko=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(376002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(8936002)(64756008)(66556008)(91956017)(6916009)(66476007)(4326008)(76116006)(66446008)(66946007)(54906003)(66574015)(83380400001)(8676002)(316002)(966005)(6506007)(6486002)(71200400001)(53546011)(478600001)(6512007)(2616005)(5660300002)(4001150100001)(2906002)(41300700001)(36756003)(38070700009)(122000001)(38100700002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODFmdUJFTGxNSVVaQVFaY3hRZW90RUUvZ1JWY2RXVVRnVVhmaWVzRjJvZE1I?=
 =?utf-8?B?dFV5N0dyL09nNXBjbEZrMUYxdkUvVzlJZ044QzZ2TGVhM3UvTzJCY01hVUVW?=
 =?utf-8?B?Wlo3RVBYRTJXbTltT3dMSmU4bVkrNG1wTG4rSmlXeTVOSDBuenZjSjhTYyti?=
 =?utf-8?B?VXR2NTVpYmdtaFZNMEdEWkkybnNBUlF6TzhBQWFSQ2w2VmgxWmtycmFjODVH?=
 =?utf-8?B?cGkxRTNTZTV4dkZHTTc1T2JzWXhybFZwbEV2NlNNVytkMHh5SmgyZVhxalhT?=
 =?utf-8?B?TStJejBCTkhQenVQZDEwTjZsM0xLV1RDY0I1cDZKa3VWeDZMWDhVeUFveWx0?=
 =?utf-8?B?TGNuSnVjSzJOdGZLWGh4eFZTYzRXRWhVYkxlRTZxZGpvL3hnRFI0T29yL0Q4?=
 =?utf-8?B?Rnc3RFZOS3l1TDVnTzVTZ0UvRVlkZ3REQ016eDFmWVo4MlRZazVBWis2WlZO?=
 =?utf-8?B?WWxDMWJCb3NER3hjRWxLdUJhOFB5UEFUVWhyVEp3L0sxVHZPYTErOFJuRk42?=
 =?utf-8?B?MWdGbXZ1ZWRyS09hRndDamE5QmVtaklsS0w0OGp5c0dNTFExT2lUSVR4VXEy?=
 =?utf-8?B?VGZwT0pFL3RDQjZzNXRNd2xQR1NrUEsxYjYyRnVIaVNqSU1JVDBIMFJjM2Fu?=
 =?utf-8?B?Rkdqenppa1V2cjdXVnZmK0grbGFob2tYNjFnQ3dLYmlWSlg5em14ckt4ZEhy?=
 =?utf-8?B?ai9kbUpuUlJ2cmZzTDN0ME5QS2dSZTZ5SHZuaVRDWGRSdFNNMTM0VVhqU1Nx?=
 =?utf-8?B?emR1LzdPS0VzTGlPOVJLMjRzNU9WcnI2Z3FEd0x5MmZiUDBMMks5TFpiQjlT?=
 =?utf-8?B?N0Z2RlNRdVdZRkczNllOWU1jZldJR2o1MjdjaFgzSVpsVEF6QVB4azdQeWly?=
 =?utf-8?B?SFlOT0RhOXhzUXdtN0ZRVjNRUmViVytrTFJLQTI4RHBlWmZNYVpWMW9Cczhv?=
 =?utf-8?B?NDA1UkxrRjJOcXE1a2ZIaE1hS01xdnFSQVVKOUlueXpPTnoxQmMxYkJZZUtw?=
 =?utf-8?B?NmRFZ251NmNNK3l1OUU1Q1RqZmN3a0I0M1hTMTZWU0dXbmp3NlhLTHVVeGF1?=
 =?utf-8?B?bys0OVFRRkcxZFVVSXJ0YkRQYzZYOXF5b09nV2VLc2tlY3hla25rOFdYalE3?=
 =?utf-8?B?eEJjRk9aZFdpRjdGUzFiQmE5dlkvWEh3TXVyQXRJWlpOaEsxL3pwWU9Md050?=
 =?utf-8?B?cWVmY0xHM094cnRaZFFCZ0x0Uk5lUWZxV3FTbzlvQnIyVTNWNU91K3c4Q3dE?=
 =?utf-8?B?RUYzL2hPbGwzM1NueGRqQ3YraTh0MTAydkhueFQvQnV4aXdXckkyWXU0aHQ3?=
 =?utf-8?B?bUtML0Q5VWlhSWwvc3JScXEvVXFPQ1B0ZG1xUS9IY1phOGNpVUUyeDBmeCs3?=
 =?utf-8?B?THNMUkE2ZTZMQXZZWEdoRGF5eGl0eFR0WGRjWW53azNoR3djZk94WWwybVM4?=
 =?utf-8?B?VGF6alorNXJGT1E0akgyVWp1QlBWOGpHVEg2cFlrYzVnb1BrSjk5VnQvNnVl?=
 =?utf-8?B?SllyakkzUmFHT0dFUEdlbHhSK2xaUEFhUlNhQmFtOVF0VWlpN0tabURMUVRC?=
 =?utf-8?B?T25vRGNXRXR4M1IwTFhiS0RJMDFuOUdpc3gvRTV5d05LMW56cXF2c08vS25O?=
 =?utf-8?B?QUxSNnVWbUYzSUg3NTVkb2h6RndwWFZJNEFuclNpODVKZmM0c0hvNVRJQklD?=
 =?utf-8?B?WW9EYlo2NkhsMXlNTjc2UU9GcmRnWk1udUp2cXhTY1NuTUEwTFZhSXd1bk9k?=
 =?utf-8?B?QSswUE5Hc3FuU2pVSVlaWlhJUUsxQUlMdzFUTEovWGFsSER6OGpnOXR0RE01?=
 =?utf-8?B?cDBEWkJCZCtGOE8zcUxGNUZWZXdHZDNqcnh6UHR2WmdFVUhPdjZpRWgxdlV1?=
 =?utf-8?B?TjNJeDZ1S1g4ZWN2SXdCalJtZGVRTHF0MUhQczI1b3FZTS9YOTQ2eDRqTE1s?=
 =?utf-8?B?TitxYmh4QUg0Z0UyTTZvTGI5cS9rQWR6WXc1Um9KTWtvVkh0YmpoODNIMUtV?=
 =?utf-8?B?UVZ2ZUE4Zm5MRDBBSWhBNjBGMENSeEVVWk5hSWRCLzFCNU82clFzTExOVUhZ?=
 =?utf-8?B?NWEyZzQvUldlWExoZW9KWjBNY2Y2Mk5hb0VnOWVqVDk2U1hpclFydmVyLzlF?=
 =?utf-8?B?S1p4c0pOTTEwQ1VBMTJ1UGI2ZFlnY3kvVkt4YTRjMmdkWlFvek9iTjRkUHFa?=
 =?utf-8?Q?02YVDX1BF4pbi2h4/PHmCHQwe/W5ZpEzMhx8DwuWstmG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B22689210505FD4289E6971341B50298@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fff01094-c7e5-4b1e-6054-08dbfd6a47f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 12:35:11.8123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mFFVxOsiOJkYv/fLTo6EeiCD5fDgxf5w4ChNMHc1Erchnz5cfgqqB5pXEoLvzMSXdae0ljzRPe1BNd0qNcjTmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9254

T24gVGh1LCAyMDIzLTEyLTE0IGF0IDE5OjMwICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gVGh1LCBEZWMgMTQsIDIwMjMgYXQgNDo1MeKAr1BNIERyYWdvcyBUYXR1bGVh
IDxkdGF0dWxlYUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUaHUsIDIwMjMtMTIt
MTQgYXQgMDg6NDUgLTA1MDAsIE1pY2hhZWwgUy4gVHNpcmtpbiB3cm90ZToNCj4gPiA+IE9uIFRo
dSwgRGVjIDE0LCAyMDIzIGF0IDAxOjM5OjU1UE0gKzAwMDAsIERyYWdvcyBUYXR1bGVhIHdyb3Rl
Og0KPiA+ID4gPiBPbiBUdWUsIDIwMjMtMTItMTIgYXQgMTU6NDQgLTA4MDAsIFNpLVdlaSBMaXUg
d3JvdGU6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gT24gMTIvMTIvMjAyMyAxMToyMSBBTSwgRXVn
ZW5pbyBQZXJleiBNYXJ0aW4gd3JvdGU6DQo+ID4gPiA+ID4gPiBPbiBUdWUsIERlYyA1LCAyMDIz
IGF0IDExOjQ24oCvQU0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+IHdyb3Rl
Og0KPiA+ID4gPiA+ID4gPiBBZGRyZXNzZXMgZ2V0IHNldCBieSAuc2V0X3ZxX2FkZHJlc3MuIGh3
IHZxIGFkZHJlc3NlcyB3aWxsIGJlIHVwZGF0ZWQgb24NCj4gPiA+ID4gPiA+ID4gbmV4dCBtb2Rp
ZnlfdmlydHF1ZXVlLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1i
eTogRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+DQo+ID4gPiA+ID4gPiA+IFJl
dmlld2VkLWJ5OiBHYWwgUHJlc3NtYW4gPGdhbEBudmlkaWEuY29tPg0KPiA+ID4gPiA+ID4gPiBB
Y2tlZC1ieTogRXVnZW5pbyBQw6lyZXogPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+ID4gPiA+ID4g
PiBJJ20ga2luZCBvZiBvayB3aXRoIHRoaXMgcGF0Y2ggYW5kIHRoZSBuZXh0IG9uZSBhYm91dCBz
dGF0ZSwgYnV0IEkNCj4gPiA+ID4gPiA+IGRpZG4ndCBhY2sgdGhlbSBpbiB0aGUgcHJldmlvdXMg
c2VyaWVzLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBNeSBtYWluIGNvbmNlcm4gaXMgdGhh
dCBpdCBpcyBub3QgdmFsaWQgdG8gY2hhbmdlIHRoZSB2cSBhZGRyZXNzIGFmdGVyDQo+ID4gPiA+
ID4gPiBEUklWRVJfT0sgaW4gVmlydElPLCB3aGljaCB2RFBBIGZvbGxvd3MuIE9ubHkgbWVtb3J5
IG1hcHMgYXJlIG9rIHRvDQo+ID4gPiA+ID4gPiBjaGFuZ2UgYXQgdGhpcyBtb21lbnQuIEknbSBu
b3Qgc3VyZSBhYm91dCB2cSBzdGF0ZSBpbiB2RFBBLCBidXQgdmhvc3QNCj4gPiA+ID4gPiA+IGZv
cmJpZHMgY2hhbmdpbmcgaXQgd2l0aCBhbiBhY3RpdmUgYmFja2VuZC4NCj4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gU3VzcGVuZCBpcyBub3QgZGVmaW5lZCBpbiBWaXJ0SU8gYXQgdGhpcyBtb21l
bnQgdGhvdWdoLCBzbyBtYXliZSBpdCBpcw0KPiA+ID4gPiA+ID4gb2sgdG8gZGVjaWRlIHRoYXQg
YWxsIG9mIHRoZXNlIHBhcmFtZXRlcnMgbWF5IGNoYW5nZSBkdXJpbmcgc3VzcGVuZC4NCj4gPiA+
ID4gPiA+IE1heWJlIHRoZSBiZXN0IHRoaW5nIGlzIHRvIHByb3RlY3QgdGhpcyB3aXRoIGEgdkRQ
QSBmZWF0dXJlIGZsYWcuDQo+ID4gPiA+ID4gSSB0aGluayBwcm90ZWN0IHdpdGggdkRQQSBmZWF0
dXJlIGZsYWcgY291bGQgd29yaywgd2hpbGUgb24gdGhlIG90aGVyDQo+ID4gPiA+ID4gaGFuZCB2
RFBBIG1lYW5zIHZlbmRvciBzcGVjaWZpYyBvcHRpbWl6YXRpb24gaXMgcG9zc2libGUgYXJvdW5k
IHN1c3BlbmQNCj4gPiA+ID4gPiBhbmQgcmVzdW1lIChpbiBjYXNlIGl0IGhlbHBzIHBlcmZvcm1h
bmNlKSwgd2hpY2ggZG9lc24ndCBoYXZlIHRvIGJlDQo+ID4gPiA+ID4gYmFja2VkIGJ5IHZpcnRp
byBzcGVjLiBTYW1lIGFwcGxpZXMgdG8gdmhvc3QgdXNlciBiYWNrZW5kIGZlYXR1cmVzLA0KPiA+
ID4gPiA+IHZhcmlhdGlvbnMgdGhlcmUgd2VyZSBub3QgYmFja2VkIGJ5IHNwZWMgZWl0aGVyLiBP
ZiBjb3Vyc2UsIHdlIHNob3VsZA0KPiA+ID4gPiA+IHRyeSBiZXN0IHRvIG1ha2UgdGhlIGRlZmF1
bHQgYmVoYXZpb3IgYmFja3dhcmQgY29tcGF0aWJsZSB3aXRoDQo+ID4gPiA+ID4gdmlydGlvLWJh
c2VkIGJhY2tlbmQsIGJ1dCB0aGF0IGNpcmNsZXMgYmFjayB0byBubyBzdXNwZW5kIGRlZmluaXRp
b24gaW4NCj4gPiA+ID4gPiB0aGUgY3VycmVudCB2aXJ0aW8gc3BlYywgZm9yIHdoaWNoIEkgaG9w
ZSB3ZSBkb24ndCBjZWFzZSBkZXZlbG9wbWVudCBvbg0KPiA+ID4gPiA+IHZEUEEgaW5kZWZpbml0
ZWx5LiBBZnRlciBhbGwsIHRoZSB2aXJ0aW8gYmFzZWQgdmRhcCBiYWNrZW5kIGNhbiB3ZWxsDQo+
ID4gPiA+ID4gZGVmaW5lIGl0cyBvd24gZmVhdHVyZSBmbGFnIHRvIGRlc2NyaWJlIChtaW5vciBk
aWZmZXJlbmNlIGluKSB0aGUNCj4gPiA+ID4gPiBzdXNwZW5kIGJlaGF2aW9yIGJhc2VkIG9uIHRo
ZSBsYXRlciBzcGVjIG9uY2UgaXQgaXMgZm9ybWVkIGluIGZ1dHVyZS4NCj4gPiA+ID4gPiANCj4g
PiA+ID4gU28gd2hhdCBpcyB0aGUgd2F5IGZvcndhcmQgaGVyZT8gRnJvbSB3aGF0IEkgdW5kZXJz
dGFuZCB0aGUgb3B0aW9ucyBhcmU6DQo+ID4gPiA+IA0KPiA+ID4gPiAxKSBBZGQgYSB2ZHBhIGZl
YXR1cmUgZmxhZyBmb3IgY2hhbmdpbmcgZGV2aWNlIHByb3BlcnRpZXMgd2hpbGUgc3VzcGVuZGVk
Lg0KPiA+ID4gPiANCj4gPiA+ID4gMikgRHJvcCB0aGVzZSAyIHBhdGNoZXMgZnJvbSB0aGUgc2Vy
aWVzIGZvciBub3cuIE5vdCBzdXJlIGlmIHRoaXMgbWFrZXMgc2Vuc2UgYXMNCj4gPiA+ID4gdGhp
cy4gQnV0IHRoZW4gU2ktV2VpJ3MgcWVtdSBkZXZpY2Ugc3VzcGVuZC9yZXN1bWUgcG9jIFswXSB0
aGF0IGV4ZXJjaXNlcyB0aGlzDQo+ID4gPiA+IGNvZGUgd29uJ3Qgd29yayBhbnltb3JlLiBUaGlz
IG1lYW5zIHRoZSBzZXJpZXMgd291bGQgYmUgbGVzcyB3ZWxsIHRlc3RlZC4NCj4gPiA+ID4gDQo+
ID4gPiA+IEFyZSB0aGVyZSBvdGhlciBwb3NzaWJsZSBvcHRpb25zPyBXaGF0IGRvIHlvdSB0aGlu
az8NCj4gPiA+ID4gDQo+ID4gPiA+IFswXSBodHRwczovL2dpdGh1Yi5jb20vc2l3bGl1LWtlcm5l
bC9xZW11L3RyZWUvc3ZxLXJlc3VtZS13aXANCj4gPiA+IA0KPiA+ID4gSSBhbSBmaW5lIHdpdGgg
ZWl0aGVyIG9mIHRoZXNlLg0KPiA+ID4gDQo+ID4gSG93IGFib3V0IGFsbG93aW5nIHRoZSBjaGFu
Z2Ugb25seSB1bmRlciB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnM6DQo+ID4gICB2aG9zdF92ZHBh
X2Nhbl9zdXNwZW5kICYmIHZob3N0X3ZkcGFfY2FuX3Jlc3VtZSAmJg0KPiA+IFZIT1NUX0JBQ0tF
TkRfRl9FTkFCTEVfQUZURVJfRFJJVkVSX09LIGlzIHNldA0KPiA+IA0KPiA+ID8NCj4gDQo+IEkg
dGhpbmsgdGhlIGJlc3Qgb3B0aW9uIGJ5IGZhciBpcyAxLCBhcyB0aGVyZSBpcyBubyBoaW50IGlu
IHRoZQ0KPiBjb21iaW5hdGlvbiBvZiB0aGVzZSAzIGluZGljYXRpbmcgdGhhdCB5b3UgY2FuIGNo
YW5nZSBkZXZpY2UNCj4gcHJvcGVydGllcyBpbiB0aGUgc3VzcGVuZGVkIHN0YXRlLg0KPiANClN1
cmUuIFdpbGwgcmVzcGluIGEgdjMgd2l0aG91dCB0aGVzZSB0d28gcGF0Y2hlcy4NCg0KQW5vdGhl
ciBzZXJpZXMgY2FuIGltcGxlbWVudCBvcHRpb24gMiBhbmQgYWRkIHRoZXNlIDIgcGF0Y2hlcyBv
biB0b3AuDQoNCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gRHJhZ29zDQo+ID4gDQo+ID4gPiA+IFRo
YW5rcywNCj4gPiA+ID4gRHJhZ29zDQo+ID4gPiA+IA0KPiA+ID4gPiA+IFJlZ2FyZHMsDQo+ID4g
PiA+ID4gLVNpd2VpDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiANCj4gPiA+ID4gPiA+IEphc29uLCB3aGF0IGRvIHlvdSB0aGluaz8NCj4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gVGhhbmtzIQ0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IC0tLQ0K
PiA+ID4gPiA+ID4gPiAgIGRyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYyAgfCA5ICsr
KysrKysrKw0KPiA+ID4gPiA+ID4gPiAgIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmY192ZHBh
LmggfCAxICsNCj4gPiA+ID4gPiA+ID4gICAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMo
KykNCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zk
cGEvbWx4NS9uZXQvbWx4NV92bmV0LmMgYi9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0
LmMNCj4gPiA+ID4gPiA+ID4gaW5kZXggZjhmMDg4Y2NlZDUwLi44MGUwNjZkZTA4NjYgMTAwNjQ0
DQo+ID4gPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYw0K
PiA+ID4gPiA+ID4gPiArKysgYi9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4g
PiA+ID4gPiA+ID4gQEAgLTEyMDksNiArMTIwOSw3IEBAIHN0YXRpYyBpbnQgbW9kaWZ5X3ZpcnRx
dWV1ZShzdHJ1Y3QgbWx4NV92ZHBhX25ldCAqbmRldiwNCj4gPiA+ID4gPiA+ID4gICAgICAgICAg
Ym9vbCBzdGF0ZV9jaGFuZ2UgPSBmYWxzZTsNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgdm9pZCAq
b2JqX2NvbnRleHQ7DQo+ID4gPiA+ID4gPiA+ICAgICAgICAgIHZvaWQgKmNtZF9oZHI7DQo+ID4g
PiA+ID4gPiA+ICsgICAgICAgdm9pZCAqdnFfY3R4Ow0KPiA+ID4gPiA+ID4gPiAgICAgICAgICB2
b2lkICppbjsNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgaW50IGVycjsNCj4gPiA+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiA+IEBAIC0xMjMwLDYgKzEyMzEsNyBAQCBzdGF0aWMgaW50IG1vZGlmeV92
aXJ0cXVldWUoc3RydWN0IG1seDVfdmRwYV9uZXQgKm5kZXYsDQo+ID4gPiA+ID4gPiA+ICAgICAg
ICAgIE1MWDVfU0VUKGdlbmVyYWxfb2JqX2luX2NtZF9oZHIsIGNtZF9oZHIsIHVpZCwgbmRldi0+
bXZkZXYucmVzLnVpZCk7DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiAgICAgICAgICBv
YmpfY29udGV4dCA9IE1MWDVfQUREUl9PRihtb2RpZnlfdmlydGlvX25ldF9xX2luLCBpbiwgb2Jq
X2NvbnRleHQpOw0KPiA+ID4gPiA+ID4gPiArICAgICAgIHZxX2N0eCA9IE1MWDVfQUREUl9PRih2
aXJ0aW9fbmV0X3Ffb2JqZWN0LCBvYmpfY29udGV4dCwgdmlydGlvX3FfY29udGV4dCk7DQo+ID4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiAgICAgICAgICBpZiAobXZxLT5tb2RpZmllZF9maWVs
ZHMgJiBNTFg1X1ZJUlRRX01PRElGWV9NQVNLX1NUQVRFKSB7DQo+ID4gPiA+ID4gPiA+ICAgICAg
ICAgICAgICAgICAgaWYgKCFpc192YWxpZF9zdGF0ZV9jaGFuZ2UobXZxLT5md19zdGF0ZSwgc3Rh
dGUsIGlzX3Jlc3VtYWJsZShuZGV2KSkpIHsNCj4gPiA+ID4gPiA+ID4gQEAgLTEyNDEsNiArMTI0
MywxMiBAQCBzdGF0aWMgaW50IG1vZGlmeV92aXJ0cXVldWUoc3RydWN0IG1seDVfdmRwYV9uZXQg
Km5kZXYsDQo+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgc3RhdGVfY2hhbmdlID0gdHJ1
ZTsNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgfQ0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+
ID4gKyAgICAgICBpZiAobXZxLT5tb2RpZmllZF9maWVsZHMgJiBNTFg1X1ZJUlRRX01PRElGWV9N
QVNLX1ZJUlRJT19RX0FERFJTKSB7DQo+ID4gPiA+ID4gPiA+ICsgICAgICAgICAgICAgICBNTFg1
X1NFVDY0KHZpcnRpb19xLCB2cV9jdHgsIGRlc2NfYWRkciwgbXZxLT5kZXNjX2FkZHIpOw0KPiA+
ID4gPiA+ID4gPiArICAgICAgICAgICAgICAgTUxYNV9TRVQ2NCh2aXJ0aW9fcSwgdnFfY3R4LCB1
c2VkX2FkZHIsIG12cS0+ZGV2aWNlX2FkZHIpOw0KPiA+ID4gPiA+ID4gPiArICAgICAgICAgICAg
ICAgTUxYNV9TRVQ2NCh2aXJ0aW9fcSwgdnFfY3R4LCBhdmFpbGFibGVfYWRkciwgbXZxLT5kcml2
ZXJfYWRkcik7DQo+ID4gPiA+ID4gPiA+ICsgICAgICAgfQ0KPiA+ID4gPiA+ID4gPiArDQo+ID4g
PiA+ID4gPiA+ICAgICAgICAgIE1MWDVfU0VUNjQodmlydGlvX25ldF9xX29iamVjdCwgb2JqX2Nv
bnRleHQsIG1vZGlmeV9maWVsZF9zZWxlY3QsIG12cS0+bW9kaWZpZWRfZmllbGRzKTsNCj4gPiA+
ID4gPiA+ID4gICAgICAgICAgZXJyID0gbWx4NV9jbWRfZXhlYyhuZGV2LT5tdmRldi5tZGV2LCBp
biwgaW5sZW4sIG91dCwgc2l6ZW9mKG91dCkpOw0KPiA+ID4gPiA+ID4gPiAgICAgICAgICBpZiAo
ZXJyKQ0KPiA+ID4gPiA+ID4gPiBAQCAtMjIwMiw2ICsyMjEwLDcgQEAgc3RhdGljIGludCBtbHg1
X3ZkcGFfc2V0X3ZxX2FkZHJlc3Moc3RydWN0IHZkcGFfZGV2aWNlICp2ZGV2LCB1MTYgaWR4LCB1
NjQgZGVzY18NCj4gPiA+ID4gPiA+ID4gICAgICAgICAgbXZxLT5kZXNjX2FkZHIgPSBkZXNjX2Fy
ZWE7DQo+ID4gPiA+ID4gPiA+ICAgICAgICAgIG12cS0+ZGV2aWNlX2FkZHIgPSBkZXZpY2VfYXJl
YTsNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgbXZxLT5kcml2ZXJfYWRkciA9IGRyaXZlcl9hcmVh
Ow0KPiA+ID4gPiA+ID4gPiArICAgICAgIG12cS0+bW9kaWZpZWRfZmllbGRzIHw9IE1MWDVfVklS
VFFfTU9ESUZZX01BU0tfVklSVElPX1FfQUREUlM7DQo+ID4gPiA+ID4gPiA+ICAgICAgICAgIHJl
dHVybiAwOw0KPiA+ID4gPiA+ID4gPiAgIH0NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmNfdmRwYS5oIGIvaW5jbHVk
ZS9saW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaA0KPiA+ID4gPiA+ID4gPiBpbmRleCBiODZkNTFh
ODU1ZjYuLjk1OTRhYzQwNTc0MCAxMDA2NDQNCj4gPiA+ID4gPiA+ID4gLS0tIGEvaW5jbHVkZS9s
aW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaA0KPiA+ID4gPiA+ID4gPiArKysgYi9pbmNsdWRlL2xp
bnV4L21seDUvbWx4NV9pZmNfdmRwYS5oDQo+ID4gPiA+ID4gPiA+IEBAIC0xNDUsNiArMTQ1LDcg
QEAgZW51bSB7DQo+ID4gPiA+ID4gPiA+ICAgICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tf
U1RBVEUgICAgICAgICAgICAgICAgICAgID0gKHU2NCkxIDw8IDAsDQo+ID4gPiA+ID4gPiA+ICAg
ICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfRElSVFlfQklUTUFQX1BBUkFNUyAgICAgID0g
KHU2NCkxIDw8IDMsDQo+ID4gPiA+ID4gPiA+ICAgICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01B
U0tfRElSVFlfQklUTUFQX0RVTVBfRU5BQkxFID0gKHU2NCkxIDw8IDQsDQo+ID4gPiA+ID4gPiA+
ICsgICAgICAgTUxYNV9WSVJUUV9NT0RJRllfTUFTS19WSVJUSU9fUV9BRERSUyAgICAgICAgICAg
PSAodTY0KTEgPDwgNiwNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgTUxYNV9WSVJUUV9NT0RJRllf
TUFTS19ERVNDX0dST1VQX01LRVkgICAgICAgICAgPSAodTY0KTEgPDwgMTQsDQo+ID4gPiA+ID4g
PiA+ICAgfTsNCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IC0tDQo+ID4gPiA+ID4gPiA+
IDIuNDIuMA0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiANCj4g
PiANCj4gDQoNCg==

